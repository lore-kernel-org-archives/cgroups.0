Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797724;
	b=TBROs4J7ZsihkPpbVhepnTFLMhOqNFf4+K0avMRvIDC5A3jnhwKtlrolORdrJXagVnD/
	 d6Pzv7mk5beN4c4uc0E6nq3lsHiALuLUBHvySC3oFUxWvqKzm+mrZzR8iJYMqwkkYW82i
	 if57INKpctojQAzK1gOO0y4yBKR5cFNvc1niggX3NDoe1Pe/hRaawKN2iA3z0vdOyMqyh
	 WxXNsZYXO0RG636v6voBKMfsEks89650dfDVX8YhxDYmmrnCAdycz99PbM14IjkR7OJ6O
	 5ZkgmXuCBLFBMj0wLKF/4SHEQiRAlr3nITpcPxofsAWLPfxGaXvhLjiAZhLvmDvpsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797724;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=SD83MyKiywTc+TN/8/2wfNOj/0fFKMFcGtnw7SCodeU=;
	b=mV6LhYrCK04AQZweHOvsRDIXaO3fmHpaeSSMUnuFCZyzsd9+VSJ2CpFPilhF+lIUWvmY
	 jzlPrZ1jZCb7vuFKxN/utbAGfpNiSsFwIBlektQ4k2JhuZErHt4w8XuhANKBmrjc0COrv
	 h4Ffk6oKGtWupkW7yuFTtFwposXkV6hgkBYElZ6Y24Jgo3w3awh5SqwCNOIQvqVmiR3HD
	 e1gp0rW/gf7I6ovKGob+gI8/CBtKPYJsQID8qfvGo01mxFZB253woTRA38YLGtpNOuvpe
	 I5y8FNI4XiVZzuVJTkWfp1MyraR/NP11gExNvOKTtHWIhwB/yGAmpnqzcpns8tWNFiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bSu+kViu;
	arc=none smtp.remote-ip=91.218.175.120
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6B606A32C
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:08:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AE6B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bSu+kViu
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yOZI4i+Ly/cHDAGc0pvxPEGgnqpY30xhJvqcupnDhuY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797719; v=1; x=1794402519;
 b=bSu+kViurHqJIPdQRGDI/TTtXJBWtZuOfdjnIRkh8qjR7BaCr+KtzPXFP/LO27cW5NxL8sxw
 IB0BF0OmbpOUfplEhBtcjMKtsZ38/BOzBBjjte8S8XwJYGdEduK3eMrcQYtSEeLZ8E2j+4u/6um
 UuEaUYZECKrDfj2QOK+3KMmA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 44a248944bee64e0;
	Wed, 04 Nov 2026 13:08:39 +0000
X-Mizu-Trace-ID: 44a248944bee64e0
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 0/7] mm/vmscan: move tracepoints to mm/ and add MGLRU tracepoints
Date: Wed,  4 Nov 2026 21:08:10 +0800
Message-Id: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
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

Part 2, MGLRU tracepoints (patches 5-7):

  5) add mm_mglru_scan_folios on the scan path, next to the classic
     mm_vmscan_lru_isolate, reporting the same counters plus nr_sorted
     and the nid, memcg id, max_seq, tier and min_seq of the lruvec;
  6) add lruvec_gen_size() to mm/vmscan.h, returning the number of
     pages of one type in the generation of a given seq, and convert
     the two open-coded users in vmscan.c;
  7) add mm_mglru_aging where aging is triggered in
     try_to_shrink_lruvec(), reporting the nid, memcg id,
     sc->priority, swappiness, max_seq, the anon/file min_seq and the
     per-generation page counts of both types before aging, from the
     oldest generation to the newest as in the debugfs lru_gen file.

Both new events only take pointers (lruvec, sc) plus a few local
values, and derive everything else in TP_fast_assign(), so the reclaim
paths do no extra work when they are disabled.

Effect
======

Part 1 moves the loads of the tracepoint arguments out of the reclaim
paths and into the trace event callbacks, which only run when the event
is enabled. On x86_64 with gcc 11.4, the callers in mm/vmscan.o shrink
accordingly (bytes), e.g.:

  isolate_lru_folios    4499 -> 4335 (-164)
  __node_reclaim        2402 -> 2220 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3669 -> 3544 (-125)
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
generation window moves over time. A sample trace, captured under
memory.reclaim of a test memcg, with the classic-LRU tracepoints left
enabled to show how they interleave:

  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_skipped=0 nr_taken=36 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_sorted=0 nr_skipped=0 nr_taken=36 lru=inactive_file max_seq=3 tier=3 min_seq=0
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=36 nr_reclaimed=31 nr_dirty=1 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=1 nr_ref_keep=4 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_aging: nid=0 memcg_id=1833 priority=2 swappiness=0 max_seq=3 anon_min_seq=0 file_min_seq=2 nr_anon={0x0,0x0,0x802,0x0} nr_file={0x0,0x0,0x357,0x0}
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_skipped=0 nr_taken=64 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_sorted=0 nr_skipped=0 nr_taken=64 lru=inactive_file max_seq=4 tier=3 min_seq=2
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=64 nr_reclaimed=64 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_aging: nid=0 memcg_id=1833 priority=2 swappiness=0 max_seq=4 anon_min_seq=1 file_min_seq=2 nr_anon={0x0,0x802,0x0,0x0} nr_file={0x0,0x317,0x0,0x0}

The mm_mglru_scan_folios lines carry the node, memcg id and the
generation window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate
lines above them cannot - those cannot even say which memcg they came
from. The mm_mglru_aging lines show when and why aging is triggered:
the first one has only two file generations left (file_min_seq=2,
max_seq=3, swappiness=0), so eviction is not possible anymore; the
second one has three left, and aging runs again as the priority is
below DEF_PRIORITY. The scans in between already report the new window
(max_seq=4 min_seq=2).

Testing
=======

The output of mm_mglru_aging matches the debugfs lru_gen_full file
dumped right before the aging. As the sizes are taken before aging, the
youngest generation is populated too, e.g. for a test memcg whose anon
pages are being accessed while it is aged:

  mm_mglru_aging: nid=0 memcg_id=1833 priority=11 swappiness=60 max_seq=13 anon_min_seq=12 file_min_seq=12 nr_anon={0x0,0x0,0x1925,0x15ef} nr_file={0x0,0x0,0x411,0x0}

  # cat /sys/kernel/debug/lru_gen_full    (generation lines only)
  memcg 1833 /tpy
   node     0
           10       4539          0           0x
           11       2904          0           0x
           12       2757       6437        1041
           13       1564       5615           0

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

This series was developed with the assistance of an LLM-based coding
assistant.

---
Changes in v7:
  - Patch 7: replace mm_mglru_inc_max_seq with mm_mglru_aging, emitted
    in try_to_shrink_lruvec() right before try_to_inc_max_seq(), to
    show why and at what priority aging is triggered. It also reports
    sc->priority and swappiness, and the per-generation sizes are taken
    before aging, so the youngest generation is populated as well. The
    reason itself is not reported, as it can be derived from these
    fields (Barry).
  - Rebase onto the latest mm-new.
  - Collect Reviewed-by tags from Baoquan and Barry.
  - Link to v6: https://lore.kernel.org/linux-mm/20261103025610.3738894-1-ridong.chen@linux.dev/

Changes in v6:
  - Rebase onto mm-new; MAINTAINERS already listed
    include/trace/events/vmscan.h under MEMORY MANAGEMENT - RECLAIM,
    patch 2 now renames that entry.
  - New patch 6: add lruvec_gen_size(), ported from Barry's swappiness
    series [3], in mm/vmscan.h so the tracepoint can use it too, and
    convert lruvec_evictable_size() and the debugfs lru_gen output
    (Barry).
  - Patch 7: order nr_anon/nr_file by seq, from the oldest generation
    to the newest, the same order as the debugfs lru_gen file, instead
    of by generation slot (Barry, Baoquan).
  - Collect Reviewed-by/Acked-by/Tested-by tags from Baoquan, Muchun
    and Barry.
  - Link to v5: https://lore.kernel.org/linux-mm/20261031090041.58574-1-ridong.chen@linux.dev/

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
[3]: https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/



Ridong Chen (7):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the vmscan tracepoints
  mm/mglru: add tracepoint for scan_folios()
  mm/mglru: add lruvec_gen_size() helper
  mm/mglru: add tracepoint for aging

 MAINTAINERS                                   |   5 +-
 mm/Makefile                                   |   1 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      | 198 ++++++++++++++----
 mm/vmscan.c                                   | 157 ++------------
 mm/vmscan.h                                   | 134 ++++++++++++
 7 files changed, 322 insertions(+), 177 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (75%)
 create mode 100644 mm/vmscan.h


base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.34.1

