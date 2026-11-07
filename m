Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015917;
	b=O+amY3LiJFKCi2B35ttbAqBb82tMLd3/pdG1lihDkwMpSx++yQMVb2IJedm7hNOewPCW
	 eiLLtBL6IC7DlCXyc/vZq8MZBfK4ziQLX7cad7yj/AC8wyq/giGMHe4gbQQniTv4X1POL
	 3tDO/oVCRCs3yg/1rPrWe2WWuw0TlBe9Eu8urXUrSBN/B3PV0xFfn2fVAqPZPdQoStNMS
	 a12HgYUzD5lQscVVioAbmq00PY7GdWOzggb9IqgaeP/tpd+tHTB0xNnu3YrKFiWB/8Cm1
	 TfeyBgNAmG+Q3NEkJi5FYN1oETy9BJPYQygBSonGKeOIoPKKH8wTyacRmepOixb5ffQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015917;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VjM8Am2jAL/k/qxtGI9mzTyn8XGKaVXD0TYl5AfnZvE=;
	b=06taX5vyaaEu9vS2OwKnPWXUszwI5nbFiivsfHIy/Ha1axShPSx2NyWgz6YnKy21wZKv
	 ZcVbrF2KST5Nn6duYMq0iFUE43uG3sd7ZKAqnYsflqz6PpAtGQUp+pzFntivcbmtuRUV3
	 lMEImLtNLWXNK0lO3Nct551Rac4091eAcdLt35Kap4DVuz9SqQnRXTTW+TCVz/T7d4ZQD
	 Kf3Ku+6RJcuxt0sTuGixgkQSOmW5ylzm+UiiLh7q5Iqbv4d69uziqyjyGsRSVvZhzsJDj
	 TkP+B+M9sT06+626ErQLKUzXE7p7DIBS52rlIOv/X7RwUbfzj8OjUH7gr6hpxBwyHog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UfqGOhgW;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DDD606D834;
	Sat,  7 Nov 2026 01:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90DDD606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UfqGOhgW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015901;
	bh=VjM8Am2jAL/k/qxtGI9mzTyn8XGKaVXD0TYl5AfnZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfqGOhgWQClItusxF+E3FP/PVFJMQI66lwSO8mPlKMzeBLo5YtZH3W58jqAxh3Jmg
	 244qwGwE43IQBJ5XTyDQuHIRZRLAjTUMJzLe3K9YK2qlK5ypEV90JjyChkOLv9N9cZ
	 Pv86RNR5pfEdyp0WY4GA/2Oi/KalETVzSr7GyJZtX9Lf5v9JiEF0VVshoM9zQuWVch
	 5+1LPK1Qsezf0mOWMqvXo0LQoVMLFGIrhEkVWXqoxong8MuhKjyD/fmtroUUdofKnC
	 qTqB77fkKeLlr+BlTXS/fUa/euK4BOl7PjMgukhd0MiMJat39IsejAXpDt4Z67kM7I
	 srXH2+luobwvg==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPn3KtDzMR4;
	Fri, 06 Nov 2026 20:45:01 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v4 08/26] sched/deadline: Take a deadline boost from the waiter's rt_mutex node
Date: Fri,  6 Nov 2026 20:44:33 -0500
Message-Id: <20261107014451.1487825-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

A task boosted by a deadline waiter of an rt_mutex it holds runs on the
waiter's reservation: pi_se points at the waiter's entity, whose
dl_runtime, dl_deadline and dl_period replenish_dl_entity() reads. The
waiter can leave SCHED_DEADLINE meanwhile. __sched_setscheduler()
changes it under its runqueue lock, and walks the chain to the owner,
rt_mutex_adjust_pi(), once that lock is released. In between,
inactive_task_timer() at the waiter's 0-lag time, or
task_non_contending() in the change itself for a waiter woken but not
yet off the lock, clears the waiter's parameters. The owner is still
boosted, and the next time its runtime runs out, at a tick or a switch,
replenish_dl_entity() never leaves, under the runqueue lock with
interrupts off:

	while (dl_se->runtime <= 0) {
		dl_se->deadline += pi_of(dl_se)->dl_period;
		dl_se->runtime += pi_of(dl_se)->dl_runtime;
	}

Its CPU locks up, and so does the one walking the chain, waiting for the
owner's runqueue lock.

A copy of the waiter's parameters taken at the boost is not enough:
rt_mutex_setprio() reads the waiter with no lock of the waiter's, and a
copy taken as the waiter leaves the class takes them cleared. The
waiter's rt_mutex node records its priority and deadline under its
pi_lock, which every change of its parameters holds, and every waiter
enters its owner's pi_waiters with them current since "locking/rtmutex:
Clone a waiter's sort keys as it enters pi_waiters", which this series
applies on top of. Record there the reservation the waiter runs on, its
own or the one a boost lent it, and take a deadline boost from the node
of the top pi waiter: the priority, the deadline that decides whether a
deadline owner is boosted, and a copy of the reservation, which the
boosted task runs on from then on.

rt_mutex_setprio(), rt_effective_prio() and __setscheduler_dl_pi() read
that node, rt_effective_prio() from the top pi waiter rather than
p->pi_top_task, which try_to_take_rt_mutex() can leave stale. The chain
walk and rt_mutex_adjust_pi() compare a deadline waiter's reservation
too, so that a change of its parameters alone reaches the owner. struct
rt_mutex_waiter, on the stack of every rt_mutex sleeper and, with
PREEMPT_RT, of every sleeping lock waiter, grows from 112 to 160 bytes.
rt_mutex_get_top_task() has no user left.

Tested in VMs of 8 CPUs, 2 or 3 per case, with the same result in each:

 - a debug delay of 300ms before rt_mutex_adjust_pi() opens the window:
   a 1ms/100ms deadline waiter of a spinning owner, switched to
   SCHED_OTHER with its inactive timer armed, locks up v7.4-rc1 and this
   series without this patch, the owner's CPU warning in
   replenish_dl_entity(); with this patch the owner is deboosted when
   the change returns;
 - without the delay, a deadline waiter switched in and out of
   SCHED_DEADLINE 20000 times a second while a thread boosts the owner
   again thousands of times a second, with a 50us timed lock: a copy
   taken from the waiter itself locks the owner's CPU up within a
   second, and this patch runs 600 seconds;
 - a deadline waiter that changes class while another is ahead of it,
   then is promoted, boosts the owner as its class says, either way;
 - the locking API, ww_mutex, locktorture rtmutex_lock and futex
   selftests pass, with and without PREEMPT_RT.

Found by the Sashiko AI review of the third posting of this series; the
window of a copy taken from the waiter itself, and a node not current on
promotion, by reviews of this posting by a second model.

Fixes: a5e7be3b28a2 ("sched/deadline: Clear dl_entity params when setscheduling to different class")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           | 21 +++++++--
 include/linux/sched/deadline.h  | 17 ++++++++
 include/linux/sched/rt.h        | 11 -----
 kernel/locking/rtmutex.c        | 41 +++++++++++++++---
 kernel/locking/rtmutex_api.c    |  2 +-
 kernel/locking/rtmutex_common.h |  5 +++
 kernel/sched/core.c             | 69 ++++++++++++++++++++++++++----
 kernel/sched/deadline.c         | 76 ++++++++++++++++++++++++---------
 kernel/sched/sched.h            | 19 +++------
 kernel/sched/syscalls.c         |  6 +--
 10 files changed, 198 insertions(+), 69 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..f0b6a8a91323 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -640,6 +640,13 @@ struct sched_rt_entity {
 struct rq_flags;
 typedef struct task_struct *(*dl_server_pick_f)(struct sched_dl_entity *, struct rq_flags *rf);
 
+/* The parameters of a deadline reservation: runtime, relative deadline, period. */
+struct sched_dl_params {
+	u64				runtime;
+	u64				deadline;
+	u64				period;
+};
+
 struct sched_dl_entity {
 	struct rb_node			rb_node;
 
@@ -706,6 +713,9 @@ struct sched_dl_entity {
 	 * contributes to the root domain's total_bw. Only meaningful for server
 	 * entities (@dl_server == 1). Allows toggling the reservation on/off
 	 * without losing the configured @dl_runtime/@dl_period.
+	 *
+	 * @dl_boosted tells if priority inheritance boosted the entity: it
+	 * runs on the parameters copied in @pi_params.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -718,6 +728,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_boosted        : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
@@ -745,11 +756,13 @@ struct sched_dl_entity {
 
 #ifdef CONFIG_RT_MUTEXES
 	/*
-	 * Priority Inheritance. When a DEADLINE scheduling entity is boosted
-	 * pi_se points to the donor, otherwise points to the dl_se it belongs
-	 * to (the original one/itself).
+	 * Priority inheritance: the parameters of the reservation the
+	 * entity runs on while @dl_boosted, copied at the boost from the
+	 * node of the waiter that lends them (rt_waiter_node). Not read
+	 * from the waiter: it may leave SCHED_DEADLINE and have its own
+	 * cleared before the chain walk deboosts this one.
 	 */
-	struct sched_dl_entity *pi_se;
+	struct sched_dl_params		pi_params;
 #endif
 };
 
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 273538200a44..416ca548a038 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -10,6 +10,23 @@
 
 #include <linux/sched.h>
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * The reservation @dl_se runs on: its own, or the one a priority
+ * inheritance boost lent it. Under its task's pi_lock or rq lock.
+ */
+static inline struct sched_dl_params dl_entity_params(const struct sched_dl_entity *dl_se)
+{
+	if (dl_se->dl_boosted)
+		return dl_se->pi_params;
+	return (struct sched_dl_params){
+		.runtime	= dl_se->dl_runtime,
+		.deadline	= dl_se->dl_deadline,
+		.period		= dl_se->dl_period,
+	};
+}
+#endif
+
 static inline bool dl_prio(int prio)
 {
 	return unlikely(prio < MAX_DL_PRIO);
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 922935cc3383..a790428734db 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -57,20 +57,9 @@ extern void rt_mutex_schedule(void);
 extern void rt_mutex_post_schedule(void);
 extern void rt_mutex_futex_post_schedule(void);
 
-/*
- * Must hold either p->pi_lock or task_rq(p)->lock.
- */
-static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *p)
-{
-	return p->pi_top_task;
-}
 extern void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
-static inline struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
-{
-	return NULL;
-}
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index e89f0f0e604b..c0869c63a476 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -363,16 +363,21 @@ static __always_inline int __waiter_prio(struct task_struct *task)
 }
 
 /*
- * Update the waiter->tree copy of the sort keys.
+ * Update the waiter->tree copy of the sort keys, and of the reservation a
+ * deadline waiter lends the owner: under @task's pi_lock, which every
+ * change of its parameters holds, so that a boost never runs on those of
+ * a waiter that left the class before the chain walk came.
  */
 static __always_inline void
 waiter_update_prio(struct rt_mutex_waiter *waiter, struct task_struct *task)
 {
 	lockdep_assert_held(&waiter->lock->wait_lock);
+	lockdep_assert_held(&task->pi_lock);
 	lockdep_assert(RB_EMPTY_NODE(&waiter->tree.entry));
 
 	waiter->tree.prio = __waiter_prio(task);
 	waiter->tree.deadline = task->dl.deadline;
+	waiter->tree.dl = dl_entity_params(&task->dl);
 }
 
 /*
@@ -387,6 +392,7 @@ waiter_clone_prio(struct rt_mutex_waiter *waiter, struct task_struct *task)
 
 	waiter->pi_tree.prio = waiter->tree.prio;
 	waiter->pi_tree.deadline = waiter->tree.deadline;
+	waiter->pi_tree.dl = waiter->tree.dl;
 }
 
 /*
@@ -433,6 +439,27 @@ static __always_inline int rt_waiter_node_equal(struct rt_waiter_node *left,
 	return 1;
 }
 
+/*
+ * Whether the lock tree copy of @waiter's node still has what @task would
+ * record in it: its sort keys and, for a deadline task, the reservation
+ * it lends the owner, which a change of its parameters moves without them
+ * (sched_setattr() leaves the deadline of a task that is not running).
+ */
+static __always_inline bool rt_waiter_node_current(struct rt_mutex_waiter *waiter,
+						   struct task_struct *task)
+{
+	struct sched_dl_params dl;
+
+	if (!rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task)))
+		return false;
+	if (!dl_prio(waiter->tree.prio))
+		return true;
+	dl = dl_entity_params(&task->dl);
+	return dl.runtime == waiter->tree.dl.runtime &&
+	       dl.deadline == waiter->tree.dl.deadline &&
+	       dl.period == waiter->tree.dl.period;
+}
+
 static inline bool rt_mutex_steal(struct rt_mutex_waiter *waiter,
 				  struct rt_mutex_waiter *top_waiter)
 {
@@ -831,13 +858,13 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 	}
 
 	/*
-	 * If the waiter priority is the same as the task priority
-	 * then there is no further priority adjustment necessary.  If
-	 * deadlock detection is off, we stop the chain walk. If its
-	 * enabled we continue, but stop the requeueing in the chain
-	 * walk.
+	 * If the waiter priority is the same as the task priority, and
+	 * so is the reservation of a deadline task, then there is no
+	 * further priority adjustment necessary.  If deadlock detection
+	 * is off, we stop the chain walk. If its enabled we continue,
+	 * but stop the requeueing in the chain walk.
 	 */
-	if (rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task))) {
+	if (rt_waiter_node_current(waiter, task)) {
 		if (!detect_deadlock)
 			goto out_unlock_pi;
 		else
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index eb18b094473c..ba907636cc3c 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -510,7 +510,7 @@ void __sched rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || rt_waiter_node_equal(&waiter->tree, task_to_waiter_node(task))) {
+	if (!waiter || rt_waiter_node_current(waiter, task)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 1f56d40c3e66..9abd3184cfa3 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -33,6 +33,11 @@ struct rt_waiter_node {
 	struct rb_node	entry;
 	int		prio;
 	u64		deadline;
+	/*
+	 * A deadline waiter's reservation, its relative runtime, deadline
+	 * and period, recorded with @prio and the absolute @deadline.
+	 */
+	struct sched_dl_params dl;
 };
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a088d4576f5..55a4f2d8294e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -95,6 +95,9 @@
 #include "smp.h"
 
 #include "../workqueue_internal.h"
+#ifdef CONFIG_RT_MUTEXES
+#include "../locking/rtmutex_common.h"
+#endif
 #include "../../io_uring/io-wq.h"
 #include "../smpboot.h"
 #include "../locking/mutex.h"
@@ -7742,6 +7745,55 @@ void rt_mutex_futex_post_schedule(void)
 	lockdep_assert(fetch_and_set(current->sched_rt_mutex, 0));
 }
 
+/*
+ * The priority @pi_task, the top pi waiter of node @pi, lends a task of
+ * priority @prio: its own, read without its lock, as the chain walk that
+ * follows a change of it brings the change; but that of its node where
+ * either is a deadline one. A deadline boost runs on the reservation the
+ * node recorded with it under the waiter's pi_lock: past a change of the
+ * waiter's own, its parameters may be cleared before the walk comes
+ * (__dl_clear_params()), and replenish_dl_entity() never ends over a
+ * runtime of 0.
+ */
+static int __rt_effective_prio(struct task_struct *pi_task,
+			       struct rt_waiter_node *pi, int prio)
+{
+	int pi_prio;
+
+	if (!pi_task)
+		return prio;
+	pi_prio = pi_task->prio;
+	if (dl_prio(pi_prio) || dl_prio(pi->prio))
+		pi_prio = pi->prio;
+	return min(prio, pi_prio);
+}
+
+/* The node of @p's top pi waiter, or NULL. Under @p->pi_lock. */
+static struct rt_waiter_node *rt_mutex_top_pi_node(struct task_struct *p)
+{
+	lockdep_assert_held(&p->pi_lock);
+	return task_has_pi_waiters(p) ? &task_top_pi_waiter(p)->pi_tree : NULL;
+}
+
+/* The priority @p, of priority @prio of its own, runs at with its boost. */
+int rt_effective_prio(struct task_struct *p, int prio)
+{
+	struct rt_waiter_node *pi = rt_mutex_top_pi_node(p);
+
+	return __rt_effective_prio(pi ? task_top_pi_waiter(p)->task : NULL, pi, prio);
+}
+
+/*
+ * The reservation the top pi waiter of @p lends it, as its node recorded
+ * it, or NULL if that node is not a deadline one. Under @p->pi_lock.
+ */
+const struct sched_dl_params *rt_mutex_top_dl_params(struct task_struct *p)
+{
+	struct rt_waiter_node *pi = rt_mutex_top_pi_node(p);
+
+	return pi && dl_prio(pi->prio) ? &pi->dl : NULL;
+}
+
 /*
  * rt_mutex_setprio - set the current priority of a task
  * @p: task to boost
@@ -7758,11 +7810,11 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 	int prio, oldprio, queue_flag =
 		DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK;
 	const struct sched_class *prev_class, *next_class;
+	struct rt_waiter_node *pi = pi_task ? rt_mutex_top_pi_node(p) : NULL;
 	struct rq_flags rf;
 	struct rq *rq;
 
-	/* XXX used to be waiter->prio, not waiter->task->prio */
-	prio = __rt_effective_prio(pi_task, p->normal_prio);
+	prio = __rt_effective_prio(pi_task, pi, p->normal_prio);
 
 	/*
 	 * If nothing changed; bail early.
@@ -7832,21 +7884,22 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		 */
 		if (dl_prio(prio)) {
 			if (!dl_prio(p->normal_prio) ||
-			    (pi_task && dl_prio(pi_task->prio) &&
-			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
-				p->dl.pi_se = pi_task->dl.pi_se;
+			    (pi_task && dl_prio(pi->prio) &&
+			     (dl_entity_is_special(&pi_task->dl) ||
+			      dl_time_before(pi->deadline, p->dl.deadline)))) {
+				dl_boost(&p->dl, &pi->dl);
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				p->dl.pi_se = &p->dl;
+				p->dl.dl_boosted = 0;
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				p->dl.dl_boosted = 0;
 			if (oldprio < prio)
 				scope->flags |= ENQUEUE_HEAD;
 		} else {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				p->dl.dl_boosted = 0;
 			if (rt_prio(oldprio))
 				p->rt.timeout = 0;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6cf33045d93a..b8b0076870a6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -84,25 +84,63 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
 }
 
 #ifdef CONFIG_RT_MUTEXES
-static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
-	return dl_se->pi_se;
+	return dl_se->dl_boosted;
 }
 
-static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+/*
+ * The parameters of the reservation @dl_se runs on: its own, or the
+ * donor's, copied by dl_boost().
+ */
+static inline u64 pi_runtime_of(struct sched_dl_entity *dl_se)
 {
-	return pi_of(dl_se) != dl_se;
+	return dl_se->dl_boosted ? dl_se->pi_params.runtime : dl_se->dl_runtime;
 }
-#else /* !CONFIG_RT_MUTEXES: */
-static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+
+static inline u64 pi_deadline_of(struct sched_dl_entity *dl_se)
 {
-	return dl_se;
+	return dl_se->dl_boosted ? dl_se->pi_params.deadline : dl_se->dl_deadline;
 }
 
+static inline u64 pi_period_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->dl_boosted ? dl_se->pi_params.period : dl_se->dl_period;
+}
+
+/*
+ * Boost @dl_se with the reservation @params a waiter's rt_mutex node
+ * recorded, under the waiter's pi_lock: a copy, as the waiter may leave
+ * SCHED_DEADLINE, and __dl_clear_params() clear its own parameters,
+ * before the chain walk that follows deboosts @dl_se, and a replenishment
+ * over a dl_period and a dl_runtime of 0 never ends. Under the rq lock and
+ * pi_lock of @dl_se's task.
+ */
+void dl_boost(struct sched_dl_entity *dl_se, const struct sched_dl_params *params)
+{
+	dl_se->pi_params = *params;
+	dl_se->dl_boosted = 1;
+}
+#else /* !CONFIG_RT_MUTEXES: */
 static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
 }
+
+static inline u64 pi_runtime_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->dl_runtime;
+}
+
+static inline u64 pi_deadline_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->dl_deadline;
+}
+
+static inline u64 pi_period_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->dl_period;
+}
 #endif /* !CONFIG_RT_MUTEXES */
 
 static inline u8 dl_get_type(struct sched_dl_entity *dl_se, struct rq *rq)
@@ -731,9 +769,8 @@ static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
 static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 					    struct rq *rq)
 {
-	/* for non-boosted task, pi_of(dl_se) == dl_se */
-	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
-	dl_se->runtime = pi_of(dl_se)->dl_runtime;
+	dl_se->deadline = rq_clock(rq) + pi_deadline_of(dl_se);
+	dl_se->runtime = pi_runtime_of(dl_se);
 
 	/*
 	 * If it is a deferred reservation, and the server
@@ -808,7 +845,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	WARN_ON_ONCE(pi_of(dl_se)->dl_runtime <= 0);
+	WARN_ON_ONCE(pi_runtime_of(dl_se) <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
@@ -822,8 +859,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
-		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
-		dl_se->runtime = pi_of(dl_se)->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_deadline_of(dl_se);
+		dl_se->runtime = pi_runtime_of(dl_se);
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -836,8 +873,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_of(dl_se)->dl_period;
-		dl_se->runtime += pi_of(dl_se)->dl_runtime;
+		dl_se->deadline += pi_period_of(dl_se);
+		dl_se->runtime += pi_runtime_of(dl_se);
 	}
 
 	/*
@@ -946,9 +983,9 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (pi_of(dl_se)->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
+	left = (pi_deadline_of(dl_se) >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
 	right = ((dl_se->deadline - t) >> DL_SCALE) *
-		(pi_of(dl_se)->dl_runtime >> DL_SCALE);
+		(pi_runtime_of(dl_se) >> DL_SCALE);
 
 	return dl_time_before(right, left);
 }
@@ -3977,10 +4014,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
-
-#ifdef CONFIG_RT_MUTEXES
-	dl_se->pi_se			= dl_se;
-#endif
+	dl_se->dl_boosted		= 0;
 }
 
 void init_dl_entity(struct sched_dl_entity *dl_se)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1d76950dbb0a..a06cf2e0d983 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -356,6 +356,9 @@ extern int  sched_dl_global_validate(void);
 extern void sched_dl_do_global(void);
 extern int  sched_dl_overflow(struct task_struct *p, int policy, const struct sched_attr *attr);
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
+#ifdef CONFIG_RT_MUTEXES
+extern void dl_boost(struct sched_dl_entity *dl_se, const struct sched_dl_params *params);
+#endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
@@ -4244,20 +4247,8 @@ bool task_is_pushable(struct rq *rq, struct task_struct *p, int cpu)
 
 #ifdef CONFIG_RT_MUTEXES
 
-static inline int __rt_effective_prio(struct task_struct *pi_task, int prio)
-{
-	if (pi_task)
-		prio = min(prio, pi_task->prio);
-
-	return prio;
-}
-
-static inline int rt_effective_prio(struct task_struct *p, int prio)
-{
-	struct task_struct *pi_task = rt_mutex_get_top_task(p);
-
-	return __rt_effective_prio(pi_task, prio);
-}
+extern int rt_effective_prio(struct task_struct *p, int prio);
+extern const struct sched_dl_params *rt_mutex_top_dl_params(struct task_struct *p);
 
 #else /* !CONFIG_RT_MUTEXES: */
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index c3f404cddb9e..89c185f7d498 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -297,10 +297,10 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 */
 
 	if (dl_prio(newprio) && !dl_policy(policy)) {
-		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+		const struct sched_dl_params *params = rt_mutex_top_dl_params(p);
 
-		if (pi_task) {
-			p->dl.pi_se = pi_task->dl.pi_se;
+		if (params) {
+			dl_boost(&p->dl, params);
 			scope->flags |= ENQUEUE_REPLENISH;
 		}
 	}
-- 
2.47.3

