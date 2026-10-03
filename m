Received: from mta1.migadu.com (out-222.mta1.migadu.com [95.215.58.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3448842901F
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 12:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791031291; cv=none; b=q6gq5ikN4383T4Yq+6+g62EOhYU7OV4yZTcHeQmm+vN5rjyETfbajzhe1pmue7euJH1mCtGKSNc8SxMxVUNqRf4zAUCZmCIqXay7ZHsh46hR420bMnrzaQkjM70/hz4px1T0FkK0Av1DNZBhjcD+O+0dtK9TMF44AaSKHQBWL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791031291; c=relaxed/simple;
	bh=Fbi8tb5ZBDz3qJnKrweeop5zVc4oRDTUvK4GGFXRNEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul5YcAd8J8l5DKbce3GmL95u9t5Edz2DHMSebD/zoFRpdi1t+t6wg/N+R+h7ywpLN0JYLlNlS1yCSXDPT/Mrfeq0HtOJttMzLRNtsXNRcpYzNVyuOP3qQo2GOPyGDcHxEoiBM/EWCsi29hj7yOyVI7hU8SaTCJH3DvSX+GY1HdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=udgHpIRH; arc=none smtp.client-ip=95.215.58.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="udgHpIRH"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Fbi8tb5ZBDz3qJnKrweeop5zVc4oRDTUvK4GGFXRNEY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791031286; v=1; x=1791636086;
 b=udgHpIRHR7WdR53QQ+CzWA1VRRvtlZAL97bfwDFXwuzRGlzHs5Tbwou9v8mbLyBhBksR+5Qa
 dt80g5jetlH+YUh9iENqtQWykFnHlkuc05gdjoB6r7LkwdTMfhRqc+35FTkqok0sHxLtd0rGWkA
 ERRgffM0gqhpwvSsQH10nO8s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ff9abf820e5b11bb;
	Sat, 03 Oct 2026 12:41:26 +0000
X-Mizu-Trace-ID: ff9abf820e5b11bb
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
Subject: [RFC PATCH v10 2/4] selftests/bpf: add iocost cost model test
Date: Sat,  3 Oct 2026 20:40:43 +0800
Message-ID: <20261003124045.1289305-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003124045.1289305-1-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two example iocost cost models and tests which attach them to
one device, given as major:minor in $IOCOST_TEST_DEV.

The first model implements the builtin linear HDD formula at double
cost.  The second implements the multi-stream sequentiality
detection: it keeps a per-cgroup table of stream slots instead of
the single builtin cursor, so
concurrent sequential streams in one cgroup are priced sequentially.
Both set the target device through the struct_ops member before
load, and attaching the struct_ops binds the model to the device;
the maps are declared ".struct_ops.link" so that a test dying in
between does not leave the model attached.

The test verifies the model=bpf readback while attached, that
ctrl=bpf is rejected, that a second model on the same device fails
with -EBUSY, that model=linear and model=bpf switch between the
attached and builtin models without detaching, and that detaching
restores the builtin model.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 233 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 141 +++++++++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 163 ++++++++++++
 4 files changed, 539 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 2b883b388f90c..c5634ee91e690 100644
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
index 0000000000000..fa3ba82a840d5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,233 @@
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
+ * Write a line to io.cost.model for dev and return the errno of the
+ * write negated (0 on success), as ASSERT_ERR() expects.
+ */
+static int write_cost_model(const char *dev, const char *what)
+{
+	char buf[128];
+	FILE *fp;
+	int err = 0;
+
+	snprintf(buf, sizeof(buf), "%s %s", dev, what);
+	fp = fopen("/sys/fs/cgroup/io.cost.model", "w");
+	if (!fp)
+		return -EACCES;
+	if (fwrite(buf, 1, strlen(buf), fp) != strlen(buf))
+		err = ferror(fp) ? -errno : -EIO;
+	if (fclose(fp) && !err)
+		err = -errno;
+	return err;
+}
+
+/*
+ * Attach the example model to one device, given as major:minor in
+ * $IOCOST_TEST_DEV: the dev member is written through the struct_ops
+ * map's initial value before load, as hid_bpf_ops does with hid_id,
+ * and attaching the struct_ops attaches the model to the device.
+ * Detaching the struct_ops restores the builtin model.
+ *
+ * Requires root, cgroup v2 and a device with iocost support.
+ */
+void serial_test_iocost_model(void)
+{
+	struct iocost_model *skel, *second;
+	unsigned int maj, min;
+	int err;
+	char model[32], *dev;
+
+	dev = getenv("IOCOST_TEST_DEV");
+	if (!dev || geteuid() != 0 || sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		printf("%s:SKIP:needs root and IOCOST_TEST_DEV=<maj>:<min>\n",
+		       __func__);
+		test__skip();
+		return;
+	}
+
+	skel = iocost_model__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	skel->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+
+	err = iocost_model__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_model__destroy(skel);
+		return;
+	}
+
+	err = iocost_model__attach(skel);
+	if (err == -EOPNOTSUPP || err == -ENODEV) {
+		printf("%s:SKIP:device is not blk-mq, has no iocost or does not exist\n",
+		       __func__);
+		iocost_model__destroy(skel);
+		test__skip();
+		return;
+	}
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
+			second->struct_ops.iocost_2x->dev =
+				(__u32)makedev(maj, min);
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
+			iocost_model__destroy(second);
+		}
+
+		/*
+		 * attachment and model selection are independent:
+		 * ctrl=bpf is never accepted, model=linear switches
+		 * back to the builtin without detaching, model=bpf
+		 * switches to the attached model again
+		 */
+		err = write_cost_model(dev, "ctrl=bpf");
+		ASSERT_ERR(err, "ctrl_bpf_rejected");
+
+		err = write_cost_model(dev, "model=linear");
+		ASSERT_OK(err, "model_linear_write");
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_linear"))
+			ASSERT_EQ(strcmp(model, "linear"), 0, "model_linear");
+
+		/* still attached: switching back to the model works */
+		err = write_cost_model(dev, "model=bpf");
+		ASSERT_OK(err, "model_bpf_write");
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_bpf"))
+			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");
+
+		bpf_link__destroy(skel->links.iocost_2x);
+		/* cleared, or the skeleton destroy below detaches again */
+		skel->links.iocost_2x = NULL;
+
+		/* after detach, model=bpf fails: nothing is attached */
+		err = write_cost_model(dev, "model=bpf");
+		ASSERT_ERR(err, "model_bpf_after_detach");
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
+ * they are serial.
+ */
+void serial_test_iocost_model_streams(void)
+{
+	struct iocost_ms *skel;
+	unsigned int maj, min;
+	int err;
+	char model[32], *dev;
+
+	dev = getenv("IOCOST_TEST_DEV");
+	if (!dev || geteuid() != 0 || sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		printf("%s:SKIP:needs root and IOCOST_TEST_DEV=<maj>:<min>\n",
+		       __func__);
+		test__skip();
+		return;
+	}
+
+	skel = iocost_ms__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	skel->struct_ops.iocost_ms->dev = (__u32)makedev(maj, min);
+
+	err = iocost_ms__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_ms__destroy(skel);
+		return;
+	}
+
+	err = iocost_ms__attach(skel);
+	if (err == -EOPNOTSUPP || err == -ENODEV) {
+		printf("%s:SKIP:device is not blk-mq, has no iocost or does not exist\n",
+		       __func__);
+		iocost_ms__destroy(skel);
+		test__skip();
+		return;
+	}
+	if (ASSERT_OK(err, "attach")) {
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback"))
+			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");
+
+		bpf_link__destroy(skel->links.iocost_ms);
+		skel->links.iocost_ms = NULL;
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
index 0000000000000..e4414d4802e2b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,141 @@
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
+ * twice the builtin model under the same read/write workload
+ * (the builtin prices flushes as zero; this model prices them
+ * as one-page writes), so the
+ * doubled cost is a direct check that accounting goes through the
+ * BPF path.  On a non-rotational device, or one with user-pinned
+ * coefficients, the ratio to the builtin model is arbitrary.
+ *
+ * The cursor handling follows the builtin: a zero cursor means "no
+ * previous IO", and the cursor is advanced for bios the builtin
+ * prices (READ/WRITE with a non-zero size; the builtin skips the
+ * whole update when the cost is zero), so flushes and discards
+ * leave it alone and long merged streams do not drift past the
+ * 16MB seek threshold.
+ *
+ * The model implements the full linear formula itself, including
+ * flushes: there is no fallback to the builtin model, which prices
+ * a dataless WRITE|REQ_PREFLUSH as zero; this model prices it as
+ * a one-page sequential write.
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
+ * per-cgroup cursor storage: keyed by the cgroup and freed with it,
+ * so a cgroup that comes back starts with no cursor
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
+		 * ops are priced per page at the write coefficient
+		 */
+		base = 0; coef_page = WPAGE; randio = 0;
+	}
+
+	/* mirror the builtin cursor semantics described above */
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
+	/*
+	 * a size-zero IO never moves the cursor, so it must not be
+	 * judged against it either; the builtin skips it entirely,
+	 * this model prices it as a one-page sequential write
+	 */
+	if (cur && priced && nbytes) {
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
+SEC(".struct_ops.link") /* detach on close */
+struct iocost_model_ops iocost_2x = {
+	.read_vtime_per_page = 2 * RPAGE,
+	.write_vtime_per_page = 2 * WPAGE,
+	.calc_cost = (void *)iocost_2x_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 0000000000000..c4bd5138a95ed
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,163 @@
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
+	advance = nbytes >> 9;	/* sectors, truncated like the builtin */
+
+	/*
+	 * only bios the builtin prices participate in stream tracking;
+	 * the early return below skips the merge discount, which only
+	 * applies to tracked data bios
+	 */
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
+SEC(".struct_ops.link") /* detach on close */
+struct iocost_model_ops iocost_ms = {
+	.read_vtime_per_page = RPAGE,
+	.write_vtime_per_page = WPAGE,
+	.calc_cost = (void *)iocost_ms_calc_cost,
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

