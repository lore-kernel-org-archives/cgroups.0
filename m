From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 2/4] cgroup: Add test_cpucg_stats() testcase to cgroup cpu selftests
Date: Fri, 22 Apr 2022 10:33:51 -0700
Message-ID: <20220422173349.3394844-3-void@manifault.com>
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
This patch adds a new testcase called test_cpucg_stats() that verifies the
expected behavior of the cpu.stat interface. In doing so, we define a
new hog_cpus_timed() function which takes a cpu_hog_func_param struct
that configures how many CPUs it uses, and how long it runs. Future
patches will also spawn threads that hog CPUs, so this function will
eventually serve those use-cases as well.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.h |   3 +
 tools/testing/selftests/cgroup/test_cpu.c    | 128 +++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index 4f66d10626d2..1df13dc8b8aa 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -8,6 +8,9 @@
 
 #define MB(x) (x << 20)
 
+#define USEC_PER_SEC	1000000L
+#define NSEC_PER_SEC	1000000000L
+
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index a724bff00d07..3bd61964a262 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -2,11 +2,19 @@
 
 #define _GNU_SOURCE
 #include <linux/limits.h>
+#include <errno.h>
+#include <pthread.h>
 #include <stdio.h>
+#include <time.h>
 
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+struct cpu_hog_func_param {
+	int nprocs;
+	struct timespec ts;
+};
+
 /*
  * This test creates two nested cgroups with and without enabling
  * the cpu controller.
@@ -70,12 +78,132 @@ static int test_cpucg_subtree_control(const char *root)
 	return ret;
 }
 
+static void *hog_cpu_thread_func(void *arg)
+{
+	while (1)
+		;
+
+	return NULL;
+}
+
+static struct timespec
+timespec_sub(const struct timespec *lhs, const struct timespec *rhs)
+{
+	struct timespec zero = {
+		.tv_sec = 0,
+		.tv_nsec = 0,
+	};
+	struct timespec ret;
+
+	if (lhs->tv_sec < rhs->tv_sec)
+		return zero;
+
+	ret.tv_sec = lhs->tv_sec - rhs->tv_sec;
+
+	if (lhs->tv_nsec < rhs->tv_nsec) {
+		if (ret.tv_sec == 0)
+			return zero;
+
+		ret.tv_sec--;
+		ret.tv_nsec = NSEC_PER_SEC - rhs->tv_nsec + lhs->tv_nsec;
+	} else
+		ret.tv_nsec = lhs->tv_nsec - rhs->tv_nsec;
+
+	return ret;
+}
+
+static int hog_cpus_timed(const char *cgroup, void *arg)
+{
+	const struct cpu_hog_func_param *param =
+		(struct cpu_hog_func_param *)arg;
+	struct timespec ts_run = param->ts;
+	struct timespec ts_remaining = ts_run;
+	int i, ret;
+
+	for (i = 0; i < param->nprocs; i++) {
+		pthread_t tid;
+
+		ret = pthread_create(&tid, NULL, &hog_cpu_thread_func, NULL);
+		if (ret != 0)
+			return ret;
+	}
+
+	while (ts_remaining.tv_sec > 0 || ts_remaining.tv_nsec > 0) {
+		struct timespec ts_total;
+
+		ret = nanosleep(&ts_remaining, NULL);
+		if (ret && errno != EINTR)
+			return ret;
+
+		ret = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts_total);
+		if (ret != 0)
+			return ret;
+
+		ts_remaining = timespec_sub(&ts_run, &ts_total);
+	}
+
+	return 0;
+}
+
+/*
+ * Creates a cpu cgroup, burns a CPU for a few quanta, and verifies that
+ * cpu.stat shows the expected output.
+ */
+static int test_cpucg_stats(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long usage_usec, user_usec, system_usec;
+	long usage_seconds = 2;
+	long expected_usage_usec = usage_seconds * USEC_PER_SEC;
+	char *cpucg;
+
+	cpucg = cg_name(root, "cpucg_test");
+	if (!cpucg)
+		goto cleanup;
+
+	if (cg_create(cpucg))
+		goto cleanup;
+
+	usage_usec = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	user_usec = cg_read_key_long(cpucg, "cpu.stat", "user_usec");
+	system_usec = cg_read_key_long(cpucg, "cpu.stat", "system_usec");
+	if (usage_usec != 0 || user_usec != 0 || system_usec != 0)
+		goto cleanup;
+
+	struct cpu_hog_func_param param = {
+		.nprocs = 1,
+		.ts = {
+			.tv_sec = usage_seconds,
+			.tv_nsec = 0,
+		},
+	};
+	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
+		goto cleanup;
+
+	usage_usec = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	user_usec = cg_read_key_long(cpucg, "cpu.stat", "user_usec");
+	if (user_usec <= 0)
+		goto cleanup;
+
+	if (!values_close(usage_usec, expected_usage_usec, 1))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_destroy(cpucg);
+	free(cpucg);
+
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct cpucg_test {
 	int (*fn)(const char *root);
 	const char *name;
 } tests[] = {
 	T(test_cpucg_subtree_control),
+	T(test_cpucg_stats),
 };
 #undef T
 
-- 
2.30.2

