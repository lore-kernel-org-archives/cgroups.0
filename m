From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix dentry still in use bug when dropping css refs
 after umount
Date: Sat, 30 Jun 2012 15:07:55 +0800
Message-ID: <4FEEA5CB.8070809@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org

To avoid rmdir hang, now we won't drain css references at rmdir, but
rmdir will proceed regardless of css refs. We still have to wait till
all css refs have been released before destroying cgroup, and this is
achieved by holding an extra dentry refcnt for each css, which leads to
this bug:

BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgroup] 
------------[ cut here ]------------ 
kernel BUG at fs/dcache.c:965! 
...
Call Trace: 
  [<ffffffff811ec19a>] shrink_dcache_for_umount+0x4a/0x90 
  [<ffffffff811cc3c7>] generic_shutdown_super+0x37/0x160 
  [<ffffffff811cc5d9>] kill_anon_super+0x19/0x40 
  [<ffffffff811cc63a>] kill_litter_super+0x3a/0x50 
  [<ffffffff810fb65a>] cgroup_kill_sb+0x20a/0x280 
  [<ffffffff811ccdc5>] deactivate_locked_super+0x65/0xb0 
  [<ffffffff811ce339>] deactivate_super+0x89/0xe0 
  [<ffffffff810f7734>] cgroup_d_release+0x34/0x40 
  [<ffffffff811eb258>] d_free+0x58/0xc0 
  [<ffffffff811ee5f0>] dput+0x220/0x350 
  [<ffffffff810f7429>] css_dput_fn+0x19/0x30 
  [<ffffffff8107b4d9>] process_one_work+0x239/0x800 
  [<ffffffff8107eba3>] worker_thread+0x2e3/0x710 
  [<ffffffff81087e46>] kthread+0xd6/0xf0 

If there's a css ref dangling after umount, when the ref goes down
to 0, dput will drop the cgroup's dentry and then drop the root
dentry. But kill_sb will be called inbetween, as dropping cgroup dentry
unpinned sb, and now vfs will find the root dentry's refcnt is not 0.

To fix this, we make css pin cgroup instead of cgroup dentry.

Reported-by: Shyju P V <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reported-by: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    8 +++-
 kernel/cgroup.c        |   99 ++++++++++++++++++++++--------------------------
 2 files changed, 52 insertions(+), 55 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d3f5fba..a642f2e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,6 +17,7 @@
 #include <linux/rwsem.h>
 #include <linux/idr.h>
 #include <linux/workqueue.h>
+#include <linux/kref.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -78,8 +79,8 @@ struct cgroup_subsys_state {
 	/* ID for this css, if possible */
 	struct css_id __rcu *id;
 
-	/* Used to put @cgroup->dentry on the last css_put() */
-	struct work_struct dput_work;
+	/* Used to put @cgroup->css_refs on the last css_put() */
+	struct work_struct put_work;
 };
 
 /* bits in struct cgroup_subsys_state flags field */
@@ -170,6 +171,9 @@ struct cgroup {
 	 */
 	atomic_t count;
 
+	/* We won't destroy the cgroup when there are css refs */
+	struct kref css_refs;
+
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
 	 * Our children link their 'sibling' into our 'children'.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..5b28938 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -875,12 +875,42 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 	return ret;
 }
 
+static void cgroup_release(struct kref *ref)
+{
+	struct cgroup_subsys *ss;
+	struct cgroup *cgrp = container_of(ref, struct cgroup, css_refs);
+
+	mutex_lock(&cgroup_mutex);
+	/*
+	 * Release the subsystem state objects.
+	 */
+	for_each_subsys(cgrp->root, ss)
+		ss->destroy(cgrp);
+
+	cgrp->root->number_of_cgroups--;
+	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	/*
+	 * if we're getting rid of the cgroup, refcount should ensure
+	 * that there are no pidlists left.
+	 */
+	BUG_ON(!list_empty(&cgrp->pidlists));
+
+	kfree_rcu(cgrp, rcu_head);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
 		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
+
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -890,32 +920,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * agent */
 		synchronize_rcu();
 
-		mutex_lock(&cgroup_mutex);
-		/*
-		 * Release the subsystem state objects.
-		 */
-		for_each_subsys(cgrp->root, ss)
-			ss->destroy(cgrp);
-
-		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
-
-		/*
-		 * We want to drop the active superblock reference from the
-		 * cgroup creation after all the dentry refs are gone -
-		 * kill_sb gets mighty unhappy otherwise.  Mark
-		 * dentry->d_fsdata with cgroup_diput() to tell
-		 * cgroup_d_release() to call deactivate_super().
-		 */
-		dentry->d_fsdata = cgroup_diput;
-
-		/*
-		 * if we're getting rid of the cgroup, refcount should ensure
-		 * that there are no pidlists left.
-		 */
-		BUG_ON(!list_empty(&cgrp->pidlists));
-
-		kfree_rcu(cgrp, rcu_head);
+		kref_put(&cgrp->css_refs, cgroup_release);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
 		struct cgroup *cgrp = dentry->d_parent->d_fsdata;
@@ -933,13 +938,6 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
-static void cgroup_d_release(struct dentry *dentry)
-{
-	/* did cgroup_diput() tell me to deactivate super? */
-	if (dentry->d_fsdata == cgroup_diput)
-		deactivate_super(dentry->d_sb);
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1415,6 +1413,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
+	kref_init(&cgrp->css_refs);
 }
 
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -1547,7 +1546,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
-		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
@@ -3890,12 +3888,12 @@ static int cgroup_populate_dir(struct cgroup *cgrp)
 	return 0;
 }
 
-static void css_dput_fn(struct work_struct *work)
+static void css_put_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, dput_work);
+		container_of(work, struct cgroup_subsys_state, put_work);
 
-	dput(css->cgroup->dentry);
+	kref_put(&css->cgroup->css_refs, cgroup_release);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
@@ -3912,14 +3910,14 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	cgrp->subsys[ss->subsys_id] = css;
 
 	/*
-	 * If !clear_css_refs, css holds an extra ref to @cgrp->dentry
-	 * which is put on the last css_put().  dput() requires process
-	 * context, which css_put() may be called without.  @css->dput_work
-	 * will be used to invoke dput() asynchronously from css_put().
+	 * If !clear_css_refs, css holds a ref to @cgrp->css_refs
+	 * which is put on the last css_put().
 	 */
-	INIT_WORK(&css->dput_work, css_dput_fn);
+	INIT_WORK(&css->put_work, css_put_fn);
 	if (ss->__DEPRECATED_clear_css_refs)
 		set_bit(CSS_CLEAR_CSS_REFS, &css->flags);
+	else
+		kref_get(&cgrp->css_refs);
 }
 
 static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
@@ -4022,11 +4020,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (err < 0)
 		goto err_remove;
 
-	/* If !clear_css_refs, each css holds a ref to the cgroup's dentry */
-	for_each_subsys(root, ss)
-		if (!ss->__DEPRECATED_clear_css_refs)
-			dget(dentry);
-
 	/* The cgroup directory was pre-locked for us */
 	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
 
@@ -4127,11 +4120,11 @@ static int cgroup_has_css_refs(struct cgroup *cgrp)
  * veto removal on any invocation.  This behavior is deprecated and will be
  * removed as soon as the existing user (memcg) is updated.
  *
- * If clear is not set, each css holds an extra reference to the cgroup's
- * dentry and cgroup removal proceeds regardless of css refs.
+ * If clear is not set, each css holds a reference to cgroup->css_refs
+ * and cgroup removal proceeds regardless of css refs.
  * ->pre_destroy() will be called at least once and is not allowed to fail.
- * On the last put of each css, whenever that may be, the extra dentry ref
- * is put so that dentry destruction happens only after all css's are
+ * On the last put of each css, whenever that may be, cgroup->css_refs
+ * is put so that cgroup destruction happens only after all css's are
  * released.
  */
 static int cgroup_clear_css_refs(struct cgroup *cgrp)
@@ -5002,7 +4995,7 @@ void __css_put(struct cgroup_subsys_state *css)
 		break;
 	case 0:
 		if (!test_bit(CSS_CLEAR_CSS_REFS, &css->flags))
-			schedule_work(&css->dput_work);
+			schedule_work(&css->put_work);
 		break;
 	}
 	rcu_read_unlock();
-- 
1.7.9.7

