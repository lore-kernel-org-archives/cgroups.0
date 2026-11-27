Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790182;
	b=RQXAz6uhe8cF0z1c8M1OjeoEyRugos8cnhOUyjfFsX7x3Yvp7yUF1vtjK/LAcfr4LDmu
	 Ut3PlNDF+fXBybk/3xuFryT1ZvVgBsGjqyqebrOwZQoxSqxgjPJk3MB/S6Z89w15xO28S
	 eBZYvrYhw6LwYF+M0XZGUgvPvh6dwZhW8lYmeFUJkwUYyHz99wITMuQFGTLZbhZvabvR3
	 4cUrpsxb6Ei2HX1aqN6wyvid0N0gprUYq8Pwc44S5Aw4foIzBMTHjQNC7f9j+cfj8EEkN
	 LiBc0+nHq9EEg+habYO6336mU/pQLjd0imjxYro8dZSYN4i+HXiEgT2QpXdL0Svlw1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790182;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rQ7eB3an2suHQbMCqx7u6Dyl0M+RgSdlULpDUTNiItc=;
	b=Vr8GdrB0b9bhT+Xc1653sdcLl6hdR5pLFs8VOtFbVkGUGI7geDka8TNR/mfqQCQykQpg
	 uo5kE90fG+P1i8QD851pkRMC5WVGCL+rJetWJpXywSJ0Bl8LtOIAxzoHqgKMNNih+thb5
	 Xl8XuVBCK31LUHyFT66gyMq8lw9UZvumlGiUc4jE+wnIubmLUj7gGGCX1V9O12ruUEU1x
	 Dd8Yl7zUQrLqKZgzRiooIzuibkSOn6+k4l6DEAxT3qrLoUs+6lVDf/d5RxFvsBBNyxXSN
	 ISfRw7J/dDAELzApAOA1BcwIi+JUE1FC8l5VwQTYHOsYw+dqh4+0lBlpbc6CofBUwhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LhvlvvmW;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B284606BAA6;
	Fri, 27 Nov 2026 14:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B284606BAA6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LhvlvvmW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790178;
	bh=rQ7eB3an2suHQbMCqx7u6Dyl0M+RgSdlULpDUTNiItc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhvlvvmWfQHQdpNn62iB2y/ra3l+NhDevw5nwqPLUlEMzeNB4Sl3IRGv3kCM2HzUp
	 RraVlwR6CKC3prcU6rUiX/d6WqRo+qKKhH2zxGMyz7qBexcRkpHUW02AIzX7QFQikW
	 wxrR+FlSKvPrnGSRIfFN+qb3gi8qm7P6sxMMhgvCtsE2oh1wjjQDMYRlAvzJuGyFQI
	 YgA3MssbnltSaj21YBkEthGZQDSZ3kwO8rCUUo9zvKT6lFcTYG57GjnXT44NLJofK1
	 VUY7+eME6j5U0aC1AkATt8vB1Q17jdzc2GnC0Yu3ncGE42cKMYK1oIymzvKbMRybOL
	 pL6Qb0Og/G9jA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZV5FP2zXZV;
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
Subject: [PATCH v12 30/43] sched/deadline: Start a period for a task that enters the class blocked
Date: Fri, 27 Nov 2026 09:35:57 -0500
Message-ID: <36173003b241b9b994997ab4edce8a5cff1895ad.1795771148.git.mathieu.desnoyers@efficios.com>
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

Commit fb00aca47440 ("rtmutex: Turn the plist into an rb-tree") sorts
the waiters of an rt_mutex by priority. For deadline tasks, "the one
with the earliest deadline wins". A waiter takes the deadline of its
task. A task that blocks by itself is running, so its deadline is a
current one.

A task can also enter the class while it waits on an rt_mutex. Another
task can make it SCHED_DEADLINE with sched_setattr(). A priority
inheritance boost can also put it in the class, if it owns another
rt_mutex. switched_to_dl() does not set up a task that is not queued.
Its wakeup does. But the chain walk that follows the change reads the
deadline before that wakeup, and copies it into the waiter. A task new
to the class has a deadline of 0.

So the waiter goes before every other deadline waiter. It takes the
rt_mutex first, whatever their deadlines. Those waiters can then miss
their deadlines. It also boosts a deadline owner whose own deadline is
earlier.

Fix this by starting a new period while the task waits, as
setup_new_dl_entity() does at an enqueue. The period uses the
parameters the task runs on: its own, or its donor's when it is
boosted. At the wakeup, update_dl_entity() then checks that period as
for any wakeup. Two places start the period:
 - switched_to_dl(), for a task that waits on an rt_mutex, if its
   deadline has passed.
 - rt_mutex_setprio(), with the new dl_boost_blocked(), when a blocked
   task with no parameters of its own gets a new donor. This includes
   the boost that puts it in the class. For a queued task, the enqueue
   of the boost already does this.

switched_to_dl() leaves one case alone. A task that comes back to the
class can keep its deadline. v7.4-rc2 always keeps it. With the first
series, it keeps it only if it comes back before its 0-lag time. So a
constrained task can come back past its deadline and before its next
period. A new period would let it run before its next period. So, as
dl_check_constrained_dl() does, leave it alone unless it is boosted. Its
wakeup throttles it until its next period.

Its waiter then keeps the passed deadline, and sorts before the other
deadline waiters. At an unlock, it is woken and throttled. The lock then
stays free until its next period.

The setattr_blocked_keeps_order and boost_blocked_keeps_order cases,
added to deadline_bw_test later in this series, test this. Both fail on
v7.4-rc2 and on the series without this patch. The case
reenter_pi_blocked_in_gap tests the constrained task left alone. The
triage of the Sashiko AI review of this series found the bug.

Fixes: fb00aca47440 ("rtmutex: Turn the plist into an rb-tree")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c     |  4 +++
 kernel/sched/deadline.c | 55 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  1 +
 3 files changed, 60 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7a3a7e755d20..edd26b321fee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7980,8 +7980,12 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
 			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
+				struct sched_dl_entity *old_donor = p->dl.pi_se;
+
 				dl_set_donor(&p->dl, pi_task);
 				scope->flags |= ENQUEUE_REPLENISH;
+				if (!scope->queued && p->dl.pi_se != old_donor)
+					dl_boost_blocked(p);
 			} else {
 				dl_deboost(&p->dl);
 				/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 26cab0470cb7..9c707512d93d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -247,6 +247,12 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 		}
 	}
 }
+
+/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return p->pi_blocked_on;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -261,6 +267,11 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
 }
+
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return false;
+}
 #endif /* !CONFIG_RT_MUTEXES */
 
 static inline u8 dl_get_type(struct sched_dl_entity *dl_se, struct rq *rq)
@@ -1335,6 +1346,30 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 	trace_sched_dl_replenish_tp(dl_se, cpu_of(rq), dl_get_type(dl_se, rq));
 }
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * Start a period from the new donor of @p, if @p has no reservation of its
+ * own and waits on an rt_mutex. The enqueue does this for a queued task, in
+ * replenish_dl_entity(). A blocked task is not enqueued, but the chain walk
+ * copies its deadline into its waiter.
+ *
+ * Call it only when the donor changes. A new period changes the deadline,
+ * so the chain walk finds the waiter out of date and goes on. In a ww_mutex
+ * cycle, a new period at each step would never let the walk stop.
+ *
+ * The caller holds the rq lock and the pi_lock of @p, and has updated the
+ * rq clock.
+ */
+void dl_boost_blocked(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	if (!dl_se->dl_deadline && !dl_se->dl_throttled &&
+	    dl_task_pi_blocked(p))
+		replenish_dl_new_period(dl_se, task_rq(p));
+}
+#endif
+
 /*
  * We are being explicitly informed that a new instance is starting,
  * and this means that:
@@ -4901,6 +4936,26 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (!task_on_rq_queued(p)) {
 		add_rq_bw(&p->dl, &rq->dl);
 
+		/*
+		 * The chain walk sorts the waiter of a task by its deadline,
+		 * before the wakeup sets the task up. A task new to the class
+		 * has a deadline of 0, which goes before every real one. So
+		 * start a new period now for a task that waits on an
+		 * rt_mutex, as setup_new_dl_entity() does at an enqueue.
+		 *
+		 * A task that comes back to the class before its 0-lag time
+		 * keeps its deadline. For a constrained task, that deadline
+		 * can have passed before its next period. As
+		 * dl_check_constrained_dl() does, leave such a task alone
+		 * unless it is boosted. Its wakeup throttles it until its
+		 * next period.
+		 */
+		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
+		    dl_time_before(p->dl.deadline, rq_clock(rq)) &&
+		    (is_dl_boosted(&p->dl) ||
+		     !dl_time_before(rq_clock(rq), dl_next_period(&p->dl))))
+			replenish_dl_new_period(&p->dl, rq);
+
 		return;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b53885c624fd..32560b08808e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -413,6 +413,7 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 }
 
 extern void dl_deboost(struct sched_dl_entity *dl_se);
+extern void dl_boost_blocked(struct task_struct *p);
 
 /*
  * End the boost of @dl_se, and forget the deadline and runtime saved for
-- 
2.47.3

