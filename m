From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Wed,  1 Apr 2015 19:57:20 +1100
Message-ID: <1427878641-5273-4-git-send-email-cyphar@cyphar.com>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Add a new cgroup subsystem callback can_fork that conditionally
states whether or not the fork is accepted or rejected by a cgroup
policy. In addition, add a cancel_fork callback so that if an error
occurs later in the forking process, any state modified by can_fork can
be reverted.

Allow for a private opaque pointer to be passed from the cgroup_can_fork
to cgroup_post_fork, allowing for the fork state to be stored by each
subsystem separately.

In order for a subsystem to know that a task associated with a cgroup
hierarchy is being migrated to another hierarchy, add a detach callback
to the subsystem which is run after the migration has been confirmed but
before the old_cset's refcount is dropped. This is necessary in order
for a subsystem to be able to keep a proper count of how many tasks are
associated with that subsystem.

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup.h  |  35 +++++++++++--
 kernel/cgroup.c         | 133 ++++++++++++++++++++++++++++++++++++++++++++----
 kernel/cgroup_freezer.c |   2 +-
 kernel/fork.c           |  31 +++++++++--
 kernel/sched/core.c     |   2 +-
 5 files changed, 185 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..d4cdd7a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -25,14 +25,23 @@
 
 #ifdef CONFIG_CGROUPS
 
+struct cgroup_fork_state;
 struct cgroup_root;
 struct cgroup_subsys;
 struct cgroup;
 
+extern struct cgroup_fork_state *cgroup_cfs_alloc(void);
+extern void cgroup_cfs_free(struct cgroup_fork_state *cfs);
+
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p,
+			   struct cgroup_fork_state *cfs);
+extern void cgroup_cancel_fork(struct task_struct *p,
+			       struct cgroup_fork_state *cfs);
+extern void cgroup_post_fork(struct task_struct *p,
+			     struct cgroup_fork_state *old_cfs);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -649,7 +658,11 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
-	void (*fork)(struct task_struct *task);
+	void (*detach)(struct cgroup_subsys_state *old_css,
+		       struct task_struct *task);
+	int (*can_fork)(struct task_struct *task, void **private);
+	void (*cancel_fork)(struct task_struct *task, void **private);
+	void (*fork)(struct task_struct *task, void **private);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
 		     struct task_struct *task);
@@ -943,12 +956,28 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 
 #else /* !CONFIG_CGROUPS */
 
+struct cgroup_fork_state;
 struct cgroup_subsys_state;
 
+static inline struct cgroup_fork_state *cfs cgroup_cfs_alloc(void)
+{
+	return NULL;
+}
+static inline void cgroup_cfs_free(struct cgroup_fork_state *cfs) {}
+
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p,
+				  struct cgroup_fork_state *cfs)
+{
+	return 0;
+}
+static inline void cgroup_cancel_fork(struct task_struct *p,
+				      struct cgroup_fork_state *cfs) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    struct cgroup_fork_state *old_cfs) {}
+
 static inline void cgroup_exit(struct task_struct *p) {}
 
 static inline int cgroupstats_build(struct cgroupstats *stats,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index abd491f..7b0ba2f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -176,14 +176,18 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
 static u64 css_serial_nr_next = 1;
 
 /*
- * These bitmask flags indicate whether tasks in the fork and exit paths should
- * check for fork/exit handlers to call. This avoids us having to do
- * extra work in the fork/exit path if none of the subsystems need to
- * be called.
+ * These bitmask flags indicate whether tasks in the fork and exit paths
+ * should check for fork/exit handlers to call. This avoids us having to do
+ * extra work in the fork/exit path if a subsystems doesn't need to be
+ * called.
  */
 static int need_fork_callback __read_mostly;
 static int need_exit_callback __read_mostly;
 
+/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
+static int need_canfork_callback __read_mostly;
+static int need_cancelfork_callback __read_mostly;
+
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -412,7 +416,7 @@ static int notify_on_release(const struct cgroup *cgrp)
 	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
 
 /**
- * for_each_subsys_which - filter for_each_subsys with a bitmask
+ * for_each_subsys_which - filter for_each_subsys with a subsys bitmask
  * @ss_mask: the bitmask
  * @ss: the iteration cursor
  * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
@@ -2054,6 +2058,8 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 				struct css_set *new_cset)
 {
 	struct css_set *old_cset;
+	struct cgroup_subsys_state *css;
+	int i;
 
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_rwsem);
@@ -2078,6 +2084,18 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
 
 	/*
+	 * We detach from the old_cset subsystems here. We must do this
+	 * before we drop the refcount for old_cset, in order to make sure
+	 * that nobody frees it underneath us.
+	 */
+	for_each_e_css(css, i, old_cgrp) {
+		struct cgroup_subsys_state *old_css = old_cset->subsys[i];
+
+		if (old_css->ss->detach)
+			old_css->ss->detach(old_css, tsk);
+	}
+
+	/*
 	 * We just gained a reference on old_cset by taking it from the
 	 * task. As trading it for new_cset is protected by cgroup_mutex,
 	 * we're safe to drop it here; it will be freed under RCU.
@@ -2321,9 +2339,10 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 	 */
 	tset.csets = &tset.dst_csets;
 
-	for_each_e_css(css, i, cgrp)
+	for_each_e_css(css, i, cgrp) {
 		if (css->ss->attach)
 			css->ss->attach(css, &tset);
+	}
 
 	ret = 0;
 	goto out_release_tset;
@@ -4935,6 +4954,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	need_fork_callback |= (bool) ss->fork << ss->id;
 	need_exit_callback |= (bool) ss->exit << ss->id;
+	need_canfork_callback |= (bool) ss->can_fork << ss->id;
+	need_cancelfork_callback |= (bool) ss->cancel_fork << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5173,6 +5194,33 @@ static const struct file_operations proc_cgroupstats_operations = {
 	.release = single_release,
 };
 
+struct cgroup_fork_state {
+	void *ss_state[CGROUP_SUBSYS_COUNT];
+};
+
+/**
+ * cgroup_cfs_alloc - allocates an empty cgroup_fork_state
+ */
+struct cgroup_fork_state *cgroup_cfs_alloc(void)
+{
+	struct cgroup_fork_state *cfs;
+
+	cfs = kzalloc(sizeof(struct cgroup_fork_state), GFP_KERNEL);
+	if (!cfs)
+		return ERR_PTR(-ENOMEM);
+
+	return cfs;
+}
+
+/**
+ * cgroup_cfs_free - frees a cgroup_fork_state pointer
+ * @cfs: the pointer to free
+ */
+void cgroup_cfs_free(struct cgroup_fork_state *cfs)
+{
+	kfree(cfs);
+}
+
 /**
  * cgroup_fork - initialize cgroup related fields during copy_process()
  * @child: pointer to task_struct of forking parent process.
@@ -5188,6 +5236,63 @@ void cgroup_fork(struct task_struct *child)
 }
 
 /**
+ * cgroup_can_fork - called on a new task before the process is exposed.
+ * @child: the task in question.
+ *
+ * This calls the subsystem can_fork() callbacks. If the can_fork() callback
+ * returns an error, the fork aborts with that error code. This allows for
+ * a cgroup subsystem to conditionally allow or deny new forks.
+ */
+int cgroup_can_fork(struct task_struct *child, struct cgroup_fork_state *cfs)
+{
+	struct cgroup_subsys *ss;
+	int i, j, retval;
+
+	for_each_subsys_which(need_canfork_callback, ss, i) {
+		retval = ss->can_fork(child, &cfs->ss_state[i]);
+		if (retval)
+			goto out_revert;
+	}
+
+	return 0;
+
+out_revert:
+	for_each_subsys_which(need_cancelfork_callback, ss, j) {
+		if (j >= i)
+			break;
+		ss->cancel_fork(child, &cfs->ss_state[i]);
+	}
+
+	return retval;
+}
+
+/**
+ * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
+ * @child: the task in question
+ *
+ * This calls the cancel_fork() callbacks if a fork failed *after*
+ * cgroup_can_fork() succeded.
+ */
+void cgroup_cancel_fork(struct task_struct *child, struct cgroup_fork_state *cfs)
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	for_each_subsys_which(need_cancelfork_callback, ss, i) {
+		void **state = NULL;
+
+		/*
+		 * Only if %ss has a can_fork() callback is %cfs->ss_state[i] meaningful
+		 * -- otherwise just pass a NULL.
+		 */
+		if (need_canfork_callback & (1 << i))
+			state = &cfs->ss_state[i];
+
+		ss->cancel_fork(child, &cfs->ss_state[i]);
+	}
+}
+
+/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
@@ -5197,7 +5302,7 @@ void cgroup_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, struct cgroup_fork_state *old_cfs)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5241,8 +5346,18 @@ void cgroup_post_fork(struct task_struct *child)
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
 	 */
-	for_each_subsys_which(need_fork_callback, ss, i)
-		ss->fork(child);
+	for_each_subsys_which(need_fork_callback, ss, i) {
+		void **state = NULL;
+
+		/*
+		 * Only if %ss has a can_fork() callback is %old_cfs->ss_state[i]
+		 * meaningful -- otherwise just pass a NULL.
+		 */
+		if (need_canfork_callback & (1 << i))
+			state = &old_cfs->ss_state[i];
+
+		ss->fork(child, state);
+	}
 }
 
 /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 92b98cc..6c9b090 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -203,7 +203,7 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
  * to do anything as freezer_attach() will put @task into the appropriate
  * state.
  */
-static void freezer_fork(struct task_struct *task)
+static void freezer_fork(struct task_struct *task, void **private)
 {
 	struct freezer *freezer;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..9d74393 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1196,6 +1196,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	struct cgroup_fork_state *cfs;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1322,12 +1323,17 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_begin(current);
 	cgroup_fork(p);
+	cfs = cgroup_cfs_alloc();
+	if (IS_ERR(cfs)) {
+		retval = PTR_ERR(cfs);
+		goto bad_fork_cleanup_threadgroup_lock;
+	}
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
 	if (IS_ERR(p->mempolicy)) {
 		retval = PTR_ERR(p->mempolicy);
 		p->mempolicy = NULL;
-		goto bad_fork_cleanup_threadgroup_lock;
+		goto bad_fork_cfs_free;
 	}
 #endif
 #ifdef CONFIG_CPUSETS
@@ -1468,6 +1474,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
+
+	/*
+	 * Ensure that the cgroup subsystem policies allow the new process to be
+	 * forked. If this fork is happening in an organization operation, then
+	 * this will not charge the correct css_set. This is fixed during
+	 * cgroup_post_fork() (when the css_set has been updated) by undoing
+	 * this operation and forcefully charging the correct css_set.
+	 */
+	retval = cgroup_can_fork(p, cfs);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
@@ -1504,7 +1522,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cancel_cgroup;
 	}
 
 	if (likely(p->pid)) {
@@ -1546,7 +1564,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, cfs);
+	cgroup_cfs_free(cfs);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
@@ -1556,6 +1575,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cancel_cgroup:
+	cgroup_cancel_fork(p, cfs);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
@@ -1585,8 +1606,10 @@ bad_fork_cleanup_perf:
 bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
-bad_fork_cleanup_threadgroup_lock:
+bad_fork_cfs_free:
 #endif
+	cgroup_cfs_free(cfs);
+bad_fork_cleanup_threadgroup_lock:
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	delayacct_tsk_free(p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f0f831e..75337bf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7986,7 +7986,7 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
-static void cpu_cgroup_fork(struct task_struct *task)
+static void cpu_cgroup_fork(struct task_struct *task, void **private)
 {
 	sched_move_task(task);
 }
-- 
2.3.4
