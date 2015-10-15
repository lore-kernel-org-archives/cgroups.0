From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 11/14] cgroup: don't hold css_set_rwsem across css task
 iteration
Date: Wed, 14 Oct 2015 21:35:39 -0400
Message-ID: <20151015013539.GB20884@htj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <1444570210-15640-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jzKN0ndPa+QnO0Bgnk68aqVVIZ8lzQlzYyokg99z2HI=;
        b=XMNEl9Ry3ztgPl2q0csPapNoYJCyMsfUWqWhxOGm7oh+x6QSN/610QZ/GJVYOvQum6
         pa6SBSq8b4aIeLLkp+MezI2UzYWBgcRKpRJWPe2Ds1xsqOsq67t5iWFtbOJv0Tz/piqj
         0nDM+20c2eD8WhJwsVENOQJblxc1WkQ5g4vlb1kJCnOngw704AD/UTdDuBNglJEX1Dt/
         rwgnc1+HAq1vLL8m5O6YX3UDb9kE5bf5DBP7cQG9KnOFTq7DSb06xlsH6+XFSJqHAxh8
         cK5Gbf4LTSKehnAGfS1tDsLS5d5MadiqyzkG/tjrPnZvjPt5oGCAcFLcpJZJ7r7lFVlz
         K/3Q==
Content-Disposition: inline
In-Reply-To: <1444570210-15640-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com

From 5cd30f075f6c8e3d68852661d317ffd1f26f96f9 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 14 Oct 2015 21:31:41 -0400

css_sets are synchronized through css_set_rwsem but the locking scheme
is kinda bizarre.  The hot paths - fork and exit - have to write lock
the rwsem making the rw part pointless; furthermore, many readers
already hold cgroup_mutex.

One of the readers is css task iteration.  It read locks the rwsem
over the entire duration of iteration.  This leads to silly locking
behavior.  When cpuset tries to migrate processes of a cgroup to a
different NUMA node, css_set_rwsem is held across the entire migration
attempt which can take a long time locking out forking, exiting and
other cgroup operations.

This patch updates css task iteration so that it locks css_set_rwsem
only while the iterator is being advanced.  css task iteration
involves two levels - css_set and task iteration.  As css_sets in use
are practically immutable, simply pinning the current one is enough
for resuming iteration afterwards.  Task iteration is tricky as tasks
may leave their css_set while iteration is in progress.  This is
solved by keeping track of active iterators and advancing them if
their next task leaves its css_set.

v2: put_task_struct() in css_task_iter_next() moved outside
    css_set_rwsem.  A later patch will add cgroup operations to
    task_struct free path which may grab the same lock and this avoids
    deadlock possibilities.

    css_set_move_task() updated to use list_for_each_entry_safe() when
    walking task_iters and advancing them.  This is necessary as
    advancing an iter may remove it from the list.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  3 ++
 include/linux/cgroup.h      |  4 +++
 kernel/cgroup.c             | 87 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 80 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1744450..62413c3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -211,6 +211,9 @@ struct css_set {
 	 */
 	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
 
+	/* all css_task_iters currently walking this cset */
+	struct list_head task_iters;
+
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
 };
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index bdfdb3a..a9dcf0e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -42,6 +42,10 @@ struct css_task_iter {
 	struct list_head		*task_pos;
 	struct list_head		*tasks_head;
 	struct list_head		*mg_tasks_head;
+
+	struct css_set			*cur_cset;
+	struct task_struct		*cur_task;
+	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
 extern struct cgroup_root cgrp_dfl_root;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 56e2b77..0c5b0e6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -216,6 +216,7 @@ static struct cftype cgroup_legacy_base_files[];
 
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned long ss_mask);
+static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 		      bool visible);
@@ -593,6 +594,7 @@ struct css_set init_css_set = {
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
+	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 };
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
@@ -675,8 +677,9 @@ static void css_set_update_populated(struct css_set *cset, bool populated)
  * css_set, @from_cset can be NULL.  If @task is being disassociated
  * instead of moved, @to_cset can be NULL.
  *
- * This function automatically handles populated_cnt updates but the caller
- * is responsible for managing @from_cset and @to_cset's reference counts.
+ * This function automatically handles populated_cnt updates and
+ * css_task_iter adjustments but the caller is responsible for managing
+ * @from_cset and @to_cset's reference counts.
  */
 static void css_set_move_task(struct task_struct *task,
 			      struct css_set *from_cset, struct css_set *to_cset,
@@ -685,7 +688,22 @@ static void css_set_move_task(struct task_struct *task,
 	lockdep_assert_held(&css_set_rwsem);
 
 	if (from_cset) {
+		struct css_task_iter *it, *pos;
+
 		WARN_ON_ONCE(list_empty(&task->cg_list));
+
+		/*
+		 * @task is leaving, advance task iterators which are
+		 * pointing to it so that they can resume at the next
+		 * position.  Advancing an iterator might remove it from
+		 * the list, use safe walk.  See css_task_iter_advance*()
+		 * for details.
+		 */
+		list_for_each_entry_safe(it, pos, &from_cset->task_iters,
+					 iters_node)
+			if (it->task_pos == &task->cg_list)
+				css_task_iter_advance(it);
+
 		list_del_init(&task->cg_list);
 		if (!css_set_populated(from_cset))
 			css_set_update_populated(from_cset, false);
@@ -1019,6 +1037,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	INIT_LIST_HEAD(&cset->mg_tasks);
 	INIT_LIST_HEAD(&cset->mg_preload_node);
 	INIT_LIST_HEAD(&cset->mg_node);
+	INIT_LIST_HEAD(&cset->task_iters);
 	INIT_HLIST_NODE(&cset->hlist);
 
 	/* Copy the set of subsystem state objects generated in
@@ -3804,6 +3823,8 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
 
+	lockdep_assert_held(&css_set_rwsem);
+
 	/* Advance to the next non-empty css_set */
 	do {
 		l = l->next;
@@ -3831,12 +3852,36 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
 
 	it->tasks_head = &cset->tasks;
 	it->mg_tasks_head = &cset->mg_tasks;
+
+	/*
+	 * We don't keep css_sets locked across iteration steps and thus
+	 * need to take steps to ensure that iteration can be resumed after
+	 * the lock is re-acquired.  Iteration is performed at two levels -
+	 * css_sets and tasks in them.
+	 *
+	 * Once created, a css_set never leaves its cgroup lists, so a
+	 * pinned css_set is guaranteed to stay put and we can resume
+	 * iteration afterwards.
+	 *
+	 * Tasks may leave @cset across iteration steps.  This is resolved
+	 * by registering each iterator with the css_set currently being
+	 * walked and making css_set_move_task() advance iterators whose
+	 * next task is leaving.
+	 */
+	if (it->cur_cset) {
+		list_del(&it->iters_node);
+		put_css_set_locked(it->cur_cset);
+	}
+	get_css_set(cset);
+	it->cur_cset = cset;
+	list_add(&it->iters_node, &cset->task_iters);
 }
 
 static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct list_head *l = it->task_pos;
 
+	lockdep_assert_held(&css_set_rwsem);
 	WARN_ON_ONCE(!l);
 
 	/*
@@ -3864,19 +3909,16 @@ static void css_task_iter_advance(struct css_task_iter *it)
  * css_task_iter_next() to walk through the tasks until the function
  * returns NULL.  On completion of iteration, css_task_iter_end() must be
  * called.
- *
- * Note that this function acquires a lock which is released when the
- * iteration finishes.  The caller can't sleep while iteration is in
- * progress.
  */
 void css_task_iter_start(struct cgroup_subsys_state *css,
 			 struct css_task_iter *it)
-	__acquires(css_set_rwsem)
 {
 	/* no one should try to iterate before mounting cgroups */
 	WARN_ON_ONCE(!use_task_css_set_links);
 
-	down_read(&css_set_rwsem);
+	memset(it, 0, sizeof(*it));
+
+	down_write(&css_set_rwsem);
 
 	it->ss = css->ss;
 
@@ -3888,6 +3930,8 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 	it->cset_head = it->cset_pos;
 
 	css_task_iter_advance_css_set(it);
+
+	up_write(&css_set_rwsem);
 }
 
 /**
@@ -3900,14 +3944,22 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
  */
 struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
-	struct task_struct *res;
-
 	if (!it->cset_pos)
 		return NULL;
 
-	res = list_entry(it->task_pos, struct task_struct, cg_list);
+	if (it->cur_task)
+		put_task_struct(it->cur_task);
+
+	down_write(&css_set_rwsem);
+
+	it->cur_task = list_entry(it->task_pos, struct task_struct, cg_list);
+	get_task_struct(it->cur_task);
+
 	css_task_iter_advance(it);
-	return res;
+
+	up_write(&css_set_rwsem);
+
+	return it->cur_task;
 }
 
 /**
@@ -3917,9 +3969,16 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
  * Finish task iteration started by css_task_iter_start().
  */
 void css_task_iter_end(struct css_task_iter *it)
-	__releases(css_set_rwsem)
 {
-	up_read(&css_set_rwsem);
+	if (it->cur_cset) {
+		down_write(&css_set_rwsem);
+		list_del(&it->iters_node);
+		put_css_set_locked(it->cur_cset);
+		up_write(&css_set_rwsem);
+	}
+
+	if (it->cur_task)
+		put_task_struct(it->cur_task);
 }
 
 /**
-- 
2.4.3
