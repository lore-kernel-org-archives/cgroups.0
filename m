From: Balasubramani Vivekanandan <balu252-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: print cgroup information when system panics due to panic_on_oom
Date: Fri,  6 Mar 2015 15:09:29 +0530
Message-ID: <1425634769-21340-1-git-send-email-balasubramani_vivekanandan@mentor.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=vLA60GCleZ1OOgZQQK27STb21098swN2g7LT6YqYVxI=;
        b=H8BLBRp71DiRFLTUxn3NUFDx2fdOvfE0LL5VQMBDeyRKl44/U0HKmA/jtCcRm12vuN
         pVjMYZS57mmxYMbovKIPhDKq+4yO+Fkvwvi/lh7Qs2Xa9hW4Dk1oXJXYOM5PQeSwEPSm
         sqd2v+az4ZqY7Ys3TXXf+PJFe+KjezkTG+ww+XwvhrEGBaUQDzZICjiypFDjMQFaVUsc
         7PfLjwh5bq4KppGwexXkWOFvExkcKbtqgLDBivp9SPe8jjLguR3kmJlgyLFcoRNJZv/l
         ie7/GFCKN55NTw1GpbN1/OQu3TvItE3Jth3BCFbNABilptSM6Ab85EgFqU25cSqAmyhE
         LtwQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

If panic_on_oom=2, then there was no cgroup information printed,
if system panics due of cgroup memory limit reached. Information is
only printed when configured to kill task. This patch prints
information of the cgroup whose limit triggerred panic

Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
---
 include/linux/oom.h |  3 ++-
 mm/memcontrol.c     | 21 ++++++++++++---------
 mm/oom_kill.c       |  7 ++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index d5771bed..44b2f6f 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -66,7 +66,8 @@ extern bool oom_zonelist_trylock(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-			       int order, const nodemask_t *nodemask);
+			       int order, const nodemask_t *nodemask,
+			       struct mem_cgroup *memcg);
 
 extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c86945..d026778 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1442,17 +1442,20 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 	struct mem_cgroup *iter;
 	unsigned int i;
 
-	if (!p)
-		return;
-
 	mutex_lock(&oom_info_lock);
 	rcu_read_lock();
 
-	pr_info("Task in ");
-	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
-	pr_cont(" killed as a result of limit of ");
-	pr_cont_cgroup_path(memcg->css.cgroup);
-	pr_cont("\n");
+	if (p) {
+		pr_info("Task in ");
+		pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
+		pr_cont(" killed as a result of limit of ");
+		pr_cont_cgroup_path(memcg->css.cgroup);
+		pr_cont("\n");
+	} else {
+		pr_info("Memory limit reached of cgroup ");
+		pr_cont_cgroup_path(memcg->css.cgroup);
+		pr_cont("\n");
+	}
 
 	rcu_read_unlock();
 
@@ -1537,7 +1540,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		return;
 	}
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL, memcg);
 	totalpages = mem_cgroup_get_limit(memcg) ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 642f38c..52628c8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -612,7 +612,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
 void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-			int order, const nodemask_t *nodemask)
+			int order, const nodemask_t *nodemask,
+			struct mem_cgroup *memcg)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -625,7 +626,7 @@ void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
-	dump_header(NULL, gfp_mask, order, NULL, nodemask);
+	dump_header(NULL, gfp_mask, order, memcg, nodemask);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
 }
@@ -740,7 +741,7 @@ static void __out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
 						&totalpages);
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
-	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
+	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask, NULL);
 
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-- 
2.3.1
