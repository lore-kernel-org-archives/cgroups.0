Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606912CDA5
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 06:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785305761; cv=none; b=tsOybOmZYo4N1HMizqEh+e5JzRVzqFZZWlm77KD3pJZr9s/6/XDoqEAog3p1zTY+ec+mAtrJDtuQnRPXNMfMeq0xRKTc0CcVMZ+m4Fj0v3kAYpDPjQcr2DNyosiFT04XzQrZC6vWXUZ0HhBiin743rqsoguek7AEUfTdIPXSVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785305761; c=relaxed/simple;
	bh=qYTWycBTyjc7o23kNmR4HzmKyuAiFu9k5WIzmSIGYuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RCUSuMgXNKcdaPrdQuYRiYCANQFLrlcXoUvoybTlt69yV+0ssrlRj8DKcZ+q/KQvLDsgj6UNUOH5VzSzuEZgpyM24pJfvk21V3b0c9SDz6LW06f15YjorPYiTyRfaB7FSBBONJfhamExpHOBO8k8B/6nQ2PwibjK/a005bet1kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mJ1LnvGX; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mJ1LnvGX"
Message-ID: <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785305755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrwl4T0wokUMsgTEiucrmEaPLvIskj+e7z9qSMf7oIY=;
	b=mJ1LnvGXB6ZpGZZZvBrU6iFbLMGDuixbk+xBex4tNo4s6ZHuKUkSDXv4u++HsT7M/gtbWm
	hJ4tgOBsfy0UglTlyTDKeMPYLhuyloR7Ep7rIFa9rGYt28RoVGge9+Pdqrck4yjdL7HVSP
	e9yvye7cSbKwMh7mTAXtPRVodlgQV0c=
Date: Wed, 29 Jul 2026 14:15:25 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka> <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <amdkHvSMj95DUri5@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/27 21:58, Michal Hocko 写道:
> On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
>>
>>
>> 在 2026/7/27 16:16, Michal Hocko 写道:
>>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>
>>>> kernfs serializes file operations only per open file, so separate open
>>>> files can update the same memory.high or memory.max file concurrently.
>>>> Both handlers store the new limit before synchronous reclaim, but
>>>> continue to use the writer's local target in the reclaim loop. If another
>>>> writer raises or removes the limit, the first writer can continue
>>>> reclaiming toward a stale target.
>>>>
>>>> For memory.max, this can leave the writer looping indefinitely once
>>>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>>>> the current limit and returns true without killing, while the writer
>>>> still compares usage against its stale target and records another OOM
>>>> event.
>>>
>>> The current behavior is deliberate as described in b6e6edcfa4056.
>>> What is an actual problem you are trying to fix?
>>
>> Thanks for raising this. I agree that the behavior introduced by
>> b6e6edcfa405 is deliberate while the limit installed by the writer
>> remains current. The problem occurs when that limit is overwritten by a
>> later write through another open file.
>>
>> Writer A stores a low memory.max and enters synchronous reclaim. Writer
>> B then restores memory.max to "max". A still compares usage against its
>> local old target, while mem_cgroup_out_of_memory() checks the current
>> memory.max. Since 1378b37d03e8, the current-margin check in
>> mem_cgroup_out_of_memory() sees sufficient margin and returns true
>> without selecting a victim. Once the reclaim retries are exhausted, A
>> therefore loops indefinitely and increments the oom counter in
>> memory.events on every iteration.
>>
>> I reproduced this with a cgroup holding 128 MiB of anonymous memory and
>> with swapping disabled for the cgroup. Writer A lowered memory.max to
>> 32 MiB. After that value became visible, writer B restored memory.max
>> to "max" through another open file.
> 
> Is this trying to replicate any real workload? One would expect that
> writers to limit do some sort of coordination otherwise the exact
> behavior is not really well defined.
> 

No, this was not motivated by a reported production workload. We found
it through automated randomized testing for our cgroup observability
work and reduced it to the reproducer above.

>> On the unpatched kernel, A remained blocked after B's write, and the oom
>> counter in memory.events increased from 37333 to 13512861 during the
>> reproducer's one-second sampling interval. With the patch, the same
>> reproducer observed A return after B superseded A's limit.
>>
>> The new check does not change the behavior introduced by b6e6edcfa405
>> while the writer's target remains the active limit.  For the indefinite
>> loop described above, 1378b37d03e8 appears to be the more precise
>> Fixes: target for the memory.max hunk. Does that match your reading of
>> the history?
> 
> Well, to be really honest I am not really convinced this needs fixing.
> And if yes, your patch changes a well established behavior existing
> userspace might already depend on. While your described case doesn't
> look great it doesn't seem really harmful and the looping task is
> killable.

That makes sense. Without a concrete workload showing practical impact,
there is not enough justification to change the established behavior.
We can revisit this if such a workload turns up.

Andrew, please drop this patch from your queue.

Thanks,
Guopeng
