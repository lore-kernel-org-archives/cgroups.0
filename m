Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B604D47ACE6
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 12:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806795; cv=none; b=Yz04P/L708bI6RNwMhevfjee8WKH7z+bfJBC6wMRuPOMD0ChJB3dFQ/FdvdyRtYHcedevVyeFEi2PUBMRdXWyyPCKi/YvaGVghRVUtnkQVAhf0OORCgwW1p3u0qdtBSTybg835rl0zSO1bkZeA57F1+3AmQbJe8jG62X9uNzFhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806795; c=relaxed/simple;
	bh=a3t9J4KhhuluYeHnkyUEnJaoH/t0rZuNGK4OciI2mfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzMZr+nUEpCL6Kg03FPV8S/1XUY4ELBBhZq4MRsFPK8X84elmuDXMVlo37toxJhgU4LsR5CR8CC1cPWBwpwXuL97KIXgH2mXIHJxpjHugoECRo79JLNn0n45QiPW3DWr0eKMMKThOgyEDfIcvmY9oR1pG/mMICj948qeY6VXfvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qu7xCNQu; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qu7xCNQu"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so1532174a91.3
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806790; x=1792411590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hy+eARgrFpDT0ZhRfOHwtN1niTEnWD5P7Xvkvc+A7GA=;
        b=qu7xCNQuZxg7HnZm7MZ5SyGTFeHWXbZUK2V+xehWTo6sw6xZwvT4nj9i8fu7GiDrFk
         ISxM3ESThnlH4om3Y/kop1iZwqe5Lop+bnfNbOKyrdOa4j7qL3gIYRjnIE/ta5dwDISI
         BNOYnPPBnXn3sQlD2w5Dza5Lvk8nld1T7UogXLvsUju48NhJLfqax6bwreWG9kTNvlTp
         CQR3ltoD769f5ajYqnZ9eEgmFKNO1HL7Ljt8sqXuK7NDFTTS9DJozzMIscwFhEFl2lLg
         Rgd4kxZLirAySfbL6dhVwoiy1T+NJ1o3RLxDqU725jEQDT8Lcepw0XygMB0ewdg20Iz1
         h9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806790; x=1792411590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hy+eARgrFpDT0ZhRfOHwtN1niTEnWD5P7Xvkvc+A7GA=;
        b=IOlpbfRCd3EcYLxGIuCF2zb1iD+BHrBNMZ9sCJGFRGEFH9cAIZPjq9W2XF9Bv1ltgp
         2QhJsBkz0WmArAPpNbiWUXsnZvo/wZOBNKA1KwlEoPnx9vFyzCTh0X9sdQrWCkmhdPL2
         m86WW9PiC6anNWeKDZE+/OfxkEdQNmDIbnnFsDm2HfX8pgOWFxl9XzBcgH2S9VBfCl7b
         UL4kyejwd7r1VYzr7CxR8y+lD5sQj1WTFarqfQl1z39ytOS5nFl+rH+RyZc+Z5KPM2ic
         fnuFfchJGExJfHIEWJuScBEwTLmPa1hBDqUnVWeABWiBtAfrK2CetV402G1PVPrKNdA6
         OjOQ==
X-Forwarded-Encrypted: i=1; AKwUvBy67PEHJC27zIbXCMSeOagn9j04Qz7XNcIb3rDi0v3TfoTx39SabfKSRSIrhIkzDaYFx7mx9XO8@vger.kernel.org
X-Gm-Message-State: AFq9FYKuuYVdNUdczyn48n7CObPOAZDHntOyyOAIwFLozFkuV9IJ91f5
	OadNB5h6+0rvXqeAW3BFGj6IK1M4khgaoKPVYIkz8gWsP/U3ModTiT3P
X-Gm-Gg: AYBFou1P34XG+xf1MkHpzv/z0TulvPzyaMGlmckeao328KHIntXRzqIABqRbw72xZAQ
	LnA2Ap8GLBxDdZfTiceHXE6nVyJNZgWUOy1gDaGf+sQ/5CJhV/cL7HXS7uXONqpw3D//YBxjo/H
	LEvDKOLYnydN4Eaene2kvjeSDjxuQvgsioidPNZA+f6pWrzkJXeRovoPwwK+cW7zrETaX9R7opf
	pvK/9Ls+dCE1UhZTTRWlgAdcGLrFwGjiqF2N/MpK/X/p7UDJkx+CLiWQC4pn65zb9M3sELO6Cj9
	kD75mci8+A74JS6VPkq2Z5ne5I8UBUAYp6Edh8PcZHAVCBRVUrkrF5ey8QpX/hNjF0e2hRnMtc8
	fgsPg/pXKKtcTEy4lTsygb7QNOriAM32qiOI4XbdHIG+L+k9rt3l4MAQBGV0NG7cHDp6URNdA2b
	BKrItsUDMgcv2l7eX2/ecZKHgv1r7bZ9/WqMH+DrVZMBK+EmSj0ztpZiCsOTWAfrmuy3we64aJy
	e9Fs/XvEr0AZvZmhkGWGUCwgNorosBC5CmgSk1fGZ0j85pZyOyMZDEJ
X-Received: by 2002:a17:90b:5444:b0:3a7:9ad9:68e1 with SMTP id 98e67ed59e1d1-3ab3a735fddmr8030646a91.13.1791806789634;
        Mon, 12 Oct 2026 05:06:29 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.06.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:06:29 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v2 3/3] selftests/bpf: add tests for the bpf_numab_ops struct_ops
Date: Mon, 12 Oct 2026 20:04:38 +0800
Message-ID: <20261012120438.52849-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Five cases:
- attach/detach with counter proof
- hierarchy aggregation
- multi-policy combination
- inheritance
- a surface-dispatching policy

Assisted-by: LLM
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_numab_ops.c  | 250 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_numab_ops.c       |  57 ++++
 2 files changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab_ops.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c b/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
new file mode 100644
index 000000000000..3e5dac8e3131
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <time.h>
+#include "cgroup_helpers.h"
+#include "bpf_numab_ops.skel.h"
+
+#define CGROUP_PATH	"/bpf_numab_ops"
+#define CHILD_PATH	CGROUP_PATH "/child"
+
+/*
+ * task_tick_fair() consults the per-cgroup NUMA balancing policy on every
+ * tick of a running task, so a short busy loop is enough to prove that the
+ * hook runs. This works regardless of the global numa_balancing sysctl
+ * state and regardless of the machine's NUMA topology: both the enabled
+ * and disabled code paths end up calling every attached policy.
+ */
+static void burn_cpu_ms(int ms)
+{
+	struct timespec now;
+	u64 deadline;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	deadline = now.tv_sec * 1000ULL + now.tv_nsec / 1000000ULL + ms;
+
+	do {
+		clock_gettime(CLOCK_MONOTONIC, &now);
+	} while (now.tv_sec * 1000ULL + now.tv_nsec / 1000000ULL < deadline);
+}
+
+static void test_attach_detach(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link = NULL;
+	int cgroup_fd, before;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					   cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link, "attach_enable_ops"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt");
+
+	/*
+	 * Detach and let a grace period pass so that no reader is still
+	 * walking the old effective array, then verify the hook stopped
+	 * running.
+	 */
+	before = skel->bss->enable_cnt;
+	bpf_link__destroy(link);
+	link = NULL;
+	sleep(1);
+	burn_cpu_ms(300);
+	ASSERT_EQ(skel->bss->enable_cnt, before, "enable_cnt_after_detach");
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * Attach to the parent cgroup while the task lives in the child: the
+ * child's effective array must aggregate the parent's policy.
+ */
+static void test_hierarchy(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *plink = NULL;
+	int parent_fd, child_fd = -1;
+
+	parent_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_parent_cgroup"))
+		return;
+
+	child_fd = create_and_get_cgroup(CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup;
+
+	if (!ASSERT_OK(join_cgroup(CHILD_PATH), "join_child_cgroup"))
+		goto cleanup;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	plink = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    parent_fd, NULL);
+	if (!ASSERT_OK_PTR(plink, "attach_to_parent"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt_from_parent_policy");
+
+cleanup:
+	bpf_link__destroy(plink);
+	bpf_numab_ops__destroy(skel);
+	if (child_fd >= 0) {
+		close(child_fd);
+		join_cgroup(CGROUP_PATH);
+		remove_cgroup(CHILD_PATH);
+	}
+	close(parent_fd);
+}
+
+/*
+ * Attach two policies to the same cgroup. Both must run: the kernel
+ * combines what they return.
+ */
+static void test_multi(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link1 = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link1, "attach_enable_ops"))
+		goto cleanup;
+
+	link2 = bpf_map__attach_cgroup_opts(skel->maps.numab_disable_ops,
+					    cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link2, "attach_disable_ops"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	skel->bss->disable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt");
+	ASSERT_GT(skel->bss->disable_cnt, 0, "disable_cnt");
+
+cleanup:
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link1);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * Attach to the parent first, then create and join the child cgroup. The
+ * child must inherit the parent's effective array via cgroup_bpf_inherit().
+ */
+static void test_inherit(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *plink = NULL;
+	int parent_fd, child_fd = -1;
+
+	parent_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_parent_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	plink = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    parent_fd, NULL);
+	if (!ASSERT_OK_PTR(plink, "attach_to_parent"))
+		goto cleanup;
+
+	child_fd = create_and_get_cgroup(CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup;
+
+	if (!ASSERT_OK(join_cgroup(CHILD_PATH), "join_child_cgroup"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt_inherited");
+
+cleanup:
+	bpf_link__destroy(plink);
+	bpf_numab_ops__destroy(skel);
+	if (child_fd >= 0) {
+		close(child_fd);
+		join_cgroup(CGROUP_PATH);
+		remove_cgroup(CHILD_PATH);
+	}
+	close(parent_fd);
+}
+
+/*
+ * A surface-dispatching policy must load, attach and run from the task
+ * surface.  The folio surface runs from the scanner and fault paths,
+ * which need a scan pass and foreign-node folios to consult, so folio_cnt
+ * is left for debugging rather than asserted here.
+ */
+static void test_mixed(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link = NULL;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link = bpf_map__attach_cgroup_opts(skel->maps.numab_mixed_ops,
+					   cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link, "attach_mixed_ops"))
+		goto cleanup;
+
+	skel->bss->task_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->task_cnt, 0, "task_cnt");
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+void serial_test_bpf_numab_ops(void)
+{
+	if (test__start_subtest("attach_detach"))
+		test_attach_detach();
+	if (test__start_subtest("hierarchy"))
+		test_hierarchy();
+	if (test__start_subtest("multi"))
+		test_multi();
+	if (test__start_subtest("mixed"))
+		test_mixed();
+	if (test__start_subtest("inherit"))
+		test_inherit();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_numab_ops.c b/tools/testing/selftests/bpf/progs/bpf_numab_ops.c
new file mode 100644
index 000000000000..c9abff2cd694
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_numab_ops.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* Counters, bumped from the NUMA balancing hot paths. */
+int enable_cnt;
+int disable_cnt;
+int task_cnt;
+int folio_cnt;
+
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_enable, struct task_struct *p, struct folio *folio)
+{
+	__sync_fetch_and_add(&enable_cnt, 1);
+	return BPF_NUMAB_NORMAL;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_enable_ops = {
+	.numab_mode = (void *)numab_mode_enable,
+};
+
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_disable, struct task_struct *p, struct folio *folio)
+{
+	__sync_fetch_and_add(&disable_cnt, 1);
+	return BPF_NUMAB_DISABLED;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_disable_ops = {
+	.numab_mode = (void *)numab_mode_disable,
+};
+
+/*
+ * A surface-dispatching policy: exactly one of @p and @folio is set, so
+ * the prog answers the task surface and the memory surface separately.
+ */
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_mixed, struct task_struct *p, struct folio *folio)
+{
+	if (p) {
+		__sync_fetch_and_add(&task_cnt, 1);
+		return BPF_NUMAB_NORMAL;
+	}
+	__sync_fetch_and_add(&folio_cnt, 1);
+	return BPF_NUMAB_TIERING;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_mixed_ops = {
+	.numab_mode = (void *)numab_mode_mixed,
+};
+
+char _license[] SEC("license") = "GPL";
-- 
2.52.0

