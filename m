From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove unneeded header files
Date: Sat, 10 Jun 2023 14:41:38 +0800
Message-ID: <20230610064138.1472319-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Remove some unnecessary header files. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b0aee733b92b..58e6f18f01c1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -37,12 +37,10 @@
 #include <linux/sched/deadline.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
-#include <linux/seq_file.h>
 #include <linux/security.h>
 #include <linux/spinlock.h>
 #include <linux/oom.h>
 #include <linux/sched/isolation.h>
-#include <linux/mutex.h>
 #include <linux/cgroup.h>
 #include <linux/wait.h>
 
-- 
2.27.0

