From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v4 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Fri,  6 Mar 2015 12:45:56 +1100
Message-ID: <1425606357-6337-2-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

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

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup.h |  9 ++++++
 kernel/cgroup.c        | 82 ++++++++++++++++++++++++++++++++++++++++----------
 kernel/fork.c          | 12 +++++++-
 3 files changed, 86 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b9cb94c..43ed1ee 100644
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
@@ -948,6 +952,11 @@ struct cgroup_subsys_state;
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
index 29a7b2c..378badb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -182,6 +182,9 @@ static u64 css_serial_nr_next = 1;
  */
 static int need_forkexit_callback __read_mostly;
 
+/* Ditto for the can_fork/cancel_fork callbacks. */
+static int need_canfork_callback __read_mostly;
+
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
@@ -4933,6 +4936,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	init_css_set.subsys[ss->id] = css;
 
 	need_forkexit_callback |= ss->fork || ss->exit;
+	need_canfork_callback |= ss->can_fork || ss->cancel_fork;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5183,22 +5187,6 @@ void cgroup_fork(struct task_struct *child)
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
@@ -5233,6 +5221,68 @@ void cgroup_post_fork(struct task_struct *child)
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
+	if (need_canfork_callback) {
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
+	if (need_canfork_callback) {
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
index cf65139..35850a9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1469,6 +1469,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
@@ -1504,7 +1512,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_cgroup_cancel;
 	}
 
 	if (likely(p->pid)) {
@@ -1556,6 +1564,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	return p;
 
+bad_fork_cgroup_cancel:
+	cgroup_cancel_fork(p);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
-- 
2.3.1
