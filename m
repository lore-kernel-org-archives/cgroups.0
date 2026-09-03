Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40430447811
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 07:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788420951; cv=none; b=e61Izsw7rfQrhbOVYPFV6U+/IJthNXjRxOlCKOWh47t7gb4XPrU7GqD+O8oqsXzXWIV6YQk5l1fG9HkCV+UKB7ONm5hvDdVkQtFUeB6u/841+YzOpgCO9TkmD27skPJy+9MREyAuB5RsHXfqyVV+22UyqKeFDpCrQUobld45z1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788420951; c=relaxed/simple;
	bh=u3Ile/OYKX4kP8lluygtrG5IPVka1AQyFIVtj+OD9x8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JIVID+EeP2ol6iGaiXxrLocYb/1c0eaAIUuZjjKA1J6yNxRYqoXxDB4dKsNCIO8DDXaCyRuCgBJwbLmAIgekuk7leOBg33YSNooLSDcmW0AKkoNhuVp0YNKyz+j+5dq6MSgaAJfGRwACPIV7hssXSv8Y6OeOz6kj2K7Thw0/2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ovesXsCq; arc=none smtp.client-ip=95.215.58.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ovesXsCq"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u3Ile/OYKX4kP8lluygtrG5IPVka1AQyFIVtj+OD9x8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788420947; v=1; x=1789025747;
 b=ovesXsCqkLcdfQMmUvpejbKdqCAd0Zf9jCBF51XbiDpQeM1GUBfMojj7EC4wUjKP8GjQ15hv
 VZbQ9YgHlpKPQ5gskoZFar8h3iR/w4nMVlIoMoLC6ioTU9dmuFRNAC+mMyQfWOwRZrkvTVhXHxM
 T4jR+O1WMHVxQged8Yzr9khk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 14c2f6911cc44582;
	Thu, 03 Sep 2026 07:35:37 +0000
X-Mizu-Trace-ID: 14c2f6911cc44582
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: Michal Koutny <mkoutny@suse.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>,
	Tao Cui <cuitao@kylinos.cn>,
	cui.tao@linux.dev
Subject: [PATCH v6] selftests/cgroup: add PSI pressure trigger and validation tests
Date: Thu,  3 Sep 2026 15:35:23 +0800
Message-ID: <20260903073523.1055584-1-cui.tao@linux.dev>
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
cgroup.pressure hide/show toggle test, and two CPU-pressure trigger
tests using over-subscription: one expects the trigger to fire at a
tiny threshold, the other expects it not to fire at a whole-window
threshold. Skips when PSI is disabled or a resource is absent.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes since v5 (Michal Koutny review):
- Terminate trigger writes with a newline instead of a NUL. The parser
  (psi_write()) overwrites the last byte of the write with a NUL, so a
  plain strlen()-sized write silently truncates the last digit for
  privileged users (e.g. a 2000000us window becomes 200000us) and
  fails with EINVAL for unprivileged ones. The newline keeps the
  payload intact and drops the reliance on the undocumented NUL
  convention.
- Keep pressure_open() silent: the SKIP message already reports why a
  resource is unavailable and strace accompanies these tests anyway.
  This replaces the ksft_perror() added on review of v4, which
  duplicated the SKIP reason.
- Treat a test cgroup creation failure in FIXTURE_SETUP() as a failure
  instead of a SKIP.
- Drop the unprivileged-minimum remark from the fire test comment and
  the duplicate sysconf() error report.
- Add cgroup_trigger_no_fire, the false-trigger side of the firing
  test: with the threshold equal to the whole window, ncpus+1 hogs must
  not fire it. Under this oversubscription the measured cpu.pressure
  "some" stays in the 2-17% range on 2- and 16-CPU machines, so the
  margin is comfortable.

Changes since v4 (Suren Baghdasaryan review):
- Report pressure_open() errors with ksft_perror() instead of a raw
  fprintf.
- Create the test cgroup in FIXTURE_SETUP() so that setup and teardown
  are symmetric, and drop the per-test creation and the NULL guard in
  the teardown.
- Factor the identical bodies of proc_trigger_io/memory/cpu into
  test_psi_write(); the helper takes _metadata so that its ASSERTs
  attribute to the calling test, following the seccomp selftests
  precedent.
- Drop the now-unneeded NULL init of self->cg and the stale stdbool.h
  include left over from the restructuring.

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
v4: https://lore.kernel.org/all/20260824085913.546741-1-cui.tao@linux.dev/
v5: https://lore.kernel.org/all/20260902040725.877155-1-cui.tao@linux.dev/
---
 tools/testing/selftests/cgroup/.gitignore |   1 +
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_psi.c | 219 ++++++++++++++++++++++
 4 files changed, 223 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_psi.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf070..ce2b907c57ea3 100644
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
index e01584c2189ac..a8c69e37332a4 100644
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
index 39f979690dd3b..8a3ef479e83d3 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,4 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_PSI=y
diff --git a/tools/testing/selftests/cgroup/test_psi.c b/tools/testing/selftests/cgroup/test_psi.c
new file mode 100644
index 0000000000000..95dcb8a9f1843
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_psi.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
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
+/*
+ * The kernel parser overwrites the last byte of a trigger write with a
+ * NUL, so terminate with a newline to keep the payload intact.
+ */
+static ssize_t write_trigger(int fd, const char *trigger)
+{
+	char buf[64];
+
+	snprintf(buf, sizeof(buf), "%s\n", trigger);
+
+	return write(fd, buf, strlen(buf));
+}
+
+static int pressure_open(const char *resource)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/proc/pressure/%s", resource);
+	return open(path, O_RDWR);
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
+	if (cg_find_unified_root(self->root, sizeof(self->root), NULL))
+		SKIP(return, "cgroup v2 isn't mounted");
+
+	/* PSI must be enabled (CONFIG_PSI=y, not disabled on the cmdline). */
+	psi_fd = open("/proc/pressure/memory", O_RDONLY);
+	if (psi_fd < 0)
+		SKIP(return, "PSI unavailable (CONFIG_PSI=n or psi=0)");
+	close(psi_fd);
+
+	self->cg = cg_name(self->root, "psi_trigger_test");
+	ASSERT_NE(NULL, self->cg);
+	ASSERT_EQ(0, cg_create(self->cg));
+}
+
+FIXTURE_TEARDOWN(psi)
+{
+	cg_killall(self->cg);
+	cg_destroy(self->cg);
+	free(self->cg);
+}
+
+/*
+ * /proc/pressure/<resource> accepts exactly one trigger per file
+ * descriptor. Verify that a "some" trigger arms and that a second
+ * trigger on the same fd is rejected with EBUSY.
+ */
+static void test_psi_write(struct __test_metadata *_metadata,
+			   const char *filename)
+{
+	int fd;
+
+	fd = pressure_open(filename);
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(write_trigger(fd, "some 150000 2000000"), 0);
+	ASSERT_EQ(-1, write_trigger(fd, "full 150000 2000000"));
+	ASSERT_EQ(EBUSY, errno);
+	close(fd);
+}
+
+TEST_F(psi, proc_trigger_io)
+{
+	test_psi_write(_metadata, "io");
+}
+
+TEST_F(psi, proc_trigger_memory)
+{
+	test_psi_write(_metadata, "memory");
+}
+
+TEST_F(psi, proc_trigger_cpu)
+{
+	test_psi_write(_metadata, "cpu");
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
+	cpupress = cg_control(self->cg, "cpu.pressure");
+	ASSERT_NE(NULL, cpupress);
+	fd = open(cpupress, O_RDWR);
+	free(cpupress);
+	ASSERT_GE(fd, 0);
+	pfd.fd = fd;
+
+	/* 1usec threshold over a 2s window: any CPU stall fires it. */
+	ASSERT_GT(write_trigger(fd, "some 1 2000000"), 0);
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
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
+/*
+ * The flip side of cgroup_trigger_fire: with the threshold equal to the
+ * whole window, even ncpus+1 hogs must not accumulate enough stall to
+ * fire the trigger.
+ */
+TEST_F(psi, cgroup_trigger_no_fire)
+{
+	char *cpupress;
+	struct pollfd pfd = { .events = POLLPRI };
+	long ncpus;
+	int fd;
+	int i;
+
+	cpupress = cg_control(self->cg, "cpu.pressure");
+	ASSERT_NE(NULL, cpupress);
+	fd = open(cpupress, O_RDWR);
+	free(cpupress);
+	ASSERT_GE(fd, 0);
+	pfd.fd = fd;
+
+	ASSERT_GT(write_trigger(fd, "some 2000000 2000000"), 0);
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+	ASSERT_NE(-1, ncpus);
+
+	for (i = 0; i < ncpus + 1; i++)
+		ASSERT_GE(cg_run_nowait(self->cg, hog_cpu, NULL), 0);
+
+	ASSERT_EQ(0, poll(&pfd, 1, PSI_POLL_TIMEOUT_MS));
+	close(fd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.43.0

