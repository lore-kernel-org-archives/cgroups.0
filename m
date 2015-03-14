From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Sat, 14 Mar 2015 15:37:14 +1100
Message-ID: <1426307835-5893-3-git-send-email-cyphar@cyphar.com>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Add a new cgroup subsystem callback can_fork that conditionally
states whether or not the fork is accepted or rejected by a cgroup
policy.

In addition, add a cancel_fork callback so that if an error occurs later
in the forking process, any state modified by can_fork can be reverted.

In order to ensure that the fork charged the right hierarchy, save the
"current" css_set before doing ss->can_fork and compare it with the
"current" css_set that gets committed to the task *proper* in post_fork.
If they do not match, revert the can_fork's charging of the wrong
hierarchy and forcefully reapply it to the right hierarchy using the
reapply_fork callback. Since a changing "current" css_set in
copy_process indicates an organisation operation took place, we can
break the cgroup policy in this case.

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup.h | 13 ++++++-
 kernel/cgroup.c        | 92 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/fork.c          | 18 ++++++++--
 3 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..9592f6e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,7 +32,9 @@ struct cgroup;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p, void **state);
+extern void cgroup_cancel_fork(struct task_struct *p, void **state);
+extern void cgroup_post_fork(struct task_struct *p, void **old_state);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -649,6 +651,13 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
+	int (*can_fork)(struct cgroup_subsys_state *css,
+			struct task_struct *task);
+	void (*cancel_fork)(struct cgroup_subsys_state *css,
+			    struct task_struct *task);
+	void (*reapply_fork)(struct cgroup_subsys_state *css,
+			     struct cgroup_subsys_state *old_css,
+			     struct task_struct *task);
 	void (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
@@ -948,6 +957,8 @@ struct cgroup_subsys_state;
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p) { return 0; }
+static inline void cgroup_cancel_fork(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
 static inline void cgroup_exit(struct task_struct *p) {}
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d60107e..1a77790 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -183,6 +183,10 @@ static u64 css_serial_nr_next = 1;
  */
 static int need_forkexit_callback __read_mostly;
 
+/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
+static int need_canfork_callback __read_mostly = 0,
+	   need_reapplyfork_callback __read_mostly = 0;
+
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -4947,6 +4951,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	init_css_set.subsys[ss->id] = css;
 
 	need_forkexit_callback |= !!(ss->fork || ss->exit) << ss->id;
+	need_canfork_callback |= !!(ss->can_fork || ss->cancel_fork) << ss->id;
+	need_reapplyfork_callback |= !!(ss->reapply_fork) << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5200,6 +5206,66 @@ void cgroup_fork(struct task_struct *child)
 }
 
 /**
+ * cgroup_can_fork - called on a new task before the process is exposed.
+ * @child: the task in question.
+ *
+ * This calls the subsystem can_fork() callbacks. If the can_fork() callback
+ * returns an error, the fork aborts with that error code. This allows for
+ * a cgroup subsystem to conditionally allow or deny new forks.
+ */
+int cgroup_can_fork(struct task_struct *child, void **state)
+{
+	struct cgroup_subsys *ss;
+	struct css_set *cset;
+	int i, j, retval;
+
+	cset = task_css_set(current);
+	get_css_set(cset);
+	*state = cset;
+
+	for_each_subsys_which(need_canfork_callback, ss, i)
+		if (ss->can_fork) {
+			retval = ss->can_fork(cset->subsys[i], child);
+			if (retval)
+				goto out_revert;
+		}
+
+	return 0;
+
+out_revert:
+	for_each_subsys_which(need_canfork_callback, ss, j) {
+		if (j == i)
+			break;
+
+		if (ss->cancel_fork)
+			ss->cancel_fork(cset->subsys[i], child);
+	}
+
+	put_css_set(cset);
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
+void cgroup_cancel_fork(struct task_struct *child, void **state)
+{
+	struct cgroup_subsys *ss;
+	struct css_set *cset = *state;
+	int i;
+
+	for_each_subsys_which(need_canfork_callback, ss, i)
+		if (ss->cancel_fork)
+			ss->cancel_fork(cset->subsys[i], child);
+
+	put_css_set(cset);
+}
+
+/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
@@ -5209,9 +5275,10 @@ void cgroup_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, void **old_state)
 {
 	struct cgroup_subsys *ss;
+	struct css_set *cset, *old_cset = *old_state;
 	int i;
 
 	/*
@@ -5235,9 +5302,8 @@ void cgroup_post_fork(struct task_struct *child)
 	 * in the init_css_set before cg_links is enabled and there's no
 	 * operation which transfers all tasks out of init_css_set.
 	 */
+	cset = old_cset;
 	if (use_task_css_set_links) {
-		struct css_set *cset;
-
 		down_write(&css_set_rwsem);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
@@ -5249,6 +5315,24 @@ void cgroup_post_fork(struct task_struct *child)
 	}
 
 	/*
+	 * Deal with tasks that were migrated mid-fork. If the css_set
+	 * changed between can_fork() and post_fork() an organisation
+	 * operation has occurred, and we need to revert/reapply the
+	 * the can_fork().
+	 */
+	for_each_subsys_which(need_canfork_callback, ss, i) {
+		struct cgroup_subsys_state *css = cset->subsys[i],
+					   *old_css = old_cset->subsys[i];
+
+		/*
+		 * We only reapply for subsystems whose
+		 * association changed in the interim.
+		 */
+		if (old_css != css && ss->reapply_fork)
+			ss->reapply_fork(css, old_css, child);
+	}
+
+	/*
 	 * Call ss->fork().  This must happen after @child is linked on
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
@@ -5256,6 +5340,8 @@ void cgroup_post_fork(struct task_struct *child)
 	for_each_subsys_which(need_forkexit_callback, ss, i)
 		if (ss->fork)
 			ss->fork(child);
+
+	put_css_set(old_cset);
 }
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..c15ca74 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1196,6 +1196,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	void *cfs;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1469,6 +1470,17 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->task_works = NULL;
 
 	/*
+	 * Ensure that the cgroup subsystem policies allow the new process to be
+	 * forked. If this fork is happening in an organization operation, then
+	 * this will not charge the correct css_set. This is fixed after
+	 * cgroup_post_fork() (when the css_set has been updated) by undoing
+	 * this operation and forcefully charging the correct css_set.
+	 */
+	retval = cgroup_can_fork(p, &cfs);
+	if (retval)
+		goto bad_fork_free_pid;
+
+	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
 	 */
@@ -1504,7 +1516,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cgroup_cancel;
 	}
 
 	if (likely(p->pid)) {
@@ -1546,7 +1558,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, &cfs);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
@@ -1556,6 +1568,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cgroup_cancel:
+	cgroup_cancel_fork(p, &cfs);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
-- 
2.3.2
