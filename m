Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650C3314A90;
	Fri, 16 Oct 2026 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792112327; cv=none; b=V4ipJ0Q5CBKNK9WjM6Jgxn/nxctjphnSNXXu/fpexF7kD0IBdVcia/wQ/cQQuvtRiELLCfN0LKVBrcav0wUQCO8CeKWZ5PO80yg/OSf3jSQeoN205XgHYB41fTL9/ElaIYPNVRswFRym4KWDs7PZOa/GFx2SH9MTstWCh7312JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792112327; c=relaxed/simple;
	bh=gZHq20XyGhvAOz0lGCEk1/Rxo5czP+nTnqJg2ki4m9U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nvpAsj1JKQQhpmFOnxAGPf4DPXnfVXAUszC4lrkwRAdHGEHViIJZInSLiSshQRrGvQplD64HDETY+GAn/HnaoLzhcFMLS3CHpnzD4yMSnjT/BX8MOFWxNj3kgmylikbNJMiSk1PCnD5Du9MxpdyNd7QDiJFVVX9G6qITCI07/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOQ0xc88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOQ0xc88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AD91F000C5;
	Fri, 16 Oct 2026 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792112317;
	bh=RR9cRtj6rZdpMcx+AFWBtWQ0JWEoIVZNsQZgVJ+kILs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qOQ0xc88WAvVTVuFgMaEAQ4Cjt9md/ms0MfJDRpYnr5r73g3RpNIyk0jyBKWZgL9i
	 xUCUMTH7D3y5m3khh+N4yesBHRGDrpHJhGHeyhhNVo74YmuoJVz1zZKkAv3+ysBmyB
	 xrdT7eIaEE1jvD9MYvuwPWdOnH4xpDBnWBWDOhYw=
Date: Thu, 15 Oct 2026 17:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
In-Reply-To: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
	<20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
	<84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 13:42:41 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> On 10/14/26 22:50, Andrew Morton wrote:
> > On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> > 
> >> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> >> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
> >> ever charges an object to those shrinkers. Every superblock registers
> >> such a shrinker, so the cost is
> >>
> >>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
> >>
> >> because the unit is 520 bytes and comes from kmalloc-1k.
> > 
> > So we could almost halve this just by using a dedicated kmem_cache?
> 
> Yeap, a dedicated cache gets approximately the same cost per shrinker id.
> On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes each:
> 
>                                       ids/unit  bytes/unit  bytes/id
>     today, kmalloc-1k                    64        1024        16
>     patch 1, kmalloc-512                 63         512       ~8.1
>     dedicated cache                      64        ~528       ~8.3
>     dedicated cache, HWCACHE_ALIGN       64         576        9
> 
> So the two are ~equal on memory, and the choice is about the code.
> 
> I went with 63 ids per unit because the unit then simply fills the
> kmalloc slot it already comes from.
> 
> The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up(),
> plus the static_assert.
> 
> If you prefer the cache, I'm happy to redo patch 1 that way.
> Patch 2 does not care about the unit size.

OK, thanks.  Yes, using a kmem_cache is a simple no-brainer.  Let's get
that done first and then let's look at additional optimizations on top
as a separate activity.

But a tweak which reduces 145GB of bloat to half of that is lipsticking
the pig, and what a pig it is.

Why the heck is memcg allocating so many of these things?  What sort of
rip-out/rethink/start-over can we do to reduce this by 99.x%?
