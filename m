Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207370;
	b=WHbWa3pXuGSfB9TG06ekU45/ZNWolBiSoglOipQWNGXNHZMXhM70kargCZjHDP7T+xtE
	 HwCFeno9sOmAjhvupQgK9FmSgqrQfUSRTr3REnwpFq4kAGkhNtyssLKK+IZI9SYW0ySFI
	 lQC7D8cWfdsjkYNv/aIPymv5BKjorEVczJJNxae3jq9S8uZPluNTKAuKx0KIuX1xK5RE1
	 yGwD4OuaidfUaYVqXT5uKAPGJzbVn1CIg6PE9SjruO542U0SJMcts8f+nhyZgmHVkxByP
	 o99w+X5HUlg2Q9xatt3JPl4ELNSLOE33uehSqNVeO/wB+B8wDNE0Y1ZOn7y/SOGBVtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207370;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MIcgqPEzEHBcDf3d2oXJCi2MVBOs9a+z9hx+ENa1oMU=;
	b=qrYV9eoCDrcVKVrmo02q1u48OM7DquSEQH/1U9bfHoyFZWFuwP9WBwEMUUlvtHe3c9yY
	 3zX4UvAzvnR+5TeLXznc1xGFSQ6YPWt5iDE8X26xl9B3ktfqbumwJhKPSFkY0cmyKity8
	 H38WKEQm/D7hWe2z+yt/X34DQDKe8SSM/WWoAauixwahwUEQTl4Q48+WQFGyMzcy7ds6p
	 Qq4+urVpWOVGA4Y/VbdIRzSyCWMagLrWBBrr5kiFuLmgT4i7J3ri1ug3s4xY+/XP9njPV
	 wUn3FM4K49UMLTbuhBDA1zOStOeRP5QTQ/5ReDqBKfk7ZUWCI+sElc5wI1a4pSIfkkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PM399v4E;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1289A60A6F6C;
	Fri, 20 Nov 2026 20:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1289A60A6F6C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PM399v4E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207361;
	bh=MIcgqPEzEHBcDf3d2oXJCi2MVBOs9a+z9hx+ENa1oMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM399v4EgIFXnLFBE8lc4lKxqHxSHWJnWYZ8sqC971dSLeNnmgg0fYKe+bx74YqeJ
	 wlLl0Is6ey3+IFe04xMi+BNdsO6wSPaUm9nLJ/nytModz6Cc99u1YWTjJ/pBmznyMp
	 sfSHonBFzMhsARD+Qq4jBcMqi1XUFy/Kn85frX0/NLqK85TgpmFoI4ea6y9LPL4Vzv
	 3cKyIw8Pls3G3F9CFYJSsA5YsBg8doMJ8FM+k9/jQKU334u4SESJhJZUQ7omv+hQey
	 PnVUfZLue1a4WOfb/Wg8UC0J1H0sGP/CGb5GtKwV1ucU0u72q2+9Ot9LwoTpjh/f7h
	 WmkvxXjg0t/sQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2T0LL9zV8B;
	Fri, 20 Nov 2026 15:42:41 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v10 39/40] selftests/sched: Test parameter changes in deadline_bw_test
Date: Fri, 20 Nov 2026 15:42:16 -0500
Message-Id: <32515da7f3166ad7ae059ea3ae9aec5a3254f058.1795207233.git.mathieu.desnoyers@efficios.com>
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

Add the twelve cases of deadline_bw_test that test the fixes of
parameter changes, earlier in this series. In each, a task with runtime
left changes its parameters, or comes back to the class with new ones:
- a running task that leaves the class and comes back at once
- a running or sleeping task that shrinks its reservation, to an
  implicit or a constrained deadline
- a boosted task that changes its parameters, which the deboost then
  checks
- a task blocked on a PI mutex that changes its parameters, which
  changes its place among the waiters
- a running task past its deadline that changes its parameters, which
  throttles it until its next period
- a task asleep past its deadline whose relative deadline shrinks, which
  must not move its next period

Add three more cases, of a lock owner that cannot run on its own
reservation. A deadline waiter must boost it.

The comment above each case gives its scenario.

On v7.4-rc2, in 8 VMs of 8 CPUs, five of these cases fail in every VM:
- change_boosted_new_params
- change_constrained_new_params
- change_running_new_params
- return_running_new_params
- wake_constrained_new_params

These cases did not run there. Each fails without the fix named:
- setattr_blocked_new_period, boost_new_params_stale,
  deboost_asleep_new_params and setattr_blocked_reenter:
  "sched/deadline: Check the runtime of a task whose parameters
  change". Its dl_check_blocked_params() checks a blocked task, its
  rt_mutex_setprio() change deboosts a task with new parameters first,
  and its dl_deboost() leaves a sleeping task to its wakeup.
- constrained_gap_change_running: "sched/deadline: Reschedule a running
  task throttled at its enqueue".
- wake_after_deadline_shrunk: "sched/deadline: Keep the start of the
  period across a change of dl_deadline".
- pi_owner_asleep_in_gap, pi_owner_throttled and
  pi_owner_throttled_asleep: "sched/deadline: Boost an owner that
  cannot run on its own reservation".

deboost_new_params_reboost passes on v7.4-rc2 and with the first
series. There, a task made SCHED_DEADLINE while it waits on a PI mutex
keeps a deadline of 0, so it boosts the owner in any case. The case can
fail only from "sched/deadline: Start a period for a task that enters
the class blocked" on.

With the whole series, every case passes wherever it runs, PREEMPT_RT
included. The cases that need isolated CPUs ran in guests booted with
isolcpus=domain,1,2 or isolcpus=domain,0,1. No kernel warning is
logged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 1347 ++++++++++++++++-
 1 file changed, 1311 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index 7925623ed1da..ba20f7036f6c 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -284,6 +284,20 @@ static int set_deadline(pid_t tid, uint64_t runtime, uint64_t period)
 	return set_deadline_flags(tid, runtime, period, 0);
 }
 
+/* Make @tid a deadline task with a relative deadline shorter than @period. */
+static int set_constrained(pid_t tid, uint64_t runtime, uint64_t deadline, uint64_t period)
+{
+	struct dl_attr attr = {
+		.size = sizeof(attr),
+		.sched_policy = SCHED_DEADLINE,
+		.sched_runtime = runtime,
+		.sched_deadline = deadline,
+		.sched_period = period,
+	};
+
+	return syscall(SYS_sched_setattr, tid, &attr, 0) ? -errno : 0;
+}
+
 static int set_other(pid_t tid)
 {
 	struct dl_attr attr = { .size = sizeof(attr), .sched_policy = SCHED_OTHER };
@@ -2729,17 +2743,30 @@ static _Atomic pid_t ret_tid;
 static atomic_int ret_first_period_ms;
 
 /*
- * Run as the thread of return_asleep_new_params(). Become a deadline task
- * of 50ms every 100ms and run 20ms. 30ms of runtime are left, and the
- * 0-lag time is about 20ms ahead. Then sleep. The main thread switches
- * the thread to SCHED_OTHER and back, with 10ms every 100ms. Then spin
- * for 100ms, and store the CPU time used, in ms, in ret_first_period_ms.
- * Return NULL, or 1 on an error.
+ * Run as the thread of the return cases. Become a deadline task of 50ms
+ * every 100ms and run 20ms. 30ms of runtime are left, and the 0-lag time
+ * is about 20ms ahead. Then change to new parameters, as @arg says:
+ * - 0: the thread switches itself to SCHED_OTHER and back to
+ *   SCHED_DEADLINE, while it runs.
+ * - 1: the thread sleeps. The main thread switches it to SCHED_OTHER and
+ *   back.
+ * - 2: the thread changes its own parameters while it runs. It stays in
+ *   SCHED_DEADLINE.
+ * - 3: as 2, while a donor boosts the thread. The thread takes pi_lock and
+ *   wakes the donor up. The donor blocks on pi_lock. The thread then
+ *   changes its parameters, and unlocks.
+ * - 4: as 2, to a constrained deadline: 8ms in 20ms, every 100ms.
+ * - 5: the thread sleeps. The main thread changes it to 8ms in 20ms,
+ *   every 100ms.
+ * The new parameters are 10ms every 100ms, except in modes 4 and 5.
+ * Then spin for 100ms, and store the CPU time used, in ms, in
+ * ret_first_period_ms. Return NULL, or 1 on an error.
  */
 static void *returner(void *arg)
 {
+	long mode = (long)arg;
 	uint64_t t0, cpu0;
-	int err;
+	int err = 0;
 
 	ret_tid = gettid_();
 	err = set_deadline(0, 50 * NSEC_PER_MSEC, PERIOD);
@@ -2748,8 +2775,34 @@ static void *returner(void *arg)
 		return (void *)1;
 	}
 	spin_ns(20 * NSEC_PER_MSEC);
-	sem_post(&ret_ready);
-	sem_wait_sig(&ret_go);
+	if (mode == 1 || mode == 5) {
+		sem_post(&ret_ready);
+		sem_wait_sig(&ret_go);
+	} else if (mode == 4) {
+		err = set_constrained(0, 8 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, PERIOD);
+	} else if (mode == 3) {
+		if (take_pi_lock())
+			return (void *)1;
+		sem_post(&owner_go);
+		t0 = now_ns();
+		while (!refill_donor_locking || proc_state_of(donor_tid) != 'S') {
+			if (now_ns() - t0 > NSEC_PER_SEC) {
+				ksft_print_msg("the donor did not block on the lock\n");
+				drop_pi_lock();
+				return (void *)1;
+			}
+		}
+		err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+		drop_pi_lock();
+	} else {
+		err = mode ? 0 : set_other(0);
+		if (!err)
+			err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	}
+	if (err) {
+		ksft_print_msg("the task could not change: %s\n", strerror(-err));
+		return (void *)1;
+	}
 	t0 = now_ns();
 	cpu0 = thread_time_ns();
 	while (now_ns() - t0 < PERIOD)
@@ -2759,46 +2812,80 @@ static void *returner(void *arg)
 }
 
 /*
- * A task leaves SCHED_DEADLINE while it sleeps, and comes back at once
- * with a smaller runtime. Its 0-lag time is ahead, so it keeps its
- * deadline and the runtime it has left. returner() runs the task. It must
- * get about 10ms of CPU time in the 100ms after the change: its new
- * runtime, not the 30ms left from the old one. The case fails above 20ms.
+ * Run a return case: returner() with @mode as its argument. The thread
+ * must get about 10ms of CPU time in the 100ms after the change, 8ms in
+ * modes 4 and 5. That is its new runtime, not the 30ms left from the old
+ * one. The case fails above 20ms.
  */
-static int return_asleep_new_params(void)
+static int return_case(long mode)
 {
-	void *t_ret;
+	void *t_ret, *d_ret = NULL;
 	int err, ret = KSFT_PASS;
-	pthread_t t;
+	pthread_t t, d;
 
 	if (sem_init(&ret_ready, 0, 0) || sem_init(&ret_go, 0, 0)) {
 		ksft_print_msg("sem_init: %s\n", strerror(errno));
 		return KSFT_FAIL;
 	}
 	ret_first_period_ms = -1;
-	if (pthread_create(&t, NULL, returner, NULL)) {
+	if (mode == 3) {
+		/* The donor: a deadline task of 2ms every 10ms */
+		if (pi_init() || sem_init(&refill_donor_ready, 0, 0))
+			return KSFT_SKIP;
+		refill_donor_locking = 0;
+		donor_tid = 0;
+		if (pthread_create(&d, NULL, refill_donor, NULL)) {
+			ksft_print_msg("the donor thread could not start\n");
+			return KSFT_FAIL;
+		}
+		if (sem_wait_for(&refill_donor_ready, 5000) || donor_tid <= 0) {
+			ksft_print_msg("the donor is not ready\n");
+			sem_post(&owner_go);
+			join(d);
+			return KSFT_FAIL;
+		}
+	}
+	if (pthread_create(&t, NULL, returner, (void *)mode)) {
 		ksft_print_msg("the task thread could not start\n");
+		if (mode == 3) {
+			sem_post(&owner_go);
+			join(d);
+		}
 		return KSFT_FAIL;
 	}
-	if (sem_wait_for(&ret_ready, 5000)) {
-		/* The thread may get there late. Let it end. */
+	if (mode == 1 || mode == 5) {
+		if (sem_wait_for(&ret_ready, 5000)) {
+			/* The thread may get there late. Let it end. */
+			sem_post(&ret_go);
+			join(t);
+			return KSFT_FAIL;	/* the task said why */
+		}
+		/* Before its 0-lag time, about 20ms ahead */
+		err = wait_for(10, proc_state_of(ret_tid) == 'S') ? -EAGAIN : 0;
+		if (!err && mode == 1)
+			err = set_other(ret_tid);
+		if (!err && mode == 1)
+			err = set_deadline(ret_tid, 10 * NSEC_PER_MSEC, PERIOD);
+		if (!err && mode == 5)
+			err = set_constrained(ret_tid, 8 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC,
+					      PERIOD);
 		sem_post(&ret_go);
-		join(t);
-		return KSFT_FAIL;	/* the task said why */
-	}
-	/* Before its 0-lag time, about 20ms ahead */
-	err = wait_for(10, proc_state_of(ret_tid) == 'S') ? -EAGAIN : 0;
-	if (!err)
-		err = set_other(ret_tid);
-	if (!err)
-		err = set_deadline(ret_tid, 10 * NSEC_PER_MSEC, PERIOD);
-	sem_post(&ret_go);
-	if (err) {
-		ksft_print_msg("the task could not change asleep: %s\n", strerror(-err));
-		join(t);
-		return KSFT_FAIL;
+		if (err) {
+			ksft_print_msg("the task could not change asleep: %s\n",
+				       strerror(-err));
+			join(t);
+			return KSFT_FAIL;
+		}
 	}
 	err = pthread_join(t, &t_ret);
+	if (mode == 3) {
+		if (t_ret)
+			sem_post(&owner_go);	/* the task never woke the donor up */
+		if (pthread_join(d, &d_ret) || d_ret)
+			ret = KSFT_FAIL;
+		pi_fini();
+		sem_destroy(&refill_donor_ready);
+	}
 	if (err) {
 		ksft_print_msg("pthread_join: %s\n", strerror(err));
 		ret = KSFT_FAIL;
@@ -2814,6 +2901,1054 @@ static int return_asleep_new_params(void)
 	return ret;
 }
 
+/*
+ * A running task leaves SCHED_DEADLINE and comes back at once with a
+ * smaller runtime. Its 0-lag time is ahead, so it keeps its deadline and
+ * the runtime it has left. It must not run on more than the new runtime.
+ */
+static int return_running_new_params(void)
+{
+	return return_case(0);
+}
+
+/* The same, for a task that leaves and comes back while it sleeps. */
+static int return_asleep_new_params(void)
+{
+	return return_case(1);
+}
+
+/* The same, for a task that changes its parameters within the class. */
+static int change_running_new_params(void)
+{
+	return return_case(2);
+}
+
+/*
+ * The same, for a task that changes its parameters while a donor boosts
+ * it. The donor is a deadline task of 2ms every 10ms. Its deadline is the
+ * earlier one, so the task runs on its own runtime while boosted. The
+ * unlock ends the boost. The runtime left must then be checked against
+ * the new parameters.
+ */
+static int change_boosted_new_params(void)
+{
+	return return_case(3);
+}
+
+/*
+ * A running task of 50ms every 100ms has 30ms left. It changes itself to
+ * 8ms in 20ms, every 100ms. Its deadline stays 80ms ahead, further than
+ * the new 20ms. The check of the runtime left uses the new density over
+ * those 80ms. That allows 32ms, so the check keeps the 30ms. The task
+ * must keep no more than its new 8ms.
+ */
+static int change_constrained_new_params(void)
+{
+	return return_case(4);
+}
+
+/*
+ * The same, for a task that the main thread changes while it sleeps. The
+ * check is at its wakeup.
+ */
+static int wake_constrained_new_params(void)
+{
+	return return_case(5);
+}
+
+static sem_t shrink_ready;
+static _Atomic pid_t shrink_tid;
+static _Atomic unsigned long long shrink_t0;
+static _Atomic long long shrink_back_ms;
+
+/*
+ * Run as T of wake_after_deadline_shrunk(). Its comment has the steps.
+ * Store in shrink_back_ms the time at which T runs after its sleep.
+ * Return NULL, or 1 on an error.
+ */
+static void *shrink_t(void *arg)
+{
+	struct timespec ts;
+	uint64_t t0, end;
+	int err;
+
+	shrink_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	t0 = now_ns();
+	shrink_t0 = t0;
+	sem_post(&shrink_ready);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(NSEC_PER_MSEC);
+	end = t0 + 110 * NSEC_PER_MSEC;
+	ts.tv_sec = end / NSEC_PER_SEC;
+	ts.tv_nsec = end % NSEC_PER_SEC;
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+	shrink_back_ms = (now_ns() - t0) / NSEC_PER_MSEC;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Shorten the relative deadline of a task asleep past its deadline:
+ * 1. T becomes a deadline task of 10ms every 100ms, at 0ms. Its deadline
+ *    is 100ms. It runs 1ms, and sleeps until 110ms.
+ * 2. At 105ms, the main thread changes T to 10ms in 20ms, every 100ms.
+ * 3. T wakes up at 110ms. Its period ended at 100ms. It must run at once,
+ *    in a new period.
+ *
+ * Worked out from the deadline and the new relative deadline, the next
+ * period would start at 100 - 20 + 100 = 180ms. The wakeup would then
+ * throttle T until 180ms. The case fails if T runs at 130ms or later.
+ */
+static int wake_after_deadline_shrunk(void)
+{
+	void *t_ret = NULL;
+	int err, ret = KSFT_FAIL;
+	uint64_t at;
+	pthread_t t;
+
+	if (sem_init(&shrink_ready, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	shrink_back_ms = -1;
+	if (pthread_create(&t, NULL, shrink_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&shrink_ready, 5000)) {
+		join(t);
+		goto out;
+	}
+	at = shrink_t0 + 105 * NSEC_PER_MSEC;
+	while (now_ns() < at)
+		sleep_ns(NSEC_PER_MSEC);
+	if (proc_state_of(shrink_tid) != 'S') {
+		ksft_print_msg("T is not asleep at 105ms\n");
+		join(t);
+		goto out;
+	}
+	err = set_constrained(shrink_tid, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC,
+			      PERIOD);
+	if (err) {
+		ksft_print_msg("T could not change asleep: %s\n", strerror(-err));
+		join(t);
+		goto out;
+	}
+	pthread_join(t, &t_ret);
+	if (t_ret || shrink_back_ms < 0)
+		goto out;	/* T said why */
+	if (shrink_back_ms >= 130) {
+		ksft_print_msg("T ran again at %lld ms, after its wakeup at 110\n",
+			       (long long)shrink_back_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&shrink_ready);
+	return ret;
+}
+
+static sem_t gap_h_ready, gap_h_go, gap_h_end;
+static atomic_int gap_h_err;
+static _Atomic long long gap_used_ms, gap_back_ms;
+
+/*
+ * Run as H of constrained_gap_change_running(). Become a deadline task of
+ * 40ms in 45ms, every 100ms, and wait for gap_h_go. Then spin for 35ms of
+ * CPU time, and wait for gap_h_end. Return NULL, or 1 on an error.
+ */
+static void *gap_h(void *arg)
+{
+	int err = set_constrained(0, 40 * NSEC_PER_MSEC, 45 * NSEC_PER_MSEC, PERIOD);
+
+	gap_h_err = err;
+	sem_post(&gap_h_ready);
+	if (err) {
+		ksft_print_msg("H refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	sem_wait_sig(&gap_h_go);
+	spin_ns(35 * NSEC_PER_MSEC);
+	sem_wait_sig(&gap_h_end);
+	if (set_other(0))
+		ksft_print_msg("H cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as T of constrained_gap_change_running(). Its comment has the
+ * steps. Store in gap_used_ms the CPU time T used until 55ms, and in
+ * gap_back_ms the time at which T runs again after its change. Return
+ * NULL, or 1 on an error.
+ */
+static void *gap_t(void *arg)
+{
+	uint64_t t0, c0;
+	int err;
+
+	err = set_constrained(0, 40 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	t0 = now_ns();
+	c0 = thread_time_ns();
+	sem_post(&gap_h_go);
+	while (now_ns() - t0 < 55 * NSEC_PER_MSEC)
+		;
+	gap_used_ms = (thread_time_ns() - c0) / NSEC_PER_MSEC;
+	err = set_constrained(0, 39 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC, PERIOD);
+	gap_back_ms = (now_ns() - t0) / NSEC_PER_MSEC;
+	if (err)
+		ksft_print_msg("T could not change: %s\n", strerror(-err));
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * Change the parameters of a running task past its deadline, before its
+ * next period. P has one CPU:
+ * 1. H, a deadline task of 40ms in 45ms, every 100ms, waits.
+ * 2. T becomes a deadline task of 40ms in 50ms, every 100ms, and wakes H.
+ *    H has the earlier deadline. It runs for 35ms.
+ * 3. T runs from 35ms. At 50ms it is past its deadline, with runtime
+ *    left.
+ * 4. At 55ms, T changes its runtime to 39ms. The enqueue of the change
+ *    throttles it until its next period, at 100ms.
+ *
+ * T must then leave the CPU until 100ms. Its CPU time does not show it:
+ * a throttled task that keeps running is not charged. So T reads the time
+ * when its change returns. The case fails before 90ms.
+ */
+static int constrained_gap_change_running(void)
+{
+	void *h_ret = NULL, *t_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t h, t;
+
+	if (sem_init(&gap_h_ready, 0, 0) || sem_init(&gap_h_go, 0, 0) ||
+	    sem_init(&gap_h_end, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	gap_used_ms = -1;
+	gap_back_ms = -1;
+	if (pthread_create(&h, NULL, gap_h, NULL)) {
+		ksft_print_msg("the H thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&gap_h_ready, 5000) || gap_h_err) {
+		sem_post(&gap_h_go);
+		sem_post(&gap_h_end);
+		join(h);
+		goto out;	/* H said why */
+	}
+	if (pthread_create(&t, NULL, gap_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		sem_post(&gap_h_go);
+		sem_post(&gap_h_end);
+		join(h);
+		goto out;
+	}
+	pthread_join(t, &t_ret);
+	sem_post(&gap_h_go);	/* if T never woke H */
+	sem_post(&gap_h_end);
+	pthread_join(h, &h_ret);
+	if (t_ret || h_ret || gap_back_ms < 0)
+		goto out;	/* the thread said why */
+	if (gap_used_ms > 30) {
+		ksft_print_msg("T used %lld ms of its first 55: H did not delay it\n",
+			       (long long)gap_used_ms);
+		goto out;
+	}
+	if (gap_back_ms < 90) {
+		ksft_print_msg("T ran again at %lld ms, throttled until 100\n",
+			       (long long)gap_back_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&gap_h_ready);
+	sem_destroy(&gap_h_go);
+	sem_destroy(&gap_h_end);
+	return ret;
+}
+
+static sem_t rb_donor_go;
+static atomic_int rb_abort, rb_donor_locking, rb_donor_done, rb_waiter_locking;
+static _Atomic pid_t rb_waiter_tid;
+static _Atomic long long rb_spin_ns;
+static int rb_stale;
+
+/*
+ * Run as the owner O of deboost_new_params_reboost(), or of
+ * boost_new_params_stale() if rb_stale is set. Their comments have the
+ * steps. Store in rb_spin_ns the time that O's last spin takes: 20ms of
+ * CPU time, 8ms with rb_stale. Return NULL, or 1 on an error.
+ */
+static void *reboost_owner(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	owner_tid = gettid_();
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	sem_wait_sig(&owner_go);
+	if (rb_abort) {
+		drop_pi_lock();
+		return NULL;
+	}
+	err = set_deadline(0, 50 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n",
+			       strerror(-err));
+		goto out;
+	}
+	sem_post(&rb_donor_go);
+	t0 = now_ns();
+	while (!rb_donor_locking || proc_state_of(donor_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			ksft_print_msg("the donor did not block on the lock\n");
+			err = -1;
+			goto out;
+		}
+	}
+	err = set_deadline(rb_waiter_tid, 2 * NSEC_PER_MSEC,
+			   rb_stale ? 60 * NSEC_PER_MSEC : PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		goto out;
+	}
+	err = set_deadline(0, 5 * NSEC_PER_MSEC,
+			   rb_stale ? 20 * NSEC_PER_MSEC : PERIOD);
+	if (err) {
+		ksft_print_msg("the owner could not change: %s\n",
+			       strerror(-err));
+		goto out;
+	}
+	t0 = now_ns();
+	while (!rb_donor_done) {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			ksft_print_msg("the donor did not time out\n");
+			err = -1;
+			goto out;
+		}
+	}
+	t0 = now_ns();
+	spin_ns((rb_stale ? 8 : 20) * NSEC_PER_MSEC);
+	rb_spin_ns = now_ns() - t0;
+out:
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * Run as the donor D of deboost_new_params_reboost(). Become a deadline
+ * task of 5ms every 50ms, and sleep until rb_donor_go. Then wait 20ms for
+ * pi_lock. Return NULL if the wait timed out or the case gave up, or 1
+ * otherwise.
+ */
+static void *reboost_donor(void *arg)
+{
+	struct timespec ts;
+	int err;
+
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, PERIOD / 2);
+	if (err) {
+		ksft_print_msg("the donor refused as a deadline task: %s\n",
+			       strerror(-err));
+		donor_tid = -1;
+		return (void *)1;
+	}
+	donor_tid = gettid_();
+	sem_wait_sig(&rb_donor_go);
+	if (rb_abort) {
+		set_other(0);
+		return NULL;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += 20 * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	rb_donor_locking = 1;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	rb_donor_done = 1;
+	if (!err)
+		pthread_mutex_unlock(&pi_lock);
+	if (set_other(0))
+		ksft_print_msg("the donor cannot leave SCHED_DEADLINE\n");
+	if (err != ETIMEDOUT) {
+		ksft_print_msg("the donor: %s, not a timeout\n",
+			       err ? strerror(err) : "got pi_lock");
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * Run as the waiter W of deboost_new_params_reboost(). Wait for pi_lock
+ * as a fair task. The owner makes W a deadline task during the wait.
+ * Return NULL, or 1 on an error.
+ */
+static void *reboost_waiter(void *arg)
+{
+	rb_waiter_tid = gettid_();
+	rb_waiter_locking = 1;
+	if (take_pi_lock())
+		return (void *)1;
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the waiter cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+static int reboost_case(int stale);
+
+/*
+ * Check that a deboost boosts the owner again when the check of its new
+ * parameters moves its deadline after the one of its top waiter. The
+ * threads share the CPU of P:
+ *
+ *   owner O                     donor D               waiter W
+ *   fair                        5ms every 50ms        fair
+ *
+ *   takes pi_lock               sleeps
+ *                                                     blocks on pi_lock
+ *   becomes 50ms every 100ms
+ *   wakes D up
+ *                               preempts O
+ *                               waits 20ms for
+ *                                 pi_lock, boosts O
+ *   makes W 2ms every 100ms
+ *   changes itself to 5ms
+ *     every 100ms
+ *   spins
+ *                               times out: W is now
+ *                                 the top waiter
+ *   spins 20ms
+ *   unlocks
+ *                                                     takes pi_lock
+ *
+ * W gets its deadline after O does, so W's deadline is the later one.
+ * W blocks as a fair task: a deadline W could not preempt O to block.
+ *
+ * O has run about 20ms of its 50ms when D times out. The deboost checks
+ * the runtime left against the new parameters. It is too much, so O
+ * starts a new period: 5ms and a deadline 100ms ahead. W's deadline is
+ * now the earlier one. W must boost O again. A boosted O is refilled
+ * from W, so its last spin takes about 20ms. Without the boost, O is
+ * throttled once its 5ms run out, until its new deadline. The case fails
+ * if the spin takes more than 50ms.
+ */
+static int deboost_new_params_reboost(void)
+{
+	return reboost_case(0);
+}
+
+/*
+ * As deboost_new_params_reboost(), with W's deadline between those of O's
+ * old and new parameters. W gets 2ms every 60ms, and O changes itself to
+ * 5ms every 20ms. When D times out, W's deadline is earlier than the one
+ * O still has from its old parameters. The deboost must still check O's
+ * runtime first. O then starts a new period: 5ms and a deadline 20ms
+ * ahead, earlier than W's. W must not boost O. O is throttled once its
+ * 5ms run out, so its last spin of 8ms takes about 20ms. If W boosts O,
+ * O is refilled from W, and the spin takes about 8ms. The case fails if
+ * the spin takes less than 15ms.
+ */
+static int boost_new_params_stale(void)
+{
+	return reboost_case(1);
+}
+
+/*
+ * Run deboost_new_params_reboost(), or boost_new_params_stale() if
+ * @stale is set.
+ */
+static int reboost_case(int stale)
+{
+	void *o_ret = NULL, *d_ret = NULL, *w_ret = NULL;
+	int ret = KSFT_FAIL, have_d = 0, have_w = 0;
+	pthread_t o, d, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&rb_donor_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_FAIL;
+	}
+	donor_tid = 0;
+	rb_abort = 0;
+	rb_donor_locking = 0;
+	rb_donor_done = 0;
+	rb_waiter_locking = 0;
+	rb_waiter_tid = 0;
+	rb_spin_ns = -1;
+	rb_stale = stale;
+	if (pthread_create(&o, NULL, reboost_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		goto out_fini;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took pi_lock\n");
+		goto out;
+	}
+	have_d = !pthread_create(&d, NULL, reboost_donor, NULL);
+	if (!have_d || wait_for(1000, donor_tid &&
+				   proc_state_of(donor_tid) == 'S') ||
+	    donor_tid < 0) {
+		ksft_print_msg("the donor never slept\n");
+		goto out;
+	}
+	have_w = !pthread_create(&w, NULL, reboost_waiter, NULL);
+	if (!have_w || wait_for(1000, rb_waiter_locking &&
+				   proc_state_of(rb_waiter_tid) == 'S')) {
+		ksft_print_msg("the waiter never waited on pi_lock\n");
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	/* On a failure, the owner and the donor end without the steps. */
+	rb_abort = ret != KSFT_PASS;
+	sem_post(&owner_go);
+	if (pthread_join(o, &o_ret))
+		ret = KSFT_FAIL;
+	sem_post(&rb_donor_go);
+	if (have_d && pthread_join(d, &d_ret))
+		ret = KSFT_FAIL;
+	if (have_w && pthread_join(w, &w_ret))
+		ret = KSFT_FAIL;
+	if (o_ret || d_ret || w_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (ret == KSFT_PASS && !stale && rb_spin_ns > PERIOD / 2) {
+		ksft_print_msg("the spin took %lld ms: not boosted again\n",
+			       rb_spin_ns / (long long)NSEC_PER_MSEC);
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && stale && rb_spin_ns < 15 * NSEC_PER_MSEC) {
+		ksft_print_msg("the spin took %lld ms: boosted with old parameters\n",
+			       rb_spin_ns / (long long)NSEC_PER_MSEC);
+		ret = KSFT_FAIL;
+	}
+out_fini:
+	sem_destroy(&rb_donor_go);
+	pi_fini();
+	return ret;
+}
+
+static sem_t das_donor_ready, das_owner_locked;
+static atomic_int das_donor_locking;
+static _Atomic pid_t das_donor_tid;
+static _Atomic long long das_back_ms;
+
+/*
+ * Run as the donor D of deboost_asleep_new_params(). Become a deadline
+ * task of 1ms every 10ms. Once O holds pi_lock, wait 150ms for it. Return
+ * NULL if the wait timed out, or 1 otherwise.
+ */
+static void *das_donor(void *arg)
+{
+	struct timespec ts;
+	int err;
+
+	das_donor_tid = gettid_();
+	err = set_deadline(0, NSEC_PER_MSEC, 10 * NSEC_PER_MSEC);
+	sem_post(&das_donor_ready);
+	if (err) {
+		ksft_print_msg("the donor refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	if (sem_wait_for(&das_owner_locked, 5000)) {
+		ksft_print_msg("the owner did not take the lock\n");
+		set_other(0);
+		return (void *)1;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += 150 * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	das_donor_locking = 1;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	if (!err)
+		pthread_mutex_unlock(&pi_lock);
+	if (set_other(0))
+		ksft_print_msg("the donor cannot leave SCHED_DEADLINE\n");
+	if (err != ETIMEDOUT) {
+		ksft_print_msg("the donor: %s, not a timeout\n",
+			       err ? strerror(err) : "got pi_lock");
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * Run as the owner O of deboost_asleep_new_params(). Its comment has the
+ * steps. Store in das_back_ms the time at which O runs after its sleep.
+ * Return NULL, or 1 on an error.
+ */
+static void *das_owner(void *arg)
+{
+	struct timespec ts;
+	uint64_t t0, end;
+	int err;
+
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, PERIOD);
+	t0 = now_ns();
+	if (err || take_pi_lock()) {
+		if (err)
+			ksft_print_msg("the owner refused as a deadline task: %s\n",
+				       strerror(-err));
+		sem_post(&das_owner_locked);
+		set_other(0);
+		return (void *)1;
+	}
+	sem_post(&das_owner_locked);
+	while (!das_donor_locking || proc_state_of(das_donor_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			ksft_print_msg("the donor did not block on the lock\n");
+			err = -1;
+			goto out;
+		}
+	}
+	err = set_constrained(0, 9 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the owner could not change: %s\n", strerror(-err));
+		goto out;
+	}
+	end = t0 + 190 * NSEC_PER_MSEC;
+	ts.tv_sec = end / NSEC_PER_SEC;
+	ts.tv_nsec = end % NSEC_PER_SEC;
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+	das_back_ms = (now_ns() - t0) / NSEC_PER_MSEC;
+out:
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * Deboost a task that sleeps on a timer, after it changed its parameters
+ * while boosted. The threads share the CPU of P:
+ * 1. O becomes a deadline task of 10ms in 20ms, every 100ms, at 0ms. It
+ *    takes pi_lock.
+ * 2. D, a deadline task of 1ms every 10ms, waits 150ms for pi_lock. It
+ *    boosts O.
+ * 3. O changes itself to 9ms in 20ms, every 100ms. It sleeps until
+ *    190ms, holding pi_lock.
+ * 4. D times out at 150ms, while O sleeps.
+ * 5. O wakes up at 190ms. Its own period ended at 100ms. It must run at
+ *    once, in a new period.
+ *
+ * If the deboost checks O's new parameters while O sleeps, O starts a
+ * period at 150ms, with a deadline at 170ms. Its wakeup at 190ms is then
+ * between that deadline and the next period, at 250ms. It throttles O
+ * until 250ms. The case fails if O runs at 220ms or later.
+ */
+static int deboost_asleep_new_params(void)
+{
+	void *o_ret = NULL, *d_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t o, d;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&das_donor_ready, 0, 0) || sem_init(&das_owner_locked, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_FAIL;
+	}
+	das_donor_locking = 0;
+	das_donor_tid = 0;
+	das_back_ms = -1;
+	if (pthread_create(&d, NULL, das_donor, NULL)) {
+		ksft_print_msg("the donor thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&das_donor_ready, 5000)) {
+		sem_post(&das_owner_locked);
+		join(d);
+		goto out;
+	}
+	if (pthread_create(&o, NULL, das_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&das_owner_locked);
+		join(d);
+		goto out;
+	}
+	pthread_join(o, &o_ret);
+	pthread_join(d, &d_ret);
+	if (o_ret || d_ret || das_back_ms < 0)
+		goto out;	/* the thread said why */
+	if (das_back_ms >= 220) {
+		ksft_print_msg("O ran again at %lld ms, after its wakeup at 190\n",
+			       (long long)das_back_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&das_donor_ready);
+	sem_destroy(&das_owner_locked);
+	pi_fini();
+	return ret;
+}
+
+static sem_t ob_locked, ob_go;
+static _Atomic unsigned long long ob_t0;
+static _Atomic long long ob_got_ms;
+static int ob_throttled;
+
+/*
+ * Run as the owner O of owner_boost_case(). Take pi_lock. With
+ * ob_throttled, become a deadline task of 10ms every 100ms and spin 15ms
+ * of CPU time, so that O runs out of runtime holding the lock. Else
+ * become a deadline task of 10ms in 20ms, every 500ms, and sleep until
+ * 40ms. O then wakes past its deadline, before its next period. Then
+ * unlock. Return NULL, or 1 on an error.
+ */
+static void *ob_owner(void *arg)
+{
+	struct timespec ts;
+	uint64_t end;
+	int err;
+
+	if (ob_throttled)
+		err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	else
+		err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC,
+				      5 * PERIOD);
+	ob_t0 = now_ns();
+	if (err || take_pi_lock()) {
+		if (err)
+			ksft_print_msg("the owner refused as a deadline task: %s\n",
+				       strerror(-err));
+		sem_post(&ob_locked);
+		set_other(0);
+		return (void *)1;
+	}
+	sem_post(&ob_locked);
+	if (ob_throttled) {
+		spin_ns(15 * NSEC_PER_MSEC);
+	} else {
+		end = ob_t0 + 40 * NSEC_PER_MSEC;
+		ts.tv_sec = end / NSEC_PER_SEC;
+		ts.tv_nsec = end % NSEC_PER_SEC;
+		while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+			;
+	}
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as the waiter W of owner_boost_case(). Wait for ob_go. Then
+ * become a deadline task of 5ms every 300ms, and take pi_lock. Store in
+ * ob_got_ms the time at which W gets it. Return NULL, or 1 on an error.
+ */
+static void *ob_waiter(void *arg)
+{
+	int err;
+
+	sem_wait_sig(&ob_go);
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, 3 * PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		return (void *)1;
+	}
+	if (take_pi_lock()) {
+		set_other(0);
+		return (void *)1;
+	}
+	ob_got_ms = (now_ns() - ob_t0) / NSEC_PER_MSEC;
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the waiter cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run an owner_boost case: ob_owner() and ob_waiter(), as @throttled
+ * says. W must get pi_lock within @limit_ms of O's start.
+ */
+static int owner_boost_case(int throttled, int limit_ms)
+{
+	void *o_ret = NULL, *w_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t o, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&ob_locked, 0, 0) || sem_init(&ob_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_FAIL;
+	}
+	ob_throttled = throttled;
+	ob_got_ms = -1;
+	if (pthread_create(&w, NULL, ob_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		goto out;
+	}
+	if (pthread_create(&o, NULL, ob_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&ob_go);
+		join(w);
+		goto out;
+	}
+	/* O holds pi_lock, and runs until it is throttled or asleep. */
+	if (sem_wait_for(&ob_locked, 5000)) {
+		sem_post(&ob_go);
+		join(o);
+		join(w);
+		goto out;
+	}
+	if (!throttled)
+		sleep_ns(30 * NSEC_PER_MSEC);	/* O sleeps past its deadline */
+	sem_post(&ob_go);
+	pthread_join(o, &o_ret);
+	pthread_join(w, &w_ret);
+	if (o_ret || w_ret || ob_got_ms < 0)
+		goto out;	/* the thread said why */
+	if (ob_got_ms >= limit_ms) {
+		ksft_print_msg("the waiter got the lock at %lld ms, not before %d\n",
+			       (long long)ob_got_ms, limit_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&ob_locked);
+	sem_destroy(&ob_go);
+	pi_fini();
+	return ret;
+}
+
+/*
+ * A deadline waiter blocks on a lock whose owner sleeps past its deadline:
+ * 1. O becomes a deadline task of 10ms in 20ms, every 500ms, at 0ms. It
+ *    takes pi_lock and sleeps until 40ms.
+ * 2. At 30ms, W becomes a deadline task of 5ms every 300ms and blocks on
+ *    pi_lock. O's deadline, 20ms, is the earlier one.
+ * 3. O wakes up at 40ms, between its deadline and its next period, at
+ *    500ms. The wakeup would throttle it until then.
+ *
+ * W must boost O: O cannot run on its own reservation. O then runs at
+ * 40ms and unlocks. The case fails if W gets pi_lock at 200ms or later.
+ */
+static int pi_owner_asleep_in_gap(void)
+{
+	return owner_boost_case(0, 200);
+}
+
+/*
+ * A deadline waiter blocks on a lock whose owner ran out of runtime:
+ * 1. O becomes a deadline task of 10ms every 100ms, at 0ms. It takes
+ *    pi_lock and spins 15ms of CPU time. It is throttled at 10ms, until
+ *    100ms.
+ * 2. W then becomes a deadline task of 5ms every 300ms and blocks on
+ *    pi_lock. O's deadline, 100ms, is the earlier one.
+ *
+ * W must boost O: O cannot run on its own reservation. O then runs its
+ * last 5ms on W's runtime and unlocks. The case fails if W gets pi_lock
+ * at 60ms or later.
+ */
+static int pi_owner_throttled(void)
+{
+	return owner_boost_case(1, 60);
+}
+
+static sem_t ota_locked, ota_wgo, ota_wout, ota_owake;
+static atomic_int ota_wlocking;
+static _Atomic pid_t ota_o_tid, ota_w_tid;
+static _Atomic unsigned long long ota_t0;
+
+/*
+ * Run as the owner O of pi_owner_throttled_asleep(). Its comment has the
+ * steps. Return NULL, or 1 on an error.
+ */
+static void *ota_owner(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	ota_o_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	ota_t0 = now_ns();
+	if (err || take_pi_lock()) {
+		if (err)
+			ksft_print_msg("the owner refused as a deadline task: %s\n",
+				       strerror(-err));
+		sem_post(&ota_locked);
+		set_other(0);
+		return (void *)1;
+	}
+	sem_post(&ota_locked);
+	spin_ns(12 * NSEC_PER_MSEC);	/* throttled at 10ms: W boosts it */
+	t0 = now_ns();
+	while (!ota_wlocking || proc_state_of(ota_w_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			ksft_print_msg("the waiter did not block on the lock\n");
+			drop_pi_lock();
+			set_other(0);
+			return (void *)1;
+		}
+	}
+	spin_ns(3 * NSEC_PER_MSEC);	/* on W's runtime */
+	sem_wait_sig(&ota_owake);
+	drop_pi_lock();
+	set_other(0);
+	return NULL;
+}
+
+/*
+ * Run as the waiter W of pi_owner_throttled_asleep(). Wait for ota_wgo.
+ * Then become a deadline task of 5ms every 300ms, wait 50ms for pi_lock,
+ * and leave the class. Return NULL if the wait timed out, or 1 otherwise.
+ */
+static void *ota_waiter(void *arg)
+{
+	struct timespec ts;
+	int err;
+
+	ota_w_tid = gettid_();
+	sem_wait_sig(&ota_wgo);
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, 3 * PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		sem_post(&ota_wout);
+		return (void *)1;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += 50 * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	ota_wlocking = 1;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	if (!err)
+		pthread_mutex_unlock(&pi_lock);
+	if (set_other(0))
+		ksft_print_msg("the waiter cannot leave SCHED_DEADLINE\n");
+	sem_post(&ota_wout);
+	if (err != ETIMEDOUT) {
+		ksft_print_msg("the waiter: %s, not a timeout\n",
+			       err ? strerror(err) : "got pi_lock");
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * A deboost puts back the reservation of an owner that sleeps. The
+ * threads share the CPU of P:
+ * 1. O becomes a deadline task of 10ms every 100ms, at 0ms. It takes
+ *    pi_lock and spins. It runs out of runtime at 10ms, until 100ms.
+ * 2. W becomes a deadline task of 5ms every 300ms, and waits 50ms for
+ *    pi_lock. O cannot run on its own reservation: W boosts it.
+ * 3. O runs 3ms on W's runtime, then sleeps, boosted.
+ * 4. W times out, at about 60ms, and leaves the class.
+ * 5. The main thread switches O to SCHED_OTHER. At 180ms, it reads
+ *    total_bw.
+ *
+ * O went to sleep with the runtime and the deadline of W's refill. Mixed
+ * with O's own parameters, they put its 0-lag time more than 200ms
+ * ahead. The deboost puts back O's own runtime and deadline. Their 0-lag
+ * time is about 100ms. O's bandwidth must be gone from total_bw at
+ * 180ms.
+ */
+static int pi_owner_throttled_asleep(void)
+{
+	void *o_ret = NULL, *w_ret = NULL;
+	long long base, bw = -1;
+	int err, ret = KSFT_FAIL;
+	pthread_t o, w;
+	uint64_t at;
+
+	if (total_bw_of(top_cpu(1)) < 0) {
+		ksft_print_msg("sched_debug tells of no total_bw\n");
+		return KSFT_SKIP;
+	}
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&ota_locked, 0, 0) || sem_init(&ota_wgo, 0, 0) ||
+	    sem_init(&ota_wout, 0, 0) || sem_init(&ota_owake, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	ota_wlocking = 0;
+	ota_w_tid = 0;
+	ota_o_tid = 0;
+	base = total_bw_of(top_cpu(1));	/* without O and W */
+	if (pthread_create(&w, NULL, ota_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		goto out;
+	}
+	if (pthread_create(&o, NULL, ota_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&ota_wgo);
+		join(w);
+		goto out;
+	}
+	/* The main thread runs once O is throttled. */
+	if (sem_wait_for(&ota_locked, 5000)) {
+		sem_post(&ota_wgo);
+		sem_post(&ota_owake);
+		join(w);
+		join(o);
+		goto out;
+	}
+	sem_post(&ota_wgo);
+	if (sem_wait_for(&ota_wout, 5000)) {
+		ksft_print_msg("the waiter did not time out\n");
+	} else if (wait_for(1000, proc_state_of(ota_o_tid) == 'S')) {
+		ksft_print_msg("the owner is not asleep\n");
+	} else {
+		err = set_other(ota_o_tid);
+		if (err) {
+			ksft_print_msg("the owner cannot leave SCHED_DEADLINE: %s\n",
+				       strerror(-err));
+		} else {
+			at = ota_t0 + 180 * NSEC_PER_MSEC;
+			while (now_ns() < at)
+				sleep_ns(NSEC_PER_MSEC);
+			bw = total_bw_of(top_cpu(1));
+		}
+	}
+	sem_post(&ota_owake);
+	pthread_join(w, &w_ret);
+	pthread_join(o, &o_ret);
+	if (o_ret || w_ret || bw < 0)
+		goto out;	/* a thread said why */
+	if (bw != base) {
+		ksft_print_msg("total_bw %lld at 180ms, %lld expected\n", bw, base);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&ota_locked);
+	sem_destroy(&ota_wgo);
+	sem_destroy(&ota_wout);
+	sem_destroy(&ota_owake);
+	pi_fini();
+	return ret;
+}
+
 static pthread_mutex_t pi_lock2;
 static sem_t holder_go;
 static atomic_int holder_holds, chain_waits, donor_done, x_waits, l2_takes;
@@ -2860,8 +3995,8 @@ static int take_l2_ranked(atomic_int *rank)
  * boost refills its runtime from the donor's 40ms. Then wait on pi_lock2
  * while holding pi_lock. The donor's timeout deboosts the owner during
  * that wait. The owner then has more runtime left than its own 10ms.
- * Return NULL, 1 on an error, or 2 if the spin took over 50ms: the owner
- * was throttled, so it was not boosted.
+ * Return NULL, or 1 on an error. Return 2 if the spin took over 50ms.
+ * The owner was then throttled, so it was not boosted.
  */
 static void *chain_owner(void *arg)
 {
@@ -3198,6 +4333,131 @@ static int boost_blocked_keeps_order(void)
 	return blocked_keeps_order(1);
 }
 
+static int dl_waiter_spin_ms;
+
+/*
+ * A waiter of pi_lock2 that is a deadline task of 400ms every 1s. It
+ * spins dl_waiter_spin_ms of CPU time once it starts its period, then
+ * waits. It leaves the class at the end.
+ */
+static void *dl_waiter(void *arg)
+{
+	int err;
+
+	fair_tid = gettid_();
+	err = set_deadline(0, 400 * NSEC_PER_MSEC, NSEC_PER_SEC);
+	if (err) {
+		ksft_print_msg("a waiter refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(dl_waiter_spin_ms * NSEC_PER_MSEC);
+	chain_waits = 1;
+	err = take_l2_ranked(&chain_rank);
+	if (set_other(0))
+		ksft_print_msg("a waiter cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+static int setattr_blocked_case(int reenter);
+
+/*
+ * Check the order of the waiters of pi_lock2 when sched_setattr() changes
+ * the parameters of one of them while it waits. The holder has pi_lock2:
+ * 1. W, a deadline task of 400ms every 1s, waits on pi_lock2. Its
+ *    deadline is about 1s ahead.
+ * 2. The other waiter, a deadline task of 5ms every 50ms, waits on
+ *    pi_lock2. Its deadline is about 50ms ahead.
+ * 3. The main thread gives W 1ms every 10ms. The 400ms left overflow these
+ *    parameters, so W starts a new period: its deadline is 10ms ahead.
+ * 4. The holder drops pi_lock2.
+ *
+ * W must take pi_lock2 first. W is not queued at step 3. Unless its
+ * runtime is checked against its new parameters then, its waiter node
+ * keeps the deadline 1s ahead.
+ */
+static int setattr_blocked_new_period(void)
+{
+	return setattr_blocked_case(0);
+}
+
+/*
+ * The same, when W leaves the class and comes back while it waits. W
+ * first spins 100ms, so its 0-lag time is about 250ms ahead. At step 3,
+ * the main thread switches W to SCHED_OTHER, then back to SCHED_DEADLINE
+ * with 1ms every 10ms. W keeps its deadline 1s ahead when it comes back.
+ * Its runtime must then be checked against its new parameters.
+ */
+static int setattr_blocked_reenter(void)
+{
+	return setattr_blocked_case(1);
+}
+
+/*
+ * Run setattr_blocked_new_period(), or setattr_blocked_reenter() if
+ * @reenter is set.
+ */
+static int setattr_blocked_case(int reenter)
+{
+	void *w_ret = NULL, *x_ret = NULL;
+	int ret = KSFT_FAIL, have_w = 0, have_x = 0, err;
+	pthread_t h, w, x;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pi_init_lock2()) {
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	if (pthread_create(&h, NULL, l2_holder, NULL)) {
+		ksft_print_msg("the holder thread could not start\n");
+		goto out_fini;
+	}
+	if (wait_for(5000, holder_holds) || holder_holds != 1) {
+		ksft_print_msg("the holder never took pi_lock2\n");
+		goto out;
+	}
+	dl_waiter_spin_ms = reenter ? 100 : 0;
+	have_w = !pthread_create(&w, NULL, dl_waiter, NULL);
+	if (!have_w || wait_for(1000, chain_waits && proc_state_of(fair_tid) == 'S')) {
+		ksft_print_msg("the waiter W never waited on pi_lock2\n");
+		goto out;
+	}
+	have_x = !pthread_create(&x, NULL, early_waiter, NULL);
+	if (!have_x || wait_for(1000, x_waits && proc_state_of(x_tid) == 'S')) {
+		ksft_print_msg("the other waiter never waited on pi_lock2\n");
+		goto out;
+	}
+	err = reenter ? set_other(fair_tid) : 0;
+	if (err) {
+		ksft_print_msg("W cannot leave SCHED_DEADLINE: %s\n", strerror(-err));
+		goto out;
+	}
+	err = set_deadline(fair_tid, NSEC_PER_MSEC, 10 * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("new parameters for W refused: %s\n", strerror(-err));
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_post(&holder_go);	/* pi_lock2 goes to its top waiter */
+	if (have_x && pthread_join(x, &x_ret))
+		ret = KSFT_FAIL;
+	if (have_w && pthread_join(w, &w_ret))
+		ret = KSFT_FAIL;
+	join(h);
+	if (w_ret || x_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (ret == KSFT_PASS && chain_rank > x_rank) {
+		ksft_print_msg("W took pi_lock2 after the other waiter\n");
+		ret = KSFT_FAIL;
+	}
+out_fini:
+	pthread_mutex_destroy(&pi_lock2);
+	sem_destroy(&holder_go);
+	pi_fini();
+	return ret;
+}
+
 /*
  * The threads of pi_chain_donor_leaves(): O, M, W, Z and Y. leave_tid[]
  * holds their tids. leave_y_ns is the CPU time Y gets in O's window, or
@@ -11423,9 +12683,24 @@ static const struct p_case {
 	{ "deboost_in_asleep_after_refill", deboost_in_asleep_after_refill, MEASURED_IN_P },
 	{ "requeue_pi_new_period", requeue_pi_new_period, MEASURED_IN_P },
 	{ "deboost_keeps_own_runtime", deboost_keeps_own_runtime, MEASURED_IN_P },
+	{ "return_running_new_params", return_running_new_params, MEASURED_IN_P },
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
+	{ "change_running_new_params", change_running_new_params, MEASURED_IN_P },
+	{ "change_boosted_new_params", change_boosted_new_params, MEASURED_IN_P },
+	{ "change_constrained_new_params", change_constrained_new_params, MEASURED_IN_P },
+	{ "wake_constrained_new_params", wake_constrained_new_params, MEASURED_IN_P },
+	{ "constrained_gap_change_running", constrained_gap_change_running, MEASURED_IN_P },
+	{ "wake_after_deadline_shrunk", wake_after_deadline_shrunk, MEASURED_IN_P },
+	{ "deboost_new_params_reboost", deboost_new_params_reboost, MEASURED_IN_P },
+	{ "boost_new_params_stale", boost_new_params_stale, MEASURED_IN_P },
+	{ "deboost_asleep_new_params", deboost_asleep_new_params, MEASURED_IN_P },
+	{ "pi_owner_asleep_in_gap", pi_owner_asleep_in_gap, MEASURED_IN_P },
+	{ "pi_owner_throttled", pi_owner_throttled, MEASURED_IN_P },
+	{ "pi_owner_throttled_asleep", pi_owner_throttled_asleep, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
 	{ "setattr_blocked_keeps_order", setattr_blocked_keeps_order, MEASURED_IN_P },
+	{ "setattr_blocked_new_period", setattr_blocked_new_period, MEASURED_IN_P },
+	{ "setattr_blocked_reenter", setattr_blocked_reenter, MEASURED_IN_P },
 	{ "boost_blocked_keeps_order", boost_blocked_keeps_order, MEASURED_IN_P },
 	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
 	{ "pi_chain_top_moves", pi_chain_top_moves, MEASURED_IN_P },
-- 
2.47.3

