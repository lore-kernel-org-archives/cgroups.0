From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Date: Sun, 17 Feb 2013 12:03:37 +0800
Message-ID: <51205699.5080900@huawei.com>
References: <51205684.5040407@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51205684.5040407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

rename() will change dentry->d_name. The result of this race can
be worse than seeing partially rewritten name, but we might access
a stale pointer because rename() will re-allocate memory to hold
a longer name.

As accessing dentry->name must be protected by dentry->d_lock or
parent inode's i_mutex, while on the other hand cgroup-path() can
be called with some irq-safe spinlocks held, we can't generate
cgroup path using dentry->d_name.

Alternatively we make a copy of dentry->d_lock and save it in
cgrp->name when a cgroup is created, and update cgrp->name at
rename().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  4 ++-
 kernel/cgroup.c        | 94 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..8b2ce2a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -171,6 +171,8 @@ struct cgroup {
 
 	struct cgroup *parent;		/* my parent */
 	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
+	char *name;			/* a copy of dentry->d_name */
+	spinlock_t name_lock;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
@@ -409,7 +411,7 @@ int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int cgroup_path(struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d4c92e..cea6a88 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -890,6 +890,7 @@ static void cgroup_free_fn(struct work_struct *work)
 	simple_xattrs_free(&cgrp->xattrs);
 
 	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	kfree(cgrp->name);
 	kfree(cgrp);
 }
 
@@ -1410,6 +1411,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
+	spin_lock_init(&cgrp->name_lock);
 	simple_xattrs_init(&cgrp->xattrs);
 }
 
@@ -1565,6 +1567,18 @@ static int cgroup_get_rootdir(struct super_block *sb)
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
@@ -1613,13 +1627,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
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
@@ -1660,8 +1680,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		list_add(&root->root_list, &roots);
 		root_count++;
 
-		sb->s_root->d_fsdata = root_cgrp;
-		root->top_cgroup.dentry = sb->s_root;
+		dentry->d_fsdata = root_cgrp;
+		root->top_cgroup.dentry = dentry;
 
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
@@ -1751,6 +1771,7 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	mutex_unlock(&cgroup_root_mutex);
 	mutex_unlock(&cgroup_mutex);
 
+	kfree(cgrp->name);
 	simple_xattrs_free(&cgrp->xattrs);
 
 	kill_litter_super(sb);
@@ -1774,38 +1795,39 @@ static struct kobject *cgroup_kobj;
  * Called with cgroup_mutex held or else with an RCU-protected cgroup
  * reference.  Writes path of cgroup into buf.  Returns 0 on success,
  * -errno on error.
+ *
+ *  We can't generate cgroup path using dentry->d_name, as accessing
+ *  dentry->name must be protected by irq-unsafe dentry->d_lock or
+ *  parent inode's i_mutex, while on the other hand cgroup_path() can
+ *  be called with some irq-safe spinlocks held.
  */
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
+int cgroup_path(struct cgroup *cgrp, char *buf, int buflen)
 {
-	struct dentry *dentry = cgrp->dentry;
 	char *start;
 
 	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
 			   "cgroup_path() called without proper locking");
 
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
 
 	*start = '\0';
-	for (;;) {
-		int len = dentry->d_name.len;
+	while (true) {
+		int len;
+		unsigned long flags;
 
-		if ((start -= len) < buf)
+		spin_lock_irqsave(&cgrp->name_lock, flags);
+		len = strlen(cgrp->name);
+		if ((start -= len) < buf) {
+			spin_unlock_irqrestore(&cgrp->name_lock, flags);
 			return -ENAMETOOLONG;
-		memcpy(start, dentry->d_name.name, len);
+		}
+		memcpy(start, cgrp->name, len);
+		spin_unlock_irqrestore(&cgrp->name_lock, flags);
+
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
 
-		dentry = cgrp->dentry;
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
@@ -2539,13 +2561,35 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
 static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 			    struct inode *new_dir, struct dentry *new_dentry)
 {
+	unsigned long flags;
+	int ret;
+	char *name;
+	struct cgroup *cgrp;
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
+	spin_lock_irqsave(&cgrp->name_lock, flags);
+	kfree(cgrp->name);
+	cgrp->name = name;
+	spin_unlock_irqrestore(&cgrp->name_lock, flags);
+	return 0;
 }
 
 static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
@@ -4144,9 +4188,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
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
@@ -4252,6 +4300,8 @@ err_free_all:
 	deactivate_super(sb);
 err_free_id:
 	ida_simple_remove(&root->cgroup_ida, cgrp->id);
+err_free_name:
+	kfree(cgrp->name);
 err_free_cgrp:
 	kfree(cgrp);
 	return err;
@@ -4656,6 +4706,8 @@ int __init cgroup_init_early(void)
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 
+	dummytop->name = "/";
+
 	init_css_set_link.cg = &init_css_set;
 	init_css_set_link.cgrp = dummytop;
 	list_add(&init_css_set_link.cgrp_link_list,
-- 
1.8.0.2
