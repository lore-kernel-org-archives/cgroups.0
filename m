Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA341835F
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 19:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786131461; cv=none; b=cBQBuFk6Gj8JDrbkL8qtJ5ZnWetoy0ubocgQONjywT/4ca35AcmeQMpB+k2XIwF8SOqONvHb65tg+hlEjbSQ/UY4nZsS7DEzpiNK2NSwuZ1R4Fr6QYvXSc9tezSoQaqU7UStv/dGrP07klpo371WTFByszsq++dmyOosIttr2M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786131461; c=relaxed/simple;
	bh=8L2jNqqneTrWjIhxBAyTlYEDrqUxG5JMpaCEtZLJpN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQNA5lVxkvEzzJGoI7WunDQbQHBX7QoObs9dXqxgOSCqH8D5QJV5Tjp2Ztcqu83Tt8k4jwwDg2mmIM4UZd/DMuSU8unn3Q6I/x8frQqtxvzZHZbE4kCZfhyY81Yrhg587OvnhPhhc2SOq4CypMbwRPt4wPJM30LKLGnN/ht4lac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lyh7K97d; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lyh7K97d"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca88130e09aso2934199a12.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 12:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786131458; x=1786736258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=516fNSEVFZidFTbnujDBUpNRDc+xNXskAxbQE+m29cc=;
        b=Lyh7K97dEOnrAUVmkZ3bm2ItCwlZiM8HfVOkM92N9L+eJnTQ7DmiJzm2v05gFaRC4Y
         Rje5IB/6lNYNAtxqkvMdEZ0faE/cjUzfRTmgvqPzxb6Q/GI/5/qirKs5Bmxygd6e8ly+
         Y6TzYCHsYO110blHkHcuKG5orOYxcgmVEHou7G1DRA294YJXJEKIZgl8d3IIw1BA89m2
         vqIvX/VvOoL6KnxdFppfm/7xNSlTuBKsiBYmI+Pe3B0N8MYxJRzTYAlBtFa+xOonr8wQ
         /2N6vSgsAzBVL5gDDU/3B1PftkOaMfATvGNWa9jtoubi+oalaM9krrT21+zubbIqkWgN
         4Mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786131458; x=1786736258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=516fNSEVFZidFTbnujDBUpNRDc+xNXskAxbQE+m29cc=;
        b=ML/WKlVqie8abbgNOcWsVD8g8dew/5jL7B2k2qIisDy7BdPI564WYMrOwCklievibU
         nIbHZ8jlAjxyoz9Ka7fDLAET1xFiFFEnvZlnigFrmndK49cBe6akvdFvRUnLEjSXRSCc
         2wANTzOgkvn1tcqoWBppwlagD1DnTysX/9YAAw+d4jg+bq2BVPIZ5PokwwpwHcqXNtnB
         pzEfzHb8MYxawj1nbo/0r01WnH+yqQxMDeXPadgBfUWYx90WxXv3yJcAP0IKEaYwysmf
         P2hTTF4KnBU0RHeJ3xP/ZvbJcWqe5wuh8+po6L8fYy++crP5OVIQC0nQtiRT5Y29aQ3+
         qzVg==
X-Forwarded-Encrypted: i=1; AHgh+RqRQ5nmBLKJ/zGtOUoa4pd7wjGSfWAdXyctpcjdIDfEqg73xf0/VzNB0rXLsNtVSSxvXxN9+oNY@vger.kernel.org
X-Gm-Message-State: AOJu0YwJUEdzl3G0DzeDAoGLTCtqEPlG3cvn4hH7dTnC4hcwF7PrfHiu
	hfFEdnHOsh79j8D2N1yiZYIOuAZmGDUYFjVaQiUhe5ae4xgHZqDBkw0s
X-Gm-Gg: AR+sD12GRTzoYhvcIGOpBvSe2yFwoZdEhaEfxtzqXNbQlSChFDeUAopIfkGWLqcFKtN
	Wp7gWzmL9iY0hxFCRApQEurt2BgIZ5vmeISrIDJUHsQC613oG11kzgRaa394JHnioeorcglj88U
	6TLar2DinFAXe/0Hq/+YvDFigJYhLH9LFFxzfHrI8dwcqN0X/Oba9xKpDgSEH0VujAFcPd5R5OP
	pjPDGP5XwhDUDYXo66vX0l69eLJS0P9j6Iz+BivGVDJ+H+ojVe1eQvCdRhqcKpp6Pjw8808mcaQ
	IE5qcVkbqWQLFwrAHRdHSibhK/YGg4hOAfPCViEBgBikVB5j5h7PtSmWO4kruTmkDbE+3yCKLip
	vbhHnsitSURCusLiz1wr8j3CkVh6T8M0JYR6WChCE+lwYIDg+UhUgkCMShS4uBZ3MY/hzR45LrX
	E9FF3tl3ZA7SoHGDZ/HyyL+q1yEirfGWHL9XjrZvU23BTfhpGomDOMvNzjJid4/iMnKw==
X-Received: by 2002:a05:6a20:9183:b0:3bf:63af:855 with SMTP id adf61e73a8af0-3cb85dee60cmr28788437637.1.1786131458255;
        Fri, 07 Aug 2026 12:37:38 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:72::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde308sm10594920eec.20.2026.08.07.12.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 12:37:37 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	kernel-team@meta.com,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH 2/2] selftests/bpf: add test for blkcg io.stat BPF kfuncs
Date: Fri,  7 Aug 2026 12:37:32 -0700
Message-ID: <20260807193732.4073299-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807193732.4073299-1-ziyang.meme@gmail.com>
References: <20260807193732.4073299-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cgroup_iter_io, a test_progs test for the block I/O controller BPF
kfuncs.  A SEC("iter.s/cgroup") program acquires the cgroup's blkcg,
flushes stats, iterates its blkgs and reads the io.stat counters for a
target device.

The userspace side attaches a loop device, generates O_DIRECT read and
write I/O charged to a test cgroup, and then:

  - checks the write and read byte/io counters are nonzero,
  - checks the reported device id,
  - compares every kfunc-read value against the cgroup's io.stat file
    for the same device and requires an exact match,
  - reads the same device through bpf_get_root_blkcg() and checks the
    root counters are at or above the test cgroup's.

The measured device is pinned to the loop device, which has no
asynchronous writeback, so the kfunc snapshot and the io.stat file
snapshot are identical rather than merely close.  The root cgroup's
numbers for a device come from the disk itself and so cover every
cgroup's I/O to it, which is why the root check is "at or above" rather
than an exact match.

CONFIG_BLK_CGROUP is added to the test config; CONFIG_BLK_DEV_LOOP is
already present.

Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/bpf/cgroup_iter_io.h  |  17 +
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/cgroup_iter_io.c | 310 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_io.c      | 107 ++++++
 4 files changed, 435 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_io.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_io.c

diff --git a/tools/testing/selftests/bpf/cgroup_iter_io.h b/tools/testing/selftests/bpf/cgroup_iter_io.h
new file mode 100644
index 000000000000..f4bbaaccdf71
--- /dev/null
+++ b/tools/testing/selftests/bpf/cgroup_iter_io.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#ifndef __CGROUP_ITER_IO_H
+#define __CGROUP_ITER_IO_H
+
+struct io_query {
+	/* one device's io.stat counters */
+	__u64 rbytes;
+	__u64 wbytes;
+	__u64 rios;
+	__u64 wios;
+	__u64 dbytes;
+	__u64 dios;
+	__u64 dev;	/* dev_t of the device the counters belong to */
+};
+
+#endif /* __CGROUP_ITER_IO_H */
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index ea7044f30adc..270e6bf9194d 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -1,3 +1,4 @@
+CONFIG_BLK_CGROUP=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
new file mode 100644
index 000000000000..32cda8243318
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <fcntl.h>
+#include <linux/loop.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include "cgroup_helpers.h"
+#include "cgroup_iter_io.h"
+#include "cgroup_iter_io.skel.h"
+
+#define IO_SIZE (4 * 1024 * 1024)
+
+static int read_stats(struct bpf_link *link)
+{
+	int fd, ret = 0;
+	ssize_t bytes;
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
+		return 1;
+
+	/* Results land in skel->data_query; the read itself returns no data. */
+	bytes = read(fd, NULL, 0);
+	if (!ASSERT_EQ(bytes, 0, "read fd"))
+		ret = 1;
+
+	close(fd);
+	return ret;
+}
+
+/*
+ * Attach a loop device to an anonymous temp file so we have a real block
+ * device to generate cgroup-charged I/O against. Returns 0 on success, or -1
+ * if loop devices are unavailable (non-root / no CONFIG_BLK_DEV_LOOP) so the
+ * caller can skip.
+ */
+static int loop_setup(char *loop_path, size_t sz, int *ctl_fd, int *loop_fd,
+		      int *back_fd)
+{
+	char back_path[] = "/tmp/cgroup_iter_io.XXXXXX";
+	int nr;
+
+	*ctl_fd = *loop_fd = *back_fd = -1;
+
+	*ctl_fd = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
+	if (*ctl_fd < 0)
+		return -1;
+
+	nr = ioctl(*ctl_fd, LOOP_CTL_GET_FREE);
+	if (nr < 0)
+		goto err;
+	snprintf(loop_path, sz, "/dev/loop%d", nr);
+
+	*back_fd = mkstemp(back_path);
+	if (*back_fd < 0)
+		goto err;
+	unlink(back_path);
+	if (ftruncate(*back_fd, (off_t)IO_SIZE * 4))
+		goto err;
+
+	*loop_fd = open(loop_path, O_RDWR | O_CLOEXEC);
+	if (*loop_fd < 0)
+		goto err;
+	if (ioctl(*loop_fd, LOOP_SET_FD, *back_fd))
+		goto err;
+
+	return 0;
+err:
+	if (*loop_fd >= 0)
+		close(*loop_fd);
+	if (*back_fd >= 0)
+		close(*back_fd);
+	close(*ctl_fd);
+	*ctl_fd = *loop_fd = *back_fd = -1;
+	return -1;
+}
+
+static void loop_teardown(const char *loop_path, int ctl_fd, int loop_fd,
+			  int back_fd)
+{
+	int nr = -1;
+
+	if (loop_fd >= 0) {
+		ioctl(loop_fd, LOOP_CLR_FD, 0);
+		close(loop_fd);
+	}
+	if (back_fd >= 0)
+		close(back_fd);
+	if (ctl_fd >= 0) {
+		if (sscanf(loop_path, "/dev/loop%d", &nr) == 1 && nr >= 0)
+			ioctl(ctl_fd, LOOP_CTL_REMOVE, nr);
+		close(ctl_fd);
+	}
+}
+
+/* O_DIRECT I/O to the loop device, charged to the current cgroup. */
+static int do_direct_io(const char *loop_path)
+{
+	void *buf;
+	int fd, ret = -1;
+
+	fd = open(loop_path, O_RDWR | O_DIRECT | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	if (posix_memalign(&buf, 4096, IO_SIZE))
+		goto out_fd;
+	memset(buf, 0xab, IO_SIZE);
+
+	if (pwrite(fd, buf, IO_SIZE, 0) != IO_SIZE)
+		goto out_buf;
+	fsync(fd);
+	if (pread(fd, buf, IO_SIZE, 0) != IO_SIZE)
+		goto out_buf;
+	ret = 0;
+out_buf:
+	free(buf);
+out_fd:
+	close(fd);
+	return ret;
+}
+
+/*
+ * Parse the io.stat line for device @dev out of the cgroup's io.stat file and
+ * fill @out. @dev is a kernel dev_t (as returned by bpf_blkg_dev), whose
+ * major:minor split matches how io.stat prints the device. Returns 0 if the
+ * device's line was found.
+ */
+static int parse_io_stat(int cgroup_fd, __u64 dev, struct io_query *out)
+{
+	unsigned int want_maj = dev >> 20, want_min = dev & ((1U << 20) - 1);
+	char buf[4096], *line, *saveptr;
+	int fd, n, ret = -1;
+
+	fd = openat(cgroup_fd, "io.stat", O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = '\0';
+
+	for (line = strtok_r(buf, "\n", &saveptr); line;
+	     line = strtok_r(NULL, "\n", &saveptr)) {
+		unsigned long long rb = 0, wb = 0, ri = 0, wi = 0, db = 0, di = 0;
+		unsigned int maj, min;
+
+		/*
+		 * The "maj:min" token is always present; the field block is
+		 * optional (the kernel omits it for a device with no read/write
+		 * I/O), so a match of >= 2 is enough and absent fields stay 0.
+		 */
+		if (sscanf(line,
+			   "%u:%u rbytes=%llu wbytes=%llu rios=%llu wios=%llu dbytes=%llu dios=%llu",
+			   &maj, &min, &rb, &wb, &ri, &wi, &db, &di) < 2)
+			continue;
+		if (maj != want_maj || min != want_min)
+			continue;
+
+		out->rbytes = rb;
+		out->wbytes = wb;
+		out->rios = ri;
+		out->wios = wi;
+		out->dbytes = db;
+		out->dios = di;
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+void test_cgroup_iter_io(void)
+{
+	char *cgroup_rel_path = "/cgroup_iter_io_test";
+	int ctl_fd = -1, loop_fd = -1, back_fd = -1;
+	struct cgroup_iter_io *skel = NULL;
+	struct bpf_link *link = NULL;
+	char loop_path[64];
+	struct io_query *q;
+	int cgroup_fd;
+
+	cgroup_fd = cgroup_setup_and_join(cgroup_rel_path);
+	if (!ASSERT_OK_FD(cgroup_fd, "cgroup_setup_and_join"))
+		return;
+
+	if (loop_setup(loop_path, sizeof(loop_path), &ctl_fd, &loop_fd, &back_fd)) {
+		test__skip();	/* needs root + CONFIG_BLK_DEV_LOOP */
+		goto cleanup_cgroup_fd;
+	}
+
+	skel = cgroup_iter_io__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter_io__open_and_load"))
+		goto cleanup_loop;
+
+	/*
+	 * Pin the read to the loop device so the measured device is stable and
+	 * quiesced. Convert the glibc-encoded st_rdev to the kernel dev_t
+	 * encoding (major << 20 | minor) that bpf_blkg_dev returns.
+	 */
+	{
+		struct stat lst;
+
+		if (!ASSERT_OK(fstat(loop_fd, &lst), "fstat loop"))
+			goto cleanup_skel;
+		skel->data_query->target_dev =
+			((__u64)major(lst.st_rdev) << 20) | minor(lst.st_rdev);
+	}
+
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {
+		.cgroup.cgroup_fd = cgroup_fd,
+		.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
+	};
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_io_query, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
+		goto cleanup_skel;
+
+	/* This process is in the test cgroup, so the loop I/O is charged here. */
+	if (!ASSERT_OK(do_direct_io(loop_path), "do_direct_io"))
+		goto cleanup_link;
+
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup_link;
+
+	/*
+	 * Weak check: we did I/O, so the numbers must be non-zero. Follows the
+	 * pattern in cgroup_iter_memcg.
+	 */
+	q = &skel->data_query->io_query;
+	if (test__start_subtest("cgroup_iter_io__write")) {
+		ASSERT_GT(q->wbytes, 0, "wbytes");
+		ASSERT_GT(q->wios, 0, "wios");
+	}
+	if (test__start_subtest("cgroup_iter_io__read")) {
+		ASSERT_GT(q->rbytes, 0, "rbytes");
+		ASSERT_GT(q->rios, 0, "rios");
+	}
+	if (test__start_subtest("cgroup_iter_io__dev"))
+		ASSERT_GT(q->dev, 0, "dev");
+
+	/*
+	 * Stronger check: the kfunc-read values must equal what the io.stat
+	 * file reports for the same device. Refresh via the prog, then read
+	 * the file with no I/O in between, so both flushed snapshots match
+	 * exactly.
+	 */
+	if (test__start_subtest("cgroup_iter_io__match")) {
+		struct io_query filev = {};
+
+		if (ASSERT_OK(read_stats(link), "read stats") &&
+		    ASSERT_OK(parse_io_stat(cgroup_fd, q->dev, &filev),
+			      "parse io.stat")) {
+			ASSERT_EQ(q->rbytes, filev.rbytes, "rbytes");
+			ASSERT_EQ(q->wbytes, filev.wbytes, "wbytes");
+			ASSERT_EQ(q->rios, filev.rios, "rios");
+			ASSERT_EQ(q->wios, filev.wios, "wios");
+			ASSERT_EQ(q->dbytes, filev.dbytes, "dbytes");
+			ASSERT_EQ(q->dios, filev.dios, "dios");
+		}
+	}
+
+	/*
+	 * Separate program for the root block cgroup. Its counters do not come
+	 * from rstat, they are refilled from the disks themselves, so this
+	 * covers the other half of bpf_blkcg_flush_stats(). They cover every
+	 * cgroup's I/O to the loop device, and only this test touches it, so
+	 * they must be at or above what the test cgroup was charged.
+	 */
+	if (test__start_subtest("cgroup_iter_io__root")) {
+		struct bpf_link *root_link;
+		struct io_query *r;
+
+		skel->data_query->got_root_blkcg = 0;
+		root_link = bpf_program__attach_iter(skel->progs.cgroup_root_blkcg_query,
+						     &opts);
+		if (ASSERT_OK_PTR(root_link, "attach root iter")) {
+			if (ASSERT_OK(read_stats(root_link), "read root stats")) {
+				r = &skel->data_query->root_query;
+				ASSERT_EQ(skel->data_query->got_root_blkcg, 1,
+					  "got_root_blkcg");
+				ASSERT_EQ(r->dev, q->dev, "root dev");
+				ASSERT_GE(r->wbytes, q->wbytes, "root wbytes");
+				ASSERT_GE(r->wios, q->wios, "root wios");
+				ASSERT_GE(r->rbytes, q->rbytes, "root rbytes");
+				ASSERT_GE(r->rios, q->rios, "root rios");
+			}
+			bpf_link__destroy(root_link);
+		}
+	}
+
+cleanup_link:
+	bpf_link__destroy(link);
+cleanup_skel:
+	cgroup_iter_io__destroy(skel);
+cleanup_loop:
+	loop_teardown(loop_path, ctl_fd, loop_fd, back_fd);
+cleanup_cgroup_fd:
+	close(cgroup_fd);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_io.c b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c
new file mode 100644
index 000000000000..b839def94508
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include "bpf_experimental.h"
+#include "cgroup_iter_io.h"
+
+char _license[] SEC("license") = "GPL";
+
+/* The counters of the device named by target_dev are stored here. */
+struct io_query io_query SEC(".data.query");
+
+/* The same device's counters read through the root block cgroup. */
+struct io_query root_query SEC(".data.query");
+
+/* Set to 1 by cgroup_root_blkcg_query when bpf_get_root_blkcg() succeeds. */
+__u64 got_root_blkcg SEC(".data.query");
+
+/* Device to read, set by userspace (kernel dev_t). Pinning the device keeps
+ * the read deterministic and lets the value be compared to io.stat exactly.
+ */
+__u64 target_dev SEC(".data.query");
+
+/*
+ * Flush @blkcg and copy the target device's counters into @out. Reading only
+ * the one pinned device keeps the result deterministic: that device is
+ * quiesced, so its counters match io.stat exactly, while picking "any device
+ * with I/O" would race with backing-store writeback.
+ */
+static __always_inline void read_target_dev(struct blkcg *blkcg,
+					    struct io_query *out)
+{
+	struct blkcg_gq *pos;
+
+	/* io.stat needs a flush before it can be read (sleepable). */
+	bpf_blkcg_flush_stats(blkcg);
+
+	/* The per-device blkg walk needs an RCU section. */
+	bpf_rcu_read_lock();
+	bpf_for_each(blkg, pos, blkcg) {
+		if (bpf_blkg_dev(pos) != target_dev)
+			continue;
+
+		out->dev = bpf_blkg_dev(pos);
+		out->rbytes = bpf_blkg_iostat_bytes(pos, BLKG_IOSTAT_READ);
+		out->wbytes = bpf_blkg_iostat_bytes(pos, BLKG_IOSTAT_WRITE);
+		out->rios = bpf_blkg_iostat_ios(pos, BLKG_IOSTAT_READ);
+		out->wios = bpf_blkg_iostat_ios(pos, BLKG_IOSTAT_WRITE);
+		out->dbytes = bpf_blkg_iostat_bytes(pos, BLKG_IOSTAT_DISCARD);
+		out->dios = bpf_blkg_iostat_ios(pos, BLKG_IOSTAT_DISCARD);
+		break;
+	}
+	bpf_rcu_read_unlock();
+}
+
+SEC("iter.s/cgroup")
+int cgroup_io_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct blkcg *blkcg;
+
+	/* The last iteration has a NULL cgroup, skip it. */
+	if (!cgrp)
+		return 1;
+
+	/* Start fresh so a device that is not found stays all-zero. */
+	__builtin_memset(&io_query, 0, sizeof(io_query));
+
+	blkcg = bpf_get_blkcg(&cgrp->self);
+	if (!blkcg)
+		return 0;
+
+	read_target_dev(blkcg, &io_query);
+
+	bpf_put_blkcg(blkcg);
+	return 0;
+}
+
+SEC("iter.s/cgroup")
+int cgroup_root_blkcg_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+	struct blkcg *blkcg;
+
+	/* The last iteration has a NULL cgroup, skip it. */
+	if (!cgrp)
+		return 1;
+
+	__builtin_memset(&root_query, 0, sizeof(root_query));
+
+	blkcg = bpf_get_root_blkcg();
+	if (!blkcg)
+		return 0;
+
+	/*
+	 * The root cgroup takes its numbers from the disks themselves rather
+	 * than from rstat, so this also covers the root side of
+	 * bpf_blkcg_flush_stats(). The counters cover every cgroup's I/O, so
+	 * they can only be at or above what this test's own cgroup did.
+	 */
+	read_target_dev(blkcg, &root_query);
+
+	got_root_blkcg = 1;
+	bpf_put_blkcg(blkcg);
+	return 0;
+}
-- 
2.53.0-Meta

