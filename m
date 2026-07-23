Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280D83F1AAD
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 20:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838345; cv=none; b=pi36agnYUQoBiwOHSLXV+WYU0Smj6RdqVUtlOQb4EIsFt3AVicCe+aHh7zp3F7IrNYxfW835lrNgNgi3MvR80YcYYShB9fqC9ee/Oj/cRRU4njzHWY8gUJ/VzYJCrBPFPwyf5GobUehdmD8gOswMhihH+byWROCMet/MrpeDELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838345; c=relaxed/simple;
	bh=UmbeopojOH95a+HX7si1JTBMxQOdMxfqcO5BpdeaTdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ji4iOBbpN2D1wpDA+4wKe5tqxhxWHiXfiQujwOYyc7acgjsrTjpCddM26az1oApkvTOjMU9nfQU9AJka1tViwImcknpvQa4cIDPLD8ByNOFm1t0mOPAT2Z28EtJMOvmCU2J7FJmf63RC/MEtp1ni0OfDhRB4En9bOB6Ysyt2zSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=fQN38Iul; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="fQN38Iul"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e5b048375so89487485a.1
        for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 13:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784838341; x=1785443141; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IFF4yQtEVs6i5fdto4RrDVs1x4A+ievAa0eCNbUcchk=;
        b=fQN38IulzBUEdxF776LJ5O5SSH9vOBxkFJyGPWAdDaGnd8pfmDcRLwCGdBqy5xFuj9
         PRDRNRbC18UV8d1e3biDyTeLlGhaUcnn5nO13Vduz25cVsKoD79IqyWT4bfbUkLlSAaE
         Zdlr2aFWsGLre9h96VtmUHmxQWl2xBlPFQ1VvKxmWpwLAXk5ppledOEyHEh9gkVAHwOS
         QCHumUoLH+vx52kWHU49pAHJJruR2vSJShjtdnKFk4A6JULILUybnj37H+quXzgAIZiy
         xRWKsfBy/NpkgK/g7sR9CTlu7wVccWe0JIOmowr17aDqKiccYT5kaYm1WPb3qCNWs42v
         KOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838341; x=1785443141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IFF4yQtEVs6i5fdto4RrDVs1x4A+ievAa0eCNbUcchk=;
        b=TFBi9DsZuSksumxCNlPZ84AKUCWrH1PwpDPNli0EsljKkIlWwHJK3gL7zxtVE3tzcH
         Ik4nazgKjyptdudu8GNAtDEqOYWxONuudZWUCEuw8VfipV3WZYX5U4K0f8jB0Z2e17ZE
         9875F1uAn2IvV9w9A6BIfb1CSNOD19qRz23Nf6bh053xHUkHiWtLcSkcNCSJhRaO4cbR
         lxPQh8+AxKHy9jbHWEFlr7axUIFUogKMOEN2pv7zAd9hykm+TFDz+3Rung8weP+7uuIu
         Cbx3fWP2C7lUPpsQ+VpvQEdhKd/ibupDq6sWUYMdW9ajX3Qc9zBqTKniglWHoOZzCrS/
         moPw==
X-Forwarded-Encrypted: i=1; AHgh+Roh/c/TvHlTMgz3KlvnuBufCezQRCryTKkCGs/yfJjGleFeUyCEteNv9G+WEdqKxFz5//o/mR4y@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5OYfR2tKgwfiYW3OQGOG8juYPRdkE77/wsGkHpU/sOXUPG4se
	GY41UcJwGg/uPwHM3fzIDurJxvf5OJumXdkzL45EyZTHAaw+aU7yNgtTonBhiX43bK8=
X-Gm-Gg: AR+sD11qp4WU7n2bYjeOlmN5F0DF4iaPz968d8JCvdUf9L2j0QxU898dvB/7e81Z/L1
	MfdJjkVqGaT6RO7v23SwRalePWwL5zEyqfSlDID4AjLJfoyL8fEFhO/KSMTrPPzwoU8PdwJwbPw
	2AkU7VCHnoTael1yPVWmrdv4N5a9KRamR5TF6YmhPtwTCKB8/i1yuCTCappMSw0A4WWMC3Cl8ur
	HtmFwqx8RtiQnuHfhfjZ8l9MS+wtU7zS4FvrdO5qNoJl6IiBTSFzUatp44D759DLiGWNZ7I5PBO
	xg7gTjbf1bZNJqPRcGG4INmOaBxg2dubbtsnWZcO4BzK3mdf9UealrAPWzgYLze8S9gIvPKuPMe
	ISefq2F7XAGEoN9/RTGBzps4ThNtvQ39LHvZF80RV+41yVPF2uvHSOB9upEgyiJ32DVq0xRk3fG
	9M
X-Received: by 2002:a05:620a:4550:b0:931:3d2:6fd with SMTP id af79cd13be357-93103d226f4mr481862985a.43.1784838340842;
        Thu, 23 Jul 2026 13:25:40 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a0ab39sm506266585a.26.2026.07.23.13.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:25:39 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:25:35 -0400
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
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amJ4v3QD2wym14ap@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.450685-3-usama.arif@linux.dev>

On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> The anon/file scan balance in get_scan_count() is driven by two scalars
> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> producer under lruvec->lru_lock. The acquisition sites for cost work
> specifically are:
> 
>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>     nr_reclaimed). One acquisition per inactive shrink.
>   - shrink_active_list() does the same with (0, nr_rotated). One
>     acquisition per active shrink.
>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>     purely to record the refault cost. One acquisition per refault.
>   - prepare_scan_control() takes lru_lock just to snapshot the two
>     scalars into sc->{anon,file}_cost.
>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>     re-acquires lru_lock on each ancestor to propagate the update,
>     adding O(memcg-depth) acquisitions per producer call.
> 
> This hurts because lru_lock is already a heavy contention point on
> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> and folio_add_lru() takes it. The cost work itself is trivial (two
> scalar bumps and one comparison), but it contends with and causes
> contention for actual LRU manipulation. The parent_lruvec() walk also
> multiplies cost-update overhead by memcg hierarchy depth.

vvv

> Replace the producer-side accumulators with a read-side accumulator fed
> from per-LRU vmstat counters. The old producer formula was:
> 
>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> already bumped by writeout() for the same successful outcome that fed
> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> be sampled per lruvec and aggregated through the memcg hierarchy.
> 
> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> producer-local input. They are bumped from shrink_inactive_list() by
> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> lru_note_cost_refault() used to bill.
> 
> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> raw per-side deltas are computed against cost->last_rotated and
> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> Extracting the deltas from the individual counters (rather than from a
> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> true per-counter growth, so a signed-long wraparound of any underlying
> vmstat still yields the correct delta on 32-bit. The weighted delta is
> folded into cost->count. Since one vmstat delta can cover many producer
> events between reclaim passes, halve cost->count on both sides until
> their sum is back within the lrusize/4 bound instead of halving only
> once.

^^^

This is a quite a bit of explaining the code, which is kind of
drowning out what's really going on. How about something like:

---

The balance formula for anon and file, respectively, is this:

    cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated

Instead of recording cost and running averaging logic directly when
these events occur, snapshot running vmstat counters once per reclaim
cycle and derive the balance from event deltas since the last run.

WORKINGSET_RESTORE_* and NR_VMSCAN_WRITE already exist and have been
accounted all along; PGROTATE_* are added for replacing the rotation
event callbacks.

This is overall cheaper and has fewer lock aquisition sites.

---

> Moving accumulation and decay to the reclaim side also improves the cost
> model across reclaim gaps. With producer-side decay, events that happen
> while reclaim is idle still age each other before reclaim ever samples
> the costs. If a workload refaults a large anon set and then a smaller
> file set before reclaim runs again, the later file activity can age the
> earlier anon activity out of the cost model. The new scheme observes the
> whole between-reclaim delta and decays anon and file proportionally, so
> the scan-balance history better represents what happened since the last
> reclaim pass.
> 
> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> extraction, the cost->count update and the halving loop against
> concurrent reclaimers in the same memcg+node.
> 
> Hierarchy aggregation is now implicit in the vmstat accounting. The
> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> existed only because anon_cost/file_cost were private lruvec fields. With
> the cost expressed as lruvec vmstats, rstat propagates the underlying
> counters through the memcg hierarchy and prepare_scan_control() consumes
> the same ratelimited rstat view as the surrounding reclaim heuristics.
> 
> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> no longer needed and is removed.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Under pure MGLRU the scan-balance signal itself is not consumed (both
> prepare_scan_control() and get_scan_count() are short-circuited on the
> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> evict_folios() so per-memcg observability of rotation-driven reclaim work
> stays consistent across both implementations.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Otherwise, looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
