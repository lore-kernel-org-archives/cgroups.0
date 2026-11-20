Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207376;
	b=w/w3HcvUbFIW08/J7L+TWAWtJU4y9ZvO20eP4MkOQut7JAYUDKxBUV+zJc3c5nSlw/Oo
	 u4fKfEe3inEmXSw/ZuDXU+EqnlHzSL37f4VcXmdUnVbBshy+SmTNK4tHJUVzcT/g+yh5Q
	 gu0lCAeIDtUm0F1yY/vFmk2mvd5+C4Jd5iBxa8trOOtYboazwcGkbwqNQZYZXfMfNgTlD
	 hITeI9MgEV7t3Rx0vGFcGoB9ohEX7Uh8nUhEUHQJEXkKG/lFiHMG4lba6c+TmdjZUIing
	 oG5jmgCw1NT6+fz0uXM3XPw0j4p39gmpWTsEnSjye9Vm5dyCL//1o+kQYYRvhAy4Eww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L7CY1AiM6Bl47j/TqIU6+buC9sJguo7v9T9/RAWf5lg=;
	b=l9Avu9THWHmnhH4yTuoKG0Dv8oMV6a4EmLdaHGISyK8vvtvxVFA9/IsmB7WijN2I15XO
	 K/D3y5RcDxqinNFb2tDldXvspq+mufW8xucqDuBSmku7txX3WFlHaXlXgsTwbf+FXCiau
	 ufChOU+/n8RADV7XxHms1FUDfbeoGlJa44IddkHHZFWDkfXBPxWDjRwdp5VlibZJJHUmr
	 SnK+VYyS2sNhmc7YVSS4m+fPimjGEuXPEkbx1+SJPLi5DwC9LUzLxlz2WceXueBQ+Sun+
	 7SistfODtq88GPzoFLVtPEvXxx3seGHpSMfGjsh4tVqQBlQhrJgMdzpn4OUHTNLNNZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GGWo+5va;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C8E60A5BCF;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C8E60A5BCF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GGWo+5va
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207360;
	bh=L7CY1AiM6Bl47j/TqIU6+buC9sJguo7v9T9/RAWf5lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGWo+5vaGGoA55LjNHU+aUeIIKqSNRowV4QlSNs3W1YsGjiHjlt0YvS6+fnBI8uMl
	 LdG4x4n1WGDLopG3fzTVe/uvssGDOQGkIzJdG4e5/oUOPSlFxWDxPD6QKBKBNkWwKA
	 jm+zh+cmhFMeLVrgCC1atiFoDyWW7RUK96tQi4aDtQsA6hSpvwhP8HB6zd7wMr6QkL
	 hHXJksseYY9uASnKTtUPzwiZbK8SJv+6j3/v3+fwfrASYY4eV0iJ6gLAuhmthRPtlk
	 TqRY5MY1o+ywqjuDeYPR0tuMxLvzkOuQ5MesfGVPHlBeo5ETvbWDT1NMR1G4hHuElc
	 B7mxp9gV593Qg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2R5vpzzSTZ;
	Fri, 20 Nov 2026 15:42:39 -0500 (EST)
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
Subject: [PATCH v10 35/40] sched/deadline: Check the runtime of a task whose parameters change
Date: Fri, 20 Nov 2026 15:42:12 -0500
Message-Id: <f0f5e657ac6bccc75297da3739df812adda360b2.1795207233.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

Commit 40767b0dc768 ("sched/deadline: Fix deadline parameter
modification handling") lets new parameters take effect at the next
period. So sched_setattr() cannot give a task a fresh runtime.

But admission control counts the new bandwidth at once. When a task
shrinks its reservation, the runtime left from the old one is not
checked against the new one. A comment in sched_dl_overflow() names
the gap: the old bandwidth should stay counted until the 0-lag time.

So a running task can shrink its reservation, and still run on the old
one. Other tasks can meanwhile be admitted into the bandwidth it gave
back. On v7.4-rc2, a task of 50ms every 100ms changed to 10ms every
100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule after a change of parameters, as
the previous patch does for a task that enters the class.
__setparam_dl() marks a change of the runtime, the deadline or the
period in dl_new_params. The next enqueue then calls update_dl_entity().
It starts a new period, or reduces the runtime of a constrained task,
if the runtime left does not fit. The task gets no more than a wakeup
would give it. A larger reservation still takes effect at the next
period.

The enqueue flags cannot tell a change of parameters: a cgroup move
also uses ENQUEUE_MOVE. Without the mark, a task that waited behind
others could fail the check, and get a later deadline for no reason.

A boosted task runs on the parameters of its donor. So it keeps the mark
until its deboost. dl_deboost() checks it there, before
rt_mutex_setprio() compares the task with its top waiter. Until then,
the task has the deadline of its old parameters. So rt_mutex_setprio()
deboosts a marked task first, even if its top waiter has the earlier
deadline. It then compares the waiter with the deadline from the check,
and boosts the task again if needed.

dl_deboost() leaves the check to the next enqueue in two cases:
- a constrained task past its deadline and before its next period: the
  enqueue throttles it first.
- a task asleep on anything but an rt_mutex: a period started at the
  deboost would run while it sleeps.

A task blocked on an rt_mutex is not enqueued before its wakeup, but its
waiter node holds its deadline. So sched_setattr() checks the runtime of
such a task at once, in dl_check_blocked_params(), also when the task
comes back to the class. rt_mutex_adjust_pi() then requeues its waiter.
prio_changed_dl() does not check it: a cgroup move or an affinity change
gets there too, and does not requeue the waiter.

Until the check, the 0-lag time of a task that blocks mixes its old
runtime and deadline with its new parameters. When the runtime left
does not fit them, that 0-lag time has passed. The bandwidth is then
released at once, as the check would do. A comment in
dl_time_to_zerolag() now says so.

The change_running_new_params case, added to deadline_bw_test later in
this series, tests this. change_boosted_new_params tests a task that
changes its parameters while boosted. Both fail on v7.4-rc2 and pass
with this patch. deboost_new_params_reboost and boost_new_params_stale
test the check at the deboost. setattr_blocked_new_period tests a task
blocked on an rt_mutex. Without dl_check_blocked_params(), it took the
lock after a waiter with a later deadline, in every run.

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |   5 ++
 kernel/sched/core.c     |   6 +++
 kernel/sched/deadline.c | 106 ++++++++++++++++++++++++++++++++++++----
 kernel/sched/sched.h    |   1 +
 kernel/sched/syscalls.c |   3 ++
 5 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cbd387993607..491ddeea7d65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -715,6 +715,10 @@ struct sched_dl_entity {
 	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
 	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
 	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
+	 * @dl_new_params tells if sched_setattr() changed the runtime, the
+	 * deadline or the period. The next enqueue that is not boosted, or
+	 * the deboost, checks the runtime left against them, and clears it.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -729,6 +733,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
 	unsigned int			dl_bw_oncpu       : 1;
+	unsigned int			dl_new_params     : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 75bfde7046fb..0dce129b4146 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7966,8 +7966,14 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		 *          running task
 		 */
 		if (dl_prio(prio)) {
+			/*
+			 * A boosted task that changed its parameters still has
+			 * the deadline of its old ones. Deboost it first, so
+			 * that its top waiter is compared with its new one.
+			 */
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
+			     !(p->dl.dl_new_params && p->dl.pi_se != &p->dl) &&
 			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
 				struct sched_dl_entity *old_donor = p->dl.pi_se;
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 83aefe5ab671..fe48137509ad 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -93,6 +93,19 @@ static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
 	dl_se->runtime = dl_se->dl_runtime;
 }
 
+/*
+ * Return true if @dl_se has a constrained deadline, and the rq clock is
+ * past its deadline and before its next period. An enqueue then throttles
+ * it until that period.
+ */
+static inline bool dl_in_constrained_gap(struct sched_dl_entity *dl_se)
+{
+	u64 now = rq_clock(rq_of_dl_se(dl_se));
+
+	return !dl_is_implicit(dl_se) && dl_time_before(dl_se->deadline, now) &&
+	       dl_time_before(now, dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period);
+}
+
 #ifdef CONFIG_RT_MUTEXES
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -116,6 +129,14 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 
 static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
 
+static void update_dl_entity(struct sched_dl_entity *dl_se);
+
+/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return p->pi_blocked_on;
+}
+
 /*
  * End the boost of @dl_se, whose task stays in the class. If the boost
  * refilled its runtime from the donor's parameters, start a new period
@@ -124,11 +145,22 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
  * first. Without a refill, the task keeps the runtime and the deadline
  * of its own reservation.
  *
+ * If sched_setattr() changed the parameters during the boost, check the
+ * runtime left against them now, for the same reason. rt_mutex_setprio()
+ * then compares the result with the top waiter. Leave that check to the
+ * next enqueue for a task with a constrained deadline, past its deadline
+ * and before its next period. The enqueue first throttles it until that
+ * period: see dl_check_constrained_dl(). Leave it to the wakeup too, for
+ * a task asleep on anything but an rt_mutex: a period started now would
+ * run while it sleeps.
+ *
  * The caller holds the rq lock and the pi_lock of the task, and has
  * updated the rq clock.
  */
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
+	struct task_struct *p = dl_task_of(dl_se);
+
 	if (dl_se->dl_donor_refill) {
 		dl_start_own_period(dl_se);
 		/*
@@ -145,12 +177,41 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 		}
 	}
 	dl_drop_boost(dl_se);
+
+	if (!task_on_rq_queued(p) && !dl_task_pi_blocked(p))
+		return;
+	if (dl_se->dl_new_params && !dl_se->dl_throttled && dl_in_constrained_gap(dl_se))
+		return;
+	if (dl_se->dl_new_params) {
+		dl_se->dl_new_params = 0;
+		if (!dl_se->dl_throttled)
+			update_dl_entity(dl_se);
+	}
 }
 
-/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
-static inline bool dl_task_pi_blocked(struct task_struct *p)
+/*
+ * Check the runtime of @p against the parameters that sched_setattr() just
+ * gave it, if @p waits on an rt_mutex. Before any wakeup, its waiter node
+ * holds its deadline. The caller then calls rt_mutex_adjust_pi(), which
+ * requeues the waiter with the result. Other changes of @p, such as a
+ * cgroup move, do not requeue it: leave the check to sched_setattr().
+ *
+ * A boosted task, a throttled one, or one past its deadline and before
+ * its next period keeps the mark. Its deboost or its wakeup checks it.
+ * The caller holds the rq lock and the pi_lock of @p, and has updated the
+ * rq clock.
+ */
+void dl_check_blocked_params(struct task_struct *p)
 {
-	return p->pi_blocked_on;
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	if (!dl_task(p) || task_on_rq_queued(p) || !dl_task_pi_blocked(p))
+		return;
+	if (dl_se->dl_new_params && !is_dl_boosted(dl_se) &&
+	    !dl_se->dl_throttled && !dl_in_constrained_gap(dl_se)) {
+		dl_se->dl_new_params = 0;
+		update_dl_entity(dl_se);
+	}
 }
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
@@ -707,6 +768,15 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
  *
  * Each check compares against the bound scaled by dl_runtime / dl_period.
  * That quotient cannot overflow, as dl_runtime <= dl_period.
+ *
+ * After sched_setattr(), the runtime and the deadline can still be those
+ * of the old parameters: a boosted task, or one past its deadline and
+ * before its next period, keeps them until its deboost or its enqueue.
+ * The 0-lag time then mixes them with the new dl_runtime and dl_period.
+ * If the runtime left does not fit the new parameters, the 0-lag time
+ * has passed, and the bandwidth is released at once. The check of the
+ * runtime would start a new period there, with a 0-lag time of now or
+ * before.
  */
 static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 {
@@ -2965,7 +3035,16 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
+	bool new_params = dl_se->dl_new_params;
+
 	WARN_ON_ONCE(on_dl_rq(dl_se));
+	/*
+	 * A boosted task is refilled from its donor. Keep the mark until the
+	 * runtime is checked against its own parameters. dl_deboost() checks
+	 * it at the deboost, and an enqueue that is not boosted checks it.
+	 */
+	if (!is_dl_boosted(dl_se))
+		dl_se->dl_new_params = 0;
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -3014,12 +3093,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
-	} else if ((flags & ENQUEUE_CLASS) && !is_dl_boosted(dl_se)) {
+	} else if (((flags & ENQUEUE_CLASS) || new_params) &&
+		   !is_dl_boosted(dl_se)) {
 		/*
-		 * The task enters the class runnable. It may come back before
-		 * its deadline, with the runtime left from older parameters.
-		 * Check that runtime against the new parameters, as a wakeup
-		 * does.
+		 * The task enters the class, or its parameters change, while
+		 * it is runnable. It may have runtime left from older
+		 * parameters. Check that runtime against the new parameters,
+		 * as a wakeup does.
 		 */
 		update_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_MOVE) &&
@@ -4859,7 +4939,9 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 		 * The chain walk sorts its waiter by its deadline first. A task
 		 * new to the class has a deadline of 0, which goes before every
 		 * real one. Start a new period now, as setup_new_dl_entity()
-		 * does at an enqueue.
+		 * does at an enqueue. dl_check_blocked_params() has checked the
+		 * runtime of a task that sched_setattr() brings back before its
+		 * 0-lag time.
 		 */
 		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
 		    dl_time_before(p->dl.deadline, rq_clock(rq)))
@@ -5179,6 +5261,11 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	u64 period = attr->sched_period ?: attr->sched_deadline;
 	bool held;
 
+	if (attr->sched_runtime != dl_se->dl_runtime ||
+	    attr->sched_deadline != dl_se->dl_deadline ||
+	    period != dl_se->dl_period)
+		dl_se->dl_new_params = 1;
+
 	/*
 	 * Change the bandwidth that the runqueue counts here, with the
 	 * parameters. A task that priority inheritance boosted into the
@@ -5312,6 +5399,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
 }
 
 void init_dl_entity(struct sched_dl_entity *dl_se)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e512091ce5ed..4151364ca4ff 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -414,6 +414,7 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 
 extern void dl_deboost(struct sched_dl_entity *dl_se);
 extern void dl_boost_blocked(struct task_struct *p);
+extern void dl_check_blocked_params(struct task_struct *p);
 
 /* End the boost of @dl_se. The caller holds the rq lock of its task. */
 static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 9884fa55538a..b25504e8748b 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -311,6 +311,9 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 */
 	if (!dl_prio(newprio))
 		dl_drop_boost(&p->dl);
+
+	/* rt_mutex_adjust_pi() then requeues the waiter of a blocked task. */
+	dl_check_blocked_params(p);
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
-- 
2.47.3

