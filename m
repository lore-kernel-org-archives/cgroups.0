Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793437261;
	b=xHTUrj/KZQy/mqn5rn1R32rxBAFep+AaF18R49K81tHMaACHE6kQE6UTfHwSLVfYe78o
	 sVF3Hu1FWXDk3K61Fw2CpuiyavatcBqqfSz+2bbRDgY5b6iC2X+JjxTPA+hnx+aepALEJ
	 p5gFwQaR2ICmA7jJmMYDOUZCDvK8ZE2LASluGpM0r653BFTJ3wNa81fv1NUt+8ZO88m3s
	 RITT4do+O1Tf0mQ7vjyTwTolWdjAAVMo2cd/5GdPpnXqBvD+nUWInYnmDNqAZb/fpK3Ug
	 eUJqTIPt+QsrhWFtGdmekkVBvmWX5DXIarS1LkxIABo/rhRn8EGQb3tCrR+pM42yDMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437261;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/+cDz8z+S13VVW23DttFiWRGg6YpwxqQvUMi2t0mKYg=;
	b=BRGXTvXYIscmSld6vIRVK+DUzVVzDyg7q8HkaZxRW37TSr7JJVHkUGCZUqE2bnVBpJs8
	 NkvRwuX8x+O7sNeyuh+J0iKJEZTo0KHmJtT3d3Dt8CB6SRq6UIonIZw9d3WOEPCTcxmpN
	 NssxyOZwIxDkuyKyQZmMI0ScPLm8SyRR5GRGXPfc7LIwWVLOjWX+pKkt0pX6Xqoc/LEJZ
	 /WVCiKLko7frgazTSmgWR8pXoop0zVFnpfbyf65l/A+xiQ0jAM4tJXemR1AMvagVJb/IC
	 32c7T5p1JR816ub5RTXIKpZYCW/saU6oOKpmpI5TGu1wgyLgamVOmm1m7e0TAxDAx/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="d/AIhSmj";
	arc=none smtp.remote-ip=95.215.58.18
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FA7606A327
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 09:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44FA7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d/AIhSmj
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9ESn0iXGOsbPe21qbfI7nx+GR2XMCLLmsCh+GUZKzlI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437257; v=1; x=1794042057;
 b=d/AIhSmjk5wYePxo28ut9MO2TWV5KHyRlSNA9yN9Kw+F8IpI4OnHWv2y6wMoyklQXNhvhAR4
 UeF6hb+My090UMmwqJ6sm2kJ+LvMSSSoYB0xtOcUtxidraIs4npx2HSFqt9zReV4aj2awIUrOGn
 b5vOToj3/U5KYogTVT9OztRQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e4beb363cb06b63a;
	Sat, 31 Oct 2026 09:00:57 +0000
X-Mizu-Trace-ID: e4beb363cb06b63a
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
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>
Subject: [PATCH v5 0/6] mm/vmscan: move tracepoints to mm/ and add MGLRU tracepoints
Date: Sat, 31 Oct 2026 17:00:35 +0800
Message-ID: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
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

Part 1, restructuring (patches 1-4):

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, setting
     TRACE_INCLUDE_PATH to "." and adding -I$(src) for vmscan.o;
  3) move struct scan_control into a dedicated mm/vmscan.h with an
     ordinary include guard, which trace_vmscan.h pulls in;
  4) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign: the reclaim-begin events, the LRU
     isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Part 2, MGLRU tracepoints (patches 5-6):

  5) add mm_mglru_scan_folios on the scan path, next to the classic
     mm_vmscan_lru_isolate, reporting the same counters plus nr_sorted
     and the nid, memcg id, max_seq, tier and min_seq of the lruvec;
  6) add mm_mglru_inc_max_seq on the aging path, reporting the nid,
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

This series was developed with the assistance of an LLM-based coding
assistant. All changes have been reviewed by hand, and I take full
responsibility for them.

---
Changes in v5:
  - Squash v4 patches 4-7 into a single patch 4 (Barry).
  - Link to v4: https://lore.kernel.org/linux-mm/20261019034426.2354049-1-ridong.chen@linux.dev/

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

Ridong Chen (6):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the vmscan tracepoints
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

-- 
2.43.0

