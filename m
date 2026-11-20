Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207372;
	b=UuWHkvLO4oGj4/MGbc7qTXmHp9D9uaugCvovRtOzxgmX4rHIRpsf5799VK37Gfgvtncm
	 TPXD0qwgFHSPYLGIR7emgK2LV7OpGP79D5UgDDxZ5KkNKsxSh9N9r/oVVHduSRfPC76lY
	 msQs2W850cg3GwyZGKO86bGn0FFzEyJ9J79Yjq9dHBYKy19GJimB+XA1uP/hDFWdUu49L
	 AqdcKDyDPMfN8zAbTQJRq+F4WHdo5qXBL9HL1Zns48Jkoed67IFI+oMytP31YneJsW5GL
	 lZQ1keJa8mkXYCRwLSmv7oMy7alk1iNf9UslujPGIFlD5VwVM9bzLeT5wS7owaRHocA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207372;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YXUWfEVAXloR8LkoMC9RWnVkSMtfOwquMWSjikHkl4A=;
	b=r+dKViBNkvpP1bj7IcsEQKu7EK7bJvUm4+r9pVfp+jY8Kcm0jtWelkBq2IdJgGxBjdKr
	 3Go2X/Q/C5eIKjjZ+vmd8xEfNv6ToPsgytgYt9iiLcx1T0ZRScH2GpPpEeXrqAADBf2BT
	 qGBX/H2HKT/vVOBzoXTz4EpROe+j+Y9rdSdI6600cVX6FpGSL9lNTBUUb4pLWvOrrXPIq
	 saURcUIfPfxZUXwyCqkCvIE4S3wqk/94sjpCeJo1oIaHDcysm3qqrm6Q0IwT0BxKxDyYg
	 RvIvEmWKWIm/QpFBido0Nou01tcfm1CA2zbSRpqrB/YWspLcz6H/txGhQM9L5GxrfLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Cw4HYl3b;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7102560A6F59;
	Fri, 20 Nov 2026 20:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7102560A6F59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Cw4HYl3b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207360;
	bh=YXUWfEVAXloR8LkoMC9RWnVkSMtfOwquMWSjikHkl4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw4HYl3b0OASV6QaKN5LYJrBVUz8hOyFTYf4IiYdqmjsujEONr4XDGI/9+83paeff
	 V3qTThYqHyLzJtJiG7KF8WLN1iuiktmW2g/VVCyKloKvMkN8rGLh/kZuXc3Etv6MkE
	 YkMEvJY+4Ea3KjRA5kX04Hfv6HtMbM2hCAiwjnO0mNPkygB7Y3LXw4jE/sN1Z3vO+2
	 aFb6lz4PdEySdAPzJxG88B0bLBRSO2YsT2YuWQL+vYTLtwqFZDF+7qtqyyU+qu+lDP
	 l8NTA8ZEbb5uuPZjndR5gxOH/17rO+xx/5FyaVVGPMCnpzTfmzH0qg7PR9rLwpG/Zx
	 Pe/1drCBi3DOg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2S5zWvzV89;
	Fri, 20 Nov 2026 15:42:40 -0500 (EST)
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
Subject: [PATCH v10 38/40] sched/deadline: Boost an owner that cannot run on its own reservation
Date: Fri, 20 Nov 2026 15:42:15 -0500
Message-Id: <297755d1d8dde37f65e12a4cd502c6332011f44c.1795207233.git.mathieu.desnoyers@efficios.com>
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

rt_mutex_setprio() lets a deadline waiter boost the owner of the lock if
the waiter's deadline is earlier than the owner's.
Commit 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance
logic") added this test. A boosted owner is not throttled: when its
runtime runs out, it is refilled from the waiter's parameters.

The test assumes that the owner runs on its own deadline. Two kinds of
owners cannot:
- An owner that ran out of runtime is throttled until its next period.
- An owner with a constrained deadline, past its deadline and before its
  next period, is throttled at its next enqueue.
  Commit df8eac8cafce ("sched/deadline: Throttle a constrained deadline
  task activated after the deadline") does this.

Such an owner can still have the earlier deadline. A deadline that has
passed is always the earlier one. So the waiter does not boost such an
owner. It waits until the owner's next period: up to dl_period -
dl_deadline for a constrained owner. Before "sched/deadline: Reschedule
a running task throttled at its enqueue", a running owner in that gap
kept the CPU. It usually released the lock then. That patch now stops
it at once, so its waiters wait.

An owner past its deadline and not in that gap gets a new period at its
next enqueue. Its deadline is then now + dl_deadline, which can be
after the waiter's. The waiter does not boost it either.

Fix this by comparing the waiter with the deadline that the owner would
run on, in dl_waiter_boosts():
- A throttled owner, or one in that gap, is always boosted. The boost
  lasts until the owner's own next period.
- Another owner past its deadline is compared at now + dl_deadline.

dl_boost_start() saves the deadline, runtime and period start of an
owner boosted this way, and dl_deboost() puts them back. The time the
owner ran boosted was the donor's. If the owner blocked while boosted,
its inactive timer was armed from the donor's runtime and deadline.
dl_deboost() then works out its 0-lag time again. replenish_dl_entity()
no longer warns about a boosted owner with an expired deadline. It
starts a period of the donor.

The Sashiko AI review of this series found the gap case. The cases
pi_owner_asleep_in_gap and pi_owner_throttled of deadline_bw_test,
added later in this series, test the two kinds of owners. Both fail
without this patch. pi_owner_throttled_asleep tests the 0-lag time
worked out again at the deboost. It fails without this patch too.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  12 +++++
 kernel/sched/core.c     |   9 +++-
 kernel/sched/deadline.c | 104 +++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h    |   3 ++
 4 files changed, 113 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 244e57fa8c21..3282fc337715 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -662,6 +662,10 @@ struct sched_dl_entity {
 	s64				runtime;	/* Remaining runtime for this instance	*/
 	u64				deadline;	/* Absolute deadline for this instance	*/
 	u64				period_start;	/* Absolute start of this instance	*/
+	/* Saved by dl_boost_start(): see dl_boost_held */
+	u64				own_deadline;
+	s64				own_runtime;
+	u64				own_period_start;
 	unsigned int			flags;		/* Specifying the scheduler behaviour	*/
 
 	/*
@@ -720,6 +724,13 @@ struct sched_dl_entity {
 	 * @dl_new_params tells if sched_setattr() changed the runtime, the
 	 * deadline or the period. The next enqueue that is not boosted, or
 	 * the deboost, checks the runtime left against them, and clears it.
+	 *
+	 * @dl_boost_held tells if a waiter boosts the task because the task
+	 * could not run on its own reservation: it was throttled, or past its
+	 * deadline and before its next period. The boost then lasts until
+	 * the task's own next period at least. The deboost puts back the
+	 * deadline, runtime and period start saved in own_deadline,
+	 * own_runtime and own_period_start.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -735,6 +746,7 @@ struct sched_dl_entity {
 	unsigned int			dl_bw_attached    : 1;
 	unsigned int			dl_bw_oncpu       : 1;
 	unsigned int			dl_new_params     : 1;
+	unsigned int			dl_boost_held     : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0dce129b4146..cbe0dfe26de3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7974,10 +7974,13 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
 			     !(p->dl.dl_new_params && p->dl.pi_se != &p->dl) &&
-			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
+			     dl_waiter_boosts(p, pi_task))) {
 				struct sched_dl_entity *old_donor = p->dl.pi_se;
 
 				dl_set_donor(&p->dl, pi_task);
+				if (dl_prio(p->normal_prio) && old_donor == &p->dl &&
+				    p->dl.pi_se != &p->dl)
+					dl_boost_start(&p->dl);
 				scope->flags |= ENQUEUE_REPLENISH;
 				if (!scope->queued && p->dl.pi_se != old_donor)
 					dl_boost_blocked(p);
@@ -7989,8 +7992,10 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				 * Boost the task again then.
 				 */
 				if (pi_task && dl_prio(pi_task->prio) &&
-				    dl_entity_preempt(&pi_task->dl, &p->dl)) {
+				    dl_waiter_boosts(p, pi_task)) {
 					dl_set_donor(&p->dl, pi_task);
+					if (p->dl.pi_se != &p->dl)
+						dl_boost_start(&p->dl);
 					scope->flags |= ENQUEUE_REPLENISH;
 				}
 			}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e9b3d3ec71d7..ff1c104f6afd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -146,6 +146,10 @@ static inline bool dl_task_pi_blocked(struct task_struct *p)
  * first. Without a refill, the task keeps the runtime and the deadline
  * of its own reservation.
  *
+ * A boost that dl_boost_start() held puts back the deadline, runtime
+ * and period start it saved instead. The donor's reservation paid for
+ * the time the task ran boosted.
+ *
  * If sched_setattr() changed the parameters during the boost, check the
  * runtime left against them now, for the same reason. rt_mutex_setprio()
  * then compares the result with the top waiter. Leave that check to the
@@ -161,21 +165,32 @@ static inline bool dl_task_pi_blocked(struct task_struct *p)
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
 	struct task_struct *p = dl_task_of(dl_se);
+	bool own = false;
 
+	/* Put back what dl_boost_start() saved. */
+	if (dl_se->dl_boost_held) {
+		dl_se->deadline = dl_se->own_deadline;
+		dl_se->runtime = dl_se->own_runtime;
+		dl_se->period_start = dl_se->own_period_start;
+		dl_se->dl_donor_refill = 0;
+		own = true;
+	}
 	if (dl_se->dl_donor_refill) {
 		dl_start_own_period(dl_se);
-		/*
-		 * A task asleep since the refill has its inactive timer armed
-		 * from the donor's runtime and deadline. The 0-lag time of the
-		 * new period is now: stop counting the task in running_bw
-		 * now. If the timer handler is already running, it does that.
-		 */
-		if (dl_se->dl_non_contending &&
-		    hrtimer_try_to_cancel(&dl_se->inactive_timer) == 1) {
-			dl_se->dl_non_contending = 0;
-			put_task_struct(dl_task_of(dl_se));
-			task_non_contending(dl_se, true);
-		}
+		own = true;
+	}
+	/*
+	 * A task that blocked while boosted has its inactive timer armed
+	 * from the donor's runtime and deadline. Cancel it, and work out the
+	 * 0-lag time again from the runtime and deadline the task gets back.
+	 * After a new period, that 0-lag time is now. If the timer handler
+	 * is already running, it releases the bandwidth.
+	 */
+	if (own && dl_se->dl_non_contending &&
+	    hrtimer_try_to_cancel(&dl_se->inactive_timer) == 1) {
+		dl_se->dl_non_contending = 0;
+		put_task_struct(p);
+		task_non_contending(dl_se, true);
 	}
 	dl_drop_boost(dl_se);
 
@@ -214,6 +229,62 @@ void dl_check_blocked_params(struct task_struct *p)
 		update_dl_entity(dl_se);
 	}
 }
+
+/*
+ * Return true if the deadline waiter @pi_task must boost the owner @p,
+ * which has a deadline policy of its own. Compare @pi_task with the
+ * deadline that @p would run on:
+ * - @p is throttled, or past its deadline and before its next period:
+ *   it cannot run on its own reservation. Boost it.
+ * - @p was boosted for that reason: keep the boost until its own next
+ *   period. After that period starts, compare with now + dl_deadline.
+ * - @p is past its deadline otherwise: its next enqueue starts a new
+ *   period. Compare with now + dl_deadline.
+ * - Else, compare with the deadline of @p.
+ * A special entity, such as a sugov kthread, always boosts @p.
+ *
+ * The caller holds the rq lock of @p and has updated the rq clock.
+ */
+bool dl_waiter_boosts(struct task_struct *p, struct task_struct *pi_task)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+	u64 now = rq_clock(task_rq(p));
+
+	if (dl_entity_is_special(&pi_task->dl))
+		return true;
+	if (dl_se->dl_boost_held) {
+		if (dl_time_before(now, dl_se->own_period_start + dl_se->dl_period))
+			return true;
+		return dl_time_before(pi_task->dl.deadline, now + dl_se->dl_deadline);
+	}
+	if (!is_dl_boosted(dl_se)) {
+		if (dl_se->dl_throttled || dl_in_constrained_gap(dl_se))
+			return true;
+		if (dl_time_before(dl_se->deadline, now))
+			return dl_time_before(pi_task->dl.deadline,
+					      now + dl_se->dl_deadline);
+	}
+	return dl_entity_preempt(&pi_task->dl, dl_se);
+}
+
+/*
+ * Call this when @dl_se gets its first donor, after dl_set_donor()
+ * installed it. If @dl_se cannot run on its own reservation, save its
+ * deadline, runtime and period start in own_*. Then set dl_boost_held.
+ * dl_deboost() puts them back. A task with no parameters of its own has
+ * nothing to save. The caller holds the rq lock and has updated the rq
+ * clock.
+ */
+void dl_boost_start(struct sched_dl_entity *dl_se)
+{
+	if (!dl_se->dl_runtime ||
+	    (!dl_se->dl_throttled && !dl_in_constrained_gap(dl_se)))
+		return;
+	dl_se->own_deadline = dl_se->deadline;
+	dl_se->own_runtime = dl_se->runtime;
+	dl_se->own_period_start = dl_se->period_start;
+	dl_se->dl_boost_held = 1;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -1443,7 +1514,13 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * entity.
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
-		printk_deferred_once("sched: DL replenish lagged too much\n");
+		/*
+		 * dl_waiter_boosts() boosts an owner past its deadline. Its
+		 * deadline is then expected to be in the past: do not warn.
+		 * The new period takes the donor's parameters.
+		 */
+		if (!is_dl_boosted(dl_se))
+			printk_deferred_once("sched: DL replenish lagged too much\n");
 		replenish_dl_new_period(dl_se, rq);
 	}
 
@@ -5420,6 +5497,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
 	dl_se->dl_new_params		= 0;
+	dl_se->dl_boost_held		= 0;
 }
 
 void init_dl_entity(struct sched_dl_entity *dl_se)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4151364ca4ff..447aac4c0227 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -415,12 +415,15 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 extern void dl_deboost(struct sched_dl_entity *dl_se);
 extern void dl_boost_blocked(struct task_struct *p);
 extern void dl_check_blocked_params(struct task_struct *p);
+extern bool dl_waiter_boosts(struct task_struct *p, struct task_struct *pi_task);
+extern void dl_boost_start(struct sched_dl_entity *dl_se);
 
 /* End the boost of @dl_se. The caller holds the rq lock of its task. */
 static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
 {
 	dl_clear_donor(dl_se);
 	dl_se->dl_donor_refill = 0;
+	dl_se->dl_boost_held = 0;
 }
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
-- 
2.47.3

