Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AB928C854
	for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 05:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785045474; cv=none; b=s38EFwb4imHNOUBTtQgXq3fV648IJhsBYqN23maoIAoYVl+t618yIB7dl9Ciu+uZrWHufXo4r71hFHWzsdQ4xxX+3DJugJQp3bxYyAnZOg3ON6LNedp3npAq5ufZQcSUOfBt/hzXM+g2X3KFPUnKG4iS7ijTKU2EI25c9hn5dtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785045474; c=relaxed/simple;
	bh=LfhN5S0nsgHL+y7oiP7U8s36NLA0x5CBzYguAtY6kCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FdbZP/LYQ5DWL9apsOPt4k7Uh6VPsIKLEAhzyn7+7klverCT8AeWeGtuV98cWOMBmjMxwd4ffdWjkc5hA+5SgWd/Kkin2Vy6R1Rt6dxLB7Rwl7SX6hAtgOCgaIB1xhawowV1NCIm90dhb7wHjTXEN8nkdlHaPpsVQv8k7yOrZoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gu7fnFA/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gu7fnFA/"
Message-ID: <d1ad2a71-ae4f-4c2b-a322-0bbcea951287@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785045469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgy7HKoDwUU1q2Cv23+1u+utSeqsqofimkXnRhKfzCc=;
	b=gu7fnFA/IB/GMxZ3sgqLwB1o1wUe1twXi7uByBDbnQAuPZaCqOl1U+zE9dBDSly0rmdqAA
	cpaMmW1Ky1ZaTy9Hm2ZVm5vPZVUFrJTPTO7QIGZ7LIRSKajURoyAF1DOASUA9+vlOLDcjX
	+zLk0RyFgwxBnzwtS8oacP2vq2Gx/LQ=
Date: Sun, 26 Jul 2026 13:57:29 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260725204251.f96eddc5fbc8e965546cc292@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/26 11:42, Andrew Morton 写道:
> On Fri, 24 Jul 2026 10:18:05 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
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
> 
> Thanks.
> 
>> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> 
> Dec 2019
> 
>> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> 
> Mar 2016
> 
> Having two Fixes: targets is confusing.  The Fixes: identifies which
> kernel versions should be patched, so how is anyone to figure out
> whether their 2018 kernel actually needs the patch?
> 
> I assume one of the two hunks is for 2019 and the other is for 2016, so
> two separate patches each with a single Fixes: would be more useful.
> 

Thanks, that makes sense.

For similar cases where separate code paths were introduced by different
commits and have different affected-version ranges, I will split the
fixes into separate patches, each with its own Fixes tag.

> That being said, both versions are so ancient that it probably doesn't
> matter.  In fact the bug seems so obscure that I'm not planning on
> adding cc:stable to this anyway.  Maintainers, please advise.
> 
>> Reproducer:
>>
>> Populate a cgroup with anonymous memory and disable swapping. Lower
>> memory.max from one open file, then restore it to "max" through another
>> open file after the new limit becomes visible.
>>
>> Without the patch, the first writer remains blocked and repeatedly
>> increments the OOM event counter. With the patch, it returns normally.
> 
> This is nice info - I'll promote it into the permanent changelog.
> 
> 
> I'll queue the patch for 7.3-rc1 and shall await maintainer input,
> please.
> 

