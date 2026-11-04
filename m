Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797771;
	b=z/0G5HmrCq02MPee+aNtV80wQg1uy9fgiynfoskiZH+wewRfloCCy5gYmTbM1h1JZy+0
	 N3Cthr5QZYr0fDH0+muhKU005awTAMWyzLGot+NcsLyW+/xe8tup+nFY+f3TR0TzCP2sG
	 6tP+rujee1SXimZWdYT/cmbYb1BQuO/pHadHckngeQC95xLaVOEvorRjAcDuWtim4xzWp
	 8+cEHQezY/DiVg1UtIS4pcvYzSONESR5Nzoan2EPMSkmqT+KlwlXLXXywc3M0eTZ1jrba
	 Gvj/kNh8BZS9L30EPvgXysJMJOqSjGundm3nU26ini4LHAmp/srd196UNGvQAePkpmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797771;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=noDUbIgLa825dHKldqzrhnDFk6K8dNFNAvunc7DmhzY=;
	b=Vid1kRTiz3f2FFCJgr3xtR/RhPuxWREUS04hwo9bjFrFfq4sHvNDWBR5yegyqoayFPk9
	 9Mfj1SeeAeVcIsNweX6JzCRtOcMnoyPsC/EkYmGllqo7z9Bn01BF8TjBaG5qC+oJ0XWHT
	 7pHHO0sp4kHPcE1KpunEAknTzIvGgyj2aP4JsNpac4rhWgAfcGyzh097I0hhP4PJvJU9B
	 neXOaTirIPwbv2nMdzslyF4KrU7n/IHGuWw3ujfrVmpnbM4KuFPVrkcSmeNsNPSmrHrQJ
	 fUdP2VG01GoPIqwTrPM7BX+Ayr0w1l9YJckJy68T4l8ILUJzB4mQzTc8ukRLBsTQZWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QnWHc+qF;
	arc=none smtp.remote-ip=95.215.58.47
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C084606A32D
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C084606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QnWHc+qF
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aeCw2+1bP3hgm+WMWp4t8z1qVMGSwcZVYaNM1wqU5ug=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797769; v=1; x=1794402569;
 b=QnWHc+qFkzFqXeGicujhQk2UG/nY9uRrjz9ceZZ4mFvfKzpGt7SARYy1/KhpidUbFer+Daf+
 Gckp6uEt7AE/fgsEAT7V7HjRThmIccMIEIqehZ9+dIRjkycFy85riQyLbUBqbIA9ElsI7A35vy2
 nQ2Xxgz62uo7zLtUuw3o0SdM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7d7cf5f30fc11238;
	Wed, 04 Nov 2026 13:09:29 +0000
X-Mizu-Trace-ID: 7d7cf5f30fc11238
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
Subject: [PATCH v7 4/7] mm/vmscan: pass scan_control to the vmscan tracepoints
Date: Wed,  4 Nov 2026 21:08:14 +0800
Message-Id: <20261104130817.849089-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
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

Several vmscan tracepoints spell out reclaim state as individual
arguments, all of which the caller already holds in struct scan_control.
Now that the struct is visible from the trace header, pass sc directly
and pick the fields out in TP_fast_assign instead of spelling them out
at every callsite:

- mm_vmscan_direct_reclaim_begin, mm_vmscan_memcg_reclaim_begin and
  mm_vmscan_node_reclaim_begin: gfp_mask and order.

- mm_vmscan_lru_isolate, mm_vmscan_lru_shrink_inactive and
  mm_vmscan_lru_shrink_active: reclaim_idx, order and priority.

- mm_vmscan_reclaim_pages: nr_scanned. nr_reclaimed stays a separate
  argument: it is the return value of shrink_folio_list(), which does
  not update sc->nr_reclaimed.

- mm_vmscan_balance_pgdat_end: order and nr_reclaimed. highest_zoneidx
  stays a separate argument: it is a balance_pgdat() parameter, and
  sc.reclaim_idx may differ from it by the time the end event fires.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 74 +++++++++++++++++++++++------------------------
 mm/vmscan.c       | 26 ++++++++---------
 2 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 3917e1b62dfa..b2ad83e5f25e 100644
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
@@ -178,9 +177,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg),
+	TP_ARGS(sc, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
@@ -189,8 +188,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 	),
 
 	TP_fast_assign(
-		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
-		__entry->order		= order;
+		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
+		__entry->order		= sc->order;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
@@ -204,17 +203,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
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
 
@@ -350,15 +349,14 @@ TRACE_EVENT(mm_shrink_slab_end,
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-	TP_PROTO(int highest_zoneidx,
-		int order,
-		unsigned long nr_requested,
-		unsigned long nr_scanned,
-		unsigned long nr_skipped,
-		unsigned long nr_taken,
-		int lru),
+	TP_PROTO(struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int lru),
 
-	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
+	TP_ARGS(sc, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
 
 	TP_STRUCT__entry(
 		__field(int, highest_zoneidx)
@@ -371,8 +369,8 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 	),
 
 	TP_fast_assign(
-		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->order = order;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
 		__entry->nr_requested = nr_requested;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
@@ -419,11 +417,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		 struct reclaim_stat *stat),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+	TP_ARGS(nid, sc, nr_reclaimed, stat),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -441,7 +439,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->nr_scanned = nr_scanned;
+		__entry->nr_scanned = sc->nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->nr_dirty = stat->nr_dirty;
 		__entry->nr_writeback = stat->nr_writeback;
@@ -466,9 +464,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat, int priority, int file),
+		struct reclaim_stat *stat, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -498,7 +496,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 		__entry->nr_activate1 = stat->nr_activate[1];
 		__entry->nr_ref_keep = stat->nr_ref_keep;
 		__entry->nr_unmap_fail = stat->nr_unmap_fail;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
@@ -517,9 +515,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
-		unsigned long nr_referenced, int priority, int file),
+		unsigned long nr_referenced, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -537,7 +535,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->nr_active = nr_active;
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
@@ -551,9 +549,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
-	TP_PROTO(int nid, int order, gfp_t gfp_flags),
+	TP_PROTO(int nid, struct scan_control *sc),
 
-	TP_ARGS(nid, order, gfp_flags),
+	TP_ARGS(nid, sc),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -563,8 +561,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
-		__entry->gfp_flags = (__force unsigned long)gfp_flags;
+		__entry->order = sc->order;
+		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d9c3c5d020ed..9fc2399d63bc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1764,7 +1764,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		}
 	}
 	*nr_scanned = total_scan;
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
@@ -2054,7 +2054,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc, file);
 	return nr_reclaimed;
 }
 
@@ -2161,7 +2161,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc, file);
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -2184,7 +2184,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
@@ -4798,9 +4798,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				scanned, skipped, isolated,
-				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
+				    scanned, skipped, isolated,
+				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4942,7 +4942,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			type_scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
@@ -6834,7 +6834,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6875,7 +6875,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7352,8 +7352,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
@@ -7831,8 +7830,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	if (!sc->proactive)
-- 
2.34.1

