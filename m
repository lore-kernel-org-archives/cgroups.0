From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/12] cgroup: make sure parent won't be destroyed before
 its children
Date: Mon, 8 Apr 2013 14:35:02 +0800
Message-ID: <51626516.3000603@huawei.com>
References: <5162648B.9070802@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5162648B.9070802-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Suppose we rmdir a cgroup and there're still css refs, this cgroup won't
be freed. Then we rmdir the parent cgroup, and the parent is freed
immediately due to css ref draining to 0. Now it would be a disaster if
the still-alive child cgroup tries to access its parent.

Make sure this won't happen.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 06aeb42..7ee3bdf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -888,6 +888,13 @@ static void cgroup_free_fn(struct work_struct *work)
 	mutex_unlock(&cgroup_mutex);
 
 	/*
+	 * We get a ref to the parent's dentry, and put the ref when
+	 * this cgroup is being freed, so it's guaranteed that the
+	 * parent won't be destroyed before its children.
+	 */
+	dput(cgrp->parent->dentry);
+
+	/*
 	 * Drop the active superblock reference that we took when we
 	 * created the cgroup
 	 */
@@ -4170,6 +4177,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	for_each_subsys(root, ss)
 		dget(dentry);
 
+	/* hold a ref to the parent's dentry */
+	dget(parent->dentry);
+
 	/* creation succeeded, notify subsystems */
 	for_each_subsys(root, ss) {
 		err = online_css(ss, cgrp);
-- 
1.8.0.2
