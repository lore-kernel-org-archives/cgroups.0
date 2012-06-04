From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove hierarchy_mutex
Date: Mon, 04 Jun 2012 14:37:06 +0800
Message-ID: <4FCC5792.8010203@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It was introduced for memcg to iterate cgroup hierarchy without
holding cgroup_mutex, but soon after that it was replaced with
a lockless way in memcg.

No one used hierarchy_mutex since that, so remove it.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/cgroups.txt |    2 +-
 include/linux/cgroup.h            |   17 ++------------
 kernel/cgroup.c                   |   45 -------------------------------------
 3 files changed, 3 insertions(+), 61 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 8e74980..e86faae 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -656,7 +656,7 @@ example in cpusets, no task may attach before 'cpus' and 'mems' are set
 up.
 
 void bind(struct cgroup *root)
-(cgroup_mutex and ss->hierarchy_mutex held by caller)
+(cgroup_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
 and root cgroup. Currently this will only involve movement between
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d3f5fba..c90eaa8 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -500,21 +500,8 @@ struct cgroup_subsys {
 	const char *name;
 
 	/*
-	 * Protects sibling/children links of cgroups in this
-	 * hierarchy, plus protects which hierarchy (or none) the
-	 * subsystem is a part of (i.e. root/sibling).  To avoid
-	 * potential deadlocks, the following operations should not be
-	 * undertaken while holding any hierarchy_mutex:
-	 *
-	 * - allocating memory
-	 * - initiating hotplug events
-	 */
-	struct mutex hierarchy_mutex;
-	struct lock_class_key subsys_key;
-
-	/*
 	 * Link to parent, and list entry in parent's children.
-	 * Protected by this->hierarchy_mutex and cgroup_lock()
+	 * Protected by cgroup_lock()
 	 */
 	struct cgroupfs_root *root;
 	struct list_head sibling;
@@ -602,7 +589,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
  * the lifetime of cgroup_subsys_state is subsys's matter.
  *
  * Looking up and scanning function should be called under rcu_read_lock().
- * Taking cgroup_mutex()/hierarchy_mutex() is not necessary for following calls.
+ * Taking cgroup_mutex is not necessary for following calls.
  * But the css returned by this routine can be "not populated yet" or "being
  * destroyed". The caller should check css and cgroup's status.
  */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0f3527d..907c3f2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1063,28 +1063,24 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			BUG_ON(cgrp->subsys[i]);
 			BUG_ON(!dummytop->subsys[i]);
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
-			mutex_lock(&ss->hierarchy_mutex);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
 			if (ss->bind)
 				ss->bind(cgrp);
-			mutex_unlock(&ss->hierarchy_mutex);
 			/* refcount was already taken, and we're keeping it */
 		} else if (bit & removed_bits) {
 			/* We're removing this subsystem */
 			BUG_ON(ss == NULL);
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
-			mutex_lock(&ss->hierarchy_mutex);
 			if (ss->bind)
 				ss->bind(dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			subsys[i]->root = &rootnode;
 			list_move(&ss->sibling, &rootnode.subsys_list);
-			mutex_unlock(&ss->hierarchy_mutex);
 			/* subsystem is now free - drop reference on module */
 			module_put(ss->module);
 		} else if (bit & final_bits) {
@@ -3906,37 +3902,6 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 		set_bit(CSS_CLEAR_CSS_REFS, &css->flags);
 }
 
-static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
-{
-	/* We need to take each hierarchy_mutex in a consistent order */
-	int i;
-
-	/*
-	 * No worry about a race with rebind_subsystems that might mess up the
-	 * locking order, since both parties are under cgroup_mutex.
-	 */
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup_subsys *ss = subsys[i];
-		if (ss == NULL)
-			continue;
-		if (ss->root == root)
-			mutex_lock(&ss->hierarchy_mutex);
-	}
-}
-
-static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
-{
-	int i;
-
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup_subsys *ss = subsys[i];
-		if (ss == NULL)
-			continue;
-		if (ss->root == root)
-			mutex_unlock(&ss->hierarchy_mutex);
-	}
-}
-
 /*
  * cgroup_create - create a cgroup
  * @parent: cgroup that will be parent of the new cgroup
@@ -3997,9 +3962,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			ss->post_clone(cgrp);
 	}
 
-	cgroup_lock_hierarchy(root);
 	list_add(&cgrp->sibling, &cgrp->parent->children);
-	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups++;
 
 	err = cgroup_create_dir(cgrp, dentry, mode);
@@ -4026,9 +3989,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
  err_remove:
 
-	cgroup_lock_hierarchy(root);
 	list_del(&cgrp->sibling);
-	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups--;
 
  err_destroy:
@@ -4236,10 +4197,8 @@ again:
 		list_del_init(&cgrp->release_list);
 	raw_spin_unlock(&release_list_lock);
 
-	cgroup_lock_hierarchy(cgrp->root);
 	/* delete this cgroup from parent->children */
 	list_del_init(&cgrp->sibling);
-	cgroup_unlock_hierarchy(cgrp->root);
 
 	list_del_init(&cgrp->allcg_node);
 
@@ -4313,8 +4272,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	mutex_init(&ss->hierarchy_mutex);
-	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
 
 	/* this function shouldn't be used with modular subsystems, since they
@@ -4441,8 +4398,6 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	mutex_init(&ss->hierarchy_mutex);
-	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
 
 	/* success! */
-- 
1.7.9.7
