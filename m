From: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] selftests: cgroup: add test_zswap program
Date: Wed, 21 Jun 2023 17:35:46 +0200
Message-ID: <20230621153548.428093-2-cerasuolodomenico@gmail.com>
References: <20230621153548.428093-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687361755; x=1689953755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLXTp0RUGgA+Jc/sbfJseOldAYLgzR9TekxbeG05s8o=;
        b=RyrImiepPCrpOmy1ozaSxyvcEDzp9MhE3T2S32+bcXkS1ZJzt1kFvryEHapCuclisn
         FsMnBcnAgFvVbz6oHOnhjon9AzlNuRq2CeT9VGoekE8V0UMz5c+VXoFvg4jFkTzdqk+l
         zCxPPRFEFfvNeWQrQn5XGRP/ts+3BrdZOvhFYBqSf2BgPLY203kPTKllyM0/471/aFL6
         OcKfCwkc99LlwRgxgbKjREL2XCJLiI2GiJPwbCb8Ov09ctVU+UVoYc1tsiL8jr9oJbck
         eM4hcz2ZMDYQzQKIyt7/dhp1et0FiNe5SSxnxPrYJdLkUyWmVoqzfZgwgMyqsMdkeBUk
         Evnw==
In-Reply-To: <20230621153548.428093-1-cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ddstreet-EkmVulN54Sk@public.gmane.org, vitaly.wool-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add empty cgroup-zswap self test scaffold program, test functions to be
added in the next commits.

Signed-off-by: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/cgroup/.gitignore   |  1 +
 tools/testing/selftests/cgroup/Makefile     |  2 +
 tools/testing/selftests/cgroup/test_zswap.c | 62 +++++++++++++++++++++
 3 files changed, 65 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_zswap.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index c4a57e69f749..4d556df4f77b 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -5,4 +5,5 @@ test_freezer
 test_kmem
 test_kill
 test_cpu
+test_zswap
 wait_inotify
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index 3d263747d2ad..27dbdd7bb4bb 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += test_core
 TEST_GEN_PROGS += test_freezer
 TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_cpu
+TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
@@ -23,3 +24,4 @@ $(OUTPUT)/test_core: cgroup_util.c
 $(OUTPUT)/test_freezer: cgroup_util.c
 $(OUTPUT)/test_kill: cgroup_util.c
 $(OUTPUT)/test_cpu: cgroup_util.c
+$(OUTPUT)/test_zswap: cgroup_util.c
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
new file mode 100644
index 000000000000..001533667322
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <unistd.h>
+#include <stdio.h>
+
+#include "../kselftest.h"
+#include "cgroup_util.h"
+
+#define T(x) { x, #x }
+struct zswap_test {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+};
+#undef T
+
+static bool zswap_configured(void)
+{
+	return access("/sys/module/zswap", F_OK) == 0;
+}
+
+int main(int argc, char **argv)
+{
+	char root[PATH_MAX];
+	int i, ret = EXIT_SUCCESS;
+
+	if (cg_find_unified_root(root, sizeof(root)))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	if (!zswap_configured())
+		ksft_exit_skip("zswap isn't configured\n");
+
+	/*
+	 * Check that memory controller is available:
+	 * memory is listed in cgroup.controllers
+	 */
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
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
2.34.1

