From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH bpf-next v4 5/8] selftests/bpf: Test cgroup_iter.
Date: Fri, 22 Jul 2022 02:13:10 +0000
Message-ID: <20220722021313.3150035-6-yosryahmed@google.com>
References: <20220722021313.3150035-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/2zgWSswf48FBVcdSK+ZCEzEIOisbOgEmAjPmkYvrqc=;
        b=meNnC6TOmehrxMsYph8rfZlbtL4FMRL7bFGyyKdvYbYGlC0prZG+AAqhSCJ7VmzVOD
         6lPo/TwFiU17Yi1uhxWFjsGvuSKR+3s9vJ5W9l1Mn4wH2gk4NKcN9xO3ogGpgPHBez/+
         Htdo9GKs0wn9cTpmG1YYRRb2VB2N1yD/u0ixeT1LDbid1vWxXVv9gf2jdOJnrizI5hW6
         BrPA7B2qF6cfn+r7Qw00RQ1Rzj0dqcRr8xaAgKl3JCJgKD5EqE/vWO6baZC/VuBgj4Ag
         FU0WuEkcYGPj4wkj+lKDUhnBv7dw4dBSBdjQDDE5TYcARNmceW3ZEVxb6Kf54/acj0b0
         /rww==
In-Reply-To: <20220722021313.3150035-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
of the following structure:

    ROOT (working cgroup)
     |
   PARENT
  /      \
CHILD1  CHILD2

and tests the following scenarios:

 - invalid cgroup fd.
 - pre-order walk over descendants from PARENT.
 - post-order walk over descendants from PARENT.
 - walk of ancestors from PARENT.
 - early termination.

Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
---
 .../selftests/bpf/prog_tests/cgroup_iter.c    | 190 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
 .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++++
 3 files changed, 236 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
new file mode 100644
index 000000000000..4c8f11f78491
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "cgroup_iter.skel.h"
+#include "cgroup_helpers.h"
+
+#define ROOT		0
+#define PARENT		1
+#define CHILD1		2
+#define CHILD2		3
+#define NUM_CGROUPS	4
+
+#define PROLOGUE	"prologue\n"
+#define EPILOGUE	"epilogue\n"
+
+#define format_expected_output1(cg_id1) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n" EPILOGUE, (cg_id1))
+
+#define format_expected_output2(cg_id1, cg_id2) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n%8llu\n" EPILOGUE, \
+		 (cg_id1), (cg_id2))
+
+#define format_expected_output3(cg_id1, cg_id2, cg_id3) \
+	snprintf(expected_output, sizeof(expected_output), \
+		 PROLOGUE "%8llu\n%8llu\n%8llu\n" EPILOGUE, \
+		 (cg_id1), (cg_id2), (cg_id3))
+
+const char *cg_path[] = {
+	"/", "/parent", "/parent/child1", "/parent/child2"
+};
+
+static int cg_fd[] = {-1, -1, -1, -1};
+static unsigned long long cg_id[] = {0, 0, 0, 0};
+static char expected_output[64];
+
+int setup_cgroups(void)
+{
+	int fd, i = 0;
+
+	for (i = 0; i < NUM_CGROUPS; i++) {
+		fd = create_and_get_cgroup(cg_path[i]);
+		if (fd < 0)
+			return fd;
+
+		cg_fd[i] = fd;
+		cg_id[i] = get_cgroup_id(cg_path[i]);
+	}
+	return 0;
+}
+
+void cleanup_cgroups(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_CGROUPS; i++)
+		close(cg_fd[i]);
+}
+
+static void read_from_cgroup_iter(struct bpf_program *prog, int cgroup_fd,
+				  int order, const char *testname)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+	int len, iter_fd;
+	static char buf[64];
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = cgroup_fd;
+	linfo.cgroup.traversal_order = order;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(prog, &opts);
+	if (!ASSERT_OK_PTR(link, "attach_iter"))
+		return;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	if (iter_fd < 0)
+		goto free_link;
+
+	memset(buf, 0, sizeof(buf));
+	while ((len = read(iter_fd, buf, sizeof(buf))) > 0)
+		;
+
+	ASSERT_STREQ(buf, expected_output, testname);
+
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+}
+
+/* Invalid cgroup. */
+static void test_invalid_cgroup(struct cgroup_iter *skel)
+{
+
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.cgroup.cgroup_fd = (__u32)-1;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_id_printer, &opts);
+	if (!ASSERT_ERR_PTR(link, "attach_iter"))
+		bpf_link__destroy(link);
+}
+
+/* Preorder walk prints parent and child in order. */
+static void test_walk_preorder(struct cgroup_iter *skel)
+{
+	format_expected_output3(cg_id[PARENT], cg_id[CHILD1], cg_id[CHILD2]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PRE, "preorder");
+}
+
+/* Postorder walk prints child and parent in order. */
+static void test_walk_postorder(struct cgroup_iter *skel)
+{
+	format_expected_output3(cg_id[CHILD1], cg_id[CHILD2], cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_POST, "postorder");
+}
+
+/* Walking parents prints parent and then root. */
+static void test_walk_parent_up(struct cgroup_iter *skel)
+{
+	/* terminate the walk when ROOT is met. */
+	skel->bss->terminal_cgroup = cg_id[ROOT];
+
+	format_expected_output2(cg_id[PARENT], cg_id[ROOT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PARENT_UP, "parent_up");
+
+	skel->bss->terminal_cgroup = 0;
+}
+
+/* Early termination prints parent only. */
+static void test_early_termination(struct cgroup_iter *skel)
+{
+	/* terminate the walk after the first element is processed. */
+	skel->bss->terminate_early = 1;
+
+	format_expected_output1(cg_id[PARENT]);
+
+	read_from_cgroup_iter(skel->progs.cgroup_id_printer, cg_fd[PARENT],
+			      BPF_ITER_CGROUP_PRE, "early_termination");
+
+	skel->bss->terminate_early = 0;
+}
+
+void test_cgroup_iter(void)
+{
+	struct cgroup_iter *skel = NULL;
+
+	if (setup_cgroup_environment() < 0)
+		return;
+
+	if (setup_cgroups() < 0)
+		goto out;
+
+	skel = cgroup_iter__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter__open_and_load"))
+		goto out;
+
+	if (test__start_subtest("cgroup_iter__invalid_cgroup"))
+		test_invalid_cgroup(skel);
+	if (test__start_subtest("cgroup_iter__preorder"))
+		test_walk_preorder(skel);
+	if (test__start_subtest("cgroup_iter__postorder"))
+		test_walk_postorder(skel);
+	if (test__start_subtest("cgroup_iter__parent_up_walk"))
+		test_walk_parent_up(skel);
+	if (test__start_subtest("cgroup_iter__early_termination"))
+		test_early_termination(skel);
+out:
+	cgroup_iter__destroy(skel);
+	cleanup_cgroups();
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing/selftests/bpf/progs/bpf_iter.h
index e9846606690d..c41ee80533ca 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -17,6 +17,7 @@
 #define bpf_iter__bpf_sk_storage_map bpf_iter__bpf_sk_storage_map___not_used
 #define bpf_iter__sockmap bpf_iter__sockmap___not_used
 #define bpf_iter__bpf_link bpf_iter__bpf_link___not_used
+#define bpf_iter__cgroup bpf_iter__cgroup___not_used
 #define btf_ptr btf_ptr___not_used
 #define BTF_F_COMPACT BTF_F_COMPACT___not_used
 #define BTF_F_NONAME BTF_F_NONAME___not_used
@@ -40,6 +41,7 @@
 #undef bpf_iter__bpf_sk_storage_map
 #undef bpf_iter__sockmap
 #undef bpf_iter__bpf_link
+#undef bpf_iter__cgroup
 #undef btf_ptr
 #undef BTF_F_COMPACT
 #undef BTF_F_NONAME
@@ -141,6 +143,11 @@ struct bpf_iter__bpf_link {
 	struct bpf_link *link;
 };
 
+struct bpf_iter__cgroup {
+	struct bpf_iter_meta *meta;
+	struct cgroup *cgroup;
+} __attribute__((preserve_access_index));
+
 struct btf_ptr {
 	void *ptr;
 	__u32 type_id;
diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter.c b/tools/testing/selftests/bpf/progs/cgroup_iter.c
new file mode 100644
index 000000000000..2a34d146d6df
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Google */
+
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+volatile int terminate_early = 0;
+volatile u64 terminal_cgroup = 0;
+
+static inline u64 cgroup_id(struct cgroup *cgrp)
+{
+	return cgrp->kn->id;
+}
+
+SEC("iter/cgroup")
+int cgroup_id_printer(struct bpf_iter__cgroup *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct cgroup *cgrp = ctx->cgroup;
+
+	/* epilogue */
+	if (cgrp == NULL) {
+		BPF_SEQ_PRINTF(seq, "epilogue\n");
+		return 0;
+	}
+
+	/* prologue */
+	if (ctx->meta->seq_num == 0)
+		BPF_SEQ_PRINTF(seq, "prologue\n");
+
+	BPF_SEQ_PRINTF(seq, "%8llu\n", cgroup_id(cgrp));
+
+	if (terminal_cgroup == cgroup_id(cgrp))
+		return 1;
+
+	return terminate_early ? 1 : 0;
+}
-- 
2.37.1.359.gd136c6c3e2-goog

