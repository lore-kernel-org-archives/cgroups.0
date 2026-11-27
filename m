Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790180;
	b=1MseMLF//NvWDpRRGPwTXx5lnSDWT2ZPM4i8wEIf9QemTDemiiB/E5/e7w8kqKmcyJ9S
	 fVILmZsL+dNKMa1aOqQs8J+dMVO4P7kcbn9HCrQdkVHTHJkUXtcoo2Ydx+YhEpze80+Cl
	 jgVFW34sCxD4APZo1ClR+/zILy80t+v11NfO2GTbOaDVYZdMyomt4Zb6lp3qpCYr2j7fb
	 +3KuR+sDWYyI8g7ApI6XX4dp7xf6pfYQgjD/CCHNomQ3JSH6s3CQZMACSz1+XhA9LKGUN
	 Abo3u1WrBJt8lSlVArTZIFR3rxMzkmX9hOip1lPtJM0+K5LBWOo8fkHjjg9MzRNNyuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790180;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VdK4NQJ9UF3s1hxZTeESYE0+hwQ5ImDs9MdwPJOQRTQ=;
	b=tFfRxqD7Ht/qq5dS8mq0qXnYdCqgOWPVhColX5Y+Zkqo1FeTa6J/x0sQ5Ptd4lAdvMEy
	 DZRYdhGqHFNR4kb4t5Vw49OyPLdk+ElTIDuMzAF0tZ2OQSt0EO82Bs54LnvvBW6EfdGUe
	 ur3KdGDdrO32V+Ux+fADDwOiq4jO922QhYH4/TcNfzG+t0qfCnt4E4yPG97KPkhY7Fye2
	 JgOdZy5wr671kiXzR5yB3VxSMTvaQsuT5CYbW2pPRjaVzujdByooYFh0NI0hptBsqG0JO
	 EvUBqfsdusRC2G1MZKLhRA8W35Stbx8nQldzuvoCU5Pd8kR0R0cZldgqocgtQ5uD+YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=boKrkO3h;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0060A3822;
	Fri, 27 Nov 2026 14:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C0060A3822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=boKrkO3h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790176;
	bh=VdK4NQJ9UF3s1hxZTeESYE0+hwQ5ImDs9MdwPJOQRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boKrkO3h/pa6IExPTGti+xNrl8pqFbS50CUxuxZ1VpB8RRuTke5HadzscXs0QxBhl
	 GrJVOr0jTLACPbMqaZE2nnk6YsV5Wh1xiRtZURfVojQebungvYSCpr4Cimq1EYFlSj
	 bJxGOBhRL8ZYFp6OipeqOOWSKO0XG4CQPNoOAfaXKP3on/cNwa1W4whnZu2JL7fUrI
	 wVFXYE5MVF3hJWcYqJEXg14KQwDEH9rW4Ac7yJlAlLIkKjEcLa3fIfqqcs7C6E+7Ys
	 inBoPNzAGUdZV6c01iLYWeaqUvN+tV18bLfdtB1zKFLyJjgw7drOvnuspC/Vovd3Q4
	 4X6EJsNvxUlhQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZS4kx3zXck;
	Fri, 27 Nov 2026 09:36:16 -0500 (EST)
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
Subject: [PATCH v12 18/43] selftests/sched: Test the root domain of a task in deadline_bw_test
Date: Fri, 27 Nov 2026 09:35:45 -0500
Message-ID: <bd056b300844440d73b5b27b5d36d1b9491fa0e3.1795771148.git.mathieu.desnoyers@efficios.com>
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

Earlier in this series, fixes keep a deadline task in the root domain
that counts its bandwidth. Add the 32 cases of deadline_bw_test that
test them. They cover CPU hotplug and cpuset changes with partition
roots, and with CPUs isolated by isolcpus=domain:
- the CPU a task falls back to when its CPU goes offline
- a task that runs, sleeps or wakes while its CPU goes offline
- the refusals of a CPU offline or a cpuset change that would leave a
  deadline task no CPU in its root domain
- a rebuild that counts a task in the root domain it runs in
- a CPU offline that would take more bandwidth than the root domain has
  free, with the CPU's fair server (hotplug_server_refused)

The comment above each case gives its scenario. Twenty-one of these cases
need CPUs isolated by isolcpus=domain, and skip without them.

The message of each fix names the cases that test it.
hotplug_server_refused is not named there. It fails with
isolcpus=domain,0,1 before these fixes.

On v7.4-rc2, in 8 VMs of 8 CPUs, hotplug_partition_invalid_refused fails
in every VM. hotplug_child_partition_kept fails in 2 of 8. The cases
that need isolcpus=domain skip there. With the first series alone,
rebuild_record_taken fails with isolcpus=domain,0,1 in a guest of 7
CPUs.

These cases did not run on v7.4-rc2:
- hotplug_sibling_partition_refused fails if cpuset_offline_moves_dl()
  ignores a partition left with tasks and no CPU.
- hotplug_top_last_refused tests the offline of the last CPU of the
  top cpuset.
- partition_grows_child_valid fails without the check of the CPUs a
  partition root just got, in "cgroup/cpuset: Refuse to take a
  deadline task out of its root domain".
- hotplug_asleep_setattr fails if sched_setattr() admits a task asleep
  on an offline CPU in the root domain of that CPU. Without
  isolcpus=domain, that root domain has no active CPU, so
  sched_setattr() returns EBUSY. "sched/deadline: Record the root
  domain holding a task's bandwidth" admits the task in the root domain
  of an active CPU of its mask instead.
- hotplug_first_sibling_refused, hotplug_nested_partition_refused and
  hotplug_isolated_child_refused take the last CPU of a child partition.
  Its parent partition has no CPU of its own, so cpuset can then give
  it the CPUs of another child partition. A deadline task under that
  parent would change root domain. "sched/deadline: Keep the last CPU
  a task has in its root domain" refuses that offline with EBUSY.

With the fixes up to here, every case passes wherever it runs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../sched/deadline/deadline_bw_test.c         | 2615 ++++++++++++++++-
 1 file changed, 2612 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index f50d45dd5799..87fa1a7d420f 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -35,8 +35,13 @@
  * accounting, which clears what an earlier case left.
  *
  * The cases of hp_cases[] run after them, without P. These are the
- * hotplug cases, and affinity_vs_setattr. The test skips the hotplug
- * cases if no CPU can go offline. It still runs affinity_vs_setattr.
+ * hotplug cases, and ten other cases: mask_out_refused,
+ * partition_takes_refused, no_admission_affinity_moves,
+ * affinity_vs_setattr, rebuild_waking_keeps,
+ * partition_takes_fallback_refused, mask_grows_refused,
+ * partition_swap_refused, partition_refused_no_warn and
+ * partition_grows_child_valid. The test skips the hotplug cases if no
+ * CPU can go offline. It still runs these ten.
  * death_zombie_hotplug takes CPUs offline too, but it is in p_cases[]: it
  * needs the cpuset setup of those cases.
  *
@@ -45,7 +50,7 @@
  *
  * The test needs root, deadline admission control and 3 housekeeping
  * CPUs. Some cases need 4. Most also need the cgroup v2 cpuset
- * controller. Some need debugfs or CPU hotplug. Five need
+ * controller. Some need debugfs or CPU hotplug. Twenty-six need
  * isolcpus="domain" at boot.
  */
 #define _GNU_SOURCE
@@ -6859,6 +6864,73 @@ static int hotplug_server(void)
 	return KSFT_PASS;
 }
 
+/*
+ * A CPU that goes offline takes its capacity and the bandwidth of its
+ * fair server out of the root domain. Set the server of hp_cpu to the
+ * admission limit less 10%. The offline then costs the root domain the
+ * room of one probe task. Hold every probe task that the root domain
+ * admits but one: the CPU can still go offline. Hold one more: the
+ * offline must fail with EBUSY.
+ */
+static int hotplug_server_refused(void)
+{
+	uint64_t rt_runtime, rt_period, runtime;
+	int n, err, ret = KSFT_PASS;
+	char buf[32];
+
+	if (ext_switched_all()) {
+		ksft_print_msg("a hotplug can end the sched_ext scheduler\n");
+		return KSFT_SKIP;
+	}
+	if (read_file("/proc/sys/kernel/sched_rt_runtime_us", buf, sizeof(buf)) ||
+	    read_file("/proc/sys/kernel/sched_rt_period_us", buf, sizeof(buf))) {
+		ksft_print_msg("no sched_rt_runtime_us or sched_rt_period_us\n");
+		return KSFT_SKIP;
+	}
+	read_file("/proc/sys/kernel/sched_rt_runtime_us", buf, sizeof(buf));
+	rt_runtime = atoll(buf);
+	read_file("/proc/sys/kernel/sched_rt_period_us", buf, sizeof(buf));
+	rt_period = atoll(buf);
+	if (!rt_period || 5 * rt_runtime < rt_period) {
+		ksft_print_msg("the admission limit is below a fifth of a CPU\n");
+		return KSFT_SKIP;
+	}
+	runtime = SERVER_PERIOD * rt_runtime / rt_period - SERVER_PERIOD / 10;
+	if (server_set(hp_cpu, runtime, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", hp_cpu);
+		return KSFT_SKIP;
+	}
+	n = probe(NULL);
+	if (n < 2) {
+		ksft_print_msg("no room for two probe tasks\n");
+		return KSFT_SKIP;
+	}
+	if (hold(n - 1)) {
+		release_held();
+		return KSFT_FAIL;
+	}
+	err = cpu_online(hp_cpu, 0);
+	if (err) {
+		ksft_print_msg("CPU %d, room for one probe task left: offline refused (%s)\n",
+			       hp_cpu, strerror(-err));
+		ret = KSFT_FAIL;
+	} else if (cpu_online(hp_cpu, 1) || hold(1)) {
+		cpu_up(hp_cpu);
+		ret = KSFT_FAIL;
+	} else {
+		err = cpu_online(hp_cpu, 0);
+		if (err != -EBUSY) {
+			ksft_print_msg("CPU %d, no room left: offline %s, not EBUSY\n",
+				       hp_cpu, err ? strerror(-err) : "accepted");
+			if (!err)
+				cpu_up(hp_cpu);
+			ret = KSFT_FAIL;
+		}
+	}
+	release_held();
+	return ret;
+}
+
 /* Return whether @cpu is in @list, a CPU list as sysfs prints it. */
 static int in_cpu_list(const char *list, int cpu)
 {
@@ -6898,6 +6970,485 @@ static int fallback_wake(int fd, pid_t pid)
 	return 0;
 }
 
+/*
+ * The CPUs of fallback_case() and no_admission_affinity_moves(). I1 and I2
+ * are isolated by isolcpus="domain". H and K are housekeeping CPUs: CPUs
+ * that isolcpus does not isolate. H has a higher number than I2. K is
+ * another one.
+ *
+ * H has a higher number than I2 because of select_fallback_rq(). It
+ * gives a task that
+ * must leave its CPU the first CPU of its mask. A task allowed on I2 and
+ * H then goes to I2, unless the kernel keeps it in its root domain.
+ *
+ * fb_i1_hp says whether I1 can go offline.
+ */
+static int fb_i1 = -1, fb_i2 = -1, fb_h = -1, fb_k = -1, fb_i1_hp;
+
+/*
+ * Read total_bw of the root domain of the isolated CPUs into @def, and of
+ * the housekeeping root domain into @hk. Return 0, or -1.
+ */
+static int fallback_totals(long long *def, long long *hk)
+{
+	*def = total_bw_of(fb_i2);
+	*hk = total_bw_of(fb_h);
+	if (*def == -1 || *hk == -1) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Find I1, I2, H and K. Take a hotpluggable CPU as I1 if there is one.
+ * With @offline, I1 must be hotpluggable. Return 0, or -1 if the CPUs do
+ * not allow the case. fb_k is set only once all four are found.
+ */
+static int fallback_cpus(int offline)
+{
+	int i;
+
+	if (fb_k >= 0)
+		return offline && !fb_i1_hp ? -1 : 0;
+	/* A failed scan can leave I1, I2 or H set. Scan from scratch. */
+	fb_i1 = -1;
+	fb_i2 = -1;
+	fb_h = -1;
+	for (i = 0; i < nisol; i++) {
+		if (fb_i1 < 0 && cpu_hotpluggable(isol[i]))
+			fb_i1 = isol[i];
+		else if (fb_i2 < 0)
+			fb_i2 = isol[i];
+	}
+	fb_i1_hp = fb_i1 >= 0;
+	if (fb_i1 < 0 && nisol >= 2) {
+		fb_i1 = isol[0];
+		fb_i2 = isol[1];
+	}
+	for (i = 0; fb_i2 >= 0 && i < ncpus && fb_h < 0; i++) {
+		if (online[i] > fb_i2)
+			fb_h = online[i];
+	}
+	for (i = 0; fb_h >= 0 && i < ncpus && fb_k < 0; i++) {
+		if (online[i] != fb_h)
+			fb_k = online[i];
+	}
+	if (fb_i1 >= 0 && fb_i2 >= 0 && fb_k >= 0)
+		return offline && !fb_i1_hp ? -1 : 0;
+	fb_k = -1;
+	return -1;
+}
+
+enum fb_mode { FB_RUN_I1, FB_ON_I1, FB_ON_K, FB_ON_H, FB_MASK_H, FB_LAST_H, FB_PART_H, FB_STAY_K };
+
+/*
+ * B is a cpuset of I1, I2 and H. C is a cpuset of I1, in B. Neither is a
+ * partition. A deadline task of 10% is allowed on all CPUs. It sleeps on
+ * K or on H, and the housekeeping root domain counts it. The case moves
+ * it, asleep, into C or into B.
+ *
+ * In C, the task has I1 only. The move asks the root domain of the
+ * isolated CPUs for room, and that root domain counts the task. In B, the
+ * task still has H, a CPU of the housekeeping root domain. That root
+ * domain goes on counting it.
+ *
+ * The case then does one thing, and wakes the task. The table gives the
+ * cpuset the task is in, the CPU it sleeps on, what the case does, and
+ * the CPU the task must wake up on:
+ *
+ *   case                       in  asleep on  then                  wakes on
+ *   hotplug_fallback           C   I1         I1 goes offline       I2
+ *   hotplug_fallback_running   C   I1, runs   I1 goes offline       I2
+ *   hotplug_fallback_moved     C   K          I1 goes offline       I2
+ *   hotplug_fallback_in_mask   C   H          I1 goes offline       I2
+ *   mask_out_refused           C   H          C is given H only:    I1
+ *                                             EBUSY
+ *   hotplug_last_refused       B   H          H offline: EBUSY      H
+ *   hotplug_keeps_root_domain  B   H          H goes offline        K
+ *   partition_takes_refused    B   H          Q takes H: invalid    H
+ *
+ * hotplug_fallback wakes the task once after the move, so that it sleeps
+ * on I1. In hotplug_fallback_running, the task then spins on I1 with a
+ * period of 2ms. It is moved off I1 before the cpuset update of the
+ * offline, by select_fallback_rq(). The case checks where it runs after
+ * the offline. hotplug_keeps_root_domain gives B the CPU K as well. In
+ * partition_takes_refused, Q is a cpuset of H next to B. The case makes
+ * it a partition root, which must be invalid.
+ *
+ * With I1 offline, C has no CPU left, and the task gets the CPUs of B:
+ * I2 and H. It must wake up on I2, in the root domain that counts it. On
+ * H, it would run in a root domain that did not admit it. The three
+ * refusals have one reason: each change would leave the task no CPU in
+ * the root domain that counts it.
+ *
+ * In every case, the root domain of the CPU the task wakes on must count
+ * it, and the other one must not. The case checks the root domain of that
+ * CPU, not its number. The reference values of total_bw are taken with no
+ * task. If the case takes a CPU offline, they are taken with that CPU
+ * offline. Once the task is gone, total_bw must be
+ * back to them. The messages give total_bw of the root domain of the
+ * isolated CPUs first, then of the housekeeping one.
+ */
+static int fallback_case(enum fb_mode mode)
+{
+	int in_b = mode == FB_LAST_H || mode == FB_PART_H || mode == FB_STAY_K;
+	int off_cpu;
+	int on_h = mode == FB_ON_H || mode == FB_MASK_H || in_b;
+	int no_offline = mode == FB_MASK_H || mode == FB_LAST_H || mode == FB_PART_H;
+	char cg_q[PATH_MAX];
+	int running = mode == FB_RUN_I1;
+	int on_i1 = mode == FB_ON_I1 || running;
+	char cg_b[PATH_MAX], cg_c[PATH_MAX], path[PATH_MAX + 32], buf[256], one[16];
+	long long def0, hk0, def_off = 0, hk_off = 0, def_ref, hk_ref, def, hk, bw;
+	int fd[2], ret = KSFT_SKIP, added = 0, made = 0, w, at, err;
+	pid_t pid = -1;
+
+	/* hotplug_keeps_root_domain takes H offline, not I1. */
+	if (!root[0] || fallback_cpus(!no_offline && mode != FB_STAY_K)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs%s\n",
+			       no_offline ? "" : ", CPU hotplug");
+		return KSFT_SKIP;
+	}
+	off_cpu = mode == FB_STAY_K ? fb_h : fb_i1;
+	if ((mode == FB_LAST_H || mode == FB_STAY_K) && !cpu_hotpluggable(fb_h)) {
+		ksft_print_msg("CPU %d cannot go offline\n", fb_h);
+		return KSFT_SKIP;
+	}
+	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", root);
+	if (read_file(path, buf, sizeof(buf)))
+		return KSFT_SKIP;
+	if (!strstr(buf, "cpuset")) {
+		if (write_file(root, "cgroup.subtree_control", "+cpuset"))
+			return KSFT_SKIP;
+		added = 1;
+	}
+	if (snprintf(cg_q, sizeof(cg_q), "%s/deadline_bw_q", root) >= (int)sizeof(cg_q) ||
+	    snprintf(cg_b, sizeof(cg_b), "%s/deadline_bw_b", root) >= (int)sizeof(cg_b) ||
+	    snprintf(cg_c, sizeof(cg_c), "%s/c", cg_b) >= (int)sizeof(cg_c))
+		goto out;
+	if (mkdir(cg_b, 0755) && errno != EEXIST) {
+		ksft_print_msg("mkdir %s: %s\n", cg_b, strerror(errno));
+		goto out;
+	}
+	made = 1;
+	if (mode == FB_STAY_K)
+		snprintf(buf, sizeof(buf), "%d,%d,%d,%d", fb_i1, fb_i2, fb_h, fb_k);
+	else
+		snprintf(buf, sizeof(buf), "%d,%d,%d", fb_i1, fb_i2, fb_h);
+	snprintf(one, sizeof(one), "%d", fb_i1);
+	if (write_file(cg_b, "cpuset.cpus", buf) ||
+	    write_file(cg_b, "cgroup.subtree_control", "+cpuset") ||
+	    (mkdir(cg_c, 0755) && errno != EEXIST) ||
+	    write_file(cg_c, "cpuset.cpus", one)) {
+		ksft_print_msg("cpusets B and C cannot be made\n");
+		goto out;
+	}
+	if (fallback_totals(&def0, &hk0))
+		goto out;
+	ret = KSFT_FAIL;
+	if (!no_offline) {
+		if (cpu_online(off_cpu, 0)) {
+			ksft_print_msg("offline of CPU %d refused\n", off_cpu);
+			goto out;
+		}
+		/* H may be the offline CPU: read the housekeeping total_bw on K. */
+		def_off = total_bw_of(fb_i2);
+		hk_off = total_bw_of(fb_k);
+		if (def_off == -1 || hk_off == -1)
+			ret = KSFT_SKIP;
+		cpu_up(off_cpu);
+		if (ret == KSFT_SKIP)
+			goto out;
+	}
+
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		goto out;
+	}
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a deadline task");
+	if (!pid) {
+		cpu_set_t set;
+		int i, err;
+		char c;
+
+		/* Run on K or H, then allow every CPU again, and stay there. */
+		close(fd[1]);
+		CPU_ZERO(&set);
+		CPU_SET(on_h ? fb_h : fb_k, &set);
+		err = sched_setaffinity(0, sizeof(set), &set);
+		for (i = 0; i < CPU_SETSIZE; i++)
+			CPU_SET(i, &set);
+		if (err || sched_setaffinity(0, sizeof(set), &set) ||
+		    (running ? set_deadline(0, 1 * NSEC_PER_MSEC, 2 * NSEC_PER_MSEC) :
+			       set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD))) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		/* hotplug_fallback_running: spin from the first wakeup on. */
+		if (running) {
+			if (read(fd[0], &c, 1) == 1)
+				mv_state[1]++;
+			for (;;)
+				;
+		}
+		while (read(fd[0], &c, 1) == 1)
+			mv_state[1]++;
+		_exit(0);
+	}
+	close(fd[0]);
+	if (pid < 0 || child_up("hotplug_fallback", 0))
+		goto out_fd;
+	if (wait_for(1000, proc_state_of(pid) == 'S') || fallback_totals(&def, &hk))
+		goto out_fd;
+	bw = def + hk - def0 - hk0;
+	if (bw <= 0) {
+		ksft_print_msg("the deadline task adds %lld to total_bw\n", bw);
+		goto out_fd;
+	}
+
+	/*
+	 * Move it asleep into C, or into B. For hotplug_fallback, wake it
+	 * once so that it runs on I1.
+	 */
+	if (enter(in_b ? cg_b : cg_c, pid) ||
+	    (on_i1 && !running && fallback_wake(fd[1], pid)))
+		goto out_fd;
+	if (running) {
+		int n = mv_state[1];
+
+		if (write(fd[1], "w", 1) != 1 || wait_for(1000, mv_state[1] != n) ||
+		    wait_for(1000, task_cpu_of(pid) == fb_i1)) {
+			ksft_print_msg("the deadline task does not run on CPU %d\n", fb_i1);
+			goto out_fd;
+		}
+	}
+	at = task_cpu_of(pid);
+	if (on_i1 ? at != fb_i1 : on_h ? at != fb_h : at == fb_i1) {
+		ksft_print_msg("the deadline task sleeps on CPU %d\n", at);
+		ret = on_h ? KSFT_SKIP : KSFT_FAIL;
+		goto out_fd;
+	}
+	/* With no CPU offline, the reference is total_bw with no task. */
+	def_ref = no_offline ? def0 : def_off;
+	hk_ref = no_offline ? hk0 : hk_off;
+	if (mode == FB_MASK_H) {
+		snprintf(one, sizeof(one), "%d", fb_h);
+		err = write_file(cg_c, "cpuset.cpus", one);
+		if (err != -EBUSY) {
+			ksft_print_msg("C given CPU %d only: %s, not EBUSY\n", fb_h,
+				       err ? strerror(-err) : "accepted");
+			goto out_fd;
+		}
+	} else if (mode == FB_LAST_H) {
+		err = cpu_online(fb_h, 0);
+		if (err != -EBUSY) {
+			ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", fb_h,
+				       err ? strerror(-err) : "accepted");
+			cpu_up(fb_h);
+			goto out_fd;
+		}
+	} else if (mode == FB_PART_H) {
+		snprintf(one, sizeof(one), "%d", fb_h);
+		if ((mkdir(cg_q, 0755) && errno != EEXIST) ||
+		    write_file(cg_q, "cpuset.cpus", one) ||
+		    write_file(cg_q, "cpuset.cpus.partition", "root")) {
+			ksft_print_msg("cpuset Q cannot be made\n");
+			goto out_fd;
+		}
+		snprintf(path, sizeof(path), "%s/cpuset.cpus.partition", cg_q);
+		if (read_file(path, buf, sizeof(buf)) || !strstr(buf, "Deadline task")) {
+			ksft_print_msg("Q takes CPU %d from B: %s", fb_h, buf);
+			goto out_fd;
+		}
+	} else if (cpu_online(off_cpu, 0)) {
+		ksft_print_msg("offline of CPU %d with the task asleep refused\n", off_cpu);
+		goto out_fd;
+	}
+	if (running)
+		sleep_ns(PERIOD);
+	else if (fallback_wake(fd[1], pid))
+		goto out_up;
+	def = total_bw_of(fb_i2);
+	hk = total_bw_of(fb_k);
+	if (def == -1 || hk == -1)
+		goto out_up;
+	w = task_cpu_of(pid);
+	ret = KSFT_PASS;
+	if (in_cpu_list(isolated, w) ? def != def_ref + bw || hk != hk_ref :
+				     hk != hk_ref + bw || def != def_ref) {
+		ksft_print_msg("woken on CPU %d: total_bw %lld, %lld, not %lld, %lld\n",
+			       w, def, hk,
+			       in_cpu_list(isolated, w) ? def_ref + bw : def_ref,
+			       in_cpu_list(isolated, w) ? hk_ref : hk_ref + bw);
+		ret = KSFT_FAIL;
+	} else if (in_cpu_list(isolated, w) == in_b) {
+		ksft_print_msg("woken on CPU %d: out of the root domain that counted it\n",
+			       w);
+		ret = KSFT_FAIL;
+	}
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	def = total_bw_of(fb_i2);
+	hk = total_bw_of(fb_k);
+	if (def != def_ref || hk != hk_ref) {
+		ksft_print_msg("task gone: total_bw %lld, %lld, not %lld, %lld\n",
+			       def, hk, def_ref, hk_ref);
+		ret = KSFT_FAIL;
+	}
+out_up:
+	reap(pid);
+	if (!no_offline)
+		cpu_up(off_cpu);
+	pid = -1;
+out_fd:
+	reap(pid);
+	close(fd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (fallback_totals(&def, &hk) || def != def0 || hk != hk0)) {
+		ksft_print_msg("task gone, CPU %d online: total_bw %lld, %lld, not %lld, %lld\n",
+			       off_cpu, def, hk, def0, hk0);
+		ret = KSFT_FAIL;
+	}
+out:
+	if (made) {
+		if (rmdir(cg_q) && errno != ENOENT)
+			ksft_print_msg("rmdir %s: %s\n", cg_q, strerror(errno));
+		if (wait_for(1000, !rmdir(cg_c) || errno == ENOENT) ||
+		    wait_for(1000, !rmdir(cg_b) || errno == ENOENT))
+			ksft_print_msg("rmdir %s: %s\n", cg_b, strerror(errno));
+	}
+	if (added && write_file(root, "cgroup.subtree_control", "-cpuset"))
+		ksft_print_msg("the cpuset controller stays enabled\n");
+	return ret;
+}
+
+static int hotplug_fallback_running(void)
+{
+	return fallback_case(FB_RUN_I1);
+}
+
+static int hotplug_fallback(void)
+{
+	return fallback_case(FB_ON_I1);
+}
+
+static int hotplug_fallback_moved(void)
+{
+	return fallback_case(FB_ON_K);
+}
+
+static int hotplug_fallback_in_mask(void)
+{
+	return fallback_case(FB_ON_H);
+}
+
+static int mask_out_refused(void)
+{
+	return fallback_case(FB_MASK_H);
+}
+
+static int hotplug_last_refused(void)
+{
+	return fallback_case(FB_LAST_H);
+}
+
+static int hotplug_keeps_root_domain(void)
+{
+	return fallback_case(FB_STAY_K);
+}
+
+static int partition_takes_refused(void)
+{
+	return fallback_case(FB_PART_H);
+}
+
+/*
+ * Turn admission control off. A task pins itself to H, becomes a deadline
+ * task of 10% and spins. The housekeeping root domain counts it. The case
+ * then sets its affinity to I2 with sched_setaffinity(). Nothing reserves
+ * room for it: its bandwidth must follow it to the root domain of the
+ * isolated CPUs. Once the task is gone and admission control is on again,
+ * total_bw must be what it was.
+ */
+static int no_admission_affinity_moves(void)
+{
+	long long def0, hk0, def, hk, bw;
+	int ret = KSFT_FAIL, at;
+	char saved[64];
+	cpu_set_t set;
+	pid_t pid;
+
+	if (fallback_cpus(0)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs\n");
+		return KSFT_SKIP;
+	}
+	if (fallback_totals(&def0, &hk0))
+		return KSFT_SKIP;
+	if (read_file("/proc/sys/kernel/sched_rt_runtime_us", saved, sizeof(saved)) ||
+	    write_file("/proc/sys/kernel", "sched_rt_runtime_us", "-1")) {
+		ksft_print_msg("admission control cannot be turned off\n");
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	pid = fork_child("a deadline task");
+	if (!pid) {
+		CPU_ZERO(&set);
+		CPU_SET(fb_h, &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		for (;;)
+			spin_ns(NSEC_PER_MSEC);
+	}
+	if (pid < 0 || child_up("no_admission_affinity_moves", 0))
+		goto out;
+	sleep_ns(PERIOD);
+	if (fallback_totals(&def, &hk))
+		goto out;
+	bw = hk - hk0;
+	if (bw <= 0 || def != def0) {
+		ksft_print_msg("the deadline task adds %lld to total_bw of its root domain\n", bw);
+		goto out;
+	}
+	CPU_ZERO(&set);
+	CPU_SET(fb_i2, &set);
+	if (sched_setaffinity(pid, sizeof(set), &set)) {
+		ksft_print_msg("sched_setaffinity to CPU %d: %s\n", fb_i2, strerror(errno));
+		goto out;
+	}
+	sleep_ns(2 * PERIOD);
+	at = task_cpu_of(pid);
+	if (at != fb_i2 || fallback_totals(&def, &hk))
+		goto out;
+	ret = KSFT_PASS;
+	if (def != def0 + bw || hk != hk0) {
+		ksft_print_msg("on CPU %d: total_bw %lld, %lld, not %lld, %lld\n",
+			       at, def, hk, def0 + bw, hk0);
+		ret = KSFT_FAIL;
+	}
+out:
+	reap(pid);
+	if (write_file("/proc/sys/kernel", "sched_rt_runtime_us", saved)) {
+		ksft_print_msg("admission control cannot be turned on again\n");
+		return KSFT_FAIL;
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (fallback_totals(&def, &hk) || def != def0 || hk != hk0)) {
+		ksft_print_msg("task gone: total_bw %lld, %lld, not %lld, %lld\n",
+			       def, hk, def0, hk0);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
 /*
  * The cpusets of the cases below: B and Q in the root cgroup, C in B. A
  * case makes those it needs. cs_setup() names them and enables the cpuset
@@ -7145,6 +7696,1779 @@ static int move_back_cpu_offline(void)
 	return ret;
 }
 
+enum sp_mode { SP_HK_10, SP_HK_WAKING, SP_ISO_WAKING };
+
+/*
+ * Return a CPU other than @not: an isolated one if @side, else a
+ * housekeeping one. Return -1 if there is none.
+ */
+static int other_cpu(int side, int not)
+{
+	int n = side ? nisol : ncpus, *cpus = side ? isol : online, i;
+
+	for (i = n - 1; i >= 0; i--) {
+		if (cpus[i] != not)
+			return cpus[i];
+	}
+	return -1;
+}
+
+/*
+ * A deadline task loses its CPU to an offline. It is in the root cgroup,
+ * and allowed on every CPU: its mask holds CPUs of the two root domains.
+ * It must stay in the root domain that counts it. The steps:
+ * 1. A task runs on the last housekeeping CPU that can go offline. Then
+ *    it allows every CPU and becomes a deadline task, of 10% for
+ *    SP_HK_10, of 90% for SP_HK_WAKING. The housekeeping root domain
+ *    counts it.
+ *    For SP_ISO_WAKING, the task runs on the last isolated CPU that can
+ *    go offline. Then it allows the isolated CPUs only, and becomes a
+ *    deadline task of 90%. The root domain of the isolated CPUs counts
+ *    it. Then it allows every CPU.
+ *    The task of SP_HK_10 spins. The others spin 50us and sleep 50us, in
+ *    a loop.
+ * 2. Wait a period. X is the CPU the task runs on.
+ * 3. Take X offline.
+ * 4. Wait two periods. The task must run on a CPU of its root domain.
+ *    That root domain must still count it.
+ * The task of SP_HK_10 is throttled most of the time. Its replenishment
+ * timer then finds its CPU offline, and picks a CPU for it. The other
+ * tasks wake up while the offline goes on, and the wakeup picks a CPU
+ * for them.
+ *
+ * A kernel that does not prefer the root domain of the task at a wakeup
+ * gives it the first CPU of its mask. The waking cases fail on such a
+ * kernel only if that CPU is of the other kind. SP_HK_WAKING needs an
+ * isolated CPU first, SP_ISO_WAKING a housekeeping CPU first.
+ *
+ * The kernel records with the task the CPU where it became a deadline
+ * task. The waking cases need X to be that CPU: a wakeup in the offline
+ * looks at the root domain of that CPU. SP_HK_10 takes any housekeeping
+ * CPU as X.
+ *
+ * Do it in rounds, each with a new task. Stop once 3 rounds check
+ * something, or after 10 rounds. A round checks nothing if X cannot go
+ * offline, or for a waking case, if X is not the CPU recorded.
+ *
+ * The references of total_bw are taken with no task: with X offline
+ * after the task is gone, and with every CPU online. The messages give
+ * total_bw of the root domain of the isolated CPUs first, then of the
+ * housekeeping one.
+ */
+static int spin_offline(enum sp_mode mode)
+{
+	uint64_t runtime = (mode == SP_HK_10 ? 10 : 90) * NSEC_PER_MSEC;
+	int iso = mode == SP_ISO_WAKING, start = -1, rounds = 0, round;
+	long long def0, hk0, def, hk, ref_def, ref_hk, bw;
+	int x, d, h, cpu, i, down, ret = KSFT_SKIP;
+	pid_t pid;
+
+	for (i = 0; i < (iso ? nisol : ncpus); i++) {
+		if (cpu_hotpluggable(iso ? isol[i] : online[i]))
+			start = iso ? isol[i] : online[i];
+	}
+	if (!nisol || (iso && nisol < 2) || start < 0) {
+		ksft_print_msg("needs isolcpus=domain: %d isolated CPUs, one hotpluggable\n",
+			       iso ? 2 : 1);
+		return KSFT_SKIP;
+	}
+	if (totals_of(isol[0], online[0], &def0, &hk0))
+		return KSFT_SKIP;
+	ret = KSFT_PASS;
+	for (round = 0; round < 10 && rounds < 3 && ret == KSFT_PASS; round++) {
+		mv_state[0] = 0;
+		mv_state[1] = 0;
+		pid = fork_child("a spinning deadline task");
+		if (!pid) {
+			cpu_set_t set;
+
+			CPU_ZERO(&set);
+			CPU_SET(start, &set);
+			if (sched_setaffinity(0, sizeof(set), &set))
+				_exit(1);
+			spin_ns(NSEC_PER_MSEC);
+			for (i = 0; i < (iso ? nisol : CPU_SETSIZE); i++)
+				CPU_SET(iso ? isol[i] : i, &set);
+			if (sched_setaffinity(0, sizeof(set), &set) ||
+			    set_deadline(0, runtime, PERIOD)) {
+				mv_state[0] = -1;
+				_exit(1);
+			}
+			for (i = 0; i < CPU_SETSIZE; i++)
+				CPU_SET(i, &set);
+			if (sched_setaffinity(0, sizeof(set), &set)) {
+				mv_state[0] = -1;
+				_exit(1);
+			}
+			mv_state[0] = 1;
+			for (;;) {
+				mv_state[1]++;
+				if (mode == SP_HK_10)
+					continue;
+				spin_ns(50 * NSEC_PER_USEC);
+				sleep_ns(50 * NSEC_PER_USEC);
+			}
+		}
+		ret = KSFT_FAIL;
+		down = 0;
+		if (pid < 0 || child_up("spin_offline", 0))
+			goto next;
+		sleep_ns(PERIOD);
+		x = task_cpu_of(pid);
+		if (mode == SP_HK_10 ? in_cpu_list(isolated, x) || !cpu_hotpluggable(x) :
+				       x != start) {
+			ret = KSFT_PASS;	/* check nothing */
+			goto next;
+		}
+		d = other_cpu(1, x);
+		h = other_cpu(0, x);
+		if (totals_of(d, h, &def, &hk))
+			goto next;
+		bw = iso ? def - def0 : hk - hk0;
+		if (bw <= 0 || (iso ? hk != hk0 : def != def0)) {
+			ksft_print_msg("on CPU %d, the deadline task adds %lld, %lld to total_bw\n",
+				       task_cpu_of(pid), def - def0, hk - hk0);
+			goto next;
+		}
+		if (task_cpu_of(pid) != x) {
+			ret = KSFT_PASS;	/* moved off X: check nothing */
+			goto next;
+		}
+		rounds++;
+		if (cpu_online(x, 0)) {
+			ksft_print_msg("offline of CPU %d with the task on it refused\n", x);
+			goto next;
+		}
+		down = 1;
+		sleep_ns(2 * PERIOD);
+		cpu = task_cpu_of(pid);
+		if (totals_of(d, h, &def, &hk))
+			goto next;
+		reap(pid);
+		pid = -1;
+		sleep_ns(3 * PERIOD);
+		if (totals_of(d, h, &ref_def, &ref_hk))
+			goto next;
+		if (in_cpu_list(isolated, cpu) != iso) {
+			ksft_print_msg("round %d: CPU %d offline, the task runs on CPU %d\n",
+				       round, x, cpu);
+			goto next;
+		}
+		if (iso ? def != ref_def + bw || hk != ref_hk :
+			  hk != ref_hk + bw || def != ref_def) {
+			ksft_print_msg("round %d: on CPU %d: total_bw %lld, %lld, not %lld, %lld\n",
+				       round, cpu, def, hk, iso ? ref_def + bw : ref_def,
+				       iso ? ref_hk : ref_hk + bw);
+			goto next;
+		}
+		ret = KSFT_PASS;
+next:
+		reap(pid);
+		if (down)
+			cpu_up(x);
+		sleep_ns(3 * PERIOD);
+		if (ret == KSFT_PASS)
+			ret = totals_check("task gone", isol[0], online[0], def0, hk0);
+	}
+	if (ret == KSFT_PASS && !rounds) {
+		ksft_print_msg("the task never ran on a CPU that can go offline\n");
+		ret = KSFT_SKIP;
+	}
+	return ret;
+}
+
+static int hotplug_spinner_keeps(void)
+{
+	return spin_offline(SP_HK_10);
+}
+
+static int hotplug_waking_keeps(void)
+{
+	return spin_offline(SP_HK_WAKING);
+}
+
+static int hotplug_isolated_keeps(void)
+{
+	return spin_offline(SP_ISO_WAKING);
+}
+
+/*
+ * A rebuild of the sched domains must keep a deadline task in the root
+ * domain that counts it. The task wakes up often, so that a wakeup can
+ * land inside a rebuild. The steps:
+ * 1. A task runs on H, the highest housekeeping CPU. Then it allows every
+ *    CPU and becomes a deadline task of 90%. The housekeeping root domain
+ *    counts it. It spins 50us and sleeps 50us, in a loop.
+ * 2. Wait a period. The task must run on a housekeeping CPU.
+ * 3. Make Q a partition root of another housekeeping CPU, and remove it.
+ *    Each of the two steps rebuilds the sched domains.
+ * 4. The task must run on a housekeeping CPU. The housekeeping root
+ *    domain must still count it, and the other one must not.
+ * A kernel that gets this wrong gives the task the first CPU of the root
+ * domain of the isolated CPUs. That root domain then counts it, with no
+ * admission test. This shows only if that first CPU is isolated, as with
+ * isolcpus=domain,0,1. The case skips otherwise.
+ *
+ * Do it in 20 rounds, each with a new task. The first rebuild of a new
+ * task is the one most likely to go wrong. The case is not deterministic.
+ * The messages give total_bw of the root domain of the isolated CPUs
+ * first, then of the housekeeping one.
+ */
+static int rebuild_waking_keeps(void)
+{
+	int h = top_cpu(1), q = other_cpu(0, top_cpu(1)), d = nisol ? isol[0] : -1;
+	long long def0, hk0, def, hk;
+	int round, cpu, ret;
+	pid_t pid;
+
+	if (d < 0 || d > online[0] || q < 0) {
+		ksft_print_msg("needs isolcpus=domain with the first CPU isolated, as with 0,1\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	ret = KSFT_SKIP;
+	if (totals_of(d, h, &def0, &hk0))
+		goto out;
+	ret = KSFT_PASS;
+	for (round = 0; round < 20 && ret == KSFT_PASS; round++) {
+		mv_state[0] = 0;
+		pid = fork_child("a waking deadline task");
+		if (!pid) {
+			cpu_set_t set;
+			int i;
+
+			CPU_ZERO(&set);
+			CPU_SET(h, &set);
+			if (sched_setaffinity(0, sizeof(set), &set))
+				_exit(1);
+			spin_ns(NSEC_PER_MSEC);
+			for (i = 0; i < CPU_SETSIZE; i++)
+				CPU_SET(i, &set);
+			if (sched_setaffinity(0, sizeof(set), &set) ||
+			    set_deadline(0, 90 * NSEC_PER_MSEC, PERIOD)) {
+				mv_state[0] = -1;
+				_exit(1);
+			}
+			mv_state[0] = 1;
+			for (;;) {
+				spin_ns(50 * NSEC_PER_USEC);
+				sleep_ns(50 * NSEC_PER_USEC);
+			}
+		}
+		ret = KSFT_FAIL;
+		if (pid < 0 || child_up("rebuild_waking_keeps", 0))
+			goto next;
+		sleep_ns(PERIOD);
+		cpu = task_cpu_of(pid);
+		if (totals_of(d, h, &def, &hk))
+			goto next;
+		if (in_cpu_list(isolated, cpu) || def != def0 || hk <= hk0) {
+			ksft_print_msg("round %d: on CPU %d before the rebuild: total_bw %lld, %lld\n",
+				       round, cpu, def, hk);
+			goto next;
+		}
+		if (make_partition(cs_q, q)) {
+			ksft_print_msg("no partition root Q of CPU %d\n", q);
+			goto next;
+		}
+		remove_partition(cs_q);
+		cpu = task_cpu_of(pid);
+		if (totals_check("after the rebuild", d, h, def, hk) != KSFT_PASS)
+			ksft_print_msg("round %d: the task runs on CPU %d\n", round, cpu);
+		else if (in_cpu_list(isolated, cpu))
+			ksft_print_msg("round %d: after the rebuild, the task runs on CPU %d\n",
+				       round, cpu);
+		else
+			ret = KSFT_PASS;
+next:
+		remove_partition(cs_q);
+		reap(pid);
+		sleep_ns(3 * PERIOD);
+		if (ret == KSFT_PASS)
+			ret = totals_check("task gone", d, h, def0, hk0);
+	}
+out:
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A user affinity can keep a task out of the root domain that counts
+ * it. The CPUs are those of fallback_case(). B is a cpuset of I1, I2, H
+ * and K. C, in B, is a cpuset of H. Neither is a partition. The steps:
+ * 1. A task in the root cgroup allows I1 and I2 only. It becomes a
+ *    deadline task of 10%. The root domain of the isolated CPUs counts
+ *    it.
+ * 2. It sets its affinity to I1, I2 and H. That holds the root domain
+ *    that counts it, so it is accepted. It sleeps.
+ * 3. Move it asleep into C. It has H only. The housekeeping root domain
+ *    counts it now. Wake it: it runs on H.
+ * 4. Take H offline. C has no CPU left, and the task would get the CPUs
+ *    of B: I1, I2 and K. Its affinity keeps I1 and I2 of them. That holds
+ *    no CPU of the root domain that counts it.
+ * The offline must fail with EBUSY. The task must still sleep on H, and
+ * total_bw must not change. Wake it: it must run on H.
+ */
+static int hotplug_user_mask_refused(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (fallback_cpus(0) || !cpu_hotpluggable(fb_h)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs, hotplug\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d,%d,%d,%d", fb_i1, fb_i2, fb_h, fb_k);
+	if (cs_make(cs_b, buf) || write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", fb_h);
+	if (cs_make(cs_c, buf) || fallback_totals(&def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a deadline task");
+	if (!pid) {
+		cpu_set_t set;
+		char c;
+
+		CPU_ZERO(&set);
+		CPU_SET(fb_i1, &set);
+		CPU_SET(fb_i2, &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		CPU_SET(fb_h, &set);
+		if (sched_setaffinity(0, sizeof(set), &set)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		while (read(fd[0], &c, 1) == 1)
+			mv_state[1]++;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("hotplug_user_mask_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || fallback_totals(&def, &hk))
+		goto out;
+	bw = def - def0;
+	if (bw <= 0 || hk != hk0) {
+		ksft_print_msg("the deadline task adds %lld, %lld to total_bw\n", bw, hk - hk0);
+		goto out;
+	}
+	err = enter(cs_c, pid);
+	if (err) {
+		ksft_print_msg("a move into C refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (fallback_wake(fd[1], pid) ||
+	    totals_check("in C", fb_i2, fb_h, def0, hk0 + bw))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h) {
+		ksft_print_msg("woken in C on CPU %d, not %d\n", cpu, fb_h);
+		goto out;
+	}
+	err = cpu_online(fb_h, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", fb_h,
+			       err ? strerror(-err) : "accepted");
+		if (!err) {
+			if (!fallback_wake(fd[1], pid))
+				ksft_print_msg("woken on CPU %d\n", task_cpu_of(pid));
+			cpu_up(fb_h);
+		}
+		goto out;
+	}
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h || proc_state_of(pid) != 'S') {
+		ksft_print_msg("offline refused: the task is on CPU %d, state %c\n",
+			       cpu, proc_state_of(pid));
+		goto out;
+	}
+	if (totals_check("offline refused", fb_i2, fb_h, def0, hk0 + bw) ||
+	    fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, fb_h);
+		goto out;
+	}
+	ret = totals_check("woken", fb_i2, fb_h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", fb_i2, fb_h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * cgroup v2 works out the CPUs of each cpuset from the top down, at an
+ * offline too. A cpuset left with no CPU takes all those of its parent.
+ * Its child then keeps those that its own cpuset.cpus holds. The CPUs are
+ * those of fallback_case(). B, in the root cgroup, has cpuset.cpus H. C,
+ * in B, has cpuset.cpus I1, I2 and H. Neither is a partition. C gets H.
+ * The steps:
+ * 1. A task in the root cgroup runs on H. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 2. Move it asleep into C. It keeps H.
+ * 3. Take H offline. B has no CPU left, and gets all the CPUs of the root
+ *    cgroup. C keeps I1 and I2 of them: no CPU of the root domain that
+ *    counts the task. The root cgroup itself still has K. The kernel must
+ *    work out the CPUs of C from those of B, not from those of the root
+ *    cgroup.
+ * The offline must fail with EBUSY. The task must still sleep on H, and
+ * total_bw must not change. Wake it: it must run on H.
+ */
+static int hotplug_nested_refused(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (fallback_cpus(0) || !cpu_hotpluggable(fb_h)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs, hotplug\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d", fb_h);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d,%d,%d", fb_i1, fb_i2, fb_h);
+	if (cs_make(cs_c, buf) || fallback_totals(&def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(fb_h, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("hotplug_nested_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') ||
+	    fallback_totals(&def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_c, pid);
+	cpu = task_cpu_of(pid);
+	if (bw <= 0 || def != def0 || err || cpu != fb_h) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in C: %s, on CPU %d\n",
+			       def - def0, bw, strerror(-err), cpu);
+		goto out;
+	}
+	if (totals_check("in C", fb_i2, fb_h, def0, hk0 + bw))
+		goto out;
+	err = cpu_online(fb_h, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", fb_h,
+			       err ? strerror(-err) : "accepted");
+		if (!err) {
+			if (!fallback_wake(fd[1], pid))
+				ksft_print_msg("woken on CPU %d\n",
+					       task_cpu_of(pid));
+			cpu_up(fb_h);
+		}
+		goto out;
+	}
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h || proc_state_of(pid) != 'S') {
+		ksft_print_msg("offline refused: the task is on CPU %d, state %c\n",
+			       cpu, proc_state_of(pid));
+		goto out;
+	}
+	if (totals_check("offline refused", fb_i2, fb_h, def0, hk0 + bw) ||
+	    fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, fb_h);
+		goto out;
+	}
+	ret = totals_check("woken", fb_i2, fb_h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", fb_i2, fb_h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * The CPUs of the partition cases and of cascade_case(). X, Y and Z are
+ * the three highest online CPUs: CPUs that isolcpus="domain" does not
+ * isolate. W, the lowest one, stays with the root cgroup. Return 0, or -1
+ * if they are missing or X cannot go offline.
+ */
+static int pc_x, pc_y, pc_z, pc_w;
+
+static int partition_cpus(void)
+{
+	if (ncpus < 4 || !cpu_hotpluggable(top_cpu(3))) {
+		ksft_print_msg("needs 4 CPUs, CPU hotplug\n");
+		return -1;
+	}
+	pc_x = top_cpu(3);
+	pc_y = top_cpu(2);
+	pc_z = top_cpu(1);
+	pc_w = online[0];
+	return 0;
+}
+
+/*
+ * A partition root left with no CPU of its own takes the CPUs of a child
+ * partition, if it holds a task. The child partition becomes invalid. B
+ * is an isolated partition of X, Y and Z. C, in B, is an isolated
+ * partition of Y and Z. So B keeps X only. The steps:
+ * 1. Take X offline and back with no task, to read the total_bw of each
+ *    root domain without X.
+ * 2. A task in the root cgroup runs on W. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 3. Move it asleep into B. It has X only. The default root domain, which
+ *    spans the CPUs of isolated partitions, counts it.
+ * 4. Take X offline. B takes Y and Z, and C becomes invalid. The task gets
+ *    Y and Z: CPUs of the same root domain.
+ * The offline must be accepted. The default root domain must still count
+ * the task. Wake it: it must run on Y or Z.
+ */
+static int hotplug_child_partition_kept(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, ret = KSFT_SKIP, x_off = 0;
+	long long def0, hk0, def_off, hk_off, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (partition_cpus() || cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d,%d,%d", pc_x, pc_y, pc_z);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "isolated") ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d,%d", pc_y, pc_z);
+	if (cs_make(cs_c, buf) ||
+	    write_file(cs_c, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_b, "isolated", 1) || partition_has(cs_b, "invalid", 0) ||
+	    !partition_has(cs_c, "isolated", 1) || partition_has(cs_c, "invalid", 0))
+		goto out;
+	if (totals_of(pc_y, pc_w, &def0, &hk0))
+		goto out;
+	err = cpu_online(pc_x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d with no task: %s\n", pc_x, strerror(-err));
+		goto out;
+	}
+	err = totals_of(pc_y, pc_w, &def_off, &hk_off);
+	cpu_up(pc_x);
+	if (err || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(pc_w, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("hotplug_child_partition_kept", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(pc_y, pc_w, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_b, pid);
+	if (bw <= 0 || def != def0 || err) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in B: %s\n",
+			       def - def0, bw, strerror(-err));
+		goto out;
+	}
+	if (totals_check("in B", pc_y, pc_w, def0 + bw, hk0) || fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != pc_x) {
+		ksft_print_msg("woken in B on CPU %d, not %d\n", cpu, pc_x);
+		goto out;
+	}
+	err = cpu_online(pc_x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d: %s, not accepted\n", pc_x, strerror(-err));
+		goto out;
+	}
+	x_off = 1;
+	if (!partition_has(cs_c, "invalid", 1) ||
+	    totals_check("X offline", pc_y, pc_w, def_off + bw, hk_off) ||
+	    fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != pc_y && cpu != pc_z) {
+		ksft_print_msg("woken on CPU %d, not %d or %d\n", cpu, pc_y, pc_z);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	if (x_off)
+		cpu_up(pc_x);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", pc_y, pc_w, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * The same rule, with a child partition of another kind. B is a root
+ * partition of X and Y. C, in B, is an isolated partition of Y. So B keeps
+ * X only, in a root domain of its own. N, in B, is a cpuset that is not a
+ * partition. The steps:
+ * 1. A task that is not a deadline task sleeps in N.
+ * 2. A task in the root cgroup runs on W. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 3. Move it asleep into C. The default root domain counts it.
+ * 4. Take X offline. B would take Y, and C would become invalid. Y would
+ *    leave the default root domain for that of B, with the deadline task.
+ *    That root domain did not admit it.
+ * The offline must fail with EBUSY. C must stay valid, and total_bw must
+ * not change. Wake the task: it must run on Y. Once the task is gone, the
+ * offline must be accepted.
+ */
+static int hotplug_partition_invalid_refused(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, ret = KSFT_SKIP, x_off = 0;
+	long long def0, hk0, def, hk, bw;
+	char buf[64], cs_n[PATH_MAX];
+	pid_t pid = -1, other = -1;
+
+	if (partition_cpus() || cs_setup())
+		return KSFT_SKIP;
+	if (snprintf(cs_n, sizeof(cs_n), "%s/n", cs_b) >= (int)sizeof(cs_n))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d,%d", pc_x, pc_y);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "root") ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", pc_y);
+	if (cs_make(cs_c, buf) ||
+	    write_file(cs_c, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_b, "root", 1) || partition_has(cs_b, "invalid", 0) ||
+	    !partition_has(cs_c, "isolated", 1) || partition_has(cs_c, "invalid", 0))
+		goto out;
+	if (mkdir(cs_n, 0755) && errno != EEXIST) {
+		ksft_print_msg("mkdir %s: %s\n", cs_n, strerror(errno));
+		goto out;
+	}
+	other = fork_child("a task in N");
+	if (!other) {
+		for (;;)
+			pause();
+	}
+	if (other < 0 || enter(cs_n, other) || totals_of(pc_y, pc_w, &def0, &hk0) ||
+	    pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(pc_w, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("hotplug_partition_invalid_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(pc_y, pc_w, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_c, pid);
+	if (bw <= 0 || def != def0 || err) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in C: %s\n",
+			       def - def0, bw, strerror(-err));
+		goto out;
+	}
+	if (totals_check("in C", pc_y, pc_w, def0 + bw, hk0))
+		goto out;
+	err = cpu_online(pc_x, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", pc_x,
+			       err ? strerror(-err) : "accepted");
+		x_off = !err;
+		goto out;
+	}
+	if (partition_has(cs_c, "invalid", 0) ||
+	    totals_check("offline refused", pc_y, pc_w, def0 + bw, hk0) ||
+	    fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != pc_y) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, pc_y);
+		goto out;
+	}
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	err = cpu_online(pc_x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d with the task gone: %s\n", pc_x,
+			       strerror(-err));
+		goto out;
+	}
+	x_off = 1;
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	reap(other);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	if (x_off)
+		cpu_up(pc_x);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", pc_y, pc_w, def0, hk0);
+	if (cs_n[0] && wait_for(1000, !rmdir(cs_n) || errno == ENOENT))
+		ksft_print_msg("rmdir %s: %s\n", cs_n, strerror(errno));
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A partition root that gets more CPUs makes a child partition valid. A
+ * is the highest housekeeping CPU, B the next one:
+ * 1. B is a root partition of A. A deadline task of 10% sleeps in B.
+ * 2. C, in B, becomes a root partition of A. B would have no CPU left
+ *    for its task: C is invalid.
+ * 3. B gets A and B.
+ * C must become valid. The check runs before the rebuild of the sched
+ * domains: the root domain that counts the task still spans A alone.
+ * Its task then gets B.
+ */
+static int partition_grows_child_valid(void)
+{
+	int go[2] = { -1, -1 }, ack[2] = { -1, -1 }, i, err, ret = KSFT_SKIP;
+	int a = top_cpu(1), b = top_cpu(2);
+	char buf[64], path[PATH_MAX + 32];
+	pid_t pid = -1;
+	cpu_set_t all;
+	char c;
+
+	if (ncpus < 3 || cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d", a);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "root") ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset") ||
+	    !partition_has(cs_b, "root", 1) || partition_has(cs_b, "invalid", 0))
+		goto out;
+	if (pipe(go) || pipe(ack))
+		goto out;
+	pid = fork_child("a deadline task in B");
+	if (!pid) {
+		/* Run once in B, so that the task sleeps on a CPU of B. */
+		if (read(go[0], &c, 1) == 1 && write(ack[1], &c, 1) == 1)
+			for (;;)
+				pause();
+		_exit(1);
+	}
+	ret = KSFT_FAIL;
+	if (pid < 0)
+		goto out;
+	CPU_ZERO(&all);
+	for (i = 0; i < CPU_SETSIZE; i++)
+		CPU_SET(i, &all);
+	if (sched_setaffinity(pid, sizeof(all), &all)) {
+		ksft_print_msg("sched_setaffinity: %s\n", strerror(errno));
+		goto out;
+	}
+	c = 'x';
+	if (enter(cs_b, pid) || write(go[1], &c, 1) != 1 || read(ack[0], &c, 1) != 1) {
+		ksft_print_msg("the task never ran in B\n");
+		goto out;
+	}
+	err = set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("a deadline task refused in B: %s\n", strerror(-err));
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", a);
+	if (cs_make(cs_c, buf))
+		goto out;
+	write_file(cs_c, "cpuset.cpus.partition", "root");
+	if (!partition_has(cs_c, "invalid", 1)) {
+		ksft_print_msg("C took the last CPU of B\n");
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d,%d", a, b);
+	err = write_file(cs_b, "cpuset.cpus", buf);
+	if (err) {
+		ksft_print_msg("B cannot get CPUs %s: %s\n", buf, strerror(-err));
+		goto out;
+	}
+	if (!partition_has(cs_c, "root", 1) || partition_has(cs_c, "invalid", 0))
+		goto out;
+	snprintf(path, sizeof(path), "%s/cpuset.cpus.effective", cs_b);
+	if (read_file(path, buf, sizeof(buf)))
+		goto out;
+	buf[strcspn(buf, "\n")] = 0;
+	snprintf(path, sizeof(path), "%d", b);
+	if (strcmp(buf, path)) {
+		ksft_print_msg("B has CPUs %s, not %d\n", buf, b);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	for (i = 0; i < 2; i++) {
+		if (go[i] >= 0)
+			close(go[i]);
+		if (ack[i] >= 0)
+			close(ack[i]);
+	}
+	sleep_ns(3 * PERIOD);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * Take offline the last CPU of the top cpuset. B is a root partition of
+ * every housekeeping CPU but X, the highest one. A deadline task of 10%
+ * sleeps in B. With X offline, the top cpuset would have no CPU left, so
+ * cpuset would make every partition invalid. B's CPUs would join a new
+ * root domain, with the deadline task. That root domain did not admit it.
+ * The offline must fail with EBUSY, and B must stay valid. Once the task
+ * is gone, the offline must be accepted. The case skips if the top
+ * cpuset keeps other CPUs, such as isolated ones.
+ */
+static int hotplug_top_last_refused(void)
+{
+	int i, n = 0, err, ret = KSFT_SKIP, x = top_cpu(1), x_off = 0;
+	char buf[256], cpus[1024], path[PATH_MAX + 32];
+	int go[2] = { -1, -1 }, ack[2] = { -1, -1 };
+	pid_t pid = -1;
+	cpu_set_t all;
+	char c;
+
+	if (ncpus < 3 || !cpu_hotpluggable(x) || cs_setup())
+		return KSFT_SKIP;
+	for (i = 0; i < ncpus - 1 && n < (int)sizeof(cpus) - 16; i++)
+		n += snprintf(cpus + n, sizeof(cpus) - n, "%s%d", i ? "," : "", online[i]);
+	if (cs_make(cs_b, cpus) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "root") ||
+	    !partition_has(cs_b, "root", 1) || partition_has(cs_b, "invalid", 0))
+		goto out;
+	snprintf(path, sizeof(path), "%s/cpuset.cpus.effective", root);
+	if (read_file(path, buf, sizeof(buf)))
+		goto out;
+	buf[strcspn(buf, "\n")] = 0;
+	snprintf(cpus, sizeof(cpus), "%d", x);
+	if (strcmp(buf, cpus)) {
+		ksft_print_msg("the top cpuset keeps CPUs %s, not only %d\n", buf, x);
+		goto out;
+	}
+	if (pipe(go) || pipe(ack))
+		goto out;
+	pid = fork_child("a deadline task in B");
+	if (!pid) {
+		/* Run once in B, so that the task sleeps on a CPU of B. */
+		if (read(go[0], &c, 1) == 1 && write(ack[1], &c, 1) == 1)
+			for (;;)
+				pause();
+		_exit(1);
+	}
+	ret = KSFT_FAIL;
+	if (pid < 0)
+		goto out;
+	/* It inherits our affinity: let it have every CPU of B. */
+	CPU_ZERO(&all);
+	for (i = 0; i < CPU_SETSIZE; i++)
+		CPU_SET(i, &all);
+	if (sched_setaffinity(pid, sizeof(all), &all)) {
+		ksft_print_msg("sched_setaffinity: %s\n", strerror(errno));
+		goto out;
+	}
+	if (enter(cs_b, pid))
+		goto out;
+	c = 'x';
+	if (write(go[1], &c, 1) != 1 || read(ack[0], &c, 1) != 1) {
+		ksft_print_msg("the task never ran in B\n");
+		goto out;
+	}
+	err = set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("a deadline task refused in B: %s\n", strerror(-err));
+		goto out;
+	}
+	err = cpu_online(x, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", x,
+			       err ? strerror(-err) : "accepted");
+		x_off = !err;
+		goto out;
+	}
+	if (partition_has(cs_b, "invalid", 0)) {
+		ksft_print_msg("B became invalid\n");
+		goto out;
+	}
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	err = cpu_online(x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d with the task gone: %s\n", x,
+			       strerror(-err));
+		goto out;
+	}
+	x_off = 1;
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	for (i = 0; i < 2; i++) {
+		if (go[i] >= 0)
+			close(go[i]);
+		if (ack[i] >= 0)
+			close(ack[i]);
+	}
+	if (x_off)
+		cpu_up(x);
+	sleep_ns(3 * PERIOD);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * The same rule, when the offline makes invalid a partition that does not
+ * hold the CPU. B is a root partition of X and Y, with no task. D, in B,
+ * is a root partition of X. C, in B, is an isolated partition of Y, made
+ * after D. So B keeps no CPU of its own. The steps:
+ * 1. A task that is not a deadline task sleeps in D.
+ * 2. A task in the root cgroup runs on W. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 3. Move it asleep into C. The default root domain counts it.
+ * 4. Take X offline. D would have no CPU left, and become invalid. Its
+ *    task would then count in B, which would take Y from C. C would
+ *    become invalid. Y would leave the default root domain for that of B,
+ *    with the deadline task. That root domain did not admit it.
+ * The offline must fail with EBUSY. C must stay valid, and total_bw must
+ * not change. Once the task is gone, the offline must be accepted, and C
+ * must become invalid.
+ */
+static int hotplug_sibling_partition_refused(void)
+{
+	int fd[2] = { -1, -1 }, err, ret = KSFT_SKIP, x_off = 0;
+	long long def0, hk0, def, hk, bw;
+	char buf[64], cs_d[PATH_MAX];
+	pid_t pid = -1, other = -1;
+
+	cs_d[0] = 0;
+	if (partition_cpus() || cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d,%d", pc_x, pc_y);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "root") ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	if (snprintf(cs_d, sizeof(cs_d), "%s/d", cs_b) >= (int)sizeof(cs_d)) {
+		cs_d[0] = 0;
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", pc_x);
+	if (cs_make(cs_d, buf) ||
+	    write_file(cs_d, "cpuset.cpus.partition", "root"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", pc_y);
+	if (cs_make(cs_c, buf) ||
+	    write_file(cs_c, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_d, "root", 1) || partition_has(cs_d, "invalid", 0) ||
+	    !partition_has(cs_c, "isolated", 1) || partition_has(cs_c, "invalid", 0))
+		goto out;
+	other = fork_child("a task in D");
+	if (!other) {
+		for (;;)
+			pause();
+	}
+	if (other < 0 || enter(cs_d, other) || totals_of(pc_y, pc_w, &def0, &hk0) ||
+	    pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(pc_w, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("hotplug_sibling_partition_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(pc_y, pc_w, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_c, pid);
+	if (bw <= 0 || def != def0 || err) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in C: %s\n",
+			       def - def0, bw, strerror(-err));
+		goto out;
+	}
+	if (totals_check("in C", pc_y, pc_w, def0 + bw, hk0))
+		goto out;
+	err = cpu_online(pc_x, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", pc_x,
+			       err ? strerror(-err) : "accepted");
+		x_off = !err;
+		goto out;
+	}
+	if (partition_has(cs_c, "invalid", 0) ||
+	    totals_check("offline refused", pc_y, pc_w, def0 + bw, hk0))
+		goto out;
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	err = cpu_online(pc_x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d with the task gone: %s\n", pc_x,
+			       strerror(-err));
+		goto out;
+	}
+	x_off = 1;
+	/* The offline did make C invalid: the refusal was not too strict. */
+	if (!partition_has(cs_c, "invalid", 1)) {
+		ksft_print_msg("C stays valid with CPU %d offline\n", pc_x);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	reap(other);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	if (x_off)
+		cpu_up(pc_x);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", pc_y, pc_w, def0, hk0);
+	if (cs_d[0] && wait_for(1000, !rmdir(cs_d) || errno == ENOENT))
+		ksft_print_msg("rmdir %s: %s\n", cs_d, strerror(errno));
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A CPU of an isolated partition is in the default root domain, like the
+ * CPUs that isolcpus="domain" isolates. X and K are housekeeping CPUs: X
+ * the highest, K the lowest. I is an isolated CPU. Q is an isolated
+ * partition of X. The steps:
+ * 1. A task in the root cgroup runs on K. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 2. Move it asleep into Q. The default root domain counts it.
+ * 3. Take X offline. Q has no CPU left and becomes invalid. The task
+ *    falls back to the CPUs of the root cgroup. The isolated CPUs are
+ *    still in the default root domain.
+ * The offline must be accepted. The default root domain must go on
+ * counting the task, and the housekeeping root domain must not. Woken,
+ * the task must run on an isolated CPU.
+ */
+static int hotplug_isolated_partition_falls_back(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, i, ret = KSFT_SKIP, x_off = 0;
+	int x = ncpus >= 2 ? top_cpu(1) : -1, k = online[0], ic = nisol ? isol[0] : -1;
+	long long def0, hk0, def, hk, bw, srv;
+	uint64_t runtime, period;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (ic < 0 || x < 0 || !cpu_hotpluggable(x) || !server_found || cs_setup()) {
+		ksft_print_msg("needs isolcpus=\"domain\", 2 housekeeping CPUs, CPU hotplug, fair server files\n");
+		return KSFT_SKIP;
+	}
+	snprintf(buf, sizeof(buf), "%d", x);
+	if (cs_make(cs_q, buf) || write_file(cs_q, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_q, "isolated", 1) || partition_has(cs_q, "invalid", 0) ||
+	    totals_of(ic, k, &def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(k, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("hotplug_isolated_partition_falls_back", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(ic, k, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_q, pid);
+	if (bw <= 0 || def != def0 || err) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in Q: %s\n",
+			       def - def0, bw, strerror(-err));
+		goto out;
+	}
+	if (totals_check("in Q", ic, k, def0 + bw, hk0))
+		goto out;
+	/* The fair server of X leaves the default root domain with X. */
+	if (server_get(x, "runtime", &runtime) || server_get(x, "period", &period) || !period) {
+		ksft_print_msg("no fair server parameters for CPU %d\n", x);
+		goto out;
+	}
+	srv = (long long)((runtime << 20) / period);	/* as to_ratio() */
+	err = cpu_online(x, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d: %s\n", x, strerror(-err));
+		goto out;
+	}
+	x_off = 1;
+	if (totals_check("X offline", ic, k, def0 + bw - srv, hk0) || fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	for (i = 0; i < nisol && isol[i] != cpu; i++)
+		;
+	if (i == nisol) {
+		ksft_print_msg("woken on CPU %d, not an isolated CPU\n", cpu);
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	if (x_off)
+		cpu_up(x);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", ic, k, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A dead task runs no more, so it cannot leave its root domain. The CPUs
+ * are those of fallback_case(). B is a cpuset of I1, I2 and H, not a
+ * partition. The steps:
+ * 1. A task in the root cgroup runs on H. Then it allows every CPU and
+ *    becomes a deadline task of 100ms every 1s. It sleeps.
+ * 2. Move it asleep into B. It keeps H. The housekeeping root domain
+ *    counts it.
+ * 3. Wake it. It spins 90ms and exits. The case does not reap it. Its
+ *    0-lag time is about 800ms ahead.
+ * 4. Take H offline. Once H is offline, the dead task would have no CPU
+ *    in the root domain that counts it. That does not matter: it never
+ *    runs again.
+ * The offline must be accepted. The case then reaps the task and brings
+ * H back. Past the 0-lag time, total_bw must be what it was.
+ *
+ * The case depends on time: it skips if the task takes more than 500ms
+ * to show as a zombie.
+ */
+static int hotplug_dead_accepted(void)
+{
+	int fd[2] = { -1, -1 }, err, cpu, ret = KSFT_SKIP, ran = 0;
+	long long def0, hk0, def, hk;
+	uint64_t t;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (fallback_cpus(0) || !cpu_hotpluggable(fb_h)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs, hotplug\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d,%d,%d", fb_i1, fb_i2, fb_h);
+	if (cs_make(cs_b, buf) || fallback_totals(&def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(fb_h, 1, 100 * NSEC_PER_MSEC, NSEC_PER_SEC, fd[0]);
+	ran = pid >= 0;
+	if (pid < 0 || child_up("hotplug_dead_accepted", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S'))
+		goto out;
+	err = enter(cs_b, pid);
+	if (err) {
+		ksft_print_msg("a move into B refused: %s\n", strerror(-err));
+		goto out;
+	}
+	if (fallback_totals(&def, &hk))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h || def != def0 || hk <= hk0) {
+		ksft_print_msg("in B on CPU %d: total_bw %lld, %lld\n", cpu, def, hk);
+		goto out;
+	}
+	if (write(fd[1], "x", 1) != 1) {
+		ksft_print_msg("write to the deadline task: %s\n", strerror(errno));
+		goto out;
+	}
+	t = now_ns();
+	if (wait_for(1000, proc_state_of(pid) == 'Z'))
+		goto out;
+	if (now_ns() - t > 500 * NSEC_PER_MSEC) {
+		ksft_print_msg("the task took over 500ms to exit\n");
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	sleep_ns(10 * NSEC_PER_MSEC);		/* past do_task_dead() */
+	err = cpu_online(fb_h, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d under a dead task: %s\n", fb_h,
+			       strerror(-err));
+		goto out;
+	}
+	reap(pid);
+	pid = -1;
+	cpu_up(fb_h);
+	sleep_ns(NSEC_PER_SEC);			/* past the 0-lag time */
+	ran = 0;
+	ret = totals_check("task gone", fb_i2, fb_h, def0, hk0);
+out:
+	reap(pid);
+	cpu_up(fb_h);
+	/* Let the next case start after the 0-lag time of the task. */
+	if (ran)
+		sleep_ns(NSEC_PER_SEC);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A cpuset that loses all its CPUs takes them from its parent, through
+ * its own cpuset.cpus. The CPUs are those of fallback_case(). The steps:
+ * 1. B, in the root cgroup, has cpuset.cpus H. C, in B, has cpuset.cpus
+ *    I2. I2 is not in B, so C gets H.
+ * 2. A task in the root cgroup runs on H. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 3. Move it asleep into C. It keeps H.
+ * 4. Q, in the root cgroup, has cpuset.cpus H. Make it a partition root.
+ *    B would then get the CPUs of the root cgroup, and C would get I2
+ *    of them. The task would have no CPU in the root domain that counts
+ *    it.
+ * Q must be an invalid partition root, for the deadline task. Wake the
+ * task: it must run on H, and the housekeeping root domain must count it.
+ */
+static int partition_takes_fallback_refused(void)
+{
+	int fd[2] = { -1, -1 }, cpu, err, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (fallback_cpus(0)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d", fb_h);
+	if (cs_make(cs_b, buf) || write_file(cs_b, "cgroup.subtree_control", "+cpuset"))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", fb_i2);
+	if (cs_make(cs_c, buf) || fallback_totals(&def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(fb_h, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("partition_takes_fallback_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || fallback_totals(&def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_c, pid);
+	cpu = task_cpu_of(pid);
+	if (bw <= 0 || def != def0 || err || cpu != fb_h) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in C: %s, on CPU %d\n",
+			       def - def0, bw, strerror(-err), cpu);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", fb_h);
+	if (cs_make(cs_q, buf))
+		goto out;
+	write_file(cs_q, "cpuset.cpus.partition", "root");
+	if (!partition_has(cs_q, "Deadline task", 1) ||
+	    fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, fb_h);
+		goto out;
+	}
+	ret = totals_check("woken", fb_i2, fb_h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", fb_i2, fb_h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A mask that grows can still take a task out of its root domain. That
+ * happens if the user affinity of the task holds only the new CPUs.
+ * The CPUs: I1 is isolated by isolcpus="domain", H is the first
+ * housekeeping CPU. The steps:
+ * 1. Q is a partition root of the other housekeeping CPUs. The
+ *    housekeeping root domain of the root cgroup then has H only.
+ * 2. B, in the root cgroup, is a cpuset of H and I1. A task enters B. It
+ *    sets its affinity to I1, and runs there. It is not a deadline task.
+ * 3. Give B the CPU H only. The task gets H: its affinity holds no CPU of
+ *    B. Wake it: it runs on H.
+ * 4. The task becomes a deadline task of 10%. Its mask holds the whole
+ *    housekeeping root domain of the root cgroup, H. That root domain
+ *    counts it. It sleeps.
+ * 5. Give B the CPUs H and I1 again. The task would then get I1 only, its
+ *    affinity, in another root domain.
+ * The write of step 5 must fail with EBUSY. Wake the task: it must run on
+ * H, and the housekeeping root domain must count it.
+ */
+static int mask_grows_refused(void)
+{
+	int h = online[0], i1 = nisol ? isol[0] : -1, fd[2] = { -1, -1 };
+	int i, n = 0, err, cpu, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[4096];
+	pid_t pid = -1;
+
+	if (i1 < 0) {
+		ksft_print_msg("needs CPUs isolated by isolcpus=domain\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	for (i = 1; i < ncpus && n < (int)sizeof(buf); i++)
+		n += snprintf(buf + n, sizeof(buf) - n, "%s%d", i > 1 ? "," : "", online[i]);
+	if (n >= (int)sizeof(buf) || make_partition_cpus(cs_q, buf)) {
+		ksft_print_msg("no partition root Q of CPUs %s\n", buf);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d,%d", h, i1);
+	if (cs_make(cs_b, buf) || totals_of(i1, h, &def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a task with an affinity");
+	if (!pid) {
+		cpu_set_t set;
+		char c;
+
+		CPU_ZERO(&set);
+		CPU_SET(i1, &set);
+		if (enter(cs_b, getpid()) || sched_setaffinity(0, sizeof(set), &set)) {
+			mv_state[1] = -1;
+			_exit(1);
+		}
+		spin_ns(NSEC_PER_MSEC);
+		mv_state[1] = 1;
+		/* Wait for B of H only. Run there, and become a deadline task. */
+		if (read(fd[0], &c, 1) != 1)
+			_exit(1);
+		spin_ns(NSEC_PER_MSEC);
+		if (set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		while (read(fd[0], &c, 1) == 1)
+			mv_state[1]++;
+		_exit(0);
+	}
+	if (pid < 0 || wait_for(1000, mv_state[1]) || mv_state[1] != 1 ||
+	    wait_for(1000, proc_state_of(pid) == 'S')) {
+		ksft_print_msg("the task cannot take CPU %d\n", i1);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", h);
+	err = write_file(cs_b, "cpuset.cpus", buf);
+	if (err) {
+		ksft_print_msg("B given CPU %d only: %s\n", h, strerror(-err));
+		goto out;
+	}
+	mv_state[1] = 0;
+	if (write(fd[1], "d", 1) != 1 || child_up("mask_grows_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(i1, h, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	cpu = task_cpu_of(pid);
+	if (bw <= 0 || def != def0 || cpu != h) {
+		ksft_print_msg("a deadline task on CPU %d adds %lld, %lld to total_bw\n",
+			       cpu, def - def0, bw);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d,%d", h, i1);
+	err = write_file(cs_b, "cpuset.cpus", buf);
+	if (err != -EBUSY) {
+		ksft_print_msg("B given CPUs %s: %s, not EBUSY\n", buf,
+			       err ? strerror(-err) : "accepted");
+		if (!err && !fallback_wake(fd[1], pid))
+			ksft_print_msg("woken on CPU %d\n", task_cpu_of(pid));
+		goto out;
+	}
+	if (fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, h);
+		goto out;
+	}
+	ret = totals_check("woken", i1, h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", i1, h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * One write to cpuset.cpus can make a partition root take CPUs and give
+ * others back. The CPUs: I1 is isolated by isolcpus="domain". H is a
+ * housekeeping CPU. The steps:
+ * 1. Q is an isolated partition root of I1.
+ * 2. B, in the root cgroup, has cpuset.cpus H and I1. Q holds I1, so B
+ *    gets H.
+ * 3. A task in the root cgroup runs on H. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 4. Move it asleep into B. It keeps H.
+ * 5. Write H to the cpuset.cpus of Q. Q would take H and give I1 back. B
+ *    would then get I1 only, in another root domain.
+ * Q must become an invalid partition root, for the deadline task. Wake
+ * the task: it must run on H, and the housekeeping root domain must count
+ * it.
+ */
+static int partition_swap_refused(void)
+{
+	int h = online[ncpus - 1], i1 = nisol ? isol[0] : -1, fd[2] = { -1, -1 };
+	int cpu, err, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (i1 < 0) {
+		ksft_print_msg("needs CPUs isolated by isolcpus=domain\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d", i1);
+	if (cs_make(cs_q, buf) || write_file(cs_q, "cpuset.cpus.partition", "isolated") ||
+	    !partition_has(cs_q, "isolated", 1) || partition_has(cs_q, "invalid", 0)) {
+		ksft_print_msg("no isolated partition Q of CPU %d\n", i1);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d,%d", h, i1);
+	if (cs_make(cs_b, buf) || totals_of(i1, h, &def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(h, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("partition_swap_refused", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || totals_of(i1, h, &def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_b, pid);
+	cpu = task_cpu_of(pid);
+	if (bw <= 0 || def != def0 || err || cpu != h) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in B: %s, on CPU %d\n",
+			       def - def0, bw, strerror(-err), cpu);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d", h);
+	write_file(cs_q, "cpuset.cpus", buf);
+	if (!partition_has(cs_q, "Deadline task", 1) || fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, h);
+		goto out;
+	}
+	ret = totals_check("woken", i1, h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", i1, h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/* Return the taint flags of the kernel, or -1. */
+static long taint_flags(void)
+{
+	char buf[64];
+
+	if (read_file("/proc/sys/kernel/tainted", buf, sizeof(buf)))
+		return -1;
+	return atol(buf);
+}
+
+#define TAINT_WARN	(1L << 9)
+
+/*
+ * An invalid partition root holds no CPU of its parent. A refusal must
+ * not give any back. The CPUs are those of fallback_case(). B is a cpuset
+ * of I1, I2 and H, not a partition. The steps:
+ * 1. A task in the root cgroup runs on H. Then it allows every CPU and
+ *    becomes a deadline task of 10%. It sleeps. The housekeeping root
+ *    domain counts it.
+ * 2. Move it asleep into B. It keeps H.
+ * 3. Q, in the root cgroup, has cpuset.cpus H and K. Its
+ *    cpuset.cpus.exclusive is H. Make it a partition root. It would take H,
+ *    the only housekeeping CPU of B. Q must be invalid, for the deadline
+ *    task.
+ * 4. Write H to the cpuset.cpus of Q. The same check refuses again.
+ * The kernel must not warn: the taint flag W must stay clear. Q must
+ * still be invalid for the deadline task. The case skips if the flag
+ * was set before.
+ */
+static int partition_refused_no_warn(void)
+{
+	int fd[2] = { -1, -1 }, cpu, err, ret = KSFT_SKIP;
+	long long def0, hk0, def, hk, bw;
+	char buf[64];
+	pid_t pid = -1;
+
+	if (fallback_cpus(0)) {
+		ksft_print_msg("needs isolcpus=domain: 2 isolated, 2 housekeeping CPUs\n");
+		return KSFT_SKIP;
+	}
+	if (taint_flags() < 0 || (taint_flags() & TAINT_WARN)) {
+		ksft_print_msg("the kernel has warned already\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	snprintf(buf, sizeof(buf), "%d,%d,%d", fb_i1, fb_i2, fb_h);
+	if (cs_make(cs_b, buf) || fallback_totals(&def0, &hk0) || pipe(fd))
+		goto out;
+	ret = KSFT_FAIL;
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(fb_h, 1, 10 * NSEC_PER_MSEC, PERIOD, fd[0]);
+	if (pid < 0 || child_up("partition_refused_no_warn", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S') || fallback_totals(&def, &hk))
+		goto out;
+	bw = hk - hk0;
+	err = enter(cs_b, pid);
+	cpu = task_cpu_of(pid);
+	if (bw <= 0 || def != def0 || err || cpu != fb_h) {
+		ksft_print_msg("a deadline task adds %lld, %lld to total_bw, in B: %s, on CPU %d\n",
+			       def - def0, bw, strerror(-err), cpu);
+		goto out;
+	}
+	snprintf(buf, sizeof(buf), "%d,%d", fb_h, fb_k);
+	if (cs_make(cs_q, buf))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", fb_h);
+	if (write_file(cs_q, "cpuset.cpus.exclusive", buf)) {
+		ksft_print_msg("Q cannot have CPU %d exclusive\n", fb_h);
+		goto out;
+	}
+	write_file(cs_q, "cpuset.cpus.partition", "root");
+	if (!partition_has(cs_q, "Deadline task", 1))
+		goto out;
+	write_file(cs_q, "cpuset.cpus", buf);
+	if (taint_flags() & TAINT_WARN) {
+		ksft_print_msg("Q given CPU %d: the kernel warned\n", fb_h);
+		goto out;
+	}
+	if (!partition_has(cs_q, "Deadline task", 1) || fallback_wake(fd[1], pid))
+		goto out;
+	cpu = task_cpu_of(pid);
+	if (cpu != fb_h) {
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, fb_h);
+		goto out;
+	}
+	ret = totals_check("woken", fb_i2, fb_h, def0, hk0 + bw);
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS)
+		ret = totals_check("task gone", fb_i2, fb_h, def0, hk0);
+	cs_cleanup();
+	return ret;
+}
+
+/*
+ * A rebuild must count a task where its cpuset lets it run. The kernel
+ * records, with the bandwidth of a task, a CPU of the root domain that
+ * counts it. A partition root can take that CPU later. A, B and D are the
+ * three highest housekeeping CPUs. C is the first one. Q is a partition
+ * root of the other housekeeping CPUs, C among them. The steps:
+ * 1. Take D offline. The housekeeping root domain then has A and B only.
+ * 2. A task in the root cgroup sets its affinity to A and B. It becomes a
+ *    deadline task of 10% and sleeps. Bring D back online. The task keeps
+ *    its affinity.
+ * 3. Take A and B offline. No CPU of the task's mask is active. Its
+ *    cpuset gives it D, so the rebuild counts it on D. D is recorded.
+ * 4. Make Q a member, then a partition root of D instead of C. The
+ *    cpuset of the task now gives it C. Its mask is still A and B.
+ * Q must not count the task. The root domain of C must count it. Wake
+ * the task: it must run on C, and total_bw must not change.
+ *
+ * The references of total_bw are taken once the task is gone, with the
+ * CPUs as in step 4.
+ */
+static int rebuild_record_taken(void)
+{
+	int a = top_cpu(3), b = top_cpu(2), c = online[0], d = top_cpu(1);
+	int fd[2] = { -1, -1 }, i, n, err, cpu, ret = KSFT_SKIP;
+	long long q, h, q0, h0, bw;
+	char buf[4096];
+	pid_t pid = -1;
+
+	if (ncpus < 4 || !cpu_hotpluggable(a) || !cpu_hotpluggable(b) ||
+	    !cpu_hotpluggable(d)) {
+		ksft_print_msg("needs 4 CPUs, 3 of them hotpluggable\n");
+		return KSFT_SKIP;
+	}
+	if (cs_setup())
+		return KSFT_SKIP;
+	/* Q has every housekeeping CPU but A, B and D. */
+	for (i = n = 0; i < ncpus - 3; i++)
+		n += snprintf(buf + n, sizeof(buf) - n, "%s%d", n ? "," : "",
+			      online[i]);
+	if (make_partition_cpus(cs_q, buf)) {
+		ksft_print_msg("Q cannot be a partition root of CPUs %s\n", buf);
+		goto out;
+	}
+	ret = KSFT_FAIL;
+	err = cpu_online(d, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d: %s\n", d, strerror(-err));
+		goto out;
+	}
+	bw = total_bw_of(a);
+	if (bw == -1) {
+		ksft_print_msg("no total_bw in /sys/kernel/debug/sched/debug\n");
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		goto out;
+	}
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = fork_child("a deadline task");
+	if (!pid) {
+		cpu_set_t set;
+		char ch;
+
+		CPU_ZERO(&set);
+		CPU_SET(a, &set);
+		CPU_SET(b, &set);
+		if (sched_setaffinity(0, sizeof(set), &set) ||
+		    set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		while (read(fd[0], &ch, 1) == 1)
+			mv_state[1]++;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("rebuild_record_taken", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S'))
+		goto out;
+	bw = total_bw_of(a) - bw;
+	if (bw <= 0) {
+		ksft_print_msg("the deadline task adds %lld to total_bw\n", bw);
+		goto out;
+	}
+	err = cpu_online(d, 1);
+	if (!err)
+		err = cpu_online(a, 0);
+	if (!err)
+		err = cpu_online(b, 0);
+	if (err) {
+		ksft_print_msg("hotplug of CPUs %d, %d, %d: %s\n", d, a, b,
+			       strerror(-err));
+		goto out;
+	}
+	/*
+	 * Q has D and every CPU it had but C. One write of cpuset.cpus
+	 * would make Q an invalid partition root: the check sees the root
+	 * cgroup lose D, and get C back too late.
+	 */
+	for (i = 1, n = 0; i < ncpus - 3; i++)
+		n += snprintf(buf + n, sizeof(buf) - n, "%d,", online[i]);
+	snprintf(buf + n, sizeof(buf) - n, "%d", d);
+	err = write_file(cs_q, "cpuset.cpus.partition", "member");
+	if (err || make_partition_cpus(cs_q, buf)) {
+		ksft_print_msg("Q cannot be a partition root of CPUs %s\n", buf);
+		partition_has(cs_q, "root\n", 1);
+		goto out;
+	}
+	q = total_bw_of(d);
+	h = total_bw_of(c);
+	if (fallback_wake(fd[1], pid))
+		goto out;
+	/* Go on after a failure: the totals tell more. */
+	cpu = task_cpu_of(pid);
+	if (cpu != c)
+		ksft_print_msg("woken on CPU %d, not %d\n", cpu, c);
+	else if (!totals_check("woken", d, c, q, h))
+		ret = KSFT_PASS;
+	reap(pid);
+	pid = -1;
+	sleep_ns(3 * PERIOD);
+	if (totals_of(d, c, &q0, &h0)) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (q != q0 || h != h0 + bw) {
+		ksft_print_msg("Q counts %lld of %lld, the root cgroup %lld\n",
+			       q - q0, bw, h - h0);
+		ret = KSFT_FAIL;
+	}
+out:
+	reap(pid);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	cpu_up(a);
+	cpu_up(b);
+	cpu_up(d);
+	cs_cleanup();
+	return ret;
+}
+
 /* Moves between two root domains, from the main process, with P */
 
 /*
@@ -7950,6 +10274,259 @@ static const struct p_case {
 
 #define N_P_CASES	((int)ARRAY_SIZE(p_cases))
 
+/*
+ * A fair task asleep on a CPU that goes offline is still on that CPU. In
+ * the root cgroup, its mask still holds that CPU. sched_setattr() must admit
+ * the task in the root domain of an active CPU of its mask. The steps:
+ * 1. A task in the root cgroup runs on hp_cpu, then allows every CPU and
+ *    sleeps.
+ * 2. Take hp_cpu offline.
+ * 3. Make the task a deadline task of 10ms every 100ms.
+ * The change must be accepted. Without isolcpus=domain, the root domain
+ * of the offline CPU has no active CPU, and would refuse it with EBUSY.
+ */
+static int hotplug_asleep_setattr(void)
+{
+	int fd[2], err, ret = KSFT_FAIL, off = 0;
+	pid_t pid;
+
+	if (hp_cpu < 0)
+		return KSFT_SKIP;
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	pid = fork_child("a task asleep on a CPU going offline");
+	if (!pid) {
+		cpu_set_t one, all;
+		char c;
+
+		CPU_ZERO(&one);
+		CPU_SET(hp_cpu, &one);
+		if (sched_getaffinity(0, sizeof(all), &all) ||
+		    sched_setaffinity(0, sizeof(one), &one))
+			_exit(1);
+		spin_ns(NSEC_PER_MSEC);
+		if (sched_setaffinity(0, sizeof(all), &all))
+			_exit(1);
+		if (read(fd[0], &c, 1) != 1)
+			_exit(1);
+		_exit(0);
+	}
+	if (pid < 0)
+		goto out;
+	if (wait_for(1000, proc_state_of(pid) == 'S' && task_cpu_of(pid) == hp_cpu)) {
+		ksft_print_msg("the task is not asleep on CPU %d\n", hp_cpu);
+		goto out;
+	}
+	err = cpu_online(hp_cpu, 0);
+	if (err) {
+		ksft_print_msg("offline of CPU %d: %s\n", hp_cpu, strerror(-err));
+		goto out;
+	}
+	off = 1;
+	err = set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("sched_setattr() of the task asleep on offline CPU %d: %s\n",
+			       hp_cpu, strerror(-err));
+		goto out;
+	}
+	ret = KSFT_PASS;
+	if (set_other(pid))
+		ksft_print_msg("the task cannot leave SCHED_DEADLINE\n");
+out:
+	reap(pid);
+	close(fd[0]);
+	close(fd[1]);
+	if (off)
+		cpu_up(hp_cpu);
+	return ret;
+}
+
+/* The child cpusets that a cascade case made, the deepest last. */
+static char cc_sub[4][PATH_MAX];
+static int cc_n;
+
+/*
+ * Make the child cpuset @name of @parent, with cpuset.cpus @cpus, and make
+ * it a partition of type @prs. Return its path, or NULL.
+ */
+static const char *cc_make(const char *parent, const char *name, const char *cpus,
+			   const char *prs)
+{
+	char *cg = cc_sub[cc_n];
+
+	if (cc_n >= 4 ||
+	    snprintf(cg, PATH_MAX, "%s/%s", parent, name) >= PATH_MAX)
+		return NULL;
+	cc_n++;
+	if (cs_make(cg, cpus))
+		return NULL;
+	if (write_file(cg, "cpuset.cpus.partition", prs) ||
+	    !partition_has(cg, prs, 1) || partition_has(cg, "invalid", 0))
+		return NULL;
+	return cg;
+}
+
+/* Remove the child cpusets of a cascade case, the deepest first. */
+static void cc_cleanup(void)
+{
+	while (cc_n > 0)
+		remove_partition(cc_sub[--cc_n]);
+}
+
+/*
+ * Start a deadline task of 10% in the root cgroup on W, asleep, and move
+ * it into @cg. Return its pid, or -1.
+ */
+static pid_t cc_dl_task(const char *cg, int fd)
+{
+	pid_t pid;
+	int err;
+
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = task_from(pc_w, 1, 10 * NSEC_PER_MSEC, PERIOD, fd);
+	if (pid < 0 || child_up("a cascade case", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S'))
+		return pid < 0 ? -1 : (reap(pid), -1);
+	err = enter(cg, pid);
+	if (err) {
+		ksft_print_msg("a move into %s refused: %s\n", cg, strerror(-err));
+		reap(pid);
+		return -1;
+	}
+	return pid;
+}
+
+/* Start a task that is not a deadline task, asleep in @cg. Return its pid, or -1. */
+static pid_t cc_fair_task(const char *cg)
+{
+	pid_t pid = fork_child("a task that is not a deadline task");
+
+	if (!pid) {
+		for (;;)
+			pause();
+	}
+	if (pid > 0 && enter(cg, pid)) {
+		reap(pid);
+		return -1;
+	}
+	return pid;
+}
+
+enum { CC_FIRST, CC_NESTED, CC_ISOLATED };
+
+/*
+ * Run a cascade case of @kind: the offline of X makes a partition
+ * invalid, and cpuset then takes the CPUs of another partition. B is a
+ * root partition with no task, whose CPUs all go to child partitions.
+ * Its child G, made first, holds X. The offline of X leaves the
+ * partition that holds X with tasks and no CPU: G, or the child of G
+ * with CC_NESTED. cpuset makes that partition invalid. Its tasks then
+ * count in its parent. What the hotplug walk then does depends on the
+ * order of the children:
+ * - CC_FIRST: G is a root partition with a task that is not a deadline
+ *   task. S1, an isolated partition of Y, holds a deadline task. S2 is an
+ *   isolated partition of Z. B now holds the task of G and has no CPU. It
+ *   takes Y from S1, the first child after G. The deadline task of S1
+ *   would leave the default root domain.
+ * - CC_NESTED: G is a root partition of X with a child root partition of
+ *   X, which holds a task that is not a deadline task. S, an isolated
+ *   partition of Y and Z, holds a deadline task. The child of G becomes
+ *   invalid. G is visited before it, so G stays valid, with tasks and no
+ *   CPU. The next hotplug event makes G invalid, then S: the deadline
+ *   task of S would leave the default root domain.
+ * - CC_ISOLATED: B has X and Y. G is an isolated partition of X with a
+ *   deadline task and a task that is not one. S2 is an isolated partition
+ *   of Y. B takes Y from S2. The deadline task of G would leave the
+ *   default root domain.
+ * The offline must fail with EBUSY.
+ */
+static int cascade_case(int kind)
+{
+	const char *g, *s = NULL, *s2 = NULL, *gc = NULL;
+	int fd[2] = { -1, -1 }, err, ret = KSFT_SKIP, x_off = 0;
+	pid_t dl = -1, fair = -1;
+	char buf[64];
+
+	cc_n = 0;
+	if (partition_cpus() || cs_setup())
+		return KSFT_SKIP;
+	if (kind == CC_ISOLATED)
+		snprintf(buf, sizeof(buf), "%d,%d", pc_x, pc_y);
+	else
+		snprintf(buf, sizeof(buf), "%d,%d,%d", pc_x, pc_y, pc_z);
+	if (cs_make(cs_b, buf) ||
+	    write_file(cs_b, "cpuset.cpus.partition", "root") ||
+	    write_file(cs_b, "cgroup.subtree_control", "+cpuset") || pipe(fd))
+		goto out;
+	snprintf(buf, sizeof(buf), "%d", pc_x);
+	g = cc_make(cs_b, "g", buf, kind == CC_ISOLATED ? "isolated" : "root");
+	if (!g)
+		goto out;
+	if (kind == CC_NESTED) {
+		if (write_file(g, "cgroup.subtree_control", "+cpuset"))
+			goto out;
+		gc = cc_make(g, "gc", buf, "root");
+		snprintf(buf, sizeof(buf), "%d,%d", pc_y, pc_z);
+		s = gc ? cc_make(cs_b, "s", buf, "isolated") : NULL;
+	} else {
+		snprintf(buf, sizeof(buf), "%d", pc_y);
+		s = cc_make(cs_b, kind == CC_FIRST ? "s1" : "s2", buf, "isolated");
+		if (s && kind == CC_FIRST) {
+			snprintf(buf, sizeof(buf), "%d", pc_z);
+			s2 = cc_make(cs_b, "s2", buf, "isolated");
+		}
+	}
+	if (!s || (kind == CC_FIRST && !s2))
+		goto out;
+	ret = KSFT_FAIL;
+	fair = cc_fair_task(kind == CC_NESTED ? gc : g);
+	dl = fair < 0 ? -1 : cc_dl_task(kind == CC_ISOLATED ? g : s, fd[0]);
+	if (dl < 0)
+		goto out;
+	err = cpu_online(pc_x, 0);
+	if (err != -EBUSY) {
+		ksft_print_msg("offline of CPU %d: %s, not EBUSY\n", pc_x,
+			       err ? strerror(-err) : "accepted");
+		x_off = !err;
+		goto out;
+	}
+	ret = KSFT_PASS;
+out:
+	reap(dl);
+	reap(fair);
+	if (fd[0] >= 0) {
+		close(fd[0]);
+		close(fd[1]);
+	}
+	if (x_off)
+		cpu_up(pc_x);
+	sleep_ns(3 * PERIOD);
+	cc_cleanup();
+	cs_cleanup();
+	return ret;
+}
+
+/* The CC_FIRST kind of cascade_case() */
+static int hotplug_first_sibling_refused(void)
+{
+	return cascade_case(CC_FIRST);
+}
+
+/* The CC_NESTED kind of cascade_case() */
+static int hotplug_nested_partition_refused(void)
+{
+	return cascade_case(CC_NESTED);
+}
+
+/* The CC_ISOLATED kind of cascade_case() */
+static int hotplug_isolated_child_refused(void)
+{
+	return cascade_case(CC_ISOLATED);
+}
+
 static const struct hp_case {
 	const char *name;
 	int (*fn)(void);
@@ -7961,8 +10538,40 @@ static const struct hp_case {
 	{ "hotplug_refused", hotplug_refused },
 	{ "hotplug_departed", hotplug_departed },
 	{ "hotplug_server", hotplug_server },
+	{ "hotplug_server_refused", hotplug_server_refused },
+	{ "hotplug_fallback", hotplug_fallback },
+	{ "hotplug_fallback_running", hotplug_fallback_running },
+	{ "hotplug_fallback_moved", hotplug_fallback_moved },
+	{ "hotplug_fallback_in_mask", hotplug_fallback_in_mask },
+	{ "mask_out_refused", mask_out_refused, 1 },
+	{ "hotplug_last_refused", hotplug_last_refused },
+	{ "hotplug_keeps_root_domain", hotplug_keeps_root_domain },
+	{ "partition_takes_refused", partition_takes_refused, 1 },
+	{ "no_admission_affinity_moves", no_admission_affinity_moves, 1 },
 	{ "affinity_vs_setattr", affinity_vs_setattr, 1 },
 	{ "move_back_cpu_offline", move_back_cpu_offline },
+	{ "hotplug_spinner_keeps", hotplug_spinner_keeps },
+	{ "hotplug_waking_keeps", hotplug_waking_keeps },
+	{ "hotplug_isolated_keeps", hotplug_isolated_keeps },
+	{ "rebuild_waking_keeps", rebuild_waking_keeps, 1 },
+	{ "hotplug_user_mask_refused", hotplug_user_mask_refused },
+	{ "hotplug_nested_refused", hotplug_nested_refused },
+	{ "hotplug_dead_accepted", hotplug_dead_accepted },
+	{ "hotplug_child_partition_kept", hotplug_child_partition_kept },
+	{ "hotplug_partition_invalid_refused", hotplug_partition_invalid_refused },
+	{ "hotplug_sibling_partition_refused", hotplug_sibling_partition_refused },
+	{ "hotplug_top_last_refused", hotplug_top_last_refused },
+	{ "partition_grows_child_valid", partition_grows_child_valid, 1 },
+	{ "hotplug_asleep_setattr", hotplug_asleep_setattr },
+	{ "hotplug_first_sibling_refused", hotplug_first_sibling_refused },
+	{ "hotplug_nested_partition_refused", hotplug_nested_partition_refused },
+	{ "hotplug_isolated_child_refused", hotplug_isolated_child_refused },
+	{ "hotplug_isolated_partition_falls_back", hotplug_isolated_partition_falls_back },
+	{ "partition_takes_fallback_refused", partition_takes_fallback_refused, 1 },
+	{ "mask_grows_refused", mask_grows_refused, 1 },
+	{ "partition_swap_refused", partition_swap_refused, 1 },
+	{ "partition_refused_no_warn", partition_refused_no_warn, 1 },
+	{ "rebuild_record_taken", rebuild_record_taken },
 };
 
 #define N_HP_CASES	((int)ARRAY_SIZE(hp_cases))
-- 
2.47.3

