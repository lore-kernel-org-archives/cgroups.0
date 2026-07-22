Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E9B3B19AF;
	Wed, 22 Jul 2026 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784715402; cv=none; b=FZtd3tQSUMcTOgIX0WizYrMdNA4elWbOKJsAKa1SqLMOpDosPqLDK0Fhs3Ia22GO7s/hog0IG779sj0RGXuctRkGe5f84DYEomFMUsT2/0fyd2GLxQj/Jgvlgwo32V4OpEXoXOBvgqMP3lN0aoG9T1KKuZwg3rrvNHzYSGTd9W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784715402; c=relaxed/simple;
	bh=NX5iAyJ3e+snnWnA1WdCRJwEZpKuNeQi8eIEWjzNxgc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gKtm06fjytxIEm1SoXhjVJUYGy/KCU9Owpoiwg8gzdfTfkI/Snr5GElW4pLuz6orQDp6JuNG5DFySqaP6PD/ZA+BEHlzeyPUrsmuMWiririalIgcRbfouhuume/GZ8USxta1T5W6NULR/8uDTwR1j6slNY0CTamayDHk0OCHJT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cehKhQic; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cehKhQic"
Message-ID: <36cefa74-bd88-44be-94b2-13b613e50528@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784715387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lcMeD72NxnTGKJ/lMIJ+2LVnzwq0+08WrYCqZgmK26c=;
	b=cehKhQicz/6PIkkIv45mtq558rplym/jlIAg27IqhD3cTzWHKZIwYsRuaGcSk+vmKuG8dg
	1WuA8mNQuSZUllm1NIDyK6Thx+rOlpHnux2vld7dCpw8WZbew2o9ltA29aR8Y/QMgcNFlv
	ywwZf12Oz5VfMSDh7ZBlTKk4o/uTlxI=
Date: Wed, 22 Jul 2026 18:15:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, linux-block@vger.kernel.org, josef@toxicpanda.com,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 david.laight.linux@gmail.com, haris.iqbal@linux.dev,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v3] blk-throttle: fix divide-by-zero on legacy iops limit
 of 0
To: yukuai@fygo.io, tj@kernel.org, axboe@kernel.dk
References: <20260721040850.90544-1-cui.tao@linux.dev>
 <3e1616f1-1dc1-4912-8404-4f53b2d1205c@fygo.io>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <3e1616f1-1dc1-4912-8404-4f53b2d1205c@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/22 15:25, yu kuai 写道:
> Hi,
> 
> 在 2026/7/21 12:08, Tao Cui 写道:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Writing a multiple of 2^32 (e.g. 4294967296) to a legacy cgroup v1
>> throttle iops file (blkio.throttle.{read,write}_iops_device) silently
>> truncates to 0: tg_set_conf() stores the sscanf-parsed u64 value into
>> an unsigned int field with no clamping. The cgroup v2 path,
>> tg_set_limit(), already clamps the same kind of value with
>> min_t(u64, val, UINT_MAX), but the legacy path never did. Note that
>> the "!v -> U64_MAX" mapping only catches an explicit zero and does not
>> catch a value that truncates to zero.
>>
>> With iops stored as 0, tg_update_has_rules() sets has_rules_iops[] and
>> the next IO reaches tg_within_iops_limit(), which computes
>>
>>      jiffy_wait = max(jiffy_wait, HZ / iops_limit + 1);
>>
>> triggering a divide-by-zero oops. The unclamped write in tg_set_conf()
>> is long-standing, but it only became a crash once the HZ / iops_limit
>> divide was added.
>>
>> Fix it in two places:
>>
>>    * tg_set_conf(): clamp the value to UINT_MAX, consistent with
>>      tg_set_limit(). This closes the truncation root cause (and the
>>      general silent truncation for any value above UINT_MAX).
>>
>>    * tg_dispatch_iops_time(): treat iops_limit == 0 as unlimited so the
>>      divide in tg_within_iops_limit() is never reached, defending
>>      against any future path that could produce a zero limit.
>>
>> Fixes: 1beabab88ece ("blk-throttle: fix lower control under super low iops limit")
> 
Hi Kuai,

Thanks for the review, and you're right on both points.

> I think the root cause is that iops_limit set to 0, and what's the behavior of throttle
> with iops=0? Since calculate_io_allowed() will always return 0, it's likely that no IO
> can be issued.

On the root cause: yes, iops=0 is the real root cause and it predates
1beabab88ece. With iops_limit = 0, calculate_io_allowed() returns 0
(0 * jiffy_elapsed), so no IO can be issued at all; 1beabab88ece only
turned that pre-existing iops=0 hang into a divide-by-zero via the new
HZ / iops_limit. Attributing it to 1beabab88ece was therefore wrong --
my apologies. I'll drop the Fixes: tag in v4.
> 
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>
>> ---
>> Changes in v3:
>> - Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accepts
>>    two unsigned types of different width (both >= 4 bytes), so
>>    min(v, UINT_MAX) compiles clean. (David Laight)
>> - Add a Fixes: tag pointing at the commit that introduced the
>>    HZ / iops_limit divide, which is also where the oops became reachable.
>>
>> Changes in v2:
>> - Use a "void *field" local for the config write so the assignment reads
>>    *(u64 *)field / *(unsigned int *)field instead of the
>>    (type *)((void *)tg + of_cft(of)->private) casts.
>> - Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
>> ---
>>   block/blk-throttle.c | 13 ++++++++++---
>>   1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index ffc3b70065d4..e894852c3142 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -883,7 +883,12 @@ static unsigned long tg_dispatch_iops_time(struct throtl_grp *tg, struct bio *bi
>>   	u32 iops_limit = tg_iops_limit(tg, rw);
>>   	unsigned long iops_wait;
>>   
>> -	if (iops_limit == UINT_MAX || tg->flags & THROTL_TG_CANCELING)
>> +	/*
>> +	 * iops_limit == 0 is not a valid limit. Treat it as unlimited so we
>> +	 * never reach the HZ / iops_limit divide in tg_within_iops_limit().
>> +	 */
>> +	if (iops_limit == UINT_MAX || iops_limit == 0 ||
>> +	    tg->flags & THROTL_TG_CANCELING)
>>   		return 0;
> 
> Is the above still needed with the tg_set_conf() changes? 0 is not a valid limit, and
> it should not exist in the first place, so I don't like the above new checking.
On the iops_limit == 0 check: agreed, dropping it. With the tg_set_conf()
clamp in place, 0 can never be stored as a limit (explicit 0 maps to
U64_MAX, anything that would truncate to 0 is clamped to UINT_MAX, and
the init value is UINT_MAX), so the runtime check only guards an
unreachable state. v4 keeps only the tg_set_conf() clamp.

Will send v4 shortly.

Thanks,
Tao
> 
>>   
>>   	tg_update_slice(tg, rw);
>> @@ -1383,10 +1388,12 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
>>   	tg = blkg_to_tg(ctx.blkg);
>>   	tg_update_carryover(tg);
>>   
>> +	void *field = (void *)tg + of_cft(of)->private;
>> +
>>   	if (is_u64)
>> -		*(u64 *)((void *)tg + of_cft(of)->private) = v;
>> +		*(u64 *)field = v;
>>   	else
>> -		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
>> +		*(unsigned int *)field = min(v, UINT_MAX);
>>   
>>   	tg_conf_updated(tg, false);
>>   	ret = 0;
> 

