Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE617A303
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871180; cv=none; b=eClbWlPSU10okpubzCRJD/ilGYC6j9buceeTOio+dMHY1S7cOfnbMDQoApCiiLdUtsL7AYh84LO870hQg4E2/cCCtqBWkJFq5aWa6c9nGOZqtAKfNHomDAiVxYi9gZ+GzpXc22HbV1PLTJ+vEAKX0tHikbglYfAJ7VmaLy/GbIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871180; c=relaxed/simple;
	bh=mHIy657W67A8Isv5MaLtawF1GfpD+T+X03X0+hig5vY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxnR3hu6Pyej+21UyTRoV+X33uILyBGlza0wWP2jTded98fEP44UUoxTnvmYsMw79kubPH3JPrbTZbu1OOikCLDT8X0jmy3MAh/WdgjtUxlgWy7ZHx4XXgyPJc6KlCsLuzKztyHK7FxK/PoWHuO9wJapLQMOAsxYGqQSK2OiR3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WaWdo30/; arc=none smtp.client-ip=95.215.58.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WaWdo30/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mHIy657W67A8Isv5MaLtawF1GfpD+T+X03X0+hig5vY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789871176; v=1; x=1790475976;
 b=WaWdo30/xKBJqkDfXqFTnV7U1/EdIlWWkwRh86QphM/3pajdyOpx59fv4TNLJYzRFu9pzd/Q
 l6120cpVvIkSuegQwnnmqkVCKGpo38s/N3eWnq8Immr+u/IYOYiQrdG9AudNLSDkGk2SG+WA0fj
 Bkr/6aVdHEgy3uVefwVHzzjM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9adb6d34471e089e;
	Sun, 20 Sep 2026 02:26:16 +0000
X-Mizu-Trace-ID: 9adb6d34471e089e
X-Migadu-Flow: FLOW_OUT
Message-ID: <f27e12d8-2e34-4c10-9773-d1af5b8538b6@linux.dev>
Date: Sun, 20 Sep 2026 10:26:05 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Defer sched domain rebuild to common
 unlock path
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260918102730.72263-1-guopeng.zhang@linux.dev>
 <c74015aa-0e51-4161-9fe8-c779a34c64ce@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <c74015aa-0e51-4161-9fe8-c779a34c64ce@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/18 18:41, Ridong Chen 写道:
> 
> 
> On 9/18/2026 6:27 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Both callers of update_prstate(), cpuset_partition_write() and
>> cpuset_css_killed(), call cpuset_update_sd_hk_unlock() immediately
>> afterwards. That helper rebuilds sched domains when force_sd_rebuild is
>> set before releasing the cpuset locks, so the check in update_prstate()
>> is redundant.
>>
>> Commit 3bfe47967191 ("cgroup/cpuset: Move
>> housekeeping_update()/rebuild_sched_domains() together") removed the
>> same check from cpuset_write_resmask(). Remove the remaining one from
>> update_prstate().
>>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 8f24171..d58ecf5 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3039,8 +3039,6 @@ out:
>>       update_partition_sd_lb(cs, old_prs);
>>         notify_partition_change(cs, old_prs);
>> -    if (force_sd_rebuild)
>> -        rebuild_sched_domains_locked();
>>       free_tmpmasks(&tmpmask);
>>       return 0;
>>   }
> 
> This title is confusing. I thought you were doing some async work, what does "defer" mean here? In fact, it just removes a piece of redundant code.
> 

Thanks for the review.

I misunderstood this. I used "Defer" because the rebuild still happens later in cpuset_update_sd_hk_unlock().

You're right, the title is confusing. I'll fix it in v2.

Thanks,
Guopeng


