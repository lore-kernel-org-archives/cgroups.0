Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F245237AF
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861793; cv=none; b=Q822vTBfpdEcXz5tRAjHBPWO6z0h6ILe29Zny/yx8Zviln5wqYKKrMI5IzlIWMZBQcgUFjhEA1C8rYK2kZP1rFLhd026tEQVD2c4hmf6RsVVU5efSgWFQ9EA10VT+YHqaEDR3CHJl1fg3PQ9UHi5xAhQC9W/RPHj/Xy0Jtq2O3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861793; c=relaxed/simple;
	bh=r4FFykHx2l0Mym4QKl1EfWhMWo17b+iIf/S75GX9C8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwDr6k4KyjXoGNxIfacwtlhFYo1j5nD5GwvpySXFC9wJKaZuwGtbF5Q9vCb1FyEpo8TwxJ1tiqfRq2wmd9Hhgbg1BZ0wkxQyJs9Gs7W6B3ZPvVigqgp5yyeUSMXKvtaDXwKYsbhzTQAkJ5f+9y6pvixDnzlxhBk7IUe8Uk16igs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hjw1Nxt2; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hjw1Nxt2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=r4FFykHx2l0Mym4QKl1EfWhMWo17b+iIf/S75GX9C8I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861788; v=1; x=1789466588;
 b=Hjw1Nxt2FlCqtEby6RwyjPsfi6lncRLLubQU5P83G2amqWf8Ng7nmMPT77tiNSEnplLzyeu6
 gCVQeMiqQDcWMLvBqgjBDUw+IfOls7MHNOSxzZaN5x1mfojTTxnglofb15rQsEkM5pMLZRD2rIs
 Me4XMXnBVrfCTZHt8ypyB7No=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dbfa77b83717f402;
	Tue, 08 Sep 2026 10:03:08 +0000
X-Mizu-Trace-ID: dbfa77b83717f402
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
Subject: [RFC PATCH 6/8] selftests/bpf: add iocost cost model test
Date: Tue,  8 Sep 2026 18:01:41 +0800
Message-ID: <20260908100143.47598-7-cui.tao@linux.dev>
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

Add an example cost model implementing iocost_model_ops with the
builtin linear HDD formula at double cost, and a runner which
registers it as a struct_ops, switches a device to ctrl=bpf through
io.cost.model and verifies the readback, restoring ctrl=auto
afterwards.  The runner first checks the negative case: writing
ctrl=bpf while no model is registered is rejected.  Under the same
workload the doubled model should charge exactly twice the builtin
model, which makes it a convenient way to verify that accounting
goes through the BPF path; the accounting itself needs real IO and
is covered by the kernel-side validation described in the cover
letter.  The runner is skipped unless $IOCOST_TEST_DEV gives a
major:minor of a device with iocost enabled.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 .../selftests/bpf/prog_tests/iocost_model.c   | 124 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        |  91 +++++++++++++
 2 files changed, 215 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c

diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
new file mode 100644
index 0000000000000..386026241d5b4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Tao Cui */
+#include <test_progs.h>
+#include "iocost_model.skel.h"
+
+/*
+ * Switch a device to ctrl=bpf through io.cost.model and verify the
+ * readback, restoring ctrl=auto afterwards.  Returns 0 on success.
+ * Shared by the example-model tests below.
+ */
+static int switch_to_bpf(const char *dev)
+{
+	char path[] = "/sys/fs/cgroup/io.cost.model";
+	char word[256], line[256], buf[300];
+	FILE *fp;
+	int err, found = 0;
+
+	fp = fopen(path, "r+");
+	if (!fp) {
+		TH_LOG("open %s: %s", path, strerror(errno));
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		TH_LOG("%s has no iocost line", dev);
+		fclose(fp);
+		return -1;
+	}
+
+	snprintf(buf, sizeof(buf), "%s ctrl=bpf", dev);
+	err = fprintf(fp, "%s\n", buf);
+	if (err <= 0) {
+		TH_LOG("write ctrl=bpf failed");
+		fclose(fp);
+		return -1;
+	}
+	fflush(fp);
+
+	rewind(fp);
+	found = 0;
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
+			found = strstr(line, "ctrl=bpf") != NULL;
+			break;
+		}
+	}
+	if (!found)
+		TH_LOG("readback does not show ctrl=bpf");
+
+	fprintf(fp, "%s ctrl=auto\n", dev);
+	fclose(fp);
+	return found ? 0 : -1;
+}
+
+static int dev_has_iocost(void)
+{
+	FILE *fp = fopen("/sys/fs/cgroup/io.cost.qos", "r");
+
+	if (fp)
+		fclose(fp);
+	return fp != NULL;
+}
+
+/*
+ * Register the example cost model and switch a device to ctrl=bpf.
+ * IO accounting itself is not checked here; it needs a device doing
+ * real IO under iocost and is covered by the kernel-side validation
+ * described in the cover letter.
+ *
+ * Requires root, cgroup v2 and a device with iocost support.  The
+ * device must be given as major:minor in $IOCOST_TEST_DEV, otherwise
+ * the test is skipped.
+ */
+void serial_test_iocost_model(void)
+{
+	struct iocost_model *skel;
+	char word[256], *dev;
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
+	/* negative: ctrl=bpf must be rejected while no model is
+	 * registered, so a typo cannot silently disable cost model
+	 * updates */
+	if (sscanf(dev, "%255s", word) != 1)
+		return;
+	{
+		char path[] = "/sys/fs/cgroup/io.cost.model";
+		char buf[300];
+		FILE *fp = fopen(path, "w");
+
+		snprintf(buf, sizeof(buf), "%s ctrl=bpf\n", word);
+		err = 0;
+		if (fp) {
+			err = fprintf(fp, "%s", buf) <= 0;
+			fclose(fp);
+		}
+		ASSERT_TRUE(err, "ctrl_bpf_without_model_rejected");
+	}
+
+	skel = iocost_model__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_load"))
+		return;
+
+	/* attaching the struct_ops registers the model; a second
+	 * registration of the same ops would fail with EBUSY */
+	err = iocost_model__attach(skel);
+	if (ASSERT_OK(err, "attach"))
+		ASSERT_OK(switch_to_bpf(dev), "switch_and_readback");
+
+	iocost_model__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 0000000000000..70f7987f8eb6a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Tao Cui */
+/*
+ * Example iocost cost model: the builtin linear HDD formula with all
+ * costs doubled.
+ *
+ * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
+ * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
+ * analog) in vtime units where 1s == 2^37, expressed with the same
+ * round-up divisions so they cannot drift from the kernel, so a
+ * device switched to ctrl=bpf with this model registered charges
+ * exactly twice the builtin model under the same workload, which
+ * makes it a convenient way to verify that accounting goes through
+ * the BPF path.
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
+static __always_inline u64 builtin_cost(u64 op, u64 nbytes, u64 sector,
+					u64 cursor, u64 flags)
+{
+	u64 pages, seek_pages = 0, base, coef_page;
+
+	if (!nbytes)
+		return 0;
+
+	switch (op) {
+	case REQ_OP_READ:
+		base = RSEQIO;
+		coef_page = RPAGE;
+		break;
+	case REQ_OP_WRITE:
+		base = WSEQIO;
+		coef_page = WPAGE;
+		break;
+	default:
+		return 0;
+	}
+
+	if (cursor) {
+		seek_pages = sector > cursor ? sector - cursor
+					     : cursor - sector;
+		seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;
+		if (seek_pages > LCOEF_RANDIO_PAGES)
+			base = (op == REQ_OP_READ) ? RRANDIO : WRANDIO;
+	}
+
+	pages = RU(nbytes, IOC_PAGE_SIZE);
+	if (flags & IOCOST_COST_F_MERGE)
+		base = 0;
+	return base + pages * coef_page;
+}
+
+SEC("struct_ops")
+u64 BPF_PROG(iocost_2x_calc_cost, u64 op, u64 nbytes, u64 sector,
+	     u64 cursor, u64 iocg_id, u64 flags)
+{
+	return 2 * builtin_cost(op, nbytes, sector, cursor, flags);
+}
+
+SEC(".struct_ops")
+struct iocost_model_ops iocost_2x = {
+	.calc_cost = (void *)iocost_2x_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

