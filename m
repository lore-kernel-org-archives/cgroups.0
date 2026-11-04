Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826736;
	b=xqYp2A77gHTyUZzKgvIyJNMb6hQKIEGXl9EXSZ6bsWIaoJcOxDgn9U3YP+b7qXGaoINl
	 dkqfr+vV/eTdMkueo/6d/Ll4MIJP10LX0z+g+cEjYq6HwM8aljHhwQ8ummXgjdSJLKFAC
	 MLQiRgCdM4enV8bL4IF3s23rYXAiwlkoJPA5670m++J2cbs75gi5BkBmCtC99kMyOPDdH
	 ymSX/V+ZRmQDjIPf6N6U3Vwm8rh853DJZZEIL4MwiGuDzeJgV5eo1/M8J4+D3tS5FiS+j
	 YSfYbjzWTggNFxRYjeX6RnuyH0XiDGaVgHVS1D7620LCh6LreDLjJ0ROLsn0L437uFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826736;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OpTdcf808StUyODW+2gsKmPcAeI29oZdFAWuai+TIrU=;
	b=q76NWDPKg8qSEaZOzDBWDf7kQuLRcrZKbhHEb46zhyQj/KJLXzpgzBURcWjbnDGcoVhW
	 O/kG0zEcvukSnIE8ZIaNl7OM9DuLctsWArBxkZXgugCNjfA8OSWDdAt0eIiQF+eTeSAhI
	 gwUspMZRJK/T4ZbOOVHY1Hn1359HIpNSeMWuyIypqdYz3V0WijRYHfiualyDrx667auzl
	 1HfNvwflpkkAKsE8WulWvXPZ4TcMKdoXYjPiaLFL/+KSWkScTM2KOO+qAHQ0PRhJ+grT9
	 LlaSh61DJFJY0kFSFD2N5yPcyGKEiB4baoax/RFXyVtCG6F3lpgI2ungkxVtpxc4HtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=hswg82AD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DB8608176D;
	Wed,  4 Nov 2026 21:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24DB8608176D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=hswg82AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826733;
	bh=OpTdcf808StUyODW+2gsKmPcAeI29oZdFAWuai+TIrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hswg82ADIK+XUrZSwqVYhR7aXfCo6Z1YhT7vNKa3+vHuE2JFEnRBKXg0bu/vS07dc
	 lhh9mQJZz7jRgzxzqIcgWSuDefK2B0UekXcG4vhrrOkw9J67KMXGgAcLsqlz7ynXMx
	 d5lwa6KNMI/WMQQ8kZyr52bVZsk/6aIq8M33NIRSn6QyfP+SBckYIFKT37NRDtMlNK
	 w5XzxDmpACMatNGSOZI0zjnbYUpURtIlzGrpjgeiVvFWvEbmqPb1yq6bNnRbqyx32R
	 olF2yiuQZh+QQtOUmB38wwZzhXaq3aQ2GPRnQz2zbNQDkJ4fA4ef4KohovkJIQbin8
	 fbWRGZPJxg9Yw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRx5hbfzLXW;
	Wed, 04 Nov 2026 16:12:13 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 08/21] selftests/sched: Add a test of SCHED_DEADLINE policy round trips
Date: Wed,  4 Nov 2026 16:11:54 -0500
Message-Id: <20261104211207.1392343-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

Add deadline_switch_test, with a case for the fix two patches back and
one for commit 41a7968022ca ("sched/deadline: Fix total_bw leak when
switching away from SCHED_DEADLINE while !queued"):

 - throttled_round_trip: a task with a runtime of 10ms per 2s period
   spins, so that each replenishment throttles it again at once. Right
   after a throttle it is switched to SCHED_OTHER, and back 200us after
   its deadline: past its replenishment timer, and before its 0-lag
   time, which the overrun scaled by 200 puts later. It must run again
   within a period and a half. Three attempts;
 - asleep_round_trip: a task of 9ms every 10ms, running 0.2ms and
   sleeping 50ms, is switched to SCHED_OTHER and back while it sleeps
   past its 0-lag time, enough times that a leak of its bandwidth at
   each round trip fills the root domain: sched_setattr() then fails
   with EBUSY. Skipped without admission control (sched_rt_runtime_us
   at -1). A kernel that leaks is left without SCHED_DEADLINE bandwidth
   until a reboot, so this case runs last.

In 8 VMs of 8 vCPUs each, v7.3 fails both cases, and v7.4-rc1 with the
four deadline fixes of sched/urgent fails the first; with the two
previous patches as well both pass; every time.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/sched/.gitignore      |   1 +
 tools/testing/selftests/sched/Makefile        |   1 +
 .../selftests/sched/deadline_switch_test.c    | 332 ++++++++++++++++++
 3 files changed, 334 insertions(+)
 create mode 100644 tools/testing/selftests/sched/deadline_switch_test.c

diff --git a/tools/testing/selftests/sched/.gitignore b/tools/testing/selftests/sched/.gitignore
index 6996d4654d92..d97f40c21ab5 100644
--- a/tools/testing/selftests/sched/.gitignore
+++ b/tools/testing/selftests/sched/.gitignore
@@ -1 +1,2 @@
 cs_prctl_test
+deadline_switch_test
diff --git a/tools/testing/selftests/sched/Makefile b/tools/testing/selftests/sched/Makefile
index 099ee9213557..ae9421eabf15 100644
--- a/tools/testing/selftests/sched/Makefile
+++ b/tools/testing/selftests/sched/Makefile
@@ -10,5 +10,6 @@ LDLIBS += -lpthread
 
 TEST_GEN_FILES := cs_prctl_test
 TEST_PROGS := cs_prctl_test
+TEST_GEN_PROGS := deadline_switch_test
 
 include ../lib.mk
diff --git a/tools/testing/selftests/sched/deadline_switch_test.c b/tools/testing/selftests/sched/deadline_switch_test.c
new file mode 100644
index 000000000000..81125d81b618
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline_switch_test.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A SCHED_DEADLINE task switched to SCHED_OTHER and back:
+ *
+ *  - throttled: switched out after its runtime ran out, and back after
+ *    its deadline but before its 0-lag time, it must run again, the
+ *    replenishment it missed while out of SCHED_DEADLINE or not;
+ *  - asleep past its 0-lag time: its bandwidth must leave the root domain
+ *    when it leaves SCHED_DEADLINE, or the switch back adds it again and
+ *    sched_setattr() soon refuses SCHED_DEADLINE with EBUSY.
+ *
+ * On a kernel that leaks, the second case leaves the root domain without
+ * bandwidth for new SCHED_DEADLINE tasks until a reboot.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/sysinfo.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+
+#ifndef SCHED_DEADLINE
+#define SCHED_DEADLINE	6
+#endif
+
+#define NSEC_PER_USEC	1000ULL
+#define NSEC_PER_MSEC	1000000ULL
+#define NSEC_PER_SEC	1000000000ULL
+
+struct dl_attr {
+	uint32_t size;
+	uint32_t sched_policy;
+	uint64_t sched_flags;
+	int32_t sched_nice;
+	uint32_t sched_priority;
+	uint64_t sched_runtime;
+	uint64_t sched_deadline;
+	uint64_t sched_period;
+};
+
+/* Written by the child, read by the parent. */
+struct shared {
+	uint64_t stamp;		/* last time the child ran */
+	uint64_t run_start;	/* when it last resumed after a gap */
+	uint64_t runs;		/* resumptions after a gap */
+	uint64_t sleeps;	/* sleeps begun */
+};
+
+static uint64_t now_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+static void sleep_ns(uint64_t ns)
+{
+	struct timespec ts = { .tv_sec = ns / NSEC_PER_SEC, .tv_nsec = ns % NSEC_PER_SEC };
+
+	while (nanosleep(&ts, &ts) && errno == EINTR)
+		;
+}
+
+static void sleep_until(uint64_t t)
+{
+	struct timespec ts = { .tv_sec = t / NSEC_PER_SEC, .tv_nsec = t % NSEC_PER_SEC };
+
+	while (clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL) == EINTR)
+		;
+}
+
+static int set_deadline(pid_t pid, uint64_t runtime, uint64_t period)
+{
+	struct dl_attr attr = {
+		.size = sizeof(attr),
+		.sched_policy = SCHED_DEADLINE,
+		.sched_runtime = runtime,
+		.sched_deadline = period,
+		.sched_period = period,
+	};
+
+	return syscall(__NR_sched_setattr, pid, &attr, 0) ? -errno : 0;
+}
+
+static int set_other(pid_t pid)
+{
+	struct sched_param sp = { .sched_priority = 0 };
+
+	return sched_setscheduler(pid, SCHED_OTHER, &sp) ? -errno : 0;
+}
+
+static struct shared *sh;
+
+static void reap(pid_t pid)
+{
+	int status;
+
+	if (pid <= 0)
+		return;
+	if (kill(pid, SIGKILL) && errno != ESRCH)
+		ksft_print_msg("kill %d: %s\n", pid, strerror(errno));
+	/* A task lost in SCHED_DEADLINE runs again, and dies, once out of it. */
+	set_other(pid);			/* gone already: nothing to switch */
+	while (waitpid(pid, &status, 0) != pid) {
+		if (errno == EINTR)
+			continue;
+		ksft_print_msg("waitpid %d: %s\n", pid, strerror(errno));
+		break;
+	}
+}
+
+/* The child died before the case was done: @status says whether it skips. */
+static int gone(int status)
+{
+	if (WIFEXITED(status) && WEXITSTATUS(status) == KSFT_SKIP) {
+		ksft_print_msg("SCHED_DEADLINE refused\n");
+		return KSFT_SKIP;
+	}
+	if (WIFSIGNALED(status))
+		ksft_print_msg("the task died of signal %d\n", WTERMSIG(status));
+	else
+		ksft_print_msg("the task exited with %d\n", WEXITSTATUS(status));
+	return KSFT_FAIL;
+}
+
+/* Spins: runs out of its runtime at once, and is throttled. */
+static void spinner(void)
+{
+	uint64_t last = now_ns();
+
+	for (;;) {
+		uint64_t t = now_ns();
+
+		if (t - last > 2 * NSEC_PER_MSEC) {
+			__atomic_store_n(&sh->run_start, t, __ATOMIC_RELAXED);
+			__atomic_fetch_add(&sh->runs, 1, __ATOMIC_RELEASE);
+		}
+		__atomic_store_n(&sh->stamp, t, __ATOMIC_RELEASE);
+		last = t;
+	}
+}
+
+#define LOST_RUNTIME	(10 * NSEC_PER_MSEC)
+#define LOST_PERIOD	(2 * NSEC_PER_SEC)
+#define LOST_MARGIN	(200 * NSEC_PER_USEC)
+
+/*
+ * The window between the deadline and the 0-lag time is the overrun
+ * scaled by period/runtime: 200 here, so that an overrun of 2us leaves
+ * 400us. A runtime longer than a tick keeps an overrun caught at the tick
+ * from carrying past the next replenishment, which comes a period after
+ * the last. The switch back comes LOST_MARGIN after the deadline, once
+ * the replenishment timer has fired on a task out of SCHED_DEADLINE.
+ */
+static int test_throttled_round_trip(void)
+{
+	int attempt, ret = KSFT_PASS, err;
+	pid_t pid;
+
+	memset(sh, 0, sizeof(*sh));
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	if (!pid) {
+		if (set_deadline(0, LOST_RUNTIME, LOST_PERIOD))
+			_exit(KSFT_SKIP);
+		spinner();
+	}
+	for (attempt = 0; attempt < 3 && ret == KSFT_PASS; attempt++) {
+		uint64_t runs, r, s, t;
+
+		/* A resumption at a replenishment, D, then its throttle. */
+		runs = __atomic_load_n(&sh->runs, __ATOMIC_ACQUIRE);
+		t = now_ns();
+		while (__atomic_load_n(&sh->runs, __ATOMIC_ACQUIRE) == runs) {
+			if (now_ns() - t > 3 * LOST_PERIOD) {
+				int status;
+
+				if (waitpid(pid, &status, WNOHANG) == pid)
+					return gone(status);
+				ksft_print_msg("the task did not resume within 3 periods\n");
+				reap(pid);
+				return KSFT_FAIL;
+			}
+			sleep_ns(NSEC_PER_MSEC);
+		}
+		r = __atomic_load_n(&sh->run_start, __ATOMIC_RELAXED);
+		do {
+			s = __atomic_load_n(&sh->stamp, __ATOMIC_ACQUIRE);
+			sleep_ns(2 * NSEC_PER_MSEC);
+		} while (__atomic_load_n(&sh->stamp, __ATOMIC_ACQUIRE) != s);
+		/* Throttled until D + period: out, and back after that. */
+		err = set_other(pid);
+		if (!err) {
+			sleep_until(r + LOST_PERIOD + LOST_MARGIN);
+			err = set_deadline(pid, LOST_RUNTIME, LOST_PERIOD);
+		}
+		if (err) {
+			ksft_print_msg("policy switch: %s\n", strerror(-err));
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(10 * NSEC_PER_MSEC);
+		s = __atomic_load_n(&sh->stamp, __ATOMIC_ACQUIRE);
+		t = now_ns();
+		while (__atomic_load_n(&sh->stamp, __ATOMIC_ACQUIRE) == s &&
+		       now_ns() - t < LOST_PERIOD + LOST_PERIOD / 2)
+			sleep_ns(NSEC_PER_MSEC);
+		if (__atomic_load_n(&sh->stamp, __ATOMIC_ACQUIRE) == s) {
+			ksft_print_msg("throttled, switched out and back: never ran again\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	reap(pid);
+	return ret;
+}
+
+#define LEAK_RUNTIME	(9 * NSEC_PER_MSEC)
+#define LEAK_PERIOD	(10 * NSEC_PER_MSEC)
+
+/* Runs 0.2ms, sleeps 50ms. */
+static void sleeper(void)
+{
+	for (;;) {
+		uint64_t end = now_ns() + 200 * NSEC_PER_USEC;
+
+		while (now_ns() < end)
+			;
+		__atomic_fetch_add(&sh->sleeps, 1, __ATOMIC_RELEASE);
+		sleep_ns(50 * NSEC_PER_MSEC);
+	}
+}
+
+/*
+ * 90% of a CPU per round trip: a leak fills the root domain within about
+ * as many round trips as it has CPUs.
+ */
+static int test_asleep_round_trip(void)
+{
+	int i, trips = get_nprocs() * 10 / 9 + 3, ret = KSFT_PASS, err;
+	pid_t pid;
+	FILE *f;
+
+	f = fopen("/proc/sys/kernel/sched_rt_runtime_us", "r");
+	if (f) {
+		long rt = 0;
+
+		if (fscanf(f, "%ld", &rt) == 1 && rt < 0) {
+			fclose(f);
+			ksft_print_msg("no admission control: a leak cannot be seen\n");
+			return KSFT_SKIP;
+		}
+		fclose(f);
+	}
+	memset(sh, 0, sizeof(*sh));
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	if (!pid) {
+		if (set_deadline(0, LEAK_RUNTIME, LEAK_PERIOD))
+			_exit(KSFT_SKIP);
+		sleeper();
+	}
+	for (i = 0; i < trips; i++) {
+		uint64_t sleeps = __atomic_load_n(&sh->sleeps, __ATOMIC_ACQUIRE);
+		uint64_t t = now_ns();
+
+		while (__atomic_load_n(&sh->sleeps, __ATOMIC_ACQUIRE) == sleeps) {
+			if (now_ns() - t > NSEC_PER_SEC) {
+				int status;
+
+				if (waitpid(pid, &status, WNOHANG) == pid)
+					return gone(status);
+				ksft_print_msg("the task did not run within 1s\n");
+				reap(pid);
+				return KSFT_FAIL;
+			}
+			sleep_ns(NSEC_PER_MSEC);
+		}
+		/* Asleep, well past its 0-lag time. */
+		sleep_ns(5 * NSEC_PER_MSEC);
+		err = set_other(pid);
+		if (!err)
+			err = set_deadline(pid, LEAK_RUNTIME, LEAK_PERIOD);
+		if (err) {
+			ksft_print_msg("switch back refused after %d of %d round trips: %s\n",
+				       i, trips, strerror(-err));
+			ret = KSFT_FAIL;
+			break;
+		}
+	}
+	reap(pid);
+	return ret;
+}
+
+static void report(const char *name, int ret)
+{
+	if (ret == KSFT_PASS)
+		ksft_test_result_pass("%s\n", name);
+	else if (ret == KSFT_SKIP)
+		ksft_test_result_skip("%s\n", name);
+	else
+		ksft_test_result_fail("%s\n", name);
+}
+
+int main(void)
+{
+	sh = mmap(NULL, sizeof(*sh), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (sh == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	ksft_print_header();
+	ksft_set_plan(2);
+	/* The first one first: the second fills the root domain where it leaks. */
+	report("throttled_round_trip", test_throttled_round_trip());
+	report("asleep_round_trip", test_asleep_round_trip());
+	ksft_finished();
+}
-- 
2.47.3

