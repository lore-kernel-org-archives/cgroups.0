Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3F191F94
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 02:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784861938; cv=none; b=IHfwGHUb0Oys96Fchp2LOE8YKDmghWdR8K+LLSB0Ol1Xkn3S6+CzlFZ0wJXaMkPcpqYiiVrSw+Na1DJ1bstriaFSIAbAl2ubQkFYj3mfsf2F9zOyY1aFdspDv3OBn5FoBsQLdgJE36BuJX2mQaBEU1YcW8s3fyUSDVhYWB1abtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784861938; c=relaxed/simple;
	bh=oNzlbkbdxLFebAfbh38zscNfBTCjRnnmWiZYkMUxcw4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwJzQUhIyefrEgDfAvzQiN8/OjNaf2OEs91Se5+1hjbDIGQ19chI4xReAbabAZCcnVJS2zeCv2Y9khPY77WbtRnhdy+Tj9G94hM5goNXtzI/6Qi5s5IJ06tf+7Yg7MnhnHF32RA3giOsBZX+TeBfiev+l8GCVDzKQ47aXYVFrsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YbWBIzex; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YbWBIzex"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784861923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FwORFNQO6kU1JmyVxScgBVEuST+CsVkexc4BgNBkLwA=;
	b=YbWBIzexl5FbpOamacfZ4C4zeKzIibglM8AwU8U1nbpSZH5WrJHDz97QJ+GMzu8ac5Bb6g
	kQdwAgU4TA8RxEyiY09GE4i/DsDAZ5Ql+yOEYevU9iDaG4H3BOh6voMM1HSoezdNBFpa2n
	rGzo2C5zdahIKqNyZHqP0Dv4TnOsgcQ=
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH] selftests/cgroup: add PSI pressure trigger and validation tests
Date: Fri, 24 Jul 2026 10:58:26 +0800
Message-ID: <20260724025826.504586-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The cgroup selftest suite had no PSI coverage at all. Add test_psi.c:

  - /proc/pressure/{cpu,memory,io} trigger validation: a second trigger
    on the same fd fails EBUSY; out-of-range window/threshold and
    unparseable input fail EINVAL; "some" on /proc/pressure/irq fails
    EINVAL (skipped when the file is absent).
  - cgroup.pressure toggle: disabling hides *.pressure files and
    round-trips; out-of-range input fails ERANGE, non-numeric EINVAL.
  - best-effort positive test: arm a sensitive memory.pressure trigger
    under a tight memory.max, churn memory to induce a stall and expect
    poll() to wake (SKIP if no stall can be induced).

The validation and toggle tests are pure userspace assertions guarding
psi_trigger_create() and cgroup_pressure_write() against regressions.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_psi.c | 358 ++++++++++++++++++++++
 3 files changed, 361 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_psi.c

diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..a8c69e37332a 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_memcontrol
 TEST_GEN_PROGS += test_pids
+TEST_GEN_PROGS += test_psi
 TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
@@ -32,4 +33,5 @@ $(OUTPUT)/test_kill: $(LIBCGROUP_O)
 $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
+$(OUTPUT)/test_psi: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..8a3ef479e83d 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,4 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_PSI=y
diff --git a/tools/testing/selftests/cgroup/test_psi.c b/tools/testing/selftests/cgroup/test_psi.c
new file mode 100644
index 000000000000..6627c500c887
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_psi.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/limits.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+/* How long to wait for a best-effort trigger event before giving up. */
+#define PSI_POLL_TIMEOUT_MS	5000
+/* Memory footprint of the churner; much larger than the cgroup's memory.max. */
+#define PSI_CHURN_SIZE		MB(128)
+
+/* Open /proc/pressure/<resource> O_RDWR (write registers triggers). */
+static int pressure_open(const char *resource)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
+	return open(path, O_RDWR);
+}
+
+/* Write trigger descriptor with the trailing NUL the parser expects. */
+static ssize_t write_trigger(int fd, const char *trigger)
+{
+	return write(fd, trigger, strlen(trigger) + 1);
+}
+
+/* 2nd trigger on same fd -> EBUSY; bad window/threshold/garbage -> EINVAL. */
+static int test_proc_pressure_validation(const char *root)
+{
+	static const char *const resources[] = { "cpu", "memory", "io" };
+	int ret = KSFT_FAIL;
+	int fd = -1;
+	int i;
+
+	(void)root;
+
+	for (i = 0; i < (int)ARRAY_SIZE(resources); i++) {
+		fd = pressure_open(resources[i]);
+		if (fd < 0) {
+			ksft_print_msg("open /proc/pressure/%s: %s\n",
+				       resources[i], strerror(errno));
+			goto cleanup;
+		}
+
+		/* 2s window works with or without CAP_SYS_RESOURCE. */
+		errno = 0;
+		if (write_trigger(fd, "some 150000 2000000") <= 0) {
+			ksft_print_msg("valid 'some' trigger rejected: %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+
+		/* A second trigger on the same fd must fail with EBUSY. */
+		errno = 0;
+		if (write_trigger(fd, "full 150000 2000000") != -1 || errno != EBUSY) {
+			ksft_print_msg("second trigger: expected EBUSY, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+
+		close(fd);
+		fd = pressure_open(resources[i]);
+		if (fd < 0)
+			goto cleanup;
+
+		/* window == 0 -> EINVAL */
+		errno = 0;
+		if (write_trigger(fd, "some 150000 0") != -1 || errno != EINVAL) {
+			ksft_print_msg("window=0: expected EINVAL, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+		/* window > 10s -> EINVAL */
+		errno = 0;
+		if (write_trigger(fd, "some 150000 20000000") != -1 || errno != EINVAL) {
+			ksft_print_msg("window>10s: expected EINVAL, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+		/* threshold == 0 -> EINVAL */
+		errno = 0;
+		if (write_trigger(fd, "some 0 2000000") != -1 || errno != EINVAL) {
+			ksft_print_msg("threshold=0: expected EINVAL, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+		/* threshold > window -> EINVAL */
+		errno = 0;
+		if (write_trigger(fd, "some 3000000 2000000") != -1 || errno != EINVAL) {
+			ksft_print_msg("threshold>window: expected EINVAL, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+		/* unparseable input -> EINVAL */
+		errno = 0;
+		if (write_trigger(fd, "foo 1 2") != -1 || errno != EINVAL) {
+			ksft_print_msg("garbage: expected EINVAL, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
+
+		close(fd);
+		fd = -1;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	return ret;
+}
+
+/* /proc/pressure/irq is full-only: "some" fails EINVAL (skip if absent). */
+static int test_proc_pressure_irq(const char *root)
+{
+	int ret = KSFT_FAIL;
+	int fd;
+
+	(void)root;
+
+	fd = pressure_open("irq");
+	if (fd < 0) {
+		if (errno == ENOENT)
+			return KSFT_SKIP;
+		ksft_print_msg("open /proc/pressure/irq: %s\n", strerror(errno));
+		return KSFT_FAIL;
+	}
+
+	errno = 0;
+	if (write_trigger(fd, "some 150000 1000000") != -1 || errno != EINVAL) {
+		ksft_print_msg("irq 'some' trigger: expected EINVAL, got %s\n",
+			       strerror(errno));
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	close(fd);
+	return ret;
+}
+
+/* cgroup.pressure 0/1 hides/shows *.pressure; ERANGE/EINVAL on bad input. */
+static int test_cgroup_pressure_toggle(const char *root)
+{
+	char *cg = NULL;
+	char buf[BUF_SIZE];
+	int ret = KSFT_FAIL;
+
+	cg = cg_name(root, "psi_toggle_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg))
+		goto cleanup;
+
+	/* Disable: reads back 0 and memory.pressure becomes unreadable. */
+	if (cg_write(cg, "cgroup.pressure", "0")) {
+		ksft_print_msg("failed to disable cgroup.pressure\n");
+		goto cleanup;
+	}
+	if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(buf) != 0) {
+		ksft_print_msg("cgroup.pressure=0 readback: '%s'\n", buf);
+		goto cleanup;
+	}
+	if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) >= 0) {
+		ksft_print_msg("memory.pressure still visible while disabled\n");
+		goto cleanup;
+	}
+
+	/* Re-enable: reads back 1 and memory.pressure is visible again. */
+	if (cg_write(cg, "cgroup.pressure", "1")) {
+		ksft_print_msg("failed to re-enable cgroup.pressure\n");
+		goto cleanup;
+	}
+	if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(buf) != 1) {
+		ksft_print_msg("cgroup.pressure=1 readback: '%s'\n", buf);
+		goto cleanup;
+	}
+	if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) < 0) {
+		ksft_print_msg("memory.pressure unreadable while enabled\n");
+		goto cleanup;
+	}
+
+	/* Out-of-range -> ERANGE, non-numeric -> EINVAL. */
+	if (cg_write(cg, "cgroup.pressure", "2") != -ERANGE) {
+		ksft_print_msg("cgroup.pressure=2: expected ERANGE\n");
+		goto cleanup;
+	}
+	if (cg_write(cg, "cgroup.pressure", "foo") != -EINVAL) {
+		ksft_print_msg("cgroup.pressure=foo: expected EINVAL\n");
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	if (cg)
+		cg_destroy(cg);
+	free(cg);
+	return ret;
+}
+
+/* Touch every page to force allocation under a tight memory.max. */
+static void churn_memory(size_t size)
+{
+	char *p = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	int iter;
+
+	if (p == MAP_FAILED)
+		return;
+	for (iter = 0; iter < 5; iter++) {
+		size_t i;
+
+		for (i = 0; i < size; i += 4096)
+			p[i] = (char)(iter + i);
+	}
+	munmap(p, size);
+}
+
+/* Induce a stall under tight memory.max; expect poll() wake (SKIP on timeout). */
+static int test_cgroup_trigger_fire(const char *root)
+{
+	char *cg = NULL, *mempress = NULL;
+	int fd = -1, ret = KSFT_FAIL;
+	struct pollfd pfd;
+	pid_t pid;
+
+	cg = cg_name(root, "psi_trigger_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg))
+		goto cleanup;
+
+	/* A tight memory.max forces direct reclaim while churning. */
+	if (cg_write(cg, "memory.max", "50000000")) {
+		ksft_print_msg("failed to set memory.max\n");
+		goto cleanup;
+	}
+	if (cg_enter_current(cg)) {
+		ksft_print_msg("failed to enter cgroup\n");
+		goto cleanup;
+	}
+
+	mempress = cg_control(cg, "memory.pressure");
+	if (!mempress)
+		goto cleanup;
+	fd = open(mempress, O_RDWR);
+	if (fd < 0) {
+		ksft_print_msg("open memory.pressure: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	/* 1us threshold in a 1s window: any memory stall fires it. */
+	errno = 0;
+	if (write_trigger(fd, "some 1 1000000") <= 0) {
+		ksft_print_msg("arming trigger failed: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	if (pid == 0) {
+		churn_memory(PSI_CHURN_SIZE);
+		_exit(0);
+	}
+
+	pfd.fd = fd;
+	pfd.events = POLLPRI;
+	switch (poll(&pfd, 1, PSI_POLL_TIMEOUT_MS)) {
+	case -1:
+		ksft_print_msg("poll: %s\n", strerror(errno));
+		break;
+	case 0:
+		ksft_print_msg("no trigger event; could not induce memstall\n");
+		ret = KSFT_SKIP;
+		break;
+	default:
+		if (pfd.revents & (POLLPRI | POLLIN))
+			ret = KSFT_PASS;
+		else
+			ksft_print_msg("poll returned 0x%x\n", pfd.revents);
+		break;
+	}
+
+	waitpid(pid, NULL, 0);
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (cg) {
+		cg_enter_current(root);
+		cg_destroy(cg);
+	}
+	free(mempress);
+	free(cg);
+	return ret;
+}
+
+#define TEST(x) { #x, x }
+
+struct psi_test {
+	const char *name;
+	int (*fn)(const char *root);
+};
+
+static struct psi_test tests[] = {
+	TEST(test_proc_pressure_validation),
+	TEST(test_proc_pressure_irq),
+	TEST(test_cgroup_pressure_toggle),
+	TEST(test_cgroup_trigger_fire),
+};
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int i;
+
+	(void)argc;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("failed to enable memory controller\n");
+
+	for (i = 0; i < (int)ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
-- 
2.43.0

