Received: from mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9CE4657C6
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 08:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113721; cv=none; b=KAH0ThEMHptfVbADIEOALlMMDmQVWIVVlKrberopxu7pt9UXupTHECkVHsZzPXNFoyky72nd2EQ+Rv9jReJ+pCm6v8R34gIhL67bEWwwfDkI91PsS8y6O6WVd8KlIz8r6a+UdyLjAVQe4qT57BX4QOToE6d9QF0UOQdRMvGvYfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113721; c=relaxed/simple;
	bh=MlIZcCXSxTICdrlqvuuIMch3l/hSvENFUEtEORDa6Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcTwoGaYy1dMG9ye0HYWLvSAB2OqKgDAsDFJWZxgKCIMvXGc6Hq/ZPnCiXirHKGkcfJMJbP1eQBJn65T4AKouKy3PHOO4jsCanFaL/+TIzu4AglBiVdRHupE5p3m/REIOoz1ZpUWxwY8SSUNB2l5/rYAQ7wlcGfz59R0hoqt2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r+oGFJjp; arc=none smtp.client-ip=91.218.175.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r+oGFJjp"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MlIZcCXSxTICdrlqvuuIMch3l/hSvENFUEtEORDa6Hc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113718; v=1; x=1789718518;
 b=r+oGFJjpjPNVoTAMB21ph5+IOjt5CEFIzmZVsSjBVVoaEcDyEXELWyEFEXn+bB1X7FOC+v9Z
 1ctT4+tf7gBXDaiGuroot1tLxpdzApgdqgQXXbyMumsT8sY6NVGZtGuKLvYxv2VNtUOeeoo8u0t
 hYMxOEaPdYT+Xofg5mejiX5g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 0c3212cca3ab0784;
	Fri, 11 Sep 2026 08:01:57 +0000
X-Mizu-Trace-ID: 0c3212cca3ab0784
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v5 4/4] mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
Date: Fri, 11 Sep 2026 16:00:51 +0800
Message-ID: <4a7a64eed2b145ad535fedaea3624f8310c29d5b.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hui Zhu <zhuhui@kylinos.cn>

On cgroup v2, reparent_state_local() returns early and never moves the
dying memcg's non-hierarchical state_local base counts to its parent.
Meanwhile memcg_reparent_objcgs() rewrites objcg->memcg to the parent,
so when the reparented folios are freed later, the negative deltas land
on the parent's lruvec.  The parent therefore receives the uncharges
without ever having received the matching charges, and its state_local
(NR_LRU_BASE + lru, MEMCG_SOCK, NR_SLAB_RECLAIMABLE_B,
NR_SLAB_UNRECLAIMABLE_B) permanently underflows.  Since
lruvec_page_state_local() clamps negative values to zero, the underflow
masks the parent's own legitimate pages.

count_shadow_nodes() is the only reader of these non-hierarchical
state_locals on cgroup v2, so the underflow directly distorts the
workingset shadow node budget.

Fix this by reparenting the lruvec state_locals on cgroup v2 as well,
mirroring what cgroup v1 already does.  Only the lruvec stats consumed
by count_shadow_nodes() are moved; the memcg-level stats are left alone
because on v2 they are exposed through the rstat hierarchical tree and
are not read from state_local.

Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol-v1.h |  5 +++--
 mm/memcontrol.c    | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 1e394269c613d..0578b7076764d 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m, void *v);
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -73,8 +76,6 @@ void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgr
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9995f3d2aae1b..f13030f75fa54 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -232,14 +232,29 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
 
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -248,17 +263,18 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -570,7 +586,6 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -592,7 +607,6 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
-- 
2.43.0

