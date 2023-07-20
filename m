From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 8/8] selftests: cgroup: test_memcontrol: add a selftest
 for memcg recharging
Date: Thu, 20 Jul 2023 07:08:25 +0000
Message-ID: <20230720070825.992023-9-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836922; x=1692428922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyMIM9+tcYiRGMTsBGjvi0vU3Mwws8djANktEDDglwA=;
        b=byOeZzDwSe+TlCjYRKBoXqqWywqR6C1yG/A40dOXCXNDbvhvWImB25mBWajRKzlpsd
         7pw0yGkSnP78uE/qIJ91xiFtjZ8WsotdIkdUAUo9pCwMIjy6NapBzMWDaD5jSQ5WRKqG
         Se0fctUKe/3aEu5ubRL9pul76zHCCtINkNBEyKURGH2aFpknJ55HycotBhqzgpzYPQKE
         UJtv9JLEiNXgfyyCUh834Zn94be/WG5kodBP7zmNrBOk5cu/mZ3dShiUkQYtjSSYO1Rs
         4gRgPSThLVz2L65vzOc7OySwGSHuufaREX+F7eqZX0F2Ko4WmwxK9yLR5upAijtlIKWO
         +cGA==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

When a memcg is removed, any mapped pages charged to it are recharged to
the memcg of the process(es) mapping them. Any remaining pages are
recharged using deferred recharge on the next time they are accessed or
ditied. Add a selftest that exercises these paths for shmem and normal
files:
- A page is recharged on offlining if it is already mapped into the
  address space of a process in a different memcg.
- A page is recharged after offlining when written to by a process in a
  different memcg (if the write results in dirtying the page).
- A page is recharged after offlining when read by a process in a
  different memcg.
- A page is recharged after offlining when mapped by a process in a
  different memcg.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c  |  14 +
 tools/testing/selftests/cgroup/cgroup_util.h  |   1 +
 .../selftests/cgroup/test_memcontrol.c        | 310 ++++++++++++++++++
 3 files changed, 325 insertions(+)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index e8bbbdb77e0d..e853b2a4db77 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -519,6 +519,20 @@ int is_swap_enabled(void)
 	return cnt > 1;
 }
 
+
+int is_memcg_recharging_enabled(void)
+{
+	char buf[10];
+	bool enabled;
+
+	if (read_text("/proc/sys/vm/recharge_offline_memcgs",
+		      buf, sizeof(buf)) <= 0)
+		return -1;
+
+	enabled = strtol(buf, NULL, 10);
+	return enabled;
+}
+
 int set_oom_adj_score(int pid, int score)
 {
 	char path[PATH_MAX];
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index c92df4e5d395..10c0fa36bfd7 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -49,6 +49,7 @@ extern int get_temp_fd(void);
 extern int alloc_pagecache(int fd, size_t size);
 extern int alloc_anon(const char *cgroup, void *arg);
 extern int is_swap_enabled(void);
+extern int is_memcg_recharging_enabled(void);
 extern int set_oom_adj_score(int pid, int score);
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index c7c9572003a8..4e1ea93e0a54 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -17,6 +17,8 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
+#include <sched.h>
 
 #include "../kselftest.h"
 #include "cgroup_util.h"
@@ -1287,6 +1289,313 @@ static int test_memcg_oom_group_score_events(const char *root)
 	return ret;
 }
 
+/* Map 50M from the beginning of a file */
+static int map_fd_50M_noexit(const char *cgroup, void *arg)
+{
+	size_t size = MB(50);
+	int ppid = getppid();
+	int fd = (long)arg;
+	char *memory;
+
+	memory = mmap(NULL, size, PROT_READ, MAP_SHARED | MAP_POPULATE, fd, 0);
+	if (memory == MAP_FAILED) {
+		fprintf(stderr, "error: mmap, errno %d\n", errno);
+		return -1;
+	}
+
+	while (getppid() == ppid)
+		sleep(1);
+
+	munmap(memory, size);
+	return 0;
+}
+
+/*
+ * Write 50M to the beginning of a file.
+ * The file is sync'ed first to make sure any dirty pages are laundered before
+ * we dirty them again.
+ */
+static int write_fd_50M(const char *cgroup, void *arg)
+{
+	size_t size = MB(50);
+	int fd = (long)arg;
+	char buf[PAGE_SIZE];
+	int i;
+
+	fsync(fd);
+	lseek(fd, 0, SEEK_SET);
+	for (i = 0; i < size; i += sizeof(buf))
+		write(fd, buf, sizeof(buf));
+
+	return 0;
+}
+
+/* See write_fd_50M() */
+static int write_fd_50M_noexit(const char *cgroup, void *arg)
+{
+	int ppid = getppid();
+
+	write_fd_50M(cgroup, arg);
+
+	while (getppid() == ppid)
+		sleep(1);
+
+	return 0;
+}
+
+/* Read 50M from the beginning of a file */
+static int read_fd_50M_noexit(const char *cgroup, void *arg)
+{
+	size_t size = MB(50);
+	int ppid = getppid();
+	int fd = (long)arg;
+	char buf[PAGE_SIZE];
+	int i;
+
+	lseek(fd, 0, SEEK_SET);
+	for (i = 0; i < size; i += sizeof(buf))
+		read(fd, buf, sizeof(buf));
+
+	while (getppid() == ppid)
+		sleep(1);
+
+	return 0;
+}
+
+#define TEST_RECHARGE_DIR "/test-recharge"
+
+static int __test_memcg_recharge(const char *root, char *stat_name)
+{
+	char *parent = NULL, *child1 = NULL, *child2 = NULL;
+	long stat, prev, pstat, current;
+	int ret = KSFT_FAIL;
+	char file_path[256];
+	int i, pid;
+	struct {
+		int fd;
+		int (*before_fn)(const char *cgroup, void *arg);
+		int (*after_fn)(const char *cgroup, void *arg);
+	} test_files[] = {
+		/* test recharge for already mapped file */
+		{
+			.before_fn = map_fd_50M_noexit,
+		},
+		/* test recharge on new mapping after offline */
+		{
+			.after_fn = map_fd_50M_noexit,
+		},
+		/* test recharge on write after offline */
+		{
+			.after_fn = write_fd_50M_noexit,
+		},
+		/* test recharge on read after offline */
+		{
+			.after_fn = read_fd_50M_noexit,
+		}
+	};
+
+	parent = cg_name(root, "parent");
+	if (!parent)
+		goto cleanup;
+
+	if (cg_create(parent))
+		goto cleanup;
+
+	if (cg_write(parent, "cgroup.subtree_control", "+memory"))
+		goto cleanup;
+
+	child1 = cg_name(parent, "child1");
+	if (!child1)
+		goto cleanup;
+
+	if (cg_create(child1))
+		goto cleanup;
+
+	child2 = cg_name(parent, "child2");
+	if (!child2)
+		goto cleanup;
+
+	if (cg_create(child2))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(test_files); i++) {
+		long target = MB(50) * (i+1); /* 50MB per file */
+		int fd;
+
+		snprintf(file_path, sizeof(file_path), "%s/file%d",
+			 TEST_RECHARGE_DIR, i);
+
+		fd = open(file_path, O_CREAT | O_RDWR);
+		if (fd < 0)
+			goto cleanup;
+
+		test_files[i].fd = fd;
+		if (cg_run(child1, write_fd_50M, (void *)(long) fd))
+			goto cleanup;
+
+		stat = 0;
+		do {
+			sleep(1);
+			prev = stat;
+			stat = cg_read_key_long(child1, "memory.stat",
+						stat_name);
+		} while (stat < target && stat > prev);
+
+		if (stat < target) {
+			fprintf(stderr, "error: child1 %s %ld < %ld",
+				stat_name, stat, target);
+			goto cleanup;
+		}
+
+		current = cg_read_long(child1, "memory.current");
+		if (current < target) {
+			fprintf(stderr, "error: child1 current %ld < %ld",
+				current, target);
+			goto cleanup;
+		}
+
+		if (test_files[i].before_fn) {
+			pid = cg_run_nowait(child2, test_files[i].before_fn,
+					    (void *)(long)fd);
+			if (pid < 0)
+				goto cleanup;
+			/* make sure before_fn() finishes executing before offlining */
+			sleep(1);
+		}
+	}
+
+	current = cg_read_long(child2, "memory.current");
+	if (current > MB(1)) {
+		fprintf(stderr, "error: child2 current %ld > 1M\n", current);
+		goto cleanup;
+	}
+
+	stat = cg_read_key_long(child2, "memory.stat", stat_name);
+	if (stat > 0) {
+		fprintf(stderr, "error: child2 %s %ld > 0\n",
+			stat_name, stat);
+		goto cleanup;
+	}
+
+	if (cg_destroy(child1) < 0)
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(test_files); i++) {
+		long target = MB(50) * (i+1);
+		int fd = test_files[i].fd;
+
+		if (test_files[i].after_fn) {
+			pid = cg_run_nowait(child2, test_files[i].after_fn,
+					    (void *)(long)fd);
+			if (pid < 0)
+				goto cleanup;
+		}
+
+		stat = 0;
+		do {
+			sleep(1);
+			prev = stat;
+			stat = cg_read_key_long(child2, "memory.stat",
+						stat_name);
+		} while (stat < target && stat > prev);
+
+		if (stat < target) {
+			fprintf(stderr, "error: child2 %s %ld < %ld\n",
+				stat_name, stat, target);
+			goto cleanup;
+		}
+
+		current = cg_read_long(child2, "memory.current");
+		if (current < target) {
+			fprintf(stderr, "error: child2 current %ld < %ld\n",
+				current, target);
+			goto cleanup;
+		}
+	}
+
+	pstat = cg_read_key_long(parent, "memory.stat", stat_name);
+	if (stat < pstat) {
+		fprintf(stderr, "error: recharged %s (%ld) < total (%ld)\n",
+			stat_name, stat, pstat);
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+cleanup:
+	if (child2) {
+		cg_destroy(child2);
+		free(child2);
+	}
+	if (child1) {
+		cg_destroy(child1);
+		free(child1);
+	}
+	if (parent) {
+		cg_destroy(parent);
+		free(parent);
+	}
+	for (i = 0; i < ARRAY_SIZE(test_files); i++) {
+		close(test_files[i].fd);
+		snprintf(file_path, sizeof(file_path), "%s/file%d",
+			 TEST_RECHARGE_DIR, i);
+		remove(file_path);
+	}
+	return ret;
+}
+
+static int test_memcg_recharge(const char *root)
+{
+	int i, ret = KSFT_PASS;
+	struct {
+		char *mount_type, *stat_name;
+	} test_setups[] = {
+		/* test both shmem & normal files */
+		{
+			.mount_type = "tmpfs",
+			.stat_name = "shmem",
+		},
+		{
+			.stat_name = "file",
+		}
+	};
+
+	if (!is_memcg_recharging_enabled())
+		return KSFT_SKIP;
+
+	if (unshare(CLONE_NEWNS) < 0)
+		return KSFT_FAIL;
+
+	if (mount(NULL, "/", "", MS_REC | MS_PRIVATE, NULL) < 0)
+		return KSFT_FAIL;
+
+	for (i = 0; i < ARRAY_SIZE(test_setups); i++) {
+		int setup_ret = KSFT_FAIL;
+		char *mount_type = test_setups[i].mount_type;
+		char *stat_name = test_setups[i].stat_name;
+
+		if (mkdir(TEST_RECHARGE_DIR, 0777) < 0)
+			goto next;
+
+		if (mount_type &&
+		    mount(NULL, TEST_RECHARGE_DIR, mount_type, 0, NULL) < 0)
+			goto next;
+
+		setup_ret = __test_memcg_recharge(root, stat_name);
+
+next:
+		if (mount_type)
+			umount(TEST_RECHARGE_DIR);
+		remove(TEST_RECHARGE_DIR);
+
+		if (setup_ret == KSFT_FAIL) {
+			ret = KSFT_FAIL;
+			break;
+		}
+	}
+	umount("/");
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct memcg_test {
 	int (*fn)(const char *root);
@@ -1306,6 +1615,7 @@ struct memcg_test {
 	T(test_memcg_oom_group_leaf_events),
 	T(test_memcg_oom_group_parent_events),
 	T(test_memcg_oom_group_score_events),
+	T(test_memcg_recharge),
 };
 #undef T
 
-- 
2.41.0.255.g8b1d071c50-goog

