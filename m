Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3279718DB2A
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 01:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784858080; cv=none; b=czy3L87X/YBMWrcsmkH1dn7AVS/xCekw2VeZOrnT68rz8gVOUt4lReOpWtX7PviKLFkAHoOwJgYtVd91ObQmDjKUJSrkt4NkiZlYDqJCOD0scTSe7KnItliTRP6SMd5m8wPtJp7B644s6PpCNp6uFAJs7Ve0sO7joKMrKivlNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784858080; c=relaxed/simple;
	bh=kCvEJAuIUckE0u0lVejFGYWj/Ed+wvBTnjiLi84Jq5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMrUzNel2yBZeW+OZnN7O06sHxFngM16Q223akgZ38+io1M8xToI0js5DD2O/uxyEhIwB5i4Nc4G9ePFBZot1/TqBINZT/FY4JJcw3aSA/uNi1Q+tVRWnC9Y5Hoa3H/WGw2e4noksnwaT281A6YLQC9LQBCA3mf8mHctRYWcP3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d6GRTJe3; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d6GRTJe3"
Date: Thu, 23 Jul 2026 18:53:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784858075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Uo80B0gJ4nFnJDjBKSb2WqdqmzTtmF4qygD8Kxnt1s=;
	b=d6GRTJe3yobovDb/SD+n6Hclux25W43hYIZjkIRvhmGzCFyY69hAqFr4f8gsU8bUQ9ibRn
	Lgbpdyr/Y+kP49gCsby6g4iAtnWCZ3tlwlDvEealJ4Ph6/DiK3c6Njp7l0ynhVbrbRwaIo
	YdycinAxOYT0TOdWAQcrfcLDJoqz/GI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amK-ApfqfwkPheC5@linux.dev>
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
X-Migadu-Flow: FLOW_OUT

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
> 
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
> 
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

Oh man too long commit message, please follow Johannes's suggestion.

The patch looks good but I have one question. We already have concept of
pgrotated through /proc/vmstat which represents number of pages we have moved to
the tail of inactive LRU to make them next reclaim candidates. This patch is
exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
the number of pages we scanned but didn't reclaim plus number of pages given one
more trip in the active LRU.

Older and newer pgrotate metrics kind of represent something different. It may
cause confusion. Now before suggesting to change the name, let me ask do we
really need to expose these to the userspace? How exactly users can use these
new metrics? I think you can use them here without exposing to userspace. So,
does it makes sense to delay userspace exposure later when we have a more solid
usecase for that unless you have it already.

BTW really awesome work and I really like how these patches have reduced the lru
lock contention drastically.
