From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: remove memcg_kmem_skip_account
Date: Tue, 18 Sep 2018 17:45:01 -0700
Message-ID: <20180919004501.178023-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dPLvabeEu2R5NLjbgna2in9ApyNxHhQTFLi6gYIcZD0=;
        b=D9KTvBvrrAn23w6+nsWFdBhh5C7g8llWsnMC/BzXW0nGAXspOy4e9BubHJLItqLxt5
         nbZlHvMY08B0mvPSdc/43Vf21U8YDgbIBpJBLb+PA7eg03ur18PwVxfnbekEvNqXyK6m
         zKYVbVPRC4QTO3I+KOQ2NESTqBDI5VgcuP+/ocHFqQzGJfiR2Jfr/n4iXqS1xacLOskx
         BXLhnwKFNv5XEYvMkiU+FgdtXU2sg8RkXl9XNKHdl+DnQFvnfRhSlZRxAzLerEvninOv
         sdO2jN0nCRQJeKEGCDI6500p8Ca3xckLP6psNtZBY0Ag9FR1m0VYeviPkbi+MxKiNwDS
         eDyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The flag memcg_kmem_skip_account was added during the era of opt-out
kmem accounting. There is no need for such flag in the opt-in world as
there aren't any __GFP_ACCOUNT allocations within
memcg_create_cache_enqueue().

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/sched.h |  3 ---
 mm/memcontrol.c       | 24 +-----------------------
 2 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 977cb57d7bc9..c30e3cd4b81c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -723,9 +723,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_MEMCG
 	unsigned			in_user_fault:1;
-#ifdef CONFIG_MEMCG_KMEM
-	unsigned			memcg_kmem_skip_account:1;
-#endif
 #endif
 #ifdef CONFIG_COMPAT_BRK
 	unsigned			brk_randomized:1;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e79cb59552d9..bde698a0bb99 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2460,7 +2460,7 @@ static void memcg_kmem_cache_create_func(struct work_struct *w)
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
  */
-static void __memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
+static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 					       struct kmem_cache *cachep)
 {
 	struct memcg_kmem_cache_create_work *cw;
@@ -2478,25 +2478,6 @@ static void __memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
 	queue_work(memcg_kmem_cache_wq, &cw->work);
 }
 
-static void memcg_schedule_kmem_cache_create(struct mem_cgroup *memcg,
-					     struct kmem_cache *cachep)
-{
-	/*
-	 * We need to stop accounting when we kmalloc, because if the
-	 * corresponding kmalloc cache is not yet created, the first allocation
-	 * in __memcg_schedule_kmem_cache_create will recurse.
-	 *
-	 * However, it is better to enclose the whole function. Depending on
-	 * the debugging options enabled, INIT_WORK(), for instance, can
-	 * trigger an allocation. This too, will make us recurse. Because at
-	 * this point we can't allow ourselves back into memcg_kmem_get_cache,
-	 * the safest choice is to do it like this, wrapping the whole function.
-	 */
-	current->memcg_kmem_skip_account = 1;
-	__memcg_schedule_kmem_cache_create(memcg, cachep);
-	current->memcg_kmem_skip_account = 0;
-}
-
 static inline bool memcg_kmem_bypass(void)
 {
 	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
@@ -2531,9 +2512,6 @@ struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
 	if (memcg_kmem_bypass())
 		return cachep;
 
-	if (current->memcg_kmem_skip_account)
-		return cachep;
-
 	memcg = get_mem_cgroup_from_current();
 	kmemcg_id = READ_ONCE(memcg->kmemcg_id);
 	if (kmemcg_id < 0)
-- 
2.19.0.397.gdd90340f6a-goog

