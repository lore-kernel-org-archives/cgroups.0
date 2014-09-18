From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix unbalanced locking
Date: Thu, 18 Sep 2014 17:28:46 +0800
Message-ID: <541AA5CE.8040006@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.

It is wrong that we release the mutex in the failure path in
pidlist_array_load(), because cgroup_pidlist_stop() will be called
no matter if cgroup_pidlist_start() returns errno or not.

Fixes: 4bac00d16a8760eae7205e41d2c246477d42a210
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.14+
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2332efd..de70b63 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3970,7 +3970,6 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		mutex_unlock(&cgrp->pidlist_mutex);
 		pidlist_free(array);
 		return -ENOMEM;
 	}
-- 
1.8.0.2
