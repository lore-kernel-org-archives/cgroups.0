From: zgpeng.linux@gmail.com
Subject: [PATCH] oom: choose a more suitable process to kill while all processes are not killable
Date: Fri, 20 Dec 2019 14:26:12 +0800
Message-ID: <1576823172-25943-1-git-send-email-zgpeng.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sLQwYn83trd9XP0m0VSg2ROtVjHj/MiokIdaMbs0cVg=;
        b=P/w4T7YlmdltPydFyxnyFx8IP3iRFTt6ngWTIipJ8X9+t5RdFUxp0GmzwR1y8cFoil
         0Un/ojBgwFRQxx3bN0PrWfAWJnbYKK2RbXFj0gs2mIC5ZTQmbP8wDEnZYR4R3UF3Bven
         LDChDt+bkb1McC8Dypn3T53eBELy4Oc523i8oTZpCdB2Z/JniO0d7xSON9wNI7wLMtp8
         AVmUWj/t0Xnt5gKGC4ECIybmU5CaUf9itm+km1cb8eFHxzuDbf99lhtW7PjtYqSbFxco
         DUTK3lDOAjFLXYfhLdmE0mvzLW9ssveAi0aExIyEyF7Az6gntHBK8UUXAAASFni9YFC5
         XIug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, shakeelb@google.com
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, zgpeng <zgpeng@tencent.com>

From: zgpeng <zgpeng@tencent.com>

It has been found in multiple business scenarios that when a oom occurs
in a cgroup, the process that consumes the most memory in the cgroup is 
not killed first. Analysis of the reasons found that each process in the
cgroup oom_score_adj is set to -998, oom_badness in the calculation of 
points, if points is negative, uniformly set it to 1. For these processes 
that should not be killed, the kernel does not distinguish which process 
consumes the most memory. As a result, there is a phenomenon that a 
process with low memory consumption may be killed first. In addition, 
when the memory is large, even if oom_score_adj is not set so small, 
such as -1, there will be similar problems.

Based on the scenario mentioned above, the existing oom killer can be 
optimized. In this patch, oom_badness is optimized so that when points 
are negative, it can also distinguish which process consumes the most 
memory. Therefore, when oom occurs, the process with the largest memory 
consumption can be killed first.

Signed-off-by: zgpeng <zgpeng@tencent.com>
---
 drivers/tty/sysrq.c |  1 +
 fs/proc/base.c      |  6 ++++--
 include/linux/oom.h |  4 ++--
 mm/memcontrol.c     |  1 +
 mm/oom_kill.c       | 21 +++++++++------------
 mm/page_alloc.c     |  1 +
 6 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 573b205..1fe79d9 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -367,6 +367,7 @@ static void moom_callback(struct work_struct *ignored)
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = -1,
+		.chosen_points = LONG_MIN,
 	};
 
 	mutex_lock(&oom_lock);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ebea950..2c7c4e0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -548,9 +548,11 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long totalpages = totalram_pages() + total_swap_pages;
-	unsigned long points = 0;
+	long points = 0;
 
-	points = oom_badness(task, totalpages) * 1000 / totalpages;
+	points = oom_badness(task, totalpages);
+	points = points > 0 ? points : 1;
+	points = points * 1000 / totalpages;
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
diff --git a/include/linux/oom.h b/include/linux/oom.h
index c696c26..2d2b898 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -48,7 +48,7 @@ struct oom_control {
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
-	unsigned long chosen_points;
+	long chosen_points;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -107,7 +107,7 @@ static inline vm_fault_t check_stable_address_space(struct mm_struct *mm)
 
 bool __oom_reap_task_mm(struct mm_struct *mm);
 
-extern unsigned long oom_badness(struct task_struct *p,
+extern long oom_badness(struct task_struct *p,
 		unsigned long totalpages);
 
 extern bool out_of_memory(struct oom_control *oc);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74..73e2381 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1563,6 +1563,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.chosen_points = LONG_MIN,
 	};
 	bool ret;
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 71e3ace..160f364 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -195,17 +195,17 @@ static bool is_dump_unreclaim_slabs(void)
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	long points;
 	long adj;
 
 	if (oom_unkillable_task(p))
-		return 0;
+		return LONG_MIN;
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return 0;
+		return LONG_MIN;
 
 	/*
 	 * Do not even consider tasks which are explicitly marked oom
@@ -217,7 +217,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 			test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
 			in_vfork(p)) {
 		task_unlock(p);
-		return 0;
+		return LONG_MIN;
 	}
 
 	/*
@@ -232,11 +232,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 	adj *= totalpages / 1000;
 	points += adj;
 
-	/*
-	 * Never return 0 for an eligible task regardless of the root bonus and
-	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
-	 */
-	return points > 0 ? points : 1;
+	return points;
 }
 
 static const char * const oom_constraint_text[] = {
@@ -309,7 +305,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -335,12 +331,12 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	 * killed first if it triggers an oom, then select it.
 	 */
 	if (oom_task_origin(task)) {
-		points = ULONG_MAX;
+		points = LONG_MAX;
 		goto select;
 	}
 
 	points = oom_badness(task, oc->totalpages);
-	if (!points || points < oc->chosen_points)
+	if (points == LONG_MIN || points < oc->chosen_points)
 		goto next;
 
 select:
@@ -1126,6 +1122,7 @@ void pagefault_out_of_memory(void)
 		.memcg = NULL,
 		.gfp_mask = 0,
 		.order = 0,
+		.chosen_points = LONG_MIN,
 	};
 
 	if (mem_cgroup_oom_synchronize(true))
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4785a8a..63ccb2a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3797,6 +3797,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.chosen_points = LONG_MIN,
 	};
 	struct page *page;
 
-- 
1.8.3.1

