From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH v3] memcg: return -EINTR at bypassing try_charge().
Date: Wed, 21 Dec 2011 19:29:34 +0900
Message-ID: <20111221192934.2751f8f1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111219165146.4d72f1bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20111221172423.5d036cdd.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111221172423.5d036cdd.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you for review.
I'm sorry if my response is delayed.
==
From 1e8c917c64b3947d2e54c6e5073d53d80bd97c30 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Wed, 21 Dec 2011 16:27:25 +0900
Subject: [PATCH] memcg: return -EINTR at bypassing try_charge().

This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch
When running testprogram and stop it by Ctrl-C, add_lru/del_lru
will find pc->mem_cgroup is NULL and get panic. The reason
is bypass code in try_charge().

At try_charge(), it checks the thread is fatal or not as..
fatal_signal_pending() or TIF_MEMDIE. In this case, __try_charge()
returns 0(success) with setting *ptr as NULL.

Now, lruvec are deteremined by pc->mem_cgroup. So, it's better
to reset pc->mem_cgroup as root_mem_cgroup. This patch does
following change in try_charge()
  1. return -EINTR at bypassing.
  2. set *ptr = root_mem_cgroup at bypassing.

By this change, in page fault / radix-tree-insert path,
the page will be charged against root_mem_cgroup and the thread's
operations will go ahead without trouble. In other path,
migration or move_account etc..., -EINTR will stop the operation.
(may need some cleanup later..)

After this change, pc->mem_cgroup will have valid pointer if
the page is used.

Changelog: v2 -> v3
 - handle !mm case in another way.
 - removed redundant commments
 - fixed move_parent bug of uninitialized pointer
Changelog: v1 -> v2
 - returns -EINTR at bypassing.
 - change error code handling at callers.
 - changed the name of patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9175097..5f78c99 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2185,6 +2185,24 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 }
 
 /*
+ * __mem_cgroup_try_charge() does
+ * 1. detect memcg to be charged against from passed *mm and *ptr,
+ * 2. update res_counter
+ * 3. call memory reclaim if necessary.
+ *
+ * In some special case, if the task is fatal, fatal_signal_pending() or
+ * TIF_MEMDIE, this functoion returns -EINTR with filling *ptr as
+ * root_mem_cgroup. There are 2 reasons for this. 1st is that
+ * fatal threads should quit as soon as possible without any hazards.
+ * 2nd is that all page should have valid pc->mem_cgroup if it will be
+ * used. If mm is NULL and the caller doesn't pass valid memcg pointer,
+ * that's treated as charge to root_mem_cgroup.
+ *
+ * So, try_charge will return
+ *  0       ...  at success. filling *ptr with a valid memcg pointer.
+ *  -ENOMEM ...  charge failure because of resource limits.
+ *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
+ *
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
  */
@@ -2215,7 +2233,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
-		goto bypass;
+		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -2316,8 +2334,8 @@ nomem:
 	*ptr = NULL;
 	return -ENOMEM;
 bypass:
-	*ptr = NULL;
-	return 0;
+	*ptr = root_mem_cgroup;
+	return -EINTR;
 }
 
 /*
@@ -2583,7 +2601,7 @@ static int mem_cgroup_move_parent(struct page *page,
 
 	parent = mem_cgroup_from_cont(pcg);
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret || !parent)
+	if (ret)
 		goto put_back;
 
 	if (nr_pages > 1)
@@ -2630,9 +2648,8 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 
 	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
-	if (ret || !memcg)
+	if (ret == -ENOMEM)
 		return ret;
-
 	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
 	return 0;
 }
@@ -2743,11 +2760,16 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
 	css_put(&memcg->css);
+	if (ret == -EINTR)
+		ret = 0;
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	if (ret == -EINTR)
+		ret = 0;
+	return ret;
 }
 
 static void
@@ -3205,7 +3227,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, memcgp, false);
 	css_put(&memcg->css);/* drop extra refcnt */
-	if (ret || *memcgp == NULL) {
+	if (ret) {
 		if (PageAnon(page)) {
 			lock_page_cgroup(pc);
 			ClearPageCgroupMigration(pc);
@@ -3215,6 +3237,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 			 */
 			mem_cgroup_uncharge_page(page);
 		}
+		/* we'll need to revisit this error code (we have -EINTR) */
 		return -ENOMEM;
 	}
 	/*
@@ -3633,7 +3656,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM || ret == -EINTR)
 			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
@@ -5091,9 +5114,9 @@ one_by_one:
 		}
 		ret = __mem_cgroup_try_charge(NULL,
 					GFP_KERNEL, 1, &memcg, false);
-		if (ret || !memcg)
+		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
-			return -ENOMEM;
+			return ret;
 		mc.precharge++;
 	}
 	return ret;
-- 
1.7.4.1

