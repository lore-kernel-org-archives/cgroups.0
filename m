From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 5/5] selftests/bpf: Add selftests for current_under_cgroupv1v2
Date: Sun,  3 Sep 2023 14:28:00 +0000
Message-ID: <20230903142800.3870-6-laoar.shao@gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693751295; x=1694356095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXV1VH0aENFBhlgyeq6hQvsVgH339T3EWStJqjKjW+o=;
        b=iry41PyrpkV7Ny57Cr/afcfK2/SS8eUHsGTbKNY/Em4PSPLQkoufrHTR8RHtHkMNyK
         GIWr3j1nnjSquvklGMlkBdZv9BjuUiglmYUAlB8imGpwus5VZZMky1QclI5sMcPtfOON
         r0BldredxqtXiKss1b1oKadfQP22tGo/+lfNVuJJI+ZEW3Kmr+/B2qCSwe31X45fLRM/
         R4H6rNwkASw7AluoQZiiNMxoxqaYysU5hwrww9WuUm3HRaxq/SqMujV4y7/22F9NZkYy
         iZJ0iLUcj1HV6VIhR+NzB8SaiB07fJGie3z3Naj9eeGIahFWcyt6tQFPVn8rUqXGmQTu
         /LMQ==
In-Reply-To: <20230903142800.3870-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add selftests for bpf_current_task_under_cgroup() on both cgroup1 and
cgroup2. The result as follows,

  $ tools/testing/selftests/bpf/test_progs --name=current_under_cgroupv1v2
  #62/1    current_under_cgroupv1v2/test_current_under_cgroup2:OK
  #62/2    current_under_cgroupv1v2/test_current_under_cgroup1:OK
  #62      current_under_cgroupv1v2:OK
  Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../bpf/prog_tests/current_under_cgroupv1v2.c      | 76 ++++++++++++++++++++++
 .../bpf/progs/test_current_under_cgroupv1v2.c      | 31 +++++++++
 2 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/current_under_cgroupv1v2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_current_under_cgroupv1v2.c

diff --git a/tools/testing/selftests/bpf/prog_tests/current_under_cgroupv1v2.c b/tools/testing/selftests/bpf/prog_tests/current_under_cgroupv1v2.c
new file mode 100644
index 0000000..62efca3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/current_under_cgroupv1v2.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_current_under_cgroupv1v2.skel.h"
+
+#define CGROUP2_DIR "/current_under_cgroup2"
+
+static void attach_progs(int cgrp_fd)
+{
+	struct test_current_under_cgroupv1v2 *skel;
+	int cgrp_map_fd, ret, idx = 0;
+
+	skel = test_current_under_cgroupv1v2__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_current_under_cgroupv1v2__open"))
+		return;
+
+	cgrp_map_fd = bpf_map__fd(skel->maps.cgrp_map);
+	ret = bpf_map_update_elem(cgrp_map_fd, &idx, &cgrp_fd, BPF_ANY);
+	if (!ASSERT_OK(ret, "update_cgrp_map"))
+		goto cleanup;
+
+	/* Attach LSM prog first */
+	skel->links.lsm_run = bpf_program__attach_lsm(skel->progs.lsm_run);
+	if (!ASSERT_OK_PTR(skel->links.lsm_run, "lsm_attach"))
+		goto cleanup;
+
+	/* LSM prog will be triggered when attaching fentry */
+	skel->links.fentry_run = bpf_program__attach_trace(skel->progs.fentry_run);
+	ASSERT_NULL(skel->links.fentry_run, "fentry_attach");
+
+cleanup:
+	test_current_under_cgroupv1v2__destroy(skel);
+}
+
+static void current_under_cgroup1(void)
+{
+	int cgrp_fd, ret;
+
+	/* Setup cgroup1 hierarchy */
+	ret = setup_classid_environment();
+	if (!ASSERT_OK(ret, "setup_classid_environment"))
+		return;
+
+	ret = join_classid();
+	if (!ASSERT_OK(ret, "join_cgroup1"))
+		goto cleanup;
+
+	cgrp_fd = open_classid();
+	attach_progs(cgrp_fd);
+	close(cgrp_fd);
+
+cleanup:
+	/* Cleanup cgroup1 hierarchy */
+	cleanup_classid_environment();
+}
+
+static void current_under_cgroup2(void)
+{
+	int cgrp_fd;
+
+	cgrp_fd = test__join_cgroup(CGROUP2_DIR);
+	if (!ASSERT_GE(cgrp_fd, 0, "cgroup_join_cgroup2"))
+		return;
+
+	attach_progs(cgrp_fd);
+	close(cgrp_fd);
+}
+
+void test_current_under_cgroupv1v2(void)
+{
+	if (test__start_subtest("test_current_under_cgroup2"))
+		current_under_cgroup2();
+	if (test__start_subtest("test_current_under_cgroup1"))
+		current_under_cgroup1();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_current_under_cgroupv1v2.c b/tools/testing/selftests/bpf/progs/test_current_under_cgroupv1v2.c
new file mode 100644
index 0000000..9f0af0b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_current_under_cgroupv1v2.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, 1);
+} cgrp_map SEC(".maps");
+
+SEC("lsm/bpf")
+int BPF_PROG(lsm_run, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	if (cmd != BPF_LINK_CREATE)
+		return 0;
+
+	if (bpf_current_task_under_cgroup(&cgrp_map, 0 /* map index */))
+		return -1;
+	return 0;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(fentry_run)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

