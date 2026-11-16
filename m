Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855973;
	b=u7No3UJl4Oq3j9N85cRZ8bqex6Irn/4DgGTcRHLjaC/WMRVUJEUbFOtmzj77TzxPIO6B
	 X2DsHu6hcrQxYKgtD8Pj18Xqu5dw2rBBFMgF496ViCOXRsCQue8cm0C1jMFfCSIU7B/zG
	 r21Q+FJT5EJkjK7GDnXpN6dHSrBFv6Ez8lzI4YTn6XazJkYjac9L+rFTbl8ZYWC6CYAYk
	 gA+xXDBLtLDwjV/bYoHFUuev7RnPKP+x59G2N7Z6lE8M1hKQQ+XQ8rYn5i1kBFmnQbGbx
	 DkoedQ9P1YmEcDleDqRTeZHyK5YcmMGnETPJEclR4ZkzemqVgcJ9QlQSZfQ7KT9fHug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855973;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ARreNfLSGdkmUn1/Vdh/VVG3o7GBC6q78tEMx8/VVx4=;
	b=WYunN3sirj0p9l9VK7zQFLcJiW16cOGVHeWXHvmcjdy6Leglrcv+/xtL9vfglWQldGWr
	 h9EgbuXyjgjvbCJZbkutvLIqQdQOE/Qmq1vilSRCD/QK5wH4TinibUASn3RI60/XfnVeb
	 /KMoc4n+ren+mPSHfYaetsfzengwfU9ieZYFhPPvuXc0LWp4NvdHc/lmYo2u91eHQCqO3
	 ftnETr3qq0Cd+4sEJlh+vZzKQcfUMaRZEIDe90zxsBKhajCc7HZ8qgVyu3lfOMO4q65dT
	 Gzq9OYHmzOIn9epPv9PVYhjko6ulcwJ9NPJjVoRS1jIIFSoZu5Uw9ItaFjgGLPJLzzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Un372Sv0;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420860A260D;
	Mon, 16 Nov 2026 19:06:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F420860A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Un372Sv0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855955;
	bh=ARreNfLSGdkmUn1/Vdh/VVG3o7GBC6q78tEMx8/VVx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un372Sv0goyNRzCA4K7PqIJJqok0TqWKRa6bHOH4nMM4nXNBsbUutp1GsekIQ4QN4
	 8kJmbw54etiChAH5tKRXuESORKJeZ+xzWmhgpIv9n301UJGdg7h9wPRxQjlbUqLx1s
	 rcDvzdr4DUPpbrvwnMHit5vyXT8BylqcvZ1LiwRPrhMHFd5mqRhLgzgTKVKZt/hPyx
	 KxGQ1nHEmpRJt4z1dgpplhv0W+qn6NkeCVgRzDbU96aeIdUi+jAP16CpPlPZyLvZr7
	 EuYk2HjgVwKvFwZVf0QLZlQEBK1iF5ectc6XfafDG06WuSGojTgTIlRAORFvsFY/ii
	 xnAONtnKlN4pg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4g3NgfzQD4;
	Mon, 16 Nov 2026 14:05:55 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v6 10/37] sched/deadline: Reset the donor's runtime at a deboost in the class
Date: Mon, 16 Nov 2026 14:05:22 -0500
Message-Id: <20261116190549.230119-11-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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
"sched/deadline: Reset the deadline and the runtime with the parameters"
resets them for a task with no parameters. For a task with parameters,
they are cleared with the parameters at its 0-lag time.

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

The task can still hold a lock that another deadline task waits on. The
new deadline can be later than that waiter's. rt_mutex_setprio() then
boosts the task again.

A task that was not refilled keeps its runtime and its deadline. They
are those of its own reservation. A new period there would give it a
full runtime at every contended unlock.

The Sashiko AI review of the fourth posting found the sched_setattr()
case. Four cases of deadline_bw_test, added later in this series, test
this fix: deboost_in_class_resets_period, deboost_blocked_keeps_order,
deboost_after_donor_refill and deboost_keeps_own_runtime.

In deboost_after_donor_refill, an owner of 5ms every 100ms runs 8ms with
the lock. Its donor is a task of 2ms every 10ms. A deboost that tests
the runtime against dl_runtime, in place of the flag, misses this
refill: it leaves less than dl_runtime. The owner then held less than
1ms after the unlock, in 3 guests of 3. With the flag, it holds its own
5ms.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  6 ++++++
 kernel/sched/core.c     | 16 +++++++++++++---
 kernel/sched/deadline.c | 37 +++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h    | 10 ++++++++++
 kernel/sched/syscalls.c |  2 +-
 5 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..96b498f79484 100644
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
@@ -711,6 +716,7 @@ struct sched_dl_entity {
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
+	unsigned int			dl_donor_refill   : 1;
 	unsigned int			dl_server         : 1;
 	unsigned int			dl_server_active  : 1;
 	unsigned int			dl_defer	  : 1;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ed660f099a5..a22df8b43a1a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7834,16 +7834,26 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				p->dl.pi_se = pi_task->dl.pi_se;
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				p->dl.pi_se = &p->dl;
+				dl_deboost(&p->dl);
+				/*
+				 * dl_deboost() can start a new period. Its
+				 * deadline can then be after the top waiter's.
+				 * Boost the task again then.
+				 */
+				if (pi_task && dl_prio(pi_task->prio) &&
+				    dl_entity_preempt(&pi_task->dl, &p->dl)) {
+					p->dl.pi_se = pi_task->dl.pi_se;
+					scope->flags |= ENQUEUE_REPLENISH;
+				}
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				dl_drop_boost(&p->dl);
 			if (oldprio < prio)
 				scope->flags |= ENQUEUE_HEAD;
 		} else {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				dl_drop_boost(&p->dl);
 			if (rt_prio(oldprio))
 				p->rt.timeout = 0;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dd48f74412b8..1f3da0e0a698 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -93,6 +93,38 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
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
+	}
+	dl_drop_boost(dl_se);
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -734,6 +766,7 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 	/* for non-boosted task, pi_of(dl_se) == dl_se */
 	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
 	dl_se->runtime = pi_of(dl_se)->dl_runtime;
+	dl_note_donor_refill(dl_se);
 
 	/*
 	 * If it is a deferred reservation, and the server
@@ -842,11 +875,15 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
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
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 92134ce326a4..d87296abec4c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -356,6 +356,16 @@ extern int  sched_dl_global_validate(void);
 extern void sched_dl_do_global(void);
 extern int  sched_dl_overflow(struct task_struct *p, int policy, const struct sched_attr *attr);
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
+#ifdef CONFIG_RT_MUTEXES
+extern void dl_deboost(struct sched_dl_entity *dl_se);
+
+/* End the boost of @dl_se. The caller holds the rq lock of its task. */
+static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
+{
+	dl_se->pi_se = dl_se;
+	dl_se->dl_donor_refill = 0;
+}
+#endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 9b04e77297ae..f346176f1ba1 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -310,7 +310,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * the class. Drop its boost then, as rt_mutex_setprio() does.
 	 */
 	if (!dl_prio(newprio))
-		p->dl.pi_se = &p->dl;
+		dl_drop_boost(&p->dl);
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
-- 
2.47.3

