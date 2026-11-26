Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655362;
	b=D4lIkW8jux0WFEQhbuAEyi5ZwJuqX9EP4F0bJK5jwCf7nRCIWvtIC6XkC/pRO9wTC61k
	 54KtWeTjrDUZNUAWXsE+pWmWEVPybEaHCLCOJ93zpCBON7BOCEJ4t0fEFHVCUU22PFiSj
	 LJr5xnnNYREq3afip1If0eilcHvd5g8ctn791aPslX1Bg/1XxAWk0ZB7EuL9IC9p1VWv1
	 H5WOKa+BEXEm5oBbuRFRXb0E++c2q+9ebAsvSvTXywCRCu/HJf6i5dOH1HtE3pC/q9dd7
	 rioaiXQphXc3URQ0cF2IfEaqIH5MUHFmMg6Is7nGh4XjmspDYhrH6OaAD6RVUFmmQBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655362;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kgsIwVM2pF3+zO0IwTsXCdFjBZYIrUD1S7z8LQowEYg=;
	b=U2znClg9ROPEHCOdabSDEcwk5lDRyLt891zZK56Zg3Y9MPTjqT3M3mIrvD7O59MJRN9B
	 NMaMtO6DLBV+l01Fd3EXgHMWIsqGIAEgYGR7/75UAQfA2fHnmow3mJf/aSscoxZVq6Soy
	 3Hq2l9EQn+g/4PLDAR6Jqn63378IGFqJd92PFrUwPPMmkeP29zjHdloHkxV3JvvBpMSJU
	 LWuff6IFvhj1byQlAzjKsICOF+T8haIuw6533DeHNqDfwmfvgsBF7DODzWMQ7IhKEzKA1
	 gmUPtyjidhhyDNAp+6tGLHz/Vj+YavIyyuO/OQ+aXKh9UU3m76Z1ixC+EXl9vXABEcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=aMq+hsOW;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36126606B75F;
	Thu, 26 Nov 2026 01:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36126606B75F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=aMq+hsOW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655359;
	bh=kgsIwVM2pF3+zO0IwTsXCdFjBZYIrUD1S7z8LQowEYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMq+hsOW1iDND83Qr8Utdz7MHhJh1Z9MKGhMj4HwTQNr/S+9katClk6E+og3XbxTe
	 TBE1aTUe1RLz83q30d6JnCmMcNLaFyEM3GBuHBrh2Q0Q3+pxqdUuEOEeiAz1GTN6Ao
	 mLFeBPwdRcPzI28ptgkPLnNT5Y8XX14ZUL3tCEXorSQO9Rh8GKITbiOJyVmDTBnVf+
	 9gfBZ9fHCHRxqA+gxB41I6SNgo18CispDTKykdGmVbfYGFoCczw7B/0Bj17280gVSJ
	 BN4A7REMuZSqYxEBwnEu5SxgFr3rVSmNU39w5Gmj3EyCJHnG+Xwkku+qOmp8yzAB6x
	 tR4dkJ5GINB7A==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjp47VQzWx8;
	Wed, 25 Nov 2026 20:09:18 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v11 42/43] selftests/sched: Test parameter changes in deadline_bw_test
Date: Wed, 25 Nov 2026 20:08:41 -0500
Message-ID: <f4340ebcf4ff6e789ad8c5272eb798b3180265d4.1795646915.git.mathieu.desnoyers@efficios.com>
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

Add 39 cases to deadline_bw_test, for the fixes earlier in this series.
The comment above each case gives its scenario:
- In 24 cases, a task with runtime left changes its parameters, or
  comes back to the class with new ones. In params_swap_overload, two
  tasks pass a large runtime back and forth. This is Example 1 of Tang,
  Anderson and Abeni (RTNS 2021).
- In 11 cases, a lock owner cannot run on its own reservation, so a
  deadline waiter must boost it. In pi_owner_runs_out_later,
  pi_owner_wakes_in_gap_later and pi_owner_handed_off, the owner loses
  its reservation after the waiter blocked. In pi_owner_reboost_loop
  and pi_owners_reboost_loop, a waiter boosts a throttled owner over and
  over. Another deadline task must still get its runtime.
- In 4 cases, a constrained task leaves the class in its gap and comes
  back. The gap is the time between its deadline and its next period.

These cases fail on v7.4-rc2, in each of two VMs of 8 CPUs. In the
series, each one fails at the patch before the fix named, and passes
from that fix on:
- "sched/deadline: Cap the runtime left of a constrained task at
  dl_runtime": wake_constrained_new_params.
- "sched/deadline: Check the runtime of a task that comes back
  runnable": return_running_new_params.
- "sched/deadline: Keep the debt of a task across a change of
  parameters": change_running_new_params, change_boosted_new_params,
  constrained_gap_change_running, change_constrained_new_params,
  setattr_blocked_new_period, period_grown_untouched,
  deadline_widened_asleep, period_shrunk_throttled,
  period_shrunk_throttled_started, runtime_raised_waited,
  deboost_out_new_params and params_swap_overload.
- "sched/deadline: Boost an owner that cannot run on its own
  reservation": pi_owner_asleep_in_gap, pi_owner_throttled,
  pi_owner_throttled_asleep and pi_owner_held_new_params.
- "sched/deadline: Boost an owner throttled after its waiter blocked":
  pi_owner_runs_out_later, pi_owner_wakes_in_gap_later and
  pi_owner_handed_off.

These cases pass on v7.4-rc2 and with the whole series. A wrong
version of the fix named would fail them:
- "sched/deadline: Keep the debt of a task across a change of
  parameters": deboost_asleep_new_params, setattr_blocked_reenter,
  deadline_grows_running, period_shrunk_running, period_grown_running,
  params_flip_no_gain, period_shrunk_no_burst,
  wake_after_deadline_shrunk and constrained_after_job.
- "sched/deadline: Boost an owner that cannot run on its own
  reservation": pi_owner_throttled_rival, pi_owner_held_long,
  pi_owner_reboost_loop and pi_owners_reboost_loop. In the series
  before that fix, pi_owner_throttled_rival failed in some runs. The
  last two failed on an earlier version of the fix, in which each boost
  started a new period of the waiter.

deboost_new_params_reboost passes on v7.4-rc2, and at each patch of
this series. On v7.4-rc2, a task made SCHED_DEADLINE while it waits on a
PI mutex keeps a deadline of 0. So it boosts the owner in any case.
From "sched/deadline: Start a period for a task that enters the class
blocked" on, that task gets a real deadline. The case then checks the
deboost of "sched/deadline: Keep the debt of a task across a change of
parameters". The debt moves the owner's deadline after the waiter's.
The deboost must then boost the owner again.

The four reenter_*_in_gap cases pass on v7.4-rc2. On the first
series, they fail from these patches on:
- "sched/deadline: Reset the deadline and the runtime with the
  parameters": reenter_runnable_in_gap.
- "sched/deadline: Release the bandwidth of a task that leaves the class
  asleep": reenter_asleep_in_gap, reenter_asleep_late_in_gap and
  reenter_pi_blocked_in_gap.
Three of them pass from "sched/deadline: Count the 0-lag time from the
next period" on. reenter_asleep_late_in_gap passes from
"sched/deadline: Keep a departing constrained task until its next
period" on.

The cases run in P, a one-CPU partition root. The harness now waits
after each case, for up to 10s. It waits until the total_bw of P's CPU
comes back down to its value before the case. A task of a case can keep
its bandwidth counted after it exits, until its 0-lag time.
params_swap_overload leaves a debt that takes seconds to repay.
random_mix runs right after it. Without the wait, random_mix failed in
most runs: the this_bw it read dropped when that debt was repaid.

With the whole series, every case passes, PREEMPT_RT included. No
kernel warning is logged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 3645 ++++++++++++++++-
 1 file changed, 3608 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index 83dd8b4e79a3..78b58888e9d5 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -32,7 +32,9 @@
  *
  * The cases of p_cases[] run with P, a partition root of the last
  * housekeeping CPU. P is made anew for each case. Making it rebuilds the
- * accounting, which clears what an earlier case left.
+ * accounting, which clears what an earlier case leaked. A task that exits
+ * stays counted until its 0-lag time: run_p_cases() waits for that after
+ * each case.
  *
  * The cases of hp_cases[] run after them, without P. These are the
  * hotplug cases, and ten other cases: mask_out_refused,
@@ -58,6 +60,7 @@
 #include <fcntl.h>
 #include <limits.h>
 #include <pthread.h>
+#include <sys/klog.h>
 #include <sched.h>
 #include <semaphore.h>
 #include <signal.h>
@@ -284,6 +287,20 @@ static int set_deadline(pid_t tid, uint64_t runtime, uint64_t period)
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
@@ -2602,6 +2619,163 @@ static int deboost_in_asleep_after_refill(void)
 	return ret;
 }
 
+static sem_t nps_wake;
+static _Atomic pid_t nps_o_tid;
+static _Atomic uint64_t nps_t0;
+
+/*
+ * Run as the owner O of deboost_out_new_params(). Its comment has the
+ * steps. Return NULL, or 1 on an error.
+ */
+static void *nps_owner(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	nps_o_tid = gettid_();
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, PERIOD);
+	nps_t0 = now_ns();
+	if (err || take_pi_lock()) {
+		if (err)
+			ksft_print_msg("the owner refused as a deadline task: %s\n",
+				       strerror(-err));
+		sem_post(&inas_locked);
+		set_other(0);
+		return (void *)1;
+	}
+	sem_post(&inas_locked);
+	t0 = now_ns();
+	while (!inas_locking || proc_state_of(inas_d_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			ksft_print_msg("the donor did not block on the lock\n");
+			drop_pi_lock();
+			set_other(0);
+			return (void *)1;
+		}
+	}
+	spin_ns(4 * NSEC_PER_MSEC);
+	sem_wait_sig(&nps_wake);
+	drop_pi_lock();
+	set_other(0);
+	return NULL;
+}
+
+/*
+ * A boosted task changes its parameters before any refill, then leaves
+ * the class at its deboost. O and D share the CPU of P:
+ * 1. D becomes a deadline task of 2ms every 50ms, and waits.
+ * 2. O becomes a deadline task of 5ms every 100ms, at 0ms. It takes
+ *    pi_lock.
+ * 3. D waits 30ms for pi_lock. Its deadline is the earlier one: it boosts
+ *    O.
+ * 4. O runs 4ms, within its own runtime, and sleeps, boosted. Its 0-lag
+ *    time is at 100 - 1 * 100 / 5 = 80ms.
+ * 5. The main thread changes O to 5ms every 200ms, then switches O to
+ *    SCHED_OTHER. The boost keeps O in the class.
+ * 6. D times out at about 30ms. O leaves the class at its deboost.
+ *
+ * At the deboost, at 30ms, O has used 4ms. Its old bandwidth of 5% gave
+ * it 1.5ms by then. So O has a debt of 2.5ms. The new bandwidth of 2.5%
+ * repays that at 130ms. O's bandwidth must stay in total_bw until then.
+ * Mixing the runtime and the deadline of the old parameters with the new
+ * ones would put its 0-lag time at 200 - 1 * 200 / 5 = 160ms. The case
+ * reads total_bw at 115ms and at 145ms.
+ */
+static int deboost_out_new_params(void)
+{
+	long long base, with_o = -1, early = -1, late = -1;
+	void *o_ret = NULL, *d_ret = NULL;
+	int err, out = 0, ret = KSFT_FAIL;
+	pthread_t o, d;
+
+	if (total_bw_of(top_cpu(1)) < 0) {
+		ksft_print_msg("sched_debug tells of no total_bw\n");
+		return KSFT_SKIP;
+	}
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&inas_ready, 0, 0) || sem_init(&inas_locked, 0, 0) ||
+	    sem_init(&inas_out, 0, 0) || sem_init(&inas_read, 0, 0) ||
+	    sem_init(&nps_wake, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	inas_locking = 0;
+	inas_d_tid = 0;
+	nps_o_tid = 0;
+	if (pthread_create(&d, NULL, inas_donor, NULL)) {
+		ksft_print_msg("the donor thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&inas_ready, 5000)) {
+		sem_post(&inas_locked);
+		sem_post(&inas_read);
+		join(d);
+		goto out;
+	}
+	base = total_bw_of(top_cpu(1));	/* with D, without O */
+	if (pthread_create(&o, NULL, nps_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&inas_locked);
+		sem_post(&inas_read);
+		join(d);
+		goto out;
+	}
+	if (wait_for(1000, inas_locking && proc_state_of(inas_d_tid) == 'S' &&
+		     nps_o_tid && proc_state_of(nps_o_tid) == 'S')) {
+		ksft_print_msg("the owner did not sleep boosted\n");
+	} else {
+		err = set_deadline(nps_o_tid, 5 * NSEC_PER_MSEC, 2 * PERIOD);
+		if (!err)
+			with_o = total_bw_of(top_cpu(1));
+		if (!err)
+			err = set_other(nps_o_tid);
+		if (!err && sem_getvalue(&inas_out, &out))
+			out = -1;
+		if (err)
+			ksft_print_msg("the owner cannot change its parameters: %s\n",
+				       strerror(-err));
+		else if (out)
+			ksft_print_msg("the donor timed out before the change\n");
+		else if (sem_wait_for(&inas_out, 5000))
+			ksft_print_msg("the donor did not time out\n");
+		else {
+			while (now_ns() - nps_t0 < 115 * NSEC_PER_MSEC)
+				sleep_ns(NSEC_PER_MSEC);
+			early = total_bw_of(top_cpu(1));
+			while (now_ns() - nps_t0 < 145 * NSEC_PER_MSEC)
+				sleep_ns(NSEC_PER_MSEC);
+			late = total_bw_of(top_cpu(1));
+		}
+	}
+	sem_post(&inas_read);
+	pthread_join(d, &d_ret);
+	sem_post(&nps_wake);
+	pthread_join(o, &o_ret);
+	if (o_ret || d_ret || late < 0)
+		goto out;	/* a thread said why */
+	if (early != with_o) {
+		ksft_print_msg("total_bw %lld at 115 ms, %lld expected: %s\n", early,
+			       with_o, "O left before it repaid its debt");
+		goto out;
+	}
+	if (late != base) {
+		ksft_print_msg("total_bw %lld at 145 ms, %lld expected: %s\n", late,
+			       base, "O stayed after it repaid its debt");
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&inas_ready);
+	sem_destroy(&inas_locked);
+	sem_destroy(&inas_out);
+	sem_destroy(&inas_read);
+	sem_destroy(&nps_wake);
+	pi_fini();
+	return ret;
+}
+
 static _Atomic uint32_t rq_cond, rq_pi;
 static atomic_int rq_order, rq_w_rank, rq_x_rank, rq_x_locking;
 static _Atomic pid_t rq_w_tid, rq_x_tid;
@@ -2754,17 +2928,30 @@ static _Atomic pid_t ret_tid;
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
@@ -2773,8 +2960,34 @@ static void *returner(void *arg)
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
@@ -2784,46 +2997,80 @@ static void *returner(void *arg)
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
+	void *t_ret = NULL, *d_ret = NULL;
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
@@ -2839,6 +3086,3008 @@ static int return_asleep_new_params(void)
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
+ * 1. T makes itself a deadline task of 10ms every 100ms, at 0ms. Its
+ *    deadline is 100ms. It runs 1ms, and sleeps until 110ms.
+ * 2. At 105ms, the main thread changes T to 10ms in 20ms, every 100ms.
+ * 3. T wakes up at 110ms.
+ *
+ * T's job ran. It counts as a job of the new parameters with the same
+ * deadline, released at 100 - 20 = 80ms. So T's next period starts at
+ * 80 + 100 = 180ms, and T runs then. A new period at the wakeup would
+ * start only 30ms after the release of the job that ran. That is less
+ * than a period of the new parameters. The case fails if T runs before
+ * 170ms or at 200ms or later.
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
+	if (shrink_back_ms < 170 || shrink_back_ms >= 200) {
+		ksft_print_msg("T ran again at %lld ms, not at 180\n",
+			       (long long)shrink_back_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&shrink_ready);
+	return ret;
+}
+
+static sem_t widen_ready;
+static _Atomic pid_t widen_tid;
+static _Atomic unsigned long long widen_t0;
+static _Atomic long long widen_used_us;
+
+/*
+ * Run as T of deadline_widened_asleep(). Its comment has the steps.
+ * Store in widen_used_us the CPU time that T gets from 30ms to 95ms.
+ * Return NULL, or 1 on an error.
+ */
+static void *widen_t(void *arg)
+{
+	struct timespec ts;
+	uint64_t t0, end, cpu0;
+	int err;
+
+	widen_tid = gettid_();
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, PERIOD);
+	t0 = now_ns();
+	widen_t0 = t0;
+	sem_post(&widen_ready);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(8 * NSEC_PER_MSEC);
+	end = t0 + 30 * NSEC_PER_MSEC;
+	ts.tv_sec = end / NSEC_PER_SEC;
+	ts.tv_nsec = end % NSEC_PER_SEC;
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+	cpu0 = thread_time_ns();
+	while (now_ns() < t0 + 95 * NSEC_PER_MSEC)
+		;
+	widen_used_us = (thread_time_ns() - cpu0) / NSEC_PER_USEC;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Widen the relative deadline of a task asleep in its period:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 100ms, at 0ms. It
+ *    spins 8ms and sleeps until 30ms.
+ * 2. At 25ms, the main thread changes T to 10ms every 100ms. T's deadline
+ *    is now 100ms. It has 2ms of runtime left.
+ * 3. T wakes up at 30ms and spins until 95ms.
+ *
+ * T must get about its 2ms left before 100ms. If its deadline stayed at
+ * 20ms, it would have passed at the wakeup. T would then get a new period
+ * of 10ms. The case fails if T gets 5ms of CPU time or more.
+ */
+static int deadline_widened_asleep(void)
+{
+	void *t_ret = NULL;
+	int err, ret = KSFT_FAIL;
+	uint64_t at;
+	pthread_t t;
+
+	if (sem_init(&widen_ready, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	widen_used_us = -1;
+	if (pthread_create(&t, NULL, widen_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&widen_ready, 5000)) {
+		join(t);
+		goto out;
+	}
+	at = widen_t0 + 25 * NSEC_PER_MSEC;
+	while (now_ns() < at)
+		sleep_ns(NSEC_PER_MSEC);
+	if (proc_state_of(widen_tid) != 'S') {
+		ksft_print_msg("T is not asleep at 25ms\n");
+		join(t);
+		goto out;
+	}
+	err = set_deadline(widen_tid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("T could not change asleep: %s\n", strerror(-err));
+		join(t);
+		goto out;
+	}
+	pthread_join(t, &t_ret);
+	if (t_ret || widen_used_us < 0)
+		goto out;	/* T said why */
+	if (widen_used_us >= 5000) {
+		ksft_print_msg("T got %lld us before its deadline, with 2ms left\n",
+			       (long long)widen_used_us);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&widen_ready);
+	return ret;
+}
+
+/*
+ * The kernel prints this when a refill finds a deadline long passed. It
+ * prints it once per boot, so a case can see it only if no earlier test
+ * caused it.
+ */
+#define DL_LAG_MSG	"sched: DL replenish lagged too much"
+
+/*
+ * Return 1 if the kernel log holds @s, 0 if it does not, or -1 if it
+ * cannot be read.
+ */
+static int klog_has(const char *s)
+{
+	int len = klogctl(10, NULL, 0);		/* SYSLOG_ACTION_SIZE_BUFFER */
+	char *buf;
+	int n, ret;
+
+	if (len <= 0)
+		return -1;
+	buf = malloc(len + 1);
+	if (!buf)
+		return -1;
+	n = klogctl(3, buf, len);		/* SYSLOG_ACTION_READ_ALL */
+	ret = -1;
+	if (n >= 0) {
+		buf[n] = '\0';
+		ret = !!strstr(buf, s);
+	}
+	free(buf);
+	return ret;
+}
+
+static sem_t shorten_ready;
+static _Atomic pid_t shorten_tid;
+static _Atomic unsigned long long shorten_t0;
+static _Atomic long long shorten_back_ms;
+
+/*
+ * Run as T of period_shrunk_throttled(). Its comment has the steps. Store
+ * in shorten_back_ms the time at which T runs after its yield. Return
+ * NULL, or 1 on an error.
+ */
+static void *shorten_t(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	shorten_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	t0 = now_ns();
+	shorten_t0 = t0;
+	sem_post(&shorten_ready);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(8 * NSEC_PER_MSEC);
+	sched_yield();
+	shorten_back_ms = (now_ns() - t0) / NSEC_PER_MSEC;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Shorten the period of a task throttled until its next period:
+ * 1. T becomes a deadline task of 10ms every 100ms, at 0ms. It runs 8ms
+ *    and yields. Its replenishment timer is armed at 100ms.
+ * 2. At @at_ms, the main thread changes T to 10ms every @period_ms.
+ *
+ * T ran ahead of its share: its 0-lag time is at 80ms. The change keeps
+ * that debt, and repays it at the new bandwidth. T's next period starts
+ * once it is repaid. The timer must be armed again there. T must run
+ * again at @back_ms: the case fails 5ms before it, or 30ms after it. A
+ * refill at 100ms would also find a period that ended before, and print
+ * "sched: DL replenish lagged too much". The case fails if that message
+ * is logged. It skips if the message was logged before: the kernel prints
+ * it once.
+ */
+static int shorten_case(int at_ms, int period_ms, int back_ms)
+{
+	void *t_ret = NULL;
+	int err, had, ret = KSFT_FAIL;
+	uint64_t at;
+	pthread_t t;
+
+	had = klog_has(DL_LAG_MSG);
+	if (had) {
+		ksft_print_msg(had < 0 ? "the kernel log cannot be read\n" :
+			       "the lag message was logged before this case\n");
+		return KSFT_SKIP;
+	}
+	if (sem_init(&shorten_ready, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	shorten_back_ms = -1;
+	if (pthread_create(&t, NULL, shorten_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&shorten_ready, 5000)) {
+		join(t);
+		goto out;
+	}
+	at = shorten_t0 + at_ms * NSEC_PER_MSEC;
+	while (now_ns() < at)
+		sleep_ns(NSEC_PER_MSEC);
+	err = set_deadline(shorten_tid, 10 * NSEC_PER_MSEC, period_ms * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("T could not change throttled: %s\n", strerror(-err));
+		join(t);
+		goto out;
+	}
+	pthread_join(t, &t_ret);
+	if (t_ret || shorten_back_ms < 0)
+		goto out;	/* T said why */
+	if (shorten_back_ms < back_ms - 5 || shorten_back_ms >= back_ms + 30) {
+		ksft_print_msg("T ran again at %lld ms, not at its next period at %d\n",
+			       (long long)shorten_back_ms, back_ms);
+		goto out;
+	}
+	if (klog_has(DL_LAG_MSG) == 1) {
+		ksft_print_msg("the refill logged \"%s\"\n", DL_LAG_MSG);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&shorten_ready);
+	return ret;
+}
+
+/*
+ * Shorten the period of a throttled task: shorten_case() with a change at
+ * 30ms to a period of 50ms. T then owes 5ms, repaid at 20% in 25ms. T
+ * must run again at 55ms.
+ */
+static int period_shrunk_throttled(void)
+{
+	return shorten_case(30, 50, 55);
+}
+
+/*
+ * Shorten the period of a throttled task, later in its period:
+ * shorten_case() with a change at 60ms to a period of 20ms. T then owes
+ * 2ms, repaid at 50% in 4ms. T must run again at 64ms.
+ */
+static int period_shrunk_throttled_started(void)
+{
+	return shorten_case(60, 20, 64);
+}
+
+/* The kinds of period_rule_case() */
+enum { PR_SHRUNK, PR_GROWN, PR_UNTOUCHED, PR_RAISED };
+
+static sem_t pr_h_ready, pr_h_go;
+static atomic_int pr_h_err;
+static int pr_kind;
+static _Atomic long long pr_pre_cpu_ms, pr_mark_ms, pr_done_ms;
+
+/*
+ * Run as H of period_rule_case(). Become a deadline task with a deadline
+ * earlier than T's, and wait for pr_h_go. Then keep the CPU: 5ms with
+ * PR_UNTOUCHED, 60ms with PR_RAISED. Return NULL, or 1 on an error.
+ */
+static void *pr_h(void *arg)
+{
+	int err;
+
+	if (pr_kind == PR_UNTOUCHED)
+		err = set_constrained(0, 6 * NSEC_PER_MSEC, 10 * NSEC_PER_MSEC, PERIOD);
+	else
+		err = set_constrained(0, 62 * NSEC_PER_MSEC, 65 * NSEC_PER_MSEC, PERIOD);
+	pr_h_err = err;
+	sem_post(&pr_h_ready);
+	if (err) {
+		ksft_print_msg("H refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	sem_wait_sig(&pr_h_go);
+	spin_ns((pr_kind == PR_UNTOUCHED ? 5 : 60) * NSEC_PER_MSEC);
+	if (set_other(0))
+		ksft_print_msg("H cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as T of period_rule_case(). The comments of the cases have the
+ * steps. Store the times of T's marks in pr_mark_ms and pr_done_ms, and
+ * the CPU time T used before its change in pr_pre_cpu_ms. Return NULL, or
+ * 1 on an error.
+ */
+static void *pr_t(void *arg)
+{
+	uint64_t ms = NSEC_PER_MSEC, t0, c0;
+	int err;
+
+	if (pr_kind == PR_RAISED)
+		err = set_deadline(0, 10 * ms, PERIOD);
+	else
+		err = set_constrained(0, 10 * ms, 20 * ms,
+				      pr_kind == PR_SHRUNK ? PERIOD : PERIOD / 2);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		sem_post(&pr_h_go);
+		return (void *)1;
+	}
+	t0 = now_ns();
+	c0 = thread_time_ns();
+	switch (pr_kind) {
+	case PR_SHRUNK:
+	case PR_GROWN:
+		spin_ns(3 * ms);
+		break;
+	case PR_UNTOUCHED:
+		/* H preempts T here, for 5ms. */
+		sem_post(&pr_h_go);
+		while (now_ns() - t0 < 4 * ms)
+			;
+		break;
+	case PR_RAISED:
+		spin_ns(2 * ms);
+		/* H preempts T here, for 60ms. */
+		sem_post(&pr_h_go);
+		while (now_ns() - t0 < 55 * ms)
+			;
+		break;
+	}
+	pr_pre_cpu_ms = (thread_time_ns() - c0) / ms;
+	if (pr_kind == PR_RAISED)
+		err = set_deadline(0, 15 * ms, PERIOD);
+	else
+		err = set_constrained(0, 10 * ms, 20 * ms,
+				      pr_kind == PR_SHRUNK ? PERIOD / 2 : PERIOD);
+	if (err) {
+		ksft_print_msg("T could not change: %s\n", strerror(-err));
+		set_other(0);
+		return (void *)1;
+	}
+	switch (pr_kind) {
+	case PR_SHRUNK:
+		spin_ns(9 * ms);
+		break;
+	case PR_GROWN:
+		spin_ns(4 * ms);
+		pr_mark_ms = (now_ns() - t0) / ms;
+		spin_ns(5 * ms);
+		break;
+	case PR_UNTOUCHED:
+		spin_ns(9 * ms);
+		break;
+	case PR_RAISED:
+		spin_ns(12 * ms);
+		break;
+	}
+	pr_done_ms = (now_ns() - t0) / ms;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run a case where T changes its own parameters while it runs. P has one
+ * CPU. With PR_UNTOUCHED and PR_RAISED, a deadline task H first keeps T
+ * off the CPU: H has the earlier deadline. So T has more runtime left than
+ * a wakeup at that time would give it. H sleeps more than its period
+ * before T wakes it: its wakeup then starts a new period.
+ */
+static int period_rule_case(int kind)
+{
+	int with_h = kind == PR_UNTOUCHED || kind == PR_RAISED;
+	void *h_ret = NULL, *t_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t h, t;
+
+	if (sem_init(&pr_h_ready, 0, 0) || sem_init(&pr_h_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	pr_kind = kind;
+	pr_pre_cpu_ms = -1;
+	pr_mark_ms = -1;
+	pr_done_ms = -1;
+	if (with_h) {
+		if (pthread_create(&h, NULL, pr_h, NULL)) {
+			ksft_print_msg("the H thread could not start\n");
+			goto out;
+		}
+		if (sem_wait_for(&pr_h_ready, 5000) || pr_h_err) {
+			sem_post(&pr_h_go);
+			join(h);
+			goto out;	/* H said why */
+		}
+		sleep_ns(PERIOD + 10 * NSEC_PER_MSEC);
+	}
+	if (pthread_create(&t, NULL, pr_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		t_ret = (void *)1;
+	} else {
+		pthread_join(t, &t_ret);
+	}
+	if (with_h) {
+		sem_post(&pr_h_go);	/* if T never woke H */
+		pthread_join(h, &h_ret);
+	}
+	if (t_ret || h_ret || pr_done_ms < 0)
+		goto out;	/* the thread said why */
+	switch (kind) {
+	case PR_SHRUNK:
+		if (pr_done_ms < 45 || pr_done_ms >= 80) {
+			ksft_print_msg("T ended at %lld ms: its next period is at 50\n",
+				       (long long)pr_done_ms);
+			goto out;
+		}
+		break;
+	case PR_GROWN:
+		if (pr_mark_ms >= 30) {
+			ksft_print_msg("T used 7ms of its runtime by %lld ms\n",
+				       (long long)pr_mark_ms);
+			goto out;
+		}
+		if (pr_done_ms < 95 || pr_done_ms >= 130) {
+			ksft_print_msg("T ended at %lld ms: its next period is at 100\n",
+				       (long long)pr_done_ms);
+			goto out;
+		}
+		break;
+	case PR_UNTOUCHED:
+		if (pr_pre_cpu_ms > 2) {
+			ksft_print_msg("T used %lld ms before its change: H did not delay it\n",
+				       (long long)pr_pre_cpu_ms);
+			goto out;
+		}
+		if (pr_done_ms < 95 || pr_done_ms >= 130) {
+			ksft_print_msg("T ended at %lld ms: its next period is at 100\n",
+				       (long long)pr_done_ms);
+			goto out;
+		}
+		break;
+	case PR_RAISED:
+		if (pr_pre_cpu_ms > 6) {
+			ksft_print_msg("T used %lld ms before its change: H did not delay it\n",
+				       (long long)pr_pre_cpu_ms);
+			goto out;
+		}
+		if (pr_done_ms < 110 || pr_done_ms >= 140) {
+			ksft_print_msg("T ended at %lld ms: its next period is at about 115\n",
+				       (long long)pr_done_ms);
+			goto out;
+		}
+		break;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&pr_h_ready);
+	sem_destroy(&pr_h_go);
+	return ret;
+}
+
+/*
+ * Shorten the period of a running task:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 100ms, at 0ms. It
+ *    spins 3ms.
+ * 2. T changes its period to 50ms, and spins 9ms more. It runs out of
+ *    runtime at about 10ms.
+ *
+ * The period in progress keeps its start. So T's next period starts at
+ * 50ms, and T ends its spin at about 52ms. The case fails if T ends
+ * before 45ms, or at 80ms or later.
+ */
+static int period_shrunk_running(void)
+{
+	return period_rule_case(PR_SHRUNK);
+}
+
+/*
+ * Lengthen the period of a running task:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 50ms, at 0ms. It
+ *    spins 3ms.
+ * 2. T changes its period to 100ms, and spins 4ms more. It then spins
+ *    5ms more, and runs out of runtime at about 10ms.
+ *
+ * The job in progress keeps its deadline, at 20ms: T must end its first
+ * 7ms at once. T's next period starts at 100ms, and T ends at about
+ * 102ms. The case fails if T ends its first 7ms at 30ms or later, or if
+ * it ends before 95ms, or at 130ms or later.
+ */
+static int period_grown_running(void)
+{
+	return period_rule_case(PR_GROWN);
+}
+
+/*
+ * Lengthen the period of a task that has not run yet in its period:
+ * 1. H, a deadline task of 6ms in 10ms, every 100ms, sleeps.
+ * 2. T becomes a deadline task of 10ms in 20ms, every 50ms, at 0ms, and
+ *    wakes H. H has the earlier deadline. It runs for 5ms.
+ * 3. T runs from 5ms, with its 10ms of runtime and 15ms to its deadline.
+ *    It changes its period to 100ms, and spins 9ms.
+ *
+ * T keeps its job, with the runtime that the new density allows before
+ * its deadline: 10ms in 20ms over the 15ms left, 7.5ms. Its next period
+ * is its release plus the new period, at 100ms. T runs 7.5ms, waits, and
+ * ends at about 101ms. The case fails if T ends before 95ms, or at 130ms
+ * or later.
+ */
+static int period_grown_untouched(void)
+{
+	return period_rule_case(PR_UNTOUCHED);
+}
+
+/*
+ * Raise the runtime of a task late in its period:
+ * 1. H, a deadline task of 62ms in 65ms, every 100ms, sleeps.
+ * 2. T becomes a deadline task of 10ms every 100ms, at 0ms. It spins 2ms,
+ *    and wakes H. H has the earlier deadline. It runs for 60ms.
+ * 3. T runs from about 62ms, with 8ms left. It raises its runtime to
+ *    15ms, and spins 12ms.
+ *
+ * T used 2ms by 62ms, less than its share: it has no debt. It keeps its
+ * job and its 8ms. Its next period starts once those 8ms are paid at the
+ * new bandwidth, at about 115ms. T runs its 8ms, waits, and ends at about
+ * 119ms. The case fails if T ends before 110ms, or at 140ms or later.
+ */
+static int runtime_raised_waited(void)
+{
+	return period_rule_case(PR_RAISED);
+}
+
+static atomic_int flip_stop;
+static _Atomic pid_t flip_tid;
+static _Atomic long long flip_cpu_ms;
+static sem_t flip_ready;
+
+/*
+ * Run as T of params_flip_no_gain(). Become a deadline task of 10ms
+ * every 100ms, and spin until flip_stop. Store the CPU time used in
+ * flip_cpu_ms. Return NULL, or 1 on an error.
+ */
+static void *flip_t(void *arg)
+{
+	uint64_t c0;
+	int err;
+
+	flip_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	sem_post(&flip_ready);
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	c0 = thread_time_ns();
+	while (!flip_stop)
+		;
+	flip_cpu_ms = (thread_time_ns() - c0) / NSEC_PER_MSEC;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Flip the parameters of a task that never sleeps:
+ * 1. T becomes a deadline task of 10ms every 100ms, and spins.
+ * 2. For 500ms, the main thread changes T every 3ms: to 2ms every 20ms,
+ *    then back to 10ms every 100ms. Both are 10% of a CPU. P has one
+ *    CPU, so the main thread mostly runs while T is throttled.
+ *
+ * No change may give T runtime. T must get about 10% of the 500ms, plus
+ * its first 10ms. The case fails if T gets 90ms of CPU time or more, or
+ * if the kernel logs "sched: DL replenish lagged too much". It skips if
+ * that message was logged before: the kernel prints it once.
+ */
+static int params_flip_no_gain(void)
+{
+	void *t_ret = NULL;
+	int err = 0, had, i, ret = KSFT_FAIL;
+	uint64_t end;
+	pthread_t t;
+
+	had = klog_has(DL_LAG_MSG);
+	if (had) {
+		ksft_print_msg(had < 0 ? "the kernel log cannot be read\n" :
+			       "the lag message was logged before this case\n");
+		return KSFT_SKIP;
+	}
+	if (sem_init(&flip_ready, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	flip_stop = 0;
+	flip_cpu_ms = -1;
+	if (pthread_create(&t, NULL, flip_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&flip_ready, 5000)) {
+		flip_stop = 1;
+		join(t);
+		goto out;
+	}
+	end = now_ns() + 500 * NSEC_PER_MSEC;
+	for (i = 0; !err && now_ns() < end; i++) {
+		sleep_ns(3 * NSEC_PER_MSEC);
+		if (i & 1)
+			err = set_deadline(flip_tid, 10 * NSEC_PER_MSEC, PERIOD);
+		else
+			err = set_deadline(flip_tid, 2 * NSEC_PER_MSEC, PERIOD / 5);
+	}
+	flip_stop = 1;
+	pthread_join(t, &t_ret);
+	if (err) {
+		ksft_print_msg("T could not change: %s\n", strerror(-err));
+		goto out;
+	}
+	if (t_ret || flip_cpu_ms < 0)
+		goto out;	/* T said why */
+	if (flip_cpu_ms >= 90) {
+		ksft_print_msg("T got %lld ms of CPU time in 500ms, with 10%% of a CPU\n",
+			       (long long)flip_cpu_ms);
+		goto out;
+	}
+	if (klog_has(DL_LAG_MSG) == 1) {
+		ksft_print_msg("a refill logged \"%s\"\n", DL_LAG_MSG);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&flip_ready);
+	return ret;
+}
+
+static sem_t vic_b_ready, vic_go;
+static atomic_int vic_stop, vic_b_err;
+static _Atomic unsigned long long vic_t0;
+static _Atomic long long vic_b_done_ms;
+
+/*
+ * Run as B of period_shrunk_no_burst(). Become a deadline task of 40ms
+ * every 100ms, and wait for vic_go. Then spin 39ms, and store in
+ * vic_b_done_ms the time at which the spin ends. Return NULL, or 1 on an
+ * error.
+ */
+static void *vic_b(void *arg)
+{
+	int err = set_deadline(0, 40 * NSEC_PER_MSEC, PERIOD);
+
+	vic_b_err = err;
+	sem_post(&vic_b_ready);
+	if (err) {
+		ksft_print_msg("B refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	sem_wait_sig(&vic_go);
+	if (!vic_stop) {
+		spin_ns(39 * NSEC_PER_MSEC);
+		vic_b_done_ms = (now_ns() - vic_t0) / NSEC_PER_MSEC;
+	}
+	if (set_other(0))
+		ksft_print_msg("B cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as A of period_shrunk_no_burst(). Its comment has the steps. Return
+ * NULL, or 1 on an error.
+ */
+static void *vic_a(void *arg)
+{
+	int err = set_deadline(0, 40 * NSEC_PER_MSEC, PERIOD);
+
+	if (err) {
+		ksft_print_msg("A refused as a deadline task: %s\n", strerror(-err));
+		vic_stop = 1;
+		sem_post(&vic_go);
+		return (void *)1;
+	}
+	vic_t0 = now_ns();
+	sem_post(&vic_go);
+	spin_ns(39 * NSEC_PER_MSEC + NSEC_PER_MSEC / 2);
+	err = set_deadline(0, 400 * NSEC_PER_USEC, NSEC_PER_MSEC);
+	if (err)
+		ksft_print_msg("A could not change: %s\n", strerror(-err));
+	while (!vic_stop)
+		;
+	if (set_other(0))
+		ksft_print_msg("A cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * A task that used its runtime shortens its period, at the same
+ * bandwidth. P has one CPU:
+ * 1. B, a deadline task of 40ms every 100ms, sleeps for more than its
+ *    period.
+ * 2. A becomes a deadline task of 40ms every 100ms, at 0ms, and wakes B.
+ *    B's wakeup starts a period, with a deadline just after A's.
+ * 3. A spins 39.5ms. It then changes to 0.4ms every 1ms, and spins on.
+ * 4. B runs when A is throttled, and spins 39ms.
+ *
+ * A ran about 24ms ahead of its share. Repaid at its new bandwidth, that
+ * debt puts A's next period at about 99ms, and B ends at about 79ms. If the change gave A a
+ * period at once, A would run 0.4ms of every 1ms from 40ms, with
+ * deadlines before B's. B would end at about 105ms, after its deadline.
+ * The case fails if B ends at 95ms or later.
+ */
+static int period_shrunk_no_burst(void)
+{
+	void *a_ret = NULL, *b_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t a, b;
+
+	if (sem_init(&vic_b_ready, 0, 0) || sem_init(&vic_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	vic_stop = 0;
+	vic_b_done_ms = -1;
+	if (pthread_create(&b, NULL, vic_b, NULL)) {
+		ksft_print_msg("the B thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&vic_b_ready, 5000) || vic_b_err) {
+		vic_stop = 1;
+		sem_post(&vic_go);
+		join(b);
+		goto out;	/* B said why */
+	}
+	sleep_ns(PERIOD + 10 * NSEC_PER_MSEC);
+	if (pthread_create(&a, NULL, vic_a, NULL)) {
+		ksft_print_msg("the A thread could not start\n");
+		vic_stop = 1;
+		sem_post(&vic_go);
+		join(b);
+		goto out;
+	}
+	pthread_join(b, &b_ret);
+	vic_stop = 1;
+	pthread_join(a, &a_ret);
+	if (a_ret || b_ret || vic_b_done_ms < 0)
+		goto out;	/* the thread said why */
+	if (vic_b_done_ms >= 95) {
+		ksft_print_msg("B ended at %lld ms: A ran in new periods before 99ms\n",
+			       (long long)vic_b_done_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&vic_b_ready);
+	sem_destroy(&vic_go);
+	return ret;
+}
+
+static sem_t cmix_b_ready, cmix_go;
+static atomic_int cmix_stop, cmix_b_err;
+static _Atomic unsigned long long cmix_t0;
+static _Atomic long long cmix_b_done_ms;
+
+/*
+ * Run as B of constrained_after_job(). Become a deadline task of 150ms
+ * every 200ms, and wait for cmix_go. Then spin 148ms, and store in
+ * cmix_b_done_ms the time at which the spin ends. Return NULL, or 1 on an
+ * error.
+ */
+static void *cmix_b(void *arg)
+{
+	int err = set_deadline(0, 150 * NSEC_PER_MSEC, 200 * NSEC_PER_MSEC);
+
+	cmix_b_err = err;
+	sem_post(&cmix_b_ready);
+	if (err) {
+		ksft_print_msg("B refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	sem_wait_sig(&cmix_go);
+	if (!cmix_stop) {
+		spin_ns(148 * NSEC_PER_MSEC);
+		cmix_b_done_ms = (now_ns() - cmix_t0) / NSEC_PER_MSEC;
+	}
+	if (set_other(0))
+		ksft_print_msg("B cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as A of constrained_after_job(). Its comment has the steps. Return
+ * NULL, or 1 on an error.
+ */
+static void *cmix_a(void *arg)
+{
+	int err = set_deadline(0, 15 * NSEC_PER_MSEC, PERIOD);
+
+	if (err) {
+		ksft_print_msg("A refused as a deadline task: %s\n", strerror(-err));
+		cmix_stop = 1;
+		sem_post(&cmix_go);
+		return (void *)1;
+	}
+	cmix_t0 = now_ns();
+	sem_post(&cmix_go);
+	spin_ns(14 * NSEC_PER_MSEC + NSEC_PER_MSEC / 2);
+	err = set_constrained(0, 18 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC,
+			      120 * NSEC_PER_MSEC);
+	if (err)
+		ksft_print_msg("A could not change: %s\n", strerror(-err));
+	while (!cmix_stop)
+		;
+	if (set_other(0))
+		ksft_print_msg("A cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * A task that used most of its runtime moves to a constrained deadline,
+ * at the same bandwidth. P has one CPU:
+ * 1. B makes itself a deadline task of 150ms every 200ms. It sleeps for
+ *    more than its period.
+ * 2. A makes itself a deadline task of 15ms every 100ms, at 0ms, and
+ *    wakes B. A's deadline is 100ms. B's wakeup starts a period, with a
+ *    deadline at 200ms.
+ * 3. A spins 14.5ms. It then changes itself to 18ms in 20ms, every
+ *    120ms, and spins on.
+ * 4. A is throttled at 15ms, when its runtime runs out. B then runs, and
+ *    spins 148ms.
+ *
+ * A's job of the old parameters counts as a whole job of the new ones.
+ * It keeps its deadline of 100ms, so it counts as released at
+ * 100 - 20 = 80ms. A's next job then starts at 80 + 120 = 200ms, and B
+ * ends at about 163ms. If A's next job started at 120ms, its deadline at
+ * 140ms would come before B's. A would preempt B for 18ms, and B would
+ * end at about 181ms. The case fails if B ends at 172ms or later.
+ */
+static int constrained_after_job(void)
+{
+	void *a_ret = NULL, *b_ret = NULL;
+	int ret = KSFT_FAIL;
+	pthread_t a, b;
+
+	if (sem_init(&cmix_b_ready, 0, 0) || sem_init(&cmix_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	cmix_stop = 0;
+	cmix_b_done_ms = -1;
+	if (pthread_create(&b, NULL, cmix_b, NULL)) {
+		ksft_print_msg("the B thread could not start\n");
+		goto out;
+	}
+	if (sem_wait_for(&cmix_b_ready, 5000) || cmix_b_err) {
+		cmix_stop = 1;
+		sem_post(&cmix_go);
+		join(b);
+		goto out;	/* B said why */
+	}
+	sleep_ns(210 * NSEC_PER_MSEC);
+	if (pthread_create(&a, NULL, cmix_a, NULL)) {
+		ksft_print_msg("the A thread could not start\n");
+		cmix_stop = 1;
+		sem_post(&cmix_go);
+		join(b);
+		goto out;
+	}
+	pthread_join(b, &b_ret);
+	cmix_stop = 1;
+	pthread_join(a, &a_ret);
+	if (a_ret || b_ret || cmix_b_done_ms < 0)
+		goto out;	/* the thread said why */
+	if (cmix_b_done_ms >= 172) {
+		ksft_print_msg("B ended at %lld ms: A's next job came before 200ms\n",
+			       (long long)cmix_b_done_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&cmix_b_ready);
+	sem_destroy(&cmix_go);
+	return ret;
+}
+
+static _Atomic long long grow_back_ms;
+
+/*
+ * Run as T of deadline_grows_running(). Its comment has the steps. Store
+ * in grow_back_ms how late T runs after its sleep. Return NULL, or 1 on
+ * an error.
+ */
+static void *grow_t(void *arg)
+{
+	struct timespec ts;
+	uint64_t end;
+	int err;
+
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, PERIOD);
+	if (!err) {
+		sched_yield();
+		err = set_constrained(0, 10 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC,
+				      PERIOD);
+	}
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		set_other(0);
+		return (void *)1;
+	}
+	sched_yield();
+	end = now_ns() + 30 * NSEC_PER_MSEC;
+	ts.tv_sec = end / NSEC_PER_SEC;
+	ts.tv_nsec = end % NSEC_PER_SEC;
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+	grow_back_ms = (now_ns() - end) / NSEC_PER_MSEC;
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Lengthen the relative deadline of a task that its replenishment timer
+ * refills:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 100ms, and yields.
+ *    The timer refills it at the start of its next period.
+ * 2. T changes itself to 10ms in 50ms, every 100ms, and yields again.
+ * 3. The timer refills T at the start of its next period. T then sleeps
+ *    30ms. It wakes up before its new deadline, 50ms into the period.
+ *
+ * T must run at once. With the old relative deadline, its deadline would
+ * be 20ms into the period, and the wakeup would throttle T until the next
+ * period. The case fails if T runs 20ms or more after its wakeup.
+ */
+static int deadline_grows_running(void)
+{
+	void *t_ret = NULL;
+	pthread_t t;
+
+	grow_back_ms = -1;
+	if (pthread_create(&t, NULL, grow_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		return KSFT_FAIL;
+	}
+	pthread_join(t, &t_ret);
+	if (t_ret || grow_back_ms < 0)
+		return KSFT_FAIL;	/* T said why */
+	if (grow_back_ms >= 20) {
+		ksft_print_msg("T ran %lld ms after its wakeup\n",
+			       (long long)grow_back_ms);
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
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
+/*
+ * Return the absolute deadline of the deadline task @tid, in ns of the rq
+ * clock, from dl.deadline in /proc/<tid>/sched. Return -1 if it cannot be
+ * read.
+ */
+static long long dl_deadline_of(pid_t tid)
+{
+	char path[64], line[256];
+	long long d = -1;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%d/sched", tid);
+	f = fopen(path, "r");
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f)) {
+		char *val = strchr(line, ':');
+
+		if (!strncmp(line, "dl.deadline", 11) && val) {
+			d = atoll(val + 1);
+			break;
+		}
+	}
+	fclose(f);
+	return d;
+}
+
+/* Milliseconds from @from to @to, both from now_ns(). */
+#define MS_FROM(from, to)	((long long)((int64_t)((to) - (from)) / (int64_t)NSEC_PER_MSEC))
+
+static _Atomic uint32_t rb2_pi;
+static atomic_int rb2_t_locking;
+static _Atomic pid_t rb2_t_tid;
+static _Atomic uint64_t rb2_t_start, rb2_t_got;
+
+/*
+ * Run as T of reenter_pi_blocked_in_gap(). Become a deadline task of 10ms
+ * in 20ms, every 500ms. Spin 2ms of CPU time, then take rb2_pi with
+ * FUTEX_LOCK_PI. Once T holds it, store the time and unlock. Return NULL,
+ * or 1 on an error.
+ */
+static void *rb2_t(void *arg)
+{
+	uint32_t tid = gettid_();
+	int err;
+
+	rb2_t_tid = tid;
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	rb2_t_start = now_ns();
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		rb2_t_locking = -1;
+		return (void *)1;
+	}
+	spin_ns(2 * NSEC_PER_MSEC);
+	rb2_t_locking = 1;
+	if (syscall(SYS_futex, &rb2_pi, FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG,
+		    0, NULL, NULL, 0)) {
+		ksft_print_msg("FUTEX_LOCK_PI: %s\n", strerror(errno));
+		set_other(0);
+		return (void *)1;
+	}
+	rb2_t_got = now_ns();
+	if (!atomic_compare_exchange_strong(&rb2_pi, &tid, 0))
+		syscall(SYS_futex, &rb2_pi, FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG,
+			0, NULL, NULL, 0);
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * A task blocked on an rt_mutex leaves the deadline class in its
+ * constrained gap and comes back. The main thread holds the PI futex
+ * rb2_pi. P has one CPU:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 500ms, at 0ms. It
+ *    spins 2ms and blocks on rb2_pi. Its deadline is 20ms.
+ * 2. At 40ms, T is past its deadline and before its next period, at
+ *    500ms. The main thread switches T to SCHED_OTHER, then back to
+ *    SCHED_DEADLINE with the same parameters. T still waits on rb2_pi.
+ * 3. At about 45ms, the main thread unlocks rb2_pi.
+ *
+ * T used 2ms of its 10ms. Past its deadline, it gets no more runtime in
+ * that period: a wakeup would throttle it until 500ms. Leaving the class
+ * and coming back must not give it a new period before then. The case
+ * fails if T gets rb2_pi before 490ms.
+ */
+static int reenter_pi_blocked_in_gap(void)
+{
+	long long dl_gap = -1, dl_back = -1;
+	uint64_t back_at = 0, unlock_at;
+	int ret = KSFT_FAIL, err;
+	void *t_ret = NULL;
+	pthread_t t;
+
+	rb2_pi = gettid_();
+	rb2_t_locking = 0;
+	rb2_t_tid = 0;
+	rb2_t_start = 0;
+	rb2_t_got = 0;
+	if (pthread_create(&t, NULL, rb2_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(1000, rb2_t_locking &&
+		     (rb2_t_locking < 0 || (proc_state_of(rb2_t_tid) == 'S' &&
+					    (rb2_pi & FUTEX_WAITERS)))) ||
+	    rb2_t_locking < 0) {
+		ksft_print_msg("T never blocked on rb2_pi\n");
+		goto out;
+	}
+	while (now_ns() - rb2_t_start < 40 * NSEC_PER_MSEC)
+		sleep_ns(NSEC_PER_MSEC);
+	dl_gap = dl_deadline_of(rb2_t_tid);
+	err = set_other(rb2_t_tid);
+	if (err) {
+		ksft_print_msg("T cannot leave SCHED_DEADLINE: %s\n", strerror(-err));
+		goto out;
+	}
+	err = set_constrained(rb2_t_tid, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	back_at = now_ns();
+	if (err) {
+		ksft_print_msg("T refused back as a deadline task: %s\n", strerror(-err));
+		goto out;
+	}
+	dl_back = dl_deadline_of(rb2_t_tid);
+	if (proc_state_of(rb2_t_tid) != 'S' || !(rb2_pi & FUTEX_WAITERS)) {
+		ksft_print_msg("T no longer waits on rb2_pi\n");
+		goto out;
+	}
+	sleep_ns(5 * NSEC_PER_MSEC);
+	ret = KSFT_PASS;
+out:
+	unlock_at = now_ns();
+	{
+		uint32_t tid = gettid_();
+
+		if (!atomic_compare_exchange_strong(&rb2_pi, &tid, 0))
+			syscall(SYS_futex, &rb2_pi, FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG,
+				0, NULL, NULL, 0);
+	}
+	if (pthread_join(t, &t_ret) || t_ret || ret != KSFT_PASS)
+		return KSFT_FAIL;	/* the thread said why */
+	ksft_print_msg("T back at %lld ms, deadline moved by %lld ms; next period at 500 ms\n",
+		       MS_FROM(rb2_t_start, back_at),
+		       dl_back < 0 || dl_gap < 0 ? -1LL :
+		       (dl_back - dl_gap) / (long long)NSEC_PER_MSEC);
+	ksft_print_msg("(0: kept, %lld: new period); unlock %lld ms; T got the lock %lld ms\n",
+		       MS_FROM(rb2_t_start, back_at),
+		       MS_FROM(rb2_t_start, unlock_at), MS_FROM(rb2_t_start, rb2_t_got));
+	if (MS_FROM(rb2_t_start, rb2_t_got) < 490) {
+		ksft_print_msg("T ran before its next period\n");
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+static int ra_fd[2];
+static atomic_int ra_t_asleep;
+static _Atomic pid_t ra_t_tid;
+static _Atomic uint64_t ra_t_start, ra_t_run;
+
+/*
+ * Run as T of reenter_asleep_case(). Become a deadline task of 10ms in
+ * 20ms, every 500ms. Spin 2ms of CPU time, then sleep in a read of
+ * ra_fd[0]. Once woken, store the time and leave SCHED_DEADLINE. Return
+ * NULL, or 1 on an error.
+ */
+static void *ra_t(void *arg)
+{
+	char c;
+	int err;
+
+	ra_t_tid = gettid_();
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	ra_t_start = now_ns();
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		ra_t_asleep = -1;
+		return (void *)1;
+	}
+	spin_ns(2 * NSEC_PER_MSEC);
+	ra_t_asleep = 1;
+	if (read(ra_fd[0], &c, 1) != 1) {
+		ksft_print_msg("T: read: %s\n", strerror(errno));
+		set_other(0);
+		return (void *)1;
+	}
+	ra_t_run = now_ns();
+	if (set_other(0))
+		ksft_print_msg("T cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * The same as reenter_pi_blocked_in_gap(), without the rt_mutex. P has
+ * one CPU:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 500ms, at 0ms. It
+ *    spins 2ms and sleeps in a read of a pipe, with 8ms left. Its
+ *    deadline is 20ms. Its 0-lag time is 100ms.
+ * 2. At @at_ms, T is past its deadline and before its next period, at
+ *    500ms. The main thread switches T to SCHED_OTHER, then back to
+ *    SCHED_DEADLINE with the same parameters.
+ * 3. About 5ms later, the main thread wakes T up.
+ *
+ * Leaving the class and coming back must not give T a new period before
+ * 500ms. The case fails if T runs after its wakeup before 490ms.
+ */
+static int reenter_asleep_case(int at_ms)
+{
+	long long dl_gap = -1, dl_back = -1;
+	uint64_t back_at = 0, wake_at = 0;
+	int ret = KSFT_FAIL, err;
+	void *t_ret = NULL;
+	pthread_t t;
+
+	if (pipe(ra_fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	ra_t_asleep = 0;
+	ra_t_tid = 0;
+	ra_t_start = 0;
+	ra_t_run = 0;
+	if (pthread_create(&t, NULL, ra_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		goto close;
+	}
+	if (wait_for(1000, ra_t_asleep &&
+		     (ra_t_asleep < 0 || proc_state_of(ra_t_tid) == 'S')) ||
+	    ra_t_asleep < 0) {
+		ksft_print_msg("T never slept\n");
+		goto out;
+	}
+	while (now_ns() - ra_t_start < (uint64_t)at_ms * NSEC_PER_MSEC)
+		sleep_ns(NSEC_PER_MSEC);
+	dl_gap = dl_deadline_of(ra_t_tid);
+	err = set_other(ra_t_tid);
+	if (err) {
+		ksft_print_msg("T cannot leave SCHED_DEADLINE: %s\n", strerror(-err));
+		goto out;
+	}
+	err = set_constrained(ra_t_tid, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	back_at = now_ns();
+	if (err) {
+		ksft_print_msg("T refused back as a deadline task: %s\n", strerror(-err));
+		goto out;
+	}
+	dl_back = dl_deadline_of(ra_t_tid);
+	if (proc_state_of(ra_t_tid) != 'S') {
+		ksft_print_msg("T is no longer asleep\n");
+		goto out;
+	}
+	sleep_ns(5 * NSEC_PER_MSEC);
+	ret = KSFT_PASS;
+out:
+	wake_at = now_ns();
+	if (write(ra_fd[1], "x", 1) != 1)
+		ksft_print_msg("write: %s\n", strerror(errno));
+	if (pthread_join(t, &t_ret) || t_ret)
+		ret = KSFT_FAIL;	/* the thread said why */
+close:
+	close(ra_fd[0]);
+	close(ra_fd[1]);
+	if (ret != KSFT_PASS)
+		return KSFT_FAIL;
+	ksft_print_msg("T back at %lld ms, deadline %s%lld ms; next period at 500 ms\n",
+		       MS_FROM(ra_t_start, back_at),
+		       dl_back == 0 ? "is 0, moved by " : "moved by ",
+		       dl_back < 0 || dl_gap < 0 ? -1LL :
+		       (dl_back - dl_gap) / (long long)NSEC_PER_MSEC);
+	ksft_print_msg("T woken at %lld ms, ran at %lld ms\n",
+		       MS_FROM(ra_t_start, wake_at), MS_FROM(ra_t_start, ra_t_run));
+	if (MS_FROM(ra_t_start, ra_t_run) < 490) {
+		ksft_print_msg("T ran before its next period\n");
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+/* Run reenter_asleep_case() before T's 0-lag time. */
+static int reenter_asleep_in_gap(void)
+{
+	return reenter_asleep_case(40);
+}
+
+/* Run reenter_asleep_case() after T's 0-lag time, before its next period. */
+static int reenter_asleep_late_in_gap(void)
+{
+	return reenter_asleep_case(150);
+}
+
+static atomic_int rr_t_ready, rr_stop;
+static _Atomic pid_t rr_t_tid;
+static _Atomic uint64_t rr_t_start, rr_back_at, rr_t_ran;
+
+/*
+ * Run as T of reenter_runnable_in_gap(). Become a deadline task of 10ms in
+ * 20ms, every 500ms, and spin until rr_stop. Store in rr_t_ran the first
+ * time T runs more than 2ms after rr_back_at. The 2ms leave out the time T
+ * may run as SCHED_OTHER before it is back. Return NULL, or 1 on an
+ * error.
+ */
+static void *rr_t(void *arg)
+{
+	int err;
+
+	rr_t_tid = gettid_();
+	err = set_constrained(0, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	rr_t_start = now_ns();
+	if (err) {
+		ksft_print_msg("T refused as a deadline task: %s\n", strerror(-err));
+		rr_t_ready = -1;
+		return (void *)1;
+	}
+	rr_t_ready = 1;
+	while (!rr_stop) {
+		uint64_t t = now_ns(), b = rr_back_at;
+
+		if (b && !rr_t_ran && t > b + 2 * NSEC_PER_MSEC)
+			rr_t_ran = t;
+	}
+	return NULL;
+}
+
+/*
+ * The same as reenter_asleep_in_gap(), for a task that stays runnable. P
+ * has one CPU:
+ * 1. T becomes a deadline task of 10ms in 20ms, every 500ms, at 0ms, and
+ *    spins. It is throttled at 10ms, until its next period at 500ms.
+ * 2. At 40ms, the main thread switches T to SCHED_OTHER, then back to
+ *    SCHED_DEADLINE with the same parameters.
+ *
+ * Leaving the class and coming back must not give T a new period before
+ * 500ms. With a new period, T would run at once. The case fails if T runs
+ * from 2ms to 50ms after rr_back_at.
+ */
+static int reenter_runnable_in_gap(void)
+{
+	int ret = KSFT_FAIL, err;
+	void *t_ret = NULL;
+	pthread_t t;
+
+	rr_t_ready = 0;
+	rr_stop = 0;
+	rr_t_tid = 0;
+	rr_t_start = 0;
+	rr_back_at = 0;
+	rr_t_ran = 0;
+	if (pthread_create(&t, NULL, rr_t, NULL)) {
+		ksft_print_msg("the T thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(1000, rr_t_ready) || rr_t_ready < 0) {
+		ksft_print_msg("T never started\n");
+		goto out;
+	}
+	while (now_ns() - rr_t_start < 40 * NSEC_PER_MSEC)
+		sleep_ns(NSEC_PER_MSEC);
+	err = set_other(rr_t_tid);
+	if (err) {
+		ksft_print_msg("T cannot leave SCHED_DEADLINE: %s\n", strerror(-err));
+		goto out;
+	}
+	/* Store it before the switch back. A T given a new period runs at once. */
+	rr_back_at = now_ns();
+	err = set_constrained(rr_t_tid, 10 * NSEC_PER_MSEC, 20 * NSEC_PER_MSEC, 5 * PERIOD);
+	if (err) {
+		ksft_print_msg("T refused back as a deadline task: %s\n", strerror(-err));
+		goto out;
+	}
+	sleep_ns(50 * NSEC_PER_MSEC);
+	ret = KSFT_PASS;
+out:
+	set_other(rr_t_tid);
+	rr_stop = 1;
+	if (pthread_join(t, &t_ret) || t_ret)
+		ret = KSFT_FAIL;
+	if (ret != KSFT_PASS)
+		return KSFT_FAIL;
+	ksft_print_msg("T back at %lld ms, ran again at %lld ms\n",
+		       MS_FROM(rr_t_start, rr_back_at),
+		       rr_t_ran ? MS_FROM(rr_t_start, rr_t_ran) : -1LL);
+	if (rr_t_ran && rr_t_ran < rr_back_at + 50 * NSEC_PER_MSEC) {
+		ksft_print_msg("T ran before its next period\n");
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+static sem_t rb_donor_go;
+static atomic_int rb_abort, rb_donor_locking, rb_donor_done, rb_waiter_locking;
+static _Atomic pid_t rb_waiter_tid;
+static _Atomic long long rb_spin_ns;
+
+/*
+ * Run as the owner O of deboost_new_params_reboost(). Its comment has
+ * the steps. Store in rb_spin_ns the time that O's last spin, 20ms of CPU
+ * time, takes. Return NULL, or 1 on an error.
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
+static int reboost_case(void);
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
+ * O has run about 20ms of its 50ms when D times out: 10ms more than its
+ * share. The deboost fits O's period to the new parameters. O keeps 5ms,
+ * and its next period starts once those 5ms and the 10ms of debt are
+ * paid at 5%: its deadline is about 300ms ahead. W's deadline is now the
+ * earlier one. W must boost O again. A boosted O is refilled from W, so
+ * its last spin takes about 20ms. Without the boost, O is throttled once
+ * its 5ms run out, until its new deadline. The case fails if the spin
+ * takes more than 50ms.
+ */
+static int deboost_new_params_reboost(void)
+{
+	return reboost_case();
+}
+
+/* Run deboost_new_params_reboost(). */
+static int reboost_case(void)
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
+/* The kinds of owner_boost_case() */
+enum {
+	OB_GAP, OB_THROTTLED, OB_NEW_PARAMS, OB_RIVAL, OB_LONG,
+	OB_LATE_THROTTLE, OB_LATE_GAP,
+};
+
+static sem_t ob_locked, ob_go, ob_rival_go;
+static _Atomic unsigned long long ob_t0;
+static _Atomic long long ob_got_ms;
+static _Atomic pid_t ob_w_tid;
+static int ob_throttled, ob_kind;
+static atomic_int ob_w_locking;
+
+/*
+ * Run as the owner O of owner_boost_case(). Become a deadline task, take
+ * pi_lock, and act by ob_kind:
+ * - OB_GAP and OB_LATE_GAP: 10ms in 20ms, every 500ms. Sleep until 40ms.
+ *   O then wakes past its deadline, before its next period.
+ * - the other kinds: 10ms every 100ms. O runs out of runtime at 10ms,
+ *   holding the lock. Then:
+ *   - OB_THROTTLED and OB_RIVAL: spin 15ms of CPU time.
+ *   - OB_LATE_THROTTLE: sleep until W blocks on pi_lock, then spin 15ms.
+ *   - OB_NEW_PARAMS: spin 12ms. Change O to 9ms every 100ms, and W to 5ms
+ *     every 310ms. Then spin 3ms.
+ *   - OB_LONG: spin 12ms, then sleep until 250ms.
+ * Then unlock. Return NULL, or 1 on an error.
+ */
+static void *ob_owner(void *arg)
+{
+	struct timespec ts;
+	uint64_t end;
+	int err, bad = 0;
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
+	if (ob_kind == OB_NEW_PARAMS) {
+		spin_ns(12 * NSEC_PER_MSEC);
+		err = set_deadline(0, 9 * NSEC_PER_MSEC, PERIOD);
+		if (!err)
+			err = set_deadline(ob_w_tid, 5 * NSEC_PER_MSEC,
+					   3 * PERIOD + 10 * NSEC_PER_MSEC);
+		if (err) {
+			ksft_print_msg("the owner could not change the parameters: %s\n",
+				       strerror(-err));
+			bad = 1;
+		}
+		spin_ns(3 * NSEC_PER_MSEC);
+	} else if (ob_kind == OB_LONG) {
+		spin_ns(12 * NSEC_PER_MSEC);
+		end = ob_t0 + 250 * NSEC_PER_MSEC;
+		ts.tv_sec = end / NSEC_PER_SEC;
+		ts.tv_nsec = end % NSEC_PER_SEC;
+		while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+			;
+	} else if (ob_kind == OB_LATE_THROTTLE) {
+		end = now_ns();
+		while (!ob_w_locking || proc_state_of(ob_w_tid) != 'S') {
+			if (now_ns() - end > NSEC_PER_SEC) {
+				ksft_print_msg("the waiter did not block on the lock\n");
+				bad = 1;
+				break;
+			}
+			sleep_ns(NSEC_PER_MSEC);
+		}
+		spin_ns(15 * NSEC_PER_MSEC);
+	} else if (ob_throttled) {
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
+	return bad ? (void *)1 : NULL;
+}
+
+/*
+ * Run as the waiter W of owner_boost_case(). Wait for ob_go. Then
+ * become a deadline task of 5ms every 300ms, or of 2ms every 10ms with
+ * OB_RIVAL, and take pi_lock. Store in ob_got_ms the time at which W gets
+ * it. Return NULL, or 1 on an error.
+ */
+static void *ob_waiter(void *arg)
+{
+	int err;
+
+	ob_w_tid = gettid_();
+	sem_wait_sig(&ob_go);
+	if (ob_kind == OB_RIVAL)
+		err = set_deadline(0, 2 * NSEC_PER_MSEC, 10 * NSEC_PER_MSEC);
+	else
+		err = set_deadline(0, 5 * NSEC_PER_MSEC, 3 * PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		if (ob_kind == OB_RIVAL)
+			sem_post(&ob_rival_go);	/* release the rival */
+		return (void *)1;
+	}
+	if (ob_kind == OB_RIVAL)
+		sem_post(&ob_rival_go);
+	ob_w_locking = 1;
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
+ * Run as the rival C of pi_owner_throttled_rival(). Become a deadline
+ * task of 40ms in 60ms, every 100ms. Wait until W is about to block,
+ * then sleep until 13ms after O's start, and spin 40ms of CPU time.
+ * Return NULL, or 1 on an error.
+ */
+static void *ob_rival(void *arg)
+{
+	struct timespec ts;
+	uint64_t end;
+	int err;
+
+	err = set_constrained(0, 40 * NSEC_PER_MSEC, 60 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the rival refused as a deadline task: %s\n",
+			       strerror(-err));
+		return (void *)1;
+	}
+	sem_wait_sig(&ob_rival_go);
+	end = ob_t0 + 13 * NSEC_PER_MSEC;
+	ts.tv_sec = end / NSEC_PER_SEC;
+	ts.tv_nsec = end % NSEC_PER_SEC;
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+	spin_ns(40 * NSEC_PER_MSEC);
+	if (set_other(0))
+		ksft_print_msg("the rival cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run an owner_boost case of @kind: ob_owner() and ob_waiter(), and
+ * ob_rival() with OB_RIVAL. W must get pi_lock within @limit_ms of O's
+ * start.
+ */
+static int owner_boost_case(int kind, int limit_ms)
+{
+	void *o_ret = NULL, *w_ret = NULL, *c_ret = NULL;
+	int throttled = kind != OB_GAP && kind != OB_LATE_GAP;
+	int ret = KSFT_FAIL;
+	pthread_t o, w, c;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (kind == OB_LONG) {
+		int had = klog_has(DL_LAG_MSG);
+
+		if (had) {
+			ksft_print_msg(had < 0 ? "the kernel log cannot be read\n" :
+				       "the lag message was logged before this case\n");
+			pi_fini();
+			return KSFT_SKIP;
+		}
+	}
+	if (sem_init(&ob_locked, 0, 0) || sem_init(&ob_go, 0, 0) ||
+	    sem_init(&ob_rival_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_FAIL;
+	}
+	ob_throttled = throttled;
+	ob_kind = kind;
+	ob_got_ms = -1;
+	ob_w_locking = 0;
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
+	if (kind == OB_GAP)
+		sleep_ns(30 * NSEC_PER_MSEC);	/* O sleeps past its deadline */
+	if (kind == OB_RIVAL && pthread_create(&c, NULL, ob_rival, NULL)) {
+		ksft_print_msg("the rival thread could not start\n");
+		kind = OB_THROTTLED;
+		c_ret = (void *)1;
+	}
+	sem_post(&ob_go);
+	pthread_join(o, &o_ret);
+	pthread_join(w, &w_ret);
+	if (kind == OB_RIVAL)
+		pthread_join(c, &c_ret);
+	if (o_ret || w_ret || c_ret || ob_got_ms < 0)
+		goto out;	/* the thread said why */
+	if (ob_got_ms >= limit_ms) {
+		ksft_print_msg("the waiter got the lock at %lld ms, not before %d\n",
+			       (long long)ob_got_ms, limit_ms);
+		goto out;
+	}
+	if (kind == OB_LONG && klog_has(DL_LAG_MSG) == 1) {
+		ksft_print_msg("the deboost logged \"%s\"\n", DL_LAG_MSG);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	sem_destroy(&ob_locked);
+	sem_destroy(&ob_go);
+	sem_destroy(&ob_rival_go);
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
+	return owner_boost_case(OB_GAP, 200);
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
+	return owner_boost_case(OB_THROTTLED, 60);
+}
+
+/*
+ * A deadline waiter blocks on a lock whose owner can still run on its own
+ * reservation, and the owner then runs out of runtime:
+ * 1. O becomes a deadline task of 10ms every 100ms, at 0ms. It takes
+ *    pi_lock, and sleeps until W blocks on it.
+ * 2. W becomes a deadline task of 5ms every 300ms and blocks on pi_lock.
+ *    O's deadline, 100ms, is the earlier one: W does not boost O.
+ * 3. O spins 15ms of CPU time. It runs out of runtime after 10ms, with
+ *    pi_lock.
+ *
+ * W must boost O then: O cannot run on its own reservation until 100ms.
+ * O then runs its last 5ms on W's runtime and unlocks. The case fails if
+ * W gets pi_lock at 60ms or later.
+ */
+static int pi_owner_runs_out_later(void)
+{
+	return owner_boost_case(OB_LATE_THROTTLE, 60);
+}
+
+/*
+ * A deadline waiter blocks on a lock whose owner sleeps before its
+ * deadline:
+ * 1. O becomes a deadline task of 10ms in 20ms, every 500ms, at 0ms. It
+ *    takes pi_lock and sleeps until 40ms.
+ * 2. W becomes a deadline task of 5ms every 300ms and blocks on pi_lock,
+ *    before 20ms. O's deadline, 20ms, is the earlier one: W does not
+ *    boost O.
+ * 3. O wakes up at 40ms, between its deadline and its next period, at
+ *    500ms. The wakeup would throttle it until then.
+ *
+ * W must boost O at that wakeup. O then runs at 40ms and unlocks. The
+ * case fails if W gets pi_lock at 200ms or later.
+ */
+static int pi_owner_wakes_in_gap_later(void)
+{
+	return owner_boost_case(OB_LATE_GAP, 200);
+}
+
+static _Atomic unsigned long long ho_t0;
+static _Atomic long long ho_w_got_ms;
+static _Atomic pid_t ho_o_tid, ho_w_tid;
+static atomic_int ho_o_locking, ho_w_locking, ho_w_queued;
+
+/*
+ * Run as the owner O of pi_owner_handed_off(). Become a deadline task of
+ * 10ms every 100ms, and take pi_lock, which A holds. Once O has it, set
+ * ho_w_queued if W still waits for it. Spin 15ms of CPU time and unlock.
+ * Return NULL, or 1 on an error.
+ */
+static void *ho_owner(void *arg)
+{
+	int err;
+
+	ho_o_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	ho_t0 = now_ns();
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n",
+			       strerror(-err));
+		return (void *)1;
+	}
+	ho_o_locking = 1;
+	if (take_pi_lock()) {
+		set_other(0);
+		return (void *)1;
+	}
+	ho_w_queued = ho_w_got_ms < 0 && proc_state_of(ho_w_tid) == 'S';
+	spin_ns(15 * NSEC_PER_MSEC);
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run as the waiter W of pi_owner_handed_off(). Become a deadline task of
+ * 5ms every 300ms and take pi_lock. Store in ho_w_got_ms the time at
+ * which W gets it. Return NULL, or 1 on an error.
+ */
+static void *ho_waiter(void *arg)
+{
+	int err;
+
+	ho_w_tid = gettid_();
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, 3 * PERIOD);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		return (void *)1;
+	}
+	ho_w_locking = 1;
+	if (take_pi_lock()) {
+		set_other(0);
+		return (void *)1;
+	}
+	ho_w_got_ms = (now_ns() - ho_t0) / NSEC_PER_MSEC;
+	drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the waiter cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * A variant of pi_owner_runs_out_later(): the owner gets the lock by a
+ * hand-off, with the waiter already queued on it. A, the main thread of
+ * the case, is a SCHED_OTHER task:
+ * 1. A takes pi_lock.
+ * 2. O becomes a deadline task of 10ms every 100ms, at 0ms. It blocks on
+ *    pi_lock.
+ * 3. W becomes a deadline task of 5ms every 300ms. It blocks on pi_lock.
+ * 4. A unlocks. O's deadline, about 100ms, is the earlier one. So O gets
+ *    pi_lock, and W stays queued on it. O can still run on its own
+ *    reservation, so W does not boost it.
+ * 5. O spins 15ms of CPU time. It runs out of runtime after 10ms, with
+ *    pi_lock.
+ *
+ * W must boost O then: O cannot run on its own reservation until about
+ * 100ms. W blocked on pi_lock before O owned it. So the boost must find W
+ * among the waiters that O got with the lock. O then runs its last 5ms on
+ * W's runtime and unlocks. The case fails if W does not wait for pi_lock
+ * when O gets it, or if W gets pi_lock at 60ms or later.
+ */
+static int pi_owner_handed_off(void)
+{
+	void *o_ret = NULL, *w_ret = NULL;
+	int ret = KSFT_FAIL, w_blocked;
+	pthread_t o, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	ho_o_tid = 0;
+	ho_w_tid = 0;
+	ho_o_locking = 0;
+	ho_w_locking = 0;
+	ho_w_queued = 0;
+	ho_w_got_ms = -1;
+	if (take_pi_lock())
+		goto out;
+	w_blocked = 1;
+	if (pthread_create(&o, NULL, ho_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		drop_pi_lock();
+		goto out;
+	}
+	if (wait_for(1000, ho_o_locking && proc_state_of(ho_o_tid) == 'S')) {
+		ksft_print_msg("the owner did not block on the lock\n");
+		drop_pi_lock();
+		join(o);
+		goto out;
+	}
+	if (pthread_create(&w, NULL, ho_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		drop_pi_lock();
+		join(o);
+		goto out;
+	}
+	if (wait_for(1000, ho_w_locking && proc_state_of(ho_w_tid) == 'S')) {
+		ksft_print_msg("the waiter did not block on the lock\n");
+		w_blocked = 0;
+	}
+	drop_pi_lock();
+	pthread_join(o, &o_ret);
+	pthread_join(w, &w_ret);
+	if (!w_blocked || o_ret || w_ret || ho_w_got_ms < 0)
+		goto out;	/* the thread said why */
+	if (!ho_w_queued) {
+		ksft_print_msg("the waiter did not wait when the owner got the lock\n");
+		goto out;
+	}
+	if (ho_w_got_ms >= 60) {
+		ksft_print_msg("the waiter got the lock at %lld ms, not before 60\n",
+			       (long long)ho_w_got_ms);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	pi_fini();
+	return ret;
+}
+
+/*
+ * The owner of pi_owner_throttled() changes its parameters while boosted:
+ * 1. As in pi_owner_throttled(), O is throttled at 10ms, and W boosts it.
+ * 2. After 12ms of CPU time, O changes itself to 9ms every 100ms. Then it
+ *    changes W to 5ms every 310ms. This change of W walks the chain to O.
+ *    O has new parameters, so rt_mutex_setprio() deboosts O before it
+ *    compares O with W.
+ *
+ * O has used up its own runtime until 100ms, so W must boost it again.
+ * O then runs its last 3ms and unlocks. The case fails if W gets pi_lock
+ * at 60ms or later.
+ */
+static int pi_owner_held_new_params(void)
+{
+	return owner_boost_case(OB_NEW_PARAMS, 60);
+}
+
+/*
+ * A deadline task C competes with the boosted owner of
+ * pi_owner_throttled():
+ * 1. O becomes a deadline task of 10ms every 100ms, at 0ms. Its deadline
+ *    is 100ms. It takes pi_lock and spins 15ms of CPU time. It is
+ *    throttled at 10ms.
+ * 2. W then becomes a deadline task of 2ms every 10ms, and blocks on
+ *    pi_lock. Its deadline is about 20ms. W boosts O.
+ * 3. C becomes a deadline task of 40ms in 60ms, every 100ms. It wakes up
+ *    at 13ms, with a deadline of about 70ms, and spins 40ms.
+ *
+ * Boosted, O must run on W's deadlines, before C's. O then runs its last
+ * 5ms and unlocks. Refilled from its own deadline, O would get a deadline
+ * of 110ms. That is after C's, so O would wait for C. The case fails if W
+ * gets pi_lock at 35ms or later.
+ */
+static int pi_owner_throttled_rival(void)
+{
+	return owner_boost_case(OB_RIVAL, 35);
+}
+
+/*
+ * The owner of pi_owner_throttled() stays boosted past its own next
+ * period:
+ * 1. As in pi_owner_throttled(), O is throttled at 10ms, and W boosts it.
+ * 2. After 12ms of CPU time, O sleeps until 250ms with the lock. Its own
+ *    period ends at 100ms, during that sleep.
+ * 3. O unlocks at 250ms.
+ *
+ * The deboost must start a period of O's own. Putting back the period
+ * that ended at 100ms would make the next refill print "sched: DL
+ * replenish lagged too much". The case fails if that message is logged,
+ * or if W gets pi_lock at 400ms or later. It skips if the message was
+ * logged before: the kernel prints it once.
+ */
+static int pi_owner_held_long(void)
+{
+	return owner_boost_case(OB_LONG, 400);
+}
+
+/*
+ * The threads of reboost_loop_case(): rb_owner() for each owner, rb_waiter()
+ * and rb_victim(). Each owner holds its own lock in rb_lock[].
+ */
+#define RB_OWNERS	2	/* the most owners of a case */
+#define RB_JOBS		20	/* periods of the victim */
+#define RB_RUNTIME	(35 * NSEC_PER_MSEC)	/* of the victim */
+#define RB_PERIOD	(50 * NSEC_PER_MSEC)	/* of the victim */
+
+static pthread_mutex_t rb_lock[RB_OWNERS];
+static sem_t rb_locked, rb_ready, rb_go, rb_go_w;
+static atomic_int rb_stop, rb_release;
+static uint64_t rb_victim_ns, rb_waits;
+
+/*
+ * Run as an owner of reboost_loop_case(). Become a deadline task of 1ms
+ * every 3s, take rb_lock[@arg] and post rb_locked. Spin until rb_release
+ * is set, then unlock. Return NULL, or 1 on an error.
+ */
+static void *rb_owner(void *arg)
+{
+	long i = (long)arg;
+	int err = set_deadline(0, NSEC_PER_MSEC, 30 * PERIOD);
+
+	if (err) {
+		ksft_print_msg("an owner refused as a deadline task: %s\n",
+			       strerror(-err));
+		sem_post(&rb_locked);
+		return (void *)1;
+	}
+	err = pthread_mutex_lock(&rb_lock[i]);
+	sem_post(&rb_locked);
+	if (err) {
+		ksft_print_msg("an owner cannot take its lock: %s\n", strerror(err));
+		set_other(0);
+		return (void *)1;
+	}
+	while (!atomic_load(&rb_release))
+		;
+	err = pthread_mutex_unlock(&rb_lock[i]);
+	if (err)
+		ksft_print_msg("an owner cannot unlock: %s\n", strerror(err));
+	if (set_other(0))
+		ksft_print_msg("an owner cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * Run as the waiter of reboost_loop_case(), with @arg owners. Become a
+ * deadline task of 1ms every 10ms, post rb_ready and wait for rb_go_w.
+ * Until rb_stop is set, wait 1ms for each lock in turn, and count the
+ * waits in rb_waits. Each wait boosts the owner, and must time out. Then
+ * set rb_release, and take each lock without a timeout: its owner runs
+ * on the boost and unlocks. Return NULL, or 1 on an error.
+ */
+static void *rb_waiter(void *arg)
+{
+	int n = (long)arg, i = 0, err, bad = 0;
+
+	err = set_deadline(0, NSEC_PER_MSEC, 10 * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n",
+			       strerror(-err));
+		bad = 1;
+	}
+	sem_post(&rb_ready);
+	sem_wait_sig(&rb_go_w);
+	while (!bad && !atomic_load(&rb_stop)) {
+		struct timespec ts;
+
+		clock_gettime(CLOCK_REALTIME, &ts);
+		ts.tv_nsec += 1000000L;
+		ts.tv_sec += ts.tv_nsec / 1000000000L;
+		ts.tv_nsec %= 1000000000L;
+		err = pthread_mutex_timedlock(&rb_lock[i], &ts);
+		if (err != ETIMEDOUT) {
+			ksft_print_msg("a wait of 1ms for a lock: %s, not a timeout\n",
+				       err ? strerror(err) : "got it");
+			if (!err)
+				pthread_mutex_unlock(&rb_lock[i]);
+			bad = 1;
+			break;
+		}
+		rb_waits++;
+		i = (i + 1) % n;
+	}
+	atomic_store(&rb_release, 1);
+	for (i = 0; i < n; i++) {
+		err = pthread_mutex_lock(&rb_lock[i]);
+		if (err) {
+			ksft_print_msg("the waiter cannot take a lock: %s\n", strerror(err));
+			bad = 1;
+			continue;
+		}
+		pthread_mutex_unlock(&rb_lock[i]);
+	}
+	if (set_other(0))
+		ksft_print_msg("the waiter cannot leave SCHED_DEADLINE\n");
+	return bad ? (void *)1 : NULL;
+}
+
+/*
+ * Run as the victim of reboost_loop_case(). Become a deadline task of
+ * RB_RUNTIME every RB_PERIOD, post rb_ready and wait for rb_go. Then
+ * start the waiter with rb_go_w. In each of RB_JOBS periods, spin until
+ * this thread has run RB_RUNTIME in the period or the period ends. Then
+ * sleep until the next period. Store the CPU time it got in rb_victim_ns,
+ * and set rb_stop. Return NULL, or 1 on an error.
+ */
+static void *rb_victim(void *arg)
+{
+	uint64_t next, cpu;
+	int err, j;
+
+	err = set_deadline(0, RB_RUNTIME, RB_PERIOD);
+	if (err) {
+		ksft_print_msg("the victim refused as a deadline task: %s\n",
+			       strerror(-err));
+		atomic_store(&rb_stop, 1);
+		sem_post(&rb_ready);
+		sem_post(&rb_go_w);
+		return (void *)1;
+	}
+	sem_post(&rb_ready);
+	sem_wait_sig(&rb_go);
+	cpu = thread_time_ns();
+	next = now_ns();
+	sem_post(&rb_go_w);
+	for (j = 0; j < RB_JOBS; j++) {
+		uint64_t job = thread_time_ns();
+		struct timespec ts;
+
+		next += RB_PERIOD;
+		while (thread_time_ns() - job < RB_RUNTIME && now_ns() < next)
+			;
+		ts.tv_sec = next / NSEC_PER_SEC;
+		ts.tv_nsec = next % NSEC_PER_SEC;
+		while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+			;
+	}
+	rb_victim_ns = thread_time_ns() - cpu;
+	atomic_store(&rb_stop, 1);
+	if (set_other(0))
+		ksft_print_msg("the victim cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run the scenario of pi_owner_reboost_loop() with @n owners: start
+ * rb_owner() for each, then rb_waiter() and rb_victim(). Fail if the
+ * waiter waits fewer than 100 times, or if the victim gets less than 95%
+ * of its runtime.
+ */
+static int reboost_loop_case(int n)
+{
+	uint64_t need = RB_JOBS * RB_RUNTIME;
+	void *r, *bad = NULL;
+	pthread_mutexattr_t a;
+	pthread_t o[RB_OWNERS], w, v;
+	int i, started = 0, inited = 0, ret = KSFT_FAIL;
+
+	if (pthread_mutexattr_init(&a))
+		return KSFT_SKIP;
+	if (pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT)) {
+		pthread_mutexattr_destroy(&a);
+		ksft_print_msg("no priority inheritance mutex\n");
+		return KSFT_SKIP;
+	}
+	for (; inited < n; inited++)
+		if (pthread_mutex_init(&rb_lock[inited], &a))
+			break;
+	pthread_mutexattr_destroy(&a);
+	if (inited < n || sem_init(&rb_locked, 0, 0) || sem_init(&rb_ready, 0, 0) ||
+	    sem_init(&rb_go, 0, 0) || sem_init(&rb_go_w, 0, 0)) {
+		ksft_print_msg("the locks or semaphores cannot be set up\n");
+		goto out_locks;
+	}
+	atomic_store(&rb_stop, 0);
+	atomic_store(&rb_release, 0);
+	rb_victim_ns = 0;
+	rb_waits = 0;
+	for (; started < n; started++) {
+		if (pthread_create(&o[started], NULL, rb_owner, (void *)(long)started)) {
+			ksft_print_msg("an owner thread could not start\n");
+			break;
+		}
+	}
+	for (i = 0; i < started; i++)
+		if (sem_wait_for(&rb_locked, 5000))
+			break;
+	if (started < n || i < started)
+		goto out_owners;
+	/* Each owner holds its lock, and is throttled after 1ms. */
+	sleep_ns(20 * NSEC_PER_MSEC);
+	if (pthread_create(&w, NULL, rb_waiter, (void *)(long)n)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		goto out_owners;
+	}
+	if (pthread_create(&v, NULL, rb_victim, NULL)) {
+		ksft_print_msg("the victim thread could not start\n");
+		atomic_store(&rb_stop, 1);
+		sem_post(&rb_go_w);
+		pthread_join(w, &r);
+		goto out_owners;
+	}
+	/*
+	 * Wait until the waiter and the victim are deadline tasks. Then start
+	 * the victim, which starts the waiter. This thread is not a deadline
+	 * task. If it posted to both, the boosted owner could keep it off the
+	 * CPU between the two posts.
+	 */
+	if (sem_wait_for(&rb_ready, 5000) || sem_wait_for(&rb_ready, 5000))
+		atomic_store(&rb_stop, 1);
+	sem_post(&rb_go);
+	pthread_join(v, &r);
+	bad = r;
+	pthread_join(w, &r);
+	bad = bad ? bad : r;
+	for (i = 0; i < started; i++) {
+		pthread_join(o[i], &r);
+		bad = bad ? bad : r;
+	}
+	started = 0;
+	if (bad)
+		goto out;	/* the thread said why */
+	if (rb_waits < 100) {
+		ksft_print_msg("the waiter waited only %llu times\n",
+			       (unsigned long long)rb_waits);
+		goto out;
+	}
+	if (rb_victim_ns * 100 < need * 95) {
+		ksft_print_msg("the victim ran %llu of its %llu ms, after %llu waits\n",
+			       (unsigned long long)(rb_victim_ns / NSEC_PER_MSEC),
+			       (unsigned long long)(need / NSEC_PER_MSEC),
+			       (unsigned long long)rb_waits);
+		goto out;
+	}
+	ret = KSFT_PASS;
+	goto out;
+out_owners:
+	/*
+	 * A throttled owner runs again at its next period, within 3s, and
+	 * sees rb_release.
+	 */
+	atomic_store(&rb_stop, 1);
+	atomic_store(&rb_release, 1);
+	for (i = 0; i < started; i++)
+		join(o[i]);
+out:
+	sem_destroy(&rb_locked);
+	sem_destroy(&rb_ready);
+	sem_destroy(&rb_go);
+	sem_destroy(&rb_go_w);
+out_locks:
+	while (inited--)
+		pthread_mutex_destroy(&rb_lock[inited]);
+	return ret;
+}
+
+/*
+ * A waiter boosts a throttled owner over and over:
+ * 1. O becomes a deadline task of 1ms every 3s. It takes a lock and
+ *    spins. It is throttled after 1ms, until its next period.
+ * 2. 20ms later, W becomes a deadline task of 1ms every 10ms. It waits
+ *    for the lock again and again, until V is done. Each wait boosts O
+ *    and times out after 1ms.
+ * 3. At the same time, V becomes a deadline task of 35ms every 50ms. It
+ *    spins 35ms in each of 20 periods, for 1s in all.
+ *
+ * O runs only while W boosts it. It must get at most W's runtime in each
+ * of W's periods: 10% of the CPU. That fits with V's 70%. If each boost
+ * started a new period of W for O, O would get 1ms at every wait, with a
+ * deadline 10ms away. It would then run at every boost, before V. The
+ * case fails if V runs less than 95% of its 700ms, or if W waits fewer
+ * than 100 times.
+ */
+static int pi_owner_reboost_loop(void)
+{
+	return reboost_loop_case(1);
+}
+
+/*
+ * As pi_owner_reboost_loop(), with two owners, each holding its own lock.
+ * W waits for the two locks in turn. The limit applies to each owner
+ * separately: each can get W's runtime in each of W's periods. Together
+ * they can get 20% of the CPU, which still fits with V's 70%. The case
+ * fails as pi_owner_reboost_loop() does.
+ */
+static int pi_owners_reboost_loop(void)
+{
+	return reboost_loop_case(2);
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
@@ -2885,8 +6134,8 @@ static int take_l2_ranked(atomic_int *rank)
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
@@ -3224,6 +6473,137 @@ static int boost_blocked_keeps_order(void)
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
+ * 3. The main thread gives W 1ms every 10ms. W has not run, so it owes
+ *    nothing: it starts a new period at once. Its deadline is 10ms ahead.
+ * 4. The holder drops pi_lock2.
+ *
+ * W must take pi_lock2 first. W is not queued at step 3. Unless its
+ * period is fitted to its new parameters then, its waiter node keeps the
+ * deadline 1s ahead.
+ */
+static int setattr_blocked_new_period(void)
+{
+	return setattr_blocked_case(0);
+}
+
+/*
+ * The same, when W leaves the class and comes back while it waits. W
+ * first spins 100ms: 60ms more than its share, so its 0-lag time is about
+ * 250ms ahead. At step 3, the main thread switches W to SCHED_OTHER, then
+ * back to SCHED_DEADLINE with 3ms every 10ms. W keeps its parameters
+ * until its 0-lag time, so it comes back with that debt. Repaid at 30%,
+ * the debt puts W's next period about 190ms ahead. W must take pi_lock2
+ * after the other waiter. A new period at once, as a wakeup would start,
+ * would let W take it first.
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
+	err = set_deadline(fair_tid, (reenter ? 3 : 1) * NSEC_PER_MSEC, 10 * NSEC_PER_MSEC);
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
+	} else if (ret == KSFT_PASS && !reenter && chain_rank > x_rank) {
+		ksft_print_msg("W took pi_lock2 after the other waiter\n");
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && reenter && chain_rank < x_rank) {
+		ksft_print_msg("W took pi_lock2 before the other waiter\n");
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
@@ -7171,6 +10551,144 @@ static int params_waking(void)
 	return ret;
 }
 
+/* Two tasks that pass a large runtime back and forth */
+
+#define SW_BIG		(70 * NSEC_PER_MSEC)
+#define SW_SMALL	NSEC_PER_MSEC
+#define SW_MARGIN	(10 * NSEC_PER_MSEC)	/* raise a task of 1ms below this */
+#define SW_SETTLE	(500 * NSEC_PER_MSEC)
+#define SW_WINDOW	(2 * NSEC_PER_SEC)
+#define SW_MAX_SHARE	85			/* fail at this % of P's CPU */
+
+/*
+ * sw_state[i] is 1 once task i is in P, and -1 if it could not enter.
+ * sw_state[2 + i] is the CPU time it used, in us.
+ */
+static atomic_int *sw_state;
+
+/*
+ * Fork task @i of params_swap_overload() into P. It spins, and writes
+ * the CPU time it used to sw_state[2 + @i]. Return its pid, or -1.
+ */
+static pid_t sw_task(int i)
+{
+	pid_t pid = fork_child("a task of the swap");
+	uint64_t c0;
+
+	if (pid)
+		return pid;
+	if (enter(cg_p, getpid())) {
+		sw_state[i] = -1;
+		_exit(1);
+	}
+	c0 = thread_time_ns();
+	sw_state[i] = 1;
+	for (;;)
+		sw_state[2 + i] = (thread_time_ns() - c0) / NSEC_PER_USEC;
+}
+
+/*
+ * Pass a runtime of 70ms back and forth between two tasks, as in
+ * Example 1 of "On the Defectiveness of SCHED_DEADLINE w.r.t. Tardiness
+ * and Affinities, and a Partial Fix", Tang, Anderson and Abeni, RTNS
+ * 2021. P has one CPU. A and B are processes in P that spin. The main
+ * process, outside P, changes their parameters with sched_setattr():
+ * 1. It makes A a deadline task of 70ms every 100ms. This releases a
+ *    job of 70ms. It then cuts the runtime of A to 1ms.
+ * 2. It does the same with B.
+ * 3. For 2.5s, it polls the runtime left of A and B in /proc. It cuts a
+ *    task of 70ms to 1ms once the task is refilled. It raises a task of
+ *    1ms to 70ms when less than 10ms is left, if the other one is a task
+ *    of 1ms. The next job of the raised task then gets 70ms.
+ *
+ * Admission control sees at most 71% of the CPU, plus the fair server.
+ * If a change keeps the runtime of the job in progress, every job gets
+ * 70ms. A and B then ask for 140% of the CPU, and get the whole CPU. A
+ * change must cap the runtime left at the new runtime, and keep the debt
+ * of the task. A and B then get no more than their 71%. The case fails if
+ * they get 85% of the CPU or more in the last 2s.
+ *
+ * The paper uses 94ms. P cannot admit 94ms and 1ms: its limit is 95%,
+ * and its fair server takes 5% of it. In the paper, the tardiness also
+ * grows without bound. Here it does not: a change of a task past its
+ * deadline starts a new period. So the case measures the CPU time of A
+ * and B, not their deadlines.
+ */
+static int params_swap_overload(void)
+{
+	uint64_t param[2] = { SW_SMALL, SW_SMALL }, start, t, t0 = 0, t1;
+	int cpu0[2] = { 0, 0 }, err = 0, i, changes = 0, ret = KSFT_FAIL;
+	pid_t pid[2] = { -1, -1 };
+	long long used[2];
+
+	sw_state = mv_state + 8;
+	for (i = 0; i < 4; i++)
+		sw_state[i] = 0;
+	pid[0] = sw_task(0);
+	pid[1] = sw_task(1);
+	if (pid[0] < 0 || pid[1] < 0)
+		goto out;
+	if (wait_for(5000, sw_state[0] && sw_state[1]) ||
+	    sw_state[0] < 0 || sw_state[1] < 0) {
+		ksft_print_msg("the tasks could not enter P\n");
+		goto out;
+	}
+	for (i = 0; i < 2 && !err; i++) {
+		err = set_deadline(pid[i], SW_BIG, PERIOD);
+		if (!err)
+			err = set_deadline(pid[i], SW_SMALL, PERIOD);
+	}
+	if (err) {
+		ksft_print_msg("no room for a task of 70ms in P: %s\n", strerror(-err));
+		ret = err == -EBUSY ? KSFT_SKIP : KSFT_FAIL;
+		goto out;
+	}
+	start = now_ns();
+	while (!err && (t = now_ns()) < start + SW_SETTLE + SW_WINDOW) {
+		if (!t0 && t >= start + SW_SETTLE) {
+			t0 = t;
+			cpu0[0] = sw_state[2];
+			cpu0[1] = sw_state[3];
+		}
+		for (i = 0; i < 2 && !err; i++) {
+			long long left = dl_runtime_left(pid[i]);
+			uint64_t to;
+
+			if (param[i] == SW_BIG && left > (long long)SW_BIG / 2)
+				to = SW_SMALL;
+			else if (param[i] == SW_SMALL && left < (long long)SW_MARGIN &&
+				 param[!i] == SW_SMALL)
+				to = SW_BIG;
+			else
+				continue;
+			err = set_deadline(pid[i], to, PERIOD);
+			param[i] = to;
+			changes++;
+		}
+		sleep_ns(100 * NSEC_PER_USEC);
+	}
+	t1 = now_ns();
+	used[0] = sw_state[2] - cpu0[0];
+	used[1] = sw_state[3] - cpu0[1];
+	if (err) {
+		ksft_print_msg("a change refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (100000 * (used[0] + used[1]) >= SW_MAX_SHARE * (long long)(t1 - t0)) {
+		ksft_print_msg("A %lld%%, B %lld%% of the CPU, %d changes\n",
+			       100000 * used[0] / (long long)(t1 - t0),
+			       100000 * used[1] / (long long)(t1 - t0), changes);
+		ksft_print_msg("A and B got %d%% or more, with 71%% admitted\n",
+			       SW_MAX_SHARE);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid[0]);
+	reap(pid[1]);
+	return ret;
+}
+
 /* A random mix of the transitions above */
 
 #define MIX_WORKERS	6
@@ -11452,11 +14970,49 @@ static const struct p_case {
 	{ "deboost_out_after_donor_refill", deboost_out_after_donor_refill, MEASURED_IN_P },
 	{ "deboost_out_asleep_after_refill", deboost_out_asleep_after_refill, MEASURED_IN_P },
 	{ "deboost_in_asleep_after_refill", deboost_in_asleep_after_refill, MEASURED_IN_P },
+	{ "deboost_out_new_params", deboost_out_new_params, MEASURED_IN_P },
 	{ "requeue_pi_new_period", requeue_pi_new_period, MEASURED_IN_P },
 	{ "deboost_keeps_own_runtime", deboost_keeps_own_runtime, MEASURED_IN_P },
+	{ "return_running_new_params", return_running_new_params, MEASURED_IN_P },
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
+	{ "change_running_new_params", change_running_new_params, MEASURED_IN_P },
+	{ "change_boosted_new_params", change_boosted_new_params, MEASURED_IN_P },
+	{ "change_constrained_new_params", change_constrained_new_params, MEASURED_IN_P },
+	{ "wake_constrained_new_params", wake_constrained_new_params, MEASURED_IN_P },
+	{ "constrained_gap_change_running", constrained_gap_change_running, MEASURED_IN_P },
+	{ "reenter_pi_blocked_in_gap", reenter_pi_blocked_in_gap, MEASURED_IN_P },
+	{ "reenter_asleep_in_gap", reenter_asleep_in_gap, MEASURED_IN_P },
+	{ "reenter_asleep_late_in_gap", reenter_asleep_late_in_gap, MEASURED_IN_P },
+	{ "reenter_runnable_in_gap", reenter_runnable_in_gap, MEASURED_IN_P },
+	{ "wake_after_deadline_shrunk", wake_after_deadline_shrunk, MEASURED_IN_P },
+	{ "deadline_grows_running", deadline_grows_running, MEASURED_IN_P },
+	{ "deadline_widened_asleep", deadline_widened_asleep, MEASURED_IN_P },
+	{ "period_shrunk_throttled", period_shrunk_throttled, MEASURED_IN_P },
+	{ "period_shrunk_throttled_started", period_shrunk_throttled_started, MEASURED_IN_P },
+	{ "period_shrunk_running", period_shrunk_running, MEASURED_IN_P },
+	{ "period_grown_running", period_grown_running, MEASURED_IN_P },
+	{ "period_grown_untouched", period_grown_untouched, MEASURED_IN_P },
+	{ "runtime_raised_waited", runtime_raised_waited, MEASURED_IN_P },
+	{ "params_flip_no_gain", params_flip_no_gain, MEASURED_IN_P },
+	{ "period_shrunk_no_burst", period_shrunk_no_burst, MEASURED_IN_P },
+	{ "constrained_after_job", constrained_after_job, MEASURED_IN_P },
+	{ "deboost_new_params_reboost", deboost_new_params_reboost, MEASURED_IN_P },
+	{ "deboost_asleep_new_params", deboost_asleep_new_params, MEASURED_IN_P },
+	{ "pi_owner_asleep_in_gap", pi_owner_asleep_in_gap, MEASURED_IN_P },
+	{ "pi_owner_throttled", pi_owner_throttled, MEASURED_IN_P },
+	{ "pi_owner_runs_out_later", pi_owner_runs_out_later, MEASURED_IN_P },
+	{ "pi_owner_wakes_in_gap_later", pi_owner_wakes_in_gap_later, MEASURED_IN_P },
+	{ "pi_owner_handed_off", pi_owner_handed_off, MEASURED_IN_P },
+	{ "pi_owner_throttled_asleep", pi_owner_throttled_asleep, MEASURED_IN_P },
+	{ "pi_owner_held_new_params", pi_owner_held_new_params, MEASURED_IN_P },
+	{ "pi_owner_throttled_rival", pi_owner_throttled_rival, MEASURED_IN_P },
+	{ "pi_owner_held_long", pi_owner_held_long, MEASURED_IN_P },
+	{ "pi_owner_reboost_loop", pi_owner_reboost_loop, MEASURED_IN_P },
+	{ "pi_owners_reboost_loop", pi_owners_reboost_loop, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
 	{ "setattr_blocked_keeps_order", setattr_blocked_keeps_order, MEASURED_IN_P },
+	{ "setattr_blocked_new_period", setattr_blocked_new_period, MEASURED_IN_P },
+	{ "setattr_blocked_reenter", setattr_blocked_reenter, MEASURED_IN_P },
 	{ "boost_blocked_keeps_order", boost_blocked_keeps_order, MEASURED_IN_P },
 	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
 	{ "pi_chain_top_moves", pi_chain_top_moves, MEASURED_IN_P },
@@ -11510,6 +15066,7 @@ static const struct p_case {
 	{ "server_states", server_states, FROM_OUTSIDE },
 	{ "server_reclaim", server_reclaim, MEASURED_IN_P },
 	{ "params_waking", params_waking, FROM_OUTSIDE },
+	{ "params_swap_overload", params_swap_overload, FROM_OUTSIDE },
 	{ "random_mix", random_mix, FROM_OUTSIDE },
 	{ "move_normalized", move_normalized, FROM_OUTSIDE },
 };
@@ -11842,6 +15399,7 @@ static void run_p_cases(void)
 	}
 	for (i = 0; i < N_P_CASES; i++) {
 		const struct p_case *c = &p_cases[i];
+		long long bw0 = total_bw_of(top_cpu(1));
 
 		if (ok && make_p()) {
 			remove_p();
@@ -11861,6 +15419,19 @@ static void run_p_cases(void)
 			ret = c->fn();
 		remove_p();
 		server_restore();
+		/*
+		 * A task of the case can keep its bandwidth counted after it
+		 * exits: until its 0-lag time, or until its debt is repaid. Wait
+		 * for that, so that the next case starts from the same total_bw.
+		 * A lower total_bw also ends the wait. Bandwidth lost by a case
+		 * would never come back, and the wait would then cost the whole
+		 * 10s.
+		 */
+		if (bw0 >= 0 &&
+		    wait_for_step(10000, 10 * NSEC_PER_MSEC,
+				  total_bw_of(top_cpu(1)) <= bw0))
+			ksft_print_msg("%s: total_bw %lld after the case, %lld before\n",
+				       c->name, total_bw_of(top_cpu(1)), bw0);
 		report(c->name, ret);
 	}
 	if (added && write_file(root, "cgroup.subtree_control", "-cpuset"))
-- 
2.47.3

