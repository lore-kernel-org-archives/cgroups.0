From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 3/5] record nr_switches per task_group
Date: Mon,  9 Apr 2012 19:25:13 -0300
Message-ID: <1334010315-4453-4-git-send-email-glommer@parallels.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334010315-4453-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

In the interest of providing a per-cgroup figure of common statistics,
this patch adds a nr_switches counter to each group runqueue (both cfs
and rt).

To avoid impact on schedule(), we don't walk the tree at stat gather
time. This is because schedule() is called much more frequently than
the tick functions, in which we do walk the tree.

When this figure needs to be read (different patch), we will
aggregate them at read time.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/sched/core.c  |   32 ++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    3 +++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1cfb7f0..1ee3772 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3168,6 +3168,37 @@ pick_next_task(struct rq *rq)
 }
 
 /*
+ * For all other data, we do a tree walk at the time of
+ * gathering. We want, however, to minimize the impact over schedule(),
+ * because... well... it's schedule().
+ *
+ * Therefore we only gather for the current cgroup, and walk the tree
+ * at read time
+ */
+static void update_switches_task_group(struct rq *rq,
+				       struct task_struct *prev,
+				       struct task_struct *next)
+{
+#ifdef CONFIG_CGROUP_SCHED
+	int cpu = cpu_of(rq);
+
+	if (rq->curr_tg == &root_task_group)
+		goto out;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (prev->sched_class == &fair_sched_class)
+		rq->curr_tg->cfs_rq[cpu]->nr_switches++;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (prev->sched_class == &rt_sched_class)
+		rq->curr_tg->rt_rq[cpu]->nr_switches++;
+#endif
+out:
+	rq->curr_tg = task_group(next);
+#endif
+}
+
+/*
  * __schedule() is the main scheduler function.
  */
 static void __sched __schedule(void)
@@ -3230,6 +3261,7 @@ need_resched:
 		rq->curr = next;
 		++*switch_count;
 
+		update_switches_task_group(rq, prev, next);
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * The context switch have flipped the stack from under us
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b8bcd147..3b300f3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -224,6 +224,7 @@ struct cfs_rq {
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
+	u64 nr_switches;
 
 	/*
 	 * leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
@@ -307,6 +308,7 @@ struct rt_rq {
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
+	u64 nr_switches;
 #endif
 };
 
@@ -389,6 +391,7 @@ struct rq {
 	unsigned long nr_uninterruptible;
 
 	struct task_struct *curr, *idle, *stop;
+	struct task_group *curr_tg;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-- 
1.7.7.6
