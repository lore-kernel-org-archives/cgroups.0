From: Glauber Costa <glommer@parallels.com>
Subject: [RFC 2/4] per-namespace allowed filesystems list
Date: Mon, 23 Jan 2012 20:56:10 +0400
Message-ID: <1327337772-1972-3-git-send-email-glommer@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, serge@hallyn.com, daniel.lezcano@free.fr, pjt@google.com, mzxreary@0pointer.de, xemul@parallels.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, eric.dumazet@gmail.com, Glauber Costa <glommer@parallels.com>

This patch creates a list of allowed filesystems per-namespace.
The goal is to prevent users inside a container, even root,
to mount filesystems that are not allowed by the main box admin.

My main two motivators to pursue this are:
 1) We want to prevent a certain tailored view of some virtual
    filesystems, for example, by bind-mounting files with userspace
    generated data into /proc. The ability of mounting /proc inside
    the container works against this effort, while disallowing it
    via capabilities would have the effect of disallowing other
    mounts as well.

2) Some filesystems are known not to behave well under a container
   environment. They require changes to work in a safe-way. We can
   whitelist only the filesystems we want.

This works as a whitelist. Only filesystems in the list are allowed
to be mounted. Doing a blacklist would create problems when, say,
a module is loaded. The whitelist is only checked if it is enabled first.
So any setup that was already working, will keep working. And whoever
is not interested in limiting filesystem mount, does not need
to bother about it.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 fs/filesystems.c              |   83 +++++++++++++++++++++++++++++++++++++++++
 fs/namespace.c                |    5 ++-
 include/linux/fs.h            |    9 ++++
 include/linux/mnt_namespace.h |   20 ++++++++++
 4 files changed, 116 insertions(+), 1 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 458d120..118d0d6 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/mnt_namespace.h>
 #include <asm/uaccess.h>
 
 /*
@@ -218,6 +219,26 @@ int __init get_filesystem_list(char *buf)
 	return len;
 }
 
+static bool fs_allowed(struct file_system_type *fs, struct mnt_namespace *mnt)
+{
+	struct fs_allowed *p;
+	bool ret = true;
+
+	if (!fslist_is_enabled(mnt))
+		goto out;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(p, &mnt->fs_allowed, list)
+		if (p->fstype == fs)
+			goto out_rcu;
+
+	ret = false;
+out_rcu:
+	rcu_read_unlock();
+out:
+	return ret;
+}
+
 #ifdef CONFIG_PROC_FS
 int filesystems_proc_show(struct seq_file *m, void *v)
 {
@@ -265,4 +286,66 @@ struct file_system_type *get_fs_type(const char *name)
 	return fs;
 }
 
+void destroy_filesystems_list(struct mnt_namespace *mnt)
+{
+	struct fs_allowed *fs;
+
+	WARN_ON(!mnt);
+
+	if (!fslist_is_enabled(mnt))
+		return;
+	mutex_lock(&mnt->fs_list_mutex);
+	synchronize_rcu();
+
+	list_for_each_entry(fs, &mnt->fs_allowed, list) {
+		list_del(&fs->list);
+		kfree(fs);
+	}
+	mutex_unlock(&mnt->fs_list_mutex);
+}
+
+void enable_filesystems_list(struct mnt_namespace *mnt)
+{
+	mnt->fs_list_enabled = true;
+}
+
+int add_filesystem_list(const char *name, struct mnt_namespace *mnt)
+{
+	struct file_system_type **fstype;
+	struct fs_allowed *fs;
+
+	if (!fslist_is_enabled(mnt))
+		return -EINVAL;
+
+	fstype = find_filesystem(name, strlen(name));
+	if (!fstype)
+		return -EINVAL;
+
+	if (fs_allowed(*fstype, mnt))
+		return 0;
+
+	fs = kmalloc(sizeof(*fs), GFP_KERNEL);
+	if (!fs)
+		return -ENOMEM;
+
+	fs->fstype = *fstype;
+
+	mutex_lock(&mnt->fs_list_mutex);
+	list_add_rcu(&fs->list, &mnt->fs_allowed);
+	mutex_unlock(&mnt->fs_list_mutex);
+
+	return 0;
+}
+
+struct file_system_type *get_fs_type_ns(const char *name,
+					struct mnt_namespace *mnt)
+{
+	struct file_system_type *fs = get_fs_type(name);
+
+	if (fs && mnt && !fs_allowed(fs, mnt)) {
+		put_filesystem(fs);
+		fs = NULL;
+	}
+	return fs;
+}
 EXPORT_SYMBOL(get_fs_type);
diff --git a/fs/namespace.c b/fs/namespace.c
index cfc6d44..e897985 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1958,7 +1958,8 @@ static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
 struct vfsmount *
 do_kern_mount(const char *fstype, int flags, const char *name, void *data)
 {
-	struct file_system_type *type = get_fs_type(fstype);
+	struct file_system_type *type = get_fs_type_ns(fstype,
+					current->nsproxy->mnt_ns);
 	struct vfsmount *mnt;
 	if (!type)
 		return ERR_PTR(-ENODEV);
@@ -2365,6 +2366,7 @@ static struct mnt_namespace *alloc_mnt_ns(void)
 	INIT_LIST_HEAD(&new_ns->list);
 	init_waitqueue_head(&new_ns->poll);
 	new_ns->event = 0;
+	init_fslist(new_ns);
 	return new_ns;
 }
 
@@ -2745,6 +2747,7 @@ void put_mnt_ns(struct mnt_namespace *ns)
 	br_write_unlock(vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
+	destroy_filesystems_list(ns);
 	kfree(ns);
 }
 EXPORT_SYMBOL(put_mnt_ns);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3286d74..ab3633a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2531,6 +2531,15 @@ extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern int filesystems_proc_show(struct seq_file *m, void *v);
 
+
+struct mnt_namespace;
+extern struct file_system_type *get_fs_type_ns(const char *name,
+					       struct mnt_namespace *mnt);
+extern void enable_filesystems_list(struct mnt_namespace *ns);
+extern void destroy_filesystems_list(struct mnt_namespace *ns);
+extern int add_filesystem_list(const char *name, struct mnt_namespace *ns);
+extern int del_filesystem_list(char *name, struct mnt_namespace *ns);
+
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern struct super_block *user_get_super(dev_t);
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 2930485..4138fb4 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -6,12 +6,20 @@
 #include <linux/seq_file.h>
 #include <linux/wait.h>
 
+struct fs_allowed {
+	struct list_head	list;
+	struct file_system_type *fstype;
+};
+
 struct mnt_namespace {
 	atomic_t		count;
 	struct vfsmount *	root;
 	struct list_head	list;
 	wait_queue_head_t poll;
 	int event;
+	struct list_head	fs_allowed;
+	struct mutex		fs_list_mutex;
+	bool			fs_list_enabled;
 };
 
 struct proc_mounts {
@@ -22,6 +30,18 @@ struct proc_mounts {
 
 struct fs_struct;
 
+static inline bool fslist_is_enabled(struct mnt_namespace *mnt)
+{
+	return mnt->fs_list_enabled;
+}
+
+static inline void init_fslist(struct mnt_namespace *ns)
+{
+	ns->fs_list_enabled = false;
+	INIT_LIST_HEAD(&ns->fs_allowed);
+	mutex_init(&ns->fs_list_mutex);
+}
+
 extern struct mnt_namespace *create_mnt_ns(struct vfsmount *mnt);
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
-- 
1.7.7.4

