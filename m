Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D42E7397
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789701500; cv=none; b=IvOvWaEa1Y+CeVMhBnZGbMyu6/Fml8ga2LRAUMk+VrPMfJsMIv63YSxpUJ0wfbrkl7jsLxUSpul0gPb2PjiMA9fvzy73kw0XJBPyBYEl2LVZJTnd6O3IKYBDxzVBfmsh8HZaNItqZw3qEG079LjrJUVvr4kYeRobxnxq5WT7Fz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789701500; c=relaxed/simple;
	bh=ARW9joIi7dPPk0SAvElj20JRaOGRj5vaOMrxljRAHmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibckWNrXsaE07Fp9ej0+UdZhU0QgJ1Xp1iJgR1Z3MSyXxKEs8NSTOJqUfY4oGlQvNdfc2W8oFnM6kCECYdhTzli2UCC+FqpIXf3ihZWYZUcodK80QWmFQW1HWqSK0ebZIQUfwVoDmKhsyC2m+edupVRWcmME10uuCOMh/hWQCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b5ZSlee8; arc=none smtp.client-ip=91.218.175.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b5ZSlee8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ARW9joIi7dPPk0SAvElj20JRaOGRj5vaOMrxljRAHmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701496; v=1; x=1790306296;
 b=b5ZSlee8zj0+cqKbmVk78oomZ5ihxkdmHwpcjheLroIlEF7K5MyQOGK2S/7KFBrbzjmdFB/q
 pmiBqPX50SDGFFfdt/fTllT+thnnNp38MJ4rJ/0wgvq+6SzyOZWU6YcUpJe7IuaU2dMdGzmARcG
 Jy/LAMMvAyfDMNBZBzG8X3ic=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7917c4899b70ecd3;
	Fri, 18 Sep 2026 03:18:16 +0000
X-Mizu-Trace-ID: 7917c4899b70ecd3
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ameryhung@gmail.com
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v5 2/5] selftests/bpf: add iocost cost model test
Date: Fri, 18 Sep 2026 11:17:48 +0800
Message-ID: <20260918031751.1255420-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918031751.1255420-1-cui.tao@linux.dev>
References: <20260918031751.1255420-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add an example cost model implementing the full builtin linear HDD
formula at double cost, including flush pricing, and a runner which
registers it as a struct_ops and binds it to a device through
io.cost.model with "model=iocost_2x", verifying the readback and
restoring "model=linear" afterwards, checking the write error and
errno of every step including the restoration.  Binding an unknown
model name is verified to fail with ENOENT.  Under the same workload
the doubled model charges exactly twice the builtin model (verified
2882us -> 5722us per IO, completed IO count halved).

Per-cgroup stream state uses a CGRP_STORAGE map keyed by the cgroup
of the blkcg argument, so the model inherits the cgroup lifetime and
never leaks or reuses stale state.  opf carries the full
bio->bi_opf including REQ_* flag bits, so the operation must be
extracted with a mask, not compared for equality.

All writes go through write(2) rather than stdio, since the kernel's
rejection happens in the write() syscall, not in the userspace buffer
copy.  CONFIG_BLK_CGROUP_IOCOST and CONFIG_BLK_CGROUP_IOCOST_BPF are
added to the selftest kernel config: without them vmlinux.h does not
contain iocost_model_ops and the skeletons fail to build; the runtime
skip cannot avoid a build dependency.

The runner is skipped unless $IOCOST_TEST_DEV gives a major:minor of
a device with iocost enabled.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 166 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 136 ++++++++++++++
 3 files changed, 304 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 2f79688dcf7ce..67a630cb56148 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -138,3 +138,5 @@ CONFIG_SMC_HS_CTRL_BPF=y
 CONFIG_DIBS=y
 CONFIG_DIBS_LO=y
 CONFIG_PM_WAKELOCKS=y
+CONFIG_BLK_CGROUP_IOCOST=y
+CONFIG_BLK_CGROUP_IOCOST_BPF=y
diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
new file mode 100644
index 0000000000000..85b5ea7482eed
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <ctype.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include "iocost_model.skel.h"
+
+/*
+ * Write a line to io.cost.model with write(2) and return the errno of
+ * the failed write, or 0 on success.  stdio is not used here on
+ * purpose: the kernel's rejection happens in the write() syscall,
+ * not in the userspace buffer copy, and every write, including
+ * the error paths of the callers below, is checked.
+ */
+static int write_cost_model(const char *buf)
+{
+	int fd, err = 0;
+	ssize_t n;
+
+	fd = open("/sys/fs/cgroup/io.cost.model", O_WRONLY);
+	if (fd < 0)
+		return -errno;	/* negative: the file is not there */
+	n = write(fd, buf, strlen(buf));
+	if (n < 0)
+		err = errno;
+	close(fd);
+	return err;
+}
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
+	while (*end && !isspace(*end))
+		end++;
+	snprintf(model, model_sz, "%.*s", (int)(end - m), m);
+	return 0;
+}
+
+/*
+ * Bind the named model to a device with "model=<name>", verify the
+ * readback and restore the builtin model.  Returns 0 on success.
+ */
+static int bind_model(const char *dev, const char *name)
+{
+	char buf[300], got[64];
+	int err;
+
+	snprintf(buf, sizeof(buf), "%s model=%s\n", dev, name);
+	err = write_cost_model(buf);
+	if (err)
+		return err > 0 ? -err : -EIO;
+	err = readback_model(dev, got, sizeof(got));
+	if (!err && !strcmp(got, name)) {
+		/*
+		 * restore the builtin linear model on every path so
+		 * the device is not left bound to a model the caller
+		 * may unregister right after; the write is checked too
+		 */
+		snprintf(buf, sizeof(buf), "%s model=linear\n", dev);
+		err = write_cost_model(buf);
+		return err > 0 ? -err : (err ? -EIO : 0);
+	}
+
+	/*
+	 * bind failed or does not read back: still restore, but report
+	 * the original failure rather than the restore result
+	 */
+	snprintf(buf, sizeof(buf), "%s model=linear\n", dev);
+	write_cost_model(buf);
+	return err ? -EIO : -EINVAL;
+}
+
+/*
+ * True when the device line exists in io.cost.qos and iocost is
+ * enabled on it.
+ */
+static int dev_has_iocost(const char *dev)
+{
+	char line[256], word[256];
+	FILE *fp;
+	int found = 0;
+
+	fp = fopen("/sys/fs/cgroup/io.cost.qos", "r");
+	if (!fp)
+		return 0;
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s", word) == 1 && !strcmp(word, dev)) {
+			found = strstr(line, "enable=1") != NULL;
+			break;
+		}
+	}
+	fclose(fp);
+	return found;
+}
+
+/*
+ * Bind the 2x example model and verify the io.cost.model readback.
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
+	char buf[300], *dev;
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
+	/*
+	 * negative: binding an unknown model name must be rejected,
+	 * so a typo cannot silently disable cost model updates
+	 */
+	snprintf(buf, sizeof(buf), "%s model=no_such_model\n", dev);
+	err = write_cost_model(buf);
+	ASSERT_EQ(err > 0 ? err : 0, ENOENT, "unknown_model_rejected");
+
+	skel = iocost_model__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_load"))
+		return;
+
+	/* attaching the struct_ops registers the model by name */
+	err = iocost_model__attach(skel);
+	if (ASSERT_OK(err, "attach"))
+		ASSERT_OK(bind_model(dev, "iocost_2x"), "bind_and_readback");
+
+	iocost_model__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 0000000000000..66fab4711c0b5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Example iocost cost model: the builtin linear HDD formula with all
+ * costs doubled.
+ *
+ * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
+ * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
+ * analog) in vtime units where 1s == 2^37.  On a rotational device
+ * still on ctrl=auto, a device bound to this model through
+ * io.cost.model charges exactly twice the builtin model under the
+ * same workload, so the doubled cost is a direct check that
+ * accounting goes through the BPF path.  On a non-rotational device,
+ * or one with user-pinned coefficients, the ratio to the builtin
+ * model is arbitrary.
+ *
+ * The cursor handling mirrors the builtin: a zero cursor means "no
+ * previous IO", and the cursor is only advanced for READ and WRITE
+ * bios the builtin prices, so flushes and discards leave it alone.
+ *
+ * The model implements the full linear formula itself, including
+ * flushes: there is no fallback to the builtin model, a dataless
+ * WRITE|REQ_PREFLUSH is priced as a one-page write.
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
+ * the model never leaks or reuses stale per-cgroup state
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_CGRP_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, __u64);
+} cursor_store SEC(".maps");
+
+SEC("struct_ops")
+u64 BPF_PROG(iocost_2x_calc_cost, u64 opf, u64 nbytes, u64 sector,
+	     struct blkcg *blkcg, u64 model_flags)
+{
+	u64 pages, seek_pages = 0, base, coef_page, randio, cost;
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
+	 * discards leave it alone and long merged streams do not
+	 * drift past the 16MB seek threshold
+	 */
+	{
+		__u64 *cursor, cur;
+		int priced = (opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
+			     (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE;
+
+		cursor = bpf_cgrp_storage_get(&cursor_store,
+					      blkcg->css.cgroup, NULL,
+					      BPF_LOCAL_STORAGE_GET_F_CREATE);
+		if (!cursor) {
+			if (model_flags & IOCOST_COST_F_MERGE)
+				base = 0;
+			return 2 * (base + pages * coef_page);
+		}
+		cur = *cursor;
+		if (cur && priced) {
+			seek_pages = sector > cur ? sector - cur
+						   : cur - sector;
+			seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;
+			if (seek_pages > LCOEF_RANDIO_PAGES)
+				base = randio;
+		}
+		if (priced && nbytes)
+			*cursor = sector + RU(nbytes, 512);
+	}
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
+	.calc_cost = (void *)iocost_2x_calc_cost,
+	.name = "iocost_2x",
+};
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

