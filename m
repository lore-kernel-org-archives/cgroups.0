From: Glauber Costa <glommer@openvz.org>
Subject: [PATCH v7 09/11] sched: record per-cgroup number of context switches
Date: Wed, 29 May 2013 15:03:20 +0400
Message-ID: <1369825402-31046-10-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org, Glauber Costa <glommer@openvz.org>

Context switches are, to this moment, a property of the runqueue. When
running containers, we would like to be able to present a separate
figure for each container (or cgroup, in this context).

The chosen way to accomplish this is to increment a per cfs_rq or
rt_rq, depending on the task, for each of the sched entities involved,
up to the parent. It is trivial to note that for the parent cgroup, we
always add 1 by doing this. Also, we are not introducing any hierarchy
walks in here. An already existent walk is reused.
There are, however, two main issues:

 1. the traditional context switch code only increment nr_switches when
 a different task is being inserted in the rq. Eventually, albeit not
 likely, we will pick the same task as before. Since for cfq and rt we
 only now which task will be next after the walk, we need to do the walk
 again, decrementing 1. Since this is by far not likely, it seems a fair
 price to pay.

 2. Those figures do not include switches from and to the idle or stop
 task. Those need to be recorded separately, which will happen in a
 follow up patch.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c  | 18 ++++++++++++++++++
 kernel/sched/rt.c    | 15 +++++++++++++--
 kernel/sched/sched.h |  3 +++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 414cf1c..b29e5dd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3642,6 +3642,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 		prev->sched_class->put_prev_task(rq, prev);
 
 	do {
+		if (likely(prev))
+			cfs_rq->nr_switches++;
 		se = pick_next_entity(cfs_rq);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
@@ -3651,6 +3653,22 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
 	if (hrtick_enabled(rq))
 		hrtick_start_fair(rq, p);
 
+	/*
+	 * This condition is extremely unlikely, and most of the time will just
+	 * consist of this unlikely branch, which is extremely cheap. But we
+	 * still need to have it, because when we first loop through cfs_rq's,
+	 * we can't possibly know which task we will pick. The call to
+	 * set_next_entity above is not meant to mess up the tree in this case,
+	 * so this should give us the same chain, in the same order.
+	 */
+	if (unlikely(p == prev)) {
+		se = &p->se;
+		for_each_sched_entity(se) {
+			cfs_rq = cfs_rq_of(se);
+			cfs_rq->nr_switches--;
+		}
+	}
+
 	return p;
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6c41fa1..894fc0b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1326,13 +1326,16 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	return next;
 }
 
-static struct task_struct *_pick_next_task_rt(struct rq *rq)
+static struct task_struct *
+_pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_rt_entity *rt_se;
 	struct task_struct *p;
 	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
+		if (likely(prev))
+			rt_rq->rt_nr_switches++;
 		rt_se = pick_next_rt_entity(rq, rt_rq);
 		BUG_ON(!rt_se);
 		rt_rq = group_rt_rq(rt_se);
@@ -1341,6 +1344,14 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	p = rt_task_of(rt_se);
 	p->se.exec_start = rq_clock_task(rq);
 
+	/* See fair.c for an explanation on this */
+	if (unlikely(p == prev)) {
+		for_each_sched_rt_entity(rt_se) {
+			rt_rq = rt_rq_of_se(rt_se);
+			rt_rq->rt_nr_switches--;
+		}
+	}
+
 	return p;
 }
 
@@ -1359,7 +1370,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	if (prev)
 		prev->sched_class->put_prev_task(rq, prev);
 
-	p = _pick_next_task_rt(rq);
+	p = _pick_next_task_rt(rq, prev);
 
 	/* The running task is never eligible for pushing */
 	if (p)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a39eb9b..39d3284 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -273,6 +273,7 @@ struct cfs_rq {
 	unsigned int nr_spread_over;
 #endif
 
+	u64 nr_switches;
 #ifdef CONFIG_SMP
 /*
  * Load-tracking only depends on SMP, FAIR_GROUP_SCHED dependency below may be
@@ -342,6 +343,8 @@ static inline int rt_bandwidth_enabled(void)
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned int rt_nr_running;
+	u64 rt_nr_switches;
+
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
-- 
1.8.1.4
