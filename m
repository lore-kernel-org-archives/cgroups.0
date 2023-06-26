From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] sched/psi: tie psi trigger destruction with file's lifecycle
Date: Mon, 26 Jun 2023 13:17:13 -0700
Message-ID: <20230626201713.1204982-2-surenb@google.com>
References: <20230626201713.1204982-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687810639; x=1690402639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq8+wU1+ftupKRzTavGvuGzAv+IrA9NsG4RPXvRV+Hg=;
        b=2d0SSP77yGd4ZQlpVXn6Esny2V4NSGEGR5oafruotot9uscE8sjU7Jh7A1DGeOTqy9
         CuMWKEY+FRpMia9A/yIf99c2NWkCdQ+wZHAKbW2FOxGXxyX7aZvduGJ7958Ph98CQkDu
         g7Kfp5+LOAEeEs5cXK4CeqrYApQd9Rj/qgUuwVTdstap1H6fmBPcQRRdWXzgb3dLOpoa
         lkkP4QVsYQ5JwA83o0mir5tTEY8n8DJhts7Th2lGirLGMgxwcksn5pyklD+lH2E/4Tae
         5uIu1VHl7k1u5gwH52OcxLWPX8PcO/5UV3kKAsmY/m3YgBVRz/cX2PaSWor0jCNPj5ra
         3jiA==
In-Reply-To: <20230626201713.1204982-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Destroying psi trigger in cgroup_file_release causes UAF issues when
a cgroup is removed from under a polling process. This is happening
because cgroup removal causes a call to cgroup_file_release via this
path:

do_rmdir
  cgroup_rmdir
    kernfs_drain_open_files
      cgroup_file_release
        cgroup_pressure_release

while the actual file is still alive. Destroying the trigger at this
point would also destroy its waitqueue head and if there is still a
polling process on that file accessing the waitqueue, it will step
on a freed pointer.
Patch [1] fixed this issue for epoll() case using wake_up_pollfree(),
however the same issue exists for synchronous poll() case.
The root cause of this issue is that the lifecycles of the psi trigger's
waitqueue and of the file associated with the trigger are different. Fix
this by destroying the trigger from inside kernfs_ops.free operation
which is tied to the last fput() of the file. This also renders the fix
in [1] obsolete, so revert it.

[1] commit c2dbe32d5db5 ("sched/psi: Fix use-after-free in ep_remove_wait_queue()")

Reported-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Closes: https://lore.kernel.org/all/20230613062306.101831-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup-defs.h |  1 +
 include/linux/psi.h         |  6 +++++-
 kernel/cgroup/cgroup.c      | 29 ++++++++++++++++++++++++++++-
 kernel/sched/psi.c          | 13 ++++++-------
 4 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a0d5466c7be..6f5230a8821f 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -598,6 +598,7 @@ struct cftype {
 
 	int (*open)(struct kernfs_open_file *of);
 	void (*release)(struct kernfs_open_file *of);
+	void (*free)(struct kernfs_open_file *of);
 
 	/*
 	 * read_u64() is a shortcut for the common case of returning a
diff --git a/include/linux/psi.h b/include/linux/psi.h
index ab26200c2803..ebb4c7efba84 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -25,7 +25,11 @@ void psi_memstall_leave(unsigned long *flags);
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 struct psi_trigger *psi_trigger_create(struct psi_group *group,
 			char *buf, enum psi_res res, struct file *file);
-void psi_trigger_destroy(struct psi_trigger *t);
+void psi_trigger_disable(struct psi_trigger *t);
+static inline void psi_trigger_destroy(struct psi_trigger *t)
+{
+	kfree(t);
+}
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 			poll_table *wait);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4d42f0cbc11e..62e91ce6ca20 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3895,6 +3895,13 @@ static void cgroup_pressure_release(struct kernfs_open_file *of)
 {
 	struct cgroup_file_ctx *ctx = of->priv;
 
+	psi_trigger_disable(ctx->psi.trigger);
+}
+
+static void cgroup_pressure_free(struct kernfs_open_file *of)
+{
+	struct cgroup_file_ctx *ctx = of->priv;
+
 	psi_trigger_destroy(ctx->psi.trigger);
 }
 
@@ -4055,7 +4062,21 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 	if (cft->release)
 		cft->release(of);
 	put_cgroup_ns(ctx->ns);
-	kfree(ctx);
+	/* Keep the context alive until cft->free is called */
+	if (!cft->free)
+		kfree(ctx);
+}
+
+static void cgroup_file_free(struct kernfs_open_file *of)
+{
+	struct cftype *cft = of_cft(of);
+
+	if (cft->free) {
+		struct cgroup_file_ctx *ctx = of->priv;
+
+		cft->free(of);
+		kfree(ctx);
+	}
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
@@ -4158,6 +4179,7 @@ static struct kernfs_ops cgroup_kf_single_ops = {
 	.atomic_write_len	= PAGE_SIZE,
 	.open			= cgroup_file_open,
 	.release		= cgroup_file_release,
+	.free			= cgroup_file_free,
 	.write			= cgroup_file_write,
 	.poll			= cgroup_file_poll,
 	.seq_show		= cgroup_seqfile_show,
@@ -4167,6 +4189,7 @@ static struct kernfs_ops cgroup_kf_ops = {
 	.atomic_write_len	= PAGE_SIZE,
 	.open			= cgroup_file_open,
 	.release		= cgroup_file_release,
+	.free			= cgroup_file_free,
 	.write			= cgroup_file_write,
 	.poll			= cgroup_file_poll,
 	.seq_start		= cgroup_seqfile_start,
@@ -5294,6 +5317,7 @@ static struct cftype cgroup_psi_files[] = {
 		.write = cgroup_io_pressure_write,
 		.poll = cgroup_pressure_poll,
 		.release = cgroup_pressure_release,
+		.free = cgroup_pressure_free,
 	},
 	{
 		.name = "memory.pressure",
@@ -5302,6 +5326,7 @@ static struct cftype cgroup_psi_files[] = {
 		.write = cgroup_memory_pressure_write,
 		.poll = cgroup_pressure_poll,
 		.release = cgroup_pressure_release,
+		.free = cgroup_pressure_free,
 	},
 	{
 		.name = "cpu.pressure",
@@ -5310,6 +5335,7 @@ static struct cftype cgroup_psi_files[] = {
 		.write = cgroup_cpu_pressure_write,
 		.poll = cgroup_pressure_poll,
 		.release = cgroup_pressure_release,
+		.free = cgroup_pressure_free,
 	},
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	{
@@ -5319,6 +5345,7 @@ static struct cftype cgroup_psi_files[] = {
 		.write = cgroup_irq_pressure_write,
 		.poll = cgroup_pressure_poll,
 		.release = cgroup_pressure_release,
+		.free = cgroup_pressure_free,
 	},
 #endif
 	{
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index e072f6b31bf3..b4ad50805e08 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -622,7 +622,7 @@ static void psi_schedule_rtpoll_work(struct psi_group *group, unsigned long dela
 
 	task = rcu_dereference(group->rtpoll_task);
 	/*
-	 * kworker might be NULL in case psi_trigger_destroy races with
+	 * kworker might be NULL in case psi_trigger_disable races with
 	 * psi_task_change (hotpath) which can't use locks
 	 */
 	if (likely(task))
@@ -1372,7 +1372,7 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	return t;
 }
 
-void psi_trigger_destroy(struct psi_trigger *t)
+void psi_trigger_disable(struct psi_trigger *t)
 {
 	struct psi_group *group;
 	struct task_struct *task_to_destroy = NULL;
@@ -1386,11 +1386,10 @@ void psi_trigger_destroy(struct psi_trigger *t)
 
 	group = t->group;
 	/*
-	 * Wakeup waiters to stop polling and clear the queue to prevent it from
-	 * being accessed later. Can happen if cgroup is deleted from under a
-	 * polling process.
+	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
+	 * from under a polling process.
 	 */
-	wake_up_pollfree(&t->event_wait);
+	wake_up_interruptible(&t->event_wait);
 
 	if (t->aggregator == PSI_AVGS) {
 		mutex_lock(&group->avgs_lock);
@@ -1446,7 +1445,6 @@ void psi_trigger_destroy(struct psi_trigger *t)
 		kthread_stop(task_to_destroy);
 		atomic_set(&group->rtpoll_scheduled, 0);
 	}
-	kfree(t);
 }
 
 __poll_t psi_trigger_poll(void **trigger_ptr,
@@ -1573,6 +1571,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 
+	psi_trigger_disable(seq->private);
 	psi_trigger_destroy(seq->private);
 	return single_release(inode, file);
 }
-- 
2.41.0.162.gfafddb0af9-goog

