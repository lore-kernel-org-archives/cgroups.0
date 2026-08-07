Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7853B14C6
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086288; cv=none; b=EexXuQMSM6of+ToTlDJml82i0X6AnPRZJ8xejnmch3UHCgtOqTYofvwDKk3icm2C9WHvZ+M/Bpq4+jEdcOZZb3XknM7fJOFyvewShLmoebaLTtqZ4pHBqSEKdU5/a6+yOiI2bRVLKQbD2u2zQjy/4GtjN+RmBH+nipIfpaCNm1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086288; c=relaxed/simple;
	bh=2WN46265SKpK2rl2uMXTMHPazwKb6f8Kq0navi7/mq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwlxugGDyY7kRXsU4zjJ0UELiOIAIOCvB++cE+JeTALhERlLO0wwOQURyOIv0KIX7JdeloYpjX+EVk1/bo0l/X8VGCQ42pW3N28UdqH7OAnEA2rF5sNy0BNl7U1H6WX6wkIwxhkhDnc4dVz8DVkoRNakJQC5kgGMILZi+w8ZbQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R4jLkR7u; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R4jLkR7u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4imcAAhgfmNN33DZhnb7eyN3kSA/23VjOaNJH4+P0vE=;
	b=R4jLkR7uFCNAhm3lER2deyMdH3S+uXKbLxFoOPZIqX2eX5zHA7CxUySSg/XrzSov18URDH
	uQpR3CRzj6yEGJ3ejVJyIqpYvfd7RcatF3T/ZvVh6P4d5+buh0vwN6FQkz/OT4+NvfT5Mf
	IMj5wbNe6hw9p2bBhzmD0oEDeKOFXvA=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 3/4] selftests/bpf: add thread_wq cgroup test
Date: Fri,  7 Aug 2026 15:04:11 +0800
Message-ID: <dbc676924bb41d1e943df252460e5068a4cf71ad.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

Add test cases for bpf_thread_wq with cgroup attachment:

- Test thread_wq execution in a specified cgroup and verify
  callback runs in the target cgroup
- Test thread_wq execution without cgroup attachment and verify
  callback runs in a different cgroup

This validates that bpf_thread_wq properly attaches to and
executes callbacks within the specified cgroup context.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/thread_wq_cgroup.c         | 87 +++++++++++++++++++
 .../selftests/bpf/progs/thread_wq_cgroup.c    | 56 ++++++++++++
 2 files changed, 143 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/thread_wq_cgroup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c b/tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c
new file mode 100644
index 000000000000..7537b03f17e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thread_wq_cgroup.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <unistd.h>
+#include "cgroup_helpers.h"
+#include "thread_wq_cgroup.skel.h"
+
+#define TEST_CGROUP "/thread_wq_test"
+#define WAIT_TIMEOUT_SECS 30
+
+void test_thread_wq_cgroup(void)
+{
+	struct thread_wq_cgroup *skel = NULL;
+	int err, prog_fd, cg_fd = -1;
+	unsigned long long cg_id;
+	int waited_secs;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "setup_cgroup_environment"))
+		return;
+	cg_fd = create_and_get_cgroup(TEST_CGROUP);
+	if (!ASSERT_GE(cg_fd, 0, "create_and_get_cgroup"))
+		goto cleanup;
+	cg_id = get_cgroup_id(TEST_CGROUP);
+	if (!ASSERT_GT(cg_id, 0ULL, "get_cgroup_id"))
+		goto cleanup;
+
+	skel = thread_wq_cgroup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.start_thread_wq);
+
+	/* Run bpf_thread_wq in the specified cgroup. */
+	skel->bss->test_key = 0;
+	skel->bss->target_cgroup_id = cg_id;
+	skel->bss->callback_cgroup_id = 0;
+	skel->bss->twq_done = 0;
+	if (!ASSERT_OK(bpf_prog_test_run_opts(prog_fd, &topts),
+		       "bpf_prog_test_run_opts in cgroup"))
+		goto cleanup;
+	if (!ASSERT_OK(topts.retval, "retval in cgroup"))
+		goto cleanup;
+	for (waited_secs = 0; waited_secs < WAIT_TIMEOUT_SECS; waited_secs++) {
+		if (skel->bss->twq_done)
+			break;
+		sleep(1);
+	}
+	if (!ASSERT_TRUE(skel->bss->twq_done, "twq_done in cgroup"))
+		goto cleanup;
+	if (!ASSERT_EQ(skel->bss->callback_cgroup_id, cg_id,
+		       "callback_cgroup_id in cgroup"))
+		goto cleanup;
+
+	/* Run bpf_thread_wq without cgroup attachment (cgroup_id = 0). */
+	LIBBPF_OPTS_RESET(topts);
+	skel->bss->test_key = 1;
+	skel->bss->target_cgroup_id = 0;
+	skel->bss->callback_cgroup_id = 0;
+	skel->bss->twq_done = 0;
+	if (!ASSERT_OK(bpf_prog_test_run_opts(prog_fd, &topts),
+		       "bpf_prog_test_run_opts without cgroup"))
+		goto cleanup;
+	if (!ASSERT_OK(topts.retval, "retval without cgroup"))
+		goto cleanup;
+	for (waited_secs = 0; waited_secs < WAIT_TIMEOUT_SECS; waited_secs++) {
+		if (skel->bss->twq_done)
+			break;
+		sleep(1);
+	}
+	if (!ASSERT_TRUE(skel->bss->twq_done, "twq_done without cgroup"))
+		goto cleanup;
+	if (!ASSERT_NEQ(skel->bss->callback_cgroup_id, cg_id,
+			"callback_cgroup_id without cgroup"))
+		goto cleanup;
+
+cleanup:
+	if (skel) {
+		thread_wq_cgroup__destroy(skel);
+		/* Wait thread_wq kthread quit. */
+		sleep(2);
+	}
+	if (cg_fd >= 0)
+		close(cg_fd);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/thread_wq_cgroup.c b/tools/testing/selftests/bpf/progs/thread_wq_cgroup.c
new file mode 100644
index 000000000000..c70a37f55397
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/thread_wq_cgroup.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 */
+
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct elem {
+	struct bpf_thread_wq twq;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, struct elem);
+} map_arr SEC(".maps");
+
+__u64 target_cgroup_id;
+__u64 callback_cgroup_id;
+int twq_done;
+int test_key;
+
+static int twq_callback(void *map, int *key, void *value)
+{
+	callback_cgroup_id = bpf_get_current_cgroup_id();
+	twq_done = 1;
+	return 0;
+}
+
+SEC("syscall")
+int start_thread_wq(void *ctx)
+{
+	struct elem *val;
+	int key = test_key;
+	int ret;
+
+	val = bpf_map_lookup_elem(&map_arr, &key);
+	if (!val)
+		return -1;
+
+	ret = bpf_thread_wq_init(&val->twq, &map_arr, target_cgroup_id, 0);
+	if (ret)
+		goto out;
+
+	ret = bpf_thread_wq_set_callback(&val->twq, twq_callback, 0);
+	if (ret)
+		goto out;
+
+	ret = bpf_thread_wq_start(&val->twq, 0);
+
+out:
+	return ret;
+}
-- 
2.53.0

