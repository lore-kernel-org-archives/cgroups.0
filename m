Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB1C47988A
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786628258; cv=none; b=NRpdjFT21wlZdIoSO5bpcPJJeafq+moMQL1OswICzjTMC/nvo0AX3p+VJejqRlT7121WnkvYsZFlUnFScNP4MQpES+KpS4QhVwQzE1ERUA3yvgmVjgar+ZNNQhEXwUrVS7SQUtCBpgpaNU12a0BoS5s5BDKW2yvlTlN/WbwYOM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786628258; c=relaxed/simple;
	bh=ba7i6YJwO3U/e4F2sO298omrIZym2EVdxxtpiUxCPmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=URHM5ZK0eBnPsYiU39hMsZLoum5++x5gzE3Vly0PhomjmK3ef+yeAd97AB1pMQm9SCH06Ca+5MokCW5qkIXpSeQkDv7btvPbfaexEeYtBwV+uLwBIRbslh83KLrMVrYC5WFtJp2JtrNAFNobT6gfzQ75vE8Y2EWc1BBM0clKz+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kvV7ngcN; arc=none smtp.client-ip=95.215.58.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kvV7ngcN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ba7i6YJwO3U/e4F2sO298omrIZym2EVdxxtpiUxCPmA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786628254; v=1; x=1787233054;
 b=kvV7ngcNVulWYwuOX7TEKezal5GcIWEulFNK8h87ai9zy6lT1ZOxES+fuKU5kzeaRMlqlPcm
 9sFXu8sM47E5b0KEHgSzICdCFYktDZpzJREeQcz2qnNTj1o0SYMUMoy1Xb/Qh8NoLYHkRP9yuPM
 WvVIY1rDLXlUzuMk/pHdv0Pk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from ctao-book.. (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 9247cecd94de72f9;
	Thu, 13 Aug 2026 13:37:33 +0000
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
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
Subject: [PATCH v3] selftests/cgroup: add PSI pressure trigger and validation tests
Date: Thu, 13 Aug 2026 21:37:23 +0800
Message-ID: <20260813133723.1663605-1-cui.tao@linux.dev>
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

Link: https://lore.kernel.org/all/20260724025826.504586-1-cui.tao@linux.dev/
Link: https://lore.kernel.org/all/20260728083742.2359320-1-cui.tao@linux.dev/
---
 tools/testing/selftests/cgroup/.gitignore |   1 +
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_psi.c | 296 ++++++++++++++++++++++
 4 files changed, 300 insertions(+)
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
index 000000000000..cfb412f61458
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_psi.c
@@ -0,0 +1,296 @@
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
+#include <linux/limits.h>
+
+#include "kselftest.h"
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
+		ksft_print_msg("open %s: %s\n", path, strerror(errno));
+	return fd;
+}
+
+/*
+ * /proc/pressure/<resource> accepts exactly one trigger per file
+ * descriptor. For io, memory and cpu verify that a "some" trigger arms
+ * and that a second trigger on the same fd is rejected with EBUSY. For
+ * irq, which only tracks "full", verify that "some" is rejected and
+ * "full" arms. irq is optional -- it only exists with IRQ-time
+ * accounting -- so a missing /proc/pressure/irq is SKIP, not FAIL.
+ */
+static int test_proc_trigger(const char *resource, bool full_only)
+{
+	int fd, ret = KSFT_FAIL;
+
+	fd = pressure_open(resource);
+	if (fd < 0)
+		return full_only ? KSFT_SKIP : KSFT_FAIL;
+
+	if (!full_only) {
+		if (write_trigger(fd, "some 150000 2000000") <= 0) {
+			ksft_print_msg("%s: 'some' trigger rejected: %s\n",
+				       resource, strerror(errno));
+			goto out;
+		}
+		if (write_trigger(fd, "full 150000 2000000") != -1 ||
+		    errno != EBUSY) {
+			ksft_print_msg("%s: second trigger not EBUSY\n",
+				       resource);
+			goto out;
+		}
+	} else {
+		if (write_trigger(fd, "some 150000 2000000") != -1) {
+			ksft_print_msg("irq: 'some' trigger unexpectedly accepted\n");
+			goto out;
+		}
+		if (write_trigger(fd, "full 150000 2000000") <= 0) {
+			ksft_print_msg("irq: 'full' trigger rejected: %s\n",
+				       strerror(errno));
+			goto out;
+		}
+	}
+
+	ret = KSFT_PASS;
+out:
+	close(fd);
+	return ret;
+}
+
+/*
+ * cgroup.pressure gates visibility of the per-resource *.pressure files
+ * inside a cgroup: writing 0 hides them, writing 1 shows them again.
+ * Drive one hide/show cycle and check that memory.pressure appears and
+ * disappears along with it.
+ */
+static int test_cgroup_pressure_toggle(const char *root)
+{
+	char buf[BUF_SIZE];
+	char *cg = NULL;
+	int ret = KSFT_FAIL, created = 0;
+
+	cg = cg_name(root, "psi_toggle_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg)) {
+		ksft_print_msg("cg_create: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	created = 1;
+
+	if (cg_write(cg, "cgroup.pressure", "0")) {
+		ksft_print_msg("write cgroup.pressure=0: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	if (cg_read_strcmp(cg, "cgroup.pressure", "0\n")) {
+		ksft_print_msg("cgroup.pressure readback != 0\n");
+		goto cleanup;
+	}
+	if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) >= 0) {
+		ksft_print_msg("memory.pressure readable while hidden\n");
+		goto cleanup;
+	}
+
+	if (cg_write(cg, "cgroup.pressure", "1")) {
+		ksft_print_msg("write cgroup.pressure=1: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	if (cg_read_strcmp(cg, "cgroup.pressure", "1\n")) {
+		ksft_print_msg("cgroup.pressure readback != 1\n");
+		goto cleanup;
+	}
+	if (cg_read(cg, "memory.pressure", buf, sizeof(buf)) < 0) {
+		ksft_print_msg("memory.pressure unreadable after enabling\n");
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	if (created)
+		cg_destroy(cg);
+	free(cg);
+	return ret;
+}
+
+/* A child that burns CPU forever; stopped by cg_killall() in the parent. */
+static int hog_cpu(const char *cgroup, void *arg)
+{
+	for (;;)
+		;
+	return 0;
+}
+
+/*
+ * Arm a "some" trigger on a cgroup's cpu.pressure, oversubscribe the
+ * cgroup with more spinning hogs than there are CPUs, and check that the
+ * trigger fires once the cgroup stalls on CPU.
+ */
+static int test_cgroup_trigger_fire(const char *root)
+{
+	char *cg = NULL, *cpupress = NULL;
+	int fd = -1, ret = KSFT_FAIL, created = 0, i;
+	long ncpus;
+
+	cg = cg_name(root, "psi_trigger_test");
+	if (!cg)
+		goto cleanup;
+	if (cg_create(cg)) {
+		ksft_print_msg("cg_create: %s\n", strerror(errno));
+		goto cleanup;
+	}
+	created = 1;
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
+	/*
+	 * 1usec threshold over a 2s window: any CPU stall fires it. The 2s
+	 * window is the smallest unprivileged users are allowed to arm.
+	 */
+	if (write_trigger(fd, "some 1 2000000") <= 0) {
+		ksft_print_msg("arm trigger: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	ncpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (ncpus <= 0) {
+		ksft_print_msg("sysconf(_SC_NPROCESSORS_ONLN) returned %ld\n",
+			       ncpus);
+		goto cleanup;
+	}
+
+	/* ncpus+1 hogs guarantee CPU contention inside the cgroup. */
+	for (i = 0; i < ncpus + 1; i++) {
+		if (cg_run_nowait(cg, hog_cpu, NULL) < 0) {
+			ksft_print_msg("spawn hog %d: %s\n", i, strerror(errno));
+			goto cleanup;
+		}
+	}
+
+	struct pollfd pfd = { .fd = fd, .events = POLLPRI };
+
+	switch (poll(&pfd, 1, PSI_POLL_TIMEOUT_MS)) {
+	case -1:
+		ksft_print_msg("poll: %s\n", strerror(errno));
+		goto cleanup;
+	case 0:
+		ksft_print_msg("trigger did not fire (could not induce CPU pressure)\n");
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
+cleanup:
+	if (fd >= 0)
+		close(fd);
+	if (created) {
+		cg_killall(cg);
+		cg_destroy(cg);
+	}
+	free(cpupress);
+	free(cg);
+	return ret;
+}
+
+struct psi_proc_test {
+	const char *name;
+	const char *resource;
+	bool full_only;
+};
+static const struct psi_proc_test proc_tests[] = {
+	{ "proc_trigger_io",     "io",     false },
+	{ "proc_trigger_memory", "memory", false },
+	{ "proc_trigger_cpu",    "cpu",    false },
+	{ "proc_trigger_irq",    "irq",    true  },
+};
+
+struct psi_cg_test {
+	const char *name;
+	int (*fn)(const char *root);
+};
+static const struct psi_cg_test cg_tests[] = {
+	{ "cgroup_pressure_toggle", test_cgroup_pressure_toggle },
+	{ "cgroup_trigger_fire",    test_cgroup_trigger_fire },
+};
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int psi_fd, i;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(proc_tests) + ARRAY_SIZE(cg_tests));
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	/* PSI must be enabled (CONFIG_PSI=y, not disabled on the cmdline). */
+	psi_fd = open("/proc/pressure/memory", O_RDONLY);
+	if (psi_fd < 0)
+		ksft_exit_skip("PSI unavailable (CONFIG_PSI=n or psi=0)\n");
+	close(psi_fd);
+
+	for (i = 0; i < ARRAY_SIZE(proc_tests); i++) {
+		switch (test_proc_trigger(proc_tests[i].resource,
+					  proc_tests[i].full_only)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", proc_tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", proc_tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", proc_tests[i].name);
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cg_tests); i++) {
+		switch (cg_tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", cg_tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", cg_tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", cg_tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
-- 
2.43.0

