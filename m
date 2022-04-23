From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 2/5] cgroup: Add test_cpucg_nested_weight_underprovisioned() testcase
Date: Sat, 23 Apr 2022 05:30:51 -0700
Message-ID: <20220423123053.2982931-2-void@manifault.com>
References: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220423123053.2982931-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The cgroup cpu controller test suite currently contains a testcase called
test_cpucg_nested_weight_underprovisioned() which verifies the expected
behavior of cpu.weight when applied to nested cgroups. That first testcase
validated the expected behavior when the processes in the leaf cgroups
overcommitted the system. This patch adds a complementary
test_cpucg_nested_weight_underprovisioned() testcase which validates
behavior when those leaf cgroups undercommit the system.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 73 ++++++++++++++++++-----
 1 file changed, 57 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index fc90b4d0feb9..de6289814c23 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -403,22 +403,8 @@ static int test_cpucg_weight_underprovisioned(const char *root)
 			underprovision_validate);
 }
 
-/*
- * First, this test creates the following hierarchy:
- * A
- * A/B     cpu.weight = 1000
- * A/C     cpu.weight = 1000
- * A/C/D   cpu.weight = 5000
- * A/C/E   cpu.weight = 5000
- *
- * A separate process is then created for each leaf, which spawn nproc threads
- * that burn a CPU for a few seconds.
- *
- * Once all of those processes have exited, we verify that each of the leaf
- * cgroups have roughly the same usage from cpu.stat.
- */
 static int
-test_cpucg_nested_weight_overprovisioned(const char *root)
+run_cpucg_nested_weight_test(const char *root, bool overprovisioned)
 {
 	int ret = KSFT_FAIL, i;
 	char *parent = NULL, *child = NULL;
@@ -426,6 +412,16 @@ test_cpucg_nested_weight_overprovisioned(const char *root)
 	long nested_leaf_usage, child_usage;
 	int nprocs = get_nprocs();
 
+	if (!overprovisioned) {
+		if (nprocs < 4)
+			/*
+			 * Only run the test if there are enough cores to avoid overprovisioning
+			 * the system.
+			 */
+			return KSFT_SKIP;
+		nprocs /= 4;
+	}
+
 	parent = cg_name(root, "cpucg_test");
 	child = cg_name(parent, "cpucg_child");
 	if (!parent || !child)
@@ -501,9 +497,13 @@ test_cpucg_nested_weight_overprovisioned(const char *root)
 	}
 
 	nested_leaf_usage = leaf[1].usage + leaf[2].usage;
-	if (!values_close(leaf[0].usage, nested_leaf_usage, 15))
+	if (overprovisioned) {
+		if (!values_close(leaf[0].usage, nested_leaf_usage, 15))
+			goto cleanup;
+	} else if (!values_close(leaf[0].usage * 2, nested_leaf_usage, 15))
 		goto cleanup;
 
+
 	child_usage = cg_read_key_long(child, "cpu.stat", "usage_usec");
 	if (child_usage <= 0)
 		goto cleanup;
@@ -524,6 +524,46 @@ test_cpucg_nested_weight_overprovisioned(const char *root)
 	return ret;
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
+	return run_cpucg_nested_weight_test(root, true);
+}
+
+/*
+ * First, this test creates the following hierarchy:
+ * A
+ * A/B     cpu.weight = 1000
+ * A/C     cpu.weight = 1000
+ * A/C/D   cpu.weight = 5000
+ * A/C/E   cpu.weight = 5000
+ *
+ * A separate process is then created for each leaf, which nproc / 4 threads
+ * that burns a CPU for a few seconds.
+ *
+ * Once all of those processes have exited, we verify that each of the leaf
+ * cgroups have roughly the same usage from cpu.stat.
+ */
+static int
+test_cpucg_nested_weight_underprovisioned(const char *root)
+{
+	return run_cpucg_nested_weight_test(root, false);
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -534,6 +574,7 @@ struct cpucg_test {
 	T(test_cpucg_weight_overprovisioned),
 	T(test_cpucg_weight_underprovisioned),
 	T(test_cpucg_nested_weight_overprovisioned),
+	T(test_cpucg_nested_weight_underprovisioned),
 };
 #undef T
 
-- 
2.30.2

