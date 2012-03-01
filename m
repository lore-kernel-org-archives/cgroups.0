From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 3/3] cgroup: add xattr support
Date: Thu, 01 Mar 2012 14:17:31 +0800
Message-ID: <4F4F147B.7090803@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F4F1459.4080300@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lennart Poettering <mzxreary@0pointer.de>, Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Eric Paris <eparis@redhat.com>

This is one of the items in the plumber's wish list.

For use cases:

>> What would the use case be for this?
>
> Attaching meta information to services, in an easily discoverable
> way. For example, in systemd we create one cgroup for each service, and
> could then store data like the main pid of the specific service as an
> xattr on the cgroup itself. That way we'd have almost all service state
> in the cgroupfs, which would make it possible to terminate systemd and
> later restart it without losing any state information. But there's more:
> for example, some very peculiar services cannot be terminated on
> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> services in question could just mark that on their cgroup, by setting an
> xattr. On the more desktopy side of things there are other
> possibilities: for example there are plans defining what an application
> is along the lines of a cgroup (i.e. an app being a collection of
> processes). With xattrs one could then attach an icon or human readable
> program name on the cgroup.
>
> The key idea is that this would allow attaching runtime meta information
> to cgroups and everything they model (services, apps, vms), that doesn't
> need any complex userspace infrastructure, has good access control
> (i.e. because the file system enforces that anyway, and there's the
> "trusted." xattr namespace), notifications (inotify), and can easily be
> shared among applications.
>
> Lennart

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    7 ++++
 init/Kconfig           |   12 ++++++
 kernel/cgroup.c        |   92 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9b93c9a..141c3ad 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -16,6 +16,7 @@
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
+#include <linux/xattr.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -211,6 +212,9 @@ struct cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	/* directory xattrs */
+	struct kmem_xattrs xattrs;
 };
 
 /*
@@ -298,6 +302,9 @@ struct cftype {
 	/* The subsystem this cgroup file belongs to */
 	struct cgroup_subsys *subsys;
 
+	/* file xattrs */
+	struct kmem_xattrs xattrs;
+
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..ba9a9dc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -601,6 +601,18 @@ menuconfig CGROUPS
 
 if CGROUPS
 
+config CGROUP_XATTR
+	bool "Cgroup extended attributes"
+	default n
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  Currently the system.* namespace is not supported.
+
+	  If unsure, say N.
+
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
 	default n
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5ec9048..57f3b79 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -865,7 +865,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 */
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
+		kmem_xattrs_free(&cgrp->xattrs);
+
 		kfree_rcu(cgrp, rcu_head);
+	} else {
+		struct cftype *cft = dentry->d_fsdata;
+		kmem_xattrs_free(&cft->xattrs);
 	}
 	iput(inode);
 }
@@ -1355,6 +1360,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
+	kmem_xattrs_init(&cgrp->xattrs);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -1700,6 +1706,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
+	kmem_xattrs_free(&cgrp->xattrs);
+
 	kill_litter_super(sb);
 	cgroup_drop_root(root);
 }
@@ -2504,19 +2512,83 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
+#ifdef CONFIG_CGROUP_XATTR
+
+static struct kmem_xattrs *__d_xattrs(struct dentry *dentry)
+{
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		return &__d_cgrp(dentry)->xattrs;
+	else
+		return &__d_cft(dentry)->xattrs;
+}
+
+static bool is_valid_xattr(const char *name)
+{
+	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) ||
+	    !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
+	    !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN))
+		return true;
+	return false;
+}
+
+static int cgroup_setxattr(struct dentry *dentry, const char *name,
+			   const void *val, size_t size, int flags)
+{
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return kmem_xattr_set(__d_xattrs(dentry), name, val, size, flags);
+}
+
+static int cgroup_removexattr(struct dentry *dentry, const char *name)
+{
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return kmem_xattr_remove(__d_xattrs(dentry), name);
+}
+
+static ssize_t cgroup_getxattr(struct dentry *dentry, const char *name,
+			       void *buf, size_t size)
+{
+	if (!is_valid_xattr(name))
+		return -EINVAL;
+	return kmem_xattr_get(__d_xattrs(dentry), name, buf, size);
+}
+
+static ssize_t cgroup_listxattr(struct dentry *dentry, char *buf, size_t size)
+{
+	return kmem_xattr_list(__d_xattrs(dentry), buf, size);
+}
+
+#endif /* CONFIG_CGROUP_XATTR */
+
 static const struct file_operations cgroup_file_operations = {
-	.read = cgroup_file_read,
-	.write = cgroup_file_write,
-	.llseek = generic_file_llseek,
-	.open = cgroup_file_open,
-	.release = cgroup_file_release,
+	.read		= cgroup_file_read,
+	.write		= cgroup_file_write,
+	.llseek		= generic_file_llseek,
+	.open		= cgroup_file_open,
+	.release	= cgroup_file_release,
+};
+
+static const struct inode_operations cgroup_file_inode_operations = {
+#ifdef CONFIG_CGROUP_XATTR
+	.setxattr	= cgroup_setxattr,
+	.getxattr	= cgroup_getxattr,
+	.listxattr	= cgroup_listxattr,
+	.removexattr	= cgroup_removexattr,
+#endif
 };
 
 static const struct inode_operations cgroup_dir_inode_operations = {
-	.lookup = cgroup_lookup,
-	.mkdir = cgroup_mkdir,
-	.rmdir = cgroup_rmdir,
-	.rename = cgroup_rename,
+	.lookup		= cgroup_lookup,
+	.mkdir		= cgroup_mkdir,
+	.rmdir		= cgroup_rmdir,
+	.rename		= cgroup_rename,
+#ifdef CONFIG_CGROUP_XATTR
+	.setxattr	= cgroup_setxattr,
+	.getxattr	= cgroup_getxattr,
+	.listxattr	= cgroup_listxattr,
+	.removexattr	= cgroup_removexattr,
+#endif
 };
 
 static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
@@ -2564,6 +2636,7 @@ static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
+		inode->i_op = &cgroup_file_inode_operations;
 	}
 	d_instantiate(dentry, inode);
 	dget(dentry);	/* Extra count - pin the dentry in core */
@@ -2633,6 +2706,7 @@ int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
 	cft->subsys = subsys;
+	kmem_xattrs_init(&cft->xattrs);
 
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
-- 
1.7.3.1
