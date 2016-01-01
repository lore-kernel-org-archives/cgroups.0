From: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
Date: Fri,  1 Jan 2016 20:09:13 +0800
Message-ID: <2f805346f87680dddfa9253dc9031db3b6ead8ad.1451648318.git.yu.c.chen@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vishnu Pratap Singh <vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pintu Kumar <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Commit be4c9dd7aee5 ("cpuset: enable onlined cpu/node in effective masks")
leverages cpuset's cpus_allowed and its parent's effective_cpus to calculate
the new_cpus by:

cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);

However cpus_allowed will also be updated after the CPU is offline, in
hotplug_update_tasks_legacy, so when the CPU is online again, it will use
the old cpus_allowed mask to calculate the new_cpus, thus new_cpus will get
incorrect value after each round of offline/online.

This problem is found on ubuntu 15.10 with cpuset mounted:

1. echo 0 > /sys/devices/system/cpu/cpu2/online
2. echo 1 > /sys/devices/system/cpu/cpu2/online
3. cat /sys/fs/cgroup/cpuset/cpuset.cpus
   0-3
4. cat /sys/fs/cgroup/cpuset/user.slice/cpuset.cpus
   0-1,3
5. taskset -c 2 ls
   taskset: failed to set pid 0's affinity: Invalid argument

This patch works around this problem by introducing a new
mask cpumask_var_t cpus_sysfs inside struct cpuset,
which will only be updated by writing value to sysfs.cpuset.cpus,
and CPU offline/online will use this mask to set the new cpumask
for a cpuset.

Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vishnu Pratap Singh <vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Pintu Kumar <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cpuset.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 02a8ea5..49c9cd5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -106,6 +106,12 @@ struct cpuset {
 	nodemask_t effective_mems;
 
 	/*
+	 * This cpumask can only be modified by sysfs - cpuset.cpus,
+	 * and will not change during cpu online/offline.
+	 */
+	cpumask_var_t cpus_sysfs;
+
+	/*
 	 * This is old Memory Nodes tasks took on.
 	 *
 	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
@@ -963,6 +969,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	cpumask_copy(cs->cpus_sysfs, trialcs->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
 
 	/* use trialcs->cpus_allowed as a temp variable */
@@ -1922,17 +1929,22 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 		goto free_cs;
 	if (!alloc_cpumask_var(&cs->effective_cpus, GFP_KERNEL))
 		goto free_cpus;
+	if (!alloc_cpumask_var(&cs->cpus_sysfs, GFP_KERNEL))
+		goto free_effective;
 
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	cpumask_clear(cs->effective_cpus);
 	nodes_clear(cs->effective_mems);
+	cpumask_clear(cs->cpus_sysfs);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
 	return &cs->css;
 
+free_effective:
+	free_cpumask_var(cs->effective_cpus);
 free_cpus:
 	free_cpumask_var(cs->cpus_allowed);
 free_cs:
@@ -1997,6 +2009,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	cs->effective_mems = parent->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
 	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
+	cpumask_copy(cs->cpus_sysfs, parent->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
@@ -2030,6 +2043,7 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 
 	free_cpumask_var(cs->effective_cpus);
 	free_cpumask_var(cs->cpus_allowed);
+	free_cpumask_var(cs->cpus_sysfs);
 	kfree(cs);
 }
 
@@ -2078,11 +2092,14 @@ int __init cpuset_init(void)
 		BUG();
 	if (!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL))
 		BUG();
+	if (!alloc_cpumask_var(&top_cpuset.cpus_sysfs, GFP_KERNEL))
+		BUG();
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 	cpumask_setall(top_cpuset.effective_cpus);
 	nodes_setall(top_cpuset.effective_mems);
+	cpumask_setall(top_cpuset.cpus_sysfs);
 
 	fmeter_init(&top_cpuset.fmeter);
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
@@ -2213,7 +2230,10 @@ retry:
 		goto retry;
 	}
 
-	cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
+	else
+		cpumask_and(&new_cpus, cs->cpus_sysfs, parent_cs(cs)->effective_cpus);
 	nodes_and(new_mems, cs->mems_allowed, parent_cs(cs)->effective_mems);
 
 	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
@@ -2354,6 +2374,8 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
 	top_cpuset.effective_mems = node_states[N_MEMORY];
 
+	cpumask_copy(top_cpuset.cpus_sysfs, cpu_active_mask);
+
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 }
 
-- 
1.8.4.2
