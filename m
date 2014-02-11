From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: protect modifications to cgroup_idr with cgroup_mutex
Date: Tue, 11 Feb 2014 16:05:46 +0800
Message-ID: <52F9D9DA.7040108@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Setup cgroupfs like this:
  # mount -t cgroup -o cpuacct xxx /cgroup
  # mkdir /cgroup/sub1
  # mkdir /cgroup/sub2

Then run these two commands:
  # for ((; ;)) { mkdir /cgroup/sub1/tmp && rmdir /mnt/sub1/tmp; } &
  # for ((; ;)) { mkdir /cgroup/sub2/tmp && rmdir /mnt/sub2/tmp; } &

After seconds you may see this warning:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 25243 at lib/idr.c:527 sub_remove+0x87/0x1b0()
idr_remove called for id=6 which is not allocated.
...
Call Trace:
 [<ffffffff8156063c>] dump_stack+0x7a/0x96
 [<ffffffff810591ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81059296>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81300aa7>] sub_remove+0x87/0x1b0
 [<ffffffff810f3f02>] ? css_killed_work_fn+0x32/0x1b0
 [<ffffffff81300bf5>] idr_remove+0x25/0xd0
 [<ffffffff810f2bab>] cgroup_destroy_css_killed+0x5b/0xc0
 [<ffffffff810f4000>] css_killed_work_fn+0x130/0x1b0
 [<ffffffff8107cdbc>] process_one_work+0x26c/0x550
 [<ffffffff8107eefe>] worker_thread+0x12e/0x3b0
 [<ffffffff81085f96>] kthread+0xe6/0xf0
 [<ffffffff81570bac>] ret_from_fork+0x7c/0xb0
---[ end trace 2d1577ec10cf80d0 ]---

It's because allocating/removing cgroup ID is not properly synchronized.

The bug was introduced when we converted cgroup_ida to cgroup_idr.
While synchronization is already done inside ida_simple_{get,remove}(),
users are responsible for concurrent calls to idr_{alloc,remove}().

Fixes: 4e96ee8e981b ("cgroup: convert cgroup_ida to cgroup_idr")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #3.12+
Reported-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 30 ++++++++++++++++--------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5c09759..9450f02 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -166,6 +166,8 @@ struct cgroup {
 	 *
 	 * The ID of the root cgroup is always 0, and a new cgroup
 	 * will be assigned with a smallest available ID.
+	 *
+	 * Allocating/Removing ID must be protected by cgroup_mutex.
 	 */
 	int id;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2f46ba..4bbaadd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -886,7 +886,9 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * per-subsystem and moved to css->id so that lookups are
 		 * successful until the target css is released.
 		 */
+		mutex_lock(&cgroup_mutex);
 		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
+		mutex_unlock(&cgroup_mutex);
 		cgrp->id = -1;
 
 		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
@@ -4173,14 +4175,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	rcu_assign_pointer(cgrp->name, name);
 
 	/*
-	 * Temporarily set the pointer to NULL, so idr_find() won't return
-	 * a half-baked cgroup.
-	 */
-	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
-	if (cgrp->id < 0)
-		goto err_free_name;
-
-	/*
 	 * Only live parents can have children.  Note that the liveliness
 	 * check isn't strictly necessary because cgroup_mkdir() and
 	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
@@ -4189,9 +4183,17 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 */
 	if (!cgroup_lock_live_group(parent)) {
 		err = -ENODEV;
-		goto err_free_id;
+		goto err_free_name;
 	}
 
+	/*
+	 * Temporarily set the pointer to NULL, so idr_find() won't return
+	 * a half-baked cgroup.
+	 */
+	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
+	if (cgrp->id < 0)
+		goto err_unlock;
+
 	/* Grab a reference on the superblock so the hierarchy doesn't
 	 * get deleted on unmount if there are child cgroups.  This
 	 * can be done outside cgroup_mutex, since the sb can't
@@ -4221,7 +4223,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 */
 	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
-		goto err_unlock;
+		goto err_free_id;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	cgrp->serial_nr = cgroup_serial_nr_next++;
@@ -4257,12 +4259,12 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	return 0;
 
-err_unlock:
-	mutex_unlock(&cgroup_mutex);
-	/* Release the reference count that we took on the superblock */
-	deactivate_super(sb);
 err_free_id:
 	idr_remove(&root->cgroup_idr, cgrp->id);
+	/* Release the reference count that we took on the superblock */
+	deactivate_super(sb);
+err_unlock:
+	mutex_unlock(&cgroup_mutex);
 err_free_name:
 	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
-- 
1.8.0.2
