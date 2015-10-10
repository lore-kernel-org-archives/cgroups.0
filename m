From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] cgroup: make cgroup->nr_populated count the number of populated css_sets
Date: Fri,  9 Oct 2015 23:29:29 -0400
Message-ID: <1444447781-16182-3-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6NEfwsQH+ap8jI1vQYVq4ClYGUhO0v8OxyBmYOWw/b0=;
        b=YpgKS6YFCYpr4uj7HiQGV8VD4/J+v0/V7whqypa8AahwDRbpwXnaPl7iwv497nxxMM
         FD8Xl6SaPG1E5AokuAEkaijNl4aVg8SXEAGWY164gYSIs4URsg2+A3BMODxal5PElBEL
         k64ssTXaeRq4owaEx/sd+AYVOjNTSX4Zy6bpQQTjK/w17gjHt+yVyiMooFvrrtM3OYFp
         7U/5DWlt8ODo+dmifyB/N3d9EIPm8mrOoJpRNrYwLRTcIdeu9euIlLCjAveVyfwuR1B4
         52ZFFydNSrd1lziWZwu58/6pNP1HNF2iif64jhRkajZPbYpGa6b2ght344LQw8kJl8l1
         V2tw==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, cgroup->nr_populated counts whether the cgroup has any
css_sets linked to it and the number of children which has non-zero
->nr_populated.  This works because a css_set's refcnt converges with
the number of tasks linked to it and thus there's no css_set linked to
a cgroup if it doesn't have any live tasks.

To help tracking resource usage of zombie tasks, putting the ref of
css_set will be separated from disassociating the task from the
css_set which means that a cgroup may have css_sets linked to it even
when it doesn't have any live tasks.

This patch updates cgroup->nr_populated so that for the cgroup itself
it counts the number of css_sets which have tasks associated with them
so that empty css_sets don't skew the populated test.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  8 +++---
 kernel/cgroup.c             | 65 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index df589a0..1744450 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -232,10 +232,10 @@ struct cgroup {
 	int id;
 
 	/*
-	 * If this cgroup contains any tasks, it contributes one to
-	 * populated_cnt.  All children with non-zero popuplated_cnt of
-	 * their own contribute one.  The count is zero iff there's no task
-	 * in this cgroup or its subtree.
+	 * Each non-empty css_set associated with this cgroup contributes
+	 * one to populated_cnt.  All children with non-zero popuplated_cnt
+	 * of their own contribute one.  The count is zero iff there's no
+	 * task in this cgroup or its subtree.
 	 */
 	int populated_cnt;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 49f30f1..e5231d0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -582,14 +582,25 @@ struct css_set init_css_set = {
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
 /**
+ * css_set_populated - does a css_set contain any tasks?
+ * @cset: target css_set
+ */
+static bool css_set_populated(struct css_set *cset)
+{
+	lockdep_assert_held(&css_set_rwsem);
+
+	return !list_empty(&cset->tasks) || !list_empty(&cset->mg_tasks);
+}
+
+/**
  * cgroup_update_populated - updated populated count of a cgroup
  * @cgrp: the target cgroup
  * @populated: inc or dec populated count
  *
- * @cgrp is either getting the first task (css_set) or losing the last.
- * Update @cgrp->populated_cnt accordingly.  The count is propagated
- * towards root so that a given cgroup's populated_cnt is zero iff the
- * cgroup and all its descendants are empty.
+ * One of the css_sets associated with @cgrp is either getting its first
+ * task or losing the last.  Update @cgrp->populated_cnt accordingly.  The
+ * count is propagated towards root so that a given cgroup's populated_cnt
+ * is zero iff the cgroup and all its descendants don't contain any tasks.
  *
  * @cgrp's interface file "cgroup.populated" is zero if
  * @cgrp->populated_cnt is zero and 1 otherwise.  When @cgrp->populated_cnt
@@ -618,6 +629,24 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 	} while (cgrp);
 }
 
+/**
+ * css_set_update_populated - update populated state of a css_set
+ * @cset: target css_set
+ * @populated: whether @cset is populated or depopulated
+ *
+ * @cset is either getting the first task or losing the last.  Update the
+ * ->populated_cnt of all associated cgroups accordingly.
+ */
+static void css_set_update_populated(struct css_set *cset, bool populated)
+{
+	struct cgrp_cset_link *link;
+
+	lockdep_assert_held(&css_set_rwsem);
+
+	list_for_each_entry(link, &cset->cgrp_links, cgrp_link)
+		cgroup_update_populated(link->cgrp, populated);
+}
+
 /*
  * hash table for cgroup groups. This improves the performance to find
  * an existing css_set. This hash doesn't (currently) take into
@@ -663,10 +692,8 @@ static void put_css_set_locked(struct css_set *cset)
 		list_del(&link->cgrp_link);
 
 		/* @cgrp can't go away while we're holding css_set_rwsem */
-		if (list_empty(&cgrp->cset_links)) {
-			cgroup_update_populated(cgrp, false);
+		if (list_empty(&cgrp->cset_links))
 			check_for_release(cgrp);
-		}
 
 		kfree(link);
 	}
@@ -875,8 +902,6 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	link->cset = cset;
 	link->cgrp = cgrp;
 
-	if (list_empty(&cgrp->cset_links))
-		cgroup_update_populated(cgrp, true);
 	list_move(&link->cset_link, &cgrp->cset_links);
 
 	/*
@@ -1754,6 +1779,8 @@ static void cgroup_enable_task_cg_lists(void)
 		if (!(p->flags & PF_EXITING)) {
 			struct css_set *cset = task_css_set(p);
 
+			if (!css_set_populated(cset))
+				css_set_update_populated(cset, true);
 			list_add(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
@@ -1868,8 +1895,11 @@ static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 	 * objects.
 	 */
 	down_write(&css_set_rwsem);
-	hash_for_each(css_set_table, i, cset, hlist)
+	hash_for_each(css_set_table, i, cset, hlist) {
 		link_css_set(&tmp_links, cset, root_cgrp);
+		if (css_set_populated(cset))
+			cgroup_update_populated(root_cgrp, true);
+	}
 	up_write(&css_set_rwsem);
 
 	BUG_ON(!list_empty(&root_cgrp->self.children));
@@ -2256,10 +2286,16 @@ static void cgroup_task_migrate(struct task_struct *tsk,
 	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	old_cset = task_css_set(tsk);
 
+	if (!css_set_populated(new_cset))
+		css_set_update_populated(new_cset, true);
+
 	get_css_set(new_cset);
 	rcu_assign_pointer(tsk->cgroups, new_cset);
 	list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
 
+	if (!css_set_populated(old_cset))
+		css_set_update_populated(old_cset, false);
+
 	/*
 	 * We just gained a reference on old_cset by taking it from the
 	 * task. As trading it for new_cset is protected by cgroup_mutex,
@@ -3774,7 +3810,7 @@ static void css_advance_task_iter(struct css_task_iter *it)
 			link = list_entry(l, struct cgrp_cset_link, cset_link);
 			cset = link->cset;
 		}
-	} while (list_empty(&cset->tasks) && list_empty(&cset->mg_tasks));
+	} while (!css_set_populated(cset));
 
 	it->cset_pos = l;
 
@@ -5492,17 +5528,20 @@ void cgroup_exit(struct task_struct *tsk)
 
 	/*
 	 * Unlink from @tsk from its css_set.  As migration path can't race
-	 * with us, we can check cg_list without grabbing css_set_rwsem.
+	 * with us, we can check css_set and cg_list without synchronization.
 	 */
+	cset = task_css_set(tsk);
+
 	if (!list_empty(&tsk->cg_list)) {
 		down_write(&css_set_rwsem);
 		list_del_init(&tsk->cg_list);
+		if (!css_set_populated(cset))
+			css_set_update_populated(cset, false);
 		up_write(&css_set_rwsem);
 		put_cset = true;
 	}
 
 	/* Reassign the task to the init_css_set. */
-	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
 	/* see cgroup_post_fork() for details */
-- 
2.4.3
