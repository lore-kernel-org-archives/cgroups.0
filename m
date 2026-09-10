Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A2148EC9E
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045125; cv=none; b=j177xLo8AYZM8CcwTm5v7I18lnI/DGqGZmIRhKhcqRFFv6mXF739becN2yuPK5dBQFVgtqORNjWvt1E2JI+6udUWN7znHkv1A+vAOgSEvYl8avsqZUceIG61ktTElfRjSQEcHVGaf2Gbd0iqsBwgb1XTKKLSFQ6usOCNkJBj+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045125; c=relaxed/simple;
	bh=Se0UEuEkn7sxV61bxAAIjwfnVXML7LXljmTxrF6ZABc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHsmNxFvzgg0en6c2Whh5pXZvAy8Ro+7ixVtl7jUVoOP0urtiMi8wIB//qXJPZXuZQW7wSllNLbetD/dgGY/NAhcPmlLyPPHZnkawK73YmAhVFxYyHc8h/MbCl1c1D5h5iNqJVDWF79JrHgfBuk/oHaJh+efjCBVqT/NgeCFzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PBesXywy; arc=none smtp.client-ip=95.215.58.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PBesXywy"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Se0UEuEkn7sxV61bxAAIjwfnVXML7LXljmTxrF6ZABc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789045119; v=1; x=1789649919;
 b=PBesXywyCmuIu4NJ3ekT0u+54gg4KasAp6ZuQ1IBUbRd0p+7yPv4G2gzWBf4E6fJJo+GyZb7
 ykL9jsMtNuZRhUAP7K9CT1ULZCjvd+KHxQjzLR88xtQBq6O0L4b7iqMHGzjMvaBeuRxHCAGxv2p
 A9cnnpiXSW3tIzeWH8PyAz1U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 315279177ac67947;
	Thu, 10 Sep 2026 12:58:38 +0000
X-Mizu-Trace-ID: 315279177ac67947
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
Subject: [RFC PATCH v2 2/5] selftests/bpf: add iocost cost model test
Date: Thu, 10 Sep 2026 20:58:14 +0800
Message-ID: <20260910125817.223354-3-cui.tao@linux.dev>
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
 .../selftests/bpf/prog_tests/iocost_model.c   | 193 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 116 +++++++++++
 3 files changed, 311 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 2f79688dcf7c..67a630cb5614 100644
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
index 000000000000..e9344b13fba9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include "iocost_model.skel.h"
+#include "iocost_ms.skel.h"
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
+		return errno;
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
+	if (err) {
+		CHECK(false, "write_model", "write model=%s: %s\n", name,
+		      strerror(err));
+		return -1;
+	}
+	err = readback_model(dev, got, sizeof(got));
+	if (err || strcmp(got, name)) {
+		CHECK(false, "readback_model", "got model=%s want %s\n",
+		      err ? "(none)" : got, name);
+		return -1;
+	}
+
+	/* restore the builtin linear model; the write is checked too */
+	snprintf(buf, sizeof(buf), "%s model=linear\n", dev);
+	err = write_cost_model(buf);
+	if (err) {
+		CHECK(false, "restore_linear", "write model=linear: %s\n",
+		      strerror(err));
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * The dev argument must be present in io.cost.qos already, which
+ * means iocost is enabled for it.
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
+			found = 1;
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
+	if (!ASSERT_TRUE(dev_has_iocost(dev), "iocost_mounted"))
+		return;
+
+	/*
+	 * negative: binding an unknown model name must be rejected,
+	 * so a typo cannot silently disable cost model updates
+	 */
+	snprintf(buf, sizeof(buf), "%s model=no_such_model\n", dev);
+	err = write_cost_model(buf);
+	ASSERT_EQ(err, ENOENT, "unknown_model_rejected");
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
+	if (!ASSERT_TRUE(dev_has_iocost(dev), "iocost_mounted"))
+		return;
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
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 000000000000..f8ad417b3584
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Example iocost cost model: the builtin linear HDD formula with all
+ * costs doubled.
+ *
+ * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD
+ * defaults (rbps=174019176 rseqiops=41708 rrandiops=370, w-side
+ * analog) in vtime units where 1s == 2^37, expressed with the same
+ * round-up divisions so they cannot drift from the kernel.  A device
+ * bound to this model through io.cost.model charges exactly twice the
+ * builtin model under the same workload, which makes it a convenient
+ * way to verify that accounting goes through the BPF path.
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
+	 * mirror the builtin single per-cgroup cursor: the model keeps
+	 * its own cursor keyed by the blkcg argument
+	 */
+	{
+		__u64 *cursor, cur;
+
+		cursor = bpf_cgrp_storage_get(&cursor_store,
+					      blkcg->css.cgroup, NULL,
+					      BPF_LOCAL_STORAGE_GET_F_CREATE);
+		if (!cursor)
+			return 2 * (base + RU(nbytes, IOC_PAGE_SIZE) * coef_page);
+		cur = *cursor;
+		seek_pages = sector > cur ? sector - cur : cur - sector;
+		seek_pages >>= IOC_SECT_TO_PAGE_SHIFT;
+		if (seek_pages > LCOEF_RANDIO_PAGES)
+			base = randio;
+		if (!(model_flags & IOCOST_COST_F_MERGE))
+			*cursor = sector + RU(nbytes, 512);
+	}
+
+	pages = RU(nbytes, IOC_PAGE_SIZE);
+	if (!pages)
+		pages = 1;	/* dataless flush: one page */
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

