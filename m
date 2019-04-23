From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v2 4/6] mm: unify SLAB and SLUB page accounting
Date: Tue, 23 Apr 2019 14:31:31 -0700
Message-ID: <20190423213133.3551969-5-guro@fb.com>
References: <20190423213133.3551969-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=DYe1Kczls7Vz3TOywv3SCxyloB0ylRoW+6/MG/k28Aw=;
 b=bHFYCX9dNv+cHnVzRdmj18VbL4bDaxiJJyLgc94iTPCfRd9wNi3dL/rByW9imQZa6iGr
 kACIO/RjRo+g9bmaNvlqG0vBB/KS4n/qab2mlGo2lBZ6N+pY8AiRkfvXFNklVhQHI0sR
 qBwXvEKBnK4lJsv6nu2Q33NJFu6LmyVS0aY= 
In-Reply-To: <20190423213133.3551969-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Currently the page accounting code is duplicated in SLAB and SLUB
internals. Let's move it into new (un)charge_slab_page helpers
in the slab_common.c file. These helpers will be responsible
for statistics (global and memcg-aware) and memcg charging.
So they are replacing direct memcg_(un)charge_slab() calls.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 mm/slab.c | 19 +++----------------
 mm/slab.h | 22 ++++++++++++++++++++++
 mm/slub.c | 14 ++------------
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 14466a73d057..53e6b2687102 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1389,7 +1389,6 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 								int nodeid)
 {
 	struct page *page;
-	int nr_pages;
 
 	flags |= cachep->allocflags;
 
@@ -1399,17 +1398,11 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 		return NULL;
 	}
 
-	if (memcg_charge_slab(page, flags, cachep->gfporder, cachep)) {
+	if (charge_slab_page(page, flags, cachep->gfporder, cachep)) {
 		__free_pages(page, cachep->gfporder);
 		return NULL;
 	}
 
-	nr_pages = (1 << cachep->gfporder);
-	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, nr_pages);
-	else
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, nr_pages);
-
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
@@ -1424,12 +1417,6 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 {
 	int order = cachep->gfporder;
-	unsigned long nr_freed = (1 << order);
-
-	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -nr_freed);
-	else
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, -nr_freed);
 
 	BUG_ON(!PageSlab(page));
 	__ClearPageSlabPfmemalloc(page);
@@ -1438,8 +1425,8 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 	page->mapping = NULL;
 
 	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += nr_freed;
-	memcg_uncharge_slab(page, order, cachep);
+		current->reclaim_state->reclaimed_slab += 1 << order;
+	uncharge_slab_page(page, order, cachep);
 	__free_pages(page, order);
 }
 
diff --git a/mm/slab.h b/mm/slab.h
index 4a261c97c138..0f5c5444acf1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -205,6 +205,12 @@ ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
 int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
+static inline int cache_vmstat_idx(struct kmem_cache *s)
+{
+	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 
 /* List of all root caches. */
@@ -352,6 +358,22 @@ static inline void memcg_link_cache(struct kmem_cache *s,
 
 #endif /* CONFIG_MEMCG_KMEM */
 
+static __always_inline int charge_slab_page(struct page *page,
+					    gfp_t gfp, int order,
+					    struct kmem_cache *s)
+{
+	memcg_charge_slab(page, gfp, order, s);
+	mod_lruvec_page_state(page, cache_vmstat_idx(s), 1 << order);
+	return 0;
+}
+
+static __always_inline void uncharge_slab_page(struct page *page, int order,
+					       struct kmem_cache *s)
+{
+	mod_lruvec_page_state(page, cache_vmstat_idx(s), -(1 << order));
+	memcg_uncharge_slab(page, order, s);
+}
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
diff --git a/mm/slub.c b/mm/slub.c
index 195f61785c7d..90563c0b3b5f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1499,7 +1499,7 @@ static inline struct page *alloc_slab_page(struct kmem_cache *s,
 	else
 		page = __alloc_pages_node(node, flags, order);
 
-	if (page && memcg_charge_slab(page, flags, order, s)) {
+	if (page && charge_slab_page(page, flags, order, s)) {
 		__free_pages(page, order);
 		page = NULL;
 	}
@@ -1692,11 +1692,6 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (!page)
 		return NULL;
 
-	mod_lruvec_page_state(page,
-		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		1 << oo_order(oo));
-
 	inc_slabs_node(s, page_to_nid(page), page->objects);
 
 	return page;
@@ -1730,18 +1725,13 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 			check_object(s, page, p, SLUB_RED_INACTIVE);
 	}
 
-	mod_lruvec_page_state(page,
-		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		-pages);
-
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
 
 	page->mapping = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	memcg_uncharge_slab(page, order, s);
+	uncharge_slab_page(page, order, s);
 	__free_pages(page, order);
 }
 
-- 
2.20.1

