Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD683EF0A6
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 07:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371273; cv=none; b=UR4KHdE4WaxVJO3+oSSp5un7KAdiJdP8wv39cCrPeYp3OcGcvUpjCfkA1CsDysBSSTOyuiFgaWDy8dxy84ooUqXQWPvlXHU8HIfsz41t0M8/uJkchQqESXUVkm6kCtj1QCoryZwGMQoZ93tmN/Fj2aK7iMUpA/vvldWPygT4Br0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371273; c=relaxed/simple;
	bh=5OH0lWZCoe7n+yXrKygqKN02h/ZxoNJdExL1YEWGH00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkPFbXA9PbFR3lNL6/8lRClHXvC0sbtJKiilfkK4Yg6ZGXL3hjagBNeXeT4aPWZxYDTa8N3yxkXr47p++BDE1PzGIGE7qpsqTxu6yC/uouA+VefcC4/TPQNOzSG3rjgInAfCQSoGT/IhqBN3SRVGfDMZiBnoG8G3fdUZR63XxWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wNGkJkw0; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wNGkJkw0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5OH0lWZCoe7n+yXrKygqKN02h/ZxoNJdExL1YEWGH00=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789371268; v=1; x=1789976068;
 b=wNGkJkw0ceT1t95MNSVsY81lU4U/mGT/jHdzJQ3ls5Yj8E4XEvid15JR78baBNO2Gz8m4OSi
 hfs4AjLEobVoFqnkqT207sMwF857vj/YJLUfm9Yw/pQ2CtlTZpSNtY8jB8WKtODlWBpwm0WHgjb
 zAxE6pVmguxMPhgFinXFp1A4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8f69f72fb371e25a;
	Mon, 14 Sep 2026 07:34:28 +0000
X-Mizu-Trace-ID: 8f69f72fb371e25a
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v3 4/5] selftests/bpf: add multi-stream sequentiality example model
Date: Mon, 14 Sep 2026 15:33:55 +0800
Message-ID: <20260914073356.791518-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914073356.791518-1-cui.tao@linux.dev>
References: <20260914073356.791518-1-cui.tao@linux.dev>
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
stream slots: an IO is sequential iff its sector matches the expected
next sector of any tracked stream.  Interleaved sequential readers in
one cgroup keep their own slots instead of ping-ponging a single
cursor, and random IO inside a hot window rarely matches a moving
expectation.  Merged bios skip the base cost but still advance the
matched stream position, so a merge at the expected sector does not
make the following new IO look random.

Stream state lives in a CGRP_STORAGE map keyed by the cgroup of the
blkcg argument, following the cgroup lifetime; there is no
fixed-size registry to exhaust.

Measured (QEMU, virtio-blk with the HDD profile, 4k IOs, w=1000):
two sequential readers in one cgroup are priced 1961us/op by the
builtin model (judged random) and 23us/op by this model (judged
sequential), the completed IO count rises from 4495 to 207505;
random IO inside an 8M window is priced 24us/op by builtin
(undercharge) and 2607us/op by this model; single-stream sequential
and whole-disk random pricing are unchanged.

Stream updates are lockless like the builtin cursor; a lost update
misclassifies a single IO.  Slots are only advanced for bios the
builtin prices.  The streams test lives here with the model it
loads.  The page count truncates like the builtin.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 .../selftests/bpf/prog_tests/iocost_model.c   |  34 ++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 156 ++++++++++++++++++
 2 files changed, 190 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
index bf9f245e29a52..db0a74b1885be 100644
--- a/tools/testing/selftests/bpf/prog_tests/iocost_model.c
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -4,6 +4,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include "iocost_model.skel.h"
+#include "iocost_ms.skel.h"
 
 /*
  * Write a line to io.cost.model with write(2) and return the errno of
@@ -164,3 +165,36 @@ void serial_test_iocost_model(void)
 
 	iocost_model__destroy(skel);
 }
+
+/*
+ * Same check for the multi-stream example model.  Only one model can
+ * be bound to a device at a time; both tests bind and restore, so
+ * they are serial and independent.
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
+	if (!dev_has_iocost(dev)) {
+		printf("skip: %s has no iocost enabled\n", dev);
+		test__skip();
+		return;
+	}
+
+	skel = iocost_ms__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_load"))
+		return;
+
+	err = iocost_ms__attach(skel);
+	if (ASSERT_OK(err, "attach"))
+		ASSERT_OK(bind_model(dev, "iocost_ms"), "bind_and_readback");
+
+	iocost_ms__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 0000000000000..2a3c1d6aae4df
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Example multi-stream sequentiality detection cost model.
+ *
+ * The builtin model keeps a single cursor per cgroup, so two
+ * interleaved sequential readers in one cgroup are all priced random
+ * (measured 89x overcharge, 12.9x throughput collapse), while random
+ * IO inside a hot window smaller than the 16MB seek threshold is
+ * priced sequential (measured 107x undercharge).  This model replaces
+ * the single cursor with a per-cgroup table of stream slots: an IO is
+ * sequential iff its sector matches the expected next sector of any
+ * tracked stream.  Interleaved streams keep their own slots, and
+ * windowed random IO rarely matches a moving expectation.
+ *
+ * Stream state lives in a CGRP_STORAGE map, so it is created and
+ * freed with the cgroup.  The model implements the full builtin
+ * linear formula itself, including flush pricing.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* VTIME_PER_SEC comes from vmlinux.h (a BTF enum constant) */
+#define IOC_PAGE_SIZE		4096
+#define IOC_SECT_TO_PAGE_SHIFT	3	/* 512B sectors to 4kB pages */
+#define IOCOST_COST_F_MERGE	(1ULL << 0)	/* not in BTF: a plain macro */
+#define IOCOST_REQ_OP_MASK	0xff		/* REQ_OP_MASK, not in BTF */
+
+/*
+ * DIV64_U64_ROUND_UP / DIV_ROUND_UP_ULL equivalents, folded at
+ * compile time
+ */
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
+/*
+ * per-cgroup stream table: keyed by the cgroup, freed with it
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_CGRP_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct streams);
+} stream_tab SEC(".maps");
+
+SEC("struct_ops")
+u64 BPF_PROG(iocost_ms_calc_cost, u64 opf, u64 nbytes, u64 sector,
+	     struct blkcg *blkcg, u64 model_flags)
+{
+	struct streams *s;
+	u64 pages, base, coef_page, randio, advance, now;
+	u32 i, victim = 0, found = 0xFFFFFFFF;
+
+	if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ) {
+		base = RSEQIO; coef_page = RPAGE; randio = RRANDIO;
+	} else if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE) {
+		base = WSEQIO; coef_page = WPAGE; randio = WRANDIO;
+	} else {
+		/*
+		 * a fully owning model must price every op; unknown
+		 * ops are priced as per-page writes
+		 */
+		base = 0; coef_page = WPAGE; randio = 0;
+	}
+	advance = nbytes >> 9;	/* whole sectors, like bio_end_sector() */
+
+	/* only bios the builtin prices participate in stream tracking */
+	if (!(((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
+	       (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE) && nbytes)) {
+		pages = nbytes >> IOC_PAGE_SHIFT;
+		if (!pages)
+			pages = 1;
+		return base + pages * coef_page;
+	}
+
+	s = bpf_cgrp_storage_get(&stream_tab, blkcg->css.cgroup, NULL,
+				 BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!s) {
+		/* no storage: price per page, truncating like the builtin */
+		pages = nbytes >> IOC_PAGE_SHIFT;
+		if (!pages)
+			pages = 1;
+		return base + pages * coef_page;
+	}
+
+	/*
+	 * Slot access is lockless, mirroring the builtin single-cursor
+	 * update in ioc_rqos_throttle(): concurrent CPUs submitting for
+	 * the same cgroup can race on slot updates; mispricing is
+	 * bounded and acceptable for an example model.
+	 */
+	now = bpf_ktime_get_ns();
+	for (i = 0; i < NSLOTS; i++) {
+		if (s->expected[i] == sector && s->stamp[i]) {
+			found = i;
+			break;
+		}
+	}
+	if (found != 0xFFFFFFFF) {
+		/* sequential: keep the seq base from the op branch */
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
+
+	/* builtin truncates: max(sectors >> IOC_SECT_TO_PAGE_SHIFT, 1) */
+	pages = nbytes >> IOC_PAGE_SHIFT;
+	if (!pages)
+		pages = 1;
+	if (model_flags & IOCOST_COST_F_MERGE) {
+		/*
+		 * merged bios skip the base cost but still advance
+		 * the stream position above, so a merge at the
+		 * expected sector does not make the following new IO
+		 * look random
+		 */
+		base = 0;
+	}
+
+	return base + pages * coef_page;
+}
+
+SEC(".struct_ops")
+struct iocost_model_ops iocost_ms = {
+	.calc_cost = (void *)iocost_ms_calc_cost,
+	.name = "iocost_ms",
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

