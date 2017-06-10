From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/10] cgroup: implement CSS_TASK_ITER_THREADED
Date: Sat, 10 Jun 2017 10:03:47 -0400
Message-ID: <20170610140351.10703-7-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9u5mW5024Sggk5ToyI4mXEeoWYGa5+yxhh89DFJiZjw=;
        b=VanxsxOapF/M42qAnzW7ai6PrkSPlzS90Pflw8yg+ciQ+QHpscJQCOc96mVKvTH5ur
         YPz9gDWDNqhzDrNXFsKpjrkxdUXYqBXW/Q6HdxJxMrD3r3IzheQRuohmEmRCjhvR65XU
         Bw1KXz4ZofqD9Kp3jqRnz+U03ELPBhflCdppaMGmJz2bQSBxwnt7tzXK2wZrEyCfm+Jo
         dg/8w9ZBg1tLyd1gQzqNMC9cz73oqO5tyPEprnnI0rOsAZF0FUpkm4RcwDbKNIYiemEN
         wrxpk6YBcss9Xx0TG+laGnEesBtTj9Kfdjqhov2OART36ddGpQbi4eOWPZaRqvMDMJhD
         dHrg==
In-Reply-To: <20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |  6 ++++
 kernel/cgroup/cgroup.c | 81 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8755eb5ece18..05da7cc9ea2d 100644
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
index 0fa4ffe84933..765c1c27c879 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3610,27 +3610,36 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
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
@@ -3640,10 +3649,50 @@ static void css_task_iter_advance_css_set(struct css_task_iter *it)
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
@@ -3786,6 +3835,9 @@ void css_task_iter_end(struct css_task_iter *it)
 		spin_unlock_irq(&css_set_lock);
 	}
 
+	if (it->cur_pcset)
+		put_css_set(it->cur_pcset);
+
 	if (it->cur_task)
 		put_task_struct(it->cur_task);
 }
@@ -3811,6 +3863,7 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct css_task_iter *it = of->priv;
+	unsigned iter_flags = CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
@@ -3824,10 +3877,10 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
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
2.13.0
