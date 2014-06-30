From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/3] kernfs: introduce kernfs_pin_sb()
Date: Mon, 30 Jun 2014 11:50:28 +0800
Message-ID: <53B0DE84.40206@huawei.com>
References: <53B0DE66.5080100@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B0DE66.5080100-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

kernfs_pin_sb() tries to get a refcnt of the superblock.

This will be used by cgroupfs.

v2:
- make kernfs_pin_sb() return the superblock.
- drop kernfs_drop_sb().

[ This is a prerequisite for a bugfix. ]
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15
Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/mount.c      | 27 +++++++++++++++++++++++++++
 include/linux/kernfs.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f25a7c0..616c5c4 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -210,6 +210,33 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations. Return NULL if there's no superblock associated to this
+ * kernfs_root, or -EINVAL if the superblock is being freed.
+ */
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+	struct super_block *sb = NULL;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns) {
+			sb = info->sb;
+			if (!atomic_inc_not_zero(&info->sb->s_active))
+				sb = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	mutex_unlock(&kernfs_mutex);
+	return sb;
+}
+
 void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 589318b..9096296 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -287,6 +287,7 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       struct kernfs_root *root, bool *new_sb_created,
 			       const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
+struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
 
 void kernfs_init(void);
 
-- 
1.8.0.2
