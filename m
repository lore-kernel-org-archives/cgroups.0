From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/6] cgroup: remove duplicate RCU free on struct cgroup
Date: Thu, 24 Jan 2013 14:31:27 +0800
Message-ID: <5100D53F.1080206@huawei.com>
References: <5100D4FE.9080205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5100D4FE.9080205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

When destroying a cgroup, though in cgroup_diput() we've called
synchronize_rcu(), we then still have to free it via call_rcu().

The story is, long ago to fix a race between reading /proc/sched_debug
and freeing cgroup, the code was changed to utilize call_rcu(). See
commit a47295e6bc42ad35f9c15ac66f598aa24debd4e2 ("cgroups: make
cgroup_path() RCU-safe")

As we've fixed cpu cgroup that cpu_cgroup_offline_css() is used
to unregister a task_group so there won't be concurrent access
to this task_group after synchronize_rcu() in diput(). Now we can
just kfree(cgrp).

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b9a76e2..a39e2b0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -892,7 +892,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		simple_xattrs_free(&cgrp->xattrs);
 
 		ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
-		kfree_rcu(cgrp, rcu_head);
+		kfree(cgrp);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
-- 
1.8.0.2
