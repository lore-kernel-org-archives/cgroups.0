From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: localize memcg_kmem_enabled() check
Date: Wed,  2 Jan 2019 16:31:29 -0800
Message-ID: <20190103003129.186555-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HDV6bRTeM31dJ5NVRvjDVymoFmv0ZgrAy5+J+74imwM=;
        b=HuGgvOMlODWlVV0hrvHa+zm6Vizkv1wtWe4Ggo8yFywSfFUaJe/zU5eWo0Nb0dtMln
         AIp1FuGObkjtff9BqiEwR1w9lW4vRNOA6Ld4H2iRKQ5M+BfnYJ4c6YM4ZAqgOSSybdDm
         rcmJpDz3MGrLCa6yL1+kWJDGDqsoa8+P+YZ9PGnS1U8JxV4hfjNIJSKK4fnUXcfFJJDt
         Sx5uvFDZSLvqfJgrigsNmh13wWy3ZhNDeTJnyMg7PXPQR1b6A8Ccv5syH9SIf9MEcQqO
         t9U93PBWacBIU2FhwWDgstJRZp/E4qURmnkZG1ee6nUwuEOdz6RgnLYe43jbYAvMFgGw
         scsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

Move the memcg_kmem_enabled() checks into memcg kmem charge/uncharge
functions, so, the users don't have to explicitly check that condition.
This is purely code cleanup patch without any functional change. Only
the order of checks in memcg_charge_slab() can potentially be changed
but the functionally it will be same. This should not matter as
memcg_charge_slab() is not in the hot path.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 fs/pipe.c                  |  3 +--
 include/linux/memcontrol.h | 28 ++++++++++++++++++++++++----
 mm/memcontrol.c            | 16 ++++++++--------
 mm/page_alloc.c            |  4 ++--
 mm/slab.h                  |  4 ----
 5 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index bdc5d3c0977d..51d5fd8840ab 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -140,8 +140,7 @@ static int anon_pipe_buf_steal(struct pipe_inode_info *pipe,
 	struct page *page = buf->page;
 
 	if (page_count(page) == 1) {
-		if (memcg_kmem_enabled())
-			memcg_kmem_uncharge(page, 0);
+		memcg_kmem_uncharge(page, 0);
 		__SetPageLocked(page);
 		return 0;
 	}
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 83ae11cbd12c..e264d5c28781 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1273,12 +1273,12 @@ static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 
 struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
-int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			    struct mem_cgroup *memcg);
 
 #ifdef CONFIG_MEMCG_KMEM
-int memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
-void memcg_kmem_uncharge(struct page *page, int order);
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+void __memcg_kmem_uncharge(struct page *page, int order);
+int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			      struct mem_cgroup *memcg);
 
 extern struct static_key_false memcg_kmem_enabled_key;
 extern struct workqueue_struct *memcg_kmem_cache_wq;
@@ -1300,6 +1300,26 @@ static inline bool memcg_kmem_enabled(void)
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
+static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+{
+	if (memcg_kmem_enabled())
+		return __memcg_kmem_charge(page, gfp, order);
+	return 0;
+}
+
+static inline void memcg_kmem_uncharge(struct page *page, int order)
+{
+	if (memcg_kmem_enabled())
+		__memcg_kmem_uncharge(page, order);
+}
+
+static inline int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp,
+					  int order, struct mem_cgroup *memcg)
+{
+	if (memcg_kmem_enabled())
+		return __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+	return 0;
+}
 /*
  * helper for accessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4afd5971f2d4..e8ca09920d71 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2557,7 +2557,7 @@ void memcg_kmem_put_cache(struct kmem_cache *cachep)
 }
 
 /**
- * memcg_kmem_charge_memcg: charge a kmem page
+ * __memcg_kmem_charge_memcg: charge a kmem page
  * @page: page to charge
  * @gfp: reclaim mode
  * @order: allocation order
@@ -2565,7 +2565,7 @@ void memcg_kmem_put_cache(struct kmem_cache *cachep)
  *
  * Returns 0 on success, an error code on failure.
  */
-int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
 			    struct mem_cgroup *memcg)
 {
 	unsigned int nr_pages = 1 << order;
@@ -2588,24 +2588,24 @@ int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
 }
 
 /**
- * memcg_kmem_charge: charge a kmem page to the current memory cgroup
+ * __memcg_kmem_charge: charge a kmem page to the current memory cgroup
  * @page: page to charge
  * @gfp: reclaim mode
  * @order: allocation order
  *
  * Returns 0 on success, an error code on failure.
  */
-int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
 	struct mem_cgroup *memcg;
 	int ret = 0;
 
-	if (mem_cgroup_disabled() || memcg_kmem_bypass())
+	if (memcg_kmem_bypass())
 		return 0;
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
 		if (!ret)
 			__SetPageKmemcg(page);
 	}
@@ -2613,11 +2613,11 @@ int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 	return ret;
 }
 /**
- * memcg_kmem_uncharge: uncharge a kmem page
+ * __memcg_kmem_uncharge: uncharge a kmem page
  * @page: page to uncharge
  * @order: allocation order
  */
-void memcg_kmem_uncharge(struct page *page, int order)
+void __memcg_kmem_uncharge(struct page *page, int order)
 {
 	struct mem_cgroup *memcg = page->mem_cgroup;
 	unsigned int nr_pages = 1 << order;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0634fbdef078..d65c337d2257 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1053,7 +1053,7 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
 	if (memcg_kmem_enabled() && PageKmemcg(page))
-		memcg_kmem_uncharge(page, order);
+		__memcg_kmem_uncharge(page, order);
 	if (check_free)
 		bad += free_pages_check(page);
 	if (bad)
@@ -4667,7 +4667,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 
 out:
 	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
-	    unlikely(memcg_kmem_charge(page, gfp_mask, order) != 0)) {
+	    unlikely(__memcg_kmem_charge(page, gfp_mask, order) != 0)) {
 		__free_pages(page, order);
 		page = NULL;
 	}
diff --git a/mm/slab.h b/mm/slab.h
index 4190c24ef0e9..cde51d7f631f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -276,8 +276,6 @@ static __always_inline int memcg_charge_slab(struct page *page,
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
-	if (!memcg_kmem_enabled())
-		return 0;
 	if (is_root_cache(s))
 		return 0;
 	return memcg_kmem_charge_memcg(page, gfp, order, s->memcg_params.memcg);
@@ -286,8 +284,6 @@ static __always_inline int memcg_charge_slab(struct page *page,
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 						struct kmem_cache *s)
 {
-	if (!memcg_kmem_enabled())
-		return;
 	memcg_kmem_uncharge(page, order);
 }
 
-- 
2.20.1.415.g653613c723-goog

