From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: implement CSS_TASK_ITER_THREADED
Date: Sun, 16 Jul 2017 22:07:19 -0400
Message-ID: <20170717020721.3612468-5-tj@kernel.org>
References: <20170717020721.3612468-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=265lB2M+N+pe+n5h4M1t5E+6jPBZ0dBFIX9dfOuhdVI=;
        b=iClJpDd8dpVyMQvCqd/Gc1xbSpj4nznvwMp4376CZjLfvCjquUVaUXaIOR4jh3bjHE
         8QI3TMzHTkJRsLNILFwDLilFeHDguDUvG+HpZJ/xCBQ/iRxQf6K99wBO2NWsKDuzuReh
         Ef7sZfMdlnIKlNK0Lywwp681P4bTGAqmGq+VQG9C6lUayhsoGf2MKYaf/VjkLGWgretP
         nl0GVMjR72U6dS1GmFRB/PoPjivNebDSxUD93T0A6FcLFcWVhkOGmf0CU3JwrcoDDW9A
         JIILjM9Du7H8JwmBGJLJ59mvYBjJHDxmBRjgqk8viJzycUkFfNo2yYnTdJc0WO8V5T2a
         7rSg==
In-Reply-To: <20170717020721.3612468-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

cgroup v2 is in the process of growing thread granularity support.
Once thread mode is enabled, the root cgroup of the subtree serves as
the dom_cgrp to which the processes of the subtree conceptually belong
and domain-level resource consumptions not tied to any specific task
are charged.  In the subtree, threads won't be subject to process
granularity or no-internal-task constraint and can be distributed
arbitrarily across the subtree.

This patch implements a new task iterator flag CSS_TASK_ITER_THREADED,
which, when used on a dom_cgrp, makes the iteration include the tasks
on all the associated threaded css_sets.  "cgroup.procs" read path is
updated to use it so that reading the file on a proc_cgrp lists all
processes.  This will also be used by controller implementations which
need to walk processes or tasks at the resource domain level.

Task iteration is implemented nested in css_set iteration.  If
CSS_TASK_ITER_THREADED is specified, after walking tasks of each
!threaded css_set, all the associated threaded css_sets are visited
before moving onto the next !threaded css_set.

v2: ->cur_pcset renamed to ->cur_dcset.  Updated for the new
    enable-threaded-per-cgroup behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  6 ++++
 kernel/cgroup/cgroup.c | 77 +++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b7dd230..79faa64 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -38,6 +38,8 @@
 
 /* walk only threadgroup leaders */
 #define CSS_TASK_ITER_PROCS		(1U << 0)
+/* walk all threaded css_sets in the domain */
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
+	struct css_set			*cur_dcset;
 	struct task_struct		*cur_task;
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c7e1c24..a1d59af 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3629,6 +3629,58 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 	return ret;
 }
 
+static struct css_set *css_task_iter_next_css_set(struct css_task_iter *it)
+{
+	struct list_head *l;
+	struct cgrp_cset_link *link;
+	struct css_set *cset;
+
+	lockdep_assert_held(&css_set_lock);
+
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
+	l = l->next;
+	if (l == it->cset_head) {
+		it->cset_pos = NULL;
+		return NULL;
+	}
+
+	if (it->ss) {
+		cset = container_of(l, struct css_set, e_cset_node[it->ss->id]);
+	} else {
+		link = list_entry(l, struct cgrp_cset_link, cset_link);
+		cset = link->cset;
+	}
+
+	it->cset_pos = l;
+
+	/* initialize threaded css_set walking */
+	if (it->flags & CSS_TASK_ITER_THREADED) {
+		if (it->cur_dcset)
+			put_css_set_locked(it->cur_dcset);
+		it->cur_dcset = cset;
+		get_css_set(cset);
+
+		it->tcset_head = &cset->threaded_csets;
+		it->tcset_pos = &cset->threaded_csets;
+	}
+
+	return cset;
+}
+
 /**
  * css_task_iter_advance_css_set - advance a task itererator to the next css_set
  * @it: the iterator to advance
@@ -3637,32 +3689,19 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
  */
 static void css_task_iter_advance_css_set(struct css_task_iter *it)
 {
-	struct list_head *l = it->cset_pos;
-	struct cgrp_cset_link *link;
 	struct css_set *cset;
 
 	lockdep_assert_held(&css_set_lock);
 
 	/* Advance to the next non-empty css_set */
 	do {
-		l = l->next;
-		if (l == it->cset_head) {
-			it->cset_pos = NULL;
+		cset = css_task_iter_next_css_set(it);
+		if (!cset) {
 			it->task_pos = NULL;
 			return;
 		}
-
-		if (it->ss) {
-			cset = container_of(l, struct css_set,
-					    e_cset_node[it->ss->id]);
-		} else {
-			link = list_entry(l, struct cgrp_cset_link, cset_link);
-			cset = link->cset;
-		}
 	} while (!css_set_populated(cset));
 
-	it->cset_pos = l;
-
 	if (!list_empty(&cset->tasks))
 		it->task_pos = cset->tasks.next;
 	else
@@ -3805,6 +3844,9 @@ void css_task_iter_end(struct css_task_iter *it)
 		spin_unlock_irq(&css_set_lock);
 	}
 
+	if (it->cur_dcset)
+		put_css_set(it->cur_dcset);
+
 	if (it->cur_task)
 		put_task_struct(it->cur_task);
 }
@@ -3830,6 +3872,7 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct css_task_iter *it = of->priv;
+	unsigned iter_flags = CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
@@ -3843,10 +3886,10 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
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

