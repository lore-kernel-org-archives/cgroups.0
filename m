Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790181;
	b=M0ksfAvz44vTrSDww+RJC8oqFVM2SR2Q6GOOd9DCPUqjOG/cB/GX33mS+tll6M7VnnSA
	 lsgQzI4aYCHjArmzhzKfWCVjTIci7JjibMmYZtVLTn4M/0SWtHCYMeyNUlSYw0bA832I+
	 IUdJ7Z5ABwA4W3ayGhpQOHMFrnILMweXVHyw7t1DyzIunf6by61jl7cb4/mzN2ky57PQC
	 JrksJvxSNyP4WGQ0UoVRCRm197M3HJ85ifwy61qCgFdvaUwLvO781VUcFfMztaRbfl5Dx
	 Cl/x6oZAu3ilS2tfb9h7rc3h4cAmQpfMus6YvlitY/yPmb2BM+Do5Ou6b2JpvwWeNew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790181;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QRt5QJSaH+mk/HutkEo3sQCsNqGBk17cH5jUYMgv3Rw=;
	b=Xit4tZLn15UVKgE4iRFsBINfxJweuqY5ytajC7rWbB4GX9uj4cHDnfIlMqR8ErsGbdis
	 KQljfBy1O8rr998EwNnu66PUkZ3M/jV61ckYskt2KDpFrWJr/rWzWiUbs+0teJzfAHrR/
	 7ZQpYtdIoUN6bWlorO+fvYyH2WvYBEk5/viusV4c9Z2ejjR/rAWuSl9+6573ZWP4K/HW6
	 OYTLfq0bfSzo8hH0ovnnUTWlTGa+fZ9R/UJRcNIXUfAU9kuXo4I5h3POYuC2FCky0dju5
	 oU3gOILBqIWs2TuoxSt/p2N4TSewIKaZq7oB+sYsEIg5+ttGfHTpdVw5mjmovqeF+Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ni5DLmy6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EC960746CE;
	Fri, 27 Nov 2026 14:36:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2EC960746CE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ni5DLmy6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790177;
	bh=QRt5QJSaH+mk/HutkEo3sQCsNqGBk17cH5jUYMgv3Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni5DLmy63/v7Wd42smd34ZG1WRBzr0FRgpWYjWGqnObbJP+HlW9VWmSAr4XxYqebv
	 qklMeL8rX3dmKLRTGoMjOgQqO9CnvExAXjUJ5IschQUZhFjekmY8Ox51RNc02Z+P+5
	 eU2mnfdZJHY8HToW7UXQwxNtG1Z8I9oUVsdWtTN4Xz5QGQ+ZNbVh9V+VCrwAqRRgsj
	 JahX5tw04BDgR8M8A//1R/GjF/Gg1gz1x4uHGuj/Mkt4osUhWe8NdkKkpNS4QL1fjd
	 f5v7/+oTKFrMdzn0B4ut/tTGffiQBq/Yrtp6+zPyGmY4ExrqHn3DfVy4SdSs8EXcIP
	 GAtZrOjI7m/WA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZT6HFGzXZR;
	Fri, 27 Nov 2026 09:36:17 -0500 (EST)
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
Subject: [PATCH v12 25/43] sched/deadline: Count the 0-lag time from the next period
Date: Fri, 27 Nov 2026 09:35:52 -0500
Message-ID: <6d4923bb2cc2d45c2b06e81a9246a77bb9c60cab.1795771148.git.mathieu.desnoyers@efficios.com>
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
 Documentation/scheduler/sched-deadline.rst | 12 ++++----
 kernel/sched/deadline.c                    | 32 ++++++++++++++--------
 2 files changed, 27 insertions(+), 17 deletions(-)

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
index d481bf5a68c7..7dc0b71e7cce 100644
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
@@ -633,12 +637,16 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
  */
 static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 {
-	/* Time to the deadline. Negative if the deadline has passed. */
-	s64 left = dl_se->deadline - rq_clock(rq);
+	/* Time to the next period. Negative if it has started. */
+	s64 left = dl_next_period(dl_se) - rq_clock(rq);
+
+	/* A task with no period yet has received nothing: no 0-lag time. */
+	if (!dl_se->deadline)
+		return -1;
 
 	if (dl_se->runtime < 0) {
 		/*
-		 * Overrun: the 0-lag time is after the deadline, by the time
+		 * Overrun: the 0-lag time is after the next period, by the time
 		 * needed to pay the overrun back at the reserved bandwidth.
 		 */
 		u64 overrun = -dl_se->runtime;
@@ -659,8 +667,8 @@ static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 	}
 
 	/*
-	 * Runtime left: the 0-lag time is before the deadline. It has
-	 * passed if the deadline has.
+	 * Runtime left: the 0-lag time is before the next period. It has
+	 * passed if the next period has started.
 	 */
 	if (left < 0)
 		return -1;
@@ -668,7 +676,7 @@ static s64 dl_time_to_zerolag(struct sched_dl_entity *dl_se, struct rq *rq)
 	/*
 	 * runtime * dl_period / dl_runtime > left: the 0-lag time has
 	 * passed. The runtime left is more than the bandwidth gives until
-	 * the deadline, as a wakeup would find with dl_entity_overflow().
+	 * the next period.
 	 */
 	if (dl_se->runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
 						 dl_se->dl_period)) {
@@ -1756,7 +1764,7 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
 
-	if (dl_time_before(dl_se->deadline, rq_clock(rq)) &&
+	if (dl_se->deadline && dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 	    dl_time_before(rq_clock(rq), dl_next_period(dl_se))) {
 		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(dl_se)))
 			return;
-- 
2.47.3

