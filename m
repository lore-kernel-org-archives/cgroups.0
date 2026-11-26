Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655351;
	b=vRhkYJUjarFBNVnhMTEaTk6Fdx8ndR+9Y/Q7hFvCW+monM+mKCc6BfQDGiAZ3R6Y0ZPp
	 BnjdFHrRvIV6UfvVHiGOWwjY8/NJY7gg55cxlmIx6jxJtSTDADeQ4PGWwyrKPNpfQEeH1
	 3QRzLa90FLjtV2htGQJwezrCfKDEmvwEKmzWTIqqGsW1BivpVwnbjQ73tboaiIfIATJ8f
	 d04fNWR2m5+7S3ew0UcXYc2VY2o4KI0ZNMCuaHs0JdkjKUJfHMTcatyt8N/BQnEThUHwH
	 mQ+p0Ze9OQvhJjGtXDTdud8PsEeGPWupAzYJkld/ti8YyOD03FrnolsdDvGr8yK65pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655351;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iKoBngYyWL5JYUkl19sgosUbRFPRZPljOz5UHgkeaI4=;
	b=f8lCspLUpg6KCpVgLGNEehjac8voETI/B2jlWIYx8Z5NeCF9QiwRKixRR7kNXxv9hXzn
	 Dl5lBcJ4sxWShXNX7DKXMIK/wEaBkf0QdHI5iYlOGn9VHTJFm7z9d6LeAr8xW9M4rxVNw
	 evZOxV5+Hedwq/cIHq8WfoMft890u22Rc6HOZLeDBNBlQJ95WZQJiXIRwq51J9in8G7aB
	 R+nUCXkKyRamwZpNJQz9FYAgM4rEcbDMXECgwHY6nKet9z+04I5SoWcjJnqy6LEGptCtp
	 1wBc/BMNqhFyyuKoaoc4tanTyQa6/+4zR4nIt+1L/UG52ylpR1afJxuTK/XtIwI6IAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=odXEDkvr;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34639606B74A;
	Thu, 26 Nov 2026 01:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34639606B74A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=odXEDkvr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655350;
	bh=iKoBngYyWL5JYUkl19sgosUbRFPRZPljOz5UHgkeaI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odXEDkvr7MGr+gOREvkLPKbNMYz+pvb3WuA8M6D6E8LENqef1BsoyevMt4MfOivRA
	 D3tn+eYgsMp3KdrcCsiZczJinJcGjJU+ngVrOxzqR1ps5fhygrYNG5tcOcFH36LqRS
	 6FV4sURUrDXT46jkTfcpnaqSw9+CWGv4WuVRovNQb3oyshsuqmsqc9roEpDxDLb0VE
	 TP2C4izzAdwzXYRsh2FTsERlb/6DpHOgts+4JGqJLwBTabSOx+67R6ixeAEyFOO0mH
	 3BZybLZqNY57w7UhoZIdaxlmmGwMAX6npJo/cO/2nZluBKZiihzZ0szVthpSRPz+FC
	 3r4RtPyXn4Gkw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjd6KdKzWWB;
	Wed, 25 Nov 2026 20:09:09 -0500 (EST)
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
Subject: [PATCH v11 30/43] sched/deadline: Start a period for a task that enters the class blocked
Date: Wed, 25 Nov 2026 20:08:29 -0500
Message-ID: <f878da91a2dcaec14aaf959a83659c166a98ad05.1795646914.git.mathieu.desnoyers@efficios.com>
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
index 40bfa1364b90..5b2ac1b3f6f6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7969,8 +7969,12 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
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
index 5ec1c5eaf764..4d46d1c9c698 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -228,6 +228,12 @@ void dl_deboost(struct sched_dl_entity *dl_se)
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
@@ -242,6 +248,11 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
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
@@ -1301,6 +1312,30 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
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
@@ -4866,6 +4901,26 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
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

