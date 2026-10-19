Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9423D9DAD
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 03:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792382020; cv=none; b=KST4aWZ/xbUkG6zTqfZgOWhnbhjTUfEXHqMxxCDCKEVBIYN5i1sUi831JvW6K7l2QlOr+OLGzCnAiBptHH852EMMQA9IXrpowjoX03D/sujo/jF6W8LEiShmCEOIwcPG/VSaJF2oUxjj4YGQuS3UdBAZWIlKu5UJIJpqfJDjqqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792382020; c=relaxed/simple;
	bh=AtApVs4y/DcK1VhFwo4n+80r7AMWjpD6/0wGQReG9UU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nDMaCzo0m/OGMpNYbaAcFeWYSughibKH6Vis4doNKTY2T+Na0BBz/fW5b6UQfWiBxWNUIwhW2D6bNGqB6FxiM746+iu7w3AqYTIZxP1D6lP7Y2Q+UbWKOCtx1Lh1SnRDuGVG9DE52KSkGqmS6UxrCTJByh3W7mUY0aMhFjrDGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JkJGySxW; arc=none smtp.client-ip=95.215.58.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JkJGySxW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AtApVs4y/DcK1VhFwo4n+80r7AMWjpD6/0wGQReG9UU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792382015; v=1; x=1792986815;
 b=JkJGySxW1033tLQJ05zc0hVyiAF5hjwu8XR4jiTDr44uNfn0r3cbM6bA0pip529JAz6svpHf
 ZgbTzt0rjl4JFzZhNuqTwSRiBBSx1HR1pfzH5ImpYv+/ItjusZBstsCFWgZpBxhyOqjOh4Dqr4q
 CX4fGYWeuW1CcMMyzLVD7J1M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 356f95a479b725c2;
	Mon, 19 Oct 2026 03:53:35 +0000
X-Mizu-Trace-ID: 356f95a479b725c2
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
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 4/9] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Mon, 19 Oct 2026 11:52:47 +0800
Message-Id: <20261019035252.2357900-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

The reclaim-begin tracepoints describe the entry conditions of a reclaim
invocation, which struct scan_control already carries. Now that the struct
is visible from the trace header, pass sc directly and pick the fields out
in TP_fast_assign instead of spelling out gfp_mask and order at every
callsite.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 24 ++++++++++++------------
 mm/vmscan.c       |  7 +++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 3917e1b62dfa..db4590356845 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -178,9 +178,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg),
+	TP_ARGS(sc, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
@@ -189,8 +189,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	),
 
 	TP_fast_assign(
-		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
-		__entry->order		= order;
+		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
+		__entry->order		= sc->order;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
@@ -204,17 +204,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -551,9 +551,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
-	TP_PROTO(int nid, int order, gfp_t gfp_flags),
+	TP_PROTO(int nid, struct scan_control *sc),
 
-	TP_ARGS(nid, order, gfp_flags),
+	TP_ARGS(nid, sc),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -563,8 +563,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
-		__entry->gfp_flags = (__force unsigned long)gfp_flags;
+		__entry->order = sc->order;
+		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8b8f4049e278..e064354ea24f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6884,7 +6884,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6925,7 +6925,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7881,8 +7881,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	if (!sc->proactive)
-- 
2.34.1

