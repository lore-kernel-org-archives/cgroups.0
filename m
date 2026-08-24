Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8286B3EC6B9
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 08:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787561967; cv=none; b=o06ju46MTI1dDaLHVUIZ82t7c9VVfIAB7OOlxNTMWHldS1+KKJPr8qavDlr9OI5PMaC6x0nypU5DEbeCXfaEg9Wzb5OyO7Es4kUXv41KKTmVdgArn2itJ9e9lu8Hwzq8EO76vDAe8yQIswzMQuIvJRmuYJLQmg0coQzkGWlRXSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787561967; c=relaxed/simple;
	bh=v9Mz9IiugeMcpSwkMTt7bd+jUvOA+Fz24RK1+H/N/XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D7hrC2nIfGbHAGt3pysqLwCBTXaC4dMmIBD95xGWw3EpkdYblKKKmlNXnuI/tcNTHnk0uDSlEXlKpfiSuG5Ya+I1uozUhzzz58+TYR3Sphq9wHHiq5kKlKb6CFuhSa0y5e+cCbMwj+qKbN3o54h2uPjQ+gWyj2dIlRsQdshAglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oYPiAJlu; arc=none smtp.client-ip=95.215.58.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oYPiAJlu"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=v9Mz9IiugeMcpSwkMTt7bd+jUvOA+Fz24RK1+H/N/XQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787561963; v=1; x=1788166763;
 b=oYPiAJluJELoXb3uIQR2ERVFSV6cUPjC/9GaRN37RC3r4ozHQoLDEzrKdtuVy98MNueiToML
 YkT7XaUJU4nJ2dvqcfsoJckSQM14GRdXj9sJeeZScKNT0W7S8uzXyJSrhb66q8ezIhbQY8G8udr
 99swrSGZV0LJVlXV4QfyFG/A=
X-Envelope-To: cgroups@vger.kernel.org
Received: from ctao-book.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id f3e3724dbd18898d;
	Mon, 24 Aug 2026 08:59:23 +0000
X-Mizu-Trace-ID: f3e3724dbd18898d
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Koutny <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH v4] selftests/cgroup: add PSI pressure trigger and validation tests
Date: Mon, 24 Aug 2026 16:59:13 +0800
Message-ID: <20260824085913.546741-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The cgroup selftests have no PSI coverage. Add test_psi.c: per-resource
trigger smoke tests (one trigger per fd, IRQ full-only), a
cgroup.pressure hide/show toggle test, and a CPU-pressure trigger test
using over-subscription. Skips when PSI is disabled or a resource is
absent.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes since v3 (Suren Baghdasaryan review):
- Convert to the kselftest harness: each case is a TEST_F(psi, ...)
  with the cgroup root/PSI availability checks in FIXTURE_SETUP() and
  the teardown (kill hogs, destroy cgroup) in FIXTURE_TEARDOWN(),
  which also removes the "ret"/"created" bookkeeping.
- A trigger that does not fire within the poll timeout is now a FAIL
  instead of a SKIP: ncpus+1 hogs with a 1usec threshold must stall,
  so a timeout indicates a real problem.
- Treat a poll() timeout and a poll() error uniformly via ASSERT.
- Check sysconf(_SC_NPROCESSORS_ONLN) only for -1 and report
  strerror(errno); declare variables one per line; for(;;) {}.
- Make hog_cpu() die with the runner via PR_SET_PDEATHSIG so an
  interrupted run does not leave orphaned hogs pinning every CPU.

Changes since v2 (Suren Baghdasaryan, Michal Koutny review):
- Restructure the trigger test into per-resource cases (io, memory, cpu,
  irq) so a failure points at the specific resource; irq is skipped when
  /proc/pressure/irq is absent.
- Spawn the CPU hogs with cg_run_nowait() instead of open-coding fork(),
  and arm the trigger with a 2s window so unprivileged users can set it.
- Address the remaining review comments on cleanup and robustness:
  guard teardown with a "created" flag, use cg_read_strcmp() instead of
  atoi(), report strerror() on errors, and fix the unused-parameter and
  sign-compare nits.

Changes since v1 (Michal Koutny, sashiko review):
- Keep trigger tests smoke-level; switch the firing test from memory to
  CPU pressure; drop churn_memory().
- Keep the runner out of the cgroup; add PSI/IRQ skip-guards and a
  .gitignore entry.

v1: https://lore.kernel.org/all/20260724025826.504586-1-cui.tao@linux.dev/
v2: https://lore.kernel.org/all/20260728083742.2359320-1-cui.tao@linux.dev/
v3: https://lore.kernel.org/all/20260813133723.1663605-1-cui.tao@linux.dev/
---
 tools/testing/selftests/cgroup/.gitignore |   1 +
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_psi.c | 206 ++++++++++++++++++++++
 4 files changed, 210 insertions(+)
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
index 000000000000..d5fab10f4fd4
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_psi.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/prctl.h>
+#include <linux/limits.h>
+
+#include "../kselftest_harness.h"
+#include "cgroup_util.h"
+
+#define PSI_POLL_TIMEOUT_MS	5000
+
+/* PSI triggers are written with a trailing NUL the kernel parser expects. */
+static ssize_t write_trigger(int fd, const char *trigger)
+{
+	return write(fd, trigger, strlen(trigger) + 1);
+}
+
+static int pressure_open(const char *resource)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
+	fd = open(path, O_RDWR);
+	if (fd < 0)
+		fprintf(stderr, "open %s: %s\n", path, strerror(errno));
+	return fd;
+}
+
+FIXTURE(psi)
+{
+	char root[PATH_MAX];
+	char *cg;
+};
+
+FIXTURE_SETUP(psi)
+{
+	int psi_fd;
+
+	self->cg = NULL;
+
+	if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
+		SKIP(return, "cgroup v2 isn't mounted");
+
+	/* PSI must be enabled (CONFIG_PSI=y, not disabled on the cmdline). */
+	psi_fd = open("/proc/pressure/memory", O_RDONLY);
+	if (psi_fd < 0)
+		SKIP(return, "PSI unavailable (CONFIG_PSI=n or psi=0)");
+	close(psi_fd);
+}
+
+FIXTURE_TEARDOWN(psi)
+{
+	if (self->cg) {
+		cg_killall(self->cg);
+		cg_destroy(self->cg);
+		free(self->cg);
+	}
+}
+
+/*
+ * /proc/pressure/<resource> accepts exactly one trigger per file
+ * descriptor. For io, memory and cpu verify that a "some" trigger arms
+ * and that a second trigger on the same fd is rejected with EBUSY.
+ */
+TEST_F(psi, proc_trigger_io)
+{
+	int fd;
+
+	fd = pressure_open("io");
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
+	ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd);
+}
+
+TEST_F(psi, proc_trigger_memory)
+{
+	int fd;
+
+	fd = pressure_open("memory");
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
+	ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd);
+}
+
+TEST_F(psi, proc_trigger_cpu)
+{
+	int fd;
+
+	fd = pressure_open("cpu");
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
+	ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd);
+}
+
+/*
+ * irq only tracks "full", so a "some" trigger must be rejected while a
+ * "full" trigger arms. irq is optional -- it only exists with IRQ-time
+ * accounting -- so a missing /proc/pressure/irq is SKIP, not FAIL.
+ */
+TEST_F(psi, proc_trigger_irq)
+{
+	int fd;
+
+	fd = pressure_open("irq");
+	if (fd < 0)
+		SKIP(return, "/proc/pressure/irq unavailable");
+
+	ASSERT_EQ(-1, write_trigger(fd, "some 150000 2000000"));
+	ASSERT_GT(write_trigger(fd, "full 150000 2000000"), 0);
+	close(fd);
+}
+
+/*
+ * cgroup.pressure gates visibility of the per-resource *.pressure files
+ * inside a cgroup: writing 0 hides them, writing 1 shows them again.
+ * Drive one hide/show cycle and check that memory.pressure appears and
+ * disappears along with it.
+ */
+TEST_F(psi, cgroup_pressure_toggle)
+{
+	char buf[BUF_SIZE];
+
+	self->cg = cg_name(self->root, "psi_toggle_test");
+	ASSERT_NE(NULL, self->cg);
+	ASSERT_EQ(0, cg_create(self->cg));
+
+	ASSERT_EQ(0, cg_write(self->cg, "cgroup.pressure", "0"));
+	ASSERT_EQ(0, cg_read_strcmp(self->cg, "cgroup.pressure", "0\n"));
+	ASSERT_LT(cg_read(self->cg, "memory.pressure", buf, sizeof(buf)), 0);
+
+	ASSERT_EQ(0, cg_write(self->cg, "cgroup.pressure", "1"));
+	ASSERT_EQ(0, cg_read_strcmp(self->cg, "cgroup.pressure", "1\n"));
+	ASSERT_GE(cg_read(self->cg, "memory.pressure", buf, sizeof(buf)), 0);
+}
+
+/*
+ * A child that burns CPU forever; stopped by cg_killall() on teardown.
+ * It also dies with the runner, so an interrupted run (e.g. Ctrl-C
+ * during poll()) does not leave orphaned hogs pinning every CPU.
+ */
+static int hog_cpu(const char *cgroup, void *arg)
+{
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	for (;;) {}
+	return 0;
+}
+
+/*
+ * Arm a "some" trigger on a cgroup's cpu.pressure, oversubscribe the
+ * cgroup with more spinning hogs than there are CPUs, and check that the
+ * trigger fires once the cgroup stalls on CPU.
+ */
+TEST_F(psi, cgroup_trigger_fire)
+{
+	char *cpupress;
+	struct pollfd pfd = { .events = POLLPRI };
+	long ncpus;
+	int fd;
+	int i;
+
+	self->cg = cg_name(self->root, "psi_trigger_test");
+	ASSERT_NE(NULL, self->cg);
+	ASSERT_EQ(0, cg_create(self->cg));
+
+	cpupress = cg_control(self->cg, "cpu.pressure");
+	ASSERT_NE(NULL, cpupress);
+	fd = open(cpupress, O_RDWR);
+	free(cpupress);
+	ASSERT_GE(fd, 0);
+	pfd.fd = fd;
+
+	/*
+	 * 1usec threshold over a 2s window: any CPU stall fires it. The 2s
+	 * window is the smallest unprivileged users are allowed to arm.
+	 */
+	ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (ncpus == -1)
+		TH_LOG("sysconf(_SC_NPROCESSORS_ONLN): %s", strerror(errno));
+	ASSERT_NE(-1, ncpus);
+
+	/* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
+	for (i = 0; i < ncpus + 1; i++)
+		ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
+
+	ASSERT_EQ(1, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
+	ASSERT_NE(0, pfd.revents & POLLPRI);
+	close(fd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.43.0

