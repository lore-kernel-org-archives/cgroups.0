From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] cgroup: track migration context in cgroup_mgctx
Date: Thu, 29 Dec 2016 17:11:14 -0500
Message-ID: <20161229221115.31995-3-tj@kernel.org>
References: <20161229221115.31995-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AAcOVgezeG4LL18O4fNznp8GTGFrSnlp7i1CUermccI=;
        b=L0wUrSZexp9d9otB0felGBKEpXZqTsT4CbwByhDcvLJsA6tE55yCzTAbkDlT7u5ZDL
         3l9qm+k/hPxeteT/o8WKW8Nx2cwaGHV5zcg62lNibF+gQLyeoAAQbXANns3nx5VWUAR5
         51oCsUDipVGItIn6DN9xy1f66l9PSYhq8QBRgQyHJrT7X7AguUx4i7gZ0SIX6wS1ZLnC
         i88I5yzf1Lti9Q8AsAnBF0y6PvpBkesYXh/+C5z7RdM5GJhYvZy3EBy/kqPHg2AzmOn3
         wTpXAzDZ2JBAGTQCv4rTsmDN0QAbaaN/PL7NB8VpxvDdO61fzzSfIuZ9Bb0M3uGMLxZh
         7q/w==
In-Reply-To: <20161229221115.31995-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup migration is performed in four steps - css_set preloading,
addition of target tasks, actual migration, and clean up.  A list
named preloaded_csets is used to track the preloading.  This is a bit
too restricted and the code is already depending on the subtlety that
all source css_sets appear before destination ones.

Let's create struct cgroup_mgctx which keeps track of everything
during migration.  Currently, it has separate preload lists for source
and destination csets and also embeds cgroup_taskset which is used
during the actual migration.  This moves struct cgroup_taskset
definition to cgroup-internal.h.

This patch doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  66 ++++++++++++++++--
 kernel/cgroup/cgroup-v1.c       |  10 +--
 kernel/cgroup/cgroup.c          | 144 ++++++++++++++++------------------------
 3 files changed, 122 insertions(+), 98 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 589b0e7..5f8c8ac 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -26,6 +26,61 @@ struct cgrp_cset_link {
 	struct list_head	cgrp_link;
 };
 
+/* used to track tasks and csets during migration */
+struct cgroup_taskset {
+	/* the src and dst cset list running through cset->mg_node */
+	struct list_head	src_csets;
+	struct list_head	dst_csets;
+
+	/* the subsys currently being processed */
+	int			ssid;
+
+	/*
+	 * Fields for cgroup_taskset_*() iteration.
+	 *
+	 * Before migration is committed, the target migration tasks are on
+	 * ->mg_tasks of the csets on ->src_csets.  After, on ->mg_tasks of
+	 * the csets on ->dst_csets.  ->csets point to either ->src_csets
+	 * or ->dst_csets depending on whether migration is committed.
+	 *
+	 * ->cur_csets and ->cur_task point to the current task position
+	 * during iteration.
+	 */
+	struct list_head	*csets;
+	struct css_set		*cur_cset;
+	struct task_struct	*cur_task;
+};
+
+/* migration context also tracks preloading */
+struct cgroup_mgctx {
+	/*
+	 * Preloaded source and destination csets.  Used to guarantee
+	 * atomic success or failure on actual migration.
+	 */
+	struct list_head	preloaded_src_csets;
+	struct list_head	preloaded_dst_csets;
+
+	/* tasks and csets to migrate */
+	struct cgroup_taskset	tset;
+};
+
+#define CGROUP_TASKSET_INIT(tset)						\
+{										\
+	.src_csets		= LIST_HEAD_INIT(tset.src_csets),		\
+	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),		\
+	.csets			= &tset.src_csets,				\
+}
+
+#define CGROUP_MGCTX_INIT(name)							\
+{										\
+	LIST_HEAD_INIT(name.preloaded_src_csets),				\
+	LIST_HEAD_INIT(name.preloaded_dst_csets),				\
+	CGROUP_TASKSET_INIT(name.tset),						\
+}
+
+#define DEFINE_CGROUP_MGCTX(name)						\
+	struct cgroup_mgctx name = CGROUP_MGCTX_INIT(name)
+
 struct cgroup_sb_opts {
 	u16 subsys_mask;
 	unsigned int flags;
@@ -112,13 +167,12 @@ struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
 			       struct cgroup_namespace *ns);
 
 bool cgroup_may_migrate_to(struct cgroup *dst_cgrp);
-void cgroup_migrate_finish(struct list_head *preloaded_csets);
-void cgroup_migrate_add_src(struct css_set *src_cset,
-			    struct cgroup *dst_cgrp,
-			    struct list_head *preloaded_csets);
-int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets);
+void cgroup_migrate_finish(struct cgroup_mgctx *mgctx);
+void cgroup_migrate_add_src(struct css_set *src_cset, struct cgroup *dst_cgrp,
+			    struct cgroup_mgctx *mgctx);
+int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx);
 int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-		   struct cgroup_root *root);
+		   struct cgroup_mgctx *mgctx, struct cgroup_root *root);
 
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 465b101..7a965f4 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
  */
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 {
-	LIST_HEAD(preloaded_csets);
+	DEFINE_CGROUP_MGCTX(mgctx);
 	struct cgrp_cset_link *link;
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -106,10 +106,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	/* all tasks in @from are being moved, all csets are source */
 	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &from->cset_links, cset_link)
-		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
+		cgroup_migrate_add_src(link->cset, to, &mgctx);
 	spin_unlock_irq(&css_set_lock);
 
-	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
 		goto out_err;
 
@@ -125,14 +125,14 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			ret = cgroup_migrate(task, false, to->root);
+			ret = cgroup_migrate(task, false, &mgctx, to->root);
 			if (!ret)
 				trace_cgroup_transfer_tasks(to, task, false);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
 out_err:
-	cgroup_migrate_finish(&preloaded_csets);
+	cgroup_migrate_finish(&mgctx);
 	percpu_up_write(&cgroup_threadgroup_rwsem);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index aed492e..f90554d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1916,49 +1916,18 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
-/* used to track tasks and other necessary states during migration */
-struct cgroup_taskset {
-	/* the src and dst cset list running through cset->mg_node */
-	struct list_head	src_csets;
-	struct list_head	dst_csets;
-
-	/* the subsys currently being processed */
-	int			ssid;
-
-	/*
-	 * Fields for cgroup_taskset_*() iteration.
-	 *
-	 * Before migration is committed, the target migration tasks are on
-	 * ->mg_tasks of the csets on ->src_csets.  After, on ->mg_tasks of
-	 * the csets on ->dst_csets.  ->csets point to either ->src_csets
-	 * or ->dst_csets depending on whether migration is committed.
-	 *
-	 * ->cur_csets and ->cur_task point to the current task position
-	 * during iteration.
-	 */
-	struct list_head	*csets;
-	struct css_set		*cur_cset;
-	struct task_struct	*cur_task;
-};
-
-#define CGROUP_TASKSET_INIT(tset)	(struct cgroup_taskset){	\
-	.src_csets		= LIST_HEAD_INIT(tset.src_csets),	\
-	.dst_csets		= LIST_HEAD_INIT(tset.dst_csets),	\
-	.csets			= &tset.src_csets,			\
-}
-
 /**
- * cgroup_taskset_add - try to add a migration target task to a taskset
+ * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
- * @tset: target taskset
+ * @mgctx: target migration context
  *
- * Add @task, which is a migration target, to @tset.  This function becomes
- * noop if @task doesn't need to be migrated.  @task's css_set should have
- * been added as a migration source and @task->cg_list will be moved from
- * the css_set's tasks list to mg_tasks one.
+ * Add @task, which is a migration target, to @mgctx->tset.  This function
+ * becomes noop if @task doesn't need to be migrated.  @task's css_set
+ * should have been added as a migration source and @task->cg_list will be
+ * moved from the css_set's tasks list to mg_tasks one.
  */
-static void cgroup_taskset_add(struct task_struct *task,
-			       struct cgroup_taskset *tset)
+static void cgroup_migrate_add_task(struct task_struct *task,
+				    struct cgroup_mgctx *mgctx)
 {
 	struct css_set *cset;
 
@@ -1978,10 +1947,11 @@ static void cgroup_taskset_add(struct task_struct *task,
 
 	list_move_tail(&task->cg_list, &cset->mg_tasks);
 	if (list_empty(&cset->mg_node))
-		list_add_tail(&cset->mg_node, &tset->src_csets);
+		list_add_tail(&cset->mg_node,
+			      &mgctx->tset.src_csets);
 	if (list_empty(&cset->mg_dst_cset->mg_node))
 		list_add_tail(&cset->mg_dst_cset->mg_node,
-			      &tset->dst_csets);
+			      &mgctx->tset.dst_csets);
 }
 
 /**
@@ -2048,17 +2018,18 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 
 /**
  * cgroup_taskset_migrate - migrate a taskset
- * @tset: taget taskset
+ * @mgctx: migration context
  * @root: cgroup root the migration is taking place on
  *
- * Migrate tasks in @tset as setup by migration preparation functions.
+ * Migrate tasks in @mgctx as setup by migration preparation functions.
  * This function fails iff one of the ->can_attach callbacks fails and
- * guarantees that either all or none of the tasks in @tset are migrated.
- * @tset is consumed regardless of success.
+ * guarantees that either all or none of the tasks in @mgctx are migrated.
+ * @mgctx is consumed regardless of success.
  */
-static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
+static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx,
 				  struct cgroup_root *root)
 {
+	struct cgroup_taskset *tset = &mgctx->tset;
 	struct cgroup_subsys *ss;
 	struct task_struct *task, *tmp_task;
 	struct css_set *cset, *tmp_cset;
@@ -2151,25 +2122,31 @@ bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
 
 /**
  * cgroup_migrate_finish - cleanup after attach
- * @preloaded_csets: list of preloaded css_sets
+ * @mgctx: migration context
  *
  * Undo cgroup_migrate_add_src() and cgroup_migrate_prepare_dst().  See
  * those functions for details.
  */
-void cgroup_migrate_finish(struct list_head *preloaded_csets)
+void cgroup_migrate_finish(struct cgroup_mgctx *mgctx)
 {
+	LIST_HEAD(preloaded);
 	struct css_set *cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
+
+	list_splice_tail_init(&mgctx->preloaded_src_csets, &preloaded);
+	list_splice_tail_init(&mgctx->preloaded_dst_csets, &preloaded);
+
+	list_for_each_entry_safe(cset, tmp_cset, &preloaded, mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
 		put_css_set_locked(cset);
 	}
+
 	spin_unlock_irq(&css_set_lock);
 }
 
@@ -2177,10 +2154,10 @@ void cgroup_migrate_finish(struct list_head *preloaded_csets)
  * cgroup_migrate_add_src - add a migration source css_set
  * @src_cset: the source css_set to add
  * @dst_cgrp: the destination cgroup
- * @preloaded_csets: list of preloaded css_sets
+ * @mgctx: migration context
  *
  * Tasks belonging to @src_cset are about to be migrated to @dst_cgrp.  Pin
- * @src_cset and add it to @preloaded_csets, which should later be cleaned
+ * @src_cset and add it to @mgctx->src_csets, which should later be cleaned
  * up by cgroup_migrate_finish().
  *
  * This function may be called without holding cgroup_threadgroup_rwsem
@@ -2191,7 +2168,7 @@ void cgroup_migrate_finish(struct list_head *preloaded_csets)
  */
 void cgroup_migrate_add_src(struct css_set *src_cset,
 			    struct cgroup *dst_cgrp,
-			    struct list_head *preloaded_csets)
+			    struct cgroup_mgctx *mgctx)
 {
 	struct cgroup *src_cgrp;
 
@@ -2219,32 +2196,32 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	src_cset->mg_src_cgrp = src_cgrp;
 	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
-	list_add(&src_cset->mg_preload_node, preloaded_csets);
+	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
 }
 
 /**
  * cgroup_migrate_prepare_dst - prepare destination css_sets for migration
- * @preloaded_csets: list of preloaded source css_sets
+ * @mgctx: migration context
  *
  * Tasks are about to be moved and all the source css_sets have been
- * preloaded to @preloaded_csets.  This function looks up and pins all
- * destination css_sets, links each to its source, and append them to
- * @preloaded_csets.
+ * preloaded to @mgctx->preloaded_src_csets.  This function looks up and
+ * pins all destination css_sets, links each to its source, and append them
+ * to @mgctx->preloaded_dst_csets.
  *
  * This function must be called after cgroup_migrate_add_src() has been
  * called on each migration source css_set.  After migration is performed
  * using cgroup_migrate(), cgroup_migrate_finish() must be called on
- * @preloaded_csets.
+ * @mgctx.
  */
-int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
+int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 {
-	LIST_HEAD(csets);
 	struct css_set *src_cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	/* look up the dst cset for each src cset and link it to src */
-	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets, mg_preload_node) {
+	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
+				 mg_preload_node) {
 		struct css_set *dst_cset;
 
 		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp);
@@ -2270,15 +2247,15 @@ int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
 		src_cset->mg_dst_cset = dst_cset;
 
 		if (list_empty(&dst_cset->mg_preload_node))
-			list_add(&dst_cset->mg_preload_node, &csets);
+			list_add_tail(&dst_cset->mg_preload_node,
+				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
 	}
 
-	list_splice_tail(&csets, preloaded_csets);
 	return 0;
 err:
-	cgroup_migrate_finish(&csets);
+	cgroup_migrate_finish(mgctx);
 	return -ENOMEM;
 }
 
@@ -2287,6 +2264,7 @@ int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
  * @leader: the leader of the process or the task to migrate
  * @threadgroup: whether @leader points to the whole process or a single task
  * @root: cgroup root migration is taking place on
+ * @mgctx: migration context
  *
  * Migrate a process or task denoted by @leader.  If migrating a process,
  * the caller must be holding cgroup_threadgroup_rwsem.  The caller is also
@@ -2301,9 +2279,8 @@ int cgroup_migrate_prepare_dst(struct list_head *preloaded_csets)
  * actually starting migrating.
  */
 int cgroup_migrate(struct task_struct *leader, bool threadgroup,
-		   struct cgroup_root *root)
+		   struct cgroup_mgctx *mgctx, struct cgroup_root *root)
 {
-	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
 	struct task_struct *task;
 
 	/*
@@ -2315,14 +2292,14 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	rcu_read_lock();
 	task = leader;
 	do {
-		cgroup_taskset_add(task, &tset);
+		cgroup_migrate_add_task(task, mgctx);
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, task);
 	rcu_read_unlock();
 	spin_unlock_irq(&css_set_lock);
 
-	return cgroup_taskset_migrate(&tset, root);
+	return cgroup_migrate_execute(mgctx, root);
 }
 
 /**
@@ -2336,7 +2313,7 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 		       bool threadgroup)
 {
-	LIST_HEAD(preloaded_csets);
+	DEFINE_CGROUP_MGCTX(mgctx);
 	struct task_struct *task;
 	int ret;
 
@@ -2348,8 +2325,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	rcu_read_lock();
 	task = leader;
 	do {
-		cgroup_migrate_add_src(task_css_set(task), dst_cgrp,
-				       &preloaded_csets);
+		cgroup_migrate_add_src(task_css_set(task), dst_cgrp, &mgctx);
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, task);
@@ -2357,11 +2333,11 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	spin_unlock_irq(&css_set_lock);
 
 	/* prepare dst csets and commit */
-	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (!ret)
-		ret = cgroup_migrate(leader, threadgroup, dst_cgrp->root);
+		ret = cgroup_migrate(leader, threadgroup, &mgctx, dst_cgrp->root);
 
-	cgroup_migrate_finish(&preloaded_csets);
+	cgroup_migrate_finish(&mgctx);
 
 	if (!ret)
 		trace_cgroup_attach_task(dst_cgrp, leader, threadgroup);
@@ -2528,8 +2504,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
  */
 static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 {
-	LIST_HEAD(preloaded_csets);
-	struct cgroup_taskset tset = CGROUP_TASKSET_INIT(tset);
+	DEFINE_CGROUP_MGCTX(mgctx);
 	struct cgroup_subsys_state *d_css;
 	struct cgroup *dsct;
 	struct css_set *src_cset;
@@ -2545,33 +2520,28 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		struct cgrp_cset_link *link;
 
 		list_for_each_entry(link, &dsct->cset_links, cset_link)
-			cgroup_migrate_add_src(link->cset, dsct,
-					       &preloaded_csets);
+			cgroup_migrate_add_src(link->cset, dsct, &mgctx);
 	}
 	spin_unlock_irq(&css_set_lock);
 
 	/* NULL dst indicates self on default hierarchy */
-	ret = cgroup_migrate_prepare_dst(&preloaded_csets);
+	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
 		goto out_finish;
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(src_cset, &preloaded_csets, mg_preload_node) {
+	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets, mg_preload_node) {
 		struct task_struct *task, *ntask;
 
-		/* src_csets precede dst_csets, break on the first dst_cset */
-		if (!src_cset->mg_src_cgrp)
-			break;
-
 		/* all tasks in src_csets need to be migrated */
 		list_for_each_entry_safe(task, ntask, &src_cset->tasks, cg_list)
-			cgroup_taskset_add(task, &tset);
+			cgroup_migrate_add_task(task, &mgctx);
 	}
 	spin_unlock_irq(&css_set_lock);
 
-	ret = cgroup_taskset_migrate(&tset, cgrp->root);
+	ret = cgroup_migrate_execute(&mgctx, cgrp->root);
 out_finish:
-	cgroup_migrate_finish(&preloaded_csets);
+	cgroup_migrate_finish(&mgctx);
 	percpu_up_write(&cgroup_threadgroup_rwsem);
 	return ret;
 }
-- 
2.9.3

