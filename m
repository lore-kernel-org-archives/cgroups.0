Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790182;
	b=oBsQ80wdW+09Lux8M5YUpIvTyMQpFMkPrwMU1oK9ChMYapP5tsppOeEub14qFdfIWzWP
	 QmhwyIoM+kl7p78mZYyiDYQHQxzLPlj74BlHduBaLoDzRUZ2BA8/BwYmF7EIHsYhqce13
	 OcFxH/gCkYwd8E6TZchCvHKANEaYoiRn3Vkh64yv6kFlAR5JeY2ucNfoBlt46MRtdzkh4
	 jPT5FQL1gzyKxJQJJCYpgLBftnUyThE13jl9uqVPEx8NhRA3oZa99EPAjemUgJSGp8xk/
	 qX6Q7RSKaej+a2fNay4NEVGCGosp5GnhKPACSf39w9rhqbrGtA/bN+ytceEJIRwPMsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790182;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K/iHttSG4bsBRQBZmpMKn256TW3eAMQJyiA0LIWkfBg=;
	b=qqNSbTLiJ4Oypq8pCmOCzkahz4gmesY2DUqgqmfDqWm16fy39Qaq1uJL9sJpUPbhCsSf
	 fUZcBemfLRrg4pP+13C8u3YC1PcsiD0AUYTXLz/DY69REF4X7ekUtXPK+HsN3C0FvFyIq
	 sV23RMGOplBwGFJGqLP6cthTBJ3353DyZND93o4JATtcEG6v1n1dzYVwVbbbyt2T2usM4
	 geq190fNSR2JIG9Ufg4YDXhcmHmG7GqeCqFfHkyqeZsac1jsTcmVvblxfe7XEcMWOR2G4
	 q9Ir6uEgkbRO/M8OH2mlZyZEhlAo+z5NHyKSut6dQifU5NP39YVDsYg5JQEou4YSk9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QWS3mMks;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69BB60746F8;
	Fri, 27 Nov 2026 14:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E69BB60746F8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QWS3mMks
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790178;
	bh=K/iHttSG4bsBRQBZmpMKn256TW3eAMQJyiA0LIWkfBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWS3mMksL417LejdCwGAeLJgmpBsd8aOkX7u2abekaZaCf/C5DU/kSdoYmRnMShFs
	 /KoDKs26eTBmIj31BjhKb19FMjAuuMyU6uvhYb8nr2fdpXvHxaGi5WVw0OUo0SykoT
	 GI4ghuhJtB+yQhO8tYk0pGtZ/nxDjEQXz1/e6OgJrAeRUF4tDPHwiRX4bZk3HvSUv6
	 FzKfq6TCJd+asFhU74xTthZk8UYrfb/IwnIooV7cOSJ/9H6oGaJ8reAbQnzR/j/52t
	 Su75mNhk8qrFVAFGM6E7lDGIC1WeEkYiq+oi7FBr4w6ex2xFj/O2OnwaxiUF53s5lw
	 DyWgG85WuEhaQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZV2xFTzXZT;
	Fri, 27 Nov 2026 09:36:18 -0500 (EST)
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
Subject: [PATCH v12 28/43] sched/deadline: Restore the owner's period at a deboost in the class
Date: Fri, 27 Nov 2026 09:35:55 -0500
Message-ID: <6e2be1b0455b47b25eb2ca53dd51e69e38f8ae6e.1795771148.git.mathieu.desnoyers@efficios.com>
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

A task that holds an rt_mutex wanted by a deadline task is boosted. That
deadline task is its donor. Commit 2d3d891d3344 ("sched/deadline: Add
SCHED_DEADLINE inheritance logic") gives the boosted task the donor's
parameters "during the whole period it holds the pi-lock". When its
runtime runs out, replenish_dl_entity() refills it from the donor: it
adds the donor's runtime, and moves the deadline by the donor's period.

A task that stays in the class at its deboost keeps these values.
rt_mutex_setprio() only resets dl.pi_se. So after the unlock, the task
can run the rest of the donor's refill on top of its own runtime, in
one of its own periods. Other deadline tasks would then miss their
deadlines.

In M-BWI [1], the owner goes back to its own server at the unlock. Do
the same here:
- At the first refill from the donor, the new dl_hold_refilled_boost()
  saves the task's own deadline and runtime, and sets dl_boost_held.
  A negative runtime is saved as 0: that overrun comes from the boost.
- At the deboost, the new dl_deboost() puts them back. A task whose own
  runtime is used up, or whose own deadline has passed, is throttled
  until its own next period. If that period has started, the task
  starts it. The runtime put back is capped at what the task's own
  density allows, as update_dl_revised_wakeup() does.
- A task asleep on anything but an rt_mutex, and not throttled before
  the boost, is not throttled and starts no period. A period started
  while it sleeps could end before it wakes. Its wakeup throttles it,
  or starts its next period.
- A task with no parameters of its own at the first refill has nothing
  saved. If sched_setattr() gives it parameters during the boost, its
  deboost starts a new period from them. A new flag, dl_donor_refill,
  records the refill.

dl_deboost() runs at the deboost, not at the next enqueue. A task
blocked on another rt_mutex is not enqueued, and the chain walk copies
its deadline into its waiter node first. dl_deboost() also cancels an
inactive timer armed from the donor's values, and computes the 0-lag
time again. Right after a deboost starts a period, that time is exactly
now. task_non_contending() now takes it as passed. The deadline put
back can be later than the top waiter's: rt_mutex_setprio() then boosts
the task again.

"sched/deadline: Restore the owner's period at a deboost out of the
class", later in this series, does the same for a task that leaves the
class at its deboost.

The Sashiko AI review of this series found the sched_setattr() case and
the inactive timer. deboost_in_class_resets_period and
deboost_after_donor_refill, added to deadline_bw_test later in this
series, fail without this patch, in every run.

[1] D. Faggioli, G. Lipari, T. Cucinotta, "Analysis and Implementation
    of the Multiprocessor BandWidth Inheritance Protocol", Real-Time
    Systems, 2012, section 5.1

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  16 ++++
 kernel/sched/core.c     |  16 +++-
 kernel/sched/deadline.c | 205 +++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h    |  14 +++
 kernel/sched/syscalls.c |   2 +-
 5 files changed, 245 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0c89263b1db9..5a056a2914d0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -661,6 +661,9 @@ struct sched_dl_entity {
 	 */
 	s64				runtime;	/* Remaining runtime for this instance	*/
 	u64				deadline;	/* Absolute deadline for this instance	*/
+	/* Saved when a boost is held: see dl_boost_held */
+	u64				own_deadline;
+	s64				own_runtime;
 	unsigned int			flags;		/* Specifying the scheduler behaviour	*/
 
 	/*
@@ -683,6 +686,17 @@ struct sched_dl_entity {
 	 * @dl_overrun tells if the task asked to be informed about runtime
 	 * overruns.
 	 *
+	 * @dl_donor_refill tells if a replenishment changed the runtime of
+	 * a boosted task. The replenishment used the parameters of its
+	 * donor, or set the runtime to 0 when those were cleared. The
+	 * runtime and deadline are then not those of the task's own
+	 * reservation. The end of the boost clears the flag.
+	 *
+	 * @dl_boost_held tells that own_deadline and own_runtime hold the
+	 * task's own deadline and runtime. The first refill of a boost saves
+	 * them, for a task with parameters of its own. The deboost puts them
+	 * back.
+	 *
 	 * @dl_server tells if this is a server entity.
 	 *
 	 * @dl_server_active tells if the dlserver is active(started).
@@ -715,6 +729,8 @@ struct sched_dl_entity {
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
+	unsigned int			dl_donor_refill   : 1;
+	unsigned int			dl_boost_held     : 1;
 	unsigned int			dl_server         : 1;
 	unsigned int			dl_server_active  : 1;
 	unsigned int			dl_defer	  : 1;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2700c8e98b0e..7a3a7e755d20 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7983,16 +7983,26 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				dl_set_donor(&p->dl, pi_task);
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				dl_clear_donor(&p->dl);
+				dl_deboost(&p->dl);
+				/*
+				 * The deadline that dl_deboost() gives back
+				 * can be after the top waiter's. Boost the
+				 * task again then.
+				 */
+				if (pi_task && dl_prio(pi_task->prio) &&
+				    dl_entity_preempt(&pi_task->dl, &p->dl)) {
+					dl_set_donor(&p->dl, pi_task);
+					scope->flags |= ENQUEUE_REPLENISH;
+				}
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
-				dl_clear_donor(&p->dl);
+				dl_drop_boost(&p->dl);
 			if (oldprio < prio)
 				scope->flags |= ENQUEUE_HEAD;
 		} else {
 			if (dl_prio(oldprio))
-				dl_clear_donor(&p->dl);
+				dl_drop_boost(&p->dl);
 			if (rt_prio(oldprio))
 				p->rt.timeout = 0;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a6ca7870416e..c7f6b45d2a3a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -83,6 +83,60 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
 
+/*
+ * Start a period of the reservation of @dl_se now. The caller holds the rq
+ * lock and has updated the rq clock.
+ */
+static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
+{
+	dl_se->deadline = rq_clock(rq_of_dl_se(dl_se)) + dl_se->dl_deadline;
+	dl_se->runtime = dl_se->dl_runtime;
+}
+
+/*
+ * Put back the deadline and runtime saved when the boost was held, by
+ * dl_hold_refilled_boost(). If the task's own next period has started
+ * since, start a period of its own instead. Return true if the boost was
+ * held. The caller holds the rq lock and has updated the rq clock.
+ *
+ * A task @asleep on anything but an rt_mutex gets that period at its
+ * wakeup instead: a period started now would run while it sleeps.
+ */
+static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se,
+				     bool asleep)
+{
+	u64 now = rq_clock(rq_of_dl_se(dl_se));
+	u64 next = dl_se->own_deadline - dl_se->dl_deadline + dl_se->dl_period;
+
+	if (!dl_se->dl_boost_held)
+		return false;
+	if (dl_time_before(now, next)) {
+		dl_se->deadline = dl_se->own_deadline;
+		dl_se->runtime = dl_se->own_runtime;
+		/*
+		 * Past its own deadline, the task is in its constrained gap:
+		 * it waits for its own next period. Give back no runtime, so
+		 * that dl_deboost() throttles it. Before its deadline,
+		 * dl_hold_refilled_boost() can keep runtime left, from a
+		 * wakeup refill. Cap it at what the task's own density allows
+		 * until its deadline, as update_dl_revised_wakeup() does.
+		 */
+		if (!dl_time_before(now, dl_se->deadline))
+			dl_se->runtime = 0;
+		else if (dl_se->runtime > 0)
+			dl_se->runtime = min_t(s64, dl_se->runtime,
+					       (dl_se->dl_density *
+						(dl_se->deadline - now)) >> BW_SHIFT);
+	} else if (asleep) {
+		dl_se->deadline = dl_se->own_deadline;
+		dl_se->runtime = 0;
+	} else {
+		dl_start_own_period(dl_se);
+	}
+	dl_se->dl_donor_refill = 0;
+	return true;
+}
+
 #ifdef CONFIG_RT_MUTEXES
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -93,12 +147,116 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return pi_of(dl_se) != dl_se;
 }
+
+static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
+
+/*
+ * Record that a replenishment changes the runtime of @dl_se while it is
+ * boosted. At the first refill, dl_hold_refilled_boost() saves the
+ * task's own deadline and runtime. Call this before the replenishment
+ * adds runtime or moves the deadline. A task with no parameters of its
+ * own at the first refill, or no period yet, has no period to save. The
+ * deboost then starts a period of its own. Later refills of the
+ * same boost save nothing, even if the task gets parameters meanwhile.
+ */
+static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+{
+	bool first;
+
+	if (!is_dl_boosted(dl_se))
+		return;
+	first = !dl_se->dl_donor_refill;
+	dl_se->dl_donor_refill = 1;
+	if (first && dl_se->dl_runtime && dl_se->deadline &&
+	    !dl_se->dl_boost_held)
+		dl_hold_refilled_boost(dl_se);
+}
+
+static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
+static int start_dl_timer(struct sched_dl_entity *dl_se);
+
+/*
+ * End the boost of @dl_se, whose task stays in the class. Then bring the
+ * runtime and the deadline of the task back to its own parameters:
+ *  - After a held boost, dl_end_held_boost() puts back the values that
+ *    dl_hold_refilled_boost() saved. The time the task ran on the
+ *    donor's refills is not charged to its own runtime. If that runtime
+ *    is used up, throttle the task again until its own next period, or
+ *    start that period if it has started.
+ *  - After a refill of a task that had no parameters of its own at the
+ *    refill, start a new period now, or at the wakeup of a task asleep.
+ *  - Without a refill, the task keeps the runtime and the deadline of its
+ *    own reservation.
+ * Do it now: the next enqueue is too late for a task blocked on another
+ * rt_mutex. The chain walk copies its deadline into its waiter node first.
+ *
+ * The caller holds the rq lock and the pi_lock of the task, and has
+ * updated the rq clock.
+ */
+void dl_deboost(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	bool asleep = !task_on_rq_queued(p) && !p->pi_blocked_on;
+	bool held = dl_end_held_boost(dl_se, asleep);
+	bool own = held;
+
+	if (dl_se->dl_donor_refill) {
+		/* A task asleep gets its first own period at its wakeup. */
+		if (asleep) {
+			dl_se->deadline = 0;
+			dl_se->runtime = 0;
+		} else {
+			dl_start_own_period(dl_se);
+		}
+		own = true;
+	}
+	/*
+	 * If the task blocked while boosted, its inactive timer can be armed
+	 * from the runtime and deadline of the donor's refills. Cancel it, and
+	 * work out the 0-lag time again from the runtime and deadline the task
+	 * gets back.
+	 * If the timer handler is already running, it releases the
+	 * bandwidth.
+	 */
+	if (own && dl_se->dl_non_contending &&
+	    hrtimer_try_to_cancel(&dl_se->inactive_timer) == 1) {
+		dl_se->dl_non_contending = 0;
+		put_task_struct(p);
+		task_non_contending(dl_se, true);
+	}
+	dl_drop_boost(dl_se);
+
+	/*
+	 * A held boost can end before the task's own next period, with its
+	 * own runtime used up. Throttle the task until that period. If
+	 * start_dl_timer() finds that the period has already started, start
+	 * it now. Leave a task asleep to its wakeup, unless it was throttled
+	 * before the boost: its wakeup throttles it, or starts its next
+	 * period.
+	 */
+	if (held && dl_se->runtime <= 0 && (!asleep || dl_se->dl_throttled)) {
+		struct rq *rq = task_rq(p);
+
+		dl_se->dl_throttled = 1;
+		if (!start_dl_timer(dl_se)) {
+			dl_se->dl_throttled = 0;
+			if (!asleep)
+				dl_start_own_period(dl_se);
+		} else if (task_current_donor(rq, p)) {
+			resched_curr(rq);
+		}
+	}
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
 	return dl_se;
 }
 
+static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+{
+}
+
 static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
@@ -791,10 +949,12 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	}
 
 	/*
-	 * If the "0-lag time" already passed, decrease the active
-	 * utilization now, instead of starting a timer
+	 * If the "0-lag time" is now or already passed, decrease the active
+	 * utilization now, instead of starting a timer. A deboost can call
+	 * this right after it starts a period. The 0-lag time is then
+	 * exactly now.
 	 */
-	if ((zerolag_time < 0) || hrtimer_active(&dl_se->inactive_timer)) {
+	if ((zerolag_time <= 0) || hrtimer_active(&dl_se->inactive_timer)) {
 		if (dl_server(dl_se)) {
 			sub_running_bw(dl_se, dl_rq);
 		} else {
@@ -1144,6 +1304,7 @@ static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
 static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 					    struct rq *rq)
 {
+	dl_note_donor_refill(dl_se);
 	/* for non-boosted task, pi_of(dl_se) == dl_se */
 	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
 	dl_se->runtime = pi_of(dl_se)->dl_runtime;
@@ -1243,11 +1404,14 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	if (unlikely(!runtime || !deadline || !period)) {
 		WARN_ON_ONCE(!is_dl_boosted(dl_se));
 		if (!dl_se->dl_deadline) {
+			dl_note_donor_refill(dl_se);
 			dl_se->deadline = rq_clock(rq);
 			dl_se->runtime = 0;
 		}
-		if (dl_se->runtime < 0 || dl_se->dl_yielded)
+		if (dl_se->runtime < 0 || dl_se->dl_yielded) {
 			dl_se->runtime = 0;
+			dl_note_donor_refill(dl_se);
+		}
 		dl_se->dl_yielded = 0;
 		dl_se->dl_throttled = 0;
 		return;
@@ -1265,6 +1429,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
+		dl_note_donor_refill(dl_se);
 		dl_se->deadline = rq_clock(rq) + deadline;
 		dl_se->runtime = runtime;
 	}
@@ -1272,6 +1437,9 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
 		dl_se->runtime = 0;
 
+	if (dl_se->runtime <= 0)
+		dl_note_donor_refill(dl_se);
+
 	/*
 	 * We keep moving the deadline away until we get some
 	 * available runtime for the entity. This ensures correct
@@ -5013,6 +5181,33 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	return err;
 }
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * A boosted task is refilled from its donor when its runtime is used up,
+ * or when its deadline has passed. A wakeup also refills it when the
+ * donor's density does not allow the runtime left. After the first
+ * refill, the runtime and the deadline of the task are no longer those
+ * of its own reservation. So save them in own_* at that refill: this
+ * holds the boost. dl_deboost() puts them back.
+ *
+ * Keep the runtime left if the task's own deadline is still ahead.
+ * Otherwise save no runtime. A negative runtime is an overrun that comes
+ * from the boost, so the task's own reservation does not pay for it (see
+ * replenish_dl_entity()).
+ *
+ * The caller holds the rq lock of the task, and has updated the rq clock.
+ */
+static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
+{
+	u64 now = rq_clock(rq_of_dl_se(dl_se));
+
+	dl_se->own_deadline = dl_se->deadline;
+	dl_se->own_runtime = dl_time_before(now, dl_se->deadline) ?
+			     max_t(s64, dl_se->runtime, 0) : 0;
+	dl_se->dl_boost_held = 1;
+}
+#endif /* CONFIG_RT_MUTEXES */
+
 /*
  * This function initializes the sched_dl_entity of a newly becoming
  * SCHED_DEADLINE task.
@@ -5142,6 +5337,8 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+	dl_se->dl_donor_refill		= 0;
+	dl_se->dl_boost_held		= 0;
 	dl_se->dl_server		= 0;
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 859d782cc899..b53885c624fd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -411,6 +411,20 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 {
 	dl_replace_donor(dl_se, dl_se);
 }
+
+extern void dl_deboost(struct sched_dl_entity *dl_se);
+
+/*
+ * End the boost of @dl_se, and forget the deadline and runtime saved for
+ * it. dl_deboost() puts them back first, for a task that stays in the
+ * class. The caller holds the rq lock of its task.
+ */
+static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
+{
+	dl_clear_donor(dl_se);
+	dl_se->dl_donor_refill = 0;
+	dl_se->dl_boost_held = 0;
+}
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 79285e66e051..9778663fe370 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -310,7 +310,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * the class. Drop its boost then, as rt_mutex_setprio() does.
 	 */
 	if (!dl_prio(newprio))
-		dl_clear_donor(&p->dl);
+		dl_drop_boost(&p->dl);
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
-- 
2.47.3

