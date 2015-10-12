From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 13/14] cgroup: keep zombies associated with their original
 cgroups
Date: Mon, 12 Oct 2015 13:44:15 -0400
Message-ID: <20151012174415.GA27198@htj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <1444570210-15640-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZKbCr0M6lqrlKVagOAEaIMnPoFyGlIvoAK+guAZZRjc=;
        b=u0AaPRGKxDYxXtgsydBkraIVhj7Bid8IVy/87m5mMI2Dm++DzTjevvuD/piD2b5F5x
         phVuHcEywPwfx5EBZtF4xY0SKyphOYFZaM1jiXxXDGrzQJjE/Dg+TpT8apD71E3EN4Ow
         0vra9sLfqyOI1Dbm29iYnsxwAV6wBAs2X3h7LtbiasJG7kBMg2FsojdVV3AgSDkmtTsc
         hEsO5DItDtSurFt77LrBLtXiV5YVPaDon+2jzDWncaQ1/sF6dcrfCL4lLJrLtkqr6MPM
         q76PG69WFWrLIUzcT/Erae9BepRbr076X147+VVZdVvJZc4lYvGn+PAO8uN+Z5cBUe1N
         wurg==
Content-Disposition: inline
In-Reply-To: <1444570210-15640-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From 202cd16bb2011fc09488683b57eb68967bda9373 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 12 Oct 2015 13:43:29 -0400

cgroup_exit() is called when a task exits and disassociates the
exiting task from its cgroups and half-attach it to the root cgroup.
This is unnecessary and undesirable.

No controller actually needs an exiting task to be disassociated with
non-root cgroups.  Both cpu and perf_event controllers update the
association to the root cgroup from their exit callbacks just to keep
consistent with the cgroup core behavior.

Also, this disassociation makes it difficult to track resources held
by zombies or determine where the zombies came from.  Currently, pids
controller is completely broken as it uncharges on exit and zombies
always escape the resource restriction.  With cgroup association being
reset on exit, fixing it is pretty painful.

There's no reason to reset cgroup membership on exit.  The zombie can
be removed from its css_set so that it doesn't show up on
"cgroup.procs" and thus can't be migrated or interfere with cgroup
removal.  It can still pin and point to the css_set so that its cgroup
membership is maintained.  This patch makes cgroup core keep zombies
associated with their cgroups at the time of exit.

* Previous patches decoupled populated_cnt tracking from css_set
  lifetime, so a dying task can be simply unlinked from its css_set
  while pinning and pointing to the css_set.  This keeps css_set
  association from task side alive while hiding it from "cgroup.procs"
  and populated_cnt tracking.  The css_set reference is dropped when
  the task_struct is freed.

* ->exit() callback no longer needs the css arguments as the
  associated css never changes once PF_EXITING is set.  Removed.

* cpu and perf_events controllers no longer need ->exit() callbacks.
  There's no reason to explicitly switch away on exit.  The final
  schedule out is enough.  The callbacks are removed.

* On traditional hierarchies, nothing changes.  "/proc/PID/cgroup"
  still reports "/" for all zombies.  On the default hierarchy,
  "/proc/PID/cgroup" keeps reporting the cgroup that the task belonged
  to at the time of exit.  If the cgroup gets removed before the task
  is reaped, " (deleted)" is appended.

v2: Build brekage due to missing dummy cgroup_free() when
    !CONFIG_CGROUP fixed.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  4 +++
 include/linux/cgroup-defs.h                 |  4 +--
 include/linux/cgroup.h                      |  2 ++
 kernel/cgroup.c                             | 51 +++++++++++++++++++----------
 kernel/cgroup_pids.c                        |  6 ++--
 kernel/events/core.c                        | 16 ---------
 kernel/fork.c                               |  1 +
 kernel/sched/core.c                         | 16 ---------
 8 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 176b940..6932453 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -374,6 +374,10 @@ supported and the interface files "release_agent" and
 
 - The "cgroup.clone_children" file is removed.
 
+- /proc/PID/cgroup keeps reporting the cgroup that a zombie belonged
+  to before exiting.  If the cgroup is removed before the zombie is
+  reaped, " (deleted)" is appeneded to the path.
+
 
 5-3. Controller File Conventions
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 62413c3..6a1ab64 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -435,9 +435,7 @@ struct cgroup_subsys {
 	int (*can_fork)(struct task_struct *task, void **priv_p);
 	void (*cancel_fork)(struct task_struct *task, void *priv);
 	void (*fork)(struct task_struct *task, void *priv);
-	void (*exit)(struct cgroup_subsys_state *css,
-		     struct cgroup_subsys_state *old_css,
-		     struct task_struct *task);
+	void (*exit)(struct task_struct *task);
 	void (*bind)(struct cgroup_subsys_state *root_css);
 
 	int early_init;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4602073..22e3754 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -102,6 +102,7 @@ extern void cgroup_cancel_fork(struct task_struct *p,
 extern void cgroup_post_fork(struct task_struct *p,
 			     void *old_ss_priv[CGROUP_CANFORK_COUNT]);
 void cgroup_exit(struct task_struct *p);
+void cgroup_free(struct task_struct *p);
 
 int cgroup_init_early(void);
 int cgroup_init(void);
@@ -547,6 +548,7 @@ static inline void cgroup_cancel_fork(struct task_struct *p,
 static inline void cgroup_post_fork(struct task_struct *p,
 				    void *ss_priv[CGROUP_CANFORK_COUNT]) {}
 static inline void cgroup_exit(struct task_struct *p) {}
+static inline void cgroup_free(struct task_struct *p) {}
 
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0bfa26a..0bfab7c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5373,14 +5373,34 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
 		seq_putc(m, ':');
+
 		cgrp = task_cgroup_from_root(tsk, root);
-		path = cgroup_path(cgrp, buf, PATH_MAX);
-		if (!path) {
-			retval = -ENAMETOOLONG;
-			goto out_unlock;
+
+		/*
+		 * On traditional hierarchies, all zombie tasks show up as
+		 * belonging to the root cgroup.  On the default hierarchy,
+		 * while a zombie doesn't show up in "cgroup.procs" and
+		 * thus can't be migrated, its /proc/PID/cgroup keeps
+		 * reporting the cgroup it belonged to before exiting.  If
+		 * the cgroup is removed before the zombie is reaped,
+		 * " (deleted)" is appended to the cgroup path.
+		 */
+		if (cgroup_on_dfl(cgrp) || !(tsk->flags & PF_EXITING)) {
+			path = cgroup_path(cgrp, buf, PATH_MAX);
+			if (!path) {
+				retval = -ENAMETOOLONG;
+				goto out_unlock;
+			}
+		} else {
+			path = "/";
 		}
+
 		seq_puts(m, path);
-		seq_putc(m, '\n');
+
+		if (cgroup_on_dfl(cgrp) && cgroup_is_dead(cgrp))
+			seq_puts(m, " (deleted)\n");
+		else
+			seq_putc(m, '\n');
 	}
 
 	retval = 0;
@@ -5587,7 +5607,6 @@ void cgroup_exit(struct task_struct *tsk)
 {
 	struct cgroup_subsys *ss;
 	struct css_set *cset;
-	bool put_cset = false;
 	int i;
 
 	/*
@@ -5600,22 +5619,20 @@ void cgroup_exit(struct task_struct *tsk)
 		spin_lock_bh(&css_set_lock);
 		css_set_move_task(tsk, cset, NULL, false);
 		spin_unlock_bh(&css_set_lock);
-		put_cset = true;
+	} else {
+		get_css_set(cset);
 	}
 
-	/* Reassign the task to the init_css_set. */
-	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
-
 	/* see cgroup_post_fork() for details */
-	for_each_subsys_which(ss, i, &have_exit_callback) {
-		struct cgroup_subsys_state *old_css = cset->subsys[i];
-		struct cgroup_subsys_state *css = task_css(tsk, i);
+	for_each_subsys_which(ss, i, &have_exit_callback)
+		ss->exit(tsk);
+}
 
-		ss->exit(css, old_css, tsk);
-	}
+void cgroup_free(struct task_struct *task)
+{
+	struct css_set *cset = task_css_set(task);
 
-	if (put_cset)
-		put_css_set(cset);
+	put_css_set(cset);
 }
 
 static void check_for_release(struct cgroup *cgrp)
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 806cd76..45f0856 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -266,11 +266,9 @@ static void pids_fork(struct task_struct *task, void *priv)
 	css_put(old_css);
 }
 
-static void pids_exit(struct cgroup_subsys_state *css,
-		      struct cgroup_subsys_state *old_css,
-		      struct task_struct *task)
+static void pids_exit(struct task_struct *task)
 {
-	struct pids_cgroup *pids = css_pids(old_css);
+	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
 
 	pids_uncharge(pids, 1);
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f548f69..e987494 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9293,25 +9293,9 @@ static void perf_cgroup_attach(struct cgroup_subsys_state *css,
 		task_function_call(task, __perf_cgroup_move, task);
 }
 
-static void perf_cgroup_exit(struct cgroup_subsys_state *css,
-			     struct cgroup_subsys_state *old_css,
-			     struct task_struct *task)
-{
-	/*
-	 * cgroup_exit() is called in the copy_process() failure path.
-	 * Ignore this case since the task hasn't ran yet, this avoids
-	 * trying to poke a half freed task state from generic code.
-	 */
-	if (!(task->flags & PF_EXITING))
-		return;
-
-	task_function_call(task, __perf_cgroup_move, task);
-}
-
 struct cgroup_subsys perf_event_cgrp_subsys = {
 	.css_alloc	= perf_cgroup_css_alloc,
 	.css_free	= perf_cgroup_css_free,
-	.exit		= perf_cgroup_exit,
 	.attach		= perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
diff --git a/kernel/fork.c b/kernel/fork.c
index 7d5f0f1..118743b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -251,6 +251,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	cgroup_free(tsk);
 	task_numa_free(tsk);
 	security_task_free(tsk);
 	exit_creds(tsk);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3595403..2cad9ba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8163,21 +8163,6 @@ static void cpu_cgroup_attach(struct cgroup_subsys_state *css,
 		sched_move_task(task);
 }
 
-static void cpu_cgroup_exit(struct cgroup_subsys_state *css,
-			    struct cgroup_subsys_state *old_css,
-			    struct task_struct *task)
-{
-	/*
-	 * cgroup_exit() is called in the copy_process() failure path.
-	 * Ignore this case since the task hasn't ran yet, this avoids
-	 * trying to poke a half freed task state from generic code.
-	 */
-	if (!(task->flags & PF_EXITING))
-		return;
-
-	sched_move_task(task);
-}
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_u64(struct cgroup_subsys_state *css,
 				struct cftype *cftype, u64 shareval)
@@ -8509,7 +8494,6 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.exit		= cpu_cgroup_exit,
 	.legacy_cftypes	= cpu_files,
 	.early_init	= 1,
 };
-- 
2.4.3
