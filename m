Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655358;
	b=Db5ABUgqVuyIja2PgHmoqjpOXGeDut5V4GI6D7NC79jbbrqVd9eRwepix5IvA8DFjG7u
	 vft4U6ufAyQ1lEeMaqiSvmEN663LCvuYaVqPDOgjMosoh74ZH8+f+WEeautBy/f+vu9aa
	 W9WCwXTTuTNTVZ9w6Y3NuGUbe/BL5AVMpDQMXkU/nOQCBKoHKbrjGuBaK7yndhQNRf0b+
	 jEVw6dKDbq04cCxGH0aEHOx+QfNonNchr1Mi7VwrHla9TOkAnZWUeWB8bIPvsMU/vVMxL
	 8QLzBpCFX2xz+uQ3MQ7F+2UKi5m37MGrnVQl5zDzXxEYyqw4MsGADIv7zT0zrDMVa+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655358;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w/LxllS5hbULEf4ra8uG4jW9LrdM19zsrYlJehEWMps=;
	b=VofZtjS8N6HKbbYQQ7hg1YL+dyaXegpjUd7p/I0NOANojAmZgF5AXA9VvR+ik8+Mrie8
	 02S6iAuCPHCQnw+4dZDdqJUEV5EiFZlk+P2YR1fbmyL9i2+8MkdhvBL1TlP8RcpEn6nEf
	 ZZMmJWD+25us86PMUzOBVW2wTszcdaWpmY1/tGJn79NDNAwGjExnUSeV9mJqoWwyJYzI7
	 L1CBb9e1XdSaPBpPfEUA7z6f6PLVe6It7jkrZZlRdppQC8J9zgpqVGYArny6Ao5QHB09G
	 DOL7AkVgQgXYFgA0qzkYhE3L3caL7F3r6jp7P34Tp72BXe+xPUubsuKP7xvkgCTsp0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=rtJygpx4;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0AA6070BAF;
	Thu, 26 Nov 2026 01:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED0AA6070BAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=rtJygpx4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655356;
	bh=w/LxllS5hbULEf4ra8uG4jW9LrdM19zsrYlJehEWMps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtJygpx4iZxmLzwkRXjFC7ikF1aVWew76hgDKcS3CDyzcFxHfDQUxdlC3Fkp7yStB
	 VKcoM1p/Aym3AiwP8J72z56x0H+MlJa634MaPkRgNlYEzDIHiuektf5NZ1RpzGB9EM
	 WJaIXTt4X3sRpjs2NC7II/kz3VYBzPoHS9yicSgicj8u/DGeM/D+0arGWh5ki2S3/a
	 JDVtdXXCH3IQ7S5p3GksNzFI/3ljWEkrxJESfkqC3n4/XB8FLv5p4sAVgwfJDV9v+N
	 Hrykz7c7m3O2FYDofUlFfbT3dUSF7pE0CwbPLSGCs4vH5ccqAfk0aSTTEgrTiaUKEV
	 hkZUEkqlFnqkg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjl40SkzWB1;
	Wed, 25 Nov 2026 20:09:15 -0500 (EST)
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
Subject: [PATCH v11 38/43] sched/deadline: Boost an owner that cannot run on its own reservation
Date: Wed, 25 Nov 2026 20:08:37 -0500
Message-ID: <29af731a1e529469abd92e902bcc8126f8cbe972.1795646914.git.mathieu.desnoyers@efficios.com>
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

rt_mutex_setprio() lets a deadline waiter boost the owner of the lock
only if the waiter's deadline is earlier than the owner's. Commit
2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
added this test with the boost. The boost is there to "ensure a pi-lock
owner with waiters is never throttled down". The test assumes that the
owner runs on its current deadline. Two owners do not:
- An owner that ran out of runtime is throttled until its next period.
  Its deadline is often earlier than the waiter's.
- A constrained owner past its deadline and before its next period is
  in its constrained gap. Its deadline has passed. Its next enqueue
  throttles it, since commit df8eac8cafce ("sched/deadline: Throttle a
  constrained deadline task activated after the deadline").

The waiter does not boost these owners. It waits for the owner's next
period, and can miss its own deadline. This holds for a deadline task
that waits on a PI futex, or on an rt_mutex in the kernel.

Fix the test in a new dl_waiter_boosts(): a throttled owner, or one in
its constrained gap, is always boosted. In M-BWI [1], an owner runs in
the reservation of a waiter when its own cannot run. Another owner past
its deadline is compared at now + dl_deadline, the deadline its next
enqueue gives it.

Such a boost is held from its start, until the owner's own next period.
The new dl_boost_start() saves the owner's period, as a boost held at
its first refill does. The new dl_boost_donor_period() then runs the
owner on a period of the donor's parameters, starting now. A refill
from the owner's own deadline would often end after the waiter's.

Nothing charges the donor for this time. A waiter that times out again
and again would give the owner one donor runtime per boost. So the
deboost keeps the donor period, and the next held boost resumes it,
until a whole donor period has passed. The resumed runtime is capped at
what the donor's density allows until the deadline, as
update_dl_revised_wakeup() does.

The patch also handles these cases:
- At the deboost, an owner throttled while asleep is throttled again
  until its own next period, with its timer moved there.
- A yield gave up the rest of the owner's own period: dl_boost_start()
  saves no runtime for it, and the donor period ignores the yield.
- sched_setattr() during a held boost fits the saved period to the new
  parameters, as for a boost held at its first refill.
- replenish_dl_entity() no longer warns that it "lagged too much" when
  it refills a boosted entity past its deadline.
- In a lock cycle, the top waiter's donor can be the owner itself.
  dl_set_donor() now reports it, and rt_mutex_setprio() ends the boost
  instead of leaving it held. A Spin model of the chain walk found this.

The limit is per owner: a waiter that boosts N owners in turn gives
them N donor runtimes per donor period. The limit also needs a donor
with an implicit deadline. An owner with no parameters of its own still
has no limit, as before this patch.

The Sashiko AI review of this series found the gap case.
"selftests/sched: Test parameter changes in deadline_bw_test", later in
this series, lists the cases that fail without this patch.

[1] D. Faggioli, G. Lipari, T. Cucinotta, "Analysis and Implementation
    of the Multiprocessor BandWidth Inheritance Protocol", Real-Time
    Systems, 2012, section 5.1

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Fixes: df8eac8cafce ("sched/deadline: Throttle a constrained deadline task activated after the deadline")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  18 +++-
 kernel/sched/core.c     |  36 +++++---
 kernel/sched/deadline.c | 183 +++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h    |  17 +++-
 kernel/sched/syscalls.c |   4 +-
 5 files changed, 218 insertions(+), 40 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 148e2939e6cb..cafa26c874b0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -681,6 +681,10 @@ struct sched_dl_entity {
 			u64		setattr_period;
 		};
 	};
+	/* Saved by dl_end_held_boost(): see dl_boost_granted */
+	u64				boost_deadline;
+	s64				boost_runtime;
+	u64				boost_period_start;
 	unsigned int			flags;		/* Specifying the scheduler behaviour	*/
 
 	/*
@@ -710,9 +714,12 @@ struct sched_dl_entity {
 	 * reservation. The end of the boost clears the flag.
 	 *
 	 * @dl_boost_held tells that own_deadline, own_runtime and
-	 * own_period_start hold the task's own period. The first refill of a
-	 * boost saves them, for a task with parameters of its own. The deboost
-	 * puts them back.
+	 * own_period_start hold the task's own period. dl_boost_start() saves
+	 * them for a task that could not run on its own reservation: it was
+	 * throttled, or past its deadline and before its next period. While a
+	 * waiter waits, that boost lasts at least until the task's own next
+	 * period. The first refill of any other boost saves them too, for a
+	 * task with parameters of its own. The deboost puts them back.
 	 *
 	 * @dl_server tells if this is a server entity.
 	 *
@@ -754,6 +761,10 @@ struct sched_dl_entity {
 	 * setattr_runtime, setattr_deadline and setattr_period hold the old
 	 * parameters. The first refill or the deboost fits the period to the
 	 * new ones with them.
+	 *
+	 * @dl_boost_granted tells if boost_deadline, boost_runtime and
+	 * boost_period_start hold the donor period that the last held boost
+	 * ran on. dl_boost_donor_period() can resume it.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -770,6 +781,7 @@ struct sched_dl_entity {
 	unsigned int			dl_bw_attached    : 1;
 	unsigned int			dl_bw_oncpu       : 1;
 	unsigned int			dl_new_params     : 1;
+	unsigned int			dl_boost_granted  : 1;
 	unsigned int			dl_setattr_saved  : 1;
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fa032d6dc873..c1e043d27b67 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7961,9 +7961,9 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		 * 1. -rt task is running and holds mutex A
 		 *      --> -dl task blocks on mutex A
 		 *
-		 * 2. -dl task is running and holds mutex A
-		 *      --> -dl task blocks on mutex A and could preempt the
-		 *          running task
+		 * 2. -dl task holds mutex A
+		 *      --> -dl task blocks on mutex A, and dl_waiter_boosts()
+		 *          returns true for it
 		 */
 		if (dl_prio(prio)) {
 			/*
@@ -7975,13 +7975,27 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
 			     !(p->dl.dl_new_params && p->dl.pi_se != &p->dl) &&
-			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
+			     dl_waiter_boosts(p, pi_task))) {
 				struct sched_dl_entity *old_donor = p->dl.pi_se;
 
-				dl_set_donor(&p->dl, pi_task);
-				scope->flags |= ENQUEUE_REPLENISH;
-				if (!scope->queued && p->dl.pi_se != old_donor)
-					dl_boost_blocked(p);
+				if (!dl_set_donor(&p->dl, pi_task)) {
+					/*
+					 * The donor of the top waiter is @p: @p waits
+					 * on a lock that it owns. End the boost of a
+					 * deadline task, as a deboost does. Another
+					 * task keeps its donor: a deboost would leave
+					 * it in the class with no parameters.
+					 */
+					if (dl_prio(p->normal_prio) && old_donor != &p->dl)
+						dl_deboost(&p->dl);
+				} else {
+					if (dl_prio(p->normal_prio) &&
+					    old_donor == &p->dl && p->dl.pi_se != &p->dl)
+						dl_boost_start(&p->dl);
+					scope->flags |= ENQUEUE_REPLENISH;
+					if (!scope->queued && p->dl.pi_se != old_donor)
+						dl_boost_blocked(p);
+				}
 			} else {
 				dl_deboost(&p->dl);
 				/*
@@ -7990,8 +8004,10 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				 * task again then.
 				 */
 				if (pi_task && dl_prio(pi_task->prio) &&
-				    dl_entity_preempt(&pi_task->dl, &p->dl)) {
-					dl_set_donor(&p->dl, pi_task);
+				    dl_waiter_boosts(p, pi_task) &&
+				    dl_set_donor(&p->dl, pi_task)) {
+					if (p->dl.pi_se != &p->dl)
+						dl_boost_start(&p->dl);
 					scope->flags |= ENQUEUE_REPLENISH;
 				}
 			}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1ec7789e81b8..a526497c099c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -96,10 +96,10 @@ static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
 
 /*
  * Put back the deadline, runtime and period start saved when the boost
- * was held, by dl_hold_refilled_boost(). If the task's own next period
- * has started since, start a period of its own instead. Return true if
- * the boost was held. The caller holds the rq lock and has updated the
- * rq clock.
+ * was held, by dl_boost_start() or dl_hold_refilled_boost(). If the
+ * task's own next period has started since, start a period of its own
+ * instead. Return true if the boost was held. The caller holds the rq
+ * lock and has updated the rq clock.
  */
 static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se)
 {
@@ -107,6 +107,14 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se)
 
 	if (!dl_se->dl_boost_held)
 		return false;
+	/*
+	 * Keep what is left of the donor period, for the next held boost to
+	 * resume: see dl_boost_donor_period().
+	 */
+	dl_se->boost_deadline = dl_se->deadline;
+	dl_se->boost_runtime = dl_se->runtime;
+	dl_se->boost_period_start = dl_se->period_start;
+	dl_se->dl_boost_granted = 1;
 	if (dl_time_before(now, dl_se->own_period_start + dl_se->dl_period)) {
 		dl_se->deadline = dl_se->own_deadline;
 		dl_se->runtime = dl_se->own_runtime;
@@ -126,7 +134,15 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se)
 					       (dl_se->dl_density *
 						(dl_se->deadline - now)) >> BW_SHIFT);
 	} else {
+		/*
+		 * A new period lifts the throttle. A task asleep since
+		 * before the boost still has its replenishment timer armed
+		 * for its old next period: cancel it.
+		 */
 		dl_start_own_period(dl_se);
+		dl_se->dl_throttled = 0;
+		if (hrtimer_try_to_cancel(&dl_se->dl_timer) == 1)
+			put_task_struct(dl_task_of(dl_se));
 	}
 	dl_se->dl_donor_refill = 0;
 	return true;
@@ -179,9 +195,12 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 }
 
 static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
-static int start_dl_timer(struct sched_dl_entity *dl_se);
 
 static void update_dl_entity(struct sched_dl_entity *dl_se);
+static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
+					   struct rq *rq);
+static int start_dl_timer(struct sched_dl_entity *dl_se);
+static void cancel_replenish_timer(struct sched_dl_entity *dl_se);
 
 /* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
 static inline bool dl_task_pi_blocked(struct task_struct *p)
@@ -196,10 +215,10 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
  * End the boost of @dl_se, whose task stays in the class. Then bring the
  * runtime and the deadline of the task back to its own parameters:
  *  - After a held boost, dl_end_held_boost() puts back the values that
- *    dl_hold_refilled_boost() saved. The time the task ran on the
- *    donor's refills is not charged to its own runtime. If that runtime
- *    is used up, throttle the task again until its own next period, or
- *    start that period if it has started.
+ *    dl_boost_start() or dl_hold_refilled_boost() saved. The time the
+ *    task ran on its donor's parameters is not charged to its own
+ *    runtime. If that runtime is used up, throttle the task again until
+ *    its own next period, or start that period if it has started.
  *  - After a refill of a task that had no parameters of its own at the
  *    refill, start a new period now. dl_hold_refilled_boost() holds the
  *    boost of a task that had them.
@@ -264,6 +283,13 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	if (held && dl_se->runtime <= 0) {
 		struct rq *rq = task_rq(p);
 
+		/*
+		 * The timer can still be armed. enqueue_task_dl() cancels it
+		 * when it boosts a runnable task, but a task that slept through
+		 * the boost kept it. sched_setattr() can have moved the task's
+		 * next period since. Cancel the timer before arming it again.
+		 */
+		cancel_replenish_timer(dl_se);
 		dl_se->dl_throttled = 1;
 		if (!start_dl_timer(dl_se)) {
 			dl_se->dl_throttled = 0;
@@ -347,6 +373,114 @@ void dl_check_blocked_params(struct task_struct *p)
 		update_dl_entity(dl_se);
 	}
 }
+
+/*
+ * Return true if the deadline waiter @pi_task must boost the owner @p,
+ * which has a deadline policy of its own. Compare @pi_task with the
+ * deadline that @p would run on:
+ * - The boost of @p is held: keep it until the next period of @p
+ *   starts. After that, compare with now + dl_deadline.
+ * - @p is not boosted, and cannot run on its own reservation. It is
+ *   throttled, or past its deadline and before its next period. Boost it.
+ * - @p is not boosted, and past its deadline otherwise: its next enqueue
+ *   starts a new period. Compare with now + dl_deadline.
+ * - Else, compare with the deadline of @p.
+ * A special entity (a sugov kthread) always boosts @p.
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
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t);
+
+/*
+ * Run @dl_se, whose boost is held, on a period of its donor. Resume the
+ * donor period that the last held boost ran on, unless a whole period of
+ * the current donor has passed since it started. A new period at each
+ * boost would give the task one donor runtime per boost. Nothing charges
+ * the donor for that runtime.
+ *
+ * If the deadline of the resumed period has passed, move to its next
+ * period here, with a full donor runtime. A later enqueue would
+ * otherwise start a period from now, which gives a second donor runtime
+ * too early. As in a refill by replenish_dl_entity(), the task can use
+ * that runtime at once, although its period starts in the future.
+ *
+ * Cap the runtime to the donor's density until the deadline, as
+ * update_dl_revised_wakeup() does at the wakeup of a constrained task.
+ */
+static void dl_boost_donor_period(struct sched_dl_entity *dl_se)
+{
+	struct sched_dl_entity *pi_se = pi_of(dl_se);
+	struct rq *rq = rq_of_dl_se(dl_se);
+	u64 runtime = READ_ONCE(pi_se->dl_runtime);
+	u64 period = READ_ONCE(pi_se->dl_period);
+	u64 now = rq_clock(rq);
+
+	if (dl_se->dl_boost_granted && runtime && period &&
+	    dl_time_before(now, dl_se->boost_period_start + period)) {
+		dl_se->period_start = dl_se->boost_period_start;
+		dl_se->deadline = dl_se->boost_deadline;
+		dl_se->runtime = dl_se->boost_runtime;
+		if (!dl_time_before(now, dl_se->deadline)) {
+			dl_se->period_start += period;
+			dl_se->deadline += period;
+			dl_se->runtime = runtime;
+		}
+		if (dl_entity_overflow(dl_se, now))
+			dl_se->runtime = (READ_ONCE(pi_se->dl_density) *
+					  (dl_se->deadline - now)) >> BW_SHIFT;
+		return;
+	}
+	replenish_dl_new_period(dl_se, rq);
+}
+
+/*
+ * Call this when @dl_se gets its first donor, after dl_set_donor(). If
+ * @dl_se cannot run on its own reservation, hold the boost from now. Save
+ * its deadline, runtime and period start in own_*, and set dl_boost_held.
+ * Then run it on a period of the donor. A refill would instead add donor
+ * periods to its own deadline. That is often later than the waiter's.
+ *
+ * A task with no parameters of its own has nothing to save. The caller
+ * holds the rq lock and has updated the rq clock.
+ */
+void dl_boost_start(struct sched_dl_entity *dl_se)
+{
+	if (!dl_se->dl_runtime ||
+	    (!dl_se->dl_throttled && !dl_in_constrained_gap(dl_se)))
+		return;
+	/*
+	 * A yield gave up the rest of the task's own period: save no runtime
+	 * for it. The yield does not apply to the donor period placed below.
+	 */
+	dl_se->own_deadline = dl_se->deadline;
+	dl_se->own_runtime = dl_se->dl_yielded ? 0 : dl_se->runtime;
+	dl_se->own_period_start = dl_se->period_start;
+	dl_se->dl_boost_held = 1;
+	dl_se->dl_yielded = 0;
+	dl_boost_donor_period(dl_se);
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -1644,7 +1778,13 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * entity.
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
-		printk_deferred_once("sched: DL replenish lagged too much\n");
+		/*
+		 * dl_waiter_boosts() can boost an owner past its deadline: do
+		 * not warn for a boosted entity. The new period takes the
+		 * donor's parameters.
+		 */
+		if (!is_dl_boosted(dl_se))
+			printk_deferred_once("sched: DL replenish lagged too much\n");
 		replenish_dl_new_period(dl_se, rq);
 	}
 
@@ -5548,10 +5688,10 @@ static u64 dl_mul_div_cap(u64 a, u64 b, u64 c, u64 cap)
 /*
  * Fit a period of @dl_se to its new parameters. sched_setattr() changed
  * them from @old_runtime, @old_deadline and @old_period. At @now,
- * *@start, *@deadline and *@runtime describe the period in progress
- * under the old parameters. On return, they describe a period under the
- * new ones. Return true if the task must wait for that period, with no
- * runtime.
+ * *@start, *@deadline and *@runtime describe a period under the old
+ * parameters: the one in progress, or the one that a held boost keeps
+ * aside. On return, they describe a period under the new ones. Return
+ * true if the task must wait for that period, with no runtime.
  *
  * These terms are used below:
  *  - The release of the job is *@deadline - @old_deadline.
@@ -5692,12 +5832,14 @@ static bool dl_setattr_place(struct sched_dl_entity *dl_se, u64 now,
  *    deboost comes first, dl_deboost() or dl_drop_boost_out() fits it.
  *
  * Return true if the runtime left or the period still needs work later.
- * That is the case for a boosted task: its deboost does it. A task with
- * no period under the old parameters needs it too: its next enqueue
- * checks the runtime left as a wakeup does. Return false for any other
- * task: it is now in a period of the new parameters. The wakeup check
- * rounds to the microsecond. It could find an overflow there and start
- * a new period, which the debt does not allow.
+ * That is the case for a boosted task: its deboost does it. dl_new_params
+ * also makes rt_mutex_setprio() deboost it, and compare it again with
+ * its top waiter. A task with no period under the old parameters needs
+ * it too: its next enqueue checks the runtime left as a wakeup does.
+ * Return false for any other task: it is now in a period of the new
+ * parameters. The wakeup check rounds to the microsecond. It could find
+ * an overflow there and start a new period, which the debt does not
+ * allow.
  *
  * The caller holds the rq lock and the pi_lock of the task, and has
  * updated the rq clock. The task is not on its dl_rq: every caller runs
@@ -5966,6 +6108,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
 	dl_se->dl_new_params		= 0;
+	dl_se->dl_boost_granted		= 0;
 	dl_se->dl_setattr_saved		= 0;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 43aef9b61b67..f5a4e033f335 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -386,24 +386,31 @@ static inline void dl_replace_donor(struct sched_dl_entity *dl_se,
  * put_task_struct() frees it through call_rcu(), and the rq lock holds
  * off the grace period.
  *
+ * The donor of @pi_task can be @dl_se itself: the task of @dl_se then
+ * waits, through @pi_task, on a lock that it owns, while a chain walk is
+ * in progress. Return false then, and leave the donor as it is. Return
+ * true if @dl_se has the donor of @pi_task.
+ *
  * The caller holds the rq lock and the pi_lock of the task of @dl_se.
  */
-static inline void dl_set_donor(struct sched_dl_entity *dl_se,
+static inline bool dl_set_donor(struct sched_dl_entity *dl_se,
 				struct task_struct *pi_task)
 {
 	struct sched_dl_entity *pi_se;
 
 	for (;;) {
 		pi_se = READ_ONCE(pi_task->dl.pi_se);
+		if (pi_se == dl_se)
+			return false;
 		if (pi_se == dl_se->pi_se)
-			return;
-		if (pi_se == dl_se ||
-		    tryget_task_struct(container_of(pi_se, struct task_struct, dl)))
+			return true;
+		if (tryget_task_struct(container_of(pi_se, struct task_struct, dl)))
 			break;
 		/* Pairs with the ordering of refcount_dec_and_test(). */
 		smp_rmb();
 	}
 	dl_replace_donor(dl_se, pi_se);
+	return true;
 }
 
 /* Make @dl_se its own donor. The caller holds the rq lock of its task. */
@@ -416,6 +423,8 @@ extern void dl_deboost(struct sched_dl_entity *dl_se);
 extern void dl_drop_boost_out(struct sched_dl_entity *dl_se);
 extern void dl_boost_blocked(struct task_struct *p);
 extern void dl_check_blocked_params(struct task_struct *p);
+extern bool dl_waiter_boosts(struct task_struct *p, struct task_struct *pi_task);
+extern void dl_boost_start(struct sched_dl_entity *dl_se);
 
 /*
  * End the boost of @dl_se, and forget the deadline and runtime saved for
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 4f26601f0530..165f407f45b3 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -315,10 +315,8 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	if (dl_prio(newprio) && !dl_policy(policy)) {
 		struct task_struct *pi_task = rt_mutex_get_top_task(p);
 
-		if (pi_task) {
-			dl_set_donor(&p->dl, pi_task);
+		if (pi_task && dl_set_donor(&p->dl, pi_task))
 			scope->flags |= ENQUEUE_REPLENISH;
-		}
 	}
 
 	/*
-- 
2.47.3

