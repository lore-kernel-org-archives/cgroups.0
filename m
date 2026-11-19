Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105512;
	b=VWI5YHV1M95KJGP6akd9OGBUtmYxmBjyxMUhjU09GLVi18kbAt1gopKtVOMw9e/88VAh
	 6RuRPUy2sphihv6wUn7MpA4J/JE7td8g4whSScDKcE72dJrLtEjhE5/0AsSUvnHISG8M5
	 YwJTfUw9BUFvaYVYILz5m/ZHgE7naGmtskwcUL0JPHbqVI6+VBAr8xpkKcv26zcFpwURD
	 lsv9zuYrhbT2QM7KUTSsAPaTt0skF3yOXM31XiE4rrwv/JXs+rJRGABaBzLqldUPn+aOO
	 boMi60S+c7C9NrPwTcHabmu2SXrqsWevsw7s4Ge1YFlIfLNTOTUEmmrqJ8Zj2PCcRfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105512;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uClSp9NdUJ6NSEA7KMZSKcnlzngxSvKSifOFhJ8B9d4=;
	b=Z7aWxJgzVQwO3lfT7nUWc8Dxnlu/Iwb6emEoTSw9SIvz9w97vVhcxqUePLWw1SvWz535
	 zd3/BtNxc3/DtyZAD2tYxhyQQAj/Yvsgtv+jT9ox1q3lMbdBL5mG1bmXS5ZZA0Qs5rK3s
	 oF817xtqJCioHm2YyNLNEjOuAu8AGkY5oTzGD3dTiZltavGhx55f9Fuev97QRd+y58m9r
	 vKXT9O7sejYQOw0ffVUhlv50tgy+mcydtpkwZGTjvUBc5mGDWVGHIpdu9iN0iq4Q6EH9N
	 i3O8aW2mPHkqAOYNt1dbaENVeaRgyaHJPt/i35KzC2mSPEkKuTAtOqkIngHJ50OPo/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PYDDiGdM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7560A5BE7;
	Thu, 19 Nov 2026 16:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1E7560A5BE7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PYDDiGdM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795105504;
	bh=uClSp9NdUJ6NSEA7KMZSKcnlzngxSvKSifOFhJ8B9d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYDDiGdM4o5GGgBjsjFhqikGxVIRy1SrUbkH73IH/5UpeADw5knOLH0MQOkHBkUiw
	 wgSbx0hlhlwA8blw3cPCdIyacNyfidFyN5e9cM51HfZZc5okvep0YpeHErSZGam61q
	 Oq0B39BozVhyjNVNCNz81jDtSaQ5vxbLyA8Bzwse6E2R4+gwxImDWLN8FTPARo/dws
	 gwx4Yd8Ihw5qyXP8f7aNcOjrDUH7+ga+agZCf0cFatVPx7K0JhdqaNMy2ygzg6e39K
	 jycrRd2WhGEyoKwXN8svuQpyYZz+7NHpeEH/ZNwORQ5xYoxNqogXUDd/x7xL78K8RT
	 Zsbzx5XuLzknQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVkMh4Mh6zSPn;
	Thu, 19 Nov 2026 11:25:04 -0500 (EST)
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
Subject: [RESEND PATCH v4 16/17] selftests/sched: Add a test of SCHED_DEADLINE policy round trips
Date: Thu, 19 Nov 2026 11:24:56 -0500
Message-Id: <ec34a6392cdb46a56843a7e15b94e14076fca78f.1795105408.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
References: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
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

Add deadline_switch_test, with five cases:
- throttled_round_trip: a task of 10ms every 2s spins, so it is
  throttled in every period. Right after a throttle, the test switches
  it to SCHED_OTHER. The test switches it back 200us after its
  deadline, between its replenishment timer and its 0-lag time. It must
  then run again.
- asleep_round_trip: a task of 9ms every 10ms runs 0.2ms, then sleeps
  50ms. While it sleeps past its 0-lag time, the test switches it to
  SCHED_OTHER and back. A leak at each round trip fills the root
  domain, and the switch back fails with EBUSY.
- sysrq_normalize: sysrq-n takes a deadline task out of the class.
  Another task must then still enter SCHED_DEADLINE.
- sysrq_boosted_owner: sysrq-n takes a SCHED_OTHER task out of the
  deadline class while a deadline waiter boosts it. After the unlock,
  the task enters SCHED_DEADLINE at 10ms every 100ms. It must not run
  more than its runtime in its first period.
- sysrq_running_owner: a SCHED_OTHER task spins alone on a CPU, with a
  lock held. A deadline waiter of 100us every 1ms boosts it. The test
  starts 2048 sleeping SCHED_FIFO threads, then fires sysrq-n. Every
  thread must end, and the owner must no longer be boosted.

The cases need CAP_SYS_NICE, and skip without it. asleep_round_trip
also skips without admission control, when sched_rt_runtime_us is -1.
sysrq-n changes the policy of every real-time user task. So the three
sysrq cases run only with DEADLINE_TEST_SYSRQ set. They also need root
and CONFIG_MAGIC_SYSRQ. The two owner cases run only if
sysrq_normalize passed.

On a kernel with the bugs, asleep_round_trip and sysrq_normalize keep
new tasks out of SCHED_DEADLINE. So they run last, followed only by
the two owner cases.

On v7.4-rc2, in 8-CPU VMs, three of the five cases fail:
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

sysrq_running_owner tests "sched/deadline: Do not replenish a boost
from cleared parameters". With the early return of that fix disabled,
the guest locked up in 3 runs of 3.

With the whole series, the five cases pass, with and without
PREEMPT_RT.

The test goes in a new selftest target, sched/deadline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/Makefile              |    1 +
 .../selftests/sched/deadline/.gitignore       |    1 +
 .../testing/selftests/sched/deadline/Makefile |    8 +
 tools/testing/selftests/sched/deadline/config |    1 +
 .../sched/deadline/deadline_switch_test.c     | 1115 +++++++++++++++++
 5 files changed, 1126 insertions(+)
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
index 000000000000..40c7c6bafc2b
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
@@ -0,0 +1,1115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test SCHED_DEADLINE tasks that switch to SCHED_OTHER and back:
+ *
+ * - throttled_round_trip: the test switches a throttled task to
+ *   SCHED_OTHER. The task's replenishment timer fires while it is out of
+ *   SCHED_DEADLINE. The test switches it back after its deadline, before
+ *   its 0-lag time. The task must run again.
+ * - asleep_round_trip: a task is switched out and back while it sleeps
+ *   past its 0-lag time. Its bandwidth must leave the root domain when it
+ *   leaves SCHED_DEADLINE. Otherwise each switch back adds it again, and
+ *   sched_setattr() soon fails with EBUSY.
+ * - sysrq_normalize: sysrq-n takes a deadline task out of the class.
+ *   Another task must then still enter SCHED_DEADLINE.
+ * - sysrq_boosted_owner: a deadline waiter boosts a sleeping SCHED_OTHER
+ *   owner into the deadline class. sysrq-n must end the boost. When the
+ *   owner later calls sched_setattr() to enter SCHED_DEADLINE, it must be
+ *   throttled at its own runtime.
+ * - sysrq_running_owner: a deadline waiter boosts a running SCHED_OTHER
+ *   owner. sysrq-n clears the waiter's parameters before it ends the
+ *   boost. The owner must keep running until then.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sched.h>
+#include <semaphore.h>
+#include <signal.h>
+#include <stdatomic.h>
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
+	 * Switched to SCHED_OTHER, it runs and dies. Ignore the result: the
+	 * task may be dead already.
+	 */
+	set_other(pid);
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
+/*
+ * Return the runtime @pid has left, from dl.runtime in /proc/<pid>/sched.
+ * It is below zero for a throttled task: the task overran by that much.
+ * Return 1 if it cannot be read.
+ */
+static long long dl_runtime_left(pid_t pid)
+{
+	char path[64], line[256];
+	long long left = 1;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%d/sched", pid);
+	f = fopen(path, "r");
+	if (!f)
+		return 1;
+	while (fgets(line, sizeof(line), f)) {
+		char *val = strchr(line, ':');
+
+		if (!strncmp(line, "dl.runtime", 10) && val) {
+			left = atoll(val + 1);
+			break;
+		}
+	}
+	fclose(f);
+	return left;
+}
+
+#define LOST_RUNTIME	(10 * NSEC_PER_MSEC)
+#define LOST_PERIOD	(2 * NSEC_PER_SEC)
+#define LOST_MARGIN	(200 * NSEC_PER_USEC)
+
+/*
+ * The child is a deadline task of 10ms every 2s, and spins. Three times,
+ * the parent does this:
+ * - Wait until the child resumes at a replenishment, at time r, and is
+ *   throttled again.
+ * - Switch it to SCHED_OTHER.
+ * - Sleep until r + LOST_PERIOD + LOST_MARGIN. r + LOST_PERIOD is the
+ *   child's deadline. Its replenishment timer fires there, on a task out
+ *   of SCHED_DEADLINE.
+ * - Switch it back to SCHED_DEADLINE.
+ * - Check that it runs again within 1.5 periods.
+ *
+ * The switch back must come before the 0-lag time. The 0-lag time is after
+ * the deadline by the overrun times period/runtime, which is 200 here.
+ * The overrun is how far the task ran past its runtime before the kernel
+ * throttled it. The parent reads it from /proc. A round whose switch back
+ * comes after the 0-lag time tests nothing, and does not count. The check
+ * keeps half of LOST_MARGIN as a margin. The case is skipped if no round
+ * counts. If the overrun cannot be read, every round counts.
+ */
+static int test_throttled_round_trip(void)
+{
+	int attempt, ret = KSFT_PASS, err, counted = 0;
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
+		long long left;
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
+		left = dl_runtime_left(pid);
+		err = set_other(pid);
+		if (!err) {
+			sleep_until(r + LOST_PERIOD + LOST_MARGIN);
+			err = set_deadline(pid, LOST_RUNTIME, LOST_PERIOD);
+			t = now_ns();
+		}
+		if (err) {
+			ksft_print_msg("policy switch: %s\n", strerror(-err));
+			ret = KSFT_FAIL;
+			break;
+		}
+		/* The deadline is at most r + LOST_PERIOD: r is read after it. */
+		if (left > 0 ||
+		    t + LOST_MARGIN / 2 <
+		    r + LOST_PERIOD + (uint64_t)-left * (LOST_PERIOD / LOST_RUNTIME))
+			counted++;
+		else
+			ksft_print_msg("an overrun of %lld ns: switched back after the 0-lag time\n",
+				       -left);
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
+	if (ret == KSFT_PASS && !counted)
+		ret = KSFT_SKIP;
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
+		/*
+		 * Wait 5ms. The task is still asleep, and past its 0-lag
+		 * time.
+		 */
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
+ * sysrq-n calls __sched_setscheduler() on every real-time and deadline
+ * user task, under tasklist_lock, to make it SCHED_OTHER. On a kernel
+ * with the bug, that call takes cpuset_mutex for a deadline task and
+ * never releases it. No task can enter SCHED_DEADLINE after that.
+ *
+ * sysrq-n changes the whole system. So the sysrq cases run last, and only
+ * with DEADLINE_TEST_SYSRQ set.
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
+			/*
+			 * The prober is blocked on a mutex. Do not wait for
+			 * it.
+			 */
+			return KSFT_FAIL;
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
+ * Run as the owner thread. Take pi_lock, post owner_locked, and sleep on
+ * owner_go while holding the lock. A deadline waiter boosts the owner
+ * during that sleep. Then drop the lock, become a deadline task of 10ms
+ * every 100ms, and spin for 100ms. Store the CPU time used, in ms, in
+ * owner_ms. Return NULL, or 1 on an error.
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
+ * Check that sysrq-n ends the boost of a SCHED_OTHER lock owner.
+ *
+ * M is the main thread, O the owner, W the waiter. All three start as
+ * SCHED_OTHER. pi_lock is a priority inheritance mutex.
+ *
+ *   M                           O                          W
+ *   start O
+ *                               lock pi_lock
+ *                               post owner_locked
+ *                               sleep on owner_go
+ *   start W
+ *                                                          sched_setattr():
+ *                                                            deadline,
+ *                                                            5ms every 50ms
+ *                                                          timedlock pi_lock,
+ *                                                            300ms: boosts O
+ *   see O at deadline priority
+ *   write "n" to sysrq-trigger:
+ *     O and W leave the class
+ *                                                          timedlock times out:
+ *                                                            deboosts O
+ *   join W
+ *   post owner_go
+ *                               unlock pi_lock
+ *                               sched_setattr(): deadline,
+ *                                 10ms every 100ms
+ *                               spin 100ms, measure
+ *                                 CPU time
+ *   join O
+ *
+ * sysrq-n takes O out of the deadline class without a chain walk. The
+ * boost must end there. On a kernel with the bug it does not, and the
+ * deboost at W's timeout sees no change of priority, so it leaves the
+ * boost too. O would then enter SCHED_DEADLINE as a boosted task, and
+ * never be throttled. O must get about 10ms of CPU time in its 100ms. The
+ * case fails above 20ms.
+ *
+ * O sleeps while it is boosted, on purpose. A boosted task runs on its
+ * waiter's parameters. sysrq-n takes W out of the class too, and W's
+ * parameters can then be cleared. On a kernel that refills the runtime
+ * from cleared parameters, a running O would loop in
+ * replenish_dl_entity().
+ *
+ * Run the case only if sysrq_normalize passed. @normalized is its result.
+ * Otherwise sysrq-n may leave cpuset_mutex held, and O would block in
+ * sched_setattr().
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
+		goto out_sem;
+	}
+	if (sem_wait_for(&owner_locked, 5000)) {
+		ksft_print_msg("the owner never took the lock\n");
+		sem_post(&owner_go);	/* in case it gets there late */
+		join(o);
+		ret = KSFT_FAIL;
+		goto out_sem;
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
+out_sem:
+	sem_destroy(&owner_go);
+	sem_destroy(&owner_locked);
+out:
+	close(fd);
+	pthread_mutex_destroy(&pi_lock);
+	return ret;
+}
+
+#define FILLERS		2048
+#define FILLER_STACK	(64 * 1024 > PTHREAD_STACK_MIN ? 64 * 1024 : PTHREAD_STACK_MIN)
+
+static atomic_int running_stop;
+static sem_t filler_ready, waiter_go;
+static int filler_pipe[2];
+static int running_cpu;
+
+/*
+ * Run as a filler thread: become SCHED_FIFO, and sleep until the write end
+ * of filler_pipe is closed. Return NULL, or 1 on an error.
+ */
+static void *filler(void *arg)
+{
+	struct sched_param sp = { .sched_priority = 1 };
+	int err = sched_setscheduler(0, SCHED_FIFO, &sp) ? errno : 0;
+	char c;
+
+	sem_post(&filler_ready);
+	if (err)
+		return (void *)1;
+	while (read(filler_pipe[0], &c, 1) < 0 && errno == EINTR)
+		;
+	return NULL;
+}
+
+/*
+ * Run as the owner thread O of sysrq_running_owner, on running_cpu only.
+ * Take pi_lock and post owner_locked. Spin until running_stop is set, or
+ * for 5s. Then unlock. Return NULL, or 1 on an error.
+ */
+static void *running_owner(void *arg)
+{
+	uint64_t t0;
+	cpu_set_t one;
+	int err;
+
+	owner_tid = syscall(SYS_gettid);
+	CPU_ZERO(&one);
+	CPU_SET(running_cpu, &one);
+	if (sched_setaffinity(0, sizeof(one), &one)) {
+		ksft_print_msg("the owner cannot run on CPU %d: %s\n", running_cpu,
+			       strerror(errno));
+		sem_post(&owner_locked);
+		return (void *)1;
+	}
+	err = pthread_mutex_lock(&pi_lock);
+	if (err) {
+		ksft_print_msg("the owner cannot take the lock: %s\n", strerror(err));
+		sem_post(&owner_locked);
+		return (void *)1;
+	}
+	sem_post(&owner_locked);
+	t0 = now_ns();
+	while (!atomic_load(&running_stop) && now_ns() - t0 < 5 * NSEC_PER_SEC)
+		;
+	err = pthread_mutex_unlock(&pi_lock);
+	if (err) {
+		ksft_print_msg("the owner cannot unlock: %s\n", strerror(err));
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * Run as the waiter thread W of sysrq_running_owner. Wait for waiter_go.
+ * Then become a deadline task of 100us every 1ms, and wait for pi_lock.
+ * Return NULL once it got the lock, or 1.
+ */
+static void *running_waiter(void *arg)
+{
+	int err;
+
+	while (sem_wait(&waiter_go) && errno == EINTR)
+		;
+	err = set_deadline(0, 100 * NSEC_PER_USEC, NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("the waiter refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	err = pthread_mutex_lock(&pi_lock);
+	if (!err)
+		pthread_mutex_unlock(&pi_lock);
+	set_other(0);			/* sysrq-n did it already */
+	if (err) {
+		ksft_print_msg("the waiter cannot take the lock: %s\n", strerror(err));
+		return (void *)1;
+	}
+	return NULL;
+}
+
+/*
+ * Check that a boosted owner that runs survives the clearing of its
+ * donor's parameters.
+ *
+ * M is the main thread, O the owner, W the waiter. pi_lock is a priority
+ * inheritance mutex. O runs alone on the last CPU. M and the fillers run
+ * on the other CPUs. The fillers are 2048 sleeping SCHED_FIFO threads,
+ * created after W and before O.
+ *
+ *   M                           O                          W
+ *   start W, the fillers, O
+ *                               lock pi_lock
+ *                               post owner_locked
+ *                               spin
+ *   post waiter_go
+ *                                                          sched_setattr():
+ *                                                            deadline,
+ *                                                            100us every 1ms
+ *                                                          lock pi_lock:
+ *                                                            boosts O
+ *                               runs on W's runtime,
+ *                                 refilled as it runs out
+ *   see O at deadline priority
+ *   sleep 20ms
+ *   write "n" to sysrq-trigger:
+ *     W leaves the class.
+ *     Its parameters are
+ *     cleared.
+ *     Then the fillers leave
+ *     their class, one by one.
+ *                               refills from W's cleared
+ *                                 parameters
+ *     Then O leaves the class.
+ *   see O not boosted
+ *   set running_stop
+ *                               unlock pi_lock
+ *                                                          take pi_lock, unlock
+ *   join O and W
+ *   end the fillers
+ *
+ * sysrq-n changes the tasks in the order of the task list, with no chain
+ * walk. The fillers keep O boosted from cleared parameters for a few ms.
+ * O refills its runtime in that time. On a kernel with the bug, that
+ * refill loops forever with O's rq lock held. sysrq-n then waits forever
+ * for that lock. The case passes if every thread ends.
+ *
+ * Run the case only if sysrq_normalize passed. @normalized is its result.
+ */
+static int test_sysrq_running_owner(int normalized)
+{
+	int fd, err, i, started = 0, ret = KSFT_PASS;
+	pthread_t o, w, *fill = NULL;
+	cpu_set_t old, others;
+	pthread_mutexattr_t a;
+	pthread_attr_t fa;
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
+	if (get_nprocs() < 2 || sched_getaffinity(0, sizeof(old), &old)) {
+		ksft_print_msg("needs 2 CPUs\n");
+		return KSFT_SKIP;
+	}
+	for (running_cpu = CPU_SETSIZE - 1; running_cpu >= 0; running_cpu--)
+		if (CPU_ISSET(running_cpu, &old))
+			break;
+	others = old;
+	CPU_CLR(running_cpu, &others);
+	if (!CPU_COUNT(&others)) {
+		ksft_print_msg("needs 2 CPUs\n");
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
+	fill = calloc(FILLERS, sizeof(*fill));
+	if (!fill || pipe(filler_pipe)) {
+		ksft_print_msg("setup: %s\n", strerror(errno));
+		ret = KSFT_FAIL;
+		goto out_free;
+	}
+	if (sem_init(&owner_locked, 0, 0) || sem_init(&filler_ready, 0, 0) ||
+	    sem_init(&waiter_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		close(filler_pipe[1]);
+		ret = KSFT_FAIL;
+		goto out_pipe;
+	}
+	err = pthread_attr_init(&fa);
+	if (!err) {
+		err = pthread_attr_setstacksize(&fa, FILLER_STACK);
+		if (err)
+			pthread_attr_destroy(&fa);
+	}
+	if (err) {
+		ksft_print_msg("filler stack of %zu bytes: %s\n", (size_t)FILLER_STACK,
+			       strerror(err));
+		close(filler_pipe[1]);
+		ret = KSFT_FAIL;
+		goto out_sem;
+	}
+	running_stop = 0;
+	/* W, then the fillers, then O: the order of the task list */
+	if (pthread_create(&w, NULL, running_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	/*
+	 * Keep M and the fillers off O's CPU. W keeps every CPU: a deadline
+	 * task must be allowed on its whole root domain.
+	 */
+	if (sched_setaffinity(0, sizeof(others), &others)) {
+		ksft_print_msg("sched_setaffinity: %s\n", strerror(errno));
+		sem_post(&waiter_go);
+		ret = KSFT_FAIL;
+		goto join_w;
+	}
+	for (started = 0; started < FILLERS; started++) {
+		if (pthread_create(&fill[started], &fa, filler, NULL)) {
+			ksft_print_msg("filler %d could not start\n", started);
+			ret = KSFT_FAIL;
+			break;
+		}
+	}
+	for (i = 0; i < started; i++)
+		if (sem_wait_for(&filler_ready, 5000))
+			ret = KSFT_FAIL;
+	if (ret != KSFT_PASS) {
+		sem_post(&waiter_go);
+		goto join_w;
+	}
+	if (pthread_create(&o, NULL, running_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&waiter_go);
+		ret = KSFT_FAIL;
+		goto join_w;
+	}
+	if (sem_wait_for(&owner_locked, 5000)) {
+		ksft_print_msg("the owner never took the lock\n");
+		ret = KSFT_FAIL;
+	}
+	sem_post(&waiter_go);
+	t = now_ns();
+	while (ret == KSFT_PASS && prio_of(owner_tid) != DL_TASK_PRIO &&
+	       now_ns() - t < 200 * NSEC_PER_MSEC)
+		sleep_ns(NSEC_PER_MSEC);
+	if (ret == KSFT_PASS && prio_of(owner_tid) != DL_TASK_PRIO) {
+		ksft_print_msg("the waiter never boosted the owner\n");
+		ret = KSFT_FAIL;
+	}
+	if (ret == KSFT_PASS) {
+		sleep_ns(20 * NSEC_PER_MSEC);
+		if (write(fd, "n", 1) != 1) {
+			ksft_print_msg("sysrq-n: %s\n", strerror(errno));
+			ret = KSFT_SKIP;
+		} else if (prio_of(owner_tid) == DL_TASK_PRIO) {
+			ksft_print_msg("the owner is still boosted after sysrq-n\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	running_stop = 1;
+	if (join(o))
+		ret = KSFT_FAIL;	/* the owner said why */
+join_w:
+	if (join(w))
+		ret = KSFT_FAIL;	/* the waiter said why */
+out:
+	close(filler_pipe[1]);
+	for (i = 0; i < started; i++)
+		if (join(fill[i]))
+			ret = KSFT_FAIL;
+	sched_setaffinity(0, sizeof(old), &old);
+	pthread_attr_destroy(&fa);
+out_sem:
+	sem_destroy(&waiter_go);
+	sem_destroy(&filler_ready);
+	sem_destroy(&owner_locked);
+out_pipe:
+	close(filler_pipe[0]);
+out_free:
+	free(fill);
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
+	ksft_set_plan(5);
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
+	report("sysrq_running_owner", test_sysrq_running_owner(ret));
+	ksft_finished();
+}
-- 
2.47.3

