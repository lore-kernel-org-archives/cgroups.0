From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v3 6/7] kselftests: cgroup: add freezer controller self-tests
Date: Fri, 16 Nov 2018 16:38:29 -0800
Message-ID: <20181117003830.15344-7-guro@fb.com>
References: <20181117003830.15344-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JbKQRq9isEIEZmWTbZXWEorHLrqr9rgVjBExbftdsfw=;
        b=VDbTbbqoCsFIu+U1N11pBo+oZR1cBkLoY7tf5ab8tvcCAM6SGHTbE9tv0ZSeVTdpIW
         3f0O1xqtuj5UJwxUvbpIJPN0ggvJYU24bTk0hkXajHSEv/bPuhafEo4aXRK2QfzvmN0o
         oUdLzDiH21wpJsDw/tT1MkV31kX1YkMRSZP1xiW695ssMLjk69Fj2g6srMfZXo26Dygw
         R3i4PsCp9cQkm/n/0NhASuIvCSANK7mmQvipiOp1CrVLPLvqgYRgPVJizSzINj2/8tsc
         HNwcADWI36Vw7fPUzTrhV3bg4H3U5hrdPpNnFl/nzGax5wmZeDqY4+mGE0rtqP6wMdHG
         Ss+A==
In-Reply-To: <20181117003830.15344-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org

This patch implements six tests for the freezer controller for
cgroup v2:
1) a simple test, which aims to freeze and unfreeze a cgroup with 100
processes
2) a more complicated tree test, which creates a hierarchy of cgroups,
puts some processes in some cgroups, and tries to freeze and unfreeze
different parts of the subtree
3) a forkbomb test: the test aims to freeze a forkbomb running in a
cgroup, kill all tasks in the cgroup and remove the cgroup without
the unfreezing.
4) rmdir test: the test creates two nested cgroups, freezes the parent
one, checks that the child can be successfully removed, and a new
child can be created
5) migration tests: the test checks migration of a task between
frozen cgroups: from a frozen to a running, from a running to a
frozen, and from a frozen to a frozen.
6) ptrace test: the test checks that it's possible to attach to
a process in a frozen cgroup, get some information and detach, and
the cgroup will remain frozen.

Expected output:

  $ ./test_freezer
  ok 1 test_cgfreezer_simple
  ok 2 test_cgfreezer_tree
  ok 3 test_cgfreezer_forkbomb
  ok 4 test_cgrreezer_rmdir
  ok 5 test_cgfreezer_migrate
  ok 6 test_cgfreezer_ptrace

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-kselftest@vger.kernel.org
---
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  81 ++-
 tools/testing/selftests/cgroup/cgroup_util.h  |   7 +
 tools/testing/selftests/cgroup/test_freezer.c | 685 ++++++++++++++++++
 5 files changed, 775 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index adacda50a4b2..7f9835624793 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -1,2 +1,3 @@
 test_memcontrol
 test_core
+test_freezer
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index 23fbaa4a9630..8d369b6a2069 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -5,8 +5,10 @@ all:
 
 TEST_GEN_PROGS = test_memcontrol
 TEST_GEN_PROGS += test_core
+TEST_GEN_PROGS += test_freezer
 
 include ../lib.mk
 
 $(OUTPUT)/test_memcontrol: cgroup_util.c
 $(OUTPUT)/test_core: cgroup_util.c
+$(OUTPUT)/test_freezer: cgroup_util.c
diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index eba06f94433b..e9cdad673901 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -74,6 +74,16 @@ char *cg_name_indexed(const char *root, const char *name, int index)
 	return ret;
 }
 
+char *cg_control(const char *cgroup, const char *control)
+{
+	size_t len = strlen(cgroup) + strlen(control) + 2;
+	char *ret = malloc(len);
+
+	snprintf(ret, len, "%s/%s", cgroup, control);
+
+	return ret;
+}
+
 int cg_read(const char *cgroup, const char *control, char *buf, size_t len)
 {
 	char path[PATH_MAX];
@@ -196,7 +206,59 @@ int cg_create(const char *cgroup)
 	return mkdir(cgroup, 0644);
 }
 
-static int cg_killall(const char *cgroup)
+int cg_for_all_procs(const char *cgroup, int (*fn)(int pid, void *arg),
+		     void *arg)
+{
+	char buf[PAGE_SIZE];
+	char *ptr = buf;
+	int ret;
+
+	if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
+		return -1;
+
+	while (ptr < buf + sizeof(buf)) {
+		int pid = strtol(ptr, &ptr, 10);
+
+		if (pid == 0)
+			break;
+		if (*ptr)
+			ptr++;
+		else
+			break;
+		ret = fn(pid, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int cg_wait_for_proc_count(const char *cgroup, int count)
+{
+	char buf[10 * PAGE_SIZE] = {0};
+	int attempts;
+	char *ptr;
+
+	for (attempts = 10; attempts >= 0; attempts--) {
+		int nr = 0;
+
+		if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
+			break;
+
+		for (ptr = buf; *ptr; ptr++)
+			if (*ptr == '\n')
+				nr++;
+
+		if (nr >= count)
+			return 0;
+
+		usleep(100000);
+	}
+
+	return -1;
+}
+
+int cg_killall(const char *cgroup)
 {
 	char buf[PAGE_SIZE];
 	char *ptr = buf;
@@ -238,6 +300,14 @@ int cg_destroy(const char *cgroup)
 	return ret;
 }
 
+int cg_enter(const char *cgroup, int pid)
+{
+	char pidbuf[64];
+
+	snprintf(pidbuf, sizeof(pidbuf), "%d", pid);
+	return cg_write(cgroup, "cgroup.procs", pidbuf);
+}
+
 int cg_enter_current(const char *cgroup)
 {
 	char pidbuf[64];
@@ -367,3 +437,12 @@ int set_oom_adj_score(int pid, int score)
 	close(fd);
 	return 0;
 }
+
+char proc_read_text(int pid, const char *item, char *buf, size_t size)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
+
+	return read_text(path, buf, size);
+}
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index 9ac8b7958f83..8ee63c00a668 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -18,6 +18,7 @@ static inline int values_close(long a, long b, int err)
 extern int cg_find_unified_root(char *root, size_t len);
 extern char *cg_name(const char *root, const char *name);
 extern char *cg_name_indexed(const char *root, const char *name, int index);
+extern char *cg_control(const char *cgroup, const char *control);
 extern int cg_create(const char *cgroup);
 extern int cg_destroy(const char *cgroup);
 extern int cg_read(const char *cgroup, const char *control,
@@ -32,6 +33,7 @@ extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_run(const char *cgroup,
 		  int (*fn)(const char *cgroup, void *arg),
 		  void *arg);
+extern int cg_enter(const char *cgroup, int pid);
 extern int cg_enter_current(const char *cgroup);
 extern int cg_run_nowait(const char *cgroup,
 			 int (*fn)(const char *cgroup, void *arg),
@@ -41,3 +43,8 @@ extern int alloc_pagecache(int fd, size_t size);
 extern int alloc_anon(const char *cgroup, void *arg);
 extern int is_swap_enabled(void);
 extern int set_oom_adj_score(int pid, int score);
+extern int cg_for_all_procs(const char *cgroup, int (*fn)(int pid, void *arg),
+			    void *arg);
+extern int cg_wait_for_proc_count(const char *cgroup, int count);
+extern int cg_killall(const char *cgroup);
+extern char proc_read_text(int pid, const char *item, char *buf, size_t size);
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
new file mode 100644
index 000000000000..0c4106658360
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -0,0 +1,685 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <stdbool.h>
+#include <linux/limits.h>
+#include <sys/ptrace.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <poll.h>
+#include <stdlib.h>
+#include <sys/inotify.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+#define DEBUG
+#ifdef DEBUG
+#define debug(args...) fprintf(stderr, args)
+#else
+#define debug(args...)
+#endif
+
+/*
+ * Freeze the given cgroup and wait for the inotify signal.
+ * If there is no signal in 10 seconds, treat this as an error.
+ */
+static int cg_freeze_wait(const char *cgroup, bool freeze)
+{
+	int fd, wd;
+	struct pollfd fds;
+	int ret = -1;
+
+	fd = inotify_init1(IN_NONBLOCK);
+	if (fd == -1)
+		return fd;
+
+	wd = inotify_add_watch(fd, cg_control(cgroup, "cgroup.events"),
+			       IN_MODIFY);
+	if (wd == -1) {
+		close(fd);
+		return wd;
+	}
+	fds.fd = fd;
+	fds.events = POLLIN;
+
+	ret = cg_write(cgroup, "cgroup.freeze", freeze ? "1" : "0");
+	if (ret) {
+		close(fd);
+		return ret;
+	}
+
+	while (true) {
+		wd = poll(&fds, 1, 10000);
+
+		if (wd == -1 && errno == EINTR)
+			continue;
+
+		if (wd == 1 && fds.revents & POLLIN)
+			ret = 0;
+
+		break;
+	}
+
+	close(fd);
+
+	return ret;
+}
+
+/*
+ * Check if the process is frozen and parked in a proper place.
+ */
+static int proc_check_frozen(int pid, void *arg)
+{
+	char buf[PAGE_SIZE];
+	int len;
+
+	len = proc_read_text(pid, "stat", buf, sizeof(buf));
+	if (len == -1) {
+		debug("Can't get %d stat\n", pid);
+		return -1;
+	}
+
+	if (strstr(buf, "(test_freezer) S ") == NULL) {
+		debug("Process %d in the unexpected state: %s\n", pid, buf);
+		return -1;
+	}
+
+	len = proc_read_text(pid, "stack", buf, sizeof(buf));
+	if (len == -1) {
+		debug("Can't get stack of the process %d\n", pid);
+		return -1;
+	}
+
+	if (strstr(buf, "[<0>] cgroup_enter_frozen") != buf) {
+		debug("Process %d has unexpected stacktrace: %s\n", pid, buf);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Check if the cgroup is frozen and all belonging processes are
+ * parked in a proper place.
+ */
+static int cg_check_frozen(const char *cgroup, bool frozen)
+{
+	if (frozen) {
+		/*
+		 * Check the cgroup.events::frozen value.
+		 */
+		if (cg_read_strstr(cgroup, "cgroup.events", "frozen 1") != 0) {
+			debug("Cgroup %s isn't unexpectedly frozen\n", cgroup);
+			return -1;
+		}
+
+		/*
+		 * Check that all processes are parked in the proper place.
+		 */
+		if (cg_for_all_procs(cgroup, proc_check_frozen, NULL)) {
+			debug("Some processes of cgroup %s are not frozen\n",
+			      cgroup);
+			return -1;
+		}
+	} else {
+		/*
+		 * Check the cgroup.events::frozen value.
+		 */
+		if (cg_read_strstr(cgroup, "cgroup.events", "frozen 0") != 0) {
+			debug("Cgroup %s is unexpectedly frozen\n", cgroup);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * A simple process running in a sleep loop until being
+ * re-parented.
+ */
+static int child_fn(const char *cgroup, void *arg)
+{
+	int ppid = getppid();
+
+	while (getppid() == ppid)
+		usleep(1000);
+
+	return getppid() == ppid;
+}
+
+/*
+ * A simple test for the cgroup freezer: populated the cgroup with 100
+ * running processes and freeze it. Then unfreeze it. Then it kills all
+ * processes and destroys the cgroup.
+ */
+static int test_cgfreezer_simple(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cgroup = NULL;
+	int i;
+
+	cgroup = cg_name(root, "cg_test");
+	if (!cgroup)
+		goto cleanup;
+
+	if (cg_create(cgroup))
+		goto cleanup;
+
+	for (i = 0; i < 100; i++)
+		cg_run_nowait(cgroup, child_fn, NULL);
+
+	if (cg_wait_for_proc_count(cgroup, 100))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup, false))
+		goto cleanup;
+
+	if (cg_freeze_wait(cgroup, true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup, true))
+		goto cleanup;
+
+	if (cg_freeze_wait(cgroup, false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup, false))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(cgroup);
+	return ret;
+}
+
+/*
+ * The test creates the following hierarchy:
+ *       A
+ *    / / \ \
+ *   B  E  I K
+ *  /\  |
+ * C  D F
+ *      |
+ *      G
+ *      |
+ *      H
+ *
+ * with a process in C, H and 3 processes in K.
+ * Then it tries to freeze and unfreeze the whole tree.
+ */
+static int test_cgfreezer_tree(const char *root)
+{
+	char *cgroup[10] = {0};
+	int ret = KSFT_FAIL;
+	int i;
+
+	cgroup[0] = cg_name(root, "cg_test_A");
+	if (!cgroup[0])
+		goto cleanup;
+
+	cgroup[1] = cg_name(cgroup[0], "cg_test_B");
+	if (!cgroup[1])
+		goto cleanup;
+
+	cgroup[2] = cg_name(cgroup[1], "cg_test_C");
+	if (!cgroup[2])
+		goto cleanup;
+
+	cgroup[3] = cg_name(cgroup[1], "cg_test_D");
+	if (!cgroup[3])
+		goto cleanup;
+
+	cgroup[4] = cg_name(cgroup[0], "cg_test_E");
+	if (!cgroup[4])
+		goto cleanup;
+
+	cgroup[5] = cg_name(cgroup[4], "cg_test_F");
+	if (!cgroup[5])
+		goto cleanup;
+
+	cgroup[6] = cg_name(cgroup[5], "cg_test_G");
+	if (!cgroup[6])
+		goto cleanup;
+
+	cgroup[7] = cg_name(cgroup[6], "cg_test_H");
+	if (!cgroup[7])
+		goto cleanup;
+
+	cgroup[8] = cg_name(cgroup[0], "cg_test_I");
+	if (!cgroup[8])
+		goto cleanup;
+
+	cgroup[9] = cg_name(cgroup[0], "cg_test_K");
+	if (!cgroup[9])
+		goto cleanup;
+
+	for (i = 0; i < 10; i++)
+		if (cg_create(cgroup[i]))
+			goto cleanup;
+
+	cg_run_nowait(cgroup[2], child_fn, NULL);
+	cg_run_nowait(cgroup[7], child_fn, NULL);
+	cg_run_nowait(cgroup[9], child_fn, NULL);
+	cg_run_nowait(cgroup[9], child_fn, NULL);
+	cg_run_nowait(cgroup[9], child_fn, NULL);
+
+	/*
+	 * Wait until all child processes will enter
+	 * corresponding cgroups.
+	 */
+
+	if (cg_wait_for_proc_count(cgroup[2], 1) ||
+	    cg_wait_for_proc_count(cgroup[7], 1) ||
+	    cg_wait_for_proc_count(cgroup[9], 3))
+		goto cleanup;
+
+	/*
+	 * Freeze B.
+	 */
+	if (cg_freeze_wait(cgroup[1], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	/*
+	 * Freeze F.
+	 */
+	if (cg_freeze_wait(cgroup[5], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[5], true))
+		goto cleanup;
+
+	/*
+	 * Freeze G.
+	 */
+	if (cg_freeze_wait(cgroup[6], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[6], true))
+		goto cleanup;
+
+	/*
+	 * Check that A and E are not frozen.
+	 */
+	if (cg_check_frozen(cgroup[0], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[4], false))
+		goto cleanup;
+
+	/*
+	 * Freeze A. Check that A, B and E are frozen.
+	 */
+	if (cg_freeze_wait(cgroup[0], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[4], true))
+		goto cleanup;
+
+	/*
+	 * Unfreeze B, F and G
+	 */
+	if (cg_freeze_wait(cgroup[1], false))
+		goto cleanup;
+
+	if (cg_freeze_wait(cgroup[5], false))
+		goto cleanup;
+
+	if (cg_freeze_wait(cgroup[6], false))
+		goto cleanup;
+
+	/*
+	 * Check that C and H are still frozen.
+	 */
+	if (cg_check_frozen(cgroup[2], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[7], true))
+		goto cleanup;
+
+	/*
+	 * Unfreezing A failed. Check that A, C and K are not frozen.
+	 */
+	if (cg_freeze_wait(cgroup[0], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[2], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[9], false))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	for (i = 9; i >= 0 && cgroup[i]; i--) {
+		cg_destroy(cgroup[i]);
+		free(cgroup[i]);
+	}
+
+	return ret;
+}
+
+/*
+ * A fork bomb emulator.
+ */
+static int forkbomb_fn(const char *cgroup, void *arg)
+{
+	int ppid;
+
+	fork();
+	fork();
+
+	ppid = getppid();
+
+	while (getppid() == ppid)
+		usleep(1000);
+
+	return getppid() == ppid;
+}
+
+/*
+ * The test runs a fork bomb in a cgroup and tries to freeze it.
+ * Then it kills all processes and checks that cgroup isn't populated
+ * anymore.
+ */
+static int test_cgfreezer_forkbomb(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cgroup = NULL;
+
+	cgroup = cg_name(root, "cg_forkbomb_test");
+	if (!cgroup)
+		goto cleanup;
+
+	if (cg_create(cgroup))
+		goto cleanup;
+
+	cg_run_nowait(cgroup, forkbomb_fn, NULL);
+
+	usleep(100000);
+
+	if (cg_freeze_wait(cgroup, true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup, true))
+		goto cleanup;
+
+	if (cg_killall(cgroup))
+		goto cleanup;
+
+	if (cg_wait_for_proc_count(cgroup, 0))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(cgroup);
+	return ret;
+}
+
+/*
+ * The test creates two nested cgroups, freezes the parent
+ * and removes the child. Then it checks that the parent cgroup
+ * remains frozen and it's possible to create a new child
+ * without unfreezing. The new child is frozen too.
+ */
+static int test_cgfreezer_rmdir(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *parent, *child = NULL;
+
+	parent = cg_name(root, "cg_test_A");
+	if (!parent)
+		goto cleanup;
+
+	child = cg_name(parent, "cg_test_B");
+	if (!child)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+
+	if (cg_freeze_wait(parent, true))
+		goto cleanup;
+
+	if (cg_check_frozen(parent, true))
+		goto cleanup;
+
+	if (cg_destroy(child))
+		goto cleanup;
+
+	if (cg_check_frozen(parent, true))
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+
+	if (cg_check_frozen(child, true))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (child)
+		cg_destroy(child);
+	free(child);
+	if (parent)
+		cg_destroy(parent);
+	free(parent);
+	return ret;
+}
+
+/*
+ * The test creates two cgroups: A and B. The it runs a process in A,
+ * and performs several migrations:
+ * 1) A (running) -> B (frozen)
+ * 2) B (frozen) -> A (running)
+ * 3) A (frozen) -> B (frozen)
+ *
+ * One each step it checks that the actual state of cgroups matches
+ * the expected state.
+ */
+static int test_cgfreezer_migrate(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cgroup[2] = {0};
+	int pid;
+
+	cgroup[0] = cg_name(root, "cg_test_A");
+	if (!cgroup[0])
+		goto cleanup;
+
+	cgroup[1] = cg_name(root, "cg_test_B");
+	if (!cgroup[1])
+		goto cleanup;
+
+	if (cg_create(cgroup[0]))
+		goto cleanup;
+
+	if (cg_create(cgroup[1]))
+		goto cleanup;
+
+	pid = cg_run_nowait(cgroup[0], child_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	if (cg_wait_for_proc_count(cgroup[0], 1))
+		goto cleanup;
+
+	/*
+	 * Migrate from A (running) to B (frozen)
+	 */
+	if (cg_freeze_wait(cgroup[1], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	if (cg_enter(cgroup[1], pid))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	/*
+	 * Migrate from B (frozen) to A (running)
+	 */
+	if (cg_enter(cgroup[0], pid))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], false))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	/*
+	 * Migrate from A (frozen) to B (frozen)
+	 */
+	if (cg_freeze_wait(cgroup[0], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], true))
+		goto cleanup;
+
+	if (cg_enter(cgroup[1], pid))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[0], true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup[1], true))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (cgroup[0])
+		cg_destroy(cgroup[0]);
+	free(cgroup[0]);
+	if (cgroup[1])
+		cg_destroy(cgroup[1]);
+	free(cgroup[1]);
+	return ret;
+}
+
+/*
+ * The test checks that ptrace works with a tracing process in a frozen cgroup.
+ */
+static int test_cgfreezer_ptrace(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cgroup = NULL;
+	siginfo_t siginfo;
+	int pid;
+
+	cgroup = cg_name(root, "cg_test");
+	if (!cgroup)
+		goto cleanup;
+
+	if (cg_create(cgroup))
+		goto cleanup;
+
+	pid = cg_run_nowait(cgroup, child_fn, NULL);
+	if (pid < 0)
+		goto cleanup;
+
+	if (cg_wait_for_proc_count(cgroup, 1))
+		goto cleanup;
+
+	if (cg_freeze_wait(cgroup, true))
+		goto cleanup;
+
+	if (cg_check_frozen(cgroup, true))
+		goto cleanup;
+
+	if (ptrace(PTRACE_SEIZE, pid, NULL, NULL))
+		goto cleanup;
+
+	if (ptrace(PTRACE_INTERRUPT, pid, NULL, NULL))
+		goto cleanup;
+
+	waitpid(pid, NULL, 0);
+
+	if (ptrace(PTRACE_GETSIGINFO, pid, NULL, &siginfo))
+		goto cleanup;
+
+	if (ptrace(PTRACE_DETACH, pid, NULL, NULL))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	if (cgroup)
+		cg_destroy(cgroup);
+	free(cgroup);
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct cgfreezer_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_cgfreezer_simple),
+	T(test_cgfreezer_tree),
+	T(test_cgfreezer_forkbomb),
+	T(test_cgfreezer_rmdir),
+	T(test_cgfreezer_migrate),
+	T(test_cgfreezer_ptrace),
+};
+#undef T
+
+int main(int argc, char *argv[])
+{
+	char root[PATH_MAX];
+	int i, ret = EXIT_SUCCESS;
+
+	if (cg_find_unified_root(root, sizeof(root)))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ret = EXIT_FAILURE;
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	return ret;
+}
-- 
2.17.2

