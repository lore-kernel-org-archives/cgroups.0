From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v10 35/35] memcg: reap dead memcgs upon global memory pressure.
Date: Mon,  3 Jun 2013 23:30:04 +0400
Message-ID: <1370287804-3481-36-git-send-email-glommer@openvz.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370287804-3481-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When we delete kmem-enabled memcgs, they can still be zombieing
around for a while. The reason is that the objects may still be alive,
and we won't be able to delete them at destruction time.

The only entry point for that, though, are the shrinkers. The
shrinker interface, however, is not exactly tailored to our needs. It
could be a little bit better by using the API Dave Chinner proposed, but
it is still not ideal since we aren't really a count-and-scan event, but
more a one-off flush-all-you-can event that would have to abuse that
somehow.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c0e1113f..919fb24b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -400,7 +400,6 @@ static size_t memcg_size(void)
 		nr_node_ids * sizeof(struct mem_cgroup_per_node);
 }
 
-#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 static LIST_HEAD(dangling_memcgs);
 static DEFINE_MUTEX(dangling_memcgs_mutex);
 
@@ -409,11 +408,14 @@ static inline void memcg_dangling_free(struct mem_cgroup *memcg)
 	mutex_lock(&dangling_memcgs_mutex);
 	list_del(&memcg->dead);
 	mutex_unlock(&dangling_memcgs_mutex);
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 	free_pages((unsigned long)memcg->memcg_name, 0);
+#endif
 }
 
 static inline void memcg_dangling_add(struct mem_cgroup *memcg)
 {
+#ifdef CONFIG_MEMCG_DEBUG_ASYNC_DESTROY
 	/*
 	 * cgroup.c will do page-sized allocations most of the time,
 	 * so we'll just follow the pattern. Also, __get_free_pages
@@ -439,15 +441,12 @@ static inline void memcg_dangling_add(struct mem_cgroup *memcg)
 	}
 
 add_list:
+#endif
 	INIT_LIST_HEAD(&memcg->dead);
 	mutex_lock(&dangling_memcgs_mutex);
 	list_add(&memcg->dead, &dangling_memcgs);
 	mutex_unlock(&dangling_memcgs_mutex);
 }
-#else
-static inline void memcg_dangling_free(struct mem_cgroup *memcg) {}
-static inline void memcg_dangling_add(struct mem_cgroup *memcg) {}
-#endif
 
 static DEFINE_MUTEX(set_limit_mutex);
 
@@ -6313,6 +6312,41 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+static void memcg_vmpressure_shrink_dead(void)
+{
+	struct memcg_cache_params *params, *tmp;
+	struct kmem_cache *cachep;
+	struct mem_cgroup *memcg;
+
+	mutex_lock(&dangling_memcgs_mutex);
+	list_for_each_entry(memcg, &dangling_memcgs, dead) {
+		mutex_lock(&memcg->slab_caches_mutex);
+		/* The element may go away as an indirect result of shrink */
+		list_for_each_entry_safe(params, tmp,
+					 &memcg->memcg_slab_caches, list) {
+			cachep = memcg_params_to_cache(params);
+			/*
+			 * the cpu_hotplug lock is taken in kmem_cache_create
+			 * outside the slab_caches_mutex manipulation. It will
+			 * be taken by kmem_cache_shrink to flush the cache.
+			 * So we need to drop the lock. It is all right because
+			 * the lock only protects elements moving in and out the
+			 * list.
+			 */
+			mutex_unlock(&memcg->slab_caches_mutex);
+			kmem_cache_shrink(cachep);
+			mutex_lock(&memcg->slab_caches_mutex);
+		}
+		mutex_unlock(&memcg->slab_caches_mutex);
+	}
+	mutex_unlock(&dangling_memcgs_mutex);
+}
+
+static void memcg_register_kmem_events(struct cgroup *cont)
+{
+	vmpressure_register_kernel_event(cont, memcg_vmpressure_shrink_dead);
+}
+
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	int ret;
@@ -6348,6 +6382,10 @@ static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 	}
 }
 #else
+static inline void memcg_register_kmem_events(struct cgroup *cont)
+{
+}
+
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	return 0;
@@ -6733,8 +6771,10 @@ mem_cgroup_css_online(struct cgroup *cont)
 	struct mem_cgroup *memcg, *parent;
 	int error = 0;
 
-	if (!cont->parent)
+	if (!cont->parent) {
+		memcg_register_kmem_events(cont);
 		return 0;
+	}
 
 	mutex_lock(&memcg_create_mutex);
 	memcg = mem_cgroup_from_cont(cont);
-- 
1.8.1.4
