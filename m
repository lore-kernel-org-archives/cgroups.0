Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655349;
	b=TnszKJ5ySnyzZ5Hr+5bCbsqYc6lYeyYtKi0FoCo1tXWZM7N9yoX33+1nQmS7xZBezGPJ
	 Pee4Px3+NNSTjKcEJzQlcW+hjKeNagUF5VbMNhFpIWAp03NYXzIZjkUJ4MMsEjOv3TLhO
	 9TsVKxBcD5a38MTHDazUMPMRJl1Ap2KXhWGfy02FqOzpGKCgadeAiQb0PWjrsdlO5052M
	 BXPJk+XLtDfYtBeyMaOrtHDBJy6IPv4U5bX/Pzj8ysF9SIs3a4WUVXbpmKhbCsq2kompG
	 qocr0teKhTgeRV5l23rfvNjxTg+LJph1//Z/2UBVZNcti9YlTTBhytvBTqDHl0nQ+Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655349;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fpaOAYMJami17I88oWyFK67D/hfxu223AaAKW6OX5hQ=;
	b=mMtAPQI6OuSwbb41nhVRx/RGSylrqy4usA/rZgUeebioXaLqI94gZHfOpbPSYPcyEieZ
	 xw626nQkOXGX/vp4Cyw8GKoTzZSAHJEkDjzSa2oo5x+08+0LDLOb86F2W/6aDx66l4OCi
	 EUtKVfJfJZAF3OE0jx427nvnNSRThqvb16O1i/VfP74Z6CLpx0VVrOyqXVVzqtn6KsH8a
	 AAjQk4qKj8RVsBPbuobMSN4BeRUdF/GwHRnYLhZGLEVIB+aNQFDsj/RcPQ1uFUWqd45GU
	 E4kk7SMy2n2e/RbcZwZ7zzJilCU8Yod5Iex8gIKwnxD/2M0IoSOo9gvxrGoWS+3lixw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=s2+y36E0;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942C606BF96;
	Thu, 26 Nov 2026 01:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D942C606BF96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=s2+y36E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655347;
	bh=fpaOAYMJami17I88oWyFK67D/hfxu223AaAKW6OX5hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2+y36E08k2a7HLH/p0Fs8HNKIbbq2LhgJTsL+zszhsLQzHtMod1loFiz8CoayNym
	 BUTsLT6cPu0d2Uc28yck3p98+2Z1q2ZnHX85AiYwoBWM9MW+k5UaIfzlueOKIg2gX/
	 lqiPmTvw7oEjub1zeZNXVkYjHfE9nOxieseFnLHI0mgy2m7BhtNy8yChQ6NHlfcAP4
	 jpy2J8hKfNxVCdJXJHAbDMRKzJ2qhST7j9I9m1u7+NeKBO6dTn0PnqRtvYgfhwRcAH
	 XgwQiH/mRlNlpwC3y49FI/semfdEhI7h5T2zPwcKtuzl5VdQmt68PvYhnecQtoFHFt
	 IMyZCYHxioN+w==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjZ3PRxzX0B;
	Wed, 25 Nov 2026 20:09:06 -0500 (EST)
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
Subject: [PATCH v11 25/43] sched/deadline: Count the 0-lag time from the next period
Date: Wed, 25 Nov 2026 20:08:24 -0500
Message-ID: <1d535c0c45a21d94ebadfce2883ce8d8b6789c44.1795646914.git.mathieu.desnoyers@efficios.com>
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

A deadline task that blocks keeps counting in running_bw until its
0-lag time. Commit 209a0cbda7a0 ("sched/deadline: Improve the tracking
of active utilization") added this for GRUB. A task that leaves the
class or exits also keeps its bandwidth in total_bw until then.
Commit 387e31300b57 ("sched/deadline: Fix the update of the
total -deadline utilization") added that.

The 0-lag time is when the task, served at its bandwidth since the
start of its period, has received the runtime it used. That is:

  next period - runtime * dl_period / dl_runtime

Here runtime is the runtime left. GRUB [1] has the same formula (rule 5
of section 4.1), with the deadline in place of the next period. In
GRUB, the deadline is always the end of the period (rules 1 and 3). For
a constrained deadline, rule R6 of [2] puts the end of the period at
deadline - dl_deadline + dl_period. This is what dl_next_period()
returns.

dl_time_to_zerolag() uses the deadline in place of the next period. The
two are the same only for an implicit deadline. A constrained deadline
comes dl_period - dl_deadline before the next period. So the 0-lag time
comes that much too early.

For example, take a task with a runtime of 10ms, a deadline of 20ms and
a period of 500ms. It runs 2ms into its period, then sleeps with 8ms
left. dl_time_to_zerolag() puts its 0-lag time at
20 - 8 * 500 / 10 = -380ms, before the task even blocked. Counted from
the next period, it is 500 - 400 = 100ms.

On v7.4-rc2, this would affect a constrained task:
- When it blocks, GRUB reclaiming would give its bandwidth to
  SCHED_FLAG_RECLAIM tasks too early. Schedutil could lower the CPU
  frequency too early. Deadline tasks could then miss their deadlines.
- When it exits or leaves the class, admission control could admit
  other tasks into a temporary overload.
This was found by reading.

Fix this by counting the 0-lag time from the next period, with
dl_next_period(). Update the formula in
Documentation/scheduler/sched-deadline.rst too.

This needs "sched/deadline: Fix an overflow of the 0-lag time with long
periods", which adds dl_time_to_zerolag().

A task that leaves the class and comes back after its 0-lag time
starts a new period. "sched/deadline: Reset the deadline and the
runtime with the parameters" does this. So a constrained task can come
back after the early 0-lag time, before its next period. It then runs
again before that next period. Three cases of deadline_bw_test check
this: reenter_runnable_in_gap, reenter_asleep_in_gap and
reenter_pi_blocked_in_gap. "selftests/sched: Test parameter changes in
deadline_bw_test", later in this series, adds them. They fail without
this patch and pass from it on.

[1] L. Abeni, G. Lipari, A. Parri, Y. Sun, "Parallel and sequential
    reclaiming in multicore real-time global scheduling", arXiv
    1512.01984, 2016, https://arxiv.org/abs/1512.01984
[2] D. Casini, L. Abeni, A. Biondi, T. Cucinotta, G. Buttazzo,
    "Constant Bandwidth Servers with Constrained Deadlines", RTNS 2017,
    https://retis.santannapisa.it/~a.biondi/papers/CBS_CD_RTNS17.pdf

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 Documentation/scheduler/sched-deadline.rst | 12 +++++-----
 kernel/sched/deadline.c                    | 26 +++++++++++++---------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.rst b/Documentation/scheduler/sched-deadline.rst
index 9019b66f6a5b..3529b667c07f 100644
--- a/Documentation/scheduler/sched-deadline.rst
+++ b/Documentation/scheduler/sched-deadline.rst
@@ -171,12 +171,14 @@ Deadline Task Scheduling
       The 0-lag time for a task entering the ActiveNonContending state is
       computed as::
 
-                        (runtime * dl_period)
-             deadline - ---------------------
-                             dl_runtime
+                           (runtime * dl_period)
+             next period - ---------------------
+                                dl_runtime
 
-      where runtime is the remaining runtime, while dl_runtime and dl_period
-      are the reservation parameters.
+      where runtime is the remaining runtime, next period is the start of
+      the task's next period, and dl_runtime and dl_period are the
+      reservation parameters. When dl_deadline equals dl_period, the next
+      period starts at the deadline.
 
   (b) If the task wakes up before the inactive timer fires, the task re-enters
       the ActiveContending state and the "inactive timer" is canceled.
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 74b3c6b967ee..1d2dcf478f95 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -607,6 +607,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
+static inline u64 dl_next_period(struct sched_dl_entity *dl_se);
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
@@ -614,14 +615,17 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
  * Return the time from now to the 0-lag time of @dl_se, or a negative
  * value if the 0-lag time has passed.
  *
- * The 0-lag time is when a task running at its reserved bandwidth would
- * use up the runtime it has left:
+ * The 0-lag time is when the task, served at its reserved bandwidth
+ * since the start of its period, has received the runtime it used. From
+ * there to the next period, the bandwidth gives exactly the runtime left:
  *
- *   0-lag = deadline - runtime * dl_period / dl_runtime
+ *   0-lag = next period - runtime * dl_period / dl_runtime
  *
  * Example: 30ms every 100ms, blocking 10ms into its period with 20ms
- * left. 0-lag = 100 - 20 * 100 / 30 = 33ms. From there to the deadline,
- * 30% of the CPU is exactly the 20ms left.
+ * left. 0-lag = 100 - 20 * 100 / 30 = 33ms.
+ *
+ * Do not count from the deadline. A constrained deadline comes before
+ * the next period, so the 0-lag time would come too early.
  *
  * The product can overflow 64 bits, so mul_u64_u64_div_u64() multiplies
  * on 128 bits. Its quotient must still fit: on x86-64 it traps
@@ -633,12 +637,12 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
  */
 static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 {
-	/* Time to the deadline. Negative if the deadline has passed. */
-	s64 left = dl_se->deadline - rq_clock(rq);
+	/* Time to the next period. Negative if it has started. */
+	s64 left = dl_next_period(dl_se) - rq_clock(rq);
 
 	if (dl_se->runtime < 0) {
 		/*
-		 * Overrun: the 0-lag time is after the deadline, by the time
+		 * Overrun: the 0-lag time is after the next period, by the time
 		 * needed to pay the overrun back at the reserved bandwidth.
 		 */
 		u64 overrun = -dl_se->runtime;
@@ -659,8 +663,8 @@ static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 	}
 
 	/*
-	 * Runtime left: the 0-lag time is before the deadline. It has
-	 * passed if the deadline has.
+	 * Runtime left: the 0-lag time is before the next period. It has
+	 * passed if the next period has started.
 	 */
 	if (left < 0)
 		return -1;
@@ -668,7 +672,7 @@ static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 	/*
 	 * runtime * dl_period / dl_runtime > left: the 0-lag time has
 	 * passed. The runtime left is more than the bandwidth gives until
-	 * the deadline, as a wakeup would find with dl_entity_overflow().
+	 * the next period.
 	 */
 	if (dl_se->runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
 						 dl_se->dl_period)) {
-- 
2.47.3

