From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from
 pc->flags
Date: Fri, 13 Jan 2012 17:40:19 +0900
Message-ID: <20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120113173001.ee5260ca.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


From 1008e84d94245b1e7c4d237802ff68ff00757736 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Thu, 12 Jan 2012 15:53:24 +0900
Subject: [PATCH 3/7] memcg: remove PCG_MOVE_LOCK flag from pc->flags.

PCG_MOVE_LOCK bit is used for bit spinlock for avoiding race between
memcg's account moving and page state statistics updates.

Considering page-statistics update, very hot path, this lock is
taken only when someone is moving account (or PageTransHuge())
And, now, all moving-account between memcgroups (by task-move)
are serialized.

So, it seems too costly to have 1bit per page for this purpose.

This patch removes PCG_MOVE_LOCK and add hashed rwlock array
instead of it. This works well enough. Even when we need to
take the lock, we don't need to disable IRQ in hot path because
of using rwlock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/page_cgroup.h |   19 -----------
 mm/memcontrol.c             |   72 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index a2d1177..5dba799 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -8,7 +8,6 @@ enum {
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	/* flags for mem_cgroup and file and I/O status */
-	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	__NR_PCG_FLAGS,
 };
@@ -95,24 +94,6 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-static inline void move_lock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	/*
-	 * We know updates to pc->flags of page cache's stats are from both of
-	 * usual context or IRQ context. Disable IRQ to avoid deadlock.
-	 */
-	local_irq_save(*flags);
-	bit_spin_lock(PCG_MOVE_LOCK, &pc->flags);
-}
-
-static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	bit_spin_unlock(PCG_MOVE_LOCK, &pc->flags);
-	local_irq_restore(*flags);
-}
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9019069..61e276f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1338,6 +1338,65 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 	return false;
 }
 
+/*
+ * At moving acccounting information between cgroups, we'll have race with
+ * page satus accounting. To avoid that, we need some locks. In general,
+ * ading atomic ops to hot path is very bad. We're using 2 level logic.
+ *
+ * When a thread starts moving account information, per-cpu MEM_CGROUP_ON_MOVE
+ * value is set. If MEM_CGROUP_ON_MOVE==0, there are no race and page status
+ * update can be done withou any locks. If MEM_CGROUP_ON_MOVE>0, we use
+ * following hashed rwlocks.
+ * - At updating information, we hold rlock.
+ * - When a page is picked up and being moved, wlock is held.
+ *
+ * This logic works well enough because moving account is not an usual event.
+ */
+
+/*
+ * This rwlock is accessed only when MEM_CGROUP_ON_MOVE > 0.
+ */
+#define NR_MOVE_ACCOUNT_LOCKS	(NR_CPUS)
+#define move_account_hash(page) ((page_to_pfn(page) % NR_MOVE_ACCOUNT_LOCKS))
+static rwlock_t move_account_locks[NR_MOVE_ACCOUNT_LOCKS];
+
+static rwlock_t *__mem_cgroup_account_move_lock(struct page *page)
+{
+	int hnum = move_account_hash(page);
+
+	return &move_account_locks[hnum];
+}
+
+static void mem_cgroup_account_move_rlock(struct page *page)
+{
+	read_lock(__mem_cgroup_account_move_lock(page));
+}
+
+static void mem_cgroup_account_move_runlock(struct page *page)
+{
+	read_unlock(__mem_cgroup_account_move_lock(page));
+}
+
+static void mem_cgroup_account_move_wlock(struct page *page,
+		unsigned long *flags)
+{
+	write_lock_irqsave(__mem_cgroup_account_move_lock(page), *flags);
+}
+
+static void mem_cgroup_account_move_wunlock(struct page *page,
+		unsigned long flags)
+{
+	write_unlock_irqrestore(__mem_cgroup_account_move_lock(page), flags);
+}
+
+static  void mem_cgroup_account_move_lock_init(void)
+{
+	int num;
+
+	for (num = 0; num < NR_MOVE_ACCOUNT_LOCKS; num++)
+		rwlock_init(&move_account_locks[num]);
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1859,7 +1918,6 @@ void mem_cgroup_update_page_stat(struct page *page,
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	bool need_unlock = false;
-	unsigned long uninitialized_var(flags);
 
 	if (mem_cgroup_disabled())
 		return;
@@ -1871,7 +1929,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 	/* pc->mem_cgroup is unstable ? */
 	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
-		move_lock_page_cgroup(pc, &flags);
+		mem_cgroup_account_move_rlock(page);
 		need_unlock = true;
 		memcg = pc->mem_cgroup;
 		if (!memcg || !PageCgroupUsed(pc))
@@ -1894,7 +1952,7 @@ void mem_cgroup_update_page_stat(struct page *page,
 
 out:
 	if (unlikely(need_unlock))
-		move_unlock_page_cgroup(pc, &flags);
+		mem_cgroup_account_move_runlock(page);
 	rcu_read_unlock();
 	return;
 }
@@ -2457,8 +2515,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_MIGRATION))
+#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) |  (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2537,7 +2594,7 @@ static int mem_cgroup_move_account(struct page *page,
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
 		goto unlock;
 
-	move_lock_page_cgroup(pc, &flags);
+	mem_cgroup_account_move_wlock(page, &flags);
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2561,7 +2618,7 @@ static int mem_cgroup_move_account(struct page *page,
 	 * guaranteed that "to" is never removed. So, we don't check rmdir
 	 * status here.
 	 */
-	move_unlock_page_cgroup(pc, &flags);
+	mem_cgroup_account_move_wunlock(page, flags);
 	ret = 0;
 unlock:
 	unlock_page_cgroup(pc);
@@ -4938,6 +4995,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
 		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
+		mem_cgroup_account_move_lock_init();
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		memcg->use_hierarchy = parent->use_hierarchy;
-- 
1.7.4.1

