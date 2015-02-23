From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RFC 1/2] cgroups: allow a cgroup subsystem to reject a fork
Date: Mon, 23 Feb 2015 14:08:10 +1100
Message-ID: <1424660891-12719-2-git-send-email-cyphar@cyphar.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

NOTE: I'm not sure if I'm doing enough cleanup inside copy_process(),
because a bunch of stuff happens between the last valid goto to the
bad_fork_free_pid label and cgroup_post_fork().

What is the correct way of doing cleanup this late inside
copy_process()?

8<----------------------------------------------------------------------

Make the cgroup subsystem post fork callback return an error code so
that subsystems can accept or reject a fork from completing with a
custom error value.

This is in preparation for implementing the numtasks cgroup scope.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup.h  |  9 ++++++---
 kernel/cgroup.c         | 13 ++++++++++---
 kernel/cgroup_freezer.c |  6 ++++--
 kernel/fork.c           |  4 +++-
 kernel/sched/core.c     |  3 ++-
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index da0dae0..91718ff 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -32,7 +32,7 @@ struct cgroup;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_post_fork(struct task_struct *p);
+extern int cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
@@ -649,7 +649,7 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys_state *css,
 		       struct cgroup_taskset *tset);
-	void (*fork)(struct task_struct *task);
+	int (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup_subsys_state *css,
 		     struct cgroup_subsys_state *old_css,
 		     struct task_struct *task);
@@ -946,7 +946,10 @@ struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_post_fork(struct task_struct *p) {}
+static inline int cgroup_post_fork(struct task_struct *p)
+{
+	return 0;
+}
 static inline void cgroup_exit(struct task_struct *p) {}
 
 static inline int cgroupstats_build(struct cgroupstats *stats,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 04cfe8a..82ecb6f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5191,7 +5191,7 @@ void cgroup_fork(struct task_struct *child)
  * cgroup_task_iter_start() - to guarantee that the new task ends up on its
  * list.
  */
-void cgroup_post_fork(struct task_struct *child)
+int cgroup_post_fork(struct task_struct *child)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -5236,10 +5236,17 @@ void cgroup_post_fork(struct task_struct *child)
 	 * and addition to css_set.
 	 */
 	if (need_forkexit_callback) {
+		int ret;
+
 		for_each_subsys(ss, i)
-			if (ss->fork)
-				ss->fork(child);
+			if (ss->fork) {
+				ret = ss->fork(child);
+				if (ret)
+					return ret;
+			}
 	}
+
+	return 0;
 }
 
 /**
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 92b98cc..f5906b7 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -203,7 +203,7 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
  * to do anything as freezer_attach() will put @task into the appropriate
  * state.
  */
-static void freezer_fork(struct task_struct *task)
+static int freezer_fork(struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -215,7 +215,7 @@ static void freezer_fork(struct task_struct *task)
 	 * right thing to do.
 	 */
 	if (task_css_is_root(task, freezer_cgrp_id))
-		return;
+		return 0;
 
 	mutex_lock(&freezer_mutex);
 	rcu_read_lock();
@@ -226,6 +226,8 @@ static void freezer_fork(struct task_struct *task)
 
 	rcu_read_unlock();
 	mutex_unlock(&freezer_mutex);
+
+	return 0;
 }
 
 /**
diff --git a/kernel/fork.c b/kernel/fork.c
index 4dc2dda..ff12e23 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1541,7 +1541,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	cgroup_post_fork(p);
+	retval = cgroup_post_fork(p);
+	if (retval)
+		goto bad_fork_free_pid;
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
 	perf_event_fork(p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5eab11d..9b9f970 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8010,9 +8010,10 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
 	sched_offline_group(tg);
 }
 
-static void cpu_cgroup_fork(struct task_struct *task)
+static int cpu_cgroup_fork(struct task_struct *task)
 {
 	sched_move_task(task);
+	return 0;
 }
 
 static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
-- 
2.3.0
