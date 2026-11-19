Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119390;
	b=Ia11KYsK6lPxmeMtJNO3kowSBAUGSv82TKT+7DzUYKtT/+5LR4yPXiteBhljum0PS99d
	 ZTwE53SaNMdWD7ptoO0ElVCCizpGsJaRJATFDgCE0/qshyhGDVDRo2AIjjUf7wWC8qM8N
	 lM2pRSVn+UE7c7hxFlmoC/7siosMR+xsSpTPlbVZ2i3c5tnFsokdD6oJOjfx71n3qyT7F
	 IPt1/6qec/+f7iRTfpmnhkX1GY6DanHOSLHFLyV85yuUfWidaxTaJGMUvw9BHMxmaQ20k
	 yaIaBsfpIqU/iqrdGTcUEJAlqlCsyJp7rMpq1K0CGvW+BlXAQ7JoCSOKOK/R31btwCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119390;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=A4c4fSBFkLM1NlHXZXhx9U6uyxz8jTzDAehMSamsQuA=;
	b=OqJE3FruC8/FxYx68w6Ag9pEVh+ZBYUVxvQJprHMOrIRKo2v5900rn04YvDCkqbpq/V3
	 QIS7hYktxHaa5G3picMTIad82OBcbD2aLKt4FrgL6Q8LpUy7eFB4Y2E9pVosXLBC7kwW8
	 iHQV5hsvVUPL/k23XDh2Vk/1qGlSuDffnna6CK4jpYS2VhAjKfQdF9nPEhFeloLUcoxy5
	 0+2+OYkCX0ML/NaKalatYx419W3CcvCVEoW/DmBkyj7CUGmo8vaKNx6s0mvHKA4jJAMwe
	 3Z1fbfwo4Ys5qxjjXY/TAznc2BZHxSk3PrkSJN3wK/OKt8X80/IZEVndefKiAwCORPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FcWs1hAD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BBC60A6F4E;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2BBC60A6F4E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FcWs1hAD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119382;
	bh=A4c4fSBFkLM1NlHXZXhx9U6uyxz8jTzDAehMSamsQuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcWs1hADkxX3TnWKvbbcaGNhH1xQtGSU0upn6/vhDvBQzLepz/cKWHbOmWVOmLRyE
	 OJI2Rz0EAiC8FX9bbV47d1/80naKgle2aKKNr4mNF+kJR99yC6vdmEvIOqxt7Onp1u
	 YpQDI1A9Ck020tQ/k9l+uJU/o/TeSkRzroHwIVVFlmeG495AfavmF/Zkehh75mX5te
	 GGhPZoELlu33teS8/E66tsRDdkChl13DAreDNtVHZT04JFfaKQdKUbW1C4vnziqdss
	 ov88ACrjxJjQmxmUucr7eqIwkGDHutEQynvm2SRFi43tUgfdesr3plSwf3/2wD2PJp
	 RzMHo3OZQj7rA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVZ4HhxzS7k;
	Thu, 19 Nov 2026 15:16:22 -0500 (EST)
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
Subject: [PATCH v8 28/33] selftests/sched: Test deadline boosts in deadline_bw_test
Date: Thu, 19 Nov 2026 15:16:07 -0500
Message-Id: <4f77243a593f5f1edfa9db07a559068482076a45.1795116791.git.mathieu.desnoyers@efficios.com>
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

Add the seven cases of deadline_bw_test that test the fixes of priority
inheritance boosts and deboosts, earlier in this series. They cover:
- a deboost after the donor refilled the owner's runtime, in the class
  and out of it
- a deboost of an owner that left the class asleep, or that enters the
  class while boosted
- a former deadline owner that sleeps with the lock
- the order of the waiters of a lock, when sched_setattr() or a boost
  puts a waiter in the class while it waits

The comment above each case gives its scenario.

The message of each fix names the cases that test it.
deboost_released_resets_period and pi_former_owner_asleep are not named
there. They fail on v7.4-rc2, and pass with the first series alone.
They test deboosts, so they come here.

On v7.4-rc2, in 8 VMs of 8 CPUs, six of these cases fail in every VM:
- boost_blocked_keeps_order
- deboost_after_donor_refill
- deboost_in_class_resets_period
- deboost_released_resets_period
- pi_former_owner_asleep
- setattr_blocked_keeps_order

deboost_out_after_donor_refill is new, and was not run there. It fails
without "sched/deadline: Start a period at a deboost out of the class".

With the fixes up to here, every case passes wherever it runs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 479 ++++++++++++++++--
 1 file changed, 444 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index c83e0272771f..fe63c8f093e7 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -880,12 +880,31 @@ static int pi_chain_two_owners(void)
 }
 
 /*
- * Run as the owner thread: take pi_lock, and sleep 400ms while holding
- * it. Return NULL, or 1 on an error.
+ * Run as the owner thread. With @arg (was_dl) set, first become a
+ * deadline task of 30ms every 100ms, run 1ms, and sleep on owner_go. The
+ * main thread switches the owner to SCHED_OTHER during that sleep. Then
+ * take pi_lock, and sleep 400ms while holding it. Return NULL, or 1 on an
+ * error.
  */
 static void *sleeping_owner(void *arg)
 {
+	int was_dl = (long)arg;
+
 	owner_tid = gettid_();
+	if (was_dl) {
+		if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+			owner_holds = -1;
+			sem_post(&owner_ready);
+			return (void *)1;
+		}
+		spin_ns(NSEC_PER_MSEC);
+		/*
+		 * Sleep. The main thread switches this thread to SCHED_OTHER
+		 * 200ms later, past its 0-lag time.
+		 */
+		sem_post(&owner_ready);
+		sem_wait_sig(&owner_go);
+	}
 	if (take_pi_lock())
 		return (void *)1;
 	owner_holds = 2;
@@ -896,30 +915,47 @@ static void *sleeping_owner(void *arg)
 
 /*
  * A SCHED_OTHER owner takes pi_lock and sleeps 400ms while holding it.
- * The main thread then waits 20ms for the lock, 5 times. For each wait it
- * becomes a deadline task of 5ms every 50ms. Each wait boosts the
+ * The main thread then waits 20ms for the lock, @rounds times. For each
+ * wait it becomes a deadline task of 5ms every 50ms. Each wait boosts the
  * sleeping owner, and its timeout deboosts it. Every wait must time out.
+ *
+ * With @was_dl, the owner was a deadline task of 30ms every 100ms before.
+ * It ran 1ms and slept. The main thread switched it to SCHED_OTHER 200ms
+ * later, past its 0-lag time.
  */
-static int pi_other_owner_asleep(void)
+static int pi_asleep(int was_dl, int rounds)
 {
 	pthread_t o;
 	int r, ret = KSFT_PASS;
 
 	if (pi_init())
 		return KSFT_SKIP;
-	if (pthread_create(&o, NULL, sleeping_owner, NULL)) {
+	if (pthread_create(&o, NULL, sleeping_owner, (void *)(long)was_dl)) {
 		ksft_print_msg("the owner thread could not start\n");
 		return KSFT_FAIL;
 	}
-	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+	if (was_dl) {
+		if (sem_wait_for(&owner_ready, 5000)) {
+			ksft_print_msg("the owner did not become a deadline task\n");
+			ret = KSFT_FAIL;
+		} else {
+			sleep_ns(200 * NSEC_PER_MSEC);
+			if (set_other(owner_tid)) {
+				ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+				ret = KSFT_FAIL;
+			}
+		}
+		sem_post(&owner_go);
+	}
+	if (ret == KSFT_PASS && (wait_for(5000, owner_holds) || owner_holds != 2)) {
 		ksft_print_msg("the owner never took the lock\n");
 		ret = KSFT_FAIL;
 	}
 	if (ret == KSFT_PASS)
 		sleep_ns(20 * NSEC_PER_MSEC);
-	for (r = 0; r < 5 && ret == KSFT_PASS; r++) {
+	for (r = 0; r < rounds && ret == KSFT_PASS; r++) {
 		if (wait_lock_for(20, 1)) {
-			ksft_print_msg("round %d of 5 failed\n", r + 1);
+			ksft_print_msg("round %d of %d failed\n", r + 1, rounds);
 			ret = KSFT_FAIL;
 		}
 	}
@@ -927,6 +963,16 @@ static int pi_other_owner_asleep(void)
 	return ret;
 }
 
+static int pi_other_owner_asleep(void)
+{
+	return pi_asleep(0, 5);
+}
+
+static int pi_former_owner_asleep(void)
+{
+	return pi_asleep(1, 5);
+}
+
 /*
  * Run as the owner thread. Become a deadline task of 30ms every 100ms,
  * and take pi_lock. Hold it for 300ms, spinning 2ms and sleeping 5ms in
@@ -1635,9 +1681,9 @@ static atomic_int owner_first_period_ms;
 static _Atomic pid_t donor_tid;
 
 /*
- * Run as the owner O of deboost_resets_period(). Store the CPU time of
- * step 4, in ms, in owner_first_period_ms. Return NULL, 1 on an error, or
- * 2 if no waiter boosted it within 1s.
+ * Run as the owner O of deboost_case(). @arg is its @mode. Store the CPU
+ * time of step 4, in ms, in owner_first_period_ms. Return NULL, 1 on an
+ * error, or 2 if no waiter boosted it within 1s.
  */
 static void *deboosted_owner(void *arg)
 {
@@ -1645,6 +1691,17 @@ static void *deboosted_owner(void *arg)
 	int err;
 
 	owner_tid = gettid_();
+	if (arg == (void *)1L) {
+		err = set_deadline(0, 60 * NSEC_PER_MSEC, PERIOD);
+		if (err) {
+			ksft_print_msg("the owner refused as a deadline task: %s\n",
+				       strerror(-err));
+			return (void *)1;
+		}
+		spin_ns(NSEC_PER_MSEC);
+		sem_post(&owner_ready);
+		sem_wait_sig(&owner_go);
+	}
 	if (take_pi_lock())
 		return (void *)1;
 	owner_holds = 2;
@@ -1655,9 +1712,18 @@ static void *deboosted_owner(void *arg)
 			return (void *)2;	/* never boosted */
 		}
 	}
+	if (arg == (void *)2L) {
+		err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+		if (err) {
+			ksft_print_msg("the boosted owner refused as a deadline task: %s\n",
+				       strerror(-err));
+			drop_pi_lock();
+			return (void *)1;
+		}
+	}
 	spin_ns(5 * NSEC_PER_MSEC);
 	drop_pi_lock();
-	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	err = arg == (void *)2L ? 0 : set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
 	if (err) {
 		ksft_print_msg("the owner refused as a deadline task: %s\n", strerror(-err));
 		return (void *)1;
@@ -1694,8 +1760,8 @@ static void *donor_waiter(void *arg)
 }
 
 /*
- * The owner O starts as SCHED_OTHER. The donor D is the waiter that
- * boosts it: a deadline task of 40ms every 100ms.
+ * Run a deboost case. The owner O starts as SCHED_OTHER. The donor D is
+ * the waiter that boosts it: a deadline task of 40ms every 100ms.
  * 1. O takes pi_lock and spins.
  * 2. D blocks on pi_lock. This boosts O, which then runs on D's runtime.
  * 3. O spins 5ms more and unlocks. The unlock deboosts O.
@@ -1704,8 +1770,16 @@ static void *donor_waiter(void *arg)
  *
  * O must get about 10ms in step 4. The case fails above 20ms: O then
  * still runs on the runtime that the boost left.
+ *
+ * @mode changes one step:
+ * - 0: nothing.
+ * - 1: before step 1, O runs 1ms as a deadline task of 60ms every 100ms,
+ *   and sleeps. The main thread switches it to SCHED_OTHER 300ms later,
+ *   past its 0-lag time.
+ * - 2: O becomes the deadline task of step 4 in step 3 instead, before
+ *   the 5ms. It stays in the deadline class at the deboost.
  */
-static int deboost_resets_period(void)
+static int deboost_case(long mode)
 {
 	int err, ret = KSFT_PASS;
 	void *o_ret, *w_ret;
@@ -1714,10 +1788,27 @@ static int deboost_resets_period(void)
 	if (pi_init())
 		return KSFT_SKIP;
 	owner_first_period_ms = -1;
-	if (pthread_create(&o, NULL, deboosted_owner, NULL)) {
+	if (pthread_create(&o, NULL, deboosted_owner, (void *)mode)) {
 		ksft_print_msg("the owner thread could not start\n");
 		return KSFT_FAIL;
 	}
+	if (mode == 1) {
+		if (sem_wait_for(&owner_ready, 5000)) {
+			/* The owner may get there late. Let it end. */
+			sem_post(&owner_go);
+			join(o);
+			return KSFT_FAIL;	/* the owner said why */
+		}
+		sleep_ns(3 * PERIOD);
+		err = proc_state_of(owner_tid) == 'S' ? set_other(owner_tid) : -EAGAIN;
+		sem_post(&owner_go);
+		if (err) {
+			ksft_print_msg("the owner could not leave the class asleep: %s\n",
+				       strerror(-err));
+			join(o);
+			return KSFT_FAIL;
+		}
+	}
 	if (wait_for(5000, owner_holds) || owner_holds != 2) {
 		ksft_print_msg("the owner never took the lock\n");
 		join(o);
@@ -1752,6 +1843,27 @@ static int deboost_resets_period(void)
 	return ret;
 }
 
+/* Run deboost_case() with a plain SCHED_OTHER owner. */
+static int deboost_resets_period(void)
+{
+	return deboost_case(0);
+}
+
+/*
+ * Run deboost_case() with an owner that left the deadline class asleep.
+ * Its bandwidth was released then.
+ */
+static int deboost_released_resets_period(void)
+{
+	return deboost_case(1);
+}
+
+/* Run deboost_case() with an owner that enters the class while boosted. */
+static int deboost_in_class_resets_period(void)
+{
+	return deboost_case(2);
+}
+
 /*
  * Return the runtime that the deadline task @tid has left, in ns, from
  * dl.runtime in /proc/<tid>/sched. Return -1 if it cannot be read.
@@ -1782,14 +1894,16 @@ static long long dl_runtime_left(pid_t tid)
 #define REFILL_DONOR_RUNTIME	(2 * NSEC_PER_MSEC)
 #define REFILL_DONOR_PERIOD	(10 * NSEC_PER_MSEC)
 
-static sem_t refill_donor_ready;
-static atomic_int refill_donor_locking;
+static sem_t refill_donor_ready, refill_measured;
+static atomic_int refill_donor_locking, refill_hold_donor;
 static _Atomic long long refill_owner_left;
 
 /*
- * Run as the donor D of deboost_keeps_own_runtime(). Become a deadline
- * task of 2ms every 10ms and sleep until the owner holds pi_lock. Then
- * block on pi_lock. Return NULL once it got the lock, or 1 on an error.
+ * Run as the donor D of refill_case(). Become a deadline task of 2ms
+ * every 10ms and sleep until the owner holds pi_lock. Then block on
+ * pi_lock. With refill_hold_donor, stay a deadline task after the unlock
+ * until refill_measured is posted. Return NULL once it got the lock, or 1
+ * on an error.
  */
 static void *refill_donor(void *arg)
 {
@@ -1809,16 +1923,18 @@ static void *refill_donor(void *arg)
 	err = take_pi_lock();
 	if (!err)
 		drop_pi_lock();
+	if (refill_hold_donor)
+		sem_wait_sig(&refill_measured);
 	if (set_other(0))
 		ksft_print_msg("the donor cannot leave SCHED_DEADLINE\n");
 	return (void *)(long)err;
 }
 
 /*
- * Run as the owner O of deboost_keeps_own_runtime(). @arg is the CPU
- * time, in ms, that O spins with the lock once it is boosted. Store the
- * runtime O has left after the unlock in refill_owner_left. Return NULL,
- * 1 on an error, or 2 if the donor did not block on the lock within 1s.
+ * Run as the owner O of refill_case(). @arg is the CPU time, in ms, that
+ * O spins with the lock once it is boosted. Store the runtime O has left
+ * after the unlock in refill_owner_left. Return NULL, 1 on an error, or 2
+ * if the donor did not block on the lock within 1s.
  */
 static void *refill_owner(void *arg)
 {
@@ -1865,18 +1981,25 @@ static void *refill_owner(void *arg)
  *                                        preempts O: its deadline is
  *                                          earlier
  *                                        blocks on pi_lock, boosts O
- *   runs 1ms more
+ *   runs @spin_ms more
  *   unlocks: the boost ends
  *                                        takes pi_lock, unlocks
  *   reads its dl.runtime
  *
  * A boosted task that runs out of runtime is not throttled. Its runtime
- * is refilled from the parameters of its donor. Here O has used about 3ms
- * of its own 5ms at the unlock, and was never refilled. It must keep what
- * it has left. A new period would hand it a full runtime at every
- * contended unlock. The case fails if O has 4ms or more.
+ * is refilled from the parameters of its donor: 2ms here.
+ *
+ * - @spin_ms is 8: O runs out of its own 5ms, and is refilled from D at
+ *   least once. At the unlock it holds what the last refill left, 2ms at
+ *   most. That is not the runtime of its own reservation. O must start a
+ *   new period at the unlock, with 5ms. The case fails if O has 3.5ms or
+ *   less.
+ * - @spin_ms is 1: O has used about 3ms of its own 5ms at the unlock, and
+ *   was never refilled. It must keep what it has left. A new period would
+ *   hand it a full runtime at every contended unlock. The case fails if O
+ *   has 4ms or more.
  */
-static int deboost_keeps_own_runtime(void)
+static int refill_case(long spin_ms)
 {
 	void *o_ret = NULL, *d_ret = NULL;
 	int err, ret = KSFT_PASS;
@@ -1903,7 +2026,7 @@ static int deboost_keeps_own_runtime(void)
 		join(d);
 		return KSFT_FAIL;
 	}
-	if (pthread_create(&o, NULL, refill_owner, (void *)1L)) {
+	if (pthread_create(&o, NULL, refill_owner, (void *)spin_ms)) {
 		ksft_print_msg("the owner thread could not start\n");
 		sem_post(&owner_go);
 		join(d);
@@ -1930,7 +2053,11 @@ static int deboost_keeps_own_runtime(void)
 	} else if (left < 0) {
 		ksft_print_msg("the runtime of the owner cannot be read\n");
 		ret = KSFT_SKIP;
-	} else if (left >= 4 * NSEC_PER_MSEC) {
+	} else if (spin_ms == 8 && left <= 3500 * NSEC_PER_USEC) {
+		ksft_print_msg("the owner has %lld us after the unlock: what the donor's refill left\n",
+			       left / NSEC_PER_USEC);
+		ret = KSFT_FAIL;
+	} else if (spin_ms == 1 && left >= 4 * NSEC_PER_MSEC) {
 		ksft_print_msg("the owner has %lld us after the unlock: a new runtime, with no refill from the donor\n",
 			       left / NSEC_PER_USEC);
 		ret = KSFT_FAIL;
@@ -1938,6 +2065,157 @@ static int deboost_keeps_own_runtime(void)
 	return ret;
 }
 
+/* Run refill_case() with an owner that is refilled from its donor. */
+static int deboost_after_donor_refill(void)
+{
+	return refill_case(8);
+}
+
+/* Run refill_case() with an owner that stays on its own runtime. */
+static int deboost_keeps_own_runtime(void)
+{
+	return refill_case(1);
+}
+
+/*
+ * Run as the owner O of deboost_out_after_donor_refill(). Store total_bw
+ * of O's root domain right after the unlock in refill_owner_left. Return
+ * NULL, 1 on an error, or 2 if the donor did not block on the lock within
+ * 1s.
+ */
+static void *former_owner(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	owner_tid = gettid_();
+	err = set_deadline(0, REFILL_OWN_RUNTIME, PERIOD);
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(2 * NSEC_PER_MSEC);
+	if (take_pi_lock())
+		return (void *)1;
+	if (set_other(0)) {
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+		drop_pi_lock();
+		return (void *)1;
+	}
+	owner_holds = 2;
+	sem_post(&owner_go);
+	t0 = now_ns();
+	while (!refill_donor_locking || proc_state_of(donor_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			drop_pi_lock();
+			return (void *)2;
+		}
+	}
+	spin_ns(8 * NSEC_PER_MSEC);
+	drop_pi_lock();
+	refill_owner_left = total_bw_of(top_cpu(1));
+	sem_post(&refill_measured);
+	return NULL;
+}
+
+/*
+ * As refill_case() with @spin_ms 8, but O leaves SCHED_DEADLINE once it
+ * holds pi_lock. O and D share the CPU of P.
+ *
+ *   owner O: 5ms every 100ms             donor D: 2ms every 10ms
+ *
+ *                                        sleeps
+ *   starts its period, runs 2ms
+ *   takes pi_lock
+ *   switches to SCHED_OTHER: its 0-lag
+ *     time is about 40ms ahead
+ *   wakes D up
+ *                                        preempts O
+ *                                        blocks on pi_lock, boosts O
+ *   runs 8ms: runs out of its own
+ *     runtime, is refilled from D
+ *   unlocks: leaves the class
+ *                                        takes pi_lock, unlocks, waits
+ *   reads total_bw
+ *
+ * At the unlock, O's runtime and deadline come from D's refills. O must
+ * start a period of its own there. Its 0-lag time is then now, and its
+ * bandwidth must be gone from total_bw at once. Mixed with O's own
+ * parameters, the runtime and deadline of the refills put the 0-lag time
+ * about 100ms ahead.
+ */
+static int deboost_out_after_donor_refill(void)
+{
+	void *o_ret = NULL, *d_ret = NULL;
+	int err, ret = KSFT_PASS;
+	long long base;
+	pthread_t o, d;
+
+	if (total_bw_of(top_cpu(1)) < 0) {
+		ksft_print_msg("sched_debug tells of no total_bw\n");
+		return KSFT_SKIP;
+	}
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&refill_donor_ready, 0, 0) || sem_init(&refill_measured, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	refill_donor_locking = 0;
+	refill_hold_donor = 1;
+	refill_owner_left = -1;
+	donor_tid = 0;
+	if (pthread_create(&d, NULL, refill_donor, NULL)) {
+		ksft_print_msg("the donor thread could not start\n");
+		refill_hold_donor = 0;
+		return KSFT_FAIL;
+	}
+	if (sem_wait_for(&refill_donor_ready, 5000) || donor_tid <= 0) {
+		ksft_print_msg("the donor is not ready\n");
+		sem_post(&owner_go);
+		sem_post(&refill_measured);
+		join(d);
+		refill_hold_donor = 0;
+		return KSFT_FAIL;
+	}
+	base = total_bw_of(top_cpu(1));	/* with D, without O */
+	if (pthread_create(&o, NULL, former_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&owner_go);
+		sem_post(&refill_measured);
+		join(d);
+		refill_hold_donor = 0;
+		return KSFT_FAIL;
+	}
+	err = pthread_join(o, &o_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	}
+	if (o_ret == (void *)1)
+		sem_post(&owner_go);	/* the owner never woke the donor up */
+	if (o_ret)
+		sem_post(&refill_measured);
+	err = pthread_join(d, &d_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	}
+	refill_hold_donor = 0;
+	if (o_ret == (void *)2) {
+		ksft_print_msg("the donor never blocked on the lock\n");
+		ret = KSFT_FAIL;
+	} else if (o_ret || d_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (refill_owner_left != base) {
+		ksft_print_msg("total_bw %lld right after the unlock, %lld expected\n",
+			       (long long)refill_owner_left, base);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 static sem_t ret_ready, ret_go;
 static _Atomic pid_t ret_tid;
 static atomic_int ret_first_period_ms;
@@ -2032,7 +2310,7 @@ static pthread_mutex_t pi_lock2;
 static sem_t holder_go;
 static atomic_int holder_holds, chain_waits, donor_done, x_waits, l2_takes;
 static atomic_int chain_rank, x_rank;
-static _Atomic pid_t x_tid;
+static _Atomic pid_t x_tid, fair_tid;
 
 /* The holder thread: take pi_lock2, and hold it until holder_go. */
 static void *l2_holder(void *arg)
@@ -2190,6 +2468,7 @@ static int pi_init_lock2(void)
 	x_rank = -1;
 	donor_tid = 0;
 	x_tid = 0;
+	fair_tid = 0;
 	return 0;
 }
 
@@ -2288,6 +2567,129 @@ static int deboost_blocked_keeps_order(void)
 	return ret;
 }
 
+/*
+ * The fair waiter: wait on pi_lock2 as a fair task. With @arg set, hold
+ * pi_lock meanwhile, for a donor to boost it. Otherwise the main thread
+ * makes it a deadline task while it waits. It leaves the class at the end.
+ */
+static void *fair_waiter(void *arg)
+{
+	int err;
+
+	fair_tid = gettid_();
+	if (arg && take_pi_lock())
+		return (void *)1;
+	chain_waits = 1;
+	err = take_l2_ranked(&chain_rank);
+	if (arg)
+		drop_pi_lock();
+	else if (set_other(0))
+		ksft_print_msg("a waiter cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * Check the order of the waiters of pi_lock2 when one of them enters the
+ * class while it waits. The holder has pi_lock2:
+ * 1. The fair waiter waits on pi_lock2. With @boost, it holds pi_lock.
+ * 2. The other waiter, a deadline task, waits on pi_lock2.
+ * 3. The fair waiter enters the class:
+ *    - Without @boost, the main thread makes it a deadline task of 10ms
+ *      every 200ms.
+ *    - With @boost, a donor of 40ms every 100ms waits on pi_lock, and
+ *      boosts it.
+ * 4. The holder drops pi_lock2.
+ *
+ * The other waiter must take pi_lock2 first: it started its period
+ * earlier, with a shorter deadline. At step 3 the fair waiter is not
+ * queued, and the chain walk copies its deadline into its waiter node on
+ * pi_lock2. A deadline of 0 in the node would put the fair waiter first.
+ */
+static int blocked_keeps_order(long boost)
+{
+	void *f_ret = NULL, *x_ret = NULL, *w_ret = NULL;
+	int ret = KSFT_FAIL, have_f = 0, have_x = 0, have_w = 0, err;
+	pthread_t h, f, x, w;
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
+	have_f = !pthread_create(&f, NULL, fair_waiter, (void *)boost);
+	if (!have_f || wait_for(1000, chain_waits && proc_state_of(fair_tid) == 'S')) {
+		ksft_print_msg("the fair waiter never waited on pi_lock2\n");
+		goto out;
+	}
+	have_x = !pthread_create(&x, NULL, early_waiter, NULL);
+	if (!have_x || wait_for(1000, x_waits && proc_state_of(x_tid) == 'S')) {
+		ksft_print_msg("the other waiter never waited on pi_lock2\n");
+		goto out;
+	}
+	if (boost) {
+		have_w = !pthread_create(&w, NULL, donor_waiter, NULL);
+		if (!have_w || wait_for(1000, donor_tid && proc_state_of(donor_tid) == 'S')) {
+			ksft_print_msg("the donor never waited on pi_lock\n");
+			goto out;
+		}
+		if (prio_of(fair_tid) != DL_TASK_PRIO) {
+			ksft_print_msg("the donor never boosted the fair waiter\n");
+			goto out;
+		}
+	} else {
+		err = set_deadline(fair_tid, 10 * NSEC_PER_MSEC, 2 * PERIOD);
+		if (err) {
+			ksft_print_msg("the fair waiter refused as a deadline task: %s\n",
+				       strerror(-err));
+			if (err == -EBUSY)
+				ret = KSFT_SKIP;	/* no room in P */
+			goto out;
+		}
+	}
+	ret = KSFT_PASS;
+out:
+	sem_post(&holder_go);	/* pi_lock2 goes to its top waiter */
+	if (have_w && pthread_join(w, &w_ret))
+		ret = KSFT_FAIL;
+	if (have_x && pthread_join(x, &x_ret))
+		ret = KSFT_FAIL;
+	if (have_f && pthread_join(f, &f_ret))
+		ret = KSFT_FAIL;
+	join(h);
+	if (f_ret || x_ret || w_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (ret == KSFT_PASS && chain_rank < x_rank) {
+		ksft_print_msg("the fair waiter took pi_lock2 before the earlier waiter\n");
+		ret = KSFT_FAIL;
+	}
+out_fini:
+	pthread_mutex_destroy(&pi_lock2);
+	sem_destroy(&holder_go);
+	pi_fini();
+	return ret;
+}
+
+/* sched_setattr() puts the fair waiter in the class. */
+static int setattr_blocked_keeps_order(void)
+{
+	return blocked_keeps_order(0);
+}
+
+/* A boost puts the fair waiter in the class. */
+static int boost_blocked_keeps_order(void)
+{
+	return blocked_keeps_order(1);
+}
+
 /*
  * The threads of pi_chain_donor_leaves(): O, M, W, Z and Y. leave_tid[]
  * holds their tids. leave_y_ns is the CPU time Y gets in O's window, or
@@ -9948,6 +10350,7 @@ static const struct p_case {
 } p_cases[] = {
 	{ "pi_deadline_owner", pi_deadline_owner, MEASURED_IN_P },
 	{ "pi_other_owner_asleep", pi_other_owner_asleep, MEASURED_IN_P },
+	{ "pi_former_owner_asleep", pi_former_owner_asleep, MEASURED_IN_P },
 	{ "pi_unlock_running", pi_unlock_running, MEASURED_IN_P },
 	{ "pi_chain_two_owners", pi_chain_two_owners, MEASURED_IN_P },
 	{ "pi_departed_moved", pi_departed_moved, FROM_OUTSIDE },
@@ -9961,9 +10364,15 @@ static const struct p_case {
 	{ "params_keep_boosted", params_keep_boosted, MEASURED_IN_P },
 	{ "boosted_owner_policy", boosted_owner_policy, MEASURED_IN_P },
 	{ "deboost_resets_period", deboost_resets_period, MEASURED_IN_P },
+	{ "deboost_released_resets_period", deboost_released_resets_period, MEASURED_IN_P },
+	{ "deboost_in_class_resets_period", deboost_in_class_resets_period, MEASURED_IN_P },
+	{ "deboost_after_donor_refill", deboost_after_donor_refill, MEASURED_IN_P },
+	{ "deboost_out_after_donor_refill", deboost_out_after_donor_refill, MEASURED_IN_P },
 	{ "deboost_keeps_own_runtime", deboost_keeps_own_runtime, MEASURED_IN_P },
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
+	{ "setattr_blocked_keeps_order", setattr_blocked_keeps_order, MEASURED_IN_P },
+	{ "boost_blocked_keeps_order", boost_blocked_keeps_order, MEASURED_IN_P },
 	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
 	{ "pi_chain_top_moves", pi_chain_top_moves, MEASURED_IN_P },
 	{ "pi_chain_top_moves_rt", pi_chain_top_moves_rt, MEASURED_IN_P },
-- 
2.47.3

