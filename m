From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: fix the WARN_ON() in update_nodemasks_hier()
Date: Wed, 30 Jul 2014 15:07:13 +0800
Message-ID: <53D899A1.3080003@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The WARN_ON() is used to check if we break the legal hierarchy, on
which the effective mems should be equal to configured mems.

Reported-by: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Tested-by: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 53a9bbf..baa155c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1136,7 +1136,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		mutex_unlock(&callback_mutex);
 
 		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
-			nodes_equal(cp->mems_allowed, cp->effective_mems));
+			!nodes_equal(cp->mems_allowed, cp->effective_mems));
 
 		update_tasks_nodemask(cp);
 
-- 
1.8.0.2
