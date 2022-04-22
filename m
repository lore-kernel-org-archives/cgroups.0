From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 4/4] cgroup: Add test_cpucg_weight_underprovisioned() testcase
Date: Fri, 22 Apr 2022 10:33:53 -0700
Message-ID: <20220422173349.3394844-5-void@manifault.com>
References: <20220422173349.3394844-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220422173349.3394844-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

test_cpu.c includes testcases that validate the cgroup cpu controller.
This patch adds a new testcase called test_cpucg_weight_underprovisioned()
that verifies that processes with different cpu.weight that are all running
on an underprovisioned system, still get roughly the same amount of cpu
time.

Because test_cpucg_weight_underprovisioned() is very similar to
test_cpucg_weight_overprovisioned(), this patch also pulls the common logic
into a separate helper function that is invoked from both testcases, and
which uses function pointers to invoke the unique portions of the
testcases.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 155 ++++++++++++++++------
 1 file changed, 117 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 8d901c06c79d..64f9ce91c992 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -19,6 +19,12 @@ enum hog_clock_type {
 	CPU_HOG_CLOCK_WALL,
 };
 
+struct cpu_hogger {
+	char *cgroup;
+	pid_t pid;
+	long usage;
+};
+
 struct cpu_hog_func_param {
 	int nprocs;
 	struct timespec ts;
@@ -223,31 +229,15 @@ static int test_cpucg_stats(const char *root)
 	return ret;
 }
 
-/*
- * First, this test creates the following hierarchy:
- * A
- * A/B     cpu.weight = 50
- * A/C     cpu.weight = 100
- * A/D     cpu.weight = 150
- *
- * A separate process is then created for each child cgroup which spawns as
- * many threads as there are cores, and hogs each CPU as much as possible
- * for some time interval.
- *
- * Once all of the children have exited, we verify that each child cgroup
- * was given proportional runtime as informed by their cpu.weight.
- */
-static int test_cpucg_weight_overprovisioned(const char *root)
+static int
+run_cpucg_weight_test(
+		const char *root,
+		pid_t (*spawn_child)(const struct cpu_hogger *child),
+		int (*validate)(const struct cpu_hogger *children, int num_children))
 {
-	struct child {
-		char *cgroup;
-		pid_t pid;
-		long usage;
-	};
 	int ret = KSFT_FAIL, i;
 	char *parent = NULL;
-	struct child children[3] = {NULL};
-	long usage_seconds = 10;
+	struct cpu_hogger children[3] = {NULL};
 
 	parent = cg_name(root, "cpucg_test_0");
 	if (!parent)
@@ -273,16 +263,7 @@ static int test_cpucg_weight_overprovisioned(const char *root)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(children); i++) {
-		struct cpu_hog_func_param param = {
-			.nprocs = get_nprocs(),
-			.ts = {
-				.tv_sec = usage_seconds,
-				.tv_nsec = 0,
-			},
-			.clock_type = CPU_HOG_CLOCK_WALL,
-		};
-		pid_t pid = cg_run_nowait(children[i].cgroup, hog_cpus_timed,
-				(void *)&param);
+		pid_t pid = spawn_child(&children[i]);
 		if (pid <= 0)
 			goto cleanup;
 		children[i].pid = pid;
@@ -302,7 +283,46 @@ static int test_cpucg_weight_overprovisioned(const char *root)
 		children[i].usage = cg_read_key_long(children[i].cgroup,
 				"cpu.stat", "usage_usec");
 
-	for (i = 0; i < ARRAY_SIZE(children) - 1; i++) {
+	if (validate(children, ARRAY_SIZE(children)))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		cg_destroy(children[i].cgroup);
+		free(children[i].cgroup);
+	}
+	cg_destroy(parent);
+	free(parent);
+
+	return ret;
+}
+
+static pid_t weight_hog_ncpus(const struct cpu_hogger *child, int ncpus)
+{
+	long usage_seconds = 10;
+	struct cpu_hog_func_param param = {
+		.nprocs = ncpus,
+		.ts = {
+			.tv_sec = usage_seconds,
+			.tv_nsec = 0,
+		},
+		.clock_type = CPU_HOG_CLOCK_WALL,
+	};
+	return cg_run_nowait(child->cgroup, hog_cpus_timed, (void *)&param);
+}
+
+static pid_t weight_hog_all_cpus(const struct cpu_hogger *child)
+{
+	return weight_hog_ncpus(child, get_nprocs());
+}
+
+static int
+overprovision_validate(const struct cpu_hogger *children, int num_children)
+{
+	int ret = KSFT_FAIL, i;
+
+	for (i = 0; i < num_children - 1; i++) {
 		long delta;
 
 		if (children[i + 1].usage <= children[i].usage)
@@ -315,16 +335,74 @@ static int test_cpucg_weight_overprovisioned(const char *root)
 
 	ret = KSFT_PASS;
 cleanup:
-	for (i = 0; i < ARRAY_SIZE(children); i++) {
-		cg_destroy(children[i].cgroup);
-		free(children[i].cgroup);
+	return ret;
+}
+
+/*
+ * First, this test creates the following hierarchy:
+ * A
+ * A/B     cpu.weight = 50
+ * A/C     cpu.weight = 100
+ * A/D     cpu.weight = 150
+ *
+ * A separate process is then created for each child cgroup which spawns as
+ * many threads as there are cores, and hogs each CPU as much as possible
+ * for some time interval.
+ *
+ * Once all of the children have exited, we verify that each child cgroup
+ * was given proportional runtime as informed by their cpu.weight.
+ */
+static int test_cpucg_weight_overprovisioned(const char *root)
+{
+	return run_cpucg_weight_test(root, weight_hog_all_cpus,
+			overprovision_validate);
+}
+
+static pid_t weight_hog_one_cpu(const struct cpu_hogger *child)
+{
+	return weight_hog_ncpus(child, 1);
+}
+
+static int
+underprovision_validate(const struct cpu_hogger *children, int num_children)
+{
+	int ret = KSFT_FAIL, i;
+
+	for (i = 0; i < num_children - 1; i++) {
+		if (!values_close(children[i + 1].usage, children[0].usage, 15))
+			goto cleanup;
 	}
-	cg_destroy(parent);
-	free(parent);
 
+	ret = KSFT_PASS;
+cleanup:
 	return ret;
 }
 
+/*
+ * First, this test creates the following hierarchy:
+ * A
+ * A/B     cpu.weight = 50
+ * A/C     cpu.weight = 100
+ * A/D     cpu.weight = 150
+ *
+ * A separate process is then created for each child cgroup which spawns a
+ * single thread that hogs a CPU. The testcase is only run on systems that
+ * have at least one core per-thread in the child processes.
+ *
+ * Once all of the children have exited, we verify that each child cgroup
+ * had roughly the same runtime despite having different cpu.weight.
+ */
+static int test_cpucg_weight_underprovisioned(const char *root)
+{
+	// Only run the test if there are enough cores to avoid overprovisioning
+	// the system.
+	if (get_nprocs() < 4)
+		return KSFT_SKIP;
+
+	return run_cpucg_weight_test(root, weight_hog_one_cpu,
+			underprovision_validate);
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -333,6 +411,7 @@ struct cpucg_test {
 	T(test_cpucg_subtree_control),
 	T(test_cpucg_stats),
 	T(test_cpucg_weight_overprovisioned),
+	T(test_cpucg_weight_underprovisioned),
 };
 #undef T
 
-- 
2.30.2

