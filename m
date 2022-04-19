From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 1/4] cgroup: Add new test_cpu.c test suite in cgroup selftests
Date: Tue, 19 Apr 2022 14:32:42 -0700
Message-ID: <20220419213244.2104972-2-void@manifault.com>
References: <20220419213244.2104972-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220419213244.2104972-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org

The cgroup selftests suite currently contains tests that validate various
aspects of cgroup, such as validating the expected behavior for memory
controllers, the expected behavior of cgroup.procs, etc. There are no tests
that validate the expected behavior of the cgroup cpu controller.

This patch therefore adds a new test_cpu.c file that will contain cpu
controller testcases. The file currently only contains a single testcase
that validates creating nested cgroups with cgroup.subtree_control
including cpu. Future patches will add more sophisticated testcases that
validate functional aspects of the cpu controller.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/.gitignore |   1 +
 tools/testing/selftests/cgroup/Makefile   |   2 +
 tools/testing/selftests/cgroup/test_cpu.c | 110 ++++++++++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_cpu.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index be9643ef6285..306ee1b01e72 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -4,3 +4,4 @@ test_core
 test_freezer
 test_kmem
 test_kill
+test_cpu
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index 745fe25fa0b9..478217cc1371 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -10,6 +10,7 @@ TEST_GEN_PROGS += test_kmem
 TEST_GEN_PROGS += test_core
 TEST_GEN_PROGS += test_freezer
 TEST_GEN_PROGS += test_kill
+TEST_GEN_PROGS += test_cpu
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
@@ -20,3 +21,4 @@ $(OUTPUT)/test_kmem: cgroup_util.c
 $(OUTPUT)/test_core: cgroup_util.c
 $(OUTPUT)/test_freezer: cgroup_util.c
 $(OUTPUT)/test_kill: cgroup_util.c
+$(OUTPUT)/test_cpu: cgroup_util.c
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
new file mode 100644
index 000000000000..4faa279bbab3
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <linux/limits.h>
+#include <stdio.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+/*
+ * This test creates two nested cgroups with and without enabling
+ * the cpu controller.
+ */
+static int test_cgcpu_subtree_control(const char *root)
+{
+	char *parent = NULL, *child = NULL, *parent2 = NULL, *child2 = NULL;
+	int ret = KSFT_FAIL;
+
+	// Create two nested cgroups with the cpu controller enabled.
+	parent = cg_name(root, "cgcpu_test_0");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+cpu"))
+		goto cleanup;
+
+	child = cg_name(parent, "cgcpu_test_child");
+	if (!child)
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+
+	if (cg_read_strstr(child, "cgroup.controllers", "cpu"))
+		goto cleanup;
+
+	// Create two nested cgroups without enabling the cpu controller.
+	parent2 = cg_name(root, "cgcpu_test_1");
+	if (!parent2)
+		goto cleanup;
+
+	if (cg_create(parent2))
+		goto cleanup;
+
+	child2 = cg_name(parent2, "cgcpu_test_child");
+	if (!child2)
+		goto cleanup;
+
+	if (cg_create(child2))
+		goto cleanup;
+
+	if (!cg_read_strstr(child2, "cgroup.controllers", "cpu"))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(child);
+	free(child);
+	cg_destroy(child2);
+	free(child2);
+	cg_destroy(parent);
+	free(parent);
+	cg_destroy(parent2);
+	free(parent2);
+
+	return ret;
+}
+
+#define T(x) { x, #x }
+struct cgcpu_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_cgcpu_subtree_control),
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
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "cpu"))
+		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
+			ksft_exit_skip("Failed to set cpu controller\n");
+
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
2.30.2

