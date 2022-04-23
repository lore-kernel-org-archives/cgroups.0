From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 3/5] cgroup: Add test_cpucg_max() testcase
Date: Sat, 23 Apr 2022 05:30:52 -0700
Message-ID: <20220423123053.2982931-3-void@manifault.com>
References: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220423123053.2982931-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The cgroup cpu controller test suite has a number of testcases that
validate the expected behavior of the cpu.weight knob, but none for
cpu.max. This testcase fixes that by adding a testcase for cpu.max as well.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 54 +++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index de6289814c23..715922c15c78 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -564,6 +564,59 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 	return run_cpucg_nested_weight_test(root, false);
 }
 
+/*
+ * This test creates a cgroup with some maximum value within a period, and
+ * verifies that a process in the cgroup is not overscheduled.
+ */
+static int test_cpucg_max(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long usage_usec, user_usec;
+	long usage_seconds = 1;
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
+	if (cg_write(cpucg, "cpu.max", "1000"))
+		goto cleanup;
+
+	struct cpu_hog_func_param param = {
+		.nprocs = 1,
+		.ts = {
+			.tv_sec = usage_seconds,
+			.tv_nsec = 0,
+		},
+		.clock_type = CPU_HOG_CLOCK_WALL,
+	};
+	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
+		goto cleanup;
+
+	usage_usec = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	user_usec = cg_read_key_long(cpucg, "cpu.stat", "user_usec");
+	if (user_usec <= 0)
+		goto cleanup;
+
+	if (user_usec >= expected_usage_usec)
+		goto cleanup;
+
+	if (values_close(usage_usec, expected_usage_usec, 95))
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
@@ -575,6 +628,7 @@ struct cpucg_test {
 	T(test_cpucg_weight_underprovisioned),
 	T(test_cpucg_nested_weight_overprovisioned),
 	T(test_cpucg_nested_weight_underprovisioned),
+	T(test_cpucg_max),
 };
 #undef T
 
-- 
2.30.2

