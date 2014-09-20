From: Zefan Li <lizefan@huawei.com>
Subject: [PATCH] cgroup: remove redundant variable in cgroup_mount()
Date: Sat, 20 Sep 2014 14:49:10 +0800
Message-ID: <541D2366.2020107@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Both pinned_sb and new_sb indicate if a new superblock is needed,
so we can just remove new_sb.

Note now we must check if kernfs_tryget_sb() returns NULL, because
when it returns NULL, kernfs_mount() may still re-use an existing
superblock, which is just allocated by another concurent mount.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---

Hi Tejun,

I think you wanted to see the @new_sb argument removed from kernfs_mount(),
but it's also used in debugfs and we can't use kernfs_tryget_sb() to
replace the new_sb check.

---
 kernel/cgroup.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 33f15b3..15a2387 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1694,7 +1694,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct dentry *dentry;
 	int ret;
 	int i;
-	bool new_sb;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1785,7 +1784,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
 		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
-		if (IS_ERR(pinned_sb) ||
+		if (IS_ERR_OR_NULL(pinned_sb) ||
 		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
@@ -1831,18 +1830,16 @@ out_free:
 		return ERR_PTR(ret);
 
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
-				CGROUP_SUPER_MAGIC, &new_sb);
-	if (IS_ERR(dentry) || !new_sb)
+				CGROUP_SUPER_MAGIC, NULL);
+	if (IS_ERR(dentry) || pinned_sb)
 		cgroup_put(&root->cgrp);
 
 	/*
 	 * If @pinned_sb, we're reusing an existing root and holding an
 	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
 	 */
-	if (pinned_sb) {
-		WARN_ON(new_sb);
+	if (pinned_sb)
 		deactivate_super(pinned_sb);
-	}
 
 	return dentry;
 }
-- 
1.8.0.2
