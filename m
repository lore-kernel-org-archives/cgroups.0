Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=jIPe0eBBgS4NbE6aK1l4YbbtvpTRWaK5aQtr9qMw1WAzgg1Wz1d3Rr8LahQ27js/NeJH
	 r3G60nGioTueZ/IU1jytmgUE9je3VPwTjSabRAaRzJJc2/A66M3Hf36Zoqj+hjE2X0Oe8
	 oS84SU93Vt+iBRwhVFyYAjqpNmSJb8X3HTNDG89qvYiA9LMpX943RJ1hzCQEhvozo7UzO
	 OAZWLx0C0WsifLa3QLhSFZxeaLr5+f44jwW3swCfdb5YcWc/TZACo3SLKiuE6kdrYhdX2
	 c4DQkln5ApQNH4lQuaNHZRy3R05wUyD/FXrGIb5lmElI/Vxu2/MtxJyDksEkXJzTcwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1wY0KtEdOeu8tEZ4FVuPw3UNQ3rtbu46Qm0QoYJO0VI=;
	b=dEPYaXMaKcbiDtGMJpxLvaY6gnG0/55qZ0iN4/vcmqpgXJw45fSvTzhpQc5y+SRdOQZL
	 JbTbu3CVtI34p2MFJKV1kI93bkpudUdA2sHurIZkyNif9ev3PhAA66v3v8KNI93RIVpGI
	 14INXuMw735+eK+zNTd87xG0mSeidMr48zCvO9MYjHSq3A3M6Gb5n9yDhzjJghsIznFLz
	 Mlf+pGIAR/qSCzN7JQCkg3KPDrT4PN68GvKz4O6irrP9qElT/qHxmnkYDHqas4BGqCvhi
	 syBpuxdnf5gPL2H5V6vsU29e15AkoIPCpt9RsFFfPh5X4Gi0eyq2Xqu561WR0Pi8rXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PrtWdvur;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0F3606B784;
	Thu, 19 Nov 2026 20:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F0F3606B784
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PrtWdvur
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119383;
	bh=1wY0KtEdOeu8tEZ4FVuPw3UNQ3rtbu46Qm0QoYJO0VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrtWdvure1bZNwepKIhT/fim2OomjO5agybCj3bU41g58OFiRta70z3YiI9wBIsC3
	 iSkzmVFEEVN74x2Q0Yw1mF43fmYz+BWWBJfwGingCgRO4qcvtKCiVH63uRZK+d1oON
	 HzlN68J4QmaYLazY76rnFn3/SRG082SJECDm+sY49dhmzWQqUnldap6qeawCmueYx3
	 Gyy/3DBb7KkCPxT/h7kqO5Aktxrl+lnr7hA0v6JV7nkVzOhWk/M5v2G1zgyqK1OhXO
	 0AH38jDw52qEbqYrQRApWnCa5/TI8QQGX/7Ty54XISH39/WTE8ZfxFDWagt4Eo9SxC
	 gT3g/cMf05A1g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVb3KglzST2;
	Thu, 19 Nov 2026 15:16:23 -0500 (EST)
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
Subject: [PATCH v8 33/33] selftests/sched: Test parameter changes in deadline_bw_test
Date: Thu, 19 Nov 2026 15:16:12 -0500
Message-Id: <0fc665302b04451f71d30fdaf87dd2b0fc754e34.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

Add the six cases of deadline_bw_test that test the fixes of parameter
changes, earlier in this series. In each, a task with runtime left
changes its parameters, or comes back to the class with new ones:
- a running task that leaves the class and comes back at once
- a running or sleeping task that shrinks its reservation, to an
  implicit or a constrained deadline
- a boosted task that changes its parameters, which the deboost then
  checks

The comment above each case gives its scenario.

On v7.4-rc2, in 8 VMs of 8 CPUs, five of these cases fail in every VM:
- change_boosted_new_params
- change_constrained_new_params
- change_running_new_params
- return_running_new_params
- wake_constrained_new_params

deboost_new_params_reboost passes there and with the first series.
There, a task made SCHED_DEADLINE while it waits on a PI mutex keeps a
deadline of 0. So the case passes without the deboost it was written
for, until "sched/deadline: Start a period for a task that enters the
class blocked".

With the whole series, every case passes wherever it runs, PREEMPT_RT
included. The isolcpus cases ran in guests booted with
isolcpus=domain,1,2 or isolcpus=domain,0,1. No kernel warning is
logged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 447 ++++++++++++++++--
 1 file changed, 413 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index fe63c8f093e7..1e9d2a9c90f6 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -283,6 +283,20 @@ static int set_deadline(pid_t tid, uint64_t runtime, uint64_t period)
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
@@ -2221,17 +2235,30 @@ static _Atomic pid_t ret_tid;
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
@@ -2240,8 +2267,34 @@ static void *returner(void *arg)
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
@@ -2251,46 +2304,80 @@ static void *returner(void *arg)
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
@@ -2306,6 +2393,292 @@ static int return_asleep_new_params(void)
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
+static sem_t rb_donor_go;
+static atomic_int rb_abort, rb_donor_locking, rb_donor_done, rb_waiter_locking;
+static _Atomic pid_t rb_waiter_tid;
+static _Atomic long long rb_spin_ns;
+
+/*
+ * Run as the owner O of deboost_new_params_reboost(). Its comment has the
+ * steps. Store in rb_spin_ns the time that O's last spin of 20ms takes.
+ * Return NULL, or 1 on an error.
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
+	err = set_deadline(rb_waiter_tid, 2 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		goto out;
+	}
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, PERIOD);
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
+	spin_ns(20 * NSEC_PER_MSEC);
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
+	} else if (ret == KSFT_PASS && rb_spin_ns > PERIOD / 2) {
+		ksft_print_msg("the spin took %lld ms: not boosted again\n",
+			       rb_spin_ns / (long long)NSEC_PER_MSEC);
+		ret = KSFT_FAIL;
+	}
+out_fini:
+	sem_destroy(&rb_donor_go);
+	pi_fini();
+	return ret;
+}
+
 static pthread_mutex_t pi_lock2;
 static sem_t holder_go;
 static atomic_int holder_holds, chain_waits, donor_done, x_waits, l2_takes;
@@ -10369,7 +10742,13 @@ static const struct p_case {
 	{ "deboost_after_donor_refill", deboost_after_donor_refill, MEASURED_IN_P },
 	{ "deboost_out_after_donor_refill", deboost_out_after_donor_refill, MEASURED_IN_P },
 	{ "deboost_keeps_own_runtime", deboost_keeps_own_runtime, MEASURED_IN_P },
+	{ "return_running_new_params", return_running_new_params, MEASURED_IN_P },
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
+	{ "change_running_new_params", change_running_new_params, MEASURED_IN_P },
+	{ "change_boosted_new_params", change_boosted_new_params, MEASURED_IN_P },
+	{ "change_constrained_new_params", change_constrained_new_params, MEASURED_IN_P },
+	{ "wake_constrained_new_params", wake_constrained_new_params, MEASURED_IN_P },
+	{ "deboost_new_params_reboost", deboost_new_params_reboost, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
 	{ "setattr_blocked_keeps_order", setattr_blocked_keeps_order, MEASURED_IN_P },
 	{ "boost_blocked_keeps_order", boost_blocked_keeps_order, MEASURED_IN_P },
-- 
2.47.3

