Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182968;
	b=HMn51hZzF7Co6AZ9jdPnQDhaXYRJndod0ItVHWQ+HnRvFiFxiHLJL9wX6h3vaS3zbM8T
	 I1p8kZnwVKfn15qM3WeqWA7XtV92aYuZcSqI/92+m77/Za6624dAB1bZk2XU0XNcmM/bC
	 y0Wk8KgDZL1ZP9anaIphY7QHO3ukzA4afKR+y+MjNjbF7w0Y50gC6koGAiyLCNEJUmu5q
	 joyBP641V0OFLrwl+/o6WOYuqaF5I7EWORYWf8Vk/hSVhOkXeiZslwpHFrpjonNdxlu70
	 yVz1uOpbjQje7CyQ1IPrtNbwlo11oZ/pkbSD1ZNBEef8bUh6fWs1UE5g9sXMoXoOOEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Lmu9vHnFjlSW6sGVNTvryoC+yZQCOLRxYEqj1cYjqWc=;
	b=w1rabyYszfQSpv/MeU6HF6A6v5/yw05JfpuiXmpMgd6f6XkA2FDEYk+oyyXOpnkI6xS5
	 urZJa7Dc41dOsh20vrXBRVGgnBLnoHLzxEtXXGVpALdxknLhhUI1TqjzAGQK0d+E7EZon
	 H30Sd0E3puCOU7LTBinsRG8SPuiiWusnA5P+smHw7X8DMGAeCPuX8Zgp5ETHj6gH6/k9J
	 xekOAOp3BvRXFTqzemXWVFKFwbsdr7rPYh1NLOB7iAdilSdGWkm1gqsX7iGtQyipaSr5a
	 tiym/1LU5SFFHqhiCL4tkoeEvDuqTuD70wp2w9pcXHfJYVdGTZeQ/S4HFqiYb+S+pXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="xG66o/JK";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB833606CEE8;
	Fri, 20 Nov 2026 13:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB833606CEE8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xG66o/JK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182964;
	bh=Lmu9vHnFjlSW6sGVNTvryoC+yZQCOLRxYEqj1cYjqWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG66o/JK37Uc6puW+keZ/zxWhqdKstAAyr7B8va2JtbmdyZBV3mvL5Yyb/W4LSXv9
	 k/a0rGXGt2R4pu45cC7kfkIv6mEOEAYj5yqjl7s62Nh78xENXnTFdX3eB53hDts19X
	 TYSnrInMoY88Zo29HRMX479dx6/TLVYgWx14xR3hQsBXx5+DArjTfQ0iqNl5TmWPI2
	 LY5N2pvPWwKgA6ODIDWYpz9KMtfevCXay7h/oVVr48t1vgMTOl/8MidVnC7rNl7h/d
	 G+HZJOdOzMEaeM0417ZgCRu0K8J0lg6eBCQ5Cvmyr7x7CBkCVeMXUGizqBlHrLgzoI
	 Xpm4kOEnhG6VA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1J0R6qzSnl;
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
Subject: [PATCH v9 27/33] sched/deadline: Start a period at a deboost out of the class
Date: Fri, 20 Nov 2026 08:55:50 -0500
Message-Id: <b0c0b935fc2c40dbd924975c77e3a0132def0abf.1795181240.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its parameters, runtime and
deadline until its 0-lag time. Commit a649f237db18 ("sched,dl: Fix sched
class hopping CBS hole") keeps them. So leaving and coming back gains
nothing. A priority inheritance boost before then keeps them too.
replenish_dl_entity() takes the donor's runtime and deadline only for a
task with no parameters of its own.

A boosted task is not throttled. When it runs out of runtime, it is
refilled from the donor's parameters. If the task stays in the class at
its deboost, "sched/deadline: Reset the donor's runtime at a deboost in
the class" starts a new period.

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
task sleeps, switched_from_dl() finds that timer armed, and kept it.
Cancel it there, and compute the 0-lag time of the new period instead.

The Sashiko AI review found this, on "sched/deadline: Reset the
deadline and the runtime with the parameters" of the first series. The
deboost_out_after_donor_refill case, added to deadline_bw_test later in
this series, tests it. An owner of 5ms every 100ms leaves the class
while it holds the lock, and is refilled by a donor of 2ms every 10ms.
Without this patch, its bandwidth was still in total_bw right after the
unlock, in 40 runs of 40. With it, the bandwidth was gone in 60 runs of
60. The deboost_out_asleep_after_refill case tests a task that sleeps
when the boost ends. Its owner has 5ms every 100ms, and its donor 1ms
every 1s, with a timeout. Without the cancel of the timer, the
bandwidth of the owner was still in total_bw after the timeout, in 6
runs of 6.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 51 +++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c57bbc7a9536..4c46a7aa2709 100644
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
@@ -117,12 +127,8 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
  */
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = rq_of_dl_se(dl_se);
-
-	if (dl_se->dl_donor_refill) {
-		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
-	}
+	if (dl_se->dl_donor_refill)
+		dl_start_own_period(dl_se);
 	dl_drop_boost(dl_se);
 }
 
@@ -812,10 +818,12 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
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
@@ -4629,6 +4637,19 @@ void dl_clear_root_domains(void)
 
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
@@ -4660,6 +4681,18 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		if (p->dl.dl_non_contending)
 			sub_running_bw(&p->dl, &rq->dl);
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * The task blocked while boosted, after a refill from the
+		 * donor. The timer armed then mixes the donor's runtime and
+		 * deadline with the task's own parameters. Cancel it, and
+		 * work out the 0-lag time of the period just started below.
+		 * If the handler runs already, it releases the bandwidth.
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

