From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
Date: Thu, 12 Jun 2014 14:33:05 +0800
Message-ID: <539949A1.90301@huawei.com>
References: <53994943.60703@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53994943.60703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We've converted cgroup to kernfs so cgroup won't be intertwined with
vfs objects and locking, but there are dark areas.

Run two instances of this script concurrently:

    for ((; ;))
    {
    	mount -t cgroup -o cpuacct xxx /cgroup
    	umount /cgroup
    }

After a while, I saw two mount processes were stuck at retrying, because
they were waiting for a subsystem to become free, but the root associated
with this subsystem never got freed.

This can happen, if thread A is in the process of killing superblock but
hasn't called percpu_ref_kill(), and at this time thread B is mounting
the same cgroup root and finds the root in the root list and performs
percpu_ref_try_get().

To fix this, we increase the refcnt of the superblock instead of increasing
the percpu refcnt of cgroup root.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

A better fix is welcome!

---
 kernel/cgroup.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bd37e8d..94e1814 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1654,7 +1654,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct dentry *dentry;
 	int ret;
 	int i;
-	bool new_sb;
+	bool sb_pinned = false;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1735,19 +1735,21 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * A root's lifetime is governed by its root cgroup.
-		 * tryget_live failure indicate that the root is being
-		 * destroyed.  Wait for destruction to complete so that the
-		 * subsystems are free.  We can use wait_queue for the wait
-		 * but this path is super cold.  Let's just sleep for a bit
-		 * and retry.
+		 * This may fail for two reasons:
+		 * - A concurrent mount is in process. We wait for that mount
+		     to complete.
+		 * - The superblock is being destroyed. We wait for the
+		 *   desctruction to complete so that the subsystems are free.
+		 * We can use wait_queue for the wait but this path is super
+		 * cold.  Let's just sleep for a bit and retry.
 		 */
-		if (!percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
+		if (!kernfs_pin_sb(root->kf_root, NULL)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
 			ret = restart_syscall();
 			goto out_free;
 		}
+		sb_pinned = true;
 
 		ret = 0;
 		goto out_unlock;
@@ -1784,8 +1786,10 @@ out_free:
 	if (ret)
 		return ERR_PTR(ret);
 
-	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
-	if (IS_ERR(dentry) || !new_sb)
+	dentry = kernfs_mount(fs_type, flags, root->kf_root, NULL);
+	if (sb_pinned)
+		kernfs_drop_sb(root->kf_root, NULL);
+	if (!sb_pinned && IS_ERR(dentry))
 		cgroup_put(&root->cgrp);
 	return dentry;
 }
-- 
1.8.0.2
