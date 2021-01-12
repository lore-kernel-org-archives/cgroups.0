From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] sched/deadline: Inform dl_task_can_attach() if the cpuset is exclusive
Date: Tue, 12 Jan 2021 16:53:41 +0100
Message-ID: <2c971b6bfb1b674968a0dc522c686f731f7b5c74.1610463999.git.bristot@redhat.com>
References: <cover.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVTn9uzhFOad5xyTB/kfLY4qPum0kGTy6dbZu/jw7w0=;
        b=bLbLI+IVdlk7mRAY7Jsd2PuyAjz+F1goXQ7CN7rwillHPWutdi3iAAU+Pv/y9wAJYFJOaU
        bA0MfPgpYX0MR7207oQSjVLcX3J6PWnr+nRLnW3CreX8uih6oWutydUN6bU78+UFx6R8D7
        xSW7S565Tlixj0xv1BM6jpHtPwUxpbw=
In-Reply-To: <cover.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In preparation for blocking SCHED_DEADLINE tasks on non-exclusive cpuset
if bandwidth control is enabled.

No functional changes.

Signed-off-by: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/sched.h   | 2 +-
 kernel/cgroup/cpuset.c  | 5 ++++-
 kernel/sched/core.c     | 4 ++--
 kernel/sched/deadline.c | 3 ++-
 kernel/sched/sched.h    | 2 +-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 942b87f80cc7..9525fbe032c9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1654,7 +1654,7 @@ current_restore_flags(unsigned long orig_flags, unsigned long flags)
 }
 
 extern int cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
-extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed);
+extern int task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed, int exclusive);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 53c70c470a38..c6513dfabd3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2132,6 +2132,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
 	struct task_struct *task;
+	int exclusive;
 	int ret;
 
 	/* used later by cpuset_attach() */
@@ -2146,8 +2147,10 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
 		goto out_unlock;
 
+	exclusive = is_cpu_exclusive(cs);
+
 	cgroup_taskset_for_each(task, css, tset) {
-		ret = task_can_attach(task, cs->cpus_allowed);
+		ret = task_can_attach(task, cs->cpus_allowed, exclusive);
 		if (ret)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f4aede34449c..5961a97541c2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7124,7 +7124,7 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 }
 
 int task_can_attach(struct task_struct *p,
-		    const struct cpumask *cs_cpus_allowed)
+		    const struct cpumask *cs_cpus_allowed, int exclusive)
 {
 	int ret = 0;
 
@@ -7143,7 +7143,7 @@ int task_can_attach(struct task_struct *p,
 	}
 
 	if (dl_task(p))
-		ret = dl_task_can_attach(p, cs_cpus_allowed);
+		ret = dl_task_can_attach(p, cs_cpus_allowed, exclusive);
 
 out:
 	return ret;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c97d2c707b98..943aa32cc1bc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2862,7 +2862,8 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 }
 
 #ifdef CONFIG_SMP
-int dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed)
+int dl_task_can_attach(struct task_struct *p,
+		const struct cpumask *cs_cpus_allowed, int exclusive)
 {
 	unsigned long flags, cap;
 	unsigned int dest_cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f5acb6c5ce49..54881d99cebd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -337,7 +337,7 @@ extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr);
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
-extern int  dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed);
+extern int  dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed, int exclusive);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern bool dl_cpu_busy(unsigned int cpu);
 
-- 
2.29.2

