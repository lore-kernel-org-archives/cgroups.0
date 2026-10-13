Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F29C5158B6
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897168; cv=none; b=b8FIHClXwMXds35JycJQQxFLmX+MgBoYHZ9iJoKEbFv7xyjuoDXmEHQuI4YG77tDCwTRff717P3AiE6air32Lfr8D5rL+ksNR+9lsW5Pz9aoedgRkNN0gsHH+27n5y4844zr85pTsmFzQihJtWYUMLNvZe7OE9YIeKiKyqyRLNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897168; c=relaxed/simple;
	bh=dGFgIE1Ak3qC4ku6H3c6KA+1Zmp1EwOYePHWmr/QoHY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Plo97ElHJoTrG7yKqQ1Mp0Bs/xC6M+OGdx1j/uqIeAbh4GaMb4FB/t58LR6Sci/lMJ+vcqcDq7l7y2PpxpBZtf/Jia8FQZY54v/J6z+TM7Yxk3ef6JAvLRRZBCZKfS98tJ3Kwd+3r1D4sc3zrdqKyb4Q35Cc4PlyJh2TtQ+Cj7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kGxcJwju; arc=none smtp.client-ip=95.215.58.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kGxcJwju"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dGFgIE1Ak3qC4ku6H3c6KA+1Zmp1EwOYePHWmr/QoHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897163; v=1; x=1792501963;
 b=kGxcJwjuZg+WkKy0F/T3dV72M22Ii83SGegKddzjlRTTpWidQ75IYu6vBeRy6QlZV9pJn1ss
 1RnvEM48gq7JmwwkGPrcFG0tsQHV1nMQeMzkKYIN9C+lgxfuVrpQWTtOfv1RQrN40OYDUVazMvg
 +oR3gWu9rIBgov+toWXwouUo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4518c51e3d8db235;
	Tue, 13 Oct 2026 13:12:42 +0000
X-Mizu-Trace-ID: 4518c51e3d8db235
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 0/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Tue, 13 Oct 2026 21:12:10 +0800
Message-Id: <20261013131217.2789684-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

This series started as an effort to add two tracepoints for MGLRU. In the
discussion, Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too, letting
the trace events access its fields directly instead of having each callsite
copy the scalars out by hand.

The series builds in small steps:

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into a dedicated mm/vmscan.h, which
     trace_vmscan.h pulls in, guarded against the multi-read that
     define_trace.h performs;
  4-7) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign, one group at a time: the reclaim-begin
     events, the LRU isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Besides the cleanup, this moves the loads of the tracepoint arguments out
of the reclaim paths and into the trace event callbacks, which only run
when the event is enabled. On x86_64 with gcc 11.4, the callers in
mm/vmscan.o shrink accordingly (bytes), e.g.:

  isolate_lru_folios    4060 -> 3896 (-164)
  __node_reclaim        2258 -> 2076 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3669 -> 3544 (-125)
  evict_folios          4787 -> 4698  (-89)

There is no functional change. TP_STRUCT__entry and TP_printk are
untouched, so the tracefs event format is identical. This was confirmed
by diffing the tracefs format files before and after, and by capturing
the direct/memcg/node reclaim-begin events under load in a QEMU guest
(order, gfp_flags and memcg_id all match). BPF programs attached via
raw_tp/tp_btf do see the new TP_PROTO and need to be adjusted;
tracepoints are not a stable ABI (see Documentation/bpf/bpf_design_QA.rst).

highest_zoneidx and nr_reclaimed stay separate arguments: the former is
a balance_pgdat() parameter (sc.reclaim_idx may differ from it by the
time the end event fires), and the latter is the return value of
shrink_folio_list(), which does not update sc->nr_reclaimed.

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

---
Changes in RFC v3:
  - Use "Assisted-by: LLM" (Muchun).
  - Note the BPF raw_tp/tp_btf impact in the changelogs (Sashiko).
  - Changelog wording fixes and minor indentation fixes.
  - Link to RFC v2: https://lore.kernel.org/all/20260928114625.3609130-1-ridong.chen@linux.dev/

Changes in RFC v2:
  - Convert the remaining vmscan tracepoints too.
  - Move struct scan_control to mm/vmscan.h (Baoquan).

Ridong Chen (7):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to a dedicated header
  mm/vmscan: pass scan_control to the reclaim-begin tracepoints
  mm/vmscan: pass scan_control to the LRU isolate/shrink tracepoints
  mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
  mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end

 MAINTAINERS                                   |   4 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      |  80 ++++++-----
 mm/vmscan.c                                   | 136 ++----------------
 mm/vmscan.h                                   | 118 +++++++++++++++
 6 files changed, 178 insertions(+), 164 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (90%)
 create mode 100644 mm/vmscan.h


base-commit: 4eb2586bd40db27d77cc5b724ca9386ed0c71d53
-- 
2.34.1

