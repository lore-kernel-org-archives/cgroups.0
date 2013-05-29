From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 08/11] sched: Push put_prev_task() into pick_next_task()
Date: Wed, 29 May 2013 15:03:19 +0400
Message-ID: <1369825402-31046-9-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

In order to avoid having to do put/set on a whole cgroup hierarchy
when we context switch, push the put into pick_next_task() so that
both operations are in the same function. Further changes then allow
us to possibly optimize away redundant work.

[ glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org: incorporated mailing list feedback ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/core.c      | 20 +++++++-------------
 kernel/sched/fair.c      |  6 +++++-
 kernel/sched/idle_task.c |  6 +++++-
 kernel/sched/rt.c        | 27 ++++++++++++++++-----------
 kernel/sched/sched.h     |  8 +++++++-
 kernel/sched/stop_task.c |  5 ++++-
 6 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0fa0f87..3b1441f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2295,18 +2295,11 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *prev)
-{
-	if (prev->on_rq || rq->skip_clock_update < 0)
-		update_rq_clock(rq);
-	prev->sched_class->put_prev_task(rq, prev);
-}
-
 /*
  * Pick up the highest-prio task:
  */
 static inline struct task_struct *
-pick_next_task(struct rq *rq)
+pick_next_task(struct rq *rq, struct task_struct *prev)
 {
 	const struct sched_class *class;
 	struct task_struct *p;
@@ -2316,13 +2309,13 @@ pick_next_task(struct rq *rq)
 	 * the fair class we can call that function directly:
 	 */
 	if (likely(rq->nr_running == rq->cfs.h_nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
+		p = fair_sched_class.pick_next_task(rq, prev);
 		if (likely(p))
 			return p;
 	}
 
 	for_each_class(class) {
-		p = class->pick_next_task(rq);
+		p = class->pick_next_task(rq, prev);
 		if (p)
 			return p;
 	}
@@ -2417,8 +2410,9 @@ need_resched:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	put_prev_task(rq, prev);
-	next = pick_next_task(rq);
+	if (prev->on_rq || rq->skip_clock_update < 0)
+		update_rq_clock(rq);
+	next = pick_next_task(rq, prev);
 	clear_tsk_need_resched(prev);
 	rq->skip_clock_update = 0;
 
@@ -4395,7 +4389,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 		if (rq->nr_running == 1)
 			break;
 
-		next = pick_next_task(rq);
+		next = pick_next_task(rq, NULL);
 		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a7f5c39..414cf1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3628,7 +3628,8 @@ preempt:
 		set_last_buddy(se);
 }
 
-static struct task_struct *pick_next_task_fair(struct rq *rq)
+static struct task_struct *
+pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
@@ -3637,6 +3638,9 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	if (!cfs_rq->nr_running)
 		return NULL;
 
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index d8da010..4f0a332 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -33,8 +33,12 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 	resched_task(rq->idle);
 }
 
-static struct task_struct *pick_next_task_idle(struct rq *rq)
+static struct task_struct *
+pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
 	/* Trigger the post schedule to do an idle_enter for CFS */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4a21045..6c41fa1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1330,15 +1330,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
-	struct rt_rq *rt_rq;
-
-	rt_rq = &rq->rt;
-
-	if (!rt_rq->rt_nr_running)
-		return NULL;
-
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
+	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
@@ -1352,9 +1344,22 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+	struct rt_rq *rt_rq = &rq->rt;
+
+	if (!rt_rq->rt_nr_running)
+		return NULL;
+
+	if (rt_rq_throttled(rt_rq))
+		return NULL;
+
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
+	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
 	if (p)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0e5e795..a39eb9b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -987,7 +987,13 @@ struct sched_class {
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
-	struct task_struct * (*pick_next_task) (struct rq *rq);
+	/*
+	 * It is the responsibility of the pick_next_task() method that will
+	 * return the next task to call put_prev_task() on the @prev task or
+	 * something equivalent.
+	 */
+	struct task_struct * (*pick_next_task) (struct rq *rq,
+						struct task_struct *prev);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 4142d7e..6adf6a9 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -23,12 +23,15 @@ check_preempt_curr_stop(struct rq *rq, struct task_struct *p, int flags)
 	/* we're never preempted */
 }
 
-static struct task_struct *pick_next_task_stop(struct rq *rq)
+static struct task_struct *
+pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 {
 	struct task_struct *stop = rq->stop;
 
 	if (stop && stop->on_rq) {
 		stop->se.exec_start = rq_clock_task(rq);
+		if (prev)
+			prev->sched_class->put_prev_task(rq, prev);
 		return stop;
 	}
 
-- 
1.8.1.4
