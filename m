From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 4/5] Add test_cpucg_max_nested() testcase
Date: Sat, 23 Apr 2022 05:30:53 -0700
Message-ID: <20220423123053.2982931-4-void@manifault.com>
References: <20220423123053.2982931-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220423123053.2982931-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The cgroup cpu controller selftests have a test_cpucg_max() testcase
that validates the behavior of the cpu.max knob. Let's also add a
testcase that verifies that the behavior works correctly when set on a
nested cgroup.

Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 63 +++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 715922c15c78..24020a2c68dc 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -617,6 +617,68 @@ static int test_cpucg_max(const char *root)
 	return ret;
 }
 
+/*
+ * This test verifies that a process inside of a nested cgroup whose parent
+ * group has a cpu.max value set, is properly throttled.
+ */
+static int test_cpucg_max_nested(const char *root)
+{
+	int ret = KSFT_FAIL;
+	long usage_usec, user_usec;
+	long usage_seconds = 1;
+	long expected_usage_usec = usage_seconds * USEC_PER_SEC;
+	char *parent, *child;
+
+	parent = cg_name(root, "cpucg_parent");
+	child = cg_name(parent, "cpucg_child");
+	if (!parent || !child)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+cpu"))
+		goto cleanup;
+
+	if (cg_create(child))
+		goto cleanup;
+
+	if (cg_write(parent, "cpu.max", "1000"))
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
+	if (cg_run(child, hog_cpus_timed, (void *)&param))
+		goto cleanup;
+
+	usage_usec = cg_read_key_long(child, "cpu.stat", "usage_usec");
+	user_usec = cg_read_key_long(child, "cpu.stat", "user_usec");
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
@@ -629,6 +691,7 @@ struct cpucg_test {
 	T(test_cpucg_nested_weight_overprovisioned),
 	T(test_cpucg_nested_weight_underprovisioned),
 	T(test_cpucg_max),
+	T(test_cpucg_max_nested),
 };
 #undef T
 
-- 
2.30.2

