Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD94B1498
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596060; cv=none; b=PlFUlXLx6j67Vw7WbCiinBXDOarajNVVON3aTs/HqnYXrE+IosBlrWFWOt8XaAHKpV4Au3EPKcP2clnWKBvYHsps+oq57AaZTZE9zAXhJlcU2ihhWVwaXx4nR72B9dYxNrHinrtBJJBcVyfuTMFPy1QkSl/PAsaKck+NJwAgksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596060; c=relaxed/simple;
	bh=2ujtuvz8o2Cp7N7qQ7PelJhq0ebMgD0lcl5ObFFnDtY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n0tlak/poSyqpTKLBsm2tz8KvnSRUOW5uTKeJl6OMqx8LRh7ldBY64wHiZxxKTKHpV751yt7BzgMbRKT7eBSCgYvWQ+PZ8G3ybmr3rVInd9dUM3wLadpph7ZQQn0ZYtPQc2GNGfAfl4rwJ0HDF1temWG6NiJkX4yG98zTlObFws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AO6/Qt+s; arc=none smtp.client-ip=95.215.58.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AO6/Qt+s"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2ujtuvz8o2Cp7N7qQ7PelJhq0ebMgD0lcl5ObFFnDtY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596057; v=1; x=1791200857;
 b=AO6/Qt+s9nVMe6C2QfIsJKwvqWVBLh8QcY73jBUoKwXWWI9CmCyXIyIh0S8YDSokCbTvvmUN
 q7Fyd+LEQSVk6zBSzPsbCqT1SZcIEPTetpKg9p49vSnqZO9Gny6wYcBM3VboQWIuJ8r1j2GbK+L
 CARTcU49Tl+TAW8yQeLDWYSA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 72fbe1077ee4d1cd;
	Mon, 28 Sep 2026 11:47:36 +0000
X-Mizu-Trace-ID: 72fbe1077ee4d1cd
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
Subject: [PATCH RFC v2 4/7] mm/vmscan: pass scan_control to the reclaim-begin tracepoints
Date: Mon, 28 Sep 2026 19:46:21 +0800
Message-Id: <20260928114625.3609130-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
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
callsite. The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 24 ++++++++++++------------
 mm/vmscan.c       |  7 +++----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 91fb1c30dd46..28561fda83b3 100644
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
index 2fd9b42f89d8..2fed83738b4b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6885,7 +6885,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6926,7 +6926,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7882,8 +7882,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	psi_memstall_enter(&pflags);
-- 
2.34.1

