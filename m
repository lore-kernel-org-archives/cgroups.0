From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3] sysfs: fix namespace refcnt leak
Date: Tue, 25 Feb 2014 19:28:44 +0800
Message-ID: <530C7E6C.2020500@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

As mount() and kill_sb() is not a one-to-one match, we shoudn't get
ns refcnt unconditionally in sysfs_mount(), and instead we should
get the refcnt only when kernfs_mount() allocated a new superblock.

v2:
- Changed the name of the new argument, suggested by Tejun.
- Made the argument optional, suggested by Tejun.

v3:
- Make the new argument as second-to-last arg, suggested by Tejun.

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/mount.c      | 8 +++++++-
 fs/sysfs/mount.c       | 5 +++--
 include/linux/kernfs.h | 9 +++++----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 405279b..6a5f04a 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -131,6 +131,7 @@ const void *kernfs_super_ns(struct super_block *sb)
  * @fs_type: file_system_type of the fs being mounted
  * @flags: mount flags specified for the mount
  * @root: kernfs_root of the hierarchy being mounted
+ * @new_sb_created: tell the caller if we allocated a new superblock
  * @ns: optional namespace tag of the mount
  *
  * This is to be called from each kernfs user's file_system_type->mount()
@@ -141,7 +142,8 @@ const void *kernfs_super_ns(struct super_block *sb)
  * The return value can be passed to the vfs layer verbatim.
  */
 struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, const void *ns)
+			       struct kernfs_root *root, bool *new_sb_created,
+			       const void *ns)
 {
 	struct super_block *sb;
 	struct kernfs_super_info *info;
@@ -159,6 +161,10 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 		kfree(info);
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
+
+	if (new_sb_created)
+		*new_sb_created = !sb->s_root;
+
 	if (!sb->s_root) {
 		error = kernfs_fill_super(sb);
 		if (error) {
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 5c7fdd9..a66ad61 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -27,6 +27,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 {
 	struct dentry *root;
 	void *ns;
+	bool new_sb;
 
 	if (!(flags & MS_KERNMOUNT)) {
 		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
@@ -37,8 +38,8 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	}
 
 	ns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
-	root = kernfs_mount_ns(fs_type, flags, sysfs_root, ns);
-	if (IS_ERR(root))
+	root = kernfs_mount_ns(fs_type, flags, sysfs_root, &new_sb, ns);
+	if (IS_ERR(root) || !new_sb)
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
 	return root;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 649497a..09669d0 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -279,7 +279,8 @@ void kernfs_notify(struct kernfs_node *kn);
 
 const void *kernfs_super_ns(struct super_block *sb);
 struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-			       struct kernfs_root *root, const void *ns);
+			       struct kernfs_root *root, bool *new_sb_created,
+			       const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
 
 void kernfs_init(void);
@@ -372,7 +373,7 @@ static inline const void *kernfs_super_ns(struct super_block *sb)
 
 static inline struct dentry *
 kernfs_mount_ns(struct file_system_type *fs_type, int flags,
-		struct kernfs_root *root, const void *ns)
+		struct kernfs_root *root, bool *new_sb_created, const void *ns)
 { return ERR_PTR(-ENOSYS); }
 
 static inline void kernfs_kill_sb(struct super_block *sb) { }
@@ -430,9 +431,9 @@ static inline int kernfs_rename(struct kernfs_node *kn,
 
 static inline struct dentry *
 kernfs_mount(struct file_system_type *fs_type, int flags,
-	     struct kernfs_root *root)
+	     struct kernfs_root *root, bool *new_sb_created)
 {
-	return kernfs_mount_ns(fs_type, flags, root, NULL);
+	return kernfs_mount_ns(fs_type, flags, root, new_sb_created, NULL);
 }
 
 #endif	/* __LINUX_KERNFS_H */
-- 
1.8.0.2
