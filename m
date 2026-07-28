Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8488E257854
	for <cgroups@vger.kernel.org>; Tue, 28 Jul 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785227930; cv=none; b=aDCJrysb6oM6c799eO2yelCRTF71xEUgiLknoPiK9QmCw6PHmy8KzMHINqyCF0RB65tIqy2rXxJiHDy0wuZt1VLJ7+5dJFbX6XA3eblYKGIiKyYMYBqDJeFVbykvGP+IbOwXxz4YuTWeekR9zjnW3WQHAnaitJD9XQE0lv6C2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785227930; c=relaxed/simple;
	bh=bUfnHhGxXNI9TF0TjXenconsZRV+LOrRxzgYTnurGik=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QpBXD8NL9cqEWtFkgprw6Vjmw3Em+Xw0h0HTCeaj4eUrEbFu7xp1sxZ1n2fND4m2+zq6PWspCTlctRYOe49L5zrmsaplhU8wf2o310LOWBHSjh75TGn/gUgmGQslGQVd7eY7fIQ47fQU4NVI/ZyF0VOd3pARg7o2UIPNNiyDmoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QxnmviKD; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QxnmviKD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785227926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZH4d5/BxOtrgAYDND11fz5q8aNdMt9i1KsWxLQi68Fo=;
	b=QxnmviKDnk3nJpMvOLIUuZUSr0eplXoNARdBlgphihgIfxi85ajML0FlufiAU07SL9B2an
	psaNGiSICUF/mPdYNBUHFxMcQfjxFoyII8uQSnXAtwNT1YxX8lZw7cfwLv2Zo6TYeAW5xo
	57aKn+F8CVzpPd2inDip+HwxD53iObA=
From: Tao Cui <cui.tao@linux.dev>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH v2] selftests/cgroup: add PSI pressure trigger and validation tests
Date: Tue, 28 Jul 2026 16:37:42 +0800
Message-ID: <20260728083742.2359320-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

The cgroup selftests have no PSI coverage. Add test_psi.c: trigger
smoke tests (one per fd, IRQ full-only), cgroup.pressure toggle, and a
CPU-pressure trigger test using over-subscription. Skips when PSI is
disabled or a resource is absent.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
Changes since v1 (Michal Koutny, sashiko review):
- Trim errno checks to smoke level; loosen toggle range checks.
- Switch trigger test from memory to CPU pressure (deterministic, no SKIP).
- churn_memory() removed -- sysconf/shared-helper point is moot.
- Runner stays out of the cgroup; hogs reaped via cg_killall().
- Add PSI/IRQ skip-guards, zero-init buffers, .gitignore entry.
---
 tools/testing/selftests/cgroup/.gitignore |   1 +
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_psi.c | 280 ++++++++++++++++++++++
 4 files changed, 284 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_psi.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..ce2b907c57ea 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -8,5 +8,6 @@ test_kill
 test_kmem
 test_memcontrol
 test_pids
+test_psi
 test_zswap
 wait_inotify
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
index 000000000000..51dc35e26013
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_psi.c
@@ -0,0 +1,280 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/limits.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+/* How long to wait for the CPU-pressure trigger before giving up. */
+#define PSI_POLL_TIMEOUT_MS	5000
+
+static int pressure_open(const char *resource)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
+	return open(path, O_RDWR);
+}
+
+/* Write a trigger descriptor, including the trailing NUL the parser expects. */
+static ssize_t write_trigger(int fd, const char *trigger)
+{
+	return write(fd, trigger, strlen(trigger) + 1);
+}
+
+/* Trigger smoke test: second on same fd -> EBUSY; IRQ rejects "some". */
+static int test_proc_triggers(const char *root)
+{
+	static const char *const resources[] = { "io", "memory", "cpu" };
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
+		errno = 0;
+		if (write_trigger(fd, "some 150000 2000000") <= 0) {
+			ksft_print_msg("%s: 'some' trigger rejected: %s\n",
+				       resources[i], strerror(errno));
+			goto cleanup;
+		}
+		/* A second trigger on the same fd must fail with EBUSY. */
+		errno = 0;
+		if (write_trigger(fd, "full 150000 2000000") != -1 || errno != EBUSY) {
+			ksft_print_msg("%s: second trigger expected EBUSY, got %s\n",
+				       resources[i], strerror(errno));
+			goto cleanup;
+		}
+
+		close(fd);
+		fd = -1;
+	}
+
+	/* IRQ is full-only, and only exists with CONFIG_IRQ_TIME_ACCOUNTING. */
+	fd = pressure_open("irq");
+	if (fd >= 0) {
+		errno = 0;
+		if (write_trigger(fd, "some 150000 1000000") != -1) {
+			ksft_print_msg("irq 'some': expected failure, got %s\n",
+				       strerror(errno));
+			goto cleanup;
+		}
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
+/* cgroup.pressure 0/1 hides/shows the *.pressure files and round-trips. */
+static int test_cgroup_pressure_toggle(const char *root)
+{
+	char buf[BUF_SIZE] = { 0 };
+	char *cg = NULL;
+	int ret = KSFT_FAIL;
+
+	cg = cg_name(root, "psi_toggle_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_write(cg, "cgroup.pressure", "0")) {
+		ksft_print_msg("failed to disable cgroup.pressure\n");
+		goto cleanup;
+	}
+	if (cg_read(cg, "cgroup.pressure", buf, sizeof(buf)) < 0 || atoi(buf) != 0) {
+		ksft_print_msg("cgroup.pressure=0 readback: '%s'\n", buf);
+		goto cleanup;
+	}
+	if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) >= 0) {
+		ksft_print_msg("memory.pressure visible while disabled\n");
+		goto cleanup;
+	}
+
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
+	ret = KSFT_PASS;
+cleanup:
+	if (cg)
+		cg_destroy(cg);
+	free(cg);
+	return ret;
+}
+
+/* Induce deterministic CPU pressure (more hogs than CPUs). */
+static int test_cgroup_trigger_fire(const char *root)
+{
+	char *cg = NULL, *cpupress = NULL;
+	int fd = -1, ret = KSFT_FAIL;
+	struct pollfd pfd;
+	long ncpus, i;
+	pid_t pid;
+
+	cg = cg_name(root, "psi_trigger_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg))
+		goto cleanup;
+
+	cpupress = cg_control(cg, "cpu.pressure");
+	if (!cpupress)
+		goto cleanup;
+	fd = open(cpupress, O_RDWR);
+	if (fd < 0) {
+		ksft_print_msg("open cpu.pressure: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	/* 1us threshold in a 1s window: any cpu stall fires it. */
+	errno = 0;
+	if (write_trigger(fd, "some 1 1000000") <= 0) {
+		ksft_print_msg("arming trigger failed: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (ncpus <= 0)
+		ncpus = 1;
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_print_msg("fork: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	if (pid == 0) {
+		/* Enter the cgroup, then over-subscribe it with CPU hogs. */
+		if (cg_enter_current(cg))
+			_exit(KSFT_FAIL);
+		for (i = 0; i < ncpus; i++) {
+			if (fork() == 0) {
+				for (;;)
+					asm volatile("" ::: "memory");
+				_exit(0);
+			}
+		}
+		for (;;)
+			asm volatile("" ::: "memory");	/* child is also a hog */
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
+		ksft_print_msg("no trigger event; could not induce cpu pressure\n");
+		ret = KSFT_SKIP;
+		break;
+	default:
+		if (pfd.revents & POLLPRI)
+			ret = KSFT_PASS;
+		else
+			ksft_print_msg("poll returned 0x%x\n", pfd.revents);
+		break;
+	}
+
+	/* Stop the hogs (bounded, so waitpid can't hang) and reap the child. */
+	cg_killall(cg);
+	waitpid(pid, NULL, 0);
+
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (cg) {
+		cg_killall(cg);
+		cg_destroy(cg);
+	}
+	free(cpupress);
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
+	TEST(test_proc_triggers),
+	TEST(test_cgroup_pressure_toggle),
+	TEST(test_cgroup_trigger_fire),
+};
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int mempress_fd;
+	int i;
+
+	(void)argc;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	/* PSI must be enabled (CONFIG_PSI=y, not default-disabled). */
+	mempress_fd = open("/proc/pressure/memory", O_RDONLY);
+	if (mempress_fd < 0)
+		ksft_exit_skip("PSI unavailable (CONFIG_PSI=n or psi=0)\n");
+	close(mempress_fd);
+
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

