Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D116F44E660
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917977; cv=none; b=hr1FybrFPgKsOjcXqJgdgCsSIG6IibDX9KBAMNT259ldJ9859XXZ8XFtQHAc3g+gbjxqj/eFuvb99fNIZaA7/1Oy6E68UWx0yrq8zqPHpgXBA8Mb0zcLaEzlvtmB0JnKShWPJJ4n33Tp3+uB79Z90G704AtmfB75EyusfrsOKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917977; c=relaxed/simple;
	bh=49BORHob0PSsoLTDI4uttqyoK+dUWT4F1j4eK8avkXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKxyhE0dgM5uCqsR3ASvX9TlEY34FRCCpuwHUehrV7jstkfiickj42Soufjlof4uljOJWKrXTyLJ5t2YZzsSN4sgQwzYb4SxOdy91mQfzjL3bPGf2ZcuY6bBPTpPODev5VOtchUVreD3d460Y71IW9RSZTM5cbsYeguLsCJLdYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=ABBktMGK; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="ABBktMGK"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8efcef23d21so7631126d6.2
        for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 11:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784917972; x=1785522772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pXz8gdKZyjeAUSJH5WauhE2Y5aZihjLOBIOIDBnII0I=;
        b=ABBktMGK1MlXRAZ2VyAhDq2V7G2a9xWYxxjqeyQcqhls12yOwEyRx0ybekoPigSb64
         cpY+P5j/3udIl5Y8b6onbKL0/DxvFxLWUf0G/GYCYdJdDxthm+9XkFahsJNcuJnYqfDN
         2AyUiFKYsqt2/2dOZLxQcFVzIEGgFRvmIwHH40covJ0l5qnHYXU6tWvXVi/2LV07KPQ9
         vldRaIg4XeY7wB/IsaRxA7VAyakZ3AGb99zV51JOVIpcxGcdxeOILfE25yIHQdzXWEpf
         SRQ2uYh/SHJlJD5sma2Z93gQC9vY1c4jdLIPPV6lGANd+em5vOt5AZEpWwegEjRuh78J
         8XGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784917972; x=1785522772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pXz8gdKZyjeAUSJH5WauhE2Y5aZihjLOBIOIDBnII0I=;
        b=rnThzUpu/I0gHrT7NjQ9bQjGLlGXP9HyFcc9DD4uKWKlAvRjbSjZricvZdzWpTOxbI
         F+udoCDwTAlT47FQ0Z6IGEbFzZslEGbHWBluHsNg4DFoprNApfldjoBWd8/z79mIe3ZX
         vJpKwo20fyItjrMY6EcJMGXKZHCY50hc9IrpL7iYRq9p5jVoFVdhdVbM1+tUzfY7gAV8
         /m/J4ylhYACl9fnTCbfRouBWIxKhzjn3dw3wbVpOH5G7WxEWtMVJgnwoIK8jjEshZTDQ
         ECjBjoWpbcQfAR0L+r8YAsycjdh6WZTuqvbwn0V2J30SgT1izsNnL4/+ei5prM10ZqAt
         oOiw==
X-Forwarded-Encrypted: i=1; AHgh+RrBPD85+JKXLU0GiT356dfSPUTiiPuf4E8BxGXhDrE4SrPZXAqLaL45cu/VHkt10HufXdDRbPAi@vger.kernel.org
X-Gm-Message-State: AOJu0YxugY6vnNAAiMmYPdP9ml0CO6Vvdu7QQ61RfzIoRRSoz//nM5tL
	5cmf7ydJTHTJhNRArPQIZxyO+h2nT3SzUsugEiVAWcQVJKlLZXuIpdaQUVBSiWN0t5Q=
X-Gm-Gg: AR+sD11nrVOl43ohugmP2xVLYmhp1TBu7Ah8OUZiljiVqc32RT+d4VYK/ocbaEcZ8w+
	cSRxCcJU7FV+5NyT3tKS29KgkAs7MK5lJcmAc6f14srJPJwQ7uHnrObk+1ns6RwuPBXwLhBUgDN
	pOw1ZgoLrVdWA6IM/mDM+pdVBrULDPwDmyt5Xd15OKTdjHmb7peWJbqLQhCUgGpoLvF0sKGw/YK
	969VuIjLxh3EkOaXimuRbA4YBbGCMIbHOWJccHR/FQlu57MFHpHoJmQ6OF2Sz2DYncL1295RYKo
	0vheCuDB2evCzeYIzO3+NWVTVBoIlnxwf4xyv/fEvs2SkzY8y0OHQu/jT5Z2chhDzrOdwCGuWka
	6jf0t6XZ66ngy99TxypqElqWcPkfTuUK5AG9bochwIPoKaw4A3ql51CsC15aP8sFsVRbpXZ8l1l
	xL
X-Received: by 2002:a05:6214:5191:b0:8e9:f62b:bee9 with SMTP id 6a1803df08f44-907ca8df69fmr99553356d6.57.1784917972296;
        Fri, 24 Jul 2026 11:32:52 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e85241e7sm4261406d6.8.2026.07.24.11.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:32:51 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:32:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amOv0MlF1S-oFZHX@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a85420-caac-477e-b371-8628ed28c428@linux.dev>

On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> 
> 
> On 24/07/2026 02:53, Shakeel Butt wrote:
> > On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> >> The anon/file scan balance in get_scan_count() is driven by two scalars
> >> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> >> producer under lruvec->lru_lock. The acquisition sites for cost work
> >> specifically are:
> >>
> >>   - shrink_inactive_list() re-takes lru_lock at function exit purely
> >>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
> >>     nr_reclaimed). One acquisition per inactive shrink.
> >>   - shrink_active_list() does the same with (0, nr_rotated). One
> >>     acquisition per active shrink.
> >>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
> >>     purely to record the refault cost. One acquisition per refault.
> >>   - prepare_scan_control() takes lru_lock just to snapshot the two
> >>     scalars into sc->{anon,file}_cost.
> >>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
> >>     re-acquires lru_lock on each ancestor to propagate the update,
> >>     adding O(memcg-depth) acquisitions per producer call.
> >>
> >> This hurts because lru_lock is already a heavy contention point on
> >> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> >> and folio_add_lru() takes it. The cost work itself is trivial (two
> >> scalar bumps and one comparison), but it contends with and causes
> >> contention for actual LRU manipulation. The parent_lruvec() walk also
> >> multiplies cost-update overhead by memcg hierarchy depth.
> >>
> >> Replace the producer-side accumulators with a read-side accumulator fed
> >> from per-LRU vmstat counters. The old producer formula was:
> >>
> >>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> >>
> >> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> >> already bumped by writeout() for the same successful outcome that fed
> >> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> >> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> >> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> >> be sampled per lruvec and aggregated through the memcg hierarchy.
> >>
> >> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> >> producer-local input. They are bumped from shrink_inactive_list() by
> >> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> >> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> >> lru_note_cost_refault() used to bill.
> >>
> >> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> >> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> >> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> >> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> >> raw per-side deltas are computed against cost->last_rotated and
> >> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> >> Extracting the deltas from the individual counters (rather than from a
> >> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> >> true per-counter growth, so a signed-long wraparound of any underlying
> >> vmstat still yields the correct delta on 32-bit. The weighted delta is
> >> folded into cost->count. Since one vmstat delta can cover many producer
> >> events between reclaim passes, halve cost->count on both sides until
> >> their sum is back within the lrusize/4 bound instead of halving only
> >> once.
> >>
> >> Moving accumulation and decay to the reclaim side also improves the cost
> >> model across reclaim gaps. With producer-side decay, events that happen
> >> while reclaim is idle still age each other before reclaim ever samples
> >> the costs. If a workload refaults a large anon set and then a smaller
> >> file set before reclaim runs again, the later file activity can age the
> >> earlier anon activity out of the cost model. The new scheme observes the
> >> whole between-reclaim delta and decays anon and file proportionally, so
> >> the scan-balance history better represents what happened since the last
> >> reclaim pass.
> >>
> >> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> >> extraction, the cost->count update and the halving loop against
> >> concurrent reclaimers in the same memcg+node.
> >>
> >> Hierarchy aggregation is now implicit in the vmstat accounting. The
> >> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> >> existed only because anon_cost/file_cost were private lruvec fields. With
> >> the cost expressed as lruvec vmstats, rstat propagates the underlying
> >> counters through the memcg hierarchy and prepare_scan_control() consumes
> >> the same ratelimited rstat view as the surrounding reclaim heuristics.
> >>
> >> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> >> no longer needed and is removed.
> >>
> >> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> >> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> >> The reported values only refresh when prepare_scan_control() runs and
> >> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> >> they express is unchanged.
> >>
> >> Under pure MGLRU the scan-balance signal itself is not consumed (both
> >> prepare_scan_control() and get_scan_count() are short-circuited on the
> >> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> >> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> >> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> >> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> >> evict_folios() so per-memcg observability of rotation-driven reclaim work
> >> stays consistent across both implementations.
> >>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > 
> > Oh man too long commit message, please follow Johannes's suggestion.
> 
> Will do!
> > 
> > The patch looks good but I have one question. We already have concept of
> > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > the number of pages we scanned but didn't reclaim plus number of pages given one
> > more trip in the active LRU.
> > 
> > Older and newer pgrotate metrics kind of represent something different. It may
> > cause confusion. Now before suggesting to change the name, let me ask do we
> > really need to expose these to the userspace? How exactly users can use these
> > new metrics? I think you can use them here without exposing to userspace. So,
> > does it makes sense to delay userspace exposure later when we have a more solid
> > usecase for that unless you have it already.
> > 
> 
> I do think the userspace counters have diagnostic value. They can be another metric
> to show how much anon/file reclaim work is spent on pages that are not immediately
> reclaimed, including pages retained on actie LRU. It could help explain if there
> is elevated reclaim CPU usage.

Hm, this is an interesting discussion.

The existing PGROTATED is kind of useless. When it's bumped:

- truncation fails and moves folios to the LRU tail for faster reclaim
- writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry

Ok, who needs to know this? The new counters you're adding, on the
other hand, they capture the information you frequently need for
understanding reclaim behavior.

That said, looking closer at this one more time, you can already
(almost) derive them fully from existing counters:

drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON

The first two are already split by anon and file. The third you'd have
to (1) split by type and (2) stop counting, or have a separate event,
for MADV_COLD driven deactivations.

And (2) seems overdue anyway. There is no point in maintaining counts
for what userspace madvises. And it adds noise when it gets conflated
with a stat tracking kernel reclaim behavior.
