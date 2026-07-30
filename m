Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D70B3655EC
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 01:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376101; cv=none; b=RnJWTdjg3DHOMU3HzmSXs8YaXiMdfW3JwNOyEeAaYTzYHsTjPQIVZdoqzal171LTuly8wXyOO0gLJpvO2rN4ESj4wg8faZyN3Hh8ofY6xX2DSqo66qy1YW49CCwacgNsYGk5iWeFPUM7AOhDTAi0G0Uq5eigoOqCNWwGVLPI02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376101; c=relaxed/simple;
	bh=KLDja6n4BKo/QrapPt4yWwqelwNdhgNa6lu6UQ9kO60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LnoKUyBTgjZGI6brQLoy0UY4Q36EcZSQOLGIctjYNoYxA02+GId0wh0SIwOPkE15SwVUewj3FfMV6xuBp5QogJCIBQvKgoT3fq0zDB+K4i0ZqAZdgHaYyUsircVWTKIXL44trTNbkM0ncfC4xCDpJiASqnlJJrQvhy674XXsGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=snIU8Z+v; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="snIU8Z+v"
Message-ID: <0710df28-5870-4d33-aba1-085756290856@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785376095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2kUWZ0xcdYFc/4dDu905x5nCY+rKqCzP7jv+c5usrE=;
	b=snIU8Z+vX8Ry3ANjvdEYi7mUuak8bA4lZ6UeOPKRCzKxibeH87AGjK/ZyBXsS4tMx9lBNK
	Mzd0mnR5q8KJP5C42BVPKioszvVLq/1wsuvkovqsa7W4tXiAkmPFPsQZAYVC7FxWHp8kRD
	dxlFXpx/Wgw/KKuhdz5ZbSnUHDWHtzs=
Date: Thu, 30 Jul 2026 09:48:44 +0800
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
 <amdkHvSMj95DUri5@tiehlicka> <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
 <ammzjkUIADCxO2mP@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <ammzjkUIADCxO2mP@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/29 16:02, Michal Hocko 写道:
> On Wed 29-07-26 14:15:25, Guopeng Zhang wrote:
>>
>>
>> 在 2026/7/27 21:58, Michal Hocko 写道:
>>> On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
>>>>
>>>>
>>>> 在 2026/7/27 16:16, Michal Hocko 写道:
>>>>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> [...]
>>> Is this trying to replicate any real workload? One would expect that
>>> writers to limit do some sort of coordination otherwise the exact
>>> behavior is not really well defined.
>>>
>>
>> No, this was not motivated by a reported production workload. We found
>> it through automated randomized testing for our cgroup observability
>> work and reduced it to the reproducer above.
> 
> This is an important detail to be mentioned in the changelog. Describing
> motivation for a change is really important, especially if it has direct
> impact in user interface behavior.

Thanks for the guidance. I will take the feedback from this patch into 
account when preparing similar changes in the future.

