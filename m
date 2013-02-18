From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Date: Mon, 18 Feb 2013 09:16:48 +0800
Message-ID: <51218100.5020007@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

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

v2: make cgrp->name RCU safe.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.h     |   2 -
 include/linux/cgroup.h |   1 +
 kernel/cgroup.c        | 113 ++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 85 insertions(+), 31 deletions(-)

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
index 900af59..a3d87d9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -171,6 +171,7 @@ struct cgroup {
 
 	struct cgroup *parent;		/* my parent */
 	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
+	char __rcu *name;		/* a copy of dentry->d_name */
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d4c92e..26c071c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -890,6 +890,7 @@ static void cgroup_free_fn(struct work_struct *work)
 	simple_xattrs_free(&cgrp->xattrs);
 
 	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	kfree(cgrp->name);
 	kfree(cgrp);
 }
 
@@ -1565,6 +1566,18 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	return 0;
 }
 
+static char *cgroup_alloc_name(struct dentry *dentry)
+{
+	char *name;
+
+	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
+	if (!name)
+		return NULL;
+	memcpy(name, dentry->d_name.name, dentry->d_name.len);
+	name[dentry->d_name.len] = '\0';
+	return name;
+}
+
 static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
@@ -1613,13 +1626,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		int i;
 		struct hlist_node *node;
 		struct css_set *cg;
+		struct dentry *dentry;
 
 		BUG_ON(sb->s_root != NULL);
 
 		ret = cgroup_get_rootdir(sb);
 		if (ret)
 			goto drop_new_super;
-		inode = sb->s_root->d_inode;
+		dentry = sb->s_root;
+		inode = dentry->d_inode;
+
+		root_cgrp->name = cgroup_alloc_name(dentry);
+		if (!root_cgrp->name)
+			goto drop_new_super;
 
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
@@ -1660,8 +1679,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		list_add(&root->root_list, &roots);
 		root_count++;
 
-		sb->s_root->d_fsdata = root_cgrp;
-		root->top_cgroup.dentry = sb->s_root;
+		dentry->d_fsdata = root_cgrp;
+		root->top_cgroup.dentry = dentry;
 
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
@@ -1751,6 +1770,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
+	synchronize_rcu();
+	kfree(cgrp->name);
 	simple_xattrs_free(&cgrp->xattrs);
 
 	kill_litter_super(sb);
@@ -1771,49 +1792,47 @@ static struct kobject *cgroup_kobj;
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
-		strcpy(buf, "/");
-		return 0;
-	}
-
 	start = buf + buflen - 1;
-
 	*start = '\0';
-	for (;;) {
-		int len = dentry->d_name.len;
 
+	rcu_read_lock();
+	while (true) {
+		char *p;
+		int len;
+
+		p = rcu_dereference(cgrp->name);
+		len = strlen(p);
 		if ((start -= len) < buf)
-			return -ENAMETOOLONG;
-		memcpy(start, dentry->d_name.name, len);
+			goto fail;
+		memcpy(start, p, len);
+
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
 
-		dentry = cgrp->dentry;
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
-			return -ENAMETOOLONG;
+			goto fail;
 		*start = '/';
 	}
+	ret = 0;
 	memmove(buf, start, buf + buflen - start);
-	return 0;
+fail:
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cgroup_path);
 
@@ -2539,13 +2558,41 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
 static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 			    struct inode *new_dir, struct dentry *new_dentry)
 {
+	int ret;
+	char *name, *old_name;
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
+	synchronize_rcu();
+	kfree(old_name);
+	return 0;
 }
 
 static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
@@ -4144,9 +4191,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (!cgrp)
 		return -ENOMEM;
 
+	cgrp->name = cgroup_alloc_name(dentry);
+	if (!cgrp->name)
+		goto err_free_cgrp;
+
 	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
 	if (cgrp->id < 0)
-		goto err_free_cgrp;
+		goto err_free_name;
 
 	/*
 	 * Only live parents can have children.  Note that the liveliness
@@ -4252,6 +4303,8 @@ err_free_all:
 	deactivate_super(sb);
 err_free_id:
 	ida_simple_remove(&root->cgroup_ida, cgrp->id);
+err_free_name:
+	kfree(cgrp->name);
 err_free_cgrp:
 	kfree(cgrp);
 	return err;
@@ -4656,6 +4709,8 @@ int __init cgroup_init_early(void)
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 
+	dummytop->name = "/";
+
 	init_css_set_link.cg = &init_css_set;
 	init_css_set_link.cgrp = dummytop;
 	list_add(&init_css_set_link.cgrp_link_list,
-- 
1.8.0.2
