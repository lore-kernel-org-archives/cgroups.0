From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 4/4] memcg: cleanup all typo in memory cgroup
Date: Mon, 25 Jun 2012 16:45:10 +0800
Message-ID: <1340613910-9629-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=BxUnQYlpX06oFYsEf3J9hvTS7UZC/CX20GVpYI//r1g=;
        b=RXfYYVqLKhYFPeAaURjfOL3+MHwTqK6vZqzD6Ld+G0XqIdsX0WaGNkn6E9rJ1FXEDH
         5BEPSGxOFaPcrFvc83X1VKmfmHQAqH62iiPTFtXMfzLSSbru3OQ0c+6j+cP4/0kzDxqS
         jfdXTAJ8H2KmGEgIS47m7H5FPIuQ4Gm+EzNMA7YQItSEI+yHMxATGtGNjla6hxDEwyoA
         ZNs6gXzuhv4ng/IuKYJ44ANj+yHQneBxIjVNxIpuW0+0v1PSzK6k4OrcEv7XSaSaBizt
         w+ImpyST30oJQA83bjSPsMxUKH2VY8hIlS2DzPoSFWmbPN/JhbEt8E4KxqQmcKCpjG7g
         N1YA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4520b57..d474bf6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -115,8 +115,8 @@ static const char * const mem_cgroup_events_names[] = {
 
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremated by the number of pages. This counter is used for
- * for trigger some periodic events. This is straightforward and better
+ * it will be incremented by the number of pages. This counter is used to
+ * trigger some periodic events. This is straightforward and better
  * than using jiffies etc. to handle periodic memcg event.
  */
 enum mem_cgroup_events_target {
@@ -667,7 +667,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
  * Both of vmstat[] and percpu_counter has threshold and do periodic
  * synchronization to implement "quick" read. There are trade-off between
  * reading cost and precision of value. Then, we may have a chance to implement
- * a periodic synchronizion of counter in memcg's counter.
+ * a periodic synchronization of counter in memcg's counter.
  *
  * But this _read() function is used for user interface now. The user accounts
  * memory usage by memory cgroup and he _always_ requires exact value because
@@ -677,7 +677,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
  *
  * If there are kernel internal actions which can make use of some not-exact
  * value, and reading all cpu value can be performance bottleneck in some
- * common workload, threashold and synchonization as vmstat[] should be
+ * common workload, threshold and synchonization as vmstat[] should be
  * implemented.
  */
 static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
@@ -1304,7 +1304,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
  *
  * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
  *			  under hierarchy of moving cgroups. This is for
- *			  waiting at hith-memory prressure caused by "move".
+ *			  waiting at hit-memory pressure caused by "move".
  */
 
 static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
@@ -1597,7 +1597,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 /*
  * Check all nodes whether it contains reclaimable pages or not.
  * For quick scan, we make use of scan_nodes. This will allow us to skip
- * unused nodes. But scan_nodes is lazily updated and may not cotain
+ * unused nodes. But scan_nodes is lazily updated and may not contain
  * enough new information. We need to do double check.
  */
 static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
@@ -2211,7 +2211,6 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		return CHARGE_RETRY;
 
-	/* If we don't need to call oom-killer at el, return immediately */
 	if (!oom_check)
 		return CHARGE_NOMEM;
 	/* check OOM */
@@ -2289,7 +2288,7 @@ again:
 		 * In that case, "memcg" can point to root or p can be NULL with
 		 * race with swapoff. Then, we have small risk of mis-accouning.
 		 * But such kind of mis-account by race always happens because
-		 * we don't have cgroup_mutex(). It's overkill and we allo that
+		 * we don't have cgroup_mutex(). It's overkill and we allow that
 		 * small race, here.
 		 * (*) swapoff at el will charge against mm-struct not against
 		 * task-struct. So, mm->owner can be NULL.
@@ -2303,7 +2302,7 @@ again:
 		}
 		if (nr_pages == 1 && consume_stock(memcg)) {
 			/*
-			 * It seems dagerous to access memcg without css_get().
+			 * It seems dangerous to access memcg without css_get().
 			 * But considering how consume_stok works, it's not
 			 * necessary. If consume_stock success, some charges
 			 * from this memcg are cached on this cpu. So, we
@@ -2394,7 +2393,7 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
 }
 
 /*
- * Cancel chrages in this cgroup....doesn't propagate to parent cgroup.
+ * Cancel charges in this cgroup....doesn't propagate to parent cgroup.
  * This is useful when moving usage to parent cgroup.
  */
 static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
@@ -3208,7 +3207,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 		 * C)
 		 * The "old" page is under lock_page() until the end of
 		 * migration, so, the old page itself will not be swapped-out.
-		 * If the new page is swapped out before end_migraton, our
+		 * If the new page is swapped out before end_migration, our
 		 * hook to usual swap-out path will catch the event.
 		 */
 		if (PageAnon(page))
-- 
1.7.9.5
