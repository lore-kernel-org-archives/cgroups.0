From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 2/3] mm: memcg: plumbing memcg for kmalloc allocations
Date: Tue, 13 Feb 2018 18:56:52 -0800
Message-ID: <20180214025653.132942-3-shakeelb@google.com>
References: <20180214025653.132942-1-shakeelb@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ta8c7WSeZq4igzm0gbjFTmPozu9DMY+0BB0LY88cyqg=;
        b=pPB7fRrOn58cmnUoWzso8oVvXDEz6dhBgdt/jC2fkIVP6bWw+dKOJIUb4SQNDCP5CD
         bEq5boJBDJ+Yh1eIhN9G5j9aaXso22gI8Tkdsk3IETLbNMePs5YEWhHK5K+pSb5jdv/F
         vHhwcG+wzub2xaTK4Nd7YLMyh3z4LUYJy6sZPbZZin/vF8xnQmwB20ZJkOrGdI2Gmq2i
         2jgTPA3xAaf+cFwE3P/l1/vpXKg+s+bubFphjNzYKYoY2545QLbs61K08MkIsMugbbII
         pJRIh/XPt+PWs+gka6TQhazDaXiFAgB3w3Ivqk80sm9UoHyj9T7LCJ4hxCD1cydEMsQ5
         ZlkQ==
In-Reply-To: <20180214025653.132942-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Introducing the memcg variant for kmalloc allocation functions.
The kmalloc allocations are underlying served using the kmem caches
unless the size of the allocation request is larger than
KMALLOC_MAX_CACHE_SIZE, in which case, the kmem caches are bypassed and
the request is routed directly to page allocator. So, for __GFP_ACCOUNT
kmalloc allocations, the memcg of current task is charged. This patch
introduces memcg variant of kmalloc functions to allow callers to
provide memcg for charging.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |  3 +-
 include/linux/slab.h       | 45 +++++++++++++++++++++++---
 mm/memcontrol.c            |  9 ++++--
 mm/page_alloc.c            |  2 +-
 mm/slab.c                  | 31 +++++++++++++-----
 mm/slab_common.c           | 41 +++++++++++++++++++++++-
 mm/slub.c                  | 65 +++++++++++++++++++++++++++++++-------
 7 files changed, 166 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 48eaf19859e9..9dec8a5c0ca2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1179,7 +1179,8 @@ struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep,
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
 int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
 			    struct mem_cgroup *memcg);
-int memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+int memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
+		      struct mem_cgroup *memcg);
 void memcg_kmem_uncharge(struct page *page, int order);
 
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 24355bc9e655..9df5d6279b38 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -352,6 +352,8 @@ static __always_inline int kmalloc_index(size_t size)
 #endif /* !CONFIG_SLOB */
 
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
+void *__kmalloc_memcg(size_t size, gfp_t flags,
+		struct mem_cgroup *memcg) __assume_kmalloc_alignment __malloc;
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment __malloc;
 void *kmem_cache_alloc_memcg(struct kmem_cache *, gfp_t flags,
 		struct mem_cgroup *memcg) __assume_slab_alignment __malloc;
@@ -378,6 +380,8 @@ static __always_inline void kfree_bulk(size_t size, void **p)
 
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment __malloc;
+void *__kmalloc_node_memcg(size_t size, gfp_t flags, int node,
+		struct mem_cgroup *memcg) __assume_kmalloc_alignment __malloc;
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment __malloc;
 void *kmem_cache_alloc_node_memcg(struct kmem_cache *, gfp_t flags, int node,
 		struct mem_cgroup *memcg) __assume_slab_alignment __malloc;
@@ -387,6 +391,12 @@ static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	return __kmalloc(size, flags);
 }
 
+static __always_inline void *__kmalloc_node_memcg(size_t size, gfp_t flags,
+					struct mem_cgroup *memcg, int node)
+{
+	return __kmalloc_memcg(size, flags, memcg);
+}
+
 static __always_inline void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t flags, int node)
 {
 	return kmem_cache_alloc(s, flags);
@@ -470,15 +480,26 @@ kmem_cache_alloc_node_memcg_trace(struct kmem_cache *s, gfp_t gfpflags,
 #endif /* CONFIG_TRACING */
 
 extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern void *kmalloc_order_memcg(size_t size, gfp_t flags, unsigned int order,
+		struct mem_cgroup *memcg) __assume_page_alignment __malloc;
 
 #ifdef CONFIG_TRACING
 extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern void *kmalloc_order_memcg_trace(size_t size, gfp_t flags,
+	unsigned int order,
+	struct mem_cgroup *memcg) __assume_page_alignment __malloc;
 #else
 static __always_inline void *
 kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 {
 	return kmalloc_order(size, flags, order);
 }
+static __always_inline void *
+kmalloc_order_memcg_trace(size_t size, gfp_t flags, unsigned int order,
+			  struct mem_cgroup *memcg)
+{
+	return kmalloc_order_memcg(size, flags, order, memcg);
+}
 #endif
 
 static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
@@ -487,6 +508,14 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 	return kmalloc_order_trace(size, flags, order);
 }
 
+static __always_inline void *kmalloc_large_memcg(size_t size, gfp_t flags,
+						 struct mem_cgroup *memcg)
+{
+	unsigned int order = get_order(size);
+
+	return kmalloc_order_memcg_trace(size, flags, order, memcg);
+}
+
 /**
  * kmalloc - allocate memory
  * @size: how many bytes of memory are required.
@@ -538,11 +567,12 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static __always_inline void *kmalloc(size_t size, gfp_t flags)
+static __always_inline void *
+kmalloc_memcg(size_t size, gfp_t flags, struct mem_cgroup *memcg)
 {
 	if (__builtin_constant_p(size)) {
 		if (size > KMALLOC_MAX_CACHE_SIZE)
-			return kmalloc_large(size, flags);
+			return kmalloc_large_memcg(size, flags, memcg);
 #ifndef CONFIG_SLOB
 		if (!(flags & GFP_DMA)) {
 			int index = kmalloc_index(size);
@@ -550,12 +580,17 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			if (!index)
 				return ZERO_SIZE_PTR;
 
-			return kmem_cache_alloc_trace(kmalloc_caches[index],
-					flags, size);
+			return kmem_cache_alloc_memcg_trace(
+				kmalloc_caches[index], flags, size, memcg);
 		}
 #endif
 	}
-	return __kmalloc(size, flags);
+	return __kmalloc_memcg(size, flags, memcg);
+}
+
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
+{
+	return kmalloc_memcg(size, flags, NULL);
 }
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd37e855e277..0dcd6ab6cc94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2348,15 +2348,18 @@ int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
  *
  * Returns 0 on success, an error code on failure.
  */
-int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+int memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
+		      struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
 	int ret = 0;
 
 	if (memcg_kmem_bypass())
 		return 0;
 
-	memcg = get_mem_cgroup_from_mm(current->mm);
+	if (memcg)
+		memcg = get_mem_cgroup(memcg);
+	if (!memcg)
+		memcg = get_mem_cgroup_from_mm(current->mm);
 	if (!mem_cgroup_is_root(memcg)) {
 		ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
 		if (!ret)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2b42f603b1a..d65d58045893 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4261,7 +4261,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 
 out:
 	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
-	    unlikely(memcg_kmem_charge(page, gfp_mask, order) != 0)) {
+	    unlikely(memcg_kmem_charge(page, gfp_mask, order, NULL) != 0)) {
 		__free_pages(page, order);
 		page = NULL;
 	}
diff --git a/mm/slab.c b/mm/slab.c
index 3daeda62bd0c..4282f5a84dcd 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3715,7 +3715,8 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_memcg_trace);
 #endif
 
 static __always_inline void *
-__do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller)
+__do_kmalloc_node(size_t size, gfp_t flags, int node, struct mem_cgroup *memcg,
+		  unsigned long caller)
 {
 	struct kmem_cache *cachep;
 	void *ret;
@@ -3723,7 +3724,8 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller)
 	cachep = kmalloc_slab(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	ret = kmem_cache_alloc_node_trace(cachep, flags, node, size);
+	ret = kmem_cache_alloc_node_memcg_trace(cachep, flags, node, size,
+						memcg);
 	kasan_kmalloc(cachep, ret, size, flags);
 
 	return ret;
@@ -3731,14 +3733,21 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller)
 
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	return __do_kmalloc_node(size, flags, node, _RET_IP_);
+	return __do_kmalloc_node(size, flags, node, NULL, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
+void *__kmalloc_node_memcg(size_t size, gfp_t flags, int node,
+			   struct mem_cgroup *memcg)
+{
+	return __do_kmalloc_node(size, flags, node, memcg, _RET_IP_);
+}
+EXPORT_SYMBOL(__kmalloc_node_memcg);
+
 void *__kmalloc_node_track_caller(size_t size, gfp_t flags,
 		int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, flags, node, caller);
+	return __do_kmalloc_node(size, flags, node, NULL, caller);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif /* CONFIG_NUMA */
@@ -3750,7 +3759,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
  * @caller: function caller for debug tracking of the caller
  */
 static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
-					  unsigned long caller)
+				struct mem_cgroup *memcg, unsigned long caller)
 {
 	struct kmem_cache *cachep;
 	void *ret;
@@ -3758,7 +3767,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 	cachep = kmalloc_slab(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	ret = slab_alloc(cachep, flags, NULL, caller);
+	ret = slab_alloc(cachep, flags, memcg, caller);
 
 	kasan_kmalloc(cachep, ret, size, flags);
 	trace_kmalloc(caller, ret,
@@ -3769,13 +3778,19 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 
 void *__kmalloc(size_t size, gfp_t flags)
 {
-	return __do_kmalloc(size, flags, _RET_IP_);
+	return __do_kmalloc(size, flags, NULL, _RET_IP_);
 }
 EXPORT_SYMBOL(__kmalloc);
 
+void *__kmalloc_memcg(size_t size, gfp_t flags, struct mem_cgroup *memcg)
+{
+	return __do_kmalloc(size, flags, memcg, _RET_IP_);
+}
+EXPORT_SYMBOL(__kmalloc_memcg);
+
 void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
 {
-	return __do_kmalloc(size, flags, caller);
+	return __do_kmalloc(size, flags, NULL, caller);
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 10f127b2de7c..49aea3b0725d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1155,20 +1155,49 @@ void __init create_kmalloc_caches(slab_flags_t flags)
  * directly to the page allocator. We use __GFP_COMP, because we will need to
  * know the allocation order to free the pages properly in kfree.
  */
-void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
+static __always_inline void *__kmalloc_order_memcg(size_t size, gfp_t flags,
+						   unsigned int order,
+						   struct mem_cgroup *memcg)
 {
 	void *ret;
 	struct page *page;
 
 	flags |= __GFP_COMP;
+
+	/*
+	 * Do explicit targeted memcg charging instead of
+	 * __alloc_pages_nodemask charging current memcg.
+	 */
+	if (memcg && (flags & __GFP_ACCOUNT))
+		flags &= ~__GFP_ACCOUNT;
+
 	page = alloc_pages(flags, order);
+
+	if (memcg && page && memcg_kmem_enabled() &&
+	    memcg_kmem_charge(page, flags, order, memcg)) {
+		__free_pages(page, order);
+		page = NULL;
+	}
+
 	ret = page ? page_address(page) : NULL;
 	kmemleak_alloc(ret, size, 1, flags);
 	kasan_kmalloc_large(ret, size, flags);
 	return ret;
 }
+
+void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
+{
+	return __kmalloc_order_memcg(size, flags, order, NULL);
+}
 EXPORT_SYMBOL(kmalloc_order);
 
+void *kmalloc_order_memcg(size_t size, gfp_t flags, unsigned int order,
+			  struct mem_cgroup *memcg)
+{
+	return __kmalloc_order_memcg(size, flags, order, memcg);
+}
+EXPORT_SYMBOL(kmalloc_order_memcg);
+
 #ifdef CONFIG_TRACING
 void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 {
@@ -1177,6 +1206,16 @@ void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 	return ret;
 }
 EXPORT_SYMBOL(kmalloc_order_trace);
+
+void *kmalloc_order_memcg_trace(size_t size, gfp_t flags, unsigned int order,
+				struct mem_cgroup *memcg)
+{
+	void *ret = kmalloc_order_memcg(size, flags, order, memcg);
+
+	trace_kmalloc(_RET_IP_, ret, size, PAGE_SIZE << order, flags);
+	return ret;
+}
+EXPORT_SYMBOL(kmalloc_order_memcg_trace);
 #endif
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
diff --git a/mm/slub.c b/mm/slub.c
index 061cfbc7c3d7..5b119f4fb6bc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3791,13 +3791,14 @@ static int __init setup_slub_min_objects(char *str)
 
 __setup("slub_min_objects=", setup_slub_min_objects);
 
-void *__kmalloc(size_t size, gfp_t flags)
+static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
+				struct mem_cgroup *memcg, unsigned long caller)
 {
 	struct kmem_cache *s;
 	void *ret;
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
-		return kmalloc_large(size, flags);
+		return kmalloc_large_memcg(size, flags, memcg);
 
 	s = kmalloc_slab(size, flags);
 
@@ -3806,22 +3807,50 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	ret = slab_alloc(s, flags, NULL, _RET_IP_);
 
-	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
+	trace_kmalloc(caller, ret, size, s->size, flags);
 
 	kasan_kmalloc(s, ret, size, flags);
 
 	return ret;
 }
+
+void *__kmalloc(size_t size, gfp_t flags)
+{
+	return __do_kmalloc(size, flags, NULL, _RET_IP_);
+}
 EXPORT_SYMBOL(__kmalloc);
 
+void *__kmalloc_memcg(size_t size, gfp_t flags, struct mem_cgroup *memcg)
+{
+	return __do_kmalloc(size, flags, memcg, _RET_IP_);
+}
+EXPORT_SYMBOL(__kmalloc_memcg);
+
 #ifdef CONFIG_NUMA
-static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
+static void *kmalloc_large_node(size_t size, gfp_t flags, int node,
+				struct mem_cgroup *memcg)
 {
 	struct page *page;
 	void *ptr = NULL;
+	unsigned int order = get_order(size);
 
 	flags |= __GFP_COMP;
-	page = alloc_pages_node(node, flags, get_order(size));
+
+	/*
+	 * Do explicit targeted memcg charging instead of
+	 * __alloc_pages_nodemask charging current memcg.
+	 */
+	if (memcg && (flags & __GFP_ACCOUNT))
+		flags &= ~__GFP_ACCOUNT;
+
+	page = alloc_pages_node(node, flags, order);
+
+	if (memcg && page && memcg_kmem_enabled() &&
+	    memcg_kmem_charge(page, flags, order, memcg)) {
+		__free_pages(page, order);
+		page = NULL;
+	}
+
 	if (page)
 		ptr = page_address(page);
 
@@ -3829,15 +3858,17 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 	return ptr;
 }
 
-void *__kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *
+__do_kmalloc_node_memcg(size_t size, gfp_t flags, int node,
+			struct mem_cgroup *memcg, unsigned long caller)
 {
 	struct kmem_cache *s;
 	void *ret;
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
-		ret = kmalloc_large_node(size, flags, node);
+		ret = kmalloc_large_node(size, flags, node, memcg);
 
-		trace_kmalloc_node(_RET_IP_, ret,
+		trace_kmalloc_node(caller, ret,
 				   size, PAGE_SIZE << get_order(size),
 				   flags, node);
 
@@ -3849,15 +3880,27 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	ret = slab_alloc_node(s, flags, node, NULL, _RET_IP_);
+	ret = slab_alloc_node(s, flags, node, memcg, caller);
 
-	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
+	trace_kmalloc_node(caller, ret, size, s->size, flags, node);
 
 	kasan_kmalloc(s, ret, size, flags);
 
 	return ret;
 }
+
+void *__kmalloc_node(size_t size, gfp_t flags, int node)
+{
+	return __do_kmalloc_node_memcg(size, flags, node, NULL, _RET_IP_);
+}
 EXPORT_SYMBOL(__kmalloc_node);
+
+void *__kmalloc_node_memcg(size_t size, gfp_t flags, int node,
+			   struct mem_cgroup *memcg)
+{
+	return __do_kmalloc_node_memcg(size, flags, node, memcg, _RET_IP_);
+}
+EXPORT_SYMBOL(__kmalloc_node_memcg);
 #endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
@@ -4370,7 +4413,7 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	void *ret;
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
-		ret = kmalloc_large_node(size, gfpflags, node);
+		ret = kmalloc_large_node(size, gfpflags, node, NULL);
 
 		trace_kmalloc_node(caller, ret,
 				   size, PAGE_SIZE << get_order(size),
-- 
2.16.1.291.g4437f3f132-goog
