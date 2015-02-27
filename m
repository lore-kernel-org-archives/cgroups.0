From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri, 27 Feb 2015 15:17:18 +1100
Message-ID: <1425010639-16492-2-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425010639-16492-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425010639-16492-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Add a new cgroup subsystem callback can_fork that conditionally
states whether or not the fork is accepted or rejected with a cgroup
policy.

Make the cgroup subsystem can_fork callback return an error code so
that subsystems can accept or reject a fork from completing with a
custom error value, before the process is exposed.

In addition, add a cancel_fork callback so that if an error occurs later
in the forking process, any state modified by can_fork can be reverted.

In order for can_fork to deal with a task that has an accurate css_set,
move the css_set updating to cgroup_fork (where it belongs).

This is in preparation for implementing the nproc cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  9 ++++++
 kernel/cgroup.c        | 80 +++++++++++++++++++++++++++++++++++++++-----------
 kernel/fork.c          | 12 +++++++-
 3 files changed, 83 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index da0dae0..9897533 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,6 +32,8 @@ struct cgroup;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
+extern int cgroup_can_fork(struct task_struct *p);
+extern void cgroup_cancel_fork(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
@@ -649,6 +651,8 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
+	int (*can_fork)(struct task_struct *task);
+	void (*cancel_fork)(struct task_struct *task);
 	void (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
@@ -946,6 +950,11 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
+static inline int cgroup_can_fork(struct task_struct *p)
+{
+	return 0;
+}
+static inline void cgroup_cancel_fork(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
 static inline void cgroup_exit(struct task_struct *p) {}
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 04cfe8a..f062350 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4928,7 +4928,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	 * init_css_set is in the subsystem's root cgroup. */
 	init_css_set.subsys[ss->id] = css;
 
-	need_forkexit_callback |= ss->fork || ss->exit;
+	need_forkexit_callback |= ss->can_fork || ss->cancel_fork || ss->fork || ss->exit;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5179,22 +5179,6 @@ void cgroup_fork(struct task_struct *child)
 {
 	RCU_INIT_POINTER(child->cgroups, &init_css_set);
 	INIT_LIST_HEAD(&child->cg_list);
-}
-
-/**
- * cgroup_post_fork - called on a new task after adding it to the task list
- * @child: the task in question
- *
- * Adds the task to the list running through its css_set if necessary and
- * call the subsystem fork() callbacks.  Has to be after the task is
- * visible on the task list in case we race with the first call to
- * cgroup_task_iter_start() - to guarantee that the new task ends up on its
- * list.
- */
-void cgroup_post_fork(struct task_struct *child)
-{
-	struct cgroup_subsys *ss;
-	int i;
 
 	/*
 	 * This may race against cgroup_enable_task_cg_lists().  As that
@@ -5229,6 +5213,68 @@ void cgroup_post_fork(struct task_struct *child)
 		}
 		up_write(&css_set_rwsem);
 	}
+}
+
+/**
+ * cgroup_can_fork - called on a new task before the process is exposed.
+ * @child: the task in question.
+ *
+ * This calls the subsystem can_fork() callbacks. If the can_fork() callback
+ * returns an error, the fork aborts with that error code. This allows for
+ * a cgroup subsystem to conditionally allow or deny new forks.
+ */
+int cgroup_can_fork(struct task_struct *child)
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	if (need_forkexit_callback) {
+		int retval;
+
+		for_each_subsys(ss, i)
+			if (ss->can_fork) {
+				retval = ss->can_fork(child);
+				if (retval)
+					return retval;
+			}
+	}
+
+	return 0;
+}
+
+/**
+ * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
+ * @child: the task in question
+ *
+ * This calls the cancel_fork() callbacks if a fork failed *after*
+ * cgroup_can_fork() succeded.
+ */
+void cgroup_cancel_fork(struct task_struct *child)
+{
+	struct cgroup_subsys *ss;
+	int i;
+
+	if (need_forkexit_callback) {
+		for_each_subsys(ss, i)
+			if (ss->cancel_fork)
+				ss->cancel_fork(child);
+	}
+}
+
+/**
+ * cgroup_post_fork - called on a new task after adding it to the task list
+ * @child: the task in question
+ *
+ * Adds the task to the list running through its css_set if necessary and
+ * call the subsystem fork() callbacks.  Has to be after the task is
+ * visible on the task list in case we race with the first call to
+ * cgroup_task_iter_start() - to guarantee that the new task ends up on its
+ * list.
+ */
+void cgroup_post_fork(struct task_struct *child)
+{
+	struct cgroup_subsys *ss;
+	int i;
 
 	/*
 	 * Call ss->fork().  This must happen after @child is linked on
diff --git a/kernel/fork.c b/kernel/fork.c
index 4dc2dda..e84ce86 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1464,6 +1464,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->task_works = NULL;
 
 	/*
+	 * Ensure that the cgroup subsystem policies allow the new process to be
+	 * forked.
+	 */
+	retval = cgroup_can_fork(p);
+	if (retval)
+		goto bad_fork_free_pid;
+
+	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
 	 */
@@ -1499,7 +1507,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cgroup_cancel;
 	}
 
 	if (likely(p->pid)) {
@@ -1551,6 +1559,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cgroup_cancel:
+	cgroup_cancel_fork(p);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
-- 
2.3.1
