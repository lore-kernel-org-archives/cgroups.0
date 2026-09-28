Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A24B1473
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596016; cv=none; b=ExeparRJW8xqsuTg7UFw8oSFrhuXbXmaN/35exonyjDqll6p/ngW+JdqjqdhzB3XD8Ddla/ikngx4Adl1HtAP45h2a+BN3Syf4YlSBLmreGXYsyaDg/TDqt3YvCvZNWGdqdP1OF7d39B6hsz/6ZowzjsvbMxemve7KfDqHR+pVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596016; c=relaxed/simple;
	bh=xFoYoTFmea6JwFgNn0/x7qB+AzppySK65jVPEEVi/4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FbtOp/MsLS8EhuC1ZhhHP2TlXwSWjhPKVjedrZLMbpnl2Pm7fpGnn7yFrOA0BkqcVKvfB5rMOE/GnZamMrW3TGOrOM4CK3oweBr9c68d9R8UpPxCGu1dg47rcMDeSkbhdSNtlBHKFpjixYaQCTvKWKmMg/+fIN36434ckvcFukM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gjxE1ep/; arc=none smtp.client-ip=95.215.58.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gjxE1ep/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xFoYoTFmea6JwFgNn0/x7qB+AzppySK65jVPEEVi/4Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596011; v=1; x=1791200811;
 b=gjxE1ep/x/NJCUyfdEEKuEFLbKn+0EDEDuEmX+lPVI8NET2fk5EQKMM/Y0wpt5A4uP052Bmg
 iHGNDXaYioc96iVVC+Mm3T738pkGW3fnL7Xf95Q3T8YvI8s1XsY/gIZSK9fjlyIbarH03iNbbcQ
 f2qHo9yiBrE28pUvdOa4k8P4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a1c51cc4e3403e67;
	Mon, 28 Sep 2026 11:46:50 +0000
X-Mizu-Trace-ID: a1c51cc4e3403e67
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
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 0/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 28 Sep 2026 19:46:17 +0800
Message-Id: <20260928114625.3609130-1-ridong.chen@linux.dev>
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

  1) drop the now-unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into a dedicated mm/vmscan.h, which
     trace_vmscan.h pulls in, guarded against the multi-read that
     define_trace.h performs;
  4-7) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign, one group at a time: the reclaim-begin
     events, the LRU isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Besides the cleanup, this moves the code that computes the tracepoint
parameters into TP_fast_assign(), which is in a separate text section. It
removes code from the work flow, improving instruction cache.

There is no functional change and no ABI change: TP_STRUCT__entry and
TP_printk are untouched, so the exported event format is identical. This
was confirmed by diffing the tracefs format files before and after, and
by capturing the direct/memcg/node reclaim-begin events under load in a
QEMU guest (order, gfp_flags and memcg_id all match).

Where a value passed to a tracepoint is a local of the caller rather than
a scan_control field (highest_zoneidx for balance_pgdat_end, nr_reclaimed
for reclaim_pages), it stays a separate argument.

[1]: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

---
Changes since v1:
  - Convert the remaining vmscan tracepoints too, not just reclaim-begin
    (4 -> 7 patches).
  - Put struct scan_control in its own mm/vmscan.h instead of directly in
    trace_vmscan.h suggested by Baoquan.

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

-- 
2.34.1

