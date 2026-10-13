Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7D518153
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897297; cv=none; b=K4RfWOHgeLG+e8WIqyGuhFoZjPZXStioX0Sv6Ij17gqJ+e8bB46p731kY0sazUDTF7Bnu8/criIRE8+tYMUbluqfpzWk5lXOjW7y+26J71qlMJ1+wNPc+VR4u5uYj1mgT/+6qNkKwjbACwaevIdr+pO1CSgJIddRhcHctuSMVeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897297; c=relaxed/simple;
	bh=vBSg1QkKVy4BttTL6yPnGCNW6hVkILXIMHPxGW5nELA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dzWGzlI/eMn5GZmvILbldi2vCKluCIzoT3IyTPzdAwEUcHaJ+kxQ172mp6EICeVYyQc0d0+UY7BZLdd+WQr5VtXOcPT4Lu9SAoCOXZwoTUyqjZW3qyB6dIE/G9moSptmmSia/eUIrly/X2cggJXYcxDZ0dM3v6Mw9W54dSTOTc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WsU6N/hc; arc=none smtp.client-ip=91.218.175.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WsU6N/hc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vBSg1QkKVy4BttTL6yPnGCNW6hVkILXIMHPxGW5nELA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897294; v=1; x=1792502094;
 b=WsU6N/hc2sC7uwnFSTAPvEc2meOej7IlBokFEtkZr0E2eZ9tAXGEGKLM7D+PiTfg5qRWzAHV
 FFyeQmYXM/uH7Dau5BMnp4q1jrcfcho5U+eg5Iwk1HS0rsdIsup8sa9lTkDGySG7l9AdnAiNb/O
 oTUKe8GoFXySefMAgnJ/q9Vc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 208741b0836346c2;
	Tue, 13 Oct 2026 13:14:54 +0000
X-Mizu-Trace-ID: 208741b0836346c2
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
Subject: [PATCH RFC v3 7/7] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
Date: Tue, 13 Oct 2026 21:13:09 +0800
Message-Id: <20261013131309.2790253-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

balance_pgdat() passes sc.order and sc.nr_reclaimed to
mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
struct scan_control instead and read the fields out in TP_fast_assign,
consistent with the other reclaim tracepoints. highest_zoneidx stays a
separate argument: it is a balance_pgdat() parameter, and
sc.reclaim_idx may differ from it by the time the end event fires.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 9 ++++-----
 mm/vmscan.c       | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 96e41f444924..10b3cda1c435 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
 
 TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
-	TP_PROTO(int nid, int order, int highest_zoneidx,
-		 unsigned long nr_reclaimed),
+	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
 
-	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+	TP_ARGS(nid, sc, highest_zoneidx),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
+		__entry->order = sc->order;
 		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_reclaimed = sc->nr_reclaimed;
 	),
 
 	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3278dbe47bf..561e14dd490c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7403,8 +7403,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
-- 
2.34.1

