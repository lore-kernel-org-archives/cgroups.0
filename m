From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] cgroup: Keep accurate count of tasks in each css_set
Date: Wed, 14 Jun 2017 16:08:36 -0400
Message-ID: <20170614200842.15174-2-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=80GTTmysLAjwm9KDZZ9Wi+ePopPQpD7EP0REk1Jzjdk=;
        b=ALi8GLaGIVeu/HL29ehqXh0nJxuBHsq2WQNy86mZFvyDojVvG49yKz2fC25pjejdNm
         mUihfyYX6GRKKsBhtUYVvK+xm/gYYVtQ989oZ7MP1YCnVUmKEfx9AnoCk2YH79VzIn8o
         Z2/1aY+kg6ZxpAbN2NC6X3CXuwGRKCb6lxQyrkCZPg6uj8v7UW2wfnc5C155MiD5DTq6
         dib6hi64tyKk/FDMzEOIn7AgIe7Vv21W44KHH1z7gbfjmG/v9fgnmngWNLPZOZq2T3R/
         l08onpObpGwEMJVLLFiI8dZOwyLPlBWVmvSfzjvyPAeRB+eG8AU1Nqi1WnzjWJwdIsEr
         PuZw==
In-Reply-To: <20170614200842.15174-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

From: Waiman Long <longman@redhat.com>

The reference count in the css_set data structure was used as a
proxy of the number of tasks attached to that css_set. However, that
count is actually not an accurate measure especially with thread mode
support. So a new variable nr_tasks is added to the css_set to keep
track of the actual task count. This new variable is protected by
the css_set_lock. Functions that require the actual task count are
updated to use the new variable.

tj: s/task_count/nr_tasks/ for consistency with cgroup_root->nr_cgrps.
    Refreshed on top of cgroup/for-v4.13 which dropped on
    css_set_populated() -> nr_tasks conversion.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  3 +++
 kernel/cgroup/cgroup-v1.c   |  6 +-----
 kernel/cgroup/cgroup.c      | 10 ++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ec47101cb1bf..3bc4196bf217 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -166,6 +166,9 @@ struct css_set {
 	/* the default cgroup associated with this css_set */
 	struct cgroup *dfl_cgrp;
 
+	/* internal task count, protected by css_set_lock */
+	int nr_tasks;
+
 	/*
 	 * Lists running through all tasks using this cgroup group.
 	 * mg_tasks lists tasks which belong to this cset but are in the
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 85d75152402d..e9ea5f201fac 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -334,10 +334,6 @@ static struct cgroup_pidlist *cgroup_pidlist_find_create(struct cgroup *cgrp,
 /**
  * cgroup_task_count - count the number of tasks in a cgroup.
  * @cgrp: the cgroup in question
- *
- * Return the number of tasks in the cgroup.  The returned number can be
- * higher than the actual number of tasks due to css_set references from
- * namespace roots and temporary usages.
  */
 static int cgroup_task_count(const struct cgroup *cgrp)
 {
@@ -346,7 +342,7 @@ static int cgroup_task_count(const struct cgroup *cgrp)
 
 	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &cgrp->cset_links, cset_link)
-		count += refcount_read(&link->cset->refcount);
+		count += link->cset->nr_tasks;
 	spin_unlock_irq(&css_set_lock);
 	return count;
 }
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8d4e85eae42c..dbfd7028b1c6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -573,6 +573,11 @@ static int css_set_count	= 1;	/* 1 for init_css_set */
 /**
  * css_set_populated - does a css_set contain any tasks?
  * @cset: target css_set
+ *
+ * css_set_populated() should be the same as !!cset->nr_tasks at steady
+ * state. However, css_set_populated() can be called while a task is being
+ * added to or removed from the linked list before the nr_tasks is
+ * properly updated. Hence, we can't just look at ->nr_tasks here.
  */
 static bool css_set_populated(struct css_set *cset)
 {
@@ -1598,6 +1603,7 @@ static void cgroup_enable_task_cg_lists(void)
 				css_set_update_populated(cset, true);
 			list_add_tail(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
+			cset->nr_tasks++;
 		}
 		spin_unlock(&p->sighand->siglock);
 	} while_each_thread(g, p);
@@ -2064,8 +2070,10 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 			struct css_set *to_cset = cset->mg_dst_cset;
 
 			get_css_set(to_cset);
+			to_cset->nr_tasks++;
 			css_set_move_task(task, from_cset, to_cset, true);
 			put_css_set_locked(from_cset);
+			from_cset->nr_tasks--;
 		}
 	}
 	spin_unlock_irq(&css_set_lock);
@@ -4789,6 +4797,7 @@ void cgroup_post_fork(struct task_struct *child)
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
+			cset->nr_tasks++;
 			css_set_move_task(child, NULL, cset, false);
 		}
 		spin_unlock_irq(&css_set_lock);
@@ -4838,6 +4847,7 @@ void cgroup_exit(struct task_struct *tsk)
 	if (!list_empty(&tsk->cg_list)) {
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
+		cset->nr_tasks--;
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
-- 
2.13.0

