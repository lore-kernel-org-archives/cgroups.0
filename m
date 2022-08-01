From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup/cpuset: Keep user set cpus affinity
Date: Mon,  1 Aug 2022 11:41:24 -0400
Message-ID: <20220801154124.2011987-3-longman@redhat.com>
References: <20220801154124.2011987-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659368511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=swtQM1D5z4tOUeh3RHmfi2nHTc39eT087LYzvN2ud4o=;
        b=K2BmMxGo8QVSIXv45/QA6Fki2q48EaAXywyPHRNzCYQAD6S+GkK61QF6JtL99kW/GuxY25
        +UYWLC+PRzVVU0sKQZ5sFB3W7rxeUvSu5jMv147OFz+lMFP5OP2fxCVWVG98ysX8RAs3sE
        VlAuGgCYBqFWMqKLAEFd4Fcr80X+wKY=
In-Reply-To: <20220801154124.2011987-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that any change to the current cpuset hierarchy may reset
the cpumask of the tasks in the affected cpusets to the default cpuset
value even if those tasks have cpus affinity explicitly set by the users
before. That is especially easy to trigger under a cgroup v2 environment
where writing "+cpuset" to the root cgroup's cgroup.subtree_control
file will reset the cpus affinity of all the processes in the system.

That is problematic in a nohz_full environment where the tasks running
in the nohz_full CPUs usually have their cpus affinity explicitly set
and will behave incorrectly if cpus affinity changes.

Fix this problem by looking at user_cpus_ptr which will be set if
cpus affinity have been explicitly set before and use it to restrcit
the given cpumask unless there is no overlap. In that case, it will
fallback to the given one.

With that change in place, it was verified that tasks that have its
cpus affinity explicitly set will not be affected by changes made to
the v2 cgroup.subtree_control files.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 71a418858a5e..2e3af93bed03 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -704,6 +704,26 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	return ret;
 }
 
+/*
+ * Preserve user provided cpumask if set unless there is no overlap.
+ */
+static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
+				       const struct cpumask *mask)
+{
+	if (p->user_cpus_ptr && cpumask_intersects(p->user_cpus_ptr, mask)) {
+		cpumask_var_t new_mask;
+		int ret;
+
+		alloc_cpumask_var(&new_mask, GFP_KERNEL);
+		cpumask_and(new_mask, p->user_cpus_ptr, mask);
+		ret = set_cpus_allowed_ptr(p, new_mask);
+		free_cpumask_var(new_mask);
+		return ret;
+	}
+
+	return set_cpus_allowed_ptr(p, mask);
+}
+
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
@@ -1130,7 +1150,7 @@ static void update_tasks_cpumask(struct cpuset *cs)
 
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it)))
-		set_cpus_allowed_ptr(task, cs->effective_cpus);
+		cpuset_set_cpus_allowed_ptr(task, cs->effective_cpus);
 	css_task_iter_end(&it);
 }
 
@@ -2303,7 +2323,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+		WARN_ON_ONCE(cpuset_set_cpus_allowed_ptr(task, cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
-- 
2.31.1

