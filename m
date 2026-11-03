Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.127
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793680486;
	b=HND7Dy3DS3uoLjgRijF+SV8v/kL346hhqvgyIrutMqD2/oRrAJG6cV1Q1DiRf4YIl62W
	 hh/T4HSL33F/v+0OdAuLleTcvfuUPM74sUBa5LEHZGAIT+aC3tZLGY2l2dRpV+Ux4E4r/
	 pY9LbykwvqwEdc0/Ndbw4VabwRymlZw//gblLDxoJP3ewf2bAIJSH16xynTNnA9vDYsMZ
	 +MymAZj0k76U68NGUyz8h0d1naBk9A1NeGUZXATcElEeYc01bV2k1R4fzu0RdG0KWC5LV
	 GDkguiOlNtPw5xfuyvCie6kXt4s9NMutc1AGLCf+dFWNDQdxQsTxKeo7CSvB299ODiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793680486;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K9Njty/s8OSTY2jW7LGO6SCpfmnpl1SS5BBMpxrgIQM=;
	b=pcxrhLcN2jC0XVopIzdTxaMsfR8rA7jisatxxOnLK5A6zwd1vpkncDirNB+AVYwQl+vc
	 cbD4xR+lN7GZwiqH2bumHrs2kTq9DAPrcBJH6LzC73VvRg9BRoUIr2QQrqHtf40Xe88XY
	 tNDmCvsPaZiSm477VcpeoT+WeWFK3uUq2oGoWUJZ1RBpFTZ7Wz/NnijQbWAiWShRMRIVd
	 spf+ZMxBIA6qOguvMNWBRV7F1RILjMfSIWDnKgmviZ+ttqO1rDll8pfXYDHe5pow5x09K
	 nDOlT1b1nzvbH65zXwme8UVBXVM/jpcIK5kE6bwtFwT1+mnRQ824bU2ZaVMGlCOdcGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KHDkkMsv;
	arc=none smtp.remote-ip=91.218.175.127
Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C443A606A326
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 04:34:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C443A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KHDkkMsv
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Tkk/8VKuhrIf4fgRDjiA2Ro1wKiXOIisjNU8KXqStt4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793680482; v=1; x=1794285282;
 b=KHDkkMsvPiy7YmZ1IhyOB0Yed0gk+ac9uCTMIQA+xCfR/YBe14wxj/lhmy+VD41r6zHOc2tl
 rA0T1oKitTyLSkt9MfU+T0t7+b6MZguMyS2AVRW3hL4HNkXpPV5cZqT2MZ+Nn4fjbjNCQODHUvs
 7KXv/3hs1NW2LmEDpLDsmnmw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c175a73cfa824ebc;
	Tue, 03 Nov 2026 04:34:42 +0000
X-Mizu-Trace-ID: c175a73cfa824ebc
X-Migadu-Flow: FLOW_OUT
Date: Mon, 2 Nov 2026 20:34:40 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <auli2Zlf1F0tyi4X@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
 <auhN7v127jwy-q-W@tiehlicka>
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
In-Reply-To: <auhN7v127jwy-q-W@tiehlicka>

On Mon, Nov 02, 2026 at 09:46:38AM +0100, Michal Hocko wrote:
> On Fri 30-10-26 13:54:13, Shakeel Butt wrote:
> > Reclaim can charge memory, for example when zswap stores a page.
> > try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> > they fail at a limit. A charge that fits still has memory.high
> > enforced. That can make a task in direct reclaim do more reclaim and
> > sleep longer later, and kswapd records overage that it never handles.
> > 
> > It is also a problem for the next patches, which make kernel threads
> > queue high_work. The worker charges memory from its own reclaim, so it
> > can queue itself again. With those patches but not this one, the worker
> > queued itself in 118 of 284 runs in a VM test with incompressible zswap
> > data.
> > 
> > Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> > memory.high, as they can already go over memory.max. Drop the
> > PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> > 
> > Other effects:
> > - As before, the check reads current, so it also catches interrupts on
> >   a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
> >   themselves for swap over network, so the check can't be limited to
> >   task context.
> > - These charges no longer charge a batch or refill the per-cpu stock.
> > - MEMCG_MAX still goes to the first cgroup that the charge puts over
> >   its limit. On cgroup v1, memory.failcnt no longer counts them.
> > - high_work can still run again and again when there is nothing left
> >   to reclaim. This only stops reclaim from queuing more reclaim.
> > 
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 0e484f7f823a..af95a4574a0f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
> >  	 * when it rechecks the overage and simply bail out.
> >  	 */
> >  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> > -	    !(current->flags & PF_MEMALLOC) &&
> >  	    gfpflags_allow_blocking(gfp_mask))
> >  		__mem_cgroup_handle_over_high(gfp_mask);
> >  }
> > @@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (consume_stock(memcg, nr_pages))
> >  		return ret;
> >  
> > +	/*
> > +	 * Reclaim may need memory to free memory. Let it go over the
> > +	 * limits for a while rather than fail or OOM kill. Doing this
> > +	 * before trying the limits also skips memory.high, so the
> > +	 * high_work worker can't queue itself from its own reclaim.
> > +	 */
> > +	if (unlikely(current->flags & PF_MEMALLOC)) {
> > +		/* Find the cgroup this charge puts over its limit, if any. */
> > +		for (mem_over_limit = memcg; mem_over_limit;
> > +		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> > +			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
> > +				break;
> > +		goto force;
> > +	}
> 
> This is racy. Not a huge deal as we would get a false event in the worst
> case but I think it would make more sense to check the margine after the
> charge is forced. So this would become

I actually tested your version as well i.e. after the charge. It is just
as racy and it has some additional issues which are inlined.

> --- 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..bd202ec05acf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,13 +2653,20 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool passed_oom = false;
>  	unsigned int reclaim_options;
>  	bool drained = false;
> -	bool raised_max_event = false;

First, raised_max_event can't go. Since 374f65b14819 rejected charges use it
too, and without it forced charges that already raised MEMCG_MAX before reclaim
raise it again.

>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
> +	/*
> +	 * Reclaim may need memory to free memory. Let it go over the
> +	 * limits for a while rather than fail or OOM kill. Doing this
> +	 * before trying the limits also skips memory.high, so the
> +	 * high_work worker can't queue itself from its own reclaim.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC))
> +		goto force;
>  
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
> @@ -2683,15 +2690,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> -
>  	if (unlikely(task_in_memcg_oom(current)))
>  		goto nomem;
>  
> @@ -2712,7 +2710,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto nomem;
>  
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2773,13 +2770,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
> -	/*
> -	 * If the allocation has to be enforced, don't forget to raise
> -	 * a MEMCG_MAX event.
> -	 */
> -	if (!raised_max_event)
> -		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> @@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> +	/*
> +	 * If the allocation has to be enforced, don't forget to raise
> +	 * a MEMCG_MAX event.
> +	 */
> +	for (mem_over_limit = memcg; mem_over_limit;
> +	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> +		if (!mem_cgroup_margin(mem_over_limit))

Second, !mem_cgroup_margin() is true at usage == max, so a charge that fits
exactly raises an event (unlike today).

> +			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);

Third, we definitely need a break here otherwise every ancestor at its limit gets
an event which does not happen today.

I want to keep my current version.
