Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B984F7998
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656128; cv=none; b=EjQE/HDhS/L7llZ/DJ3AcEvyWUbwMcGc2kr4Sv5wybDI1SfP+kaoOvaTxAJzL937o0w3OqWRDVUbNjYF7vikWWvK6dGZJpSZ3oDTObCgiqK6SKgVAC8chv2lqdtHDA6cg+2GMOFrTVO5XU6KUeRawGwQvjF57UfZKIl5fl5zqkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656128; c=relaxed/simple;
	bh=vp2J4n0CbSrGTpuHrSDYdICgPaD/f9fPdyLRV/2i+Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI6iQkYOxPvx0Vh6nvw870GtwMve5eWNTgsZUrO1DQkhnofAxQY4MA4RpaY97l3xZ5HzU9UOXSRZMLeHynrGJTdN+c2VMuy1FXMAMgwU2z+SN/qIXlE81amtL6AcLr0Y8d6URVkcSyt0cTfVlsoKTfMVtEtwtkj0cBBwz+H4M7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QZxwMPJb; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZxwMPJb"
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-381072761d4so6523690a91.0
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 10:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656121; x=1785260921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AKxksonGf+ONkWkO5QIWgd6TDCo2B078e/Xr4EoxJss=;
        b=QZxwMPJbOmtByA0lssLtKg10RxRAPef/5LKxEAfDlsu39+yplZiFqhECr8iz9JmWtc
         sHQ4H8LxNTecSajJmfOOlQOQMVUoT5RAeyfLWQDj54o9ZjWgyFu/gPgVDXYefScpGv3W
         sNPJwDQqAgNVmMm/BUcGepqSf4EzUrdIpXnJ1iyQWweZSPn/xjHyYkIHWL4Q3L9LYmux
         GNmafpUm0LGSR0Vzqs/aL01VPrT16goZdKb4KhJN0HrqlfixozpaymlqTpMhH3kZb4Sh
         csREo0wjjLgqILoDuVSpq+S8rK1g8FFM56ZZe/sn+KA3CfCBIkL932s6rzRYXu5eRWyB
         zxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656121; x=1785260921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AKxksonGf+ONkWkO5QIWgd6TDCo2B078e/Xr4EoxJss=;
        b=mCoSPF3VqbMpx5GnCQD7+pv9Wwkju+3OYCCcrD6YoIQBChoeU//CDySbEZcE6/3bya
         pew2wA5tmbhdsiFbMp427KHN9GMvfFopdZFdOW2DAFJL2mRkp5L1e51KJ4TZfxiBdVyU
         Glwrr10qcwqCcJwlhFh1ccuSJKBoHnP5myqJK6la83piLllSzAshQWO5jyHRP8W5YE4J
         htuee/gT2brfnyBRafFi0WCpu2Kq4fz4yO+GyDDdTda1IKXNB0X3qeRuaZdToFv6bAKw
         GVCXp6uFWHTt4skMD7yIDpdgavSTBXnStKWR7WfiWMki9r29g2gnB5Bu+mJwbsiDFENE
         IkYA==
X-Forwarded-Encrypted: i=1; AHgh+RpLXvBGR4qEhxBV7R69yYyyV0ckkemt+WoLqpMaDBTqwNzoEI6z/3MpWtDMAAwnQUkvhcBuMOFQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzJX2ACSbL5jMTo0HxHtLM1myldCyCuXhGxaJH2wpUt+AjEaVtn
	AWF8AAUSwKY0nYrfDk1yPkw6TbqgZR10yy/OrDlIYsBOeIdIFhNpft4/
X-Gm-Gg: AR+sD13uwsYwRN4VmkjsG48dx5R8BOx30jp78GaYNVSn/BY+S+G9OHwkZAwP/BrSi/k
	sIXVfLDrmN8x79KZWIzTL1EDG1wQYHZA0EXreiTBYkkKIsUqU7Na8efMRIibHKfIct17eEmUwRR
	abx5kO9XIwhRmIoUNIVA9w7VW9nhhZCOTWnxdgkmKfdfAd4gDJTczICa+cUinnDb5lVm7h7kF4s
	JLwI28adQJplFtvJhl0rWnhOp/E6RPNSnSF6r57phpZCGymnURtllH4zpnbtGBdGgD7PKfjbfvt
	l8gwmVE0A6rBC5sicp039wlkr/rTbKSxpcw+o2x3P/xThsUvvCgzBwzhE4yuGhRsTVon4LNuxO/
	DpDrRFYTjRKnd2IZsXUqLrxdWZ5CgmZn+QPqA2dwMcwb+tHmo3U2lyu9OjC1KfS099cg9d2IM
X-Received: by 2002:a05:6a21:1404:b0:3c3:856e:dccd with SMTP id adf61e73a8af0-3c3ad7ec9camr21040818637.23.1784656121245;
        Tue, 21 Jul 2026 10:48:41 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e070538sm814778eec.20.2026.07.21.10.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:40 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
Date: Tue, 21 Jul 2026 10:48:31 -0700
Message-ID: <20260721174833.1232771-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721174833.1232771-1-ziyang.meme@gmail.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
return values that agree with what userspace reads from cgroupfs, across
a whole cgroup subtree that has been charged on many CPUs.

It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
only asserts each value is greater than zero, so it never checks that a
value is actually correct.  This test compares the kfunc values against
what userspace reads from memory.stat, and checks every node in the
cgroup tree.

Moreover, cgroup_iter_memcg does not exercise the rstat flush
(mem_cgroup_flush_stats()).  This test does: it launches a process on
each leaf that charges and holds memory across multiple CPUs (so the
leaf's rstat is dirty on K per-cpu trees), then confirms the flush works
for both the BPF and the file path by checking two properties:

  1. after the flush, each leaf's anon is at least what the process
     charged there;

  2. after the flush, the sum of the leaves' charged memory equals the
     amount at the root.

The BPF reader and the file reader run in two separate rounds.  Each
round builds the same cgroup tree from scratch and charges the same
amount of memory, so both rounds start from the same state and the
numbers are comparable.  In detail:

  - round 1 (BPF) builds the subtree, forks one child per leaf that
    charges the leaf across K CPUs and then blocks holding the charge,
    walks the tree with a SEC("iter.s/cgroup") program that flushes the
    subtree at the root and reads each cgroup via the memcg kfuncs
    (bpf_get_mem_cgroup, bpf_mem_cgroup_flush_stats,
    bpf_mem_cgroup_page_state, bpf_mem_cgroup_vm_events,
    bpf_put_mem_cgroup) into a hash map;

  - round 2 (cgroupfs) builds and charges an identical tree the same way,
    then reads every cgroup's memory.stat / memory.current from
    userspace.

The subtests differ in how many CPUs each leaf is charged on (a single
CPU or across K CPUs), and run on two cgroup tree sizes.  The charging
children pin CPUs and there is one per leaf, so the test is registered
serial.

The traditional path reads memory.stat / memory.current through a new
read_cgroup_file() helper added to cgroup_helpers (the read counterpart
of write_cgroup_file).  When the memcg kfuncs are unavailable
(CONFIG_MEMCG=n) the test skips cleanly; the base selftest config now
selects CONFIG_MEMCG=y.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/cgroup/.gitignore     |   6 +
 tools/testing/selftests/cgroup/Makefile       |  21 +
 tools/testing/selftests/cgroup/config         |   4 +
 .../selftests/cgroup/lib/cgroup_util.c        |  48 ++
 .../cgroup/lib/include/cgroup_util.h          |   1 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  86 ++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  27 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 780 ++++++++++++++++++
 8 files changed, 973 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..9e6616af832e 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -6,7 +6,13 @@ test_freezer
 test_hugetlb_memcg
 test_kill
 test_kmem
+test_memcg_stat_cross_cpu
 test_memcontrol
 test_pids
 test_zswap
 wait_inotify
+# Artifacts generated by lib.bpf.mk
+/tools
+*.bpf.o
+*.linked.o
+*.skel.h
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..daebd35aec79 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -14,14 +14,29 @@ TEST_GEN_PROGS += test_freezer
 TEST_GEN_PROGS += test_hugetlb_memcg
 TEST_GEN_PROGS += test_kill
 TEST_GEN_PROGS += test_kmem
+TEST_GEN_PROGS += test_memcg_stat_cross_cpu
 TEST_GEN_PROGS += test_memcontrol
 TEST_GEN_PROGS += test_pids
 TEST_GEN_PROGS += test_zswap
 
 LOCAL_HDRS += $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pidfd.h
 
+# test_memcg_stat_cross_cpu builds a BPF program + skeleton through lib.bpf.mk.
+# OVERRIDE_TARGETS suppresses lib.mk's default C link rule (re-supplied below);
+# it must be set before ../lib.mk is included.
+BPF_SRCS         := memcg_stat_cross_cpu.bpf.c
+OVERRIDE_TARGETS := 1
+
 include ../lib.mk
 include lib/libcgroup.mk
+include ../lib.bpf.mk
+
+# Re-supply the default C link rule that OVERRIDE_TARGETS removed, for the plain
+# cgroup tests.  test_memcg_stat_cross_cpu has its own recipe further below.
+LOCAL_HDRS += $(selfdir)/kselftest_harness.h $(selfdir)/kselftest.h
+$(OUTPUT)/%: %.c $(LOCAL_HDRS)
+	$(call msg,CC,,$@)
+	$(Q)$(LINK.c) $(filter-out $(LOCAL_HDRS),$^) $(LDLIBS) -o $@
 
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
@@ -33,3 +48,9 @@ $(OUTPUT)/test_kmem: $(LIBCGROUP_O)
 $(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
 $(OUTPUT)/test_pids: $(LIBCGROUP_O)
 $(OUTPUT)/test_zswap: $(LIBCGROUP_O)
+
+# test_memcg_stat_cross_cpu links cgroup_util and the generated BPF skeleton
+# against the in-tree static libbpf that lib.bpf.mk built.
+$(OUTPUT)/test_memcg_stat_cross_cpu: test_memcg_stat_cross_cpu.c \
+					$(BPF_SKELS) $(LIBCGROUP_O)
+	$(call bpf_link,$@,$< $(LIBCGROUP_O))
diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index 39f979690dd3..9457bf604b23 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -4,3 +4,7 @@ CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_MEMCG=y
 CONFIG_PAGE_COUNTER=y
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_CGROUP_BPF=y
+CONFIG_DEBUG_INFO_BTF=y
diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..3a30557855d3 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -54,6 +54,54 @@ ssize_t write_text(const char *path, char *buf, ssize_t len)
 	return len < 0 ? -errno : len;
 }
 
+/*
+ * cg_get_id - return the kernfs id of a cgroup directory
+ * @cgroup: absolute path to the cgroup directory
+ *
+ * Returns the cgroup's kernfs node id (cgrp->kn->id) -- the same value the
+ * kernel exposes to BPF as cgrp->kn->id and via bpf_get_current_cgroup_id().
+ * This is obtained from the cgroupfs file handle and is NOT the directory's
+ * st_ino.  Returns 0 (an invalid id) on failure.
+ */
+unsigned long long cg_get_id(const char *cgroup)
+{
+	union {
+		unsigned long long id;
+		unsigned char raw[8];
+	} handle;
+	struct file_handle *fhp, *fhp2;
+	int mount_id, fhsize, err;
+	unsigned long long ret = 0;
+
+	fhsize = sizeof(*fhp);
+	fhp = calloc(1, fhsize);
+	if (!fhp)
+		return 0;
+
+	/*
+	 * The probe call is expected to fail (EOVERFLOW) and report the real
+	 * handle size in fhp->handle_bytes; a cgroupfs handle is always 8 bytes.
+	 */
+	err = name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0);
+	if (err >= 0 || fhp->handle_bytes != 8)
+		goto out;
+
+	fhsize = sizeof(*fhp) + fhp->handle_bytes;
+	fhp2 = realloc(fhp, fhsize);
+	if (!fhp2)
+		goto out;
+	fhp = fhp2;
+
+	if (name_to_handle_at(AT_FDCWD, cgroup, fhp, &mount_id, 0) < 0)
+		goto out;
+
+	memcpy(handle.raw, fhp->f_handle, 8);
+	ret = handle.id;
+out:
+	free(fhp);
+	return ret;
+}
+
 char *cg_name(const char *root, const char *name)
 {
 	size_t len = strlen(root) + strlen(name) + 2;
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 8ebb2b4d4ec0..832fcefe60a4 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -54,6 +54,7 @@ extern ssize_t write_text(const char *path, char *buf, ssize_t len);
 extern int cg_find_controller_root(char *root, size_t len, const char *controller);
 extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
+extern unsigned long long cg_get_id(const char *cgroup);
 extern char *cg_name_indexed(const char *root, const char *name, int index);
 extern char *cg_control(const char *cgroup, const char *control);
 extern int cg_create(const char *cgroup);
diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
new file mode 100644
index 000000000000..3b8c716e8d01
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include "memcg_stat_cross_cpu.h"
+
+char _license[] SEC("license") = "GPL";
+
+/*
+ * Per-cgroup results, keyed by cgroup id.  The BPF-side id (cgrp->kn->id)
+ * equals the userspace get_cgroup_id() value, so the test can correlate map
+ * entries back to the cgroups it created.  max_entries is resized by userspace
+ * (bpf_map__set_max_entries) to the size of the subtree before load.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u64);
+	__type(value, struct memcg_stat_snapshot);
+} results SEC(".maps");
+
+/*
+ * Sleepable cgroup iterator: flush the subtree's rstat once at the root, then
+ * for every cgroup in the walked subtree read a fixed set of memcg statistics
+ * through the memcg kfuncs and stash them in the hash map for userspace to
+ * compare against memory.stat.
+ *
+ * The flush kfunc may sleep, hence SEC("iter.s/cgroup").
+ */
+SEC("iter.s/cgroup")
+int cgroup_memcg_stat_cross_cpu(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct memcg_stat_snapshot snap = {};
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	int idx_anon, idx_file, idx_shmem, idx_fmapped, idx_pgfault;
+	__u64 cg_id;
+
+	/*
+	 * DESCENDANTS_PRE ends with a terminal element where cgroup == NULL.
+	 * Return 0 (not 1) so the walk runs to completion.
+	 */
+	if (!cgrp)
+		return 0;
+
+	css = &cgrp->self;
+	memcg = bpf_get_mem_cgroup(css);
+	if (!memcg)
+		return 0;
+
+	/*
+	 * Flush once, at the subtree root -- the first element visited in
+	 * DESCENDANTS_PRE order (seq_num == 0).  css_rstat_flush() is
+	 * subtree-wide, so this one flush brings the whole walked subtree
+	 * up to date and every descendant read afterwards is accurate;
+	 * flushing again per-cgroup would only hit the no-op threshold gate.
+	 */
+	if (ctx->meta->seq_num == 0)
+		bpf_mem_cgroup_flush_stats(memcg);
+
+	cg_id = BPF_CORE_READ(cgrp, kn, id);
+	snap.cgroup_id = cg_id;
+
+	idx_anon = bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED);
+	idx_file = bpf_core_enum_value(enum node_stat_item, NR_FILE_PAGES);
+	idx_shmem = bpf_core_enum_value(enum node_stat_item, NR_SHMEM);
+	idx_fmapped = bpf_core_enum_value(enum node_stat_item, NR_FILE_MAPPED);
+	idx_pgfault = bpf_core_enum_value(enum vm_event_item, PGFAULT);
+
+	snap.anon = bpf_mem_cgroup_page_state(memcg, idx_anon);
+	snap.file = bpf_mem_cgroup_page_state(memcg, idx_file);
+	snap.shmem = bpf_mem_cgroup_page_state(memcg, idx_shmem);
+	snap.file_mapped = bpf_mem_cgroup_page_state(memcg, idx_fmapped);
+	snap.pgfault = bpf_mem_cgroup_vm_events(memcg, idx_pgfault);
+
+	/* page_counter fields need no kfunc; read them off the trusted ptr. */
+	snap.usage_pages = BPF_CORE_READ(memcg, memory.usage.counter);
+	snap.max_pages = BPF_CORE_READ(memcg, memory.max);
+
+	bpf_map_update_elem(&results, &cg_id, &snap, BPF_ANY);
+
+	bpf_put_mem_cgroup(memcg);
+	return 0;
+}
diff --git a/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
new file mode 100644
index 000000000000..1583cafdab7e
--- /dev/null
+++ b/tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#ifndef __MEMCG_STAT_CROSS_CPU_H
+#define __MEMCG_STAT_CROSS_CPU_H
+
+/*
+ * One per-cgroup snapshot, produced by the BPF cgroup iterator and read back
+ * from a BPF hash map keyed by cgroup id.  After the charge has quiesced the
+ * test compares every field against what userspace parses from
+ * memory.stat / memory.current / memory.max, so the two must agree.
+ *
+ * Page-state values are in bytes (already unit-scaled by the kernel), so they
+ * compare directly against memory.stat.  usage_pages / max_pages come straight
+ * off the page_counter and are in PAGES.
+ */
+struct memcg_stat_snapshot {
+	__u64 cgroup_id;
+	__u64 anon;		/* NR_ANON_MAPPED, bytes */
+	__u64 file;		/* NR_FILE_PAGES, bytes */
+	__u64 shmem;		/* NR_SHMEM, bytes */
+	__u64 file_mapped;	/* NR_FILE_MAPPED, bytes */
+	__u64 pgfault;		/* PGFAULT, count */
+	__u64 usage_pages;	/* page_counter memory.usage, in PAGES */
+	__u64 max_pages;	/* page_counter memory.max, in PAGES */
+};
+
+#endif /* __MEMCG_STAT_CROSS_CPU_H */
diff --git a/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
new file mode 100644
index 000000000000..673b3da467ba
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
@@ -0,0 +1,780 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+
+/*
+ * memcg_stat_cross_cpu
+ * ====================
+ * A memory-cgroup statistics correctness test.  It compares the memcg
+ * statistics read through the BPF memcg kfuncs against what userspace reads
+ * from memory.stat, over a whole cgroup tree that has been charged across many
+ * CPUs.  Where a plain kfunc smoke test only checks that a single cgroup's
+ * values are non-zero, this test checks the values are actually correct and
+ * that a cross-CPU rstat flush aggregates every per-CPU slice.
+ *
+ * The BPF reader and the file reader are run in two separate rounds, each on
+ * its own freshly built and charged tree:
+ *
+ *   round 1: build the subtree; fork one process per leaf that charges the leaf
+ *            across K CPUs and then blocks holding the charge; walk the tree
+ *            with a SEC("iter.s/cgroup") program that flushes and reads each
+ *            cgroup via the memcg kfuncs into a hash map; record one snapshot
+ *            per node; clean the tree.
+ *   round 2: build and charge an identical tree the same way, then read every
+ *            cgroup's memory.stat / memory.current from userspace.
+ *
+ * The correctness is ensured as follows: each leaf was charged a known amount
+ * of anon spread over K CPUs, so the flushed anon must be at least that amount,
+ * and the subtree root's recursive anon must equal the sum of the leaves' anon.
+ *
+ * The charging children are CPU-pinning and there is one per leaf.
+ */
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <sys/prctl.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "kselftest.h"
+#include "cgroup_util.h"
+#include "memcg_stat_cross_cpu.h"
+#include "memcg_stat_cross_cpu.skel.h"
+
+#define SUBTREE_NAME "mcg_xcpu"
+
+static char root[PATH_MAX];	/* cgroup2 mount root */
+static char *subtree_root;	/* <root>/mcg_xcpu, from cg_name() */
+
+struct cg_node {
+	char path[PATH_MAX];
+	__u64 id;
+	bool is_leaf;
+};
+
+/* Field subset parsed from memory.stat / memory.current. */
+struct file_snap {
+	__u64 anon, file, shmem, file_mapped, pgfault;
+	__u64 current;		/* memory.current, bytes */
+	__u64 max;		/* memory.max, bytes (valid unless max_is_max) */
+	bool max_is_max;
+};
+
+static long page_size;
+
+/* ---- allowed CPU set --------------------------------------------------- */
+
+static int *cpu_list; /* ids of the CPUs this process may run on */
+static int n_cpu; /* number of such CPUs */
+
+/*
+ * Collect the CPUs the test is allowed to run on.
+ * Bounded by CPU_SETSIZE (1024).
+ */
+static int collect_cpus(void)
+{
+	cpu_set_t set;
+	int i, want, n = 0;
+
+	CPU_ZERO(&set);
+	if (sched_getaffinity(0, sizeof(set), &set))
+		return -1;
+	want = CPU_COUNT(&set);
+	if (want <= 0)
+		return -1;
+	cpu_list = calloc(want, sizeof(*cpu_list));
+	if (!cpu_list)
+		return -1;
+	for (i = 0; i < CPU_SETSIZE && n < want; i++)
+		if (CPU_ISSET(i, &set))
+			cpu_list[n++] = i;
+	n_cpu = n;
+	return 0;
+}
+
+/* Pin the calling task to a single CPU. */
+static int pin_cpu(int cpu)
+{
+	cpu_set_t set;
+
+	CPU_ZERO(&set);
+	CPU_SET(cpu, &set);
+	return sched_setaffinity(0, sizeof(set), &set);
+}
+
+/* ---- tree construction ------------------------------------------------- */
+
+static struct cg_node *nodes;
+static int n_nodes;
+static int n_leaves;
+
+static int add_node(const char *path, bool is_leaf, int *keep_fd)
+{
+	if (cg_create(path))
+		return -1;
+	if (keep_fd) {
+		*keep_fd = open(path, O_RDONLY);
+		if (*keep_fd < 0)
+			return -1;
+	}
+
+	strncpy(nodes[n_nodes].path, path, sizeof(nodes[n_nodes].path) - 1);
+	nodes[n_nodes].path[sizeof(nodes[n_nodes].path) - 1] = '\0';
+	nodes[n_nodes].id = cg_get_id(path);
+	nodes[n_nodes].is_leaf = is_leaf;
+	if (is_leaf)
+		n_leaves++;
+	n_nodes++;
+	return 0;
+}
+
+/* Recursively create children of @path. @path must already exist and be recorded. */
+static int build_children(const char *path, int fanout, int depth)
+{
+	char child[PATH_MAX];
+	int i;
+
+	if (depth == 0)
+		return 0;
+
+	/* Enable memory on this interior node so its children get a memcg. */
+	if (cg_write(path, "cgroup.subtree_control", "+memory"))
+		return -1;
+
+	for (i = 0; i < fanout; i++) {
+		snprintf(child, sizeof(child), "%s/c%d", path, i);
+		if (add_node(child, depth == 1, NULL))
+			return -1;
+		if (build_children(child, fanout, depth - 1))
+			return -1;
+	}
+	return 0;
+}
+
+static size_t tree_capacity(int fanout, int depth)
+{
+	size_t total = 1, level = 1;
+	int d;
+
+	for (d = 0; d < depth; d++) {
+		level *= fanout;
+		total += level;
+	}
+	return total;
+}
+
+/* The tree is arranged in the DFS order within an array */
+static int build_tree(int fanout, int depth, int *root_fd)
+{
+	n_nodes = 0;
+	n_leaves = 0;
+	nodes = calloc(tree_capacity(fanout, depth), sizeof(*nodes));
+	if (!nodes)
+		return -1;
+
+	if (add_node(subtree_root, depth == 0, root_fd))
+		return -1;
+	return build_children(subtree_root, fanout, depth);
+}
+
+/* ---- cross-CPU charge (one pinning child per leaf) --------------------- */
+
+static pid_t *charger_pids;
+static int n_chargers;
+/* parent pid, for the children's PR_SET_PDEATHSIG race check */
+static pid_t test_pid;
+static int charge_ready[2] = { -1, -1 };	/* child -> parent "ready" barrier */
+static int charge_ctrl[2] = { -1, -1 };	/* parent -> child "exit" (close to signal) */
+
+/*
+ * One charging child, dedicated to a single leaf and spread over K CPUs.  It
+ * joins its leaf, maps a resident anon region, then faults the region in K
+ * slices, each on a different CPU, so this leaf's rstat ends up dirty on K
+ * per-cpu trees.  The region stays mapped, so the charge persists while the
+ * parent reads.  After signalling readiness the child blocks (holding the
+ * charge) until the parent closes the control pipe.  Never returns.
+ *
+ * @base is this child's starting index into cpu_list; its K CPUs are
+ * (base + 0..K-1) mod n_cpu.
+ */
+static void charger_child(const struct cg_node *leaf, int base, int k,
+			  size_t resident_bytes)
+{
+	size_t per, off;
+	char *region;
+	char c;
+	int j;
+
+	/*
+	 * If the parent dies without running the cleanup that closes the control
+	 * pipe -- e.g. a CI timeout SIGKILLs the whole test -- ask the kernel to
+	 * SIGKILL this child too, so it can never hang as an orphan holding a
+	 * charge.
+	 */
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	if (getppid() != test_pid)
+		_exit(0);
+
+	close(charge_ready[0]);
+	close(charge_ctrl[1]);
+
+	if (cg_enter_current(leaf->path))
+		_exit(1);
+
+	region = mmap(NULL, resident_bytes, PROT_READ | PROT_WRITE,
+		      MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (region == MAP_FAILED)
+		_exit(2);
+
+	/*
+	 * Fault the region in K slices, each on a different CPU, so the charge
+	 * for this leaf is scattered across K per-cpu rstat trees.  A correct
+	 * flush must gather all K slices.
+	 */
+	per = resident_bytes / k;
+	for (j = 0; j < k; j++) {
+		off = (size_t)j * per;
+		if (pin_cpu(cpu_list[(base + j) % n_cpu]))
+			_exit(3);
+		memset(region + off, 1,
+		       (j == k - 1) ? resident_bytes - off : per);
+	}
+
+	/* Ready: the charge is in place and spread across K CPUs. */
+	if (write(charge_ready[1], "x", 1) != 1)
+		_exit(4);
+	close(charge_ready[1]);
+
+	/* Hold the charge (region stays mapped) until the parent tells
+	 * us to exit by closing the control pipe.
+	 */
+	while (read(charge_ctrl[0], &c, 1) > 0)
+		;
+
+	munmap(region, resident_bytes);
+	_exit(0);
+}
+
+/*
+ * Fork one charging child per leaf, each spread over K CPUs.  Returns 0 once
+ * every child has charged its leaf and is holding the charge, so the tree is
+ * under a steady, quiesced load.  On failure the caller's cleanup path calls
+ * stop_chargers().
+ */
+static int start_chargers(int cpus_per_leaf, size_t resident_bytes)
+{
+	int k_eff, i, h = 0;
+
+	k_eff = (cpus_per_leaf > 0 && cpus_per_leaf <= n_cpu) ? cpus_per_leaf :
+								n_cpu;
+
+	if (pipe(charge_ready) || pipe(charge_ctrl)) {
+		ksft_print_msg("pipe: %s\n", strerror(errno));
+		return -1;
+	}
+
+	charger_pids = calloc(n_leaves, sizeof(*charger_pids));
+	if (!charger_pids) {
+		ksft_print_msg("calloc charger_pids failed\n");
+		return -1;
+	}
+
+	/* recorded before the fork so each child can PR_SET_PDEATHSIG against us */
+	test_pid = getpid();
+
+	for (i = 0; i < n_nodes; i++) {
+		pid_t pid;
+
+		if (!nodes[i].is_leaf)
+			continue;
+
+		pid = fork();
+		if (pid < 0) {
+			ksft_print_msg("fork charger: %s\n", strerror(errno));
+			return -1;
+		}
+		if (pid == 0)
+			charger_child(&nodes[i], h * k_eff, k_eff,
+				      resident_bytes);
+
+		charger_pids[n_chargers++] = pid;
+		h++;
+	}
+
+	/* parent: keeps only the ready-read end and the ctrl-write end */
+	close(charge_ready[1]);
+	charge_ready[1] = -1;
+	close(charge_ctrl[0]);
+	charge_ctrl[0] = -1;
+
+	/* wait until every child has charged its leaf and is holding it */
+	for (i = 0; i < n_chargers; i++) {
+		char c;
+		ssize_t r = read(charge_ready[0], &c, 1);
+
+		if (r != 1) {
+			ksft_print_msg("charger exited before ready (setup failed?)\n");
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static void stop_chargers(void)
+{
+	int i, status;
+
+	/* closing the ctrl write end unblocks every child -> they munmap + exit */
+	if (charge_ctrl[1] >= 0) {
+		close(charge_ctrl[1]);
+		charge_ctrl[1] = -1;
+	}
+	if (charge_ctrl[0] >= 0) {
+		close(charge_ctrl[0]);
+		charge_ctrl[0] = -1;
+	}
+	if (charge_ready[0] >= 0) {
+		close(charge_ready[0]);
+		charge_ready[0] = -1;
+	}
+	if (charge_ready[1] >= 0) {
+		close(charge_ready[1]);
+		charge_ready[1] = -1;
+	}
+
+	for (i = 0; i < n_chargers; i++) {
+		if (!charger_pids || charger_pids[i] <= 0)
+			continue;
+		if (waitpid(charger_pids[i], &status, 0) == charger_pids[i] &&
+		    (!WIFEXITED(status) || WEXITSTATUS(status) != 0))
+			ksft_print_msg("charger %d exited abnormally (status=0x%x)\n",
+				       charger_pids[i], status);
+	}
+
+	free(charger_pids);
+	charger_pids = NULL;
+	n_chargers = 0;
+}
+
+/* ---- file (traditional) reader ----------------------------------------- */
+
+static void parse_stat(char *buf, struct file_snap *o)
+{
+	char *save, *line;
+
+	for (line = strtok_r(buf, "\n", &save); line;
+	     line = strtok_r(NULL, "\n", &save)) {
+		unsigned long long val;
+		char name[64];
+
+		if (sscanf(line, "%63s %llu", name, &val) != 2)
+			continue;
+		if (!strcmp(name, "anon"))
+			o->anon = val;
+		else if (!strcmp(name, "file"))
+			o->file = val;
+		else if (!strcmp(name, "shmem"))
+			o->shmem = val;
+		else if (!strcmp(name, "file_mapped"))
+			o->file_mapped = val;
+		else if (!strcmp(name, "pgfault"))
+			o->pgfault = val;
+	}
+}
+
+static int file_read_node(const char *path, struct file_snap *o)
+{
+	char buf[8192];
+
+	memset(o, 0, sizeof(*o));
+
+	if (cg_read(path, "memory.stat", buf, sizeof(buf)))
+		return -1;
+	parse_stat(buf, o);
+
+	if (!cg_read(path, "memory.current", buf, sizeof(buf)))
+		o->current = strtoull(buf, NULL, 10);
+	if (!cg_read(path, "memory.max", buf, sizeof(buf))) {
+		if (!strncmp(buf, "max", 3))
+			o->max_is_max = true;
+		else
+			o->max = strtoull(buf, NULL, 10);
+	}
+	return 0;
+}
+
+/* ---- BPF reader -------------------------------------------------------- */
+
+static int bpf_walk_once(struct bpf_link *link)
+{
+	char buf[4096];
+	ssize_t r;
+	int fd;
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (fd < 0)
+		return -1;
+	while ((r = read(fd, buf, sizeof(buf))) > 0)
+		;
+	close(fd);
+	return r == 0 ? 0 : -1;
+}
+
+/* ---- correctness comparison -------------------------------------------- */
+
+static bool close_enough(__u64 a, __u64 b, __u64 tol)
+{
+	return (a > b ? a - b : b - a) <= tol;
+}
+
+/* Dump one node's bpf-vs-file stats; called when a mismatch is detected. */
+static void dump_node(int i, const struct memcg_stat_snapshot *b,
+		      const struct file_snap *f)
+{
+	ksft_print_msg("node %d bpf : anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
+		       i, b->anon, b->file, b->shmem, b->file_mapped, b->pgfault);
+	ksft_print_msg("node %d file: anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
+		       i, f->anon, f->file, f->shmem, f->file_mapped, f->pgfault);
+}
+
+/*
+ * Compare the BPF kfunc snapshots (round 1) against the memory.stat values
+ * (round 2), node by node.  The two rounds are independent, equivalently
+ * charged trees, so the flushed stats are compared within a small tolerance
+ * that absorbs per-round overhead (i.e., a charging child's own stack pages).
+ * A wrong unit, enum or field in the kfunc path would miss by far more.
+ *
+ * Two per-round checks verify the flush itself: each leaf was charged
+ * resident_bytes of anon spread over K CPUs, so its flushed anon must be at
+ * least that; and the root's recursive anon must equal the sum of the leaves'
+ * anon (rstat propagated the charge up the tree).
+ *
+ * Returns 0 if every check passes, -1 otherwise.
+ */
+static int check_correctness(const struct memcg_stat_snapshot *bpf,
+			     const struct file_snap *file, const bool *is_leaf,
+			     int n, size_t resident_bytes)
+{
+	__u64 stat_tol = 64 * page_size;
+	__u64 pgf_tol = 1024;
+	__u64 broot = 0, bsum = 0, froot = 0, fsum = 0;
+	int i, mism = 0, flush_bad = 0;
+
+	for (i = 0; i < n; i++) {
+		const struct memcg_stat_snapshot *b = &bpf[i];
+		const struct file_snap *f = &file[i];
+		__u64 bcur = b->usage_pages * page_size;
+
+		/* kfunc path (round 1) compared with memory.stat path (round 2) */
+		if (!close_enough(b->anon, f->anon, stat_tol) ||
+		    !close_enough(b->file, f->file, stat_tol) ||
+		    !close_enough(b->shmem, f->shmem, stat_tol) ||
+		    !close_enough(b->file_mapped, f->file_mapped, stat_tol) ||
+		    !close_enough(b->pgfault, f->pgfault, pgf_tol)) {
+			mism++;
+			dump_node(i, b, f);
+		}
+
+		/* memory.current is live (no flush) and must bound the flushed anon */
+		if (b->anon == 0 || b->anon > bcur) {
+			flush_bad++;
+			ksft_print_msg("node %d: anon=%llu exceeds current=%llu\n",
+				       i, b->anon, bcur);
+		}
+
+		/* each leaf's flush must have gathered the full cross-CPU charge */
+		if (is_leaf[i]) {
+			if (b->anon < resident_bytes || f->anon < resident_bytes) {
+				flush_bad++;
+				ksft_print_msg("node %d: short flush bpf=%llu file=%llu\n",
+					       i, b->anon, f->anon);
+			}
+			bsum += b->anon;
+			fsum += f->anon;
+		}
+		if (i == 0) { /* nodes[0] == subtree_root */
+			broot = b->anon;
+			froot = f->anon;
+		}
+	}
+
+	if (mism) {
+		ksft_print_msg("bpf (round 1) disagrees with memory.stat (round 2)\n");
+		return -1;
+	}
+	if (flush_bad) {
+		ksft_print_msg("flush did not aggregate the cross-cpu charge\n");
+		return -1;
+	}
+	if (broot != bsum || froot != fsum) {
+		ksft_print_msg("root anon != sum of leaf anon: bpf %llu/%llu file %llu/%llu\n",
+			       broot, bsum, froot, fsum);
+		return -1;
+	}
+	if (bsum == 0) {
+		ksft_print_msg("tree carries no anon\n");
+		return -1;
+	}
+	return 0;
+}
+
+/* ---- one case ---------------------------------------------------------- */
+
+struct testcase {
+	const char *name;
+	int fanout;
+	int depth;
+	int cpus_per_leaf; /* K: CPUs each leaf is charged on; 0 = all CPUs */
+	size_t resident_bytes; /* anon charged per leaf */
+};
+
+/*
+ * Remove the subtree in reverse creation order.  Nodes are recorded in DFS
+ * order (a parent precedes all its descendants), so iterating backwards
+ * removes every child before its parent.
+ */
+static void destroy_tree(void)
+{
+	int i;
+
+	if (!nodes)
+		return;
+	for (i = n_nodes - 1; i >= 0; i--)
+		cg_destroy(nodes[i].path);
+	free(nodes);
+	nodes = NULL;
+}
+
+/*
+ * Round 1: build and charge a fresh tree, walk it with the BPF iterator (which
+ * flushes and reads each cgroup via the memcg kfuncs), and capture one snapshot
+ * per node into @snap.  @is_leaf records the tree shape so the later comparison
+ * can run after the tree is gone.  Returns the node count, or -1 on failure.
+ * The tree is always torn down before returning.
+ */
+static int capture_bpf_round(const struct testcase *tc,
+			     struct memcg_stat_snapshot *snap, bool *is_leaf)
+{
+	struct memcg_stat_cross_cpu *skel = NULL;
+	struct bpf_link *link = NULL;
+	int root_fd = -1, ret = -1, i, mfd;
+
+	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
+		ksft_print_msg("build tree (bpf) failed\n");
+		goto out;
+	}
+	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
+		goto out;
+
+	skel = memcg_stat_cross_cpu__open();
+	if (!skel) {
+		ksft_print_msg("skel open failed\n");
+		goto out;
+	}
+	if (bpf_map__set_max_entries(skel->maps.results, n_nodes + 8)) {
+		ksft_print_msg("set max_entries failed\n");
+		goto out;
+	}
+	if (memcg_stat_cross_cpu__load(skel)) {
+		ksft_print_msg("skel load failed\n");
+		goto out;
+	}
+
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {};
+
+	linfo.cgroup.cgroup_fd = root_fd;
+	linfo.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_memcg_stat_cross_cpu,
+					&opts);
+	if (!link) {
+		ksft_print_msg("attach iter failed\n");
+		goto out;
+	}
+
+	/* bpf walk through the cgroup tree and fetch result */
+	if (bpf_walk_once(link)) {
+		ksft_print_msg("bpf walk failed\n");
+		goto out;
+	}
+
+	mfd = bpf_map__fd(skel->maps.results);
+	for (i = 0; i < n_nodes; i++) {
+		/* Save the position for the leaf, used for later correctness check */
+		is_leaf[i] = nodes[i].is_leaf;
+		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &snap[i])) {
+			ksft_print_msg("map lookup failed for node %d\n", i);
+			goto out;
+		}
+	}
+	ret = n_nodes;
+out:
+	bpf_link__destroy(link);
+	memcg_stat_cross_cpu__destroy(skel);
+	if (root_fd >= 0)
+		close(root_fd);
+	stop_chargers();
+	destroy_tree();
+	return ret;
+}
+
+/*
+ * Round 2: build and charge an identical fresh tree, then read every cgroup via
+ * memory.stat / memory.current.  The tree is reset after bpf read, so each
+ * read does a real rstat flush.  Returns the node count, or -1 on failure.
+ * The tree is always clear before returning.
+ */
+static int capture_file_round(const struct testcase *tc, struct file_snap *snap)
+{
+	int root_fd = -1, ret = -1, i;
+
+	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
+		ksft_print_msg("build tree (file) failed\n");
+		goto out;
+	}
+	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
+		goto out;
+
+	for (i = 0; i < n_nodes; i++)
+		if (file_read_node(nodes[i].path, &snap[i])) {
+			ksft_print_msg("file read failed for node %d\n", i);
+			goto out;
+		}
+	ret = n_nodes;
+out:
+	if (root_fd >= 0)
+		close(root_fd);
+	stop_chargers();
+	destroy_tree();
+	return ret;
+}
+
+static int run_case(const struct testcase *tc)
+{
+	struct memcg_stat_snapshot *bpf = NULL;
+	struct file_snap *file = NULL;
+	bool *is_leaf = NULL;
+	size_t cap = tree_capacity(tc->fanout, tc->depth);
+	int nb, nf, ret = KSFT_FAIL;
+
+	bpf = calloc(cap, sizeof(*bpf));
+	file = calloc(cap, sizeof(*file));
+	is_leaf = calloc(cap, sizeof(*is_leaf));
+	if (!bpf || !file || !is_leaf) {
+		ksft_print_msg("calloc failed\n");
+		goto out;
+	}
+
+	ksft_print_msg("%s: fanout=%d depth=%d cpus=%d/%d resident=%zuKB/leaf\n",
+		       tc->name, tc->fanout, tc->depth, n_cpu, tc->cpus_per_leaf,
+		       tc->resident_bytes >> 10);
+
+	/* round 1: BPF reader flushes and reads its own charged tree */
+	nb = capture_bpf_round(tc, bpf, is_leaf);
+	if (nb < 0)
+		goto out;
+
+	/* round 2: file reader flushes and reads a fresh, equivalent tree */
+	nf = capture_file_round(tc, file);
+	if (nf < 0)
+		goto out;
+
+	if (nb != nf) {
+		ksft_print_msg("node count differs between rounds: %d vs %d\n",
+			       nb, nf);
+		goto out;
+	}
+
+	if (!check_correctness(bpf, file, is_leaf, nb, tc->resident_bytes))
+		ret = KSFT_PASS;
+out:
+	free(bpf);
+	free(file);
+	free(is_leaf);
+	return ret;
+}
+
+static const struct testcase cases[] = {
+	/* name, fan, depth, K, resident anon */
+	{ "single_cpu_small_tree", 4, 2, 1, 2 << 20 },
+	{ "cross_cpu_small_tree", 4, 2, 0, 2 << 20 },
+	{ "single_cpu_large_tree", 10, 3, 1, 256 << 10 },
+	{ "cross_cpu_large_tree", 10, 3, 0, 256 << 10 },
+};
+
+static bool memcg_kfuncs_available(void)
+{
+	struct btf *btf;
+	bool ok;
+
+	btf = btf__load_vmlinux_btf();
+	if (!btf)
+		return false;
+	ok = btf__find_by_name_kind(btf, "bpf_get_mem_cgroup", BTF_KIND_FUNC) > 0;
+	btf__free(btf);
+	return ok;
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(cases));
+
+	/* Feature gate first: a read-only BTF probe, no privilege needed. */
+	if (!memcg_kfuncs_available())
+		ksft_exit_skip("memcg BPF kfuncs are not available\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroup v2 isn't mounted\n");
+
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+
+	if (collect_cpus())
+		ksft_exit_skip("cannot read CPU affinity\n");
+
+	page_size = sysconf(_SC_PAGESIZE);
+	subtree_root = cg_name(root, SUBTREE_NAME);
+	if (!subtree_root)
+		ksft_exit_skip("cannot build subtree root path\n");
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		switch (run_case(&cases[i])) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", cases[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", cases[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", cases[i].name);
+			break;
+		}
+	}
+
+	free(cpu_list);
+	cpu_list = NULL;
+	n_cpu = 0;
+
+	ksft_finished();
+}
-- 
2.53.0-Meta

