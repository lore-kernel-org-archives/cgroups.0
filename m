From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/5] kernfs: introduce kernfs_pin_sb() and kernfs_drop_sb()
Date: Thu, 12 Jun 2014 14:32:28 +0800
Message-ID: <5399497C.8080402@huawei.com>
References: <53994943.60703@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53994943.60703@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>


kernfs_pin_sb() tries to get a refcnt of the superblock, while
kernfs_drop_sb() drops this refcnt.

This will be used by cgroupfs.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/mount.c      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h |  3 +++
 2 files changed, 48 insertions(+)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index f25a7c0..4f924e0 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -210,6 +210,51 @@ void kernfs_kill_sb(struct super_block *sb)
 	kernfs_put(root_kn);
 }
 
+/**
+ * kernfs_pin_sb: try to pin the superblock associated with a kernfs_root
+ * @kernfs_root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * Pin the superblock so the superblock won't be destroyed in subsequent
+ * operations.
+ */
+bool kernfs_pin_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+	int ret = false;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns) {
+			ret = atomic_inc_not_zero(&info->sb->s_active);
+			break;
+		}
+	}
+	mutex_unlock(&kernfs_mutex);
+	return ret;
+}
+
+/**
+ * kernfs_drop_sb: drop the refcnt that we got by kernfs_pin_sb()
+ * @root: the kernfs_root in question
+ * @ns: the namespace tag
+ *
+ * This must be paired with kernfs_pin_sb(). It will require sb->u_mount
+ * if the refcnt reaches zero.
+ */
+void kernfs_drop_sb(struct kernfs_root *root, const void *ns)
+{
+	struct kernfs_super_info *info;
+
+	mutex_lock(&kernfs_mutex);
+	list_for_each_entry(info, &root->supers, node) {
+		if (info->ns == ns)
+			break;
+	}
+	mutex_unlock(&kernfs_mutex);
+	deactivate_super(info->sb);
+}
+
 void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 589318b..1958017 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -288,6 +288,9 @@ struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
 			       const void *ns);
 void kernfs_kill_sb(struct super_block *sb);
 
+bool kernfs_pin_sb(struct kernfs_root *root, const void *ns);
+void kernfs_drop_sb(struct kernfs_root *root, const void *ns);
+
 void kernfs_init(void);
 
 #else	/* CONFIG_KERNFS */
-- 
1.8.0.2
