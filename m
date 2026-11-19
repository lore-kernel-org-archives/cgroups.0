Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119386;
	b=ZbrAnqa2IcUD1LZdZhiX6WG8ZhYBMnxxBmb6efz6yQLnPPvTPG/GxtVP31YacOWnVJp1
	 LzgQMtOUz3o682Jd6VNt6q4U5KfV24Z2YqCSiYarpbi/F8FSikvDjjQjXSxHDit+Af5u5
	 YV+jiukAraGtUUJH0U5tKmo/puK/cT90YEWjRyC+T7M9K37oeDMSrCAXMzTDMLDjvdhcJ
	 7YF+5koIK2YXvEuCz0ntfIorNDZ+daNSW8SU2YVJNCMWPL2h0vCJ98ji9vqc4sQLivGXM
	 hbMzw6SkGxTaAhCMjpjvPEmgpS3316H7WFXLFIzBMh9om3PYmaAaM3N8xlUvZ0hK+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119386;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zdp6sqR7deXNuVcXmAI75BuqzTUQDAEmKAZwqOOtlcA=;
	b=hGOTbG6q5ZGh3SegpFCDx6ITNOU50TCeNoH4kmIestMur788RO9mXls6t/UtfgRwW1F4
	 Uoy3PZR9SSBByt6g83oOLHg/IAjaDEEtupRsVcYXpUoUFtcqZ8tCL7NWrsOdcHmQeRoRT
	 Ma5YhuFvjp4isKiexhERPrNFlruk0ebEz4Wq6/vyjrO7AOMb3OKgzxRrjunQOkWICsiSN
	 aEIc+hzrCdi+QgUQuGXVTfIGJqc5qS2ibFiMpW0ZPWV4qbVlE+oP6OO6pmMjO4yaT4p1/
	 2XwVLZ/r+50pVojm62PLAi04d72X2Ry0s6Tr/i1QTCYuyHAg9zAH/snRLnVEdedgYqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=L+nezfUB;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AC7606A325;
	Thu, 19 Nov 2026 20:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41AC7606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=L+nezfUB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119378;
	bh=zdp6sqR7deXNuVcXmAI75BuqzTUQDAEmKAZwqOOtlcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+nezfUBsIq8H6gXZQGsQwLekVoIHZoLmq9gqLe8V+gOs3hAFjO1ORf7Qe3dWZsea
	 uldselZL0/Rcrxbs9uAaXvY9YkcZF5dNuiB+JufeFrIKl5bk6JGXaZMChMW6m0YgHH
	 e9PJrpWw3VxTn9F96a3Z9oha2S3YD9kVx0WZiCfdLo5ziMqEpjTZewb+7Q/0Bm3jTK
	 rSoD9GbRG2ncavUuUWkN6CPo9oGmchx35ukIihdfOy6taO94bFzwfCCUimJ+BsTvXh
	 kC9OLVrTGArFuZKq511P8T/6ipW5ApKENyWB4qPAsnnIDlCu0sc2g4JInRU4OLxNhM
	 bGHzTifWMEAFw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVV4T6SzTsG;
	Thu, 19 Nov 2026 15:16:18 -0500 (EST)
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
Subject: [PATCH v8 06/33] selftests/sched: Test the root domain rebuild in deadline_bw_test
Date: Thu, 19 Nov 2026 15:15:45 -0500
Message-Id: <b2ec4354da3021a9c16b4a14121e555eba9a88f2.1795116790.git.mathieu.desnoyers@efficios.com>
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

Add seven cases to deadline_bw_test. Most test the rebuild of the root
domains' accounting, earlier in this series. They cover:
- CPU hotplug with sleeping deadline tasks, and with tasks that left the
  class before their 0-lag time
- a zombie deadline task during a CPU hotplug (death_zombie_hotplug)
- a priority inheritance owner that left the class, then moves
  (pi_departed_moved)
- sched_setaffinity() racing with sched_setattr() (affinity_vs_setattr)

The comment above each case gives its scenario. Two cases follow
reproducers of Juri Lelli's sched-deadline-tests:
hotplug_sleeper_switched and hotplug_no_admission_pinned.

The message of each fix names the cases that test it. These cases are
not named there:
- hotplug_departed and hotplug_no_admission_pinned: "sched/deadline: Keep
  departing bandwidth across a root domain rebuild"
- affinity_vs_setattr tests "sched/deadline: Check SCHED_DEADLINE
  affinity under the rq lock", of the first series. It comes here
  because it fails without CONFIG_CPUSETS before these fixes.

On v7.4-rc2, in 8 VMs of 8 CPUs, six of these cases fail in every VM:
- affinity_vs_setattr
- death_zombie_hotplug
- hotplug_departed
- hotplug_no_admission_pinned
- hotplug_sleeper_switched
- pi_departed_moved

hotplug_sleepers passes there. It fails on v7.4-rc2 and with the first
series without CONFIG_CPUSETS. It also fails there when
isolcpus=domain,0,1 isolates the boot CPU. The rebuild fixes make it
pass.

With the fixes up to here, every case passes wherever it runs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://github.com/jlelli/sched-deadline-tests
---
 .../sched/deadline/deadline_bw_test.c         | 654 +++++++++++++++++-
 1 file changed, 650 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index 6ff9da964403..ba2a18f354d4 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -31,8 +31,11 @@
  * housekeeping CPU. P is made anew for each case. Making it rebuilds the
  * accounting, which clears what an earlier case left.
  *
- * The cases of hp_cases[] run after them, without P. They take CPUs
- * offline. The test skips them if no CPU can go offline.
+ * The cases of hp_cases[] run after them, without P. These are the
+ * hotplug cases, and affinity_vs_setattr. The test skips the hotplug
+ * cases if no CPU can go offline. It still runs affinity_vs_setattr.
+ * death_zombie_hotplug takes CPUs offline too, but it is in p_cases[]: it
+ * needs the cpuset setup of those cases.
  *
  * The server cases change the fair server of a CPU through debugfs, and
  * the test then puts it back.
@@ -4554,7 +4557,10 @@ static int params_waking(void)
 	return ret;
 }
 
-/* CPU hotplug, from the main process, with no P */
+/*
+ * CPU hotplug, from the main process, with no P. Two cases below run with
+ * P instead: death_zombie_hotplug and pi_departed_moved.
+ */
 
 static int hp_cpu = -1;
 
@@ -4584,6 +4590,213 @@ static void cpu_up(int cpu)
 		ksft_print_msg("CPU %d cannot come back online: %s\n", cpu, strerror(-err));
 }
 
+/*
+ * Four deadline tasks of 30% sleep. Take hp_cpu offline and back. Once
+ * the sleepers are gone, the housekeeping root domain must admit what it
+ * did before. Skip unless 22 probe tasks fit: the sleepers take the room
+ * of 12, and the offline CPU that of about 10.
+ */
+static int hotplug_sleepers(void)
+{
+	int base = probe(NULL), after, i, ret = KSFT_PASS;
+	pid_t pid[4];
+
+	if (base < 22) {
+		ksft_print_msg("needs room for 22 probe tasks\n");
+		return KSFT_SKIP;
+	}
+	for (i = 0; i < 4; i++) {
+		mv_state[0] = 0;
+		pid[i] = mover(MV_ASLEEP, 30 * NSEC_PER_MSEC);
+		if (pid[i] < 0 || child_up("a deadline sleeper", 0)) {
+			while (i >= 0)
+				reap(pid[i--]);
+			return KSFT_FAIL;
+		}
+	}
+	if (cpu_online(hp_cpu, 0) || cpu_online(hp_cpu, 1)) {
+		ksft_print_msg("offline and online of CPU %d with deadline sleepers failed\n",
+			       hp_cpu);
+		ret = KSFT_FAIL;
+		cpu_up(hp_cpu);
+	}
+	for (i = 0; i < 4; i++)
+		reap(pid[i]);
+	sleep_ns(3 * PERIOD);
+	after = probe(NULL);
+	if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("hotplug with sleepers: %d probe tasks admitted before, %d after\n",
+			       base, after);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * Fork a task that runs on @cpu, then restores its affinity, becomes a
+ * deadline task of 30% and sleeps. A deadline task cannot have an
+ * affinity of one CPU, so the task goes to @cpu first. It sets
+ * mv_state[0] as mover() does. Return its pid, or -1.
+ */
+static pid_t sleeper_on(int cpu)
+{
+	pid_t pid = fork_child("a deadline sleeper");
+
+	if (!pid) {
+		cpu_set_t all, one;
+
+		CPU_ZERO(&one);
+		CPU_SET(cpu, &one);
+		if (sched_getaffinity(0, sizeof(all), &all) ||
+		    sched_setaffinity(0, sizeof(one), &one))
+			_exit(1);
+		spin_ns(NSEC_PER_MSEC);
+		if (sched_setaffinity(0, sizeof(all), &all) ||
+		    set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/*
+ * A deadline task of 30% sleeps on hp_cpu. Take hp_cpu offline, then
+ * switch the task to SCHED_OTHER. hp_cpu has left the housekeeping root
+ * domain by then, but that root domain still counts the task. The switch
+ * must release the bandwidth there.
+ *
+ * Check this with hp_cpu still offline: bringing it back rebuilds the
+ * accounting, which would hide a bandwidth left behind. The reference is
+ * what the housekeeping root domain admits with hp_cpu offline and no
+ * task. Once the CPU is back and the task is gone, that root domain must
+ * also admit what it did at first.
+ */
+static int hotplug_sleeper_switched(void)
+{
+	int base = probe(NULL), base_off, after, cpu, ret = KSFT_PASS;
+	pid_t pid;
+
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("CPU %d cannot go offline\n", hp_cpu);
+		cpu_up(hp_cpu);
+		return KSFT_SKIP;
+	}
+	base_off = probe(NULL);
+	cpu_up(hp_cpu);
+	mv_state[0] = 0;
+	pid = sleeper_on(hp_cpu);
+	if (pid < 0 || child_up("a deadline sleeper", 0)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	sleep_ns(PERIOD);
+	cpu = task_cpu_of(pid);
+	if (cpu != hp_cpu) {
+		ksft_print_msg("the sleeper is on CPU %d, not on CPU %d\n", cpu, hp_cpu);
+		reap(pid);
+		return KSFT_SKIP;
+	}
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("CPU %d cannot go offline under a deadline sleeper\n", hp_cpu);
+		ret = KSFT_FAIL;
+	} else if (set_other(pid)) {
+		ksft_print_msg("the sleeper cannot leave SCHED_DEADLINE\n");
+		ret = KSFT_FAIL;
+	} else {
+		sleep_ns(3 * PERIOD);
+		after = probe(NULL);
+		if (after != base_off) {
+			ksft_print_msg("a sleeper switched out, its CPU still offline: %d probe tasks admitted, %d expected\n",
+				       after, base_off);
+			ret = KSFT_FAIL;
+		}
+	}
+	cpu_up(hp_cpu);
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	after = probe(NULL);
+	if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("a sleeper switched out on an offline CPU: %d probe tasks admitted before, %d after\n",
+			       base, after);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * Turn admission control off (sched_rt_runtime_us = -1). A task pins
+ * itself to hp_cpu, becomes a deadline task of 50% and spins. Without
+ * admission control, a deadline task can have an affinity of one CPU.
+ * Take hp_cpu offline: the mask of the task holds no active CPU. The
+ * task must go on running on another CPU. Once the CPU is back, the task
+ * is gone and admission control is on again, the housekeeping root domain
+ * must admit what it did before.
+ */
+static int hotplug_no_admission_pinned(void)
+{
+	int base = probe(NULL), after, ret = KSFT_PASS, last;
+	char saved[64];
+	pid_t pid;
+
+	if (read_file("/proc/sys/kernel/sched_rt_runtime_us", saved, sizeof(saved)) ||
+	    write_file("/proc/sys/kernel", "sched_rt_runtime_us", "-1")) {
+		ksft_print_msg("admission control cannot be turned off\n");
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a pinned deadline task");
+	if (!pid) {
+		cpu_set_t one;
+
+		CPU_ZERO(&one);
+		CPU_SET(hp_cpu, &one);
+		if (sched_setaffinity(0, sizeof(one), &one) ||
+		    set_deadline(0, 50 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		for (;;)
+			mv_state[1]++;
+	}
+	if (pid < 0 || child_up("a pinned deadline task", 0)) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	sleep_ns(PERIOD);
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("CPU %d cannot go offline under a pinned deadline task\n", hp_cpu);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	last = mv_state[1];
+	sleep_ns(3 * PERIOD);
+	if (mv_state[1] == last) {
+		ksft_print_msg("the pinned task does not run after its CPU went offline\n");
+		ret = KSFT_FAIL;
+	}
+out:
+	cpu_up(hp_cpu);
+	reap(pid);
+	if (write_file("/proc/sys/kernel", "sched_rt_runtime_us", saved)) {
+		ksft_print_msg("admission control cannot be turned on again\n");
+		return KSFT_FAIL;
+	}
+	sleep_ns(3 * PERIOD);
+	after = probe(NULL);
+	if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("a pinned task without admission control: %d probe tasks admitted before, %d after\n",
+			       base, after);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /*
  * Deadline sleepers take most of the free bandwidth. Taking hp_cpu
  * offline must then fail with EBUSY. Once the sleepers are gone, the
@@ -4638,6 +4851,303 @@ static int hotplug_refused(void)
 	return ret;
 }
 
+/*
+ * A deadline task of 40% spins. The case switches it to SCHED_OTHER
+ * before its 0-lag time. Then it takes the CPU that the task is on
+ * offline, before that time too. Past the 0-lag time, with the CPU still
+ * offline, the housekeeping root domain must admit what it admits with a
+ * CPU offline and no task. Once the CPU is back and the task is gone, it
+ * must admit what it did at the start.
+ */
+static int hotplug_departed(void)
+{
+	int base = probe(NULL), base_off, after, cpu, ret = KSFT_PASS;
+	pid_t pid;
+
+	/*
+	 * Take the reference with hp_cpu offline and no task of ours. The
+	 * task may be on another CPU: the case assumes that any one CPU
+	 * offline leaves the same room. The case compares while that CPU
+	 * is still offline. Bringing it back rebuilds the accounting,
+	 * which would hide an error.
+	 */
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("offline of CPU %d refused\n", hp_cpu);
+		return KSFT_FAIL;
+	}
+	base_off = probe(NULL);
+	cpu_up(hp_cpu);
+	if (base <= 0 || base_off <= 0) {
+		ksft_print_msg("no room to probe with the CPU online or offline\n");
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = mover(MV_THROTTLED, 40 * NSEC_PER_MSEC);
+	if (pid < 0 || child_up("a departing deadline task", 0)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	sleep_ns(PERIOD / 2);
+	/* Not asleep: its bandwidth stays until its 0-lag time. */
+	if (set_other(pid))
+		ret = KSFT_FAIL;
+	cpu = task_cpu_of(pid);
+	if (cpu < 0 || !cpu_hotpluggable(cpu)) {
+		cpu_set_t set;
+
+		/* Out of the class now, it may be pinned to hp_cpu. */
+		cpu = hp_cpu;
+		CPU_ZERO(&set);
+		CPU_SET(cpu, &set);
+		if (sched_setaffinity(pid, sizeof(set), &set))
+			ret = KSFT_FAIL;
+	}
+	if (ret == KSFT_PASS && cpu_online(cpu, 0)) {
+		ksft_print_msg("offline of CPU %d refused\n", cpu);
+		ret = KSFT_FAIL;
+	}
+	sleep_ns(3 * PERIOD);		/* its 0-lag time, the CPU offline */
+	if (ret == KSFT_PASS) {
+		after = probe(NULL);
+		if (after != base_off) {
+			ksft_print_msg("departed, CPU %d offline: %d admitted, %d expected\n",
+				       cpu, after, base_off);
+			ret = KSFT_FAIL;
+		}
+	}
+	cpu_up(cpu);
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	after = probe(NULL);
+	if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("departed, CPU back online: %d admitted before, %d after\n",
+			       base, after);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+#define ZOMBIE_RUNTIME	(200 * NSEC_PER_MSEC)
+#define ZOMBIE_PERIOD	(2 * NSEC_PER_SEC)
+
+/*
+ * Q is a partition root of two CPUs. The kernel records, with the
+ * bandwidth of a task, a CPU of the root domain that counts it. The steps:
+ * 1. A task enters Q and becomes a deadline task of 200ms every 2s.
+ * 2. It runs 190ms and exits, its 0-lag time about 1.7s ahead. The case
+ *    does not reap it yet. A rebuild of the accounting still finds a
+ *    zombie in the task list.
+ * 3. total_bw of Q must count the zombie.
+ * 4. The case takes each CPU of Q offline and back, one after the other.
+ *    One of them is the CPU recorded with the bandwidth of the zombie.
+ *    The rebuild at its offline drops that bandwidth.
+ * 5. Before the 0-lag time, total_bw of Q must be what it was without
+ *    the task. No later rebuild may count the zombie again: the release
+ *    at the 0-lag time removes nothing by then.
+ * 6. The case reaps the zombie. Past the 0-lag time, total_bw of Q must
+ *    still be that value.
+ *
+ * The case runs with the cases in P, from the main process: Q needs the
+ * cpuset controller. Q has two CPUs because the last CPU of a root domain
+ * that holds deadline bandwidth cannot go offline.
+ */
+static int death_zombie_hotplug(void)
+{
+	int cpu[2] = { top_cpu(3), top_cpu(2) }, i, ret = KSFT_PASS;
+	long long base, bw, held, after;
+	char cpus[32];
+	uint64_t t;
+	pid_t pid;
+
+	if (ncpus < 4 || !cpu_hotpluggable(cpu[0]) || !cpu_hotpluggable(cpu[1])) {
+		ksft_print_msg("needs 4 non-isolated CPUs, 2 hotpluggable beside P\n");
+		return KSFT_SKIP;
+	}
+	snprintf(cpus, sizeof(cpus), "%d,%d", cpu[0], cpu[1]);
+	if (make_partition_cpus(cg_q, cpus)) {
+		ksft_print_msg("no partition root Q of CPUs %s\n", cpus);
+		remove_partition(cg_q);
+		return KSFT_SKIP;
+	}
+	base = total_bw_of(cpu[0]);
+	if (base < 0) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		remove_partition(cg_q);
+		return KSFT_SKIP;
+	}
+	bw = (ZOMBIE_RUNTIME << 20) / ZOMBIE_PERIOD;	/* as to_ratio() */
+	mv_state[0] = 0;
+	pid = fork_child("a deadline task that exits");
+	if (!pid) {
+		if (enter(cg_q, getpid()) || set_deadline(0, ZOMBIE_RUNTIME, ZOMBIE_PERIOD))
+			_exit(1);
+		/* 10ms left: the 0-lag time is 100ms before the deadline. */
+		spin_ns(ZOMBIE_RUNTIME - 10 * NSEC_PER_MSEC);
+		mv_state[0] = 1;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("a task of Q that exits", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'Z')) {
+		ksft_print_msg("no zombie deadline task\n");
+		reap(pid);
+		remove_partition(cg_q);
+		return KSFT_FAIL;
+	}
+	/* Its 0-lag time is about 1.7s ahead. Check total_bw within 1s. */
+	t = now_ns();
+	held = total_bw_of(cpu[0]);
+	if (held != base + bw) {
+		ksft_print_msg("total_bw of Q: %lld with the zombie, %lld expected\n",
+			       held, base + bw);
+		ret = KSFT_FAIL;
+	}
+	for (i = 0; i < 2 && ret == KSFT_PASS; i++) {
+		if (cpu_online(cpu[i], 0) || cpu_online(cpu[i], 1)) {
+			ksft_print_msg("offline and online of CPU %d failed\n", cpu[i]);
+			cpu_up(cpu[i]);
+			ret = KSFT_FAIL;
+		}
+	}
+	after = total_bw_of(cpu[0]);
+	if (ret == KSFT_PASS && now_ns() - t > NSEC_PER_SEC) {
+		ksft_print_msg("the hotplugs took over 1s: the 0-lag time may be past\n");
+		ret = KSFT_SKIP;
+	} else if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("total_bw of Q after the hotplugs: %lld, %lld expected%s\n",
+			       after, base,
+			       after == base + bw ? ": the zombie counted again" : "");
+		ret = KSFT_FAIL;
+	}
+	reap(pid);
+	sleep_ns(ZOMBIE_PERIOD);		/* past its 0-lag time */
+	after = total_bw_of(cpu[0]);
+	if (ret == KSFT_PASS && after != base) {
+		ksft_print_msg("total_bw of Q past the 0-lag time: %lld, %lld expected\n",
+			       after, base);
+		ret = KSFT_FAIL;
+	}
+	remove_partition(cg_q);
+	return ret;
+}
+
+/*
+ * Fork the owner of pi_departed_moved(). It takes shm_lock, becomes a
+ * deadline task and runs most of its runtime. It sets mv_state[0] to 1
+ * and sleeps 300ms. Then it sets mv_state[1] to 1 and sleeps with the
+ * lock. Return its pid, or -1.
+ */
+static pid_t departed_owner(void)
+{
+	pid_t pid = fork_child("the owner of the lock");
+
+	if (!pid) {
+		if (pthread_mutex_lock(shm_lock) ||
+		    set_deadline(0, ZOMBIE_RUNTIME, ZOMBIE_PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		/* 20ms left: the 0-lag time is 200ms before the deadline. */
+		spin_ns(ZOMBIE_RUNTIME - 20 * NSEC_PER_MSEC);
+		mv_state[0] = 1;
+		sleep_ns(300 * NSEC_PER_MSEC);
+		mv_state[1] = 1;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/*
+ * The owner is a deadline task of 200ms every 2s, outside P. It holds
+ * shm_lock, runs 180ms and sleeps, its 0-lag time about 1.6s ahead. The
+ * steps:
+ * 1. The case switches the sleeping owner to SCHED_OTHER. The
+ *    housekeeping root domain keeps its bandwidth until the 0-lag time.
+ * 2. The case moves the owner into P. The owner wakes up and runs there.
+ * 3. A deadline waiter of 5ms every 50ms, outside P, blocks on shm_lock
+ *    and boosts the owner.
+ * 4. The case kills the waiter, which ends the boost.
+ *
+ * After step 4, total_bw of the housekeeping root domain must still count
+ * the bandwidth of the owner. total_bw of P never counted it and must be
+ * unchanged: the end of the boost must not subtract it there. Past the
+ * 0-lag time, both must be what they were at the start.
+ */
+static int pi_departed_moved(void)
+{
+	int p_cpu = top_cpu(1), r_cpu = online[0], ret = KSFT_PASS;
+	long long base_p, base_r, bw, in_p, in_r;
+	pid_t owner, waiter = -1;
+
+	base_p = total_bw_of(p_cpu);
+	base_r = total_bw_of(r_cpu);
+	if (base_p < 0 || base_r < 0) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		return KSFT_SKIP;
+	}
+	if (shm_lock_init())
+		return KSFT_SKIP;
+	bw = (ZOMBIE_RUNTIME << 20) / ZOMBIE_PERIOD;	/* as to_ratio() */
+	mv_state[1] = 0;
+	owner = departed_owner();
+	if (owner < 0)
+		return KSFT_FAIL;
+	if (child_up("the owner of the lock", 0)) {
+		reap(owner);
+		return KSFT_FAIL;
+	}
+	/* The owner is asleep, about 1.6s before its 0-lag time. */
+	sleep_ns(20 * NSEC_PER_MSEC);
+	if (set_other(owner) || enter(cg_p, owner)) {
+		ksft_print_msg("the owner cannot leave the class and enter P\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_state(&mv_state[1], 1) || task_cpu_of(owner) != p_cpu) {
+		ksft_print_msg("the owner did not run in P\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	waiter = lock_waiter();
+	if (waiter < 0) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_state(&mv_state[2], 1)) {
+		ksft_print_msg("no waiter\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	sleep_ns(50 * NSEC_PER_MSEC);	/* blocked, boosting the owner */
+	reap(waiter);
+	waiter = -1;
+	sleep_ns(150 * NSEC_PER_MSEC);	/* the waiter is past its 0-lag time */
+	in_p = total_bw_of(p_cpu);
+	in_r = total_bw_of(r_cpu);
+	if (in_p != base_p || in_r != base_r + bw) {
+		ksft_print_msg("after the boost: total_bw of P %lld, %lld expected\n",
+			       in_p, base_p);
+		ksft_print_msg("after the boost: total_bw outside %lld, %lld expected\n",
+			       in_r, base_r + bw);
+		ret = KSFT_FAIL;
+	}
+out:
+	reap(waiter);
+	reap(owner);
+	sleep_ns(ZOMBIE_PERIOD);	/* past the owner's 0-lag time */
+	in_p = total_bw_of(p_cpu);
+	in_r = total_bw_of(r_cpu);
+	if (ret == KSFT_PASS && (in_p != base_p || in_r != base_r)) {
+		ksft_print_msg("past the 0-lag time: total_bw of P %lld, %lld expected\n",
+			       in_p, base_p);
+		ksft_print_msg("past the 0-lag time: total_bw outside %lld, %lld expected\n",
+			       in_r, base_r);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /*
  * The bandwidth of a fair server must leave the root domain with its CPU
  * and come back with it, whatever its size. Probe the housekeeping root
@@ -4743,6 +5253,134 @@ static void report(const char *name, int ret)
 		ksft_test_result_fail("%s\n", name);
 }
 
+/* sched_setaffinity() against sched_setattr(), with no P */
+
+/*
+ * The state that affinity_racer() shares with the case. pid and one are
+ * its target and its mask. go and done count the rounds. ret is the
+ * result of its last call.
+ */
+static struct {
+	pid_t pid;
+	cpu_set_t one;
+	atomic_int go;
+	atomic_int done;
+	atomic_int stop;
+	int ret;
+} aff;
+
+/*
+ * Give aff.pid the affinity aff.one, once for each new value of aff.go.
+ * Return when aff.stop is set.
+ */
+static void *affinity_racer(void *arg)
+{
+	int round;
+
+	for (round = 1; ; round++) {
+		while (aff.go < round && !aff.stop)
+			;
+		if (aff.stop)
+			break;
+		aff.ret = sched_setaffinity(aff.pid, sizeof(aff.one), &aff.one) ? -errno : 0;
+		aff.done = round;
+	}
+	return arg;
+}
+
+/*
+ * Race sched_setaffinity() against sched_setattr() on a sleeping task.
+ * One thread gives the task an affinity of one CPU. Another one makes it
+ * a deadline task. A deadline task must be allowed on its whole root
+ * domain, so at most one of the two calls may succeed:
+ * - sched_setattr() fails with EPERM if the affinity came first;
+ * - sched_setaffinity() fails with EBUSY if the policy came first.
+ *
+ * Do it 1000 times. Each round starts with the task back in SCHED_OTHER
+ * with its full affinity. Once the task is gone, the free bandwidth must
+ * be what it was. The case needs no cpuset: it runs without P, with the
+ * hotplug cases.
+ */
+static int affinity_vs_setattr(void)
+{
+	const char *name = "affinity_vs_setattr";
+	int base, i, cpu, both = 0, ret = KSFT_PASS;
+	cpu_set_t all;
+	pthread_t t;
+	pid_t pid;
+
+	base = probe(NULL);
+	pid = fork_child(name);
+	if (!pid) {
+		for (;;)
+			pause();
+	}
+	if (pid < 0)
+		return KSFT_FAIL;
+	/*
+	 * Wait until the task sleeps in pause(). A task that still runs
+	 * when it becomes a deadline task can overrun its 2us. Its
+	 * bandwidth then stays counted until its 0-lag time, seconds after
+	 * it is gone, and the next cases would see it.
+	 */
+	if (wait_for(1000, proc_state_of(pid) == 'S') ||
+	    sched_getaffinity(pid, sizeof(all), &all)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	CPU_ZERO(&aff.one);
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		if (CPU_ISSET(cpu, &all)) {
+			CPU_SET(cpu, &aff.one);
+			break;
+		}
+	}
+	aff.pid = pid;
+	aff.go = 0;
+	aff.done = 0;
+	aff.stop = 0;
+	if (pthread_create(&t, NULL, affinity_racer, NULL)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+
+	for (i = 1; i <= 1000 && ret == KSFT_PASS; i++) {
+		int err;
+
+		if (set_other(pid) || sched_setaffinity(pid, sizeof(all), &all)) {
+			ksft_print_msg("%s: the task cannot be reset: %s\n", name, strerror(errno));
+			ret = KSFT_FAIL;
+			break;
+		}
+		aff.go = i;
+		err = set_deadline(pid, 2 * NSEC_PER_USEC, PERIOD);
+		while (aff.done < i)
+			;
+		if (!err && !aff.ret) {
+			both++;
+		} else if ((err && err != -EPERM) || (aff.ret && aff.ret != -EBUSY)) {
+			ksft_print_msg("%s: round %d: sched_setattr: %s, sched_setaffinity: %s\n",
+				       name, i, strerror(-err), strerror(-aff.ret));
+			ret = KSFT_FAIL;
+		}
+	}
+	aff.stop = 1;
+	join(t);
+	if (both) {
+		ksft_print_msg("%s: %d rounds of %d: a deadline task with an affinity of one CPU\n",
+			       name, both, i - 1);
+		ret = KSFT_FAIL;
+	}
+	/* A deadline task of 2us every 100ms would take seconds to exit. */
+	if (set_other(pid))
+		ksft_print_msg("%s: the task stays a deadline task\n", name);
+	reap(pid);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && admits(base, "after the task is gone"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
 /* The tables of the cases, and main() */
 
 enum where {
@@ -4760,6 +5398,7 @@ static const struct p_case {
 	{ "pi_other_owner_asleep", pi_other_owner_asleep, MEASURED_IN_P },
 	{ "pi_unlock_running", pi_unlock_running, MEASURED_IN_P },
 	{ "pi_chain_two_owners", pi_chain_two_owners, MEASURED_IN_P },
+	{ "pi_departed_moved", pi_departed_moved, FROM_OUTSIDE },
 	{ "params_asleep", params_asleep, IN_P },
 	{ "params_non_contending", params_non_contending, MEASURED_IN_P },
 	{ "params_switched_asleep", params_switched_asleep, MEASURED_IN_P },
@@ -4790,6 +5429,7 @@ static const struct p_case {
 	{ "death_pi_deadline_owner", death_pi_deadline_owner, MEASURED_IN_P },
 	{ "death_group", death_group, MEASURED_IN_P },
 	{ "death_zombie_switched", death_zombie_switched, FROM_OUTSIDE },
+	{ "death_zombie_hotplug", death_zombie_hotplug, FROM_OUTSIDE },
 	{ "yield_switched_out", yield_switched_out, IN_P },
 	{ "yield_killed", yield_killed, MEASURED_IN_P },
 	{ "overrun_caught", overrun_caught, IN_P },
@@ -4808,9 +5448,15 @@ static const struct p_case {
 static const struct hp_case {
 	const char *name;
 	int (*fn)(void);
+	int no_hp;		/* takes no CPU offline */
 } hp_cases[] = {
+	{ "hotplug_sleepers", hotplug_sleepers },
+	{ "hotplug_sleeper_switched", hotplug_sleeper_switched },
+	{ "hotplug_no_admission_pinned", hotplug_no_admission_pinned },
 	{ "hotplug_refused", hotplug_refused },
+	{ "hotplug_departed", hotplug_departed },
 	{ "hotplug_server", hotplug_server },
+	{ "affinity_vs_setattr", affinity_vs_setattr, 1 },
 };
 
 #define N_HP_CASES	((int)ARRAY_SIZE(hp_cases))
@@ -4949,7 +5595,7 @@ int main(void)
 	if (hp_cpu < 0)
 		ksft_print_msg("no CPU hotplug: hotplug cases skipped\n");
 	for (i = 0; i < N_HP_CASES; i++) {
-		if (hp_cpu < 0) {
+		if (hp_cpu < 0 && !hp_cases[i].no_hp) {
 			ksft_test_result_skip("%s\n", hp_cases[i].name);
 			continue;
 		}
-- 
2.47.3

