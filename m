Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115244;
	b=e5eT2moq1D18B3Hcct+GkoYEEjKovuFQ/hjX2ycE57CAch24rHsMs+vRV9TEK3JumjT2
	 DVxMD61Qz7C3RhEdbmNG64jX5KhfO05cyVapKt36KXCR/yvWKBKFLlGmQ6SSAgjCEKfGU
	 jKP7ar/SHmdWioHOMsA/Mti0l7NPZB31UzHYD0GnZaPpIFQqEoH/dd5DC12eT7hD8GfzG
	 y3GLAijndPvM/7F6dLhxXF/plzsC5aVuK/0qzfEAafvg2BkZenmm2vXF7g1nEnhCn2O4k
	 9tLZziaF6TfpDM8q4CyZYJQxVU6uv5TPsKRo1MmRJxI7Is95Fpih7d16N5mdMBwSbXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115244;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Hnhca0Z5Kk3wwFK2tZAenLdTzy4mJXBVvuQgL1pVB9Q=;
	b=ZJXq1SxC6nPAwzS8Ut1+We2PG8+kGtP4NfcJ7dNoF/2Ugz02kcp86jWSKhi/XaciJZ3x
	 h6fq3lZsab1zE1UMB49eK9m/TiLSwFhfys2xQ3/BhR/M0OK29dH5ZX0bEvIk/OV2Af7P8
	 frN79rediGdnMZpk3Gyhqz/5uMTyz1hDoo0yz0m6JJkysACbsw7eZMlvFrvsLRdfioho8
	 reMMycw0z23BUzjPJccyLG0CXk2rOOuMZfGMFHP1aBZcLZPeuZ0G8Mw5yrAfE/1TTFi3s
	 DElr0IdpQJj4wxvhtH3jM4O00lCrS+WKMZ0GpIHRU2zue+P7lOE2cyoB84s2AqlTAjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iCRfLiCe;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5112260A5BD5;
	Thu, 19 Nov 2026 19:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5112260A5BD5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iCRfLiCe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795115240;
	bh=Hnhca0Z5Kk3wwFK2tZAenLdTzy4mJXBVvuQgL1pVB9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCRfLiCes55DjqVgZJlTCUuN13N7fOl2XjtlDmCMW0ILkq/u/z/x75fGdg7O89CQZ
	 YG4LU2PmfHLKmCvQBEIhQGMHvH6ngf5Zpe1+CXidG97X0IVWKVhnt1/mwBq/2C1Xwv
	 vCBTVUkGYAh8gLxLIC0L3gLBlHA+zNlV23m/iwQ/kA8OaX2+x+q2vkRwfJwhFsGDZA
	 uGhUAReaBdOee4UFyRR6To8MeJFlG2K7KRbqSFIsY9ADJLFk1IeaHNHqI3sp+i3+qP
	 1w1MqQNGA/eqNZtJapZ4CdSwdT7RwJ8F0qTK6PSeR7BIxo6ckser50ZyxYASUinfZJ
	 m3u14W5mS0HvA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVnyv6Y90zSBR;
	Thu, 19 Nov 2026 14:07:19 -0500 (EST)
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
Subject: [PATCH v5 17/17] selftests/sched: Add a test of SCHED_DEADLINE bandwidth accounting
Date: Thu, 19 Nov 2026 14:07:14 -0500
Message-Id: <90f0986ac819f480267ffa4275db7cb26d3be219.1795115075.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
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

Upstream has no selftest of the SCHED_DEADLINE bandwidth accounting. A
leak or a double release does not show at once. Later, the root domain
refuses deadline tasks, or admits more than it can run.

Add deadline_bw_test, with 47 cases. Most cases count the tasks of 10ms
every 100ms that a root domain admits, before and after they run. Once
the tasks of the case are gone and past their 0-lag time, the two counts
must be equal. The cases cover:
- priority inheritance, boost and deboost
- parameter changes, SCHED_FLAG_KEEP_PARAMS among them
- cpuset moves
- deaths, sched_yield() and runtime overruns
- a stopped task
- bandwidth reclaiming and deadline server changes
- CPU hotplug
- parameter changes while a task wakes on another CPU (params_waking)

The comment above each case gives its scenario. params_waking also
compares the this_bw of its CPUs, which "sched/debug: Show the deadline
bandwidth of each runqueue" prints. Two cases follow reproducers of Juri
Lelli's sched-deadline-tests: stopped_switched_out and
pi_chain_two_owners.

The test needs root, deadline admission control and 3 CPUs. Most cases
need the cgroup v2 cpuset controller, and some need debugfs, CPU hotplug
or 4 CPUs. move_cancelled needs CONFIG_RT_GROUP_SCHED. A case skips
without what it needs. While a sched_ext scheduler runs all fair tasks,
the server cases use the ext server, and hotplug_server skips.

The message of each fix in this series names the cases that test it.
These cases are not named there. Each fails without its fix, and passes
with it:
- overrun_caught and stopped_switched_out: "sched/deadline: Release the
  bandwidth of a task that leaves the class asleep"
- params_keep_class_change: "sched: Refuse SCHED_FLAG_KEEP_PARAMS that
  would change the policy or the class"

overrun_caught fails in part of the runs only.

On v7.4-rc2, in three runs of 8 VMs of 8 CPUs, six cases fail in every
VM:
- boosted_owner_policy
- deboost_resets_period
- death_zombie_switched
- params_keep_boosted
- params_keep_class_change
- stopped_switched_out

params_switched_asleep was only in the third run. It failed in every VM
there. params_shrunk_long_period passed there: div64_long() does not
trap.

overrun_caught fails in 5 VMs of 24. In one VM, hotplug_server crashed
the kernel with a divide error in inactive_task_timer().
"sched/deadline: Do not divide by zero active CPUs of a root domain"
fixes it.

Two cases skip there. params_waking needs the this_bw that "sched/debug:
Show the deadline bandwidth of each runqueue" prints. move_cancelled
needs CONFIG_RT_GROUP_SCHED.

With the whole series, every case passes wherever it runs, PREEMPT_RT
included. The test also ran in guests built without cpusets, and in
guests booted with isolcpus=domain,1,2 or isolcpus=domain,0,1.
move_cancelled ran in two guests built with CONFIG_RT_GROUP_SCHED. No
kernel warning is logged.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://github.com/jlelli/sched-deadline-tests
---
 .../selftests/sched/deadline/.gitignore       |    1 +
 .../testing/selftests/sched/deadline/Makefile |    2 +-
 tools/testing/selftests/sched/deadline/config |    4 +
 .../sched/deadline/deadline_bw_test.c         | 4960 +++++++++++++++++
 .../testing/selftests/sched/deadline/settings |    1 +
 5 files changed, 4967 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_bw_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/settings

diff --git a/tools/testing/selftests/sched/deadline/.gitignore b/tools/testing/selftests/sched/deadline/.gitignore
index 9f203c455b91..5a572318e1ba 100644
--- a/tools/testing/selftests/sched/deadline/.gitignore
+++ b/tools/testing/selftests/sched/deadline/.gitignore
@@ -1 +1,2 @@
 deadline_switch_test
+deadline_bw_test
diff --git a/tools/testing/selftests/sched/deadline/Makefile b/tools/testing/selftests/sched/deadline/Makefile
index 3f4dc1ec6119..c3156059bdcf 100644
--- a/tools/testing/selftests/sched/deadline/Makefile
+++ b/tools/testing/selftests/sched/deadline/Makefile
@@ -3,6 +3,6 @@
 CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 
-TEST_GEN_PROGS := deadline_switch_test
+TEST_GEN_PROGS := deadline_switch_test deadline_bw_test
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/sched/deadline/config b/tools/testing/selftests/sched/deadline/config
index 3a3a7285a708..b19db0c962e0 100644
--- a/tools/testing/selftests/sched/deadline/config
+++ b/tools/testing/selftests/sched/deadline/config
@@ -1 +1,5 @@
+CONFIG_CGROUPS=y
+CONFIG_CPUSETS=y
+CONFIG_DEBUG_FS=y
+CONFIG_HOTPLUG_CPU=y
 CONFIG_MAGIC_SYSRQ=y
diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
new file mode 100644
index 000000000000..6ff9da964403
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -0,0 +1,4960 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the bandwidth accounting of SCHED_DEADLINE. The deadline tasks
+ * of the cases go through:
+ *  - priority inheritance
+ *  - parameter changes
+ *  - cpuset moves
+ *  - deaths, yields and runtime overruns
+ *  - bandwidth reclaiming and fair server changes
+ *  - CPU hotplug
+ *
+ * Most cases measure the free bandwidth of a root domain before and after
+ * they run. probe() counts the tasks of 10ms every 100ms that the root
+ * domain admits. Once the tasks of the case are gone and their 0-lag time
+ * is past, the two counts must be equal. Fewer means leaked bandwidth.
+ * More means bandwidth released twice, which lets the root domain admit
+ * deadline tasks beyond its capacity. A deadline task that a case keeps
+ * running must also make progress.
+ *
+ * The reclaiming cases measure the share of a CPU that a deadline task
+ * with SCHED_FLAG_RECLAIM gets. That share follows extra_bw: the free
+ * bandwidth that the task's runqueue can reclaim. probe() follows the
+ * root domain's total_bw instead.
+ *
+ * The CPUs that isolcpus="domain" isolates are in the default root
+ * domain: the root domain of the isolated CPUs. The other CPUs are the
+ * housekeeping CPUs, in the housekeeping root domain. The test leaves the
+ * isolated CPUs out, and keeps its tasks off them.
+ *
+ * The cases of p_cases[] run with P, a partition root of the last
+ * housekeeping CPU. P is made anew for each case. Making it rebuilds the
+ * accounting, which clears what an earlier case left.
+ *
+ * The cases of hp_cases[] run after them, without P. They take CPUs
+ * offline. The test skips them if no CPU can go offline.
+ *
+ * The server cases change the fair server of a CPU through debugfs, and
+ * the test then puts it back.
+ *
+ * The test needs root, deadline admission control and 3 housekeeping
+ * CPUs. Some cases need 4. Most also need the cgroup v2 cpuset
+ * controller. Some need debugfs or CPU hotplug.
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
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+#include <linux/futex.h>
+
+#include "../../kselftest.h"
+
+#ifndef SCHED_DEADLINE
+#define SCHED_DEADLINE	6
+#endif
+#ifndef SCHED_FLAG_RECLAIM
+#define SCHED_FLAG_RECLAIM	0x02
+#endif
+#ifndef SCHED_FLAG_DL_OVERRUN
+#define SCHED_FLAG_DL_OVERRUN	0x04
+#endif
+#ifndef SCHED_FLAG_KEEP_PARAMS
+#define SCHED_FLAG_KEEP_PARAMS	0x10
+#endif
+
+#define NSEC_PER_USEC	1000ULL
+#define NSEC_PER_MSEC	1000000ULL
+#define NSEC_PER_SEC	1000000000ULL
+
+/* The threads of probe() and hold() do nothing: a small stack will do. */
+#define THREAD_STACK	(64 * 1024 > PTHREAD_STACK_MIN ? 64 * 1024 : PTHREAD_STACK_MIN)
+
+#define PROBE_RUNTIME	(10 * NSEC_PER_MSEC)
+#define PROBE_PERIOD	(100 * NSEC_PER_MSEC)
+#define PERIOD		(100 * NSEC_PER_MSEC)
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
+static char root[PATH_MAX], cg_p[PATH_MAX], cg_q[PATH_MAX];
+/* The online CPUs at the start, ascending, except the isolated ones */
+static int ncpus, *online;
+static char isolated[4096];	/* the CPU list of /sys/devices/system/cpu/isolated */
+
+/* Return the @n-th highest online CPU, counting from 1. */
+static int top_cpu(int n)
+{
+	return online[ncpus - n];
+}
+
+/*
+ * clock_gettime() cannot fail in now_ns() and thread_time_ns(). Both
+ * clocks are always supported, and the pointer is valid.
+ */
+static uint64_t now_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+static uint64_t thread_time_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
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
+static void spin_ns(uint64_t ns)
+{
+	uint64_t end = thread_time_ns() + ns;
+
+	while (thread_time_ns() < end)
+		;
+}
+
+/*
+ * Poll @cond every @step ns, for at most @ms. Return 0 once it holds, or
+ * -1 on a timeout. The bound makes a child that never started, or was
+ * refused SCHED_DEADLINE, fail its case instead of hanging it.
+ */
+#define wait_for_step(ms, step, cond)					\
+({									\
+	uint64_t wait_end = now_ns() + (uint64_t)(ms) * NSEC_PER_MSEC;	\
+	int wait_ret = -1;						\
+									\
+	while (1) {							\
+		if (cond) {						\
+			wait_ret = 0;					\
+			break;						\
+		}							\
+		if (now_ns() >= wait_end)				\
+			break;						\
+		sleep_ns(step);						\
+	}								\
+	wait_ret;							\
+})
+
+#define wait_for(ms, cond)	wait_for_step(ms, NSEC_PER_MSEC, cond)
+
+/* Wait on @s. Retry when a signal interrupts the wait. */
+static void sem_wait_sig(sem_t *s)
+{
+	while (sem_wait(s)) {
+		if (errno == EINTR)
+			continue;
+		ksft_print_msg("sem_wait: %s\n", strerror(errno));
+		return;
+	}
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
+		if (errno == EINTR)
+			continue;
+		if (errno != ETIMEDOUT)
+			ksft_print_msg("sem_timedwait: %s\n", strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Fork a child that is killed when the thread that forked it dies, so
+ * that it cannot keep its bandwidth. Every caller forks from the main
+ * thread of its process. Print a message with @what if fork() fails.
+ * Return what fork() returns. The caller must handle -1.
+ */
+static pid_t fork_child(const char *what)
+{
+	pid_t parent = getpid();
+	pid_t pid = fork();
+
+	if (pid < 0)
+		ksft_print_msg("fork for %s: %s\n", what, strerror(errno));
+	else if (!pid && (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent))
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
+	while (waitpid(pid, &status, 0) != pid) {
+		if (errno == EINTR)
+			continue;
+		ksft_print_msg("waitpid %d: %s\n", pid, strerror(errno));
+		break;
+	}
+}
+
+static void join(pthread_t t)
+{
+	int err = pthread_join(t, NULL);
+
+	if (err)
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+}
+
+static pid_t gettid_(void)
+{
+	return syscall(SYS_gettid);
+}
+
+static int set_deadline_flags(pid_t tid, uint64_t runtime, uint64_t period,
+			      uint64_t flags)
+{
+	struct dl_attr attr = {
+		.size = sizeof(attr),
+		.sched_policy = SCHED_DEADLINE,
+		.sched_flags = flags,
+		.sched_runtime = runtime,
+		.sched_deadline = period,
+		.sched_period = period,
+	};
+
+	return syscall(SYS_sched_setattr, tid, &attr, 0) ? -errno : 0;
+}
+
+static int set_deadline(pid_t tid, uint64_t runtime, uint64_t period)
+{
+	return set_deadline_flags(tid, runtime, period, 0);
+}
+
+static int set_other(pid_t tid)
+{
+	struct dl_attr attr = { .size = sizeof(attr), .sched_policy = SCHED_OTHER };
+
+	return syscall(SYS_sched_setattr, tid, &attr, 0) ? -errno : 0;
+}
+
+static int write_file(const char *dir, const char *name, const char *val)
+{
+	char path[PATH_MAX];
+	int fd, err = 0;
+	ssize_t n;
+
+	if (snprintf(path, sizeof(path), "%s/%s", dir, name) >= (int)sizeof(path))
+		return -ENAMETOOLONG;
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	n = write(fd, val, strlen(val));
+	if (n < 0)
+		err = -errno;
+	else if (n != (ssize_t)strlen(val))
+		err = -EIO;
+	if (close(fd) && !err)
+		err = -errno;
+	return err;
+}
+
+static int read_file(const char *path, char *buf, size_t len)
+{
+	int fd = open(path, O_RDONLY);
+	ssize_t n;
+
+	if (fd < 0)
+		return -1;
+	do {
+		n = read(fd, buf, len - 1);
+	} while (n < 0 && errno == EINTR);
+	close(fd);
+	if (n < 0)
+		return -1;
+	buf[n] = 0;
+	return 0;
+}
+
+static int enter(const char *cg, pid_t pid)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d", pid);
+	return write_file(cg, "cgroup.procs", buf);
+}
+
+/* Return whether @list, words separated by blanks, holds the word @w. */
+static int has_word(const char *list, const char *w)
+{
+	size_t len = strlen(w);
+	const char *p = list;
+
+	while ((p = strstr(p, w))) {
+		if ((p == list || p[-1] == ' ') &&
+		    (p[len] == ' ' || p[len] == '\n' || !p[len]))
+			return 1;
+		p += len;
+	}
+	return 0;
+}
+
+/* Make @cg a partition root of the CPUs in @cpus. Return 0, or -1. */
+static int make_partition_cpus(const char *cg, const char *cpus)
+{
+	char path[PATH_MAX + 32], buf[32];
+
+	if (mkdir(cg, 0755) && errno != EEXIST)
+		return -1;
+	if (write_file(cg, "cpuset.cpus", cpus) ||
+	    write_file(cg, "cpuset.cpus.partition", "root"))
+		return -1;
+	snprintf(path, sizeof(path), "%s/cpuset.cpus.partition", cg);
+	if (read_file(path, buf, sizeof(buf)) || strcmp(buf, "root\n"))
+		return -1;
+	return 0;
+}
+
+/* Make @cg a partition root of CPU @cpu. Return 0, or -1. */
+static int make_partition(const char *cg, int cpu)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%d", cpu);
+	return make_partition_cpus(cg, buf);
+}
+
+static void remove_partition(const char *cg)
+{
+	int err = write_file(cg, "cpuset.cpus.partition", "member");
+
+	if (err && err != -ENOENT)
+		ksft_print_msg("%s back to a member: %s\n", cg, strerror(-err));
+	/* A cgroup whose last task just died takes a moment to empty. */
+	if (wait_for(1000, !rmdir(cg) || errno == ENOENT))
+		ksft_print_msg("rmdir %s: %s\n", cg, strerror(errno));
+}
+
+/* Make P a partition root of the last online CPU. Return 0, or -1. */
+static int make_p(void)
+{
+	return make_partition(cg_p, top_cpu(1));
+}
+
+static void remove_p(void)
+{
+	remove_partition(cg_p);
+}
+
+/*
+ * Return field @n of /proc/@pid/stat, or @fail. Fields are numbered as
+ * in proc(5), and @n must be 3 or more: a field after the command name.
+ */
+static int stat_field(pid_t pid, int n, int fail)
+{
+	char path[64], buf[1024], *p;
+	int i;
+
+	snprintf(path, sizeof(path), "/proc/%d/stat", pid);
+	if (read_file(path, buf, sizeof(buf)))
+		return fail;
+	p = strrchr(buf, ')');
+	for (i = 0; p && i < n - 2; i++)
+		p = strchr(p + 1, ' ');
+	return p ? atoi(p + 1) : fail;
+}
+
+/* Return the CPU @pid last ran on, from /proc, or -1. */
+static int task_cpu_of(pid_t pid)
+{
+	return stat_field(pid, 39, -1);
+}
+
+/* The priority /proc shows for a deadline task, or a task boosted by one. */
+#define DL_TASK_PRIO	(-101)
+
+/* Return the priority @pid runs at, from /proc, or 0. */
+static int prio_of(pid_t pid)
+{
+	return stat_field(pid, 18, 0);
+}
+
+/* Return the CPU time @t has used, or 0 if it cannot be read. */
+static uint64_t cpu_time_of(pthread_t t)
+{
+	static int told;
+	struct timespec ts;
+	clockid_t c;
+	int err;
+
+	err = pthread_getcpuclockid(t, &c);
+	if (!err && clock_gettime(c, &ts))
+		err = errno;
+	if (err) {
+		if (!told++)
+			ksft_print_msg("the CPU time of a thread cannot be read: %s\n",
+				       strerror(err));
+		return 0;
+	}
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+/* Return the state letter of @pid in /proc, or 0. */
+static char proc_state_of(pid_t pid)
+{
+	char path[64], buf[1024], *p;
+
+	snprintf(path, sizeof(path), "/proc/%d/stat", pid);
+	if (read_file(path, buf, sizeof(buf)))
+		return 0;
+	p = strrchr(buf, ')');
+	if (!p || p[1] != ' ')
+		return 0;
+	return p[2];
+}
+
+/*
+ * Wait a period. Then return the CPU share, in percent, that @t uses
+ * over the next @ns.
+ */
+static int share_of(pthread_t t, uint64_t ns)
+{
+	uint64_t cpu, wall;
+
+	sleep_ns(PERIOD);		/* a period of its own to settle in */
+	cpu = cpu_time_of(t);
+	wall = now_ns();
+	sleep_ns(ns);
+	cpu = cpu_time_of(t) - cpu;
+	wall = now_ns() - wall;
+	return wall ? (int)(100 * cpu / wall) : -1;
+}
+
+struct probe_slot {
+	pthread_t t;
+	int err;
+};
+
+static sem_t probe_done;
+static int probe_hold[2];
+
+static void *probe_thread(void *arg)
+{
+	struct probe_slot *s = arg;
+	char c;
+
+	s->err = set_deadline(0, PROBE_RUNTIME, PROBE_PERIOD);
+	if (sem_post(&probe_done))
+		ksft_print_msg("sem_post: %s\n", strerror(errno));
+	/* Sleep until the probe closes the write end. */
+	while (!s->err) {
+		ssize_t r = read(probe_hold[0], &c, 1);
+
+		if (r >= 0)
+			break;
+		if (errno != EINTR) {
+			s->err = -errno;
+			break;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Count the deadline tasks of PROBE_RUNTIME every PROBE_PERIOD that the
+ * root domain of @cg admits. A child process joins @cg, or stays in the
+ * caller's cgroup if @cg is NULL. Its threads become deadline tasks one
+ * at a time, until one is refused. Then they all exit. Return the number
+ * admitted, or -1 on an error.
+ *
+ * The threads barely run, so their bandwidth is released when they exit.
+ * probe() still waits three periods for their 0-lag times.
+ */
+static int probe(const char *cg)
+{
+	int fd[2], n = -1, max = 16 * ncpus + 16;
+	pid_t pid;
+
+	if (pipe(fd)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return -1;
+	}
+	pid = fork_child("the admission check");
+	if (!pid) {
+		struct probe_slot *s = calloc(max, sizeof(*s));
+		pthread_attr_t a;
+		int i, k = 0;
+
+		close(fd[0]);
+		if (!s || sem_init(&probe_done, 0, 0) || pipe(probe_hold) ||
+		    (cg && enter(cg, getpid())))
+			_exit(1);
+		if (pthread_attr_init(&a) || pthread_attr_setstacksize(&a, THREAD_STACK))
+			_exit(1);
+		for (i = 0; i < max; i++) {
+			if (pthread_create(&s[i].t, &a, probe_thread, &s[i])) {
+				k = -1;	/* an error, not a refusal */
+				break;
+			}
+			if (sem_wait_for(&probe_done, 10000)) {
+				k = -1;
+				i++;	/* join that thread too */
+				break;
+			}
+			if (s[i].err) {
+				if (s[i].err != -EBUSY)
+					k = -1;
+				join(s[i].t);
+				break;
+			}
+			if (k >= 0)
+				k++;
+		}
+		if (i == max)
+			k = -1;
+		close(probe_hold[1]);
+		while (--i >= 0)
+			join(s[i].t);
+		if (write(fd[1], &k, sizeof(k)) != sizeof(k))
+			_exit(1);
+		_exit(0);
+	}
+	close(fd[1]);
+	if (pid < 0 || read(fd[0], &n, sizeof(n)) != sizeof(n))
+		n = -1;
+	close(fd[0]);
+	reap(pid);
+	sleep_ns(3 * PROBE_PERIOD);
+	return n;
+}
+
+/*
+ * Run @fn in a child process in @cg. Every thread of the case is then in
+ * @cg, and dies with the child. Return KSFT_PASS, KSFT_FAIL or KSFT_SKIP.
+ */
+static int run_in(const char *cg, int (*fn)(void))
+{
+	pid_t pid = fork_child("a case");
+	int status;
+
+	if (!pid) {
+		int err = cg ? enter(cg, getpid()) : 0;
+
+		if (err) {
+			ksft_print_msg("the case cannot enter %s: %s\n", cg, strerror(-err));
+			_exit(KSFT_SKIP);
+		}
+		_exit(fn());
+	}
+	if (pid < 0)
+		return KSFT_FAIL;
+	while (waitpid(pid, &status, 0) != pid) {
+		if (errno == EINTR)
+			continue;
+		ksft_print_msg("waitpid %d: %s\n", pid, strerror(errno));
+		return KSFT_FAIL;
+	}
+	if (!WIFEXITED(status)) {
+		ksft_print_msg("the case died of signal %d\n",
+			       WIFSIGNALED(status) ? WTERMSIG(status) : 0);
+		return KSFT_FAIL;
+	}
+	return WEXITSTATUS(status);
+}
+
+/*
+ * Run @fn in @cg with run_in(), and probe the root domain of @cg before
+ * and after. Return KSFT_SKIP if the first probe admits no task. Return
+ * KSFT_FAIL if a probe fails, or if @fn passed and the two probes differ.
+ * Otherwise return the result of @fn.
+ */
+static int measured(const char *name, const char *cg, int (*fn)(void))
+{
+	int before, after, ret;
+
+	before = probe(cg);
+	if (before <= 0) {
+		ksft_print_msg("%s: %s\n", name, before ? "the probe failed" : "no room to probe");
+		return before ? KSFT_FAIL : KSFT_SKIP;
+	}
+	ret = run_in(cg, fn);
+	sleep_ns(3 * PERIOD);
+	after = probe(cg);
+	if (after < 0) {
+		ksft_print_msg("%s: the probe failed after the case\n", name);
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && after != before) {
+		ksft_print_msg("%s: %d probe tasks admitted before, %d after: %s\n",
+			       name, before, after,
+			       after < before ? "bandwidth leaked" : "bandwidth released twice");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/* Priority inheritance */
+
+static pthread_mutex_t pi_lock;
+static sem_t owner_ready, owner_go;
+static atomic_int owner_holds, owner_tid;
+
+/*
+ * Set up pi_lock, a priority inheritance mutex, and the owner's
+ * semaphores. Return 0, or -1 if they cannot be set up.
+ */
+static int pi_init(void)
+{
+	pthread_mutexattr_t a;
+	int err;
+
+	err = pthread_mutexattr_init(&a);
+	if (!err) {
+		err = pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT);
+		if (!err)
+			err = pthread_mutex_init(&pi_lock, &a);
+		pthread_mutexattr_destroy(&a);
+	}
+	if (err) {
+		ksft_print_msg("no priority inheritance mutex: %s\n", strerror(err));
+		return -1;
+	}
+	if (sem_init(&owner_ready, 0, 0) || sem_init(&owner_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return -1;
+	}
+	owner_holds = 0;
+	return 0;
+}
+
+/* Undo pi_init(). The owner and the waiters must be gone. */
+static void pi_fini(void)
+{
+	pthread_mutex_destroy(&pi_lock);
+	sem_destroy(&owner_ready);
+	sem_destroy(&owner_go);
+}
+
+/*
+ * Make the calling thread a deadline task, and wait up to @ms for
+ * pi_lock. Then switch back to SCHED_OTHER. Return 0 if the wait ends as
+ * @timeout expects: a timeout if it is set, the lock if not. Return -1
+ * otherwise.
+ */
+static int wait_lock_for(int ms, int timeout)
+{
+	struct timespec ts;
+	int err;
+
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
+	if (err) {
+		ksft_print_msg("a waiter refused as a deadline task: %s\n", strerror(-err));
+		return -1;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += (long)ms * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	if (!err) {
+		int e = pthread_mutex_unlock(&pi_lock);
+
+		if (e)
+			ksft_print_msg("a waiter cannot unlock: %s\n", strerror(e));
+	}
+	if (set_other(0)) {
+		ksft_print_msg("a waiter cannot leave SCHED_DEADLINE\n");
+		return -1;
+	}
+	if (err != (timeout ? ETIMEDOUT : 0)) {
+		ksft_print_msg("a waiter of the lock: %s, not %s\n", err ? strerror(err) : "got it",
+			       timeout ? "a timeout" : "the lock");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Take pi_lock as the owner, and return 0. On a failure, report it, set
+ * owner_holds to -1 and return -1.
+ */
+static int take_pi_lock(void)
+{
+	int err = pthread_mutex_lock(&pi_lock);
+
+	if (err) {
+		ksft_print_msg("an owner cannot take the lock: %s\n", strerror(err));
+		owner_holds = -1;
+	}
+	return err ? -1 : 0;
+}
+
+static void drop_pi_lock(void)
+{
+	int err = pthread_mutex_unlock(&pi_lock);
+
+	if (err)
+		ksft_print_msg("an owner cannot unlock: %s\n", strerror(err));
+}
+
+/*
+ * A chain of two priority inheritance mutexes, M1 and M2. The comment of
+ * pi_chain_two_owners() describes the threads D1, N1 and N2. chain_tid[]
+ * holds their tids, in that order. chain_step says how far the case is:
+ * - 1: N2 holds M2. N2 sets it.
+ * - 2: the main thread has checked the boost of N1. N1 may now block on
+ *   M2.
+ * - 3: the main thread is done. N2 may now unlock M2.
+ */
+static pthread_mutex_t chain_m1, chain_m2;
+static atomic_int chain_tid[3], chain_step, chain_err;
+
+/*
+ * Wait up to 2s for chain_step to reach @step. Return 0 once it does, or
+ * once a thread of the chain has set chain_err. Return -1 on a timeout.
+ */
+static int chain_wait(int step)
+{
+	return wait_for(2000, chain_step >= step || chain_err);
+}
+
+/* N2: take M2, and hold it until step 3. */
+static void *chain_n2(void *arg)
+{
+	chain_tid[2] = gettid_();
+	if (pthread_mutex_lock(&chain_m2)) {
+		chain_err = 1;
+		return arg;
+	}
+	chain_step = 1;
+	if (chain_wait(3))
+		chain_err = 1;
+	pthread_mutex_unlock(&chain_m2);
+	return arg;
+}
+
+/* N1: take M1. At step 2, block on M2, which N2 holds. */
+static void *chain_n1(void *arg)
+{
+	if (pthread_mutex_lock(&chain_m1)) {
+		chain_err = 1;
+		return arg;
+	}
+	chain_tid[1] = gettid_();	/* N1 holds M1 */
+	if (chain_wait(2) || pthread_mutex_lock(&chain_m2)) {
+		chain_err = 1;
+	} else {
+		pthread_mutex_unlock(&chain_m2);
+	}
+	pthread_mutex_unlock(&chain_m1);
+	return arg;
+}
+
+/* D1: become a deadline task and block on M1, which N1 holds. */
+static void *chain_d1(void *arg)
+{
+	struct timespec ts;
+
+	chain_tid[0] = gettid_();
+	if (set_deadline(0, 5 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC)) {
+		chain_err = 1;
+		return arg;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_sec += 5;
+	if (pthread_mutex_timedlock(&chain_m1, &ts))
+		chain_err = 1;
+	else
+		pthread_mutex_unlock(&chain_m1);
+	if (set_other(0))
+		chain_err = 1;
+	return arg;
+}
+
+/*
+ * Boost two SCHED_OTHER tasks through a chain of two mutexes:
+ *
+ *   D1 (deadline) waits for M1, held by N1
+ *   N1 (boosted)  waits for M2, held by N2
+ *
+ * N1 is boosted when D1 blocks. N2 is boosted when N1 then blocks: the
+ * boost goes through N1, which has no deadline parameters of its own.
+ * Both must be in the deadline class then. Once N2 unlocks, the three
+ * must finish.
+ */
+static int pi_chain_two_owners(void)
+{
+	pthread_mutexattr_t a;
+	int ret = KSFT_PASS, i;
+	pthread_t t[3];
+
+	if (pthread_mutexattr_init(&a) ||
+	    pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT) ||
+	    pthread_mutex_init(&chain_m1, &a) || pthread_mutex_init(&chain_m2, &a)) {
+		ksft_print_msg("no priority inheritance mutex\n");
+		return KSFT_SKIP;
+	}
+	pthread_mutexattr_destroy(&a);
+	chain_step = 0;
+	chain_err = 0;
+	for (i = 0; i < 3; i++)
+		chain_tid[i] = 0;
+	if (pthread_create(&t[2], NULL, chain_n2, NULL) || chain_wait(1) ||
+	    pthread_create(&t[1], NULL, chain_n1, NULL) ||
+	    wait_for(2000, chain_tid[1]) ||
+	    pthread_create(&t[0], NULL, chain_d1, NULL)) {
+		ksft_print_msg("the threads of the chain could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(2000, prio_of(chain_tid[1]) == DL_TASK_PRIO || chain_err)) {
+		ksft_print_msg("N1 is not boosted by D1\n");
+		ret = KSFT_FAIL;
+	}
+	chain_step = 2;
+	if (ret == KSFT_PASS &&
+	    wait_for(2000, prio_of(chain_tid[2]) == DL_TASK_PRIO || chain_err)) {
+		ksft_print_msg("N2 is not boosted through N1\n");
+		ret = KSFT_FAIL;
+	}
+	chain_step = 3;
+	for (i = 0; i < 3; i++)
+		join(t[i]);
+	if (chain_err) {
+		ksft_print_msg("a thread of the chain failed\n");
+		ret = KSFT_FAIL;
+	}
+	pthread_mutex_destroy(&chain_m1);
+	pthread_mutex_destroy(&chain_m2);
+	return ret;
+}
+
+/*
+ * Run as the owner thread: take pi_lock, and sleep 400ms while holding
+ * it. Return NULL, or 1 on an error.
+ */
+static void *sleeping_owner(void *arg)
+{
+	owner_tid = gettid_();
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	sleep_ns(400 * NSEC_PER_MSEC);
+	drop_pi_lock();
+	return NULL;
+}
+
+/*
+ * A SCHED_OTHER owner takes pi_lock and sleeps 400ms while holding it.
+ * The main thread then waits 20ms for the lock, 5 times. For each wait it
+ * becomes a deadline task of 5ms every 50ms. Each wait boosts the
+ * sleeping owner, and its timeout deboosts it. Every wait must time out.
+ */
+static int pi_other_owner_asleep(void)
+{
+	pthread_t o;
+	int r, ret = KSFT_PASS;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pthread_create(&o, NULL, sleeping_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took the lock\n");
+		ret = KSFT_FAIL;
+	}
+	if (ret == KSFT_PASS)
+		sleep_ns(20 * NSEC_PER_MSEC);
+	for (r = 0; r < 5 && ret == KSFT_PASS; r++) {
+		if (wait_lock_for(20, 1)) {
+			ksft_print_msg("round %d of 5 failed\n", r + 1);
+			ret = KSFT_FAIL;
+		}
+	}
+	join(o);
+	return ret;
+}
+
+/*
+ * Run as the owner thread. Become a deadline task of 30ms every 100ms,
+ * and take pi_lock. Hold it for 300ms, spinning 2ms and sleeping 5ms in
+ * turn. A waiter boosts the owner when its deadline is the earlier one.
+ */
+static void *dl_owner(void *arg)
+{
+	uint64_t end;
+
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		owner_holds = -1;
+		return (void *)1;
+	}
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	end = now_ns() + 300 * NSEC_PER_MSEC;
+	while (now_ns() < end) {
+		spin_ns(2 * NSEC_PER_MSEC);
+		sleep_ns(5 * NSEC_PER_MSEC);
+	}
+	drop_pi_lock();
+	return NULL;
+}
+
+/*
+ * A deadline owner of 30ms every 100ms holds pi_lock for 300ms. The main
+ * thread waits 20ms for the lock, five times. For each wait it becomes a
+ * deadline task of 5ms every 50ms. Every wait must time out, and the
+ * owner must end without an error.
+ */
+static int pi_deadline_owner(void)
+{
+	int r, ret = KSFT_PASS, err;
+	pthread_t o;
+	void *res;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pthread_create(&o, NULL, dl_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the deadline owner never took the lock\n");
+		ret = KSFT_FAIL;
+	}
+	for (r = 0; r < 5 && ret == KSFT_PASS; r++)
+		if (wait_lock_for(20, 1))
+			ret = KSFT_FAIL;
+	err = pthread_join(o, &res);
+	if (err)
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+	return res || err ? KSFT_FAIL : ret;
+}
+
+/*
+ * The owner thread: take pi_lock and spin 50ms with it. The unlock
+ * deboosts it while it runs.
+ */
+static void *running_owner(void *arg)
+{
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	spin_ns(50 * NSEC_PER_MSEC);
+	drop_pi_lock();
+	return NULL;
+}
+
+/*
+ * A SCHED_OTHER owner takes pi_lock and spins 50ms. The main thread waits
+ * for the lock as a deadline task of 5ms every 50ms, which boosts the
+ * running owner. The owner's unlock deboosts it while it runs. The main
+ * thread must get the lock within 1s. Do this five times.
+ */
+static int pi_unlock_running(void)
+{
+	pthread_t o;
+	int r, ret = KSFT_PASS;
+
+	for (r = 0; r < 5 && ret == KSFT_PASS; r++) {
+		if (pi_init())
+			return KSFT_SKIP;
+		if (pthread_create(&o, NULL, running_owner, NULL)) {
+			ksft_print_msg("the owner thread could not start\n");
+			return KSFT_FAIL;
+		}
+		if (wait_for_step(5000, 100 * NSEC_PER_USEC, owner_holds) ||
+		    owner_holds != 2) {
+			ksft_print_msg("the owner never took the lock\n");
+			ret = KSFT_FAIL;
+		} else if (wait_lock_for(1000, 0)) {
+			ret = KSFT_FAIL;
+		}
+		join(o);
+		pi_fini();
+	}
+	return ret;
+}
+
+/* Parameter changes */
+
+static atomic_int t_state;	/* 1: about to sleep, or spinning */
+static _Atomic pid_t t_tid;
+static sem_t t_exit;
+
+/*
+ * The sleeper thread: become a deadline task of 20ms every 100ms. Run
+ * @arg ns of a fresh period, then sleep until t_exit is posted.
+ */
+static void *runs_then_sleeps(void *arg)
+{
+	uint64_t run = (uint64_t)(long)arg;
+
+	t_tid = gettid_();
+	if (set_deadline(0, 20 * NSEC_PER_MSEC, PERIOD)) {
+		t_state = -1;
+		return (void *)1;
+	}
+	sleep_ns(PERIOD);	/* a fresh period */
+	spin_ns(run);
+	t_state = 1;
+	sem_wait_sig(&t_exit);
+	return NULL;
+}
+
+/*
+ * Start runs_then_sleeps() in @t, to run @run ns. Return 0 once it is
+ * about to sleep, or -1.
+ */
+static int start_sleeper(pthread_t *t, uint64_t run)
+{
+	t_state = 0;
+	if (sem_init(&t_exit, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return -1;
+	}
+	if (pthread_create(t, NULL, runs_then_sleeps, (void *)(long)run)) {
+		ksft_print_msg("the sleeper thread could not start\n");
+		return -1;
+	}
+	if (wait_for_step(5000, 100 * NSEC_PER_USEC, t_state) || t_state != 1) {
+		ksft_print_msg("the sleeper was refused SCHED_DEADLINE\n");
+		sem_post(&t_exit);	/* in case it gets there late */
+		join(*t);
+		return -1;
+	}
+	return 0;
+}
+
+static void stop_sleeper(pthread_t t)
+{
+	if (sem_post(&t_exit))
+		ksft_print_msg("sem_post: %s\n", strerror(errno));
+	join(t);
+}
+
+/* Return 0 if the root domain of @cg admits @want probe tasks now, or -1. */
+static int admits_in(const char *cg, int want, const char *what)
+{
+	int n = probe(cg);
+
+	if (n != want) {
+		ksft_print_msg("%s: %d probe tasks admitted, %d expected\n", what, n, want);
+		return -1;
+	}
+	return 0;
+}
+
+/* Do the same check in the root domain of the caller's cgroup. */
+static int admits(int want, const char *what)
+{
+	return admits_in(NULL, want, what);
+}
+
+/*
+ * A deadline task of 20ms every 100ms sleeps in P, past its 0-lag time.
+ * The main thread changes its runtime to 40ms, 10ms, 30ms and 20ms. After
+ * each change, P must admit one probe task fewer for each 10ms of the new
+ * runtime.
+ */
+static int params_asleep(void)
+{
+	static const uint64_t rt[] = { 40, 10, 30, 20 };
+	int base, i, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (start_sleeper(&t, NSEC_PER_MSEC))
+		return KSFT_FAIL;
+	sleep_ns(2 * PERIOD);
+	/*
+	 * probe(NULL) probes P: this process is in P. The sleeper holds 20%,
+	 * which is two probe tasks. base is what P admits without it.
+	 */
+	base = probe(NULL) + 2;
+	for (i = 0; i < 4 && ret == KSFT_PASS; i++) {
+		char what[64];
+
+		if (set_deadline(t_tid, rt[i] * NSEC_PER_MSEC, PERIOD)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		snprintf(what, sizeof(what), "asleep, changed to %llums every 100ms",
+			 (unsigned long long)rt[i]);
+		if (admits(base - (int)(rt[i] / 10), what))
+			ret = KSFT_FAIL;
+	}
+	stop_sleeper(t);
+	return ret;
+}
+
+/*
+ * A deadline task of 20ms every 100ms runs 5ms in a new period, then
+ * sleeps. Its 0-lag time is then about 20ms ahead. 1ms later, the main
+ * thread changes its runtime to 40ms, then to 10ms. measured() checks
+ * that P admits as many probe tasks after the case as before.
+ */
+static int params_non_contending(void)
+{
+	pthread_t t;
+	int ret = KSFT_PASS;
+
+	if (start_sleeper(&t, 5 * NSEC_PER_MSEC))
+		return KSFT_FAIL;
+	sleep_ns(NSEC_PER_MSEC);
+	if (set_deadline(t_tid, 40 * NSEC_PER_MSEC, PERIOD) ||
+	    set_deadline(t_tid, 10 * NSEC_PER_MSEC, PERIOD))
+		ret = KSFT_FAIL;
+	stop_sleeper(t);
+	return ret;
+}
+
+/*
+ * Read dl_bw->total_bw of @cpu from sched_debug: the bandwidth that the
+ * root domain of @cpu counts. Return it, or -1.
+ */
+static long long total_bw_of(int cpu)
+{
+	char line[256], want[32];
+	FILE *f = fopen("/sys/kernel/debug/sched/debug", "r");
+	long long bw = -1;
+	int in = 0;
+
+	if (!f)
+		return -1;
+	snprintf(want, sizeof(want), "dl_rq[%d]:", cpu);
+	while (fgets(line, sizeof(line), f)) {
+		char *val = strchr(line, ':');
+
+		if (!strncmp(line, want, strlen(want)))
+			in = 1;
+		else if (in && !strncmp(line, "dl_rq[", 6))
+			break;			/* the next CPU's */
+		else if (in && val && strstr(line, ".dl_bw->total_bw") &&
+			 sscanf(val + 1, "%lld", &bw) == 1)
+			break;
+	}
+	fclose(f);
+	return bw;
+}
+
+/* The bandwidth of @runtime every @period, as the kernel counts it */
+static long long bw_of(uint64_t runtime, uint64_t period)
+{
+	return (long long)((runtime << 20) / period);
+}
+
+/*
+ * A deadline task of 20ms every 100ms runs 10ms of a new period, then
+ * sleeps. The main thread changes its parameters, then switches it to
+ * SCHED_OTHER. task_non_contending() computes its 0-lag time from the
+ * 10ms left and the new parameters. The root domain keeps the new
+ * bandwidth in its total_bw until then.
+ *  - Changed to 5ms every 100ms, the 10ms left overflow the new
+ *    parameters. The 0-lag time has passed. The bandwidth must be
+ *    released at once. The old parameters would keep it about 40ms more.
+ *  - Changed to 50ms every 100ms, the 10ms left fit. The 0-lag time is
+ *    20ms before the deadline, about 70ms ahead. The bandwidth must still
+ *    be counted right after the switch, and released after the deadline.
+ */
+static int params_switched_asleep(void)
+{
+	static const uint64_t rt[] = { 5, 50 };
+	int cpu = top_cpu(1), i, ret = KSFT_PASS;
+	long long base, bw, want;
+	pthread_t t;
+
+	if (total_bw_of(cpu) < 0) {
+		ksft_print_msg("sched_debug tells of no total_bw\n");
+		return KSFT_SKIP;
+	}
+	for (i = 0; i < 2 && ret == KSFT_PASS; i++) {
+		base = total_bw_of(cpu);
+		if (start_sleeper(&t, 10 * NSEC_PER_MSEC))
+			return KSFT_FAIL;
+		if (wait_for_step(5, 50 * NSEC_PER_USEC, proc_state_of(t_tid) == 'S') ||
+		    set_deadline(t_tid, rt[i] * NSEC_PER_MSEC, PERIOD) ||
+		    set_other(t_tid)) {
+			ksft_print_msg("%llums every 100ms: the sleeper was not changed\n",
+				       (unsigned long long)rt[i]);
+			ret = KSFT_FAIL;
+		} else {
+			bw = total_bw_of(cpu);
+			want = base + (i ? bw_of(rt[i] * NSEC_PER_MSEC, PERIOD) : 0);
+			if (bw != want) {
+				ksft_print_msg("%llums every 100ms: total_bw %lld after the switch, %lld expected\n",
+					       (unsigned long long)rt[i], bw, want);
+				ret = KSFT_FAIL;
+			}
+			sleep_ns(PERIOD);	/* past the deadline */
+			bw = total_bw_of(cpu);
+			if (ret == KSFT_PASS && bw != base) {
+				ksft_print_msg("%llums every 100ms: total_bw %lld after the deadline, %lld expected\n",
+					       (unsigned long long)rt[i], bw, base);
+				ret = KSFT_FAIL;
+			}
+		}
+		stop_sleeper(t);
+	}
+	return ret;
+}
+
+/* Become a deadline task of 150s every 300s, then sleep until t_exit. */
+static void *long_sleeper(void *arg)
+{
+	t_tid = gettid_();
+	if (set_deadline(0, 150 * NSEC_PER_SEC, 300 * NSEC_PER_SEC)) {
+		t_state = -1;
+		return (void *)1;
+	}
+	t_state = 1;
+	sem_wait_sig(&t_exit);
+	return NULL;
+}
+
+/*
+ * Raise the period limit to 300s. A deadline task of 150s every 300s
+ * sleeps at once, with about 150s left. The main thread shrinks its
+ * runtime to 1024ns, then switches it to SCHED_OTHER. The runtime left
+ * scaled by the new dl_period / dl_runtime does not fit in 64 bits. The
+ * 0-lag time has passed, so the bandwidth must be released at once.
+ */
+static int params_shrunk_long_period(void)
+{
+	static const char *sysctl = "/proc/sys/kernel/sched_deadline_period_max_us";
+	int cpu = top_cpu(1), ret = KSFT_PASS;
+	char old[32];
+	long long base, bw;
+	pthread_t t;
+
+	base = total_bw_of(cpu);
+	if (base < 0) {
+		ksft_print_msg("sched_debug tells of no total_bw\n");
+		return KSFT_SKIP;
+	}
+	if (read_file(sysctl, old, sizeof(old)) ||
+	    write_file("/proc/sys/kernel", "sched_deadline_period_max_us", "300000000")) {
+		ksft_print_msg("cannot raise the period limit\n");
+		return KSFT_SKIP;
+	}
+	t_state = 0;
+	if (sem_init(&t_exit, 0, 0) || pthread_create(&t, NULL, long_sleeper, NULL)) {
+		ksft_print_msg("the sleeper thread could not start\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_for_step(5000, 100 * NSEC_PER_USEC, t_state) || t_state != 1 ||
+	    wait_for_step(5, 50 * NSEC_PER_USEC, proc_state_of(t_tid) == 'S') ||
+	    set_deadline(t_tid, 1024, 300 * NSEC_PER_SEC) || set_other(t_tid)) {
+		ksft_print_msg("the sleeper was not changed\n");
+		ret = KSFT_FAIL;
+	} else {
+		bw = total_bw_of(cpu);
+		if (bw != base) {
+			ksft_print_msg("total_bw %lld after the switch, %lld expected\n", bw, base);
+			ret = KSFT_FAIL;
+		}
+	}
+	sem_post(&t_exit);
+	join(t);
+out:
+	old[strcspn(old, "\n")] = 0;
+	if (write_file("/proc/sys/kernel", "sched_deadline_period_max_us", old))
+		ksft_print_msg("could not restore the period limit to %s\n", old);
+	return ret;
+}
+
+static atomic_int spin_stop;
+/* Set before dl_spinner() starts. */
+static uint64_t spin_runtime, spin_flags;
+
+static void *dl_spinner(void *arg)
+{
+	t_tid = gettid_();
+	if (set_deadline_flags(0, spin_runtime, PERIOD, spin_flags)) {
+		t_state = -1;
+		return (void *)1;
+	}
+	t_state = 1;
+	while (!spin_stop)
+		;
+	return NULL;
+}
+
+/*
+ * Start dl_spinner() in @t, a deadline task of @runtime every 100ms with
+ * @flags. Return 0, or -1.
+ */
+static int start_spinner(pthread_t *t, uint64_t runtime, uint64_t flags)
+{
+	t_state = 0;
+	spin_stop = 0;
+	spin_runtime = runtime;
+	spin_flags = flags;
+	if (pthread_create(t, NULL, dl_spinner, NULL)) {
+		ksft_print_msg("the spinner thread could not start\n");
+		return -1;
+	}
+	if (!wait_for(5000, t_state) && t_state == 1)
+		return 0;
+	spin_stop = 1;		/* in case it gets there late */
+	join(*t);
+	return -1;
+}
+
+static void stop_spinner(pthread_t t)
+{
+	spin_stop = 1;
+	/* The thread may have left the class already. That is fine. */
+	set_other(t_tid);
+	join(t);
+}
+
+/*
+ * Wait until @t stops using CPU time: it is throttled. Return 0, or -1
+ * if that takes over 1s or its CPU time cannot be read.
+ */
+static int wait_throttled(pthread_t t)
+{
+	uint64_t end = now_ns() + NSEC_PER_SEC, last = cpu_time_of(t);
+
+	while (last && now_ns() < end) {
+		uint64_t cur;
+
+		sleep_ns(3 * NSEC_PER_MSEC);
+		cur = cpu_time_of(t);
+		if (cur == last)
+			return 0;
+		last = cur;
+	}
+	return -1;
+}
+
+/* Return 0 if @t runs 1ms more within @ns, or -1. */
+static int progresses(pthread_t t, uint64_t ns)
+{
+	uint64_t start = cpu_time_of(t), end = now_ns() + ns;
+
+	while (now_ns() < end) {
+		if (cpu_time_of(t) > start + NSEC_PER_MSEC)
+			return 0;
+		sleep_ns(2 * NSEC_PER_MSEC);
+	}
+	return -1;
+}
+
+/*
+ * A deadline task of 10ms every 100ms spins. Five times, wait until it is
+ * throttled, then change its runtime from the main thread: to 20ms, then
+ * back to 10ms, in turn. After each change it must run 1ms more within
+ * three periods.
+ */
+static int params_throttled(void)
+{
+	int r, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (start_spinner(&t, 10 * NSEC_PER_MSEC, 0))
+		return KSFT_FAIL;
+	for (r = 0; r < 5 && ret == KSFT_PASS; r++) {
+		if (wait_throttled(t) ||
+		    set_deadline(t_tid, (r & 1 ? 10 : 20) * NSEC_PER_MSEC, PERIOD)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		if (progresses(t, 3 * PERIOD)) {
+			ksft_print_msg("throttled, parameters changed: never ran again\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	stop_spinner(t);
+	return ret;
+}
+
+/*
+ * A deadline task of 20ms every 100ms sleeps in P. The main thread tries
+ * to raise its runtime by more than P has free. sched_setattr() must fail
+ * with EBUSY, and P must admit as many probe tasks after as before.
+ */
+static int params_refused(void)
+{
+	pthread_t t;
+	int ret = KSFT_PASS, base, err;
+
+	if (start_sleeper(&t, NSEC_PER_MSEC))
+		return KSFT_FAIL;
+	sleep_ns(2 * PERIOD);
+	base = probe(NULL);
+	/*
+	 * P has room for base probe tasks of 10%, and not for one more. So
+	 * growing the task's runtime by (base + 1) * 10ms must be refused,
+	 * whatever the admission limit.
+	 */
+	if (20 + 10 * (base + 1) > 100) {
+		stop_sleeper(t);
+		ksft_print_msg("P has more room than one of its tasks can take\n");
+		return KSFT_SKIP;
+	}
+	err = set_deadline(t_tid, (20 + 10 * (uint64_t)(base + 1)) * NSEC_PER_MSEC, PERIOD);
+	if (err != -EBUSY) {
+		ksft_print_msg("an increase beyond P's room: %s, not EBUSY\n",
+			       err ? strerror(-err) : "accepted");
+		ret = KSFT_FAIL;
+	} else if (admits(base, "after a refused increase")) {
+		ret = KSFT_FAIL;
+	}
+	stop_sleeper(t);
+	return ret;
+}
+
+/*
+ * A SCHED_OTHER task with a slice of 40ms asks for SCHED_DEADLINE with
+ * SCHED_FLAG_KEEP_PARAMS. That changes the class, so it must be refused
+ * with EINVAL. It must not reserve bandwidth for the parameters it would
+ * keep, which take the slice as their runtime.
+ */
+static int params_keep_class_change(void)
+{
+	struct dl_attr attr = {
+		.size = sizeof(attr),
+		.sched_policy = SCHED_OTHER,
+		.sched_runtime = 40 * NSEC_PER_MSEC,
+	};
+	int err;
+
+	if (syscall(SYS_sched_setattr, 0, &attr, 0)) {
+		ksft_print_msg("a slice of its own is refused: %s\n", strerror(errno));
+		return KSFT_SKIP;
+	}
+	attr.sched_policy = SCHED_DEADLINE;
+	attr.sched_flags = SCHED_FLAG_KEEP_PARAMS;
+	attr.sched_deadline = PERIOD;
+	attr.sched_period = PERIOD;
+	err = syscall(SYS_sched_setattr, 0, &attr, 0) ? -errno : 0;
+	if (err != -EINVAL) {
+		ksft_print_msg("to SCHED_DEADLINE with SCHED_FLAG_KEEP_PARAMS: %s, not EINVAL\n",
+			       err ? strerror(-err) : "accepted");
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+/*
+ * The waiter thread: wait up to 300ms for pi_lock as a deadline task,
+ * which boosts the owner. Return NULL if the wait timed out.
+ */
+static void *boosting_waiter(void *arg)
+{
+	return (void *)(long)wait_lock_for(300, 1);
+}
+
+/*
+ * Start a boosting_waiter() thread in @w. Wait up to 200ms for it to boost
+ * the owner. Return 0 once the owner is boosted. Otherwise report the
+ * failure, join the waiter and return -1.
+ */
+static int start_boost(pthread_t *w)
+{
+	if (pthread_create(w, NULL, boosting_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		return -1;
+	}
+	if (!wait_for(200, prio_of(owner_tid) == DL_TASK_PRIO))
+		return 0;
+	ksft_print_msg("the waiter never boosted the owner\n");
+	join(*w);
+	return -1;
+}
+
+/*
+ * Join the boosting_waiter() thread @w. Return -1 if its wait did not
+ * time out.
+ */
+static int join_waiter(pthread_t w)
+{
+	void *res;
+	int err = pthread_join(w, &res);
+
+	if (err)
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+	return err || res ? -1 : 0;
+}
+
+/*
+ * A SCHED_OTHER owner holds pi_lock and sleeps. The main thread gives it
+ * a slice of 40ms with sched_setattr(). A deadline waiter then boosts the
+ * owner into the deadline class. The main thread then calls
+ * sched_setattr() on the owner, with SCHED_DEADLINE and
+ * SCHED_FLAG_KEEP_PARAMS.
+ *
+ * The call must fail with EINVAL. The boost put the owner in the deadline
+ * class, but its policy is still SCHED_OTHER. So the call asks for another
+ * policy, which SCHED_FLAG_KEEP_PARAMS cannot give. If the call were
+ * admitted, it would reserve bandwidth for the 40ms slice, and nothing
+ * would release it.
+ */
+static int params_keep_boosted(void)
+{
+	struct dl_attr slice = {
+		.size = sizeof(slice),
+		.sched_policy = SCHED_OTHER,
+		.sched_runtime = 40 * NSEC_PER_MSEC,	/* the slice to keep */
+	};
+	struct dl_attr keep = {
+		.size = sizeof(keep),
+		.sched_policy = SCHED_DEADLINE,
+		.sched_flags = SCHED_FLAG_KEEP_PARAMS,
+		.sched_deadline = PERIOD,
+		.sched_period = PERIOD,
+	};
+	int ret = KSFT_PASS, err;
+	pthread_t o, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pthread_create(&o, NULL, sleeping_owner, (void *)0L)) {
+		ksft_print_msg("the owner thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took the lock\n");
+		join(o);
+		return KSFT_FAIL;
+	}
+	if (syscall(SYS_sched_setattr, owner_tid, &slice, 0)) {
+		ksft_print_msg("the owner cannot take a slice of its own: %s\n",
+			       strerror(errno));
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	if (start_boost(&w)) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	err = syscall(SYS_sched_setattr, owner_tid, &keep, 0) ? -errno : 0;
+	if (err != -EINVAL) {
+		ksft_print_msg("KEEP_PARAMS to SCHED_DEADLINE on a boosted owner: %s, not EINVAL\n",
+			       err ? strerror(-err) : "accepted");
+		ret = KSFT_FAIL;
+	}
+	if (join_waiter(w))
+		ret = KSFT_FAIL;	/* the waiter said why */
+out:
+	join(o);
+	return ret;
+}
+
+/*
+ * A deadline waiter boosts a sleeping SCHED_OTHER owner. The main thread
+ * then calls sched_setattr() on the owner, with SCHED_OTHER. The call
+ * must succeed while the owner is boosted.
+ */
+static int boosted_owner_policy(void)
+{
+	int ret = KSFT_PASS, err;
+	pthread_t o, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pthread_create(&o, NULL, sleeping_owner, (void *)0L)) {
+		ksft_print_msg("the owner thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took the lock\n");
+		join(o);
+		return KSFT_FAIL;
+	}
+	if (start_boost(&w)) {
+		join(o);
+		return KSFT_FAIL;
+	}
+	err = set_other(owner_tid);
+	if (err) {
+		ksft_print_msg("SCHED_OTHER on a boosted owner: %s\n", strerror(-err));
+		ret = KSFT_FAIL;
+	}
+	if (join_waiter(w))
+		ret = KSFT_FAIL;	/* the waiter said why */
+	join(o);
+	return ret;
+}
+
+static atomic_int owner_first_period_ms;
+static _Atomic pid_t donor_tid;
+
+/*
+ * Run as the owner O of deboost_resets_period(). Store the CPU time of
+ * step 4, in ms, in owner_first_period_ms. Return NULL, 1 on an error, or
+ * 2 if no waiter boosted it within 1s.
+ */
+static void *deboosted_owner(void *arg)
+{
+	uint64_t t0, cpu0;
+	int err;
+
+	owner_tid = gettid_();
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	t0 = now_ns();
+	while (prio_of(owner_tid) != DL_TASK_PRIO) {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			drop_pi_lock();
+			return (void *)2;	/* never boosted */
+		}
+	}
+	spin_ns(5 * NSEC_PER_MSEC);
+	drop_pi_lock();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	t0 = now_ns();
+	cpu0 = thread_time_ns();
+	while (now_ns() - t0 < PERIOD)
+		;
+	owner_first_period_ms = (thread_time_ns() - cpu0) / NSEC_PER_MSEC;
+	return NULL;
+}
+
+/*
+ * The waiter thread: take pi_lock as a deadline task of 40ms every
+ * 100ms. It boosts the owner, which then runs on the waiter's runtime.
+ * Return NULL once it got the lock.
+ */
+static void *donor_waiter(void *arg)
+{
+	int err;
+
+	donor_tid = gettid_();
+	err = set_deadline(0, 40 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("a waiter refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	err = take_pi_lock();
+	if (!err)
+		drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("a waiter cannot leave SCHED_DEADLINE\n");
+	return (void *)(long)err;
+}
+
+/*
+ * The owner O starts as SCHED_OTHER. The donor D is the waiter that
+ * boosts it: a deadline task of 40ms every 100ms.
+ * 1. O takes pi_lock and spins.
+ * 2. D blocks on pi_lock. This boosts O, which then runs on D's runtime.
+ * 3. O spins 5ms more and unlocks. The unlock deboosts O.
+ * 4. O becomes a deadline task of 10ms every 100ms. It spins for 100ms
+ *    and measures its CPU time.
+ *
+ * O must get about 10ms in step 4. The case fails above 20ms: O then
+ * still runs on the runtime that the boost left.
+ */
+static int deboost_resets_period(void)
+{
+	int err, ret = KSFT_PASS;
+	void *o_ret, *w_ret;
+	pthread_t o, w;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	owner_first_period_ms = -1;
+	if (pthread_create(&o, NULL, deboosted_owner, NULL)) {
+		ksft_print_msg("the owner thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took the lock\n");
+		join(o);
+		return KSFT_FAIL;
+	}
+	if (pthread_create(&w, NULL, donor_waiter, NULL)) {
+		ksft_print_msg("the waiter thread could not start\n");
+		join(o);
+		return KSFT_FAIL;
+	}
+	err = pthread_join(w, &w_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	} else if (w_ret) {
+		ret = KSFT_FAIL;	/* the waiter said why */
+	}
+	err = pthread_join(o, &o_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	} else if (o_ret == (void *)2) {
+		ksft_print_msg("the waiter never boosted the owner\n");
+		ret = KSFT_FAIL;
+	} else if (owner_first_period_ms < 0) {
+		ret = KSFT_FAIL;
+	} else if (owner_first_period_ms > 20) {
+		ksft_print_msg("the owner ran %d ms of its first 100: the donor's runtime\n",
+			       (int)owner_first_period_ms);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * Return the runtime that the deadline task @tid has left, in ns, from
+ * dl.runtime in /proc/<tid>/sched. Return -1 if it cannot be read.
+ */
+static long long dl_runtime_left(pid_t tid)
+{
+	char path[64], line[256];
+	long long left = -1;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%d/sched", tid);
+	f = fopen(path, "r");
+	if (!f)
+		return -1;
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
+#define REFILL_OWN_RUNTIME	(5 * NSEC_PER_MSEC)
+#define REFILL_DONOR_RUNTIME	(2 * NSEC_PER_MSEC)
+#define REFILL_DONOR_PERIOD	(10 * NSEC_PER_MSEC)
+
+static sem_t refill_donor_ready;
+static atomic_int refill_donor_locking;
+static _Atomic long long refill_owner_left;
+
+/*
+ * Run as the donor D of deboost_keeps_own_runtime(). Become a deadline
+ * task of 2ms every 10ms and sleep until the owner holds pi_lock. Then
+ * block on pi_lock. Return NULL once it got the lock, or 1 on an error.
+ */
+static void *refill_donor(void *arg)
+{
+	int err;
+
+	donor_tid = gettid_();
+	err = set_deadline(0, REFILL_DONOR_RUNTIME, REFILL_DONOR_PERIOD);
+	if (err) {
+		ksft_print_msg("the donor refused as a deadline task: %s\n", strerror(-err));
+		donor_tid = -1;
+		sem_post(&refill_donor_ready);
+		return (void *)1;
+	}
+	sem_post(&refill_donor_ready);
+	sem_wait_sig(&owner_go);
+	refill_donor_locking = 1;
+	err = take_pi_lock();
+	if (!err)
+		drop_pi_lock();
+	if (set_other(0))
+		ksft_print_msg("the donor cannot leave SCHED_DEADLINE\n");
+	return (void *)(long)err;
+}
+
+/*
+ * Run as the owner O of deboost_keeps_own_runtime(). @arg is the CPU
+ * time, in ms, that O spins with the lock once it is boosted. Store the
+ * runtime O has left after the unlock in refill_owner_left. Return NULL,
+ * 1 on an error, or 2 if the donor did not block on the lock within 1s.
+ */
+static void *refill_owner(void *arg)
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
+	owner_holds = 2;
+	sem_post(&owner_go);
+	t0 = now_ns();
+	while (!refill_donor_locking || proc_state_of(donor_tid) != 'S') {
+		if (now_ns() - t0 > NSEC_PER_SEC) {
+			drop_pi_lock();
+			set_other(0);
+			return (void *)2;
+		}
+	}
+	spin_ns((long)arg * NSEC_PER_MSEC);
+	drop_pi_lock();
+	refill_owner_left = dl_runtime_left(owner_tid);
+	if (set_other(0))
+		ksft_print_msg("the owner cannot leave SCHED_DEADLINE\n");
+	return NULL;
+}
+
+/*
+ * Run a case on the runtime that a deadline owner has after its boost.
+ * O and D share the CPU of P.
+ *
+ *   owner O: 5ms every 100ms             donor D: 2ms every 10ms
+ *
+ *                                        sleeps
+ *   starts its period, runs 2ms
+ *   takes pi_lock
+ *   wakes D up
+ *                                        preempts O: its deadline is
+ *                                          earlier
+ *                                        blocks on pi_lock, boosts O
+ *   runs 1ms more
+ *   unlocks: the boost ends
+ *                                        takes pi_lock, unlocks
+ *   reads its dl.runtime
+ *
+ * A boosted task that runs out of runtime is not throttled. Its runtime
+ * is refilled from the parameters of its donor. Here O has used about 3ms
+ * of its own 5ms at the unlock, and was never refilled. It must keep what
+ * it has left. A new period would hand it a full runtime at every
+ * contended unlock. The case fails if O has 4ms or more.
+ */
+static int deboost_keeps_own_runtime(void)
+{
+	void *o_ret = NULL, *d_ret = NULL;
+	int err, ret = KSFT_PASS;
+	pthread_t o, d;
+	long long left;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (sem_init(&refill_donor_ready, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	refill_donor_locking = 0;
+	refill_owner_left = -1;
+	donor_tid = 0;
+	if (pthread_create(&d, NULL, refill_donor, NULL)) {
+		ksft_print_msg("the donor thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (sem_wait_for(&refill_donor_ready, 5000) || donor_tid <= 0) {
+		ksft_print_msg("the donor is not ready\n");
+		sem_post(&owner_go);
+		join(d);
+		return KSFT_FAIL;
+	}
+	if (pthread_create(&o, NULL, refill_owner, (void *)1L)) {
+		ksft_print_msg("the owner thread could not start\n");
+		sem_post(&owner_go);
+		join(d);
+		return KSFT_FAIL;
+	}
+	err = pthread_join(o, &o_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	}
+	if (o_ret == (void *)1)
+		sem_post(&owner_go);	/* the owner never woke the donor up */
+	err = pthread_join(d, &d_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	}
+	left = refill_owner_left;
+	if (o_ret == (void *)2) {
+		ksft_print_msg("the donor never blocked on the lock\n");
+		ret = KSFT_FAIL;
+	} else if (o_ret || d_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (left < 0) {
+		ksft_print_msg("the runtime of the owner cannot be read\n");
+		ret = KSFT_SKIP;
+	} else if (left >= 4 * NSEC_PER_MSEC) {
+		ksft_print_msg("the owner has %lld us after the unlock: a new runtime, with no refill from the donor\n",
+			       left / NSEC_PER_USEC);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+static sem_t ret_ready, ret_go;
+static _Atomic pid_t ret_tid;
+static atomic_int ret_first_period_ms;
+
+/*
+ * Run as the thread of return_asleep_new_params(). Become a deadline task
+ * of 50ms every 100ms and run 20ms. 30ms of runtime are left, and the
+ * 0-lag time is about 20ms ahead. Then sleep. The main thread switches
+ * the thread to SCHED_OTHER and back, with 10ms every 100ms. Then spin
+ * for 100ms, and store the CPU time used, in ms, in ret_first_period_ms.
+ * Return NULL, or 1 on an error.
+ */
+static void *returner(void *arg)
+{
+	uint64_t t0, cpu0;
+	int err;
+
+	ret_tid = gettid_();
+	err = set_deadline(0, 50 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the task refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	spin_ns(20 * NSEC_PER_MSEC);
+	sem_post(&ret_ready);
+	sem_wait_sig(&ret_go);
+	t0 = now_ns();
+	cpu0 = thread_time_ns();
+	while (now_ns() - t0 < PERIOD)
+		;
+	ret_first_period_ms = (thread_time_ns() - cpu0) / NSEC_PER_MSEC;
+	return NULL;
+}
+
+/*
+ * A task leaves SCHED_DEADLINE while it sleeps, and comes back at once
+ * with a smaller runtime. Its 0-lag time is ahead, so it keeps its
+ * deadline and the runtime it has left. returner() runs the task. It must
+ * get about 10ms of CPU time in the 100ms after the change: its new
+ * runtime, not the 30ms left from the old one. The case fails above 20ms.
+ */
+static int return_asleep_new_params(void)
+{
+	void *t_ret;
+	int err, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (sem_init(&ret_ready, 0, 0) || sem_init(&ret_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	ret_first_period_ms = -1;
+	if (pthread_create(&t, NULL, returner, NULL)) {
+		ksft_print_msg("the task thread could not start\n");
+		return KSFT_FAIL;
+	}
+	if (sem_wait_for(&ret_ready, 5000)) {
+		/* The thread may get there late. Let it end. */
+		sem_post(&ret_go);
+		join(t);
+		return KSFT_FAIL;	/* the task said why */
+	}
+	/* Before its 0-lag time, about 20ms ahead */
+	err = wait_for(10, proc_state_of(ret_tid) == 'S') ? -EAGAIN : 0;
+	if (!err)
+		err = set_other(ret_tid);
+	if (!err)
+		err = set_deadline(ret_tid, 10 * NSEC_PER_MSEC, PERIOD);
+	sem_post(&ret_go);
+	if (err) {
+		ksft_print_msg("the task could not change asleep: %s\n", strerror(-err));
+		join(t);
+		return KSFT_FAIL;
+	}
+	err = pthread_join(t, &t_ret);
+	if (err) {
+		ksft_print_msg("pthread_join: %s\n", strerror(err));
+		ret = KSFT_FAIL;
+	} else if (t_ret || ret_first_period_ms < 0) {
+		ret = KSFT_FAIL;	/* the task said why */
+	} else if (ret_first_period_ms > 20) {
+		ksft_print_msg("the task ran %d ms of its first 100: the old runtime\n",
+			       (int)ret_first_period_ms);
+		ret = KSFT_FAIL;
+	}
+	sem_destroy(&ret_ready);
+	sem_destroy(&ret_go);
+	return ret;
+}
+
+static pthread_mutex_t pi_lock2;
+static sem_t holder_go;
+static atomic_int holder_holds, chain_waits, donor_done, x_waits, l2_takes;
+static atomic_int chain_rank, x_rank;
+static _Atomic pid_t x_tid;
+
+/* The holder thread: take pi_lock2, and hold it until holder_go. */
+static void *l2_holder(void *arg)
+{
+	int err = pthread_mutex_lock(&pi_lock2);
+
+	if (err) {
+		ksft_print_msg("the holder cannot take pi_lock2: %s\n", strerror(err));
+		holder_holds = -1;
+		return (void *)1;
+	}
+	holder_holds = 1;
+	sem_wait_sig(&holder_go);
+	pthread_mutex_unlock(&pi_lock2);
+	return NULL;
+}
+
+/*
+ * Take pi_lock2. Store in @rank how many threads took it before the
+ * caller. Then unlock it. Return 0, or -1 if the lock cannot be taken.
+ */
+static int take_l2_ranked(atomic_int *rank)
+{
+	int err = pthread_mutex_lock(&pi_lock2);
+
+	if (err) {
+		ksft_print_msg("a waiter cannot take pi_lock2: %s\n", strerror(err));
+		return -1;
+	}
+	*rank = l2_takes++;
+	pthread_mutex_unlock(&pi_lock2);
+	return 0;
+}
+
+/*
+ * Run as the owner thread, a deadline task of 10ms every 200ms. Take
+ * pi_lock, and sleep until owner_go is posted. The donor boosts the owner
+ * during that sleep. Then spin 20ms. The owner's 10ms run out, and the
+ * boost refills its runtime from the donor's 40ms. Then wait on pi_lock2
+ * while holding pi_lock. The donor's timeout deboosts the owner during
+ * that wait. The owner then has more runtime left than its own 10ms.
+ * Return NULL, 1 on an error, or 2 if the spin took over 50ms: the owner
+ * was throttled, so it was not boosted.
+ */
+static void *chain_owner(void *arg)
+{
+	uint64_t t0;
+	int err;
+
+	owner_tid = gettid_();
+	err = set_deadline(0, 10 * NSEC_PER_MSEC, 2 * PERIOD);
+	if (err) {
+		ksft_print_msg("the owner refused as a deadline task: %s\n", strerror(-err));
+		owner_holds = -1;
+		return (void *)1;
+	}
+	if (take_pi_lock())
+		return (void *)1;
+	owner_holds = 2;
+	sem_wait_sig(&owner_go);
+	t0 = now_ns();
+	spin_ns(20 * NSEC_PER_MSEC);
+	if (now_ns() - t0 > PERIOD / 2) {
+		drop_pi_lock();
+		return (void *)2;	/* throttled: never boosted */
+	}
+	chain_waits = 1;
+	err = take_l2_ranked(&chain_rank);
+	drop_pi_lock();
+	return err ? (void *)1 : NULL;
+}
+
+/*
+ * The donor thread: a deadline task of 40ms every 100ms. Wait 150ms for
+ * pi_lock. Its timeout deboosts the owner, which waits on pi_lock2 then.
+ */
+static void *timed_donor(void *arg)
+{
+	struct timespec ts;
+	int err;
+
+	donor_tid = gettid_();
+	err = set_deadline(0, 40 * NSEC_PER_MSEC, PERIOD);
+	if (err) {
+		ksft_print_msg("the donor refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	clock_gettime(CLOCK_REALTIME, &ts);
+	ts.tv_nsec += 150 * 1000000L;
+	ts.tv_sec += ts.tv_nsec / 1000000000L;
+	ts.tv_nsec %= 1000000000L;
+	err = pthread_mutex_timedlock(&pi_lock, &ts);
+	donor_done = 1;
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
+ * The other waiter: a deadline task of 5ms every 50ms. Its deadline is
+ * earlier than the one the owner gets at the deboost. Wait on pi_lock2.
+ */
+static void *early_waiter(void *arg)
+{
+	int err;
+
+	x_tid = gettid_();
+	err = set_deadline(0, 5 * NSEC_PER_MSEC, PERIOD / 2);
+	if (err) {
+		ksft_print_msg("a waiter refused as a deadline task: %s\n", strerror(-err));
+		return (void *)1;
+	}
+	x_waits = 1;
+	err = take_l2_ranked(&x_rank);
+	if (set_other(0))
+		ksft_print_msg("a waiter cannot leave SCHED_DEADLINE\n");
+	return err ? (void *)1 : NULL;
+}
+
+/* Set up pi_lock2 and holder_go. Return 0, or -1. */
+static int pi_init_lock2(void)
+{
+	pthread_mutexattr_t a;
+	int err;
+
+	err = pthread_mutexattr_init(&a);
+	if (!err) {
+		err = pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT);
+		if (!err)
+			err = pthread_mutex_init(&pi_lock2, &a);
+		pthread_mutexattr_destroy(&a);
+	}
+	if (err) {
+		ksft_print_msg("no second priority inheritance mutex: %s\n", strerror(err));
+		return -1;
+	}
+	if (sem_init(&holder_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		pthread_mutex_destroy(&pi_lock2);
+		return -1;
+	}
+	holder_holds = 0;
+	chain_waits = 0;
+	donor_done = 0;
+	x_waits = 0;
+	l2_takes = 0;
+	chain_rank = -1;
+	x_rank = -1;
+	donor_tid = 0;
+	x_tid = 0;
+	return 0;
+}
+
+/*
+ * Check the order of the waiters of pi_lock2 after a deboost. The threads
+ * are:
+ * - the holder: SCHED_OTHER. It has pi_lock2.
+ * - the owner: deadline, 10ms every 200ms. It has pi_lock.
+ * - the donor: deadline, 40ms every 100ms.
+ * - the other waiter: deadline, 5ms every 50ms.
+ *
+ * 1. The donor waits on pi_lock, and boosts the owner.
+ * 2. The owner spins on the donor's runtime, then waits on pi_lock2.
+ * 3. The other waiter waits on pi_lock2.
+ * 4. The donor times out after 150ms. The deboost starts a new period
+ *    for the owner, which has more runtime left than its own 10ms.
+ * 5. The holder drops pi_lock2.
+ *
+ * The other waiter must take pi_lock2 first: its deadline is earlier
+ * than the owner's new one. At step 4 the owner is not queued, and the
+ * chain walk copies its deadline into its waiter node on pi_lock2. A
+ * deadline of 0 in the node would put the owner first.
+ */
+static int deboost_blocked_keeps_order(void)
+{
+	void *o_ret = NULL, *d_ret = NULL, *x_ret = NULL;
+	int ret = KSFT_FAIL, have_o = 0, have_d = 0, have_x = 0;
+	pthread_t h, o, d, x;
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
+	have_o = !pthread_create(&o, NULL, chain_owner, NULL);
+	if (!have_o || wait_for(5000, owner_holds) || owner_holds != 2) {
+		ksft_print_msg("the owner never took pi_lock\n");
+		goto out;
+	}
+	have_d = !pthread_create(&d, NULL, timed_donor, NULL);
+	if (!have_d || wait_for(1000, donor_tid && proc_state_of(donor_tid) == 'S')) {
+		ksft_print_msg("the donor never waited on pi_lock\n");
+		goto out;
+	}
+	sem_post(&owner_go);
+	if (wait_for(1000, chain_waits && proc_state_of(owner_tid) == 'S')) {
+		ksft_print_msg("the owner never waited on pi_lock2\n");
+		goto out;
+	}
+	if (donor_done) {
+		ksft_print_msg("the donor timed out before the owner waited on pi_lock2\n");
+		goto out;
+	}
+	have_x = !pthread_create(&x, NULL, early_waiter, NULL);
+	if (!have_x || wait_for(1000, x_waits && proc_state_of(x_tid) == 'S')) {
+		ksft_print_msg("the other waiter never waited on pi_lock2\n");
+		goto out;
+	}
+	/* The donor's timeout deboosts the owner, which waits on pi_lock2. */
+	have_d = 0;
+	if (!pthread_join(d, &d_ret) && !d_ret)
+		ret = KSFT_PASS;
+out:
+	/* The owner may get there late. Let it end. */
+	sem_post(&owner_go);
+	sem_post(&holder_go);
+	if (have_d)
+		join(d);
+	if (have_x && pthread_join(x, &x_ret))
+		ret = KSFT_FAIL;
+	if (have_o && pthread_join(o, &o_ret))
+		ret = KSFT_FAIL;
+	join(h);
+	if (o_ret == (void *)2) {
+		ksft_print_msg("the donor never boosted the owner\n");
+		ret = KSFT_FAIL;
+	} else if (o_ret || x_ret) {
+		ret = KSFT_FAIL;	/* the thread said why */
+	} else if (ret == KSFT_PASS && chain_rank < x_rank) {
+		ksft_print_msg("the deboosted owner took pi_lock2 before the earlier waiter\n");
+		ret = KSFT_FAIL;
+	}
+out_fini:
+	pthread_mutex_destroy(&pi_lock2);
+	sem_destroy(&holder_go);
+	pi_fini();
+	return ret;
+}
+
+/*
+ * The threads of pi_chain_donor_leaves(): O, M, W, Z and Y. leave_tid[]
+ * holds their tids. leave_y_ns is the CPU time Y gets in O's window, or
+ * -1.
+ */
+enum { LV_O, LV_M, LV_W, LV_Z, LV_Y, LV_N };
+static _Atomic pid_t leave_tid[LV_N];
+static atomic_int leave_err, leave_m_locking, leave_w_locking, leave_y_stop;
+static _Atomic long long leave_y_ns;
+static sem_t leave_o_go, leave_m_go;
+
+/*
+ * O: take pi_lock2 (L2), and sleep until leave_o_go. Then spin 100ms.
+ * Measure the CPU time of Y (@arg) over the next 200ms, and unlock L2.
+ */
+static void *leave_o(void *arg)
+{
+	pthread_t y = *(pthread_t *)arg;
+	uint64_t t0, y0;
+
+	if (pthread_mutex_lock(&pi_lock2)) {
+		leave_err = 1;
+		return arg;
+	}
+	leave_tid[LV_O] = gettid_();	/* O holds L2 */
+	sem_wait_sig(&leave_o_go);
+	t0 = now_ns();
+	while (now_ns() - t0 < PERIOD)
+		;
+	y0 = cpu_time_of(y);
+	t0 = now_ns();
+	while (now_ns() - t0 < 2 * PERIOD)
+		;
+	leave_y_ns = cpu_time_of(y) - y0;
+	pthread_mutex_unlock(&pi_lock2);
+	return NULL;
+}
+
+/*
+ * M: become a deadline task of 10ms every 1s, and take pi_lock (L1). At
+ * leave_m_go, block on L2, which O holds.
+ */
+static void *leave_m(void *arg)
+{
+	if (set_deadline(0, 10 * NSEC_PER_MSEC, NSEC_PER_SEC) ||
+	    pthread_mutex_lock(&pi_lock)) {
+		leave_err = 1;
+		return arg;
+	}
+	leave_tid[LV_M] = gettid_();	/* M holds L1 */
+	sem_wait_sig(&leave_m_go);
+	leave_m_locking = 1;
+	if (pthread_mutex_lock(&pi_lock2))
+		leave_err = 1;
+	else
+		pthread_mutex_unlock(&pi_lock2);
+	pthread_mutex_unlock(&pi_lock);
+	if (set_other(0))
+		leave_err = 1;
+	return arg;
+}
+
+/*
+ * W and Z: become a deadline task of @arg ms every 40 times that, and
+ * block on L1. W is the one of 5ms. The main thread switches it to
+ * SCHED_OTHER while it waits.
+ */
+static void *leave_waiter(void *arg)
+{
+	uint64_t runtime = (long)arg * NSEC_PER_MSEC;
+	int w = (long)arg == 5;
+
+	if (set_deadline(0, runtime, 40 * runtime)) {
+		leave_err = 1;
+		return arg;
+	}
+	leave_tid[w ? LV_W : LV_Z] = gettid_();
+	if (w)
+		leave_w_locking = 1;
+	if (pthread_mutex_lock(&pi_lock))
+		leave_err = 1;
+	else
+		pthread_mutex_unlock(&pi_lock);
+	if (set_other(0))
+		leave_err = 1;
+	return arg;
+}
+
+/* Y: become a deadline task of 30ms every 100ms, and spin. */
+static void *leave_y(void *arg)
+{
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		leave_err = 1;
+		return arg;
+	}
+	leave_tid[LV_Y] = gettid_();
+	while (!leave_y_stop)
+		;
+	return arg;
+}
+
+/*
+ * A chain walk must pass a new donor on to the end of the chain. This
+ * holds even when the sort keys of the task in the middle do not change.
+ *
+ * L1 is pi_lock and L2 is pi_lock2. All threads run on the CPU of P.
+ * Each deadline thread calls sched_setattr() on itself when it starts.
+ * The threads are:
+ * - O: SCHED_OTHER.
+ * - M: a deadline task of 10ms every 1s.
+ * - W: a deadline task of 5ms every 200ms.
+ * - Z: a deadline task of 2ms every 80ms.
+ * - Y: a deadline task of 30ms every 100ms. It spins all along.
+ *
+ * 1. O takes L2, and sleeps.
+ * 2. M takes L1, and sleeps.
+ * 3. W blocks on L1. W's deadline is earlier than M's, so W boosts M. M
+ *    keeps its own deadline.
+ * 4. M blocks on L2. M passes W on to O, as O's donor. O enters the
+ *    deadline class. It sleeps, so it gets no runtime yet.
+ * 5. Z blocks on L1. Z's deadline is earlier than W's, so Z becomes M's
+ *    donor. M sleeps, so its deadline does not move. The chain walk must
+ *    go on to O and make Z O's donor too.
+ * 6. The main thread switches W to SCHED_OTHER. W sleeps and has run
+ *    almost nothing, so its parameters are cleared at once.
+ * 7. 250ms later, the main thread wakes O up. O has no deadline ahead, so
+ *    its wakeup starts a new period from its donor. O spins 100ms.
+ *    Then it measures the CPU time Y gets over 200ms, and unlocks L2.
+ *
+ * With Z as its donor, O gets 2ms every 80ms. Y's deadline is soon the
+ * earlier one, and Y gets about its 60ms. With W as its donor, O runs on
+ * cleared parameters. Each refill gives it no runtime and a deadline of
+ * about now. O then runs before Y all the time, and Y gets close to
+ * nothing. The case fails if Y gets less than 30ms.
+ *
+ * W does not exit before O unlocks L2. It waits for L1, which M releases
+ * after it gets L2.
+ */
+static int pi_chain_donor_leaves(void)
+{
+	int ret = KSFT_FAIL, i, have[LV_N] = { 0 };
+	pthread_t t[LV_N];
+	long long y_ns;
+	int err;
+
+	if (pi_init())
+		return KSFT_SKIP;
+	if (pi_init_lock2()) {
+		pi_fini();
+		return KSFT_SKIP;
+	}
+	if (sem_init(&leave_o_go, 0, 0) || sem_init(&leave_m_go, 0, 0)) {
+		ksft_print_msg("sem_init: %s\n", strerror(errno));
+		goto out_fini;
+	}
+	for (i = 0; i < LV_N; i++)
+		leave_tid[i] = 0;
+	leave_err = 0;
+	leave_m_locking = 0;
+	leave_w_locking = 0;
+	leave_y_stop = 0;
+	leave_y_ns = -1;
+	have[LV_Y] = !pthread_create(&t[LV_Y], NULL, leave_y, NULL);
+	if (!have[LV_Y] || wait_for(1000, leave_tid[LV_Y] || leave_err)) {
+		ksft_print_msg("Y never became a deadline task\n");
+		goto out;
+	}
+	have[LV_O] = !pthread_create(&t[LV_O], NULL, leave_o, &t[LV_Y]);
+	if (!have[LV_O] || wait_for(1000, leave_tid[LV_O] || leave_err)) {
+		ksft_print_msg("O never took L2\n");
+		goto out;
+	}
+	have[LV_M] = !pthread_create(&t[LV_M], NULL, leave_m, NULL);
+	if (!have[LV_M] || wait_for(1000, leave_tid[LV_M] || leave_err)) {
+		ksft_print_msg("M never took L1\n");
+		goto out;
+	}
+	have[LV_W] = !pthread_create(&t[LV_W], NULL, leave_waiter, (void *)5L);
+	if (!have[LV_W] ||
+	    wait_for(1000, (leave_w_locking && proc_state_of(leave_tid[LV_W]) == 'S') ||
+			   leave_err)) {
+		ksft_print_msg("W never blocked on L1\n");
+		goto out;
+	}
+	sem_post(&leave_m_go);
+	if (wait_for(1000, (leave_m_locking && prio_of(leave_tid[LV_O]) == DL_TASK_PRIO) ||
+			   leave_err)) {
+		ksft_print_msg("O was not boosted through M\n");
+		goto out;
+	}
+	have[LV_Z] = !pthread_create(&t[LV_Z], NULL, leave_waiter, (void *)2L);
+	if (!have[LV_Z] ||
+	    wait_for(1000, (leave_tid[LV_Z] && proc_state_of(leave_tid[LV_Z]) == 'S') ||
+			   leave_err)) {
+		ksft_print_msg("Z never blocked on L1\n");
+		goto out;
+	}
+	sleep_ns(10 * NSEC_PER_MSEC);	/* the chain walk of Z is done */
+	err = leave_err ? -EINVAL : set_other(leave_tid[LV_W]);
+	if (err) {
+		ksft_print_msg("W cannot leave SCHED_DEADLINE: %s\n", strerror(-err));
+		goto out;
+	}
+	sleep_ns(250 * NSEC_PER_MSEC);
+	ret = KSFT_PASS;
+out:
+	/* Let every thread end: O unlocks L2, then M unlocks L1. */
+	sem_post(&leave_m_go);
+	sem_post(&leave_o_go);
+	for (i = LV_O; i < LV_Y; i++)
+		if (have[i])
+			join(t[i]);
+	leave_y_stop = 1;
+	if (have[LV_Y])
+		join(t[LV_Y]);
+	y_ns = leave_y_ns;
+	if (leave_err) {
+		ksft_print_msg("a thread of the chain failed\n");
+		ret = KSFT_FAIL;
+	} else if (ret == KSFT_PASS && y_ns < 30 * (long long)NSEC_PER_MSEC) {
+		ksft_print_msg("Y ran %lld ms of 200: O ran on the cleared parameters of W\n",
+			       y_ns / (long long)NSEC_PER_MSEC);
+		ret = KSFT_FAIL;
+	}
+	sem_destroy(&leave_o_go);
+	sem_destroy(&leave_m_go);
+out_fini:
+	pthread_mutex_destroy(&pi_lock2);
+	sem_destroy(&holder_go);
+	pi_fini();
+	return ret;
+}
+
+/* cpuset moves, from the main process, outside P */
+
+/* Shared with the processes of a case: atomic in shared memory. */
+static atomic_int *mv_state;
+
+/*
+ * Wait up to 5s for a child to report in mv_state[0]. Return 0 if it is
+ * up (1). Return -1 if it was refused SCHED_DEADLINE (-1), could not
+ * start its threads (-2) or did not report. @fast polls every 100us.
+ */
+static int child_up(const char *what, int fast)
+{
+	if (wait_for_step(5000, fast ? 100 * NSEC_PER_USEC : NSEC_PER_MSEC, mv_state[0])) {
+		ksft_print_msg("%s: the task never started\n", what);
+		return -1;
+	}
+	if (mv_state[0] == -2) {
+		ksft_print_msg("%s: the process cannot start its threads\n", what);
+		return -1;
+	}
+	if (mv_state[0] != 1) {
+		ksft_print_msg("%s: the task was refused SCHED_DEADLINE\n", what);
+		return -1;
+	}
+	return 0;
+}
+
+enum mv_mode { MV_ASLEEP, MV_THROTTLED, MV_NON_CONTENDING };
+
+/*
+ * Fork a process in the caller's cgroup. The process becomes a deadline
+ * task of @runtime every 100ms, and does what @mode says:
+ * - MV_ASLEEP: run 1ms, set mv_state[0] to 1, then sleep.
+ * - MV_THROTTLED: set mv_state[0] to 1, then spin and count in
+ *   mv_state[1].
+ * - MV_NON_CONTENDING: sleep a period, run a quarter of its runtime, set
+ *   mv_state[0] to 1, then sleep. Its 0-lag time is still ahead.
+ * If it is refused SCHED_DEADLINE, the process sets mv_state[0] to -1 and
+ * exits. Return its pid, or -1.
+ */
+static pid_t mover(enum mv_mode mode, uint64_t runtime)
+{
+	pid_t pid = fork_child("a deadline task");
+
+	if (!pid) {
+		if (set_deadline(0, runtime, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		if (mode == MV_ASLEEP) {
+			spin_ns(NSEC_PER_MSEC);
+			*mv_state = 1;
+			for (;;)
+				pause();
+		}
+		if (mode == MV_NON_CONTENDING) {
+			sleep_ns(PERIOD);
+			spin_ns(runtime / 4);
+			*mv_state = 1;
+			for (;;)
+				pause();
+		}
+		*mv_state = 1;
+		for (;;)
+			mv_state[1]++;
+	}
+	return pid;
+}
+
+/*
+ * A deadline task of 60ms every 100ms sleeps in P. Move a second sleeping
+ * task of 60ms every 100ms into P from outside. The move must fail with
+ * EBUSY. P and the root cgroup must each admit as many probe tasks after
+ * as before.
+ */
+static int move_refused(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, err;
+	pid_t in_p, pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	if (base_p < 0 || base_r < 0)
+		return KSFT_FAIL;
+	mv_state[0] = 0;
+	in_p = fork_child("a deadline task of P");
+	if (!in_p) {
+		if (enter(cg_p, getpid()) || set_deadline(0, 60 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		mv_state[0] = 1;
+		for (;;)
+			pause();
+	}
+	if (in_p < 0 || child_up("a task of 60% in P", 0)) {
+		reap(in_p);
+		return KSFT_FAIL;
+	}
+	mv_state[0] = 0;
+	pid = mover(MV_ASLEEP, 60 * NSEC_PER_MSEC);
+	if (pid < 0 || child_up("a task of 60% to move into P", 0)) {
+		reap(pid);
+		reap(in_p);
+		return KSFT_FAIL;
+	}
+	err = enter(cg_p, pid);
+	if (err != -EBUSY) {
+		ksft_print_msg("a move beyond P's room: %s, not EBUSY\n",
+			       err ? strerror(-err) : "accepted");
+		ret = KSFT_FAIL;
+	}
+	reap(pid);
+	reap(in_p);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("a refused move changed the free bandwidth\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * A runtime of 1024ns every 2s gives a bandwidth of 0. A cpuset move
+ * skips such a task: it has no bandwidth to move.
+ *
+ * A deadline task of 60ms every 100ms sleeps in P. A second task sleeps
+ * outside P. The main process makes it a deadline task of 1024ns every
+ * 2s, moves it into P, and wakes it. It then runs on P's CPU. The main
+ * process then raises it to 60ms every 100ms. P has no room for that, so
+ * sched_setattr() must fail with EBUSY. The kernel must check the request
+ * against P's root domain, not against the one the task left.
+ */
+static int move_zero_bw(void)
+{
+	int base_p, base_r, ret = KSFT_PASS, err, zfd[2];
+	pid_t in_p, pid;
+
+	base_p = probe(cg_p);
+	base_r = probe(root);
+	if (base_p < 0 || base_r < 0 || pipe(zfd))
+		return KSFT_FAIL;
+	mv_state[0] = 0;
+	in_p = fork_child("a deadline task of P");
+	if (!in_p) {
+		if (enter(cg_p, getpid()) || set_deadline(0, 60 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		mv_state[0] = 1;
+		for (;;)
+			pause();
+	}
+	if (in_p < 0 || child_up("a task of 60% in P", 0)) {
+		reap(in_p);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	mv_state[0] = 0;
+	pid = fork_child("a task with no bandwidth");
+	if (!pid) {
+		char c;
+
+		close(zfd[1]);
+		mv_state[0] = 1;
+		while (read(zfd[0], &c, 1) == 1)
+			;
+		_exit(0);
+	}
+	if (pid < 0 || child_up("a task to move into P", 0) ||
+	    wait_for(1000, proc_state_of(pid) == 'S')) {
+		reap(pid);
+		reap(in_p);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	/*
+	 * Set the parameters from here, while the task sleeps. With a runtime
+	 * of 1024ns, the task could be throttled before it sleeps again, for
+	 * up to its period of 2s.
+	 */
+	err = set_deadline(pid, 1024, 2 * NSEC_PER_SEC);
+	if (err) {
+		ksft_print_msg("a runtime of 1024ns every 2s: %s\n", strerror(-err));
+		ret = KSFT_FAIL;
+	} else if (enter(cg_p, pid)) {
+		ksft_print_msg("a task with no bandwidth: its move into P refused\n");
+		ret = KSFT_FAIL;
+	} else if (write(zfd[1], "w", 1) != 1 || wait_for(1000, task_cpu_of(pid) == top_cpu(1))) {
+		ksft_print_msg("a task moved into P did not wake on P's CPU\n");
+		ret = KSFT_FAIL;
+	} else {
+		err = set_deadline(pid, 60 * NSEC_PER_MSEC, PERIOD);
+		if (err != -EBUSY) {
+			ksft_print_msg("0%% to 60%% beside a task of 60%% in P: %s, not EBUSY\n",
+				       err ? strerror(-err) : "accepted");
+			ret = KSFT_FAIL;
+		}
+	}
+	/* Throttled, it would wait up to 2s to run and die. */
+	set_other(pid);
+	reap(pid);
+	reap(in_p);
+out:
+	close(zfd[0]);
+	close(zfd[1]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && (probe(cg_p) != base_p || probe(root) != base_r)) {
+		ksft_print_msg("a refused change changed the free bandwidth\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+static void *pauser(void *arg)
+{
+	for (;;)
+		pause();
+	return arg;
+}
+
+/* What late_setter() does, and the result. */
+static struct {
+	pid_t pid;
+	uint64_t runtime;
+	uint64_t delay;
+	atomic_int go;
+	int ret;
+	_Atomic uint64_t done;
+} late;
+
+/*
+ * Make late.pid a deadline task of late.runtime every 100ms, late.delay
+ * ns after late.go. Store the result in late.ret and the time it returned
+ * in late.done.
+ */
+static void *late_setter(void *arg)
+{
+	uint64_t start;
+
+	while (!late.go)
+		;
+	start = now_ns();
+	while (now_ns() - start < late.delay)
+		;
+	late.ret = set_deadline(late.pid, late.runtime, PERIOD);
+	late.done = now_ns();
+	return arg;
+}
+
+static void no_op(int sig)
+{
+}
+
+/*
+ * Run as the deadline thread of pinned_mover(): a deadline task of 30%.
+ * Store the tid in mv_state[3], set mv_state[0] to 1 and sleep. A signal
+ * wakes the thread up. It then sleeps again. If mv_state[4] is set, this
+ * thread exits instead, and the process stays.
+ */
+static void *dl_sleeper_tid(void *arg)
+{
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		mv_state[0] = -1;
+		return arg;
+	}
+	mv_state[3] = gettid_();
+	mv_state[0] = 1;
+	while (!mv_state[4])
+		pause();
+	syscall(SYS_exit, 0);
+	return arg;
+}
+
+/*
+ * Run as the last thread of pinned_mover() with @fifo. Become a
+ * SCHED_FIFO thread, set mv_state[5] to 1, or to -1 if SCHED_FIFO is
+ * refused, and sleep.
+ */
+static void *fifo_sleeper(void *arg)
+{
+	struct sched_param sp = { .sched_priority = 1 };
+
+	mv_state[5] = sched_setscheduler(0, SCHED_FIFO, &sp) ? -1 : 1;
+	for (;;)
+		pause();
+	return arg;
+}
+
+/*
+ * Fork a process of @threads sleeping threads, then one deadline thread,
+ * dl_sleeper_tid(). A cgroup move of the process handles the deadline
+ * thread after the sleeping ones, which make the move long. With @fifo,
+ * add a SCHED_FIFO thread, fifo_sleeper(), after it. Return the pid, or
+ * -1.
+ */
+static pid_t pinned_mover(int threads, int fifo)
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
+		signal(SIGUSR1, no_op);
+		if (pthread_create(&t, NULL, dl_sleeper_tid, NULL))
+			goto no_threads;
+		if (fifo && (wait_for(5000, mv_state[0]) ||
+			     pthread_create(&t, NULL, fifo_sleeper, NULL)))
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
+ * Have the cpu controller refuse a move after cpuset_can_attach()
+ * reserved room. cpuset_cancel_attach() must then give the room back.
+ *
+ * The process is pinned_mover() with a SCHED_FIFO thread: 2048 sleeping
+ * threads, a sleeping deadline thread of 30%, and the SCHED_FIFO thread.
+ * It moves from the root cgroup into P. cpuset_can_attach() reserves
+ * room in P for the deadline thread. With CONFIG_RT_GROUP_SCHED, the cpu
+ * controller then refuses the SCHED_FIFO thread: P has no real-time
+ * runtime.
+ *
+ * Then a thread of the test, late_setter(), changes the runtime of the
+ * deadline thread during 20 such moves. sched_setattr() waits for the
+ * end of a move in progress. It must return, and succeed, once the move
+ * is cancelled.
+ *
+ * Skip if the cpu controller accepts the move.
+ */
+static int move_cancelled(void)
+{
+	int with_p, with_r, ret = KSFT_PASS, i, err, cpu_added = 0, pending = 0;
+	char path[PATH_MAX + 32], buf[256];
+	const char *name = "move_cancelled";
+	uint64_t start, len;
+	pthread_t t;
+	pid_t pid;
+
+	/* Only the root cgroup has real-time runtime for the SCHED_FIFO thread. */
+	if (enter(root, getpid())) {
+		ksft_print_msg("%s: the test cannot enter the root cgroup\n", name);
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	mv_state[3] = 0;
+	mv_state[4] = 0;
+	mv_state[5] = 0;
+	pid = pinned_mover(2048, 1);
+	if (pid < 0 || child_up(name, 0) || wait_for(5000, mv_state[5])) {
+		reap(pid);
+		return mv_state[0] == -2 ? KSFT_SKIP : KSFT_FAIL;
+	}
+	snprintf(path, sizeof(path), "%s/cgroup.subtree_control", root);
+	if (mv_state[5] < 0 || read_file(path, buf, sizeof(buf))) {
+		ksft_print_msg("%s: no SCHED_FIFO thread\n", name);
+		reap(pid);
+		return KSFT_SKIP;
+	}
+	if (!has_word(buf, "cpu")) {
+		if (write_file(root, "cgroup.subtree_control", "+cpu")) {
+			ksft_print_msg("%s: no cpu controller\n", name);
+			reap(pid);
+			return KSFT_SKIP;
+		}
+		cpu_added = 1;
+	}
+	/* The reference: the deadline thread asleep in the root cgroup. */
+	sleep_ns(2 * PERIOD);
+	with_p = probe(cg_p);
+	with_r = probe(root);
+	start = now_ns();
+	err = enter(cg_p, pid);
+	len = now_ns() - start;
+	if (!err) {
+		ksft_print_msg("%s: the cpu controller accepts a SCHED_FIFO thread: needs CONFIG_RT_GROUP_SCHED\n",
+			       name);
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	for (i = 0; i < 5; i++) {
+		if (!enter(cg_p, pid)) {
+			ksft_print_msg("%s: a move accepted\n", name);
+			ret = KSFT_FAIL;
+			goto out;
+		}
+	}
+	sleep_ns(2 * PERIOD);
+	if (admits_in(cg_p, with_p, "P, after cancelled moves") ||
+	    admits_in(root, with_r, "the root domain of the process")) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+
+	late.pid = mv_state[3];
+	for (i = 0; i < 20 && ret == KSFT_PASS; i++) {
+		late.go = 0;
+		late.done = 0;
+		late.runtime = (i % 2 ? 30 : 20) * NSEC_PER_MSEC;
+		late.delay = len * i / 20;
+		if (pthread_create(&t, NULL, late_setter, NULL)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(NSEC_PER_MSEC);
+		late.go = 1;
+		if (!enter(cg_p, pid)) {
+			ksft_print_msg("%s: a move accepted\n", name);
+			ret = KSFT_FAIL;
+		}
+		if (wait_for(5000, late.done)) {
+			ksft_print_msg("%s: sched_setattr() still waits after a cancelled move\n",
+				       name);
+			ret = KSFT_FAIL;
+			pending = 1;	/* joined once the reap ends its wait */
+			break;
+		}
+		join(t);
+		if (late.ret) {
+			ksft_print_msg("%s: sched_setattr: %s\n", name, strerror(-late.ret));
+			ret = KSFT_FAIL;
+		}
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS &&
+	    (admits_in(cg_p, with_p, "P, after the cancelled moves") ||
+	     admits_in(root, with_r, "the root domain of the process")))
+		ret = KSFT_FAIL;
+out:
+	reap(pid);
+	if (pending)
+		join(t);
+	if (cpu_added && write_file(root, "cgroup.subtree_control", "-cpu"))
+		ksft_print_msg("%s: the cpu controller stays enabled\n", name);
+	return ret;
+}
+
+/* Deaths, in P */
+
+enum die_mode { DIE_RUNNING, DIE_SWITCHED_OUT, DIE_SHRUNK };
+
+/*
+ * Fork a deadline task of 30% that runs 5ms of a fresh period and exits
+ * before its 0-lag time. @mode says what it does before it exits:
+ *  - DIE_RUNNING: nothing.
+ *  - DIE_SWITCHED_OUT: switch to SCHED_OTHER.
+ *  - DIE_SHRUNK: shrink to 10%. Its 0-lag time is then in the past.
+ *
+ * Its bandwidth is released at the 0-lag time, or at the exit for
+ * DIE_SHRUNK.
+ */
+static int die_case(enum die_mode mode, const char *what)
+{
+	pid_t pid = fork_child("a task that dies");
+	int status;
+
+	if (!pid) {
+		if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		sleep_ns(PERIOD);
+		spin_ns(5 * NSEC_PER_MSEC);
+		if (mode == DIE_SWITCHED_OUT && set_other(0))
+			_exit(2);
+		if (mode == DIE_SHRUNK && set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD))
+			_exit(3);
+		_exit(0);
+	}
+	if (pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
+	    WEXITSTATUS(status)) {
+		ksft_print_msg("a task that dies %s failed\n", what);
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+static int death_running(void)
+{
+	return die_case(DIE_RUNNING, "running");
+}
+
+static int death_switched_out(void)
+{
+	return die_case(DIE_SWITCHED_OUT, "switched out");
+}
+
+static int death_shrunk(void)
+{
+	return die_case(DIE_SHRUNK, "shrunk");
+}
+
+/*
+ * Stop a running deadline task of 30% with SIGSTOP, switch it to
+ * SCHED_OTHER while it is stopped, and kill it. The task is on no
+ * runqueue when it leaves SCHED_DEADLINE. Do it five times.
+ */
+static int stopped_switched_out(void)
+{
+	const char *what = "a deadline task to stop";
+	int i, err;
+
+	for (i = 0; i < 5; i++) {
+		pid_t pid;
+
+		mv_state[0] = 0;
+		pid = fork_child(what);
+		if (!pid) {
+			if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
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
+		err = 0;
+		if (kill(pid, SIGSTOP) || wait_for(1000, proc_state_of(pid) == 'T')) {
+			ksft_print_msg("the deadline task did not stop\n");
+			err = 1;
+		} else if (set_other(pid)) {
+			ksft_print_msg("the stopped task cannot leave SCHED_DEADLINE\n");
+			err = 1;
+		}
+		reap(pid);
+		if (err)
+			return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+/*
+ * With @moving, wait until the spinner's count in mv_state[1] moves: it
+ * runs. Without, wait until the count stops for 5ms: it is throttled.
+ * Return 0, or -1 after 1s.
+ */
+static int wait_spinner(int moving)
+{
+	uint64_t end = now_ns() + NSEC_PER_SEC;
+	int last = mv_state[1];
+
+	while (now_ns() < end) {
+		sleep_ns(moving ? NSEC_PER_MSEC : 5 * NSEC_PER_MSEC);
+		if (moving ? mv_state[1] != last : mv_state[1] == last)
+			return 0;
+		last = mv_state[1];
+	}
+	return -1;
+}
+
+enum kill_when { KILL_AFTER, KILL_THROTTLED, KILL_RUNNING };
+
+/*
+ * Start a deadline task of 30% with mover() in @mode, then kill it as
+ * @when says:
+ *  - KILL_AFTER: @after ns after it is up.
+ *  - KILL_THROTTLED: once it is throttled.
+ *  - KILL_RUNNING: while it runs.
+ *
+ * The killer first leaves P. It then watches and kills from another CPU,
+ * and does not take the task's CPU.
+ */
+static int kill_case(enum mv_mode mode, enum kill_when when, uint64_t after, const char *what)
+{
+	int ret = KSFT_PASS;
+	pid_t pid;
+
+	mv_state[0] = 0;
+	mv_state[1] = 0;
+	pid = mover(mode, 30 * NSEC_PER_MSEC);
+	if (pid < 0) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (enter(root, getpid())) {
+		ksft_print_msg("killed %s: the killer cannot leave P\n", what);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (child_up(what, 1)) {
+		ret = KSFT_FAIL;
+	} else if (when != KILL_AFTER && wait_spinner(when == KILL_RUNNING)) {
+		ksft_print_msg("killed %s: never %s\n", what,
+			       when == KILL_RUNNING ? "ran" : "throttled");
+		ret = KSFT_FAIL;
+	} else {
+		sleep_ns(after);
+	}
+out:
+	reap(pid);
+	return ret;
+}
+
+static int death_killed_asleep(void)
+{
+	return kill_case(MV_ASLEEP, KILL_AFTER, 2 * PERIOD, "asleep");
+}
+
+static int death_killed_non_contending(void)
+{
+	return kill_case(MV_NON_CONTENDING, KILL_AFTER, 0, "before its 0-lag time");
+}
+
+static int death_killed_throttled(void)
+{
+	return kill_case(MV_THROTTLED, KILL_THROTTLED, 0, "throttled");
+}
+
+static int death_killed_running(void)
+{
+	return kill_case(MV_THROTTLED, KILL_RUNNING, 0, "running");
+}
+
+/*
+ * A robust priority inheritance lock shared between processes.
+ * mv_state[0] holds the state of its owner, mv_state[2] that of its
+ * waiter. mv_state[16] is set once the lock is set up. It is in shared
+ * memory, as each case runs in its own child process.
+ */
+static pthread_mutex_t *shm_lock;
+
+/* Set up shm_lock. Return 0, or -1 if it cannot be set up. */
+static int shm_lock_init(void)
+{
+	pthread_mutexattr_t a;
+	int err;
+
+	/*
+	 * A case can kill the owner while it holds the lock. Take the lock
+	 * back and release it, so that it can be destroyed.
+	 */
+	if (mv_state[16]) {
+		err = pthread_mutex_trylock(shm_lock);
+		if (err == EOWNERDEAD)
+			err = pthread_mutex_consistent(shm_lock);
+		if (!err)
+			pthread_mutex_unlock(shm_lock);
+		pthread_mutex_destroy(shm_lock);
+		mv_state[16] = 0;
+	}
+	err = pthread_mutexattr_init(&a);
+	if (!err)
+		err = pthread_mutexattr_setpshared(&a, PTHREAD_PROCESS_SHARED);
+	if (!err)
+		err = pthread_mutexattr_setprotocol(&a, PTHREAD_PRIO_INHERIT);
+	if (!err)
+		err = pthread_mutexattr_setrobust(&a, PTHREAD_MUTEX_ROBUST);
+	if (!err)
+		err = pthread_mutex_init(shm_lock, &a);
+	pthread_mutexattr_destroy(&a);
+	if (err) {
+		ksft_print_msg("no shared priority inheritance mutex: %s\n", strerror(err));
+		return -1;
+	}
+	mv_state[16] = 1;
+	mv_state[0] = 0;
+	mv_state[2] = 0;
+	return 0;
+}
+
+/*
+ * Fork a process that takes shm_lock and sleeps with it, as a deadline
+ * task of 30% if @dl. Return its pid, or -1.
+ */
+static pid_t lock_owner(int dl)
+{
+	pid_t pid = fork_child("the owner of the lock");
+
+	if (!pid) {
+		if ((dl && set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) ||
+		    pthread_mutex_lock(shm_lock)) {
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
+ * Fork a deadline task of 5ms every 50ms that waits for shm_lock. It sets
+ * mv_state[2] to 1 before the wait, and to 2 once it got the lock. Return
+ * its pid, or -1.
+ */
+static pid_t lock_waiter(void)
+{
+	pid_t pid = fork_child("a waiter of the lock");
+
+	if (!pid) {
+		int err;
+
+		if (set_deadline(0, 5 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC)) {
+			mv_state[2] = -1;
+			_exit(1);
+		}
+		mv_state[2] = 1;
+		err = pthread_mutex_lock(shm_lock);
+		if (err == EOWNERDEAD)
+			err = pthread_mutex_consistent(shm_lock);
+		if (!err)
+			pthread_mutex_unlock(shm_lock);
+		mv_state[2] = err ? -2 : 2;
+		for (;;)
+			pause();
+	}
+	return pid;
+}
+
+/* Wait up to 1s for @var to reach @want. Return 0, or -1. */
+static int wait_state(atomic_int *var, int want)
+{
+	uint64_t end = now_ns() + NSEC_PER_SEC;
+
+	while (now_ns() < end) {
+		if (*var == want)
+			return 0;
+		sleep_ns(NSEC_PER_MSEC);
+	}
+	return -1;
+}
+
+/*
+ * Kill one side of a priority inheritance boost. lock_owner() sleeps
+ * with shm_lock, as a deadline task of 30% if @dl_owner. lock_waiter(),
+ * a deadline task of 5ms every 50ms, blocks on the lock and boosts the
+ * owner. Kill the owner if @kill_owner: the waiter must then get the
+ * lock. If not, kill the waiter.
+ *
+ * A killed owner does not die boosted. Its exit first releases its
+ * priority inheritance futexes in futex_exit_exec_release(), which
+ * deboosts it.
+ */
+static int pi_death(int dl_owner, int kill_owner, const char *what)
+{
+	int ret = KSFT_PASS;
+	pid_t owner, waiter = -1;
+
+	if (shm_lock_init())
+		return KSFT_SKIP;
+	owner = lock_owner(dl_owner);
+	if (owner < 0)
+		return KSFT_FAIL;
+	if (wait_state(&mv_state[0], 1)) {
+		ksft_print_msg("%s: no owner\n", what);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	waiter = lock_waiter();
+	if (waiter < 0) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_state(&mv_state[2], 1)) {
+		ksft_print_msg("%s: no waiter\n", what);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	sleep_ns(50 * NSEC_PER_MSEC);	/* blocked, boosting the owner */
+	if (kill_owner) {
+		reap(owner);
+		owner = -1;
+		if (wait_state(&mv_state[2], 2)) {
+			ksft_print_msg("%s: the waiter did not get the lock\n", what);
+			ret = KSFT_FAIL;
+		}
+	} else {
+		reap(waiter);
+		waiter = -1;
+		sleep_ns(50 * NSEC_PER_MSEC);	/* the owner deboosted asleep */
+	}
+out:
+	reap(waiter);
+	reap(owner);
+	return ret;
+}
+
+static int death_pi_waiter(void)
+{
+	return pi_death(0, 0, "a waiter killed");
+}
+
+static int death_pi_owner(void)
+{
+	return pi_death(0, 1, "a boosted owner killed");
+}
+
+static int death_pi_deadline_owner(void)
+{
+	return pi_death(1, 1, "a boosted deadline owner killed");
+}
+
+/*
+ * Run as thread @arg of death_group(), a deadline task with a period of
+ * 100ms. Each thread counts itself in mv_state[0] once it has run 1ms.
+ *  - Thread 0, of 10ms: run 1ms, then sleep.
+ *  - Thread 1, of 10ms: spin and count in mv_state[1], until throttled.
+ *  - Thread 2, of 60ms: wait for the killer to set mv_state[2]. Then
+ *    spin and count in mv_state[3].
+ */
+static void *group_thread(void *arg)
+{
+	long kind = (long)arg;
+
+	if (set_deadline(0, (kind == 2 ? 60 : 10) * NSEC_PER_MSEC, PERIOD)) {
+		mv_state[0] = -1000;
+		return NULL;
+	}
+	if (kind == 2)
+		while (!mv_state[2])
+			sleep_ns(NSEC_PER_MSEC);
+	spin_ns(NSEC_PER_MSEC);
+	mv_state[0]++;
+	if (!kind)
+		for (;;)
+			pause();
+	for (;;)
+		mv_state[kind == 2 ? 3 : 1]++;
+	return NULL;
+}
+
+/*
+ * Kill a process of three deadline threads with one SIGKILL, while one
+ * sleeps, one is throttled and one runs. See group_thread().
+ */
+static int death_group(void)
+{
+	int last, ret = KSFT_PASS;
+	pid_t pid;
+
+	mv_state[0] = mv_state[1] = mv_state[2] = mv_state[3] = 0;
+	pid = fork_child("a group of deadline threads");
+	if (pid < 0)
+		return KSFT_FAIL;
+	if (!pid) {
+		pthread_t t;
+		long i;
+
+		for (i = 0; i < 3; i++)
+			if (pthread_create(&t, NULL, group_thread, (void *)i))
+				mv_state[0] = -1000;
+		for (;;)
+			pause();
+	}
+	/*
+	 * Kill from outside P. P has one CPU: in P, the killer could not
+	 * run while thread 2 runs.
+	 */
+	if (enter(root, getpid())) {
+		ksft_print_msg("the killer cannot leave P\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_for(5000, mv_state[0] < 0 || mv_state[0] == 2) || mv_state[0] != 2) {
+		ksft_print_msg("only %d threads of the group started\n", (int)mv_state[0]);
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	if (wait_spinner(0)) {
+		ksft_print_msg("the first spinner never throttled\n");
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	last = mv_state[3];
+	mv_state[2] = 1;
+	if (wait_for(5000, mv_state[0] < 0 || mv_state[3] != last) || mv_state[0] != 3) {
+		ksft_print_msg("the second spinner never ran\n");
+		ret = KSFT_FAIL;
+	}
+out:
+	/* One asleep, one throttled, one running. */
+	reap(pid);
+	return ret;
+}
+
+/*
+ * Two deadline tasks are in P. One, of 30%, sleeps. The other, of 10%,
+ * exits and stays a zombie. Switching the zombie to SCHED_OTHER must be
+ * refused with ESRCH.
+ *
+ * On kernels where each cpuset counts its deadline tasks,
+ * cgroup_task_dead() took the zombie off P's count. The switch would
+ * run switched_from_dl() and take it off a second time. P's count would
+ * then be 0 with the task of 30% still in P. A rebuild of the accounting
+ * would skip P, and lose the bandwidth of that task. So rebuild the
+ * accounting, and check that P still counts the 30%.
+ */
+static int death_zombie_switched(void)
+{
+	int base, ret = KSFT_PASS, err;
+	pid_t in_p, zombie;
+
+	base = probe(cg_p);
+	if (base < 4) {
+		ksft_print_msg("no room in P for a task of 30%% and a probe\n");
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	in_p = fork_child("a deadline task of P");
+	if (!in_p) {
+		if (enter(cg_p, getpid()) || set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		mv_state[0] = 1;
+		for (;;)
+			pause();
+	}
+	if (in_p < 0 || child_up("a task of 30% in P", 0)) {
+		reap(in_p);
+		return KSFT_FAIL;
+	}
+	mv_state[0] = 0;
+	zombie = fork_child("a deadline task that exits");
+	if (!zombie) {
+		if (enter(cg_p, getpid()) || set_deadline(0, 10 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		mv_state[0] = 1;
+		_exit(0);
+	}
+	if (zombie < 0 || child_up("a task of 10% in P that exits", 0) ||
+	    wait_for(1000, proc_state_of(zombie) == 'Z')) {
+		ksft_print_msg("no zombie deadline task\n");
+		reap(zombie);
+		reap(in_p);
+		return KSFT_FAIL;
+	}
+	/* Its bandwidth is released at its 0-lag time, within a period. */
+	sleep_ns(3 * PERIOD);
+	err = set_other(zombie);
+	if (err != -ESRCH) {
+		ksft_print_msg("SCHED_OTHER on a zombie deadline task: %s, not ESRCH\n",
+			       err ? strerror(-err) : "accepted");
+		ret = KSFT_FAIL;
+	}
+	/*
+	 * Rebuild the accounting: make Q beside P, then remove it. Q is a
+	 * second partition root, of the CPU below P's.
+	 */
+	if (make_partition(cg_q, top_cpu(2))) {
+		ksft_print_msg("no partition root Q beside P\n");
+		ret = KSFT_FAIL;
+	}
+	remove_partition(cg_q);
+	if (admits_in(cg_p, base - 3, "P rebuilt, a task of 30% and a zombie in it"))
+		ret = KSFT_FAIL;
+	reap(zombie);
+	reap(in_p);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && admits_in(cg_p, base, "P, its tasks gone"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+/* sched_yield() */
+
+static atomic_int y_rounds;	/* the yields of the yielder */
+
+/*
+ * Run as the thread of start_yielder(): a deadline task of 30% that
+ * yields after 0.5ms of every period. sched_yield() throttles it until
+ * its next period, with runtime left. So it is throttled most of the
+ * time. t_state is 2 while it is in the yield.
+ */
+static void *yielder(void *arg)
+{
+	t_tid = gettid_();
+	if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+		t_state = -1;
+		return (void *)1;
+	}
+	t_state = 1;
+	while (!spin_stop) {
+		spin_ns(NSEC_PER_MSEC / 2);
+		y_rounds++;
+		t_state = 2;
+		sched_yield();
+		t_state = 1;
+	}
+	return NULL;
+}
+
+static int start_yielder(pthread_t *t)
+{
+	t_state = 0;
+	spin_stop = 0;
+	y_rounds = 0;
+	if (pthread_create(t, NULL, yielder, NULL)) {
+		ksft_print_msg("the yielder thread could not start\n");
+		return -1;
+	}
+	if (!wait_for(5000, t_state) && t_state > 0)
+		return 0;
+	spin_stop = 1;		/* in case it gets there late */
+	join(*t);
+	return -1;
+}
+
+/*
+ * Switch a deadline task to SCHED_OTHER while sched_yield() throttles it.
+ * Its bandwidth must come back, and it must run again.
+ */
+static int yield_switched_out(void)
+{
+	int base, ret = KSFT_PASS;
+	pthread_t t;
+
+	base = probe(NULL);
+	if (base < 3) {
+		ksft_print_msg("no room for a task of 30%%\n");
+		return KSFT_SKIP;
+	}
+	if (start_yielder(&t))
+		return KSFT_FAIL;
+	if (wait_throttled(t) || t_state != 2) {
+		ksft_print_msg("the task never yielded\n");
+		ret = KSFT_FAIL;
+	} else if (set_other(t_tid)) {
+		ret = KSFT_FAIL;
+	} else {
+		int last = y_rounds;
+
+		sleep_ns(2 * PERIOD);
+		if (y_rounds == last) {
+			ksft_print_msg("yielded, then switched out: never ran again\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	stop_spinner(t);
+	sleep_ns(3 * PERIOD);		/* its 0-lag time */
+	if (ret == KSFT_PASS && admits(base, "yielded, then switched out"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+/* Kill a deadline task while sched_yield() throttles it. */
+static int yield_killed(void)
+{
+	pid_t pid;
+
+	mv_state[0] = 0;
+	pid = fork_child("a task that yields");
+	if (!pid) {
+		if (set_deadline(0, 30 * NSEC_PER_MSEC, PERIOD)) {
+			mv_state[0] = -1;
+			_exit(1);
+		}
+		mv_state[0] = 1;
+		for (;;) {
+			spin_ns(NSEC_PER_MSEC / 2);
+			sched_yield();
+		}
+	}
+	if (pid < 0)
+		return KSFT_FAIL;
+	if (child_up("a task that yields", 0)) {
+		reap(pid);
+		return KSFT_FAIL;
+	}
+	sleep_ns(2 * PERIOD);
+	reap(pid);
+	return KSFT_PASS;
+}
+
+/* SCHED_FLAG_DL_OVERRUN */
+
+static atomic_int got_xcpu;
+
+static void catch_xcpu(int sig)
+{
+	got_xcpu = 1;
+}
+
+/*
+ * Run as the thread of overrun_caught(): a deadline task of 10% with
+ * SCHED_FLAG_DL_OVERRUN. Run 15ms, past the runtime, then sleep until
+ * spin_stop is set.
+ */
+static void *overruns(void *arg)
+{
+	t_tid = gettid_();
+	if (set_deadline_flags(0, 10 * NSEC_PER_MSEC, PERIOD, SCHED_FLAG_DL_OVERRUN)) {
+		t_state = -1;
+		return (void *)1;
+	}
+	t_state = 1;
+	spin_ns(15 * NSEC_PER_MSEC);
+	while (!spin_stop)
+		sleep_ns(10 * NSEC_PER_MSEC);
+	return NULL;
+}
+
+/*
+ * When a task with SCHED_FLAG_DL_OVERRUN overruns its runtime, its thread
+ * group gets SIGXCPU. Catch it here. The task's bandwidth must stay
+ * reserved after the overrun, and come back when the task leaves
+ * SCHED_DEADLINE.
+ */
+static int overrun_caught(void)
+{
+	int base, ret = KSFT_PASS;
+	uint64_t end;
+	pthread_t t;
+
+	if (signal(SIGXCPU, catch_xcpu) == SIG_ERR)
+		return KSFT_FAIL;
+	base = probe(NULL);
+	if (base < 1) {
+		ksft_print_msg("no room for a task of 10%%\n");
+		return KSFT_SKIP;
+	}
+	got_xcpu = 0;
+	t_state = 0;
+	spin_stop = 0;
+	if (pthread_create(&t, NULL, overruns, NULL))
+		return KSFT_FAIL;
+	while (!t_state)
+		sleep_ns(NSEC_PER_MSEC);
+	end = now_ns() + 2 * NSEC_PER_SEC;
+	while (!got_xcpu && now_ns() < end)
+		sleep_ns(5 * NSEC_PER_MSEC);
+	if (t_state != 1) {
+		ret = KSFT_FAIL;
+	} else if (!got_xcpu) {
+		ksft_print_msg("it overran its runtime, no SIGXCPU in 2s\n");
+		ret = KSFT_FAIL;
+	} else if (admits(base - 1, "an overrun told")) {
+		ret = KSFT_FAIL;	/* the overrun gave its 10% back */
+	}
+	stop_spinner(t);
+	sleep_ns(3 * PERIOD);		/* its 0-lag time */
+	if (ret == KSFT_PASS && admits(base, "after an overrun was told"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+/*
+ * Run as thread @arg of overrun_group_death(), a deadline task. Thread 0
+ * overruns its runtime. Threads 1 and 2 count themselves in mv_state[0],
+ * and sleep.
+ */
+static void *og_thread(void *arg)
+{
+	switch ((int)(long)arg) {
+	case 0:		/* overruns its runtime: SIGXCPU to the group */
+		if (set_deadline_flags(0, 10 * NSEC_PER_MSEC, PERIOD,
+				       SCHED_FLAG_DL_OVERRUN))
+			_exit(1);
+		/*
+		 * Wait for the other two first. On P's one CPU, this
+		 * thread has the earliest deadline of the three. It would
+		 * overrun, and kill them, before they reach the state the
+		 * signal must find them in.
+		 */
+		if (wait_for(5000, mv_state[0] >= 2))
+			_exit(2);
+		spin_ns(30 * NSEC_PER_MSEC);
+		break;
+	case 1:		/* asleep, its 0-lag time past */
+		if (set_deadline(0, 20 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		spin_ns(NSEC_PER_MSEC);
+		mv_state[0]++;
+		break;
+	case 2:		/* asleep, mostly before its 0-lag time */
+		if (set_deadline(0, 15 * NSEC_PER_MSEC, PERIOD))
+			_exit(1);
+		mv_state[0]++;
+		for (;;) {
+			spin_ns(3 * NSEC_PER_MSEC);
+			sleep_ns(22 * NSEC_PER_MSEC);
+		}
+	}
+	for (;;)
+		pause();
+}
+
+/*
+ * Let the SIGXCPU of an overrun kill the whole thread group. The
+ * bandwidth of its three deadline threads must come back.
+ */
+static int overrun_group_death(void)
+{
+	pid_t pid;
+	int i, status;
+
+	mv_state[0] = 0;
+	pid = fork_child("a group of deadline threads");
+	if (!pid) {
+		pthread_t t;
+
+		for (i = 0; i < 3; i++)
+			if (pthread_create(&t, NULL, og_thread, (void *)(long)i))
+				_exit(3);
+		for (;;)
+			pause();
+	}
+	if (pid < 0)
+		return KSFT_FAIL;
+	for (i = 0; i < 300; i++) {
+		if (waitpid(pid, &status, WNOHANG) == pid)
+			break;
+		sleep_ns(10 * NSEC_PER_MSEC);
+	}
+	if (i == 300) {
+		reap(pid);
+		ksft_print_msg("an overrun of 10ms every 100ms: no SIGXCPU in 3s\n");
+		return KSFT_FAIL;
+	}
+	if (WIFEXITED(status)) {
+		switch (WEXITSTATUS(status)) {
+		case 1:
+			ksft_print_msg("a thread of the group was refused SCHED_DEADLINE\n");
+			return KSFT_SKIP;
+		case 2:
+			ksft_print_msg("the other two threads of the group were not ready in 5s\n");
+			break;
+		default:
+			ksft_print_msg("a thread of the group could not start\n");
+		}
+		return KSFT_FAIL;
+	}
+	if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGXCPU) {
+		ksft_print_msg("the group of an overrun died of signal %d, not SIGXCPU\n",
+			       WIFSIGNALED(status) ? WTERMSIG(status) : 0);
+		return KSFT_FAIL;
+	}
+	return KSFT_PASS;
+}
+
+/* SCHED_FLAG_RECLAIM */
+
+#define RECLAIM_MIN	40	/* least % for a reclaiming task of 10% */
+#define PLAIN_MAX	25	/* most % for one without the flag */
+#define SHARE_SLACK	15	/* % two measures of a share may differ */
+#define SHARE_NS	(400 * NSEC_PER_MSEC)
+
+/*
+ * Measure the CPU share of a spinning deadline task of 10%, on P's CPU,
+ * without SCHED_FLAG_RECLAIM and then with it. With the flag, the task
+ * runs past its runtime: it takes the bandwidth of its root domain that
+ * no deadline task uses. It must get at most PLAIN_MAX percent without
+ * the flag, and at least RECLAIM_MIN percent with it.
+ */
+static int reclaim_runs(void)
+{
+	int plain, grub, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (start_spinner(&t, 10 * NSEC_PER_MSEC, 0)) {
+		ksft_print_msg("no room for a task of 10%%\n");
+		return KSFT_SKIP;
+	}
+	plain = share_of(t, SHARE_NS);
+	stop_spinner(t);
+	if (start_spinner(&t, 10 * NSEC_PER_MSEC, SCHED_FLAG_RECLAIM))
+		return KSFT_FAIL;
+	grub = share_of(t, SHARE_NS);
+	stop_spinner(t);
+	if (plain > PLAIN_MAX || grub < RECLAIM_MIN) {
+		ksft_print_msg("of a CPU, a task of 10%% got %d%%, with SCHED_FLAG_RECLAIM %d%%\n",
+			       plain, grub);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * Switch a reclaiming task out of SCHED_DEADLINE before its 0-lag time,
+ * and back. Its bandwidth stays until the inactive timer releases it.
+ * Afterwards, the task must reclaim as much as before.
+ */
+static int reclaim_switched(void)
+{
+	int before, after = 0, r, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (start_spinner(&t, 10 * NSEC_PER_MSEC, SCHED_FLAG_RECLAIM)) {
+		ksft_print_msg("no room for a task of 10%%\n");
+		return KSFT_SKIP;
+	}
+	before = share_of(t, SHARE_NS);
+	for (r = 0; r < 4; r++) {
+		if (set_other(t_tid)) {
+			ret = KSFT_FAIL;
+			break;
+		}
+		if (r & 1)
+			sleep_ns(5 * NSEC_PER_MSEC);
+		if (set_deadline_flags(t_tid, 10 * NSEC_PER_MSEC, PERIOD,
+				       SCHED_FLAG_RECLAIM)) {
+			ksft_print_msg("round %d of 4: back to SCHED_DEADLINE refused\n",
+				       r + 1);
+			ret = KSFT_FAIL;
+			break;
+		}
+		sleep_ns(PERIOD);
+	}
+	if (ret == KSFT_PASS)
+		after = share_of(t, SHARE_NS);
+	stop_spinner(t);
+	if (ret == KSFT_PASS &&
+	    (after < before - SHARE_SLACK || after > before + SHARE_SLACK)) {
+		ksft_print_msg("reclaiming: %d%% of a CPU, %d%% after 4 round trips\n",
+			       before, after);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/* Deadline servers */
+
+#define SERVER_RUNTIME	(100 * NSEC_PER_MSEC)	/* the cases start at 10% */
+#define SERVER_PERIOD	(1000 * NSEC_PER_MSEC)
+
+/*
+ * The fair server, or the ext server while a sched_ext scheduler runs all
+ * fair tasks. server_init() picks it.
+ */
+static const char *server_dir = "/sys/kernel/debug/sched/fair_server";
+static uint64_t *server_found;	/* each server's runtime and period */
+
+/* Return 1 if a sched_ext scheduler runs all fair tasks, or 0. */
+static int ext_switched_all(void)
+{
+	char buf[16];
+
+	if (read_file("/sys/kernel/sched_ext/state", buf, sizeof(buf)) ||
+	    strncmp(buf, "enabled", 7))
+		return 0;
+	if (read_file("/sys/kernel/sched_ext/switch_all", buf, sizeof(buf)))
+		return 0;
+	return buf[0] == '1';
+}
+
+static int server_get(int cpu, const char *name, uint64_t *val)
+{
+	char path[96], buf[32];
+
+	snprintf(path, sizeof(path), "%s/cpu%d/%s", server_dir, cpu, name);
+	if (read_file(path, buf, sizeof(buf)))
+		return -1;
+	*val = strtoull(buf, NULL, 10);
+	return 0;
+}
+
+static int server_put(int cpu, const char *name, uint64_t val)
+{
+	char dir[96], buf[32];
+
+	snprintf(dir, sizeof(dir), "%s/cpu%d", server_dir, cpu);
+	snprintf(buf, sizeof(buf), "%llu", (unsigned long long)val);
+	return write_file(dir, name, buf);
+}
+
+/*
+ * Set the fair server of @cpu to @runtime every @period.
+ * Return 0, or -errno.
+ */
+static int server_set(int cpu, uint64_t runtime, uint64_t period)
+{
+	uint64_t cur;
+	int err;
+
+	if (!server_found || server_get(cpu, "period", &cur))
+		return -ENOENT;
+	/* Each write keeps the runtime within the period. */
+	if (runtime <= cur) {
+		err = server_put(cpu, "runtime", runtime);
+		return err ? err : server_put(cpu, "period", period);
+	}
+	err = server_put(cpu, "period", period);
+	return err ? err : server_put(cpu, "runtime", runtime);
+}
+
+/*
+ * Record the runtime and period of each fair server. Without debugfs,
+ * record none: the server cases are then skipped.
+ */
+static void server_init(void)
+{
+	int i;
+
+	if (ext_switched_all())
+		server_dir = "/sys/kernel/debug/sched/ext_server";
+	server_found = calloc(2 * ncpus, sizeof(*server_found));
+	for (i = 0; server_found && i < ncpus; i++) {
+		if (server_get(online[i], "runtime", &server_found[2 * i]) ||
+		    server_get(online[i], "period", &server_found[2 * i + 1])) {
+			free(server_found);
+			server_found = NULL;
+			ksft_print_msg("no %s in debugfs: server cases skipped\n",
+				       strrchr(server_dir, '/') + 1);
+		}
+	}
+}
+
+/* Put the fair servers back as the test found them. */
+static void server_restore(void)
+{
+	uint64_t runtime, period;
+	int i;
+
+	for (i = 0; server_found && i < ncpus; i++) {
+		int cpu = online[i], err;
+
+		if (server_get(cpu, "runtime", &runtime) || server_get(cpu, "period", &period))
+			continue;
+		if (runtime == server_found[2 * i] && period == server_found[2 * i + 1])
+			continue;
+		/*
+		 * Retry for up to 1s. While departing tasks still hold
+		 * their bandwidth, a root domain can refuse any change of a
+		 * server, a decrease too. Their 0-lag times are a period or
+		 * two away.
+		 */
+		err = wait_for(1000, !server_set(cpu, server_found[2 * i],
+						 server_found[2 * i + 1]));
+		if (err)
+			ksft_print_msg("the fair server of CPU %d stays changed\n", cpu);
+	}
+}
+
+/* Deadline threads of 10% every 100ms that sleep until released. */
+static pthread_t *held;
+static int nheld, held_err;
+static sem_t held_up, held_go;
+
+static void *holder(void *arg)
+{
+	int err = set_deadline(0, PROBE_RUNTIME, PROBE_PERIOD);
+
+	held_err = err;
+	if (sem_post(&held_up))
+		ksft_print_msg("sem_post: %s\n", strerror(errno));
+	if (!err)
+		sem_wait_sig(&held_go);
+	return NULL;
+}
+
+/*
+ * Start @n more holders. Return 0 once they are all admitted, or -1. The
+ * caller must call release_held(), on a failure too.
+ */
+static int hold(int n)
+{
+	int max = 16 * ncpus + 16, err;
+	pthread_attr_t a;
+
+	if (!held) {
+		held = calloc(max, sizeof(*held));
+		if (!held || sem_init(&held_up, 0, 0) || sem_init(&held_go, 0, 0)) {
+			ksft_print_msg("the holders cannot be set up\n");
+			return -1;
+		}
+	}
+	err = pthread_attr_init(&a);
+	if (!err)
+		err = pthread_attr_setstacksize(&a, THREAD_STACK);
+	if (err) {
+		ksft_print_msg("pthread_attr: %s\n", strerror(err));
+		return -1;
+	}
+	for (; n > 0; n--) {
+		if (nheld == max || pthread_create(&held[nheld], &a, holder, NULL)) {
+			ksft_print_msg("a holder thread could not start\n");
+			return -1;
+		}
+		if (sem_wait_for(&held_up, 10000)) {
+			ksft_print_msg("a holder did not answer\n");
+			nheld++;	/* release_held() joins it */
+			return -1;
+		}
+		if (held_err) {
+			join(held[nheld]);
+			return -1;
+		}
+		nheld++;
+	}
+	return 0;
+}
+
+static void release_held(void)
+{
+	int i;
+
+	for (i = 0; i < nheld; i++)
+		if (sem_post(&held_go))
+			ksft_print_msg("sem_post: %s\n", strerror(errno));
+	for (i = 0; i < nheld; i++)
+		join(held[i]);
+	/* Drain the semaphore counts a late or refused holder left. */
+	while (held && (!sem_trywait(&held_up) || !sem_trywait(&held_go)))
+		;
+	nheld = 0;
+	sleep_ns(3 * PERIOD);	/* their 0-lag times */
+}
+
+/*
+ * Change the runtime and the period of the fair server of P's CPU. Its
+ * bandwidth comes out of what P's root domain has for deadline tasks.
+ * From 100ms every second (10%), P must admit two probe tasks fewer at
+ * 30%, and one fewer at 100ms every 500ms. With the server off, it must
+ * admit one more. A change that P has no room for must be refused with
+ * EBUSY, and leave the server as it was.
+ */
+static int server_params(void)
+{
+	static const struct {
+		uint64_t runtime, period;
+		int more;
+		const char *what;
+	} step[] = {
+		{ 3 * SERVER_RUNTIME, SERVER_PERIOD, -2, "a fair server of 30%" },
+		{ SERVER_RUNTIME, SERVER_PERIOD / 2, -1, "a fair server of 100ms every 500ms" },
+		{ 0, SERVER_PERIOD, 1, "the fair server off" },
+		{ SERVER_RUNTIME, SERVER_PERIOD, 0, "the fair server back to 10%" },
+	};
+	int cpu = top_cpu(1), base, err, i, ret = KSFT_PASS;
+	uint64_t runtime;
+
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", cpu);
+		return KSFT_SKIP;
+	}
+	base = probe(NULL);
+	if (base < 2) {
+		ksft_print_msg("no room in P for two probe tasks\n");
+		return KSFT_SKIP;
+	}
+	for (i = 0; i < (int)ARRAY_SIZE(step); i++) {
+		err = server_set(cpu, step[i].runtime, step[i].period);
+		if (err) {
+			ksft_print_msg("%s: %s\n", step[i].what, strerror(-err));
+			return KSFT_FAIL;
+		}
+		if (admits(base + step[i].more, step[i].what))
+			return KSFT_FAIL;
+	}
+	/*
+	 * With base - 1 probe tasks held, P has room for 10% more, and not
+	 * for 20%. So the server may grow to 20%, and not to 30%.
+	 */
+	if (hold(base - 1)) {
+		release_held();
+		return KSFT_FAIL;
+	}
+	err = server_put(cpu, "runtime", 2 * SERVER_RUNTIME);
+	if (err) {
+		ksft_print_msg("a fair server of 20%% with room for it: %s\n", strerror(-err));
+		ret = KSFT_FAIL;
+	} else {
+		err = server_put(cpu, "runtime", 3 * SERVER_RUNTIME);
+		if (err != -EBUSY) {
+			ksft_print_msg("a fair server of 30%% with no room for it: %s, not EBUSY\n",
+				       err ? strerror(-err) : "accepted");
+			ret = KSFT_FAIL;
+		} else if (server_get(cpu, "runtime", &runtime) ||
+			   runtime != 2 * SERVER_RUNTIME) {
+			ksft_print_msg("a refused change changed the fair server\n");
+			ret = KSFT_FAIL;
+		}
+	}
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD))
+		ret = KSFT_FAIL;
+	release_held();
+	if (ret == KSFT_PASS && admits(base, "after a refused change of the fair server"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+/*
+ * A rebuild of the root domains' accounting must count each fair server
+ * with its current runtime, not its runtime at boot. Check it for the
+ * server of P's CPU, set to 30%:
+ *  - In P, as Q is made and unmade beside P.
+ *  - In the root domain of the other CPUs, once P is unmade.
+ *  - In P again, once P is made anew.
+ */
+static int server_rebuilds(void)
+{
+	int cpu = top_cpu(1), base, n10, n30;
+
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", cpu);
+		return KSFT_SKIP;
+	}
+	base = probe(cg_p);
+	if (base < 2) {
+		ksft_print_msg("no room in P for two probe tasks\n");
+		return KSFT_SKIP;
+	}
+	if (server_set(cpu, 3 * SERVER_RUNTIME, SERVER_PERIOD) ||
+	    admits_in(cg_p, base - 2, "P, a fair server of 30%"))
+		return KSFT_FAIL;
+	if (make_partition(cg_q, top_cpu(2))) {
+		remove_partition(cg_q);
+		ksft_print_msg("no partition root Q beside P\n");
+		return KSFT_FAIL;
+	}
+	if (admits_in(cg_p, base - 2, "P, Q made beside it")) {
+		remove_partition(cg_q);
+		return KSFT_FAIL;
+	}
+	remove_partition(cg_q);
+	if (admits_in(cg_p, base - 2, "P, Q unmade beside it"))
+		return KSFT_FAIL;
+	/* Unmake P: its CPU and its server join the other CPUs. */
+	remove_p();
+	n30 = probe(root);
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD))
+		return KSFT_FAIL;
+	n10 = probe(root);
+	if (n10 != n30 + 2) {
+		ksft_print_msg("P unmade: %d probe tasks, its CPU's server at 30%%, %d at 10%%\n",
+			       n30, n10);
+		return KSFT_FAIL;
+	}
+	if (server_set(cpu, 3 * SERVER_RUNTIME, SERVER_PERIOD) || make_p()) {
+		ksft_print_msg("P made anew, a fair server of 30%%: failed\n");
+		return KSFT_FAIL;
+	}
+	if (admits_in(cg_p, base - 2, "P made anew, a fair server of 30%") ||
+	    server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD) ||
+	    admits_in(cg_p, base, "P, the fair server back to 10%"))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/* Wait for the futex @f, in shared memory, to be set. */
+static void wait_set(atomic_int *f)
+{
+	while (!*f)
+		syscall(SYS_futex, f, FUTEX_WAIT, 0, NULL, NULL, 0);
+}
+
+static void set_flag(atomic_int *f, int val)
+{
+	*f = val;
+	syscall(SYS_futex, f, FUTEX_WAKE, INT_MAX, NULL, NULL, 0);
+}
+
+/*
+ * Fork a process of P that spins while mv_state[4 + @rt] is set, and
+ * sleeps otherwise. It is a fair task, or a real-time one if @rt. The
+ * real-time one sleeps 1ms every 50ms, to let the real-time kthreads of
+ * P's CPU run: PREEMPT_RT runs RCU and the timers there. Return the pid,
+ * or -1.
+ */
+static pid_t server_client(int rt)
+{
+	pid_t pid = fork_child(rt ? "a real-time task of P" : "a fair task of P");
+
+	if (!pid) {
+		struct sched_param sp = { .sched_priority = 1 };
+
+		if (enter(cg_p, getpid()))
+			_exit(1);
+		if (rt && sched_setscheduler(0, SCHED_FIFO, &sp)) {
+			/* With RT group scheduling, P can have no RT runtime. */
+			if (errno == EPERM)
+				mv_state[6] = 1;
+			_exit(1);
+		}
+		mv_state[0]++;
+		for (;;) {
+			wait_set(&mv_state[4 + rt]);
+			spin_ns(rt ? 50 * NSEC_PER_MSEC : NSEC_PER_MSEC);
+			if (rt)
+				sleep_ns(NSEC_PER_MSEC);
+		}
+	}
+	return pid;
+}
+
+/* Return the CPU share of process @pid over @ns, in percent, or -1. */
+static int proc_share(pid_t pid, uint64_t ns)
+{
+	struct timespec t0, t1;
+	uint64_t wall = now_ns();
+	clockid_t c;
+
+	if (clock_getcpuclockid(pid, &c) || clock_gettime(c, &t0))
+		return -1;
+	sleep_ns(ns);
+	if (clock_gettime(c, &t1))
+		return -1;
+	wall = now_ns() - wall;
+	return (int)(100 * ((t1.tv_sec - t0.tv_sec) * NSEC_PER_SEC +
+			    t1.tv_nsec - t0.tv_nsec) / wall);
+}
+
+/* % that the share of a starved task may differ from its server's bandwidth */
+#define STARVED_SLACK	8
+
+/*
+ * Change the fair server of P's CPU, from outside P, in each state a
+ * change can find it in:
+ *  - stopped
+ *  - deferred while a fair task of P runs
+ *  - deferred while a real-time task starves that fair task
+ *  - serving it
+ *  - deferred again after serving it
+ *  - deferred while the CPU idles
+ *
+ * A fair task and a SCHED_FIFO task of P, see server_client(), put the
+ * server in these states.
+ *
+ * Each change starts a period of the server. The server defers serving a
+ * starved task to its zero-laxity time. That is 0.7s into the period at
+ * 30%, and 0.9s at 10%. Afterwards, the starved task must get the
+ * server's bandwidth, at 30% then at 10%. P's free bandwidth must then be
+ * what it was.
+ *
+ * A change cannot find the server in two more states. Throttled after
+ * serving, the server is deferred anew at once: the last of the served
+ * task's runtime is charged to it as background running. And on a CPU
+ * with no tick in idle, its idle wait begins and ends in one timer
+ * callback.
+ */
+static int server_states(void)
+{
+	static const struct {
+		int fair, rt, ms;
+	} step[] = {
+		{ 0, 0, 1500 },	/* stopped: nothing of P ran for a period */
+		{ 1, 0, 300 },	/* deferred while the fair task runs */
+		{ 1, 1, 300 },	/* deferred, fair task starved: before 0.9s */
+		{ 1, 1, 800 },	/* serving it: after 0.7s */
+		{ 1, 1, 1500 },	/* deferred again: served from 0.9s to 1s */
+		{ 0, 0, 600 },	/* deferred while the CPU idles */
+	};
+	int cpu = top_cpu(1), base, i, s30 = -1, s10 = -1, ret = KSFT_PASS;
+	pid_t fair, rt;
+
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", cpu);
+		return KSFT_SKIP;
+	}
+	base = probe(cg_p);
+	if (base <= 0) {
+		ksft_print_msg("no room in P to probe\n");
+		return KSFT_SKIP;
+	}
+	mv_state[0] = 0;
+	mv_state[6] = 0;
+	set_flag(&mv_state[4], 0);
+	set_flag(&mv_state[5], 0);
+	fair = server_client(0);
+	rt = server_client(1);
+	if (fair < 0 || rt < 0 || wait_for(5000, mv_state[0] >= 2 || mv_state[6])) {
+		if (fair >= 0 && rt >= 0)
+			ksft_print_msg("a fair or real-time task of P could not start\n");
+		ret = KSFT_FAIL;
+	} else if (mv_state[6]) {
+		ksft_print_msg("P has no real-time runtime\n");
+		ret = KSFT_SKIP;
+	}
+	/*
+	 * Even steps set the server's runtime to 30%, odd ones back to 10%.
+	 * The period stays.
+	 */
+	for (i = 0; i < (int)ARRAY_SIZE(step) && ret == KSFT_PASS; i++) {
+		set_flag(&mv_state[4], step[i].fair);
+		set_flag(&mv_state[5], step[i].rt);
+		sleep_ns(step[i].ms * NSEC_PER_MSEC);
+		if (server_put(cpu, "runtime", (i & 1 ? 1 : 3) * SERVER_RUNTIME)) {
+			ksft_print_msg("change %d of the fair server refused\n", i + 1);
+			ret = KSFT_FAIL;
+		}
+	}
+	if (ret == KSFT_PASS) {
+		set_flag(&mv_state[4], 1);
+		set_flag(&mv_state[5], 1);
+		if (server_put(cpu, "runtime", 3 * SERVER_RUNTIME))
+			ret = KSFT_FAIL;
+		s30 = proc_share(fair, 2 * SERVER_PERIOD);
+		if (server_put(cpu, "runtime", SERVER_RUNTIME))
+			ret = KSFT_FAIL;
+		s10 = proc_share(fair, 2 * SERVER_PERIOD);
+	}
+	set_flag(&mv_state[5], 0);
+	set_flag(&mv_state[4], 0);
+	reap(rt);
+	reap(fair);
+	if (ret == KSFT_PASS &&
+	    (s30 < 30 - STARVED_SLACK || s30 > 30 + STARVED_SLACK ||
+	     s10 < 10 - STARVED_SLACK || s10 > 10 + STARVED_SLACK)) {
+		ksft_print_msg("a starved fair task got %d%% of a server of 30%%, %d%% of 10%%\n",
+			       s30, s10);
+		ret = KSFT_FAIL;
+	}
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && admits_in(cg_p, base, "after the fair server's changes"))
+		ret = KSFT_FAIL;
+	return ret;
+}
+
+/*
+ * A reclaiming deadline task of P gets the share of P's CPU that its root
+ * domain leaves free. P's fair server takes from that share. The task
+ * must get:
+ *  - less once the server grows from 10% to 30%.
+ *  - as much after a rebuild of the accounting (Q made and unmade).
+ *  - what it had at first once the server is back at 10%.
+ *
+ * Then put the server back as the test found it, so that P's free
+ * bandwidth is what it was.
+ */
+static int server_reclaim(void)
+{
+	int cpu = top_cpu(1), s10, s30, rebuilt, back, ret = KSFT_PASS;
+	pthread_t t;
+
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", cpu);
+		return KSFT_SKIP;
+	}
+	if (start_spinner(&t, 10 * NSEC_PER_MSEC, SCHED_FLAG_RECLAIM)) {
+		ksft_print_msg("no room for a task of 10%%\n");
+		return KSFT_SKIP;
+	}
+	s10 = share_of(t, SHARE_NS);
+	if (server_set(cpu, 3 * SERVER_RUNTIME, SERVER_PERIOD))
+		ret = KSFT_FAIL;
+	s30 = share_of(t, SHARE_NS);
+	if (make_partition(cg_q, top_cpu(2)))
+		ret = KSFT_FAIL;
+	remove_partition(cg_q);
+	rebuilt = share_of(t, SHARE_NS);
+	if (server_set(cpu, SERVER_RUNTIME, SERVER_PERIOD))
+		ret = KSFT_FAIL;
+	back = share_of(t, SHARE_NS);
+	stop_spinner(t);
+	server_restore();
+	if (ret == KSFT_PASS &&
+	    (s30 > s10 - SHARE_SLACK ||
+	     rebuilt < s30 - SHARE_SLACK || rebuilt > s30 + SHARE_SLACK ||
+	     back < s10 - SHARE_SLACK || back > s10 + SHARE_SLACK)) {
+		ksft_print_msg("reclaiming: %d%%, %d%% at 30%%, %d%% rebuilt, %d%% back at 10%%\n",
+			       s10, s30, rebuilt, back);
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/* Parameter changes while a task wakes on another CPU */
+
+#define WAKE_NS		(5 * NSEC_PER_SEC)	/* how long the changes go on */
+#define WAKE_BURST	2000			/* pairs of changes per clock reading */
+
+/* Read this_bw and running_bw of @cpu from sched_debug. Return 0, or -1. */
+static int rq_bw_of(int cpu, long *this_bw, long *running_bw)
+{
+	char line[256], want[32];
+	FILE *f = fopen("/sys/kernel/debug/sched/debug", "r");
+	int in = 0, got = 0;
+
+	if (!f)
+		return -1;
+	snprintf(want, sizeof(want), "dl_rq[%d]:", cpu);
+	while (got < 2 && fgets(line, sizeof(line), f)) {
+		char *val = strchr(line, ':');
+
+		if (!strncmp(line, want, strlen(want)))
+			in = 1;
+		else if (in && !strncmp(line, "dl_rq[", 6))
+			break;			/* the next CPU's */
+		else if (!in || !val)
+			continue;
+		else if (strstr(line, ".running_bw") && sscanf(val + 1, "%ld", running_bw) == 1)
+			got++;
+		else if (strstr(line, ".this_bw") && sscanf(val + 1, "%ld", this_bw) == 1)
+			got++;
+	}
+	fclose(f);
+	return got == 2 ? 0 : -1;
+}
+
+static atomic_int *wk_state;		/* 0: tasks up, 1: wakeups, 2: stop */
+
+/*
+ * Fork a deadline task of @runtime every @period in Q. It counts itself
+ * in wk_state[0], then spins. With @sleeps, it instead runs 20us and
+ * sleeps 80us in a loop, and counts its wakeups in wk_state[1]. It exits
+ * once wk_state[2] is set. Return the pid, or -1.
+ */
+static pid_t waking_task(uint64_t runtime, uint64_t period, int sleeps)
+{
+	pid_t pid = fork_child("a waking deadline task");
+
+	if (!pid) {
+		if (enter(cg_q, getpid()) || set_deadline(0, runtime, period)) {
+			wk_state[0] = -1;
+			_exit(1);
+		}
+		wk_state[0]++;
+		for (;;) {
+			if (wk_state[2])
+				_exit(0);
+			spin_ns(sleeps ? 20 * NSEC_PER_USEC : NSEC_PER_MSEC);
+			if (sleeps) {
+				sleep_ns(80 * NSEC_PER_USEC);
+				wk_state[1]++;
+			}
+		}
+	}
+	return pid;
+}
+
+/*
+ * Fork a process that changes the parameters of @pid over and over, until
+ * wk_state[2] is set. Return its pid, or -1.
+ */
+static pid_t changer_proc(pid_t pid)
+{
+	pid_t self = fork_child("a changer of the parameters");
+
+	if (!self) {
+		while (!wk_state[2]) {
+			if (set_deadline(pid, 20 * NSEC_PER_MSEC, PERIOD) ||
+			    set_deadline(pid, 10 * NSEC_PER_MSEC, PERIOD))
+				break;
+		}
+		_exit(0);
+	}
+	return self;
+}
+
+/*
+ * Change the parameters of a deadline task while its wakeups move it
+ * between two CPUs.
+ *
+ * Q is a partition root of two CPUs. Three deadline tasks run in Q, see
+ * waking_task(). Two of 20ms every 50ms spin, and hold both CPUs with
+ * earlier deadlines. The third is a task of 10ms every 100ms. It runs
+ * 20us and sleeps 80us in a loop. It wakes on whichever of the two CPUs
+ * has the later deadline. So a wakeup can move it to the other CPU.
+ *
+ * Two processes outside Q change the runtime of the third task for 5s:
+ * the test and changer_proc(). Each switches it between 20ms and 10ms in
+ * a loop.
+ *
+ * A wakeup that moves a task takes its bandwidth off the runqueue it
+ * slept on. The enqueue on the new runqueue adds it there, and may be
+ * left to the CPU the task wakes on. Between the two, no runqueue counts
+ * the bandwidth. A change in that window must not change this_bw of
+ * either runqueue. Once the tasks of the case are gone, this_bw of both
+ * CPUs must be what it was before.
+ *
+ * Check this_bw only then. sched_debug prints running_bw and this_bw of
+ * a CPU one after the other, with no lock held in between. Every
+ * parameter change takes the bandwidth of a task off its runqueue and
+ * puts it back. So a reading taken during the changes can straddle one
+ * of them.
+ */
+static int params_waking(void)
+{
+	int cpu_a = top_cpu(3), cpu_b = top_cpu(2), i, ret = KSFT_PASS, changes = 0;
+	long ta, ra, tb, rb, ta2, ra2, tb2, rb2;
+	pid_t pid[3] = { -1, -1, -1 }, changer = -1;
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
+	if (rq_bw_of(cpu_a, &ta, &ra) || rq_bw_of(cpu_b, &tb, &rb)) {
+		remove_partition(cg_q);
+		ksft_print_msg("sched_debug tells of neither CPU's this_bw\n");
+		return KSFT_SKIP;
+	}
+	wk_state = mv_state + 8;
+	wk_state[0] = wk_state[1] = wk_state[2] = 0;
+	/* Two of 40% hold both CPUs with an earlier deadline than the third. */
+	pid[0] = waking_task(20 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC, 0);
+	pid[1] = waking_task(20 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC, 0);
+	pid[2] = waking_task(10 * NSEC_PER_MSEC, PERIOD, 1);
+	if (pid[0] < 0 || pid[1] < 0 || pid[2] < 0) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	wait_for(5000, wk_state[0] >= 3 || wk_state[0] < 0);
+	if (wk_state[0] != 3) {
+		ksft_print_msg("no room for the deadline tasks of a partition of two CPUs\n");
+		ret = KSFT_SKIP;
+		goto out;
+	}
+	changer = changer_proc(pid[2]);
+	if (changer < 0) {
+		ret = KSFT_FAIL;
+		goto out;
+	}
+	end = now_ns() + WAKE_NS;
+	while (now_ns() < end) {
+		for (i = 0; i < WAKE_BURST; i++, changes += 2) {
+			if (set_deadline(pid[2], 20 * NSEC_PER_MSEC, PERIOD) ||
+			    set_deadline(pid[2], 10 * NSEC_PER_MSEC, PERIOD)) {
+				ksft_print_msg("a change of the waking task refused\n");
+				ret = KSFT_FAIL;
+				goto out;
+			}
+		}
+	}
+	if (!wk_state[1]) {
+		ksft_print_msg("the waking task never woke\n");
+		ret = KSFT_FAIL;
+	}
+out:
+	wk_state[2] = 1;
+	reap(changer);
+	for (i = 0; i < 3; i++)
+		reap(pid[i]);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS) {
+		if (rq_bw_of(cpu_a, &ta2, &ra2) || rq_bw_of(cpu_b, &tb2, &rb2)) {
+			ret = KSFT_FAIL;
+		} else if (ta2 != ta || tb2 != tb) {
+			ksft_print_msg("%d changes: this_bw %ld and %ld, was %ld and %ld\n",
+				       changes, ta2, tb2, ta, tb);
+			ret = KSFT_FAIL;
+		}
+	}
+	remove_partition(cg_q);
+	return ret;
+}
+
+/* CPU hotplug, from the main process, with no P */
+
+static int hp_cpu = -1;
+
+/* Return whether the online file of @cpu can be written. */
+static int cpu_hotpluggable(int cpu)
+{
+	char path[64];
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+	return !access(path, W_OK);
+}
+
+static int cpu_online(int cpu, int on)
+{
+	char dir[64];
+
+	snprintf(dir, sizeof(dir), "/sys/devices/system/cpu/cpu%d", cpu);
+	return write_file(dir, "online", on ? "1" : "0");
+}
+
+/* Bring @cpu back online: every case that follows needs it. */
+static void cpu_up(int cpu)
+{
+	int err = cpu_online(cpu, 1);
+
+	if (err)
+		ksft_print_msg("CPU %d cannot come back online: %s\n", cpu, strerror(-err));
+}
+
+/*
+ * Deadline sleepers take most of the free bandwidth. Taking hp_cpu
+ * offline must then fail with EBUSY. Once the sleepers are gone, the
+ * housekeeping root domain must admit what it did before.
+ */
+static int hotplug_refused(void)
+{
+	int base = probe(NULL), n, i, ret = KSFT_PASS, err;
+	pid_t *pid;
+
+	if (base < 12) {
+		ksft_print_msg("needs room for 12 probe tasks\n");
+		return KSFT_SKIP;
+	}
+	/*
+	 * The sleepers of 30% leave 30% to 60% of a CPU free. A CPU that
+	 * goes offline takes more than that, so the offline must fail.
+	 */
+	n = base / 3 - 1;
+	pid = calloc(n, sizeof(*pid));
+	if (!pid) {
+		ksft_print_msg("calloc: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+	for (i = 0; i < n; i++) {
+		mv_state[0] = 0;
+		pid[i] = mover(MV_ASLEEP, 30 * NSEC_PER_MSEC);
+		if (pid[i] < 0 || child_up("a deadline sleeper", 0)) {
+			while (i >= 0)
+				reap(pid[i--]);
+			free(pid);
+			return KSFT_FAIL;
+		}
+	}
+	err = cpu_online(hp_cpu, 0);
+	if (!err) {
+		ksft_print_msg("CPU %d went offline with its deadline bandwidth in use\n", hp_cpu);
+		cpu_up(hp_cpu);
+		ret = KSFT_FAIL;
+	} else if (err != -EBUSY) {
+		ksft_print_msg("offline refused with %s, not EBUSY\n", strerror(-err));
+		ret = KSFT_FAIL;
+	}
+	for (i = 0; i < n; i++)
+		reap(pid[i]);
+	free(pid);
+	sleep_ns(3 * PERIOD);
+	if (ret == KSFT_PASS && probe(NULL) != base) {
+		ksft_print_msg("a refused offline changed the free bandwidth\n");
+		ret = KSFT_FAIL;
+	}
+	return ret;
+}
+
+/*
+ * The bandwidth of a fair server must leave the root domain with its CPU
+ * and come back with it, whatever its size. Probe the housekeeping root
+ * domain with:
+ *  - the server of hp_cpu at 10%, the CPU online: the base;
+ *  - the server at 10%, the CPU offline;
+ *  - the server at 30%, the CPU online: two probe tasks fewer than the
+ *    base;
+ *  - the server at 30%, the CPU offline: as many as at 10%, offline.
+ * With the CPU back and its server at 30%, the root domain must admit two
+ * fewer than the base again. With the server back at 10%, it must admit
+ * the base.
+ */
+static int hotplug_server(void)
+{
+	int base, off10, off30;
+
+	if (ext_switched_all()) {
+		ksft_print_msg("a hotplug can end the sched_ext scheduler\n");
+		return KSFT_SKIP;
+	}
+	if (server_set(hp_cpu, SERVER_RUNTIME, SERVER_PERIOD)) {
+		ksft_print_msg("the fair server of CPU %d cannot be set\n", hp_cpu);
+		return KSFT_SKIP;
+	}
+	base = probe(NULL);
+	if (base < 0)
+		return KSFT_FAIL;
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("offline of CPU %d refused\n", hp_cpu);
+		return KSFT_FAIL;
+	}
+	off10 = probe(NULL);
+	cpu_up(hp_cpu);
+	if (off10 < 0 || server_set(hp_cpu, 3 * SERVER_RUNTIME, SERVER_PERIOD) ||
+	    admits(base - 2, "a fair server of 30%"))
+		return KSFT_FAIL;
+	if (cpu_online(hp_cpu, 0)) {
+		ksft_print_msg("offline of CPU %d refused, its fair server at 30%%\n", hp_cpu);
+		return KSFT_FAIL;
+	}
+	off30 = probe(NULL);
+	cpu_up(hp_cpu);
+	if (off30 < 0)
+		return KSFT_FAIL;
+	if (off30 != off10) {
+		ksft_print_msg("CPU %d offline: %d probe tasks, its server at 10%%, %d at 30%%\n",
+			       hp_cpu, off10, off30);
+		return KSFT_FAIL;
+	}
+	if (admits(base - 2, "a fair server of 30%, its CPU back online") ||
+	    server_set(hp_cpu, SERVER_RUNTIME, SERVER_PERIOD) ||
+	    admits(base, "the fair server back to 10%"))
+		return KSFT_FAIL;
+	return KSFT_PASS;
+}
+
+/* Return whether @cpu is in @list, a CPU list as sysfs prints it. */
+static int in_cpu_list(const char *list, int cpu)
+{
+	const char *p = list;
+
+	while (*p >= '0' && *p <= '9') {
+		char *end;
+		long lo = strtol(p, &end, 10), hi = lo;
+
+		if (*end == '-')
+			hi = strtol(end + 1, &end, 10);
+		if (cpu >= lo && cpu <= hi)
+			return 1;
+		p = *end == ',' ? end + 1 : end;
+	}
+	return 0;
+}
+
+/* Setup */
+
+static int find_cgroup2(void)
+{
+	char line[PATH_MAX + 64], dev[64], dir[PATH_MAX], type[64];
+	FILE *f = fopen("/proc/self/mounts", "r");
+	int found = 0;
+
+	while (f && !found && fgets(line, sizeof(line), f)) {
+		if (sscanf(line, "%63s %4095s %63s", dev, dir, type) == 3 &&
+		    !strcmp(type, "cgroup2")) {
+			snprintf(root, sizeof(root), "%s", dir);
+			found = 1;
+		}
+	}
+	if (f)
+		fclose(f);
+	return found ? 0 : -1;
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
+/* The tables of the cases, and main() */
+
+enum where {
+	MEASURED_IN_P,	/* in a child in P, probed before and after */
+	IN_P,		/* in a child in P, which measures itself */
+	FROM_OUTSIDE,	/* in the main process, outside P */
+};
+
+static const struct p_case {
+	const char *name;
+	int (*fn)(void);
+	enum where where;
+} p_cases[] = {
+	{ "pi_deadline_owner", pi_deadline_owner, MEASURED_IN_P },
+	{ "pi_other_owner_asleep", pi_other_owner_asleep, MEASURED_IN_P },
+	{ "pi_unlock_running", pi_unlock_running, MEASURED_IN_P },
+	{ "pi_chain_two_owners", pi_chain_two_owners, MEASURED_IN_P },
+	{ "params_asleep", params_asleep, IN_P },
+	{ "params_non_contending", params_non_contending, MEASURED_IN_P },
+	{ "params_switched_asleep", params_switched_asleep, MEASURED_IN_P },
+	{ "params_shrunk_long_period", params_shrunk_long_period, MEASURED_IN_P },
+	{ "params_throttled", params_throttled, MEASURED_IN_P },
+	{ "params_refused", params_refused, IN_P },
+	{ "params_keep_class_change", params_keep_class_change, MEASURED_IN_P },
+	{ "params_keep_boosted", params_keep_boosted, MEASURED_IN_P },
+	{ "boosted_owner_policy", boosted_owner_policy, MEASURED_IN_P },
+	{ "deboost_resets_period", deboost_resets_period, MEASURED_IN_P },
+	{ "deboost_keeps_own_runtime", deboost_keeps_own_runtime, MEASURED_IN_P },
+	{ "return_asleep_new_params", return_asleep_new_params, MEASURED_IN_P },
+	{ "deboost_blocked_keeps_order", deboost_blocked_keeps_order, MEASURED_IN_P },
+	{ "pi_chain_donor_leaves", pi_chain_donor_leaves, MEASURED_IN_P },
+	{ "move_refused", move_refused, FROM_OUTSIDE },
+	{ "move_zero_bw", move_zero_bw, FROM_OUTSIDE },
+	{ "move_cancelled", move_cancelled, FROM_OUTSIDE },
+	{ "death_running", death_running, MEASURED_IN_P },
+	{ "death_switched_out", death_switched_out, MEASURED_IN_P },
+	{ "death_shrunk", death_shrunk, MEASURED_IN_P },
+	{ "stopped_switched_out", stopped_switched_out, MEASURED_IN_P },
+	{ "death_killed_asleep", death_killed_asleep, MEASURED_IN_P },
+	{ "death_killed_non_contending", death_killed_non_contending, MEASURED_IN_P },
+	{ "death_killed_throttled", death_killed_throttled, MEASURED_IN_P },
+	{ "death_killed_running", death_killed_running, MEASURED_IN_P },
+	{ "death_pi_waiter", death_pi_waiter, MEASURED_IN_P },
+	{ "death_pi_owner", death_pi_owner, MEASURED_IN_P },
+	{ "death_pi_deadline_owner", death_pi_deadline_owner, MEASURED_IN_P },
+	{ "death_group", death_group, MEASURED_IN_P },
+	{ "death_zombie_switched", death_zombie_switched, FROM_OUTSIDE },
+	{ "yield_switched_out", yield_switched_out, IN_P },
+	{ "yield_killed", yield_killed, MEASURED_IN_P },
+	{ "overrun_caught", overrun_caught, IN_P },
+	{ "overrun_group_death", overrun_group_death, MEASURED_IN_P },
+	{ "reclaim_runs", reclaim_runs, MEASURED_IN_P },
+	{ "reclaim_switched", reclaim_switched, MEASURED_IN_P },
+	{ "server_params", server_params, IN_P },
+	{ "server_rebuilds", server_rebuilds, FROM_OUTSIDE },
+	{ "server_states", server_states, FROM_OUTSIDE },
+	{ "server_reclaim", server_reclaim, MEASURED_IN_P },
+	{ "params_waking", params_waking, FROM_OUTSIDE },
+};
+
+#define N_P_CASES	((int)ARRAY_SIZE(p_cases))
+
+static const struct hp_case {
+	const char *name;
+	int (*fn)(void);
+} hp_cases[] = {
+	{ "hotplug_refused", hotplug_refused },
+	{ "hotplug_server", hotplug_server },
+};
+
+#define N_HP_CASES	((int)ARRAY_SIZE(hp_cases))
+
+/* Run the cases of p_cases[], each with a P made anew. */
+static void run_p_cases(void)
+{
+	char path[PATH_MAX + 32], buf[256];
+	int i, ret, added = 0, told = 0, ok;
+
+	ok = !find_cgroup2() &&
+	     snprintf(cg_p, sizeof(cg_p), "%s/deadline_bw_p", root) < (int)sizeof(cg_p) &&
+	     snprintf(cg_q, sizeof(cg_q), "%s/deadline_bw_q", root) < (int)sizeof(cg_q);
+	if (ok) {
+		/*
+		 * Enable the cpuset controller for the children of the
+		 * root while the cases run.
+		 */
+		snprintf(path, sizeof(path), "%s/cgroup.subtree_control", root);
+		ok = !read_file(path, buf, sizeof(buf));
+		added = ok && !strstr(buf, "cpuset");
+		if (added && write_file(root, "cgroup.subtree_control", "+cpuset")) {
+			ok = 0;
+			added = 0;
+		}
+	}
+	for (i = 0; i < N_P_CASES; i++) {
+		const struct p_case *c = &p_cases[i];
+
+		if (ok && make_p()) {
+			remove_p();
+			ok = 0;
+		}
+		if (!ok) {
+			if (!told++)
+				ksft_print_msg("no one-CPU partition root: cases in P skipped\n");
+			ksft_test_result_skip("%s\n", c->name);
+			continue;
+		}
+		if (c->where == MEASURED_IN_P)
+			ret = measured(c->name, cg_p, c->fn);
+		else if (c->where == IN_P)
+			ret = run_in(cg_p, c->fn);
+		else
+			ret = c->fn();
+		remove_p();
+		server_restore();
+		report(c->name, ret);
+	}
+	if (added && write_file(root, "cgroup.subtree_control", "-cpuset"))
+		ksft_print_msg("the cpuset controller stays enabled\n");
+}
+
+/*
+ * Read the online CPUs into *@cpus, in ascending order. Read those that
+ * isolcpus="domain" isolates if @iso, the others if not. Return their
+ * count, or -1.
+ */
+static int read_online(int **cpus, int iso)
+{
+	static char buf[65536];		/* a sysfs list fits in a page */
+	char *p = buf;
+	int n = 0, max = 0;
+
+	if (read_file("/sys/devices/system/cpu/online", buf, sizeof(buf)) ||
+	    strlen(buf) == sizeof(buf) - 1)
+		return -1;
+	while (*p >= '0' && *p <= '9') {
+		long lo = strtol(p, &p, 10), hi = lo;
+
+		if (*p == '-')
+			hi = strtol(p + 1, &p, 10);
+		for (; lo <= hi; lo++) {
+			if (in_cpu_list(isolated, lo) != iso)
+				continue;
+			if (n == max) {
+				int *more = realloc(*cpus, (max = 2 * max + 64) * sizeof(**cpus));
+
+				if (!more)
+					return -1;
+				*cpus = more;
+			}
+			(*cpus)[n++] = lo;
+		}
+		if (*p == ',')
+			p++;
+	}
+	return n;
+}
+
+int main(void)
+{
+	char buf[64];
+	cpu_set_t set;
+	int i;
+
+	ksft_print_header();
+	if (geteuid())
+		ksft_exit_skip("needs root\n");
+	/* No such file: nothing isolated. */
+	if (read_file("/sys/devices/system/cpu/isolated", isolated, sizeof(isolated)))
+		isolated[0] = 0;
+	ncpus = read_online(&online, 0);
+	if (ncpus < 0)
+		ksft_exit_fail_msg("the online CPUs cannot be read\n");
+	if (ncpus < 3)
+		ksft_exit_skip("needs 3 CPUs not isolated by isolcpus=domain\n");
+	/*
+	 * Keep the tasks of the test off the isolated CPUs: a deadline task
+	 * there is admitted in the root domain of the isolated CPUs. Use
+	 * sched_setaffinity() for that. A change of the partitions gives the
+	 * tasks of the root cpuset all its CPUs again, the isolated CPUs
+	 * too. But the kernel keeps them within an affinity set by
+	 * sched_setaffinity(). The children inherit this affinity.
+	 */
+	CPU_ZERO(&set);
+	for (i = 0; i < ncpus; i++)
+		CPU_SET(online[i], &set);
+	if (sched_setaffinity(0, sizeof(set), &set))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (read_file("/proc/sys/kernel/sched_rt_runtime_us", buf, sizeof(buf)) || atol(buf) < 0)
+		ksft_exit_skip("no deadline admission control\n");
+	mv_state = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (mv_state == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	shm_lock = (pthread_mutex_t *)((char *)mv_state + 256);
+
+	ksft_set_plan(N_P_CASES + N_HP_CASES);
+	server_init();
+	run_p_cases();
+
+	for (i = 1; i < ncpus && hp_cpu < 0; i++) {
+		if (cpu_hotpluggable(top_cpu(i)))
+			hp_cpu = top_cpu(i);
+	}
+	if (hp_cpu < 0)
+		ksft_print_msg("no CPU hotplug: hotplug cases skipped\n");
+	for (i = 0; i < N_HP_CASES; i++) {
+		if (hp_cpu < 0) {
+			ksft_test_result_skip("%s\n", hp_cases[i].name);
+			continue;
+		}
+		report(hp_cases[i].name, hp_cases[i].fn());
+		server_restore();
+	}
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/sched/deadline/settings b/tools/testing/selftests/sched/deadline/settings
new file mode 100644
index 000000000000..a62d2fa1275c
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/settings
@@ -0,0 +1 @@
+timeout=600
-- 
2.47.3

