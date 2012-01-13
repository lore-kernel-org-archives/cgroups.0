From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] cgroups: allow subsystems to cancel a fork
Date: Fri, 13 Jan 2012 19:13:58 +0100
Message-ID: <1326478441-3048-15-git-send-email-fweisbec@gmail.com>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=PFE+eijWbl1LWvNNr2in/UI2YjxNJPoa0rBXsG8+Z1E=;
        b=Y3dLai9FWoIRanrhUobycF55sT+6VxSC1m81H2LYCqCOt+8TH/Uq07Y+rdzzT4JDvS
         41OTT0D6eGuLCN7tsYDpFgOhVyqolCK2tJqQcfr2BXcRaR1USsyyAAhr4uHq/T2HN/9B
         V3i3hSTt+EN6LhOMXJku3piwIqpvoaoBEkX7g=
In-Reply-To: <1326478441-3048-1-git-send-email-fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Let the subsystem's fork callback return an error value so that they can
cancel a fork.  This is going to be used by the task counter subsystem to
implement the limit.

Suggested-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
 include/linux/cgroup.h  |   20 ++++++++++++++------
 kernel/cgroup.c         |   23 +++++++++++++++++++----
 kernel/cgroup_freezer.c |    6 ++++--
 kernel/exit.c           |    2 +-
 kernel/fork.c           |    7 +++++--
 5 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7ad5e40..095e66d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,10 +17,11 @@
 #include <linux/rwsem.h>
 #include <linux/idr.h>
 
+struct cgroup_subsys;
+
 #ifdef CONFIG_CGROUPS
 
 struct cgroupfs_root;
-struct cgroup_subsys;
 struct inode;
 struct cgroup;
 struct css_id;
@@ -32,9 +33,11 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
+extern int cgroup_fork_callbacks(struct task_struct *p,
+				 struct cgroup_subsys **failed_ss);
 extern void cgroup_post_fork(struct task_struct *p);
-extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_exit(struct task_struct *p, int run_callbacks,
+			struct cgroup_subsys *failed_ss);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 extern int cgroup_load_subsys(struct cgroup_subsys *ss);
@@ -494,7 +497,7 @@ struct cgroup_subsys {
 			      struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup_taskset *tset);
-	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
+	int (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			struct cgroup *old_cgrp, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
@@ -651,9 +654,14 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
-static inline void cgroup_fork_callbacks(struct task_struct *p) {}
+static inline int cgroup_fork_callbacks(struct task_struct *p,
+					struct cgroup_subsys **failed_ss)
+{
+	return 0;
+}
 static inline void cgroup_post_fork(struct task_struct *p) {}
-static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
+static inline void cgroup_exit(struct task_struct *p, int callbacks,
+			       struct cgroup_subsys *failed_ss) {}
 
 static inline void cgroup_lock(void) {}
 static inline void cgroup_unlock(void) {}
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 39c7cae..109530a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4568,8 +4568,11 @@ void cgroup_fork(struct task_struct *child)
  * tasklist. No need to take any locks since no-one can
  * be operating on this task.
  */
-void cgroup_fork_callbacks(struct task_struct *child)
+int cgroup_fork_callbacks(struct task_struct *child,
+			  struct cgroup_subsys **failed_ss)
 {
+	int err;
+
 	if (need_forkexit_callback) {
 		int i;
 		/*
@@ -4579,10 +4582,17 @@ void cgroup_fork_callbacks(struct task_struct *child)
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(ss, child);
+			if (ss->fork) {
+				err = ss->fork(ss, child);
+				if (err) {
+					*failed_ss = ss;
+					return err;
+				}
+			}
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -4649,7 +4659,8 @@ void cgroup_post_fork(struct task_struct *child)
  *    which wards off any cgroup_attach_task() attempts, or task is a failed
  *    fork, never visible to cgroup_attach_task.
  */
-void cgroup_exit(struct task_struct *tsk, int run_callbacks)
+void cgroup_exit(struct task_struct *tsk, int run_callbacks,
+		 struct cgroup_subsys *failed_ss)
 {
 	struct css_set *cg;
 	int i;
@@ -4678,6 +4689,10 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 		 */
 		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
+
+			if (ss == failed_ss)
+				break;
+
 			if (ss->exit) {
 				struct cgroup *old_cgrp =
 					rcu_dereference_raw(cg->subsys[i])->cgroup;
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 0e74805..6cdce8f 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -178,7 +178,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 	return 0;
 }
 
-static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
+static int freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
 
@@ -198,7 +198,7 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		return 0;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -207,6 +207,8 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task);
 	spin_unlock_irq(&freezer->lock);
+
+	return 0;
 }
 
 /*
diff --git a/kernel/exit.c b/kernel/exit.c
index 95a4141..b9728d9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -990,7 +990,7 @@ NORET_TYPE void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
-	cgroup_exit(tsk, 1);
+	cgroup_exit(tsk, 1, NULL);
 
 	if (group_dead)
 		disassociate_ctty(1);
diff --git a/kernel/fork.c b/kernel/fork.c
index d4ac9e3..097c597 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1049,6 +1049,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	struct cgroup_subsys *cgroup_failed_ss = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1306,8 +1307,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
+	retval = cgroup_fork_callbacks(p, &cgroup_failed_ss);
 	cgroup_callbacks_done = 1;
+	if (retval)
+		goto bad_fork_free_pid;
 
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
@@ -1408,7 +1411,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, cgroup_callbacks_done, cgroup_failed_ss);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.7.5.4
