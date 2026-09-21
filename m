Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE448491595
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789991197; cv=none; b=vAQ5rN/zSqoD9lIW4DJFoSpCsVJ5SseAqeGrjrWb8w88NcwJCWGDi+8kx1SvCzBeAcwaZ7B+nxooEcPj/GTqTRJiFM1rVMUOXMYfDx5RqE1jTH8BKbDirmz0LjTj8cJQ8k0imkvJ9PGWCQafQWMFDI+2FaUVHcOT+MBZJ9xh3IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789991197; c=relaxed/simple;
	bh=XH4B96df4h2G4S3OsyZK9oJZKdg1W5OhLImhYcFRtEE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S52uDmYYNWqUsuUxd+a1bTilUrzLodgl8g49YLkQNLMpKVsNrHi+1z8Hvq+5n0Tt5iMKc9zyfTA6bkvCsTdo8iAbQAx6VSCy4OTVClCxbGjl93mRZGprTmij6nyg6YP2M038PVq1kXKFtmu/GCj4xB8O3M9BD/fzt75/RFwZ02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=emXUwPs5; arc=none smtp.client-ip=91.218.175.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="emXUwPs5"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XH4B96df4h2G4S3OsyZK9oJZKdg1W5OhLImhYcFRtEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991192; v=1; x=1790595992;
 b=emXUwPs5q6S7QVPRLZLXHHVgK7UXwx1kTussRakTgwX0sTeuudPod4V/BBSNaKcY9JLhmQ1E
 l+88AvdhcRs70H60X+jlK+X02WfCbBCCoFJhYGq6xjoI5OQYsXwXATo5il59RtxBDzhqDNhn0Hm
 dP04JhF4Vm6IxG7RVsVS9tKY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9200fe5b77e7be9f;
	Mon, 21 Sep 2026 11:46:32 +0000
X-Mizu-Trace-ID: 9200fe5b77e7be9f
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
Subject: [PATCH RFC 0/4] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 21 Sep 2026 19:46:02 +0800
Message-Id: <20260921114606.3871820-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Background:

This series started as an effort to add two tracepoints for MGLRU. In the
discussion, Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too, letting
the trace events access its fields directly instead of having each callsite
copy the scalars out by hand.

The series builds in four small steps:

  1) drop the now-unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, using a
     relative TRACE_INCLUDE_PATH so no Makefile change is needed;
  3) move struct scan_control into that header, guarded against the
     multi-read that define_trace.h performs;
  4) pass scan_control to the reclaim-begin tracepoints and pick the
     fields out in TP_fast_assign.

There is no functional change and no ABI change: TP_STRUCT__entry and
TP_printk are untouched, so the exported event format is identical. This
was confirmed by diffing the tracefs format files before and after, and
by capturing the direct/memcg/node reclaim-begin events under load in a
QEMU guest (order, gfp_flags and memcg_id all match).

This RFC only converts the three reclaim-begin tracepoints
(direct/memcg/node) to take a scan_control pointer as a first,
self-contained step. Other vmscan tracepoints that currently spell out
individual sc->... fields can be converted the same way once the approach
is agreed upon; 

[1] https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/

Ridong Chen (4):
  mm/memcontrol: drop unused vmscan tracepoint include
  mm/vmscan: move vmscan tracepoints to a local header
  mm/vmscan: move struct scan_control to the local trace header
  mm/vmscan: pass scan_control to the reclaim-begin tracepoints

 MAINTAINERS                                   |   2 +
 mm/memcontrol.c                               |   2 -
 mm/shrinker.c                                 |   2 +-
 .../events/vmscan.h => mm/trace_vmscan.h      | 143 ++++++++++++++++--
 mm/vmscan.c                                   | 117 +-------------
 5 files changed, 138 insertions(+), 128 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (81%)

-- 
2.34.1

