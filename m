Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC2A3D0C18
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228784; cv=none; b=WzVUMl7m5SR/1yZ0WM+LibKMOKWVqtLdwci74pk9FZrmDPUjfyCfex42p69MVWnS2whmx5C4kzeZH4LnxVk/AoseqtAJjwKUP9PZHkjAjJSJB1UfvgtfdOzrzukCWOu/Q0Ag+H6tnFdjLwH5uKCbpnD4o2xtpKixF7GakdpHMro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228784; c=relaxed/simple;
	bh=6JLNIAwtKTexkjNyhU377tDrFRNH0SRxqzkPHvqyq6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL+GDQRk/e6/rCthLzOa3QHNetI8BkW0nGvxIIWaJDKT+TE2rbyAhlf/G8PDte/JBRnWxYsuuZKbmnypVZnqsqJPPwXTyhYit5o343vxAGCtUpWzL2WcESX86bKXpcI0Naky2MygIfdSymKYLXw1Ga1cPBbIHeJZX5Ok6h6k9SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ms2XLGHc; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ms2XLGHc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6JLNIAwtKTexkjNyhU377tDrFRNH0SRxqzkPHvqyq6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790228779; v=1; x=1790833579;
 b=ms2XLGHcmiVg1B/QyrV4Ib4/ExQBT3yQ4jYckL4c5WGOSRQ3XFNjKtNDA/MFCKeMszVf2mYF
 xOH4fE/zebeLMca+9kpzsfCMovv20SVDqE9SkNaLhTgRTgxN4N+QGR01H+6mVtcK+MjJv6NL44R
 +VI2dUgSUmXKmD75Jxn3Adfo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6306604b1a3171c4;
	Thu, 24 Sep 2026 05:46:18 +0000
X-Mizu-Trace-ID: 6306604b1a3171c4
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
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [RFC PATCH v7 2/4] selftests/bpf: add iocost cost model test
Date: Thu, 24 Sep 2026 13:45:47 +0800
Message-ID: <20260924054549.2271705-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924054549.2271705-1-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add an example cost model implementing the full builtin linear HDD
formula at double cost, and a test which attaches it to one device:
the dev member of the struct_ops is written through the map's
initial value before load, as hid_bpf tests do with hid_id, and
attaching the struct_ops attaches the model to the device.  The test
verifies the model=bpf readback while attached, that a second model
on the same device fails with -EBUSY, and that detaching restores
the builtin model.

Under the same workload the doubled model charges 1.99x the
builtin model (measured 2882us -> 5722us per IO, completed IO count
halved).  The example also sets the transfer cost coefficients so
the builtin sizing follows the doubled pricing.

Per-cgroup stream state uses a CGRP_STORAGE map keyed by the cgroup
of the issuing bio, so the model inherits the cgroup
lifetime.  opf carries the full bio->bi_opf
including REQ_* flag bits, so the operation must be extracted with a
mask, not compared for equality.

CONFIG_BLK_CGROUP_IOCOST and CONFIG_BLK_CGROUP_IOCOST_BPF are added
to the selftest kernel config: without them vmlinux.h does not
contain iocost_model_ops and the skeletons fail to build; the
runtime skip cannot avoid a build dependency.

Requires root, cgroup v2 and a device given as major:minor in
$IOCOST_TEST_DEV.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 182 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 139 +++++++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 159 +++++++++++++++
 4 files changed, 482 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index d292cb60a5a4..6e005145d3a8 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -140,3 +140,5 @@ CONFIG_SMC_HS_CTRL_BPF=y
 CONFIG_DIBS=y
 CONFIG_DIBS_LO=y
 CONFIG_PM_WAKELOCKS=y
+CONFIG_BLK_CGROUP_IOCOST=y
+CONFIG_BLK_CGROUP_IOCOST_BPF=y
diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
new file mode 100644
index 000000000000..156c75367af0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <fcntl.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include "iocost_model.skel.h"
+#include "iocost_ms.skel.h"
+
+/*
+ * Read back the io.cost.model line of dev and copy the model= value
+ * into @model.  Returns 0 on success.
+ */
+static int readback_model(const char *dev, char *model, size_t model_sz)
+{
+	char line[256], word[256], *m, *end;
+	FILE *fp;
+	int found = 0;
+
+	fp = fopen("/sys/fs/cgroup/io.cost.model", "r");
+	if (!fp)
+		return -1;
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
+			found = 1;
+			break;
+		}
+	}
+	fclose(fp);
+	if (!found)
+		return -1;
+
+	m = strstr(line, "model=");
+	if (!m)
+		return -1;
+	m += strlen("model=");
+	end = m;
+	while (*end && *end != ' ')
+		end++;
+	snprintf(model, model_sz, "%.*s", (int)(end - m), m);
+	return 0;
+}
+
+/*
+ * Attach the example model to one device, given as major:minor in
+ * $IOCOST_TEST_DEV: the dev member is written through the struct_ops
+ * map's initial value before load, as hid_bpf_ops does with hid_id,
+ * and loading attaches the model to the device.  Detaching the
+ * struct_ops restores the builtin model.
+ *
+ * Requires root, cgroup v2 and a device with iocost support.
+ */
+void serial_test_iocost_model(void)
+{
+	struct iocost_model *skel, *second;
+	unsigned int maj, min;
+	__u64 *ops_dev, *sdev;
+	int err;
+	char model[32], *dev;
+
+	dev = getenv("IOCOST_TEST_DEV");
+	if (!dev || geteuid() != 0 || sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		test__skip();
+		return;
+	}
+
+	skel = iocost_model__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	/* dev is the first member of struct iocost_model_ops */
+	ops_dev = bpf_map__initial_value(skel->maps.iocost_2x, NULL);
+	if (!ASSERT_OK_PTR(ops_dev, "initial_value")) {
+		iocost_model__destroy(skel);
+		return;
+	}
+	*ops_dev = makedev(maj, min);
+
+	err = iocost_model__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_model__destroy(skel);
+		return;
+	}
+
+	err = iocost_model__attach(skel);
+	if (ASSERT_OK(err, "attach")) {
+		/*
+		 * attached: the read path reports model=bpf until the
+		 * struct_ops is detached; ctrl keeps describing the
+		 * builtin coefficients
+		 */
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback"))
+			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");
+
+		/* a second model on the same device fails with -EBUSY */
+		second = iocost_model__open();
+		if (ASSERT_OK_PTR(second, "second_open")) {
+			sdev = bpf_map__initial_value(
+					second->maps.iocost_2x, NULL);
+			if (!ASSERT_OK_PTR(sdev, "second_initial_value"))
+				goto out_destroy;
+			*sdev = makedev(maj, min);
+			err = iocost_model__load(second);
+			if (ASSERT_OK(err, "second_load")) {
+				struct bpf_link *l2;
+
+				/*
+				 * the kernel rejects attaching a second
+				 * model to the device with EBUSY
+				 */
+				l2 = bpf_map__attach_struct_ops(
+						second->maps.iocost_2x);
+				if (!ASSERT_ERR_PTR(l2, "second_ebusy"))
+					bpf_link__destroy(l2);
+				else
+					ASSERT_EQ(libbpf_get_error(l2), -EBUSY,
+						  "second_ebusy_errno");
+			}
+out_destroy:
+			iocost_model__destroy(second);
+		}
+
+		iocost_model__detach(skel);
+
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_after_detach"))
+			ASSERT_EQ(strcmp(model, "linear"), 0, "model_linear");
+	}
+
+	iocost_model__destroy(skel);
+}
+/*
+ * Same check for the multi-stream example model.  Only one model can
+ * be attached to a device at a time; both tests attach and detach, so
+ * they are serial and independent.
+ */
+void serial_test_iocost_model_streams(void)
+{
+	struct iocost_ms *skel;
+	unsigned int maj, min;
+	__u64 *ops_dev;
+	int err;
+	char model[32], *dev;
+
+	dev = getenv("IOCOST_TEST_DEV");
+	if (!dev || geteuid() != 0 || sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		test__skip();
+		return;
+	}
+
+	skel = iocost_ms__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	ops_dev = bpf_map__initial_value(skel->maps.iocost_ms, NULL);
+	if (!ASSERT_OK_PTR(ops_dev, "initial_value")) {
+		iocost_ms__destroy(skel);
+		return;
+	}
+	*ops_dev = makedev(maj, min);
+
+	err = iocost_ms__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_ms__destroy(skel);
+		return;
+	}
+
+	err = iocost_ms__attach(skel);
+	if (ASSERT_OK(err, "attach")) {
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback"))
+			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");
+
+		iocost_ms__detach(skel);
+
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_after_detach"))
+			ASSERT_EQ(strcmp(model, "linear"), 0, "model_linear");
+	}
+
+	iocost_ms__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 000000000000..369818bda1cf
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Example iocost cost model: the builtin linear HDD formula with all
+ * costs doubled, for one device given by the dev member of the
+ * struct_ops.
+ *
+ * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
+ * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
+ * analog) in vtime units where 1s == 2^37.  On a rotational device
+ * still on ctrl=auto, a device with this model attached charges
+ * twice the builtin model under the same workload, so the
+ * doubled cost is a direct check that accounting goes through the
+ * BPF path.  On a non-rotational device, or one with user-pinned
+ * coefficients, the ratio to the builtin model is arbitrary.
+ *
+ * A zero cursor means "no previous IO".  The cursor advances for
+ * every priced bio with a non-zero size (READ/WRITE), merged ones
+ * included, truncating to whole sectors like the builtin, so flushes
+ * and discards leave it alone and merged streams do not drift past
+ * the 16MB seek threshold.
+ *
+ * The model implements the full linear formula itself, including
+ * flushes: there is no fallback to the builtin model, a dataless
+ * A dataless WRITE|REQ_PREFLUSH keeps the write base: the op is still
+ * WRITE, so it carries WSEQIO (or WRANDIO after a seek) plus one page.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/*
+ * VTIME_PER_SEC, IOC_PAGE_SIZE/SHIFT, IOC_SECT_TO_PAGE_SHIFT and
+ * IOCOST_COST_F_MERGE come from vmlinux.h (BTF enum constants)
+ */
+#define LCOEF_RANDIO_PAGES	4096	/* 16MB seek threshold */
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
+/*
+ * per-cgroup cursor storage: keyed by the cgroup, freed with it, so
+ * per-cgroup state follows the cgroup lifetime
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_CGRP_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, __u64);
+} cursor_store SEC(".maps");
+
+SEC("struct_ops")
+u64 BPF_PROG(iocost_2x_calc_cost, struct bio *bio, u64 model_flags)
+{
+	u64 opf = bio->bi_opf, nbytes = bio->bi_iter.bi_size;
+	u64 sector = bio->bi_iter.bi_sector;
+	struct blkcg *blkcg = bio->bi_blkg->blkcg;
+	u64 pages, seek_pages = 0, base, coef_page, randio, cost;
+	__u64 *cursor, cur;
+	int priced;
+
+	/* builtin truncates: max(sectors >> IOC_SECT_TO_PAGE_SHIFT, 1) */
+	pages = nbytes >> IOC_PAGE_SHIFT;
+	if (!pages)
+		pages = 1;
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
+
+	/*
+	 * mirror the builtin cursor semantics: seek distance is only
+	 * computed against a non-zero cursor, and the cursor is
+	 * advanced for bios the builtin prices (READ/WRITE with a
+	 * non-zero size), merged ones included, so flushes and
+	 * discards leave it alone
+	 */
+	priced = (opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
+		 (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE;
+	cursor = bpf_cgrp_storage_get(&cursor_store,
+				      blkcg->css.cgroup, NULL,
+				      BPF_LOCAL_STORAGE_GET_F_CREATE);
+	if (!cursor) {
+		if (model_flags & IOCOST_COST_F_MERGE)
+			base = 0;
+		return 2 * (base + pages * coef_page);
+	}
+	cur = *cursor;
+	if (cur && priced) {
+		seek_pages = sector > cur ? sector - cur
+					   : cur - sector;
+		seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;
+		if (seek_pages > LCOEF_RANDIO_PAGES)
+			base = randio;
+	}
+	if (priced && nbytes)
+		*cursor = sector + (nbytes >> 9);
+
+	if (model_flags & IOCOST_COST_F_MERGE)
+		base = 0;
+
+	cost = 2 * (base + pages * coef_page);
+	return cost;
+}
+
+SEC(".struct_ops")
+struct iocost_model_ops iocost_2x = {
+	.read_vtime_per_page = 2 * RPAGE,
+	.write_vtime_per_page = 2 * WPAGE,
+	.calc_cost = (void *)iocost_2x_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 000000000000..aaa2e4489c1b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,159 @@
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
+/*
+ * VTIME_PER_SEC, IOC_PAGE_SIZE/SHIFT, IOC_SECT_TO_PAGE_SHIFT and
+ * IOCOST_COST_F_MERGE come from vmlinux.h (BTF enum constants)
+ */
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
+u64 BPF_PROG(iocost_ms_calc_cost, struct bio *bio, u64 model_flags)
+{
+	u64 opf = bio->bi_opf, nbytes = bio->bi_iter.bi_size;
+	u64 sector = bio->bi_iter.bi_sector;
+	struct blkcg *blkcg = bio->bi_blkg->blkcg;
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
+	advance = RU(nbytes, 512);	/* sectors */
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
+	.read_vtime_per_page = RPAGE,
+	.write_vtime_per_page = WPAGE,
+	.calc_cost = (void *)iocost_ms_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

