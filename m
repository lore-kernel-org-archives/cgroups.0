From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 6/7] sched/fair: throttle task runtime based on cpu.headroom
Date: Mon, 8 Apr 2019 14:45:38 -0700
Message-ID: <20190408214539.2705660-7-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=OO9TirhM3pC6EEM2ULmWIFa5L79pomgcK4+Z3m72rLA=;
 b=o0fkawdqF2jtGf4hnMQsOuOcL+MUhUG66Oo/zmF+rUKp8btKYu1MEcals4hNlWUBP8r4
 w5YgZbTGEeUM0zN/xDpA1LjqIBW7YHvK/LGuYOWFJDZwxOrkVlMqsfNVI50m1BqTqqj9
 QDhQBIaChgGkfNYfTU62n//JhBv8R0s8eew= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch enables task runtime throttling based on cpu.headroom setting.
The throttling leverages the same mechanism of the cpu.max knob. Task
groups with non-zero target_idle get throttled.

In __refill_cfs_bandwidth_runtime(), global idleness measured by function
cfs_global_idleness_update() is compared against target_idle of the task
group. If the measured idleness is lower than the target, runtime of this
task group is reduced to min_runtime.

A new variable "prev_runtime" is added to struct cfs_bandwidth, so that
the new runtime could be adjust accordingly.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/sched/fair.c  | 69 +++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h |  4 +++
 2 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 49c68daffe7e..3b0535cda7cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4331,6 +4331,16 @@ static inline u64 sched_cfs_bandwidth_slice(void)
 	return (u64)sysctl_sched_cfs_bandwidth_slice * NSEC_PER_USEC;
 }
 
+static inline bool cfs_bandwidth_throttling_on(struct cfs_bandwidth *cfs_b)
+{
+	return cfs_b->quota != RUNTIME_INF || cfs_b->target_idle != 0;
+}
+
+static inline u64 cfs_bandwidth_pct_to_ns(u64 period, unsigned long pct)
+{
+	return div_u64(period * num_online_cpus() * pct, 100) >> FSHIFT;
+}
+
 /*
  * Replenish runtime according to assigned quota and update expiration time.
  * We use sched_clock_cpu directly instead of rq->clock to avoid adding
@@ -4340,9 +4350,12 @@ static inline u64 sched_cfs_bandwidth_slice(void)
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
+	/* runtimes in nanoseconds */
+	u64 idle_time, target_idle_time, max_runtime, min_runtime;
+	unsigned long idle_pct;
 	u64 now;
 
-	if (cfs_b->quota == RUNTIME_INF)
+	if (!cfs_bandwidth_throttling_on(cfs_b))
 		return;
 
 	now = sched_clock_cpu(smp_processor_id());
@@ -4353,7 +4366,49 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	if (cfs_b->target_idle == 0)
 		return;
 
-	cfs_global_idleness_update(now, cfs_b->period);
+	/*
+	 * max_runtime is the maximal possible runtime for given
+	 * target_idle and quota. In other words:
+	 *     max_runtime = min(quota,
+	 *                       total_time * (100% - target_idle))
+	 */
+	max_runtime = min_t(u64, cfs_b->quota,
+			    cfs_bandwidth_pct_to_ns(cfs_b->period,
+						    (100 << FSHIFT) - cfs_b->target_idle));
+	idle_pct = cfs_global_idleness_update(now, cfs_b->period);
+
+	/*
+	 * Throttle runtime if idle_pct is less than target_idle:
+	 *     idle_pct < cfs_b->target_idle
+	 *
+	 * or if the throttling is on in previous period:
+	 *     max_runtime != cfs_b->prev_runtime
+	 */
+	if (idle_pct < cfs_b->target_idle ||
+	    max_runtime != cfs_b->prev_runtime) {
+		idle_time = cfs_bandwidth_pct_to_ns(cfs_b->period, idle_pct);
+		target_idle_time = cfs_bandwidth_pct_to_ns(cfs_b->period,
+							   cfs_b->target_idle);
+
+		/* minimal runtime to avoid starving */
+		min_runtime = max_t(u64, min_cfs_quota_period,
+				    cfs_bandwidth_pct_to_ns(cfs_b->period,
+							    cfs_b->min_runtime));
+		if (cfs_b->prev_runtime + idle_time < target_idle_time) {
+			cfs_b->runtime = min_runtime;
+		} else {
+			cfs_b->runtime = cfs_b->prev_runtime + idle_time -
+				target_idle_time;
+			if (cfs_b->runtime > max_runtime)
+				cfs_b->runtime = max_runtime;
+			if (cfs_b->runtime < min_runtime)
+				cfs_b->runtime = min_runtime;
+		}
+	} else {
+		/* no need for throttling */
+		cfs_b->runtime = max_runtime;
+	}
+	cfs_b->prev_runtime = cfs_b->runtime;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -4382,7 +4437,7 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
 
 	raw_spin_lock(&cfs_b->lock);
-	if (cfs_b->quota == RUNTIME_INF)
+	if (!cfs_bandwidth_throttling_on(cfs_b))
 		amount = min_amount;
 	else {
 		start_cfs_bandwidth(cfs_b);
@@ -4690,7 +4745,7 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun, u
 	int throttled;
 
 	/* no need to continue the timer with no bandwidth constraint */
-	if (cfs_b->quota == RUNTIME_INF)
+	if (!cfs_bandwidth_throttling_on(cfs_b))
 		goto out_deactivate;
 
 	throttled = !list_empty(&cfs_b->throttled_cfs_rq);
@@ -4806,7 +4861,7 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 		return;
 
 	raw_spin_lock(&cfs_b->lock);
-	if (cfs_b->quota != RUNTIME_INF &&
+	if (cfs_bandwidth_throttling_on(cfs_b) &&
 	    cfs_rq->runtime_expires == cfs_b->runtime_expires) {
 		cfs_b->runtime += slack_runtime;
 
@@ -4854,7 +4909,7 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 		return;
 	}
 
-	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice)
+	if (cfs_bandwidth_throttling_on(cfs_b) && cfs_b->runtime > slice)
 		runtime = cfs_b->runtime;
 
 	expires = cfs_b->runtime_expires;
@@ -5048,7 +5103,7 @@ static void __maybe_unused update_runtime_enabled(struct rq *rq)
 		struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 		raw_spin_lock(&cfs_b->lock);
-		cfs_rq->runtime_enabled = cfs_b->quota != RUNTIME_INF;
+		cfs_rq->runtime_enabled = cfs_bandwidth_throttling_on(cfs_b);
 		raw_spin_unlock(&cfs_b->lock);
 	}
 	rcu_read_unlock();
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9309bf05ff0c..92e8a824c6fe 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -338,6 +338,7 @@ extern struct list_head task_groups;
 
 #ifdef CONFIG_CFS_BANDWIDTH
 extern void cfs_bandwidth_has_tasks_changed_work(struct work_struct *work);
+extern const u64 min_cfs_quota_period;
 #endif
 
 struct cfs_bandwidth {
@@ -370,6 +371,9 @@ struct cfs_bandwidth {
 	/* work_struct to adjust settings asynchronously */
 	struct work_struct	has_tasks_changed_work;
 
+	/* runtime assigned to previous period */
+	u64			prev_runtime;
+
 	short			idle;
 	short			period_active;
 	struct hrtimer		period_timer;
-- 
2.17.1

