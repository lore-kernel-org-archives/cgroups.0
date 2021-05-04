From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n> caches
Date: Tue,  4 May 2021 09:23:50 -0400
Message-ID: <20210504132350.4693-3-longman@redhat.com>
References: <20210504132350.4693-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620134684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=lCli4beQJsOgvS4wIOFWCZuHcGJs2tYDZCu5/pA+CYY=;
        b=XKStkX6zN9yJ2FK1iMLSXTCwI+5R8+i93Q2kpROCb1O68n25DmQGFCyZ9SUbl6hV8E0voK
        GEJuwXXvVrgA5D/HEM/aKA+sglg6P5HXK/xeKvquUGQRmW94qIESZfE+m5bkYijey9FuSM
        I1BGOuAj+vqNe+MMGRWxn37/fSlN+nY=
In-Reply-To: <20210504132350.4693-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
(KMALLOC_NORMAL) caches for non-accounted objects only and a new set of
kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
the other caches can allow a mix of accounted and non-accounted objects.

With this change, all the objcg pointer array objects will come from
KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
both the recursive kfree() problem and non-freeable slab problem
are gone.

The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
will include the newly added caches without change.

Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/slab.h | 15 +++++++++++++++
 mm/slab_common.c     | 23 +++++++++++++++--------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0c97d788762c..fca03c22ea7c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -305,9 +305,16 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
 /*
  * Whenever changing this, take care of that kmalloc_type() and
  * create_kmalloc_caches() still work as intended.
+ *
+ * KMALLOC_NORMAL is for non-accounted objects only whereas KMALLOC_CGROUP
+ * is for accounted objects only. All the other kmem caches can have both
+ * accounted and non-accounted objects.
  */
 enum kmalloc_cache_type {
 	KMALLOC_NORMAL = 0,
+#ifdef CONFIG_MEMCG_KMEM
+	KMALLOC_CGROUP,
+#endif
 	KMALLOC_RECLAIM,
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
@@ -321,6 +328,14 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
 
 static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
 {
+#ifdef CONFIG_MEMCG_KMEM
+	/*
+	 * KMALLOC_CGROUP for non-reclaimable and non-DMA object with
+	 * accounting enabled.
+	 */
+	if ((flags & (__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)) == __GFP_ACCOUNT)
+		return KMALLOC_CGROUP;
+#endif
 #ifdef CONFIG_ZONE_DMA
 	/*
 	 * The most common case is KMALLOC_NORMAL, so test for it
diff --git a/mm/slab_common.c b/mm/slab_common.c
index f8833d3e5d47..d750e3ba7af5 100644
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
@@ -847,6 +851,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
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

