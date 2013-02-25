From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/3] cgroup: fix cgroup_path() vs rename() race
Date: Mon, 25 Feb 2013 14:17:30 +0800
Message-ID: <512B01FA.5020506@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

rename() will change dentry->d_name. The result of this race can
be worse than seeing partially rewritten name, but we might access
a stale pointer because rename() will re-allocate memory to hold
a longer name.

As accessing dentry->name must be protected by dentry->d_lock or
parent inode's i_mutex, while on the other hand cgroup-path() can
be called with some irq-safe spinlocks held, we can't generate
cgroup path using dentry->d_name.

Alternatively we make a copy of dentry->d_name and save it in
cgrp->name when a cgroup is created, and update cgrp->name at
rename().

v3: use kfree_rcu() instead of synchronize_rcu() in user-visible path
v2: make cgrp->name RCU safe.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.h     |   2 -
 include/linux/cgroup.h |  17 +++++++++
 kernel/cgroup.c        | 101 ++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 91 insertions(+), 29 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2459730..e2e3404 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -216,9 +216,7 @@ static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
 {
 	int ret;
 
-	rcu_read_lock();
 	ret = cgroup_path(blkg->blkcg->css.cgroup, buf, buflen);
-	rcu_read_unlock();
 	if (ret)
 		strncpy(buf, "<unavailable>", buflen);
 	return ret;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..7f21bad 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -150,6 +150,11 @@ enum {
 	CGRP_CPUSET_CLONE_CHILDREN,
 };
 
+struct cgroup_name {
+	struct rcu_head rcu_head;
+	char name[0];
+};
+
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
@@ -172,6 +177,18 @@ struct cgroup {
 	struct cgroup *parent;		/* my parent */
 	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
 
+	/*
+	 * This is a copy of dentry->d_name, and it's needed because
+	 * we can't use dentry->d_name in cgroup_path().
+	 *
+	 * You must acquire rcu_read_lock() to access cgrp->name, and
+	 * the only place that can change it is rename(), which is
+	 * protected by parent dir's i_mutex.
+	 *
+	 * The name of the root cgroup is "/", and @name == NULL.
+	 */
+	struct cgroup_name __rcu *name;
+
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b5c6432..eb3c280 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -860,6 +860,17 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
 	return inode;
 }
 
+static struct cgroup_name *cgroup_alloc_name(struct dentry *dentry)
+{
+	struct cgroup_name *name;
+
+	name = kmalloc(sizeof(*name) + dentry->d_name.len + 1, GFP_KERNEL);
+	if (!name)
+		return NULL;
+	strcpy(name->name, dentry->d_name.name);
+	return name;
+}
+
 static void cgroup_free_fn(struct work_struct *work)
 {
 	struct cgroup *cgrp = container_of(work, struct cgroup, free_work);
@@ -890,6 +901,7 @@ static void cgroup_free_fn(struct work_struct *work)
 	simple_xattrs_free(&cgrp->xattrs);
 
 	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
 
@@ -1771,49 +1783,49 @@ static struct kobject *cgroup_kobj;
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
  *
- * Called with cgroup_mutex held or else with an RCU-protected cgroup
- * reference.  Writes path of cgroup into buf.  Returns 0 on success,
- * -errno on error.
+ * Writes path of cgroup into buf.  Returns 0 on success, -errno on error.
+ *
+ * We can't generate cgroup path using dentry->d_name, as accessing
+ * dentry->name must be protected by irq-unsafe dentry->d_lock or parent
+ * inode's i_mutex, while on the other hand cgroup_path() can be called
+ * with some irq-safe spinlocks held.
  */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
-	struct dentry *dentry = cgrp->dentry;
+	int ret = -ENAMETOOLONG;
 	char *start;
 
-	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
-			   "cgroup_path() called without proper locking");
-
-	if (cgrp == dummytop) {
-		/*
-		 * Inactive subsystems have no dentry for their root
-		 * cgroup
-		 */
+	if (!cgrp->parent) {
 		strcpy(buf, "/");
 		return 0;
 	}
 
 	start = buf + buflen - 1;
-
 	*start = '\0';
-	for (;;) {
-		int len = dentry->d_name.len;
 
+	rcu_read_lock();
+	while (cgrp->parent) {
+		struct cgroup_name *cname = rcu_dereference(cgrp->name);
+		char *name;
+		int len;
+
+		name = cname->name;
+		len = strlen(name);
 		if ((start -= len) < buf)
-			return -ENAMETOOLONG;
-		memcpy(start, dentry->d_name.name, len);
-		cgrp = cgrp->parent;
-		if (!cgrp)
-			break;
+			goto out;
+		memcpy(start, name, len);
 
-		dentry = cgrp->dentry;
-		if (!cgrp->parent)
-			continue;
 		if (--start < buf)
-			return -ENAMETOOLONG;
+			goto out;
 		*start = '/';
+
+		cgrp = cgrp->parent;
 	}
+	ret = 0;
 	memmove(buf, start, buf + buflen - start);
-	return 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
@@ -2539,13 +2551,40 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
 static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 			    struct inode *new_dir, struct dentry *new_dentry)
 {
+	int ret;
+	struct cgroup_name *name, *old_name;
+	struct cgroup *cgrp;
+
+	/*
+	 * It's convinient to use parent dir's i_mutex to protected
+	 * cgrp->name.
+	 */
+	lockdep_assert_held(&old_dir->i_mutex);
+
 	if (!S_ISDIR(old_dentry->d_inode->i_mode))
 		return -ENOTDIR;
 	if (new_dentry->d_inode)
 		return -EEXIST;
 	if (old_dir != new_dir)
 		return -EIO;
-	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
+
+	cgrp = __d_cgrp(old_dentry);
+
+	name = cgroup_alloc_name(new_dentry);
+	if (!name)
+		return -ENOMEM;
+
+	ret = simple_rename(old_dir, old_dentry, new_dir, new_dentry);
+	if (ret) {
+		kfree(name);
+		return ret;
+	}
+
+	old_name = cgrp->name;
+	rcu_assign_pointer(cgrp->name, name);
+
+	kfree_rcu(old_name, rcu_head);
+	return 0;
 }
 
 static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
@@ -4160,6 +4199,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
 	struct cgroup *cgrp;
+	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
 	int err = 0;
 	struct cgroup_subsys *ss;
@@ -4170,9 +4210,14 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (!cgrp)
 		return -ENOMEM;
 
+	name = cgroup_alloc_name(dentry);
+	if (!name)
+		goto err_free_cgrp;
+	rcu_assign_pointer(cgrp->name, name);
+
 	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
 	if (cgrp->id < 0)
-		goto err_free_cgrp;
+		goto err_free_name;
 
 	/*
 	 * Only live parents can have children.  Note that the liveliness
@@ -4278,6 +4323,8 @@ err_free_all:
 	deactivate_super(sb);
 err_free_id:
 	ida_simple_remove(&root->cgroup_ida, cgrp->id);
+err_free_name:
+	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
 	kfree(cgrp);
 	return err;
-- 
1.8.0.2
