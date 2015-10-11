From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 14/14] cgroup: add cgroup_subsys->free() method and use it to fix pids controller
Date: Sun, 11 Oct 2015 09:30:10 -0400
Message-ID: <1444570210-15640-4-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b5RNPQk8KtFGZe8/spnupEOSN/vBY6sN95opynmwNPg=;
        b=y5RtjZy2Ejf8hFWPqZkwIVm+19mCHq19RyQ8SIhysSp+SN3NdcKetg6Aq4uNalUeeD
         H64GRZycVNivoT6ig6FGgHCnv0WL+zwW0gG7rYt5Ov7LLf9pokZr57mQVvGKDkIIUpuz
         leAKicgGyXHvHWXHd6toBAQzEBOlz7RvFB5KkkOwa9/K8LbwQfUfYBsOcgP4VG7Dq0Mm
         WTsH94qxLXhHQcjVC7BhCQKfsJtI5EVqOKI4EfdZkCZ6GCq+iWNYSJ3QYbD+vjuEQmUl
         Jle2Z+UzqLfLm0CGkUFagHnrDRCFZ7sdriAsl2qqEhHkaSxuJpUqL7hnENJtaIIP3A6O
         Y+TA==
In-Reply-To: <1444447781-16182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

pids controller is completely broken in that it uncharges when a task
exits allowing zombies to escape resource control.  With the recent
updates, cgroup core now maintains cgroup association till task free
and pids controller can be fixed by uncharging on free instead of
exit.

This patch adds cgroup_subsys->free() method and update pids
controller to use it instead of ->exit() for uncharging.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/cgroups.txt | 4 ++++
 include/linux/cgroup-defs.h       | 1 +
 kernel/cgroup.c                   | 7 +++++++
 kernel/cgroup_pids.c              | 4 ++--
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index f935fac..c6256ae 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -637,6 +637,10 @@ void exit(struct task_struct *task)
 
 Called during task exit.
 
+void free(struct task_struct *task)
+
+Called when the task_struct is freed.
+
 void bind(struct cgroup *root)
 (cgroup_mutex held by caller)
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 6a1ab64..60d44b2 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -436,6 +436,7 @@ struct cgroup_subsys {
 	void (*cancel_fork)(struct task_struct *task, void *priv);
 	void (*fork)(struct task_struct *task, void *priv);
 	void (*exit)(struct task_struct *task);
+	void (*free)(struct task_struct *task);
 	void (*bind)(struct cgroup_subsys_state *root_css);
 
 	int early_init;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0bfab7c..21318e7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -206,6 +206,7 @@ static u64 css_serial_nr_next = 1;
  */
 static unsigned long have_fork_callback __read_mostly;
 static unsigned long have_exit_callback __read_mostly;
+static unsigned long have_free_callback __read_mostly;
 
 /* Ditto for the can_fork callback. */
 static unsigned long have_canfork_callback __read_mostly;
@@ -5174,6 +5175,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	have_fork_callback |= (bool)ss->fork << ss->id;
 	have_exit_callback |= (bool)ss->exit << ss->id;
+	have_free_callback |= (bool)ss->free << ss->id;
 	have_canfork_callback |= (bool)ss->can_fork << ss->id;
 
 	/* At system boot, before all subsystems have been
@@ -5631,6 +5633,11 @@ void cgroup_exit(struct task_struct *tsk)
 void cgroup_free(struct task_struct *task)
 {
 	struct css_set *cset = task_css_set(task);
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	for_each_subsys_which(ss, ssid, &have_free_callback)
+		ss->free(task);
 
 	put_css_set(cset);
 }
diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index 45f0856..cdd8df4 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -266,7 +266,7 @@ static void pids_fork(struct task_struct *task, void *priv)
 	css_put(old_css);
 }
 
-static void pids_exit(struct task_struct *task)
+static void pids_free(struct task_struct *task)
 {
 	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
 
@@ -347,7 +347,7 @@ struct cgroup_subsys pids_cgrp_subsys = {
 	.can_fork	= pids_can_fork,
 	.cancel_fork	= pids_cancel_fork,
 	.fork		= pids_fork,
-	.exit		= pids_exit,
+	.free		= pids_free,
 	.legacy_cftypes	= pids_files,
 	.dfl_cftypes	= pids_files,
 };
-- 
2.4.3
