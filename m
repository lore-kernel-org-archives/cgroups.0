From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 8/8] selftests/bpf: Add selftests for cgroup controller
Date: Fri, 22 Sep 2023 11:28:46 +0000
Message-ID: <20230922112846.4265-9-laoar.shao@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382160; x=1695986960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Un+n8gtPu2H9LbD/gWmNkEsxWWkM8C1lnBzSSmQYUiM=;
        b=IJGudsSt17I0f0TkZxOSBzk8SJG/ttozDfBKztpBpbs0BiDCUrtBTyhckTrFQY1r2a
         1SoCIlA46/vg4U5Ct+CTX5KTn9GnjzZF/hjIKb1DSS8sbJygU4MPjXiihMdbuAJEkcmb
         /fkIneBqcO0KBG+K2kN1cb5Hv8DHx/oAREm1+pMj0bsWAAl79g+6Cuq8RDdwTihe85lm
         1cyiD7L76R+K8OVrNYGB6Bg0faOiSFjU0SPzENkfxjV1p4Akcm5GisIhlcTPuVosnoln
         egsrOVqOj5GyS/hbBzXsSuElU1iGAaiaJcWbOU1aZAAHfUCdCgPJvJ5y2OV/jbkMMBOn
         3uMQ==
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add selftests for cgroup controller on both cgroup1 and cgroup2.
The result as follows,

  $ tools/testing/selftests/bpf/test_progs --name=cgroup_controller
  #40/1    cgroup_controller/test_cgroup1_controller:OK
  #40/2    cgroup_controller/test_invalid_cgroup_id:OK
  #40/3    cgroup_controller/test_sleepable_prog:OK
  #40/4    cgroup_controller/test_cgroup2_controller:OK
  #40      cgroup_controller:OK

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../bpf/prog_tests/cgroup_controller.c        | 149 ++++++++++++++++++
 .../bpf/progs/test_cgroup_controller.c        |  80 ++++++++++
 2 files changed, 229 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_controller.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_controller.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_controller.c b/tools/testing/selftests/bpf/prog_tests/cgroup_controller.c
new file mode 100644
index 000000000000..f76ec1e65b2a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_controller.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2023 Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> */
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_cgroup_controller.skel.h"
+
+#define CGROUP2_DIR "/cgroup2_controller"
+
+static void bpf_cgroup1_controller(bool sleepable, __u64 cgrp_id)
+{
+	struct test_cgroup_controller *skel;
+	int err;
+
+	skel = test_cgroup_controller__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		return;
+
+	skel->bss->target_pid = getpid();
+	skel->bss->ancestor_cgid = cgrp_id;
+
+	err = bpf_program__set_attach_target(skel->progs.fentry_run, 0, "bpf_fentry_test1");
+	if (!ASSERT_OK(err, "fentry_set_target"))
+		goto cleanup;
+
+	err = test_cgroup_controller__load(skel);
+	if (!ASSERT_OK(err, "load"))
+		goto cleanup;
+
+	/* Attach LSM prog first */
+	if (!sleepable) {
+		skel->links.lsm_net_cls = bpf_program__attach_lsm(skel->progs.lsm_net_cls);
+		if (!ASSERT_OK_PTR(skel->links.lsm_net_cls, "lsm_attach"))
+			goto cleanup;
+	} else {
+		skel->links.lsm_s_net_cls = bpf_program__attach_lsm(skel->progs.lsm_s_net_cls);
+		if (!ASSERT_OK_PTR(skel->links.lsm_s_net_cls, "lsm_attach_sleepable"))
+			goto cleanup;
+	}
+
+	/* LSM prog will be triggered when attaching fentry */
+	skel->links.fentry_run = bpf_program__attach_trace(skel->progs.fentry_run);
+	if (cgrp_id) {
+		ASSERT_NULL(skel->links.fentry_run, "fentry_attach_fail");
+	} else {
+		if (!ASSERT_OK_PTR(skel->links.fentry_run, "fentry_attach_success"))
+			goto cleanup;
+	}
+
+cleanup:
+	test_cgroup_controller__destroy(skel);
+}
+
+static void cgroup_controller_on_cgroup1(bool sleepable, bool invalid_cgid)
+{
+	__u64 cgrp_id;
+	int err;
+
+	/* Setup cgroup1 hierarchy */
+	err = setup_classid_environment();
+	if (!ASSERT_OK(err, "setup_classid_environment"))
+		return;
+
+	err = join_classid();
+	if (!ASSERT_OK(err, "join_cgroup1"))
+		goto cleanup;
+
+	cgrp_id = get_classid_cgroup_id();
+	if (invalid_cgid)
+		bpf_cgroup1_controller(sleepable, 0);
+	else
+		bpf_cgroup1_controller(sleepable, cgrp_id);
+
+cleanup:
+	/* Cleanup cgroup1 hierarchy */
+	cleanup_classid_environment();
+}
+
+static void bpf_cgroup2_controller(__u64 cgrp_id)
+{
+	struct test_cgroup_controller *skel;
+	int err;
+
+	skel = test_cgroup_controller__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		return;
+
+	skel->bss->target_pid = getpid();
+	skel->bss->ancestor_cgid = cgrp_id;
+
+	err = bpf_program__set_attach_target(skel->progs.fentry_run, 0, "bpf_fentry_test1");
+	if (!ASSERT_OK(err, "fentry_set_target"))
+		goto cleanup;
+
+	err = test_cgroup_controller__load(skel);
+	if (!ASSERT_OK(err, "load"))
+		goto cleanup;
+
+	skel->links.lsm_cpu = bpf_program__attach_lsm(skel->progs.lsm_cpu);
+	if (!ASSERT_OK_PTR(skel->links.lsm_cpu, "lsm_attach"))
+		goto cleanup;
+
+	skel->links.fentry_run = bpf_program__attach_trace(skel->progs.fentry_run);
+	ASSERT_NULL(skel->links.fentry_run, "fentry_attach_fail");
+
+cleanup:
+	test_cgroup_controller__destroy(skel);
+}
+
+static void cgroup_controller_on_cgroup2(void)
+{
+	int cgrp_fd, cgrp_id, err;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "cgrp2_env_setup"))
+		goto cleanup;
+
+	cgrp_fd = test__join_cgroup(CGROUP2_DIR);
+	if (!ASSERT_GE(cgrp_fd, 0, "cgroup_join_cgroup2"))
+		goto cleanup;
+
+	err = enable_controllers(CGROUP2_DIR, "cpu");
+	if (!ASSERT_OK(err, "cgrp2_env_setup"))
+		goto close_fd;
+
+	cgrp_id = get_cgroup_id(CGROUP2_DIR);
+	if (!ASSERT_GE(cgrp_id, 0, "cgroup2_id"))
+		goto close_fd;
+	bpf_cgroup2_controller(cgrp_id);
+
+close_fd:
+	close(cgrp_fd);
+cleanup:
+	cleanup_cgroup_environment();
+}
+
+void test_cgroup_controller(void)
+{
+	if (test__start_subtest("test_cgroup1_controller"))
+		cgroup_controller_on_cgroup1(false, false);
+	if (test__start_subtest("test_invalid_cgroup_id"))
+		cgroup_controller_on_cgroup1(false, true);
+	if (test__start_subtest("test_sleepable_prog"))
+		cgroup_controller_on_cgroup1(true, false);
+	if (test__start_subtest("test_cgroup2_controller"))
+		cgroup_controller_on_cgroup2();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cgroup_controller.c b/tools/testing/selftests/bpf/progs/test_cgroup_controller.c
new file mode 100644
index 000000000000..958804a34794
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cgroup_controller.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+//#endif
+/* Copyright (C) 2023 Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+
+__u64 ancestor_cgid;
+int target_pid;
+
+struct cgroup *bpf_cgroup_acquire_from_id_within_controller(u64 cgid, int ssid) __ksym;
+u64 bpf_cgroup_id_from_task_within_controller(struct task_struct *task, int ssid) __ksym;
+u64 bpf_cgroup_ancestor_id_from_task_within_controller(struct task_struct *task,
+						       int ssid, int level) __ksym;
+long bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;
+void bpf_cgroup_release(struct cgroup *p) __ksym;
+
+static int bpf_link_create_verify(int cmd, union bpf_attr *attr, unsigned int size, int ssid)
+{
+	struct cgroup *cgrp = NULL;
+	struct task_struct *task;
+	__u64 cgid, root_cgid;
+	int ret = 0;
+
+	if (cmd != BPF_LINK_CREATE)
+		return 0;
+
+	task = bpf_get_current_task_btf();
+	/* Then it can run in parallel */
+	if (target_pid != BPF_CORE_READ(task, pid))
+		return 0;
+
+	cgrp = bpf_cgroup_acquire_from_id_within_controller(ancestor_cgid, ssid);
+	if (!cgrp)
+		goto out;
+
+	if (bpf_task_under_cgroup(task, cgrp))
+		ret = -1;
+	bpf_cgroup_release(cgrp);
+
+	cgid = bpf_cgroup_id_from_task_within_controller(task, ssid);
+	if (cgid != ancestor_cgid)
+		ret = 0;
+
+	/* The level of root cgroup is 0, and its id is always 1 */
+	root_cgid = bpf_cgroup_ancestor_id_from_task_within_controller(task, ssid, 0);
+	if (root_cgid != 1)
+		ret = 0;
+
+out:
+	return ret;
+}
+
+SEC("lsm/bpf")
+int BPF_PROG(lsm_net_cls, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	return bpf_link_create_verify(cmd, attr, size, net_cls_cgrp_id);
+}
+
+SEC("lsm.s/bpf")
+int BPF_PROG(lsm_s_net_cls, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	return bpf_link_create_verify(cmd, attr, size, net_cls_cgrp_id);
+}
+
+SEC("lsm/bpf")
+int BPF_PROG(lsm_cpu, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	return bpf_link_create_verify(cmd, attr, size, cpu_cgrp_id);
+}
+
+SEC("fentry")
+int BPF_PROG(fentry_run)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.1 (Apple Git-130)

