From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2] cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()
Date: Wed, 13 Mar 2013 09:14:42 +0800
Message-ID: <513FD302.4030504@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

These two functions share most of the code.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

v2: not necessary to move cgroup_attach_task_all()

---
 include/linux/cgroup.h |   3 +-
 kernel/cgroup.c        | 107 +++++++++----------------------------------------
 kernel/cpuset.c        |   2 +-
 3 files changed, 22 insertions(+), 90 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1f75a59..013c6ce 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -691,7 +691,8 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 					struct cgroup_iter *it);
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
-int cgroup_attach_task(struct cgroup *, struct task_struct *);
+int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
+		       bool threadgroup);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4b92b9a..134d3c5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -59,7 +59,7 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/eventfd.h>
 #include <linux/poll.h>
-#include <linux/flex_array.h> /* used in cgroup_attach_proc */
+#include <linux/flex_array.h> /* used in cgroup_attach_task */
 #include <linux/kthread.h>
 
 #include <linux/atomic.h>
@@ -1944,82 +1944,6 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 }
 
 /**
- * cgroup_attach_task - attach task 'tsk' to cgroup 'cgrp'
- * @cgrp: the cgroup the task is attaching to
- * @tsk: the task to be attached
- *
- * Call with cgroup_mutex and threadgroup locked. May take task_lock of
- * @tsk during call.
- */
-int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
-{
-	int retval = 0;
-	struct cgroup_subsys *ss, *failed_ss = NULL;
-	struct cgroup *oldcgrp;
-	struct cgroupfs_root *root = cgrp->root;
-	struct cgroup_taskset tset = { };
-	struct css_set *newcg;
-
-	/* @tsk either already exited or can't exit until the end */
-	if (tsk->flags & PF_EXITING)
-		return -ESRCH;
-
-	/* Nothing to do if the task is already in that cgroup */
-	oldcgrp = task_cgroup_from_root(tsk, root);
-	if (cgrp == oldcgrp)
-		return 0;
-
-	tset.single.task = tsk;
-	tset.single.cgrp = oldcgrp;
-
-	for_each_subsys(root, ss) {
-		if (ss->can_attach) {
-			retval = ss->can_attach(cgrp, &tset);
-			if (retval) {
-				/*
-				 * Remember on which subsystem the can_attach()
-				 * failed, so that we only call cancel_attach()
-				 * against the subsystems whose can_attach()
-				 * succeeded. (See below)
-				 */
-				failed_ss = ss;
-				goto out;
-			}
-		}
-	}
-
-	newcg = find_css_set(tsk->cgroups, cgrp);
-	if (!newcg) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
-
-	for_each_subsys(root, ss) {
-		if (ss->attach)
-			ss->attach(cgrp, &tset);
-	}
-
-out:
-	if (retval) {
-		for_each_subsys(root, ss) {
-			if (ss == failed_ss)
-				/*
-				 * This subsystem was the one that failed the
-				 * can_attach() check earlier, so we don't need
-				 * to call cancel_attach() against it or any
-				 * remaining subsystems.
-				 */
-				break;
-			if (ss->cancel_attach)
-				ss->cancel_attach(cgrp, &tset);
-		}
-	}
-	return retval;
-}
-
-/**
  * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
  * @from: attach to all cgroups of a given task
  * @tsk: the task to be attached
@@ -2033,7 +1957,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	for_each_active_root(root) {
 		struct cgroup *from_cg = task_cgroup_from_root(from, root);
 
-		retval = cgroup_attach_task(from_cg, tsk);
+		retval = cgroup_attach_task(from_cg, tsk, false);
 		if (retval)
 			break;
 	}
@@ -2044,21 +1968,22 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
 /**
- * cgroup_attach_proc - attach all threads in a threadgroup to a cgroup
+ * cgroup_attach_task - attach a task or a whole threadgroup to a cgroup
  * @cgrp: the cgroup to attach to
- * @leader: the threadgroup leader task_struct of the group to be attached
+ * @tsk: the task or the leader of the threadgroup to be attached
+ * @threadgroup: attach the whole threadgroup?
  *
  * Call holding cgroup_mutex and the group_rwsem of the leader. Will take
  * task_lock of each thread in leader's threadgroup individually in turn.
  */
-static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
+int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
+		       bool threadgroup)
 {
 	int retval, i, group_size;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
-	/* guaranteed to be initialized later, but the compiler needs this */
 	struct cgroupfs_root *root = cgrp->root;
 	/* threadgroup list cursor and array */
-	struct task_struct *tsk;
+	struct task_struct *leader = tsk;
 	struct task_and_cgroup *tc;
 	struct flex_array *group;
 	struct cgroup_taskset tset = { };
@@ -2070,7 +1995,10 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 * group - group_rwsem prevents new threads from appearing, and if
 	 * threads exit, this will just be an over-estimate.
 	 */
-	group_size = get_nr_threads(leader);
+	if (threadgroup)
+		group_size = get_nr_threads(tsk);
+	else
+		group_size = 1;
 	/* flex_array supports very large thread-groups better than kmalloc. */
 	group = flex_array_alloc(sizeof(*tc), group_size, GFP_KERNEL);
 	if (!group)
@@ -2080,7 +2008,6 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (retval)
 		goto out_free_group_list;
 
-	tsk = leader;
 	i = 0;
 	/*
 	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
@@ -2109,6 +2036,9 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
+
+		if (!threadgroup)
+			break;
 	} while_each_thread(leader, tsk);
 	rcu_read_unlock();
 	/* remember the number of threads in the array for later. */
@@ -2262,9 +2192,10 @@ retry_find_task:
 			put_task_struct(tsk);
 			goto retry_find_task;
 		}
-		ret = cgroup_attach_proc(cgrp, tsk);
-	} else
-		ret = cgroup_attach_task(cgrp, tsk);
+	}
+
+	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
+
 	threadgroup_unlock(tsk);
 
 	put_task_struct(tsk);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ace5bfc..c55763b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2008,7 +2008,7 @@ static void cpuset_do_move_task(struct task_struct *tsk,
 	struct cgroup *new_cgroup = scan->data;
 
 	cgroup_lock();
-	cgroup_attach_task(new_cgroup, tsk);
+	cgroup_attach_task(new_cgroup, tsk, false);
 	cgroup_unlock();
 }
 
-- 
1.8.0.2
