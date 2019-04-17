From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 2/5] mm: generalize postponed non-root kmem_cache deactivation
Date: Wed, 17 Apr 2019 14:54:31 -0700
Message-ID: <20190417215434.25897-3-guro@fb.com>
References: <20190417215434.25897-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MtkthRXb9xr3Z6+sHE+ddzmShZROkNDy015XAdhrxgc=;
        b=bkJtX8C+3fj0Tjhyg4vCVv/IFmBzbGBkiaDAvFLmDb8Lq2CSpvTCu0DpsxNBzVRZE6
         /KavKK6sZJp6q1on9j4P5GAND/bIlyXqkI64KWpz4q5A+ph+Wga2tCFOg5zBESw4qB6F
         0a8qx/VE5UXWEj/OfguZ1W6Acn8pwoIJDzZu71ecJg94TK4ni4QRK9oElJ9DPSm60c+g
         K0zyATOpmJW3pcoANLB3OTOt8dtYU0H7WgFn7PoNVvhHacgEQcsm7GTnMLHoclASVfe4
         LiW1YvyENbVaOxl0Qz3UxRV4EsfpG6OXUukFSX+jgB8C/tTLlnztGVBcSkJ+IPrW2RX7
         G1Xg==
In-Reply-To: <20190417215434.25897-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, david@fromorbit.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Currently SLUB uses a work scheduled after an RCU grace period
to deactivate a non-root kmem_cache. This mechanism can be reused
for kmem_caches reparenting, but requires some generalization.

Let's decouple all infrastructure (rcu callback, work callback)
from the SLUB-specific code, so it can be used with SLAB as well.

Also, let's rename some functions to make the code look simpler.
All SLAB/SLUB-specific functions start with "__". Remove "deact_"
prefix from the corresponding struct fields.

Here is the graph of a new calling scheme:
kmemcg_cache_deactivate()
  __kmemcg_cache_deactivate()                  SLAB/SLUB-specific
  kmemcg_schedule_work_after_rcu()             rcu
    kmemcg_after_rcu_workfn()                  work
      kmemcg_cache_deactivate_after_rcu()
        __kmemcg_cache_deactivate_after_rcu()  SLAB/SLUB-specific

instead of:
__kmemcg_cache_deactivate()                    SLAB/SLUB-specific
  slab_deactivate_memcg_cache_rcu_sched()      SLUB-only
    kmemcg_deactivate_rcufn                    SLUB-only, rcu
      kmemcg_deactivate_workfn                 SLUB-only, work
        kmemcg_cache_deact_after_rcu()         SLUB-only

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/slab.h |  6 ++---
 mm/slab.c            |  4 +++
 mm/slab.h            |  3 ++-
 mm/slab_common.c     | 62 ++++++++++++++++++++------------------------
 mm/slub.c            |  8 +-----
 5 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9449b19c5f10..47923c173f30 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -642,10 +642,10 @@ struct memcg_cache_params {
 			struct list_head children_node;
 			struct list_head kmem_caches_node;
 
-			void (*deact_fn)(struct kmem_cache *);
+			void (*work_fn)(struct kmem_cache *);
 			union {
-				struct rcu_head deact_rcu_head;
-				struct work_struct deact_work;
+				struct rcu_head rcu_head;
+				struct work_struct work;
 			};
 		};
 	};
diff --git a/mm/slab.c b/mm/slab.c
index 57a332f524cf..14466a73d057 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2317,6 +2317,10 @@ void __kmemcg_cache_deactivate(struct kmem_cache *cachep)
 {
 	__kmem_cache_shrink(cachep);
 }
+
+void __kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s)
+{
+}
 #endif
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
diff --git a/mm/slab.h b/mm/slab.h
index 6a562ca72bca..4a261c97c138 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -172,6 +172,7 @@ int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
 int __kmem_cache_shrink(struct kmem_cache *);
 void __kmemcg_cache_deactivate(struct kmem_cache *s);
+void __kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
@@ -291,7 +292,7 @@ static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 extern void slab_init_memcg_params(struct kmem_cache *);
 extern void memcg_link_cache(struct kmem_cache *s, struct mem_cgroup *memcg);
 extern void slab_deactivate_memcg_cache_rcu_sched(struct kmem_cache *s,
-				void (*deact_fn)(struct kmem_cache *));
+				void (*work_fn)(struct kmem_cache *));
 
 #else /* CONFIG_MEMCG_KMEM */
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 6e00bdf8618d..4e5b4292a763 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -691,17 +691,18 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	put_online_cpus();
 }
 
-static void kmemcg_deactivate_workfn(struct work_struct *work)
+static void kmemcg_after_rcu_workfn(struct work_struct *work)
 {
 	struct kmem_cache *s = container_of(work, struct kmem_cache,
-					    memcg_params.deact_work);
+					    memcg_params.work);
 
 	get_online_cpus();
 	get_online_mems();
 
 	mutex_lock(&slab_mutex);
 
-	s->memcg_params.deact_fn(s);
+	s->memcg_params.work_fn(s);
+	s->memcg_params.work_fn = NULL;
 
 	mutex_unlock(&slab_mutex);
 
@@ -712,37 +713,28 @@ static void kmemcg_deactivate_workfn(struct work_struct *work)
 	css_put(&s->memcg_params.memcg->css);
 }
 
-static void kmemcg_deactivate_rcufn(struct rcu_head *head)
+/*
+ * We need to grab blocking locks.  Bounce to ->work.  The
+ * work item shares the space with the RCU head and can't be
+ * initialized eariler.
+*/
+static void kmemcg_schedule_work_after_rcu(struct rcu_head *head)
 {
 	struct kmem_cache *s = container_of(head, struct kmem_cache,
-					    memcg_params.deact_rcu_head);
+					    memcg_params.rcu_head);
 
-	/*
-	 * We need to grab blocking locks.  Bounce to ->deact_work.  The
-	 * work item shares the space with the RCU head and can't be
-	 * initialized eariler.
-	 */
-	INIT_WORK(&s->memcg_params.deact_work, kmemcg_deactivate_workfn);
-	queue_work(memcg_kmem_cache_wq, &s->memcg_params.deact_work);
+	INIT_WORK(&s->memcg_params.work, kmemcg_after_rcu_workfn);
+	queue_work(memcg_kmem_cache_wq, &s->memcg_params.work);
 }
 
-/**
- * slab_deactivate_memcg_cache_rcu_sched - schedule deactivation after a
- *					   sched RCU grace period
- * @s: target kmem_cache
- * @deact_fn: deactivation function to call
- *
- * Schedule @deact_fn to be invoked with online cpus, mems and slab_mutex
- * held after a sched RCU grace period.  The slab is guaranteed to stay
- * alive until @deact_fn is finished.  This is to be used from
- * __kmemcg_cache_deactivate().
- */
-void slab_deactivate_memcg_cache_rcu_sched(struct kmem_cache *s,
-					   void (*deact_fn)(struct kmem_cache *))
+static void kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s)
 {
-	if (WARN_ON_ONCE(is_root_cache(s)) ||
-	    WARN_ON_ONCE(s->memcg_params.deact_fn))
-		return;
+	__kmemcg_cache_deactivate_after_rcu(s);
+}
+
+static void kmemcg_cache_deactivate(struct kmem_cache *s)
+{
+	__kmemcg_cache_deactivate(s);
 
 	if (s->memcg_params.root_cache->memcg_params.dying)
 		return;
@@ -750,8 +742,9 @@ void slab_deactivate_memcg_cache_rcu_sched(struct kmem_cache *s,
 	/* pin memcg so that @s doesn't get destroyed in the middle */
 	css_get(&s->memcg_params.memcg->css);
 
-	s->memcg_params.deact_fn = deact_fn;
-	call_rcu(&s->memcg_params.deact_rcu_head, kmemcg_deactivate_rcufn);
+	WARN_ON_ONCE(s->memcg_params.work_fn);
+	s->memcg_params.work_fn = kmemcg_cache_deactivate_after_rcu;
+	call_rcu(&s->memcg_params.rcu_head, kmemcg_schedule_work_after_rcu);
 }
 
 void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
@@ -773,7 +766,7 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *memcg)
 		if (!c)
 			continue;
 
-		__kmemcg_cache_deactivate(c);
+		kmemcg_cache_deactivate(c);
 		arr->entries[idx] = NULL;
 	}
 	mutex_unlock(&slab_mutex);
@@ -866,11 +859,12 @@ static void flush_memcg_workqueue(struct kmem_cache *s)
 	mutex_unlock(&slab_mutex);
 
 	/*
-	 * SLUB deactivates the kmem_caches through call_rcu. Make
+	 * SLAB and SLUB deactivate the kmem_caches through call_rcu. Make
 	 * sure all registered rcu callbacks have been invoked.
 	 */
-	if (IS_ENABLED(CONFIG_SLUB))
-		rcu_barrier();
+#ifndef CONFIG_SLOB
+	rcu_barrier();
+#endif
 
 	/*
 	 * SLAB and SLUB create memcg kmem_caches through workqueue and SLUB
diff --git a/mm/slub.c b/mm/slub.c
index 2b9244529d76..195f61785c7d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4033,7 +4033,7 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 }
 
 #ifdef CONFIG_MEMCG
-static void kmemcg_cache_deact_after_rcu(struct kmem_cache *s)
+void __kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s)
 {
 	/*
 	 * Called with all the locks held after a sched RCU grace period.
@@ -4059,12 +4059,6 @@ void __kmemcg_cache_deactivate(struct kmem_cache *s)
 	 */
 	slub_set_cpu_partial(s, 0);
 	s->min_partial = 0;
-
-	/*
-	 * s->cpu_partial is checked locklessly (see put_cpu_partial), so
-	 * we have to make sure the change is visible before shrinking.
-	 */
-	slab_deactivate_memcg_cache_rcu_sched(s, kmemcg_cache_deact_after_rcu);
 }
 #endif	/* CONFIG_MEMCG */
 
-- 
2.20.1

