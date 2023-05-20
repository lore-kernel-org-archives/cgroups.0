From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove unneeded header files
Date: Sun, 21 May 2023 00:06:34 +0800
Message-ID: <20230520160634.3015106-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove some unnecessary header files. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e4ca2dd2b764..a136c3e6144b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -25,25 +25,13 @@
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/cpuset.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/file.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/kmod.h>
-#include <linux/kthread.h>
-#include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
 #include <linux/export.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-#include <linux/namei.h>
-#include <linux/pagemap.h>
-#include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/deadline.h>
@@ -51,18 +39,9 @@
 #include <linux/sched/task.h>
 #include <linux/seq_file.h>
 #include <linux/security.h>
-#include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
-#include <linux/string.h>
-#include <linux/time.h>
-#include <linux/time64.h>
-#include <linux/backing-dev.h>
-#include <linux/sort.h>
 #include <linux/oom.h>
 #include <linux/sched/isolation.h>
-#include <linux/uaccess.h>
-#include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/cgroup.h>
 #include <linux/wait.h>
-- 
2.27.0

