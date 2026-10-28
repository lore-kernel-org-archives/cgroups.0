Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198180;
	b=g245258hLLiKHCYZao2taGng8LIzzm9RSX1b9tU7p7XnPsoXmfiQVwfULjaR32U2IDzR
	 kjxt1H4i9j8nt0dy2YVECT/PfsGQlRTIQ8J12ExtGud9eFVIHBYcq4omf5dOAnJT2nPPE
	 VXfIdByOFQ9BeI7Zon0qU+KvxHLsrp22lE5WUPPHLEcVCmMu1mJb8SfVK+Ti7y7zDvUYU
	 IdCYsuB1tzkYVlFpe7XLGEz0eRIpL48r0ChFuNmTGTNchb/42xjBa5O+E2lC+XEO9B/D4
	 tXb7Xq0KEpJyUCN5jTaHtlB6eNBMxZlmfZaIZnXftVYgX8rYI8XhTPHRx+jNV57i/bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198180;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LQvqZGxbzyBvcq0Q9+494LxkG+PEciNSa7Qvt2H5qtI=;
	b=COoOrd0SsybXZrYdidbB6VL59CsgByukzi3ozRtcrbIACmSic5OO5xL1E6x8TaC9IIZy
	 VZXDUFYnjHfnmmKnfV5Tt+8nl8z7/Xolv8Nl0HyCayieJoQkawV2461/HioeV46QXfxeY
	 WBn7pNWRileVuIrR/cNdJC9j0UMIM4x//jYqn2i2PuAeQl5vLbLFIuEEVQIZLCdEIEhNX
	 TqTyq+bTO6LAXmof9uM685vx0LOXutFlitvLGKV6adFaH/33Rc1JgW8E5L23FDGJwj6VO
	 sE9NMqcMQPFF0HUVSdQJk3J1pm29ljFwQTH45OIA/FNga/2ndzdbqlAOABfM3yurLcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hRSTMtt8;
	arc=none smtp.remote-ip=95.215.58.188
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7465E606A327
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7465E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hRSTMtt8
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TQz+0humdudhgjZTD5BvWY2LOlWl40hSfdZfJyp+3ig=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793198176; v=1; x=1793802976;
 b=hRSTMtt8G36oJcQS7Bs0dFIi66DldaRAU2URZKOJFaTo+CCEkpsIplkWA332QEnHN7wbtHvB
 pnZxgiSDAhd3xQZWJOFHfqmZkUQAbWyfGTlUTWGIC1n8zPM3NCAKRIq9WRv+m+eWJKLFr8E/EpV
 qSVwk3ihcp8J7Jx0ZOwlbye4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id de9bdc35bde96d31;
	Wed, 28 Oct 2026 14:36:16 +0000
X-Mizu-Trace-ID: de9bdc35bde96d31
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
Subject: [PATCH 3/5] selftests/bpf: add iocost cost model test
Date: Wed, 28 Oct 2026 22:35:32 +0800
Message-ID: <20261028143534.135968-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add two example iocost cost models and tests which attach them to a
null_blk instance the tests create through configfs, so everything
runs without external setup.

The first model implements the builtin linear HDD formula at double
cost, plus iocg_init()/iocg_free() counters for the pairing checks.
The second implements the multi-stream sequentiality detection: it
keeps a per-cgroup table of stream slots instead of the single
builtin cursor, so concurrent sequential streams in one cgroup are
priced sequentially.  Both set the target device through the
struct_ops member before load, and the maps are declared
".struct_ops.link" so that a test dying in between does not leave
the model attached.

The tests verify the model=bpf readback while attached, that
ctrl=bpf is rejected, that a second model on the same device fails
with -EBUSY, that model=linear and model=bpf switch between the
attached and builtin models without detaching, and that detaching
restores the builtin model.  With the controller enabled through
io.cost.qos, they also verify that IOs are priced through
calc_cost(), that the iocost_ioc_tick tracepoint is seen from BPF,
and that iocg_init()/iocg_free() pair up across attach, detach, a
cgroup created while attached, and device removal under the
attached model, with a recreated device attachable again.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 806 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 201 +++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 175 ++++
 4 files changed, 1184 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_model.c
 create mode 100644 tools/testing/selftests/bpf/progs/iocost_ms.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 49dfe939467c..78ed59f83a16 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -141,3 +141,5 @@ CONFIG_SMC_HS_CTRL_BPF=y
 CONFIG_DIBS=y
 CONFIG_DIBS_LO=y
 CONFIG_PM_WAKELOCKS=y
+CONFIG_BLK_CGROUP_IOCOST=y
+CONFIG_BLK_DEV_NULL_BLK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/iocost_model.c b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
new file mode 100644
index 000000000000..5373d52d93a6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,806 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2026 KylinSoft Corporation. */
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/statfs.h>
+#include <linux/magic.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include "iocost_model.skel.h"
+#include "iocost_ms.skel.h"
+
+/*
+ * Write val to the configfs attribute at path, returning the errno of the
+ * write negated (0 on success).
+ */
+static int configfs_write(const char *path, const char *val)
+{
+	FILE *fp;
+	int err = 0;
+
+	fp = fopen(path, "w");
+	if (!fp)
+		return -errno;
+	if (fwrite(val, 1, strlen(val), fp) != strlen(val))
+		err = ferror(fp) ? -errno : -EIO;
+	if (fclose(fp) && !err)
+		err = -errno;
+	return err;
+}
+
+/*
+ * Read the first token of the file at path, for the dev attribute.
+ */
+static int read_file_token(const char *path, char *tok, size_t tok_sz)
+{
+	char fmt[16];
+	FILE *fp;
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -errno;
+	snprintf(fmt, sizeof(fmt), "%%%zus", tok_sz - 1);
+	if (fscanf(fp, fmt, tok) != 1) {
+		fclose(fp);
+		return -EIO;
+	}
+	fclose(fp);
+	return 0;
+}
+
+/*
+ * Create a null_blk instance through configfs and copy its maj:min
+ * into @dev. The device appears only once power is written, and is
+ * removed by rmdir of the instance directory; the maj:min comes from
+ * the sysfs directory of the created disk, which is named after the
+ * instance.
+ */
+static int nullb_create(const char *name, char *dev, size_t dev_sz)
+{
+	char path[128];
+	char p2[128];
+	int err;
+
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s", name);
+	if (mkdir(path, 0755)) {
+		if (errno != EEXIST)
+			return -errno;
+		/*
+		 * a leftover instance from an earlier crashed run may
+		 * still be powered: tear it down before reusing the
+		 * name
+		 */
+		snprintf(p2, sizeof(p2),
+			 "/sys/kernel/config/nullb/%s/power", name);
+		configfs_write(p2, "0");
+		if (rmdir(path) && errno != ENOENT)
+			return -errno;
+		if (mkdir(path, 0755) && errno != EEXIST)
+			return -errno;
+	}
+
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s/size", name);
+	err = configfs_write(path, "128");
+	if (err)
+		return err;
+
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s/power", name);
+	err = configfs_write(path, "1");
+	if (err)
+		return err;
+
+	snprintf(path, sizeof(path), "/sys/block/%s/dev", name);
+	err = read_file_token(path, dev, dev_sz);
+	if (err) {
+		/* do not leave a powered instance behind */
+		snprintf(path, sizeof(path),
+			 "/sys/kernel/config/nullb/%s/power", name);
+		configfs_write(path, "0");
+		snprintf(path, sizeof(path),
+			 "/sys/kernel/config/nullb/%s", name);
+		rmdir(path);
+	}
+	return err;
+}
+
+static int nullb_remove(const char *name)
+{
+	char path[128];
+
+	/* a powered instance cannot be removed */
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s/power", name);
+	configfs_write(path, "0");
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s", name);
+	if (rmdir(path))
+		return -errno;
+	return 0;
+}
+
+#define IOCOST_NULLB	"iocost_model_test"
+#define IOCOST_NULLB2	"iocost_model_test2"
+
+/*
+ * The tests run against their own null_blk instance created through configfs,
+ * so they need root, configfs and the null_blk driver.
+ */
+/*
+ * The BPF cost model needs cgroup v2 at /sys/fs/cgroup and
+ * CONFIG_BLK_CGROUP_IOCOST_BPF in the running kernel; both are environment
+ * properties, so their absence is a skip.
+ */
+static bool iocost_bpf_supported(void)
+{
+	FILE *f;
+	char line[128];
+	bool any = false, on = false;
+
+	f = popen("zcat /proc/config.gz 2>/dev/null", "r");
+	if (!f)
+		return false;
+	while (fgets(line, sizeof(line), f)) {
+		if (strstr(line, "CONFIG_"))
+			any = true;
+		if (strstr(line, "CONFIG_BLK_CGROUP_IOCOST_BPF=y"))
+			on = true;
+	}
+	pclose(f);
+	return on;
+}
+
+static bool iocost_test_env(void)
+{
+	struct statfs sf;
+
+	if (geteuid() != 0) {
+		printf("%s:SKIP:needs root\n", __func__);
+		test__skip();
+		return false;
+	}
+
+	if (statfs("/sys/fs/cgroup", &sf) ||
+	    sf.f_type != CGROUP2_SUPER_MAGIC) {
+		printf("%s:SKIP:needs cgroup v2 at /sys/fs/cgroup\n",
+		       __func__);
+		test__skip();
+		return false;
+	}
+
+	if (!iocost_bpf_supported()) {
+		printf("%s:SKIP:needs CONFIG_BLK_CGROUP_IOCOST_BPF\n",
+		       __func__);
+		test__skip();
+		return false;
+	}
+
+	/* isolate the configfs and cgroup mounts from the host */
+	if (unshare(CLONE_NEWNS)) {
+		printf("%s:SKIP:unshare(CLONE_NEWNS) failed: %s\n",
+		       __func__, strerror(errno));
+		test__skip();
+		return false;
+	}
+	mkdir("/sys/kernel/config", 0755);
+	(void)mount("none", "/sys/kernel/config", "configfs", 0, NULL);
+	SYS_NOFAIL("modprobe null_blk nr_devices=0");
+	if (access("/sys/kernel/config/nullb", W_OK)) {
+		printf("%s:SKIP:needs null_blk with configfs support\n",
+		       __func__);
+		test__skip();
+		return false;
+	}
+	return true;
+}
+
+/*
+ * Read back the io.cost.model line of dev and copy the model= value into
+ * @model. Returns 0 on success.
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
+ * Read the cost.usage accumulator of dev from the cgroup's io.stat. Returns 0
+ * on success, -ENODEV when the device has no line yet (no charge recorded).
+ */
+static int read_cost_usage(const char *cgroup, const char *dev,
+			   unsigned long long *usage)
+{
+	char line[512];
+	FILE *fp;
+	int found = 0;
+
+	fp = fopen(cgroup, "r");
+	if (!fp)
+		return -EIO;
+	*usage = 0;
+	while (fgets(line, sizeof(line), fp)) {
+		char *tok = strtok(line, " \n");
+
+		if (!tok || strcmp(tok, dev))
+			continue;
+		found = 1;
+		while ((tok = strtok(NULL, " \n"))) {
+			if (!strncmp(tok, "cost.usage=", 11)) {
+				*usage = strtoull(tok + 11, NULL, 0);
+				fclose(fp);
+				return 0;
+			}
+		}
+	}
+	fclose(fp);
+	return found ? -ENOENT : -ENODEV;
+}
+
+/* mkdir, recovering from a leftover of an aborted earlier run */
+static int cgroup_mkdir(const char *path)
+{
+	if (!mkdir(path, 0755))
+		return 0;
+	if (errno == EEXIST && !rmdir(path))
+		return mkdir(path, 0755) ? -errno : 0;
+	return -errno;
+}
+
+/*
+ * Write a line to io.cost.model for dev and return the errno of the write
+ * negated (0 on success), as ASSERT_ERR() expects.
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
+ * Attach the example model to the null_blk instance the test creates: the dev
+ * member is written through the struct_ops map's initial value before load,
+ * and attaching the struct_ops attaches the model to the device. Detaching the
+ * struct_ops restores the builtin model.
+ *
+ * Requires root, cgroup v2 and null_blk with configfs support.
+ */
+void serial_test_iocost_model(void)
+{
+	struct iocost_model *skel, *second, *bad;
+	unsigned int maj, min;
+	char pidbuf[16], buf[4096], path[64], qbuf[160], dev2[32];
+	int devfd, i, err, lfd;
+	char model[32], dev[32];
+	unsigned long long u1, u2, inits1;
+
+	if (!iocost_test_env())
+		return;
+	if (!ASSERT_OK(nullb_create(IOCOST_NULLB, dev, sizeof(dev)),
+		       "nullb_create"))
+		return;
+	if (sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		ASSERT_TRUE(false, "dev_parse");
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	skel = iocost_model__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open")) {
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	/*
+	 * a model with a zero coefficient must fail to attach instead of
+	 * silently zeroing the completion sizing (validate rejects it on
+	 * the map update the attach performs; the link form of the
+	 * struct_ops only reaches it there)
+	 */
+	bad = iocost_model__open();
+	if (!ASSERT_OK_PTR(bad, "bad_open")) {
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	bad->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+	bad->struct_ops.iocost_2x->write_vtime_per_page = 0;
+	if (ASSERT_OK(iocost_model__load(bad), "bad_load"))
+		ASSERT_EQ(iocost_model__attach(bad), -EINVAL,
+			  "attach_rejects_zero_coeff");
+	iocost_model__destroy(bad);
+
+	/* same for the read-side transfer coefficient */
+	bad = iocost_model__open();
+	if (!ASSERT_OK_PTR(bad, "bad_read_open")) {
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	bad->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+	bad->struct_ops.iocost_2x->read_vtime_per_page = 0;
+	if (ASSERT_OK(iocost_model__load(bad), "bad_read_load"))
+		ASSERT_EQ(iocost_model__attach(bad), -EINVAL,
+			  "attach_rejects_zero_read");
+	iocost_model__destroy(bad);
+
+	skel->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+	/*
+	 * create a cgroup for the pairing checks; its blkg comes to life
+	 * when the controller is enabled and the cgroup configured below,
+	 * exercising the iocg_init()/iocg_free() pairing end to end
+	 */
+	/*
+	 * Enable the io controller for the pairing cgroup: without it
+	 * the cgroup has no io.weight/io.stat and the iocg never
+	 * activates, so the model is consulted but nothing is charged.
+	 */
+	ASSERT_OK(configfs_write("/sys/fs/cgroup/cgroup.subtree_control",
+				 "+io"), "subtree_io");
+	if (!ASSERT_OK(cgroup_mkdir("/sys/fs/cgroup/iocost_pairing"),
+		       "mkdir_cg")) {
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	snprintf(pidbuf, sizeof(pidbuf), "%d", getpid());
+	ASSERT_OK(configfs_write("/sys/fs/cgroup/iocost_pairing/cgroup.procs",
+				  pidbuf), "cgroup_procs");
+	snprintf(path, sizeof(path), "/dev/%s", IOCOST_NULLB);
+	devfd = open(path, O_RDONLY);
+	if (!ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev")) {
+		configfs_write("/sys/fs/cgroup/cgroup.procs", pidbuf);
+		rmdir("/sys/fs/cgroup/iocost_pairing");
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	for (i = 0; i < 32; i++)
+		(void)read(devfd, buf, sizeof(buf));
+	close(devfd);
+	configfs_write("/sys/fs/cgroup/cgroup.procs", pidbuf);
+
+
+	err = iocost_model__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_model__destroy(skel);
+		rmdir("/sys/fs/cgroup/iocost_pairing");
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	err = iocost_model__attach(skel);
+	if (err == -EOPNOTSUPP || err == -ENODEV) {
+		printf("%s:SKIP:device is not blk-mq, has no iocost or does not exist\n",
+		       __func__);
+		iocost_model__destroy(skel);
+		rmdir("/sys/fs/cgroup/iocost_pairing");
+		nullb_remove(IOCOST_NULLB);
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
+			ASSERT_STREQ(model, "bpf", "model_bpf");
+
+		/*
+		 * the blkg created above was already on the blkg list
+		 * (online) when the attach walk ran, so the walk
+		 * delivered iocg_init() to it and to every other cgroup
+		 * which has a blkg on this device (the count depends on
+		 * the environment); none of them can have received
+		 * iocg_free() yet
+		 */
+		ASSERT_GT(skel->bss->iocg_inits, 0, "pair_init");
+		ASSERT_EQ(skel->bss->iocg_frees, 0, "pair_no_free");
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
+		 * pricing coverage: root cgroup IOs bypass the model, so
+		 * move into the pairing cgroup, enable the controller
+		 * and verify IOs actually go through calc_cost() and get
+		 * charged
+		 */
+		ASSERT_OK(configfs_write(
+				"/sys/fs/cgroup/iocost_pairing/cgroup.procs",
+				pidbuf), "procs_pairing_priced");
+		snprintf(qbuf, sizeof(qbuf), "%s 1000", dev);
+		ASSERT_OK(configfs_write(
+				"/sys/fs/cgroup/iocost_pairing/io.weight",
+				qbuf), "weight_pairing");
+		snprintf(qbuf, sizeof(qbuf),
+			 "%s enable=1 ctrl=user min=100.00 max=100.00", dev);
+		ASSERT_OK(configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf),
+			  "qos_enable");
+
+		devfd = open(path, O_RDONLY);
+		if (!ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev_priced")) {
+			iocost_model__destroy(skel);
+			configfs_write("/sys/fs/cgroup/cgroup.procs", pidbuf);
+			snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev);
+			(void)configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf);
+			if (rmdir("/sys/fs/cgroup/iocost_pairing") && errno != ENOENT)
+				printf("%s: rmdir cgroup failed: %s\n", __func__,
+				       strerror(errno));
+			nullb_remove(IOCOST_NULLB);
+			return;
+		}
+		ASSERT_OK(read_cost_usage("/sys/fs/cgroup/iocost_pairing/io.stat",
+					  dev, &u1), "cost_usage_pre");
+		for (i = 0; i < 500; i++)
+			(void)read(devfd, buf, sizeof(buf));
+		close(devfd);
+		ASSERT_GT(skel->bss->calc_costs, 0, "model_priced");
+		/*
+		 * the usage stat is flushed by the iocost timer, give
+		 * the current period a chance to end before reading
+		 */
+		sleep(3);
+		ASSERT_OK(read_cost_usage("/sys/fs/cgroup/iocost_pairing/io.stat",
+					  dev, &u2), "cost_usage_post");
+		ASSERT_GT(u2, u1, "cost_charged");
+		ASSERT_GT(skel->bss->ioc_ticks, 0, "tick_seen");
+
+		/*
+		 * a cgroup created while the model is attached gets its
+		 * iocg_init() when its first IO onlines the blkg
+		 */
+		inits1 = skel->bss->iocg_inits;
+		ASSERT_OK(cgroup_mkdir("/sys/fs/cgroup/iocost_late"),
+			  "mkdir_late");
+		ASSERT_OK(configfs_write(
+				"/sys/fs/cgroup/iocost_late/cgroup.procs",
+				pidbuf), "procs_late");
+		devfd = open(path, O_RDONLY);
+		if (ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev_late")) {
+			for (i = 0; i < 32; i++)
+				(void)read(devfd, buf, sizeof(buf));
+			close(devfd);
+		}
+		ASSERT_GT(skel->bss->iocg_inits, inits1, "late_init");
+		ASSERT_OK(configfs_write("/sys/fs/cgroup/cgroup.procs",
+					 pidbuf), "procs_back");
+		rmdir("/sys/fs/cgroup/iocost_late");
+
+		/*
+		 * a second device is independent: enabling it shows
+		 * the builtin model, not the one attached to the
+		 * first
+		 */
+		if (ASSERT_OK(nullb_create(IOCOST_NULLB2, dev2,
+					   sizeof(dev2)), "nullb_create2")) {
+			snprintf(qbuf, sizeof(qbuf),
+				 "%s enable=1 ctrl=auto", dev2);
+			ASSERT_OK(configfs_write(
+					"/sys/fs/cgroup/io.cost.qos", qbuf),
+				  "qos_nullb2");
+			err = readback_model(dev2, model, sizeof(model));
+			if (ASSERT_OK(err, "readback_nullb2"))
+				ASSERT_STREQ(model, "linear",
+					     "model_linear_nullb2");
+			snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev2);
+			ASSERT_OK(configfs_write(
+					"/sys/fs/cgroup/io.cost.qos", qbuf),
+				  "qos_nullb2_off");
+		}
+		nullb_remove(IOCOST_NULLB2);
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
+			ASSERT_STREQ(model, "linear", "model_linear");
+
+		/* still attached: the switch must not free the slot */
+		second = iocost_model__open();
+		if (ASSERT_OK_PTR(second, "second_open2")) {
+			second->struct_ops.iocost_2x->dev =
+				(__u32)makedev(maj, min);
+			err = iocost_model__load(second);
+			if (ASSERT_OK(err, "second_load2")) {
+				struct bpf_link *l2;
+
+				l2 = bpf_map__attach_struct_ops(
+						second->maps.iocost_2x);
+				if (!ASSERT_ERR_PTR(l2, "second_ebusy2"))
+					bpf_link__destroy(l2);
+				else
+					ASSERT_EQ(libbpf_get_error(l2), -EBUSY,
+						  "second_ebusy2_errno");
+			}
+			iocost_model__destroy(second);
+		}
+
+		/* still attached: switching back to the model works */
+		err = write_cost_model(dev, "model=bpf");
+		ASSERT_OK(err, "model_bpf_write");
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_bpf"))
+			ASSERT_STREQ(model, "bpf", "model_bpf");
+
+		/*
+		 * detach implicitly by closing the link fd instead of
+		 * calling bpf_link__destroy() explicitly: the release
+		 * path must detach the model just like the explicit
+		 * call does
+		 */
+		lfd = bpf_link__fd(skel->links.iocost_2x);
+		bpf_link__disconnect(skel->links.iocost_2x);
+		close(lfd);
+		skel->links.iocost_2x = NULL;
+
+		/* after detach, model=bpf fails: nothing is attached */
+		err = write_cost_model(dev, "model=bpf");
+		ASSERT_ERR(err, "model_bpf_after_detach");
+
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_after_detach"))
+			ASSERT_STREQ(model, "linear", "model_linear");
+
+		/* the detach walk delivered the matching iocg_free()s */
+		ASSERT_EQ(skel->bss->iocg_frees, skel->bss->iocg_inits,
+			  "pair_free");
+	}
+
+	iocost_model__destroy(skel);
+	(void)configfs_write("/sys/fs/cgroup/cgroup.procs", pidbuf);
+	snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev);
+	(void)configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf);
+	if (rmdir("/sys/fs/cgroup/iocost_pairing") && errno != ENOENT)
+		printf("%s: rmdir cgroup failed: %s\n", __func__,
+		       strerror(errno));
+	nullb_remove(IOCOST_NULLB);
+}
+/*
+ * Same check for the multi-stream example model. Only one model can be
+ * attached to a device at a time; each test creates its own device and
+ * attaches and detaches, so they are serial.
+ */
+void serial_test_iocost_model_streams(void)
+{
+	struct iocost_ms *skel;
+	unsigned int maj, min;
+	int err;
+	char model[32], dev[32];
+
+	if (!iocost_test_env())
+		return;
+	if (!ASSERT_OK(nullb_create(IOCOST_NULLB, dev, sizeof(dev)),
+		       "nullb_create"))
+		return;
+	if (sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		ASSERT_TRUE(false, "dev_parse");
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	skel = iocost_ms__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open")) {
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	skel->struct_ops.iocost_ms->dev = (__u32)makedev(maj, min);
+
+	err = iocost_ms__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_ms__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+
+	err = iocost_ms__attach(skel);
+	if (err == -EOPNOTSUPP || err == -ENODEV) {
+		printf("%s:SKIP:device is not blk-mq, has no iocost or does not exist\n",
+		       __func__);
+		iocost_ms__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		test__skip();
+		return;
+	}
+	if (ASSERT_OK(err, "attach")) {
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback"))
+			ASSERT_STREQ(model, "bpf", "model_bpf");
+
+		bpf_link__destroy(skel->links.iocost_ms);
+		skel->links.iocost_ms = NULL;
+
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_after_detach"))
+			ASSERT_STREQ(model, "linear", "model_linear");
+	}
+
+	iocost_ms__destroy(skel);
+	nullb_remove(IOCOST_NULLB);
+}
+
+/*
+ * Removal of the device while a model is attached: the test builds
+ * its own null_blk instance through configfs like the other tests,
+ * attaches to it, then removes the device out from under the model.
+ * The ejection must drop the device from the cgroup interface,
+ * down, and a recreated device must be attachable again.
+ */
+void serial_test_iocost_model_removal(void)
+{
+	struct iocost_model *skel, *skel2;
+	unsigned int maj, min;
+	char dev[32], model[32];
+	int err;
+
+	if (!iocost_test_env())
+		return;
+
+	skel = iocost_model__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	err = nullb_create("iocost_removal", dev, sizeof(dev));
+	if (!ASSERT_OK(err, "nullb_create"))
+		goto out;
+	if (sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		ASSERT_TRUE(false, "dev_parse");
+		goto out;
+	}
+
+	skel->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+	err = iocost_model__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto out;
+
+	err = iocost_model__attach(skel);
+	if (!ASSERT_OK(err, "attach"))
+		goto out;
+
+	err = readback_model(dev, model, sizeof(model));
+	if (ASSERT_OK(err, "readback"))
+		ASSERT_STREQ(model, "bpf", "model_bpf");
+
+	/* remove the device out from under the attached model */
+	if (!ASSERT_OK(nullb_remove("iocost_removal"), "nullb_remove"))
+		goto detach;
+
+	/* the ejection drops the device from the cgroup files */
+	err = readback_model(dev, model, sizeof(model));
+	ASSERT_ERR(err, "readback_after_removal");
+
+	err = write_cost_model(dev, "model=bpf");
+	ASSERT_ERR(err, "model_bpf_after_removal");
+
+	/*
+	 * the ejection path must deliver iocg_free() for every blkg
+	 * which was online on the removed device: pd_free() runs from
+	 * blkcg_deactivate_policy() before ioc_bpf_eject() drops the
+	 * map reference
+	 */
+	ASSERT_GT(skel->bss->iocg_inits, 0, "eject_had_inits");
+	ASSERT_EQ(skel->bss->iocg_frees, skel->bss->iocg_inits,
+		  "eject_balanced");
+
+detach:
+	/*
+	 * detaching after the device is gone must be a clean no-op;
+	 * this exercises the eject-then-detach ordering in the kernel
+	 */
+	bpf_link__destroy(skel->links.iocost_2x);
+	skel->links.iocost_2x = NULL;
+
+	/* the same attach and detach against a recreated device */
+	skel2 = iocost_model__open();
+	if (!ASSERT_OK_PTR(skel2, "skel2_open"))
+		goto out;
+
+	err = nullb_create("iocost_removal", dev, sizeof(dev));
+	if (!ASSERT_OK(err, "nullb_create_again"))
+		goto out2;
+	if (sscanf(dev, "%u:%u", &maj, &min) != 2) {
+		ASSERT_TRUE(false, "dev_parse_again");
+		goto out2;
+	}
+
+	skel2->struct_ops.iocost_2x->dev = (__u32)makedev(maj, min);
+	err = iocost_model__load(skel2);
+	if (!ASSERT_OK(err, "skel2_load"))
+		goto out2;
+
+	err = iocost_model__attach(skel2);
+	if (!ASSERT_OK(err, "attach_again"))
+		goto out2;
+
+	err = readback_model(dev, model, sizeof(model));
+	if (ASSERT_OK(err, "readback_again"))
+		ASSERT_STREQ(model, "bpf", "model_bpf_again");
+	ASSERT_GT(skel2->bss->iocg_inits, 0, "pair_init_again");
+
+	bpf_link__destroy(skel2->links.iocost_2x);
+	skel2->links.iocost_2x = NULL;
+
+	err = readback_model(dev, model, sizeof(model));
+	if (ASSERT_OK(err, "readback_after_detach_again"))
+		ASSERT_STREQ(model, "linear", "model_linear_again");
+
+	/* the re-attach walk delivered init for the recreated device */
+	ASSERT_EQ(skel2->bss->iocg_frees, skel2->bss->iocg_inits,
+		  "pair_balanced_again");
+
+out2:
+	iocost_model__destroy(skel2);
+out:
+	nullb_remove("iocost_removal");
+	iocost_model__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 000000000000..8875fb0f4417
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2026 KylinSoft Corporation. */
+/*
+ * Example iocost cost model: the builtin linear HDD formula with all costs
+ * doubled, for one device given by the dev member of the struct_ops.
+ *
+ * The constants mirror what calc_lcoefs() derives from the AUTOP_HDD defaults
+ * (rbps=174019176 rseqiops=41708 rrandiops=370, w-side analog) in vtime units
+ * where 1s == 2^37. On a rotational device still on ctrl=auto, a device with
+ * this model attached charges twice the builtin model under the same
+ * read/write workload (the builtin prices flushes as zero and adds a fixed
+ * flush term to data-bearing preflushes, which this model omits; this model
+ * prices flushes as one-page writes), so the doubled cost is a direct check
+ * that accounting goes through the BPF path. On a non-rotational device, or
+ * one with user-pinned coefficients, the ratio to the builtin model is
+ * arbitrary.
+ *
+ * The cursor handling follows the builtin: a zero cursor means "no previous
+ * IO", and the cursor is advanced for the bios the builtin prices
+ * (READ/WRITE/ZONE_APPEND with a non-zero size), so flushes and discards leave
+ * it alone and long merged streams do not drift past the 16MB seek threshold.
+ * One known deviation, mispricing only: the builtin does not move its cursor
+ * for an IO whose cgroup fails to activate; this model does not see the
+ * activation result.
+ *
+ * The model implements the full linear formula itself, including flushes:
+ * there is no fallback to the builtin model, which prices a dataless
+ * WRITE|REQ_PREFLUSH as zero unless flushiops is configured; this model prices
+ * it as a one-page sequential write. What a flush actually costs depends on
+ * the IOs before it, which a static formula cannot express - pricing it as a
+ * small constant is a crude penalty for unnecessarily frequent flushes, and a
+ * stateful model would be the way to do better. Discards and other unpriced
+ * operations pass through at zero cost, like the builtin.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/*
+ * VTIME_PER_SEC, IOC_PAGE_SIZE/SHIFT, IOC_SECT_TO_PAGE_SHIFT,
+ * LCOEF_RANDIO_PAGES (the 16MB seek threshold) and IOCOST_COST_F_MERGE
+ * come from vmlinux.h (BTF constants; the enum64 ones need pahole
+ * >= 1.23 to be emitted)
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
+/*
+ * cgroup callback counters: the test reads them back to verify the
+ * init/free pairing across attach, detach and device removal
+ */
+__u64 iocg_inits;
+__u64 iocg_frees;
+
+/*
+ * incremented by calc_cost(): the test asserts pricing went
+ * through the model while it is attached and the controller is
+ * enabled
+ */
+__u64 calc_costs;
+
+/* counts iocost_ioc_tick emissions observed from BPF side */
+__u64 ioc_ticks;
+
+SEC("struct_ops")
+void BPF_PROG(iocost_2x_iocg_init, struct blkcg *blkcg,
+	      struct request_queue *q)
+{
+	iocg_inits++;
+}
+
+SEC("struct_ops")
+void BPF_PROG(iocost_2x_iocg_free, struct blkcg *blkcg,
+	      struct request_queue *q)
+{
+	iocg_frees++;
+}
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
+	calc_costs++;
+
+	/* builtin truncates: max(sectors >> IOC_SECT_TO_PAGE_SHIFT, 1) */
+	pages = nbytes >> IOC_PAGE_SHIFT;
+	if (!pages)
+		pages = 1;
+
+	if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ) {
+		base = RSEQIO; coef_page = RPAGE; randio = RRANDIO;
+	} else if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE ||
+		   (opf & IOCOST_REQ_OP_MASK) == REQ_OP_ZONE_APPEND) {
+		base = WSEQIO; coef_page = WPAGE; randio = WRANDIO;
+	} else {
+		/*
+		 * the builtin prices other operations at zero and
+		 * leaves them unthrottled; pass them through the same
+		 * way instead of inventing costs
+		 */
+		return 0;
+	}
+
+	/* mirror the builtin cursor semantics described above */
+	priced = (opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
+		 (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE ||
+		 (opf & IOCOST_REQ_OP_MASK) == REQ_OP_ZONE_APPEND;
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
+	/*
+	 * the builtin moves the cursor unconditionally on submit, but
+	 * on a merge only for a back merge into the request ending at
+	 * it; a merged bio starts right at the cursor exactly then,
+	 * and a zero cursor means no history so it never matches
+	 */
+	if (priced && nbytes &&
+	    (!(model_flags & IOCOST_COST_F_MERGE) || (cur && cur == sector)))
+		*cursor = sector + (nbytes >> 9);
+
+	if (model_flags & IOCOST_COST_F_MERGE)
+		base = 0;
+
+	cost = 2 * (base + pages * coef_page);
+	return cost;
+}
+
+/* consumes the new iocost_ioc_tick tracepoint from BPF side */
+SEC("tp_btf/iocost_ioc_tick")
+__u64 BPF_PROG(iocost_2x_tick_count, struct ioc *ioc,
+	       const struct ioc_now *now, int nr_active, u64 usage_us_sum)
+{
+	ioc_ticks++;
+	return 0;
+}
+
+SEC(".struct_ops.link") /* detach on close */
+struct iocost_model_ops iocost_2x = {
+	.read_vtime_per_page = 2 * RPAGE,
+	.write_vtime_per_page = 2 * WPAGE,
+	.calc_cost = (void *)iocost_2x_calc_cost,
+	.iocg_init = (void *)iocost_2x_iocg_init,
+	.iocg_free = (void *)iocost_2x_iocg_free,
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 000000000000..87d4abcbf693
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2026 KylinSoft Corporation. */
+/*
+ * Example multi-stream sequentiality detection cost model.
+ *
+ * The builtin model keeps a single cursor per cgroup, so two interleaved
+ * sequential readers in one cgroup are all priced random (measured 89x
+ * overcharge, 12.9x throughput collapse), while random IO inside a hot window
+ * smaller than the 16MB seek threshold is priced sequential (measured 107x
+ * undercharge). This model replaces the single cursor with a per-cgroup table
+ * of stream slots: an IO is sequential iff its sector matches the expected
+ * next sector of any tracked stream. Interleaved streams keep their own slots,
+ * and windowed random IO rarely matches a moving expectation.
+ *
+ * Stream state lives in a CGRP_STORAGE map, so it is created and freed with
+ * the cgroup. The model implements the builtin linear formula itself; unlike
+ * the builtin it has no flush term, so preflushed IOs are priced as plain
+ * writes (mispricing only, the test never issues flushes).
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
+	} else if ((opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE ||
+		   (opf & IOCOST_REQ_OP_MASK) == REQ_OP_ZONE_APPEND) {
+		base = WSEQIO; coef_page = WPAGE; randio = WRANDIO;
+	} else {
+		/*
+		 * the builtin prices other operations at zero and
+		 * leaves them unthrottled; pass them through the same
+		 * way instead of inventing costs
+		 */
+		return 0;
+	}
+	advance = nbytes >> 9;	/* sectors, truncated like the builtin */
+
+	/*
+	 * only bios the builtin prices participate in stream tracking;
+	 * the early return below skips the merge discount, which only
+	 * applies to tracked data bios
+	 */
+	if (!(((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
+	       (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE ||
+	       (opf & IOCOST_REQ_OP_MASK) == REQ_OP_ZONE_APPEND) && nbytes)) {
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
+		/*
+		 * a merge which matches no slot is not a new stream:
+		 * replacing a slot could evict a live stream, so merged
+		 * bios are priced without touching the table (and skip
+		 * the base cost below)
+		 */
+		if (!(model_flags & IOCOST_COST_F_MERGE)) {
+			base = randio;
+			for (i = 1; i < NSLOTS; i++) {
+				if (s->stamp[i] < s->stamp[victim])
+					victim = i;
+			}
+			s->expected[victim] = sector + advance;
+			s->stamp[victim] = now;
+		}
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

