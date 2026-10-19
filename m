Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7EF244694
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 03:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792381549; cv=none; b=C5DCdJnRAR0ZGC9QGYoTvi+Owaun/muhvy2PI2V+9PDJc0SEck9K5Q3aRz43FWLc1D+3XqR3+X1Njdd8jCsgoDAt9GE+NAQE1c34fKAPLJkurXKbxEH/etCwVSdx+59Uuuk92gLLOsWdgCrmWzkMVEeCalMHxqSCDmz7mTECga4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792381549; c=relaxed/simple;
	bh=GVmvFdM+XNAIwjgACYtP3IWMZfKPh9cvSBz2M6fBa94=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e5q/vY1Gtrw9nzNWYXuKAzHS4vmkpgDLSU6TT2zO0g2N2J7a1M9B5/B98n/EErbSdi/oHaLA29x8XjouzXp+YDtrjJipzWwsW0+8KBFqFmJBMzzg95Jk9Ha4ryn7omiOVGNytaWfL7vjSpRQ5rH2BO8K5QUoJ0pXFlytFbnZCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZpR3aEjO; arc=none smtp.client-ip=91.218.175.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZpR3aEjO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GVmvFdM+XNAIwjgACYtP3IWMZfKPh9cvSBz2M6fBa94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792381544; v=1; x=1792986344;
 b=ZpR3aEjOfsVXgDki7RQvm55pc+bhVSFtt9iPrfFyfF/idDY8TvsLYU2gAV8vAdX8HGJWRyFm
 PbmAg/h7i5S7VQR8M4MWs81LU1kceXOXv2O17BKxQD5UlubU8PjLrk1AnPeg4MOt7j3wziJFtAo
 nQZBKG6OA+SAS8Q8HW4Cg3dU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6fb5d35c48fecbe;
	Mon, 19 Oct 2026 03:45:38 +0000
X-Mizu-Trace-ID: d6fb5d35c48fecbe
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 0/9] mm/vmscan: move tracepoints to mm/ and add MGLRU tracepoints
Date: Mon, 19 Oct 2026 11:44:17 +0800
Message-Id: <20261019034426.2354049-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Background
==========

MGLRU currently has no tracepoints of its own. The scan and evict paths
reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
generation, sequence or memcg context. A trace of a running system
therefore cannot tell which memcg a given scan belongs to, how far
reclaim has progressed through the generations, or when a new generation
is created.

While reviewing an earlier version that added two MGLRU tracepoints,
Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too,
letting the trace events access its fields directly instead of having
each callsite copy the scalars out by hand. This version merges the two
efforts into one series: the restructuring first, then the two new
tracepoints built on top of it.

Implementation
==============

Part 1, restructuring (patches 1-7):

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, setting
     TRACE_INCLUDE_PATH to "." and adding -I$(src) for vmscan.o;
  3) move struct scan_control into a dedicated mm/vmscan.h with an
     ordinary include guard, which trace_vmscan.h pulls in;
  4-7) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign, one group at a time: the reclaim-begin
     events, the LRU isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Part 2, MGLRU tracepoints (patches 8-9):

  8) add mm_mglru_scan_folios on the scan path, next to the classic
     mm_vmscan_lru_isolate, reporting the same counters plus nr_sorted
     and the nid, memcg id, max_seq, tier and min_seq of the lruvec;
  9) add mm_mglru_inc_max_seq on the aging path, reporting the nid,
     memcg id, the new max_seq, the anon/file min_seq and the
     per-generation page counts of both types.

Both new events only take pointers (lruvec, sc) plus the local counters,
and derive everything else in TP_fast_assign(), so the reclaim paths do
no extra work when they are disabled.

Effect
======

Part 1 moves the loads of the tracepoint arguments out of the reclaim
paths and into the trace event callbacks, which only run when the event
is enabled. On x86_64 with gcc 11.4, the callers in mm/vmscan.o shrink
accordingly (bytes), e.g.:

  isolate_lru_folios    4060 -> 3896 (-164)
  __node_reclaim        2407 -> 2225 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3674 -> 3549 (-125)
  evict_folios          4858 -> 4769  (-89)

There is no functional change in part 1. TP_STRUCT__entry and TP_printk
of the existing events are untouched, so their tracefs format is
identical. This was confirmed by diffing the tracefs format files before
and after, and by capturing the direct/memcg/node reclaim-begin events
under load in a QEMU guest (order, gfp_flags and memcg_id all match).
BPF programs attached via raw_tp/tp_btf do see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

highest_zoneidx and nr_reclaimed stay separate arguments: the former is
a balance_pgdat() parameter (sc.reclaim_idx may differ from it by the
time the end event fires), and the latter is the return value of
shrink_folio_list(), which does not update sc->nr_reclaimed.

Part 2 makes the full aging-to-eviction window observable per memcg:
aging advances max_seq (the leading edge), scanning consumes the oldest
generations, and the min_seq/max_seq pair on each event shows how the
generation window moves over time. A sample trace, with the classic-LRU
tracepoints left enabled to show how they interleave:

  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=4 nr_scanned=1 nr_skipped=0 nr_taken=1 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=4 nr_scanned=1 nr_sorted=0 nr_skipped=0 nr_taken=1 lru=inactive_file max_seq=3 tier=3 min_seq=0
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=1 nr_reclaimed=1 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_inc_max_seq: nid=0 memcg_id=1833 max_seq=4 anon_min_seq=1 file_min_seq=1 nr_anon={0x0,0x0,0x0,0x0} nr_file={0x0,0x12,0x0,0x0}
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=3 nr_scanned=3 nr_skipped=0 nr_taken=3 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=3 nr_scanned=3 nr_sorted=0 nr_skipped=0 nr_taken=3 lru=inactive_file max_seq=4 tier=3 min_seq=1
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=3 nr_reclaimed=3 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

The mm_mglru_scan_folios lines carry the node, memcg id and the
generation window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate
lines above them cannot - those cannot even say which memcg they came
from. The mm_mglru_inc_max_seq line then shows a new generation being
created (max_seq 3 -> 4) with the per-generation page counts for both
types, and the following scan already reports the moved window
(max_seq=4 min_seq=1).

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

---
Changes in v4:
  - Merge the MGLRU tracepoint series [2] into this one, on top of the
    restructuring, and drop the RFC tag.
  - Patch 2: use TRACE_INCLUDE_PATH "." with CFLAGS_vmscan.o += -I$(src)
    instead of a relative path (Steven).
  - Patches 8-9: pass lruvec/sc and compute the fields in
    TP_fast_assign() instead of at the call site (Steven).
  - Patches 8-9: add nid, derived from the lruvec (Baoquan).
  - Patch 8: group the int fields at the end of the entry to avoid
    padding on 64-bit (Steven).
  - Drop "mm/mglru: factor out lru_gen_seq_nr_pages()" from [2]: the
    per-generation page count is now summed inside TP_fast_assign(), so
    the helper has no user. The Reviewed-by tags given to [2] are not
    carried over, as patches 8-9 changed substantially.
  - Link to RFC v3: https://lore.kernel.org/all/20261013131309.2790253-1-ridong.chen@linux.dev/

Changes in RFC v3:
  - Use "Assisted-by: LLM" (Muchun).
  - Note the BPF raw_tp/tp_btf impact in the changelogs (Sashiko).
  - Changelog wording fixes and minor indentation fixes.
  - Link to RFC v2: https://lore.kernel.org/all/20260928114625.3609130-1-ridong.chen@linux.dev/

Changes in RFC v2:
  - Convert the remaining vmscan tracepoints too.
  - Move struct scan_control to mm/vmscan.h (Baoquan).

[2]: https://lore.kernel.org/all/20260911102939.2485750-1-ridong.chen@linux.dev/

Ridong Chen (9):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the reclaim-begin tracepoints
  mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
  mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
  mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
  mm/mglru: add tracepoint for scan_folios()
  mm/mglru: add tracepoint for inc_max_seq()

 MAINTAINERS                                   |   4 +
 mm/Makefile                                   |   1 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      | 193 ++++++++++++++----
 mm/vmscan.c                                   | 140 ++-----------
 mm/vmscan.h                                   | 118 +++++++++++
 7 files changed, 296 insertions(+), 164 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (76%)
 create mode 100644 mm/vmscan.h


base-commit: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
--
2.34.1

