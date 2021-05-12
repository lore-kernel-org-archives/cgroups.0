From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/3] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 12 May 2021 10:54:19 -0400
Message-ID: <0919aaab-cc08-f86d-1f9a-8ddfeed7bb31@redhat.com>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210512145107.6208-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620831266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SWpKC9JIophhOJfSAOpwo9ri4mX92NQqXeS4GIIdLL0=;
        b=gXhD6TJnCys8o1nXL2b3ZiAt1U4OuiXDL5LqIGy6C1yGTw0LU0qRNwzNtd/WDzySSARGDc
        jsgk/JeoM2SIVgc4+VpVTowsWR53rlTEGMiA0kZHrMq2JVw3i5mCDHgxfjNxYJ3wPac7aH
        RgrCYmDLjVb+11Th6g8VwCJZmKQqfoo=
In-Reply-To: <20210512145107.6208-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/12/21 10:51 AM, Waiman Long wrote:
> There are currently two problems in the way the objcg pointer array
> (memcg_data) in the page structure is being allocated and freed.
>
> On its allocation, it is possible that the allocated objcg pointer
> array comes from the same slab that requires memory accounting. If this
> happens, the slab will never become empty again as there is at least
> one object left (the obj_cgroup array) in the slab.
>
> When it is freed, the objcg pointer array object may be the last one
> in its slab and hence causes kfree() to be called again. With the
> right workload, the slab cache may be set up in a way that allows the
> recursive kfree() calling loop to nest deep enough to cause a kernel
> stack overflow and panic the system.
>
> One way to solve this problem is to split the kmalloc-<n> caches
> (KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
> (KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
> kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
> the other caches can still allow a mix of accounted and unaccounted
> objects.
>
> With this change, all the objcg pointer array objects will come from
> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
> both the recursive kfree() problem and non-freeable slab problem are
> gone.
>
> Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
> mixed accounted and unaccounted objects, this will slightly reduce the
> number of objcg pointer arrays that need to be allocated and save a bit
> of memory. On the other hand, creating a new set of kmalloc caches does
> have the effect of reducing cache utilization. So it is properly a wash.
>
> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
> will include the newly added caches without change.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> ---
>   include/linux/slab.h | 42 +++++++++++++++++++++++++++++++++---------
>   mm/slab_common.c     | 25 +++++++++++++++++--------
>   2 files changed, 50 insertions(+), 17 deletions(-)

The following are the diff's from previous version. It turns out that 
the previous patch doesn't work if CONFIG_ZONE_DMA isn't defined.

diff --git a/include/linux/slab.h b/include/linux/slab.h
index a51cad5f561c..aa7f6c222a60 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -312,16 +312,17 @@ static inline void __check_heap_object(const void 
*ptr, un
signed long n,
   */
  enum kmalloc_cache_type {
      KMALLOC_NORMAL = 0,
-#ifdef CONFIG_MEMCG_KMEM
-    KMALLOC_CGROUP,
-#else
+#ifndef CONFIG_ZONE_DMA
+    KMALLOC_DMA = KMALLOC_NORMAL,
+#endif
+#ifndef CONFIG_MEMCG_KMEM
      KMALLOC_CGROUP = KMALLOC_NORMAL,
+#else
+    KMALLOC_CGROUP,
  #endif
      KMALLOC_RECLAIM,
  #ifdef CONFIG_ZONE_DMA
      KMALLOC_DMA,
-#else
-    KMALLOC_DMA = KMALLOC_NORMAL,
  #endif
      NR_KMALLOC_TYPES
  };

Cheers,
Longman

