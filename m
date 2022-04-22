From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 3/4] cgroup: Add test_cpucg_weight_overprovisioned() testcase
Date: Fri, 22 Apr 2022 10:33:52 -0700
Message-ID: <20220422173349.3394844-4-void@manifault.com>
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
This patch adds a new testcase called test_cpucg_weight_overprovisioned()
that verifies the expected behavior of creating multiple processes with
different cpu.weight, on a system that is overprovisioned.

So as to avoid code duplication, this patch also updates cpu_hog_func_param
to take a new hog_clock_type enum which informs how time is counted in
hog_cpus_timed() (either process time or wall clock time).

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c |  12 ++
 tools/testing/selftests/cgroup/cgroup_util.h |   1 +
 tools/testing/selftests/cgroup/test_cpu.c    | 135 ++++++++++++++++++-
 3 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 0cf7e90c0052..b690fdc8b4cd 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -190,6 +190,18 @@ int cg_write(const char *cgroup, const char *control, char *buf)
 	return -1;
 }
 
+int cg_write_numeric(const char *cgroup, const char *control, long value)
+{
+	char buf[64];
+	int ret;
+
+	ret = sprintf(buf, "%lu", value);
+	if (ret < 0)
+		return ret;
+
+	return cg_write(cgroup, control, buf);
+}
+
 int cg_find_unified_root(char *root, size_t len)
 {
 	char buf[10 * PAGE_SIZE];
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index 1df13dc8b8aa..0f79156697cf 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -35,6 +35,7 @@ extern long cg_read_long(const char *cgroup, const char *control);
 long cg_read_key_long(const char *cgroup, const char *control, const char *key);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
+int cg_write_numeric(const char *cgroup, const char *control, long value);
 extern int cg_run(const char *cgroup,
 		  int (*fn)(const char *cgroup, void *arg),
 		  void *arg);
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 3bd61964a262..8d901c06c79d 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -2,6 +2,8 @@
 
 #define _GNU_SOURCE
 #include <linux/limits.h>
+#include <sys/sysinfo.h>
+#include <sys/wait.h>
 #include <errno.h>
 #include <pthread.h>
 #include <stdio.h>
@@ -10,9 +12,17 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+enum hog_clock_type {
+	// Count elapsed time using the CLOCK_PROCESS_CPUTIME_ID clock.
+	CPU_HOG_CLOCK_PROCESS,
+	// Count elapsed time using system wallclock time.
+	CPU_HOG_CLOCK_WALL,
+};
+
 struct cpu_hog_func_param {
 	int nprocs;
 	struct timespec ts;
+	enum hog_clock_type clock_type;
 };
 
 /*
@@ -118,8 +128,13 @@ static int hog_cpus_timed(const char *cgroup, void *arg)
 		(struct cpu_hog_func_param *)arg;
 	struct timespec ts_run = param->ts;
 	struct timespec ts_remaining = ts_run;
+	struct timespec ts_start;
 	int i, ret;
 
+	ret = clock_gettime(CLOCK_MONOTONIC, &ts_start);
+	if (ret != 0)
+		return ret;
+
 	for (i = 0; i < param->nprocs; i++) {
 		pthread_t tid;
 
@@ -135,9 +150,19 @@ static int hog_cpus_timed(const char *cgroup, void *arg)
 		if (ret && errno != EINTR)
 			return ret;
 
-		ret = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts_total);
-		if (ret != 0)
-			return ret;
+		if (param->clock_type == CPU_HOG_CLOCK_PROCESS) {
+			ret = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts_total);
+			if (ret != 0)
+				return ret;
+		} else {
+			struct timespec ts_current;
+
+			ret = clock_gettime(CLOCK_MONOTONIC, &ts_current);
+			if (ret != 0)
+				return ret;
+
+			ts_total = timespec_sub(&ts_current, &ts_start);
+		}
 
 		ts_remaining = timespec_sub(&ts_run, &ts_total);
 	}
@@ -176,6 +201,7 @@ static int test_cpucg_stats(const char *root)
 			.tv_sec = usage_seconds,
 			.tv_nsec = 0,
 		},
+		.clock_type = CPU_HOG_CLOCK_PROCESS,
 	};
 	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
 		goto cleanup;
@@ -197,6 +223,108 @@ static int test_cpucg_stats(const char *root)
 	return ret;
 }
 
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
+	struct child {
+		char *cgroup;
+		pid_t pid;
+		long usage;
+	};
+	int ret = KSFT_FAIL, i;
+	char *parent = NULL;
+	struct child children[3] = {NULL};
+	long usage_seconds = 10;
+
+	parent = cg_name(root, "cpucg_test_0");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+cpu"))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		children[i].cgroup = cg_name_indexed(parent, "cpucg_child", i);
+		if (!children[i].cgroup)
+			goto cleanup;
+
+		if (cg_create(children[i].cgroup))
+			goto cleanup;
+
+		if (cg_write_numeric(children[i].cgroup, "cpu.weight",
+					50 * (i + 1)))
+			goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		struct cpu_hog_func_param param = {
+			.nprocs = get_nprocs(),
+			.ts = {
+				.tv_sec = usage_seconds,
+				.tv_nsec = 0,
+			},
+			.clock_type = CPU_HOG_CLOCK_WALL,
+		};
+		pid_t pid = cg_run_nowait(children[i].cgroup, hog_cpus_timed,
+				(void *)&param);
+		if (pid <= 0)
+			goto cleanup;
+		children[i].pid = pid;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(children); i++) {
+		int retcode;
+
+		waitpid(children[i].pid, &retcode, 0);
+		if (!WIFEXITED(retcode))
+			goto cleanup;
+		if (WEXITSTATUS(retcode))
+			goto cleanup;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(children); i++)
+		children[i].usage = cg_read_key_long(children[i].cgroup,
+				"cpu.stat", "usage_usec");
+
+	for (i = 0; i < ARRAY_SIZE(children) - 1; i++) {
+		long delta;
+
+		if (children[i + 1].usage <= children[i].usage)
+			goto cleanup;
+
+		delta = children[i + 1].usage - children[i].usage;
+		if (!values_close(delta, children[0].usage, 35))
+			goto cleanup;
+	}
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
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
@@ -204,6 +332,7 @@ struct cpucg_test {
 } tests[] = {
 	T(test_cpucg_subtree_control),
 	T(test_cpucg_stats),
+	T(test_cpucg_weight_overprovisioned),
 };
 #undef T
 
-- 
2.30.2

