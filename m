Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207375;
	b=4E8Pdnm9HSlv+7MgEtA7sPyMYX5UrhM3hxVC8wkUV5rvLh4xRxbAh37Y0Feojk1s4vas
	 epnjXIh0uTgqN+s80btyktQdssJcn5f9xaaZAoa8rmTLAyGLeD4Z6qIv+Y8awzvMlAMhq
	 hYDB7Lu9iEiKa1alvVDK3Vhr+D7plGgI5s19CyzWKvs+HfXkvNhEZXeu6hloNXEjz0bbH
	 wX//zNRpiawo0DOtSGG6I3+xtwKnegvc6u4N/FNJPHhGrf1Ig7efz1S7Nz7uWrMsZr10z
	 fnDV/4yVpa5rW8BmM9ZJgA3EWVH6XFDGpb3WbCqRODyXHqDoICftEuARako0Dlc+jZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207375;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+ZZKfPEetf6nDFJZbzURdNyw6vHKdqUkUtaOssOLQH4=;
	b=rnXhsEGz8Tu5/aksWhtZASut62z+9f16zzGKW4dsrJW6SRGfm+RxEBMuVl5MsdGtCSyd
	 oIsDMPYuD2hButKzANSkhQqhdgGbUqylsff9z8ZYWmMhInRsRrNK8yE3jLGuDWdbPEt7P
	 6BCLMv+lesKSIc6J0fIOMYrd9BJdcfDUK0seZLIzX1se/3TWSRcsShGobG1bYfNmrdzCm
	 iYheBHvvE2LwW+vbkYL/shAoRFg4Sl39zGa5KTjFHxXpWysF7y2oJmjp7r0fLppP75oy/
	 OglB7LbtJ1m6AZYCy1uvjI/25n2hqSk1pURD9xsaFJNRKrdCKYZ8Y9l0/NxPduHvU4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=mAKmizLN;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32119606B725;
	Fri, 20 Nov 2026 20:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32119606B725
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=mAKmizLN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207361;
	bh=+ZZKfPEetf6nDFJZbzURdNyw6vHKdqUkUtaOssOLQH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAKmizLN2F1SgiGTo7AiKIuSUlWWMJq2F6E3+r/KPIpk9ONZQZha4/PEQmmCJPhqD
	 Cqb5z+rOL+5lfXzMaHOA7ipaGxGtxFm0mUdz4+FgAhaDeNa3F9DY0Nane3FOUYrRhi
	 D65qZFCVG7tqDk3JUeVeOb7Uvzbv8aUTxFj68kJOmbigRN2jLc4cumTUiw+smXM+tU
	 SeQTTPI60I4rDY1lLw/3N3pAp6kzCNOvjmRnCGWyQkZimtmCVAqtOJxiFT/W2QQt7i
	 8hPcNafXVXDL+6gEJyug4w/LlfxNUZELj650yh6rN+HT9DwOkKx/BwhhIU4Ijaj2Zs
	 /6c4M+XdpVOpQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2T1fTYzSlT;
	Fri, 20 Nov 2026 15:42:41 -0500 (EST)
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
Subject: [PATCH v10 40/40] selftests/sched: Share the helpers of the deadline tests
Date: Fri, 20 Nov 2026 15:42:17 -0500
Message-Id: <62c694b97d7fdffabae640eb6dee797eceb3701c.1795207233.git.mathieu.desnoyers@efficios.com>
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

deadline_bw_test, deadline_rebuild_test and deadline_switch_test each
have a copy of the same helpers. Move these to deadline_util.h:
- now_ns(), thread_time_ns() and sleep_ns();
- report();
- read_file(), write_file() and enter().

The Makefile rebuilds the tests when the header changes. The helpers
that differ from one test to the other stay in each test.

The Sashiko AI review of this series asked for this. No case changes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../testing/selftests/sched/deadline/Makefile |   3 +
 .../sched/deadline/deadline_bw_test.c         |  86 +-------------
 .../sched/deadline/deadline_rebuild_test.c    |  74 +-----------
 .../sched/deadline/deadline_switch_test.c     |  36 +-----
 .../selftests/sched/deadline/deadline_util.h  | 106 ++++++++++++++++++
 5 files changed, 115 insertions(+), 190 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_util.h

diff --git a/tools/testing/selftests/sched/deadline/Makefile b/tools/testing/selftests/sched/deadline/Makefile
index 15f1e96a21e6..c7a665a02d6f 100644
--- a/tools/testing/selftests/sched/deadline/Makefile
+++ b/tools/testing/selftests/sched/deadline/Makefile
@@ -6,3 +6,6 @@ LDLIBS += -lpthread
 TEST_GEN_PROGS := deadline_switch_test deadline_rebuild_test deadline_bw_test
 
 include ../../lib.mk
+
+$(OUTPUT)/%: %.c deadline_util.h
+	$(CC) $(CFLAGS) $< $(LDFLAGS) $(LDLIBS) -o $@
diff --git a/tools/testing/selftests/sched/deadline/deadline_bw_test.c b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
index ba20f7036f6c..848ac5bafd7b 100644
--- a/tools/testing/selftests/sched/deadline/deadline_bw_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_bw_test.c
@@ -94,6 +94,8 @@
 #define NSEC_PER_MSEC	1000000ULL
 #define NSEC_PER_SEC	1000000000ULL
 
+#include "deadline_util.h"
+
 /* The threads of probe() and hold() do nothing: a small stack will do. */
 #define THREAD_STACK	(64 * 1024 > PTHREAD_STACK_MIN ? 64 * 1024 : PTHREAD_STACK_MIN)
 
@@ -124,34 +126,6 @@ static int top_cpu(int n)
 	return online[ncpus - n];
 }
 
-/*
- * clock_gettime() cannot fail in now_ns() and thread_time_ns(). Both
- * clocks are always supported, and the pointer is valid.
- */
-static uint64_t now_ns(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_MONOTONIC, &ts);
-	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-}
-
-static uint64_t thread_time_ns(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
-	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-}
-
-static void sleep_ns(uint64_t ns)
-{
-	struct timespec ts = { .tv_sec = ns / NSEC_PER_SEC, .tv_nsec = ns % NSEC_PER_SEC };
-
-	while (nanosleep(&ts, &ts) && errno == EINTR)
-		;
-}
-
 static void spin_ns(uint64_t ns)
 {
 	uint64_t end = thread_time_ns() + ns;
@@ -305,52 +279,6 @@ static int set_other(pid_t tid)
 	return syscall(SYS_sched_setattr, tid, &attr, 0) ? -errno : 0;
 }
 
-static int write_file(const char *dir, const char *name, const char *val)
-{
-	char path[PATH_MAX];
-	int fd, err = 0;
-	ssize_t n;
-
-	if (snprintf(path, sizeof(path), "%s/%s", dir, name) >= (int)sizeof(path))
-		return -ENAMETOOLONG;
-	fd = open(path, O_WRONLY);
-	if (fd < 0)
-		return -errno;
-	n = write(fd, val, strlen(val));
-	if (n < 0)
-		err = -errno;
-	else if (n != (ssize_t)strlen(val))
-		err = -EIO;
-	if (close(fd) && !err)
-		err = -errno;
-	return err;
-}
-
-static int read_file(const char *path, char *buf, size_t len)
-{
-	int fd = open(path, O_RDONLY);
-	ssize_t n;
-
-	if (fd < 0)
-		return -1;
-	do {
-		n = read(fd, buf, len - 1);
-	} while (n < 0 && errno == EINTR);
-	close(fd);
-	if (n < 0)
-		return -1;
-	buf[n] = 0;
-	return 0;
-}
-
-static int enter(const char *cg, pid_t pid)
-{
-	char buf[16];
-
-	snprintf(buf, sizeof(buf), "%d", pid);
-	return write_file(cg, "cgroup.procs", buf);
-}
-
 /* Return whether @list, words separated by blanks, holds the word @w. */
 static int has_word(const char *list, const char *w)
 {
@@ -12508,16 +12436,6 @@ static int find_cgroup2(void)
 	return found ? 0 : -1;
 }
 
-static void report(const char *name, int ret)
-{
-	if (ret == KSFT_PASS)
-		ksft_test_result_pass("%s\n", name);
-	else if (ret == KSFT_SKIP)
-		ksft_test_result_skip("%s\n", name);
-	else
-		ksft_test_result_fail("%s\n", name);
-}
-
 /* sched_setaffinity() against sched_setattr(), with no P */
 
 /*
diff --git a/tools/testing/selftests/sched/deadline/deadline_rebuild_test.c b/tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
index 85b24b868da7..7b0609e8e6ed 100644
--- a/tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
@@ -52,6 +52,8 @@
 #define NSEC_PER_MSEC	1000000ULL
 #define NSEC_PER_SEC	1000000000ULL
 
+#include "deadline_util.h"
+
 struct dl_attr {
 	uint32_t size;
 	uint32_t sched_policy;
@@ -91,22 +93,6 @@ static int set_other(pid_t pid)
  * Return the CLOCK_MONOTONIC time in ns. clock_gettime() cannot fail: the
  * clock is always supported, and the pointer is valid.
  */
-static uint64_t now_ns(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_MONOTONIC, &ts);
-	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-}
-
-static void sleep_ns(uint64_t ns)
-{
-	struct timespec ts = { .tv_sec = ns / NSEC_PER_SEC, .tv_nsec = ns % NSEC_PER_SEC };
-
-	while (nanosleep(&ts, &ts) && errno == EINTR)
-		;
-}
-
 static void reap(pid_t pid)
 {
 	int status;
@@ -125,52 +111,6 @@ static void reap(pid_t pid)
 	}
 }
 
-static int write_file(const char *dir, const char *name, const char *val)
-{
-	char path[PATH_MAX];
-	int fd, err = 0;
-	ssize_t n;
-
-	if (snprintf(path, sizeof(path), "%s/%s", dir, name) >= (int)sizeof(path))
-		return -ENAMETOOLONG;
-	fd = open(path, O_WRONLY);
-	if (fd < 0)
-		return -errno;
-	n = write(fd, val, strlen(val));
-	if (n < 0)
-		err = -errno;
-	else if (n != (ssize_t)strlen(val))
-		err = -EIO;
-	if (close(fd) && !err)
-		err = -errno;
-	return err;
-}
-
-static int read_file(const char *path, char *buf, size_t len)
-{
-	int fd = open(path, O_RDONLY);
-	ssize_t n;
-
-	if (fd < 0)
-		return -1;
-	do {
-		n = read(fd, buf, len - 1);
-	} while (n < 0 && errno == EINTR);
-	close(fd);
-	if (n < 0)
-		return -1;
-	buf[n] = 0;
-	return 0;
-}
-
-static int enter(const char *cg, pid_t pid)
-{
-	char buf[16];
-
-	snprintf(buf, sizeof(buf), "%d", pid);
-	return write_file(cg, "cgroup.procs", buf);
-}
-
 /* Make @cg a partition root of CPU @cpu alone. Return 0, or -1 on error. */
 static int make_partition(const char *cg, int cpu)
 {
@@ -525,16 +465,6 @@ static int find_cgroup2(void)
 	return found ? 0 : -1;
 }
 
-static void report(const char *name, int ret)
-{
-	if (ret == KSFT_PASS)
-		ksft_test_result_pass("%s\n", name);
-	else if (ret == KSFT_SKIP)
-		ksft_test_result_skip("%s\n", name);
-	else
-		ksft_test_result_fail("%s\n", name);
-}
-
 int main(void)
 {
 	char buf[256], path[PATH_MAX + 32];
diff --git a/tools/testing/selftests/sched/deadline/deadline_switch_test.c b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
index 40c7c6bafc2b..a544bee5af5a 100644
--- a/tools/testing/selftests/sched/deadline/deadline_switch_test.c
+++ b/tools/testing/selftests/sched/deadline/deadline_switch_test.c
@@ -51,6 +51,8 @@
 #define NSEC_PER_MSEC	1000000ULL
 #define NSEC_PER_SEC	1000000000ULL
 
+#include "deadline_util.h"
+
 struct dl_attr {
 	uint32_t size;
 	uint32_t sched_policy;
@@ -70,22 +72,6 @@ struct shared {
 	uint64_t sleeps;	/* sleeps begun */
 };
 
-static uint64_t now_ns(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_MONOTONIC, &ts);
-	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-}
-
-static void sleep_ns(uint64_t ns)
-{
-	struct timespec ts = { .tv_sec = ns / NSEC_PER_SEC, .tv_nsec = ns % NSEC_PER_SEC };
-
-	while (nanosleep(&ts, &ts) && errno == EINTR)
-		;
-}
-
 static void sleep_until(uint64_t t)
 {
 	struct timespec ts = { .tv_sec = t / NSEC_PER_SEC, .tv_nsec = t % NSEC_PER_SEC };
@@ -518,14 +504,6 @@ static sem_t owner_locked, owner_go;
 static pid_t owner_tid;
 static int owner_ms;		/* the owner's CPU time in its first period */
 
-static uint64_t thread_time_ns(void)
-{
-	struct timespec ts;
-
-	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
-	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-}
-
 /*
  * Wait on @s for at most @ms, retrying on signals. Return 0, or -1 on a
  * timeout or an error.
@@ -1081,16 +1059,6 @@ static int test_sysrq_running_owner(int normalized)
 	return ret;
 }
 
-static void report(const char *name, int ret)
-{
-	if (ret == KSFT_PASS)
-		ksft_test_result_pass("%s\n", name);
-	else if (ret == KSFT_SKIP)
-		ksft_test_result_skip("%s\n", name);
-	else
-		ksft_test_result_fail("%s\n", name);
-}
-
 int main(void)
 {
 	int ret;
diff --git a/tools/testing/selftests/sched/deadline/deadline_util.h b/tools/testing/selftests/sched/deadline/deadline_util.h
new file mode 100644
index 000000000000..489233a32cbd
--- /dev/null
+++ b/tools/testing/selftests/sched/deadline/deadline_util.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Helpers that the deadline selftests share. */
+#ifndef DEADLINE_UTIL_H
+#define DEADLINE_UTIL_H
+
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "../../kselftest.h"
+
+#ifndef NSEC_PER_SEC
+#define NSEC_PER_SEC	1000000000ULL
+#endif
+
+/*
+ * clock_gettime() cannot fail in now_ns() and thread_time_ns(). Both
+ * clocks are always supported, and the pointer is valid.
+ */
+static inline uint64_t now_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+static inline uint64_t thread_time_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+}
+
+static inline void sleep_ns(uint64_t ns)
+{
+	struct timespec ts = { .tv_sec = ns / NSEC_PER_SEC, .tv_nsec = ns % NSEC_PER_SEC };
+
+	while (nanosleep(&ts, &ts) && errno == EINTR)
+		;
+}
+
+static inline void report(const char *name, int ret)
+{
+	if (ret == KSFT_PASS)
+		ksft_test_result_pass("%s\n", name);
+	else if (ret == KSFT_SKIP)
+		ksft_test_result_skip("%s\n", name);
+	else
+		ksft_test_result_fail("%s\n", name);
+}
+
+static inline int read_file(const char *path, char *buf, size_t len)
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
+static inline int write_file(const char *dir, const char *name, const char *val)
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
+static inline int enter(const char *cg, pid_t pid)
+{
+	char buf[16];
+
+	snprintf(buf, sizeof(buf), "%d", pid);
+	return write_file(cg, "cgroup.procs", buf);
+}
+
+#endif /* DEADLINE_UTIL_H */
-- 
2.47.3

