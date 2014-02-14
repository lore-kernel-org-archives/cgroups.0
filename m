From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] kernfs: fix kernfs_node_from_dentry()
Date: Fri, 14 Feb 2014 16:57:27 +0800
Message-ID: <52FDDA77.6070606@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Currently kernfs_node_from_dentry() returns NULL for root dentry,
because root_dentry->d_op == NULL.

Due to this bug cgroupstats_build() returns -EINVAL for root cgroup.

  # mount -t cgroup -o cpuacct /cgroup
  # Documentation/accounting/getdelays -C /cgroup
  fatal reply error,  errno -22

With this fix:

  # Documentation/accounting/getdelays -C /cgroup
  sleeping 305, blocked 0, running 1, stopped 0, uninterruptible 1

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/dir.c             | 2 +-
 fs/kernfs/kernfs-internal.h | 1 +
 fs/kernfs/mount.c           | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 939684e..300f57b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -501,7 +501,7 @@ const struct dentry_operations kernfs_dops = {
  */
 struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry)
 {
-	if (dentry->d_op == &kernfs_dops)
+	if (dentry->d_sb->s_op == &kernfs_sops)
 		return dentry->d_fsdata;
 	return NULL;
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index a91d7a1..8be13b2 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -65,6 +65,7 @@ struct kernfs_super_info {
 };
 #define kernfs_info(SB) ((struct kernfs_super_info *)(SB->s_fs_info))
 
+extern const struct super_operations kernfs_sops;
 extern struct kmem_cache *kernfs_node_cache;
 
 /*
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index e5b28b0..405279b 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -39,7 +39,7 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
 	return 0;
 }
 
-static const struct super_operations kernfs_sops = {
+const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= kernfs_evict_inode,
-- 
1.8.0.2
