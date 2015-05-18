From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 6/8] cgroup: allow a cgroup subsystem to reject a fork
Date: Tue, 19 May 2015 00:51:05 +1000
Message-ID: <1431960667-26593-7-git-send-email-cyphar@cyphar.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431960667-26593-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
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

Also add a tagging system for cgroup_subsys.h to allow for CGROUP_<TAG>
enumerations to be be defined and used. Also explicitly add a
CGROUP_CANFORK_COUNT macro to make arrays easier to define.

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h        | 27 ++++++++++++--
 include/linux/cgroup_subsys.h | 17 +++++++++
 kernel/cgroup.c               | 84 +++++++++++++++++++++++++++++++++++++++++--
 kernel/cgroup_freezer.c       |  2 +-
 kernel/fork.c                 | 17 +++++++--
 kernel/sched/core.c           |  2 +-
 6 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 35ba593..886a883 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -28,11 +28,16 @@
 /* define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _cgrp_id,
 enum cgroup_subsys_id {
+#define SUBSYS_TAG(_t) CGROUP_ ## _t, \
+	__unused_tag_ ## _t = CGROUP_ ## _t - 1,
 #include <linux/cgroup_subsys.h>
+#undef SUBSYS_TAG
 	CGROUP_SUBSYS_COUNT,
 };
 #undef SUBSYS
 
+#define CGROUP_CANFORK_COUNT (CGROUP_CANFORK_END - CGROUP_CANFORK_START)
+
 struct cgroup_root;
 struct cgroup_subsys;
 struct cgroup;
@@ -40,7 +45,12 @@ struct cgroup;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p,
+			   void *ss_private[CGROUP_CANFORK_COUNT]);
+extern void cgroup_cancel_fork(struct task_struct *p,
+			       void *ss_private[CGROUP_CANFORK_COUNT]);
+extern void cgroup_post_fork(struct task_struct *p,
+			     void *old_ss_private[CGROUP_CANFORK_COUNT]);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -649,7 +659,9 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
-	void (*fork)(struct task_struct *task);
+	int (*can_fork)(struct task_struct *task, void **privatep);
+	void (*cancel_fork)(struct task_struct *task, void *private);
+	void (*fork)(struct task_struct *task, void *private);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
 		     struct task_struct *task);
@@ -970,10 +982,19 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 
 struct cgroup_subsys_state;
 
+#define CGROUP_CANFORK_COUNT 0
+
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p,
+				  void *ss_private[CGROUP_CANFORK_COUNT])
+{ return 0; }
+static inline void cgroup_cancel_fork(struct task_struct *p,
+				      void *ss_private[CGROUP_CANFORK_COUNT]) {}
+static inline void cgroup_post_fork(struct task_struct *p,
+				    void *ss_private[CGROUP_CANFORK_COUNT]) {}
+
 static inline void cgroup_exit(struct task_struct *p) {}
 
 static inline int cgroupstats_build(struct cgroupstats *stats,
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e4a96fb..81b7bdd 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -3,6 +3,11 @@
  *
  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
+#ifndef SUBSYS_TAG
+#	define __TMP_SUBSYS_TAG
+#	define SUBSYS_TAG(_x)
+#endif
+
 #if IS_ENABLED(CONFIG_CPUSETS)
 SUBSYS(cpuset)
 #endif
@@ -48,11 +53,23 @@ SUBSYS(hugetlb)
 #endif
 
 /*
+ * Subsystems that implement the can_fork() family of callbacks.
+ */
+SUBSYS_TAG(CANFORK_START)
+SUBSYS_TAG(CANFORK_END)
+
+/*
  * The following subsystems are not supported on the default hierarchy.
  */
 #if IS_ENABLED(CONFIG_CGROUP_DEBUG)
 SUBSYS(debug)
 #endif
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
index a9dfdf3..ce54b78 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -183,6 +183,9 @@ static u64 css_serial_nr_next = 1;
 static unsigned long have_fork_callback __read_mostly;
 static unsigned long have_exit_callback __read_mostly;
 
+/* Ditto for the can_fork callback. */
+static unsigned long have_canfork_callback __read_mostly;
+
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -2324,9 +2327,10 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 	 */
 	tset.csets = &tset.dst_csets;
 
-	for_each_e_css(css, i, cgrp)
+	for_each_e_css(css, i, cgrp) {
 		if (css->ss->attach)
 			css->ss->attach(css, &tset);
+	}
 
 	ret = 0;
 	goto out_release_tset;
@@ -4939,6 +4943,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	have_fork_callback |= (bool)ss->fork << ss->id;
 	have_exit_callback |= (bool)ss->exit << ss->id;
+	have_canfork_callback |= (bool)ss->can_fork << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5180,6 +5185,23 @@ static const struct file_operations proc_cgroupstats_operations = {
 	.release = single_release,
 };
 
+static void **subsys_canfork_privatep(void *ss_private[CGROUP_CANFORK_COUNT],
+				      int i)
+{
+	if (CGROUP_CANFORK_START <= i && i < CGROUP_CANFORK_END)
+		return &ss_private[i - CGROUP_CANFORK_START];
+	return NULL;
+}
+
+static void *subsys_canfork_private(void *ss_private[CGROUP_CANFORK_COUNT],
+				    int i)
+{
+	void **private;
+	if ((private = subsys_canfork_privatep(ss_private, i)) != NULL)
+		return *private;
+	return NULL;
+}
+
 /**
  * cgroup_fork - initialize cgroup related fields during copy_process()
  * @child: pointer to task_struct of forking parent process.
@@ -5195,6 +5217,61 @@ void cgroup_fork(struct task_struct *child)
 }
 
 /**
+ * cgroup_can_fork - called on a new task before the process is exposed
+ * @child: the task in question.
+ *
+ * This calls the subsystem can_fork() callbacks. If the can_fork() callback
+ * returns an error, the fork aborts with that error code. This allows for
+ * a cgroup subsystem to conditionally allow or deny new forks.
+ */
+int cgroup_can_fork(struct task_struct *child,
+		    void *ss_private[CGROUP_CANFORK_COUNT])
+{
+	struct cgroup_subsys *ss;
+	int i, j, retval;
+
+	for_each_subsys_which(ss, i, &have_canfork_callback) {
+		retval = ss->can_fork(child,
+				      subsys_canfork_privatep(ss_private, i));
+		if (retval)
+			goto out_revert;
+	}
+
+	return 0;
+
+out_revert:
+	for_each_subsys(ss, j) {
+		if (j >= i)
+			break;
+
+		if (ss->cancel_fork)
+			ss->cancel_fork(child,
+					subsys_canfork_private(ss_private, j));
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
+			void *ss_private[CGROUP_CANFORK_COUNT])
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	for_each_subsys(ss, i)
+		if(ss->cancel_fork)
+			ss->cancel_fork(child,
+					subsys_canfork_private(ss_private, i));
+}
+
+/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
@@ -5204,7 +5281,8 @@ void cgroup_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child,
+		      void *old_ss_private[CGROUP_CANFORK_COUNT])
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5249,7 +5327,7 @@ void cgroup_post_fork(struct task_struct *child)
 	 * and addition to css_set.
 	 */
 	for_each_subsys_which(ss, i, &have_fork_callback)
-		ss->fork(child);
+		ss->fork(child, subsys_canfork_private(old_ss_private, i));
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
index 03c1eaa..7377698 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1245,6 +1245,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	void *cgrp_ss_private[CGROUP_CANFORK_COUNT] = {};
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1516,6 +1517,16 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->task_works = NULL;
 
 	/*
+	 * Ensure that the cgroup subsystem policies allow the new process to be
+	 * forked. It should be noted the the new process's css_set can be changed
+	 * between here and cgroup_post_fork() if an organisation operation is in
+	 * progress.
+	 */
+	retval = cgroup_can_fork(p, cgrp_ss_private);
+	if (retval)
+		goto bad_fork_free_pid;
+
+	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
 	 */
@@ -1551,7 +1562,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cancel_cgroup;
 	}
 
 	if (likely(p->pid)) {
@@ -1593,7 +1604,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, cgrp_ss_private);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
@@ -1603,6 +1614,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cancel_cgroup:
+	cgroup_cancel_fork(p, cgrp_ss_private);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f9123a8..050936e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8007,7 +8007,7 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
-static void cpu_cgroup_fork(struct task_struct *task)
+static void cpu_cgroup_fork(struct task_struct *task, void *private)
 {
 	sched_move_task(task);
 }
-- 
2.4.1
