From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] cgroup: factor out css_set_move_task()
Date: Fri,  9 Oct 2015 23:29:36 -0400
Message-ID: <1444447781-16182-10-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Cbg7oYYxZ7i2KGpKOPtZrBGDfywuNp7CAmAYNj8eYc=;
        b=KjD4/MKUwmctz1Eg4B1j+XIBp1G/zkgaca+VUXcTvtTSmbyr2KGX/jf6eC6uiyxrqv
         3BoGicASqnsJ4Wi1BSlfj2xpwyvlf0fz1i3/B+DHmkEVmMFwcruQ2zDsUfiRLRelF6G+
         X5lbEbyQSvX3YEfYhsuV4mbEqn8SzGW1j77nNHV0YbEAdEaKbb/8GSOxx9XN7BwVyIz6
         QFTdtq9Ac9EIlnAZij9SC0CEUvDy+FKT2iQE5RSchlv9UkN5g1CgTSdoYQ+lzuTEGT8L
         QfOStND6t74nRvYLHamIYHjVOXq3vnk5Dyid3FoiEMQjZB4+sMBwfz06IeF4zfOJztMB
         jZzw==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

A task is associated and disassociated with its css_set in three
places - during migration, after a new task is created and when a task
exits.  The first is handled by cgroup_task_migrate() and the latter
two are open-coded.

These are similar operations and spreading them over multiple places
makes it harder to follow and update.  This patch collects all task
css_set [dis]association operations into css_set_move_task().

While css_set_move_task() may check whether populated state needs to
be updated when not strictly necessary, the behavior is essentially
equivalent before and after this patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 104 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5cb28d2..4e239e4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -664,6 +664,52 @@ static void css_set_update_populated(struct css_set *cset, bool populated)
 		cgroup_update_populated(link->cgrp, populated);
 }
 
+/**
+ * css_set_move_task - move a task from one css_set to another
+ * @task: task being moved
+ * @from_cset: css_set @task currently belongs to (may be NULL)
+ * @to_cset: new css_set @task is being moved to (may be NULL)
+ * @use_mg_tasks: move to @to_cset->mg_tasks instead of ->tasks
+ *
+ * Move @task from @from_cset to @to_cset.  If @task didn't belong to any
+ * css_set, @from_cset can be NULL.  If @task is being disassociated
+ * instead of moved, @to_cset can be NULL.
+ *
+ * This function automatically handles populated_cnt updates but the caller
+ * is responsible for managing @from_cset and @to_cset's reference counts.
+ */
+static void css_set_move_task(struct task_struct *task,
+			      struct css_set *from_cset, struct css_set *to_cset,
+			      bool use_mg_tasks)
+{
+	lockdep_assert_held(&css_set_rwsem);
+
+	if (from_cset) {
+		WARN_ON_ONCE(list_empty(&task->cg_list));
+		list_del_init(&task->cg_list);
+		if (!css_set_populated(from_cset))
+			css_set_update_populated(from_cset, false);
+	} else {
+		WARN_ON_ONCE(!list_empty(&task->cg_list));
+	}
+
+	if (to_cset) {
+		/*
+		 * We are synchronized through cgroup_threadgroup_rwsem
+		 * against PF_EXITING setting such that we can't race
+		 * against cgroup_exit() changing the css_set to
+		 * init_css_set and dropping the old one.
+		 */
+		WARN_ON_ONCE(task->flags & PF_EXITING);
+
+		if (!css_set_populated(to_cset))
+			css_set_update_populated(to_cset, true);
+		rcu_assign_pointer(task->cgroups, to_cset);
+		list_add_tail(&task->cg_list, use_mg_tasks ? &to_cset->mg_tasks :
+							     &to_cset->tasks);
+	}
+}
+
 /*
  * hash table for cgroup groups. This improves the performance to find
  * an existing css_set. This hash doesn't (currently) take into
@@ -2260,47 +2306,6 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 }
 
 /**
- * cgroup_task_migrate - move a task from one cgroup to another.
- * @tsk: the task being migrated
- * @new_cset: the new css_set @tsk is being attached to
- *
- * Must be called with cgroup_mutex, threadgroup and css_set_rwsem locked.
- */
-static void cgroup_task_migrate(struct task_struct *tsk,
-				struct css_set *new_cset)
-{
-	struct css_set *old_cset;
-
-	lockdep_assert_held(&cgroup_mutex);
-	lockdep_assert_held(&css_set_rwsem);
-
-	/*
-	 * We are synchronized through cgroup_threadgroup_rwsem against
-	 * PF_EXITING setting such that we can't race against cgroup_exit()
-	 * changing the css_set to init_css_set and dropping the old one.
-	 */
-	WARN_ON_ONCE(tsk->flags & PF_EXITING);
-	old_cset = task_css_set(tsk);
-
-	if (!css_set_populated(new_cset))
-		css_set_update_populated(new_cset, true);
-
-	get_css_set(new_cset);
-	rcu_assign_pointer(tsk->cgroups, new_cset);
-	list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
-
-	if (!css_set_populated(old_cset))
-		css_set_update_populated(old_cset, false);
-
-	/*
-	 * We just gained a reference on old_cset by taking it from the
-	 * task. As trading it for new_cset is protected by cgroup_mutex,
-	 * we're safe to drop it here; it will be freed under RCU.
-	 */
-	put_css_set_locked(old_cset);
-}
-
-/**
  * cgroup_taskset_migrate - migrate a taskset to a cgroup
  * @tset: taget taskset
  * @dst_cgrp: destination cgroup
@@ -2340,8 +2345,14 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 */
 	down_write(&css_set_rwsem);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
-		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list)
-			cgroup_task_migrate(task, cset->mg_dst_cset);
+		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
+			struct css_set *from_cset = task_css_set(task);
+			struct css_set *to_cset = cset->mg_dst_cset;
+
+			get_css_set(to_cset);
+			css_set_move_task(task, from_cset, to_cset, true);
+			put_css_set_locked(from_cset);
+		}
 	}
 	up_write(&css_set_rwsem);
 
@@ -5476,9 +5487,8 @@ void cgroup_post_fork(struct task_struct *child,
 		down_write(&css_set_rwsem);
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
-			rcu_assign_pointer(child->cgroups, cset);
-			list_add_tail(&child->cg_list, &cset->tasks);
 			get_css_set(cset);
+			css_set_move_task(child, NULL, cset, false);
 		}
 		up_write(&css_set_rwsem);
 	}
@@ -5526,9 +5536,7 @@ void cgroup_exit(struct task_struct *tsk)
 
 	if (!list_empty(&tsk->cg_list)) {
 		down_write(&css_set_rwsem);
-		list_del_init(&tsk->cg_list);
-		if (!css_set_populated(cset))
-			css_set_update_populated(cset, false);
+		css_set_move_task(tsk, cset, NULL, false);
 		up_write(&css_set_rwsem);
 		put_cset = true;
 	}
-- 
2.4.3
