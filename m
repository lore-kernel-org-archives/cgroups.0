From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: take reference before releasing rcu_read_lock
Date: Fri, 29 Mar 2013 18:28:57 +0800
Message-ID: <51556CE9.9060000@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

The memcg is not referenced, so it can be destroyed at anytime right
after we exit rcu read section, so it's not safe to access it.

To fix this, we call css_tryget() to get a reference while we're still
in rcu read section.

This also removes a bogus comment above __memcg_create_cache_enqueue().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 63 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bbe0742..01fe340 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3456,7 +3456,6 @@ static void memcg_create_cache_work_func(struct work_struct *w)
 
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
- * Called with rcu_read_lock.
  */
 static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 					 struct kmem_cache *cachep)
@@ -3464,12 +3463,8 @@ static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
 	struct create_work *cw;
 
 	cw = kmalloc(sizeof(struct create_work), GFP_NOWAIT);
-	if (cw == NULL)
-		return;
-
-	/* The corresponding put will be done in the workqueue. */
-	if (!css_tryget(&memcg->css)) {
-		kfree(cw);
+	if (cw == NULL) {
+		css_put(&memcg->css);
 		return;
 	}
 
@@ -3525,10 +3520,9 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
-	rcu_read_unlock();
 
 	if (!memcg_can_account_kmem(memcg))
-		return cachep;
+		goto out;
 
 	idx = memcg_cache_id(memcg);
 
@@ -3537,29 +3531,38 @@ struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
 	 * code updating memcg_caches will issue a write barrier to match this.
 	 */
 	read_barrier_depends();
-	if (unlikely(cachep->memcg_params->memcg_caches[idx] == NULL)) {
-		/*
-		 * If we are in a safe context (can wait, and not in interrupt
-		 * context), we could be be predictable and return right away.
-		 * This would guarantee that the allocation being performed
-		 * already belongs in the new cache.
-		 *
-		 * However, there are some clashes that can arrive from locking.
-		 * For instance, because we acquire the slab_mutex while doing
-		 * kmem_cache_dup, this means no further allocation could happen
-		 * with the slab_mutex held.
-		 *
-		 * Also, because cache creation issue get_online_cpus(), this
-		 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
-		 * that ends up reversed during cpu hotplug. (cpuset allocates
-		 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
-		 * better to defer everything.
-		 */
-		memcg_create_cache_enqueue(memcg, cachep);
-		return cachep;
+	if (likely(cachep->memcg_params->memcg_caches[idx])) {
+		cachep = cachep->memcg_params->memcg_caches[idx];
+		goto out;
 	}
 
-	return cachep->memcg_params->memcg_caches[idx];
+	/* The corresponding put will be done in the workqueue. */
+	if (!css_tryget(&memcg->css))
+		goto out;
+	rcu_read_unlock();
+
+	/*
+	 * If we are in a safe context (can wait, and not in interrupt
+	 * context), we could be be predictable and return right away.
+	 * This would guarantee that the allocation being performed
+	 * already belongs in the new cache.
+	 *
+	 * However, there are some clashes that can arrive from locking.
+	 * For instance, because we acquire the slab_mutex while doing
+	 * kmem_cache_dup, this means no further allocation could happen
+	 * with the slab_mutex held.
+	 *
+	 * Also, because cache creation issue get_online_cpus(), this
+	 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
+	 * that ends up reversed during cpu hotplug. (cpuset allocates
+	 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
+	 * better to defer everything.
+	 */
+	memcg_create_cache_enqueue(memcg, cachep);
+	return cachep;
+out:
+	rcu_read_unlock();
+	return cachep;
 }
 EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
-- 
1.8.0.2
