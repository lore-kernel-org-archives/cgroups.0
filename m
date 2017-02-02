From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup: implement CSS_TASK_ITER_THREADED
Date: Thu,  2 Feb 2017 15:06:31 -0500
Message-ID: <20170202200632.13992-5-tj@kernel.org>
References: <20170202200632.13992-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p3lgnvKLV/zenp5a07dmJnLIx6988vi4UcX07y+dEEw=;
        b=JzSuHuThXwK9i5PKeY9t72aGbaOc1zbKDp0OenqE8faAZcjw7ShhEH/n0qcPtahELg
         vHxPeowzMvZhwfQts/5iZEtgOo7L/vXdCfDILzYsRFPa6IiMMc5TTdYf6eZIt4HZwV2i
         X2MwGBK6NO6SG4Kz77kH/HejeL9HgWYPLEPD5+1hziwkSvq9AKvmSX/sEq/FmCxRZA95
         NEB8nfViAbkV2v0bZmJrwbER73SlauCmuQBkSyHROW0Gvn+Hp+XbrrEMTI+IxXWE7w87
         pNfVwGkd3McACLm2sYES4TZbgSotoA9PfnKrDnlNoBD/xrdSayP4nhLjUzKSjFav1hgM
         ZzKw==
In-Reply-To: <20170202200632.13992-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, pjt@google.com, luto@amacapital.net, efault@gmx.de
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lvenanci@redhat.com, Tejun Heo <tj@kernel.org>

cgroup v2 is in the process of growing thread granularity support.
Once thread mode is enabled, the root cgroup of the subtree serves as
the proc_cgrp to which the processes of the subtree conceptually
belong and domain-level resource consumptions not tied to any specific
task are charged.  In the subtree, threads won't be subject to process
granularity or no-internal-task constraint and can be distributed
arbitrarily across the subtree.

This patch implements a new task iterator flag CSS_TASK_ITER_THREADED,
which, when used on a proc_cgrp, makes the iteration include the tasks
on all the associated threaded css_sets.  "cgroup.procs" read path is
updated to use it so that reading the file on a proc_cgrp lists all
processes.  This will also be used by controller implementations which
need to walk processes or tasks at the resource domain level.

Task iteration is implemented nested in css_set iteration.  If
CSS_TASK_ITER_THREADED is specified, after walking tasks of each
!threaded css_set, all the associated threaded css_sets are visited
before moving onto the next !threaded css_set.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  6 ++++
 kernel/cgroup/cgroup.c | 81 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 20f6057..cd0be87 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -38,6 +38,8 @@
 
 /* walk only threadgroup leaders */
 #define CSS_TASK_ITER_PROCS		(1U << 0)
+/* walk threaded css_sets as part of their proc_csets */
+#define CSS_TASK_ITER_THREADED		(1U << 1)
 
 /* a css_task_iter should be treated as an opaque object */
 struct css_task_iter {
@@ -47,11 +49,15 @@ struct css_task_iter {
 	struct list_head		*cset_pos;
 	struct list_head		*cset_head;
 
+	struct list_head		*tcset_pos;
+	struct list_head		*tcset_head;
+
 	struct list_head		*task_pos;
 	struct list_head		*tasks_head;
 	struct list_head		*mg_tasks_head;
 
 	struct css_set			*cur_cset;
+	struct css_set			*cur_pcset;
 	struct task_struct		*cur_task;
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6c5658a..e73b3c3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3590,27 +3590,36 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 	return ret;
 }
 
-/**
- * css_task_iter_advance_css_set - advance a task itererator to the next css_set
- * @it: the iterator to advance
- *
- * Advance @it to the next css_set to walk.
- */
-static void css_task_iter_advance_css_set(struct css_task_iter *it)
+static struct css_set *css_task_iter_next_css_set(struct css_task_iter *it)
 {
-	struct list_head *l = it->cset_pos;
+	bool threaded = it->flags & CSS_TASK_ITER_THREADED;
+	struct list_head *l;
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
 
 	lockdep_assert_held(&css_set_lock);
 
-	/* Advance to the next non-empty css_set */
+	/* find the next threaded cset */
+	if (it->tcset_pos) {
+		l = it->tcset_pos->next;
+
+		if (l != it->tcset_head) {
+			it->tcset_pos = l;
+			return container_of(l, struct css_set,
+					    threaded_csets_node);
+		}
+
+		it->tcset_pos = NULL;
+	}
+
+	/* find the next cset */
+	l = it->cset_pos;
+
 	do {
 		l = l->next;
 		if (l == it->cset_head) {
 			it->cset_pos = NULL;
-			it->task_pos = NULL;
-			return;
+			return NULL;
 		}
 
 		if (it->ss) {
@@ -3620,10 +3629,50 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
 			link = list_entry(l, struct cgrp_cset_link, cset_link);
 			cset = link->cset;
 		}
-	} while (!css_set_populated(cset));
+
+		/*
+		 * For threaded iterations, threaded csets are walked
+		 * together with their proc_csets.  Skip here.
+		 */
+	} while (threaded && css_set_threaded(cset));
 
 	it->cset_pos = l;
 
+	/* initialize threaded cset walking */
+	if (threaded) {
+		if (it->cur_pcset)
+			put_css_set_locked(it->cur_pcset);
+		it->cur_pcset = cset;
+		get_css_set(cset);
+
+		it->tcset_head = &cset->threaded_csets;
+		it->tcset_pos = &cset->threaded_csets;
+	}
+
+	return cset;
+}
+
+/**
+ * css_task_iter_advance_css_set - advance a task itererator to the next css_set
+ * @it: the iterator to advance
+ *
+ * Advance @it to the next css_set to walk.
+ */
+static void css_task_iter_advance_css_set(struct css_task_iter *it)
+{
+	struct css_set *cset;
+
+	lockdep_assert_held(&css_set_lock);
+
+	/* Advance to the next non-empty css_set */
+	do {
+		cset = css_task_iter_next_css_set(it);
+		if (!cset) {
+			it->task_pos = NULL;
+			return;
+		}
+	} while (!css_set_populated(cset));
+
 	if (!list_empty(&cset->tasks))
 		it->task_pos = cset->tasks.next;
 	else
@@ -3766,6 +3815,9 @@ void css_task_iter_end(struct css_task_iter *it)
 		spin_unlock_irq(&css_set_lock);
 	}
 
+	if (it->cur_pcset)
+		put_css_set(it->cur_pcset);
+
 	if (it->cur_task)
 		put_task_struct(it->cur_task);
 }
@@ -3791,6 +3843,7 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct css_task_iter *it = of->priv;
+	unsigned iter_flags = CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
@@ -3804,10 +3857,10 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 		if (!it)
 			return ERR_PTR(-ENOMEM);
 		of->priv = it;
-		css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS, it);
+		css_task_iter_start(&cgrp->self, iter_flags, it);
 	} else if (!(*pos)++) {
 		css_task_iter_end(it);
-		css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS, it);
+		css_task_iter_start(&cgrp->self, iter_flags, it);
 	}
 
 	return cgroup_procs_next(s, NULL, NULL);
-- 
2.9.3

