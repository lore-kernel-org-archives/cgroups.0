Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1C4389DE0
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 21:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784322499; cv=none; b=Yb/sg8Ny4wW7NXJNVd3Utx93FiQS94Y+o1BxOnYr8zeBXzDr1RoXn3XUSq5pEbXPjOzvU0dOiZrU5lVSmXB2LjawCTPGYXS0kwdudFXmtP0+x5eVTzCxVpptVpKQEAm4H/gFcGQ26ZuPpCKsym4s89n4ij4aBbyGubxtsFVvqRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784322499; c=relaxed/simple;
	bh=1oDqHUAbyufZZVARq+gPgcZMWuLd57VzTeUXeJ4g88Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J1z4bitaoJ0zYx9nWg2DWwryTTc2LW7NsnM+GEAobC3Ej6/aiaqtxsB0EyYm3icxf4X2OPFFiFzK7O9SocyyhXBqemE3o9Zg+fU9h/W4/kkRum9E+QGHA/9wfp39msSBijmgS7ScrxbcjnUlcMJc2PJV5YPm/gOjeVY+JTShqUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=s+7zbabK; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="s+7zbabK"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4955158f26aso91445e9.3
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 14:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784322494; x=1784927294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AjYCCbO3PLXnys6k424gkT2HzpdBexgKHv5hZJae8ug=;
        b=s+7zbabKNhgJAWk7dT/jj6BZOFVhvcHqfmFcdf1rFcVg/d7y8E6gJXAH0tmyktRBKh
         tc+A2zlWlaHsctGn57cYj21Fx87uakFcYqyQzpMkkIBLR68ET6zxyNr4deBna6UKjByo
         92jgLyl8E/0dAUHNl6FfZcuYe1Xdp8L6gRidA4L7Teho/lnlxNEJEAsuXSJIMxLX/3E+
         pl3fjgjj6jHf90+fgQIand4H9Al7Z3kbhZYZyp/8q4C+8O3K5lm4e4rie+MkGbhxE/Iq
         OxiKyrEbI5uA/XCrWnDRrOUFCRkOLQq+s0llF9ZnNwhpq7NTMWBi3d2f7MuNc8n84sK9
         BzaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784322494; x=1784927294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AjYCCbO3PLXnys6k424gkT2HzpdBexgKHv5hZJae8ug=;
        b=jrrvZzNfZlsfBYBS45PJt87c6GYjNvY6ajUiamnR3UAhHYZb3BI2SfnzdV2HcYFV5o
         CaoJX9SzXYtc1vmdz9yKFekwJH4FMPg30M4Z9tn8L9euYCwhzNGtTef+p7xLta4Oihhd
         NMUjnD78ljK9Wjd1wnY6JkQsChrPFkZldwEqlTW46AurBHOA1sOKLI4U6ie6Oqvui6pd
         s/xbxNY6f+tXKMLVzbqm4KxOsZGyXWlrwHOJyDHXm5J6bT6WbIOdTLjLSLlragzQE97u
         iVDaRapmEmwcB8UlVcWjrXeCaIvpf8ZY5oHqy3GJzMWt/iWJpraWFm07ucffPTlAtO5O
         fH8w==
X-Forwarded-Encrypted: i=1; AHgh+RpqnG3SPWFgyAAI9Tio6bVK+smDtPQw91Z7JyOCiOlcoQjr00G3R6K8lA4Mk284/GU4lKXaTp54@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ENXZRDm7kHB5iXGNi3e6nzTf4m139p5zAbHx6PbBOlmfnbnz
	+oA0aszDWe8i31OjMs19O6zbLcG+JPhFgDbejpMJVrFwdmHIv+juSkijE3ZuKigoS6g=
X-Gm-Gg: AfdE7cl+llA40JGJHUnIjAyNE1yYH0aONdp8mmjQjXydAhcs/7rsh+64uHaegfNDaqk
	URgR8wP+xE/fk6XAMtEV2yd4kNsXjb8XtKhzrTuIstyBwskZEDvX2dUypVnF+KChoKLHH3Qjitf
	gF6lVbD5zWiAJiRt1VL9xvuT32yI05Xd40n2iUF+23FAr9JMMokrjlfi5bqbfEN3kQ3khu6h+DT
	rdZYgt9ueCiSNwglN2/Twm7vZ3Yb+Kv7KJZUa1owCWxuQA29wbZQdwmy49bO1TtPofLAuIR0YRB
	u0ilXCFZ3EQiGHKusSxnCilC6dtV0BZZcxA2Ly9l3Iq0rWkXmq9vMRcyebBoINrYOfSoq5d+6tl
	+HCU1A2nABqiH5rpdREeKjaaKIirYFQcOrOFdR0DhULIp7uqKD8GOJQpOyuq+eV1oJOfvXafZWM
	0=
X-Received: by 2002:a05:600c:4515:b0:495:3af9:4cfe with SMTP id 5b1f17b1804b1-4954a40e322mr48126015e9.20.1784322493273;
        Fri, 17 Jul 2026 14:08:13 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2aa698sm68755195e9.4.2026.07.17.14.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 14:08:12 -0700 (PDT)
Date: Fri, 17 Jul 2026 23:08:08 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <20260717210808.GI6843@cmpxchg.org>
References: <20260717135807.3476029-1-usama.arif@linux.dev>
 <20260717135807.3476029-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717135807.3476029-3-usama.arif@linux.dev>

On Fri, Jul 17, 2026 at 06:57:32AM -0700, Usama Arif wrote:
> @@ -2303,12 +2301,63 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
>  	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
>  
>  	/*
> -	 * Determine the scan balance between anon and file LRUs.
> +	 * Determine the scan balance between anon and file LRUs from per-LRU
> +	 * vmstat counters. The raw cost per side is:
> +	 *
> +	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
> +	 *			     shrink_inactive_list and shrink_active_list
> +	 *			     (CPU work).
> +	 *	NR_VMSCAN_WRITE    - reclaim-driven anon pageout IO.
> +	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
> +	 *
> +	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
> +	 * higher cost of an IO over a rotation.
> +	 *
> +	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
> +	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
> +	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
> +	 * `now - prev_cost[f]` yields the correct delta across a signed-long
> +	 * wraparound of the underlying counter (a real hazard on 32-bit that
> +	 * the clamp in lruvec_page_state() would otherwise turn into a huge
> +	 * spurious delta).
> +	 *
> +	 * The delta against prev_cost is folded into cost_accum, which is
> +	 * halved on both sides until their sum is within lrusize/4.
> +	 * cost_lock serialises concurrent reclaimers in the same memcg+node.

IMO that's a lot of describing what the code does. Why not stick
closer to the original comments?

>  	 */
> -	spin_lock_irq(&target_lruvec->lru_lock);
> -	sc->anon_cost = target_lruvec->anon_cost;
> -	sc->file_cost = target_lruvec->file_cost;
> -	spin_unlock_irq(&target_lruvec->lru_lock);
> +	spin_lock(&target_lruvec->cost_lock);
> +	for (int f = 0; f <= 1; f++) {
> +		unsigned long now, delta;
> +
> +		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
> +		      lruvec_page_state_monotonic(target_lruvec,
> +						  WORKINGSET_RESTORE_BASE + f) *
> +				SWAP_CLUSTER_MAX;
> +		if (f == WORKINGSET_ANON)
> +			now += lruvec_page_state_monotonic(target_lruvec,
> +							   NR_VMSCAN_WRITE) *
> +				SWAP_CLUSTER_MAX;

It's hard to prove overflow behavior is correct. I would keep the
delta extraction dead simple, then do the weight math on the delta.

> +		delta = now - target_lruvec->prev_cost[f];
> +		target_lruvec->prev_cost[f] = now;
> +		target_lruvec->cost_accum[f] += delta;
> +	}
> +	unsigned long lrusize =
> +		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
> +		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
> +		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
> +		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
> +	unsigned long cost_limit = lrusize / 4;
> +
> +	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
> +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
> +	       target_lruvec->cost_accum[WORKINGSET_ANON] +
> +	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
> +		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
> +		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;

Why do you need to check them individually? Between reclaim cycles,
there are no scans->rotations. And I don't see how you could get
refault events several times the size of the LRU, let alone in excess
of ULONG_MAX.

> +	}
> +	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
> +	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
> +	spin_unlock(&target_lruvec->cost_lock);

I realize these long descriptor names make it hard, but I think this
can be cleaned up a bit and written in a more idiomatic way.

How about this (totally untested):

struct lru_cost {
	unsigned long count;
	unsigned long last_rotated;
	unsigned long last_io;
};

struct lruvec {
	struct lru_cost cost[2];
};

	struct lru_cost *anon_cost, *file_cost;
	unsigned long lrusize;
	
	/*
	 * Determine the scan balance between anon and file LRUs.
	 *
	 * The cost model is based on rotations, refaults and
	 * reclaim-driven writes (anon only) on each side.
	 *
	 * These event counters are monotonic, so each reclaim cycle
	 * the delta since the last scan is extracted and incorporated
	 * into a decaying average. This ensures currency, as workloads
	 * change over time, and avoids overflow in the calculations.
	 */
	spin_lock_irq(&target_lruvec->cost_lock);

	for (file = 0; file <= 1; file++) {
		struct lru_cost *cost = &target_lruvec->cost[file];
		unsigned long rotated, io, nr_rotated, nr_io;

		rotated = lruvec_page_state_monotonic(target_lruvec,
						PGROTATE_ANON + file);
		io = lruvec_page_state_monotonic(target_lruvec,
						WORKINGSET_RESTORE_BASE + file);
		if (!file)
			io += lruvec_page_state_monotonic(target_lruvec,
						NR_VMSCAN_WRITE);

		nr_rotated = rotated - cost->last_rotated;
		nr_io = io - cost->last_io;

		/*
		 * Reflect the relative cost of incurring IO and spending CPU
		 * time on rotations. This doesn't attempt to make a precise
		 * comparison, it just says: if reloads are about comparable
		 * between the LRU lists, or rotations are overwhelmingly
		 * different between them, adjust scan balance for CPU work.
		 */
		cost->count += nr_io * SWAP_CLUSTER_MAX + nr_rotated;

		cost->last_rotated = rotated;
		cost->last_io = io;
	}

	anon_cost = &target_lruvec->cost[WORKINGSET_ANON];
	file_cost = &target_lruvec->cost[WORKINGSET_FILE];

	lrusize = lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
		  lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
		  lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
		  lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);

	while (anon_cost->count + file_cost->count > lrusize / 4) {
		anon_cost->count /= 2;
		file_cost->count /= 2;
	}

	sc->anon_cost = anon_cost->count;
	sc->file_cost = file_cost->count;

	spin_unlock(&target_lruvec->cost_lock);
