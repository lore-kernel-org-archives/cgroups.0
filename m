Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542FB423794
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169571; cv=none; b=oX7wEdDwo+JqcTp0oOB0zF3LYIxboYEfOz6YQsP5bRNp3XwZWH4x+kRxtuabUoEVUCpZ/3HzeuA40W12v5WfeuUF+uQU4/PJ8V3NL4DClz+28DTS94PPmASCbcSPIHGC3Y7vcEG0qgiwmpK1yeL4UpEO22XW2qXG0Pth9/dWBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169571; c=relaxed/simple;
	bh=4J+vE1gr5S2pT3Fa05tuOjBcZQCpZ0vdHokSC1cZ/E8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C5x+1eLYHiEfbTDUiJjXaH+SEIrfwgozIjtWGemRu7N4oy5poHIQuTtjwQxcKFsH8iC1Vp0//3QwPSFpONLRimEObf/3wkJF1uhNgktHogY9k2GIOKgmAjxwkRhgxIRLRmz80TlpYMzl7cRqvlasuhbImJqHncJcOxtEoE5304Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rM13sHm+; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rM13sHm+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785169556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ra9yHBirTJdVcJRt2PzI1Df5TxrhLhj87Z2KqNUXLRo=;
	b=rM13sHm+PY2VgfpS5L6v/2uLlCxByJHWVm0f6YztYVumzPyM2hrjTzbCaVO+7afeUai/2l
	RL2CWVKOtH1rZDAg8Zn5ljDcE12wx6CPhCU65kXjtRhJhJiZP5L49IDG9UgpYIU0pqNSBp
	wX/QYvLvGo8FX9ZxIO27BzxG23MhRP8=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
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
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 0/3] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon, 27 Jul 2026 09:23:22 -0700
Message-ID: <20260727162550.2032-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The actual code between v4 and v5 is the same. The last patch is
now split into 2 commits and the commit messages are shorter and
cleaner.

The anon/file scan balance heuristic in get_scan_count() is fed by two
scalars in struct lruvec (anon_cost, file_cost) that every reclaim
producer updates under lruvec->lru_lock. The cost-recording work
itself is trivial, but it both contends for and contributes to
contention on lru_lock - which is often a contention point on
memory-pressured workloads. Specifically:

- shrink_inactive_list() re-acquires lru_lock at function exit just
  to call lru_note_cost_unlock_irq().
- shrink_active_list() does the same after rotation accounting.
- workingset_refault() takes folio_lruvec_lock_irq() purely to
  record the refault cost.
- prepare_scan_control() snapshots anon_cost/file_cost under
  lru_lock.
- lru_note_cost_unlock_irq() itself walks parent_lruvec() and
  re-acquires lru_lock on every ancestor, multiplying the cost
  of every update by memcg-hierarchy depth.

This series removes those producer-side acquisitions entirely. The
rotation inputs become per-LRU PGROTATE_{ANON,FILE} vmstat counters.
NR_VMSCAN_WRITE already captures reclaim-driven pageout at writeout();
charge it through lruvec_stat_mod_folio() so it is available per lruvec
and aggregated through the memcg hierarchy. Reclaim does not submit
filesystem folios for writeback from this path, so pageout contributes
only to anon cost. WORKINGSET_RESTORE_* already captures the refault
input.

PGROTATE_* are also useful independently of scan balancing. They are
cumulative base-page events, not unique-page counts. Classic inactive
reclaim records scan work that does not produce immediate reclaim or
demotion, while active reclaim records referenced executable file folios
retained on the active list. MGLRU records initially isolated pages that
remain unreclaimed after its retry passes. Read alongside pgscan_* and
pgsteal_*, their deltas identify which LRU type is consuming reclaim CPU
without producing immediate yield. Unlike the existing pgrotated event,
they do not imply a move to the inactive-list tail.

prepare_scan_control() reads the raw cost signals without lru_lock:

  anon = PGROTATE_ANON +
         (NR_VMSCAN_WRITE + WORKINGSET_RESTORE_ANON) * SWAP_CLUSTER_MAX
  file = PGROTATE_FILE +
         WORKINGSET_RESTORE_FILE * SWAP_CLUSTER_MAX

It folds the deltas into a per-lruvec accumulator. A dedicated
per-lruvec cost_lock, not touched by isolate_lru_folios(),
move_folios_to_lru(), or folio_add_lru(), serialises the accumulator
RMW and the lrusize/4 halving check. Hierarchy aggregation is implicit
in rstat propagation, so the parent_lruvec() walk and the
lru_reparent_memcg() cost-splice both disappear.

Moving accumulation and decay to the reclaim side also improves the
cost model across reclaim gaps. With producer-side decay, events that
happen while reclaim is idle still age each other before reclaim ever
samples the costs. If a workload refaults a large anon set and then a
smaller file set before reclaim runs again, the later file activity can
age the earlier anon activity out of the cost model. The new scheme
observes the whole between-reclaim delta and decays anon and file
proportionally, so the scan-balance history better represents what
happened since the last reclaim pass.

Trade-offs:
  - Cost reads see rstat-aggregated values that can lag until periodic /
    reader-triggered flushing.
  - Per-lruvec footprint grows by 4 unsigned longs + a spinlock (a
    struct lru_cost { count, last_rotated, last_io } per side), which
    is a small cost.
  - NR_VMSCAN_WRITE now also updates the folio's lruvec/memcg stat,
    adding memcg stat accounting to the reclaim writeout path while
    preserving the existing node-level total.

== Numbers ==

Tested on a 176-core, 256 GB host. The benchmark drives sustained
swap-out/refault inside a tight memcg using vm-scalability/usemem:

  usemem -n 16 --prealloc --prefault --random $((256*1024*1024))

run inside a two-level memcg with memory.max=512M on the leaf
(4 GB anon working set has to fit in 512 MB -> continuous
shrink_inactive_list + workingset_refault). A 16 GB swap file
is used. Measurement is a 30 s `perf lock record -a` window
over otherwise-idle hardware.

Workload rates are identical on both kernels (the bench drives the
same memory pressure):

                          baseline    patched      delta
  pgscan_direct  / s      172,662     171,817      ~0%
  pgsteal_direct / s       67,162      66,306      ~0%
  workingset_refault_anon / s
                           40,696      39,830      ~0%

perf lock contention (total wait per 30 s window):

  Lock Name                Before      After     % change
  shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
        (= lru_note_cost_unlock_irq)
  workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
        (= lru_note_cost_refault)
  shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
  shrink_active_list      208.34 ms    15.97 ms  -92%
  lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%

  Total LRU lock wait      ~4.23 s     ~1.66 s   -61%

The two specific contention sites the patch removes
(shrink_lruvec+0x770 = lru_note_cost_unlock_irq;
workingset_refault+0x167 = lru_note_cost_refault) are completely
absent from the patched perf-lock-contention output.
Secondary reductions in shrink_node, shrink_active_list,
lru_add_drain_cpu and pgrefill/pgactivate look like knock-on
effects from removing the cost-recording overhead and the
parent_lruvec walk.

The remaining ~1.66 s of LRU lock wait on the patched kernel is
dominated by the per-CPU pagevec drain (lru_add_drain_cpu) and the
main reclaim path in shrink_lruvec.

The numbers above can be reproduced using the script in [1].

[1] https://gist.github.com/uarif1/a4eb33a86c5b2d7bbc55b42f0956e884

v4 -> v5: https://lore.kernel.org/all/20260720164207.450685-1-usama.arif@linux.dev/
- Cleaner and shorter commit message (Johannes and Shakeel)
- Split PGROTATE_{ANON,FILE} definitions and producer accounting into
  a standalone patch, and document their public diagnostic value (Shakeel)

v3 -> v4: https://lore.kernel.org/all/20260717135807.3476029-1-usama.arif@linux.dev/
- Fold the two per-lruvec cost arrays (prev_cost[], cost_accum[]) into
  a struct lru_cost { count, last_rotated, last_io } cost[ANON_AND_FILE]
  in struct lruvec. (Johannes)
- Sample rotated and io separately in prepare_scan_control() and
  compute the raw per-counter deltas before applying the
  SWAP_CLUSTER_MAX weighting, rather than sampling a pre-weighted sum
  and taking a delta from it. Easier to reason about the overflow
  behaviour. (Johannes)
- Drop the per-side checks in the halving loop; anon > limit implies
  anon + file > limit for unsigned counters, so only the sum check
  is needed. (Johannes)
- Trim the prepare_scan_control() comment back to something close to
  the original wording. (Johannes)

v2 -> v3: https://lore.kernel.org/all/20260713163443.3562378-1-usama.arif@linux.dev/
- Reuse NR_VMSCAN_WRITE for anon pageout cost instead of adding
  PGRECLAIM_PAGEOUT_{ANON,FILE}. Reclaim no longer writes filesystem
  folios from this path, so there is no file pageout cost. (Johannes)
- Charge NR_VMSCAN_WRITE through the lruvec/memcg stats and remove the
  now-unused reclaim_stat.nr_pageout plumbing.
- Account PGROTATE_{ANON,FILE} in the MGLRU eviction path so the new
  counters remain meaningful regardless of the active LRU implementation.
  (sashiko)
- MGLRU updates PGROTATE_{ANON,FILE} so the counters remain meaningful
  with it. (sashiko)

v1 -> v2: https://lore.kernel.org/all/20260706122954.3552990-1-usama.arif@linux.dev/
- Sample via the newly introduced lruvec_page_state_monotonic()
  to fix a 32-bit delta underflow when the underlying signed
  long wraps past LONG_MAX (Johannes and sashiko)

RFC -> v1: https://lore.kernel.org/all/20260626122009.75334-1-usama.arif@linux.dev/
- Document in coverletter and commit message  how the read-side vmstat accumulator
  improves cost-model aging across reclaim gaps (Johannes)
- Fully decay the cost_accum below lrusize / 4 using a while loop (sashiko)
 
Usama Arif (3):
  mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
  mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
  mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance
    cost

 include/linux/memcontrol.h |  8 ++++
 include/linux/mmzone.h     | 15 +++++-
 include/linux/swap.h       |  3 --
 include/linux/vmstat.h     | 17 ++++++-
 mm/memcontrol-v1.c         |  4 +-
 mm/memcontrol.c            | 39 ++++++++++++++++
 mm/mmzone.c                |  1 +
 mm/swap.c                  | 69 ----------------------------
 mm/vmscan.c                | 93 ++++++++++++++++++++++++++++++++------
 mm/vmstat.c                | 13 ++++++
 mm/workingset.c            |  5 --
 11 files changed, 171 insertions(+), 96 deletions(-)

-- 
2.53.0-Meta

