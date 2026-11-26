Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655358;
	b=z6X7udbVN7V5YO8qIukMT+wGizweCQBgMvcmlR2VFOlW9iJfZ1fcag4/3K0NSzz3J6IG
	 oOygDxp3in4MBMOtifUB/9soVsc9eof5pwoSXdE9pNQ2evc2TtShMKV1ApqUhYxDp6dnL
	 dxThK+KSCnK2knC0HuFDRiGEbtSw27ZxfOVsJhkxTtKl76ztc6n76I3LvkyYeiKJJCkhN
	 BS7BGVooa+JC0cxYkbcRUiaZAxX0pUNmR497RUfheKh3QNrY8jjbDZX4rNNAsWJjhcL8V
	 KV1gVzWCXky5xZ/IKwFWmSQ4i7XjjK4F8B2BIwyCagWAccQKtbtk0plTtz4/Xk8wM2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655358;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/7DGZc9u2Pq0khCGQogo8TD7LvmExPSD6UcKJY5V7lo=;
	b=m7M0IUvgiMz0kXCvggZfA4pU0orqfGlAmNKUQjhcqp+tm917ePizHca54AJHPkSJyzXw
	 pzrETm/0poBqQrb8oj4TmQk/nQDTWiCPVH9lE5309MkV+YY4VNIlD8wbfo53VRBdFRIqP
	 /Q5+xcu3l/8fRZuHhLx0yyaFJP+HVetUdwBtiGZAAX2N+nrfNqshecTUylvtwrs8EPgY3
	 AfoCzG295qaj1Oghc4B1yn/wIVZ5JR7d+Wb4FQ4xCgmdM4a0BMlYZhjjvwNgTtbtJIipz
	 Qp3ZWEz9uchJFPUSiyWHUEQZLjQSAERqcKQQ2s0INuP7Rb0OBSouDGUqjviToBXvHvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZOX9f8oo;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7349606BA05;
	Thu, 26 Nov 2026 01:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7349606BA05
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZOX9f8oo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655356;
	bh=/7DGZc9u2Pq0khCGQogo8TD7LvmExPSD6UcKJY5V7lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOX9f8oo/lR2bOOjb5R/bvE/ehEbNSqnXhkremLfjiX8yZfaigmdlXEt9ESmhby6T
	 4xeZ2HT4xJdz2mfqy6gJ685YIf9Spmg/9tzfVGkj0WPx8Tj9ndfkPLnwd4ay7F7zfJ
	 u+IyRRxDCWy8I+fNiun1ifZ4VWdswUdeugj/V3xrfyDCSxYKIFp8wVpI4WVwVRyfHl
	 n3uC9HOLQP0r3i/b1bnpRf6dVV+u6bgSQUi2Q2jtErvOFWxeXJqyqkN3MpbqPsrQck
	 VvMrobNANfh0JbhLIqk4CB2Kxiov0aZA0KtQrlIjSChY9mOtoIQE4Mz/F71v+H7fFA
	 KDcZt82KVulYA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjm23rqzWB2;
	Wed, 25 Nov 2026 20:09:16 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	tommaso.cucinotta@gmail.com,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v11 39/43] sched/deadline: Boost an owner throttled after its waiter blocked
Date: Wed, 25 Nov 2026 20:08:38 -0500
Message-ID: <b9677397c26740470f13803d6b34bbeaee179e4a.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"sched/deadline: Boost an owner that cannot run on its own reservation"
boosts a throttled owner when a waiter blocks, leaves or changes. But
the owner can be throttled after its waiter blocked:
- its runtime runs out;
- an enqueue throttles it in its constrained gap;
- sched_setattr() throttles it until it repays its debt.
Nothing calls rt_mutex_setprio() then. The waiter waits for the owner's
next period, and can miss its own deadline.

Fix this by asking for a boost at these throttles, with the new
dl_request_owner_boost(). rt_mutex_setprio() needs the owner's
pi_lock, which nests outside the rq lock held there. So
dl_request_owner_boost() queues a hard irq_work. The work calls the new
rt_mutex_adjust_owner(), which boosts the owner from its top waiter
under the pi_lock, if dl_waiter_boosts() says so. A call to
rt_mutex_setprio() that boosts nothing would still dequeue and enqueue
the owner.

The rtmutex code also asks, without the rq lock:
- In try_to_take_rt_mutex(): the tick can throttle a task in the slow
  path of a lock, before it has waiters. It can still take the lock,
  and get waiters.
- Where a task stops waiting on a lock without taking it.
  rt_mutex_adjust_owner() skips an owner that waits on another lock,
  since a new donor would need a chain walk.
A throttle after a yield does not ask: the owner gave up its runtime.

One case stays open. An owner throttled while it waits on another lock
cannot run to take that lock. Its own waiters wait for its next period.

On a CPU going offline, the __balance_callbacks() at the end of
rt_mutex_setprio() runs balance_push(). Its per-CPU work buffer
expects one call per switch-in. The irq_work can interrupt the tail of
a switch-in, and would queue that buffer twice. balance_push() now
returns in hard interrupt context. The next __schedule() does the push.

dl_owner_boost_work() can drop the last reference on the task that
holds the irq_work, before irq_work_single() is done with it. This is
safe because put_task_struct() frees the task through call_rcu(), since
commit 8671bad873eb ("sched: Do not call __put_task_struct() on rt if
pi_blocked_on is set"), in v6.17. A backport needs that commit.
RT_MUTEXES now selects IRQ_WORK, which is only built by default on SMP.

"selftests/sched: Test parameter changes in deadline_bw_test", later in
this series, lists the cases that fail without this patch.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org # 6.16.x and older: 8671bad873eb: sched: Do not call __put_task_struct() on rt if pi_blocked_on is set
Cc: stable@vger.kernel.org
---
 include/linux/sched.h        |  6 +++
 include/linux/sched/rt.h     |  4 ++
 init/Kconfig                 |  1 +
 kernel/locking/rtmutex.c     | 27 +++++++++++
 kernel/locking/rtmutex_api.c | 27 +++++++++++
 kernel/sched/core.c          |  9 ++++
 kernel/sched/deadline.c      | 92 ++++++++++++++++++++++++++++++++++++
 7 files changed, 166 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cafa26c874b0..3e14987e0177 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -26,6 +26,7 @@
 #include <linux/mutex_types.h>
 #include <linux/plist_types.h>
 #include <linux/hrtimer_types.h>
+#include <linux/irq_work_types.h>
 #include <linux/timer_types.h>
 #include <linux/seccomp_types.h>
 #include <linux/nodemask_types.h>
@@ -851,6 +852,11 @@ struct sched_dl_entity {
 	 * to (the original one/itself).
 	 */
 	struct sched_dl_entity *pi_se;
+	/*
+	 * Queued when the task, an rt_mutex owner, can no longer run on its
+	 * own reservation: see dl_request_owner_boost().
+	 */
+	struct irq_work			boost_work;
 #endif
 	bool				dl_bw_def;
 };
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 922935cc3383..7be8f196a2fb 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -66,6 +66,10 @@ static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *p)
 }
 extern void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
+extern void rt_mutex_adjust_owner(struct task_struct *p);
+extern void dl_request_owner_boost(struct task_struct *p);
+extern bool dl_owner_needs_boost(struct task_struct *p,
+				 struct task_struct *pi_task);
 #else
 static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 4013781e0a02..f0a700046133 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2115,6 +2115,7 @@ source "arch/Kconfig"
 config RT_MUTEXES
 	bool
 	default y if PREEMPT_RT
+	select IRQ_WORK
 
 config MODULE_SIG_FORMAT
 	def_bool n
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index b09816977d4e..4088c253a611 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1086,6 +1086,20 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 	return ret;
 }
 
+/*
+ * Ask for a boost of @task, a deadline task with a deadline top waiter.
+ * @task can be throttled already. Its throttle is only read under the
+ * rq lock, so leave the check to the irq_work of
+ * dl_request_owner_boost(). The caller holds the pi_lock of @task.
+ */
+static __always_inline void rt_mutex_ask_dl_boost(struct task_struct *task)
+{
+	lockdep_assert_held(&task->pi_lock);
+	if (dl_prio(task->normal_prio) && task_has_pi_waiters(task) &&
+	    dl_prio(task_top_pi_waiter(task)->pi_tree.prio))
+		dl_request_owner_boost(task);
+}
+
 /*
  * Try to take an rt-mutex
  *
@@ -1195,6 +1209,13 @@ try_to_take_rt_mutex(struct rt_mutex_base *lock, struct task_struct *task,
 	 */
 	if (rt_mutex_has_waiters(lock))
 		rt_mutex_enqueue_pi(task, rt_mutex_top_waiter(lock));
+	/*
+	 * @task took the lock ahead of the remaining waiters, so none of
+	 * them has a higher priority. A deadline task can still need a
+	 * boost: it can be throttled already. Its throttle found no waiter,
+	 * or it waited on this lock then. Ask for the boost again.
+	 */
+	rt_mutex_ask_dl_boost(task);
 	raw_spin_unlock(&task->pi_lock);
 
 takeit:
@@ -1270,6 +1291,7 @@ static int __sched task_blocks_on_rt_mutex(struct rt_mutex_base *lock,
 			raw_spin_lock(&task->pi_lock);
 			rt_mutex_dequeue(lock, waiter);
 			task->pi_blocked_on = NULL;
+			rt_mutex_ask_dl_boost(task);
 			raw_spin_unlock(&task->pi_lock);
 			return res;
 		}
@@ -1574,6 +1596,11 @@ static void __sched remove_waiter(struct rt_mutex_base *lock,
 	scoped_guard(raw_spinlock, &waiter_task->pi_lock) {
 		rt_mutex_dequeue(lock, waiter);
 		waiter_task->pi_blocked_on = NULL;
+		/*
+		 * The task stops waiting. If it owns a lock with waiters and
+		 * was throttled meanwhile, no boost could reach it then.
+		 */
+		rt_mutex_ask_dl_boost(waiter_task);
 	}
 
 	/*
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index f1246efc62d3..384a6e951515 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -536,6 +536,33 @@ void __sched rt_mutex_adjust_pi(struct task_struct *task)
 				   next_lock, NULL, task);
 }
 
+/*
+ * Boost @task from its top waiter, as rt_mutex_adjust_prio() does when a
+ * waiter changes. dl_request_owner_boost() queues this call when @task, a
+ * deadline owner, can no longer run on its own reservation. The pi_lock
+ * of @task keeps its pi_waiters, and so its top waiter, in place.
+ *
+ * Leave @task alone if it waits on another lock, with pi_blocked_on set.
+ * A new donor would then need a chain walk from @task, and this runs in
+ * hard interrupt context. The rtmutex code asks again when @task takes
+ * that lock or stops waiting on it. If @task is throttled before then,
+ * it cannot run to take the lock, and its waiters wait for its next
+ * period.
+ */
+void rt_mutex_adjust_owner(struct task_struct *task)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	if (!task->pi_blocked_on && task_has_pi_waiters(task)) {
+		struct task_struct *pi_task = task_top_pi_waiter(task)->task;
+
+		if (dl_owner_needs_boost(task, pi_task))
+			rt_mutex_setprio(task, pi_task);
+	}
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+}
+
 /*
  * Performs the wakeup of the top-waiter and re-enables preemption.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1e043d27b67..d0113caa5826 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8626,6 +8626,15 @@ static void balance_push(struct rq *rq)
 	if (!cpu_dying(rq->cpu) || rq != this_rq())
 		return;
 
+	/*
+	 * push_work is per CPU: run once per switch-in, from __schedule().
+	 * A hard interrupt can call rt_mutex_setprio() in the tail of that
+	 * switch-in: see dl_request_owner_boost(). Leave the push to the
+	 * next __schedule(), which finds the callback installed above.
+	 */
+	if (in_hardirq())
+		return;
+
 	/*
 	 * Both the cpu-hotplug and stop task are in this case and are
 	 * required to complete the hotplug process.
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a526497c099c..7a1beec2d95e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -481,6 +481,82 @@ void dl_boost_start(struct sched_dl_entity *dl_se)
 	dl_se->dl_yielded = 0;
 	dl_boost_donor_period(dl_se);
 }
+
+/*
+ * Run as the irq_work that dl_request_owner_boost() queued, and drop the
+ * reference that it took. That can be the last one. irq_work_single()
+ * still writes the work, in the task_struct, after this returns. This is
+ * safe: put_task_struct() frees the task through call_rcu(). A hard
+ * irq_work runs with interrupts off, so no grace period can end before
+ * irq_work_single() returns.
+ */
+static void dl_owner_boost_work(struct irq_work *work)
+{
+	struct task_struct *p = container_of(work, struct task_struct,
+					     dl.boost_work);
+
+	rt_mutex_adjust_owner(p);
+	put_task_struct(p);
+}
+
+/*
+ * Ask for a boost of @p, an rt_mutex owner that was just throttled.
+ * rt_mutex_setprio() did not boost @p when its waiters blocked, because
+ * @p could still run on its own reservation then. It is called again
+ * only when a waiter changes. The rtmutex code also asks, when @p gets
+ * waiters, or stops waiting on another lock: @p can be throttled
+ * already. A throttle after a yield does not ask: the task gave up its
+ * runtime, and waits for its next period with its waiters.
+ *
+ * rt_mutex_setprio() needs the pi_lock of @p, which nests outside the rq
+ * lock that the caller holds. So queue an irq_work, which calls
+ * rt_mutex_adjust_owner() after the rq lock is released. The irq_work is
+ * hard: on PREEMPT_RT, other irq_work runs in a kthread, which the
+ * deadline tasks would delay.
+ */
+void dl_request_owner_boost(struct task_struct *p)
+{
+	if (is_dl_boosted(&p->dl) || !p->dl.dl_runtime)
+		return;
+	/*
+	 * From a throttle, the read of pi_waiters is racy: the work tests it
+	 * again under the pi_lock. A waiter that this test misses is added
+	 * under that pi_lock after it. Its path then asks for a boost, or
+	 * calls rt_mutex_setprio(), and either takes the rq lock that the
+	 * caller holds. Under that lock, the throttle is seen.
+	 */
+	if (data_race(RB_EMPTY_ROOT(&p->pi_waiters.rb_root)))
+		return;
+	get_task_struct(p);
+	if (!irq_work_queue(&p->dl.boost_work))
+		put_task_struct(p);
+}
+
+/*
+ * Return true if the waiter @pi_task must boost @p, an rt_mutex owner.
+ * Return false unless both are deadline tasks and @p is not boosted.
+ * The caller holds the pi_lock of @p, so that rt_mutex_setprio() can
+ * follow with the same top waiter. A call to rt_mutex_setprio() that
+ * boosts nothing would still dequeue and enqueue @p, and its enqueue can
+ * throttle @p. This only filters: rt_mutex_setprio() decides again, with
+ * a newer clock.
+ */
+bool dl_owner_needs_boost(struct task_struct *p, struct task_struct *pi_task)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+	bool ret = false;
+
+	if (!dl_prio(p->normal_prio) || !dl_prio(pi_task->prio))
+		return false;
+	rq = __task_rq_lock(p, &rf);
+	if (!is_dl_boosted(&p->dl)) {
+		update_rq_clock(rq);
+		ret = dl_waiter_boosts(p, pi_task);
+	}
+	__task_rq_unlock(rq, p, &rf);
+	return ret;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -491,6 +567,10 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 {
 }
 
+static inline void dl_request_owner_boost(struct task_struct *p)
+{
+}
+
 static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
@@ -2382,6 +2462,9 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 		dl_se->dl_throttled = 1;
 		if (dl_se->runtime > 0)
 			dl_se->runtime = 0;
+		/* A deadline waiter on an rt_mutex may boost it now. */
+		if (!dl_server(dl_se))
+			dl_request_owner_boost(dl_task_of(dl_se));
 	}
 }
 
@@ -2554,6 +2637,12 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 		if (!dl_server(dl_se)) {
 			update_stats_dequeue_dl(&rq->dl, dl_se, 0);
 			dequeue_pushable_dl_task(rq, dl_task_of(dl_se));
+			/*
+			 * A deadline waiter on an rt_mutex may boost it now.
+			 * Not after a yield: the task gave up its runtime.
+			 */
+			if (!dl_se->dl_yielded)
+				dl_request_owner_boost(dl_task_of(dl_se));
 		}
 
 		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(dl_se))) {
@@ -5899,6 +5988,8 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
 		replenish_dl_entity(dl_se);
 	if (task_current_donor(rq, p))
 		resched_curr(rq);
+	/* A deadline waiter on an rt_mutex may boost it now. */
+	dl_request_owner_boost(p);
 	return false;
 }
 
@@ -6131,6 +6222,7 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	 * from switched_from_dl() before the deboost drops its reference.
 	 */
 	dl_se->pi_se = dl_se;
+	dl_se->boost_work = IRQ_WORK_INIT_HARD(dl_owner_boost_work);
 #endif
 	dl_se->dl_bw_cpu = -1;
 	dl_se->dl_bw_resv_cpu = -1;
-- 
2.47.3

