Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A57D503BDE
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861803; cv=none; b=blBZLaelV7+LXMTjDRuJPxmrQVZVKDIfm1o4TSqnuJTnMNY9qykYpNQMxrU7uSvSlmuAPl1lbgZuRGMMGwixpJjX1tYOcLgthhu8xIfvUe4g7YulZU9TkV7ds2zZiJqpxyBi/XbKRLd+IGXmwfTMWMSNhxizyUNyanAxgiz3OJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861803; c=relaxed/simple;
	bh=RhJmLBVSYcp5nip2MtkY2RhJjeuafeZzdoCjJRShePM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMspItJfYP6sTon3AsNNKIf9+gbODmew5khA/08tKTtbx9YEMe4coiltuRtGHQ5S/p58r84bcFEaUBjmww/4p2H1oMryv0GD5sPjw9Jz8SIWsOsBXqNC88jXqOMBfRd+I3WTWpGNyLqcMNqA+ANa97KhxH98R3+pjaE3hz9Fy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xfksQNEI; arc=none smtp.client-ip=95.215.58.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xfksQNEI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RhJmLBVSYcp5nip2MtkY2RhJjeuafeZzdoCjJRShePM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861799; v=1; x=1789466599;
 b=xfksQNEIHgkw9CSFyzvYs7CU4LytEcilpuIow4UUDkXb0+E2g3/UOHi+BnOHF/HT041tYvJ4
 bRYtVKqoPWpsG+vAoBHgPIRPGo7LYK0oaU1dKR+qxVyprO5ZljKBR8AjdqamY7jbjzXCZo/ZAmg
 G6WZNwCIIlRB7e8dhCsWwGIo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3258799641478f75;
	Tue, 08 Sep 2026 10:03:19 +0000
X-Mizu-Trace-ID: 3258799641478f75
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 7/8] selftests/bpf: add multi-stream sequentiality example model
Date: Tue,  8 Sep 2026 18:01:42 +0800
Message-ID: <20260908100143.47598-8-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add a second example cost model which replaces the builtin
single-cursor sequentiality heuristic with a per-cgroup table of
stream slots keyed by iocg_id: an IO is sequential iff its sector
matches the expected next sector of any tracked stream.  Interleaved
sequential readers in one cgroup keep their own slots instead of
ping-ponging a single cursor, and random IO inside a hot window
rarely matches a moving expectation.

Measured (QEMU, virtio-blk with the HDD profile, 4k IOs, w=1000):
two sequential readers in one cgroup are priced 2064us/op by the
builtin model (judged random) and 23us/op by this model (judged
sequential), a throughput recovery from 7.2 to 511 MiB/s; random IO
inside an 8M window is priced 22.9us/op by builtin (undercharge) and
2643us/op by this model; single-stream sequential and whole-disk
random pricing are unchanged.

The runner reuses the switch helper from the first example model.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 .../selftests/bpf/prog_tests/iocost_model.c   |  31 +++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 122 ++++++++++++++++++
 2 files changed, 153 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
index 386026241d5b4..2c149f3cd243a 100644
--- a/tools/testing/selftests/bpf/prog_tests/iocost_model.c
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2026 Tao Cui */
 #include <test_progs.h>
 #include "iocost_model.skel.h"
+#include "iocost_ms.skel.h"
 
 /*
  * Switch a device to ctrl=bpf through io.cost.model and verify the
@@ -122,3 +123,33 @@ void serial_test_iocost_model(void)
 
 	iocost_model__destroy(skel);
 }
+
+/*
+ * Same check for the multi-stream example model.  Only one model can
+ * be registered at a time, so this test must run separately from
+ * test_iocost_model; both are serial.
+ */
+void serial_test_iocost_model_streams(void)
+{
+	struct iocost_ms *skel;
+	char *dev;
+	int err;
+
+	dev = getenv("IOCOST_TEST_DEV");
+	if (!dev || geteuid() != 0) {
+		test__skip();
+		return;
+	}
+	if (!ASSERT_TRUE(dev_has_iocost(), "iocost_mounted"))
+		return;
+
+	skel = iocost_ms__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_load"))
+		return;
+
+	err = iocost_ms__attach(skel);
+	if (ASSERT_OK(err, "attach"))
+		ASSERT_OK(switch_to_bpf(dev), "switch_and_readback");
+
+	iocost_ms__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 0000000000000..465fd5d5c62e0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Tao Cui */
+/*
+ * Example multi-stream sequentiality detection cost model.
+ *
+ * The builtin model keeps a single cursor per cgroup, so two
+ * interleaved sequential readers in one cgroup are all priced random
+ * (measured 89x overcharge, 12.9x throughput collapse), while random
+ * IO inside a hot window smaller than the 16MB seek threshold is
+ * priced sequential (measured 107x undercharge).  This model replaces
+ * the single cursor with a per-cgroup table of stream slots, keyed by
+ * the iocg_id argument: an IO is sequential iff its sector matches the
+ * expected next sector of any tracked stream.  Interleaved streams
+ * keep their own slots, and windowed random IO rarely matches a
+ * moving expectation.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* VTIME_PER_SEC comes from vmlinux.h (a BTF enum constant) */
+#define IOC_PAGE_SIZE		4096
+#define IOCOST_COST_F_MERGE	(1ULL << 0)	/* not in BTF: a plain macro */
+
+/* DIV64_U64_ROUND_UP / DIV_ROUND_UP_ULL equivalents, folded at
+ * compile time */
+#define RU(x, y)		((x) / (y) + (((x) % (y)) ? 1 : 0))
+
+#define RBPS	174019176ULL
+#define RSEQIOPS	41708ULL
+#define RRANDIOPS	370ULL
+#define WBPS	178075866ULL
+#define WSEQIOPS	42705ULL
+#define WRANDIOPS	378ULL
+
+#define RPAGE	(RU(VTIME_PER_SEC, RU(RBPS, IOC_PAGE_SIZE)))
+#define RSEQIO	(RU(VTIME_PER_SEC, RSEQIOPS) - RPAGE)
+#define RRANDIO	(RU(VTIME_PER_SEC, RRANDIOPS) - RPAGE)
+#define WPAGE	(RU(VTIME_PER_SEC, RU(WBPS, IOC_PAGE_SIZE)))
+#define WSEQIO	(RU(VTIME_PER_SEC, WSEQIOPS) - WPAGE)
+#define WRANDIO	(RU(VTIME_PER_SEC, WRANDIOPS) - WPAGE)
+
+#define NSLOTS	4
+
+struct streams {
+	__u64 expected[NSLOTS];	/* next expected sector, per stream */
+	__u64 stamp[NSLOTS];	/* LRU stamp, 0 = empty */
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u64);
+	__type(value, struct streams);
+	__uint(max_entries, 64);
+} stream_tab SEC(".maps");
+
+SEC("struct_ops")
+u64 BPF_PROG(iocost_ms_calc_cost, u64 op, u64 nbytes, u64 sector,
+	     u64 cursor, u64 iocg_id, u64 flags)
+{
+	struct streams *s;
+	u64 page, seqio, randio, base, advance, now;
+	u32 i, victim = 0, found = 0xFFFFFFFF;
+
+	if (op != REQ_OP_READ && op != REQ_OP_WRITE)
+		return 0;	/* delegate the rest to builtin */
+	if (!nbytes)
+		return 0;
+
+	if (op == REQ_OP_READ) {
+		page = RPAGE; seqio = RSEQIO; randio = RRANDIO;
+	} else {
+		page = WPAGE; seqio = WSEQIO; randio = WRANDIO;
+	}
+	advance = RU(nbytes, 512);	/* sectors */
+
+	s = bpf_map_lookup_elem(&stream_tab, &iocg_id);
+	if (!s) {
+		struct streams zero = {};
+
+		bpf_map_update_elem(&stream_tab, &iocg_id, &zero,
+				    BPF_NOEXIST);
+		s = bpf_map_lookup_elem(&stream_tab, &iocg_id);
+		if (!s)
+			return seqio + RU(nbytes, IOC_PAGE_SIZE) * page;
+	}
+
+	if (flags & IOCOST_COST_F_MERGE) {
+		base = 0;
+		goto out;
+	}
+
+	now = bpf_ktime_get_ns();
+	for (i = 0; i < NSLOTS; i++) {
+		if (s->expected[i] == sector && s->stamp[i]) {
+			found = i;
+			break;
+		}
+	}
+	if (found != 0xFFFFFFFF) {
+		base = seqio;
+		s->expected[found] = sector + advance;
+		s->stamp[found] = now;
+	} else {
+		base = randio;
+		for (i = 1; i < NSLOTS; i++) {
+			if (s->stamp[i] < s->stamp[victim])
+				victim = i;
+		}
+		s->expected[victim] = sector + advance;
+		s->stamp[victim] = now;
+	}
+out:
+	return base + RU(nbytes, IOC_PAGE_SIZE) * page;
+}
+
+SEC(".struct_ops")
+struct iocost_model_ops iocost_ms = {
+	.calc_cost = (void *)iocost_ms_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

