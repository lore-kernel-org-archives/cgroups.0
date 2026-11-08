Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164062;
	b=sGrJ9RRVZ+YJrcNr0e18xyQyd/cQoGeDs+H8SopazEYvMbP0p3maRjPhQGzj58BoKem3
	 ANGj5sNqZNlICCALqbMxQfN+dMT5t4nVDxpK29FQ3ftk4oNSkuyqn3+2+dbaw75OPtnMp
	 4KY10+8G8GJ3mUwz3Q3XHQkoYVRfNYcRdQsr4ovqM2/d2E1Frs0eHdhlri/ItghERqRj2
	 XG1bJ8ZKgROrkEYT8MsHv9lAc7xzqXPzO0ti3iwIazW1/CJAUhKEE+Qy9a1Si8kODL/p2
	 r8VydYmFkoW2UJAj71ibWZGPKExbYJKerP2grbNRICzywPEACeKU03/C00qY033UGxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164062;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3QaGUmqXH2f+qj4igXQq4Hj785oVoKfubwsopptcdeU=;
	b=kEnOuOFA5ZPT/RcdcixVl7MbQc5vOWD2PJrPJdKwZIKwEws2pt6SHMyLkj1sxCELDOm8
	 SS4FEz/cVQyjWV/oRAUjbvs2mTeMLVRmFOLu/inf5xPefwcQ9bE9dlJvZTYJ6sBeNKtiO
	 H6dlNWjQMwLk2m/ZmIDfXxgbIPd8SjVKoNU4TTimt3eG8joIOj0E0VVbt6JfH8YCzty/4
	 w623TQ/ZmTQzMBccbCfazgyVoA6GNvjUVCeCMqhfz/xKuL5C0Ij7KyMvCM6Ti5pkox+uR
	 fHATui+Za9emN+bauym8EZ8BdrlFGDUcksDfIsv70UklLg16DLGPkZAvxC+PmimFI6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HRDNTkg6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A2606D83F;
	Sun,  8 Nov 2026 18:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D2A2606D83F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HRDNTkg6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164060;
	bh=3QaGUmqXH2f+qj4igXQq4Hj785oVoKfubwsopptcdeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRDNTkg6RTv9cZpCinU3KArGYFrvjD0ZUeXD4lnF61cAf0SWzX+/elUXmqbfxwSoh
	 t+GlosAzhvEHu2ebZRaEq6eQE+9F2FXfcfv8gg8iqlWe9YCut2RmYpKg3CgA6yeh4J
	 PpcE7X+vusNZnJ5JomuZ3VGvISxlICMHFFUpFpg5JcqjhSo/6VpF0vfhl+bOfe7dxE
	 xorpPdXha7u7GH0CjCGmdMDF4uPikoqd6vFOo7yCro/c11vGZ7bRf+vezGHs79xqXd
	 oQyKYnBp4fbejrBi6f8wEJjmc2gU1PyFEMYIMAEgKpH2JUtBQS6DI12gvu+iKPoxyz
	 rPeGQkNM2wvkw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2Bz4rsNzMqw;
	Sun, 08 Nov 2026 13:54:19 -0500 (EST)
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
Subject: [PATCH v5 08/29] sched/deadline: Take a deadline boost from the waiter's rt_mutex node
Date: Sun,  8 Nov 2026 13:53:45 -0500
Message-Id: <20261108185406.1549770-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

When a SCHED_DEADLINE waiter boosts the owner of an rt_mutex, the owner
runs on the waiter's live parameters, through dl.pi_se. The waiter can
leave SCHED_DEADLINE, and have them cleared, before the owner is
deboosted. When the owner's runtime runs out, replenish_dl_entity()
loops forever on a dl_runtime of 0. It holds the rq lock, with
interrupts off. The owner's CPU warns there and locks up.

rt_mutex_setprio() also reads the waiter's live priority, not the one in
its rt_mutex node. Commit acd58620e415 ("sched/rtmutex: Refactor
rt_mutex_setprio()") found this fine: if they differ, a PI chain update
is imminent.

But the update can come too late. Leaving SCHED_DEADLINE clears the
parameters, so that admission control counts the task again when it
comes back. __sched_setscheduler() walks the chain only after it drops
the waiter's rq lock. In the change itself, task_non_contending() clears
the parameters of a waiter woken past its 0-lag time.
inactive_task_timer() clears them later, when a sleeping waiter reaches
that time.

O is a SCHED_OTHER task that holds the rt_mutex L. W is a SCHED_DEADLINE
task. T is any other task:

  CPU 0 (O)                         CPU 1 (W)                     CPU 2 (T)

  locks L
                                    blocks on L
                                      rt_mutex_setprio(O, W)
                                        O->dl.pi_se = &W->dl
                                    sleeps
                                      task_non_contending()
                                        arms W's inactive timer
                                                                  sched_setscheduler(W)
                                                                    W leaves SCHED_DEADLINE
                                                                    task_rq_unlock(W)
                                    <W's inactive timer>
                                    inactive_task_timer()
                                      __dl_clear_params()
                                        W->dl.dl_runtime = 0
  <tick>
  update_curr_dl_se()
    replenish_dl_entity()
      runtime += W->dl.dl_runtime
      loops forever
                                                                    rt_mutex_adjust_pi(W)
                                                                      rt_mutex_setprio(O, W)
                                                                        spins on O's rq lock

A copy of the parameters at the boost is not enough. rt_mutex_setprio()
would read the waiter's priority, then its parameters. A change of the
waiter can clear them in between. A stress test switches the waiter in
and out of SCHED_DEADLINE. With such a copy, the owner's CPU locked up
within a second. With this patch, the test runs for 600 seconds.

The rt_mutex node records the waiter's priority and deadline under the
waiter's pi_lock, which every change of its parameters holds. Fix this
by recording the reservation there too. A deadline boost then takes the
priority, the deadline and a copy of the reservation from the node of
the top pi waiter. rt_effective_prio() now reads that node too. It used
p->pi_top_task, which try_to_take_rt_mutex() does not update. The chain
walk and rt_mutex_adjust_pi() also compare the reservation, so that a
change of it alone reaches the owner.

This needs "locking/rtmutex: Clone the sort keys in
rt_mutex_enqueue_pi()". struct rt_mutex_waiter grows from 112 to 160
bytes on 64-bit. With PREEMPT_RT, every sleeping lock waiter has one on
its stack.

A 300ms debug delay before rt_mutex_adjust_pi() locks up v7.4-rc1 in
8-CPU VMs, but not a kernel with this patch. The locking API, ww_mutex,
locktorture and futex tests still pass with and without PREEMPT_RT.

Found by the Sashiko AI review of v3. Before v4, a second model found
the window of a copy, and the stale node of a waiter that becomes the
top waiter.

Fixes: a5e7be3b28a2 ("sched/deadline: Clear dl_entity params when setscheduling to different class")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           | 21 +++++++--
 include/linux/sched/deadline.h  | 18 ++++++++
 include/linux/sched/rt.h        | 11 -----
 kernel/locking/rtmutex.c        | 34 ++++++++++++++-
 kernel/locking/rtmutex_api.c    |  2 +-
 kernel/locking/rtmutex_common.h |  5 +++
 kernel/sched/core.c             | 77 +++++++++++++++++++++++++++++----
 kernel/sched/deadline.c         | 73 ++++++++++++++++++++++---------
 kernel/sched/sched.h            | 19 +++-----
 kernel/sched/syscalls.c         |  8 ++--
 10 files changed, 203 insertions(+), 65 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..7544c2558080 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -640,6 +640,13 @@ struct sched_rt_entity {
 struct rq_flags;
 typedef struct task_struct *(*dl_server_pick_f)(struct sched_dl_entity *, struct rq_flags *rf);
 
+/* The runtime, relative deadline and period of a deadline reservation. */
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
+	 * Priority inheritance: the reservation the entity runs on while
+	 * @dl_boosted. dl_boost() copies it from the rt_waiter_node of the
+	 * top pi waiter. It is not read from the waiter itself. The waiter
+	 * can leave SCHED_DEADLINE and have its parameters cleared before the
+	 * chain walk deboosts this entity.
 	 */
-	struct sched_dl_entity *pi_se;
+	struct sched_dl_params		pi_params;
 #endif
 };
 
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 273538200a44..dc8cd3f2eb15 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -10,6 +10,24 @@
 
 #include <linux/sched.h>
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * Return the reservation @dl_se runs on: its own, or the copy made by a
+ * priority inheritance boost. The caller holds the pi_lock or the rq
+ * lock of the task of @dl_se.
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
index 975efa1d864c..b9877e420b29 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -363,16 +363,22 @@ static __always_inline int __waiter_prio(struct task_struct *task)
 }
 
 /*
- * Update the waiter->tree copy of the sort keys.
+ * Update the waiter->tree copy of the sort keys, and of the reservation
+ * of a deadline waiter. Every change of @task's parameters holds its
+ * pi_lock, so the copy is consistent. The owner's deadline boost uses
+ * this copy, not @task. @task can leave SCHED_DEADLINE and have its
+ * parameters cleared before the chain walk reaches the owner.
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
@@ -387,6 +393,7 @@ waiter_clone_prio(struct rt_mutex_waiter *waiter, struct task_struct *task)
 
 	waiter->pi_tree.prio = waiter->tree.prio;
 	waiter->pi_tree.deadline = waiter->tree.deadline;
+	waiter->pi_tree.dl = waiter->tree.dl;
 }
 
 /*
@@ -433,6 +440,27 @@ static __always_inline int rt_waiter_node_equal(struct rt_waiter_node *left,
 	return 1;
 }
 
+/*
+ * Return true if waiter->tree still holds the sort keys of @task and, for
+ * a deadline task, its reservation. sched_setattr() can change the
+ * reservation alone: it keeps the priority and the deadline of a task
+ * that is not running.
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
@@ -830,8 +858,10 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * deadlock detection is off, we stop the chain walk. If its
 	 * enabled we continue, but stop the requeueing in the chain
 	 * walk.
+	 *
+	 * For a deadline task, the reservation must be the same too.
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
index 1f56d40c3e66..47f71d1bcd0a 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -33,6 +33,11 @@ struct rt_waiter_node {
 	struct rb_node	entry;
 	int		prio;
 	u64		deadline;
+	/*
+	 * A deadline waiter's runtime, relative deadline and period,
+	 * recorded together with @prio and the absolute @deadline.
+	 */
+	struct sched_dl_params dl;
 };
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a088d4576f5..e4d299acb1fc 100644
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
@@ -7742,6 +7745,63 @@ void rt_mutex_futex_post_schedule(void)
 	lockdep_assert(fetch_and_set(current->sched_rt_mutex, 0));
 }
 
+/*
+ * Return the effective priority of a task whose own priority is @prio
+ * and whose top pi waiter is @pi_task. @pi is the pi_tree node of
+ * @pi_task.
+ *
+ * Use the priority of @pi_task. Read it without the lock of @pi_task. Any
+ * change of that priority triggers a chain walk, which updates the boost.
+ * But if @pi_task or @pi has a deadline priority, use the one of @pi. A
+ * deadline boost runs on the reservation recorded in @pi, so its priority
+ * must come from the same record.
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
+/*
+ * Return the pi_tree node of the top pi waiter of @p, or NULL if @p has
+ * no pi waiter. The caller holds @p->pi_lock.
+ */
+static struct rt_waiter_node *rt_mutex_top_pi_node(struct task_struct *p)
+{
+	lockdep_assert_held(&p->pi_lock);
+	return task_has_pi_waiters(p) ? &task_top_pi_waiter(p)->pi_tree : NULL;
+}
+
+/*
+ * Return the effective priority of @p if its own priority is @prio. The
+ * caller holds @p->pi_lock.
+ */
+int rt_effective_prio(struct task_struct *p, int prio)
+{
+	struct rt_waiter_node *pi = rt_mutex_top_pi_node(p);
+
+	return __rt_effective_prio(pi ? task_top_pi_waiter(p)->task : NULL, pi, prio);
+}
+
+/*
+ * Return the reservation recorded in the node of the top pi waiter of @p.
+ * Return NULL if @p has no pi waiter, or if that node has no deadline
+ * priority. The caller holds @p->pi_lock.
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
@@ -7758,11 +7818,11 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
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
@@ -7832,21 +7892,22 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
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
index e4d7cbf4861d..cf24d2df6bfc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -84,25 +84,60 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
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
+ * Return the runtime, relative deadline or period @dl_se runs on: its
+ * own, or the copy made by dl_boost().
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
+ * Boost @dl_se with a copy of @params, the reservation recorded in the
+ * rt_mutex node of the top pi waiter of its task. The caller holds the
+ * rq lock and the pi_lock of that task.
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
@@ -731,9 +766,8 @@ static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
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
@@ -808,7 +842,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	WARN_ON_ONCE(pi_of(dl_se)->dl_runtime <= 0);
+	WARN_ON_ONCE(pi_runtime_of(dl_se) <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
@@ -822,8 +856,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
-		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
-		dl_se->runtime = pi_of(dl_se)->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_deadline_of(dl_se);
+		dl_se->runtime = pi_runtime_of(dl_se);
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -836,8 +870,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_of(dl_se)->dl_period;
-		dl_se->runtime += pi_of(dl_se)->dl_runtime;
+		dl_se->deadline += pi_period_of(dl_se);
+		dl_se->runtime += pi_runtime_of(dl_se);
 	}
 
 	/*
@@ -946,9 +980,9 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
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
@@ -3973,10 +4007,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
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
index 0bc778c12af4..b13a9f0143f3 100644
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
@@ -310,7 +310,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * the class. Drop its boost then, as rt_mutex_setprio() does.
 	 */
 	if (!dl_prio(newprio))
-		p->dl.pi_se = &p->dl;
+		p->dl.dl_boosted = 0;
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
-- 
2.47.3

