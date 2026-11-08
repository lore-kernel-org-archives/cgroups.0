Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164069;
	b=NdbZ9lT8zsm6ymq2XHE8EloE5b8K92DI46M6pc5zM+alTeAixrBqDNpol11jGRXJCboz
	 Uy/wReBCPLd3Fh6JZHU/AwFnIywXkQ+qNo7rBWaRhS2NCUdrEieW6Yq/ltmmwBd9TUF36
	 NsZwWv1cdPRadSTtC0ItXTkNWqQQpIik5U7RQkjJVGahgyfsh/0cc8pRMlorvWbYEIidd
	 z7NCc82cxptW50JjO3STayXuAZObe/QoIKkm6P/Sh7564xQ6d0FekGEhaNlxFr8RiGpOz
	 4trN9KTXwosXDeTA8x2fd+1rwM2aoRwG8+k7eYnv4WZrKXrBRUR5WgM3DXmF8uz7NZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164069;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ckOw5md+ZvfWnEa641qTAZgX+9EDsPubZw+SJApquAw=;
	b=Sd1XQ/32hjMhkei3nhiJQuvfduftVfk1ys5d6l59fG4Pzxj1hyO/Vb5F2+OHvNFD8lTD
	 qLX/Nplqkl/H4PXfQzMYOUI2vaIzp266Os4YydUJ8AWaKx/xVt7rA70rHGGjUs88IccNZ
	 gpiuosBiPfEDVnHyIRuQ4n4/DmoxZOAVnEYDOym92ByClSbhrinrlAVhaPAkHwbdYDB/O
	 tBMc4y0xYPukSVjpr1z1rM0zYG9Q/IPwZjWZBxsktL7Kl1k76ueHuv0nVZvN46hNNZiqJ
	 gfSJVK3kr+TmiUKVQtqdny1qt8yvm2sr2GBOnse7t2N1HEj+YuGAyj0WMeAFNEQ6SuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KWIEYd+G;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583A606D82F;
	Sun,  8 Nov 2026 18:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7583A606D82F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KWIEYd+G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164067;
	bh=ckOw5md+ZvfWnEa641qTAZgX+9EDsPubZw+SJApquAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWIEYd+GoSurm9KdRv9G4ttCCLJjbipssPoJn+tzmKRNfR0a7RNa8uGqXvARSrzLF
	 nyH/qcG9UOaSUohApBvB/yqtFG0y/NrS1x0W1Y25mFwzG/hzjsLKK6BF5PpBLi/1N8
	 NPoCgOzb0e632BarhLdeEMWU36RSeKI5ehjphDFxDliPMf8z+3Jpt9qe5o+0lj4cBJ
	 WZcc7Fun/471YLcIo2Yt9Z0CB6qDOL8+KCtOsCUfYNVIT19psbIS22fPV/23FoRJwp
	 4q0IFv+9U2MNXHXTOEtveGVxm6G/wBVhfchoVdCxU6QWpSRe3+4K351LD0ea/7jYCD
	 MYy3PzROnqnSw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C739dJzLyV;
	Sun, 08 Nov 2026 13:54:27 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v5 27/29] selftests/sched: Add a test of SCHED_DEADLINE policy round trips
Date: Sun,  8 Nov 2026 13:54:04 -0500
Message-Id: <20261108185406.1549770-28-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

No selftest runs a SCHED_DEADLINE task.

Add deadline_switch_test, with four cases:
- throttled_round_trip: a task of 10ms every 2s spins, so it is
  throttled in every period. Right after a throttle, it is switched to
  SCHED_OTHER. It is switched back 200us after its deadline, between
  its replenishment timer and its 0-lag time. It must then run again.
- asleep_round_trip: a task of 9ms every 10ms runs 0.2ms, then sleeps
  50ms. While it sleeps past its 0-lag time, it is switched to
  SCHED_OTHER and back. A leak at each round trip fills the root
  domain, and the switch back fails with EBUSY.
- sysrq_normalize: sysrq-n takes a deadline task out of the class.
  Another task must then still enter SCHED_DEADLINE.
- sysrq_boosted_owner: sysrq-n takes a SCHED_OTHER task out of the
  deadline class while a deadline waiter boosts it. After the unlock,
  the task enters SCHED_DEADLINE at 10ms every 100ms. It must not run
  more than its runtime in its first period.

The cases need CAP_SYS_NICE, and skip without it. asleep_round_trip
also skips without admission control, when sched_rt_runtime_us is -1.
sysrq-n changes the policy of every real-time user task. So the two
sysrq cases run only with DEADLINE_TEST_SYSRQ set. They also need root
and CONFIG_MAGIC_SYSRQ. sysrq_boosted_owner runs only if
sysrq_normalize passed.

On a kernel with the bugs, asleep_round_trip and sysrq_normalize keep
new tasks out of SCHED_DEADLINE. So they run last, followed only by
sysrq_boosted_owner.

On v7.4-rc1, in 8-CPU VMs, the three cases fail:
- throttled_round_trip. "sched/deadline: Do not lose a throttled task
  switched out and back" fixes it.
- asleep_round_trip. "sched/deadline: Release the bandwidth of a task
  that leaves the class asleep" fixes it.
- sysrq_normalize. "sched: Take cpuset_mutex for a deadline policy
  change only with pi" fixes it.

sysrq_boosted_owner tests "sched: Let a task boosted by a deadline
waiter change its policy". Without the sysrq-n part of that fix, the
owner ran 99-100ms of its first period, in 4 runs of 4. With it, it ran
10-11ms.

With the whole series, the four cases pass, with and without
PREEMPT_RT.

The test goes in a new selftest target, sched/deadline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/sched/deadline/.gitignore       |   1 +
 .../testing/selftests/sched/deadline/Makefile |   8 +
 tools/testing/selftests/sched/deadline/config |   1 +
 .../sched/deadline/deadline_switch_test.c     | 721 ++++++++++++++++++
 5 files changed, 732 insertions(+)
 create mode 100644 tools/testing/selftests/sched/deadline/.gitignore
 create mode 100644 tools/testing/selftests/sched/deadline/Makefile
 create mode 100644 tools/testing/selftests/sched/deadline/config
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
diff --git a/tools/testing/selftests/sched/deadline/config b/tools/testing/selftests/sched/deadline/config
new file mode 100644
index 000000000000..3a3a7285a708
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/config
@@ -0,0 +1 @@
+CONFIG_MAGIC_SYSRQ=y
diff --git a/tools/testing/selftests/sched/deadline/deadline_switch_test.c b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
new file mode 100644
index 000000000000..30b7118311ac
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
@@ -0,0 +1,721 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test SCHED_DEADLINE tasks that switch to SCHED_OTHER and back:
+ *
+ * - throttled_round_trip: a throttled task is switched out. Its
+ *   replenishment timer fires while it is out of SCHED_DEADLINE. It is
+ *   switched back after its deadline, before its 0-lag time. It must run
+ *   again.
+ * - asleep_round_trip: a task is switched out and back while it sleeps
+ *   past its 0-lag time. Its bandwidth must leave the root domain when it
+ *   leaves SCHED_DEADLINE. Otherwise each switch back adds it again, and
+ *   sched_setattr() soon fails with EBUSY.
+ * - sysrq_normalize: sysrq-n takes a deadline task out of the class.
+ *   Another task must then still enter SCHED_DEADLINE.
+ * - sysrq_boosted_owner: a deadline waiter boosts a SCHED_OTHER owner,
+ *   and sysrq-n takes the owner out of the class. When the owner later
+ *   enters SCHED_DEADLINE, it must run on its own runtime.
+ *
+ * On a kernel that leaks, asleep_round_trip leaves no room in the root
+ * domain for new SCHED_DEADLINE tasks.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <semaphore.h>
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
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
+	uint64_t run_start;	/* when it last resumed after a throttle */
+	uint64_t runs;		/* resumptions after a throttle */
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
+/*
+ * Fork a child that is killed when the test dies, so that it cannot keep
+ * its bandwidth. Return what fork() returns.
+ */
+static pid_t fork_child(void)
+{
+	pid_t parent = getpid();
+	pid_t pid = fork();
+
+	if (!pid && (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent))
+		_exit(KSFT_FAIL);
+	return pid;
+}
+
+static void reap(pid_t pid)
+{
+	int status;
+
+	if (pid <= 0)
+		return;
+	if (kill(pid, SIGKILL) && errno != ESRCH)
+		ksft_print_msg("kill %d: %s\n", pid, strerror(errno));
+	/*
+	 * A deadline task left throttled for good never runs, even to die.
+	 * Switched to SCHED_OTHER, it runs and dies.
+	 */
+	set_other(pid);			/* gone already: nothing to switch */
+	while (waitpid(pid, &status, 0) != pid) {
+		if (errno == EINTR)
+			continue;
+		ksft_print_msg("waitpid %d: %s\n", pid, strerror(errno));
+		break;
+	}
+}
+
+/*
+ * Report a child that died before the end of its case. Return KSFT_SKIP
+ * if it could not enter SCHED_DEADLINE, and KSFT_FAIL otherwise.
+ */
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
+/*
+ * Spin, so that the task uses up its runtime and is throttled in every
+ * period. Record in sh when it runs, and when it resumes after a
+ * throttle. A throttle stops the task for most of its 2s period. A gap
+ * of 1s or less, such as a preemption, is not a throttle.
+ */
+static void spinner(void)
+{
+	uint64_t last = now_ns();
+
+	for (;;) {
+		uint64_t t = now_ns();
+
+		if (t - last > NSEC_PER_SEC) {
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
+ * Switch a throttled task out of SCHED_DEADLINE and back, three times.
+ * Each time, check that it runs again.
+ *
+ * The switch back comes LOST_MARGIN after the deadline. The replenishment
+ * timer has fired by then, on a task out of SCHED_DEADLINE. The 0-lag
+ * time comes later. Its distance from the deadline is the overrun scaled
+ * by period/runtime, 200 here. So an overrun of 2us leaves 400us. The
+ * runtime is longer than a tick. An overrun caught at the tick then does
+ * not carry past the next replenishment. That replenishment comes a
+ * period after the last.
+ */
+static int test_throttled_round_trip(void)
+{
+	int attempt, ret = KSFT_PASS, err;
+	pid_t pid;
+
+	memset(sh, 0, sizeof(*sh));
+	pid = fork_child();
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
+		/*
+		 * Wait until the task resumes at a replenishment, at time r.
+		 * Then wait until it stops running: it is throttled.
+		 */
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
+		/*
+		 * The task is throttled until r + LOST_PERIOD. Switch it out
+		 * now, and back LOST_MARGIN after that.
+		 */
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
+/* Run 0.2ms, then sleep 50ms, forever. Count the sleeps in sh. */
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
+ * Switch a sleeping task out of SCHED_DEADLINE and back, over and over.
+ * The task has 90% of a CPU. If each round trip leaks it, the root domain
+ * is full after about as many round trips as it has CPUs.
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
+	pid = fork_child();
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
+		/* After 5ms, the task sleeps well past its 0-lag time. */
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
+ * Take a deadline task out of the class with sysrq-n. Then check that
+ * another task can still enter SCHED_DEADLINE.
+ *
+ * sysrq-n moves every real-time user task of the system to SCHED_OTHER,
+ * under tasklist_lock. For a deadline task, __sched_setscheduler() took
+ * cpuset_mutex there and never released it. No task could enter
+ * SCHED_DEADLINE again. As sysrq-n changes the whole system, the sysrq
+ * cases run only with DEADLINE_TEST_SYSRQ set, and last.
+ */
+static int test_sysrq_normalize(void)
+{
+	int fd, status, ret = KSFT_PASS;
+	pid_t pid, prober, w;
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
+	pid = fork_child();
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
+	/* A new task must still enter SCHED_DEADLINE within 5s. */
+	prober = fork_child();
+	if (prober < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	if (!prober)
+		_exit(set_deadline(0, LOST_RUNTIME, LOST_PERIOD) ? 1 : 0);
+	t = now_ns();
+	while ((w = waitpid(prober, &status, WNOHANG)) == 0) {
+		if (now_ns() - t > 5 * NSEC_PER_SEC) {
+			ksft_print_msg("SCHED_DEADLINE admission blocked after sysrq-n\n");
+			reap(pid);
+			return KSFT_FAIL;	/* the prober is stuck on a mutex: left behind */
+		}
+		sleep_ns(NSEC_PER_MSEC);
+	}
+	if (w != prober) {
+		ksft_print_msg("waitpid %d: %s\n", prober, strerror(errno));
+		ret = KSFT_FAIL;
+	} else if (!WIFEXITED(status) || WEXITSTATUS(status)) {
+		ksft_print_msg("SCHED_DEADLINE refused after sysrq-n\n");
+		ret = KSFT_FAIL;
+	}
+	reap(pid);
+	return ret;
+}
+
+/* The priority /proc shows for a deadline task, or a task boosted by one. */
+#define DL_TASK_PRIO	(-101)
+
+static pthread_mutex_t pi_lock;
+static sem_t owner_locked, owner_go;
+static pid_t owner_tid;
+static int owner_ms;		/* the owner's CPU time in its first period */
+
+static uint64_t thread_time_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+/*
+ * Wait on @s for at most @ms, retrying on signals. Return 0, or -1 on a
+ * timeout or an error.
+ */
+static int sem_wait_for(sem_t *s, int ms)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += (long)(ms % 1000) * 1000000L;
+	ts.tv_sec += ms / 1000 + ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	while (sem_timedwait(s, &ts)) {
+		if (errno != EINTR)
+			return -1;
+	}
+	return 0;
+}
+
+/* Return the priority @tid runs at, from /proc, or 0. */
+static int prio_of(pid_t tid)
+{
+	char path[64], buf[1024], *p;
+	ssize_t n;
+	int fd, i;
+
+	snprintf(path, sizeof(path), "/proc/%d/stat", tid);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return 0;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return 0;
+	buf[n] = 0;
+	/* The priority is field 18, the 16th after the command name. */
+	p = strrchr(buf, ')');
+	for (i = 0; p && i < 16; i++)
+		p = strchr(p + 1, ' ');
+	return p ? atoi(p + 1) : 0;
+}
+
+/* Join @t. Return -1 if the join fails or @t returned an error. */
+static int join(pthread_t t)
+{
+	void *res;
+	int err = pthread_join(t, &res);
+
+	if (err)
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+	return err || res ? -1 : 0;
+}
+
+/*
+ * The owner thread: take pi_lock, and sleep on owner_go with it. A
+ * deadline waiter boosts it meanwhile. Then drop the lock, become a
+ * deadline task of 10ms every 100ms, and spin for 100ms. Store the CPU
+ * time it got in owner_ms, in ms. Return NULL, or 1 on an error.
+ */
+static void *sleeping_owner(void *arg)
+{
+	uint64_t t0, cpu0;
+	int err;
+
+	owner_tid = syscall(SYS_gettid);
+	err = pthread_mutex_lock(&pi_lock);
+	if (err) {
+		ksft_print_msg("the owner cannot take the lock: %s\n", strerror(err));
+		return (void *)1;
+	}
+	sem_post(&owner_locked);
+	while (sem_wait(&owner_go) && errno == EINTR)
+		;
+	err = pthread_mutex_unlock(&pi_lock);
+	if (err) {
+		ksft_print_msg("the owner cannot unlock: %s\n", strerror(err));
+		return (void *)1;
+	}
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, 100 * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	t0 = now_ns();
+	cpu0 = thread_time_ns();
+	while (now_ns() - t0 < 100 * NSEC_PER_MSEC)
+		;
+	owner_ms = (thread_time_ns() - cpu0) / NSEC_PER_MSEC;
+	set_other(0);
+	return NULL;
+}
+
+/*
+ * The waiter thread: become a deadline task of 5ms every 50ms, and wait
+ * up to 300ms for pi_lock. The owner holds the lock all along. Return
+ * NULL if the wait timed out, or 1.
+ */
+static void *boosting_waiter(void *arg)
+{
+	struct timespec ts;
+	int err;
+
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += 300 * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	if (!err)
+		pthread_mutex_unlock(&pi_lock);
+	set_other(0);			/* sysrq-n may have done it */
+	if (err != ETIMEDOUT) {
+		ksft_print_msg("the waiter of the lock: %s, not a timeout\n",
+			       err ? strerror(err) : "got it");
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * A deadline waiter boosts a sleeping SCHED_OTHER owner into the deadline
+ * class. sysrq-n then takes the owner out of the class without a chain
+ * walk. The boost must end there. The deboost at the waiter's timeout
+ * sees no change of priority, and would leave the boost behind. The owner
+ * would then run as a boosted task once it enters SCHED_DEADLINE, and
+ * never be throttled. It must run 10ms of its first 100ms, not all of
+ * them.
+ *
+ * The owner sleeps while it is boosted. On older kernels, a boosted task
+ * runs on the waiter's own parameters. sysrq-n takes the waiter out of the
+ * class too, and its parameters can then be cleared. A running owner would
+ * then loop in replenish_dl_entity().
+ *
+ * Run the case only if sysrq_normalize passed: its result is @normalized.
+ * Otherwise sysrq-n may leave cpuset_mutex held, and the owner would block
+ * in sched_setattr().
+ */
+static int test_sysrq_boosted_owner(int normalized)
+{
+	int fd, err, ret = KSFT_PASS;
+	pthread_mutexattr_t a;
+	pthread_t o, w;
+	uint64_t t;
+
+	if (!getenv("DEADLINE_TEST_SYSRQ")) {
+		ksft_print_msg("sysrq-n renices every real-time task: set DEADLINE_TEST_SYSRQ=1\n");
+		return KSFT_SKIP;
+	}
+	if (normalized != KSFT_PASS) {
+		ksft_print_msg("sysrq_normalize did not pass: sched_setattr() may block\n");
+		return KSFT_SKIP;
+	}
+	fd = open("/proc/sysrq-trigger", O_WRONLY);
+	if (fd < 0) {
+		ksft_print_msg("/proc/sysrq-trigger: %s\n", strerror(errno));
+		return KSFT_SKIP;
+	}
+	err = pthread_mutexattr_init(&a);
+	if (!err) {
+		err = pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT);
+		if (!err)
+			err = pthread_mutex_init(&pi_lock, &a);
+		pthread_mutexattr_destroy(&a);
+	}
+	if (err) {
+		ksft_print_msg("no priority inheritance mutex: %s\n", strerror(err));
+		close(fd);
+		return KSFT_SKIP;
+	}
+	if (sem_init(&owner_locked, 0, 0) || sem_init(&owner_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	owner_ms = -1;
+	if (pthread_create(&o, NULL, sleeping_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (sem_wait_for(&owner_locked, 5000)) {
+		ksft_print_msg("the owner never took the lock\n");
+		sem_post(&owner_go);	/* in case it gets there late */
+		join(o);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (pthread_create(&w, NULL, boosting_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		ret = KSFT_FAIL;
+		goto unlock;
+	}
+	t = now_ns();
+	while (prio_of(owner_tid) != DL_TASK_PRIO && now_ns() - t < 200 * NSEC_PER_MSEC)
+		sleep_ns(NSEC_PER_MSEC);
+	if (prio_of(owner_tid) != DL_TASK_PRIO) {
+		ksft_print_msg("the waiter never boosted the owner\n");
+		ret = KSFT_FAIL;
+	} else if (write(fd, "n", 1) != 1) {
+		ksft_print_msg("sysrq-n: %s\n", strerror(errno));
+		ret = KSFT_SKIP;
+	}
+	if (join(w))
+		ret = KSFT_FAIL;	/* the waiter said why */
+unlock:
+	sem_post(&owner_go);
+	if (join(o)) {
+		ret = KSFT_FAIL;	/* the owner said why */
+	} else if (ret == KSFT_PASS && owner_ms > 20) {
+		ksft_print_msg("the owner ran %d ms of its first 100: the boost outlived sysrq-n\n",
+			       owner_ms);
+		ret = KSFT_FAIL;
+	}
+out:
+	close(fd);
+	pthread_mutex_destroy(&pi_lock);
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
+	int ret;
+
+	sh = mmap(NULL, sizeof(*sh), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (sh == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	ksft_print_header();
+	ksft_set_plan(4);
+	/*
+	 * Keep this order. On a kernel with the bugs, asleep_round_trip fills
+	 * the root domain, and sysrq_normalize blocks every later admission.
+	 * So sysrq_boosted_owner runs only if sysrq_normalize passed.
+	 */
+	report("throttled_round_trip", test_throttled_round_trip());
+	report("asleep_round_trip", test_asleep_round_trip());
+	ret = test_sysrq_normalize();
+	report("sysrq_normalize", ret);
+	report("sysrq_boosted_owner", test_sysrq_boosted_owner(ret));
+	ksft_finished();
+}
-- 
2.47.3

