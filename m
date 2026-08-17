Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB747253C
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787002946; cv=none; b=HgsRNtQEvfklf9BjCS8mDrXVeaiGIT3Eoso1TnGBpxXWU6Buw4DYguKnwD1uae1VFytYRyJVnLNhn3j0oasq5bymNthMak3TPMtD/UW3PSC51GPZw45kqtS0DRAn0TyHbhXIQIqBBr0wtgP/uwbR0aB+SFwIDoCiNLmSvcLVqxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787002946; c=relaxed/simple;
	bh=+BrwSqK/iZEWjOi5n/aAk9jdHYV1SOICLEzhhQHfrdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJcL5Q/hfgpNual6G57wZSoU7raJialYK5sBO4fgIXTx/LZ6kd99YEtgCdpmnac0vuIAW2tmpHedbem5Uyyn8HqT7BtIQn9kQT7xUndcF8sRxVdFDU8VnZqzzqI5dzwsFQg/hAk/VpTYheUXLKSADbrMyE5/4neHt14goPEBlgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJpTGgkh; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJpTGgkh"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so2414161a12.2
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 14:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787002944; x=1787607744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8oHY1efdTZ0mrkkqnpEhOi9h4e/ZaN6Y4vux4nxnrw=;
        b=WJpTGgkhDAn8mSHKKOrK8V5g+WWW6/bwkGhgTjq5Gb8jBGVDTncw2rtji2w0Qv3Fyf
         uQ3f57E8lIJf30l39cXbSjdbbfXq9YnRjoJXu9CfeqOVB2wzoWlpzDyNF8hk+mZ/AX47
         2G7dYkdllBvkTSSfeeWRpZByTdKcdPkRvWmyYNp9xdpyvXcv/hIkj7PmmOIZW4exYjLS
         o7P5w4I4pZ7LlFkprFtawpu9qeB1WSxbChM1mttvtSx3XFtZmo5STVDbSLTMUj1kNmmx
         4aXIUhLwxcFyveUTyGe+z37LEckyyxG52H5OXAhHDSLEE1QNZMRvKESk5jPDnCTU6dmh
         hhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787002944; x=1787607744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z8oHY1efdTZ0mrkkqnpEhOi9h4e/ZaN6Y4vux4nxnrw=;
        b=QoVk4o91CCb9d20wkFxarBV09MyboY0K24CWmL4Ja5MfUrI+h2fmTff7/vO8mrBkfU
         iKE4ILHKPSWI8FCqRzkVJXSJVdtxNk2d9NU4iIfvvOhJCVj1EzkS+zR/Y1vX21sd6CuW
         P9Qb/0rRhiSIhPnQDK22QlntTr1MCisF9X/1MNDEzcU++qpd3hgYv7mStfQTW+TihYDE
         pT/tUvLzuh3pvqARztI+nvsbf9aBOZgNvr2a3UaznwWdJuP3r0bYPzm6duIkJVC6KYQR
         Ggf/ts25Xbry3jbppiLl9ds+TXy13lwsw2A+BA8YrJoZee9jAySyBxqFXmvvAMCGeymf
         s4Ew==
X-Forwarded-Encrypted: i=1; AHgh+RpO3sA/6CHLZxaKMLnXNZl0pLx7A/H5Cw4oUly2jER2SOAu3vQ+BRvqex19/MhmhmcTmt3xWc2M@vger.kernel.org
X-Gm-Message-State: AOJu0YxL/leI06Z0jCjEIGBciukBlXSI0qLnE4QeIT64ZD53EUmvRU1N
	ojC5YfS7Cth2om+3LEuR6H+ByIIiBz/IS6F14kozttVGAGpGh1IVOA6E
X-Gm-Gg: AR+sD10kpJVd5D9WH9V+qSbt55POOfTVfA0PwkYW72Xv4IYc2ewthWWiCAEBctvhkC9
	6zpChKcWU0XBEjROkVL5Bu64b1T+R355yCsDtpy7KQ2dR6JOKBrAZk/cY8HljtdeJUdByDTUwCe
	2lcR11cBwgB3Fa17y1MQ6iIlhHFeAxOqngx6b4nUCCjB9krM5NEGn0RCDXMzdy1aOQlK79GaD3f
	VaiFebCTaCd043jjIPwe9o+HOiTk+wAsmZIgadL+g4UlWFl7+hjqwEhnv2MdfUq7fAqvyQVnD3w
	t/YRNChR3eoC115c7WfSUcpEuXOeTUm5RztqBq1ZdAVjM4zK5gboO6ouFSOn5jstxfXavuaVl3K
	CytrowhDIugOjjAXwkeDPfxiUvr5ypgZuMWSmWeeJu/DInsjltIFkYKMWBuaREuYzclTVXv/ILl
	e56UjneznmmVvjtJ9vt0BAIVeVcVjW6vvJnBa1a8k3Xv9nE67Afef3mc0=
X-Received: by 2002:a05:6a21:9087:b0:3c3:9aff:7a67 with SMTP id adf61e73a8af0-3ccda66c136mr3576310637.17.1787002943840;
        Mon, 17 Aug 2026 14:42:23 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:6b::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-326794c0c94sm18048820eec.9.2026.08.17.14.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 14:42:23 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: kernel-team@meta.com,
	Jens Axboe <axboe@kernel.dk>,
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
	Ziyang Men <ziyang.meme@gmail.com>,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] selftests/bpf: add test for blkcg io.stat BPF kfuncs
Date: Mon, 17 Aug 2026 14:42:05 -0700
Message-ID: <20260817214205.723267-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260817214205.723267-1-ziyang.meme@gmail.com>
References: <20260817214205.723267-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cgroup_iter_io to test the blkcg io.stat BPF kfuncs. The BPF program
flushes the statistics, looks up the I/O css under RCU, walks its blkgs,
and reads one device's counters with BPF_CORE_READ().

The test performs O_DIRECT I/O on a private loop device. It checks the
device ID and counters against io.stat.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/bpf/cgroup_iter_io.h  |  17 ++
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/cgroup_iter_io.c | 277 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_io.c      |  99 +++++++
 4 files changed, 394 insertions(+)
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
index 000000000000..5d27e5d28379
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_io.c
@@ -0,0 +1,277 @@
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
+	/* Root statistics include this cgroup's I/O. */
+	if (test__start_subtest("cgroup_iter_io__root")) {
+		struct bpf_link *root_link;
+		struct io_query *r;
+
+		skel->data_query->got_root_css = 0;
+		root_link = bpf_program__attach_iter(skel->progs.cgroup_root_io_query,
+						     &opts);
+		if (ASSERT_OK_PTR(root_link, "attach root iter")) {
+			if (ASSERT_OK(read_stats(root_link), "read root stats")) {
+				r = &skel->data_query->root_query;
+				ASSERT_EQ(skel->data_query->got_root_css, 1,
+					  "got_root_css");
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
index 000000000000..2cd538068987
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_io.c
@@ -0,0 +1,99 @@
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
+struct io_query root_query SEC(".data.query");
+
+__u64 got_root_css SEC(".data.query");
+
+/* Device selected by userspace in kernel dev_t format. */
+__u64 target_dev SEC(".data.query");
+
+/* Keep inline: RCU and open-coded iterators cannot cross a BPF call. */
+static __always_inline int read_target_dev(struct cgroup *cgrp,
+					   struct io_query *out)
+{
+	struct cgroup_subsys_state *css;
+	struct blkcg_gq *pos;
+	__u64 dev;
+	int ssid;
+
+	/* The flush can sleep, so run it before the RCU section. */
+	bpf_blkcg_flush_stats(cgrp);
+
+	bpf_rcu_read_lock();
+	ssid = bpf_core_enum_value(enum cgroup_subsys_id, io_cgrp_id);
+
+	/*
+	 * subsys[] is __rcu, so this read gives an RCU pointer the iterator
+	 * accepts. BPF_CORE_READ() would return a plain value instead.
+	 */
+	css = cgrp->subsys[ssid];
+	if (!css) {
+		bpf_rcu_read_unlock();
+		return 0;
+	}
+
+	bpf_for_each(blkg, pos, css) {
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
+
+SEC("iter.s/cgroup")
+int cgroup_root_io_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup *root;
+
+	if (!ctx->cgroup)
+		return 1;
+
+	__builtin_memset(&root_query, 0, sizeof(root_query));
+
+	/* The root cgroup always has id 1. */
+	root = bpf_cgroup_from_id(1);
+	if (!root)
+		return 0;
+
+	/* Root counters include all cgroups' I/O. */
+	if (read_target_dev(root, &root_query))
+		got_root_css = 1;
+
+	bpf_cgroup_release(root);
+	return 0;
+}
-- 
2.53.0-Meta

