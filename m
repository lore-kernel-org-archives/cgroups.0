Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E0536EA8D
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 06:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784876040; cv=none; b=XyzhbSWiBmvmufXmfK7eznr6MfMXhCYM8WQlKB0PSUW4RbJPyOFSRe1dR7T7u0mF/LJYe5mBtSTAzkyMGfz2pXiGvZJJ8R8I1LLGuUd6shS3pZwOqOYYzloqjTK/A04HmFJRJWXKbwTLLqwqRm7V0VOTydUQZ/HsY3tgsEI2S9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784876040; c=relaxed/simple;
	bh=/CdbwamX7b1IPnTJkU8yoaf5INqtkxYtv3QoCf/xKf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HXlnat/Jq1aWKvkh2w3oIob1Kn6/321TENthwy2yCKwIK8HJdHy9TOFiRSSu0Z9gwf3mVafnfEamYdw2PY93XW9uKmj7IIyLA33cn8HO/zW2Arbk2scGCAFdGdd6K/i3nLDq51JJ09WDsM55OtGPsFTl5tXmQFM098yb2RLrUGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fKcoAGrr; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fKcoAGrr"
Message-ID: <cf2df458-2b0e-46bd-9eea-f3c15265d90e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784876031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APONQVsPJkkQx8mNtrNVFM4P3UKPMmWHeB8nUygzPiE=;
	b=fKcoAGrrAnA635Yh9d/uLCwMRNa9LD5bxnO4YgA2+uFrLRy0La+iXderjPvz4yoAv3efz8
	Z8yOoE74pSaM0nn1NfQT2Gr9E7SPCtWd1jupNsaGo0G/ZfD7GxHXuOCCRbxT3+WrZTma1T
	X+pi5BI/4WATlWg0CzclnMNkKhRpus0=
Date: Fri, 24 Jul 2026 14:53:29 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Tao Cui <cui.tao@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/24 11:32, Tao Cui 写道:
> 
> 
> 在 2026/7/24 10:18, Guopeng Zhang 写道:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> kernfs serializes file operations only per open file, so separate open
>> files can update the same memory.high or memory.max file concurrently.
>> Both handlers store the new limit before synchronous reclaim, but
>> continue to use the writer's local target in the reclaim loop. If another
>> writer raises or removes the limit, the first writer can continue
>> reclaiming toward a stale target.
>>
>> For memory.max, this can leave the writer looping indefinitely once
>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>> the current limit and returns true without killing, while the writer
>> still compares usage against its stale target and records another OOM
>> event.
>>
>> Check the current limit at the start of each reclaim iteration and stop
>> if it no longer matches the writer's target.
>>
> 
> Fix looks correct to me.
> 
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> 
> Nit: the message lumps both paths together, but only memory.max loops
> indefinitely. memory.high has no OOM path, so it just spins
> MAX_RECLAIM_RETRIES times and breaks on its own. Worth a line to avoid
> conflating the severity.
> 
Hi,

Thanks for the review and Ack.

The message separates the two cases: the first paragraph describes the
stale-target reclaim behavior common to both, while the "For memory.max"
paragraph describes the OOM-based indefinite loop.

One detail is that memory.high is not limited to MAX_RECLAIM_RETRIES
iterations. The retry counter is decremented only when reclaim makes no
progress:

        if (!reclaimed && !nr_retries--)
                break;

If reclaim continues to make progress while pages are refaulted,
nr_retries is not decremented and the loop can still fail to converge.

Thanks,
Guopeng
>> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
>> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>> Reproducer:
>>
>> Populate a cgroup with anonymous memory and disable swapping. Lower
>> memory.max from one open file, then restore it to "max" through another
>> open file after the new limit becomes visible.
>>
>> Without the patch, the first writer remains blocked and repeatedly
>> increments the OOM event counter. With the patch, it returns normally.
>>
>>  mm/memcontrol.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8319ad8c5c23..638bdc766616 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>>  		unsigned long reclaimed;
>>  
>> +		if (high != READ_ONCE(memcg->memory.high))
>> +			break;
>> +
>>  		if (nr_pages <= high)
>>  			break;
>>  
>> @@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>>  	for (;;) {
>>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>>  
>> +		if (max != READ_ONCE(memcg->memory.max))
>> +			break;
>> +
>>  		if (nr_pages <= max)
>>  			break;
>>  
> 

