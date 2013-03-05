From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: remove include of cgroup.h from cpuset.h
Date: Tue, 5 Mar 2013 11:37:56 +0800
Message-ID: <51356894.9060501@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We don't need to include cgroup.h in cpuset.h.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cpuset.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 8c8a60d..ccd1de8 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
-#include <linux/cgroup.h>
 #include <linux/mm.h>
 
 #ifdef CONFIG_CPUSETS
-- 
1.8.0.2
