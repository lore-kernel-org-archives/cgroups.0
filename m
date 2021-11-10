From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] mm, shmem, selftests: add tmpfs memcg= mount option tests
Date: Wed, 10 Nov 2021 13:19:50 -0800
Message-ID: <20211110211951.3730787-5-almasrymina@google.com>
References: <20211110211951.3730787-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=XWUyVcqFDorfkxK8BmUlQ2jLw5lcWmVuPPsoovex71Y=;
        b=G2nMJLGxPIMyEeUfb/vaasX85o5Sfnbuzq+2YEd/YK686uuZTNaruqnosc1t/nwbaF
         m5N05wjs10IyzymZE1gJ6SWhZ1AMTcdNqaVe9/ePQ2lp28a0MtFXaJFaLSD8rvEzo5Wh
         arhruu4iKXYXKUfbZPe5gNtak87IS9WUPyWzKzMJN8Yxwl5hewD/kaNYM4lIxyeTf+fa
         nBx6tWsFO5qj9ltm0CS79xcUMAQAurs6zyFOmzCmBBqH4fRRF/TfEkkeKLL+FAEsaSzs
         RtO8Yf1co/HOZQINwy2CIqTxLQgBoMSO3o/5uxwPDjYidsajo4DRAO7ZTOxHZhxVZTK5
         Ornw==
In-Reply-To: <20211110211951.3730787-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 tools/testing/selftests/vm/.gitignore     |   1 +
 tools/testing/selftests/vm/mmap_write.c   | 103 ++++++++++++++++++++++
 tools/testing/selftests/vm/tmpfs-memcg.sh |  87 ++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 tools/testing/selftests/vm/mmap_write.c
 create mode 100755 tools/testing/selftests/vm/tmpfs-memcg.sh

diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selftests/vm/.gitignore
index 2e7e86e852828..cb229974c5f15 100644
--- a/tools/testing/selftests/vm/.gitignore
+++ b/tools/testing/selftests/vm/.gitignore
@@ -19,6 +19,7 @@ madv_populate
 userfaultfd
 mlock-intersect-test
 mlock-random-test
+mmap_write
 virtual_address_range
 gup_test
 va_128TBswitch
diff --git a/tools/testing/selftests/vm/mmap_write.c b/tools/testing/selftests/vm/mmap_write.c
new file mode 100644
index 0000000000000..88a8468f2128c
--- /dev/null
+++ b/tools/testing/selftests/vm/mmap_write.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This program faults memory in tmpfs
+ */
+
+#include <err.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/shm.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+
+/* Global definitions. */
+
+/* Global variables. */
+static const char *self;
+static char *shmaddr;
+static int shmid;
+
+/*
+ * Show usage and exit.
+ */
+static void exit_usage(void)
+{
+	printf("Usage: %s -p <path to tmpfs file> -s <size to map>\n", self);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char **argv)
+{
+	int fd = 0;
+	int key = 0;
+	int *ptr = NULL;
+	int c = 0;
+	int size = 0;
+	char path[256] = "";
+	int want_sleep = 0, private = 0;
+	int populate = 0;
+	int write = 0;
+	int reserve = 1;
+
+	/* Parse command-line arguments. */
+	setvbuf(stdout, NULL, _IONBF, 0);
+	self = argv[0];
+
+	while ((c = getopt(argc, argv, ":s:p:")) != -1) {
+		switch (c) {
+		case 's':
+			size = atoi(optarg);
+			break;
+		case 'p':
+			strncpy(path, optarg, sizeof(path));
+			break;
+		default:
+			errno = EINVAL;
+			perror("Invalid arg");
+			exit_usage();
+		}
+	}
+
+	printf("%s\n", path);
+	if (strncmp(path, "", sizeof(path)) != 0) {
+		printf("Writing to this path: %s\n", path);
+	} else {
+		errno = EINVAL;
+		perror("path not found");
+		exit_usage();
+	}
+
+	if (size != 0) {
+		printf("Writing this size: %d\n", size);
+	} else {
+		errno = EINVAL;
+		perror("size not found");
+		exit_usage();
+	}
+
+	fd = open(path, O_CREAT | O_RDWR, 0777);
+	if (fd == -1)
+		err(1, "Failed to open file.");
+
+	if (ftruncate(fd, size))
+		err(1, "failed to ftruncate %s", path);
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd);
+		err(1, "Error mapping the file");
+	}
+
+	printf("Writing to memory.\n");
+	memset(ptr, 1, size);
+	printf("Done writing to memory.\n");
+	close(fd);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/vm/tmpfs-memcg.sh b/tools/testing/selftests/vm/tmpfs-memcg.sh
new file mode 100755
index 0000000000000..eb584ddcbae5f
--- /dev/null
+++ b/tools/testing/selftests/vm/tmpfs-memcg.sh
@@ -0,0 +1,87 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+CGROUP_PATH=/dev/cgroup/memory/tmpfs-memcg-test
+
+function cleanup() {
+  rm -rf /mnt/tmpfs/*
+  umount /mnt/tmpfs
+  rm -rf /mnt/tmpfs
+
+  rmdir $CGROUP_PATH
+
+  echo CLEANUP DONE
+}
+
+function setup() {
+  mkdir -p $CGROUP_PATH
+  echo $((10 * 1024 * 1024)) > $CGROUP_PATH/memory.limit_in_bytes
+  echo 0 > $CGROUP_PATH/cpuset.cpus
+  echo 0 > $CGROUP_PATH/cpuset.mems
+
+  mkdir -p /mnt/tmpfs
+
+  echo SETUP DONE
+}
+
+function expect_equal() {
+  local expected="$1"
+  local actual="$2"
+  local error="$3"
+
+  if [[ "$actual" != "$expected" ]]; then
+    echo "expected ($expected) != actual ($actual): $3" >&2
+    cleanup
+    exit 1
+  fi
+}
+
+function expect_ge() {
+  local expected="$1"
+  local actual="$2"
+  local error="$3"
+
+  if [[ "$actual" -lt "$expected" ]]; then
+    echo "expected ($expected) < actual ($actual): $3" >&2
+    cleanup
+    exit 1
+  fi
+}
+
+cleanup
+setup
+
+mount -t tmpfs -o memcg=$CGROUP_PATH tmpfs /mnt/tmpfs
+
+TARGET_MEMCG_USAGE=$(cat $CGROUP_PATH/memory.usage_in_bytes)
+expect_equal 0 "$TARGET_MEMCG_USAGE" "Before echo, memcg usage should be 0"
+
+# Echo to allocate a page in the tmpfs
+echo hello > /mnt/tmpfs/test
+TARGET_MEMCG_USAGE=$(cat $CGROUP_PATH/memory.usage_in_bytes)
+expect_ge 4096 "$TARGET_MEMCG_USAGE" "After echo, memcg usage should be greater than 4096"
+echo "Echo test succeeded"
+
+tools/testing/selftests/vm/mmap_write -p /mnt/tmpfs/test -s $((1 * 1024 * 1024))
+TARGET_MEMCG_USAGE=$(cat $CGROUP_PATH/memory.usage_in_bytes)
+expect_ge $((1 * 1024 * 1024)) "$TARGET_MEMCG_USAGE" "After echo, memcg usage should greater than 1MB"
+echo "Write succeeded"
+
+# OOM the remote container on pagefault.
+echo
+echo
+echo "OOMing the remote container using pagefault."
+echo "This will take a long time because the kernel goes through reclaim retries,"
+echo "but should eventually be OOM-killed by 'Out of memory (Killing remote allocating task)'"
+#tools/testing/selftests/vm/mmap_write -p /mnt/tmpfs/test -s $((11 * 1024 * 1024))
+
+# OOM the remote container on non pagefault.
+echo
+echo
+echo "OOMing the remote container using cat (non-pagefault)"
+echo "This will take a long time because the kernel goes through reclaim retries,"
+echo "but should eventually the cat command should receive an ENOMEM"
+cat /dev/random > /mnt/tmpfs/random
+
+cleanup
+echo SUCCESS
