Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A1C2F8EA6
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784566981; cv=none; b=X3RfsYNGvX85ctNWzEd6BHPeATyaT7Sjmxvg0/aQWKiQzLkromsrdfCf/q/xcmrCAgwryVyMsHFNAdi2WbhnsnM/viQoGYL+kRlk1RdXaBP1gecJtCu/BaXTqRYRbPW0OR9KtPFeH77nCmrdF6jLPIxYh9JguqhBUXwViTJndO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784566981; c=relaxed/simple;
	bh=I4Cjt6De6ZMzZvXTN3Kz0QgBxiCECILQOX1r7zMp9p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBwgzE+NI4Ab4aorG058P+2z2Ldk/czaZOycM6i68nPPMjd4uJY0pbfBsYopEyq0UXjTOWuIaS22hFYTj4/LmQ3geKIInNmbdX2nawV+mRWlaDe0B+ctvGmgT3h7jiGEN9tJ+xddQApmRL2wQiJMdeRmmjIjpNssZmdEx6IXbgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vtHxYiUZ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vtHxYiUZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784566975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMuWMKqgnkPBUwOMQjhA6e2FQmdsWS/MkwAM17YGiE0=;
	b=vtHxYiUZTWBe/9tm3d3ozCfohoThor8P2b7AXRdvys5Cl6mM82JMRs56s9DMK0zdf2hsgs
	1c67AiCnb+3NQHpKBoWrNnq6WZ/99VwJopyLHTT30dCg6BRPsJfxfsLzxdQ1IaBmrgDUMn
	Ps/OUQTliWIsniL5NvYd80VXd/H8fvw=
From: Usama Arif <usama.arif@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon, 20 Jul 2026 10:02:44 -0700
Message-ID: <20260720170245.939058-1-usama.arif@linux.dev>
In-Reply-To: <20260717210808.GI6843@cmpxchg.org>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 17 Jul 2026 23:08:08 +0200 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jul 17, 2026 at 06:57:32AM -0700, Usama Arif wrote:
> > @@ -2303,12 +2301,63 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
> >  	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
> >  
> >  	/*
> > -	 * Determine the scan balance between anon and file LRUs.
> > +	 * Determine the scan balance between anon and file LRUs from per-LRU
> > +	 * vmstat counters. The raw cost per side is:
> > +	 *
> > +	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
> > +	 *			     shrink_inactive_list and shrink_active_list
> > +	 *			     (CPU work).
> > +	 *	NR_VMSCAN_WRITE    - reclaim-driven anon pageout IO.
> > +	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
> > +	 *
> > +	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
> > +	 * higher cost of an IO over a rotation.
> > +	 *
> > +	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
> > +	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
> > +	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
> > +	 * `now - prev_cost[f]` yields the correct delta across a signed-long
> > +	 * wraparound of the underlying counter (a real hazard on 32-bit that
> > +	 * the clamp in lruvec_page_state() would otherwise turn into a huge
> > +	 * spurious delta).
> > +	 *
> > +	 * The delta against prev_cost is folded into cost_accum, which is
> > +	 * halved on both sides until their sum is within lrusize/4.
> > +	 * cost_lock serialises concurrent reclaimers in the same memcg+node.
> 
> IMO that's a lot of describing what the code does. Why not stick
> closer to the original comments?
> 
> >  	 */
> > -	spin_lock_irq(&target_lruvec->lru_lock);
> > -	sc->anon_cost = target_lruvec->anon_cost;
> > -	sc->file_cost = target_lruvec->file_cost;
> > -	spin_unlock_irq(&target_lruvec->lru_lock);
> > +	spin_lock(&target_lruvec->cost_lock);
> > +	for (int f = 0; f <= 1; f++) {
> > +		unsigned long now, delta;
> > +
> > +		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
> > +		      lruvec_page_state_monotonic(target_lruvec,
> > +						  WORKINGSET_RESTORE_BASE + f) *
> > +				SWAP_CLUSTER_MAX;
> > +		if (f == WORKINGSET_ANON)
> > +			now += lruvec_page_state_monotonic(target_lruvec,
> > +							   NR_VMSCAN_WRITE) *
> > +				SWAP_CLUSTER_MAX;
> 
> It's hard to prove overflow behavior is correct. I would keep the
> delta extraction dead simple, then do the weight math on the delta.
> 
> > +		delta = now - target_lruvec->prev_cost[f];
> > +		target_lruvec->prev_cost[f] = now;
> > +		target_lruvec->cost_accum[f] += delta;
> > +	}
> > +	unsigned long lrusize =
> > +		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
> > +		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
> > +		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
> > +		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
> > +	unsigned long cost_limit = lrusize / 4;
> > +
> > +	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
> > +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
> > +	       target_lruvec->cost_accum[WORKINGSET_ANON] +
> > +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
> > +		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
> > +		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;
> 
> Why do you need to check them individually? Between reclaim cycles,
> there are no scans->rotations. And I don't see how you could get
> refault events several times the size of the LRU, let alone in excess
> of ULONG_MAX.
> 
> > +	}
> > +	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
> > +	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
> > +	spin_unlock(&target_lruvec->cost_lock);
> 
> I realize these long descriptor names make it hard, but I think this
> can be cleaned up a bit and written in a more idiomatic way.
> 

Thanks for the prototype and the above reivew comments!

I integrated all of them and sent them as v4.

And best part of it is, sashiko is happy as well now with v4 lol
