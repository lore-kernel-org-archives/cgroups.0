Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907261;
	b=01GzWgQxDS4zyFr0NeWT+63HcHkormKNI4TKB8tU+viGRS9VGaEijeXro/W3dDp+WQSt
	 1yaYoE5EuC9UP1izkt7gR1kVJOY8cyq1fimlrZzFcmcT77GOYeOq0LkO0mUMxJt6D/5PS
	 abGehIkkkIumYkDhVrTNsWu4ihIwXkKMKI+j1pVEVpIorzia+6WKTTnuImpDazJg2gLvy
	 uDDrWxr4a2pmuwi/kyjo0BIKYaWLK5gsReEW7t1FYqpDQWEtOB81VoTmMVnFTdG6O2UWz
	 A9OgodcY0FGBrm0cvkLdXr1Yvfw475Vy1wsC6BiTbXYYNraADXt85fEQCAsP036ZOCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907261;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Wg8BcKOUb3VsZQDUyDYOLGsTPKMJi9+yFrx8CvSg+vc=;
	b=GtKIJa8Gdcg2czx1qbOsaALdLqHvn/r3SSQGBM0emQIfbZNtgeauyfgnD8tRhZZtjTXw
	 z0gb/v7y3H9hbp8V0W1o0ZFxYNnEnr2E9nmI7apk21k4lPbYdYOThpJ2sDbOpT6gy04aC
	 VpxxfSJW5LBaz/C89oKfD9kBtCnkcsVT+FguFEAXYGpQsflhGkN9ZbaOufS2p/GzlpEyy
	 /x/ObngAfMnFhKQNt3+gD+fe8zCsj0vMsbIbwuoKDFZsoecHQa2NjfGnkxLe42otuKACg
	 KtycYsfBysBp1z/ZPzIPo80814BrzVYRbtNJJNaHh3u/gj8LbK8CCW8qQ2uhhkfdERw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m8+EQlfX;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA26B60A2607;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA26B60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m8+EQlfX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907252;
	bh=Wg8BcKOUb3VsZQDUyDYOLGsTPKMJi9+yFrx8CvSg+vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8+EQlfXGkim2ngJuiEF+xltXj4Fl53lZsUboDSW5X9U8vj/3K4axUMvMUNBkwIzz
	 xuHjlHDbM8MrTsKkaTwy8RdO7A+w1nuUIUNouV/eaH/z7OyBV78CDzrStucJuJ2843
	 WmYjTkRPUqOLMfBbwPz5wd9aqeez20eaXa2JWe9duTr1kzCoJLI9gyEantWPsRk0u+
	 HDMJEpwZLylS2WaAnLAkdcoUh0m64m4W6VJL9F0awMKhvjyJCEsjcnkrgW5ivP3fD0
	 eciUgS3kF0E3KaqRrJdihFBU0tZrX5S2LICO7uK44wIZooNY6kixFTxBDkLrPrEDsA
	 GxS29J2KbmZKg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDN3mn2zLwc;
	Thu, 05 Nov 2026 14:34:12 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v3 22/24] selftests/sched: Add a test of SCHED_DEADLINE policy round trips
Date: Thu,  5 Nov 2026 14:33:57 -0500
Message-Id: <20261105193359.1450487-23-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

A third case, sysrq_normalize, checks that a task can enter
SCHED_DEADLINE after sysrq-n took one out of it: "sched: Take
cpuset_mutex for a deadline policy change only with pi" has the
cpuset_mutex that sysrq-n left locked. It renices every real-time task
of the system, so it runs only with DEADLINE_TEST_SYSRQ set, and last.

In 8 VMs of 8 vCPUs each, v7.3 and v7.4-rc1 fail the two round trips;
with "sched/deadline: Do not lose a throttled task switched out and
back" and "sched/deadline: Release the bandwidth of a task that leaves
the class asleep" both pass; every time. sysrq_normalize finds the
admission blocked on v7.4-rc1, in 2 VMs of 2, and passes with the fix.

The tests of the deadline class get a directory of their own,
sched/deadline, for those of the other policies to follow, and that
directory joins the selftest targets.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/sched/deadline/.gitignore       |   1 +
 .../testing/selftests/sched/deadline/Makefile |   8 +
 .../sched/deadline/deadline_switch_test.c     | 425 ++++++++++++++++++
 4 files changed, 435 insertions(+)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_switch_test.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8b04..35b0c5e86ba7 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -120,6 +120,7 @@ TARGETS += rlimits
 TARGETS += rseq
 TARGETS += rtc
 TARGETS += rust
+TARGETS += sched/deadline
 TARGETS += sched_ext
 TARGETS += seccomp
 TARGETS += sgx
diff --git a/tools/testing/selftests/sched/deadline/.gitignore b/tools/testing/selftests/sched/deadline/.gitignore
new file mode 100644
index 000000000000..9f203c455b91
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/.gitignore
@@ -0,0 +1 @@
+deadline_switch_test
diff --git a/tools/testing/selftests/sched/deadline/Makefile b/tools/testing/selftests/sched/deadline/Makefile
new file mode 100644
index 000000000000..3f4dc1ec6119
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0+
+
+CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES)
+LDLIBS += -lpthread
+
+TEST_GEN_PROGS := deadline_switch_test
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/sched/deadline/deadline_switch_test.c b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
new file mode 100644
index 000000000000..f38c14c51139
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
@@ -0,0 +1,425 @@
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
+#include <fcntl.h>
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
+#include "../../kselftest.h"
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
+/*
+ * sysrq-n takes every task out of the real-time classes, under
+ * tasklist_lock. A deadline task among them had __sched_setscheduler()
+ * take cpuset_mutex there, and never release it: no task could enter
+ * SCHED_DEADLINE again. The case renices every real-time task of the
+ * system: it runs with DEADLINE_TEST_SYSRQ set, and last.
+ */
+static int test_sysrq_normalize(void)
+{
+	int fd, status, ret = KSFT_PASS;
+	pid_t pid, prober;
+	uint64_t t;
+
+	if (!getenv("DEADLINE_TEST_SYSRQ")) {
+		ksft_print_msg("sysrq-n renices every real-time task: set DEADLINE_TEST_SYSRQ=1\n");
+		return KSFT_SKIP;
+	}
+	fd = open("/proc/sysrq-trigger", O_WRONLY);
+	if (fd < 0) {
+		ksft_print_msg("/proc/sysrq-trigger: %s\n", strerror(errno));
+		return KSFT_SKIP;
+	}
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		close(fd);
+		return KSFT_FAIL;
+	}
+	if (!pid) {
+		if (set_deadline(0, LOST_RUNTIME, LOST_PERIOD))
+			_exit(KSFT_SKIP);
+		for (;;)
+			pause();
+	}
+	t = now_ns();
+	while (sched_getscheduler(pid) != SCHED_DEADLINE) {
+		if (waitpid(pid, &status, WNOHANG) == pid) {
+			close(fd);
+			return gone(status);
+		}
+		if (now_ns() - t > NSEC_PER_SEC) {
+			ksft_print_msg("the task did not enter SCHED_DEADLINE within 1s\n");
+			close(fd);
+			reap(pid);
+			return KSFT_FAIL;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+	}
+	if (write(fd, "n", 1) != 1) {
+		ksft_print_msg("sysrq-n: %s\n", strerror(errno));
+		close(fd);
+		reap(pid);
+		return KSFT_SKIP;
+	}
+	close(fd);
+	t = now_ns();
+	while (sched_getscheduler(pid) != SCHED_OTHER && now_ns() - t < NSEC_PER_SEC)
+		sleep_ns(NSEC_PER_MSEC);
+	if (sched_getscheduler(pid) != SCHED_OTHER) {
+		ksft_print_msg("still SCHED_DEADLINE after sysrq-n\n");
+		ret = KSFT_FAIL;
+	}
+	/* Admission still works: a task enters SCHED_DEADLINE within 5s. */
+	prober = fork();
+	if (prober < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	if (!prober)
+		_exit(set_deadline(0, LOST_RUNTIME, LOST_PERIOD) ? 1 : 0);
+	t = now_ns();
+	while (waitpid(prober, &status, WNOHANG) == 0) {
+		if (now_ns() - t > 5 * NSEC_PER_SEC) {
+			ksft_print_msg("SCHED_DEADLINE admission blocked after sysrq-n\n");
+			reap(pid);
+			return KSFT_FAIL;	/* the prober is stuck on a mutex: left behind */
+		}
+		sleep_ns(NSEC_PER_MSEC);
+	}
+	if (!WIFEXITED(status) || WEXITSTATUS(status)) {
+		ksft_print_msg("SCHED_DEADLINE refused after sysrq-n\n");
+		ret = KSFT_FAIL;
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
+	ksft_set_plan(3);
+	/*
+	 * In this order: the second fills the root domain where it leaks, and
+	 * the third leaves it without deadline admission where it locks.
+	 */
+	report("throttled_round_trip", test_throttled_round_trip());
+	report("asleep_round_trip", test_asleep_round_trip());
+	report("sysrq_normalize", test_sysrq_normalize());
+	ksft_finished();
+}
-- 
2.47.3

