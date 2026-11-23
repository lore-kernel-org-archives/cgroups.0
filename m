Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431224;
	b=nu4P6ZwM+oBXhELU5qFXbrES94Xhze43kqMDMDlkI1CLKtPu0xu4O5cey0om6QOIdjCu
	 9iT+71tLaZBtH1jXJ4t2T/CmR2A9yH1rjbYpumvOKIYvzQyrI79eySUjMird+6ZoilO3a
	 ZNzNn1mCFwHvoTlmXZfTQNyd8c4K6m8G2pJRCSG5BEiCStqs7Hfi2emSoxXZjv8o4wcVh
	 YO9cc3pcoQAZeZ6OuoETxJiZXvzFlz/eeXepmH6oQPujfLZJ4XSxu+ETst2j30iDRTObV
	 KAYaRvtaFEwS+nVh5YR/dgTp3/BfD4zhHYq26QiNDPvTY19KiEu1Z3i3++W0OhNFFNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431224;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3VJosOTv7rTl0MIXfVCQbhZsKJYv+HSjoRx7LySLiRY=;
	b=n5ayqawICENRCDF2GkvwPfjWCwm95HZLgAZnKFqQ0NyQWPnLQnaQZr/wwgRvegkSyn6a
	 gXGUyzWuxNGkFWpWm3iNMlCqz5Rd98eem0Z+Y/DUoztHcuolFCMMTk9iKL1QD7BAG2UNH
	 hN4JEZKI8CtKEzHdxx4gewuqCqsOV3kmpYp9x2R+ORjXvth1YfB7Gjjg5eg2N3X0cPAu6
	 KURsNDCR/upqJsS0joVYc/a9mIhZQMFelWIY1JLJILfIUeAEgI4TDdBRxBGF8u0sIInm2
	 7mtzjnbyrICVDKd/bxirg5MWw+3t2kj+JZc7E7Fl6UJRqVMK+p88GWTubO2SI6hqgUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=B8ixoLbd;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23228606A33C;
	Mon, 23 Nov 2026 10:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23228606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=B8ixoLbd
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431220; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=3VJosOTv7rTl0MIXfVCQbhZsKJYv+HSjoRx7LySLiRY=;
	b=B8ixoLbdmBCuNfQfTBsl97W+uz1nDfGPDBOxacVHUByQd1fXadmV8hSGNYtP5oOY3TEyLu29OZ5Id2EAQxV8XWweHDqlYXUK7VQakaMtcRatVESwen1uSsdkceKsM1SjAxq8XEEIr2KGskYLdXW9sODHr5yA7/ERINUv3t2dY+E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh-7_1795431217;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh-7_1795431217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:38 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v5 1/4] mm: list_lru: index per-memcg lists by memory CSS ID
Date: Mon, 23 Nov 2026 18:53:31 +0800
Message-ID: <20261123105334.2524066-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
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

list_lru uses kmemcg_id, a copy of the private memcg ID, to index its
per-memcg lists. kmemcg_id is only set when kmem accounting is enabled.
Non-slab shrinkers need an index that also works with cgroup.memory=nokmem.

Use memcg->css.id for non-root lists. The ID stays allocated until the
CSS is freed, so disabling and re-enabling the memory controller on the
same cgroup gives the new CSS a distinct index while the old CSS is
still referenced. Reserve index zero for the root, which uses the
per-node list directly.

In list_lru_walk_node(), hold the RCU read lock across both lookups so
the CSS ID cannot be reused between them. css_from_id() can see a CSS
before its online callback succeeds, so check that the CSS is online
before taking a reference. Drop the RCU read lock for the walk and
keep the reference across restarts to recheck the same owner.

Remove kmemcg_id and reparent the lists before the objcgs on memcg
offline, including when kmem accounting is disabled.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h | 16 --------------
 mm/list_lru.c              | 45 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 45 +++++++-------------------------------
 3 files changed, 38 insertions(+), 68 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..f0001174180c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -335,8 +335,6 @@ struct mem_cgroup {
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
-	int kmemcg_id;
-
 	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
@@ -1796,15 +1794,6 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-/*
- * A helper for accessing memcg's kmem_id, used for getting
- * corresponding LRU lists.
- */
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return memcg ? memcg->kmemcg_id : -1;
-}
-
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
 
 static inline void count_objcg_events(struct obj_cgroup *objcg,
@@ -1872,11 +1861,6 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
-{
-	return -1;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_virt(void *p)
 {
 	return NULL;
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 651983d0bf8b..b4c879d7ba01 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -41,6 +41,15 @@ static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off,
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
 
+static inline unsigned long list_lru_memcg_idx(const struct mem_cgroup *memcg)
+{
+	/* Index 0 selects the per-node root list. */
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return 0;
+
+	return memcg->css.id;
+}
+
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
 	return lru->memcg_aware;
@@ -74,9 +83,9 @@ static int lru_shrinker_id(struct list_lru *lru)
 static inline struct list_lru_one *
 list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
-	int idx = memcg_kmem_id(memcg);
+	unsigned long idx = list_lru_memcg_idx(memcg);
 
-	if (list_lru_memcg_aware(lru) && idx >= 0) {
+	if (list_lru_memcg_aware(lru) && idx) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
 		/* Lists at a reused index belong to another memcg. */
@@ -425,25 +434,30 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 #ifdef CONFIG_MEMCG
 	if (*nr_to_walk > 0 && list_lru_memcg_aware(lru)) {
 		struct list_lru_memcg *mlru;
-		struct mem_cgroup *memcg;
+		struct cgroup_subsys_state *css;
 		unsigned long index;
 
+		/*
+		 * Keep the ID from being reused between the two lookups.
+		 * css_from_id() can see a CSS before ->css_online() succeeds.
+		 */
+		rcu_read_lock();
 		xa_for_each(&lru->xa, index, mlru) {
-			rcu_read_lock();
-			memcg = mem_cgroup_from_private_id(index);
-			if (!memcg || !mem_cgroup_tryget(memcg)) {
-				rcu_read_unlock();
+			css = css_from_id(index, &memory_cgrp_subsys);
+			if (!css || !css_is_online(css) || !css_tryget(css))
 				continue;
-			}
 			rcu_read_unlock();
-			isolated += __list_lru_walk_one(lru, nid, memcg,
+			isolated += __list_lru_walk_one(lru, nid,
+							mem_cgroup_from_css(css),
 							isolate, cb_arg,
 							nr_to_walk, false);
-			mem_cgroup_put(memcg);
+			css_put(css);
 
+			rcu_read_lock();
 			if (*nr_to_walk <= 0)
 				break;
 		}
+		rcu_read_unlock();
 	}
 #endif
 
@@ -526,6 +540,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	unsigned long idx = list_lru_memcg_idx(memcg);
 	struct list_lru *lru;
 	int i;
 
@@ -538,7 +553,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, idx);
 		if (!mlru)
 			continue;
 
@@ -553,7 +568,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, idx);
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -568,11 +583,11 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
+	unsigned long idx = list_lru_memcg_idx(memcg);
 	struct list_lru_memcg *mlru;
 	bool allocated;
-	int idx = memcg->kmemcg_id;
 
-	if (idx < 0)
+	if (!idx)
 		return true;
 
 	rcu_read_lock();
@@ -616,7 +631,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 		}
 		/* Set before the lists are published, and never changed after. */
 		mlru->memcg = pos;
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, list_lru_memcg_idx(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..f6c8ee7f6fed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3839,33 +3839,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	obj_cgroup_get_many(folio_objcg(folio), new_refs);
 }
 
-static void memcg_online_kmem(struct mem_cgroup *memcg)
-{
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	static_branch_enable(&memcg_kmem_online_key);
-
-	memcg->kmemcg_id = memcg->private_id;
-}
-
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
-{
-	struct mem_cgroup *parent;
-
-	if (mem_cgroup_kmem_disabled())
-		return;
-
-	if (unlikely(mem_cgroup_is_root(memcg)))
-		return;
-
-	parent = parent_mem_cgroup(memcg);
-	memcg_reparent_list_lrus(memcg, parent);
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
@@ -4341,7 +4314,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
@@ -4415,7 +4387,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct obj_cgroup *objcg;
 	int nid;
 
-	memcg_online_kmem(memcg);
+	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root(memcg)))
+		static_branch_enable(&memcg_kmem_online_key);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -4423,7 +4396,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * here, when mem_cgroup_iter() can't skip it.
 	 */
 	if (alloc_shrinker_info(memcg))
-		goto offline_kmem;
+		goto reparent_lrus;
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
@@ -4481,8 +4454,8 @@ free_objcg:
 		}
 	}
 	free_shrinker_info(memcg);
-offline_kmem:
-	memcg_offline_kmem(memcg);
+reparent_lrus:
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -4500,11 +4473,11 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	zswap_memcg_offline_cleanup(memcg);
 
-	memcg_offline_kmem(memcg);
+	memcg_reparent_list_lrus(memcg, parent_mem_cgroup(memcg));
 	/*
 	 * The reparenting of objcg must be after the reparenting of
-	 * the list_lru in memcg_offline_kmem(), which ensures that
-	 * they will not mistakenly get the parent list_lru.
+	 * the list_lru above, which ensures that they will not
+	 * mistakenly get the parent list_lru.
 	 */
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
@@ -5942,8 +5915,6 @@ static void __init memcg_struct_check(void)
 				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
-				      kmemcg_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      oom_group);
 
-- 
2.55.0

