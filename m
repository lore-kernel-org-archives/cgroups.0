Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F7A46C4A0;
	Mon,  7 Sep 2026 11:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778883; cv=none; b=lS2UX1ziiFJLfI2C4IinWSIn0msZrZ3EjfCPG9DqS5BxzfLMKPRO7LV8fTpjq9T6L9l8HB3dlZmPXYxrcc+TFOisRW82buPop46q0TrzseQuqjn/bcZzMa0lmQYTJvBEadJGwZcQURgMkdYI8xhu1ovDAa6/aRN2oyHHptANCdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778883; c=relaxed/simple;
	bh=JmB6QM6CMrbt+mYCdTNjZXLTnGlGEZ4aEm21cS2vffY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMd+o0nT60EuFFImYkBK8BwDq6XSYXOdQaKosI2IKbJp77DSUCWZtlKglsb+PmdG4+fNDj3HswL9+45+jh47oPBQswkllC9eU0/H6WcCa1AzPpJFqBIbqDrz14V4IFVhSXOIe4dcsQUJ7piidHzAPGHlxvjWNMuveUZAUQp47Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qvXe6E+/; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qvXe6E+/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778878; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eIX+mgn/05GG1BdcM7+jXBv8ObcWey0aeeYAiAqGu6I=;
	b=qvXe6E+/V6Js0sjV4y53xggnryH5udaH77/eg76gnYO/1gLcBKzSExp/4ABDHtbO6t2ozPImSE1vKGVF0j3AoTtjvBe/3+xOo/ykbfFABrLeOPla1KmHXsSmb2KOuZVqXL5e8g66JwmIEAgob91ubhrQBM1404TVMxFCBrf9fFo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsvzn_1788778875;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsvzn_1788778875 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:16 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg ID for list_lru indexing
Date: Mon,  7 Sep 2026 19:01:08 +0800
Message-ID: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
and is only used as the list_lru xarray index.  With
cgroup.memory=nokmem the assignment never happens, so every memcg
resolves to the per-node lists.  The next patch needs the index to
work under nokmem as well, so drop the copy and use the memcg ID.

The ID works just as well as the copy did: root and NULL still
return -1 and use the per-node lists, and the ID is only released
after the list_lru reparenting, so a stale or recycled ID can never
reach a live list_lru entry.

The early return of memcg_offline_kmem() under nokmem is dropped as
well, so the reparenting also covers lrus that stay memcg aware
without kmem accounting.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 include/linux/memcontrol.h |  8 +++++---
 mm/list_lru.c              | 10 +++++-----
 mm/memcontrol.c            |  6 ------
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fdf4812e1d818..edeb287978934 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -254,7 +254,6 @@ struct mem_cgroup {
 #if BITS_PER_LONG < 64
 	seqlock_t		socket_pressure_seqlock;
 #endif
-	int kmemcg_id;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
@@ -1775,12 +1774,15 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 }
 
 /*
- * A helper for accessing memcg's kmem_id, used for getting
+ * A helper for accessing the memcg ID, used for getting
  * corresponding LRU lists.
  */
 static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 {
-	return memcg ? memcg->kmemcg_id : -1;
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return -1;
+
+	return memcg->id.id;
 }
 
 struct mem_cgroup *mem_cgroup_from_virt(void *p);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index a4522ca93ebcb..6fd4e9af84396 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -502,7 +502,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
+	int dst_idx = memcg_kmem_id(dst_memcg);
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
@@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		 * allocating a new mlru since CSS_DYING is already set for this
 		 * memcg a rcu grace period ago.
 		 */
-		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
+		mlru = xa_load(&lru->xa, memcg_kmem_id(memcg));
 		if (!mlru)
 			continue;
 
@@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
-		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+		xa_erase_irq(&lru->xa, memcg_kmem_id(memcg));
 
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
@@ -566,7 +566,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
-	int idx = memcg->kmemcg_id;
+	int idx = memcg_kmem_id(memcg);
 
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
@@ -602,7 +602,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			if (!mlru)
 				return -ENOMEM;
 		}
-		xas_set(&xas, pos->kmemcg_id);
+		xas_set(&xas, memcg_kmem_id(pos));
 		do {
 			xas_lock_irqsave(&xas, flags);
 			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf1264..619d4c1f2e8f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3780,17 +3780,12 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
 		return;
 
 	static_branch_enable(&memcg_kmem_online_key);
-
-	memcg->kmemcg_id = memcg->id.id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent;
 
-	if (mem_cgroup_kmem_disabled())
-		return;
-
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		return;
 
@@ -4225,7 +4220,6 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	seqlock_init(&memcg->socket_pressure_seqlock);
 #endif
 	memcg1_memcg_init(memcg);
-	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-- 
2.43.7

