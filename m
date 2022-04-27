From: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] selftests: cgroup: Fix unsigned expression compared with zero
Date: Wed, 27 Apr 2022 14:17:56 +0800
Message-ID: <20220427061756.56893-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Fix the following coccicheck warnings:

./tools/testing/selftests/cgroup/cgroup_util.c:566:8-12: WARNING:
Unsigned expression compared with zero: size < 0.

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 2 +-
 tools/testing/selftests/cgroup/cgroup_util.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 4c52cc6f2f9c..661e06b94a43 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -552,7 +552,7 @@ int proc_mount_contains(const char *option)
 	return strstr(buf, option) != NULL;
 }
 
-ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
+ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, ssize_t size)
 {
 	char path[PATH_MAX];
 
diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing/selftests/cgroup/cgroup_util.h
index c92df4e5d395..7b3865805f50 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/cgroup_util.h
@@ -53,7 +53,7 @@ extern int set_oom_adj_score(int pid, int score);
 extern int cg_wait_for_proc_count(const char *cgroup, int count);
 extern int cg_killall(const char *cgroup);
 int proc_mount_contains(const char *option);
-extern ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size);
+extern ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, ssize_t size);
 extern int proc_read_strstr(int pid, bool thread, const char *item, const char *needle);
 extern pid_t clone_into_cgroup(int cgroup_fd);
 extern int clone_reap(pid_t pid, int options);
-- 
2.20.1.7.g153144c

