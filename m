Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793092386;
	b=uuxmdctGKjc5LwS50sPFouWQpc/X7o2QtiAqss0PnnsKIqGo710pbw+rUg6nEdo+aMZM
	 zq9RkED9JKUU+QkKb7CQarluJbb1oRYiU5QoLww524yMB3UumKtZLKBwprex0AJmBT6KD
	 GZAqSv2ruvUgxjbIU2eDn8f1elSMUqyw2MmNFco/q2T1vV2nSf28Av7g2+fCk97T2CJS6
	 erUc/m3qt2qHlYVntFU+vSvmJydE8HDzUplGxfobOW2XdtDadZ+NnuQCQEIbl40Q2j/87
	 RGkS3mNOj9xqSv1sC7qEJUchlYYFNye/RNF+aMPIab6a3SYpaqa2CBNFHc8uMXZZ6bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092386;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zrNPQA98bso1gIF7bLBSbmMuWs6Q/3EJgOF5OyGhH8U=;
	b=vGzeFS2QIv6d1737WbGbHHnwxblJr+f5NfOhZQ6etULdeCGYJL61NhOYhJ0+oQ/JDHuC
	 WSwWQrYWEisOfrIX46dgbCfupu8g9/7aC/c4WDp+eOwpWgr42HemdC1gtyJWUGoPMbsoJ
	 dj1+Qz0l29XYKB40ZVSe8g6w6IeNIJBuk+XALhZgm/upiKO5eYQpc1ixMT1ricNUDvIOY
	 BdESZn0kQ00qgc4akcLEyR65hvZ/D21YCw+MYw4WimzW9k42lcPYTQwBVhLxDtp3YqBWn
	 IRhy85ulg4oWec2c13TtvV3JTWkVwBKEFUz7tGpt7+Pu78kR1qJm3vsZBfK44FW/NWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XR5IVBBH;
	arc=none smtp.remote-ip=95.215.58.126
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0495A606A31B
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 09:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0495A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XR5IVBBH
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gNw6rX3/dhh2H6vbjInMfVwRCNgPnsLDs4wpnXgzlr4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793092383; v=1; x=1793697183;
 b=XR5IVBBH3CCS16zN9omJhYlq4okJH3aYsvQwPhQEnEdSV05zuzIvYIMYpB1r4hqa8fNT13pG
 45MqKW7WU+Dl06tgS9xo+cssEJ4eZsqOcJrsMvy+SouhFKrz+1bHgzhElhYhbYWDx6jQg66MOmD
 xuG5tGgGq5QuuhE6D5rxU/lo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 348395f4de271727;
	Tue, 27 Oct 2026 09:13:02 +0000
X-Mizu-Trace-ID: 348395f4de271727
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
	JP Kobryn <jp.kobryn@linux.dev>,
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
Subject: [RFC PATCH 2/2] selftests/bpf: Add bpf_memcg_ops protection test
Date: Tue, 27 Oct 2026 17:12:00 +0800
Message-ID: <a5c4feb51ff6557f7423315259fd3482be3879ee.1793086858.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1793086858.git.zhuhui@kylinos.cn>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hui Zhu <zhuhui@kylinos.cn>

low_policy and min_policy are asked after the kernel compares a cgroup's
own memory.low/min, so a policy can protect a cgroup that carries
neither.  Attach both to a child cgroup, fault 8M of anonymous memory
into it and reclaim from its parent.  Check that the kernel consulted
both hooks and that the ctx named the child, the parent as the reclaim
target, a zero threshold and a nonzero usage.  Without swap nothing is
reclaimed and the write returns EAGAIN, but every scan still consulted
the hooks; both policies answer NO_OPINION, so the outcome is not
asserted.

The counters are filtered by cgroup id: attaching any policy turns the
dispatcher on for every memcg, so background reclaim would otherwise
move them too.

A full example of answering BELOW so that reclaim skips a cgroup and
takes the memory from a sibling is maintained out of tree at [1],
released under GPLv2.

[1] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_plus

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/memcg_ops_protection.c     | 151 ++++++++++++++++++
 .../bpf/progs/memcg_ops_protection.c          |  72 +++++++++
 2 files changed, 223 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_protection.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
new file mode 100644
index 000000000000..8ad47bffb42d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops_protection.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Drive the memcg_ops_protection sample: check that the kernel consults
+ * min_policy and low_policy during reclaim, and that the ctx they receive
+ * describes the check faithfully.  The policies themselves always say
+ * NO_OPINION, so nothing about reclaim's outcome changes.
+ *
+ * Layout, under the test workdir:
+ *
+ *   memcg_ops_prot           P   reclaim runs from P/memory.reclaim
+ *   memcg_ops_prot/victim    C   holds the memory, carries the ops
+ *   memcg_ops_prot_ctl       -   where the test process normally sits
+ *
+ * The test process joins C itself and faults in 8M of anonymous memory:
+ * C's usage above its zero emin/elow is exactly what makes the kernel ask
+ * the hooks.  Nothing is actually reclaimed -- without swap there is
+ * nothing to take -- so the write returns EAGAIN after seventeen full
+ * scans, and every one of them consulted the hooks.  No file is involved
+ * on purpose: a VM's working directory is often a shared mount where
+ * temporary files are unsupported or unevictable.  On the way out the
+ * process rejoins the ctl cgroup, so the framework's cleanup can rmdir
+ * C and P.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include <bpf/libbpf.h>
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "memcg_ops_protection.skel.h"
+
+#define CTL_PATH	"/memcg_ops_prot_ctl"
+#define PARENT_PATH	"/memcg_ops_prot"
+#define VICTIM_PATH	PARENT_PATH "/victim"
+
+#define FILL_SZ		(8UL << 20)
+#define RECLAIM_SZ	"1M"
+
+void test_memcg_ops_protection(void)
+{
+	struct memcg_ops_protection *skel = NULL;
+	struct bpf_link *ops_link = NULL;
+	int ctlfd = -1, pfd = -1, cfd = -1, rfd;
+	void *mem = MAP_FAILED;
+	ssize_t n;
+	int err;
+
+	/* Sets the environment up and parks this process outside of P. */
+	ctlfd = test__join_cgroup(CTL_PATH);
+	if (!ASSERT_GE(ctlfd, 0, "join_cgroup"))
+		return;
+
+	pfd = create_and_get_cgroup(PARENT_PATH);
+	if (!ASSERT_GE(pfd, 0, "create_parent"))
+		goto done;
+
+	/*
+	 * The victim's memory.* files need the memory controller in P's
+	 * subtree_control.  A failure here is the usual "v1 still owns
+	 * memory", which is a skip rather than a fail.
+	 */
+	if (enable_controllers(PARENT_PATH, "memory")) {
+		fprintf(stderr, "no memory controller under %s\n", PARENT_PATH);
+		test__skip();
+		goto done;
+	}
+
+	cfd = create_and_get_cgroup(VICTIM_PATH);
+	if (!ASSERT_GE(cfd, 0, "create_victim"))
+		goto done;
+
+	skel = memcg_ops_protection__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto done;
+
+	skel->bss->target_cgroup_id = get_cgroup_id(VICTIM_PATH);
+	skel->bss->parent_cgroup_id = get_cgroup_id(PARENT_PATH);
+	if (!ASSERT_NEQ(skel->bss->target_cgroup_id, 0ULL, "victim_id"))
+		goto done;
+	if (!ASSERT_NEQ(skel->bss->parent_cgroup_id, 0ULL, "parent_id"))
+		goto done;
+
+	if (!ASSERT_OK(memcg_ops_protection__load(skel), "load"))
+		goto done;
+
+	ops_link = bpf_map__attach_cgroup_opts(skel->maps.prot_ops, cfd, NULL);
+	if (!ASSERT_OK_PTR(ops_link, "attach_ops"))
+		goto done;
+
+	/* From here on the test process lives in C; leave via done. */
+	if (!ASSERT_OK(join_cgroup(VICTIM_PATH), "join_victim"))
+		goto done;
+
+	mem = mmap(NULL, FILL_SZ, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (!ASSERT_TRUE(mem != MAP_FAILED, "mmap"))
+		goto done;
+	memset(mem, 0xa5, FILL_SZ);
+
+	/* The trigger.  EAGAIN is as good a scan as success. */
+	rfd = openat(pfd, "memory.reclaim", O_RDWR);
+	if (!ASSERT_GE(rfd, 0, "open_reclaim"))
+		goto done;
+	n = write(rfd, RECLAIM_SZ, sizeof(RECLAIM_SZ) - 1);
+	err = n < 0 ? -errno : 0;
+	close(rfd);
+	if (!ASSERT_TRUE(err == 0 || err == -EAGAIN, "reclaim_trigger"))
+		goto done;
+
+	/* Both hooks run for one unprotected cgroup in one scan. */
+	if (!ASSERT_GT(skel->bss->min_calls, 0ULL, "min_calls"))
+		goto done;
+	if (!ASSERT_GT(skel->bss->low_calls, 0ULL, "low_calls"))
+		goto done;
+
+	/* The victim has no memory.min/low, and it is not empty. */
+	if (!ASSERT_EQ(skel->bss->seen_min_threshold, 0ULL, "emin"))
+		goto done;
+	if (!ASSERT_GT(skel->bss->seen_min_usage, 0ULL, "min_usage"))
+		goto done;
+	if (!ASSERT_EQ(skel->bss->seen_low_threshold, 0ULL, "elow"))
+		goto done;
+	if (!ASSERT_GT(skel->bss->seen_low_usage, 0ULL, "low_usage"))
+		goto done;
+
+	/* The reclaim came from P, and the ctx said so. */
+	if (!ASSERT_EQ(skel->bss->saw_min_from_parent, 1, "min_target"))
+		goto done;
+	ASSERT_EQ(skel->bss->saw_low_from_parent, 1, "low_target");
+
+done:
+	/* Detach before anything else: no policy may run during teardown. */
+	bpf_link__destroy(ops_link);
+	memcg_ops_protection__destroy(skel);
+	if (mem != MAP_FAILED)
+		munmap(mem, FILL_SZ);
+	/* A no-op when the process never made it into the victim. */
+	join_cgroup(CTL_PATH);
+	if (cfd >= 0)
+		close(cfd);
+	if (pfd >= 0)
+		close(pfd);
+	if (ctlfd >= 0)
+		close(ctlfd);
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_ops_protection.c b/tools/testing/selftests/bpf/progs/memcg_ops_protection.c
new file mode 100644
index 000000000000..0288e3ca7858
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_ops_protection.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Watch the memory.low / memory.min policy hooks for the
+ * memcg_ops_protection runner: count the consultations about the victim
+ * cgroup and snapshot what the ctx carries.  Both members always say
+ * NO_OPINION, so the kernel's own comparison decides and reclaim stays
+ * free to take the cache; the runner only checks that the hooks ran and
+ * saw sane values.
+ *
+ * The counters are victim-scoped on purpose: once any policy is attached
+ * the dispatcher runs for every memcg, and background reclaim of unrelated
+ * cgroups would otherwise drown the signal in noise.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* Set by the runner between open and load. */
+__u64 target_cgroup_id;
+__u64 parent_cgroup_id;
+
+/* How often the kernel consulted us about the victim. */
+__u64 min_calls;
+__u64 low_calls;
+
+/* Last victim-scoped snapshot, for checking what the ctx carries. */
+__u64 seen_min_threshold;
+__u64 seen_min_usage;
+__u64 seen_low_threshold;
+__u64 seen_low_usage;
+int saw_min_from_parent;
+int saw_low_from_parent;
+
+/* BPF_PROG() uses "ctx" for the raw argument array, hence "mctx" here. */
+SEC("struct_ops")
+__u32 BPF_PROG(prot_min_policy, const struct bpf_memcg_prot_ctx *mctx)
+{
+	if (mctx->cgroup_id != target_cgroup_id)
+		return BPF_MEMCG_PROT_NO_OPINION;
+
+	__sync_fetch_and_add(&min_calls, 1);
+	seen_min_threshold = mctx->threshold;
+	seen_min_usage = mctx->usage;
+	if (mctx->target_cgroup_id == parent_cgroup_id)
+		saw_min_from_parent = 1;
+
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
+SEC("struct_ops")
+__u32 BPF_PROG(prot_low_policy, const struct bpf_memcg_prot_ctx *mctx)
+{
+	if (mctx->cgroup_id != target_cgroup_id)
+		return BPF_MEMCG_PROT_NO_OPINION;
+
+	__sync_fetch_and_add(&low_calls, 1);
+	seen_low_threshold = mctx->threshold;
+	seen_low_usage = mctx->usage;
+	if (mctx->target_cgroup_id == parent_cgroup_id)
+		saw_low_from_parent = 1;
+
+	return BPF_MEMCG_PROT_NO_OPINION;
+}
+
+SEC(".struct_ops.link")
+struct bpf_memcg_ops prot_ops = {
+	.low_policy = (void *)prot_low_policy,
+	.min_policy = (void *)prot_min_policy,
+};
-- 
2.43.0

