From: Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH] cpuset: fix cpus_allowed mask for offline/online CPUs
Date: Mon, 28 Dec 2015 02:58:09 +0800
Message-ID: <f9d3c4080f29007a8580e122d18e2df8b51214fb.1451241833.git.yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, rjw@rjwysocki.net, lenb@kernel.org, rui.zhang@intel.com

Commit be4c9dd7aee5 ("cpuset: enable onlined cpu/node in effective masks")
leverages cpuset's cpus_allowed and its parent's effective_cpus to calculate
the new_cpus:
cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
since cpus_allowed will also be updated after the CPU's offline on
non-dfl platform, - that is in hotplug_update_tasks_legacy,
so when the CPU is online again, it will never get the correct
new_cpus, and new_cpus will get smaller and smaller after each round
of offline/online(because cs->cpus_allowed is getting smaller and
smaller).
This problem can be reproduced by:

1. echo 0 > /sys/devices/system/cpu/cpu2/online
2. echo 1 > /sys/devices/system/cpu/cpu2/online
3. taskset -c 2 ls
taskset: failed to set pid 0's affinity: Invalid argument

This patch works around this problem by introducing a new
mask cpumask_var_t cpus_sysfs inside struct cpuset,
which will only be updated by writing value to sysfs.cpuset.cpus,
and CPU offline/online will use this mask to set the new cpumask
for a cpuset.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
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
