From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: add xattr support
Date: Mon, 16 Jan 2012 16:07:05 +0800
Message-ID: <4F13DAA9.4070703@cn.fujitsu.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F13DA90.2000603-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

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

Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h |   15 +++
 init/Kconfig           |   12 ++
 kernel/cgroup.c        |  272 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 289 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 13db9e8..a5ac3be 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -16,6 +16,8 @@
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
+#include <linux/rbtree.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -42,6 +44,13 @@ extern void cgroup_unload_subsys(struct cgroup_subsys *ss);
 
 extern const struct file_operations proc_cgroup_operations;
 
+struct cgroup_xattr_root {
+#ifdef CONFIG_CGROUP_XATTR
+	struct rb_root root;
+	spinlock_t lock;
+#endif
+};
+
 /* Define the enumeration of all builtin cgroup subsystems */
 #define SUBSYS(_x) _x ## _subsys_id,
 enum cgroup_subsys_id {
@@ -243,6 +252,9 @@ struct cgroup {
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
+
+	/* directory xattrs */
+	struct cgroup_xattr_root xattr_root;
 };
 
 /*
@@ -330,6 +342,9 @@ struct cftype {
 	/* The subsystem this cgroup file belongs to */
 	struct cgroup_subsys *subsys;
 
+	/* file xattrs */
+	struct cgroup_xattr_root xattr_root;
+
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
diff --git a/init/Kconfig b/init/Kconfig
index 6ac2236..28990ec 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -587,6 +587,18 @@ menuconfig CGROUPS
 
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
index c4ed6fe..ab4cca5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,7 +60,8 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
-
+#include <linux/xattr.h>
+#include <linux/rbtree.h>
 #include <linux/atomic.h>
 
 /*
@@ -786,6 +787,9 @@ static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits,
 static const struct inode_operations cgroup_dir_inode_operations;
 static const struct file_operations proc_cgroupstats_operations;
 
+static void cgroup_xattrs_init(struct cgroup_xattr_root *root);
+static void cgroup_xattrs_destroy(struct cgroup_xattr_root *root);
+
 static struct backing_dev_info cgroup_backing_dev_info = {
 	.name		= "cgroup",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
@@ -865,7 +869,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 */
 		BUG_ON(!list_empty(&cgrp->pidlists));
 
+		cgroup_xattrs_destroy(&cgrp->xattr_root);
+
 		kfree_rcu(cgrp, rcu_head);
+	} else {
+		struct cftype *cft = dentry->d_fsdata;
+		cgroup_xattrs_destroy(&cft->xattr_root);
 	}
 	iput(inode);
 }
@@ -1355,6 +1364,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
+	cgroup_xattrs_init(&cgrp->xattr_root);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -1700,6 +1710,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
+	cgroup_xattrs_destroy(&cgrp->xattr_root);
+
 	kill_litter_super(sb);
 	cgroup_drop_root(root);
 }
@@ -2608,18 +2620,256 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 }
 
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
+#ifdef CONFIG_CGROUP_XATTR
+
+struct cgroup_xattr_entry {
+	struct rb_node node;
+	char *name;
+	char *val;
+	int len;
+};
+
+static void free_xattr_entry(struct cgroup_xattr_entry *entry)
+{
+	kfree(entry->name);
+	kfree(entry->val);
+	kfree(entry);
+}
+
+static struct cgroup_xattr_root *xattr_root(struct dentry *dentry)
+{
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		return &__d_cgrp(dentry)->xattr_root;
+	else
+		return &__d_cft(dentry)->xattr_root;
+}
+
+static void cgroup_xattrs_init(struct cgroup_xattr_root *root)
+{
+	spin_lock_init(&root->lock);
+	root->root = RB_ROOT;
+}
+
+static void cgroup_xattrs_destroy(struct cgroup_xattr_root *xattr_root)
+{
+	struct rb_root *root = &xattr_root->root;
+	struct rb_node *node;
+	struct cgroup_xattr_entry *entry;
+
+	while (true) {
+		node = rb_first(root);
+		if (!node)
+			break;
+		entry = rb_entry(node, struct cgroup_xattr_entry, node);
+
+		rb_erase(node, root);
+		free_xattr_entry(entry);
+	}
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
+static int __cgroup_setxattr(struct dentry *dentry, const char *name,
+			     const void *value, size_t size, int flags)
+{
+	struct cgroup_xattr_root *root = xattr_root(dentry);
+	struct cgroup_xattr_entry *entry = NULL;
+	struct cgroup_xattr_entry *new = NULL;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	int cmp;
+	int ret = 0;
+	char tmp[200];
+
+	if (!is_valid_xattr(name))
+		return -EOPNOTSUPP;
+
+	if (value) {
+		new = kzalloc(sizeof(*new), GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		new->name = kstrdup(name, GFP_KERNEL);
+		new->val = kmemdup(value, size, GFP_KERNEL);
+		new->len = size;
+		if (!new->name || !new->val) {
+			free_xattr_entry(new);
+			return -ENOMEM;
+		}
+	}
+
+	memcpy(tmp, value, size);
+	tmp[size] = '\0';
+
+	spin_lock(&root->lock);
+
+	p = &root->root.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct cgroup_xattr_entry, node);
+
+		cmp = strcmp(name, entry->name);
+		if (cmp > 0)
+			p = &(*p)->rb_right;
+		else if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			break;
+	}
+
+	if (*p) {
+		if (flags & XATTR_CREATE) {
+			ret = -EEXIST;
+		} else if (new) {
+			swap(entry->val, new->val);
+			swap(entry->len, new->len);
+		} else {
+			rb_erase(&entry->node, &root->root);
+			new = entry;
+		}
+
+		free_xattr_entry(new);
+	} else {
+		if (!new || (flags & XATTR_REPLACE)) {
+			ret = -ENOENT;
+		} else {
+			rb_link_node(&new->node, parent, p);
+			rb_insert_color(&new->node, &root->root);
+		}
+	}
+
+	spin_unlock(&root->lock);
+
+	return ret;
+}
+
+static int cgroup_setxattr(struct dentry *dentry, const char *name,
+			   const void *value, size_t size, int flags)
+{
+	if (size == 0)
+		value = "";
+
+	return __cgroup_setxattr(dentry, name, value, size, flags);
+}
+
+static int cgroup_removexattr(struct dentry *dentry, const char *name)
+{
+	return __cgroup_setxattr(dentry, name, NULL, 0, XATTR_REPLACE);
+}
+
+static ssize_t cgroup_getxattr(struct dentry *dentry, const char *name,
+			       void *buf, size_t size)
+{
+	struct cgroup_xattr_root *root = xattr_root(dentry);
+	struct cgroup_xattr_entry *entry;
+	struct rb_node *node;
+	int cmp;
+	int ret = -ENOENT;
+
+	if (!is_valid_xattr(name))
+		return -EOPNOTSUPP;
+
+	spin_lock(&root->lock);
+	node = root->root.rb_node;
+	while (node) {
+		entry = rb_entry(node, struct cgroup_xattr_entry, node);
+
+		cmp = strcmp(name, entry->name);
+		if (cmp > 0) {
+			node = node->rb_right;
+		} else if (cmp < 0) {
+			node = node->rb_left;
+		} else {
+			ret = entry->len;
+			if (buf) {
+				if (size < entry->len)
+					ret = -ERANGE;
+				else
+					memcpy(buf, entry->val, entry->len);
+			}
+			break;
+		}
+	}
+	spin_unlock(&root->lock);
+	return ret;
+}
+
+static ssize_t cgroup_listxattr(struct dentry *dentry, char *buf, size_t size)
+{
+	struct cgroup_xattr_root *root = xattr_root(dentry);
+	struct cgroup_xattr_entry *entry;
+	struct rb_node *node;
+	int total_len = 0;
+	int len;
+
+	spin_lock(&root->lock);
+	node = rb_first(&root->root);
+	while (node) {
+		entry = rb_entry(node, struct cgroup_xattr_entry, node);
+
+		if (!capable(CAP_SYS_ADMIN) &&
+		    strncmp(entry->name, XATTR_TRUSTED_PREFIX,
+			    XATTR_TRUSTED_PREFIX_LEN) == 0)
+			continue;
+
+		len = strlen(entry->name) + 1;
+		total_len += len;
+		if (buf) {
+			if (size < total_len) {
+				total_len = -ERANGE;
+				break;
+			}
+			memcpy(buf, entry->name, len);
+			buf += len;
+		}
+
+		node = rb_next(node);
+	}
+	spin_unlock(&root->lock);
+
+	return total_len;
+}
+
+#else /* CONFIG_CGROUP_XATTR */
+
+static void cgroup_xattrs_init(struct cgroup_xattr_root *root) {}
+static void cgroup_xattrs_destroy(struct cgroup_xattr_root *root) {}
+
+#endif
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
@@ -2667,6 +2917,7 @@ static int cgroup_create_file(struct dentry *dentry, umode_t mode,
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &cgroup_file_operations;
+		inode->i_op = &cgroup_file_inode_operations;
 	}
 	d_instantiate(dentry, inode);
 	dget(dentry);	/* Extra count - pin the dentry in core */
@@ -2736,6 +2987,7 @@ int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
 	cft->subsys = subsys;
+	cgroup_xattrs_init(&cft->xattr_root);
 
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
-- 
1.7.3.1
