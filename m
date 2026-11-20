Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207373;
	b=MAq65TZyCmNYAWfHdrwUIGRjg1iz9wk8JP8scZHUSrpta0whRRPLpgaWHAEeZaCYXQmE
	 W99o4rF/gFTWPJqHcxZm5kQvYtFkBY1eG+Dn8dus7j7Ju+l1ZjqN4J54TrMVYgRdm9V6+
	 kkxe2zdpHr/Zdq23fIjO0+9yll6ZTMj89VTDMoqtn5bxzYayTn7CRIzHxl4e8KPmh1mhA
	 J3d9ddycOzrfrDEkEYTcIESjIvKTbSCtArj754XUL5QSbO8Q/wnzpTszs+WQR4IeK4lOw
	 1a9eHFXr8GWHWBY0/fJggkX68zkR+nlW0zkLQuYEgy/9ADO9yxYSMp1m/AY9BpwOZGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207373;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Fm8LDhKJYh79CEQA1lv1/kd9fVTzRFlvj0XUYVL1hdk=;
	b=YA6hvL1pCK1FusLSha7CDqiYZFHHHuKONgxKC4Cd4gzFqSWg5d+d2Ah6bXmnwa7phcuT
	 9QMdckwebEW17lNzExa7zPeVF6s6LBrVQyawgzgmn6NZ46FLfBlYmZMEDI2X7tZO/ixBB
	 HK7F1AZWxhAgdknTQaN7QhvMkEwWQdEXc7l51NcrIZLmqbSeilYKsmKOQJIQVTatOWTiu
	 uuvqP5V2SneWu267XJbFXOWJNKa/I6KdHh0qUHvXe/Qh98LAcUnVUjx7+Y2uesZIjfBZD
	 k5xM1w6zfRjxb7zYqhGB7iFtFTNBC/UEut3N9HF/ltnv609gB2n7qKxNMXytKjRif6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Zbfd6H1V;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF831606A6D6;
	Fri, 20 Nov 2026 20:42:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF831606A6D6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Zbfd6H1V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207354;
	bh=Fm8LDhKJYh79CEQA1lv1/kd9fVTzRFlvj0XUYVL1hdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zbfd6H1VjLVZJlG2N69Wty4TqnRy9bBN0atxca9EqTYNFzWvaPrqBUOam+HMT1EOC
	 PZaZzBfzuy66tNmlQciN4zCuxK4JICxGxM+871BcXQ7YM4pd/yzQUxoZYduQywmQrk
	 L6iV9WMq8XlMr5EY9p7kj7JGUDWx3l3/uH3eZgFn6HwKJSip5UHeSHitnH/7FsA1QE
	 bAQZP7d/ruWla19CYWcEn4Koq/RzDiQ0woaZPFlGg0iK2r5Pr7yagmu96AytZcZZEm
	 eR1xyCT3lDg2pWdFL25/lv8t+rOTfhJpCAGFCsvQwIxxr83w7mzGu1+q34GVCYTCND
	 34+ctrC8FQMIg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2K4ShfzVBG;
	Fri, 20 Nov 2026 15:42:33 -0500 (EST)
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
Subject: [PATCH v10 12/40] selftests/sched: Test cpuset moves in deadline_bw_test
Date: Fri, 20 Nov 2026 15:41:49 -0500
Message-Id: <28f7b6e64c55133b479bd8fb93773866aa530442.1795207232.git.mathieu.desnoyers@efficios.com>
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

Add the 24 cases of deadline_bw_test that test the fixes of cpuset
attach, earlier in this series. They cover cpuset moves, and what can
happen during them:
- a rebuild of the sched domains, a policy change, an affinity change, a
  wakeup, the death of a thread, a refusal by another controller
- a task asleep, throttled, yielded, frozen or reclaiming
- moves between the housekeeping CPUs and CPUs isolated by
  isolcpus=domain
- sysrq-n during a move (move_normalized)
- a random mix of all of the above, with affinity changes (random_mix)

The comment above each case gives its scenario. random_mix also
compares the this_bw of its CPUs. Five cases need CPUs isolated by
isolcpus=domain. move_normalized fires sysrq-n, which changes the whole
system, so it needs DEADLINE_TEST_SYSRQ=1. A case skips without what it
needs.

The attach fixes are the five patches before this one, from
"sched/deadline: Move a task's bandwidth only where room was made" to
"cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
to".

The message of each fix names the cases that test it. These cases are
not named there:
- move_asleep, move_asleep_setattr, move_non_contending, move_died,
  move_woken and move_woken_full test "sched/deadline: Record the root
  domain holding a task's bandwidth". They also need the attach fixes,
  so they come here.
- frozen_moved_switched, move_throttled, reclaim_moved and yield_moved
  fail with isolcpus=domain,0,1 before the attach fixes.

On v7.4-rc2, in 8 VMs of 8 CPUs, twelve of these cases fail in every VM:

  move_affinity_became_deadline       move_died
  move_affinity_changed               move_non_contending
  move_asleep                         move_vs_rebuild
  move_back_cpu_offline               move_woken
  move_became_deadline                move_woken_full
  move_became_deadline_no_room        random_mix

These cases did not run there: those that need isolcpus=domain (they
skip), move_normalized, move_asleep_setattr and
move_asleep_fair_setattr.

With the fixes up to here, every case passes wherever it runs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 2516 ++++++++++++++++-
 1 file changed, 2511 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index ba2a18f354d4..0b53b64c7b3a 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -5,9 +5,11 @@
  *  - priority inheritance
  *  - parameter changes
  *  - cpuset moves
+ *  - affinity changes
  *  - deaths, yields and runtime overruns
  *  - bandwidth reclaiming and fair server changes
  *  - CPU hotplug
+ *  - a random mix of most of these
  *
  * Most cases measure the free bandwidth of a root domain before and after
  * they run. probe() counts the tasks of 10ms every 100ms that the root
@@ -25,7 +27,8 @@
  * The CPUs that isolcpus="domain" isolates are in the default root
  * domain: the root domain of the isolated CPUs. The other CPUs are the
  * housekeeping CPUs, in the housekeeping root domain. The test leaves the
- * isolated CPUs out, and keeps its tasks off them.
+ * isolated CPUs out, and keeps its tasks off them. Only the cases that
+ * need them use them.
  *
  * The cases of p_cases[] run with P, a partition root of the last
  * housekeeping CPU. P is made anew for each case. Making it rebuilds the
@@ -42,7 +45,8 @@
  *
  * The test needs root, deadline admission control and 3 housekeeping
  * CPUs. Some cases need 4. Most also need the cgroup v2 cpuset
- * controller. Some need debugfs or CPU hotplug.
+ * controller. Some need debugfs or CPU hotplug. Five need
+ * isolcpus="domain" at boot.
  */
 #define _GNU_SOURCE
 #include <errno.h>
@@ -106,6 +110,7 @@ struct dl_attr {
 static char root[PATH_MAX], cg_p[PATH_MAX], cg_q[PATH_MAX];
 /* The online CPUs at the start, ascending, except the isolated ones */
 static int ncpus, *online;
+static int nisol, *isol;	/* the online CPUs that isolcpus="domain" isolates */
 static char isolated[4096];	/* the CPU list of /sys/devices/system/cpu/isolated */
 
 /* Return the @n-th highest online CPU, counting from 1. */
@@ -2539,7 +2544,7 @@ static int child_up(const char *what, int fast)
 	return 0;
 }
 
-enum mv_mode { MV_ASLEEP, MV_THROTTLED, MV_NON_CONTENDING };
+enum mv_mode { MV_ASLEEP, MV_THROTTLED, MV_YIELDED, MV_NON_CONTENDING };
 
 /*
  * Fork a process in the caller's cgroup. The process becomes a deadline
@@ -2547,6 +2552,8 @@ enum mv_mode { MV_ASLEEP, MV_THROTTLED, MV_NON_CONTENDING };
  * - MV_ASLEEP: run 1ms, set mv_state[0] to 1, then sleep.
  * - MV_THROTTLED: set mv_state[0] to 1, then spin and count in
  *   mv_state[1].
+ * - MV_YIELDED: set mv_state[0] to 1. Then spin 0.5ms, count in
+ *   mv_state[1] and yield, in a loop.
  * - MV_NON_CONTENDING: sleep a period, run a quarter of its runtime, set
  *   mv_state[0] to 1, then sleep. Its 0-lag time is still ahead.
  * If it is refused SCHED_DEADLINE, the process sets mv_state[0] to -1 and
@@ -2574,6 +2581,14 @@ static pid_t mover(enum mv_mode mode, uint64_t runtime)
 			for (;;)
 				pause();
 		}
+		if (mode == MV_YIELDED) {
+			*mv_state = 1;
+			for (;;) {
+				spin_ns(NSEC_PER_MSEC / 2);
+				mv_state[1]++;
+				sched_yield();
+			}
+		}
 		*mv_state = 1;
 		for (;;)
 			mv_state[1]++;
@@ -2581,6 +2596,69 @@ static pid_t mover(enum mv_mode mode, uint64_t runtime)
 	return pid;
 }
 
+static int wait_spinner(int moving);
+
+/*
+ * Move a deadline task into P and back, from outside P. The task is a
+ * mover() process of 30ms every 100ms, forked in the cgroup of the main
+ * process. Wait until it is in the state of @mode:
+ * - MV_ASLEEP: asleep for two periods, past its 0-lag time.
+ * - MV_NON_CONTENDING: asleep for 1ms, before its 0-lag time.
+ * - MV_THROTTLED, MV_YIELDED: its counter has stopped for 5ms.
+ * Then write its pid to cgroup.procs of P, then of the root cgroup. Both
+ * moves must succeed. A throttled or yielded task must run again within
+ * three periods. Then kill the task. P and the root cgroup must each
+ * admit as many probe tasks as before the case.
+ */
+static int moves(enum mv_mode mode, const char *name)
+{
+	int base_p, base_r, after_p, after_r, ret = KSFT_PASS;
+	pid_t pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = mover(mode, 30 * NSEC_PER_MSEC);
+	if (pid < 0 || child_up(name, mode == MV_NON_CONTENDING)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	if (mode == MV_NON_CONTENDING) {
+		sleep_ns(NSEC_PER_MSEC);
+	} else if (mode == MV_ASLEEP) {
+		sleep_ns(2 * PERIOD);
+	} else if (wait_spinner(0)) {
+		/* Throttled, or yielded: its counter stops. */
+		ksft_print_msg("%s: never stopped\n", name);
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	if (enter(cg_p, pid) || enter(root, pid)) {
+		ksft_print_msg("%s: a move refused\n", name);
+		ret = KSFT_FAIL;
+	}
+	if (mode == MV_THROTTLED || mode == MV_YIELDED) {
+		int last = mv_state[1];
+
+		sleep_ns(3 * PERIOD);
+		if (mv_state[1] == last) {
+			ksft_print_msg("%s: moved, never ran again\n", name);
+			ret = KSFT_FAIL;
+		}
+	}
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	after_p = probe(cg_p);
+	after_r = probe(root);
+	if (ret == KSFT_PASS && (after_p != base_p || after_r != base_r)) {
+		ksft_print_msg("%s: probe tasks admitted, P %d -> %d, the other CPUs %d -> %d\n",
+			       name, base_p, after_p, base_r, after_r);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /*
  * A deadline task of 60ms every 100ms sleeps in P. Move a second sleeping
  * task of 60ms every 100ms into P from outside. The move must fail with
@@ -2632,6 +2710,136 @@ static int move_refused(void)
 	return ret;
 }
 
+/*
+ * A task moved asleep into P is still on a CPU of the root domain it
+ * left. It sleeps outside P as a deadline task of 10%. The main process
+ * moves it into P, and changes it to 20%. P has room for that, so
+ * sched_setattr() must accept it. The kernel must check the request
+ * against P's root domain, which counts the task. The task then runs on
+ * P's CPU.
+ */
+static int move_asleep_setattr(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, err, sfd[2];
+	pid_t pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	if (base_p < 0 || base_r < 0 || pipe(sfd))
+		return KSFT_FAIL;
+	mv_state[0] = 0;
+	pid = fork_child("a task to move into P");
+	if (!pid) {
+		char c;
+
+		close(sfd[1]);
+		mv_state[0] = 1;
+		while (read(sfd[0], &c, 1) == 1)
+			;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("a task to move into P", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S')) {
+		reap(pid);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	err = set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("a task of 10%% outside P refused: %s\n", strerror(-err));
+		ret = KSFT_FAIL;
+	} else if (enter(cg_p, pid)) {
+		ksft_print_msg("the move into P of a task of 10%% refused\n");
+		ret = KSFT_FAIL;
+	} else {
+		err = set_deadline(pid, 20 * NSEC_PER_MSEC, PERIOD);
+		if (err) {
+			ksft_print_msg("10%% to 20%% for a task moved asleep into P: %s\n",
+				       strerror(-err));
+			ret = KSFT_FAIL;
+		} else if (write(sfd[1], "w", 1) != 1 ||
+			   wait_for(1000, task_cpu_of(pid) == top_cpu(1))) {
+			ksft_print_msg("a task moved into P did not wake on P's CPU\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	set_other(pid);
+	reap(pid);
+out:
+	close(sfd[0]);
+	close(sfd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("the free bandwidth changed after the case\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * The same, for a fair task: it sleeps outside P, and the main process
+ * moves it into P. Then it makes it a deadline task of 10%. P has room
+ * for that, so sched_setattr() must accept it, and P must count the task.
+ * The root domain the task left must not. The task then runs on P's CPU.
+ */
+static int move_asleep_fair_setattr(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, err, sfd[2];
+	pid_t pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	if (base_p < 0 || base_r < 0 || pipe(sfd))
+		return KSFT_FAIL;
+	mv_state[0] = 0;
+	pid = fork_child("a fair task to move into P");
+	if (!pid) {
+		char c;
+
+		close(sfd[1]);
+		mv_state[0] = 1;
+		while (read(sfd[0], &c, 1) == 1)
+			;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("a fair task to move into P", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S')) {
+		reap(pid);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (enter(cg_p, pid)) {
+		ksft_print_msg("the move into P of a fair task refused\n");
+		ret = KSFT_FAIL;
+		goto stop;
+	}
+	err = set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("10%% for a fair task moved asleep into P: %s\n",
+			       strerror(-err));
+		ret = KSFT_FAIL;
+	} else if (probe(cg_p) != base_p - 1 || probe(root) != base_r) {
+		ksft_print_msg("P does not count the task, or the root domain it left does\n");
+		ret = KSFT_FAIL;
+	} else if (write(sfd[1], "w", 1) != 1 ||
+		   wait_for(1000, task_cpu_of(pid) == top_cpu(1))) {
+		ksft_print_msg("a task moved into P did not wake on P's CPU\n");
+		ret = KSFT_FAIL;
+	}
+stop:
+	set_other(pid);
+	reap(pid);
+out:
+	close(sfd[0]);
+	close(sfd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("the free bandwidth changed after the case\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /*
  * A runtime of 1024ns every 2s gives a bandwidth of 0. A cpuset move
  * skips such a task: it has no bandwidth to move.
@@ -2722,6 +2930,44 @@ static int move_zero_bw(void)
 	return ret;
 }
 
+static int move_asleep(void)
+{
+	return moves(MV_ASLEEP, "move_asleep");
+}
+
+static int move_throttled(void)
+{
+	return moves(MV_THROTTLED, "move_throttled");
+}
+
+static int move_non_contending(void)
+{
+	return moves(MV_NON_CONTENDING, "move_non_contending");
+}
+
+/*
+ * Fork a process that reads sched_rt_runtime_us and writes the same value
+ * back @n times, 5ms apart. Then it exits. Each write rebuilds the sched
+ * domains. Return its pid, or -1.
+ */
+static pid_t rebuilder(int n)
+{
+	pid_t pid = fork_child("a sysctl writer");
+
+	if (!pid) {
+		char buf[64];
+
+		if (read_file("/proc/sys/kernel/sched_rt_runtime_us", buf, sizeof(buf)))
+			_exit(1);
+		while (n-- > 0) {
+			write_file("/proc/sys/kernel", "sched_rt_runtime_us", buf);
+			sleep_ns(5 * NSEC_PER_MSEC);
+		}
+		_exit(0);
+	}
+	return pid;
+}
+
 static void *pauser(void *arg)
 {
 	for (;;)
@@ -2729,9 +2975,200 @@ static void *pauser(void *arg)
 	return arg;
 }
 
-/* What late_setter() does, and the result. */
+/*
+ * Run as the deadline thread of wide_mover(): a deadline task of 30% that
+ * runs 1ms, sets mv_state[0] to 1 and sleeps.
+ */
+static void *dl_pauser(void *arg)
+{
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		mv_state[0] = -1;
+		return arg;
+	}
+	spin_ns(NSEC_PER_MSEC);
+	*mv_state = 1;
+	for (;;)
+		pause();
+	return arg;
+}
+
+/*
+ * Fork a process of @threads sleeping threads, then one deadline thread,
+ * dl_pauser(). A cgroup move of the process moves its threads one by one,
+ * between cpuset_can_attach() and cpuset_attach(). The deadline thread
+ * moves last, so that a rebuild in that window can still find it in the
+ * cgroup it leaves. Return the pid, or -1.
+ */
+static pid_t wide_mover(int threads)
+{
+	pid_t pid = fork_child("a wide deadline process");
+
+	if (!pid) {
+		pthread_attr_t a;
+		pthread_t t;
+		int i;
+
+		if (pthread_attr_init(&a) || pthread_attr_setstacksize(&a, THREAD_STACK))
+			goto no_threads;
+		for (i = 0; i < threads; i++) {
+			if (pthread_create(&t, &a, pauser, NULL))
+				goto no_threads;
+		}
+		if (pthread_create(&t, NULL, dl_pauser, NULL))
+			goto no_threads;
+		for (;;)
+			pause();
+no_threads:
+		mv_state[0] = -2;
+		_exit(1);
+	}
+	return pid;
+}
+
+/*
+ * Move a process in and out of P while rebuilder() rebuilds the sched
+ * domains. The process is wide_mover(): 2048 sleeping threads, then one
+ * sleeping deadline thread of 30%. rebuilder() writes the
+ * sched_rt_runtime_us sysctl 20 times, 5ms apart. Each write is a
+ * rebuild. Without the 5ms gaps, the rebuilds would be over before the
+ * first move reaches the window below.
+ *
+ * A rebuild between cpuset_can_attach() and cpuset_attach() would drop
+ * the bandwidth that cpuset_can_attach() reserved in the destination.
+ * cpuset_attach() would then move the bandwidth of the thread all the
+ * same. So a rebuild must wait for the end of a move in progress.
+ *
+ * A later rebuild corrects the accounting. So move until rebuilder()
+ * exits: no rebuild follows the last move. The free bandwidth of P and
+ * of the other CPUs must then be what it was with the process asleep in
+ * the root cgroup. Run six rounds.
+ */
+static int move_vs_rebuild(void)
+{
+	int base_p, base_r, with_p, with_r, after_p, after_r, round, ret = KSFT_PASS;
+	const char *name = "move_vs_rebuild";
+	pid_t pid, writer;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	mv_state[0] = 0;
+	pid = wide_mover(2048);
+	if (pid < 0 || child_up(name, 0)) {
+		reap(pid);
+		return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+	}
+	/* The reference for the rounds: the task asleep in the root cgroup. */
+	sleep_ns(2 * PERIOD);
+	with_p = probe(cg_p);
+	with_r = probe(root);
+	for (round = 0; round < 6 && ret == KSFT_PASS; round++) {
+		int status, err = 0;
+
+		writer = rebuilder(20);
+		if (writer < 0) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		while (!err && waitpid(writer, &status, WNOHANG) == 0) {
+			err = enter(cg_p, pid);
+			if (!err)
+				err = enter(root, pid);
+		}
+		if (err) {
+			ksft_print_msg("%s: a move refused: %s\n", name, strerror(-err));
+			reap(writer);
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(3 * PERIOD);
+		after_p = probe(cg_p);
+		after_r = probe(root);
+		if (after_p != with_p || after_r != with_r) {
+			ksft_print_msg("%s: round %d: P %d -> %d probe tasks, the rest %d -> %d\n",
+				       name, round, with_p, after_p, with_r, after_r);
+			ret = KSFT_FAIL;
+		}
+	}
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	after_p = probe(cg_p);
+	after_r = probe(root);
+	if (ret == KSFT_PASS && (after_p != base_p || after_r != base_r)) {
+		ksft_print_msg("%s: task gone: P %d -> %d probe tasks, the rest %d -> %d\n",
+			       name, base_p, after_p, base_r, after_r);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/* The runtime every 100ms of the deadline threads of late_mover() */
+static uint64_t late_thread_runtime;
+
+/*
+ * Run as a deadline thread of late_mover(): a deadline task of
+ * late_thread_runtime that counts itself in mv_state[1] and sleeps.
+ */
+static void *dl_sleeper(void *arg)
+{
+	if (set_deadline(0, late_thread_runtime, PERIOD)) {
+		mv_state[0] = -1;
+		return arg;
+	}
+	mv_state[1]++;
+	for (;;)
+		pause();
+	return arg;
+}
+
+/*
+ * Fork a process of two deadline threads, dl_sleeper(), then @threads
+ * sleeping threads. Its main thread, the thread group leader, sleeps and
+ * is not a deadline task. A cgroup move of the process handles the
+ * leader first. The sleeping threads make the move long. Return the pid,
+ * or -1.
+ */
+static pid_t late_mover(int threads)
+{
+	pid_t pid = fork_child("a wide process");
+
+	if (!pid) {
+		pthread_attr_t a;
+		pthread_t t;
+		int i;
+
+		if (pthread_attr_init(&a) || pthread_attr_setstacksize(&a, THREAD_STACK))
+			goto no_threads;
+		for (i = 0; i < 2; i++) {
+			if (pthread_create(&t, &a, dl_sleeper, NULL))
+				goto no_threads;
+		}
+		for (i = 0; i < threads; i++) {
+			if (pthread_create(&t, &a, pauser, NULL))
+				goto no_threads;
+		}
+		if (wait_for_step(5000, NSEC_PER_MSEC, mv_state[1] == 2 || mv_state[0]))
+			goto no_threads;
+		if (!mv_state[0])
+			mv_state[0] = 1;
+		for (;;)
+			pause();
+no_threads:
+		mv_state[0] = -2;
+		_exit(1);
+	}
+	return pid;
+}
+
+/*
+ * What late_setter(), late_pinner() and late_killer() do, and the result.
+ * Each acts on thread @pid, @delay ns after @go is set. It stores its
+ * result in @ret and the time it returned in @done. late_setter() uses
+ * @runtime. late_killer() uses @tgid and @kill.
+ */
 static struct {
 	pid_t pid;
+	pid_t tgid;
+	int kill;
 	uint64_t runtime;
 	uint64_t delay;
 	atomic_int go;
@@ -2758,18 +3195,167 @@ static void *late_setter(void *arg)
 	return arg;
 }
 
+/*
+ * Make the main thread of a process a deadline task while the process
+ * moves from the root cgroup into P.
+ *
+ * The process is late_mover(). Its main thread sleeps and is not a
+ * deadline task. Two of its threads are sleeping deadline tasks of
+ * @thread percent each. 2048 more sleeping threads make the move long.
+ * A thread of the test, late_setter(), calls sched_setattr() on the main
+ * thread to make it a deadline task of @leader percent.
+ *
+ * cpuset_can_attach() reserves room in P for the two deadline threads.
+ * If the main thread became a deadline task after that, no room would be
+ * reserved for it. cpuset_attach() handles the main thread first.
+ *
+ * sched_setattr() waits for the end of a move in progress. So it runs
+ * before the move or after it:
+ *  - Before: the move counts three deadline tasks. With room in P for
+ *    the three, the move must succeed. P must then count the three, and
+ *    the root domain the process left must count none. Without room,
+ *    the move must be refused with EBUSY.
+ *  - After: the main thread is allowed on P's CPU only. It is still
+ *    asleep on a CPU of the root domain it left. sched_setattr() asks P
+ *    for room. Without room, it fails with EBUSY.
+ * Without room in P for the three, the case fails if the move and
+ * sched_setattr() both succeed.
+ *
+ * Try 30 delays of sched_setattr(), spread over the time a move takes.
+ */
+static int became_deadline(int thread, int leader, const char *name)
+{
+	int base_p, base_r, ret = KSFT_PASS, i, raced = 0;
+	int need = (2 * thread + leader) / 10, fits;
+	uint64_t start, len;
+	pid_t pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	fits = base_p >= need;
+	if (base_p < 2 * thread / 10) {
+		ksft_print_msg("%s: P admits %d probe tasks, %d needed\n", name, base_p,
+			       2 * thread / 10);
+		return KSFT_SKIP;
+	}
+	late_thread_runtime = thread * NSEC_PER_MSEC;
+	late.runtime = leader * NSEC_PER_MSEC;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = late_mover(2048);
+	if (pid < 0 || child_up(name, 0)) {
+		reap(pid);
+		return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+	}
+	/* Time one move, to spread the delays over it. */
+	start = now_ns();
+	if (enter(cg_p, pid) || enter(root, pid)) {
+		ksft_print_msg("%s: a move refused\n", name);
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	len = (now_ns() - start) / 2;
+	sleep_ns(2 * PERIOD);
+
+	late.pid = pid;
+	for (i = 0; i < 30 && ret == KSFT_PASS; i++) {
+		pthread_t t;
+		int err;
+
+		late.go = 0;
+		late.delay = len * i / 30;
+		if (pthread_create(&t, NULL, late_setter, NULL)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		err = enter(cg_p, pid);
+		join(t);
+		if (err && (fits || err != -EBUSY || late.ret)) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		} else if (!err && !late.ret && !fits) {
+			ksft_print_msg("%s: the move and the change both succeeded, with no room in P\n",
+				       name);
+			ret = KSFT_FAIL;
+		} else if (!err && !late.ret) {
+			raced++;
+			if (admits_in(cg_p, base_p - need, "P, with the three tasks") ||
+			    admits_in(root, base_r, "the root domain the tasks left"))
+				ret = KSFT_FAIL;
+		} else if (late.ret && (fits || late.ret != -EBUSY)) {
+			ksft_print_msg("%s: sched_setattr: %s\n", name, strerror(-late.ret));
+			ret = KSFT_FAIL;
+		}
+		if (ret == KSFT_FAIL)
+			ksft_print_msg("%s: try %d, the change %llu us into a move of %llu us\n",
+				       name, i, (unsigned long long)(late.delay / NSEC_PER_USEC),
+				       (unsigned long long)(len / NSEC_PER_USEC));
+		if ((!late.ret && set_other(pid)) || enter(root, pid)) {
+			ksft_print_msg("%s: the process cannot go back\n", name);
+			ret = KSFT_FAIL;
+		}
+		sleep_ns(2 * PERIOD);
+	}
+	if (ret == KSFT_PASS && fits && !raced)
+		ksft_print_msg("%s: no change succeeded with a move\n", name);
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("%s: the free bandwidth changed\n", name);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/* Run it with room in P: two threads of 20% and a main thread of 30%. */
+static int move_became_deadline(void)
+{
+	return became_deadline(20, 30, "move_became_deadline");
+}
+
+/* Run it without room in P: two threads of 30% and a main thread of 40%. */
+static int move_became_deadline_no_room(void)
+{
+	return became_deadline(30, 40, "move_became_deadline_no_room");
+}
+
 static void no_op(int sig)
 {
 }
 
+/* The CPU that dl_sleeper_tid() first runs on, or -1 for any CPU */
+static int sleeper_cpu = -1;
+
 /*
  * Run as the deadline thread of pinned_mover(): a deadline task of 30%.
  * Store the tid in mv_state[3], set mv_state[0] to 1 and sleep. A signal
  * wakes the thread up. It then sleeps again. If mv_state[4] is set, this
  * thread exits instead, and the process stays.
+ *
+ * With sleeper_cpu set, first run 1ms pinned on that CPU, then restore
+ * the previous affinity. Do this before sched_setattr(): the affinity of
+ * a deadline task must include every CPU of its root domain.
  */
 static void *dl_sleeper_tid(void *arg)
 {
+	if (sleeper_cpu >= 0) {
+		cpu_set_t all, one;
+
+		CPU_ZERO(&one);
+		CPU_SET(sleeper_cpu, &one);
+		if (sched_getaffinity(0, sizeof(all), &all) ||
+		    sched_setaffinity(0, sizeof(one), &one)) {
+			mv_state[0] = -2;
+			return arg;
+		}
+		spin_ns(NSEC_PER_MSEC);
+		if (sched_setaffinity(0, sizeof(all), &all)) {
+			mv_state[0] = -2;
+			return arg;
+		}
+	}
 	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
 		mv_state[0] = -1;
 		return arg;
@@ -2834,6 +3420,618 @@ static pid_t pinned_mover(int threads, int fifo)
 	return pid;
 }
 
+/*
+ * Restrict late.pid to the CPU of P and the CPU in @arg, late.delay ns
+ * after late.go.
+ */
+static void *late_pinner(void *arg)
+{
+	uint64_t start;
+	cpu_set_t set;
+
+	CPU_ZERO(&set);
+	CPU_SET(top_cpu(1), &set);
+	CPU_SET((long)arg, &set);
+	while (!late.go)
+		;
+	start = now_ns();
+	while (now_ns() - start < late.delay)
+		;
+	late.ret = sched_setaffinity(late.pid, sizeof(set), &set) ? -errno : 0;
+	late.done = now_ns();
+	return NULL;
+}
+
+/*
+ * Change the affinity of a sleeping deadline thread while its process
+ * moves from P to the root cgroup.
+ *
+ * The process is pinned_mover(): 2048 sleeping threads, then a deadline
+ * thread of 30%. That thread went to sleep on a CPU of the root cgroup,
+ * and was moved into P asleep. So P counts it, and it is still on that
+ * CPU. A thread of the test, late_pinner(), calls sched_setaffinity()
+ * on it.
+ *
+ * cpuset_can_attach() reserves the bandwidth of the thread on one CPU of
+ * the root cgroup. The move records that CPU. It is the CPU the thread
+ * is on, if its affinity allows that CPU. If not, it is the first CPU of
+ * the root cgroup that its affinity allows.
+ *
+ * sched_setaffinity() restricts the thread to two CPUs: the CPU of P,
+ * and a CPU of the root cgroup that the thread is not on. The affinity
+ * of a deadline task must include every CPU of the root domain that
+ * counts it, so the mask needs the CPU of P. The move then records the
+ * second CPU.
+ *
+ * sched_setaffinity() waits for the end of a move in progress. So it
+ * runs before the move or after it:
+ *  - Before: the bandwidth is reserved on the CPU the move records. The
+ *    root domain of that CPU must count the thread once the move is
+ *    done, and P must no longer count it.
+ *  - After: the thread is counted in the root domain of the root
+ *    cgroup. The mask does not include every CPU of that root domain.
+ *    sched_setaffinity() is refused with EBUSY.
+ *
+ * Try 20 delays of sched_setaffinity(), spread over the time a move
+ * takes.
+ */
+static int move_affinity_changed(void)
+{
+	int with_p, with_r, ret = KSFT_PASS, i, raced = 0;
+	const char *name = "move_affinity_changed";
+	uint64_t start, len;
+	cpu_set_t all;
+	pid_t pid;
+
+	CPU_ZERO(&all);
+	for (i = 0; i < ncpus; i++)
+		CPU_SET(online[i], &all);
+	mv_state[0] = 0;
+	mv_state[3] = 0;
+	mv_state[4] = 0;
+	pid = pinned_mover(2048, 0);
+	if (pid < 0 || child_up(name, 0)) {
+		reap(pid);
+		return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+	}
+	/* The reference: the thread asleep in the root cgroup. */
+	sleep_ns(2 * PERIOD);
+	with_p = probe(cg_p);
+	with_r = probe(root);
+	/* Time one move, to spread the delays over it. */
+	start = now_ns();
+	if (enter(cg_p, pid) || enter(root, pid)) {
+		ksft_print_msg("%s: a move refused\n", name);
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	len = (now_ns() - start) / 2;
+
+	late.pid = mv_state[3];
+	for (i = 0; i < 20 && ret == KSFT_PASS; i++) {
+		pthread_t t;
+		long cpu;
+		int err;
+
+		if (sched_setaffinity(late.pid, sizeof(all), &all) || enter(cg_p, pid)) {
+			ksft_print_msg("%s: the process cannot go into P\n", name);
+			ret = KSFT_FAIL;
+			break;
+		}
+		/* Not the CPU the thread is on: the move would record that one. */
+		cpu = task_cpu_of(late.pid) == online[1] ? online[0] : online[1];
+		late.go = 0;
+		late.delay = len * i / 20;
+		if (pthread_create(&t, NULL, late_pinner, (void *)cpu)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		err = enter(root, pid);
+		join(t);
+		if (err) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		} else if (!late.ret) {
+			raced++;
+			sleep_ns(2 * PERIOD);
+			if (admits_in(cg_p, with_p, "P, which the thread left") ||
+			    admits_in(root, with_r, "the root domain of the thread")) {
+				ksft_print_msg("%s: try %d, the change %llu us into a move of %llu us\n",
+					       name, i, (unsigned long long)(late.delay / NSEC_PER_USEC),
+					       (unsigned long long)(len / NSEC_PER_USEC));
+				ret = KSFT_FAIL;
+			}
+		} else if (late.ret && late.ret != -EBUSY) {
+			ksft_print_msg("%s: sched_setaffinity: %s\n", name, strerror(-late.ret));
+			ret = KSFT_FAIL;
+		}
+	}
+	if (ret == KSFT_PASS && !raced)
+		ksft_print_msg("%s: no change succeeded\n", name);
+	reap(pid);
+	return ret;
+}
+
+/*
+ * Make a thread a deadline task while sched_setaffinity() runs on it, and
+ * move its process from P to the root cgroup meanwhile.
+ *
+ * sched_setaffinity() waits for the end of a move in progress when the
+ * task is a deadline task. It tests the policy first, with no lock. Here
+ * the thread T is SCHED_OTHER at that test:
+ *
+ *   sched_setaffinity(T)         sched_setattr(T)        echo PID > cgroup.procs
+ *
+ *   T is SCHED_OTHER: no wait
+ *                                T is a deadline task
+ *                                                        cpuset_can_attach()
+ *                                                          reserves room for T
+ *   changes the affinity of T
+ *                                                        cpuset_attach()
+ *                                                          moves T
+ *
+ * The new affinity holds the CPU of P and one CPU of the root cgroup.
+ * The room was reserved on another CPU. Once the move is done, the
+ * root domain of the root cgroup must count T, and P must not.
+ *
+ * Delay injection: the window after the test of the policy is a few
+ * instructions wide. The case only reaches it on a kernel that can make
+ * sched_setaffinity() sleep there. It passes without reaching it
+ * otherwise.
+ */
+static int move_affinity_became_deadline(void)
+{
+	const char *name = "move_affinity_became_deadline";
+	int with_p, with_r, ret = KSFT_PASS, i;
+	uint64_t start, len, delay_ms;
+	cpu_set_t all;
+	pid_t pid;
+
+	CPU_ZERO(&all);
+	for (i = 0; i < ncpus; i++)
+		CPU_SET(online[i], &all);
+	mv_state[0] = 0;
+	mv_state[3] = 0;
+	mv_state[4] = 0;
+	pid = pinned_mover(2048, 0);
+	if (pid < 0 || child_up(name, 0)) {
+		reap(pid);
+		return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+	}
+	/* The reference: the thread a deadline task, asleep in the root cgroup. */
+	sleep_ns(2 * PERIOD);
+	with_p = probe(cg_p);
+	with_r = probe(root);
+	/* Time one move, to place the change inside it. */
+	start = now_ns();
+	if (enter(cg_p, pid) || enter(root, pid)) {
+		ksft_print_msg("%s: a move refused\n", name);
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	len = (now_ns() - start) / 2;
+	delay_ms = 3 * len / NSEC_PER_MSEC + 30;
+
+	late.pid = mv_state[3];
+	for (i = 0; i < 10 && ret == KSFT_PASS; i++) {
+		uint64_t t0, at;
+		pthread_t t;
+		int err;
+
+		if (sched_setaffinity(late.pid, sizeof(all), &all) || enter(cg_p, pid) ||
+		    set_other(late.pid)) {
+			ksft_print_msg("%s: the thread cannot go into P as SCHED_OTHER\n", name);
+			ret = KSFT_FAIL;
+			break;
+		}
+		/*
+		 * Wake the thread once, so that it runs on the CPU of P. A
+		 * thread moved asleep is refused SCHED_DEADLINE with EPERM.
+		 */
+		if (syscall(SYS_tgkill, pid, late.pid, SIGUSR1)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(5 * NSEC_PER_MSEC);
+		/*
+		 * Delay injection: sched_setaffinity() would be asked here to
+		 * sleep delay_ms after its test of the policy.
+		 */
+		late.go = 0;
+		late.delay = 0;
+		if (pthread_create(&t, NULL, late_pinner, (void *)(long)online[1])) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		t0 = now_ns();
+		late.go = 1;
+		/* With the delay, the change has tested the policy and sleeps. */
+		sleep_ns(5 * NSEC_PER_MSEC);
+		err = set_deadline(late.pid, 30 * NSEC_PER_MSEC, PERIOD);
+		if (err) {
+			ksft_print_msg("%s: sched_setattr: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		}
+		/* Start the move so that the change wakes up inside it. */
+		at = t0 + delay_ms * NSEC_PER_MSEC - len * (i + 1) / 11;
+		while (now_ns() < at)
+			;
+		err = enter(root, pid);
+		join(t);
+		if (err) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		} else if (!late.ret) {
+			sleep_ns(2 * PERIOD);
+			if (admits_in(cg_p, with_p, "P, which the thread left") ||
+			    admits_in(root, with_r, "the root domain of the thread")) {
+				ksft_print_msg("%s: try %d, the change landed in a move of %llu us\n",
+					       name, i, (unsigned long long)(len / NSEC_PER_USEC));
+				ret = KSFT_FAIL;
+			}
+		} else if (late.ret && late.ret != -EBUSY) {
+			ksft_print_msg("%s: sched_setaffinity: %s\n", name, strerror(-late.ret));
+			ret = KSFT_FAIL;
+		}
+	}
+	reap(pid);
+	return ret;
+}
+
+/*
+ * Wake thread late.pid of process late.tgid up with a signal, late.delay
+ * ns after late.go. With late.kill, the thread then exits.
+ */
+static void *late_killer(void *arg)
+{
+	uint64_t start;
+
+	while (!late.go)
+		;
+	start = now_ns();
+	while (now_ns() - start < late.delay)
+		;
+	mv_state[4] = late.kill;
+	late.ret = syscall(SYS_tgkill, late.tgid, late.pid, SIGUSR1) ? -errno : 0;
+	late.done = now_ns();
+	return arg;
+}
+
+/*
+ * Kill a sleeping deadline thread of 30% while its process moves into
+ * P. A thread that is part of a move cannot exit before the move ends:
+ * its exit waits for it. So a thread killed during the move dies right
+ * after it, and must release its bandwidth where the move left it. Once the process
+ * is gone, the free bandwidth of P and of the root domain the process
+ * left must be what it was.
+ *
+ * Try 12 delays spread over the time a move takes, each with a new
+ * process.
+ */
+static int move_died(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, i;
+	const char *name = "move_died";
+	uint64_t len = 0;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	for (i = 0; i < 12 && ret == KSFT_PASS; i++) {
+		pthread_t t;
+		pid_t pid;
+		int err;
+
+		mv_state[0] = 0;
+		mv_state[3] = 0;
+		mv_state[4] = 0;
+		pid = pinned_mover(2048, 0);
+		if (pid < 0 || child_up(name, 0)) {
+			reap(pid);
+			return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+		}
+		if (!i) {
+			/* Time one move, to spread the delays over it. */
+			uint64_t start = now_ns();
+
+			if (enter(cg_p, pid) || enter(root, pid)) {
+				ksft_print_msg("%s: a move refused\n", name);
+				reap(pid);
+				return KSFT_FAIL;
+			}
+			len = (now_ns() - start) / 2;
+		}
+		late.pid = mv_state[3];
+		late.tgid = pid;
+		late.kill = 1;
+		late.go = 0;
+		late.delay = len * i / 12;
+		if (pthread_create(&t, NULL, late_killer, NULL)) {
+			reap(pid);
+			return KSFT_FAIL;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		err = enter(cg_p, pid);
+		join(t);
+		if (err) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		}
+		reap(pid);
+		sleep_ns(3 * PERIOD);
+		if (ret == KSFT_PASS &&
+		    (admits_in(cg_p, base_p, "P, after the thread died") ||
+		     admits_in(root, base_r, "the root domain the process left"))) {
+			ksft_print_msg("%s: try %d, the death %llu us into a move of %llu us\n",
+				       name, i, (unsigned long long)(late.delay / NSEC_PER_USEC),
+				       (unsigned long long)(len / NSEC_PER_USEC));
+			ret = KSFT_FAIL;
+		}
+	}
+	return ret;
+}
+
+static int late_sysrq_fd;
+
+/*
+ * Write 'n' to /proc/sysrq-trigger, late.delay ns after late.go. sysrq-n
+ * makes every real-time and deadline task SCHED_OTHER.
+ */
+static void *late_sysrq(void *arg)
+{
+	uint64_t start;
+
+	while (!late.go)
+		;
+	start = now_ns();
+	while (now_ns() - start < late.delay)
+		;
+	late.ret = write(late_sysrq_fd, "n", 1) == 1 ? 0 : -errno;
+	late.done = now_ns();
+	return arg;
+}
+
+/*
+ * Make sysrq-n take a sleeping deadline thread of 30% out of the class
+ * while its process moves into P. cpuset_can_attach() reserves room in P
+ * for the thread. sysrq-n does not wait for the move. If it comes after
+ * the reservation, the thread moves no bandwidth, and cpuset_attach()
+ * must give the room back. Once the process is gone, the free bandwidth of P and of
+ * the root domain the process left must be what it was.
+ *
+ * sysrq-n changes the whole system. So the case runs last of the cases
+ * with P, and only with DEADLINE_TEST_SYSRQ set.
+ *
+ * Try 12 delays spread over the time a move takes, each with a new
+ * process.
+ */
+static int move_normalized(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, i;
+	const char *name = "move_normalized";
+	uint64_t len = 0;
+
+	if (!getenv("DEADLINE_TEST_SYSRQ")) {
+		ksft_print_msg("sysrq-n renices every real-time task: set DEADLINE_TEST_SYSRQ=1\n");
+		return KSFT_SKIP;
+	}
+	late_sysrq_fd = open("/proc/sysrq-trigger", O_WRONLY);
+	if (late_sysrq_fd < 0) {
+		ksft_print_msg("/proc/sysrq-trigger: %s\n", strerror(errno));
+		return KSFT_SKIP;
+	}
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	for (i = 0; i < 12 && ret == KSFT_PASS; i++) {
+		pthread_t t;
+		pid_t pid;
+		int err;
+
+		mv_state[0] = 0;
+		mv_state[3] = 0;
+		mv_state[4] = 0;
+		pid = pinned_mover(2048, 0);
+		if (pid < 0 || child_up(name, 0)) {
+			reap(pid);
+			close(late_sysrq_fd);
+			return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+		}
+		if (!i) {
+			/* Time one move, to spread the delays over it. */
+			uint64_t start = now_ns();
+
+			if (enter(cg_p, pid) || enter(root, pid)) {
+				ksft_print_msg("%s: a move refused\n", name);
+				reap(pid);
+				close(late_sysrq_fd);
+				return KSFT_FAIL;
+			}
+			len = (now_ns() - start) / 2;
+		}
+		late.go = 0;
+		late.delay = len * i / 12;
+		if (pthread_create(&t, NULL, late_sysrq, NULL)) {
+			reap(pid);
+			close(late_sysrq_fd);
+			return KSFT_FAIL;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		err = enter(cg_p, pid);
+		join(t);
+		if (err) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		} else if (late.ret) {
+			ksft_print_msg("%s: sysrq-n: %s\n", name, strerror(-late.ret));
+			ret = KSFT_SKIP;
+		}
+		reap(pid);
+		sleep_ns(3 * PERIOD);
+		if (ret == KSFT_PASS &&
+		    (admits_in(cg_p, base_p, "P, after sysrq-n") ||
+		     admits_in(root, base_r, "the root domain the process left"))) {
+			ksft_print_msg("%s: try %d, sysrq-n %llu us into a move of %llu us\n",
+				       name, i, (unsigned long long)(late.delay / NSEC_PER_USEC),
+				       (unsigned long long)(len / NSEC_PER_USEC));
+			ret = KSFT_FAIL;
+		}
+	}
+	close(late_sysrq_fd);
+	return ret;
+}
+
+static int hold(int n);
+static void release_held(void);
+
+/*
+ * Wake a sleeping deadline thread of 30% up while its process moves from
+ * P to the root cgroup.
+ *
+ * The process is pinned_mover(): 2048 sleeping threads, then the deadline
+ * thread. That thread first ran on the second CPU of the root cgroup,
+ * went to sleep there, and was moved into P asleep. So P counts it, and
+ * it is still on that CPU. A thread of the test, late_killer(), wakes it
+ * up with a signal.
+ *
+ * cpuset_can_attach() reserves room for the thread on the CPU that the
+ * move back records: the CPU the thread is on. If the thread wakes up
+ * after that, it runs on the CPU of P. cpuset_attach() must still move
+ * the bandwidth to the CPU recorded. Working the CPU out again would
+ * give the first CPU of the root cgroup, where nothing is reserved.
+ *
+ * Both CPUs are in the same root domain. So that root domain must count
+ * the thread once the move is done, and P must no longer count it.
+ *
+ * With @full, hold() first fills that root domain with deadline threads
+ * of the test, until 40% is free. The thread of 30% then fits once, and
+ * not twice.
+ *
+ * Try 12 delays spread over the time a move takes, each with a new
+ * process.
+ */
+static int woken(int full, const char *name)
+{
+	int base_p, base_r, free_r, ret = KSFT_PASS, i;
+	uint64_t len = 0;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	if (base_r < 5) {
+		ksft_print_msg("%s: no room for the thread\n", name);
+		return KSFT_SKIP;
+	}
+	free_r = base_r;
+	if (full) {
+		if (hold(base_r - 4)) {
+			release_held();
+			return KSFT_FAIL;
+		}
+		free_r = 4;
+	}
+	for (i = 0; i < 12 && ret == KSFT_PASS; i++) {
+		pid_t pid, tid;
+		pthread_t t;
+		int err;
+
+		mv_state[0] = 0;
+		mv_state[3] = 0;
+		mv_state[4] = 0;
+		/* Not the first CPU: the move falls back to that one. */
+		sleeper_cpu = online[1];
+		pid = pinned_mover(2048, 0);
+		sleeper_cpu = -1;
+		if (pid < 0 || child_up(name, 0)) {
+			reap(pid);
+			release_held();
+			return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+		}
+		tid = mv_state[3];
+		sleep_ns(PERIOD);
+		if (!i) {
+			/*
+			 * Time the move into P, to spread the delays over
+			 * a move.
+			 */
+			uint64_t start = now_ns();
+
+			err = enter(cg_p, pid);
+			if (!err) {
+				len = now_ns() - start;
+				err = enter(root, pid);
+			}
+			if (err) {
+				ksft_print_msg("%s: a move refused\n", name);
+				reap(pid);
+				release_held();
+				return KSFT_FAIL;
+			}
+		}
+		if (enter(cg_p, pid)) {
+			ksft_print_msg("%s: the process cannot go into P\n", name);
+			reap(pid);
+			release_held();
+			return KSFT_FAIL;
+		}
+		if (task_cpu_of(tid) != online[1]) {
+			ksft_print_msg("%s: the thread is on CPU %d, not on CPU %d\n", name,
+				       task_cpu_of(tid), online[1]);
+			reap(pid);
+			release_held();
+			return KSFT_SKIP;
+		}
+		late.pid = tid;
+		late.tgid = pid;
+		late.kill = 0;
+		late.go = 0;
+		late.delay = len * i / 12;
+		if (pthread_create(&t, NULL, late_killer, NULL)) {
+			reap(pid);
+			release_held();
+			return KSFT_FAIL;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		err = enter(root, pid);
+		join(t);
+		if (err) {
+			ksft_print_msg("%s: the move refused: %s\n", name, strerror(-err));
+			ret = KSFT_FAIL;
+		}
+		sleep_ns(2 * PERIOD);
+		if (ret == KSFT_PASS &&
+		    (admits_in(cg_p, base_p, "P, which the thread left") ||
+		     admits_in(root, free_r - 3, "the root domain of the thread"))) {
+			ksft_print_msg("%s: try %d, the wakeup %llu us into a move of %llu us\n",
+				       name, i, (unsigned long long)(late.delay / NSEC_PER_USEC),
+				       (unsigned long long)(len / NSEC_PER_USEC));
+			ret = KSFT_FAIL;
+		}
+		reap(pid);
+		sleep_ns(3 * PERIOD);
+	}
+	release_held();
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS &&
+	    (admits_in(cg_p, base_p, "P, at the end") ||
+	     admits_in(root, base_r, "the root domain of the rest, at the end")))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+static int move_woken(void)
+{
+	return woken(0, "move_woken");
+}
+
+static int move_woken_full(void)
+{
+	return woken(1, "move_woken_full");
+}
+
 /*
  * Have the cpu controller refuse a move after cpuset_can_attach()
  * reserved room. cpuset_cancel_attach() must then give the room back.
@@ -2959,6 +4157,78 @@ static int move_cancelled(void)
 	return ret;
 }
 
+/* Return whether every task of @cg is frozen. */
+static int cg_frozen(const char *cg)
+{
+	char path[PATH_MAX + 32], buf[256];
+
+	snprintf(path, sizeof(path), "%s/cgroup.events", cg);
+	return !read_file(path, buf, sizeof(buf)) && strstr(buf, "frozen 1");
+}
+
+/*
+ * Freeze P with a running deadline task of 30% in it. Move the frozen
+ * task to the root cgroup, switch it to SCHED_OTHER, thaw P and kill the
+ * task. Do it three times. The free bandwidth of P and of the root
+ * domain of the other CPUs must then be what it was.
+ *
+ * A frozen task sleeps in its signal handling. The root cgroup is not
+ * frozen, so the move thaws the task. It is woken on P's CPU, before
+ * cpuset_attach() gives it the CPUs of the root cgroup.
+ */
+static int frozen_moved_switched(void)
+{
+	const char *what = "a deadline task to freeze";
+	int base_p, base_r, ret = KSFT_PASS, i;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	for (i = 0; i < 3 && ret == KSFT_PASS; i++) {
+		pid_t pid;
+
+		mv_state[0] = 0;
+		pid = fork_child(what);
+		if (!pid) {
+			if (enter(cg_p, getpid()) ||
+			    set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+				mv_state[0] = -1;
+				_exit(1);
+			}
+			mv_state[0] = 1;
+			for (;;)
+				spin_ns(NSEC_PER_MSEC);
+		}
+		if (pid < 0 || child_up(what, 0)) {
+			reap(pid);
+			return KSFT_FAIL;
+		}
+		if (write_file(cg_p, "cgroup.freeze", "1")) {
+			ksft_print_msg("P cannot be frozen\n");
+			reap(pid);
+			return KSFT_SKIP;
+		}
+		if (wait_for(2000, cg_frozen(cg_p))) {
+			ksft_print_msg("P does not freeze\n");
+			ret = KSFT_FAIL;
+		} else if (enter(root, pid)) {
+			ksft_print_msg("the frozen task cannot leave P\n");
+			ret = KSFT_FAIL;
+		} else if (set_other(pid)) {
+			ksft_print_msg("the task cannot leave SCHED_DEADLINE\n");
+			ret = KSFT_FAIL;
+		}
+		if (write_file(cg_p, "cgroup.freeze", "0"))
+			ksft_print_msg("P cannot be thawed\n");
+		reap(pid);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS &&
+	    (admits_in(cg_p, base_p, "P, after the frozen tasks") ||
+	     admits_in(root, base_r, "the root domain of the rest")))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
 /* Deaths, in P */
 
 enum die_mode { DIE_RUNNING, DIE_SWITCHED_OUT, DIE_SHRUNK };
@@ -3558,6 +4828,11 @@ static int yield_switched_out(void)
 	return ret;
 }
 
+static int yield_moved(void)
+{
+	return moves(MV_YIELDED, "yield_moved");
+}
+
 /* Kill a deadline task while sched_yield() throttles it. */
 static int yield_killed(void)
 {
@@ -3833,6 +5108,109 @@ static int reclaim_switched(void)
 	return ret;
 }
 
+/*
+ * Fork a reclaiming deadline task of 10%. It spins, and publishes in
+ * mv_state[1] the CPU time it has used, in milliseconds. It idles while
+ * mv_state[2] is set, and the moves happen then. A cpuset move waits for
+ * an RCU grace period. Where RCU runs in kthreads (PREEMPT_RT), a task
+ * that reclaims its whole CPU keeps that grace period from ending. Return
+ * the pid, or -1.
+ */
+static pid_t reclaim_mover(void)
+{
+	pid_t pid = fork_child("a reclaiming task");
+
+	if (!pid) {
+		if (set_deadline_flags(0, 10 * NSEC_PER_MSEC, PERIOD,
+				       SCHED_FLAG_RECLAIM)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		for (;;) {
+			if (mv_state[2]) {
+				sleep_ns(10 * NSEC_PER_MSEC);
+				continue;
+			}
+			spin_ns(NSEC_PER_MSEC);
+			mv_state[1] = (int)(thread_time_ns() / NSEC_PER_MSEC);
+		}
+	}
+	return pid;
+}
+
+/* Idle the reclaiming task, then move it to @cg. Return 0, or -errno. */
+static int move_idle(const char *cg, pid_t pid)
+{
+	int err;
+
+	mv_state[2] = 1;
+	sleep_ns(20 * NSEC_PER_MSEC);	/* it stops spinning */
+	err = enter(cg, pid);
+	mv_state[2] = 0;
+	return err;
+}
+
+/* Return the CPU share, in percent, of the reclaiming task over @ns. */
+static int mover_share(uint64_t ns)
+{
+	uint64_t wall = now_ns();
+	int cpu = mv_state[1];
+
+	sleep_ns(ns);
+	cpu = mv_state[1] - cpu;
+	wall = now_ns() - wall;
+	return (int)(100 * (uint64_t)cpu * NSEC_PER_MSEC / wall);
+}
+
+/*
+ * Move a reclaiming task into P, back out, and into P again. It must
+ * reclaim as much of P's CPU as it did the first time. Once it is gone,
+ * the free bandwidth of both root domains must be what it was.
+ */
+static int reclaim_moved(void)
+{
+	int base_p, base_r, in_p, again = 0, ret = KSFT_PASS;
+	pid_t pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	mv_state[2] = 1;		/* idle until it is in P */
+	pid = reclaim_mover();
+	if (pid < 0)
+		return KSFT_FAIL;
+	if (child_up("a reclaiming task", 0) || move_idle(cg_p, pid)) {
+		mv_state[2] = 1;
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	sleep_ns(2 * PERIOD);
+	in_p = mover_share(SHARE_NS);
+	if (move_idle(root, pid) || move_idle(cg_p, pid)) {
+		ksft_print_msg("a move of a reclaiming task refused\n");
+		ret = KSFT_FAIL;
+	} else {
+		sleep_ns(2 * PERIOD);
+		again = mover_share(SHARE_NS);
+		if (in_p < RECLAIM_MIN || again < in_p - SHARE_SLACK ||
+		    again > in_p + SHARE_SLACK) {
+			ksft_print_msg("reclaiming: %d%% of P's CPU, %d%% after a move\n",
+				       in_p, again);
+			ret = KSFT_FAIL;
+		}
+	}
+	mv_state[2] = 1;
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("a reclaiming task moved: the free bandwidth changed\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /* Deadline servers */
 
 #define SERVER_RUNTIME	(100 * NSEC_PER_MSEC)	/* the cases start at 10% */
@@ -4557,6 +5935,281 @@ static int params_waking(void)
 	return ret;
 }
 
+/* A random mix of the transitions above */
+
+#define MIX_WORKERS	6
+#define MIX_NS		(3 * NSEC_PER_SEC)
+#define MIX_SEED	20261103	/* fixed: a rerun starts with the same draws */
+
+/*
+ * random_mix: six workers change their own state at random for 3s, and
+ * the case changes them from outside too. Q is a partition root of two
+ * CPUs, next to P. The case needs 4 housekeeping CPUs.
+ *
+ * Each worker does one of these, over and over:
+ *  - become a deadline task, with random parameters and flags
+ *  - switch to SCHED_OTHER
+ *  - sleep
+ *  - spin, at times past its runtime
+ *  - call sched_yield()
+ *  - wait up to 5ms for shm_lock and hold it 1ms. It is the mutex of the
+ *    priority inheritance cases. A deadline waiter boosts its owner.
+ *  - exit
+ *
+ * The case does one of these, over and over:
+ *  - set the deadline parameters of a random worker
+ *  - switch it to SCHED_OTHER
+ *  - change its affinity
+ *  - move it into P, into Q or into the root cgroup
+ *  - kill it
+ *  - change the fair server of P's CPU or of one CPU of Q
+ * It starts anew every worker it finds dead.
+ *
+ * The case does not check what a single transition does: the other cases
+ * do that. It checks the accounting afterwards. Once every worker is gone
+ * and its 0-lag time is past:
+ *  - P, Q and the housekeeping root domain must each admit what they
+ *    admitted before;
+ *  - this_bw of P's CPU and of the two CPUs of Q must be what it was.
+ * An over- or underflow of running_bw or this_bw also shows as a warning
+ * in the kernel log, which the test does not read.
+ */
+static atomic_int *mix_state;		/* 0: stop, 1 + i: worker i's rounds */
+
+static pid_t mix_worker(int idx, unsigned int seed)
+{
+	static const uint64_t runtime[] = { 5, 10, 20, 30 };
+	static const uint64_t period[] = { 50, 100 };
+	static const uint64_t flag[] = { 0, SCHED_FLAG_RECLAIM, SCHED_FLAG_DL_OVERRUN };
+	pid_t pid = fork_child("a worker of the mix");
+
+	if (!pid) {
+		struct sigaction sa = { .sa_handler = catch_xcpu };
+		struct timespec ts;
+		int err;
+
+		if (sigaction(SIGXCPU, &sa, NULL))
+			_exit(1);
+		seed += idx;
+		/*
+		 * Ignore the errors. Each call below is made in whatever
+		 * state the worker is in, and the kernel may refuse it.
+		 */
+		while (!mix_state[0]) {
+			unsigned int r = rand_r(&seed), v = r / 8;
+
+			switch (r % 8) {
+			case 0:
+				set_deadline_flags(0, runtime[v % 4] * NSEC_PER_MSEC,
+						   period[(v / 4) % 2] * NSEC_PER_MSEC,
+						   flag[(v / 8) % 3]);
+				break;
+			case 1:
+				set_other(0);
+				break;
+			case 2:
+				sleep_ns((v % 20 + 1) * NSEC_PER_MSEC);
+				break;
+			case 3:
+				spin_ns((v % 15 + 1) * NSEC_PER_MSEC);
+				break;
+			case 4:
+				sched_yield();
+				break;
+			case 5:
+				clock_gettime(CLOCK_REALTIME, &ts);
+				ts.tv_nsec += 5 * NSEC_PER_MSEC;
+				if (ts.tv_nsec >= NSEC_PER_SEC) {
+					ts.tv_nsec -= NSEC_PER_SEC;
+					ts.tv_sec++;
+				}
+				err = pthread_mutex_timedlock(shm_lock, &ts);
+				if (err == EOWNERDEAD)	/* its owner died */
+					err = pthread_mutex_consistent(shm_lock);
+				if (!err) {
+					spin_ns(NSEC_PER_MSEC);
+					if (pthread_mutex_unlock(shm_lock))
+						_exit(1);
+				}
+				break;
+			case 6:
+				_exit(0);	/* the case starts another */
+			default:
+				sleep_ns(NSEC_PER_MSEC / 2);
+				break;
+			}
+			mix_state[1 + idx]++;
+		}
+		_exit(0);
+	}
+	return pid;
+}
+
+static cpu_set_t mix_mask[4];
+
+static int random_mix(void)
+{
+	static const uint64_t runtime[] = { 5, 10, 20, 30 };
+	int cpu_a = top_cpu(3), cpu_b = top_cpu(2), cpu_p = top_cpu(1);
+	int base_p, base_q, base_r, i, ret = KSFT_PASS, rounds = 0, sums;
+	long ta = 0, ra, tb = 0, rb, tp = 0, rp, ta2, ra2, tb2, rb2, tp2, rp2;
+	pid_t pid[MIX_WORKERS] = { -1, -1, -1, -1, -1, -1 };
+	unsigned int seed = MIX_SEED;
+	uint64_t end;
+	char cpus[32];
+
+	if (ncpus < 4) {
+		ksft_print_msg("needs 4 non-isolated CPUs\n");
+		return KSFT_SKIP;
+	}
+	snprintf(cpus, sizeof(cpus), "%d,%d", cpu_a, cpu_b);
+	if (make_partition_cpus(cg_q, cpus)) {
+		remove_partition(cg_q);
+		ksft_print_msg("no partition root of two CPUs\n");
+		return KSFT_SKIP;
+	}
+	/*
+	 * The affinities of the mix: every CPU of the test, those of Q and
+	 * P, those of P and the rest, and all but the first.
+	 */
+	for (i = 0; i < 4; i++)
+		CPU_ZERO(&mix_mask[i]);
+	for (i = 0; i < ncpus; i++) {
+		int c = online[i];
+
+		CPU_SET(c, &mix_mask[0]);
+		if (c == cpu_a || c == cpu_b || c == cpu_p)
+			CPU_SET(c, &mix_mask[1]);
+		if (c != cpu_a && c != cpu_b)
+			CPU_SET(c, &mix_mask[2]);
+		if (i)
+			CPU_SET(c, &mix_mask[3]);
+	}
+	if (shm_lock_init()) {
+		remove_partition(cg_q);
+		return KSFT_SKIP;	/* no shared mutex for the workers */
+	}
+	/* Without this_bw in sched_debug, check the admissions only. */
+	sums = !rq_bw_of(cpu_a, &ta, &ra) && !rq_bw_of(cpu_b, &tb, &rb) &&
+	       !rq_bw_of(cpu_p, &tp, &rp);
+	base_p = probe(cg_p);
+	base_q = probe(cg_q);
+	base_r = probe(root);
+	if (base_p <= 0 || base_q <= 0 || base_r <= 0) {
+		remove_partition(cg_q);
+		ksft_print_msg("no room to probe P, Q or the rest\n");
+		return KSFT_SKIP;
+	}
+	mix_state = mv_state + 16;
+	for (i = 0; i <= MIX_WORKERS; i++)
+		mix_state[i] = 0;
+	for (i = 0; i < MIX_WORKERS; i++) {
+		pid[i] = mix_worker(i, seed);
+		if (pid[i] < 0) {
+			ret = KSFT_FAIL;
+			goto out;
+		}
+	}
+
+	end = now_ns() + MIX_NS;
+	while (now_ns() < end) {
+		unsigned int r = rand_r(&seed);
+		int w = r % MIX_WORKERS;
+
+		switch ((r / MIX_WORKERS) % 8) {
+		case 0:
+			set_deadline(pid[w], runtime[r % 4] * NSEC_PER_MSEC, PERIOD);
+			break;
+		case 7:
+			/*
+			 * Refused with EBUSY if the mask leaves out a CPU
+			 * of the root domain that counts a deadline task.
+			 */
+			sched_setaffinity(pid[w], sizeof(mix_mask[0]), &mix_mask[r % 4]);
+			break;
+		case 1:
+			set_other(pid[w]);
+			break;
+		case 2:
+			enter(cg_p, pid[w]);
+			break;
+		case 3:
+			enter(cg_q, pid[w]);
+			break;
+		case 4:
+			enter(root, pid[w]);
+			break;
+		case 5:
+			/* An exited worker is a zombie: the kill succeeds. */
+			if (kill(pid[w], SIGKILL) && errno != ESRCH)
+				ksft_print_msg("kill %d: %s\n", pid[w], strerror(errno));
+			break;
+		default:
+			server_set(r % 2 ? cpu_p : cpu_a,
+				   (r % 3 + 1) * SERVER_RUNTIME, SERVER_PERIOD);
+			break;
+		}
+		sleep_ns((r % 2000 + 100) * NSEC_PER_USEC);
+		/* Start anew each worker that exited or was killed. */
+		for (i = 0; i < MIX_WORKERS; i++) {
+			pid_t done = waitpid(pid[i], NULL, WNOHANG);
+
+			if (done < 0 && errno != EINTR) {
+				ksft_print_msg("waitpid %d: %s\n", pid[i], strerror(errno));
+				ret = KSFT_FAIL;
+				goto out;
+			}
+			if (done == pid[i]) {
+				pid[i] = mix_worker(i, seed + rounds);
+				if (pid[i] < 0) {
+					ret = KSFT_FAIL;
+					goto out;
+				}
+				rounds++;
+			}
+		}
+	}
+out:
+	mix_state[0] = 1;
+	for (i = 0; i < MIX_WORKERS; i++)
+		reap(pid[i]);
+	/*
+	 * Wait for the 0-lag times of the workers. Putting the fair servers
+	 * back needs the room they held.
+	 */
+	sleep_ns(5 * PERIOD);
+	server_restore();
+	if (ret != KSFT_PASS) {
+		remove_partition(cg_q);
+		return ret;
+	}
+	for (i = 0, rounds = 0; i < MIX_WORKERS; i++)
+		rounds += mix_state[1 + i];
+	if (!rounds) {
+		ksft_print_msg("the workers of the mix took no transition\n");
+		ret = KSFT_FAIL;
+	}
+	if (ret == KSFT_PASS && sums) {
+		if (rq_bw_of(cpu_a, &ta2, &ra2) || rq_bw_of(cpu_b, &tb2, &rb2) ||
+		    rq_bw_of(cpu_p, &tp2, &rp2)) {
+			ret = KSFT_FAIL;
+		} else if (ta2 != ta || tb2 != tb || tp2 != tp) {
+			ksft_print_msg("this_bw %ld %ld %ld, was %ld %ld %ld\n",
+				       ta2, tb2, tp2, ta, tb, tp);
+			ret = KSFT_FAIL;
+		}
+	}
+	if (ret == KSFT_PASS &&
+	    (admits_in(cg_p, base_p, "P after the mix") ||
+	     admits_in(cg_q, base_q, "Q after the mix") ||
+	     admits_in(root, base_r, "the root domain of the rest after the mix")))
+		ret = KSFT_FAIL;
+	if (ret != KSFT_PASS)
+		ksft_print_msg("seed %u, %d transitions\n", MIX_SEED, rounds);
+	remove_partition(cg_q);
+	return ret;
+}
+
 /*
  * CPU hotplug, from the main process, with no P. Two cases below run with
  * P instead: death_zombie_hotplug and pi_departed_moved.
@@ -5223,6 +6876,834 @@ static int in_cpu_list(const char *list, int cpu)
 	return 0;
 }
 
+/*
+ * Wake @pid, a task that sleeps in read() on a pipe: write a byte to @fd.
+ * The task counts its wakeups in mv_state[1]. Wait until it has run and
+ * sleeps again. Return 0, or -1.
+ */
+static int fallback_wake(int fd, pid_t pid)
+{
+	int n = mv_state[1];
+
+	if (write(fd, "w", 1) != 1) {
+		ksft_print_msg("write to the deadline task: %s\n", strerror(errno));
+		return -1;
+	}
+	if (wait_for(1000, mv_state[1] != n) ||
+	    wait_for(1000, proc_state_of(pid) == 'S')) {
+		ksft_print_msg("the deadline task did not wake up and sleep again\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * The cpusets of the cases below: B and Q in the root cgroup, C in B. A
+ * case makes those it needs. cs_setup() names them and enables the cpuset
+ * controller of the root cgroup if it is off. cs_cleanup() removes them,
+ * and turns the controller off again if cs_setup() turned it on.
+ */
+static char cs_b[PATH_MAX], cs_c[PATH_MAX], cs_q[PATH_MAX];
+static int cs_added;
+
+static int cs_setup(void)
+{
+	char path[PATH_MAX + 32], buf[256];
+
+	cs_added = 0;
+	if (!root[0] ||
+	    snprintf(cs_b, sizeof(cs_b), "%s/deadline_bw_b", root) >= (int)sizeof(cs_b) ||
+	    snprintf(cs_c, sizeof(cs_c), "%s/c", cs_b) >= (int)sizeof(cs_c) ||
+	    snprintf(cs_q, sizeof(cs_q), "%s/deadline_bw_q", root) >= (int)sizeof(cs_q))
+		return -1;
+	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", root);
+	if (read_file(path, buf, sizeof(buf)))
+		return -1;
+	if (!strstr(buf, "cpuset")) {
+		if (write_file(root, "cgroup.subtree_control", "+cpuset"))
+			return -1;
+		cs_added = 1;
+	}
+	return 0;
+}
+
+/* Make the cpuset @cg, and give it the CPUs of @cpus. Return 0, or -1. */
+static int cs_make(const char *cg, const char *cpus)
+{
+	int err = 0;
+
+	if (mkdir(cg, 0755) && errno != EEXIST)
+		err = -errno;
+	if (!err)
+		err = write_file(cg, "cpuset.cpus", cpus);
+	if (err)
+		ksft_print_msg("cpuset %s of CPUs %s: %s\n", cg, cpus, strerror(-err));
+	return err ? -1 : 0;
+}
+
+static void cs_cleanup(void)
+{
+	remove_partition(cs_c);
+	remove_partition(cs_b);
+	remove_partition(cs_q);
+	if (cs_added && write_file(root, "cgroup.subtree_control", "-cpuset"))
+		ksft_print_msg("the cpuset controller stays enabled\n");
+}
+
+/*
+ * Return whether the partition file of @cg holds @what. If not, and
+ * @tell, print what it holds.
+ */
+static int partition_has(const char *cg, const char *what, int tell)
+{
+	char path[PATH_MAX + 32], buf[256];
+
+	snprintf(path, sizeof(path), "%s/cpuset.cpus.partition", cg);
+	if (read_file(path, buf, sizeof(buf)))
+		return 0;
+	if (strstr(buf, what))
+		return 1;
+	if (tell)
+		ksft_print_msg("%s/cpuset.cpus.partition: %s", cg, buf);
+	return 0;
+}
+
+/*
+ * Read total_bw of the root domain of @d into @def, and of the root
+ * domain of @h into @hk. Return 0, or -1.
+ */
+static int totals_of(int d, int h, long long *def, long long *hk)
+{
+	*def = total_bw_of(d);
+	*hk = total_bw_of(h);
+	if (*def == -1 || *hk == -1) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Return KSFT_PASS if total_bw of the root domains of @d and @h is
+ * @def and @hk, else KSFT_FAIL. @what names the step in the message.
+ */
+static int totals_check(const char *what, int d, int h, long long def, long long hk)
+{
+	long long now_def, now_hk;
+
+	if (totals_of(d, h, &now_def, &now_hk))
+		return KSFT_FAIL;
+	if (now_def == def && now_hk == hk)
+		return KSFT_PASS;
+	ksft_print_msg("%s: total_bw %lld, %lld, not %lld, %lld\n",
+		       what, now_def, now_hk, def, hk);
+	return KSFT_FAIL;
+}
+
+/*
+ * Fork a task that runs on @cpu. Then it allows every CPU if @all. If
+ * not, it allows the housekeeping CPUs that were online at the start,
+ * even those offline now. It becomes a deadline task of @runtime every
+ * @period. If @fd is -1, it spins and counts in mv_state[1]. Else it
+ * sleeps in read() on @fd and counts in mv_state[1] each byte that wakes
+ * it. On the byte 'x', it spins 90ms and exits. It sets mv_state[0] as
+ * mover() does. Return its pid, or -1.
+ */
+static pid_t task_from(int cpu, int all, uint64_t runtime, uint64_t period, int fd)
+{
+	pid_t pid = fork_child("a deadline task");
+
+	if (!pid) {
+		cpu_set_t set, one;
+		int i;
+		char c;
+
+		CPU_ZERO(&one);
+		CPU_SET(cpu, &one);
+		if (sched_setaffinity(0, sizeof(one), &one))
+			_exit(1);
+		spin_ns(NSEC_PER_MSEC);
+		CPU_ZERO(&set);
+		for (i = 0; i < (all ? CPU_SETSIZE : ncpus); i++)
+			CPU_SET(all ? i : online[i], &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, runtime, period)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		while (fd < 0)
+			mv_state[1]++;
+		while (read(fd, &c, 1) == 1) {
+			if (c == 'x') {
+				spin_ns(90 * NSEC_PER_MSEC);
+				_exit(0);
+			}
+			mv_state[1]++;
+		}
+		_exit(0);
+	}
+	return pid;
+}
+
+/*
+ * The default root domain spans every CPU that is offline. It also spans
+ * the CPU of an isolated partition. The steps:
+ * 1. Take hp_cpu offline. Make Q an isolated partition of Y, another
+ *    housekeeping CPU.
+ * 2. A task in the root cgroup becomes a deadline task of 10% and sleeps.
+ *    The housekeeping root domain counts it. Its affinity holds the
+ *    housekeeping CPUs, hp_cpu too.
+ * 3. Move it asleep into Q. Wake it: it runs on Y. The default root
+ *    domain counts it.
+ * 4. Move it asleep back to the root cgroup. Its mask holds hp_cpu, but
+ *    no active CPU of the default root domain.
+ * 5. Wake it. It runs on a housekeeping CPU.
+ * Check after step 4 and again after step 5. The housekeeping root
+ * domain must count the task. The default root domain must not. An
+ * offline CPU of the default root domain is no CPU where the task can
+ * stay.
+ *
+ * The references of total_bw are taken after step 1. Once the task is
+ * gone, total_bw must be back to them.
+ */
+static int move_back_cpu_offline(void)
+{
+	int y = hp_cpu == top_cpu(1) ? top_cpu(2) : top_cpu(1), h = online[0];
+	int fd[2] = { -1, -1 }, cpu, err, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[16];
+	pid_t pid = -1;
+
+	if (cs_setup())
+		return KSFT_SKIP;
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("CPU %d cannot go offline\n", hp_cpu);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", y);
+	if (cs_make(cs_q, buf) || write_file(cs_q, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_q, "isolated", 1) || partition_has(cs_q, "invalid", 0)) {
+		ksft_print_msg("no isolated partition Q of CPU %d\n", y);
+		goto out;
+	}
+	if (totals_of(y, h, &def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(h, 0, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("move_back_cpu_offline", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(y, h, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	if (bw <= 0 || def != def0) {
+		ksft_print_msg("the deadline task adds %lld, %lld to total_bw\n",
+			       def - def0, bw);
+		goto out;
+	}
+	err = enter(cs_q, pid);
+	if (err) {
+		ksft_print_msg("a move into Q refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (fallback_wake(fd[1], pid) ||
+	    totals_check("in Q", y, h, def0 + bw, hk0))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != y) {
+		ksft_print_msg("woken in Q on CPU %d, not %d\n", cpu, y);
+		goto out;
+	}
+	err = enter(root, pid);
+	if (err) {
+		ksft_print_msg("the move back refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (totals_check("moved back asleep", y, h, def0, hk0 + bw) ||
+	    fallback_wake(fd[1], pid) ||
+	    totals_check("woken", y, h, def0, hk0 + bw))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu == y || in_cpu_list(isolated, cpu)) {
+		ksft_print_msg("woken on CPU %d\n", cpu);
+		goto out;
+	}
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	ret = totals_check("task gone", y, h, def0, hk0);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	cs_cleanup();
+	cpu_up(hp_cpu);
+	return ret;
+}
+
+/* Moves between two root domains, from the main process, with P */
+
+/*
+ * Fork a deadline task of 30ms every 100ms, pinned to the @n CPUs of
+ * @cpus. It runs 1ms, then sleeps. If @fd is not -1, each byte read from
+ * @fd wakes it up, and it counts the wakeups in mv_state[1]. It sets
+ * mv_state[0] as mover() does. Return its pid, or -1.
+ */
+static pid_t pinned_sleeper(const int *cpus, int n, int fd)
+{
+	pid_t pid = fork_child("a pinned deadline task");
+
+	if (!pid) {
+		cpu_set_t set;
+		char c;
+		int i;
+
+		CPU_ZERO(&set);
+		for (i = 0; i < n; i++)
+			CPU_SET(cpus[i], &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		spin_ns(NSEC_PER_MSEC);
+		mv_state[0] = 1;
+		while (fd >= 0 && read(fd, &c, 1) == 1)
+			mv_state[1]++;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/*
+ * Read total_bw of three root domains into @bw: the root domain of the
+ * isolated CPUs, the housekeeping root domain, and P. Return 0, or -1.
+ */
+static int split_totals(long long bw[3])
+{
+	bw[0] = total_bw_of(isol[0]);
+	bw[1] = total_bw_of(online[0]);
+	bw[2] = total_bw_of(top_cpu(1));
+	if (bw[0] == -1 || bw[1] == -1 || bw[2] == -1) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Return KSFT_PASS if total_bw is now @want, else KSFT_FAIL. The message
+ * gives total_bw of the root domain of the isolated CPUs, then of the
+ * housekeeping root domain, then of P.
+ */
+static int split_check(const char *what, const long long want[3])
+{
+	long long bw[3];
+
+	if (split_totals(bw))
+		return KSFT_FAIL;
+	if (bw[0] == want[0] && bw[1] == want[1] && bw[2] == want[2])
+		return KSFT_PASS;
+	ksft_print_msg("%s: total_bw %lld, %lld, %lld, not %lld, %lld, %lld\n",
+		       what, bw[0], bw[1], bw[2], want[0], want[1], want[2]);
+	return KSFT_FAIL;
+}
+
+/*
+ * Read total_bw into @base, for the cases below. Return 0, or nonzero if
+ * the case must skip. It needs CPUs isolated by isolcpus="domain".
+ */
+static int split_skip(long long base[3])
+{
+	if (!nisol) {
+		ksft_print_msg("needs CPUs isolated by isolcpus=domain\n");
+		return 1;
+	}
+	return split_totals(base);
+}
+
+/*
+ * The root cpuset holds the CPUs that isolcpus="domain" isolates, so it
+ * spans two root domains. The affinity of a task can keep it in either.
+ * A move into the root cpuset must reserve the bandwidth of the task in
+ * the root domain that the task gets.
+ *
+ * Run twice, with a deadline sleeper of 30% pinned to the isolated CPUs,
+ * then with another one pinned to the housekeeping CPUs except P's. Move
+ * the sleeper into P and back to the root cgroup, then kill it. Once it
+ * is gone, total_bw of the three root domains must be what it was.
+ */
+static int move_isolated(void)
+{
+	long long base[3];
+	int round, err;
+	pid_t pid;
+
+	if (split_skip(base))
+		return KSFT_SKIP;
+	for (round = 0; round < 2; round++) {
+		const char *what = round ? "pinned to the other CPUs" :
+				   "pinned to the isolated CPUs";
+
+		mv_state[0] = 0;
+		pid = round ? pinned_sleeper(online, ncpus - 1, -1) :
+			      pinned_sleeper(isol, nisol, -1);
+		if (pid < 0 || child_up(what, 0)) {
+			reap(pid);
+			return KSFT_FAIL;
+		}
+		err = enter(cg_p, pid);
+		if (!err)
+			err = enter(root, pid);
+		reap(pid);
+		if (err) {
+			ksft_print_msg("%s: a move refused: %s\n", what, strerror(-err));
+			return KSFT_FAIL;
+		}
+		sleep_ns(3 * PERIOD);
+		if (split_check(what, base))
+			return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+/*
+ * Fork a process pinned to the isolated CPUs. Its threads become deadline
+ * tasks of 10ms every 100ms, as in probe(), until one is refused. Then it
+ * sets mv_state[1] to 1, or to -1 on an error. The threads sleep until the
+ * process is killed.
+ */
+static pid_t fill_isolated(void)
+{
+	pid_t pid = fork_child("the tasks that fill the isolated CPUs");
+
+	if (!pid) {
+		int i, max = 16 * nisol + 16;
+		struct probe_slot *s = calloc(max, sizeof(*s));
+		pthread_attr_t a;
+		cpu_set_t set;
+
+		CPU_ZERO(&set);
+		for (i = 0; i < nisol; i++)
+			CPU_SET(isol[i], &set);
+		if (!s || sched_setaffinity(0, sizeof(set), &set) ||
+		    sem_init(&probe_done, 0, 0) || pipe(probe_hold) ||
+		    pthread_attr_init(&a) || pthread_attr_setstacksize(&a, THREAD_STACK)) {
+			mv_state[1] = -1;
+			_exit(1);
+		}
+		for (i = 0; i < max; i++) {
+			if (pthread_create(&s[i].t, &a, probe_thread, &s[i]) ||
+			    sem_wait_for(&probe_done, 10000)) {
+				mv_state[1] = -1;
+				_exit(1);
+			}
+			if (s[i].err)
+				break;
+		}
+		mv_state[1] = i < max && s[i].err == -EBUSY ? 1 : -1;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/*
+ * Move a deadline sleeper pinned to the isolated CPUs into P. Fill the
+ * isolated CPUs with deadline tasks of 10%, until one is refused. Moving
+ * the sleeper back must then be refused with EBUSY.
+ */
+static int move_isolated_refused(void)
+{
+	pid_t pid, fill = -1;
+	long long base[3];
+	int err, ret = KSFT_FAIL;
+
+	if (split_skip(base))
+		return KSFT_SKIP;
+	mv_state[0] = 0;
+	pid = pinned_sleeper(isol, nisol, -1);
+	if (pid < 0 || child_up("a sleeper pinned to the isolated CPUs", 0))
+		goto out;
+	err = enter(cg_p, pid);
+	if (err) {
+		ksft_print_msg("a move into P refused: %s\n", strerror(-err));
+		goto out;
+	}
+	mv_state[1] = 0;
+	fill = fill_isolated();
+	if (fill < 0 || wait_for(10000, mv_state[1]) || mv_state[1] != 1) {
+		ksft_print_msg("the isolated CPUs cannot be filled\n");
+		goto out;
+	}
+	err = enter(root, pid);
+	if (err == -EBUSY) {
+		ret = KSFT_PASS;
+	} else {
+		ksft_print_msg("a move back to the full isolated CPUs: %s, not EBUSY\n",
+			       err ? strerror(-err) : "accepted");
+	}
+out:
+	reap(fill);
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = split_check("the isolated CPUs filled", base);
+	return ret;
+}
+
+/*
+ * A deadline sleeper is pinned to the isolated CPUs. The case allows it
+ * all CPUs, then moves it into P and back, without waking it. So it stays
+ * on an isolated CPU, which its mask holds again. The root domain of the
+ * isolated CPUs must still count its bandwidth. Then wake it: it must run
+ * on an isolated CPU, and that root domain must still count it.
+ */
+static int move_isolated_asleep(void)
+{
+	long long base[3], want[3];
+	int fd[2], err, cpu, i, ret = KSFT_FAIL;
+	cpu_set_t set;
+	pid_t pid;
+
+	if (split_skip(base))
+		return KSFT_SKIP;
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = pinned_sleeper(isol, nisol, fd[0]);
+	if (pid < 0 || child_up("a sleeper pinned to the isolated CPUs", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || split_totals(want))
+		goto out;
+	CPU_ZERO(&set);
+	for (i = 0; i < CPU_SETSIZE; i++)
+		CPU_SET(i, &set);
+	err = sched_setaffinity(pid, sizeof(set), &set) ? -errno : 0;
+	if (!err)
+		err = enter(cg_p, pid);
+	if (!err)
+		err = enter(root, pid);
+	if (err) {
+		ksft_print_msg("the affinity of all CPUs, or a move: %s\n", strerror(-err));
+		goto out;
+	}
+	for (i = 0; i < 2; i++) {
+		const char *what = i ? "woken" : "moved back asleep";
+
+		cpu = task_cpu_of(pid);
+		if (!in_cpu_list(isolated, cpu)) {
+			ksft_print_msg("%s on CPU %d, not an isolated one\n", what, cpu);
+			goto out;
+		}
+		if (split_check(what, want))
+			goto out;
+		if (!i && fallback_wake(fd[1], pid))
+			goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	close(fd[0]);
+	close(fd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = split_check("task gone", base);
+	return ret;
+}
+
+/* The CPUs of move_spanning(): two root domains, an isolated CPU first */
+static cpu_set_t span_set;
+
+/*
+ * Fork a task that pins itself to the isolated CPUs, becomes a deadline
+ * task of 30ms every 100ms, then takes the CPUs of span_set. If @fd is
+ * -1, it spins and counts in mv_state[1]. Else it sleeps, each byte read
+ * from @fd wakes it up, and it counts the wakeups there. It sets
+ * mv_state[0] as mover() does. Return its pid, or -1.
+ */
+static pid_t spanning_task(int fd)
+{
+	pid_t pid = fork_child("a deadline task on two root domains");
+
+	if (!pid) {
+		cpu_set_t set;
+		char c;
+		int i;
+
+		CPU_ZERO(&set);
+		for (i = 0; i < nisol; i++)
+			CPU_SET(isol[i], &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD) ||
+		    sched_setaffinity(0, sizeof(span_set), &span_set)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		while (fd < 0)
+			mv_state[1]++;
+		while (read(fd, &c, 1) == 1)
+			mv_state[1]++;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/*
+ * A task becomes a deadline task on the isolated CPUs, where it is
+ * counted. Then it takes a wider affinity: the isolated CPUs, and the
+ * housekeeping CPUs above the first isolated one except P's. In the root
+ * cpuset, its CPUs span two root domains, and the lowest one is isolated.
+ * The case moves it into P, where it runs, and back to the root cgroup.
+ * The task must then run on a housekeeping CPU, and the housekeeping root
+ * domain must count its bandwidth. The root domain of the isolated CPUs
+ * must count it no more. Run twice: with a running task, then with a
+ * sleeper woken in P and again after the move back.
+ *
+ * The kernel counts a task that has a housekeeping CPU in the
+ * housekeeping root domain. The move reserves there, and a rebuild of the
+ * accounting makes the same choice. The lowest CPU of the task is
+ * isolated, so a move that takes the first CPU of the mask reserves in
+ * the wrong root domain.
+ */
+static int move_spanning(void)
+{
+	int fd[2] = { -1, -1 }, round, cpu, err, i, n = 0, ret = KSFT_PASS;
+	long long base[3], want[3];
+	pid_t pid;
+
+	if (split_skip(base))
+		return KSFT_SKIP;
+	CPU_ZERO(&span_set);
+	for (i = 0; i < nisol; i++)
+		CPU_SET(isol[i], &span_set);
+	for (i = 0; i < ncpus - 1; i++) {
+		if (online[i] > isol[0]) {
+			CPU_SET(online[i], &span_set);
+			n++;
+		}
+	}
+	if (!n) {
+		ksft_print_msg("needs a CPU above the first isolated one, besides P\n");
+		return KSFT_SKIP;
+	}
+	for (round = 0; round < 2 && ret == KSFT_PASS; round++) {
+		const char *what = round ? "a sleeper" : "a running task";
+
+		ret = KSFT_FAIL;
+		if (round && pipe(fd)) {
+			ksft_print_msg("pipe: %s\n", strerror(errno));
+			break;
+		}
+		mv_state[0] = 0;
+		mv_state[1] = 0;
+		pid = spanning_task(fd[0]);
+		if (pid < 0 || child_up(what, 0) || split_totals(want))
+			goto next;
+		/*
+		 * Moved back, its bandwidth goes to the housekeeping root
+		 * domain, not to the root domain of the isolated CPUs.
+		 */
+		want[1] += want[0] - base[0];
+		want[0] = base[0];
+		err = enter(cg_p, pid);
+		if (err) {
+			ksft_print_msg("%s: a move into P refused: %s\n", what, strerror(-err));
+			goto next;
+		}
+		if ((round && fallback_wake(fd[1], pid)) ||
+		    wait_for(1000, task_cpu_of(pid) == top_cpu(1))) {
+			ksft_print_msg("%s: not on P's CPU\n", what);
+			goto next;
+		}
+		err = enter(root, pid);
+		if (err) {
+			ksft_print_msg("%s: the move back refused: %s\n", what, strerror(-err));
+			goto next;
+		}
+		if (round ? fallback_wake(fd[1], pid) :
+			    wait_for(1000, task_cpu_of(pid) != top_cpu(1)))
+			goto next;
+		sleep_ns(PERIOD);
+		cpu = task_cpu_of(pid);
+		if (in_cpu_list(isolated, cpu)) {
+			ksft_print_msg("%s: moved back to isolated CPU %d\n", what, cpu);
+			goto next;
+		}
+		ret = split_check(what, want);
+next:
+		reap(pid);
+		if (round) {
+			close(fd[0]);
+			close(fd[1]);
+		}
+		sleep_ns(3 * PERIOD);
+		if (ret == KSFT_PASS)
+			ret = split_check("task gone", base);
+	}
+	return ret;
+}
+
+/*
+ * A deadline task moved asleep into another cpuset still sleeps on a CPU
+ * of the root domain it left. The root domain it moved to counts its
+ * bandwidth. sched_setaffinity() must check a new mask against the root
+ * domain that counts the task, not the one it sleeps in.
+ *
+ * H is a cpuset here, not the CPU of fallback_case(). It holds the
+ * housekeeping CPUs except P's. The steps:
+ * 1. Pin a fair task to the isolated CPUs.
+ * 2. Move it into H. Its affinity has no CPU of H, so it gets all the
+ *    CPUs of H.
+ * 3. Make it a deadline task there, and let it sleep.
+ * 4. Move it asleep into the root cgroup. Its affinity gives it the
+ *    isolated CPUs again, and their root domain counts it.
+ * 5. Set its affinity to the CPUs of H. That would take it out of the
+ *    root domain that counts it, so it must fail with EBUSY.
+ *
+ * If the change is accepted, wake the task and report where it runs.
+ */
+static int affinity_moved_asleep(void)
+{
+	char cg_h[PATH_MAX], cpus[4096], what[64];
+	int fd[2], i, n = 0, cpu, err, made = 0, ret = KSFT_SKIP;
+	long long base[3], want[3], bw;
+	cpu_set_t set;
+	pid_t pid = -1;
+
+	if (split_skip(base))
+		return KSFT_SKIP;
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	/*
+	 * H holds the housekeeping CPUs except P's. A task there can become
+	 * a deadline task: its mask holds its whole root domain.
+	 */
+	CPU_ZERO(&set);
+	for (i = 0; i < ncpus - 1 && n < (int)sizeof(cpus); i++) {
+		n += snprintf(cpus + n, sizeof(cpus) - n, "%s%d", i ? "," : "", online[i]);
+		CPU_SET(online[i], &set);
+	}
+	if (snprintf(cg_h, sizeof(cg_h), "%s/deadline_bw_h", root) >= (int)sizeof(cg_h))
+		goto out;
+	if (mkdir(cg_h, 0755) && errno != EEXIST) {
+		ksft_print_msg("mkdir %s: %s\n", cg_h, strerror(errno));
+		goto out;
+	}
+	made = 1;
+	if (n >= (int)sizeof(cpus) || write_file(cg_h, "cpuset.cpus", cpus)) {
+		ksft_print_msg("cpuset H cannot be made\n");
+		goto out;
+	}
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a task moved asleep");
+	if (!pid) {
+		cpu_set_t iso;
+		char c;
+
+		CPU_ZERO(&iso);
+		for (i = 0; i < nisol; i++)
+			CPU_SET(isol[i], &iso);
+		if (sched_setaffinity(0, sizeof(iso), &iso)) {
+			mv_state[1] = -1;
+			_exit(1);
+		}
+		mv_state[1] = 1;
+		/* Wait for the move into H. Become a deadline task there. */
+		if (read(fd[0], &c, 1) != 1 || set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		spin_ns(NSEC_PER_MSEC);
+		mv_state[0] = 1;
+		while (read(fd[0], &c, 1) == 1)
+			mv_state[1]++;
+		for (;;)
+			pause();
+	}
+	if (pid < 0)
+		goto out;
+	if (wait_for(1000, mv_state[1]) || mv_state[1] != 1) {
+		ksft_print_msg("the task cannot take the isolated CPUs\n");
+		goto out;
+	}
+	err = enter(cg_h, pid);
+	if (err) {
+		ksft_print_msg("a move into H refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (write(fd[1], "d", 1) != 1) {
+		ksft_print_msg("write to the task: %s\n", strerror(errno));
+		goto out;
+	}
+	if (child_up("a task moved into H", 0) || wait_for(1000, proc_state_of(pid) == 'S'))
+		goto out;
+	bw = (30 * NSEC_PER_MSEC << 20) / PERIOD;	/* as to_ratio() */
+	memcpy(want, base, sizeof(want));
+	want[1] += bw;
+	if (split_check("a deadline task in H", want))
+		goto out;
+
+	/*
+	 * Moved asleep, it stays on its CPU. The root domain of the
+	 * isolated CPUs counts it.
+	 */
+	err = enter(root, pid);
+	if (err) {
+		ksft_print_msg("the move into the root cgroup refused: %s\n", strerror(-err));
+		goto out;
+	}
+	cpu = task_cpu_of(pid);
+	if (in_cpu_list(isolated, cpu)) {
+		ksft_print_msg("moved asleep on CPU %d, an isolated one\n", cpu);
+		goto out;
+	}
+	want[0] += bw;
+	want[1] -= bw;
+	if (split_check("moved asleep", want))
+		goto out;
+
+	/* The CPUs of H leave out the root domain that counts the task. */
+	err = sched_setaffinity(pid, sizeof(set), &set) ? -errno : 0;
+	if (err == -EBUSY) {
+		ret = KSFT_PASS;
+		goto out;
+	}
+	ksft_print_msg("the affinity of the CPUs of H: %s, not EBUSY\n",
+		       err ? strerror(-err) : "accepted");
+	if (err || fallback_wake(fd[1], pid))
+		goto out;
+	/* Report its CPU, and whether the root domain of that CPU counts it. */
+	cpu = task_cpu_of(pid);
+	memcpy(want, base, sizeof(want));
+	want[in_cpu_list(isolated, cpu) ? 0 : 1] += bw;
+	snprintf(what, sizeof(what), "woken on CPU %d", cpu);
+	if (split_check(what, want) == KSFT_PASS)
+		ksft_print_msg("%s: its root domain counts it\n", what);
+out:
+	reap(pid);
+	close(fd[0]);
+	close(fd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = split_check("task gone", base);
+	if (made && wait_for(1000, !rmdir(cg_h) || errno == ENOENT))
+		ksft_print_msg("rmdir %s: %s\n", cg_h, strerror(errno));
+	return ret;
+}
+
 /* Setup */
 
 static int find_cgroup2(void)
@@ -5413,9 +7894,28 @@ static const struct p_case {
 	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
 	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
 	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
+	{ "move_asleep", move_asleep, FROM_OUTSIDE },
+	{ "move_throttled", move_throttled, FROM_OUTSIDE },
+	{ "move_non_contending", move_non_contending, FROM_OUTSIDE },
 	{ "move_refused", move_refused, FROM_OUTSIDE },
 	{ "move_zero_bw", move_zero_bw, FROM_OUTSIDE },
+	{ "move_asleep_setattr", move_asleep_setattr, FROM_OUTSIDE },
+	{ "move_asleep_fair_setattr", move_asleep_fair_setattr, FROM_OUTSIDE },
+	{ "move_vs_rebuild", move_vs_rebuild, FROM_OUTSIDE },
+	{ "move_became_deadline", move_became_deadline, FROM_OUTSIDE },
+	{ "move_became_deadline_no_room", move_became_deadline_no_room, FROM_OUTSIDE },
+	{ "move_affinity_changed", move_affinity_changed, FROM_OUTSIDE },
+	{ "move_affinity_became_deadline", move_affinity_became_deadline, FROM_OUTSIDE },
+	{ "move_died", move_died, FROM_OUTSIDE },
+	{ "move_woken", move_woken, FROM_OUTSIDE },
+	{ "move_woken_full", move_woken_full, FROM_OUTSIDE },
 	{ "move_cancelled", move_cancelled, FROM_OUTSIDE },
+	{ "frozen_moved_switched", frozen_moved_switched, FROM_OUTSIDE },
+	{ "move_isolated", move_isolated, FROM_OUTSIDE },
+	{ "move_isolated_refused", move_isolated_refused, FROM_OUTSIDE },
+	{ "move_isolated_asleep", move_isolated_asleep, FROM_OUTSIDE },
+	{ "move_spanning", move_spanning, FROM_OUTSIDE },
+	{ "affinity_moved_asleep", affinity_moved_asleep, FROM_OUTSIDE },
 	{ "death_running", death_running, MEASURED_IN_P },
 	{ "death_switched_out", death_switched_out, MEASURED_IN_P },
 	{ "death_shrunk", death_shrunk, MEASURED_IN_P },
@@ -5431,16 +7931,20 @@ static const struct p_case {
 	{ "death_zombie_switched", death_zombie_switched, FROM_OUTSIDE },
 	{ "death_zombie_hotplug", death_zombie_hotplug, FROM_OUTSIDE },
 	{ "yield_switched_out", yield_switched_out, IN_P },
+	{ "yield_moved", yield_moved, FROM_OUTSIDE },
 	{ "yield_killed", yield_killed, MEASURED_IN_P },
 	{ "overrun_caught", overrun_caught, IN_P },
 	{ "overrun_group_death", overrun_group_death, MEASURED_IN_P },
 	{ "reclaim_runs", reclaim_runs, MEASURED_IN_P },
 	{ "reclaim_switched", reclaim_switched, MEASURED_IN_P },
+	{ "reclaim_moved", reclaim_moved, FROM_OUTSIDE },
 	{ "server_params", server_params, IN_P },
 	{ "server_rebuilds", server_rebuilds, FROM_OUTSIDE },
 	{ "server_states", server_states, FROM_OUTSIDE },
 	{ "server_reclaim", server_reclaim, MEASURED_IN_P },
 	{ "params_waking", params_waking, FROM_OUTSIDE },
+	{ "random_mix", random_mix, FROM_OUTSIDE },
+	{ "move_normalized", move_normalized, FROM_OUTSIDE },
 };
 
 #define N_P_CASES	((int)ARRAY_SIZE(p_cases))
@@ -5457,6 +7961,7 @@ static const struct hp_case {
 	{ "hotplug_departed", hotplug_departed },
 	{ "hotplug_server", hotplug_server },
 	{ "affinity_vs_setattr", affinity_vs_setattr, 1 },
+	{ "move_back_cpu_offline", move_back_cpu_offline },
 };
 
 #define N_HP_CASES	((int)ARRAY_SIZE(hp_cases))
@@ -5560,7 +8065,8 @@ int main(void)
 	if (read_file("/sys/devices/system/cpu/isolated", isolated, sizeof(isolated)))
 		isolated[0] = 0;
 	ncpus = read_online(&online, 0);
-	if (ncpus < 0)
+	nisol = read_online(&isol, 1);
+	if (ncpus < 0 || nisol < 0)
 		ksft_exit_fail_msg("the online CPUs cannot be read\n");
 	if (ncpus < 3)
 		ksft_exit_skip("needs 3 CPUs not isolated by isolcpus=domain\n");
-- 
2.47.3

