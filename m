From: Waiman Long <longman@redhat.com>
Subject: [PATCH-cgroup 1/5] cgroup: Keep accurate count of tasks in each css_set
Date: Tue, 13 Jun 2017 17:18:01 -0400
Message-ID: <1497388685-31207-2-git-send-email-longman@redhat.com>
References: <1497388685-31207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 5A9022B0A66
In-Reply-To: <1497388685-31207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

The reference count in the css_set data structure was used as a
proxy of the number of tasks attached to that css_set. However, that
count is actually not an accurate measure especially with thread mode
support. So a new variable task_count is added to the css_set to keep
track of the actual task count. This new variable is protected by
the css_set_lock. Functions that require the actual task count are
updated to use the new variable.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/cgroup-defs.h |  3 +++
 kernel/cgroup/cgroup-v1.c   |  6 +-----
 kernel/cgroup/cgroup.c      | 12 +++++++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index fb694b9..ea3218a 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -163,6 +163,9 @@ struct css_set {
 	/* reference count */
 	refcount_t refcount;
 
+	/* internal task count, protected by css_set_lock */
+	int task_count;
+
 	/*
 	 * If not threaded, the following points to self.  If threaded, to
 	 * a cset which belongs to the top cgroup of the threaded subtree.
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1e101b9..9bbd4ef 100644
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
+		count += link->cset->task_count;
 	spin_unlock_irq(&css_set_lock);
 	return count;
 }
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d319438..216657e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -647,6 +647,11 @@ static bool css_set_threaded(struct css_set *cset)
 /**
  * css_set_populated - does a css_set contain any tasks?
  * @cset: target css_set
+ *
+ * css_set_populated() should be the same as !!cset->task_count at steady
+ * state. However, css_set_populated() can be called while a task is being
+ * added to or removed from the linked list before the task_count is
+ * properly updated. Hence, we can't just look at ->task_count here.
  */
 static bool css_set_populated(struct css_set *cset)
 {
@@ -668,7 +673,7 @@ static bool cgroup_has_tasks(struct cgroup *cgrp)
 	spin_lock_irq(&css_set_lock);
 
 	list_for_each_entry(link, &cgrp->cset_links, cset_link) {
-		if (css_set_populated(link->cset)) {
+		if (link->cset->task_count) {
 			has_tasks = true;
 			break;
 		}
@@ -1758,6 +1763,7 @@ static void cgroup_enable_task_cg_lists(void)
 				css_set_update_populated(cset, true);
 			list_add_tail(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
+			cset->task_count++;
 		}
 		spin_unlock(&p->sighand->siglock);
 	} while_each_thread(g, p);
@@ -2241,8 +2247,10 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 			struct css_set *to_cset = cset->mg_dst_cset;
 
 			get_css_set(to_cset);
+			to_cset->task_count++;
 			css_set_move_task(task, from_cset, to_cset, true);
 			put_css_set_locked(from_cset);
+			from_cset->task_count--;
 		}
 	}
 	spin_unlock_irq(&css_set_lock);
@@ -5236,6 +5244,7 @@ void cgroup_post_fork(struct task_struct *child)
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			get_css_set(cset);
+			cset->task_count++;
 			css_set_move_task(child, NULL, cset, false);
 		}
 		spin_unlock_irq(&css_set_lock);
@@ -5285,6 +5294,7 @@ void cgroup_exit(struct task_struct *tsk)
 	if (!list_empty(&tsk->cg_list)) {
 		spin_lock_irq(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
+		cset->task_count--;
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
-- 
1.8.3.1

