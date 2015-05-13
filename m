From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 cgroup/for-4.2 2/2] cgroup: reorganize
 include/linux/cgroup.h
Date: Wed, 13 May 2015 16:24:16 -0400
Message-ID: <20150513202416.GE11388@htj.duckdns.org>
References: <20150513193840.GC11388@htj.duckdns.org>
 <20150513193907.GD11388@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VEh606ShuiYUWmhPntN7rcWfYXInG2hNfhv5ABXCe34=;
        b=e3s96XMjoq3Ts27G6C1kgvfhAmCayqBT4lJyhSvuZAgNAjw2pR90OolRx491xUBBFr
         R94aMmeI5c8NXNujCwQceS7ABFSe8HYQoQCHrRaXqYJmC18bpzY8L/X7LJK3/mdI4gdT
         EDDzPLzT5MCrAw2ucOaScR9KEka9QVrYlnjb2o0fc3geLBZjdEqh+QqwrFa1rOk9NhIU
         21Bztqwc1BjXU2VpCDSXjjN9thPuG+JdhxogiFaSYqRZ1zH6fg2bGktr5b3KwfKYHcxn
         j7P7RaOLq6Yimya1CzWaV/FMhfLIS4h+Eu4zQIrUzi1icl5pGkf/ZTLC1dsOK4I+KJ3H
         Ckzw==
Content-Disposition: inline
In-Reply-To: <20150513193907.GD11388@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From c4d440938b5e2015c70594fe6666a099c844f929 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 13 May 2015 16:21:40 -0400

Over time, cgroup.h grew organically and doesn't have much logical
structure at this point.  Separation of cgroup-defs.h in the previous
patch gives us a good chance for reorganizing cgroup.h as changes to
the header are likely to cause conflicts anyway.

This patch reorganizes cgroup.h so that it has consistent logical
grouping.

This is pure reorganization.

v2: Relocating #ifdef CONFIG_CGROUPS caused build failure when cgroup
    is disabled.  Dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 552 ++++++++++++++++++++++++-------------------------
 1 file changed, 271 insertions(+), 281 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 96a2ecd..82319fb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,16 +22,189 @@
 
 #ifdef CONFIG_CGROUPS
 
-extern int cgroup_init_early(void);
-extern int cgroup_init(void);
-extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
-extern void cgroup_exit(struct task_struct *p);
-extern int cgroupstats_build(struct cgroupstats *stats,
-				struct dentry *dentry);
+/* a css_task_iter should be treated as an opaque object */
+struct css_task_iter {
+	struct cgroup_subsys		*ss;
+
+	struct list_head		*cset_pos;
+	struct list_head		*cset_head;
+
+	struct list_head		*task_pos;
+	struct list_head		*tasks_head;
+	struct list_head		*mg_tasks_head;
+};
+
+extern struct cgroup_root cgrp_dfl_root;
+extern struct css_set init_css_set;
+
+#define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+
+bool css_has_online_children(struct cgroup_subsys_state *css);
+struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
+					     struct cgroup_subsys *ss);
+struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
+						       struct cgroup_subsys *ss);
+
+bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
+int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
+
+int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
+int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
+int cgroup_rm_cftypes(struct cftype *cfts);
+
+char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
+int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
+int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
+		     struct pid *pid, struct task_struct *tsk);
+
+void cgroup_fork(struct task_struct *p);
+void cgroup_post_fork(struct task_struct *p);
+void cgroup_exit(struct task_struct *p);
+
+int cgroup_init_early(void);
+int cgroup_init(void);
+
+/*
+ * Iteration helpers and macros.
+ */
+
+struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
+					   struct cgroup_subsys_state *parent);
+struct cgroup_subsys_state *css_next_descendant_pre(struct cgroup_subsys_state *pos,
+						    struct cgroup_subsys_state *css);
+struct cgroup_subsys_state *css_rightmost_descendant(struct cgroup_subsys_state *pos);
+struct cgroup_subsys_state *css_next_descendant_post(struct cgroup_subsys_state *pos,
+						     struct cgroup_subsys_state *css);
+
+struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset);
+struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
+
+void css_task_iter_start(struct cgroup_subsys_state *css,
+			 struct css_task_iter *it);
+struct task_struct *css_task_iter_next(struct css_task_iter *it);
+void css_task_iter_end(struct css_task_iter *it);
+
+/**
+ * css_for_each_child - iterate through children of a css
+ * @pos: the css * to use as the loop cursor
+ * @parent: css whose children to walk
+ *
+ * Walk @parent's children.  Must be called under rcu_read_lock().
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
+ *
+ * It is allowed to temporarily drop RCU read lock during iteration.  The
+ * caller is responsible for ensuring that @pos remains accessible until
+ * the start of the next iteration by, for example, bumping the css refcnt.
+ */
+#define css_for_each_child(pos, parent)					\
+	for ((pos) = css_next_child(NULL, (parent)); (pos);		\
+	     (pos) = css_next_child((pos), (parent)))
+
+/**
+ * css_for_each_descendant_pre - pre-order walk of a css's descendants
+ * @pos: the css * to use as the loop cursor
+ * @root: css whose descendants to walk
+ *
+ * Walk @root's descendants.  @root is included in the iteration and the
+ * first node to be visited.  Must be called under rcu_read_lock().
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
+ *
+ * For example, the following guarantees that a descendant can't escape
+ * state updates of its ancestors.
+ *
+ * my_online(@css)
+ * {
+ *	Lock @css's parent and @css;
+ *	Inherit state from the parent;
+ *	Unlock both.
+ * }
+ *
+ * my_update_state(@css)
+ * {
+ *	css_for_each_descendant_pre(@pos, @css) {
+ *		Lock @pos;
+ *		if (@pos == @css)
+ *			Update @css's state;
+ *		else
+ *			Verify @pos is alive and inherit state from its parent;
+ *		Unlock @pos;
+ *	}
+ * }
+ *
+ * As long as the inheriting step, including checking the parent state, is
+ * enclosed inside @pos locking, double-locking the parent isn't necessary
+ * while inheriting.  The state update to the parent is guaranteed to be
+ * visible by walking order and, as long as inheriting operations to the
+ * same @pos are atomic to each other, multiple updates racing each other
+ * still result in the correct state.  It's guaranateed that at least one
+ * inheritance happens for any css after the latest update to its parent.
+ *
+ * If checking parent's state requires locking the parent, each inheriting
+ * iteration should lock and unlock both @pos->parent and @pos.
+ *
+ * Alternatively, a subsystem may choose to use a single global lock to
+ * synchronize ->css_online() and ->css_offline() against tree-walking
+ * operations.
+ *
+ * It is allowed to temporarily drop RCU read lock during iteration.  The
+ * caller is responsible for ensuring that @pos remains accessible until
+ * the start of the next iteration by, for example, bumping the css refcnt.
+ */
+#define css_for_each_descendant_pre(pos, css)				\
+	for ((pos) = css_next_descendant_pre(NULL, (css)); (pos);	\
+	     (pos) = css_next_descendant_pre((pos), (css)))
+
+/**
+ * css_for_each_descendant_post - post-order walk of a css's descendants
+ * @pos: the css * to use as the loop cursor
+ * @css: css whose descendants to walk
+ *
+ * Similar to css_for_each_descendant_pre() but performs post-order
+ * traversal instead.  @root is included in the iteration and the last
+ * node to be visited.
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
+ *
+ * Note that the walk visibility guarantee example described in pre-order
+ * walk doesn't apply the same to post-order walks.
+ */
+#define css_for_each_descendant_post(pos, css)				\
+	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
+	     (pos) = css_next_descendant_post((pos), (css)))
+
+/**
+ * cgroup_taskset_for_each - iterate cgroup_taskset
+ * @task: the loop cursor
+ * @tset: taskset to iterate
+ */
+#define cgroup_taskset_for_each(task, tset)				\
+	for ((task) = cgroup_taskset_first((tset)); (task);		\
+	     (task) = cgroup_taskset_next((tset)))
 
-extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
-			    struct pid *pid, struct task_struct *tsk);
+/*
+ * Inline functions.
+ */
 
 /**
  * css_get - obtain a reference on the specified css
@@ -118,8 +291,87 @@ static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
 		percpu_ref_put_many(&css->refcnt, n);
 }
 
-extern struct cgroup_root cgrp_dfl_root;
-extern struct css_set init_css_set;
+/**
+ * task_css_set_check - obtain a task's css_set with extra access conditions
+ * @task: the task to obtain css_set for
+ * @__c: extra condition expression to be passed to rcu_dereference_check()
+ *
+ * A task's css_set is RCU protected, initialized and exited while holding
+ * task_lock(), and can only be modified while holding both cgroup_mutex
+ * and task_lock() while the task is alive.  This macro verifies that the
+ * caller is inside proper critical section and returns @task's css_set.
+ *
+ * The caller can also specify additional allowed conditions via @__c, such
+ * as locks used during the cgroup_subsys::attach() methods.
+ */
+#ifdef CONFIG_PROVE_RCU
+extern struct mutex cgroup_mutex;
+extern struct rw_semaphore css_set_rwsem;
+#define task_css_set_check(task, __c)					\
+	rcu_dereference_check((task)->cgroups,				\
+		lockdep_is_held(&cgroup_mutex) ||			\
+		lockdep_is_held(&css_set_rwsem) ||			\
+		((task)->flags & PF_EXITING) || (__c))
+#else
+#define task_css_set_check(task, __c)					\
+	rcu_dereference((task)->cgroups)
+#endif
+
+/**
+ * task_css_check - obtain css for (task, subsys) w/ extra access conds
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ * @__c: extra condition expression to be passed to rcu_dereference_check()
+ *
+ * Return the cgroup_subsys_state for the (@task, @subsys_id) pair.  The
+ * synchronization rules are the same as task_css_set_check().
+ */
+#define task_css_check(task, subsys_id, __c)				\
+	task_css_set_check((task), (__c))->subsys[(subsys_id)]
+
+/**
+ * task_css_set - obtain a task's css_set
+ * @task: the task to obtain css_set for
+ *
+ * See task_css_set_check().
+ */
+static inline struct css_set *task_css_set(struct task_struct *task)
+{
+	return task_css_set_check(task, false);
+}
+
+/**
+ * task_css - obtain css for (task, subsys)
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * See task_css_check().
+ */
+static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
+						   int subsys_id)
+{
+	return task_css_check(task, subsys_id, false);
+}
+
+/**
+ * task_css_is_root - test whether a task belongs to the root css
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * Test whether @task belongs to the root css on the specified subsystem.
+ * May be invoked in any context.
+ */
+static inline bool task_css_is_root(struct task_struct *task, int subsys_id)
+{
+	return task_css_check(task, subsys_id, true) ==
+		init_css_set.subsys[subsys_id];
+}
+
+static inline struct cgroup *task_cgroup(struct task_struct *task,
+					 int subsys_id)
+{
+	return task_css(task, subsys_id)->cgroup;
+}
 
 /**
  * cgroup_on_dfl - test whether a cgroup is on the default hierarchy
@@ -236,284 +488,22 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 	pr_cont_kernfs_path(cgrp->kn);
 }
 
-char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
-
-int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
-int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
-int cgroup_rm_cftypes(struct cftype *cfts);
-
-bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
-
-struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset);
-struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
-
-/**
- * cgroup_taskset_for_each - iterate cgroup_taskset
- * @task: the loop cursor
- * @tset: taskset to iterate
- */
-#define cgroup_taskset_for_each(task, tset)				\
-	for ((task) = cgroup_taskset_first((tset)); (task);		\
-	     (task) = cgroup_taskset_next((tset)))
-
-#define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
-#include <linux/cgroup_subsys.h>
-#undef SUBSYS
-
-/**
- * task_css_set_check - obtain a task's css_set with extra access conditions
- * @task: the task to obtain css_set for
- * @__c: extra condition expression to be passed to rcu_dereference_check()
- *
- * A task's css_set is RCU protected, initialized and exited while holding
- * task_lock(), and can only be modified while holding both cgroup_mutex
- * and task_lock() while the task is alive.  This macro verifies that the
- * caller is inside proper critical section and returns @task's css_set.
- *
- * The caller can also specify additional allowed conditions via @__c, such
- * as locks used during the cgroup_subsys::attach() methods.
- */
-#ifdef CONFIG_PROVE_RCU
-extern struct mutex cgroup_mutex;
-extern struct rw_semaphore css_set_rwsem;
-#define task_css_set_check(task, __c)					\
-	rcu_dereference_check((task)->cgroups,				\
-		lockdep_is_held(&cgroup_mutex) ||			\
-		lockdep_is_held(&css_set_rwsem) ||			\
-		((task)->flags & PF_EXITING) || (__c))
-#else
-#define task_css_set_check(task, __c)					\
-	rcu_dereference((task)->cgroups)
-#endif
-
-/**
- * task_css_check - obtain css for (task, subsys) w/ extra access conds
- * @task: the target task
- * @subsys_id: the target subsystem ID
- * @__c: extra condition expression to be passed to rcu_dereference_check()
- *
- * Return the cgroup_subsys_state for the (@task, @subsys_id) pair.  The
- * synchronization rules are the same as task_css_set_check().
- */
-#define task_css_check(task, subsys_id, __c)				\
-	task_css_set_check((task), (__c))->subsys[(subsys_id)]
-
-/**
- * task_css_set - obtain a task's css_set
- * @task: the task to obtain css_set for
- *
- * See task_css_set_check().
- */
-static inline struct css_set *task_css_set(struct task_struct *task)
-{
-	return task_css_set_check(task, false);
-}
-
-/**
- * task_css - obtain css for (task, subsys)
- * @task: the target task
- * @subsys_id: the target subsystem ID
- *
- * See task_css_check().
- */
-static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
-						   int subsys_id)
-{
-	return task_css_check(task, subsys_id, false);
-}
-
-/**
- * task_css_is_root - test whether a task belongs to the root css
- * @task: the target task
- * @subsys_id: the target subsystem ID
- *
- * Test whether @task belongs to the root css on the specified subsystem.
- * May be invoked in any context.
- */
-static inline bool task_css_is_root(struct task_struct *task, int subsys_id)
-{
-	return task_css_check(task, subsys_id, true) ==
-		init_css_set.subsys[subsys_id];
-}
-
-static inline struct cgroup *task_cgroup(struct task_struct *task,
-					 int subsys_id)
-{
-	return task_css(task, subsys_id)->cgroup;
-}
-
-struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
-					   struct cgroup_subsys_state *parent);
-
-struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
-
-/**
- * css_for_each_child - iterate through children of a css
- * @pos: the css * to use as the loop cursor
- * @parent: css whose children to walk
- *
- * Walk @parent's children.  Must be called under rcu_read_lock().
- *
- * If a subsystem synchronizes ->css_online() and the start of iteration, a
- * css which finished ->css_online() is guaranteed to be visible in the
- * future iterations and will stay visible until the last reference is put.
- * A css which hasn't finished ->css_online() or already finished
- * ->css_offline() may show up during traversal.  It's each subsystem's
- * responsibility to synchronize against on/offlining.
- *
- * It is allowed to temporarily drop RCU read lock during iteration.  The
- * caller is responsible for ensuring that @pos remains accessible until
- * the start of the next iteration by, for example, bumping the css refcnt.
- */
-#define css_for_each_child(pos, parent)					\
-	for ((pos) = css_next_child(NULL, (parent)); (pos);		\
-	     (pos) = css_next_child((pos), (parent)))
-
-struct cgroup_subsys_state *
-css_next_descendant_pre(struct cgroup_subsys_state *pos,
-			struct cgroup_subsys_state *css);
-
-struct cgroup_subsys_state *
-css_rightmost_descendant(struct cgroup_subsys_state *pos);
-
-/**
- * css_for_each_descendant_pre - pre-order walk of a css's descendants
- * @pos: the css * to use as the loop cursor
- * @root: css whose descendants to walk
- *
- * Walk @root's descendants.  @root is included in the iteration and the
- * first node to be visited.  Must be called under rcu_read_lock().
- *
- * If a subsystem synchronizes ->css_online() and the start of iteration, a
- * css which finished ->css_online() is guaranteed to be visible in the
- * future iterations and will stay visible until the last reference is put.
- * A css which hasn't finished ->css_online() or already finished
- * ->css_offline() may show up during traversal.  It's each subsystem's
- * responsibility to synchronize against on/offlining.
- *
- * For example, the following guarantees that a descendant can't escape
- * state updates of its ancestors.
- *
- * my_online(@css)
- * {
- *	Lock @css's parent and @css;
- *	Inherit state from the parent;
- *	Unlock both.
- * }
- *
- * my_update_state(@css)
- * {
- *	css_for_each_descendant_pre(@pos, @css) {
- *		Lock @pos;
- *		if (@pos == @css)
- *			Update @css's state;
- *		else
- *			Verify @pos is alive and inherit state from its parent;
- *		Unlock @pos;
- *	}
- * }
- *
- * As long as the inheriting step, including checking the parent state, is
- * enclosed inside @pos locking, double-locking the parent isn't necessary
- * while inheriting.  The state update to the parent is guaranteed to be
- * visible by walking order and, as long as inheriting operations to the
- * same @pos are atomic to each other, multiple updates racing each other
- * still result in the correct state.  It's guaranateed that at least one
- * inheritance happens for any css after the latest update to its parent.
- *
- * If checking parent's state requires locking the parent, each inheriting
- * iteration should lock and unlock both @pos->parent and @pos.
- *
- * Alternatively, a subsystem may choose to use a single global lock to
- * synchronize ->css_online() and ->css_offline() against tree-walking
- * operations.
- *
- * It is allowed to temporarily drop RCU read lock during iteration.  The
- * caller is responsible for ensuring that @pos remains accessible until
- * the start of the next iteration by, for example, bumping the css refcnt.
- */
-#define css_for_each_descendant_pre(pos, css)				\
-	for ((pos) = css_next_descendant_pre(NULL, (css)); (pos);	\
-	     (pos) = css_next_descendant_pre((pos), (css)))
-
-struct cgroup_subsys_state *
-css_next_descendant_post(struct cgroup_subsys_state *pos,
-			 struct cgroup_subsys_state *css);
-
-/**
- * css_for_each_descendant_post - post-order walk of a css's descendants
- * @pos: the css * to use as the loop cursor
- * @css: css whose descendants to walk
- *
- * Similar to css_for_each_descendant_pre() but performs post-order
- * traversal instead.  @root is included in the iteration and the last
- * node to be visited.
- *
- * If a subsystem synchronizes ->css_online() and the start of iteration, a
- * css which finished ->css_online() is guaranteed to be visible in the
- * future iterations and will stay visible until the last reference is put.
- * A css which hasn't finished ->css_online() or already finished
- * ->css_offline() may show up during traversal.  It's each subsystem's
- * responsibility to synchronize against on/offlining.
- *
- * Note that the walk visibility guarantee example described in pre-order
- * walk doesn't apply the same to post-order walks.
- */
-#define css_for_each_descendant_post(pos, css)				\
-	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
-	     (pos) = css_next_descendant_post((pos), (css)))
-
-bool css_has_online_children(struct cgroup_subsys_state *css);
-
-/* A css_task_iter should be treated as an opaque object */
-struct css_task_iter {
-	struct cgroup_subsys		*ss;
-
-	struct list_head		*cset_pos;
-	struct list_head		*cset_head;
-
-	struct list_head		*task_pos;
-	struct list_head		*tasks_head;
-	struct list_head		*mg_tasks_head;
-};
-
-void css_task_iter_start(struct cgroup_subsys_state *css,
-			 struct css_task_iter *it);
-struct task_struct *css_task_iter_next(struct css_task_iter *it);
-void css_task_iter_end(struct css_task_iter *it);
-
-int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
-int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
-
-struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
-					     struct cgroup_subsys *ss);
-struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
-						       struct cgroup_subsys *ss);
-
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
 
-static inline int cgroup_init_early(void) { return 0; }
-static inline int cgroup_init(void) { return 0; }
+static inline void css_put(struct cgroup_subsys_state *css) {}
+static inline int cgroup_attach_task_all(struct task_struct *from,
+					 struct task_struct *t) { return 0; }
+static inline int cgroupstats_build(struct cgroupstats *stats,
+				    struct dentry *dentry) { return -EINVAL; }
+
 static inline void cgroup_fork(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
 static inline void cgroup_exit(struct task_struct *p) {}
 
-static inline int cgroupstats_build(struct cgroupstats *stats,
-					struct dentry *dentry)
-{
-	return -EINVAL;
-}
-
-static inline void css_put(struct cgroup_subsys_state *css) {}
-
-/* No cgroups - nothing to do */
-static inline int cgroup_attach_task_all(struct task_struct *from,
-					 struct task_struct *t)
-{
-	return 0;
-}
+static inline int cgroup_init_early(void) { return 0; }
+static inline int cgroup_init(void) { return 0; }
 
 #endif /* !CONFIG_CGROUPS */
 
-- 
2.1.0
