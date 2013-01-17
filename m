From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Date: Thu, 17 Jan 2013 16:03:12 +0800
Message-ID: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

With this change, it's guaranteed that cgroup_path() won't see NULL
cgrp->dentry, and thus we can remove the NULL check in it.

(Well, it's not true, because dummptop.dentry is always NULL)

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a893985..23a0ce1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1764,7 +1764,7 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
 			   "cgroup_path() called without proper locking");
 
-	if (!dentry || cgrp == dummytop) {
+	if (cgrp == dummytop) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -4150,6 +4150,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	init_cgroup_housekeeping(cgrp);
 
+	dentry->d_fsdata = cgrp;
+	cgrp->dentry = dentry;
+
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
@@ -4187,8 +4190,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	/* allocation complete, commit to creation */
-	dentry->d_fsdata = cgrp;
-	cgrp->dentry = dentry;
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
-- 
1.8.0.2
