Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0750748EC7A
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045133; cv=none; b=UaWHsqngYvxbftl5ynB98njZLbTpuIJDaO7EkfrieoyV85BuwC6F1PWkL8R42ZXoY+4Hi1DQHRaQPHE41CXaN7NwjXccmB6NExhINAdgzn7M480GyI7XTIkMsnHXQnAV1kzp4xmFqaTEtk1aCmnXOrRf1mVOwFSwuSoJC+Ecjgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045133; c=relaxed/simple;
	bh=kuqHBkMBo3V9YxQhfmvAdSRAURGFEJi13xW6az8I9eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moWSt5WQqu4+raD6yBYTE4b1mJ1ViPOEKFa3ldjag5oZEZVysa+w1b7967QojGAfvoHwuTDRes6XNLAPCTUXnQUCYhm/XALJqWUx2KNVW1jN8uWZOp6WwNDr37itHNJ5T8VY+TB7Yw+FsmtiNMBowxgrOFH+gb0gENb3s0Q6CCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c949H3Q9; arc=none smtp.client-ip=95.215.58.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c949H3Q9"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kuqHBkMBo3V9YxQhfmvAdSRAURGFEJi13xW6az8I9eQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789045128; v=1; x=1789649928;
 b=c949H3Q9PbRB72Uy+dGsmRmUNkOAaYUX8Sc8tbx/AzkaRmCLQc+oDkIRVqn79FjgGfUtKsHk
 yecC27LjK9cmkO81mYQz1/CHuvfBaYK33JsAFh8yekESXLdBELFhP1zXmMGO+ow4CnFRz+IJX7M
 ePvdgBtn068YrWEYRIuX6Rto=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d248a60d230e97a6;
	Thu, 10 Sep 2026 12:58:48 +0000
X-Mizu-Trace-ID: d248a60d230e97a6
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
Subject: [RFC PATCH v2 4/5] selftests/bpf: add multi-stream sequentiality example model
Date: Thu, 10 Sep 2026 20:58:16 +0800
Message-ID: <20260910125817.223354-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910125817.223354-1-cui.tao@linux.dev>
References: <20260910125817.223354-1-cui.tao@linux.dev>
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
---
 tools/testing/selftests/bpf/progs/iocost_ms.c | 136 ++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 000000000000..3cc57c03d3c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,136 @@
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
+#define LCOEF_RANDIO_PAGES	4096	/* 16MB seek threshold */
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
+		 * ops are priced as a single page write
+		 */
+		base = 0; coef_page = WPAGE; randio = 0;
+	}
+	advance = RU(nbytes, 512);	/* sectors */
+
+	s = bpf_cgrp_storage_get(&stream_tab, blkcg->css.cgroup, NULL,
+				 BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!s)
+		return base + RU(nbytes, IOC_PAGE_SIZE) * coef_page;
+
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
+	pages = RU(nbytes, IOC_PAGE_SIZE);
+	if (!pages)
+		pages = 1;	/* dataless flush: one page */
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

