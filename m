From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sat, 27 May 2023 18:31:26 +0800
Message-ID: <20230527103126.398267-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The function mem_cgroup_from_obj() is not used anymore. Remove it and
clean up relevant comments.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |  6 ------
 mm/memcontrol.c            | 31 -------------------------------
 2 files changed, 37 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 00a88cf947e1..ce8c2355ed9f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1813,7 +1813,6 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-struct mem_cgroup *mem_cgroup_from_obj(void *p);
 struct mem_cgroup *mem_cgroup_from_slab_obj(void *p);
 
 static inline void count_objcg_event(struct obj_cgroup *objcg,
@@ -1876,11 +1875,6 @@ static inline int memcg_kmem_id(struct mem_cgroup *memcg)
 	return -1;
 }
 
-static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	return NULL;
-}
-
 static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 {
 	return NULL;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6a3d4ce87b8a..532b29c9a0fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2972,37 +2972,6 @@ struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is charged.
  *
- * A passed kernel object can be a slab object, vmalloc object or a generic
- * kernel page, so different mechanisms for getting the memory cgroup pointer
- * should be used.
- *
- * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the caller
- * can not know for sure how the kernel object is implemented.
- * mem_cgroup_from_obj() can be safely used in such cases.
- *
- * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
- * cgroup_mutex, etc.
- */
-struct mem_cgroup *mem_cgroup_from_obj(void *p)
-{
-	struct folio *folio;
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	if (unlikely(is_vmalloc_addr(p)))
-		folio = page_folio(vmalloc_to_page(p));
-	else
-		folio = virt_to_folio(p);
-
-	return mem_cgroup_from_obj_folio(folio, p);
-}
-
-/*
- * Returns a pointer to the memory cgroup to which the kernel object is charged.
- * Similar to mem_cgroup_from_obj(), but faster and not suitable for objects,
- * allocated using vmalloc().
- *
  * A passed kernel object must be a slab object or a generic kernel page.
  *
  * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
-- 
2.27.0

