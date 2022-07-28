From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus affinity was explicitly set
Date: Wed, 27 Jul 2022 20:58:14 -0400
Message-ID: <20220728005815.1715522-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658969918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BmJWjBY43RDpj3JT97t8mjKUtc70HW3e4aiC0GvyquU=;
        b=HdetwII5UdxZF0jjNacU/RmvlXiu8giJ56ORNN6sCaNnkpesq/eOFSfYVtZ5B3pGAsOOvw
        T9sF2zltQ2L+vvLVes/O0WeYqBMGVTE5pCJ2+3BQl8MwrWORHkyhul6vzFuK1WenMfMgKs
        MSZx/OyGBhJtfNjeMD/dXBrjxCbIoBc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that any change to the current cpuset hierarchy may reset
the cpus_allowed list of the tasks in the affected cpusets to the
default cpuset value even if those tasks have cpus affinity explicitly
set by the users before. That is especially easy to trigger under a
cgroup v2 environment where writing "+cpuset" to the root cgroup's
cgroup.subtree_control file will reset the cpus affinity of all the
processes in the system.

That is especially problematic in a nohz_full environment where the
tasks running in the nohz_full CPUs usually have their cpus affinity
explicitly set and will behave incorrectly if cpus affinity changes.

Fix this problem by adding a flag in the task structure to indicate that
a task has their cpus affinity explicitly set before and make cpuset
code not to change their cpus_allowed list unless the user chosen cpu
list is no longer a subset of the cpus_allowed list of the cpuset itself.

With that change in place, it was verified that tasks that have its
cpus affinity explicitly set will not be affected by changes made to
the v2 cgroup.subtree_control files.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h  |  1 +
 kernel/cgroup/cpuset.c | 18 ++++++++++++++++--
 kernel/sched/core.c    |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c46f3a63b758..60ae022fa842 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -815,6 +815,7 @@ struct task_struct {
 
 	unsigned int			policy;
 	int				nr_cpus_allowed;
+	int				cpus_affinity_set;
 	const cpumask_t			*cpus_ptr;
 	cpumask_t			*user_cpus_ptr;
 	cpumask_t			cpus_mask;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 71a418858a5e..c47757c61f39 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -704,6 +704,20 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	return ret;
 }
 
+/*
+ * Don't change the cpus_allowed list if cpus affinity has been explicitly
+ * set before unless the current cpu list is not a subset of the new cpu list.
+ */
+static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
+				       const struct cpumask *new_mask)
+{
+	if (p->cpus_affinity_set && cpumask_subset(p->cpus_ptr, new_mask))
+		return 0;
+
+	p->cpus_affinity_set = 0;
+	return set_cpus_allowed_ptr(p, new_mask);
+}
+
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
@@ -1130,7 +1144,7 @@ static void update_tasks_cpumask(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		set_cpus_allowed_ptr(task, cs->effective_cpus);
+		cpuset_set_cpus_allowed_ptr(task, cs->effective_cpus);
 	css_task_iter_end(&it);
 }
 
@@ -2303,7 +2317,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+		WARN_ON_ONCE(cpuset_set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index da0bf6fe9ecd..ab8ea6fa92db 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8034,6 +8034,7 @@ __sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
 	if (retval)
 		goto out_free_new_mask;
 
+	p->cpus_affinity_set = 1;
 	cpuset_cpus_allowed(p, cpus_allowed);
 	if (!cpumask_subset(new_mask, cpus_allowed)) {
 		/*
-- 
2.31.1

