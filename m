Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967882;
	b=iqhMg6a6s4gn6jTK5x2QGyAaX57aRcvyX2PDUxt1AGeWWMY5hBpaJUcVKXMz+CUhkm/o
	 1ID2LtmVxm06zzuVNPJC4mSBCD9/Z0Faf2WWBz1qY2E6hb0AqXB94EblOr21liiWxI6XD
	 SJS2ZFSAaR34ekmxmujEehYcmiaC7BTnGSl6I9e3Tq6g1qDewxwGlii33BJQqzVtsQNYc
	 k73DDMXVl0bb1VNt+rmf3O3G+TwAPCqzf2ykBgrIkk9KgMLcXM2WP92WySZZjTmdAgvRn
	 fSHc8uFjJpufUHbALvUDz9+CxRM72P4KIJFUoYVcrM7g66pXc48suGjNnKn9UbgbgOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967882;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=J6+52ol2pwi97rtdVb38NGbh7jzPw8JO8blcw4B5nGo=;
	b=hHBk3O6dxWCc2xJODdD7AklRVkK35tabxwWjUUO8DP8LJaGYRc1lBaXPAA/5RRISPSUS
	 BiMFDOnKgM/k5gk7YTXdmooh4sP0+sltnR2kxqtjh3vEBh3tYpiJwLqFenkJAzxwXdVsM
	 l8jgIXEFFcF8Gqk1PSgaNc7b5sge90Q/BPxd61zBMiIuLOjTFsGNk9edt0QU2oceCc8hv
	 UCTOEBfQ5/fiDX9DlNGMfmR9AML2hI6eZfGVAolSx2wt4YrYeMe9mehbLjsVB/S8OOIin
	 v8ZQAwS8wKqmwbjBvL3bNcTBpGLPBUHCdA5PCwH/1uOmmkLcXz2INH8HH0VQYaLzazA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c8wI9nQv;
	arc=none smtp.remote-ip=91.218.175.125
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0088606A333
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 12:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0088606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c8wI9nQv
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lc7ZlkJnEfxIv3HVbQZhu7Yc72cgzqryegPQAUtFvcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793967879; v=1; x=1794572679;
 b=c8wI9nQv2Ff0SsJOzi9KQ9kUbMdPWYxUG4iXiTZ0NCXmHI1X5DMiJER7FpsV66Cc7j1yIFuV
 y0OEa35ejEcipFAUeFsAIomqsA/5JQqo1OiMEW8r7G4cZHR+IRE5ay6J+qZZgqWC5/Lj2qHpBME
 8wdl/vfXVhewt1QP6gRhoE3g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 69cd0e3f064b7af0;
	Fri, 06 Nov 2026 12:24:39 +0000
X-Mizu-Trace-ID: 69cd0e3f064b7af0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	alexei.starovoitov@gmail.com
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
	ameryhung@gmail.com
Subject: [RFC PATCH v13 3/4] selftests/bpf: add iocost cost model test
Date: Fri,  6 Nov 2026 20:23:55 +0800
Message-ID: <20261106122356.3224638-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106122356.3224638-1-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev>
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
cost.  The second implements multi-stream sequentiality detection: it
keeps a per-cgroup table of stream slots instead of the single builtin
cursor, so concurrent sequential streams in one cgroup are priced
sequentially.  Both set the target device through the struct_ops
member before load, and the maps are declared ".struct_ops.link" so
that a test dying in between does not leave the model attached.

The tests verify the model=bpf readback while attached, that ctrl=bpf
is rejected, that a second model on the same device fails with -EBUSY,
that model=linear and model=bpf switch between the attached and
builtin models without detaching, and that detaching restores the
builtin model.  With the controller enabled through io.cost.qos, they
also verify that IOs are priced through calc_cost() and that the
iocost_ioc_tick tracepoint is seen from BPF.  They also verify that
device removal under the attached model ejects it, with a recreated
device attachable again.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/iocost_model.c   | 812 ++++++++++++++++++
 .../selftests/bpf/progs/iocost_model.c        | 180 ++++
 tools/testing/selftests/bpf/progs/iocost_ms.c | 197 +++++
 4 files changed, 1191 insertions(+)
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
index 000000000000..a714507c040e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/iocost_model.c
@@ -0,0 +1,812 @@
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
+#include "cgroup_helpers.h"
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
+		err = ferror(fp) ? (errno ? -errno : -EIO) : -EIO;
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
+		goto err_rmdir;
+
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s/power", name);
+	err = configfs_write(path, "1");
+	if (err)
+		goto err_rmdir;
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
+
+	/*
+	 * roll the half-created instance back: power it off in case the
+	 * failure left it on, then remove the directory
+	 */
+err_rmdir:
+	snprintf(p2, sizeof(p2), "/sys/kernel/config/nullb/%s/power", name);
+	configfs_write(p2, "0");
+	snprintf(path, sizeof(path), "/sys/kernel/config/nullb/%s", name);
+	rmdir(path);
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
+/*
+ * register_bpf_struct_ops() emits the "bpf_struct_ops_iocost_model_ops"
+ * wrapper type into /sys/kernel/btf/vmlinux only when the struct_ops
+ * registration is compiled in.  The bare "iocost_model_ops" struct is
+ * no such signal: blk-iocost.c defines it outside the config guard and
+ * its name lands in the BTF whenever the file is built, even if the
+ * registration itself is compiled out.  Probing the wrapper name is
+ * what makes this definitive.
+ */
+static bool iocost_bpf_supported(void)
+{
+	static const char probe[] = "bpf_struct_ops_iocost_model_ops";
+	static int cached = -1;
+	struct stat st;
+	char *buf = NULL;
+	ssize_t got, total = 0;
+	bool on = false;
+	int fd;
+
+	if (cached >= 0)
+		return cached;
+
+	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	if (!fstat(fd, &st) && st.st_size)
+		buf = malloc(st.st_size);
+
+	/* reads may come up short; keep going until EOF */
+	if (buf) {
+		while (total < st.st_size) {
+			got = read(fd, buf + total, st.st_size - total);
+			if (got <= 0)
+				break;
+			total += got;
+		}
+		if (total == st.st_size)
+			on = memmem(buf, total, probe,
+				    sizeof(probe) - 1) != NULL;
+		free(buf);
+	}
+	close(fd);
+	cached = on;
+	return on;
+}
+
+static bool iocost_test_env(void)
+{
+	static bool ready;
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
+	/*
+	 * The private mount namespace and the configfs mount are
+	 * process-wide: set them up once so serial tests do not stack
+	 * namespaces and pile configfs mounts on top of each other.
+	 */
+	if (ready)
+		return true;
+
+	/* isolate the configfs and cgroup mounts from the host */
+	if (unshare(CLONE_NEWNS) ||
+	    mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
+		printf("%s:SKIP:cannot make mounts private: %s\n",
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
+	ready = true;
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
+	char buf[4096], *save = NULL, *linep, *tok, *word;
+	int found = 0, ret;
+
+	ret = read_cgroup_file(cgroup, "io.stat", buf, sizeof(buf));
+	if (ret)
+		return ret;
+	for (linep = strtok_r(buf, "\n", &save); linep;
+	     linep = strtok_r(NULL, "\n", &save)) {
+		char *wsave = NULL;
+
+		tok = strtok_r(linep, " \t", &wsave);
+		if (!tok || strcmp(tok, dev))
+			continue;
+		found = 1;
+		while ((word = strtok_r(NULL, " \t", &wsave))) {
+			if (!strncmp(word, "cost.usage=", 11)) {
+				*usage = strtoull(word + 11, NULL, 0);
+				return 0;
+			}
+		}
+	}
+	return found ? -ENOENT : -ENODEV;
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
+		err = ferror(fp) ? (errno ? -errno : -EIO) : -EIO;
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
+	char buf[4096], path[64], qbuf[160], dev2[32];
+	int devfd, i, err, cg;
+	char model[32], dev[32];
+	unsigned long long u1 = 0, u2 = 0;
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
+	 * Enable the io controller for the priced-IO cgroup: without it
+	 * the cgroup has no io.weight/io.stat and the iocg never
+	 * activates, so the model is consulted but nothing is charged.
+	 */
+	/*
+	 * cgroup_setup_and_join() creates the priced-IO cgroup with the
+	 * available controllers enabled, so the cgroup has
+	 * io.weight/io.stat and the iocg activates.
+	 * cleanup_cgroup_environment() removes it from every exit path
+	 * below. io.cost.qos and io.cost.model are root-only cgroupfs
+	 * files: they are written at the hierarchy root and reverted on
+	 * exit.
+	 */
+	cg = cgroup_setup_and_join("/iocost_pairing");
+	if (!ASSERT_GE(cg, 0, "setup_cg")) {
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	close(cg);
+	snprintf(path, sizeof(path), "/dev/%s", IOCOST_NULLB);
+	devfd = open(path, O_RDONLY);
+	if (!ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev")) {
+		cleanup_cgroup_environment();
+		iocost_model__destroy(skel);
+		nullb_remove(IOCOST_NULLB);
+		return;
+	}
+	for (i = 0; i < 32; i++)
+		(void)read(devfd, buf, sizeof(buf));
+	close(devfd);
+
+	err = iocost_model__load(skel);
+	if (!ASSERT_OK(err, "skel_load")) {
+		iocost_model__destroy(skel);
+		cleanup_cgroup_environment();
+		nullb_remove(IOCOST_NULLB);
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
+			ASSERT_STREQ(model, "bpf", "model_bpf");
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
+		ASSERT_OK(join_cgroup("/iocost_pairing"), "join_pairing");
+		snprintf(qbuf, sizeof(qbuf), "%s 1000", dev);
+		ASSERT_OK(write_cgroup_file("/iocost_pairing", "io.weight",
+				     qbuf), "weight_pairing");
+		snprintf(qbuf, sizeof(qbuf),
+			 "%s enable=1 ctrl=user min=100.00 max=100.00", dev);
+		ASSERT_OK(configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf),
+			  "qos_enable");
+
+		devfd = open(path, O_RDONLY);
+		if (!ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev_priced")) {
+			iocost_model__destroy(skel);
+			snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev);
+			(void)configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf);
+			nullb_remove(IOCOST_NULLB);
+			cleanup_cgroup_environment();
+			return;
+		}
+		ASSERT_OK(read_cost_usage("/iocost_pairing",
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
+		ASSERT_OK(read_cost_usage("/iocost_pairing",
+					  dev, &u2), "cost_usage_post");
+		ASSERT_GT(u2, u1, "cost_charged");
+		ASSERT_GT(skel->bss->ioc_ticks, 0, "tick_seen");
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
+		bpf_link__destroy(skel->links.iocost_2x);
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
+	}
+
+	iocost_model__destroy(skel);
+	snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev);
+	(void)configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf);
+	nullb_remove(IOCOST_NULLB);
+	cleanup_cgroup_environment();
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
+	int devfd, i, err, cg;
+	char model[32], dev[32], path[64], qbuf[160];
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
+	snprintf(path, sizeof(path), "/dev/%s", IOCOST_NULLB);
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
+	if (ASSERT_OK(err, "attach")) {
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback"))
+			ASSERT_STREQ(model, "bpf", "model_bpf");
+
+		/*
+		 * drive IO through the model: enable the controller, price
+		 * from a cgroup, and check the model actually charged them
+		 */
+		cg = cgroup_setup_and_join("/iocost_ms");
+		if (!ASSERT_GE(cg, 0, "setup_cg_ms")) {
+			iocost_ms__destroy(skel);
+			nullb_remove(IOCOST_NULLB);
+			cleanup_cgroup_environment();
+			return;
+		}
+		close(cg);
+		snprintf(qbuf, sizeof(qbuf), "%s 1000", dev);
+		ASSERT_OK(write_cgroup_file("/iocost_ms", "io.weight", qbuf),
+			  "weight_ms");
+		snprintf(qbuf, sizeof(qbuf),
+				 "%s enable=1 ctrl=user min=100.00 max=100.00", dev);
+		ASSERT_OK(configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf),
+			  "qos_enable");
+		devfd = open(path, O_RDONLY);
+		if (ASSERT_OK(devfd < 0 ? -errno : 0, "open_dev_ms")) {
+			char iobuf[4096];
+			unsigned long long u1 = 0, u2 = 0;
+
+			ASSERT_OK(read_cost_usage("/iocost_ms",
+						  dev, &u1), "cost_usage_pre");
+			for (i = 0; i < 500; i++)
+				(void)read(devfd, iobuf, sizeof(iobuf));
+			/*
+			 * Two interleaved sequential streams: exercise the
+			 * stream table, not just a single cursor.
+			 */
+			for (i = 0; i < 200; i++) {
+				(void)pread(devfd, iobuf, sizeof(iobuf),
+									(i + 1) * sizeof(iobuf));
+				(void)pread(devfd, iobuf, sizeof(iobuf),
+									(1 << 20) +
+									(i + 1) * sizeof(iobuf));
+			}
+			close(devfd);
+			sleep(3);
+			ASSERT_OK(read_cost_usage("/iocost_ms",
+						  dev, &u2), "cost_usage_post");
+			ASSERT_GT(u2, u1, "ms_cost_charged");
+			ASSERT_GT(skel->bss->calc_costs, 0,
+				  "ms_model_priced");
+		}
+		ASSERT_OK(join_root_cgroup(), "procs_back");
+		snprintf(qbuf, sizeof(qbuf), "%s enable=0", dev);
+		(void)configfs_write("/sys/fs/cgroup/io.cost.qos", qbuf);
+		bpf_link__destroy(skel->links.iocost_ms);
+		skel->links.iocost_ms = NULL;
+
+		err = readback_model(dev, model, sizeof(model));
+		if (ASSERT_OK(err, "readback_after_detach"))
+			ASSERT_STREQ(model, "linear", "model_linear");
+
+		cleanup_cgroup_environment();
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
+
+	bpf_link__destroy(skel2->links.iocost_2x);
+	skel2->links.iocost_2x = NULL;
+
+	err = readback_model(dev, model, sizeof(model));
+	if (ASSERT_OK(err, "readback_after_detach_again"))
+		ASSERT_STREQ(model, "linear", "model_linear_again");
+
+out2:
+	iocost_model__destroy(skel2);
+out:
+	nullb_remove("iocost_removal");
+	iocost_model__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
new file mode 100644
index 000000000000..85218b73d471
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_model.c
@@ -0,0 +1,180 @@
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
+ * flush term to data-bearing preflushes and to FUA writes on devices without
+ * native FUA support, which this model omits; this model prices flushes as
+ * one-page writes), so the doubled cost is a direct check
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
+ * activation result. Another, narrower one: with "flushiops"
+ * configured, the builtin also advances its cursor for a
+ * preflushed discard, which this model still ignores.
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
+ * so a cgroup that comes back starts with no cursor. A struct_ops
+ * map attaches to at most one device (a second attach to the same
+ * device fails with -EBUSY), and this example uses one map, so
+ * per-cgroup keys are per (cgroup, device) in effect
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_CGRP_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, __u64);
+} cursor_store SEC(".maps");
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
+u64 BPF_PROG(iocost_2x_calc_cost, struct bio *bio, u64 model_flags)
+{
+	u64 opf = bio->bi_opf, nbytes = bio->bi_iter.bi_size;
+	u64 sector = bio->bi_iter.bi_sector;
+	struct blkcg *blkcg = bio->bi_blkg->blkcg;
+	u64 pages, seek_pages = 0, base, coef_page, randio, cost;
+	__u64 *cursor, cur;
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
+	if (cur && nbytes) {
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
+	if (nbytes &&
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
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c
new file mode 100644
index 000000000000..92919e0f0b1b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/iocost_ms.c
@@ -0,0 +1,197 @@
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
+ * writes (mispricing only, the test never issues flushes). A
+ * struct_ops map attaches to at most one device (a second attach
+ * to the same device fails with -EBUSY), and this example uses one
+ * map, so the per-cgroup keys are per (cgroup, device) in effect.
+ * Two more known deviations:
+ * a dataless READ or WRITE is priced as a one-page access (the
+ * builtin prices it zero), and discards do not advance the
+ * stream expectation; the builtin cursor does not move for a
+ * plain discard either, only for a preflushed one when
+ * "flushiops" is configured.
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
+/*
+ * incremented by calc_cost(): the streams test asserts pricing went
+ * through the model while it is attached
+ */
+__u64 calc_costs;
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
+	calc_costs++;
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
+		/*
+		 * no storage: price per page, truncating like the
+		 * builtin; merges skip the base like the main path
+		 */
+		if (model_flags & IOCOST_COST_F_MERGE)
+			base = 0;
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
2.53.0

