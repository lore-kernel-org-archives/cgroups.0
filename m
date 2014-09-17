From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] ccgroup: remove redundant code in cgroup_rmdir()
Date: Wed, 17 Sep 2014 18:18:34 +0800
Message-ID: <54195FFA.6050600@huawei.com>
References: <54195FE1.9030607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54195FE1.9030607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We no longer clear kn->priv in cgroup_rmdir(), so we don't need
to get an extra refcnt.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0ce9d9e..26b8cb9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4841,13 +4841,10 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	cgrp = cgroup_kn_lock_live(kn);
 	if (!cgrp)
 		return 0;
-	cgroup_get(cgrp);	/* for @kn->priv clearing */
 
 	ret = cgroup_destroy_locked(cgrp);
 
 	cgroup_kn_unlock(kn);
-
-	cgroup_put(cgrp);
 	return ret;
 }
 
-- 
1.8.0.2
