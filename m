Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207368;
	b=Ig1si8XWfzuGv3CvvRwM4N8+/0PZZDZn6qeM2cfEZvs3+eEul+crPuBNs5hdlLOi9WnV
	 U2gZxmF/RveJl0jch8l0+oAOq6zUr6j0m2A2WPFc5HZm3yzQ29DsAIoMOUTHq6o6gbTCe
	 1Bh/3YoGhEyIvBI4AK9jGJh5CdureHcgvqpuT6vMxBKwSjidrKEoi4z1U3T+AF6hr3Ypc
	 3okLb6uUsp8dfB249PX9CBWpt6mW2LaDycpl7/EJ5yOr35hwEOv1mnE0oRqmsCkpzshLd
	 xBdTK9ij8bkoWMhmLPeasVA9vAbHpFmSj5S6+9ue9r3wR8XALSWJeRz6OTNnLs8gDUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207368;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7S8F9+iWYPqVTwdZ/ASV/o+SPoxwihXXCO7lT4Bc3P4=;
	b=rHjDGw840AfQ6JfLVzmhOabpwUMgjIiEd7RvVbdHzYWByah8fnJ+G/dSpbnxaf/8wwUA
	 09SylYPmwHdpJOjtC4bH2/uyW55x3xUBJwKfXxNh02MO3SC8ZeI+AsPjFl96rBAKCqvzL
	 OJ6DesvW8RasnIA8+00scYu4a7ctJVbTcS4H27cg7JKM8rNL6O4xK6AwmjNc818pnAyxm
	 171EH7aMCghQ9DJE/CxZ8cw0huW6ZYkDu/z4Hs+qtmFhZPCg6KmvouPS+PlpIWmrk2kVM
	 0rinJoIEZz5u0GBmw3hndIjh1n3KZlkJL1MnV8OtF/j26aiuws5zcO5FW9gn3iv7+Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=OprcRkZU;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8954F60A382F;
	Fri, 20 Nov 2026 20:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8954F60A382F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=OprcRkZU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207357;
	bh=7S8F9+iWYPqVTwdZ/ASV/o+SPoxwihXXCO7lT4Bc3P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OprcRkZUH6Tw3du8WlA7jpQ2FQP5evvntU1ml/4vrOYVyK9wNdS3Qa/Jt53O8JGOh
	 EsGJNvM2aqFuYZBCLal/+h57cjaxYciaTr902kna4QL8baVvp/elRtJZj/XyFXEe1o
	 A/uI5UvUyglYnVPwYh2wza5QQKvmb2MZ/+3ui1eQ1yPVYCc0IsjWd1s64Seq7V4CvC
	 X3O9VWkATx5QaOV5tu+bJCfqhtdRo8NQGxQNlKyvXk6GVsMJPJ+6pMOnlhI3tkQHJE
	 rQzpOZ/uU8vTA7f786pqICf8qvMpLPsMAhqEBVUNB+qeHy+km9Vzz16MObJnvRHksb
	 WlKHuhZHzW6ng==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2P1trJzTqg;
	Fri, 20 Nov 2026 15:42:37 -0500 (EST)
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
Subject: [PATCH v10 29/40] sched/deadline: Start a period at a deboost out of the class
Date: Fri, 20 Nov 2026 15:42:06 -0500
Message-Id: <5e6b0ddced3a3ff2f0d7c3e99e47fcefb76d3245.1795207232.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its runtime and deadline until
its 0-lag time. Commit a649f237db18 ("sched,dl: Fix sched class hopping
CBS hole") does this, so that leaving the class and coming back gains
nothing. A priority inheritance boost also keeps the runtime and
deadline of a task with parameters of its own.

But a boosted task is not throttled. When it runs out of runtime,
replenish_dl_entity() refills it from the donor's parameters. If the
task stays in the class at its deboost, "sched/deadline: Reset the
donor's runtime at a deboost in the class" starts a new period.

A task that leaves the class at its deboost is missed. switched_from_dl()
calls task_non_contending(), which computes the 0-lag time from the
runtime and deadline of the donor's refills, with the task's own
dl_runtime and dl_period. The root domain then keeps the task's
bandwidth in total_bw for too long, or releases it too early. Until it
is released, deadline tasks that would fit are refused.

Fix this by starting a period of its own in switched_from_dl(), as
dl_deboost() does. Share that code in dl_start_own_period(). The 0-lag
time of the new period is now, or has passed, so the bandwidth is
released at once. task_non_contending() now also releases it when the
0-lag time is exactly now, instead of arming a timer of 0ns.

A task can also block while boosted, after a refill. Its dequeue then
arms the inactive timer from the same mix. If the boost ends while the
task sleeps, switched_from_dl() finds that timer armed, and keeps it.
Fix this too: cancel the timer there, and compute the 0-lag time of the
new period instead.

The Sashiko AI review found this, on "sched/deadline: Reset the
deadline and the runtime with the parameters" of the first series. The
deboost_out_after_donor_refill case, added to deadline_bw_test later in
this series, tests it. Without this patch, the owner's bandwidth was
still in total_bw right after the unlock, in every run. The
deboost_out_asleep_after_refill case tests an owner asleep when the
boost ends. Without the cancel of the timer, its bandwidth was still in
total_bw after the boost ended, in every run.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 49 +++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ee3a08ff3345..b1346be9e81d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -83,6 +83,16 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
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
 #ifdef CONFIG_RT_MUTEXES
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -119,11 +129,8 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
  */
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = rq_of_dl_se(dl_se);
-
 	if (dl_se->dl_donor_refill) {
-		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
+		dl_start_own_period(dl_se);
 		/*
 		 * A task asleep since the refill has its inactive timer armed
 		 * from the donor's runtime and deadline. The 0-lag time of the
@@ -826,10 +833,12 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	zerolag_time = dl_time_to_zerolag(dl_se, rq);
 
 	/*
-	 * If the "0-lag time" already passed, decrease the active
-	 * utilization now, instead of starting a timer
+	 * If the "0-lag time" is now or already passed, decrease the active
+	 * utilization now, instead of starting a timer. A task that leaves
+	 * the class with a period of its own just started has a 0-lag time
+	 * of now.
 	 */
-	if ((zerolag_time < 0) || hrtimer_active(&dl_se->inactive_timer)) {
+	if ((zerolag_time <= 0) || hrtimer_active(&dl_se->inactive_timer)) {
 		if (dl_server(dl_se)) {
 			sub_running_bw(dl_se, dl_rq);
 		} else {
@@ -4662,6 +4671,19 @@ void dl_clear_root_domains(void)
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
+	bool own_period = p->dl.dl_runtime && p->dl.dl_donor_refill;
+
+	/*
+	 * The boost of a task with parameters of its own ends, and the task
+	 * leaves the class. If the boost refilled its runtime from the
+	 * donor's parameters, its runtime and deadline are not those of its
+	 * reservation. task_non_contending() would mix them with its own
+	 * dl_runtime and dl_period. Start a period of its own instead, as
+	 * dl_deboost() does. Its 0-lag time is then now, or has passed.
+	 */
+	if (own_period)
+		dl_start_own_period(&p->dl);
+
 	/*
 	 * task_non_contending() can start the "inactive timer" (if the 0-lag
 	 * time is in the future). If the task switches back to dl before
@@ -4693,6 +4715,19 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		if (p->dl.dl_non_contending)
 			sub_running_bw(&p->dl, &rq->dl);
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * The task blocked while boosted, after a refill from the
+		 * donor. The timer armed then mixes the donor's runtime and
+		 * deadline with the task's own parameters. Cancel it, and
+		 * work out the 0-lag time of the period just started below.
+		 * If the timer handler is already running, it releases the
+		 * bandwidth.
+		 */
+		if (own_period && p->dl.dl_non_contending &&
+		    hrtimer_try_to_cancel(&p->dl.inactive_timer) == 1) {
+			p->dl.dl_non_contending = 0;
+			put_task_struct(p);
+		}
 		/*
 		 * Without an armed timer, nothing releases total_bw. Do as for
 		 * a queued task: arm the timer if the 0-lag time is ahead, or
-- 
2.47.3

