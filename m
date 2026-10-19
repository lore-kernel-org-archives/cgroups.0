Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434771;
	b=V8m7b4IGplNF/sTpyfJuvVqUc9npjAOZHvzhK6ADzpa0EsB6eomN/SITE+LzoU1/x7ri
	 Oco0eXbddcdBZvN4dZkg+kP7nxNqiBRgVkZUqurwvSSZiARY/0z2nZxFab8PZ2rvPVTR7
	 064hI9qNmdg6vDKD7nTTE7edV1MIZQEJFn0IMDNEAxBvKq/ddQ1OMwiR6NHd5UrxtEQBA
	 ldhxwRQW5qzOVBcN1Htzc6zwFNsLey4ScEQjlXnaRL27h62fS+hUty3+7EfhU/6SWjGht
	 UmRXuO44sbqDwhWt4mCZLadcJgXz2DdXL+yDbUSBP1f/pgtSnWABGL2CfB0bBWir/Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434771;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3kyeVjIMDuAUkHukbsRjtRHh+FleBWBxQgLrgbUvso0=;
	b=MSRaprF8eN3IQ6EIoMtFa9GjsfmyAZank+UVyoo0UL0hbiXW9lph2N1RE8PIspZ98A0/
	 AISy7Otz26EQEWfajy07torl0iqV5tav9mtANBblI31EjULp57C5GWTkZxQ2h6c+7s0Q5
	 9/VsE3jiARqHwX/1tpf9VlvqIlZwLJC2UZOADpEGWUC9UtnqsUF5DggZUQHHexSizkaLa
	 dHYAN1+Fs8+g9C5WCSrcACMbXHb+lGzj6295seSUPHqw/jsQy9cSZ+5wFQOyJ/fjsACNE
	 ywXtQJy9HRNasaP3zjVKr2u67C58CWrMtXtcQsSHmoNMAl6KSS/mrJ691h8KcoFdJYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvWbnqBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE84606A31D;
	Mon, 19 Oct 2026 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvWbnqBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE28F1F000C5;
	Mon, 19 Oct 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434770;
	bh=3kyeVjIMDuAUkHukbsRjtRHh+FleBWBxQgLrgbUvso0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CvWbnqBvn4KPVXdHwspTy/yr1yekTD43IcpgzFeqEGO3Gz+zd1jmbPMLMcfqCLWUV
	 4NJGkuHiW9oBS6H3qPoJ3eBhNOHAhp0zNXAWrw0OrKvQYV2YOKwgbjDOp/bLr6hajy
	 CYbyyo4npmh4toEL5d0/Y9nLnGEqOheDLHqnVXZlhCd02mwp6y5rta1EEg5ded7S/e
	 T7sFIUOXaBGSrPHPOy34J8rx5sTTNpem6quXAymBjkuG01+R+tCX5tMMwwLTmOzGNs
	 RiSfHw3yCnOWw2kOMmy46AqYU6WZ35ubaxbzv7RhN4G+FcSm5wuhDZpk1ReskY3b9a
	 dfJsGl8QzojFg==
Date: Mon, 19 Oct 2026 19:32:48 +0100
From: Harry Yoo <harry@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/shrinker: per-memcg shrinker units in an xarray,
 allocated on demand
Message-ID: <atZeVV-uZMaLL_Id@thinkstation>
References: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>

On Mon, Oct 19, 2026 at 07:39:22PM +0200, Konstantin Khorenko wrote:
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not
> it ever charges an object to those shrinkers, plus a pointer array
> sized for shrinker_nr_max. Every superblock registers such a shrinker,
> and shrinker_nr_max never comes down, so a host that mounts many
> filesystems and runs many cgroups pays for every superblock in every
> cgroup, live or dying, and keeps paying for new cgroups after the
> mounts are gone.
> 
> This replaces patch 2/2 of v2, "mm/shrinker: allocate the per-memcg
> shrinker units on demand", with the xarray variant discussed in that
> thread. It applies on top of "mm/shrinker: allocate shrinker_info_unit
> from a dedicated kmem_cache", patch 1/2 of v2 sent on its own as v3:
> https://patch.msgid.link/20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com
> 
> Patch 1 keeps the units in an xarray per memcg and node instead of the
> pointer array. A new unit is inserted where it belongs: nothing is
> reallocated, copied or published under RCU when shrinker_nr_max grows,
> and the readers find a unit with xa_load() or walk the present ones
> with xa_for_each(). The units are still allocated up front, so this
> patch changes no behaviour.
> 
> Patch 2 allocates a unit only when the cgroup gets a list on that
> shrinker's list_lru, which is where map bits are set: a cgroup pays for
> the shrinkers it holds objects of, not for every superblock on the
> host. The install is an xarray insert with the gfp of the list
> allocation; there is no array to race with, so no lock of its own.
> The root memcg keeps its units for the deferred work of global reclaim
> and is the only memcg a shrinker registration still visits.
> 
> Measured on a 4-CPU, single-node VM, 20000 tmpfs mounts (shrinker_nr_max
> 20096) and 2000 memory cgroups, on three kernels:
> 
>   base                 v7.3-rc7 with the kmem_cache patch: every cgroup
>                        has every unit, in a pointer array
>   xarray               base + this series: units on demand, in an xarray
>   old array on demand  base + patch 2/2 of v2, rebased: units on demand,
>                        in the pointer array
> 
>                                                      old array
>                                       base    xarray  on demand
>   slab per empty cgroup               185 KB  18 KB   22 KB
>   shrink_slab_memcg(), empty cgroup   1.6 us  0.2 us  1.6 us
>   same, cgroup with objects on 100 sb 1.9 us  0.9 us  1.7 us
>   mkdir/rmdir the cgroups, 4000 more
>   mounts with them alive              same within noise

I think 'old array on demand' is probably good enough, and replacing it
with xarray is not justifiable unless you have a realistic scenario that
would benefit from it?

-- 
Cheers,
Harry / Hyeonggon
