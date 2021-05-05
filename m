From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 2/3] mm: memcg/slab: Create a new set of kmalloc-cg-<n> caches
Date: Wed,  5 May 2021 16:06:09 -0400
Message-ID: <20210505200610.13943-3-longman@redhat.com>
References: <20210505200610.13943-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620245203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=URwZ6TMpqo5Zq7yvnn0RlEsBDtzANakU/BtGxVMMkiI=;
        b=Gf8/UIYqIhwwaaCKGJbIPQSMBs00Soj4n/Cv6IMWuH74rX2VhzJAdCiMyKNBGXOS0rL8wB
        931AprbxN/kxOnldVqfGaWSVsgISkRpKKOuKmlz1b1FQ5Ax434vB1D7OYt+hSPT33Mk5Pa
        v0wJKYMVV5fOuF279OTQT3mH7B0mB3U=
In-Reply-To: <20210505200610.13943-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

There are currently two problems in the way the objcg pointer array
(memcg_data) in the page structure is being allocated and freed.

On its allocation, it is possible that the allocated objcg pointer
array comes from the same slab that requires memory accounting. If this
happens, the slab will never become empty again as there is at least
one object left (the obj_cgroup array) in the slab.

When it is freed, the objcg pointer array object may be the last one
in its slab and hence causes kfree() to be called again. With the
right workload, the slab cache may be set up in a way that allows the
recursive kfree() calling loop to nest deep enough to cause a kernel
stack overflow and panic the system.

One way to solve this problem is to split the kmalloc-<n> caches
(KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
(KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
the other caches can still allow a mix of accounted and unaccounted
objects.

With this change, all the objcg pointer array objects will come from
KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
both the recursive kfree() problem and non-freeable slab problem are
gone.

Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
mixed accounted and unaccounted objects, this will slightly reduce the
number of objcg pointer arrays that need to be allocated and save a bit
of memory. On the other hand, creating a new set of kmalloc caches does
have the effect of reducing cache utilization. So it is properly a wash.

The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
will include the newly added caches without change.

Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/slab.h | 41 ++++++++++++++++++++++++++++++++---------
 mm/slab_common.c     | 25 +++++++++++++++++--------
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0c97d788762c..a51cad5f561c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -305,12 +305,23 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
 /*
  * Whenever changing this, take care of that kmalloc_type() and
  * create_kmalloc_caches() still work as intended.
+ *
+ * KMALLOC_NORMAL can contain only unaccounted objects whereas KMALLOC_CGROUP
+ * is for accounted but unreclaimable and non-dma objects. All the other
+ * kmem caches can have both accounted and unaccounted objects.
  */
 enum kmalloc_cache_type {
 	KMALLOC_NORMAL = 0,
+#ifdef CONFIG_MEMCG_KMEM
+	KMALLOC_CGROUP,
+#else
+	KMALLOC_CGROUP = KMALLOC_NORMAL,
+#endif
 	KMALLOC_RECLAIM,
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
+#else
+	KMALLOC_DMA = KMALLOC_NORMAL,
 #endif
 	NR_KMALLOC_TYPES
 };
@@ -319,24 +330,36 @@ enum kmalloc_cache_type {
 extern struct kmem_cache *
 kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
 
+/*
+ * Define gfp bits that should not be set for KMALLOC_NORMAL.
+ */
+#define KMALLOC_NOT_NORMAL_BITS					\
+	(__GFP_RECLAIMABLE |					\
+	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
+	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
+
 static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
 {
-#ifdef CONFIG_ZONE_DMA
 	/*
 	 * The most common case is KMALLOC_NORMAL, so test for it
-	 * with a single branch for both flags.
+	 * with a single branch for all the relevant flags.
 	 */
-	if (likely((flags & (__GFP_DMA | __GFP_RECLAIMABLE)) == 0))
+	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
 		return KMALLOC_NORMAL;
 
 	/*
-	 * At least one of the flags has to be set. If both are, __GFP_DMA
-	 * is more important.
+	 * At least one of the flags has to be set. Their priorities in
+	 * decreasing order are:
+	 *  1) __GFP_DMA
+	 *  2) __GFP_RECLAIMABLE
+	 *  3) __GFP_ACCOUNT
 	 */
-	return flags & __GFP_DMA ? KMALLOC_DMA : KMALLOC_RECLAIM;
-#else
-	return flags & __GFP_RECLAIMABLE ? KMALLOC_RECLAIM : KMALLOC_NORMAL;
-#endif
+	if (IS_ENABLED(CONFIG_ZONE_DMA) && (flags & __GFP_DMA))
+		return KMALLOC_DMA;
+	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || (flags & __GFP_RECLAIMABLE))
+		return KMALLOC_RECLAIM;
+	else
+		return KMALLOC_CGROUP;
 }
 
 /*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index f8833d3e5d47..bbaf41a7c77e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -727,21 +727,25 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 }
 
 #ifdef CONFIG_ZONE_DMA
-#define INIT_KMALLOC_INFO(__size, __short_size)			\
-{								\
-	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
-	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
-	.name[KMALLOC_DMA]     = "dma-kmalloc-" #__short_size,	\
-	.size = __size,						\
-}
+#define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
+#else
+#define KMALLOC_DMA_NAME(sz)
+#endif
+
+#ifdef CONFIG_MEMCG_KMEM
+#define KMALLOC_CGROUP_NAME(sz)	.name[KMALLOC_CGROUP] = "kmalloc-cg-" #sz,
 #else
+#define KMALLOC_CGROUP_NAME(sz)
+#endif
+
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
 	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
 	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
+	KMALLOC_CGROUP_NAME(__short_size)			\
+	KMALLOC_DMA_NAME(__short_size)				\
 	.size = __size,						\
 }
-#endif
 
 /*
  * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
@@ -830,6 +834,8 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
 	if (type == KMALLOC_RECLAIM)
 		flags |= SLAB_RECLAIM_ACCOUNT;
+	else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP))
+		flags |= SLAB_ACCOUNT;
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
@@ -847,6 +853,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
 	int i;
 	enum kmalloc_cache_type type;
 
+	/*
+	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
+	 */
 	for (type = KMALLOC_NORMAL; type <= KMALLOC_RECLAIM; type++) {
 		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 			if (!kmalloc_caches[type][i])
-- 
2.18.1

