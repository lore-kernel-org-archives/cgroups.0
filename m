From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 3/3] kselftest/cgroup: add cgroup destruction test
Date: Fri, 24 Jan 2020 12:40:17 +0100
Message-ID: <20200124114017.8363-4-mkoutny@suse.com>
References: <20200120145635.GA30904@blackbody.suse.cz>
 <20200124114017.8363-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200124114017.8363-1-mkoutny-IBi9RG/b67k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Add new test to verify that a cgroup with dead processes can be destroyed.
The test spawns a child process which allocates and touches 100MB of RAM
to ensure prolonged exit. Subsequently it kills the child, waits until
the cgroup containing the child is empty and destroys the cgroup.

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
[mkoutny-IBi9RG/b67k@public.gmane.org: Fix typo in test_cgcore_destroy comment]
Acked-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_core.c | 113 +++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index c5ca669feb2b..76c9dd578ba5 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -2,7 +2,10 @@
 
 #include <linux/limits.h>
 #include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
 #include <unistd.h>
+#include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
 #include <signal.h>
@@ -12,6 +15,115 @@
 #include "../kselftest.h"
 #include "cgroup_util.h"
 
+static int touch_anon(char *buf, size_t size)
+{
+	int fd;
+	char *pos = buf;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	while (size > 0) {
+		ssize_t ret = read(fd, pos, size);
+
+		if (ret < 0) {
+			if (errno != EINTR) {
+				close(fd);
+				return -1;
+			}
+		} else {
+			pos += ret;
+			size -= ret;
+		}
+	}
+	close(fd);
+
+	return 0;
+}
+
+static int alloc_and_touch_anon_noexit(const char *cgroup, void *arg)
+{
+	int ppid = getppid();
+	size_t size = (size_t)arg;
+	void *buf;
+
+	buf = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON,
+		   0, 0);
+	if (buf == MAP_FAILED)
+		return -1;
+
+	if (touch_anon((char *)buf, size)) {
+		munmap(buf, size);
+		return -1;
+	}
+
+	while (getppid() == ppid)
+		sleep(1);
+
+	munmap(buf, size);
+	return 0;
+}
+
+/*
+ * Create a child process that allocates and touches 100MB, then waits to be
+ * killed. Wait until the child is attached to the cgroup, kill all processes
+ * in that cgroup and wait until "cgroup.procs" is empty. At this point try to
+ * destroy the empty cgroup. The test helps detect race conditions between
+ * dying processes leaving the cgroup and cgroup destruction path.
+ */
+static int test_cgcore_destroy(const char *root)
+{
+	int ret = KSFT_FAIL;
+	char *cg_test = NULL;
+	int child_pid;
+	char buf[PAGE_SIZE];
+
+	cg_test = cg_name(root, "cg_test");
+
+	if (!cg_test)
+		goto cleanup;
+
+	for (int i = 0; i < 10; i++) {
+		if (cg_create(cg_test))
+			goto cleanup;
+
+		child_pid = cg_run_nowait(cg_test, alloc_and_touch_anon_noexit,
+					  (void *) MB(100));
+
+		if (child_pid < 0)
+			goto cleanup;
+
+		/* wait for the child to enter cgroup */
+		if (cg_wait_for_proc_count(cg_test, 1))
+			goto cleanup;
+
+		if (cg_killall(cg_test))
+			goto cleanup;
+
+		/* wait for cgroup to be empty */
+		while (1) {
+			if (cg_read(cg_test, "cgroup.procs", buf, sizeof(buf)))
+				goto cleanup;
+			if (buf[0] == '\0')
+				break;
+			usleep(1000);
+		}
+
+		if (rmdir(cg_test))
+			goto cleanup;
+
+		if (waitpid(child_pid, NULL, 0) < 0)
+			goto cleanup;
+	}
+	ret = KSFT_PASS;
+cleanup:
+	if (cg_test)
+		cg_destroy(cg_test);
+	free(cg_test);
+	return ret;
+}
+
 /*
  * A(0) - B(0) - C(1)
  *        \ D(0)
@@ -512,6 +624,7 @@ struct corecg_test {
 	T(test_cgcore_populated),
 	T(test_cgcore_proc_migration),
 	T(test_cgcore_thread_migration),
+	T(test_cgcore_destroy),
 };
 #undef T
 
-- 
2.24.1

