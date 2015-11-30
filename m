From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4-fixes 2/3] cgroup: fix handling of
 multi-destination migration from subtree_control enabling
Date: Mon, 30 Nov 2015 17:44:31 -0500
Message-ID: <20151130224431.GB9039@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
 <20151124145945.GF17033@mtj.duckdns.org>
 <20151130224205.GA9039@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZTq13KbbZHh0lOrufYh+VMzPRlrxGYf1tnU4EEaf1W4=;
        b=rAiwPlSpNGPga0QlOVl0J3u2crzFuRtEwPCPA0ivftK35lUiU/MJNqjvVG014weEOe
         ZZcDM4cZFkl0vQe0KosqPXg5lVup/7vnMb5B1VABqC5XYtZPh4tshGQmUJhwdco13cIp
         e0WmMbYcQ08qILYkimRtHzXGFKPAcFpZc0PBSAlmeT0ZIRLJxGYN5lYJUd7SzWvC4h1I
         gkZ0wrIa6Pqgp/Awp4y4VfHwBr68yNbV8TazLUo+YJpg2VyLdv5Wq7Djn9YS+VYOAjpR
         lgSGDML4CEDPE1Sf+90D1ttPAKA1qc3dpvGt3I/KltyHA9jtR0rPI9nyTK/cTq//UzSD
         t1Qw==
Content-Disposition: inline
In-Reply-To: <20151130224205.GA9039-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

From 0d7d444e260493252e30c70813c7657e9ede2f12 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 30 Nov 2015 17:24:34 -0500

Consider the following v2 hierarchy.

  P0 (+memory) --- P1 (-memory) --- A
                                 \- B

P0 has memory enabled in its subtree_control while P1 doesn't.  If
both A and B contain processes, they would belong to the memory css of
P1.  Now if memory is enabled on P1's subtree_control, memory csses
should be created on both A and B and A's processes should be moved to
the former and B's processes the latter.  IOW, enabling controllers
can cause atomic migrations into different csses.

The core cgroup migration logic has been updated accordingly but the
controller migration methods haven't and still assume that all tasks
migrate to a single target css; furthermore, the methods were fed the
css in which subtree_control was updated which is the parent of the
target csses.  pids controller depends on the migration methods to
move charges and this made the controller attribute charges to the
wrong csses often triggering the following warning by driving a
counter negative.

 WARNING: CPU: 1 PID: 1 at kernel/cgroup_pids.c:97 pids_cancel.constprop.6+0x31/0x40()
 Modules linked in:
 CPU: 1 PID: 1 Comm: systemd Not tainted 4.4.0-rc1+ #29
 ...
  ffffffff81f65382 ffff88007c043b90 ffffffff81551ffc 0000000000000000
  ffff88007c043bc8 ffffffff810de202 ffff88007a752000 ffff88007a29ab00
  ffff88007c043c80 ffff88007a1d8400 0000000000000001 ffff88007c043bd8
 Call Trace:
  [<ffffffff81551ffc>] dump_stack+0x4e/0x82
  [<ffffffff810de202>] warn_slowpath_common+0x82/0xc0
  [<ffffffff810de2fa>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8118e031>] pids_cancel.constprop.6+0x31/0x40
  [<ffffffff8118e0fd>] pids_can_attach+0x6d/0xf0
  [<ffffffff81188a4c>] cgroup_taskset_migrate+0x6c/0x330
  [<ffffffff81188e05>] cgroup_migrate+0xf5/0x190
  [<ffffffff81189016>] cgroup_attach_task+0x176/0x200
  [<ffffffff8118949d>] __cgroup_procs_write+0x2ad/0x460
  [<ffffffff81189684>] cgroup_procs_write+0x14/0x20
  [<ffffffff811854e5>] cgroup_file_write+0x35/0x1c0
  [<ffffffff812e26f1>] kernfs_fop_write+0x141/0x190
  [<ffffffff81265f88>] __vfs_write+0x28/0xe0
  [<ffffffff812666fc>] vfs_write+0xac/0x1a0
  [<ffffffff81267019>] SyS_write+0x49/0xb0
  [<ffffffff81bcef32>] entry_SYSCALL_64_fastpath+0x12/0x76

This patch fixes the bug by removing @css parameter from the three
migration methods, ->can_attach, ->cancel_attach() and ->attach() and
updating cgroup_taskset iteration helpers also return the destination
css in addition to the task being migrated.  All controllers are
updated accordingly.

* Controllers which don't care whether there are one or multiple
  target csses can be converted trivially.  cpu, io, freezer, perf,
  netclassid and netprio fall in this category.

* cpuset's current implementation assumes that there's single source
  and destination and thus doesn't support v2 hierarchy already.  The
  only change made by this patchset is how that single destination css
  is obtained.

* memory migration path already doesn't do anything on v2.  How the
  single destination css is obtained is updated and the prep stage of
  mem_cgroup_can_attach() is reordered to accomodate the change.

* pids is the only controller which was affected by this bug.  It now
  correctly handles multi-destination migrations and no longer causes
  counter underflow from incorrect accounting.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c           |  6 +++---
 include/linux/cgroup-defs.h  |  9 +++------
 include/linux/cgroup.h       | 33 +++++++++++++++++++++-----------
 kernel/cgroup.c              | 43 +++++++++++++++++++++++++++++++++---------
 kernel/cgroup_freezer.c      |  6 +++---
 kernel/cgroup_pids.c         | 16 ++++++++--------
 kernel/cpuset.c              | 33 ++++++++++++++++++++------------
 kernel/events/core.c         |  6 +++---
 kernel/sched/core.c          | 12 ++++++------
 mm/memcontrol.c              | 45 ++++++++++++++++++++++----------------------
 net/core/netclassid_cgroup.c | 11 ++++++-----
 net/core/netprio_cgroup.c    |  9 +++++----
 12 files changed, 137 insertions(+), 92 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5bcdfc1..5a37188 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1127,15 +1127,15 @@ void blkcg_exit_queue(struct request_queue *q)
  * of the main cic data structures.  For now we allow a task to change
  * its cgroup only if it's the only owner of its ioc.
  */
-static int blkcg_can_attach(struct cgroup_subsys_state *css,
-			    struct cgroup_taskset *tset)
+static int blkcg_can_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
+	struct cgroup_subsys_state *dst_css;
 	struct io_context *ioc;
 	int ret = 0;
 
 	/* task_lock() is needed to avoid races with exit_io_context() */
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, dst_css, tset) {
 		task_lock(task);
 		ioc = task->io_context;
 		if (ioc && atomic_read(&ioc->nr_tasks) > 1)
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 869fd4a..06b77f9d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -422,12 +422,9 @@ struct cgroup_subsys {
 	void (*css_reset)(struct cgroup_subsys_state *css);
 	void (*css_e_css_changed)(struct cgroup_subsys_state *css);
 
-	int (*can_attach)(struct cgroup_subsys_state *css,
-			  struct cgroup_taskset *tset);
-	void (*cancel_attach)(struct cgroup_subsys_state *css,
-			      struct cgroup_taskset *tset);
-	void (*attach)(struct cgroup_subsys_state *css,
-		       struct cgroup_taskset *tset);
+	int (*can_attach)(struct cgroup_taskset *tset);
+	void (*cancel_attach)(struct cgroup_taskset *tset);
+	void (*attach)(struct cgroup_taskset *tset);
 	int (*can_fork)(struct task_struct *task, void **priv_p);
 	void (*cancel_fork)(struct task_struct *task, void *priv);
 	void (*fork)(struct task_struct *task, void *priv);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f640830..cb91b44 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -120,8 +120,10 @@ struct cgroup_subsys_state *css_rightmost_descendant(struct cgroup_subsys_state
 struct cgroup_subsys_state *css_next_descendant_post(struct cgroup_subsys_state *pos,
 						     struct cgroup_subsys_state *css);
 
-struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset);
-struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
+struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset,
+					 struct cgroup_subsys_state **dst_cssp);
+struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
+					struct cgroup_subsys_state **dst_cssp);
 
 void css_task_iter_start(struct cgroup_subsys_state *css,
 			 struct css_task_iter *it);
@@ -236,30 +238,39 @@ void css_task_iter_end(struct css_task_iter *it);
 /**
  * cgroup_taskset_for_each - iterate cgroup_taskset
  * @task: the loop cursor
+ * @dst_css: the destination css
  * @tset: taskset to iterate
  *
  * @tset may contain multiple tasks and they may belong to multiple
- * processes.  When there are multiple tasks in @tset, if a task of a
- * process is in @tset, all tasks of the process are in @tset.  Also, all
- * are guaranteed to share the same source and destination csses.
+ * processes.
+ *
+ * On the v2 hierarchy, there may be tasks from multiple processes and they
+ * may not share the source or destination csses.
+ *
+ * On traditional hierarchies, when there are multiple tasks in @tset, if a
+ * task of a process is in @tset, all tasks of the process are in @tset.
+ * Also, all are guaranteed to share the same source and destination csses.
  *
  * Iteration is not in any specific order.
  */
-#define cgroup_taskset_for_each(task, tset)				\
-	for ((task) = cgroup_taskset_first((tset)); (task);		\
-	     (task) = cgroup_taskset_next((tset)))
+#define cgroup_taskset_for_each(task, dst_css, tset)			\
+	for ((task) = cgroup_taskset_first((tset), &(dst_css));		\
+	     (task);							\
+	     (task) = cgroup_taskset_next((tset), &(dst_css)))
 
 /**
  * cgroup_taskset_for_each_leader - iterate group leaders in a cgroup_taskset
  * @leader: the loop cursor
+ * @dst_css: the destination css
  * @tset: takset to iterate
  *
  * Iterate threadgroup leaders of @tset.  For single-task migrations, @tset
  * may not contain any.
  */
-#define cgroup_taskset_for_each_leader(leader, tset)			\
-	for ((leader) = cgroup_taskset_first((tset)); (leader);		\
-	     (leader) = cgroup_taskset_next((tset)))			\
+#define cgroup_taskset_for_each_leader(leader, dst_css, tset)		\
+	for ((leader) = cgroup_taskset_first((tset), &(dst_css));	\
+	     (leader);							\
+	     (leader) = cgroup_taskset_next((tset), &(dst_css)))	\
 		if ((leader) != (leader)->group_leader)			\
 			;						\
 		else
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5cea63f..470f653 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2237,6 +2237,9 @@ struct cgroup_taskset {
 	struct list_head	src_csets;
 	struct list_head	dst_csets;
 
+	/* the subsys currently being processed */
+	int			ssid;
+
 	/*
 	 * Fields for cgroup_taskset_*() iteration.
 	 *
@@ -2299,25 +2302,29 @@ static void cgroup_taskset_add(struct task_struct *task,
 /**
  * cgroup_taskset_first - reset taskset and return the first task
  * @tset: taskset of interest
+ * @dst_cssp: output variable for the destination css
  *
  * @tset iteration is initialized and the first task is returned.
  */
-struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset)
+struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset,
+					 struct cgroup_subsys_state **dst_cssp)
 {
 	tset->cur_cset = list_first_entry(tset->csets, struct css_set, mg_node);
 	tset->cur_task = NULL;
 
-	return cgroup_taskset_next(tset);
+	return cgroup_taskset_next(tset, dst_cssp);
 }
 
 /**
  * cgroup_taskset_next - iterate to the next task in taskset
  * @tset: taskset of interest
+ * @dst_cssp: output variable for the destination css
  *
  * Return the next task in @tset.  Iteration must have been initialized
  * with cgroup_taskset_first().
  */
-struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
+struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
+					struct cgroup_subsys_state **dst_cssp)
 {
 	struct css_set *cset = tset->cur_cset;
 	struct task_struct *task = tset->cur_task;
@@ -2332,6 +2339,18 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 		if (&task->cg_list != &cset->mg_tasks) {
 			tset->cur_cset = cset;
 			tset->cur_task = task;
+
+			/*
+			 * This function may be called both before and
+			 * after cgroup_taskset_migrate().  The two cases
+			 * can be distinguished by looking at whether @cset
+			 * has its ->mg_dst_cset set.
+			 */
+			if (cset->mg_dst_cset)
+				*dst_cssp = cset->mg_dst_cset->subsys[tset->ssid];
+			else
+				*dst_cssp = cset->subsys[tset->ssid];
+
 			return task;
 		}
 
@@ -2367,7 +2386,8 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	/* check that we can legitimately attach to the cgroup */
 	for_each_e_css(css, i, dst_cgrp) {
 		if (css->ss->can_attach) {
-			ret = css->ss->can_attach(css, tset);
+			tset->ssid = i;
+			ret = css->ss->can_attach(tset);
 			if (ret) {
 				failed_css = css;
 				goto out_cancel_attach;
@@ -2400,9 +2420,12 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 */
 	tset->csets = &tset->dst_csets;
 
-	for_each_e_css(css, i, dst_cgrp)
-		if (css->ss->attach)
-			css->ss->attach(css, tset);
+	for_each_e_css(css, i, dst_cgrp) {
+		if (css->ss->attach) {
+			tset->ssid = i;
+			css->ss->attach(tset);
+		}
+	}
 
 	ret = 0;
 	goto out_release_tset;
@@ -2411,8 +2434,10 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	for_each_e_css(css, i, dst_cgrp) {
 		if (css == failed_css)
 			break;
-		if (css->ss->cancel_attach)
-			css->ss->cancel_attach(css, tset);
+		if (css->ss->cancel_attach) {
+			tset->ssid = i;
+			css->ss->cancel_attach(tset);
+		}
 	}
 out_release_tset:
 	spin_lock_bh(&css_set_lock);
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index ff02a8e..2d3df82 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -155,10 +155,10 @@ static void freezer_css_free(struct cgroup_subsys_state *css)
  * @freezer->lock.  freezer_attach() makes the new tasks conform to the
  * current state and all following state changes can see the new tasks.
  */
-static void freezer_attach(struct cgroup_subsys_state *new_css,
-			   struct cgroup_taskset *tset)
+static void freezer_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
+	struct cgroup_subsys_state *new_css;
 
 	mutex_lock(&freezer_mutex);
 
@@ -172,7 +172,7 @@ static void freezer_attach(struct cgroup_subsys_state *new_css,
 	 * current state before executing the following - !frozen tasks may
 	 * be visible in a FROZEN cgroup and frozen tasks in a THAWED one.
 	 */
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, new_css, tset) {
 		struct freezer *freezer = css_freezer(new_css);
 
 		if (!(freezer->state & CGROUP_FREEZING)) {
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index de3359a..8e27fc5 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -162,13 +162,13 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 	return -EAGAIN;
 }
 
-static int pids_can_attach(struct cgroup_subsys_state *css,
-			   struct cgroup_taskset *tset)
+static int pids_can_attach(struct cgroup_taskset *tset)
 {
-	struct pids_cgroup *pids = css_pids(css);
 	struct task_struct *task;
+	struct cgroup_subsys_state *dst_css;
 
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		struct pids_cgroup *pids = css_pids(dst_css);
 		struct cgroup_subsys_state *old_css;
 		struct pids_cgroup *old_pids;
 
@@ -187,13 +187,13 @@ static int pids_can_attach(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static void pids_cancel_attach(struct cgroup_subsys_state *css,
-			       struct cgroup_taskset *tset)
+static void pids_cancel_attach(struct cgroup_taskset *tset)
 {
-	struct pids_cgroup *pids = css_pids(css);
 	struct task_struct *task;
+	struct cgroup_subsys_state *dst_css;
 
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		struct pids_cgroup *pids = css_pids(dst_css);
 		struct cgroup_subsys_state *old_css;
 		struct pids_cgroup *old_pids;
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 10ae736..02a8ea5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1429,15 +1429,16 @@ static int fmeter_getrate(struct fmeter *fmp)
 static struct cpuset *cpuset_attach_old_cs;
 
 /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
-static int cpuset_can_attach(struct cgroup_subsys_state *css,
-			     struct cgroup_taskset *tset)
+static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
-	struct cpuset *cs = css_cs(css);
+	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 	struct task_struct *task;
 	int ret;
 
 	/* used later by cpuset_attach() */
-	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset));
+	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
+	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -1447,7 +1448,7 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, css, tset) {
 		ret = task_can_attach(task, cs->cpus_allowed);
 		if (ret)
 			goto out_unlock;
@@ -1467,9 +1468,14 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 	return ret;
 }
 
-static void cpuset_cancel_attach(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
+	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
+
+	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
+
 	mutex_lock(&cpuset_mutex);
 	css_cs(css)->attach_in_progress--;
 	mutex_unlock(&cpuset_mutex);
@@ -1482,16 +1488,19 @@ static void cpuset_cancel_attach(struct cgroup_subsys_state *css,
  */
 static cpumask_var_t cpus_attach;
 
-static void cpuset_attach(struct cgroup_subsys_state *css,
-			  struct cgroup_taskset *tset)
+static void cpuset_attach(struct cgroup_taskset *tset)
 {
 	/* static buf protected by cpuset_mutex */
 	static nodemask_t cpuset_attach_nodemask_to;
 	struct task_struct *task;
 	struct task_struct *leader;
-	struct cpuset *cs = css_cs(css);
+	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 	struct cpuset *oldcs = cpuset_attach_old_cs;
 
+	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
+
 	mutex_lock(&cpuset_mutex);
 
 	/* prepare for attach */
@@ -1502,7 +1511,7 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, css, tset) {
 		/*
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
@@ -1518,7 +1527,7 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	 * sleep and should be moved outside migration path proper.
 	 */
 	cpuset_attach_nodemask_to = cs->effective_mems;
-	cgroup_taskset_for_each_leader(leader, tset) {
+	cgroup_taskset_for_each_leader(leader, css, tset) {
 		struct mm_struct *mm = get_task_mm(leader);
 
 		if (mm) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 36babfd..026305d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9456,12 +9456,12 @@ static int __perf_cgroup_move(void *info)
 	return 0;
 }
 
-static void perf_cgroup_attach(struct cgroup_subsys_state *css,
-			       struct cgroup_taskset *tset)
+static void perf_cgroup_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
+	struct cgroup_subsys_state *css;
 
-	cgroup_taskset_for_each(task, tset)
+	cgroup_taskset_for_each(task, css, tset)
 		task_function_call(task, __perf_cgroup_move, task);
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4d568ac..a9db4819 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8217,12 +8217,12 @@ static void cpu_cgroup_fork(struct task_struct *task, void *private)
 	sched_move_task(task);
 }
 
-static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static int cpu_cgroup_can_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
+	struct cgroup_subsys_state *css;
 
-	cgroup_taskset_for_each(task, tset) {
+	cgroup_taskset_for_each(task, css, tset) {
 #ifdef CONFIG_RT_GROUP_SCHED
 		if (!sched_rt_can_attach(css_tg(css), task))
 			return -EINVAL;
@@ -8235,12 +8235,12 @@ static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static void cpu_cgroup_attach(struct cgroup_subsys_state *css,
-			      struct cgroup_taskset *tset)
+static void cpu_cgroup_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
+	struct cgroup_subsys_state *css;
 
-	cgroup_taskset_for_each(task, tset)
+	cgroup_taskset_for_each(task, css, tset)
 		sched_move_task(task);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9acfb16..c92a65b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4779,23 +4779,18 @@ static void mem_cgroup_clear_mc(void)
 	spin_unlock(&mc.lock);
 }
 
-static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
 	struct mem_cgroup *from;
 	struct task_struct *leader, *p;
 	struct mm_struct *mm;
 	unsigned long move_flags;
 	int ret = 0;
 
-	/*
-	 * We are now commited to this value whatever it is. Changes in this
-	 * tunable will only affect upcoming migrations, not the current one.
-	 * So we need to save it, and keep it going.
-	 */
-	move_flags = READ_ONCE(memcg->move_charge_at_immigrate);
-	if (!move_flags)
+	/* charge immigration isn't supported on the default hierarchy */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
 	/*
@@ -4805,13 +4800,23 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 	 * multiple.
 	 */
 	p = NULL;
-	cgroup_taskset_for_each_leader(leader, tset) {
+	cgroup_taskset_for_each_leader(leader, css, tset) {
 		WARN_ON_ONCE(p);
 		p = leader;
+		memcg = mem_cgroup_from_css(css);
 	}
 	if (!p)
 		return 0;
 
+	/*
+	 * We are now commited to this value whatever it is. Changes in this
+	 * tunable will only affect upcoming migrations, not the current one.
+	 * So we need to save it, and keep it going.
+	 */
+	move_flags = READ_ONCE(memcg->move_charge_at_immigrate);
+	if (!move_flags)
+		return 0;
+
 	from = mem_cgroup_from_task(p);
 
 	VM_BUG_ON(from == memcg);
@@ -4842,8 +4847,7 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 	return ret;
 }
 
-static void mem_cgroup_cancel_attach(struct cgroup_subsys_state *css,
-				     struct cgroup_taskset *tset)
+static void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
 {
 	if (mc.to)
 		mem_cgroup_clear_mc();
@@ -4985,10 +4989,10 @@ static void mem_cgroup_move_charge(struct mm_struct *mm)
 	atomic_dec(&mc.from->moving_account);
 }
 
-static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static void mem_cgroup_move_task(struct cgroup_taskset *tset)
 {
-	struct task_struct *p = cgroup_taskset_first(tset);
+	struct cgroup_subsys_state *css;
+	struct task_struct *p = cgroup_taskset_first(tset, &css);
 	struct mm_struct *mm = get_task_mm(p);
 
 	if (mm) {
@@ -5000,17 +5004,14 @@ static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
 		mem_cgroup_clear_mc();
 }
 #else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 {
 	return 0;
 }
-static void mem_cgroup_cancel_attach(struct cgroup_subsys_state *css,
-				     struct cgroup_taskset *tset)
+static void mem_cgroup_cancel_attach(struct cgroup_taskset *tset)
 {
 }
-static void mem_cgroup_move_task(struct cgroup_subsys_state *css,
-				 struct cgroup_taskset *tset)
+static void mem_cgroup_move_task(struct cgroup_taskset *tset)
 {
 }
 #endif
diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 6441f47..81cb3c7 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -67,14 +67,15 @@ static int update_classid(const void *v, struct file *file, unsigned n)
 	return 0;
 }
 
-static void cgrp_attach(struct cgroup_subsys_state *css,
-			struct cgroup_taskset *tset)
+static void cgrp_attach(struct cgroup_taskset *tset)
 {
-	struct cgroup_cls_state *cs = css_cls_state(css);
-	void *v = (void *)(unsigned long)cs->classid;
 	struct task_struct *p;
+	struct cgroup_subsys_state *css;
+
+	cgroup_taskset_for_each(p, css, tset) {
+		struct cgroup_cls_state *cs = css_cls_state(css);
+		void *v = (void *)(unsigned long)cs->classid;
 
-	cgroup_taskset_for_each(p, tset) {
 		task_lock(p);
 		iterate_fd(p->files, 0, update_classid, v);
 		task_unlock(p);
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index cbd0a19..40fd09f 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -218,13 +218,14 @@ static int update_netprio(const void *v, struct file *file, unsigned n)
 	return 0;
 }
 
-static void net_prio_attach(struct cgroup_subsys_state *css,
-			    struct cgroup_taskset *tset)
+static void net_prio_attach(struct cgroup_taskset *tset)
 {
 	struct task_struct *p;
-	void *v = (void *)(unsigned long)css->cgroup->id;
+	struct cgroup_subsys_state *css;
+
+	cgroup_taskset_for_each(p, css, tset) {
+		void *v = (void *)(unsigned long)css->cgroup->id;
 
-	cgroup_taskset_for_each(p, tset) {
 		task_lock(p);
 		iterate_fd(p->files, 0, update_netprio, v);
 		task_unlock(p);
-- 
2.5.0
