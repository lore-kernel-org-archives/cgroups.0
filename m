From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH v2 1/3] xattr: extract kmem_xattr code from tmpfs
Date: Thu, 01 Mar 2012 14:17:16 +0800
Message-ID: <4F4F146C.9090300@cn.fujitsu.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4F1459.4080300-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.

$ size vmlinux.o
   text    data     bss     dec     hex filename
5480650  655744 7039512 13175906         c90c62 vmlinux.o
$ size vmlinux.o
   text    data     bss     dec     hex filename
5480427  655744 7039448 13175619         c90b43 vmlinux.o

Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 fs/xattr.c               |  167 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/shmem_fs.h |    3 +-
 include/linux/xattr.h    |   23 ++++++
 mm/shmem.c               |  151 +++--------------------------------------
 4 files changed, 202 insertions(+), 142 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 82f4337..8af1b7f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -757,3 +757,170 @@ EXPORT_SYMBOL(generic_getxattr);
 EXPORT_SYMBOL(generic_listxattr);
 EXPORT_SYMBOL(generic_setxattr);
 EXPORT_SYMBOL(generic_removexattr);
+
+/*
+ * initialize the kmem_xattrs structure
+ */
+void kmem_xattrs_init(struct kmem_xattrs *xattrs)
+{
+	INIT_LIST_HEAD(&xattrs->head);
+	spin_lock_init(&xattrs->lock);
+}
+
+/*
+ * free all the xattrs
+ */
+void kmem_xattrs_free(struct kmem_xattrs *xattrs)
+{
+	struct kmem_xattr *xattr, *node;
+
+	spin_lock(&xattrs->lock);
+	list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
+		kfree(xattr->name);
+		kfree(xattr);
+	}
+	spin_unlock(&xattrs->lock);
+}
+
+/*
+ * xattr GET operation for in-memory/pseudo filesystems
+ */
+int kmem_xattr_get(struct kmem_xattrs *xattrs, const char *name,
+		   void *buffer, size_t size)
+{
+	struct kmem_xattr *xattr;
+	int ret = -ENODATA;
+
+	spin_lock(&xattrs->lock);
+	list_for_each_entry(xattr, &xattrs->head, list) {
+		if (strcmp(name, xattr->name))
+			continue;
+
+		ret = xattr->size;
+		if (buffer) {
+			if (size < xattr->size)
+				ret = -ERANGE;
+			else
+				memcpy(buffer, xattr->value, xattr->size);
+		}
+		break;
+	}
+	spin_unlock(&xattrs->lock);
+	return ret;
+}
+
+static int __kmem_xattr_set(struct kmem_xattrs *xattrs, const char *name,
+			    const void *value, size_t size, int flags)
+{
+	struct kmem_xattr *xattr;
+	struct kmem_xattr *new_xattr = NULL;
+	size_t len;
+	int err = 0;
+
+	/* value == NULL means remove */
+	if (value) {
+		/* wrap around? */
+		len = sizeof(*new_xattr) + size;
+		if (len <= sizeof(*new_xattr))
+			return -ENOMEM;
+
+		new_xattr = kmalloc(len, GFP_KERNEL);
+		if (!new_xattr)
+			return -ENOMEM;
+
+		new_xattr->name = kstrdup(name, GFP_KERNEL);
+		if (!new_xattr->name) {
+			kfree(new_xattr);
+			return -ENOMEM;
+		}
+
+		new_xattr->size = size;
+		memcpy(new_xattr->value, value, size);
+	}
+
+	spin_lock(&xattrs->lock);
+	list_for_each_entry(xattr, &xattrs->head, list) {
+		if (!strcmp(name, xattr->name)) {
+			if (flags & XATTR_CREATE) {
+				xattr = new_xattr;
+				err = -EEXIST;
+			} else if (new_xattr) {
+				list_replace(&xattr->list, &new_xattr->list);
+			} else {
+				list_del(&xattr->list);
+			}
+			goto out;
+		}
+	}
+	if (flags & XATTR_REPLACE) {
+		xattr = new_xattr;
+		err = -ENODATA;
+	} else {
+		list_add(&new_xattr->list, &xattrs->head);
+		xattr = NULL;
+	}
+out:
+	spin_unlock(&xattrs->lock);
+	if (xattr)
+		kfree(xattr->name);
+	kfree(xattr);
+	return err;
+
+}
+
+/*
+ * xattr SET operation for in-memory/pseudo filesystems
+ */
+int kmem_xattr_set(struct kmem_xattrs *xattrs, const char *name,
+		   const void *value, size_t size, int flags)
+{
+	if (size == 0)
+		value = ""; /* empty EA, do not remove */
+	return __kmem_xattr_set(xattrs, name, value, size, flags);
+}
+
+/*
+ * xattr REMOVE operation for in-memory/pseudo filesystems
+ */
+int kmem_xattr_remove(struct kmem_xattrs *xattrs, const char *name)
+{
+        return __kmem_xattr_set(xattrs, name, NULL, 0, XATTR_REPLACE);
+}
+
+static bool xattr_is_trusted(const char *name)
+{
+	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
+}
+
+/*
+ * xattr LIST operation for in-memory/pseudo filesystems
+ */
+ssize_t kmem_xattr_list(struct kmem_xattrs *xattrs, char *buffer, size_t size)
+{
+	bool trusted = capable(CAP_SYS_ADMIN);
+	struct kmem_xattr *xattr;
+	size_t used = 0;
+
+	spin_lock(&xattrs->lock);
+	list_for_each_entry(xattr, &xattrs->head, list) {
+		size_t len;
+
+		/* skip "trusted." attributes for unprivileged callers */
+		if (!trusted && xattr_is_trusted(xattr->name))
+			continue;
+
+		len = strlen(xattr->name) + 1;
+		used += len;
+		if (buffer) {
+			if (size < used) {
+				used = -ERANGE;
+				break;
+			}
+			memcpy(buffer, xattr->name, len);
+			buffer += len;
+		}
+	}
+	spin_unlock(&xattrs->lock);
+
+	return used;
+}
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e4c711c..6d006b6 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -5,6 +5,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pagemap.h>
 #include <linux/percpu_counter.h>
+#include <linux/xattr.h>
 
 /* inode in-kernel data */
 
@@ -18,7 +19,7 @@ struct shmem_inode_info {
 	};
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct list_head	swaplist;	/* chain of maybes on swap */
-	struct list_head	xattr_list;	/* list of shmem_xattr */
+	struct kmem_xattrs	xattrs;		/* list of xattrs */
 	struct inode		vfs_inode;
 };
 
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e5d1220..4d07f97 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -60,6 +60,7 @@
 #ifdef  __KERNEL__
 
 #include <linux/types.h>
+#include <linux/spinlock.h>
 
 struct inode;
 struct dentry;
@@ -96,6 +97,28 @@ ssize_t vfs_getxattr_alloc(struct dentry *dentry, const char *name,
 			   char **xattr_value, size_t size, gfp_t flags);
 int vfs_xattr_cmp(struct dentry *dentry, const char *xattr_name,
 		  const char *value, size_t size, gfp_t flags);
+
+struct kmem_xattrs {
+	struct list_head head;
+	spinlock_t lock;
+};
+
+struct kmem_xattr {
+	struct list_head list;
+	char *name;
+	size_t size;
+	char value[0];
+};
+
+void kmem_xattrs_init(struct kmem_xattrs *xattrs);
+void kmem_xattrs_free(struct kmem_xattrs *xattrs);
+int kmem_xattr_get(struct kmem_xattrs *xattrs, const char *name,
+		   void *buffer, size_t size);
+int kmem_xattr_set(struct kmem_xattrs *xattrs, const char *name,
+		   const void *value, size_t size, int flags);
+int kmem_xattr_remove(struct kmem_xattrs *xattrs, const char *name);
+ssize_t kmem_xattr_list(struct kmem_xattrs *xattrs, char *buffer, size_t size);
+
 #endif  /*  __KERNEL__  */
 
 #endif	/* _LINUX_XATTR_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index feead19..2e1e416 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -76,13 +76,6 @@ static struct vfsmount *shm_mnt;
 /* Symlink up to this size is kmalloc'ed instead of using a swappable page */
 #define SHORT_SYMLINK_LEN 128
 
-struct shmem_xattr {
-	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
-	char *name;		/* xattr name */
-	size_t size;
-	char value[0];
-};
-
 /* Flag allocation requirements to shmem_getpage */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
@@ -545,7 +538,6 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
 		shmem_unacct_size(info->flags, inode->i_size);
@@ -559,10 +551,7 @@ static void shmem_evict_inode(struct inode *inode)
 	} else
 		kfree(info->symlink);
 
-	list_for_each_entry_safe(xattr, nxattr, &info->xattr_list, list) {
-		kfree(xattr->name);
-		kfree(xattr);
-	}
+	kmem_xattrs_free(&info->xattrs);
 	BUG_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	end_writeback(inode);
@@ -1114,7 +1103,7 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
 		spin_lock_init(&info->lock);
 		info->flags = flags & VM_NORESERVE;
 		INIT_LIST_HEAD(&info->swaplist);
-		INIT_LIST_HEAD(&info->xattr_list);
+		kmem_xattrs_init(&info->xattrs);
 		cache_no_acl(inode);
 
 		switch (mode & S_IFMT) {
@@ -1679,93 +1668,6 @@ static void shmem_put_link(struct dentry *dentry, struct nameidata *nd, void *co
  * filesystem level, though.
  */
 
-static int shmem_xattr_get(struct dentry *dentry, const char *name,
-			   void *buffer, size_t size)
-{
-	struct shmem_inode_info *info;
-	struct shmem_xattr *xattr;
-	int ret = -ENODATA;
-
-	info = SHMEM_I(dentry->d_inode);
-
-	spin_lock(&info->lock);
-	list_for_each_entry(xattr, &info->xattr_list, list) {
-		if (strcmp(name, xattr->name))
-			continue;
-
-		ret = xattr->size;
-		if (buffer) {
-			if (size < xattr->size)
-				ret = -ERANGE;
-			else
-				memcpy(buffer, xattr->value, xattr->size);
-		}
-		break;
-	}
-	spin_unlock(&info->lock);
-	return ret;
-}
-
-static int shmem_xattr_set(struct dentry *dentry, const char *name,
-			   const void *value, size_t size, int flags)
-{
-	struct inode *inode = dentry->d_inode;
-	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct shmem_xattr *xattr;
-	struct shmem_xattr *new_xattr = NULL;
-	size_t len;
-	int err = 0;
-
-	/* value == NULL means remove */
-	if (value) {
-		/* wrap around? */
-		len = sizeof(*new_xattr) + size;
-		if (len <= sizeof(*new_xattr))
-			return -ENOMEM;
-
-		new_xattr = kmalloc(len, GFP_KERNEL);
-		if (!new_xattr)
-			return -ENOMEM;
-
-		new_xattr->name = kstrdup(name, GFP_KERNEL);
-		if (!new_xattr->name) {
-			kfree(new_xattr);
-			return -ENOMEM;
-		}
-
-		new_xattr->size = size;
-		memcpy(new_xattr->value, value, size);
-	}
-
-	spin_lock(&info->lock);
-	list_for_each_entry(xattr, &info->xattr_list, list) {
-		if (!strcmp(name, xattr->name)) {
-			if (flags & XATTR_CREATE) {
-				xattr = new_xattr;
-				err = -EEXIST;
-			} else if (new_xattr) {
-				list_replace(&xattr->list, &new_xattr->list);
-			} else {
-				list_del(&xattr->list);
-			}
-			goto out;
-		}
-	}
-	if (flags & XATTR_REPLACE) {
-		xattr = new_xattr;
-		err = -ENODATA;
-	} else {
-		list_add(&new_xattr->list, &info->xattr_list);
-		xattr = NULL;
-	}
-out:
-	spin_unlock(&info->lock);
-	if (xattr)
-		kfree(xattr->name);
-	kfree(xattr);
-	return err;
-}
-
 static const struct xattr_handler *shmem_xattr_handlers[] = {
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	&generic_acl_access_handler,
@@ -1796,6 +1698,7 @@ static int shmem_xattr_validate(const char *name)
 static ssize_t shmem_getxattr(struct dentry *dentry, const char *name,
 			      void *buffer, size_t size)
 {
+	struct shmem_inode_info *info = SHMEM_I(dentry->d_inode);
 	int err;
 
 	/*
@@ -1810,12 +1713,13 @@ static ssize_t shmem_getxattr(struct dentry *dentry, const char *name,
 	if (err)
 		return err;
 
-	return shmem_xattr_get(dentry, name, buffer, size);
+	return kmem_xattr_get(&info->xattrs, name, buffer, size);
 }
 
 static int shmem_setxattr(struct dentry *dentry, const char *name,
 			  const void *value, size_t size, int flags)
 {
+	struct shmem_inode_info *info = SHMEM_I(dentry->d_inode);
 	int err;
 
 	/*
@@ -1830,15 +1734,12 @@ static int shmem_setxattr(struct dentry *dentry, const char *name,
 	if (err)
 		return err;
 
-	if (size == 0)
-		value = "";  /* empty EA, do not remove */
-
-	return shmem_xattr_set(dentry, name, value, size, flags);
-
+	return kmem_xattr_set(&info->xattrs, name, value, size, flags);
 }
 
 static int shmem_removexattr(struct dentry *dentry, const char *name)
 {
+	struct shmem_inode_info *info = SHMEM_I(dentry->d_inode);
 	int err;
 
 	/*
@@ -1853,45 +1754,13 @@ static int shmem_removexattr(struct dentry *dentry, const char *name)
 	if (err)
 		return err;
 
-	return shmem_xattr_set(dentry, name, NULL, 0, XATTR_REPLACE);
-}
-
-static bool xattr_is_trusted(const char *name)
-{
-	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
+	return kmem_xattr_remove(&info->xattrs, name);
 }
 
 static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
-	bool trusted = capable(CAP_SYS_ADMIN);
-	struct shmem_xattr *xattr;
-	struct shmem_inode_info *info;
-	size_t used = 0;
-
-	info = SHMEM_I(dentry->d_inode);
-
-	spin_lock(&info->lock);
-	list_for_each_entry(xattr, &info->xattr_list, list) {
-		size_t len;
-
-		/* skip "trusted." attributes for unprivileged callers */
-		if (!trusted && xattr_is_trusted(xattr->name))
-			continue;
-
-		len = strlen(xattr->name) + 1;
-		used += len;
-		if (buffer) {
-			if (size < used) {
-				used = -ERANGE;
-				break;
-			}
-			memcpy(buffer, xattr->name, len);
-			buffer += len;
-		}
-	}
-	spin_unlock(&info->lock);
-
-	return used;
+	struct shmem_inode_info *info = SHMEM_I(dentry->d_inode);
+	return kmem_xattr_list(&info->xattrs, buffer, size);
 }
 #endif /* CONFIG_TMPFS_XATTR */
 
-- 
1.7.3.1
