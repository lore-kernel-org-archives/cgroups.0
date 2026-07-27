Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72D3B14C1
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785170128; cv=none; b=KVLLaVDzC0jFtDIAgB7pq+L3EdUT6+hMdJXIug+usywUVegCr/vwNZuRj+rrFaa1rqg7TdQxBmS2nl4jj8tdgUboeOuDixIGBPpmI5K/Rizmt2TC5W5jngHoIYRMXtktfHyNuNJFPlLiQFblGntDeybUcsQjVF8ZKcTo5WHNRJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785170128; c=relaxed/simple;
	bh=F3SsJ6hqV+KSHSAoiu+2MbdM0Q95HlPWeQL7dXH02Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrzPJtZ9L+dS5fwb9CMRUTdX5A3X7xQyRNSKt95kjZ8ea87ydYr4wRMeOv6m0zAgi14wR9MJUI77+SPFIyeKyD0d66P5H13InmeMyhS5S52+f+aax6UsO6Zczhm959vebB0ir8EzZ4QIwGtAyXjPehXfPZF8t5bVXJncTcNY0J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Yval0zVP; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Yval0zVP"
Date: Mon, 27 Jul 2026 09:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjxJ4Ft7V0oMbE64yyZGCpBckJXYaY+q8Ii9o6DiK/g=;
	b=Yval0zVPqmXh4i741fO04m8Ycl1EtwHSU8rOp72V/QNS0dUUSV/8wa+LYO2glX5Tip2lw0
	XjQsrif9WzwtKdtiSe+MQ0wSIMngI4W3rUy/Tj5c0KIiBQ9F2CGpfRH2DEVAluiAqXssf6
	2dlFOqiBZykQ9SjvkqIIkL9b5yg5KUA=
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
Subject: Re: [PATCH v5 3/3] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <ameIpQtXv9pC2aaT@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-4-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727162550.2032-4-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 09:23:25AM -0700, Usama Arif wrote:
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
> The balance formula for anon and file, respectively, is this:
> 
>     cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Instead of recording cost and running averaging logic directly when
> these events occur, snapshot running vmstat counters once per reclaim
> cycle and derive the balance from event deltas since the last run.
> 
> Use PGROTATE_* from the preceding patch for the rotation input.
> WORKINGSET_RESTORE_* and NR_VMSCAN_WRITE provide the remaining event
> counters. Charge NR_VMSCAN_WRITE through lruvec stats so all inputs can
> be sampled per lruvec and aggregated through the memcg hierarchy. This
> is overall cheaper and has fewer lock acquisition sites.
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
> either reclaim implementation. The preceding patch also bumps
> PGROTATE_{ANON,FILE} from evict_folios(), so rotation-driven reclaim
> work is accounted consistently across both implementations.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I see you already added my Ack here. Sounds good.

