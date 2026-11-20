Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207370;
	b=xpCWYRXBGLs3ZJ9b5vmB6OYBmlBJ833+jHAenXEzXe3qaPJuHaK+FROqH8AzMFQ5YwVV
	 Nnw+4S+gJuSdO0t6ZBgCsyzEi7XIl3QCDyC7IXD2KUfJuiP8PhxBZaY0dxL4UMdrr6HB1
	 R23hrmqK8ySOpOTUAuGvFwa6JZh2L0neeACfnOgiCYAvEZzhMr7V4qPAawY0X4YEJnVjj
	 pF0I4pwfKclQAK+bBP0WTjDE47PzkTPKYr2DPBCJqGfSuol7XqU+yJkV0ySMD9qKUYhyD
	 x9782QHmqFsbvdtd5gzkT2bjVTVdx08w9LcbJQT1w4L9j34ok3KNiwBZCNtP9HZV4HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207370;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+8/V0kon/10TFFxOvqWNWP3LcaAkvDLKNqHNwCY9mgo=;
	b=tyh2hfU+3jWfStQJUvtvB8Sg2hSFqCYRmReJNLzCi39rF4BrjPZhz2UMe0atDKmS2ojK
	 rScYDuyjLCpVwb6GHyKTx4sA0W3b0DZBg+KGW8vHZwWCzDGMUODKZEAMGbCawXiaKtLZe
	 ZsUYUetnsqY5/valSpzLSEVug/Ieb/VxOdRnfGUYw3DkfDT6pQuEZPFH76q90U7v6KGoX
	 yEUGAYx3Ihk062nup7j+2QA3+3K7qgD982vdzF73nTDKWdn2KAGNw29F5Ea49FFehPVtC
	 VJkz5xVon4hc08e+HtZiAMQfcBWHHvVHxYz9y7YYOHhtIn4G3cL1TJHqvr5aXZXDn4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=re2fttis;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B132160A3813;
	Fri, 20 Nov 2026 20:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B132160A3813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=re2fttis
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207356;
	bh=+8/V0kon/10TFFxOvqWNWP3LcaAkvDLKNqHNwCY9mgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re2fttis0AlxeQq+QKB/0KrhFdK4j61pfFByoDzhAP70FxWuyd0uDwaTEULVmHx9x
	 0OWeOAdbkfu79Jqab0G/P2DiAWAyHHc5XY4KS3TXjJQ48DpbG+voN0VXR33rXtDMUo
	 RjufwDPgJv3548rlaC4VXeDuqVfjJpzgwJhoR5UHgIV5vb5MfzTQEbWfBwPwXt2t67
	 /kPBoeot50Nh43SCofZL4ot27cEf50iWIS/zEtHczviLP5E12rA/KvkAGfFISDCHbQ
	 VeLWbRhM3CA6WeAtAX3IYcpL1qeWjElg7/sagBDZRPHuudOBVPQRZzM06unqbLDj7L
	 DUQllSyLF/khg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2N3d8wzVBH;
	Fri, 20 Nov 2026 15:42:36 -0500 (EST)
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
Subject: [PATCH v10 25/40] sched/deadline: Reset the donor's runtime at a deboost in the class
Date: Fri, 20 Nov 2026 15:42:02 -0500
Message-Id: <a16410b68dd594967dd00f2b2bd03f1ac458c1a7.1795207232.git.mathieu.desnoyers@efficios.com>
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

A task boosted by a deadline waiter, its donor, runs on the donor's
reservation. Commit 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE
inheritance logic") uses the waiter's parameters "during the whole
period it holds the pi-lock".

A boosted task that runs out of runtime is not throttled.
replenish_dl_entity() refills it from the waiter's parameters: it adds
the waiter's runtime, and moves the deadline by the waiter's period.
From then on, the runtime and the deadline of the task are not those of
its own reservation.

A task that leaves the class at its deboost does not keep them.
"sched/deadline: Reset the deadline and the runtime with the
parameters", of the first series, resets them for a task with no
parameters. For a task with parameters, they are cleared with the
parameters at its 0-lag time.

But the boosted task can be a SCHED_DEADLINE task itself, when the
waiter has an earlier deadline. It stays in the class at its deboost.
rt_mutex_setprio() only resets dl.pi_se. enqueue_dl_entity() keeps a
deadline that is ahead. So a task that was refilled keeps the waiter's
runtime and deadline after the unlock. A task that sched_setattr() makes
SCHED_DEADLINE while boosted ends its boost the same way.

In one period, the task can run what the waiter left on top of its own
runtime. Other deadline tasks can miss deadlines.

Fix this by recording that refill in a new flag, dl_donor_refill. If
the boost ends in the class with the flag set, start a new period at
the deboost. The next enqueue is too late for a task blocked on another
rt_mutex: the chain walk copies its deadline into its waiter first.

A task asleep since the refill has its inactive timer armed from the
waiter's runtime and deadline. Its 0-lag time can then be up to the
waiter's period ahead, and the task keeps counting in running_bw until
then. If it leaves the class meanwhile, its bandwidth stays in total_bw
until then too. So the deboost cancels that timer, and works out the
0-lag time of the new period, which is now.

The task can still hold a lock that another deadline task waits on. The
new deadline can be later than that waiter's. rt_mutex_setprio() then
boosts the task again.

A task that was not refilled keeps its runtime and its deadline. They
are those of its own reservation. A new period there would give it a
full runtime at every contended unlock.

The Sashiko AI review of this series found the sched_setattr() case
and the inactive timer. These cases of deadline_bw_test test this fix:
- deboost_blocked_keeps_order and deboost_keeps_own_runtime;
- deboost_in_class_resets_period, deboost_after_donor_refill and
  deboost_in_asleep_after_refill, added later in this series.

A flag is needed: a test of the runtime against dl_runtime misses a
refill that leaves less than dl_runtime. In deboost_after_donor_refill
the owner runs past its own runtime with the lock, and the refill
leaves it less than dl_runtime. With such a test, the owner had less
than 1ms of its 5ms after the unlock, in every run. With the flag, it
gets its own 5ms.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  6 +++++
 kernel/sched/core.c     | 16 +++++++++---
 kernel/sched/deadline.c | 57 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  9 +++++++
 kernel/sched/syscalls.c |  2 +-
 5 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0c89263b1db9..cbd387993607 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -683,6 +683,11 @@ struct sched_dl_entity {
 	 * @dl_overrun tells if the task asked to be informed about runtime
 	 * overruns.
 	 *
+	 * @dl_donor_refill tells if a boosted task had its runtime refilled
+	 * from the parameters of its donor. Its runtime and deadline are
+	 * then not those of its own reservation. The end of the boost
+	 * clears it.
+	 *
 	 * @dl_server tells if this is a server entity.
 	 *
 	 * @dl_server_active tells if the dlserver is active(started).
@@ -715,6 +720,7 @@ struct sched_dl_entity {
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
+	unsigned int			dl_donor_refill   : 1;
 	unsigned int			dl_server         : 1;
 	unsigned int			dl_server_active  : 1;
 	unsigned int			dl_defer	  : 1;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9831b4aa5235..94099ebb6246 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7972,16 +7972,26 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				dl_set_donor(&p->dl, pi_task);
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				dl_clear_donor(&p->dl);
+				dl_deboost(&p->dl);
+				/*
+				 * dl_deboost() can start a new period. Its
+				 * deadline can then be after the top waiter's.
+				 * Boost the task again then.
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
index a566e9252a41..2912d13b60d6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -93,12 +93,62 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return pi_of(dl_se) != dl_se;
 }
+
+/*
+ * Record that @dl_se had its runtime refilled from the parameters of its
+ * donor, if it is boosted.
+ */
+static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+{
+	if (is_dl_boosted(dl_se))
+		dl_se->dl_donor_refill = 1;
+}
+
+static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
+
+/*
+ * End the boost of @dl_se, whose task stays in the class. If the boost
+ * refilled its runtime from the donor's parameters, start a new period
+ * now. The next enqueue is too late for a task blocked on another
+ * rt_mutex: the chain walk copies its deadline into its waiter node
+ * first. Without a refill, the task keeps the runtime and the deadline
+ * of its own reservation.
+ *
+ * The caller holds the rq lock and the pi_lock of the task, and has
+ * updated the rq clock.
+ */
+void dl_deboost(struct sched_dl_entity *dl_se)
+{
+	struct rq *rq = rq_of_dl_se(dl_se);
+
+	if (dl_se->dl_donor_refill) {
+		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
+		dl_se->runtime = dl_se->dl_runtime;
+		/*
+		 * A task asleep since the refill has its inactive timer armed
+		 * from the donor's runtime and deadline. The 0-lag time of the
+		 * new period is now: stop counting the task in running_bw
+		 * now. If the timer handler is already running, it does that.
+		 */
+		if (dl_se->dl_non_contending &&
+		    hrtimer_try_to_cancel(&dl_se->inactive_timer) == 1) {
+			dl_se->dl_non_contending = 0;
+			put_task_struct(dl_task_of(dl_se));
+			task_non_contending(dl_se, true);
+		}
+	}
+	dl_drop_boost(dl_se);
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
@@ -1106,6 +1156,7 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 	/* for non-boosted task, pi_of(dl_se) == dl_se */
 	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
 	dl_se->runtime = pi_of(dl_se)->dl_runtime;
+	dl_note_donor_refill(dl_se);
 
 	/*
 	 * If it is a deferred reservation, and the server
@@ -1204,6 +1255,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 		if (!dl_se->dl_deadline) {
 			dl_se->deadline = rq_clock(rq);
 			dl_se->runtime = 0;
+			dl_note_donor_refill(dl_se);
 		}
 		if (dl_se->runtime < 0 || dl_se->dl_yielded)
 			dl_se->runtime = 0;
@@ -1226,11 +1278,15 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
 		dl_se->deadline = rq_clock(rq) + deadline;
 		dl_se->runtime = runtime;
+		dl_note_donor_refill(dl_se);
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
 		dl_se->runtime = 0;
 
+	if (dl_se->runtime <= 0)
+		dl_note_donor_refill(dl_se);
+
 	/*
 	 * We keep moving the deadline away until we get some
 	 * available runtime for the entity. This ensures correct
@@ -5075,6 +5131,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+	dl_se->dl_donor_refill		= 0;
 	dl_se->dl_server		= 0;
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 859d782cc899..516a49370713 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -411,6 +411,15 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 {
 	dl_replace_donor(dl_se, dl_se);
 }
+
+extern void dl_deboost(struct sched_dl_entity *dl_se);
+
+/* End the boost of @dl_se. The caller holds the rq lock of its task. */
+static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
+{
+	dl_clear_donor(dl_se);
+	dl_se->dl_donor_refill = 0;
+}
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 0343c7831101..9884fa55538a 100644
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

