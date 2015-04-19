From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Sun, 19 Apr 2015 22:22:33 +1000
Message-ID: <1429446154-10660-4-git-send-email-cyphar@cyphar.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429446154-10660-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

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

Also add a tagging system for cgroup_subsys.h to allow for CGROUP_<TAG>
enumerations to be be defined and used (as well as CGROUP_<TAG>_COUNT).

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h        |  47 +++++++++++++-----
 include/linux/cgroup_subsys.h |  27 +++++++++++
 kernel/cgroup.c               | 108 ++++++++++++++++++++++++++++++++++++++----
 kernel/cgroup_freezer.c       |   2 +-
 kernel/fork.c                 |  19 +++++++-
 kernel/sched/core.c           |   2 +-
 6 files changed, 181 insertions(+), 24 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..fbdbe80 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -25,6 +25,19 @@
 
 #ifdef CONFIG_CGROUPS
 
+/* define the enumeration of all cgroup subsystems */
+enum cgroup_subsys_id {
+#define SUBSYS(_x) _x ## _cgrp_id,
+#define SUBSYS_TAG(_t) CGROUP_ ## _t, \
+	__unused_tag_ ## _t = CGROUP_ ## _t - 1,
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS_TAG
+#undef SUBSYS
+	CGROUP_SUBSYS_COUNT,
+};
+
+#define CGROUP_PREFORK_COUNT (CGROUP_PREFORK_END - CGROUP_PREFORK_START)
+
 struct cgroup_root;
 struct cgroup_subsys;
 struct cgroup;
@@ -32,7 +45,12 @@ struct cgroup;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p,
+			   void *ss_state[CGROUP_PREFORK_COUNT]);
+extern void cgroup_cancel_fork(struct task_struct *p,
+			       void *ss_state[CGROUP_PREFORK_COUNT]);
+extern void cgroup_post_fork(struct task_struct *p,
+			     void *old_ss_state[CGROUP_PREFORK_COUNT]);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -40,14 +58,6 @@ extern int cgroupstats_build(struct cgroupstats *stats,
 extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			    struct pid *pid, struct task_struct *tsk);
 
-/* define the enumeration of all cgroup subsystems */
-#define SUBSYS(_x) _x ## _cgrp_id,
-enum cgroup_subsys_id {
-#include <linux/cgroup_subsys.h>
-	CGROUP_SUBSYS_COUNT,
-};
-#undef SUBSYS
-
 /*
  * Per-subsystem/per-cgroup state maintained by the system.  This is the
  * fundamental structural building block that controllers deal with.
@@ -649,7 +659,11 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
-	void (*fork)(struct task_struct *task);
+	void (*detach)(struct cgroup_subsys_state *old_css,
+		       struct task_struct *task);
+	int (*can_fork)(struct task_struct *task, void **private);
+	void (*cancel_fork)(struct task_struct *task, void *private);
+	void (*fork)(struct task_struct *task, void *private);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
 		     struct task_struct *task);
@@ -945,10 +959,21 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 
 struct cgroup_subsys_state;
 
+#define CGROUP_PREFORK_COUNT 0
+
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p,
+				  void *s[CGROUP_PREFORK_COUNT])
+{
+	return 0;
+}
+static inline void cgroup_cancel_fork(struct task_struct *p,
+				      void *s[CGROUP_PREFORK_COUNT]) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    void *s[CGROUP_PREFORK_COUNT]) {}
+
 static inline void cgroup_exit(struct task_struct *p) {}
 
 static inline int cgroupstats_build(struct cgroupstats *stats,
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e4a96fb..fdd3551 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -3,6 +3,16 @@
  *
  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
+#ifndef SUBSYS
+#	define __TMP_SUBSYS
+#	define SUBSYS(_x)
+#endif
+
+#ifndef SUBSYS_TAG
+#	define __TMP_SUBSYS_TAG
+#	define SUBSYS_TAG(_t)
+#endif
+
 #if IS_ENABLED(CONFIG_CPUSETS)
 SUBSYS(cpuset)
 #endif
@@ -48,11 +58,28 @@ SUBSYS(hugetlb)
 #endif
 
 /*
+ * Subsystems that implement the can_fork() family of callbacks.
+ */
+SUBSYS_TAG(PREFORK_START)
+SUBSYS_TAG(PREFORK_END)
+
+/*
  * The following subsystems are not supported on the default hierarchy.
  */
 #if IS_ENABLED(CONFIG_CGROUP_DEBUG)
 SUBSYS(debug)
 #endif
+
+#ifdef __TMP_SUBSYS
+#	undef __TMP_SUBSYS
+#	undef SUBSYS
+#endif
+
+#ifdef __TMP_SUBSYS_TAG
+#	undef __TMP_SUBSYS_TAG
+#	undef SUBSYS_TAG
+#endif
+
 /*
  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index abd491f..122a823 100644
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
@@ -5188,6 +5209,68 @@ void cgroup_fork(struct task_struct *child)
 }
 
 /**
+ * cgroup_can_fork - called on a new task before the process is exposed.
+ * @child: the task in question.
+ *
+ * This calls the subsystem can_fork() callbacks. If the can_fork() callback
+ * returns an error, the fork aborts with that error code. This allows for
+ * a cgroup subsystem to conditionally allow or deny new forks.
+ */
+int cgroup_can_fork(struct task_struct *child,
+		    void *ss_state[CGROUP_PREFORK_COUNT])
+{
+	struct cgroup_subsys *ss;
+	int i, j, retval;
+
+	for_each_subsys_which(need_canfork_callback, ss, i) {
+		retval = ss->can_fork(child,
+				      &ss_state[i - CGROUP_PREFORK_START]);
+		if (retval)
+			goto out_revert;
+	}
+
+	return 0;
+
+out_revert:
+	for_each_subsys_which(need_cancelfork_callback, ss, j) {
+		void *state = NULL;
+
+		if (j >= i)
+			break;
+
+		if (CGROUP_PREFORK_START <= j && j < CGROUP_PREFORK_END)
+			state = ss_state[j - CGROUP_PREFORK_START];
+
+		ss->cancel_fork(child, state);
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
+void cgroup_cancel_fork(struct task_struct *child,
+			void *ss_state[CGROUP_PREFORK_COUNT])
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	for_each_subsys_which(need_cancelfork_callback, ss, i) {
+		void *state = NULL;
+
+		if (CGROUP_PREFORK_START <= i && i < CGROUP_PREFORK_END)
+			state = ss_state[i - CGROUP_PREFORK_START];
+
+		ss->cancel_fork(child, state);
+	}
+}
+
+/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
@@ -5197,7 +5280,8 @@ void cgroup_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child,
+		      void *old_ss_state[CGROUP_PREFORK_COUNT])
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5241,8 +5325,14 @@ void cgroup_post_fork(struct task_struct *child)
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
 	 */
-	for_each_subsys_which(need_fork_callback, ss, i)
-		ss->fork(child);
+	for_each_subsys_which(need_fork_callback, ss, i) {
+		void *state = NULL;
+
+		if (CGROUP_PREFORK_START <= i && i < CGROUP_PREFORK_END)
+			state = old_ss_state[i - CGROUP_PREFORK_START];
+
+		ss->fork(child, state);
+	}
 }
 
 /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 92b98cc..f1b30ad 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -203,7 +203,7 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
  * to do anything as freezer_attach() will put @task into the appropriate
  * state.
  */
-static void freezer_fork(struct task_struct *task)
+static void freezer_fork(struct task_struct *task, void *private)
 {
 	struct freezer *freezer;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cf65139..8281370 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1196,6 +1196,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	void *ss_state[CGROUP_PREFORK_COUNT] = {};
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1468,6 +1469,18 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
+	retval = cgroup_can_fork(p, ss_state);
+	if (retval)
+		goto bad_fork_free_pid;
+
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
@@ -1504,7 +1517,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cancel_cgroup;
 	}
 
 	if (likely(p->pid)) {
@@ -1546,7 +1559,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, ss_state);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
@@ -1556,6 +1569,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cancel_cgroup:
+	cgroup_cancel_fork(p, ss_state);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 62671f5..205b1cf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7988,7 +7988,7 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
-static void cpu_cgroup_fork(struct task_struct *task)
+static void cpu_cgroup_fork(struct task_struct *task, void *private)
 {
 	sched_move_task(task);
 }
-- 
2.3.5
