From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 1/5] cgroup: Adding test_cpucg_nested_weight_overprovisioned() testcase
Date: Sat, 23 Apr 2022 05:30:50 -0700
Message-ID: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The cgroup cpu controller tests in
tools/testing/selftests/cgroup/test_cpu.c have some testcases that validate
the expected behavior of setting cpu.weight on cgroups, and then hogging
CPUs. What is still missing from the suite is a testcase that validates
nested cgroups. This patch adds test_cpucg_nested_weight_overprovisioned(),
which validates that a parent's cpu.weight will override its children if
they overcommit a host, and properly protect any sibling groups of that
parent.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 122 ++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 64f9ce91c992..fc90b4d0feb9 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -403,6 +403,127 @@ static int test_cpucg_weight_underprovisioned(const char *root)
 			underprovision_validate);
 }
 
+/*
+ * First, this test creates the following hierarchy:
+ * A
+ * A/B     cpu.weight = 1000
+ * A/C     cpu.weight = 1000
+ * A/C/D   cpu.weight = 5000
+ * A/C/E   cpu.weight = 5000
+ *
+ * A separate process is then created for each leaf, which spawn nproc threads
+ * that burn a CPU for a few seconds.
+ *
+ * Once all of those processes have exited, we verify that each of the leaf
+ * cgroups have roughly the same usage from cpu.stat.
+ */
+static int
+test_cpucg_nested_weight_overprovisioned(const char *root)
+{
+	int ret = KSFT_FAIL, i;
+	char *parent = NULL, *child = NULL;
+	struct cpu_hogger leaf[3] = {NULL};
+	long nested_leaf_usage, child_usage;
+	int nprocs = get_nprocs();
+
+	parent = cg_name(root, "cpucg_test");
+	child = cg_name(parent, "cpucg_child");
+	if (!parent || !child)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+	if (cg_write(parent, "cgroup.subtree_control", "+cpu"))
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+	if (cg_write(child, "cgroup.subtree_control", "+cpu"))
+		goto cleanup;
+	if (cg_write(child, "cpu.weight", "1000"))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(leaf); i++) {
+		const char *ancestor;
+		long weight;
+
+		if (i == 0) {
+			ancestor = parent;
+			weight = 1000;
+		} else {
+			ancestor = child;
+			weight = 5000;
+		}
+		leaf[i].cgroup = cg_name_indexed(ancestor, "cpucg_leaf", i);
+		if (!leaf[i].cgroup)
+			goto cleanup;
+
+		if (cg_create(leaf[i].cgroup))
+			goto cleanup;
+
+		if (cg_write_numeric(leaf[i].cgroup, "cpu.weight", weight))
+			goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(leaf); i++) {
+		pid_t pid;
+		struct cpu_hog_func_param param = {
+			.nprocs = nprocs,
+			.ts = {
+				.tv_sec = 10,
+				.tv_nsec = 0,
+			},
+			.clock_type = CPU_HOG_CLOCK_WALL,
+		};
+
+		pid = cg_run_nowait(leaf[i].cgroup, hog_cpus_timed,
+				(void *)&param);
+		if (pid <= 0)
+			goto cleanup;
+		leaf[i].pid = pid;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(leaf); i++) {
+		int retcode;
+
+		waitpid(leaf[i].pid, &retcode, 0);
+		if (!WIFEXITED(retcode))
+			goto cleanup;
+		if (WEXITSTATUS(retcode))
+			goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(leaf); i++) {
+		leaf[i].usage = cg_read_key_long(leaf[i].cgroup,
+				"cpu.stat", "usage_usec");
+		if (leaf[i].usage <= 0)
+			goto cleanup;
+	}
+
+	nested_leaf_usage = leaf[1].usage + leaf[2].usage;
+	if (!values_close(leaf[0].usage, nested_leaf_usage, 15))
+		goto cleanup;
+
+	child_usage = cg_read_key_long(child, "cpu.stat", "usage_usec");
+	if (child_usage <= 0)
+		goto cleanup;
+	if (!values_close(child_usage, nested_leaf_usage, 1))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(leaf); i++) {
+		cg_destroy(leaf[i].cgroup);
+		free(leaf[i].cgroup);
+	}
+	cg_destroy(child);
+	free(child);
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -412,6 +533,7 @@ struct cpucg_test {
 	T(test_cpucg_stats),
 	T(test_cpucg_weight_overprovisioned),
 	T(test_cpucg_weight_underprovisioned),
+	T(test_cpucg_nested_weight_overprovisioned),
 };
 #undef T
 
-- 
2.30.2

