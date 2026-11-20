Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182966;
	b=KPrwWPRKhoH038Fq+ySdsLeLEKduvQFiTl6Tpz6u2Od5bahh3SiFqU1XqiAcD26wqbha
	 J0Oz98BApsDBcoWls9fB2eNfa+S7JO81QEcJn+f1dU0hS6LM48LkYzIhihSj7DF8QZixL
	 wiUaTFfC14PmYS2y4jnuQ6dN0l21zAV3Z6xE7O1J5zxf0S6zbfYS+xO9pNhEFf+zMJQuR
	 OOZJEhOqFdS9n1TiBbo0SLPk24tHrZZ9MqaJPm4R77Ys5G9Exls3yzgncFp2tMbwSXj3o
	 0fzcB6og1VfiinYW9nsyW/08HGp/IQAjyBMowqh0eyHBuOpXHBIoqKnm8DuTZvKrm4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182966;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vkrg0oJk2aa2N4vvT20mpb2nXrxQABypSo5M2dmOD6c=;
	b=kL/t6EfhFIX41xU5SDCWYI6USCwJXzR205FnLpoZgwpUkgI4nofScCb3xQBPX3aqB5wr
	 8P6nQqreI9N0fB5qA9quj1DBvWPCxhlNJjV3upzHUyFxnFyZJFl2MyLmDYBndQGpUzDP3
	 8bokpy4gkzzV3IXzr0FedRLt0q8fT5Yai824TnX3XtOaVVniCG/lU1dvrNwR16ZLEO46h
	 wogq+uB7riPMBhSTuoUR2252Ta5xV3J36fYDlNgtwFBJoujs2WVCqgSuy8NJypBVgYGgD
	 lNGgHviLmOHT9rIfVb0T9+xDVHidlr1fdNkak0dv2ggpD/gXLMNJv6D/83qyn+nK9Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xOKellMZ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A82606ABFC;
	Fri, 20 Nov 2026 13:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A82606ABFC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xOKellMZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182963;
	bh=vkrg0oJk2aa2N4vvT20mpb2nXrxQABypSo5M2dmOD6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOKellMZoUH9PGF4GjvaROEGk8rNmhyzU50xLTw8+PqUf9DkmR9mULroZnIy0CgsA
	 8GlBo5T1gu/hjnkA9GJfmCTz1Q0wAor5Y1a0DSOPy7oBCs44Uhwbvrmo4XFMYHAlPX
	 pljVUgbe7CE83MZPYXQCOSJcmMF08IKzUnRe+Jl1n+YJy9OkfgxEPdGRoNoijjmex5
	 bOsseCBiSnd7Dc0K2xcJPhFB5uICPmGqVm0PU8NotOWKnKSsZ3jymS5oTIWoKBrv+S
	 ApvGGWHJUpy8F29ARdv8PsDjGqqBAXCUqIhQSXLiHcHifWyFVbzmOpnXKZriV+osvl
	 6J/HBxnZoA3ag==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1H1KNYzV22;
	Fri, 20 Nov 2026 08:56:03 -0500 (EST)
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
Subject: [PATCH v9 22/33] selftests/sched: Test the rtmutex chain walk in deadline_bw_test
Date: Fri, 20 Nov 2026 08:55:45 -0500
Message-Id: <5f2a4ab4ade20ccc46a1cdf43f842bf89f1e4e84.1795181240.git.mathieu.desnoyers@efficios.com>
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

Add pi_chain_top_moves and pi_chain_top_moves_rt to deadline_bw_test.
They test the two rtmutex fixes earlier in this series. In both, a
chain walk changes the top waiter of an owner to a waiter of another
lock it holds. The walk must go on to the next owner. That owner must
then get the new donor, or the new priority. The first case uses
deadline tasks, the second RT tasks. The comment above each
case gives its scenario.

On v7.4-rc2, in 8 VMs of 8 CPUs, pi_chain_top_moves_rt fails in every
VM.
pi_chain_top_moves passes there. It fails with the first series, until
"rtmutex: Continue the chain walk when a waiter's deadline donor
changes" and "rtmutex: Continue the walk when the owner's top waiter
changes lock". It needs both.

With the fixes up to here, both cases pass wherever they run.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 293 ++++++++++++++++++
 1 file changed, 293 insertions(+)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index 2b5cee6597ad..25fbbc3e88d0 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -2521,6 +2521,297 @@ static int pi_chain_donor_leaves(void)
 	return ret;
 }
 
+/*
+ * The threads of top_moves(): O, M, W, Z and Y. top_tid[] holds their
+ * tids. top_lock is L1'. top_y_ns is the CPU time Y gets in O's window,
+ * or -1.
+ */
+enum { TM_O, TM_M, TM_W, TM_Z, TM_Y, TM_N };
+static _Atomic pid_t top_tid[TM_N];
+static pthread_mutex_t top_lock;
+static atomic_int top_err, top_rt, top_m_locking, top_w_locking, top_y_stop;
+static _Atomic long long top_y_ns;
+static sem_t top_o_go, top_m_go;
+
+/* The priority /proc shows for a SCHED_FIFO task of priority @p. */
+#define FIFO_TASK_PRIO(p)	(-1 - (p))
+
+/*
+ * O: take pi_lock2 (L2), and sleep until top_o_go. With Y (@arg), spin
+ * 200ms and measure the CPU time Y gets meanwhile. Then unlock L2.
+ */
+static void *top_o(void *arg)
+{
+	uint64_t t0, y0;
+
+	if (pthread_mutex_lock(&pi_lock2)) {
+		top_err = 1;
+		return arg;
+	}
+	top_tid[TM_O] = gettid_();	/* O holds L2 */
+	sem_wait_sig(&top_o_go);
+	if (arg) {
+		y0 = cpu_time_of(*(pthread_t *)arg);
+		t0 = now_ns();
+		while (now_ns() - t0 < 2 * PERIOD)
+			;
+		top_y_ns = cpu_time_of(*(pthread_t *)arg) - y0;
+	}
+	pthread_mutex_unlock(&pi_lock2);
+	return NULL;
+}
+
+/*
+ * M: take pi_lock (L1) and top_lock (L1'). At top_m_go, block on L2,
+ * which O holds. Unlock L2, L1 and L1' once it gets L2.
+ */
+static void *top_m(void *arg)
+{
+	if (pthread_mutex_lock(&pi_lock)) {
+		top_err = 1;
+		return arg;
+	}
+	if (pthread_mutex_lock(&top_lock)) {
+		pthread_mutex_unlock(&pi_lock);
+		top_err = 1;
+		return arg;
+	}
+	top_tid[TM_M] = gettid_();	/* M holds L1 and L1' */
+	sem_wait_sig(&top_m_go);
+	top_m_locking = 1;
+	if (pthread_mutex_lock(&pi_lock2))
+		top_err = 1;
+	else
+		pthread_mutex_unlock(&pi_lock2);
+	pthread_mutex_unlock(&pi_lock);
+	pthread_mutex_unlock(&top_lock);
+	return arg;
+}
+
+/*
+ * W and Z: W blocks on L1', Z on L1. @arg is 1 for W. With top_rt, W
+ * becomes SCHED_FIFO 50 and Z SCHED_FIFO 20. Otherwise W becomes a
+ * deadline task of 2ms every 80ms and Z one of 5ms every 200ms. The main
+ * thread switches W to SCHED_OTHER while it waits.
+ */
+static void *top_waiter(void *arg)
+{
+	int w = (long)arg;
+	struct sched_param sp = { .sched_priority = w ? 50 : 20 };
+	uint64_t runtime = (w ? 2 : 5) * NSEC_PER_MSEC;
+	pthread_mutex_t *l = w ? &top_lock : &pi_lock;
+
+	if (top_rt ? sched_setscheduler(0, SCHED_FIFO, &sp) :
+		     set_deadline(0, runtime, 40 * runtime)) {
+		top_err = 1;
+		return arg;
+	}
+	top_tid[w ? TM_W : TM_Z] = gettid_();
+	if (w)
+		top_w_locking = 1;
+	if (pthread_mutex_lock(l))
+		top_err = 1;
+	else
+		pthread_mutex_unlock(l);
+	if (set_other(0))
+		top_err = 1;
+	return arg;
+}
+
+/* Y: become a deadline task of 30ms every 100ms, and spin. */
+static void *top_y(void *arg)
+{
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		top_err = 1;
+		return arg;
+	}
+	top_tid[TM_Y] = gettid_();
+	while (!top_y_stop)
+		;
+	return arg;
+}
+
+/*
+ * A chain walk must go on past a task whose top waiter moves to another
+ * lock. The priority of that task changes, and the next owner must
+ * follow.
+ *
+ * L1 is pi_lock, L1' is top_lock and L2 is pi_lock2. All threads run on
+ * the CPU of P. W and Z set their own policy when they start. With @rt,
+ * W is SCHED_FIFO 50 and Z SCHED_FIFO 20. Without @rt, W is a deadline
+ * task of 2ms every 80ms and Z one of 5ms every 200ms. W has the earlier
+ * deadline. O and M are SCHED_OTHER. Without @rt, Y is a deadline task
+ * of 30ms every 100ms. It spins all along.
+ *
+ * 1. O takes L2, and sleeps.
+ * 2. M takes L1 and L1', and sleeps.
+ * 3. W blocks on L1'. W boosts M.
+ * 4. M blocks on L2. M passes W on to O.
+ * 5. Z blocks on L1. W stays the top waiter of M.
+ * 6. The main thread switches W to SCHED_OTHER. The chain walk requeues
+ *    W on L1'. Z on L1 becomes the top waiter of M, and Z boosts M. The
+ *    walk must go on to O. Z must boost O too.
+ *
+ * With @rt, the case reads O's priority. It must be the one of Z. With
+ * the walk stopped at M, O keeps the priority of W.
+ *
+ * Without @rt, W sleeps and has run almost nothing. So its parameters
+ * are cleared at once. 250ms later, the main thread wakes O up. O
+ * measures the CPU time Y gets over the next 200ms, and unlocks L2.
+ *
+ * With Z as its donor, O gets 5ms every 200ms. Y runs at the start of
+ * each of its periods, and gets its 60ms. With W as its donor, O runs on
+ * cleared parameters. Each refill gives it no runtime and a deadline of
+ * about now. O then runs before Y until Y's deadline is past. Y runs
+ * only then, one period late, and gets about 30ms. The case fails if Y
+ * gets less than 45ms.
+ *
+ * W does not exit before O unlocks L2. It waits for L1', which M
+ * releases after it gets L2.
+ */
+static int top_moves(int rt)
+{
+	int ret = KSFT_FAIL, i, have[TM_N] = { 0 };
+	int boost = rt ? FIFO_TASK_PRIO(50) : DL_TASK_PRIO;
+	pthread_mutexattr_t a;
+	pthread_t t[TM_N];
+	long long y_ns;
+	int err, o_prio = 0;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pi_init_lock2()) {
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	err = pthread_mutexattr_init(&a);
+	if (!err) {
+		err = pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT);
+		if (!err)
+			err = pthread_mutex_init(&top_lock, &a);
+		pthread_mutexattr_destroy(&a);
+	}
+	if (err) {
+		ksft_print_msg("no third priority inheritance mutex: %s\n",
+			       strerror(err));
+		ret = KSFT_SKIP;
+		goto out_lock2;
+	}
+	if (sem_init(&top_o_go, 0, 0) || sem_init(&top_m_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		goto out_lock3;
+	}
+	for (i = 0; i < TM_N; i++)
+		top_tid[i] = 0;
+	top_err = 0;
+	top_rt = rt;
+	top_m_locking = 0;
+	top_w_locking = 0;
+	top_y_stop = 0;
+	top_y_ns = -1;
+	if (!rt) {
+		have[TM_Y] = !pthread_create(&t[TM_Y], NULL, top_y, NULL);
+		if (!have[TM_Y] || wait_for(1000, top_tid[TM_Y] || top_err)) {
+			ksft_print_msg("Y never became a deadline task\n");
+			goto out;
+		}
+	}
+	have[TM_O] = !pthread_create(&t[TM_O], NULL, top_o,
+				     rt ? NULL : &t[TM_Y]);
+	if (!have[TM_O] || wait_for(1000, top_tid[TM_O] || top_err)) {
+		ksft_print_msg("O never took L2\n");
+		goto out;
+	}
+	have[TM_M] = !pthread_create(&t[TM_M], NULL, top_m, NULL);
+	if (!have[TM_M] || wait_for(1000, top_tid[TM_M] || top_err)) {
+		ksft_print_msg("M never took L1 and L1'\n");
+		goto out;
+	}
+	have[TM_W] = !pthread_create(&t[TM_W], NULL, top_waiter, (void *)1L);
+	if (!have[TM_W] ||
+	    wait_for(1000, (top_w_locking &&
+			    proc_state_of(top_tid[TM_W]) == 'S') || top_err)) {
+		ksft_print_msg("W never blocked on L1'\n");
+		goto out;
+	}
+	sem_post(&top_m_go);
+	if (wait_for(1000, (top_m_locking && prio_of(top_tid[TM_O]) == boost) ||
+			   top_err)) {
+		ksft_print_msg("O was not boosted through M\n");
+		goto out;
+	}
+	have[TM_Z] = !pthread_create(&t[TM_Z], NULL, top_waiter, (void *)0L);
+	if (!have[TM_Z] ||
+	    wait_for(1000, (top_tid[TM_Z] &&
+			    proc_state_of(top_tid[TM_Z]) == 'S') || top_err)) {
+		ksft_print_msg("Z never blocked on L1\n");
+		goto out;
+	}
+	sleep_ns(10 * NSEC_PER_MSEC);	/* the chain walk of Z is done */
+	err = top_err ? -EINVAL : set_other(top_tid[TM_W]);
+	if (err) {
+		ksft_print_msg("W cannot leave its class: %s\n",
+			       strerror(-err));
+		goto out;
+	}
+	if (rt) {
+		sleep_ns(10 * NSEC_PER_MSEC);
+		if (prio_of(top_tid[TM_M]) != FIFO_TASK_PRIO(20)) {
+			ksft_print_msg("Z does not boost M\n");
+			goto out;
+		}
+		o_prio = prio_of(top_tid[TM_O]);
+	} else {
+		sleep_ns(250 * NSEC_PER_MSEC);
+	}
+	ret = KSFT_PASS;
+out:
+	/* Let every thread end: O unlocks L2, then M unlocks L1 and L1'. */
+	sem_post(&top_m_go);
+	sem_post(&top_o_go);
+	for (i = TM_O; i < TM_Y; i++)
+		if (have[i])
+			join(t[i]);
+	top_y_stop = 1;
+	if (have[TM_Y])
+		join(t[TM_Y]);
+	y_ns = top_y_ns;
+	if (top_err) {
+		ksft_print_msg("a thread of the chain failed\n");
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && rt && o_prio != FIFO_TASK_PRIO(20)) {
+		ksft_print_msg("O runs at priority %d, not %d: W still boosts it\n",
+			       o_prio, FIFO_TASK_PRIO(20));
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && !rt &&
+		   y_ns < 45 * (long long)NSEC_PER_MSEC) {
+		ksft_print_msg("Y ran %lld ms of 200: W is still the donor of O\n",
+			       y_ns / (long long)NSEC_PER_MSEC);
+		ret = KSFT_FAIL;
+	}
+	sem_destroy(&top_o_go);
+	sem_destroy(&top_m_go);
+out_lock3:
+	pthread_mutex_destroy(&top_lock);
+out_lock2:
+	pthread_mutex_destroy(&pi_lock2);
+	sem_destroy(&holder_go);
+	pi_fini();
+	return ret;
+}
+
+/* W and Z are deadline tasks. */
+static int pi_chain_top_moves(void)
+{
+	return top_moves(0);
+}
+
+/* W and Z are SCHED_FIFO tasks. */
+static int pi_chain_top_moves_rt(void)
+{
+	return top_moves(1);
+}
+
 /* cpuset moves, from the main process, outside P */
 
 /* Shared with the processes of a case: atomic in shared memory. */
@@ -9832,6 +10123,8 @@ static const struct p_case {
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
 	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
+	{ "pi_chain_top_moves", pi_chain_top_moves, MEASURED_IN_P },
+	{ "pi_chain_top_moves_rt", pi_chain_top_moves_rt, MEASURED_IN_P },
 	{ "move_asleep", move_asleep, FROM_OUTSIDE },
 	{ "move_throttled", move_throttled, FROM_OUTSIDE },
 	{ "move_non_contending", move_non_contending, FROM_OUTSIDE },
-- 
2.47.3

