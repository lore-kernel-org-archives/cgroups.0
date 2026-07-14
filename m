Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAED378D64
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033081; cv=none; b=jwpWNdM86ZW/isHAihTHXEdF4ZouU35H/CoJKw46Qjbrtij2pVPS6oD7DFDfaYKaL2UlfzfAz02v97uHnzJNra9QpcsIUJa7TEtS45bDVbYQ/VY1sn5wJqIEJ43F/rl1D1C5qbr90wAumSkyeKwiNeg585nkBE4yxUKwRxrm55g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033081; c=relaxed/simple;
	bh=UDMGl+NchJmNqRQFdjRgGeXOP2yiFKcr6jrvX+VusAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fylTWVGKDGCAlcR9hzE8UdMBt+QpfkRvHkVJM/SiOx3tfNLBA97oH/yZwbX12OSMB+oRRJ/sQ/x+Q1nG3v15nDhVFxkZBA43AgFwQmJkStnWkwxlajWdLqoZB2nouMz8NZCWcoRTkd2FHb+uytk9IIppwBTKwEHFTCY781ueGR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vfw4wVy4; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vfw4wVy4"
Message-ID: <25a94af5-1dbe-4ab4-b47d-fb49987bfcd4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784033076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SL2BuBErJSR+msyoMlTQpeX2tgyYFMJLBrTouVN+o3E=;
	b=Vfw4wVy4dFED07nvt6oOpMkXirev2Y5GMxKO5ot6QfOqKJyPHMsdi4giItxcH80oClK6xP
	5UglsrKFeXrW34PiHzsomYxK4+ifqhq3VTgN8mGFL/rnG6aQRdHl6tSw7NIPegyx5yPDDI
	RbSVA//0HtXp7v6qjpAxaIHb4J6CP6g=
Date: Tue, 14 Jul 2026 13:44:03 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com,
 kernel-team@meta.com
References: <20260713163443.3562378-1-usama.arif@linux.dev>
 <20260713163443.3562378-3-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260713163443.3562378-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 13/07/2026 17:34, Usama Arif wrote:
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
> Add explicit node_stat counters for the producer-local inputs:
> 
>   PGRECLAIM_PAGEOUT_{ANON,FILE} - reclaim-driven pageout submissions
>                                   (formerly stat.nr_pageout, weighted
>                                   by SWAP_CLUSTER_MAX).
>   PGROTATE_{ANON,FILE}          - reclaim-driven rotations, bumped from
>                                   both shrink_inactive_list (by
>                                   nr_scanned - nr_reclaimed) and
>                                   shrink_active_list (by nr_rotated),
>                                   unweighted.
> 
> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> lru_note_cost_refault() used to bill.
> 
> In prepare_scan_control() the raw cost signal is recomputed lock-free of
> lru_lock from monotonic counters:
> 
>   now = (PGRECLAIM_PAGEOUT_X + WORKINGSET_RESTORE_X) * SWAP_CLUSTER_MAX
>         + PGROTATE_X
> 
> The delta against a per-lruvec prev_cost[] snapshot is folded into
> cost_accum[]. Since one vmstat delta can cover many producer events
> between reclaim passes, halve cost_accum[] until the total is back
> within the lrusize/4 bound instead of halving only once.
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
> A dedicated per-lruvec spinlock, cost_lock, serialises the prev_cost
> RMW, the accumulator update, and the halving check against concurrent
> reclaimers in the same memcg+node.
> 
> Hierarchy aggregation is now implicit in the vmstat accounting. The
> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> existed only because anon_cost/file_cost were private lruvec fields. With
> the cost expressed as lruvec vmstats, rstat propagates the underlying
> counters through the memcg hierarchy and prepare_scan_control() consumes
> the same ratelimited rstat view as the surrounding reclaim heuristics.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost_accum[] instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/mmzone.h | 11 +++++--
>  include/linux/swap.h   |  3 --
>  mm/memcontrol-v1.c     |  4 +--
>  mm/memcontrol.c        |  4 +++
>  mm/mmzone.c            |  1 +
>  mm/swap.c              | 69 ----------------------------------------
>  mm/vmscan.c            | 72 ++++++++++++++++++++++++++++++++++++------
>  mm/vmstat.c            |  4 +++
>  mm/workingset.c        |  5 ---
>  9 files changed, 82 insertions(+), 91 deletions(-)
> 

The patch will need the below fixlet so that the counters keep incrementing
for MGLRU as well. The counters themselves are not actually used by MGLRU,
so this is just for observability. This was reported by sashiko, Thanks
Andrew for pointing this out!


From 0fd35b49112cc0d689741f04c485283e6dce3326 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Tue, 14 Jul 2026 05:18:16 -0700
Subject: [PATCH] [fixlet] mm/vmscan: increment pgreclaim_pageout_* and
 pgrotate_* for MGLRU

/proc/vmstat and per-memcg memory.stat expose pgreclaim_pageout_*
and pgrotate_* directly (memcg_node_stat_items in memcontrol.c
forwards them per-memcg). Without this fix they stay at 0 whenever
reclaim runs through MGLRU, misreporting observability.

Under pure MGLRU the scan-balance signal itself is not consumed (both
prepare_scan_control() and get_scan_count() are short-circuited on the
MGLRU paths, and MGLRU's own type/tier selection comes from
read_ctrl_pos() on lrugen->{avg_refaulted,avg_total,refaulted,evicted},
not from anon_cost/file_cost), so this fix is about observability.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmscan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 279f78b7a0e4..2da36374bb4a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4867,7 +4867,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0, total_pageout = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4879,6 +4880,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4891,6 +4893,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
+	total_pageout += stat.nr_pageout;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4944,6 +4948,13 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (total_pageout)
+		mod_lruvec_state(lruvec, PGRECLAIM_PAGEOUT_ANON + type,
+				 total_pageout);
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
-- 
2.53.0-Meta



