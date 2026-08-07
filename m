Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618E13A383A
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086300; cv=none; b=ldvrRvudvqDezZnR1faTVV1F7ELL6S4aeigNl9uNv6CZglR+eLaKjvfg6SoPnaE5ETzNWBkOYnDgKVaCIbnXalxcVFgVDBB1i03PFetYxWv8l00LbkgbbSTq7t2tH3/4UZloKtVvRGAXfDnYDkzjrcjFbAQclhyv8+CjNUNfIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086300; c=relaxed/simple;
	bh=FFIUTaU+9A61WU/aXFapOXAypEKF+bWXwpKUNCOTaTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4uewmTmA6uK9WPqeD2HIgoQyAM7MDeri/9IOB78TzRwRPYNSu7SrScxCTWxP+OtQ3J8qf6Jgf1QyMuOLWyl9RrWYrtzUM0Oy2Vl/9xwvJiYw1ewDeRho/pxCwU2uhiuRf2IfQk8+owJ4x44y7h1hTt15BJfBmxaUTNZ5BRBcNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dj96D+Tl; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dj96D+Tl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVFGsj6wF8TniSm635aV4RrzfQPS2L0YIewv428Po2A=;
	b=dj96D+Tlrgu8b1nz1jlaA0I5jwuCOMazRznMbo5mBfUQgUZm2BVoRNoHt3B1Bb9+RVAQ1v
	IiVJ0tIXW/29eoF1vHHPlnhitG2vPqYOyQmZpavVB0uT9EuiHRNpYbJu1jfqGMk8Ub3cMa
	LIZ9Ze9jGOx72/aU+HWLE6Voqv+bZIQ=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next 4/4] selftests/bpf: add memcg async reclaim test for bpf_wq/bpf_thread_wq
Date: Fri,  7 Aug 2026 15:04:12 +0800
Message-ID: <8c34a7f2ad826054c7e3ae88276614415755e3bc.1786086076.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

Add memcg_async_reclaim selftest that verifies BPF-driven async
proactive reclaim can mitigate refault-induced slowdown under memory
pressure.

The test creates a parent cgroup with a fixed memory.max, and two
child cgroups (high/low) under it. Both children concurrently write
and repeatedly read-fault a file larger than the shared limit. A BPF
program monitors the "high" cgroup's WORKINGSET_REFAULT_FILE stat via
a periodic timer, and when it detects refault growth beyond a
threshold, triggers async reclaim on the "low" cgroup using
bpf_try_to_free_mem_cgroup_pages(), expecting the "high" cgroup's
workload to finish faster than without such reclaim.

Two variants are covered:
- test_memcg_wq_async_reclaim: async work driven by bpf_wq.
- test_memcg_thread_wq_async_reclaim: async work driven by the new
  bpf_thread_wq, which pins the reclaim work to the "low" cgroup's
  resource context via bpf_thread_wq_init()'s cgroup_id argument.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/memcg_async_reclaim.c      | 479 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 255 ++++++++++
 2 files changed, 734 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
new file mode 100644
index 000000000000..40a5fe62cb38
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory controller eBPF async reclaim test
+ */
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/vfs.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <linux/magic.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "cgroup_helpers.h"
+
+struct bpf_args_s {
+	u64 high_cgroup_id;
+	u64 low_cgroup_id;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+#include "memcg_async_reclaim.skel.h"
+
+#define FILE_SIZE (32 * 1024 * 1024ul)
+#define BUFFER_SIZE (4096)
+#define CG_LIMIT (32 * 1024 * 1024ul)
+#define READ_TIMES 16
+
+#define CG_DIR "/memcg_async_reclaim"
+#define CG_HIGH_DIR CG_DIR "/high"
+#define CG_LOW_DIR CG_DIR "/low"
+
+#define CHECK_PERIOD_NS (2 * 1000 * 1000ull)
+#define EVENT_DELTA_THRESHOLD 1
+
+/*
+ * Test files must reside on a filesystem that supports page reclaim without
+ * swap (e.g. ext4). If /tmp is on tmpfs, the file pages are shmem-backed
+ * and can only be reclaimed through swap. But the test disables swap
+ * (memory.swap.max=0), making reclaim impossible and causing OOM.
+ *
+ * Pick a directory on a non-tmpfs filesystem: try $TMPDIR first, then /tmp,
+ * and fall back to the current directory if the chosen path is on tmpfs.
+ */
+static int get_test_dir(char *buf, size_t size)
+{
+	static const char * const candidates[] = { "/tmp", "." };
+	const char *tmpdir = getenv("TMPDIR");
+	struct statfs sfs;
+	size_t i;
+
+	if (tmpdir && tmpdir[0] && statfs(tmpdir, &sfs) == 0 &&
+	    sfs.f_type != TMPFS_MAGIC) {
+		snprintf(buf, size, "%s", tmpdir);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(candidates); i++) {
+		if (statfs(candidates[i], &sfs) == 0 &&
+		    sfs.f_type != TMPFS_MAGIC) {
+			snprintf(buf, size, "%s", candidates[i]);
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static int setup_high_low_cgroups(u64 *high_cgroup_id, u64 *low_cgroup_id)
+{
+	int ret;
+	char limit_buf[20];
+
+	ret = setup_cgroup_environment();
+	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DIR))
+		goto cleanup;
+	close(ret);
+
+	ret = enable_controllers(CG_DIR, "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	snprintf(limit_buf, sizeof(limit_buf), "%lu", CG_LIMIT);
+	ret = write_cgroup_file(CG_DIR, "memory.max", limit_buf);
+	if (!ASSERT_OK(ret, "write_cgroup_file memory.max"))
+		goto cleanup;
+
+	ret = write_cgroup_file(CG_DIR, "memory.swap.max", "0");
+	if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_HIGH_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_HIGH_DIR))
+		goto cleanup;
+	close(ret);
+
+	*high_cgroup_id = get_cgroup_id(CG_HIGH_DIR);
+	if (!ASSERT_GT(*high_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ret = create_and_get_cgroup(CG_LOW_DIR);
+	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_LOW_DIR))
+		goto cleanup;
+	close(ret);
+
+	*low_cgroup_id = get_cgroup_id(CG_LOW_DIR);
+	if (!ASSERT_GT(*high_cgroup_id, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	return 0;
+
+cleanup:
+	cleanup_cgroup_environment();
+	return -1;
+}
+
+static int write_file(const char *filename)
+{
+	int ret = -1;
+	size_t written = 0;
+	char *buffer;
+	FILE *fp;
+
+	fp = fopen(filename, "wb");
+	if (!fp)
+		goto out;
+
+	buffer = malloc(BUFFER_SIZE);
+	if (!buffer)
+		goto cleanup_fp;
+
+	memset(buffer, 'A', BUFFER_SIZE);
+
+	while (written < FILE_SIZE) {
+		size_t to_write = FILE_SIZE - written < BUFFER_SIZE ?
+				  FILE_SIZE - written : BUFFER_SIZE;
+
+		if (fwrite(buffer, 1, to_write, fp) != to_write)
+			goto cleanup;
+		written += to_write;
+	}
+
+	ret = 0;
+cleanup:
+	free(buffer);
+cleanup_fp:
+	fclose(fp);
+out:
+	return ret;
+}
+
+static int read_file(const char *filename, int iterations)
+{
+	int ret = -1;
+	long page_size = sysconf(_SC_PAGESIZE);
+	char *map;
+	size_t i;
+	int fd;
+	struct stat sb;
+
+	fd = open(filename, O_RDONLY);
+	if (fd == -1)
+		goto out;
+
+	if (fstat(fd, &sb) == -1)
+		goto cleanup_fd;
+
+	if (sb.st_size != FILE_SIZE) {
+		fprintf(stderr, "File size mismatch: expected %lu, got %lu\n",
+			(unsigned long)FILE_SIZE, (unsigned long)sb.st_size);
+		goto cleanup_fd;
+	}
+
+	map = mmap(NULL, FILE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (map == MAP_FAILED)
+		goto cleanup_fd;
+
+	for (int iter = 0; iter < iterations; iter++) {
+		for (i = 0; i < FILE_SIZE; i += page_size) {
+			/* access a byte to trigger page fault */
+			asm volatile("" :: "r"(map[i]) : "memory");
+		}
+	}
+
+	if (munmap(map, FILE_SIZE) == -1)
+		goto cleanup_fd;
+
+	ret = 0;
+
+cleanup_fd:
+	close(fd);
+out:
+	return ret;
+}
+
+static int real_test_child_work(const char *cgroup_path, char *data_filename,
+				char *time_filename, int read_times)
+{
+	struct timeval start, end;
+	double elapsed;
+	FILE *fp;
+
+	if (!ASSERT_OK(join_parent_cgroup(cgroup_path), "join_parent_cgroup"))
+		return -1;
+
+	gettimeofday(&start, NULL);
+
+	if (!ASSERT_OK(write_file(data_filename), "write_file"))
+		return -1;
+
+	if (!ASSERT_OK(read_file(data_filename, read_times), "read_file"))
+		return -1;
+
+	gettimeofday(&end, NULL);
+
+	if (!time_filename)
+		return 0;
+
+	elapsed = (end.tv_sec - start.tv_sec) +
+		  (end.tv_usec - start.tv_usec) / 1000000.0;
+	printf("%.6f\n", elapsed);
+
+	fp = fopen(time_filename, "w");
+	if (!ASSERT_OK_PTR(fp, "fopen"))
+		return -1;
+	fprintf(fp, "%.6f", elapsed);
+	fclose(fp);
+
+	return 0;
+}
+
+static int get_time(char *time_filename, double *time)
+{
+	int ret = -1;
+	FILE *fp;
+	char buf[64];
+
+	fp = fopen(time_filename, "r");
+	if (!ASSERT_OK_PTR(fp, "fopen"))
+		goto out;
+
+	if (!ASSERT_OK_PTR(fgets(buf, sizeof(buf), fp), "fgets"))
+		goto cleanup;
+
+	if (sscanf(buf, "%lf", time) != 1) {
+		PRINT_FAIL("sscanf %s", buf);
+		goto cleanup;
+	}
+
+	ret = 0;
+cleanup:
+	fclose(fp);
+out:
+	return ret;
+}
+
+static int
+run_high_low_workload(double *high_elapsed, double *low_elapsed, int read_times)
+{
+	char test_dir[PATH_MAX], high_data_file[PATH_MAX], low_data_file[PATH_MAX];
+	char high_time_file[PATH_MAX], low_time_file[PATH_MAX];
+	int ret, fd;
+	pid_t high_pid, low_pid;
+	int status;
+
+	ret = get_test_dir(test_dir, sizeof(test_dir));
+	if (!ASSERT_OK(ret, "get_test_dir: no non-tmpfs directory found"))
+		return -1;
+
+	fd = snprintf(high_data_file, sizeof(high_data_file),
+		      "%s/memcg_async_high_data_XXXXXX", test_dir);
+	if (!ASSERT_LT(fd, sizeof(high_data_file), "high_data_file path"))
+		return -1;
+
+	fd = snprintf(low_data_file, sizeof(low_data_file),
+		      "%s/memcg_async_low_data_XXXXXX", test_dir);
+	if (!ASSERT_LT(fd, sizeof(low_data_file), "low_data_file path"))
+		return -1;
+
+	fd = snprintf(high_time_file, sizeof(high_time_file),
+		      "%s/memcg_async_high_time_XXXXXX", test_dir);
+	if (!ASSERT_LT(fd, sizeof(high_time_file), "high_time_file path"))
+		return -1;
+
+	fd = snprintf(low_time_file, sizeof(low_time_file),
+		      "%s/memcg_async_low_time_XXXXXX", test_dir);
+	if (!ASSERT_LT(fd, sizeof(low_time_file), "low_time_file path"))
+		return -1;
+
+	fd = mkstemp(high_data_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		return -1;
+	close(fd);
+
+	fd = mkstemp(low_data_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup_high_data;
+	close(fd);
+
+	fd = mkstemp(high_time_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup_low_data;
+	close(fd);
+
+	fd = mkstemp(low_time_file);
+	if (!ASSERT_GE(fd, 0, "mkstemp"))
+		goto cleanup_high_time;
+	close(fd);
+
+	low_pid = fork();
+	if (!ASSERT_GE(low_pid, 0, "fork low"))
+		goto cleanup_low_time;
+	if (low_pid == 0)
+		exit(real_test_child_work(CG_LOW_DIR, low_data_file,
+					  low_time_file, read_times));
+
+	high_pid = fork();
+	if (!ASSERT_GE(high_pid, 0, "fork high")) {
+		(void)waitpid(low_pid, NULL, 0);
+		goto cleanup_low_time;
+	}
+	if (high_pid == 0)
+		exit(real_test_child_work(CG_HIGH_DIR, high_data_file,
+					  high_time_file, read_times));
+
+	ret = waitpid(low_pid, &status, 0);
+	if (!ASSERT_GT(ret, 0, "low waitpid"))
+		goto cleanup_low_time;
+	if (!ASSERT_TRUE(WIFEXITED(status), "low exited"))
+		goto cleanup_low_time;
+	if (!ASSERT_EQ(WEXITSTATUS(status), 0, "low exit status"))
+		goto cleanup_low_time;
+
+	ret = waitpid(high_pid, &status, 0);
+	if (!ASSERT_GT(ret, 0, "high waitpid"))
+		goto cleanup_low_time;
+	if (!ASSERT_TRUE(WIFEXITED(status), "high exited"))
+		goto cleanup_low_time;
+	if (!ASSERT_EQ(WEXITSTATUS(status), 0, "high exit status"))
+		goto cleanup_low_time;
+
+	if (get_time(high_time_file, high_elapsed))
+		goto cleanup_low_time;
+	if (get_time(low_time_file, low_elapsed))
+		goto cleanup_low_time;
+
+	ret = 0;
+
+cleanup_low_time:
+	unlink(low_time_file);
+cleanup_high_time:
+	unlink(high_time_file);
+cleanup_low_data:
+	unlink(low_data_file);
+cleanup_high_data:
+	unlink(high_data_file);
+	return ret;
+}
+
+static int
+setup_bpf(u64 high_cgroup_id, u64 low_cgroup_id,
+	  struct memcg_async_reclaim **skel_ptr, bool use_thread_wq)
+{
+	struct memcg_async_reclaim *skel;
+	struct bpf_args_s bpf_args = {
+		.high_cgroup_id = high_cgroup_id,
+		.low_cgroup_id = low_cgroup_id,
+		.event_delta_threshold = EVENT_DELTA_THRESHOLD,
+		.check_ns = CHECK_PERIOD_NS,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, run_opts,
+		.ctx_in = &bpf_args,
+		.ctx_size_in = sizeof(bpf_args));
+	int prog_init_fd, err;
+
+	skel = memcg_async_reclaim__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "memcg_async_reclaim__open_and_load"))
+		return -1;
+
+	if (use_thread_wq)
+		prog_init_fd = bpf_program__fd(skel->progs.thread_wq_prog_init);
+	else
+		prog_init_fd = bpf_program__fd(skel->progs.wq_prog_init);
+	if (!ASSERT_GE(prog_init_fd, 0, "bpf_program__fd"))
+		goto error_out;
+
+	err = bpf_prog_test_run_opts(prog_init_fd, &run_opts);
+	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
+		goto error_out;
+	if (!ASSERT_EQ(run_opts.retval, 0, "prog_init retval"))
+		goto error_out;
+
+	*skel_ptr = skel;
+	return 0;
+
+error_out:
+	memcg_async_reclaim__destroy(skel);
+	return -1;
+}
+
+void test_memcg_wq_async_reclaim(void)
+{
+	u64 high_cgroup_id, low_cgroup_id;
+	int err;
+	double high_time = 0.0, low_time = 0.0;
+	struct memcg_async_reclaim *skel = NULL;
+
+	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
+	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
+		return;
+
+	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel, false);
+	if (!ASSERT_OK(err, "setup_bpf"))
+		goto out;
+
+	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
+	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
+		goto out;
+
+	if (high_time >= low_time) {
+		PRINT_FAIL("high cgroup not improved with async reclaim: high_time=%f low_time=%f",
+			   high_time, low_time);
+	}
+
+out:
+	if (skel)
+		memcg_async_reclaim__destroy(skel);
+	/*
+	 * Wait for bpf_wq to release the reference to cgroup
+	 * to ensure the successful deletion of cgroup.
+	 */
+	sleep(1);
+	cleanup_cgroup_environment();
+}
+
+void test_memcg_thread_wq_async_reclaim(void)
+{
+	u64 high_cgroup_id, low_cgroup_id;
+	int err;
+	double high_time = 0.0, low_time = 0.0;
+	struct memcg_async_reclaim *skel = NULL;
+
+	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
+	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
+		return;
+
+	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel, true);
+	if (!ASSERT_OK(err, "setup_bpf"))
+		goto out;
+
+	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
+	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
+		goto out;
+
+	if (high_time >= low_time) {
+		PRINT_FAIL("high cgroup not improved with async reclaim: high_time=%f low_time=%f",
+			   high_time, low_time);
+	}
+
+out:
+	if (skel)
+		memcg_async_reclaim__destroy(skel);
+	/*
+	 * Wait for bpf_thread_wq to release the reference to cgroup
+	 * to ensure the successful deletion of cgroup.
+	 */
+	sleep(1);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
new file mode 100644
index 000000000000..eaccc8a37388
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include "bpf_experimental.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define BIT(nr)			(1UL << (nr))
+
+#define ___GFP_IO		BIT(___GFP_IO_BIT)
+#define ___GFP_FS		BIT(___GFP_FS_BIT)
+#define ___GFP_DIRECT_RECLAIM	BIT(___GFP_DIRECT_RECLAIM_BIT)
+#define ___GFP_KSWAPD_RECLAIM	BIT(___GFP_KSWAPD_RECLAIM_BIT)
+
+#define __GFP_IO		((gfp_t)___GFP_IO)
+#define __GFP_FS		((gfp_t)___GFP_FS)
+#define __GFP_DIRECT_RECLAIM	((gfp_t)___GFP_DIRECT_RECLAIM)
+#define __GFP_KSWAPD_RECLAIM	((gfp_t)___GFP_KSWAPD_RECLAIM)
+#define __GFP_RECLAIM	((gfp_t)(___GFP_DIRECT_RECLAIM | ___GFP_KSWAPD_RECLAIM))
+
+#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
+#define CLOCK_MONOTONIC_ID	1
+#define RECLAIM_PAGES		32
+#define RECLAIM_MAX_ITER	32
+
+struct bpf_args_s {
+	u64 high_cgroup_id;
+	u64 low_cgroup_id;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+struct cgroup_memcg {
+	struct cgroup *cgrp;
+	struct mem_cgroup *memcg;
+};
+
+static u64 wq_high_cgroup_id;
+static u64 wq_low_cgroup_id;
+
+static int get_cgroup_memcg_from_id(u64 cgroup_id, struct cgroup_memcg *cm)
+{
+	cm->cgrp = bpf_cgroup_from_id(cgroup_id);
+	if (!cm->cgrp)
+		return -1;
+
+	cm->memcg = bpf_get_mem_cgroup(&cm->cgrp->self);
+	if (!cm->memcg) {
+		bpf_cgroup_release(cm->cgrp);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void put_cgroup_memcg(struct cgroup_memcg *cm)
+{
+	bpf_put_mem_cgroup(cm->memcg);
+	bpf_cgroup_release(cm->cgrp);
+}
+
+static int get_cgroup_event(u64 cgroup_id, u64 *val)
+{
+	struct cgroup_memcg cm;
+
+	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
+		return -1;
+	bpf_mem_cgroup_flush_stats(cm.memcg);
+	*val = bpf_mem_cgroup_page_state(cm.memcg, WORKINGSET_REFAULT_FILE);
+	put_cgroup_memcg(&cm);
+
+	return 0;
+}
+
+static bool
+should_reclaim_cgroup(u64 cgroup_id, u64 *prev_event, u64 event_delta_threshold)
+{
+	u64 cur, delta;
+
+	if (get_cgroup_event(cgroup_id, &cur))
+		return false;
+
+	delta = cur - *prev_event;
+	*prev_event = cur;
+
+	return delta >= event_delta_threshold;
+}
+
+static int reclaim_cgroup(u64 cgroup_id)
+{
+	struct cgroup_memcg cm;
+	int i;
+
+	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
+		return 0;
+
+	for (i = 0; i < RECLAIM_MAX_ITER; i++) {
+		if (!bpf_try_to_free_mem_cgroup_pages(cm.memcg, RECLAIM_PAGES,
+						      GFP_KERNEL, 0, -1))
+			break;
+	}
+
+	put_cgroup_memcg(&cm);
+
+	return 0;
+}
+
+struct wq_elem {
+	struct bpf_timer timer;
+	struct bpf_wq work;
+	u64 prev_event;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct wq_elem);
+} wq_map SEC(".maps");
+
+static int async_free(void *map, int *key, void *value)
+{
+	struct wq_elem *elem = value;
+
+	if (should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
+		elem->event_delta_threshold)) {
+		reclaim_cgroup(wq_low_cgroup_id);
+		bpf_wq_start(&elem->work, 0);
+	}
+
+	return 0;
+}
+
+static int wq_timer_cb(void *map, int *key, struct wq_elem *elem)
+{
+	bpf_wq_start(&elem->work, 0);
+	bpf_timer_start(&elem->timer, elem->check_ns, 0);
+
+	return 0;
+}
+
+SEC("syscall")
+int wq_prog_init(struct bpf_args_s *ctx)
+{
+	struct wq_elem *elem;
+	__u32 key = 0;
+	int ret;
+
+	elem = bpf_map_lookup_elem(&wq_map, &key);
+	if (!elem)
+		return -1;
+
+	ret = bpf_wq_init(&elem->work, &wq_map, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_wq_set_callback(&elem->work, async_free, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_init(&elem->timer, &wq_map, CLOCK_MONOTONIC_ID);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_set_callback(&elem->timer, wq_timer_cb);
+	if (ret)
+		return ret;
+
+	elem->prev_event = 0;
+	elem->event_delta_threshold = ctx->event_delta_threshold;
+	elem->check_ns = ctx->check_ns;
+
+	wq_high_cgroup_id = ctx->high_cgroup_id;
+	wq_low_cgroup_id = ctx->low_cgroup_id;
+
+	return bpf_timer_start(&elem->timer, elem->check_ns, 0);
+}
+
+struct thread_wq_elem {
+	struct bpf_timer timer;
+	struct bpf_thread_wq work;
+	u64 prev_event;
+	u64 event_delta_threshold;
+	u64 check_ns;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct thread_wq_elem);
+} thread_wq_map SEC(".maps");
+
+static int thread_async_free(void *map, int *key, void *value)
+{
+	struct thread_wq_elem *elem = value;
+
+	if (should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
+		elem->event_delta_threshold)) {
+		reclaim_cgroup(wq_low_cgroup_id);
+		bpf_thread_wq_start(&elem->work, 0);
+	}
+
+	return 0;
+}
+
+static int thread_wq_timer_cb(void *map, int *key, struct thread_wq_elem *elem)
+{
+	bpf_thread_wq_start(&elem->work, 0);
+	bpf_timer_start(&elem->timer, elem->check_ns, 0);
+
+	return 0;
+}
+
+SEC("syscall")
+int thread_wq_prog_init(struct bpf_args_s *ctx)
+{
+	struct thread_wq_elem *elem;
+	__u32 key = 0;
+	int ret;
+
+	elem = bpf_map_lookup_elem(&thread_wq_map, &key);
+	if (!elem)
+		return -1;
+
+	ret = bpf_thread_wq_init(&elem->work, &thread_wq_map,
+				 ctx->low_cgroup_id, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_thread_wq_set_callback(&elem->work, thread_async_free, 0);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_init(&elem->timer, &thread_wq_map, CLOCK_MONOTONIC_ID);
+	if (ret)
+		return ret;
+
+	ret = bpf_timer_set_callback(&elem->timer, thread_wq_timer_cb);
+	if (ret)
+		return ret;
+
+	elem->prev_event = 0;
+	elem->event_delta_threshold = ctx->event_delta_threshold;
+	elem->check_ns = ctx->check_ns;
+
+	wq_high_cgroup_id = ctx->high_cgroup_id;
+	wq_low_cgroup_id = ctx->low_cgroup_id;
+
+	return bpf_timer_start(&elem->timer, elem->check_ns, 0);
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.53.0

