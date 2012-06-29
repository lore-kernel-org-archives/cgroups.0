From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch 5/5] mm, memcg: move all oom handling to memcontrol.c
Date: Fri, 29 Jun 2012 14:07:01 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206291406270.6040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com> <alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=fojq8+YprCuqiKPrweO6fgThxuxW4eth+LVw+gyFfwM=;
        b=TBCZ0gRihTezv5/0QpbMzJih8VOdt9Q0fELiAUrp7CgiDXm/nFsUD2RSanJZ9ebK+E
         Fia6WUJGhFCNztNldugyEaf8kSJ/13CBaKTa0NXcqZQTlidBvl9d9vC9fNJ9JM0ySh+h
         PDjG6mF4epPCtiT3ElnGg6HY0CTmpwutEcMGwY0rMjsz8qzl8TsU4TIDMsL9zharvOum
         2qGtGqsByclRmWCTVISfIMwS08MD1fBbA0w1sotlYmQDTg6K3HHhf6CVZwj6gEfzqP3N
         YBa+HKWWwMxtmrtQ+H6tYCf3cTttzLtdG14JLxQqRHwCBhXqtOOEYS+Z1Ix1BsCpU05z
         RFkw==
In-Reply-To: <alpine.DEB.2.00.1206291404530.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

By globally defining check_panic_on_oom(), the memcg oom handler can be
moved entirely to mm/memcontrol.c.  This removes the ugly #ifdef in the
oom killer and cleans up the code.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> 
---
 include/linux/memcontrol.h |    2 --
 include/linux/oom.h        |    3 +++
 mm/memcontrol.c            |   15 +++++++++++++--
 mm/oom_kill.c              |   23 ++---------------------
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -180,8 +180,6 @@ static inline void mem_cgroup_dec_page_stat(struct page *page,
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
-extern void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				       int order);
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/oom.h b/include/linux/oom.h
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -61,6 +61,9 @@ extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
+extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			       int order, const nodemask_t *nodemask);
+
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1469,8 +1469,8 @@ static u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
 	return min(limit, memsw);
 }
 
-void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				int order)
+void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			      int order)
 {
 	struct mem_cgroup *iter;
 	unsigned long chosen_points = 0;
@@ -1478,6 +1478,17 @@ void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
+	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_thread_flag(TIF_MEMDIE);
+		return;
+	}
+
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct cgroup *cgroup = iter->css.cgroup;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -554,8 +554,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-				int order, const nodemask_t *nodemask)
+void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
+			int order, const nodemask_t *nodemask)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -573,25 +573,6 @@ static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			      int order)
-{
-	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
-	 */
-	if (fatal_signal_pending(current)) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
-	__mem_cgroup_out_of_memory(memcg, gfp_mask, order);
-}
-#endif
-
 static BLOCKING_NOTIFIER_HEAD(oom_notify_list);
 
 int register_oom_notifier(struct notifier_block *nb)
