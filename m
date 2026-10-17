Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CB819A288;
	Sat, 17 Oct 2026 02:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792204724; cv=none; b=ZQ3Pqz3eyAqSx3ofXmwl2MVRN5wRyCJL08sSMumM4xqOt26LD7uww/Nkfh6EuDsX60Ckro5TkcgaWnKwI5zId44ZWaD6oqFX2KRbSTw/tlIhsd4Ld+zfpyLp03rwNhca+5HliuMX1s6EAHE8rgxxtJgOe27uWNChj3ZsrZF9JcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792204724; c=relaxed/simple;
	bh=v+tWZ6wzBQDmc0TsNkvNx1aa5akEKUuEFeP4oWUd75w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oNhNjGNYVy/XA7CBIO6yX2udBsVM+NrmXR/cRoJLVC3pNPGJTEnBknzYmbf8pAipPfwC5X1+vjlcvAuNjjqUsO0FYR2QTsWPPzASLjm1+C8aTbY8RO7xF+Od9U88/WYdc2xJiThEo6UMKHm3SZyiHN5OdEnMcKRNcVCHz6eVLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/GEhrIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/GEhrIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5811F000C4;
	Sat, 17 Oct 2026 02:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792204722;
	bh=yCYy/omc/k0UmUcHxQJgnXUXd6XKF1gPbq7tP/hUJKU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a/GEhrIG16ujWZEtMe2TRhF0aWm3OKHO9R7aOAjmg04ODrE/hQ76QqCThdvXH6hXK
	 l/WGCgfAhJI5+IZdEbJyG5IaaM1wkSiMeimGr9DAJRMTtlrFn2s1dLm4/Q3yImYE0f
	 U9CL2Pw5tTCsyQd7pRk0sX0fw750Mndukm5hD3zY=
Date: Fri, 16 Oct 2026 19:38:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261016193842.5af1f5a6cffafd7a24aeb521@linux-foundation.org>
In-Reply-To: <79c1246f-8c9e-4e2a-adbf-e730732b33b1@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
	<20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
	<84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
	<20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
	<79c1246f-8c9e-4e2a-adbf-e730732b33b1@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Oct 2026 14:27:32 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> On 10/16/26 02:58, Andrew Morton wrote:
> > On Thu, 15 Oct 2026 13:42:41 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> ...
> >> If you prefer the cache, I'm happy to redo patch 1 that way.
> >> Patch 2 does not care about the unit size.
> > 
> > OK, thanks.  Yes, using a kmem_cache is a simple no-brainer.  Let's get
> > that done first and then let's look at additional optimizations on top
> > as a separate activity.
> 
> OK, no problem. I'll redo patch 1 with a dedicated kmem_cache and send
> it separately.

Great.

> 
> > But a tweak which reduces 145GB of bloat to half of that is lipsticking
> > the pig, and what a pig it is.
> > 
> > Why the heck is memcg allocating so many of these things?  What sort of
> > rip-out/rethink/start-over can we do to reduce this by 99.x%?
> 
> That is what patch 2 does:
>   [PATCH v2 2/2] mm/shrinker: allocate the per-memcg shrinker units on demand
> 
> Today every memcg allocates, on every node, a unit for every 63 shrinker
> ids up to shrinker_nr_max, whether or not it ever has an object on those
> shrinkers. Patch 2 allocates a unit only when the memcg gets a list on that
> shrinker's list_lru, so a memcg pays for the shrinkers it uses, not for
> every superblock on the host.
> 
> In the synthetic test from the cover letter (8000 tmpfs mounts,
> shrinker_nr_max 8064, 2000 empty memcgs, 4 nodes):
> 
>                      units               slab per memcg
>   base               1011518 x 1024 B    548 KB
>   + patch 1          1023787 x  512 B    289 KB
>   + patches 1-2          136 x  512 B     42 KB

OK.

> Size: it would replace patch 2 with two patches. The first turns the
> array into an xarray, with the units still allocated up front, and
> removes struct shrinker_info and the expand path. The second allocates
> the units on demand, without the lock and the expand handling patch 2
> needs now. Together I expect about the size of patch 2 today, around
> 170 changed lines, mostly in mm/shrinker.c, with fewer lines in total
> than now.

That sounds like a good plan.

> Which way would you prefer: patch 2 as it is, or the xarray version in
> its place? Or something else?

The xarray approach sounds more complex?  If so I'd say only do that if
it's justified for some reason.

