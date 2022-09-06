From: Roberto Sassu <roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH 7/7] selftests/bpf: Add tests for _opts variants of libbpf
Date: Tue,  6 Sep 2022 19:03:01 +0200
Message-ID: <20220906170301.256206-8-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220906170301.256206-1-roberto.sassu-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mykolal-b10kYP2dOMg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jakub-lDpJ742SOEtZroRs9YW3xA@public.gmane.org
Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Introduce the data_input map, write-protected with a small eBPF program
implementing the lsm/bpf_map hook.

Then, ensure that bpf_map_get_fd_by_id() and bpf_map_get_fd_by_id_opts()
with NULL opts don't succeed due to requesting read-write access to the
write-protected map. Also, ensure that bpf_map_get_fd_by_id_opts() with
flags in opts set to BPF_F_RDONLY instead succeeds.

After obtaining a read-only fd, ensure that only map lookup succeeds and
not update. Ensure that update works only with the read-write fd obtained
at program loading time, when the write protection was not yet enabled.

Finally, ensure that other _opts variants of libbpf don't work if the
BPF_F_RDONLY flag is set in opts (due to the kernel not handling the
open_flags member of bpf_attr).

Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 .../bpf/prog_tests/libbpf_get_fd_opts.c       | 145 ++++++++++++++++++
 .../bpf/progs/test_libbpf_get_fd_opts.c       |  49 ++++++
 2 files changed, 194 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c

diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
new file mode 100644
index 000000000000..8ea1c44f979e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+ */
+
+#include <test_progs.h>
+
+#include "test_libbpf_get_fd_opts.skel.h"
+
+void test_libbpf_get_fd_opts(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct test_libbpf_get_fd_opts *skel;
+	struct bpf_map_info info_m = { 0 };
+	__u32 len = sizeof(info_m), value;
+	union bpf_iter_link_info linfo;
+	struct bpf_link *link;
+	struct bpf_map *map;
+	char buf[16];
+	int ret, zero = 0, fd = -1, iter_fd;
+
+	DECLARE_LIBBPF_OPTS(bpf_get_fd_opts, fd_opts_rdonly,
+		.open_flags = BPF_F_RDONLY,
+	);
+
+	skel = test_libbpf_get_fd_opts__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_libbpf_get_fd_opts__open_and_load"))
+		return;
+
+	bpf_program__set_autoattach(skel->progs.write_bpf_array_map, false);
+
+	ret = test_libbpf_get_fd_opts__attach(skel);
+	if (!ASSERT_OK(ret, "test_libbpf_get_fd_opts__attach"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
+		goto close_prog;
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id(info_m.id);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, NULL);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, &fd_opts_rdonly);
+	if (!ASSERT_GE(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Map lookup should work with read-only fd. */
+	ret = bpf_map_lookup_elem(fd, &zero, &value);
+	if (!ASSERT_OK(ret, "bpf_map_lookup_elem"))
+		goto close_prog;
+
+	if (!ASSERT_EQ(value, 0, "map value mismatch"))
+		goto close_prog;
+
+	/* Map update should not work with read-only fd. */
+	ret = bpf_map_update_elem(fd, &zero, &len, BPF_ANY);
+	if (!ASSERT_LT(ret, 0, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Map update through map iterator should not work with read-only fd. */
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.map.map_fd = fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(skel->progs.write_bpf_array_map, &opts);
+	if (!ASSERT_ERR_PTR(link, "bpf_program__attach_iter")) {
+		/*
+		 * Faulty path, this should never happen if fd modes check is
+		 * added for map iterators.
+		 */
+		iter_fd = bpf_iter_create(bpf_link__fd(link));
+		bpf_link__destroy(link);
+
+		if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create (faulty path)"))
+			goto close_prog;
+
+		read(iter_fd, buf, sizeof(buf));
+		close(iter_fd);
+
+		ret = bpf_map_lookup_elem(fd, &zero, &value);
+		if (!ASSERT_OK(ret, "bpf_map_lookup_elem (faulty path)"))
+			goto close_prog;
+
+		if (!ASSERT_EQ(value, 5,
+			       "unauthorized map update (faulty path)"))
+			goto close_prog;
+	}
+
+	/* Map update should work with read-write fd. */
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &len, BPF_ANY);
+	if (!ASSERT_OK(ret, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Map update through map iterator should work with read-write fd. */
+	linfo.map.map_fd = bpf_map__fd(map);
+	link = bpf_program__attach_iter(skel->progs.write_bpf_array_map, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
+		goto close_prog;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	bpf_link__destroy(link);
+
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto close_prog;
+
+	read(iter_fd, buf, sizeof(buf));
+	close(iter_fd);
+
+	ret = bpf_map_lookup_elem(fd, &zero, &value);
+	if (!ASSERT_OK(ret, "bpf_map_lookup_elem"))
+		goto close_prog;
+
+	if (!ASSERT_EQ(value, 5, "map value mismatch"))
+		goto close_prog;
+
+	/* Prog get fd with opts set should not work (no kernel support). */
+	ret = bpf_prog_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_prog_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Link get fd with opts set should not work (no kernel support). */
+	ret = bpf_link_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_link_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* BTF get fd with opts set should not work (no kernel support). */
+	ret = bpf_btf_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	ASSERT_EQ(ret, -EINVAL, "bpf_btf_get_fd_by_id_opts");
+
+close_prog:
+	close(fd);
+	test_libbpf_get_fd_opts__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c
new file mode 100644
index 000000000000..83366024023f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* From include/linux/mm.h. */
+#define FMODE_WRITE	0x2
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm/bpf_map")
+int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
+{
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	if (fmode & FMODE_WRITE)
+		return -EACCES;
+
+	return 0;
+}
+
+SEC("iter/bpf_map_elem")
+int write_bpf_array_map(struct bpf_iter__bpf_map_elem *ctx)
+{
+	u32 *key = ctx->key;
+	u32 *val = ctx->value;
+
+	if (key == NULL || val == NULL)
+		return 0;
+
+	*val = 5;
+	return 0;
+}
-- 
2.25.1

