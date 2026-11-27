Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790187;
	b=IvFzP12CnLhw4b5FRE9t6m0VtEnhxDzEAQmUJ/Rh1K3Nva/XNdlUOSxPrd2KJheYl1V2
	 pgMxLCAgjDE64Y3NbWRwuMsp+3QBo5nEcq2zVhjtXqhoDOZiLv/aMqPI9TSYJ8UmPGrMC
	 d+EDkq4RZeug1NjVJEwIX15+qD1zBcM5MSj2NPtse71HAHU9B+PQOTgghHVL/Rxik7tR0
	 bedydmvGFfejcC8UuTeEIcq6KjvO9sBPUdovp18CSm2Bt+wXqUuE3F/WCA2fNL2SGgJXx
	 0mL7FXGyti4e5ZECmrVju7OQvHpTwX9tTb8/rOI+5U7gA2bFJdeEOycPAwHM72/VsuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=l9ttkoxT+XG1uwFAWT96KE1ncdcbDVA0TxzRkc5XYQc=;
	b=NxuOiIyUe7JABEjW5IUoO+2Yvs2v5NrItoqRYK+v5dyoRW6GMR9LLj4ubbxRZK6uao6t
	 QLkYu2p0ump0xGhseixyjN675vY9NP/IxYqI19s3loW7NgvCaDwRItWvVT9lFWC3qgusB
	 9vxwIpamICKgmcB5Dwwz0H7ioyCbGuhheF2OR9yxDIsbYa6+c4FS8x63D2zVflpf8jXok
	 sga+R4pW7M33VKGzhSzsGTTZvNgfEzvR7D7jb5LMOGNFAdVouCDR4jgIV6SgXpbrVU0PH
	 lk6yhot1fJ0LmOVwTfatuv3yDpgx6Jwe89sAtbUHBwz2WvrT6MyBNozPoYIqvys1d7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=DXxBPktB;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5412606EB48;
	Fri, 27 Nov 2026 14:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5412606EB48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=DXxBPktB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790180;
	bh=l9ttkoxT+XG1uwFAWT96KE1ncdcbDVA0TxzRkc5XYQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXxBPktBTe3QHUz+tGZ1Qrh4rKRJLSSgWXxPHO5iXhOKp+sHEorXAroSxhlFyNEz6
	 SVCgEBR/BiCFOg8ayyBQNl+sxkZZrVF0D2k6i0hVcwlWk6zU44d/mUclTaF5I7xVw3
	 fx1BhSoqRuJwcsDfmE/DKxF93Dyc/gPHC3TnxgTE1muudwOOYVvZHACaoU5OY/A41o
	 0kC2dILDlkCAT/0oOWLpc3sh/xxL6JNsJAPbkkBgwWns0Z/P2Oou9l27OIx8SURT9U
	 eB/O8btHqx/6NeUYNk8h+8D811NlovU4+GXjbRwcYuqPjeWCdLMSgjW30e7HdXdelt
	 IJs/c3xpanC2A==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZX1JhPzXK4;
	Fri, 27 Nov 2026 09:36:20 -0500 (EST)
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
Subject: [PATCH v12 38/43] sched/deadline: Boost an owner that cannot run on its own reservation
Date: Fri, 27 Nov 2026 09:36:05 -0500
Message-ID: <bc3b068a5510b87e32a1c0f89d93884b53295226.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

Fix the test in a new dl_waiter_boosts(). It always boosts an owner
that is throttled or has no runtime left, and an owner in its
constrained gap. In M-BWI [1], an owner runs in the reservation of a
waiter when its own cannot run. Another owner past its deadline is
compared at now + dl_deadline, the deadline its next enqueue gives it.

Such a boost is held from its start, until the owner's own next period.
The new dl_boost_start() saves the owner's period, as a boost held at
its first refill does. The new dl_boost_donor_period() then runs the
owner on a period of the donor's parameters, starting now. A refill
from the owner's own deadline would often end after the waiter's.

Nothing charges the donor for this time. A waiter that times out again
and again would give the owner one donor runtime per boost. So the
deboost keeps the donor period, and the next held boost resumes it,
until a whole donor period has passed. The next boost can have another
donor. It keeps the start of the period and the runtime left, and takes
the deadline from the new donor. The resumed runtime is capped at the
donor's runtime, and at what the donor's density allows until the
deadline, as update_dl_revised_wakeup() does.

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
- An owner with no deadline policy is not boosted by such a waiter at
  all. In the class, it would have no parameters and no donor, and its
  enqueue would leave it off the runqueue. This happens on v7.4-rc2
  too, after a failed ABBA lock attempt and a sched_setscheduler(), or
  with a stale donor that a chain walk left in the waiter.
  __rt_effective_prio() now leaves the owner at its own priority. One
  read of the waiter's donor, in dl_top_donor(), chooses both the class
  and the donor. With two reads, a store in between would bring the bad
  state back. A Spin model finds this state in 8 steps with two reads,
  and none within its bounds with one. dl_top_donor() also takes the
  reference on the donor, so that nothing can fail once the class is
  chosen.

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
 kernel/sched/core.c     |  57 +++++++---
 kernel/sched/deadline.c | 230 +++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h    | 125 +++++++++++++++++-----
 kernel/sched/syscalls.c |  22 ++--
 5 files changed, 373 insertions(+), 79 deletions(-)

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
index f374b8a0a38b..9fda819aa4ef 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7904,17 +7904,23 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 	int prio, oldprio, queue_flag =
 		DEQUEUE_SAVE | DEQUEUE_MOVE | DEQUEUE_NOCLOCK;
 	const struct sched_class *prev_class, *next_class;
+	struct sched_dl_entity *donor;
 	struct rq_flags rf;
 	struct rq *rq;
+	int wprio;
 
+	/* One read decides the class and the donor: see dl_top_donor(). */
+	donor = dl_top_donor(&p->dl, pi_task, &wprio);
 	/* XXX used to be waiter->prio, not waiter->task->prio */
-	prio = __rt_effective_prio(pi_task, p->normal_prio);
+	prio = __rt_effective_prio(p, donor, wprio, p->normal_prio);
 
 	/*
 	 * If nothing changed; bail early.
 	 */
-	if (p->pi_top_task == pi_task && prio == p->prio && !dl_prio(prio))
+	if (p->pi_top_task == pi_task && prio == p->prio && !dl_prio(prio)) {
+		dl_put_donor(&p->dl, donor);
 		return;
+	}
 
 	rq = __task_rq_lock(p, &rf);
 	update_rq_clock(rq);
@@ -7972,9 +7978,9 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
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
@@ -7984,15 +7990,36 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			 * with that deadline.
 			 */
 			if (!dl_prio(p->normal_prio) ||
-			    (pi_task && dl_prio(pi_task->prio) &&
+			    (donor &&
 			     !(p->dl.dl_new_params && p->dl.pi_se != &p->dl) &&
-			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
+			     dl_waiter_boosts(p, pi_task))) {
 				struct sched_dl_entity *old_donor = p->dl.pi_se;
 
-				dl_set_donor(&p->dl, pi_task);
-				scope->flags |= ENQUEUE_REPLENISH;
-				if (!scope->queued && p->dl.pi_se != old_donor)
-					dl_boost_blocked(p);
+				/*
+				 * donor is not NULL here. A task with no
+				 * deadline policy has a deadline prio only from
+				 * a deadline waiter, whose donor is not @p: see
+				 * __rt_effective_prio().
+				 */
+				if (!dl_set_donor(&p->dl, &donor)) {
+					/*
+					 * The donor of the top waiter is @p: @p waits
+					 * on a lock that it owns, or the waiter has a
+					 * stale donor. End the boost of a deadline
+					 * task, as a deboost does. A task with no
+					 * deadline policy does not get here:
+					 * __rt_effective_prio() did not boost it.
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
@@ -8000,9 +8027,10 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				 * can be after the top waiter's. Boost the
 				 * task again then.
 				 */
-				if (pi_task && dl_prio(pi_task->prio) &&
-				    dl_entity_preempt(&pi_task->dl, &p->dl)) {
-					dl_set_donor(&p->dl, pi_task);
+				if (donor && dl_waiter_boosts(p, pi_task) &&
+				    dl_set_donor(&p->dl, &donor)) {
+					if (p->dl.pi_se != &p->dl)
+						dl_boost_start(&p->dl);
 					scope->flags |= ENQUEUE_REPLENISH;
 				}
 			}
@@ -8022,6 +8050,7 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		p->prio = prio;
 	}
 out_unlock:
+	dl_put_donor(&p->dl, donor);
 	/* Caller holds task_struct::pi_lock, IRQs are still disabled */
 
 	__balance_callbacks(rq, &rf);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ae0940838ca5..7f839185eb38 100644
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
  *
  * A task @asleep on anything but an rt_mutex gets that period at its
  * wakeup instead: a period started now would run while it sleeps.
@@ -111,30 +111,61 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se,
 
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
 		dl_se->period_start = dl_se->own_period_start;
 		/*
 		 * Past its own deadline, the task is in its constrained gap:
-		 * it waits for its own next period. Give back no runtime, so
-		 * that dl_deboost() throttles it. Before its deadline,
+		 * it waits for its own next period. Give back no runtime left,
+		 * so that dl_deboost() throttles it. An overrun of its own
+		 * runtime stays, as a refill pays it back. Before its deadline,
 		 * dl_hold_refilled_boost() can keep runtime left, from a
 		 * wakeup refill. Cap it at what the task's own density allows
 		 * until its deadline, as update_dl_revised_wakeup() does.
 		 */
 		if (!dl_time_before(now, dl_se->deadline))
-			dl_se->runtime = 0;
+			dl_se->runtime = min_t(s64, dl_se->runtime, 0);
 		else if (dl_se->runtime > 0)
 			dl_se->runtime = min_t(s64, dl_se->runtime,
 					       (dl_se->dl_density *
 						(dl_se->deadline - now)) >> BW_SHIFT);
-	} else if (asleep) {
-		dl_se->deadline = dl_se->own_deadline;
-		dl_se->period_start = dl_se->own_period_start;
-		dl_se->runtime = 0;
+		/*
+		 * sched_setattr() during the boost can have started a new
+		 * period of the task's own, with runtime. A throttle from
+		 * before the boost does not apply to it: lift it.
+		 */
+		if (dl_se->runtime > 0 && dl_se->dl_throttled) {
+			dl_se->dl_throttled = 0;
+			if (hrtimer_try_to_cancel(&dl_se->dl_timer) == 1)
+				put_task_struct(dl_task_of(dl_se));
+		}
 	} else {
-		dl_start_own_period(dl_se);
+		/*
+		 * The own next period has started, which lifts the throttle.
+		 * A task asleep since before the boost still has its
+		 * replenishment timer armed for its old next period: cancel
+		 * it. A task asleep keeps the end of its own period: its
+		 * wakeup starts the next one.
+		 */
+		if (asleep) {
+			dl_se->deadline = dl_se->own_deadline;
+			dl_se->period_start = dl_se->own_period_start;
+			dl_se->runtime = 0;
+		} else {
+			dl_start_own_period(dl_se);
+		}
+		dl_se->dl_throttled = 0;
+		if (hrtimer_try_to_cancel(&dl_se->dl_timer) == 1)
+			put_task_struct(dl_task_of(dl_se));
 	}
 	dl_se->dl_donor_refill = 0;
 	return true;
@@ -190,9 +221,12 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
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
@@ -207,10 +241,10 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
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
  *    refill, start a new period now, or at the wakeup of a task asleep.
  *    dl_hold_refilled_boost() holds the boost of a task that had them.
@@ -285,6 +319,13 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	if (held && dl_se->runtime <= 0 && (!asleep || dl_se->dl_throttled)) {
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
@@ -379,6 +420,130 @@ void dl_check_blocked_params(struct task_struct *p)
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
+		/*
+		 * A boost held at a wakeup refill can keep runtime of the
+		 * task's own, before its own deadline. The task can run on
+		 * it: compare with that deadline.
+		 */
+		if (dl_se->own_runtime > 0 &&
+		    dl_time_before(now, dl_se->own_deadline))
+			return dl_time_before(pi_task->dl.deadline,
+					      dl_se->own_deadline);
+		if (dl_time_before(now, dl_se->own_period_start + dl_se->dl_period))
+			return true;
+		return dl_time_before(pi_task->dl.deadline, now + dl_se->dl_deadline);
+	}
+	if (!is_dl_boosted(dl_se)) {
+		if (dl_se->dl_throttled || dl_in_constrained_gap(dl_se) ||
+		    (dl_se->dl_runtime && dl_se->runtime <= 0))
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
+	/*
+	 * The donor can differ from the one of the last held boost. Keep the
+	 * start of the donor period and the runtime left, but take the
+	 * deadline and the cap of the runtime from this donor.
+	 */
+	if (dl_se->dl_boost_granted && runtime && period &&
+	    dl_time_before(now, dl_se->boost_period_start + period)) {
+		dl_se->period_start = dl_se->boost_period_start;
+		dl_se->deadline = dl_se->period_start +
+				  READ_ONCE(pi_se->dl_deadline);
+		dl_se->runtime = min_t(s64, dl_se->boost_runtime, runtime);
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
@@ -1692,7 +1857,13 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
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
 
@@ -5614,10 +5785,10 @@ static u64 dl_mul_div_cap(u64 a, u64 b, u64 c, u64 cap)
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
@@ -5758,12 +5929,14 @@ static bool dl_setattr_place(struct sched_dl_entity *dl_se, u64 now,
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
@@ -6053,6 +6226,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
 	dl_se->dl_new_params		= 0;
+	dl_se->dl_boost_granted		= 0;
 	dl_se->dl_setattr_saved		= 0;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 43aef9b61b67..efc16cc6fa95 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -373,37 +373,88 @@ static inline void dl_replace_donor(struct sched_dl_entity *dl_se,
 }
 
 /*
- * Make the deadline donor of the waiter @pi_task the donor of @dl_se. A
- * boosted entity holds a reference on the task of its donor. The donor
- * is the deadline task at the head of the chain. It can stop waiting
- * and exit before the chain walk reaches @dl_se: that walk can be
- * preempted.
+ * Return the deadline donor of the waiter @pi_task, for the boost of
+ * @dl_se, and set *@prio to the priority of @pi_task. Return NULL if
+ * @pi_task is NULL or has no deadline priority, and @dl_se itself if
+ * the donor of @pi_task is @dl_se: the task of @dl_se then waits on a
+ * lock that it owns, or a chain walk left a stale donor in @pi_task.
+ * Otherwise, the donor comes with a reference on its task. Pass it to
+ * dl_set_donor(), or drop it with dl_put_donor().
+ *
+ * Read the priority and the donor once per decision. The class of the
+ * boosted task and its donor must come from the same values. Take the
+ * reference here too: nothing may fail once the class is chosen.
+ *
+ * The two are separate loads. A change of @pi_task between them can give
+ * a deadline priority with the own entity of @pi_task as donor, while
+ * @pi_task has no deadline policy. The boosted task then runs on a donor
+ * with no parameters, as when a donor leaves the class:
+ * replenish_dl_entity() covers it. The chain walk of that change then
+ * corrects the boost.
  *
  * The donor of @pi_task is read without the locks of @pi_task. Another
  * CPU can change it meanwhile, and put the last reference on the old
  * donor. That CPU stores the new donor first: read it again then. The
- * old task_struct stays readable while the rq lock is held:
- * put_task_struct() frees it through call_rcu(), and the rq lock holds
- * off the grace period.
- *
- * The caller holds the rq lock and the pi_lock of the task of @dl_se.
+ * old task_struct stays readable: put_task_struct() frees it through
+ * call_rcu(). The caller holds the pi_lock of the task of @dl_se with
+ * interrupts off, on a CPU that RCU watches: a chain walk, the irq_work
+ * of rt_mutex_adjust_owner(), or a system call. That holds off the grace
+ * period.
  */
-static inline void dl_set_donor(struct sched_dl_entity *dl_se,
-				struct task_struct *pi_task)
+static inline struct sched_dl_entity *dl_top_donor(struct sched_dl_entity *dl_se,
+						   struct task_struct *pi_task,
+						   int *prio)
 {
 	struct sched_dl_entity *pi_se;
 
+	*prio = pi_task ? READ_ONCE(pi_task->prio) : MAX_PRIO;
+	if (!dl_prio(*prio))
+		return NULL;
 	for (;;) {
 		pi_se = READ_ONCE(pi_task->dl.pi_se);
-		if (pi_se == dl_se->pi_se)
-			return;
 		if (pi_se == dl_se ||
 		    tryget_task_struct(container_of(pi_se, struct task_struct, dl)))
-			break;
+			return pi_se;
 		/* Pairs with the ordering of refcount_dec_and_test(). */
 		smp_rmb();
 	}
-	dl_replace_donor(dl_se, pi_se);
+}
+
+/* Drop a donor that dl_top_donor() returned for @dl_se and that is unused. */
+static inline void dl_put_donor(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
+{
+	if (pi_se && pi_se != dl_se)
+		put_task_struct(container_of(pi_se, struct task_struct, dl));
+}
+
+/*
+ * Make *@pi_se, a donor that dl_top_donor() returned, the donor of
+ * @dl_se. A boosted entity holds a reference on the task of its donor.
+ * The donor is the deadline task at the head of the chain. It can stop
+ * waiting and exit before the chain walk reaches @dl_se: that walk can be
+ * preempted.
+ *
+ * Return false if *@pi_se is @dl_se itself, and leave the donor as it
+ * is. Otherwise use the reference of *@pi_se, set *@pi_se to NULL, and
+ * return true. *@pi_se must not be NULL: the caller tests it, or knows
+ * it from a deadline priority that the donor gave.
+ *
+ * The caller holds the rq lock and the pi_lock of the task of @dl_se.
+ */
+static inline bool dl_set_donor(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity **pi_se)
+{
+	struct sched_dl_entity *donor = *pi_se;
+
+	if (donor == dl_se)
+		return false;
+	*pi_se = NULL;
+	if (donor == dl_se->pi_se)
+		dl_put_donor(dl_se, donor);
+	else
+		dl_replace_donor(dl_se, donor);
+	return true;
 }
 
 /* Make @dl_se its own donor. The caller holds the rq lock of its task. */
@@ -416,6 +467,8 @@ extern void dl_deboost(struct sched_dl_entity *dl_se);
 extern void dl_drop_boost_out(struct sched_dl_entity *dl_se);
 extern void dl_boost_blocked(struct task_struct *p);
 extern void dl_check_blocked_params(struct task_struct *p);
+extern bool dl_waiter_boosts(struct task_struct *p, struct task_struct *pi_task);
+extern void dl_boost_start(struct sched_dl_entity *dl_se);
 
 /*
  * End the boost of @dl_se, and forget the deadline and runtime saved for
@@ -429,6 +482,11 @@ static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
 	dl_se->dl_boost_held = 0;
 	dl_se->dl_setattr_saved = 0;
 }
+#else /* !CONFIG_RT_MUTEXES: */
+static inline void dl_put_donor(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
+{
+}
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
@@ -4349,25 +4407,44 @@ bool task_is_pushable(struct rq *rq, struct task_struct *p, int cpu)
 
 #ifdef CONFIG_RT_MUTEXES
 
-static inline int __rt_effective_prio(struct task_struct *pi_task, int prio)
+/*
+ * Return the priority of @p, of normal priority @prio, boosted by its top
+ * waiter of priority @wprio and deadline donor @donor, both read by
+ * dl_top_donor(). @donor can be @p itself: @p waits on a lock it owns,
+ * or a chain walk left a stale donor in the waiter. A boost would then
+ * leave a task with no deadline policy in the class, with no parameters
+ * and no donor: its enqueue would not put it on the runqueue. Do not
+ * boost it with that waiter.
+ */
+static inline int __rt_effective_prio(struct task_struct *p,
+				      struct sched_dl_entity *donor,
+				      int wprio, int prio)
 {
-	if (pi_task)
-		prio = min(prio, pi_task->prio);
-
-	return prio;
+	if (donor == &p->dl && !dl_prio(prio))
+		return prio;
+	return min(prio, wprio);
 }
 
-static inline int rt_effective_prio(struct task_struct *p, int prio)
+/*
+ * As __rt_effective_prio(), for the top waiter of @p. Also return in
+ * *@donor the donor it used, as dl_top_donor() returns it.
+ */
+static inline int rt_effective_prio(struct task_struct *p, int prio,
+				    struct sched_dl_entity **donor)
 {
 	struct task_struct *pi_task = rt_mutex_get_top_task(p);
+	int wprio;
 
-	return __rt_effective_prio(pi_task, prio);
+	*donor = dl_top_donor(&p->dl, pi_task, &wprio);
+	return __rt_effective_prio(p, *donor, wprio, prio);
 }
 
 #else /* !CONFIG_RT_MUTEXES: */
 
-static inline int rt_effective_prio(struct task_struct *p, int prio)
+static inline int rt_effective_prio(struct task_struct *p, int prio,
+				    struct sched_dl_entity **donor)
 {
+	*donor = NULL;
 	return prio;
 }
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 4f26601f0530..b71df4c2c13a 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -303,6 +303,7 @@ static bool check_same_owner(struct task_struct *p)
 #ifdef CONFIG_RT_MUTEXES
 static inline void __setscheduler_dl_pi(int newprio, int policy,
 			      struct task_struct *p,
+			      struct sched_dl_entity **donor,
 			      struct sched_change_ctx *scope)
 {
 	/*
@@ -312,14 +313,10 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * sure replenishment happens with the next enqueue.
 	 */
 
-	if (dl_prio(newprio) && !dl_policy(policy)) {
-		struct task_struct *pi_task = rt_mutex_get_top_task(p);
-
-		if (pi_task) {
-			dl_set_donor(&p->dl, pi_task);
-			scope->flags |= ENQUEUE_REPLENISH;
-		}
-	}
+	/* *@donor chose newprio: see rt_effective_prio(). */
+	if (dl_prio(newprio) && !dl_policy(policy) && *donor &&
+	    dl_set_donor(&p->dl, donor))
+		scope->flags |= ENQUEUE_REPLENISH;
 
 	/*
 	 * Without pi, as from normalize_rt_tasks(), a boosted task can leave
@@ -334,6 +331,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
 			      struct task_struct *p,
+			      struct sched_dl_entity **donor,
 			      struct sched_change_ctx *scope)
 {
 }
@@ -523,6 +521,7 @@ int __sched_setscheduler(struct task_struct *p,
 	int oldpolicy = -1, policy = attr->sched_policy;
 	int retval, oldprio, newprio;
 	const struct sched_class *prev_class, *next_class;
+	struct sched_dl_entity *donor = NULL;
 	struct balance_callback *head;
 	struct rq_flags rf;
 	int reset_on_fork;
@@ -729,7 +728,7 @@ int __sched_setscheduler(struct task_struct *p,
 		 * the runqueue. This will be done when the task deboost
 		 * itself.
 		 */
-		newprio = rt_effective_prio(p, newprio);
+		newprio = rt_effective_prio(p, newprio, &donor);
 		if (newprio == oldprio && !dl_prio(newprio))
 			queue_flags &= ~DEQUEUE_MOVE;
 	}
@@ -790,7 +789,7 @@ int __sched_setscheduler(struct task_struct *p,
 			__setscheduler_params(p, attr);
 			p->sched_class = next_class;
 			p->prio = newprio;
-			__setscheduler_dl_pi(newprio, policy, p, scope);
+			__setscheduler_dl_pi(newprio, policy, p, &donor, scope);
 		}
 		__setscheduler_uclamp(p, attr);
 
@@ -807,6 +806,8 @@ int __sched_setscheduler(struct task_struct *p,
 	/* Avoid rq from going away on us: */
 	preempt_disable();
 	head = splice_balance_callbacks(rq);
+	/* A donor read for newprio and not used. */
+	dl_put_donor(&p->dl, donor);
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
@@ -824,6 +825,7 @@ int __sched_setscheduler(struct task_struct *p,
 	return 0;
 
 unlock:
+	dl_put_donor(&p->dl, donor);
 	task_rq_unlock(rq, p, &rf);
 	if (cpuset_locked) {
 		dl_accounting_unlock();
-- 
2.47.3

