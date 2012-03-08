From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH] cgroup: fix race between fork and cgroup freezing
Date: Thu, 08 Mar 2012 16:45:13 +0800
Message-ID: <4F587199.6050404@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?57yqIOWLsA==?= <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

A similar bug exists in cpuset, and those are long-standing bugs.

As reported by Frederic:

> When a user freezes a cgroup, the freezer sets the subsystem state
> to CGROUP_FREEZING and then iterates over the tasks in the cgroup links.
> 
> But there is a possible race here, although unlikely, if a task
> forks and the parent is preempted between write_unlock(tasklist_lock)
> and cgroup_post_fork(). If we freeze the cgroup while the parent
> is sleeping and the parent wakes up thereafter, its child will
> be missing from the set of tasks to freeze because:
> 
> - The child was not yet linked to its css_set->tasks, as is done
> from cgroup_post_fork(). cgroup_iter_start() has thus missed it.
> 
> - The cgroup freezer's fork callback can handle that child but
> cgroup_fork_callbacks() has been called already.

I try to fix it by using seqcount. We read the counter before calling
cgroup_fork_callbacks(), and we check the counter after cgroup_post_fork().
If the seq numbers don't match, we know the forking task's cgroup
has been/is being frozen, so we freeze the child task.

cpuset can be fixed accordingly.

Reported-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h    |    5 +++--
 include/linux/init_task.h |    8 ++++++++
 include/linux/sched.h     |    1 +
 kernel/cgroup.c           |   18 ++++++++++++++++--
 kernel/cgroup_freezer.c   |   22 ++++++++++++++++++++++
 kernel/fork.c             |    5 +++--
 6 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9b6021..38c82b2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,8 +32,8 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern void cgroup_fork_callbacks(struct task_struct *p, int *seq);
+extern void cgroup_post_fork(struct task_struct *p, int seq);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -495,6 +495,7 @@ struct cgroup_subsys {
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup_taskset *tset);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
+	void (*post_fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 9c66b1a..91665ce 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -125,6 +125,13 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_CGROUPS
+# define INIT_CGROUPS(tsk)						\
+	.fork_seq = SEQCNT_ZERO
+#else
+# define INIT_CGROUPS(tsk)
+#endif
+
 #define INIT_TASK_COMM "swapper"
 
 /*
@@ -192,6 +199,7 @@ extern struct cred init_cred;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_CGROUPS(tsk)						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..d487777 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1507,6 +1507,7 @@ struct task_struct {
 	struct css_set __rcu *cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
+	seqcount_t fork_seq;
 #endif
 #ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..77435ec 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -60,6 +60,7 @@
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/seqlock.h>
 
 #include <linux/atomic.h>
 
@@ -4558,6 +4559,7 @@ void cgroup_fork(struct task_struct *child)
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
 	INIT_LIST_HEAD(&child->cg_list);
+	seqcount_init(&child->fork_seq);
 }
 
 /**
@@ -4568,8 +4570,10 @@ void cgroup_fork(struct task_struct *child)
  * tasklist. No need to take any locks since no-one can
  * be operating on this task.
  */
-void cgroup_fork_callbacks(struct task_struct *child)
+void cgroup_fork_callbacks(struct task_struct *child, int *seq)
 {
+	*seq = read_seqcount_begin(&current->fork_seq);
+
 	if (need_forkexit_callback) {
 		int i;
 		/*
@@ -4594,7 +4598,7 @@ void cgroup_fork_callbacks(struct task_struct *child)
  * with the first call to cgroup_iter_start() - to guarantee that the
  * new task ends up on its list.
  */
-void cgroup_post_fork(struct task_struct *child)
+void cgroup_post_fork(struct task_struct *child, int seq)
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
@@ -4612,6 +4616,16 @@ void cgroup_post_fork(struct task_struct *child)
 			list_add(&child->cg_list, &child->cgroups->tasks);
 		}
 		write_unlock(&css_set_lock);
+
+		if (read_seqcount_retry(&current->fork_seq, seq)) {
+			int i;
+
+			for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+				struct cgroup_subsys *ss = subsys[i];
+				if (ss->post_fork)
+					ss->post_fork(ss, child);
+			}
+		}
 	}
 }
 /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index fc0646b..88f210e 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -216,6 +216,25 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	spin_unlock_irq(&freezer->lock);
 }
 
+static void freezer_post_fork(struct cgroup_subsys *ss,
+			      struct task_struct *task)
+{
+	struct freezer *freezer;
+
+	cgroup_lock();
+
+	freezer = task_freezer(task);
+	if (!freezer->css.cgroup->parent)
+		goto out;
+
+	spin_lock_irq(&freezer->lock);
+	if (freezer->state != CGROUP_THAWED)
+		freeze_task(task);
+	spin_unlock_irq(&freezer->lock);
+out:
+	cgroup_unlock();
+}
+
 /*
  * caller must hold freezer->lock
  */
@@ -286,6 +305,8 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
+
+		write_seqcount_barrier(&task->fork_seq);
 	}
 	cgroup_iter_end(cgroup, &it);
 
@@ -381,4 +402,5 @@ struct cgroup_subsys freezer_subsys = {
 	.subsys_id	= freezer_subsys_id,
 	.can_attach	= freezer_can_attach,
 	.fork		= freezer_fork,
+	.post_fork	= freezer_post_fork,
 };
diff --git a/kernel/fork.c b/kernel/fork.c
index e2cd3e2..73abc25 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1077,6 +1077,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	int seq;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1331,7 +1332,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
+	cgroup_fork_callbacks(p, &seq);
 	cgroup_callbacks_done = 1;
 
 	/* Need tasklist lock for parent etc handling! */
@@ -1395,7 +1396,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	cgroup_post_fork(p, seq);
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
