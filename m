Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790186;
	b=AI7gKCbJY8Int4geeuceoE1TAVXAtOt49rqtkY4hAvXfbRxppZh8fHv6UHV5ZppQI3bs
	 ivepWM9JDIGSGsLPlAsKbXul7sZO/QZUggQI6/iSr0bdsvY2bX0qGoentvn1W1SewVajC
	 gbnlykSJYaFJhfT54+j7tGg5tBl6flOqeHzapy/sE1A5/GLkgPMIQpWFExEaR5nyrJtGM
	 onoyEBIvU5AMgCgkTaYcCNCaEM9Yjg9sGgiLG4v+c23NcOqG5gRIjA4COjl9fZVbzflp5
	 QVK2p6G4XYsK4VIRs6OuanGlKpFkHuPURS6IzrtzJTdpV6BX3ZKwdys8HbeE+gcp9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790186;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nKeWVl2IAK6Uj50M31GS67F4DyW8xp/yvl9wHBeyLSs=;
	b=4s8/yQ/SEjGTF3lZj8bomQUwSPXJhqVq5E3mQtT1/mTlAr0SM4rs2nSOteMCTkzlwMi6
	 9SrDO0cKv5NHL0K3KkVje4S8DS+HfDdXNghgdlIfhYDWLdCm3y6gpLeSja+Njt8bKWGc8
	 RaOMQdMDGFjLT49v9ypTDs6eCeeI6DIxU4NcHqJ6yuHLwTxJKQHxrku0w2saFJRu5+KLz
	 A59a8M1FbsyErzIr3R+VfiLIWP5B4MCAuaXYX0EN0VSm+qsOsqc3VmkdPsngkWWD7sARN
	 GxNdQkwJfqz9noCPZiW2NArVomtrgZX+0V6gQmhJ+L5cMMkuS9RpGpOQKgo2XUPQeNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=gSGdkEDP;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8111E606A6EF;
	Fri, 27 Nov 2026 14:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8111E606A6EF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=gSGdkEDP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790180;
	bh=nKeWVl2IAK6Uj50M31GS67F4DyW8xp/yvl9wHBeyLSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSGdkEDPCOMkpIGcQt2PgAbFGCcf/t84Vw98w9SKFvMAfjQCQ/ifnd/Mu4MRvMTp3
	 BcwqT1gstT33lGqDrXO5fGfkjLIavcFMZGLrim6jt7DNtUvNw/6vfB7SkU/RJkc9jr
	 n9bJvuExd/GK33ymiASvCcp2wGY+m9nqQRQJqqIE4lp7z6058x+KfhJIruCM7MJ78a
	 x9JlgWa2L9XvzcRV9L0Chbk66nxUx5aghIAIfdykBEleI7wrufFOwJ2zow7tDfKyaX
	 KoWHgv3kLy/MxpYjhRlecgDGJBF17wsBnN0uPdVWPNERb10eEEp233MXDDgQESQuat
	 9uQArwsJGQozA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZX05XszXCT;
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
Subject: [PATCH v12 37/43] sched/deadline: Keep the debt of a task across a change of parameters
Date: Fri, 27 Nov 2026 09:36:04 -0500
Message-ID: <cff3e8c36268d9ce47e4b1a4deaf0d8076965ec0.1795771148.git.mathieu.desnoyers@efficios.com>
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

sched_setattr() changes the parameters of a deadline task, and leaves
the period in progress as it is. Commit 40767b0dc768 ("sched/deadline:
Fix deadline parameter modification handling") chose this: a change
that takes effect at once "would allow one to circumvent the CBS
guarantees". It also knew the cost: admission control counts the new
bandwidth at once, which is "not on the safe side".

The period in progress does not match the new parameters:
- A task that shrinks its reservation runs on with its old runtime,
  while other tasks can be admitted into the bandwidth it gave back.
- The replenishment timer of a throttled task stays armed for the old
  dl_period.
- dl_next_period(), from commit 5ac69d37784b ("sched/deadline: Make
  sure the replenishment timer fires in the next period"), gives a
  wrong next period after a change of dl_deadline.

A task can then get more than its bandwidth, and other deadline tasks
can miss their deadlines. Tang, Anderson and Abeni build such an
overload with two tasks that pass a large runtime back and forth [1].
In the test case params_swap_overload, with 70ms and 1ms every 100ms,
the two tasks take 99% of the CPU on v7.4-rc2, where admission control
counts 71%. With this series, they get 64%. The paper refuses changes
of parameters, but sched_setattr() allows them: that is user-space ABI.

Fix this by fitting the period in progress to the new parameters, at
the change. A task served at its old bandwidth since the start of its
period would have received some runtime by now. If it used more, the
difference is its debt. The new dl_setattr_period(), called from
__setparam_dl(), keeps that debt:
- An awake task goes on with its job, with the runtime left, up to the
  new dl_runtime.
- Its next period starts when the new bandwidth has repaid the debt and
  supplied that runtime. A task that must wait is throttled until then.
- With a constrained deadline, a job that ran counts as a whole job of
  the new parameters. dl_setattr_place() lists the rules.

The rules need the start of the period, in a new field period_start.
dl_next_period() and the replenishment use it. dl_task_timer() no
longer refills a task before its next period: its handler can run just
after a change moved that period.

Some tasks are not fitted at the change. The new flag dl_new_params
marks them:
- A task with no period under the old parameters: its next enqueue
  checks it, as a wakeup does. If it is blocked on an rt_mutex,
  dl_check_blocked_params() checks it at once, so that its waiter node
  is right.
- A boosted task: the boost would override a throttle, and lose the
  debt. Its period is fitted at the first refill that holds the boost,
  or at the deboost. Its 0-lag time meanwhile counts from a fitted copy,
  in dl_zerolag_period().
- A task that comes back to the class with the same parameters, before
  its 0-lag time. It still has its old runtime and deadline, and
  __setparam_dl() fits nothing. __setscheduler_params() marks it.

User-space sees two changes:
- New parameters apply to the period in progress. A task in debt waits
  until the debt is repaid.
- A task in debt that leaves the class stays counted by admission
  control until then. Meanwhile, sched_setattr() can refuse another
  task with -EBUSY.
sched_getattr() returns what it returned before.

What remains: admission control still releases the old bandwidth at
the change. Right after a cut, a task admitted into it can rarely miss
a deadline near the change. With a constrained deadline, a job that
used the new dl_runtime ends at the change. A task that changes its
constrained dl_deadline back and forth while it waits moves its next
period later.

The Sashiko AI review of this series found the dl_next_period()
problem. "selftests/sched: Test parameter changes in deadline_bw_test",
later in this series, lists the cases that fail without this patch.
This patch also updates the expectation of params_switched_asleep,
from "selftests/sched: Add a test of SCHED_DEADLINE bandwidth
accounting": the bandwidth now stays counted until the debt is repaid.

[1] S. Tang, J. H. Anderson, L. Abeni, "On the Defectiveness of
    SCHED_DEADLINE w.r.t. Tardiness and Affinities, and a Partial Fix",
    RTNS 2021, section 3.1, Example 1,
    https://doi.org/10.1145/3453417.3453440

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Fixes: 5ac69d37784b ("sched/deadline: Make sure the replenishment timer fires in the next period")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h                         |  46 +-
 kernel/sched/core.c                           |  11 +-
 kernel/sched/deadline.c                       | 616 ++++++++++++++++--
 kernel/sched/sched.h                          |   3 +
 kernel/sched/syscalls.c                       |  25 +-
 .../sched/deadline/deadline_bw_test.c         |  28 +-
 6 files changed, 646 insertions(+), 83 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a056a2914d0..148e2939e6cb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -661,9 +661,26 @@ struct sched_dl_entity {
 	 */
 	s64				runtime;	/* Remaining runtime for this instance	*/
 	u64				deadline;	/* Absolute deadline for this instance	*/
-	/* Saved when a boost is held: see dl_boost_held */
-	u64				own_deadline;
-	s64				own_runtime;
+	u64				period_start;	/* Absolute start of this instance	*/
+	/*
+	 * setattr_* are used before a boost is held, own_* while it is held.
+	 * dl_hold_refilled_boost() goes from one to the other: it reads
+	 * setattr_* before it writes own_*.
+	 */
+	union {
+		/* Saved when a boost is held: see dl_boost_held */
+		struct {
+			u64		own_deadline;
+			s64		own_runtime;
+			u64		own_period_start;
+		};
+		/* Saved by sched_setattr(): see dl_setattr_saved */
+		struct {
+			u64		setattr_deadline;
+			u64		setattr_runtime;
+			u64		setattr_period;
+		};
+	};
 	unsigned int			flags;		/* Specifying the scheduler behaviour	*/
 
 	/*
@@ -692,10 +709,10 @@ struct sched_dl_entity {
 	 * runtime and deadline are then not those of the task's own
 	 * reservation. The end of the boost clears the flag.
 	 *
-	 * @dl_boost_held tells that own_deadline and own_runtime hold the
-	 * task's own deadline and runtime. The first refill of a boost saves
-	 * them, for a task with parameters of its own. The deboost puts them
-	 * back.
+	 * @dl_boost_held tells that own_deadline, own_runtime and
+	 * own_period_start hold the task's own period. The first refill of a
+	 * boost saves them, for a task with parameters of its own. The deboost
+	 * puts them back.
 	 *
 	 * @dl_server tells if this is a server entity.
 	 *
@@ -724,6 +741,19 @@ struct sched_dl_entity {
 	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
 	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
 	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
+	 * @dl_new_params tells that the runtime left still needs a check
+	 * against new parameters, as a wakeup does. sched_setattr() sets it
+	 * when it changes the runtime, the deadline or the period, or brings
+	 * the task back into the class. It stays set when the change cannot
+	 * fit the period in progress, or when the task is boosted: see
+	 * dl_setattr_period().
+	 *
+	 * @dl_setattr_saved tells that sched_setattr() changed the parameters
+	 * of a boosted task before any refill from its donor.
+	 * setattr_runtime, setattr_deadline and setattr_period hold the old
+	 * parameters. The first refill or the deboost fits the period to the
+	 * new ones with them.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -739,6 +769,8 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
 	unsigned int			dl_bw_oncpu       : 1;
+	unsigned int			dl_new_params     : 1;
+	unsigned int			dl_setattr_saved  : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index edd26b321fee..f374b8a0a38b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7977,8 +7977,15 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 		 *          running task
 		 */
 		if (dl_prio(prio)) {
+			/*
+			 * A boosted task whose parameters changed gets back its
+			 * own period, fitted to them, only at the deboost.
+			 * Deboost it first, so that the top waiter is compared
+			 * with that deadline.
+			 */
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
+			     !(p->dl.dl_new_params && p->dl.pi_se != &p->dl) &&
 			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
 				struct sched_dl_entity *old_donor = p->dl.pi_se;
 
@@ -8001,12 +8008,12 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
-				dl_drop_boost(&p->dl);
+				dl_drop_boost_out(&p->dl);
 			if (oldprio < prio)
 				scope->flags |= ENQUEUE_HEAD;
 		} else {
 			if (dl_prio(oldprio))
-				dl_drop_boost(&p->dl);
+				dl_drop_boost_out(&p->dl);
 			if (rt_prio(oldprio))
 				p->rt.timeout = 0;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 884fe83538ab..ae0940838ca5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -89,15 +89,17 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
  */
 static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
 {
-	dl_se->deadline = rq_clock(rq_of_dl_se(dl_se)) + dl_se->dl_deadline;
+	dl_se->period_start = rq_clock(rq_of_dl_se(dl_se));
+	dl_se->deadline = dl_se->period_start + dl_se->dl_deadline;
 	dl_se->runtime = dl_se->dl_runtime;
 }
 
 /*
- * Put back the deadline and runtime saved when the boost was held, by
- * dl_hold_refilled_boost(). If the task's own next period has started
- * since, start a period of its own instead. Return true if the boost was
- * held. The caller holds the rq lock and has updated the rq clock.
+ * Put back the deadline, runtime and period start saved when the boost
+ * was held, by dl_hold_refilled_boost(). If the task's own next period
+ * has started since, start a period of its own instead. Return true if
+ * the boost was held. The caller holds the rq lock and has updated the
+ * rq clock.
  *
  * A task @asleep on anything but an rt_mutex gets that period at its
  * wakeup instead: a period started now would run while it sleeps.
@@ -106,13 +108,13 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se,
 				     bool asleep)
 {
 	u64 now = rq_clock(rq_of_dl_se(dl_se));
-	u64 next = dl_se->own_deadline - dl_se->dl_deadline + dl_se->dl_period;
 
 	if (!dl_se->dl_boost_held)
 		return false;
-	if (dl_time_before(now, next)) {
+	if (dl_time_before(now, dl_se->own_period_start + dl_se->dl_period)) {
 		dl_se->deadline = dl_se->own_deadline;
 		dl_se->runtime = dl_se->own_runtime;
+		dl_se->period_start = dl_se->own_period_start;
 		/*
 		 * Past its own deadline, the task is in its constrained gap:
 		 * it waits for its own next period. Give back no runtime, so
@@ -129,6 +131,7 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se,
 						(dl_se->deadline - now)) >> BW_SHIFT);
 	} else if (asleep) {
 		dl_se->deadline = dl_se->own_deadline;
+		dl_se->period_start = dl_se->own_period_start;
 		dl_se->runtime = 0;
 	} else {
 		dl_start_own_period(dl_se);
@@ -137,6 +140,20 @@ static inline bool dl_end_held_boost(struct sched_dl_entity *dl_se,
 	return true;
 }
 
+/*
+ * Return true if @dl_se has a constrained deadline and a period, and the
+ * rq clock is past its deadline and before its next period. An enqueue
+ * then throttles it until that period.
+ */
+static inline bool dl_in_constrained_gap(struct sched_dl_entity *dl_se)
+{
+	u64 now = rq_clock(rq_of_dl_se(dl_se));
+
+	return dl_se->deadline && !dl_is_implicit(dl_se) &&
+	       dl_time_before(dl_se->deadline, now) &&
+	       dl_time_before(now, dl_se->period_start + dl_se->dl_period);
+}
+
 #ifdef CONFIG_RT_MUTEXES
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -151,13 +168,13 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
 
 /*
- * Record that a replenishment changes the runtime of @dl_se while it is
- * boosted. At the first refill, dl_hold_refilled_boost() saves the
- * task's own deadline and runtime. Call this before the replenishment
- * adds runtime or moves the deadline. A task with no parameters of its
- * own at the first refill, or no period yet, has no period to save. The
- * deboost then starts a period of its own. Later refills of the
- * same boost save nothing, even if the task gets parameters meanwhile.
+ * Record that a replenishment changes the runtime of @dl_se while
+ * boosted. At the first refill, hold the boost: dl_hold_refilled_boost()
+ * saves the task's own period. Call this before the replenishment moves
+ * the deadline or adds runtime. A task with no parameters of its own at the
+ * first refill, or no period yet, has no period to save. Later refills of
+ * its boost leave it
+ * as it is, even if the task gets parameters meanwhile.
  */
 static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 {
@@ -175,6 +192,17 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
 static int start_dl_timer(struct sched_dl_entity *dl_se);
 
+static void update_dl_entity(struct sched_dl_entity *dl_se);
+
+/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return p->pi_blocked_on;
+}
+
+static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
+			      u64 old_deadline, u64 old_period);
+
 /*
  * End the boost of @dl_se, whose task stays in the class. Then bring the
  * runtime and the deadline of the task back to its own parameters:
@@ -185,10 +213,28 @@ static int start_dl_timer(struct sched_dl_entity *dl_se);
  *    start that period if it has started.
  *  - After a refill of a task that had no parameters of its own at the
  *    refill, start a new period now, or at the wakeup of a task asleep.
- *  - Without a refill, the task keeps the runtime and the deadline of its
- *    own reservation.
- * Do it now: the next enqueue is too late for a task blocked on another
- * rt_mutex. The chain walk copies its deadline into its waiter node first.
+ *    dl_hold_refilled_boost() holds the boost of a task that had them.
+ *  - If sched_setattr() changed the parameters during the boost, before
+ *    any refill, fit the period to them with dl_setattr_period(). It
+ *    uses the old parameters saved at the change.
+ *  - If dl_new_params is still set, check the runtime left against the
+ *    parameters, as a wakeup does.
+ *  - Otherwise, keep the runtime and the deadline of the task's own
+ *    reservation.
+ *
+ * Do this now: the next enqueue is too late for a task blocked on another
+ * rt_mutex. The chain walk copies its deadline into its waiter node
+ * first. rt_mutex_setprio() then compares the result with the top waiter.
+ *
+ * Leave dl_new_params set, and the check to the next enqueue, in two
+ * cases:
+ *  - The task is asleep on anything but an rt_mutex. A period started now
+ *    would run while it sleeps.
+ *  - The task has a constrained deadline, and is past its deadline and
+ *    before its next period. The enqueue throttles it until that period:
+ *    see dl_check_constrained_dl().
+ * A throttled task needs no check: its replenishment uses the new
+ * parameters.
  *
  * The caller holds the rq lock and the pi_lock of the task, and has
  * updated the rq clock.
@@ -196,6 +242,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se);
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
 	struct task_struct *p = dl_task_of(dl_se);
+	bool saved = dl_se->dl_setattr_saved;
 	bool asleep = !task_on_rq_queued(p) && !p->pi_blocked_on;
 	bool held = dl_end_held_boost(dl_se, asleep);
 	bool own = held;
@@ -204,6 +251,7 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 		/* A task asleep gets its first own period at its wakeup. */
 		if (asleep) {
 			dl_se->deadline = 0;
+			dl_se->period_start = 0;
 			dl_se->runtime = 0;
 		} else {
 			dl_start_own_period(dl_se);
@@ -246,12 +294,90 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 			resched_curr(rq);
 		}
 	}
+
+	/*
+	 * Without a held boost and without a refill, fit the period with the
+	 * saved parameters. After a refill, the period started above follows
+	 * the new parameters. A held boost had its own period fitted at the
+	 * change, or at the refill that held it. In all three cases, no check
+	 * is due.
+	 */
+	if (saved) {
+		if (!own)
+			dl_setattr_period(dl_se, dl_se->setattr_runtime,
+					  dl_se->setattr_deadline,
+					  dl_se->setattr_period);
+		dl_se->dl_new_params = 0;
+	} else if (held) {
+		dl_se->dl_new_params = 0;
+	}
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
+static bool dl_setattr_place(struct sched_dl_entity *dl_se, u64 now,
+			     u64 *start, u64 *deadline, s64 *runtime,
+			     u64 old_runtime, u64 old_deadline, u64 old_period,
+			     bool run, bool asleep);
+
+/*
+ * End the boost of @dl_se, whose task leaves the class. If sched_setattr()
+ * changed its parameters before any refill of the boost, fit its period
+ * to them. switched_from_dl() has already worked out the 0-lag time from
+ * a copy of the period fitted the same way: see dl_zerolag_period(). Out
+ * of the class, the task does not go on in its job, and is not throttled.
+ *
+ * The caller holds the rq lock and the pi_lock of the task, and has
+ * updated the rq clock. The task is not on its dl_rq.
+ */
+void dl_drop_boost_out(struct sched_dl_entity *dl_se)
 {
-	return p->pi_blocked_on;
+	bool saved = dl_se->dl_setattr_saved && !dl_se->dl_donor_refill;
+
+	dl_drop_boost(dl_se);
+	if (saved && dl_se->deadline && dl_se->dl_runtime &&
+	    dl_se->setattr_runtime && dl_se->setattr_period)
+		dl_setattr_place(dl_se, rq_clock(rq_of_dl_se(dl_se)),
+				 &dl_se->period_start, &dl_se->deadline,
+				 &dl_se->runtime, dl_se->setattr_runtime,
+				 dl_se->setattr_deadline, dl_se->setattr_period,
+				 false, false);
+}
+
+/*
+ * If sched_setattr() changed the parameters of @p while @p waits on an
+ * rt_mutex, check its runtime left against them now, as a wakeup does.
+ * Before any wakeup, the waiter node of @p holds its deadline.
+ * __sched_setscheduler() then calls rt_mutex_adjust_pi(), which requeues
+ * the waiter with the result. Other changes of @p, such as a cgroup move,
+ * do not requeue the waiter. So only __sched_setscheduler() calls this.
+ *
+ * Leave dl_new_params set for a task that is boosted, throttled, or past
+ * its constrained deadline and before its next period. Its deboost, its
+ * replenishment or its wakeup deals with the new parameters.
+ *
+ * The caller holds the rq lock and the pi_lock of @p, and has updated the
+ * rq clock.
+ */
+void dl_check_blocked_params(struct task_struct *p)
+{
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
@@ -792,6 +918,35 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static inline u64 dl_next_period(struct sched_dl_entity *dl_se);
+static bool dl_setattr_place(struct sched_dl_entity *dl_se, u64 now,
+			     u64 *start, u64 *deadline, s64 *runtime,
+			     u64 old_runtime, u64 old_deadline, u64 old_period,
+			     bool run, bool asleep);
+
+/*
+ * Return the start of the next period that the 0-lag time of @dl_se
+ * counts from, and set *@runtime to the runtime left in the period.
+ * Before the first refill from its donor, a boosted task whose
+ * parameters changed keeps its old period until its deboost. Fit a
+ * copy of it to the new parameters, as the deboost does: see
+ * dl_setattr_period(). The task does not go on in its job here, so the
+ * copy keeps no runtime. Its next period is then the repayment of its
+ * debt, if it has one.
+ */
+static u64 dl_zerolag_period(struct sched_dl_entity *dl_se, struct rq *rq,
+			     s64 *runtime)
+{
+	u64 start = dl_se->period_start, deadline = dl_se->deadline;
+
+	*runtime = dl_se->runtime;
+	if (dl_se->dl_setattr_saved && !dl_se->dl_donor_refill &&
+	    deadline && dl_se->dl_runtime && dl_se->setattr_runtime &&
+	    dl_se->setattr_period)
+		dl_setattr_place(dl_se, rq_clock(rq), &start, &deadline, runtime,
+				 dl_se->setattr_runtime, dl_se->setattr_deadline,
+				 dl_se->setattr_period, false, false);
+	return start + dl_se->dl_period;
+}
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
@@ -818,22 +973,31 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
  *
  * Each check compares against the bound scaled by dl_runtime / dl_period.
  * That quotient cannot overflow, as dl_runtime <= dl_period.
+ *
+ * After sched_setattr(), a boosted task with no refill from its donor yet
+ * keeps the runtime and the deadline of its old parameters until its
+ * deboost: see dl_setattr_period().
+ * dl_zerolag_period() counts from a copy of that period, fitted to the new
+ * parameters as the deboost fits it. This matters when the task blocks
+ * while boosted, or leaves the class at its deboost: switched_from_dl()
+ * runs before dl_drop_boost_out() fits the period.
  */
 static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 {
+	s64 runtime;
 	/* Time to the next period. Negative if it has started. */
-	s64 left = dl_next_period(dl_se) - rq_clock(rq);
+	s64 left = dl_zerolag_period(dl_se, rq, &runtime) - rq_clock(rq);
 
 	/* A task with no period yet has received nothing: no 0-lag time. */
 	if (!dl_se->deadline)
 		return -1;
 
-	if (dl_se->runtime < 0) {
+	if (runtime < 0) {
 		/*
 		 * Overrun: the 0-lag time is after the next period, by the time
 		 * needed to pay the overrun back at the reserved bandwidth.
 		 */
-		u64 overrun = -dl_se->runtime;
+		u64 overrun = -runtime;
 		u64 room = S64_MAX - max(left, 0LL);
 
 		/*
@@ -862,13 +1026,13 @@ static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 	 * passed. The runtime left is more than the bandwidth gives until
 	 * the next period.
 	 */
-	if (dl_se->runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
-						 dl_se->dl_period)) {
+	if (runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
+					  dl_se->dl_period)) {
 		return -1;
 	}
 
 	/* The quotient is at most @left here. */
-	return left - mul_u64_u64_div_u64(dl_se->runtime, dl_se->dl_period,
+	return left - mul_u64_u64_div_u64(runtime, dl_se->dl_period,
 					  dl_se->dl_runtime);
 }
 
@@ -968,7 +1132,8 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	if (!dl_task && !dl_server(dl_se) && !dl_is_implicit(dl_se) &&
 	    dl_se->deadline &&
 	    READ_ONCE(dl_task_of(dl_se)->__state) != TASK_DEAD) {
-		s64 next = dl_next_period(dl_se) - rq_clock(rq);
+		s64 runtime;
+		s64 next = dl_zerolag_period(dl_se, rq, &runtime) - rq_clock(rq);
 
 		if (next > zerolag_time)
 			zerolag_time = next;
@@ -1333,7 +1498,8 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 {
 	dl_note_donor_refill(dl_se);
 	/* for non-boosted task, pi_of(dl_se) == dl_se */
-	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+	dl_se->period_start = rq_clock(rq);
+	dl_se->deadline = dl_se->period_start + pi_of(dl_se)->dl_deadline;
 	dl_se->runtime = pi_of(dl_se)->dl_runtime;
 
 	/*
@@ -1436,6 +1602,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	u64 runtime = READ_ONCE(pi_se->dl_runtime);
 	u64 deadline = READ_ONCE(pi_se->dl_deadline);
 	u64 period = READ_ONCE(pi_se->dl_period);
+	bool new_period = false;
 
 	/*
 	 * A boosted entity runs on the parameters of its donor, the top
@@ -1457,6 +1624,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 		if (!dl_se->dl_deadline) {
 			dl_note_donor_refill(dl_se);
 			dl_se->deadline = rq_clock(rq);
+			dl_se->period_start = dl_se->deadline;
 			dl_se->runtime = 0;
 		}
 		if (dl_se->runtime < 0 || dl_se->dl_yielded) {
@@ -1481,7 +1649,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
 		dl_note_donor_refill(dl_se);
-		dl_se->deadline = rq_clock(rq) + deadline;
+		dl_se->period_start = rq_clock(rq);
+		dl_se->deadline = dl_se->period_start + deadline;
 		dl_se->runtime = runtime;
 	}
 
@@ -1499,8 +1668,19 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	while (dl_se->runtime <= 0) {
 		dl_se->deadline += period;
+		dl_se->period_start += period;
 		dl_se->runtime += runtime;
+		new_period = true;
 	}
+	/*
+	 * The loop moves the deadline and period_start together. After
+	 * sched_setattr(), deadline - period_start can differ from
+	 * dl_deadline. Set the deadline from period_start for the new
+	 * period. A boosted task keeps the relative deadline of its donor.
+	 * sched_setattr() does not change a dl_server.
+	 */
+	if (new_period && !is_dl_boosted(dl_se) && !dl_server(dl_se))
+		dl_se->deadline = dl_se->period_start + dl_se->dl_deadline;
 
 	/*
 	 * At this point, the deadline really should be "in
@@ -1690,7 +1870,8 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	 * that allows more than dl_runtime. So cap the runtime at dl_runtime
 	 * first. An implicit task is checked against its bandwidth, which
 	 * keeps it within its reservation for any deadline. A boosted task
-	 * runs on the parameters of its donor.
+	 * runs on the parameters of its donor. dl_setattr_period() keeps no
+	 * more than dl_runtime already, so this check is only a guard.
 	 */
 	if (!dl_is_implicit(dl_se) && !is_dl_boosted(dl_se) &&
 	    dl_se->runtime > (s64)dl_se->dl_runtime)
@@ -1726,9 +1907,14 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	}
 }
 
+/*
+ * Return the start of the next period of @dl_se. Do not work it out from
+ * the deadline and dl_deadline: sched_setattr() can change dl_deadline
+ * during the period.
+ */
 static inline u64 dl_next_period(struct sched_dl_entity *dl_se)
 {
-	return dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period;
+	return dl_se->period_start + dl_se->dl_period;
 }
 
 #ifdef CONFIG_RT_MUTEXES
@@ -1780,6 +1966,7 @@ void dl_proxy_block(struct task_struct *p)
 	    dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 	    dl_time_before(rq_clock(rq), dl_next_period(dl_se)))
 		goto unlock;
+	dl_se->dl_new_params = 0;
 	update_dl_entity(dl_se);
 unlock:
 	__task_rq_unlock(rq, p, &rf);
@@ -1821,7 +2008,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se)
 		WARN_ON_ONCE(!dl_se->dl_throttled);
 		act = ns_to_ktime(dl_se->deadline - dl_se->runtime);
 	} else {
-		/* act = deadline - rel-deadline + period */
+		/* act = the start of the next period */
 		act = ns_to_ktime(dl_next_period(dl_se));
 	}
 
@@ -1971,6 +2158,10 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 		if (dl_se->dl_throttled && !is_dl_boosted(dl_se)) {
 			sched_clock_tick();
 			update_rq_clock(rq);
+			/* Not before the next period: see below. */
+			if (dl_time_before(rq_clock(rq), dl_next_period(dl_se)) &&
+			    start_dl_timer(dl_se))
+				goto unlock;
 			replenish_dl_entity(dl_se);
 		}
 		goto unlock;
@@ -1996,6 +2187,18 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	sched_clock_tick();
 	update_rq_clock(rq);
 
+	/*
+	 * sched_setattr() can move the next period while this handler waits
+	 * for the rq lock: see dl_setattr_period(). Do not refill before that
+	 * period starts. start_dl_timer() arms the timer there, or finds it
+	 * armed. If it finds the time passed, refill now. A boosted task
+	 * asleep is in a period of its donor: refill it as before.
+	 */
+	if (!is_dl_boosted(dl_se) &&
+	    dl_time_before(rq_clock(rq), dl_next_period(dl_se)) &&
+	    start_dl_timer(dl_se))
+		goto unlock;
+
 	/*
 	 * If the throttle happened during sched-out; like:
 	 *
@@ -2689,6 +2892,7 @@ int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 perio
 
 	dl_se->runtime = 0;
 	dl_se->deadline = 0;
+	dl_se->period_start = 0;
 
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
@@ -3147,7 +3351,18 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
+	bool new_params = dl_se->dl_new_params;
+
 	WARN_ON_ONCE(on_dl_rq(dl_se));
+	/*
+	 * Clear dl_new_params unless the task is boosted. The code below
+	 * checks the runtime left as a wakeup does, or refills the task.
+	 * A throttled task waits for its replenishment instead. A boosted
+	 * task is refilled from its donor: dl_deboost() checks it at the
+	 * deboost.
+	 */
+	if (!is_dl_boosted(dl_se))
+		dl_se->dl_new_params = 0;
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -3196,12 +3411,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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
@@ -3211,8 +3427,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	}
 
 	/*
-	 * A task can come back to the class with no runtime left, before its
-	 * deadline. It would run until the next tick. Throttle it now, until
+	 * A task can be enqueued with no runtime left, before its deadline: a
+	 * return to the class, or a wakeup after sched_setattr() left it no
+	 * runtime. It would run until the next tick. Throttle it now, until
 	 * its next period, as update_curr_dl_se() would.
 	 */
 	if (!dl_server(dl_se) && !is_dl_boosted(dl_se) &&
@@ -4965,6 +5182,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 */
 	if (!p->dl.dl_runtime) {
 		p->dl.deadline = 0;
+		p->dl.period_start = 0;
 		p->dl.runtime = 0;
 	}
 
@@ -5064,8 +5282,9 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 		 * start a new period now for a task that waits on an
 		 * rt_mutex, as setup_new_dl_entity() does at an enqueue.
 		 *
-		 * A task that comes back to the class before its 0-lag time
-		 * keeps its deadline. For a constrained task, that deadline
+		 * A task that sched_setattr() brings back before its 0-lag
+		 * time keeps its deadline. dl_check_blocked_params() has
+		 * checked its runtime. For a constrained task, that deadline
 		 * can have passed before its next period. As
 		 * dl_check_constrained_dl() and dl_proxy_block() do, leave
 		 * such a task alone unless it is boosted. Its wakeup
@@ -5073,8 +5292,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 		 */
 		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
 		    dl_time_before(p->dl.deadline, rq_clock(rq)) &&
-		    (is_dl_boosted(&p->dl) ||
-		     !dl_time_before(rq_clock(rq), dl_next_period(&p->dl))))
+		    (is_dl_boosted(&p->dl) || !dl_in_constrained_gap(&p->dl)))
 			replenish_dl_new_period(&p->dl, rq);
 
 		return;
@@ -5377,47 +5595,304 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	return err;
 }
 
+/*
+ * Return @a * @b / @c rounded up, capped at @cap. With a raised
+ * sched_deadline_period_max_us, a runtime times a ratio of period to
+ * runtime can exceed 64 bits. mul_u64_u64_div_u64() then traps on
+ * x86-64, so compare with @cap first.
+ */
+static u64 dl_mul_div_cap(u64 a, u64 b, u64 c, u64 cap)
+{
+	if (b > c && a > mul_u64_u64_div_u64(cap, c, b))
+		return cap;
+	return min(mul_u64_u64_div_u64_roundup(a, b, c), cap);
+}
+
+/* The longest wait that sched_setattr() sets, far longer than any period. */
+#define DL_SETATTR_WAIT_MAX	(1ULL << 62)
+
+/*
+ * Fit a period of @dl_se to its new parameters. sched_setattr() changed
+ * them from @old_runtime, @old_deadline and @old_period. At @now,
+ * *@start, *@deadline and *@runtime describe the period in progress
+ * under the old parameters. On return, they describe a period under the
+ * new ones. Return true if the task must wait for that period, with no
+ * runtime.
+ *
+ * These terms are used below:
+ *  - The release of the job is *@deadline - @old_deadline.
+ *  - The 0-lag time is when the task, served at its old bandwidth since
+ *    *@start, would have received the runtime it used.
+ *  - The debt is the runtime that the old bandwidth gives from @now to
+ *    a 0-lag time ahead. A task with a debt ran ahead of its
+ *    reservation.
+ *  - The repayment is when the new bandwidth, from @now, has supplied
+ *    the debt and the runtime that the job keeps.
+ *
+ * Keep the debt across the change. Admission control already counts the
+ * new bandwidth, so repay the debt at that bandwidth. Otherwise, a change
+ * could give the task a new period at once, ahead of the tasks it was
+ * admitted with.
+ *
+ * If @run, the task goes on in its current job, with the runtime left
+ * capped at dl_runtime. The next period starts at the repayment. With a
+ * new implicit deadline, the job ends there too.
+ *
+ * A constrained deadline, old or new, adds these rules:
+ *  - A job past its old deadline, or past its release plus dl_deadline,
+ *    keeps no runtime.
+ *  - A job keeps no more than the runtime left of a job of the new
+ *    parameters.
+ *  - Two releases are at least dl_period apart.
+ *
+ * A new constrained deadline adds these rules:
+ *  - The job keeps no more runtime than the new density allows before
+ *    its release plus dl_deadline.
+ *  - The job ends at max(release + dl_deadline,
+ *                        min(repayment, old deadline)).
+ *  - A job that ran counts as a whole job of the new parameters. So the
+ *    next period starts no earlier than the end of the job - dl_deadline
+ *    + dl_period. Otherwise, an old job followed closely by new jobs
+ *    could put more demand in a window than either set of parameters
+ *    does.
+ *
+ * Without a job to go on with, the task waits for its next period with no
+ * runtime, or starts it now if it is due. A task @asleep with a new
+ * constrained deadline does not wait: its wakeup starts its next period,
+ * or throttles it until then. Throttling it while it sleeps could waste
+ * a period. Its timer could start a period that ends before the wakeup.
+ * The wakeup would then throttle it until the period after.
+ */
+static bool dl_setattr_place(struct sched_dl_entity *dl_se, u64 now,
+			     u64 *start, u64 *deadline, s64 *runtime,
+			     u64 old_runtime, u64 old_deadline, u64 old_period,
+			     bool run, bool asleep)
+{
+	u64 dl_runtime = dl_se->dl_runtime;
+	u64 dl_deadline = dl_se->dl_deadline;
+	u64 dl_period = dl_se->dl_period;
+	bool constrained = dl_deadline < dl_period || old_deadline < old_period;
+	u64 release = *deadline - old_deadline;
+	u64 zerolag = *start + old_period;
+	u64 debt = 0, keep = 0, used = 0, next = now, end = *deadline;
+
+	/* Round against the task, here and below. */
+	if (*runtime > 0)
+		zerolag -= mul_u64_u64_div_u64(*runtime, old_period, old_runtime);
+	else
+		zerolag += dl_mul_div_cap(-*runtime, old_period, old_runtime,
+					  DL_SETATTR_WAIT_MAX);
+	if (dl_time_before(now, zerolag))
+		debt = mul_u64_u64_div_u64_roundup(zerolag - now, old_runtime, old_period);
+
+	if (*runtime < (s64)old_runtime)
+		used = old_runtime - max_t(s64, *runtime, 0);
+
+	if (run && *runtime > 0) {
+		if (!constrained) {
+			keep = min_t(u64, *runtime, dl_runtime);
+		} else if (dl_time_before(now, *deadline) &&
+			   dl_time_before(now, release + dl_deadline)) {
+			if (used < dl_runtime)
+				keep = min_t(u64, *runtime, dl_runtime - used);
+			if (dl_deadline < dl_period)
+				keep = min(keep, mul_u64_u64_div_u64(release + dl_deadline - now,
+								     dl_runtime, dl_deadline));
+		}
+	}
+
+	next += dl_mul_div_cap(debt + keep, dl_period, dl_runtime, DL_SETATTR_WAIT_MAX);
+	if (dl_deadline < dl_period && keep) {
+		if (dl_time_before(next, end))
+			end = next;
+		if (dl_time_before(end, release + dl_deadline))
+			end = release + dl_deadline;
+	}
+	if (constrained && dl_time_before(next, release + dl_period))
+		next = release + dl_period;
+	/* A job that ran counts as a whole job: see above. */
+	if (dl_deadline < dl_period && (keep || used) &&
+	    dl_time_before(next, end - dl_deadline + dl_period))
+		next = end - dl_deadline + dl_period;
+
+	if (keep) {
+		*runtime = keep;
+		*start = next - dl_period;
+		*deadline = dl_deadline < dl_period ? end : next;
+		return false;
+	}
+	*runtime = 0;
+	if (asleep && dl_deadline < dl_period) {
+		if (dl_time_before(next, now))
+			next = now;
+		*start = next - dl_period;
+		*deadline = *start + dl_deadline;
+		return false;
+	}
+	if (!dl_time_before(now, next)) {
+		*start = now;
+		*deadline = now + dl_deadline;
+		*runtime = dl_runtime;
+		return false;
+	}
+	*start = next - dl_period;
+	*deadline = *start + dl_deadline;
+	return true;
+}
+
+/*
+ * Fit the period in progress of @dl_se to its new parameters, by the
+ * rules of dl_setattr_place(). @old_runtime, @old_deadline and
+ * @old_period are the parameters before sched_setattr() changed them. A
+ * task that must wait for its next period is throttled until then. A
+ * task blocked on an rt_mutex counts as awake: the chain walk copies its
+ * deadline into its waiter node before any wakeup.
+ *
+ * For a boosted task, it depends on the boost:
+ *  - A held boost keeps the task's own period aside, and the task does
+ *    not run in it. Fit that period. dl_end_held_boost() puts it back.
+ *  - Any other boost runs the task in its own period until the first
+ *    refill from its donor. Save the old parameters at the first change
+ *    before that refill. If the refill comes first, it holds the boost,
+ *    and dl_hold_refilled_boost() fits the period with them. If the
+ *    deboost comes first, dl_deboost() or dl_drop_boost_out() fits it.
+ *
+ * Return true if the runtime left or the period still needs work later.
+ * That is the case for a boosted task: its deboost does it. A task with
+ * no period under the old parameters needs it too: its next enqueue
+ * checks the runtime left as a wakeup does. Return false for any other
+ * task: it is now in a period of the new parameters. The wakeup check
+ * rounds to the microsecond. It could find an overflow there and start
+ * a new period, which the debt does not allow.
+ *
+ * The caller holds the rq lock and the pi_lock of the task, and has
+ * updated the rq clock. The task is not on its dl_rq: every caller runs
+ * inside a change of the task, which dequeues it first.
+ */
+static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
+			      u64 old_deadline, u64 old_period)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = task_rq(p);
+	u64 now = rq_clock(rq);
+	bool asleep = !task_on_rq_queued(p) && !dl_task_pi_blocked(p);
+
+	if (!dl_se->deadline || !dl_se->dl_runtime || !old_runtime || !old_period)
+		return true;
+
+	if (dl_se->dl_boost_held) {
+		dl_setattr_place(dl_se, now, &dl_se->own_period_start,
+				 &dl_se->own_deadline, &dl_se->own_runtime,
+				 old_runtime, old_deadline, old_period, false, false);
+		return true;
+	}
+
+	if (is_dl_boosted(dl_se)) {
+		if (!dl_se->dl_setattr_saved && !dl_se->dl_donor_refill) {
+			dl_se->setattr_runtime = old_runtime;
+			dl_se->setattr_deadline = old_deadline;
+			dl_se->setattr_period = old_period;
+			dl_se->dl_setattr_saved = 1;
+		}
+		return true;
+	}
+
+	/*
+	 * start_dl_timer() does not move a queued timer: cancel it first. If
+	 * its handler is already running, the cancel fails. The handler then
+	 * waits for the rq lock. It finds the task no longer throttled, or
+	 * arms the timer again at the next period set here.
+	 */
+	cancel_replenish_timer(dl_se);
+	/* A yield gave up the rest of the old period only. */
+	dl_se->dl_yielded = 0;
+	if (!dl_setattr_place(dl_se, now, &dl_se->period_start, &dl_se->deadline,
+			      &dl_se->runtime, old_runtime, old_deadline,
+			      old_period, !dl_se->dl_throttled && !asleep, asleep)) {
+		dl_se->dl_throttled = 0;
+		return false;
+	}
+
+	/*
+	 * The next period is ahead, so the timer can be armed. A running
+	 * task is now off the dl_rq: reschedule, as a throttle in
+	 * update_curr_dl_se() does.
+	 */
+	dl_se->dl_throttled = 1;
+	if (WARN_ON_ONCE(!start_dl_timer(dl_se)))
+		replenish_dl_entity(dl_se);
+	if (task_current_donor(rq, p))
+		resched_curr(rq);
+	return false;
+}
+
 #ifdef CONFIG_RT_MUTEXES
 /*
  * A boosted task is refilled from its donor when its runtime is used up,
  * or when its deadline has passed. A wakeup also refills it when the
- * donor's density does not allow the runtime left. After the first
- * refill, the runtime and the deadline of the task are no longer those
- * of its own reservation. So save them in own_* at that refill: this
- * holds the boost. dl_deboost() puts them back.
+ * donor's density does not allow the runtime left. From then on, the task
+ * runs on the donor's reservation. So save the task's own period in own_*
+ * at the first refill: this holds the boost. dl_deboost() puts it back.
  *
  * Keep the runtime left if the task's own deadline is still ahead.
  * Otherwise save no runtime. A negative runtime is an overrun that comes
  * from the boost, so the task's own reservation does not pay for it (see
  * replenish_dl_entity()).
  *
- * The caller holds the rq lock of the task, and has updated the rq clock.
+ * If sched_setattr() changed the parameters before this refill,
+ * dl_setattr_period() saved the old ones in setattr_*. Fit the period
+ * saved in own_* to the new parameters with them. setattr_* share
+ * storage with own_*: read them before writing own_*. The caller holds
+ * the rq lock of the task, and has updated the rq clock.
  */
 static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
 {
+	u64 old_runtime = dl_se->setattr_runtime;
+	u64 old_deadline = dl_se->setattr_deadline;
+	u64 old_period = dl_se->setattr_period;
+	bool saved = dl_se->dl_setattr_saved;
 	u64 now = rq_clock(rq_of_dl_se(dl_se));
 
 	dl_se->own_deadline = dl_se->deadline;
-	dl_se->own_runtime = dl_time_before(now, dl_se->deadline) ?
-			     max_t(s64, dl_se->runtime, 0) : 0;
+	dl_se->own_runtime = max_t(s64, dl_se->runtime, 0);
+	dl_se->own_period_start = dl_se->period_start;
 	dl_se->dl_boost_held = 1;
+	dl_se->dl_setattr_saved = 0;
+	/*
+	 * An overrun is saved as 0: it comes from the boost. The fit counts
+	 * the runtime left as unused, even past the deadline. Without a fit,
+	 * keep no runtime past the deadline.
+	 */
+	if (saved && dl_se->own_deadline && old_runtime && old_period)
+		dl_setattr_place(dl_se, now, &dl_se->own_period_start,
+				 &dl_se->own_deadline, &dl_se->own_runtime,
+				 old_runtime, old_deadline, old_period, false, false);
+	else if (!dl_time_before(now, dl_se->own_deadline))
+		dl_se->own_runtime = 0;
 }
 #endif /* CONFIG_RT_MUTEXES */
 
 /*
- * This function initializes the sched_dl_entity of a newly becoming
- * SCHED_DEADLINE task.
- *
- * Only the static values are considered here, the actual runtime and the
- * absolute deadline will be properly calculated when the task is enqueued
- * for the first time with its new policy.
+ * Set the deadline parameters of @p from @attr. A task new to the class
+ * gets its runtime and its absolute deadline at its first enqueue with
+ * its new policy. For a task with a period in progress, fit that period
+ * to the new parameters with dl_setattr_period().
  */
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 	u64 period = attr->sched_period ?: attr->sched_deadline;
+	u64 old_runtime = dl_se->dl_runtime;
+	u64 old_deadline = dl_se->dl_deadline;
+	u64 old_period = dl_se->dl_period;
+	bool pending = dl_se->dl_new_params;
 	bool held;
 
+	if (attr->sched_runtime != dl_se->dl_runtime ||
+	    attr->sched_deadline != dl_se->dl_deadline ||
+	    period != dl_se->dl_period)
+		dl_se->dl_new_params = 1;
+
 	/*
 	 * Change the bandwidth that the runqueue counts here, with the
 	 * parameters. A task that priority inheritance boosted into the
@@ -5440,6 +5915,30 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	else if (!dl_se_holds_bw(dl_se) && held)
 		atomic_dec(&dl_nr_bw_tasks);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
+	/*
+	 * Fit the period in progress to the new parameters. Then clear
+	 * dl_new_params if the runtime left needs no check. Keep it if it
+	 * was set before this change: that check is still due.
+	 */
+	if (dl_se->dl_new_params &&
+	    !dl_setattr_period(dl_se, old_runtime, old_deadline, old_period) &&
+	    !pending)
+		dl_se->dl_new_params = 0;
+
+	/*
+	 * The inactive timer of a task asleep in the class is armed for the
+	 * 0-lag time of its old period. A change that keeps dl_bw leaves it
+	 * armed: see dl_change_utilization(). Arm it again from the period
+	 * set above. If its handler is already running, it releases the
+	 * bandwidth.
+	 */
+	if (dl_prio(p->prio) && !is_dl_boosted(dl_se) &&
+	    dl_se->dl_non_contending &&
+	    hrtimer_try_to_cancel(&dl_se->inactive_timer) == 1) {
+		dl_se->dl_non_contending = 0;
+		put_task_struct(p);
+		task_non_contending(dl_se, true);
+	}
 }
 
 void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags)
@@ -5539,6 +6038,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_density		= 0;
 
 	dl_se->deadline			= 0;
+	dl_se->period_start		= 0;
 	dl_se->runtime			= 0;
 
 	dl_se->dl_throttled		= 0;
@@ -5552,6 +6052,8 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
+	dl_se->dl_setattr_saved		= 0;
 }
 
 void init_dl_entity(struct sched_dl_entity *dl_se)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 32560b08808e..43aef9b61b67 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -413,7 +413,9 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 }
 
 extern void dl_deboost(struct sched_dl_entity *dl_se);
+extern void dl_drop_boost_out(struct sched_dl_entity *dl_se);
 extern void dl_boost_blocked(struct task_struct *p);
+extern void dl_check_blocked_params(struct task_struct *p);
 
 /*
  * End the boost of @dl_se, and forget the deadline and runtime saved for
@@ -425,6 +427,7 @@ static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
 	dl_clear_donor(dl_se);
 	dl_se->dl_donor_refill = 0;
 	dl_se->dl_boost_held = 0;
+	dl_se->dl_setattr_saved = 0;
 }
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 9778663fe370..4f26601f0530 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -242,15 +242,31 @@ static void __setscheduler_params(struct task_struct *p,
 		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
+	bool enters_dl;
 
 	if (policy == SETPARAM_POLICY)
 		policy = p->policy;
 
+	enters_dl = dl_policy(policy) && !dl_policy(p->policy);
 	p->policy = policy;
 
-	if (dl_policy(policy))
+	if (dl_policy(policy)) {
+		u64 period = attr->sched_period ?: attr->sched_deadline;
+		bool same = attr->sched_runtime == p->dl.dl_runtime &&
+			    attr->sched_deadline == p->dl.dl_deadline &&
+			    period == p->dl.dl_period;
+
 		__setparam_dl(p, attr);
-	else if (fair_policy(policy))
+		/*
+		 * A task that comes back to the class before its 0-lag time
+		 * still has its old runtime and deadline. With new parameters,
+		 * __setparam_dl() has fitted its period to them. With the same
+		 * ones, set dl_new_params, so that the runtime left is checked
+		 * as at a wakeup.
+		 */
+		if (enters_dl && same)
+			p->dl.dl_new_params = 1;
+	} else if (fair_policy(policy))
 		__setparam_fair(p, attr);
 
 	/* rt-policy tasks do not have a timerslack */
@@ -310,7 +326,10 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * the class. Drop its boost then, as rt_mutex_setprio() does.
 	 */
 	if (!dl_prio(newprio))
-		dl_drop_boost(&p->dl);
+		dl_drop_boost_out(&p->dl);
+
+	/* A blocked task's waiter node holds its deadline: check it now. */
+	dl_check_blocked_params(p);
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index 1e3881199e4c..83dd8b4e79a3 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -1246,17 +1246,17 @@ static long long bw_of(uint64_t runtime, uint64_t period)
 }
 
 /*
- * A deadline task of 20ms every 100ms runs 10ms of a new period, then
- * sleeps. The main thread changes its parameters, then switches it to
- * SCHED_OTHER. task_non_contending() computes its 0-lag time from the
- * 10ms left and the new parameters. The root domain keeps the new
- * bandwidth in its total_bw until then.
- *  - Changed to 5ms every 100ms, the 10ms left overflow the new
- *    parameters. The 0-lag time has passed. The bandwidth must be
- *    released at once. The old parameters would keep it about 40ms more.
- *  - Changed to 50ms every 100ms, the 10ms left fit. The 0-lag time is
- *    20ms before the deadline, about 70ms ahead. The bandwidth must still
- *    be counted right after the switch, and released after the deadline.
+ * A deadline task of 20ms every 100ms runs 10ms at the start of a new
+ * period, then sleeps. In those 10ms, its bandwidth gave it 2ms: it ran
+ * 8ms ahead. The main thread changes its parameters, then switches it
+ * to SCHED_OTHER. The change keeps the 8ms as a debt, repaid at the new
+ * bandwidth. task_non_contending() releases the bandwidth once the debt
+ * is repaid. Until then, the root domain counts the new bandwidth in its
+ * total_bw:
+ *  - changed to 5ms every 100ms, for about 160ms;
+ *  - changed to 50ms every 100ms, for about 16ms.
+ * The bandwidth must be counted right after the switch, and released
+ * within 300ms.
  */
 static int params_switched_asleep(void)
 {
@@ -1281,16 +1281,16 @@ static int params_switched_asleep(void)
 			ret = KSFT_FAIL;
 		} else {
 			bw = total_bw_of(cpu);
-			want = base + (i ? bw_of(rt[i] * NSEC_PER_MSEC, PERIOD) : 0);
+			want = base + bw_of(rt[i] * NSEC_PER_MSEC, PERIOD);
 			if (bw != want) {
 				ksft_print_msg("%llums every 100ms: total_bw %lld after the switch, %lld expected\n",
 					       (unsigned long long)rt[i], bw, want);
 				ret = KSFT_FAIL;
 			}
-			sleep_ns(PERIOD);	/* past the deadline */
+			sleep_ns(3 * PERIOD);	/* past the 0-lag time */
 			bw = total_bw_of(cpu);
 			if (ret == KSFT_PASS && bw != base) {
-				ksft_print_msg("%llums every 100ms: total_bw %lld after the deadline, %lld expected\n",
+				ksft_print_msg("%llums every 100ms: total_bw %lld after the 0-lag time, %lld expected\n",
 					       (unsigned long long)rt[i], bw, base);
 				ret = KSFT_FAIL;
 			}
-- 
2.47.3

