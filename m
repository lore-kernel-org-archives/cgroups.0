From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] cgroup: make css_set_rwsem a spinlock and rename it to css_set_lock
Date: Sun, 11 Oct 2015 09:30:08 -0400
Message-ID: <1444570210-15640-2-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zVLtgnICW8oxxV8YYRuF7A9Wln+D+wj/ZF/9KfVC5ak=;
        b=pRdiGlw5M9CMgh5Q3YZWv1aIJxy4dfk0iaIk7JILD5QTGgg96/A86OacjCdwIk0XLc
         zUfnnvMkTVffchtXJSbqXJKM3+jWcFcek7yD0E8TI7bFWSK4kMAl7jLW06t57VLU/L2s
         uLd54UAQ39KeN25LucvNgwtkwyojSBbLc/4avASUs5/ueqnUjP+r8MCQVJqL3lNFql00
         Sj8fm9pKfOAAQFCiJ8Rlgd6vhu3aeaqr5D5FYFGdx9lMXq3P+r+ZAjwEZDaRA7bMn1uf
         gKw4Rckw03hYW/UQRkTcndSI10MpQsvgnlm+ndFgkOGSP0I5Getya03mpQIDcoW8thzR
         gZ5A==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

css_set_rwsem is the inner lock protecting css_sets and is accessed
from hot paths such as fork and exit.  Internally, it has no reason to
be a rwsem or even mutex.  There are no internal blocking operations
while holding it.  This was rwsem because css task iteration used to
expose it to external iterator users.  As the previous patch updated
css task iteration such that the locking is not leaked to its users,
there's no reason to keep it a rwsem.

This patch converts css_set_rwsem to a spinlock and rename it to
css_set_lock.  It uses bh-safe operations as a planned usage needs to
access it from RCU callback context.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |   5 +-
 kernel/cgroup.c        | 144 ++++++++++++++++++++++++-------------------------
 2 files changed, 74 insertions(+), 75 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a9dcf0e..4602073 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -13,7 +13,6 @@
 #include <linux/nodemask.h>
 #include <linux/rculist.h>
 #include <linux/cgroupstats.h>
-#include <linux/rwsem.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
@@ -367,11 +366,11 @@ static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
  */
 #ifdef CONFIG_PROVE_RCU
 extern struct mutex cgroup_mutex;
-extern struct rw_semaphore css_set_rwsem;
+extern spinlock_t css_set_lock;
 #define task_css_set_check(task, __c)					\
 	rcu_dereference_check((task)->cgroups,				\
 		lockdep_is_held(&cgroup_mutex) ||			\
-		lockdep_is_held(&css_set_rwsem) ||			\
+		lockdep_is_held(&css_set_lock) ||			\
 		((task)->flags & PF_EXITING) || (__c))
 #else
 #define task_css_set_check(task, __c)					\
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e624363..0bfa26a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -45,7 +45,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/string.h>
 #include <linux/sort.h>
@@ -76,7 +75,7 @@
  * cgroup_mutex is the master lock.  Any modification to cgroup or its
  * hierarchy must be performed while holding it.
  *
- * css_set_rwsem protects task->cgroups pointer, the list of css_set
+ * css_set_lock protects task->cgroups pointer, the list of css_set
  * objects, and the chain of tasks off each css_set.
  *
  * These locks are exported if CONFIG_PROVE_RCU so that accessors in
@@ -84,12 +83,12 @@
  */
 #ifdef CONFIG_PROVE_RCU
 DEFINE_MUTEX(cgroup_mutex);
-DECLARE_RWSEM(css_set_rwsem);
+DEFINE_SPINLOCK(css_set_lock);
 EXPORT_SYMBOL_GPL(cgroup_mutex);
-EXPORT_SYMBOL_GPL(css_set_rwsem);
+EXPORT_SYMBOL_GPL(css_set_lock);
 #else
 static DEFINE_MUTEX(cgroup_mutex);
-static DECLARE_RWSEM(css_set_rwsem);
+static DEFINE_SPINLOCK(css_set_lock);
 #endif
 
 /*
@@ -605,7 +604,7 @@ static int css_set_count	= 1;	/* 1 for init_css_set */
  */
 static bool css_set_populated(struct css_set *cset)
 {
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	return !list_empty(&cset->tasks) || !list_empty(&cset->mg_tasks);
 }
@@ -628,7 +627,7 @@ static bool css_set_populated(struct css_set *cset)
  */
 static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 {
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	do {
 		bool trigger;
@@ -660,7 +659,7 @@ static void css_set_update_populated(struct css_set *cset, bool populated)
 {
 	struct cgrp_cset_link *link;
 
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link)
 		cgroup_update_populated(link->cgrp, populated);
@@ -685,7 +684,7 @@ static void css_set_move_task(struct task_struct *task,
 			      struct css_set *from_cset, struct css_set *to_cset,
 			      bool use_mg_tasks)
 {
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	if (from_cset) {
 		struct css_task_iter *it;
@@ -752,7 +751,7 @@ static void put_css_set_locked(struct css_set *cset)
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	if (!atomic_dec_and_test(&cset->refcount))
 		return;
@@ -783,9 +782,9 @@ static void put_css_set(struct css_set *cset)
 	if (atomic_add_unless(&cset->refcount, -1, 1))
 		return;
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	put_css_set_locked(cset);
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 }
 
 /*
@@ -1007,11 +1006,11 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	cset = find_existing_css_set(old_cset, cgrp, template);
 	if (cset)
 		get_css_set(cset);
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	if (cset)
 		return cset;
@@ -1039,7 +1038,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	 * find_existing_css_set() */
 	memcpy(cset->subsys, template, sizeof(cset->subsys));
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	/* Add reference counts and links from the new css_set. */
 	list_for_each_entry(link, &old_cset->cgrp_links, cgrp_link) {
 		struct cgroup *c = link->cgrp;
@@ -1061,7 +1060,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 		list_add_tail(&cset->e_cset_node[ssid],
 			      &cset->subsys[ssid]->cgroup->e_csets[ssid]);
 
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	return cset;
 }
@@ -1125,14 +1124,15 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	 * Release all the links from cset_links to this hierarchy's
 	 * root cgroup
 	 */
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	list_for_each_entry_safe(link, tmp_link, &cgrp->cset_links, cset_link) {
 		list_del(&link->cset_link);
 		list_del(&link->cgrp_link);
 		kfree(link);
 	}
-	up_write(&css_set_rwsem);
+
+	spin_unlock_bh(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
 		list_del(&root->root_list);
@@ -1154,7 +1154,7 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 	struct cgroup *res = NULL;
 
 	lockdep_assert_held(&cgroup_mutex);
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	if (cset == &init_css_set) {
 		res = &root->cgrp;
@@ -1177,7 +1177,7 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 
 /*
  * Return the cgroup for "task" from the given hierarchy. Must be
- * called with cgroup_mutex and css_set_rwsem held.
+ * called with cgroup_mutex and css_set_lock held.
  */
 static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 					    struct cgroup_root *root)
@@ -1526,11 +1526,11 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		ss->root = dst_root;
 		css->cgroup = dcgrp;
 
-		down_write(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		hash_for_each(css_set_table, i, cset, hlist)
 			list_move_tail(&cset->e_cset_node[ss->id],
 				       &dcgrp->e_csets[ss->id]);
-		up_write(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 
 		src_root->subsys_mask &= ~(1 << ssid);
 		scgrp->subtree_control &= ~(1 << ssid);
@@ -1807,7 +1807,7 @@ static void cgroup_enable_task_cg_lists(void)
 {
 	struct task_struct *p, *g;
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	if (use_task_css_set_links)
 		goto out_unlock;
@@ -1846,7 +1846,7 @@ static void cgroup_enable_task_cg_lists(void)
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 out_unlock:
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 }
 
 static void init_cgroup_housekeeping(struct cgroup *cgrp)
@@ -1910,7 +1910,7 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 		goto out;
 
 	/*
-	 * We're accessing css_set_count without locking css_set_rwsem here,
+	 * We're accessing css_set_count without locking css_set_lock here,
 	 * but that's OK - it can only be increased by someone holding
 	 * cgroup_lock, and that's us. The worst that can happen is that we
 	 * have some link structures left over
@@ -1952,13 +1952,13 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 	 * Link the root cgroup in this hierarchy into all the css_set
 	 * objects.
 	 */
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	hash_for_each(css_set_table, i, cset, hlist) {
 		link_css_set(&tmp_links, cset, root_cgrp);
 		if (css_set_populated(cset))
 			cgroup_update_populated(root_cgrp, true);
 	}
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	BUG_ON(!list_empty(&root_cgrp->self.children));
 	BUG_ON(atomic_read(&root->nr_cgrps) != 1);
@@ -2191,7 +2191,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 	char *path = NULL;
 
 	mutex_lock(&cgroup_mutex);
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
@@ -2204,7 +2204,7 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 			path = buf;
 	}
 
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	return path;
 }
@@ -2253,7 +2253,7 @@ static void cgroup_taskset_add(struct task_struct *task,
 {
 	struct css_set *cset;
 
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	/* @task either already exited or can't exit until the end */
 	if (task->flags & PF_EXITING)
@@ -2359,7 +2359,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 * the new cgroup.  There are no failure cases after here, so this
 	 * is the commit point.
 	 */
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
 			struct css_set *from_cset = task_css_set(task);
@@ -2370,7 +2370,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 			put_css_set_locked(from_cset);
 		}
 	}
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	/*
 	 * Migration is committed, all target tasks are now on dst_csets.
@@ -2394,13 +2394,13 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 			css->ss->cancel_attach(css, tset);
 	}
 out_release_tset:
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_splice_init(&tset->dst_csets, &tset->src_csets);
 	list_for_each_entry_safe(cset, tmp_cset, &tset->src_csets, mg_node) {
 		list_splice_tail_init(&cset->mg_tasks, &cset->tasks);
 		list_del_init(&cset->mg_node);
 	}
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	return ret;
 }
 
@@ -2417,14 +2417,14 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
 		put_css_set_locked(cset);
 	}
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 }
 
 /**
@@ -2450,7 +2450,7 @@ static void cgroup_migrate_add_src(struct css_set *src_cset,
 	struct cgroup *src_cgrp;
 
 	lockdep_assert_held(&cgroup_mutex);
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
@@ -2566,7 +2566,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	 * already PF_EXITING could be freed from underneath us unless we
 	 * take an rcu_read_lock.
 	 */
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2575,7 +2575,7 @@ static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	return cgroup_taskset_migrate(&tset, cgrp);
 }
@@ -2596,7 +2596,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	int ret;
 
 	/* look up all src csets */
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	rcu_read_lock();
 	task = leader;
 	do {
@@ -2606,7 +2606,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
@@ -2639,9 +2639,9 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 		struct cgroup *cgrp;
 		struct inode *inode;
 
-		down_read(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		up_read(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 
 		while (!cgroup_is_descendant(dst_cgrp, cgrp))
 			cgrp = cgroup_parent(cgrp);
@@ -2738,9 +2738,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (root == &cgrp_dfl_root)
 			continue;
 
-		down_read(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		from_cgrp = task_cgroup_from_root(from, root);
-		up_read(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 
 		retval = cgroup_attach_task(from_cgrp, tsk, false);
 		if (retval)
@@ -2865,7 +2865,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 
 	/* look up all csses currently attached to @cgrp's subtree */
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
 		struct cgrp_cset_link *link;
 
@@ -2877,14 +2877,14 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 			cgroup_migrate_add_src(link->cset, cgrp,
 					       &preloaded_csets);
 	}
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(NULL, &preloaded_csets);
 	if (ret)
 		goto out_finish;
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(src_cset, &preloaded_csets, mg_preload_node) {
 		struct task_struct *task, *ntask;
 
@@ -2896,7 +2896,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		list_for_each_entry_safe(task, ntask, &src_cset->tasks, cg_list)
 			cgroup_taskset_add(task, &tset);
 	}
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	ret = cgroup_taskset_migrate(&tset, cgrp);
 out_finish:
@@ -3572,10 +3572,10 @@ static int cgroup_task_count(const struct cgroup *cgrp)
 	int count = 0;
 	struct cgrp_cset_link *link;
 
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
 		count += atomic_read(&link->cset->refcount);
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	return count;
 }
 
@@ -3818,7 +3818,7 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
 
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 
 	/* Advance to the next non-empty css_set */
 	do {
@@ -3876,7 +3876,7 @@ static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct list_head *l = it->task_pos;
 
-	lockdep_assert_held(&css_set_rwsem);
+	lockdep_assert_held(&css_set_lock);
 	WARN_ON_ONCE(!l);
 
 	/*
@@ -3913,7 +3913,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	memset(it, 0, sizeof(*it));
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	it->ss = css->ss;
 
@@ -3926,7 +3926,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	css_task_iter_advance_css_set(it);
 
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 }
 
 /**
@@ -3942,7 +3942,7 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 	if (!it->cset_pos)
 		return NULL;
 
-	down_write(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	if (it->cur_task)
 		put_task_struct(it->cur_task);
@@ -3951,7 +3951,7 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 
 	css_task_iter_advance(it);
 
-	up_write(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	return it->cur_task;
 }
@@ -3965,10 +3965,10 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 void css_task_iter_end(struct css_task_iter *it)
 {
 	if (it->cur_cset) {
-		down_write(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		list_del(&it->iters_node);
 		put_css_set_locked(it->cur_cset);
-		up_write(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 	}
 
 	if (it->cur_task)
@@ -3997,10 +3997,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	mutex_lock(&cgroup_mutex);
 
 	/* all tasks in @from are being moved, all csets are source */
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(link, &from->cset_links, cset_link)
 		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 
 	ret = cgroup_migrate_prepare_dst(to, &preloaded_csets);
 	if (ret)
@@ -5353,7 +5353,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		goto out;
 
 	mutex_lock(&cgroup_mutex);
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 
 	for_each_root(root) {
 		struct cgroup_subsys *ss;
@@ -5385,7 +5385,7 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 
 	retval = 0;
 out_unlock:
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 	kfree(buf);
 out:
@@ -5531,7 +5531,7 @@ void cgroup_post_fork(struct task_struct *child,
 	 * @child during its iteration.
 	 *
 	 * If we won the race, @child is associated with %current's
-	 * css_set.  Grabbing css_set_rwsem guarantees both that the
+	 * css_set.  Grabbing css_set_lock guarantees both that the
 	 * association is stable, and, on completion of the parent's
 	 * migration, @child is visible in the source of migration or
 	 * already in the destination cgroup.  This guarantee is necessary
@@ -5546,13 +5546,13 @@ void cgroup_post_fork(struct task_struct *child,
 	if (use_task_css_set_links) {
 		struct css_set *cset;
 
-		down_write(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
 			css_set_move_task(child, NULL, cset, false);
 		}
-		up_write(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 	}
 
 	/*
@@ -5597,9 +5597,9 @@ void cgroup_exit(struct task_struct *tsk)
 	cset = task_css_set(tsk);
 
 	if (!list_empty(&tsk->cg_list)) {
-		down_write(&css_set_rwsem);
+		spin_lock_bh(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
-		up_write(&css_set_rwsem);
+		spin_unlock_bh(&css_set_lock);
 		put_cset = true;
 	}
 
@@ -5817,7 +5817,7 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 	if (!name_buf)
 		return -ENOMEM;
 
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	rcu_read_lock();
 	cset = rcu_dereference(current->cgroups);
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
@@ -5828,7 +5828,7 @@ static int current_css_set_cg_links_read(struct seq_file *seq, void *v)
 			   c->root->hierarchy_id, name_buf);
 	}
 	rcu_read_unlock();
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	kfree(name_buf);
 	return 0;
 }
@@ -5839,7 +5839,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
 
-	down_read(&css_set_rwsem);
+	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
@@ -5862,7 +5862,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	overflow:
 		seq_puts(seq, "  ...\n");
 	}
-	up_read(&css_set_rwsem);
+	spin_unlock_bh(&css_set_lock);
 	return 0;
 }
 
-- 
2.4.3
