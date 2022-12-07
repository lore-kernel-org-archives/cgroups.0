From: Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests: cgroup: Fix the invalid check in proc_read_text()
Date: Wed, 7 Dec 2022 16:33:09 +0800
Message-ID: <1670401989-8208-1-git-send-email-wangyufen@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Unsigned variable cannot be lesser than zero, So the return check of read_text() is invalid.
To fix, add a new ssize_t variable read for read_text() return value check.

Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
Signed-off-by: Wang Yufen <wangyufen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 4c52cc6..19137c0 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -555,6 +555,7 @@ int proc_mount_contains(const char *option)
 ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
 {
 	char path[PATH_MAX];
+	ssize_t read;
 
 	if (!pid)
 		snprintf(path, sizeof(path), "/proc/%s/%s",
@@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
 	else
 		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
 
-	size = read_text(path, buf, size);
-	return size < 0 ? -1 : size;
+	read = read_text(path, buf, size);
+	return read < 0 ? -1 : read;
 }
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
-- 
1.8.3.1

