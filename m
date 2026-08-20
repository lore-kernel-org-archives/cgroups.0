Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137E486BB0
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260697; cv=none; b=o8iS2pNiX9XIE1iYKcyfRDWPYQr7m+wr2Z6sujsCBJ6Gd5W+OAk2sA2XC5Tvy8yaTkQbW3v3fOT2zLxdKAAzfqBvTMxSQd/6VbE9sJgvEm3CMys7eIesYaA9kl4ZU39jVe8zjWhjb7ycWBQgDXh3YzWDD/upgqa6939uyiwEXHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260697; c=relaxed/simple;
	bh=KGpOGxE5aDGI+YJk6SVQmRM6Iyv3svPXmm0zCZ8M3JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQTFbNnhiv1QTjm0+DV+mhEbgnjYOr73zZ+Znq5cxVYTOGT8cfz50eRVNIFf02WRJkZymMA0mP/Ux3ZPzeIYr5BUcf6v55AuTfVaH5UfG3PFTmBcETN4QSd9t6hqVKlvtUSazXI8gYAAdFOEGNRj7yb5L50P5zih36/GfQtNbNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CvGTBne3; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvGTBne3"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38511175ad3so256102a91.2
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787260688; x=1787865488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pTVI5fQqcRejLtqxc3simDI2MaSc8wcnSCEjipsJOUc=;
        b=CvGTBne3x3dy5StvYbKotfPM5CN0GGYIGCQPgCOQZ1TcPV6eoK2rUX9qFwEDyPrF9w
         NB9eC9mny7lv7Sis4mQmIIg81RhW5W5mpHt1/dom96+hdQWxR4uijPnIJitTtVSeSK3F
         Pp3Hk6DysR+0IPIY4mrMrC4hoFowXtY0PJMPQ6zBNpoXtCA/Hd613mQ7UObIlnz4urds
         GEky3vPDsd9ZNLzEuK2u11C4MkixiQA6f1afkOodNilaPQ3ePYtYm/u64G2PXKPYNeyi
         uuFLvwpw5n3EK5y9XVs+G9T+8ujXlXG4Aheqh42ClzAt8rz1v9sRtuCUbymYk/ZmuoDO
         gHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260688; x=1787865488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pTVI5fQqcRejLtqxc3simDI2MaSc8wcnSCEjipsJOUc=;
        b=VKagQJm0SLJ0eSYVbeXgHu9fcsGliE94dSNkzp7hrFf3UffsJO2hht6+omaV7lgUW+
         QDDjBLNdaAqH2mf5GtYCLy372TfcAXpj103K8Cq+BslNVVoomwRcAQaElbYraEaa9sTO
         fENY0sSrJITBzDlGscMFoFFz5XEgXVttRsRTvOWf+o8F1Rg4qclltHa4G/ncUPnX/OZT
         DdxjvXWyTP3mC4+psTrvWt0U2UylA6o0AlzoYtSCh/XLQLxo/SXqXL6Gg0mf0iUzcZZY
         8xc48nI8PxrgSupbRWUOR2KH0NhvZQT2+UUBlHrsWnKztvi6d1/zncBWnxU9QngT0zX+
         Hu9g==
X-Forwarded-Encrypted: i=1; AHgh+RqTRWluVQPxrhRqLjD8KG5TOjVe84KFJrfAxIw0WULd/YquWcq110Kq1OxDOh02oAv5Jdx+nmPE@vger.kernel.org
X-Gm-Message-State: AFuF++lFHsFHWyZUWRIsZ5hIR2Blg2GiXa9h5A9vej0Ekh2fqmfD/TGY
	Fv/37V8Tii7PihtzBddOXtYndeDHxusZQFfj8y3k2fK5YwMXZ/35ObMK
X-Gm-Gg: AR+sD113QiYaa4LQ61yUbF1ZbBNhO1QVarOd1mGkVR0IaSvYGWtuSLQ/sV4Tjn+vMiG
	1vyXQ9/4x2mCQ2wbc3zlXdmqgPIvPTY60FHXGFPP91un3mLv1YS5K76hhVQ7Qn/66bKrRRpU+SG
	Tt95Zpm/HezVIm8eOhMij2G7WzBQOOi8ZWqdDqu3vmxEozTf5W7ZAUZE+hUJJQSo3xcL+uOhvKF
	vwzSlJvlsSTkb36Fm1L88/tNTqQ+pvRRVjKCaEfzIHcXEORxATUKJ6EwNQb8V7soj/OBrVqKPVM
	qt3sjLL+k0trcyx0KVqvNLE7e2XmKQwaxpnbAlV4j2g4SsJy5r44jgoiQvrE2K6lrQY+awBkCws
	ahXFGrqKo0ySMAbnrOVqy+rnrjt0smuPlR0/VfNjw9GihncCG1ZAGNdC9NYrqXvd96JMcYUZEiG
	duVqDDs/HZJwWFD9t/7YgI2cM2kxlmHlLODBPwqg6UJvg+Qej9B6WoAzE=
X-Received: by 2002:a17:90b:1c90:b0:393:19a3:4f1 with SMTP id 98e67ed59e1d1-395c351d788mr2396492a91.6.1787260687664;
        Thu, 20 Aug 2026 14:18:07 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:40::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad53874sm30447128c88.4.2026.08.20.14.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:18:07 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: kernel-team@meta.com,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] selftests/bpf: add test for blkcg io.stat BPF kfuncs
Date: Thu, 20 Aug 2026 14:17:58 -0700
Message-ID: <20260820211758.3393984-5-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820211758.3393984-1-ziyang.meme@gmail.com>
References: <20260820211758.3393984-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cgroup_iter_io to test the blkcg io.stat BPF kfuncs. The BPF
program acquires the I/O css, flushes its statistics, converts it to a
typed blkcg under RCU, walks the blkgs, and releases the css reference.

The test performs O_DIRECT I/O on a private loop device. It checks the
device ID and counters against io.stat.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/bpf/cgroup_iter_io.h  |  17 ++
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/cgroup_iter_io.c | 254 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_io.c      |  74 +++++
 4 files changed, 346 insertions(+)
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
index 482b40dde2f9..0e10d625de6e 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -1,3 +1,4 @@
+CONFIG_BLK_CGROUP=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=1
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
new file mode 100644
index 000000000000..2267780912d8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
@@ -0,0 +1,254 @@
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
+/* Set up a loop device for cgroup-charged I/O. */
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
+/* O_DIRECT keeps I/O charged to the current cgroup. */
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
+/* Read @dev's io.stat counters. @dev uses kernel dev_t encoding. */
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
+		/* Only the device id is required; missing counters stay zero. */
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
+	/* Convert glibc st_rdev to kernel dev_t format. */
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
+	/* Compare with io.stat without I/O between the reads. */
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
index 000000000000..0e9c9cd6e33a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c
@@ -0,0 +1,74 @@
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
+struct io_query io_query SEC(".data.query");
+
+/* Device selected by userspace in kernel dev_t format. */
+__u64 target_dev SEC(".data.query");
+
+/* Keep inline: RCU and open-coded iterators cannot cross a BPF call. */
+static __always_inline int read_target_dev(struct cgroup *cgrp,
+					   struct io_query *out)
+{
+	struct cgroup_subsys_state *css;
+	struct blkcg *blkcg;
+	struct blkcg_gq *pos;
+	__u64 dev;
+	int ssid;
+
+	ssid = bpf_core_enum_value(enum cgroup_subsys_id, io_cgrp_id);
+	css = bpf_cgroup_css(cgrp, ssid);
+	if (!css)
+		return 0;
+
+	css_rstat_flush(css);
+
+	bpf_rcu_read_lock();
+
+	blkcg = bpf_css_to_blkcg(css);
+	if (!blkcg) {
+		bpf_rcu_read_unlock();
+		bpf_css_release(css);
+		return 0;
+	}
+
+	bpf_for_each(blkg, pos, blkcg) {
+		dev = BPF_CORE_READ(pos, q, disk, part0, bd_dev);
+		if (dev != target_dev)
+			continue;
+
+		out->dev = dev;
+		out->rbytes = BPF_CORE_READ(pos, iostat.cur.bytes[BLKG_IOSTAT_READ]);
+		out->wbytes = BPF_CORE_READ(pos, iostat.cur.bytes[BLKG_IOSTAT_WRITE]);
+		out->rios = BPF_CORE_READ(pos, iostat.cur.ios[BLKG_IOSTAT_READ]);
+		out->wios = BPF_CORE_READ(pos, iostat.cur.ios[BLKG_IOSTAT_WRITE]);
+		out->dbytes = BPF_CORE_READ(pos, iostat.cur.bytes[BLKG_IOSTAT_DISCARD]);
+		out->dios = BPF_CORE_READ(pos, iostat.cur.ios[BLKG_IOSTAT_DISCARD]);
+		break;
+	}
+	bpf_rcu_read_unlock();
+	bpf_css_release(css);
+	return 1;
+}
+
+SEC("iter.s/cgroup")
+int cgroup_io_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *cgrp = ctx->cgroup;
+
+	if (!cgrp)
+		return 1;
+
+	/* Start fresh so a device that is not found stays all-zero. */
+	__builtin_memset(&io_query, 0, sizeof(io_query));
+
+	read_target_dev(cgrp, &io_query);
+	return 0;
+}
-- 
2.53.0-Meta

