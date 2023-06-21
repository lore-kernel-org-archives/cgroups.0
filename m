From: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] selftests: cgroup: add test_zswap with no kmem bypass test
Date: Wed, 21 Jun 2023 17:35:47 +0200
Message-ID: <20230621153548.428093-3-cerasuolodomenico@gmail.com>
References: <20230621153548.428093-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687361757; x=1689953757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzChpS5/qP0KCHtoRtmdGCRzY7mcg9Tmt0tlVbK0cFM=;
        b=a2EpY5FRgZg/ZJx9472PbHOAXhPjVRtL3gkOHiWZAInSGWmfd8S2waNUr8x/3fVqsn
         YvkLgmXw++orjAi7+VylLJjJrxY3bPjAH2qQZiYhmyzMvg8KtGXNH8Sy8rKuOp8TL2LI
         iFBNuY0fFlhVGLK5cj7U6GlTFtiiCDlMatudwoWI4DdGS96p0hhTnedP0JP0ewZ3O1A/
         XuueBkpwrasA+tNp/PZOlPfYv3RVEuvyTlDXwV/kkfZ3nJVWkA1fPeSfDtCSYAjS9RVA
         nGieIhGo9G/hfgT1jhvvwFTxwozp3MjDnp4fpvmTVkR3rqT86nVUJblmtQ7pjQgBFco6
         +XyQ==
In-Reply-To: <20230621153548.428093-1-cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ddstreet-EkmVulN54Sk@public.gmane.org, vitaly.wool-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add a cgroup selftest that verifies memcg charging in zswap.
The original issue was that kmem bypass was applied to pages swapped out
to zswap by kswapd, resulting in zswapped memory not being charged.
It was fixed by commit cd08d80ecdac("mm: correctly charge compressed
memory to its memcg").

Signed-off-by: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 163 ++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 001533667322..e859fecd310b 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -4,15 +4,178 @@
 #include <linux/limits.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <signal.h>
+#include <sys/sysinfo.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
 
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static int read_int(const char *path, size_t *value)
+{
+	FILE *file;
+	int ret = 0;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -1;
+	if (fscanf(file, "%ld", value) != 1)
+		ret = -1;
+	fclose(file);
+	return ret;
+}
+
+static int set_min_free_kb(size_t value)
+{
+	FILE *file;
+	int ret;
+
+	file = fopen("/proc/sys/vm/min_free_kbytes", "w");
+	if (!file)
+		return -1;
+	ret = fprintf(file, "%ld\n", value);
+	fclose(file);
+	return ret;
+}
+
+static int read_min_free_kb(size_t *value)
+{
+	return read_int("/proc/sys/vm/min_free_kbytes", value);
+}
+
+static int get_zswap_stored_pages(size_t *value)
+{
+	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
+}
+
+struct no_kmem_bypass_child_args {
+	size_t target_alloc_bytes;
+	size_t child_allocated;
+};
+
+static int no_kmem_bypass_child(const char *cgroup, void *arg)
+{
+	struct no_kmem_bypass_child_args *values = arg;
+	void *allocation;
+
+	allocation = malloc(values->target_alloc_bytes);
+	if (!allocation) {
+		values->child_allocated = true;
+		return -1;
+	}
+	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+		((char *)allocation)[i] = 'a';
+	values->child_allocated = true;
+	pause();
+	free(allocation);
+	return 0;
+}
+
+/*
+ * When pages owned by a memcg are pushed to zswap by kswapd, they should be
+ * charged to that cgroup. This wasn't the case before commit
+ * cd08d80ecdac("mm: correctly charge compressed memory to its memcg").
+ *
+ * The test first allocates memory in a memcg, then raises min_free_kbytes to
+ * a very high value so that the allocation falls below low wm, then makes
+ * another allocation to trigger kswapd that should push the memcg-owned pages
+ * to zswap and verifies that the zswap pages are correctly charged.
+ *
+ * To be run on a VM with at most 4G of memory.
+ */
+static int test_no_kmem_bypass(const char *root)
+{
+	size_t min_free_kb_high, min_free_kb_low, min_free_kb_original;
+	struct no_kmem_bypass_child_args *values;
+	size_t trigger_allocation_size;
+	int wait_child_iteration = 0;
+	long stored_pages_threshold;
+	struct sysinfo sys_info;
+	int ret = KSFT_FAIL;
+	int child_status;
+	char *test_group;
+	pid_t child_pid;
+
+	/* Read sys info and compute test values accordingly */
+	if (sysinfo(&sys_info) != 0)
+		return KSFT_FAIL;
+	if (sys_info.totalram > 5000000000)
+		return KSFT_SKIP;
+	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
+			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (values == MAP_FAILED)
+		return KSFT_FAIL;
+	if (read_min_free_kb(&min_free_kb_original))
+		return KSFT_FAIL;
+	min_free_kb_high = sys_info.totalram / 2000;
+	min_free_kb_low = sys_info.totalram / 500000;
+	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
+		sys_info.totalram * 5 / 100;
+	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	trigger_allocation_size = sys_info.totalram / 20;
+
+	/* Set up test memcg */
+	if (cg_write(root, "cgroup.subtree_control", "+memory"))
+		goto out;
+	test_group = cg_name(root, "kmem_bypass_test");
+	if (!test_group)
+		goto out;
+
+	/* Spawn memcg child and wait for it to allocate */
+	set_min_free_kb(min_free_kb_low);
+	if (cg_create(test_group))
+		goto out;
+	values->child_allocated = false;
+	child_pid = cg_run_nowait(test_group, no_kmem_bypass_child, values);
+	if (child_pid < 0)
+		goto out;
+	while (!values->child_allocated && wait_child_iteration++ < 10000)
+		usleep(1000);
+
+	/* Try to wakeup kswapd and let it push child memory to zswap */
+	set_min_free_kb(min_free_kb_high);
+	for (int i = 0; i < 20; i++) {
+		size_t stored_pages;
+		char *trigger_allocation = malloc(trigger_allocation_size);
+
+		if (!trigger_allocation)
+			break;
+		for (int i = 0; i < trigger_allocation_size; i += 4095)
+			trigger_allocation[i] = 'b';
+		usleep(100000);
+		free(trigger_allocation);
+		if (get_zswap_stored_pages(&stored_pages))
+			break;
+		if (stored_pages < 0)
+			break;
+		/* If memory was pushed to zswap, verify it belongs to memcg */
+		if (stored_pages > stored_pages_threshold) {
+			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
+			int delta = stored_pages * 4096 - zswapped;
+			int result_ok = delta < stored_pages * 4096 / 4;
+
+			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			break;
+		}
+	}
+
+	kill(child_pid, SIGTERM);
+	waitpid(child_pid, &child_status, 0);
+out:
+	set_min_free_kb(min_free_kb_original);
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
 	const char *name;
 } tests[] = {
+	T(test_no_kmem_bypass),
 };
 #undef T
 
-- 
2.34.1

