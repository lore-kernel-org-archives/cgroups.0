From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found in current cpuset
Date: Mon,  6 Mar 2023 15:08:47 -0500
Message-ID: <20230306200849.376804-4-longman@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678133370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPOLCRRq9h+M6y4H0byc+i6v9jsYVGqazZOEyY69QjU=;
        b=HN9t6qD7WMIoJPm1w7ab1amofZyZR8nl882hEBK/qczwb9IRiD+0Bbz0tLQcpCg18ZRahB
        ScQCLvHjAHQxj+Vyefk481njsZ6mGFqL1b/LoUFBKMuZ0qjK7sQa1OHO3hBF9NtQF+7xg9
        CXKoar3/FNvK6RL7ykbqE6lEOAPPQsI=
In-Reply-To: <20230306200849.376804-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On a system with asymmetric CPUs, a restricted task is one that can run
only a selected subset of available CPUs.  When a CPU goes offline or
when "cpuset.cpus" is changed, it is possible that a restricted task
may not have any runnable CPUs left in the current cpuset even if there
is still some CPUs in effective_cpus. In this case, the restricted task
cannot be run at all.

There are several ways we may be able to handle this situation. Treating
it like empty effective_cpus is probably too disruptive and is unfair to
the normal tasks. So it is better to have some special handling for these
restricted tasks. One possibility is to move the restricted tasks up the
cpuset hierarchy, but it is tricky to do it right. Another solution is
to assign other usable CPUs to these tasks. This patch implements the
later alternative by finding one usable CPU by walking up the cpuset
hierarchy and printing an informational message to let the users know
that these restricted tasks are running in a cpuset with no usable CPU.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 56 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bbf57dcb2f68..aa8225daf1d3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1202,6 +1202,38 @@ void rebuild_sched_domains(void)
 	cpus_read_unlock();
 }
 
+/*
+ * Find a usable effective (online) CPU up the cpuset hierarchy and return it.
+ */
+static int find_usable_cpu(struct cpuset *cs, struct cpumask *new_cpus,
+			   const struct cpumask *possible_mask)
+{
+	struct cpuset *parent;
+	unsigned long flags;
+	int cpu;
+
+	/*
+	 * When offlining cpu, some effective_cpus may not be up to date.
+	 * So check cpu_online_mask to be sure.
+	 */
+	parent = parent_cs(cs);
+	while (parent &&
+	      (!cpumask_and(new_cpus, parent->effective_cpus, possible_mask) ||
+	       !cpumask_and(new_cpus, new_cpus, cpu_online_mask)))
+		parent = parent_cs(cs);
+
+	/* Fall back to all possible online cpus, if necessary */
+	if (!parent)
+		cpumask_and(new_cpus, possible_mask, cpu_online_mask);
+
+	/* cpumask_any_distribute() has to be called with preemption disabled */
+	local_irq_save(flags);
+	cpu = cpumask_any_distribute(new_cpus);
+	local_irq_restore(flags);
+
+	return cpu;
+}
+
 /**
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
@@ -1218,6 +1250,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 	struct task_struct *task;
 	bool top_cs = cs == &top_cpuset;
 
+	percpu_rwsem_assert_held(&cpuset_rwsem);
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task = css_task_iter_next(&it))) {
 		const struct cpumask *possible_mask = task_cpu_possible_mask(task);
@@ -1232,7 +1265,28 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 		} else {
 			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
 		}
-		set_cpus_allowed_ptr(task, new_cpus);
+		/*
+		 * On systems with assymetric CPUs, it is possible that
+		 * cpumask will become empty or set_cpus_allowed_ptr() will
+		 * return an error even if we still have CPUs in
+		 * effective_cpus. In this case, we find a usable CPU walking
+		 * up the cpuset hierarchy and use that for this particular
+		 * task with an informational message about the change in the
+		 * hope that the users will adjust "cpuset.cpus" accordingly.
+		 */
+		if (cpumask_empty(new_cpus) ||
+		    set_cpus_allowed_ptr(task, new_cpus)) {
+			char name[80];
+			int cpu;
+
+			cpu = find_usable_cpu(cs, new_cpus, possible_mask);
+			cpumask_clear(new_cpus);
+			cpumask_set_cpu(cpu, new_cpus);
+			WARN_ON_ONCE(set_cpus_allowed_ptr(task, new_cpus));
+			cgroup_name(cs->css.cgroup, name, sizeof(name));
+			pr_info("cpuset: Restricted task %s(%d) in cpuset %s is forced to run on outside CPU %d\n",
+				task->comm, task->pid, name, cpu);
+		}
 	}
 	css_task_iter_end(&it);
 }
-- 
2.31.1

