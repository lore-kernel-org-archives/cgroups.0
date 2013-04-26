From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix use-after-free when umounting cgroupfs
Date: Fri, 26 Apr 2013 10:54:11 +0800
Message-ID: <5179EC53.6080006@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Try:
  # mount -t cgroup xxx /cgroup
  # mkdir /cgroup/sub && rmdir /cgroup/sub && umount /cgroup

And you might see this:

ida_remove called for id=1 which is not allocated.

It's because cgroup_kill_sb() is called to destroy root->cgroup_ida
and free cgrp->root before ida_simple_removed() is called. What's
worse is we're accessing cgrp->root while it has been freed.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6780459..a45aa12 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -845,9 +845,12 @@ static void cgroup_free_fn(struct work_struct *work)
 	 */
 	dput(cgrp->parent->dentry);
 
+	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	
 	/*
 	 * Drop the active superblock reference that we took when we
-	 * created the cgroup
+	 * created the cgroup. This will free cgrp->root, if we are
+	 * holding the last reference to @sb.
 	 */
 	deactivate_super(cgrp->root->sb);
 
@@ -859,7 +862,6 @@ static void cgroup_free_fn(struct work_struct *work)
 
 	simple_xattrs_free(&cgrp->xattrs);
 
-	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
 	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
-- 
1.8.0.2
