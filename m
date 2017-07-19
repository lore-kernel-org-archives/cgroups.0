From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] cgroup: add @flags to css_task_iter_start() and implement CSS_TASK_ITER_PROCS
Date: Wed, 19 Jul 2017 15:44:35 -0400
Message-ID: <20170719194439.2915602-3-tj@kernel.org>
References: <20170719194439.2915602-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B5G5+5GSkAEqFs9csLhQ7e35bbTNDsT5fZDW9vv8wg8=;
        b=mSqpLHDwgbHkr6v7fFNEUKIQfJWf4SgC9BFTuEP3mZBtZuiUGP1wOrLHnmAt65jheO
         QLwYuwrdttH1S+KNpN5amr+z0940JE9W5rHYDHz19OF21Q/7AvthZshen89KQJWXmBUm
         8fm/xb+kaNxv+UeLzqRSsR5myQcCEfMaqFnpO1PNgsQQuaKTQljzzFNpctJiI21XeO5s
         KUQa9tr0XROvzLMmAdz8FijAG9wO+fIm/biC7enSv2aQLR+wUs6F4446pLX3g4Q0L0fG
         Oc/cOsGYIbGgjgYkxzd5bhy73i1Y1WL4Wt8dHrhqxnUHxUPvkbL4bzdaQYuZNV3v+3vQ
         oLuA==
In-Reply-To: <20170719194439.2915602-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

css_task_iter currently always walks all tasks.  With the scheduled
cgroup v2 thread support, the iterator would need to handle multiple
types of iteration.  As a preparation, add @flags to
css_task_iter_start() and implement CSS_TASK_ITER_PROCS.  If the flag
is not specified, it walks all tasks as before.  When asserted, the
iterator only walks the group leaders.

For now, the only user of the flag is cgroup v2 "cgroup.procs" file
which no longer needs to skip non-leader tasks in cgroup_procs_next().
Note that cgroup v1 "cgroup.procs" can't use the group leader walk as
v1 "cgroup.procs" doesn't mean "list all thread group leaders in the
cgroup" but "list all thread group id's with any threads in the
cgroup".

While at it, update cgroup_procs_show() to use task_pid_vnr() instead
of task_tgid_vnr().  As the iteration guarantees that the function
only sees group leaders, this doesn't change the output and will allow
sharing the function for thread iteration.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h       |  6 +++++-
 kernel/cgroup/cgroup-v1.c    |  6 +++---
 kernel/cgroup/cgroup.c       | 24 ++++++++++++++----------
 kernel/cgroup/cpuset.c       |  6 +++---
 kernel/cgroup/freezer.c      |  6 +++---
 mm/memcontrol.c              |  2 +-
 net/core/netclassid_cgroup.c |  2 +-
 7 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 308b107..cae5831 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -36,9 +36,13 @@
 #define CGROUP_WEIGHT_DFL		100
 #define CGROUP_WEIGHT_MAX		10000
 
+/* walk only threadgroup leaders */
+#define CSS_TASK_ITER_PROCS		(1U << 0)
+
 /* a css_task_iter should be treated as an opaque object */
 struct css_task_iter {
 	struct cgroup_subsys		*ss;
+	unsigned int			flags;
 
 	struct list_head		*cset_pos;
 	struct list_head		*cset_head;
@@ -129,7 +133,7 @@ struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset,
 struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 					struct cgroup_subsys_state **dst_cssp);
 
-void css_task_iter_start(struct cgroup_subsys_state *css,
+void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
 			 struct css_task_iter *it);
 struct task_struct *css_task_iter_next(struct css_task_iter *it);
 void css_task_iter_end(struct css_task_iter *it);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 60f7247..167aaab 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -121,7 +121,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	 * ->can_attach() fails.
 	 */
 	do {
-		css_task_iter_start(&from->self, &it);
+		css_task_iter_start(&from->self, 0, &it);
 		task = css_task_iter_next(&it);
 		if (task)
 			get_task_struct(task);
@@ -373,7 +373,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
-	css_task_iter_start(&cgrp->self, &it);
+	css_task_iter_start(&cgrp->self, 0, &it);
 	while ((tsk = css_task_iter_next(&it))) {
 		if (unlikely(n == length))
 			break;
@@ -749,7 +749,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	rcu_read_unlock();
 
-	css_task_iter_start(&cgrp->self, &it);
+	css_task_iter_start(&cgrp->self, 0, &it);
 	while ((tsk = css_task_iter_next(&it))) {
 		switch (tsk->state) {
 		case TASK_RUNNING:
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e3bda075..3c5a37a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3643,6 +3643,7 @@ static void css_task_iter_advance(struct css_task_iter *it)
 	lockdep_assert_held(&css_set_lock);
 	WARN_ON_ONCE(!l);
 
+repeat:
 	/*
 	 * Advance iterator to find next entry.  cset->tasks is consumed
 	 * first and then ->mg_tasks.  After ->mg_tasks, we move onto the
@@ -3657,11 +3658,18 @@ static void css_task_iter_advance(struct css_task_iter *it)
 		css_task_iter_advance_css_set(it);
 	else
 		it->task_pos = l;
+
+	/* if PROCS, skip over tasks which aren't group leaders */
+	if ((it->flags & CSS_TASK_ITER_PROCS) && it->task_pos &&
+	    !thread_group_leader(list_entry(it->task_pos, struct task_struct,
+					    cg_list)))
+		goto repeat;
 }
 
 /**
  * css_task_iter_start - initiate task iteration
  * @css: the css to walk tasks of
+ * @flags: CSS_TASK_ITER_* flags
  * @it: the task iterator to use
  *
  * Initiate iteration through the tasks of @css.  The caller can call
@@ -3669,7 +3677,7 @@ static void css_task_iter_advance(struct css_task_iter *it)
  * returns NULL.  On completion of iteration, css_task_iter_end() must be
  * called.
  */
-void css_task_iter_start(struct cgroup_subsys_state *css,
+void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
 			 struct css_task_iter *it)
 {
 	/* no one should try to iterate before mounting cgroups */
@@ -3680,6 +3688,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 	spin_lock_irq(&css_set_lock);
 
 	it->ss = css->ss;
+	it->flags = flags;
 
 	if (it->ss)
 		it->cset_pos = &css->cgroup->e_csets[css->ss->id];
@@ -3753,13 +3762,8 @@ static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
 	struct css_task_iter *it = of->priv;
-	struct task_struct *task;
-
-	do {
-		task = css_task_iter_next(it);
-	} while (task && !thread_group_leader(task));
 
-	return task;
+	return css_task_iter_next(it);
 }
 
 static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
@@ -3780,10 +3784,10 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 		if (!it)
 			return ERR_PTR(-ENOMEM);
 		of->priv = it;
-		css_task_iter_start(&cgrp->self, it);
+		css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS, it);
 	} else if (!(*pos)++) {
 		css_task_iter_end(it);
-		css_task_iter_start(&cgrp->self, it);
+		css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS, it);
 	}
 
 	return cgroup_procs_next(s, NULL, NULL);
@@ -3791,7 +3795,7 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 
 static int cgroup_procs_show(struct seq_file *s, void *v)
 {
-	seq_printf(s, "%d\n", task_tgid_vnr(v));
+	seq_printf(s, "%d\n", task_pid_vnr(v));
 	return 0;
 }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ca8376e..252d70c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -861,7 +861,7 @@ static void update_tasks_cpumask(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&cs->css, &it);
+	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
 	css_task_iter_end(&it);
@@ -1091,7 +1091,7 @@ static void update_tasks_nodemask(struct cpuset *cs)
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
 	 */
-	css_task_iter_start(&cs->css, &it);
+	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it))) {
 		struct mm_struct *mm;
 		bool migrate;
@@ -1284,7 +1284,7 @@ static void update_tasks_flags(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&cs->css, &it);
+	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
 		cpuset_update_task_spread_flag(cs, task);
 	css_task_iter_end(&it);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 1b72d56..0823679 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -268,7 +268,7 @@ static void update_if_frozen(struct cgroup_subsys_state *css)
 	rcu_read_unlock();
 
 	/* are all tasks frozen? */
-	css_task_iter_start(css, &it);
+	css_task_iter_start(css, 0, &it);
 
 	while ((task = css_task_iter_next(&it))) {
 		if (freezing(task)) {
@@ -320,7 +320,7 @@ static void freeze_cgroup(struct freezer *freezer)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, &it);
+	css_task_iter_start(&freezer->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
 		freeze_task(task);
 	css_task_iter_end(&it);
@@ -331,7 +331,7 @@ static void unfreeze_cgroup(struct freezer *freezer)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, &it);
+	css_task_iter_start(&freezer->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
 		__thaw_task(task);
 	css_task_iter_end(&it);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3df3c04..2b2f071 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -917,7 +917,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, &it);
+		css_task_iter_start(&iter->css, 0, &it);
 		while (!ret && (task = css_task_iter_next(&it)))
 			ret = fn(task, arg);
 		css_task_iter_end(&it);
diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 029a61a..5e4f040 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -100,7 +100,7 @@ static int write_classid(struct cgroup_subsys_state *css, struct cftype *cft,
 
 	cs->classid = (u32)value;
 
-	css_task_iter_start(css, &it);
+	css_task_iter_start(css, 0, &it);
 	while ((p = css_task_iter_next(&it))) {
 		task_lock(p);
 		iterate_fd(p->files, 0, update_classid_sock,
-- 
2.9.3

