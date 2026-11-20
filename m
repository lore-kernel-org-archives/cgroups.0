Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182970;
	b=oHwNYfpj9jQ4oOAou6brGYFCwrtRHMIK0qOW+JInYfDimXR2CKcP9VK7/bq6sGh4ovZT
	 QYCvgLiyw4SfoFyke20lzK9ZDQCCFfkt++TIX5ZYjz/sG9bFgouYWrZ+z34DWe75QwUOA
	 Iekn2pt6mdg2AN5Gr5eA+QPQjvUHSfSoPtYc6PdJDUXJzWwIhzUwE7TdBHEw4PmzhU4+O
	 Fb5kQtScR6NjSwJ/EqlYOPIA/GpzMaft+UaSNJG7QRHKNeASadcvLpCPTDUiD+6Si9kbp
	 mcfNJxd+sL3LPp7axwvfeSOpxNy6nXubdJe4ITS5kfaH3xcSo/9oKSGLMXjhZlY+I6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g61ociSCBdZel0zIVQLJVWSy8g8pxReuIBRbl3sP1as=;
	b=VEaUNGgo8x32bdL3/mCvqf4Q4Gt9fLBCXhE1CxcmEH94UMPp7aF3OQgnbNx0DYzbtGU0
	 kVdS7hmtlyRL+1QSpqZhkQ7aozBJ51j/zlE58EsnpBnqM+uig51F11WP5SRnXyVEht5JU
	 OZrFdFrF2w+pAqHU+RJDESYlx07u2FJrLMCXcXQGl3Al0yw7usYATeVtyI9fjp/ol9JTl
	 afvGoyzxP6z1HHXZ93uEQ3Wv10ILynp3qoORxJTFnV1j0FZ+MVtS+wu7t2qjZR3amMajk
	 9qyQYu8ezoFC8mZmAWSl5IKG1ZIRiKPmIVLwnBkILB8s+tb8IQ46QdWC+3b5xSApw9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Hy7zTl7B;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DBD606C50E;
	Fri, 20 Nov 2026 13:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92DBD606C50E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Hy7zTl7B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182965;
	bh=g61ociSCBdZel0zIVQLJVWSy8g8pxReuIBRbl3sP1as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy7zTl7Baa1a9Z12RXjYFqQ3FZyFHd/AWou0LP1bI3symkSpBD++rYWeZIt/KdY2Q
	 xjlrf4VMZOBIfzl3fbsza3qSazU+FvnmcSVbR38R7mG1XzYHRjBooG+4k6+kkqgZC6
	 HugZnnzqhnDNGdpdw34/hMb4w/7kfrW7qZA03CGaPxipKw8TrwXwYNQm6tLsQGwDYn
	 gks4AetLQnCcAFgrlf9BIn2qL2gSF+6icYunsaczKTg4M05Xwc2kMHKnY9fdLYN/wq
	 FCPPN9v0gG8I1+prgbfSGkzGPzfqWQXn4eJoRAkjU0X2OgyYNVcBCE+mKak38HPyhl
	 mdatD0LhHoWjw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1J6jH5zSrj;
	Fri, 20 Nov 2026 08:56:04 -0500 (EST)
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
Subject: [PATCH v9 32/33] sched/deadline: Check the runtime of a task whose parameters change
Date: Fri, 20 Nov 2026 08:55:55 -0500
Message-Id: <d65436da41c304678dd3d77f003f32d05583fed7.1795181240.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
References: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
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
period. The next enqueue then calls update_dl_entity(). It starts a new
period, or reduces the runtime of a constrained task, if the runtime
left does not fit. The task gets no more than a wakeup would give it. A
boosted task runs on the parameters of its donor. So it keeps the mark
until its deboost. dl_deboost() checks it there, before
rt_mutex_setprio() compares the task with its top waiter. A task with a
constrained deadline can be past its deadline and before its next
period. It keeps the mark until its enqueue, which throttles it first.
A task blocked on an rt_mutex is not enqueued before its wakeup, but
its waiter node holds its deadline. So prio_changed_dl() checks the
runtime of such a task at once. rt_mutex_adjust_pi() then requeues its
waiter. A larger reservation still takes effect at the next period.

The enqueue flags cannot tell a change of parameters: a cgroup move
also uses ENQUEUE_MOVE. Without the mark, a task that waited behind
others could fail the check, and get a later deadline for no reason.

The change_running_new_params case, added to deadline_bw_test later in
this series, tests this. change_boosted_new_params tests a task that
changes its parameters while boosted. Both fail on v7.4-rc2 and pass
with this patch. deboost_new_params_reboost tests the check at the
deboost. setattr_blocked_new_period tests a task blocked on an
rt_mutex. Without the check in prio_changed_dl(), it took the lock
after a waiter with a later deadline, in 6 runs of 6.

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  5 +++
 kernel/sched/deadline.c | 72 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 71 insertions(+), 6 deletions(-)

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
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b319173178f3..77f37a23b808 100644
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
@@ -114,6 +127,8 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 		dl_se->dl_donor_refill = 1;
 }
 
+static void update_dl_entity(struct sched_dl_entity *dl_se);
+
 /*
  * End the boost of @dl_se, whose task stays in the class. If the boost
  * refilled its runtime from the donor's parameters, start a new period
@@ -122,6 +137,13 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
  * first. Without a refill, the task keeps the runtime and the deadline
  * of its own reservation.
  *
+ * If sched_setattr() changed the parameters during the boost, check the
+ * runtime left against them now, for the same reason. rt_mutex_setprio()
+ * then compares the result with the top waiter. Leave that check to the
+ * next enqueue for a task with a constrained deadline, past its deadline
+ * and before its next period. The enqueue first throttles it until that
+ * period: see dl_check_constrained_dl().
+ *
  * The caller holds the rq lock and the pi_lock of the task, and has
  * updated the rq clock.
  */
@@ -130,6 +152,14 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	if (dl_se->dl_donor_refill)
 		dl_start_own_period(dl_se);
 	dl_drop_boost(dl_se);
+
+	if (dl_se->dl_new_params && !dl_se->dl_throttled && dl_in_constrained_gap(dl_se))
+		return;
+	if (dl_se->dl_new_params) {
+		dl_se->dl_new_params = 0;
+		if (!dl_se->dl_throttled)
+			update_dl_entity(dl_se);
+	}
 }
 
 /* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
@@ -2912,7 +2942,16 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
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
 
@@ -2961,12 +3000,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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
@@ -4832,8 +4872,22 @@ static u64 get_prio_dl(struct rq *rq, struct task_struct *p)
  */
 static void prio_changed_dl(struct rq *rq, struct task_struct *p, u64 old_deadline)
 {
-	if (!task_on_rq_queued(p))
+	if (!task_on_rq_queued(p)) {
+		/*
+		 * The deadline of a task blocked on an rt_mutex is in its
+		 * waiter node, before any wakeup. If sched_setattr() changed
+		 * its parameters, check its runtime against them now, as
+		 * dl_deboost() does. rt_mutex_adjust_pi() then requeues the
+		 * waiter with the result.
+		 */
+		if (p->dl.dl_new_params && !is_dl_boosted(&p->dl) &&
+		    !p->dl.dl_throttled && dl_task_pi_blocked(p) &&
+		    !dl_in_constrained_gap(&p->dl)) {
+			p->dl.dl_new_params = 0;
+			update_dl_entity(&p->dl);
+		}
 		return;
+	}
 
 	if (p->dl.deadline == old_deadline)
 		return;
@@ -5114,6 +5168,11 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
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
@@ -5247,6 +5306,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

