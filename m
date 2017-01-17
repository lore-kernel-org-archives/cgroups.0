From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] slab: use memcg_kmem_cache_wq for slab destruction operations
Date: Tue, 17 Jan 2017 15:54:11 -0800
Message-ID: <20170117235411.9408-11-tj@kernel.org>
References: <20170117235411.9408-1-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Xt0KaT4ie26cN6z4/OQ62YlS47J8wNqPSFkSe0avTw=;
        b=t13aiR0upRYsD9ILntm7JIwRMa6EaeMrLt3j+YJmRCIVMBRV/DWAB5JRqN6K+TLDzN
         o6k2O3YsryYpIWbYW0UZXRc0JrB44MvgITpiRdQT/he9tuI1JgxYzbPZ1n6v6Lq+5+43
         b5IgrxmOJab5ck1W3AiiPQksx7ypuM1jwlpzytS+g0e9A161geqMWUZg9vhP7h3ob/o/
         Dbn4Ld2iSa2v2OTZN84YUXTi0inJ3vSxxJymZtGpAU/1+xNKPoSSDWc1vp94FTmBDbpq
         e9QXTJK3vq67WFj4XLc2R+dIbPYnHS9sXXYJbrmR8vuE6QC0mQynLWH4GxFMTXF/Znk5
         kYoA==
In-Reply-To: <20170117235411.9408-1-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc: jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

If there's contention on slab_mutex, queueing the per-cache
destruction work item on the system_wq can unnecessarily create and
tie up a lot of kworkers.

Rename memcg_kmem_cache_create_wq to memcg_kmem_cache_wq and make it
global and use that workqueue for the destruction work items too.
While at it, convert the workqueue from an unbound workqueue to a
per-cpu one with concurrency limited to 1.  It's generally preferable
to use per-cpu workqueues and concurrency limit of 1 is safe enough.

This is suggested by Joonsoo Kim.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 16 ++++++++--------
 mm/slab_common.c           |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4de925c..67f3303 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -810,6 +810,7 @@ void memcg_kmem_uncharge(struct page *page, int order);
 
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 extern struct static_key_false memcg_kmem_enabled_key;
+extern struct workqueue_struct *memcg_kmem_cache_wq;
 
 extern int memcg_nr_cache_ids;
 void memcg_get_cache_ids(void);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2b20f7f..8757403 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -317,6 +317,8 @@ void memcg_put_cache_ids(void)
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
+struct workqueue_struct *memcg_kmem_cache_wq;
+
 #endif /* !CONFIG_SLOB */
 
 /**
@@ -2145,8 +2147,6 @@ struct memcg_kmem_cache_create_work {
 	struct work_struct work;
 };
 
-static struct workqueue_struct *memcg_kmem_cache_create_wq;
-
 static void memcg_kmem_cache_create_func(struct work_struct *w)
 {
 	struct memcg_kmem_cache_create_work *cw =
@@ -2178,7 +2178,7 @@ static void __memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 	cw->cachep = cachep;
 	INIT_WORK(&cw->work, memcg_kmem_cache_create_func);
 
-	queue_work(memcg_kmem_cache_create_wq, &cw->work);
+	queue_work(memcg_kmem_cache_wq, &cw->work);
 }
 
 static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
@@ -5780,12 +5780,12 @@ static int __init mem_cgroup_init(void)
 #ifndef CONFIG_SLOB
 	/*
 	 * Kmem cache creation is mostly done with the slab_mutex held,
-	 * so use a special workqueue to avoid stalling all worker
-	 * threads in case lots of cgroups are created simultaneously.
+	 * so use a workqueue with limited concurrency to avoid stalling
+	 * all worker threads in case lots of cgroups are created and
+	 * destroyed simultaneously.
 	 */
-	memcg_kmem_cache_create_wq =
-		alloc_ordered_workqueue("memcg_kmem_cache_create", 0);
-	BUG_ON(!memcg_kmem_cache_create_wq);
+	memcg_kmem_cache_wq = alloc_workqueue("memcg_kmem_cache", 0, 1);
+	BUG_ON(!memcg_kmem_cache_wq);
 #endif
 
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 32610d1..5e6a98c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -656,7 +656,7 @@ static void kmemcg_deactivate_rcufn(struct rcu_head *head)
 	 * initialized eariler.
 	 */
 	INIT_WORK(&s->memcg_params.deact_work, kmemcg_deactivate_workfn);
-	schedule_work(&s->memcg_params.deact_work);
+	queue_work(memcg_kmem_cache_wq, &s->memcg_params.deact_work);
 }
 
 /**
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
