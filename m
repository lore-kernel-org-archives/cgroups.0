From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/12] cpuset: add cs->effective_cpus and cs->effective_mems
Date: Fri, 11 Oct 2013 17:49:32 +0800
Message-ID: <5257C9AC.5090603@huawei.com>
References: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5257C9A1.1030404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We're going to have separate user-configured masks and effective ones.

Eventually configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction,
and these are the real masks that apply to the tasks in the cpuset.

We calculate effective mask this way:
  - top cpuset's effective_mask == online_mask, otherwise
  - cpuset's effective_mask == configured_mask & parent effective_mask,
    if the result is empty, it inherits parent effective mask.

Those behavior changes are for sane_behavior only. For !sane_behavior
effective_mask and configured_mask are the same, so we won't break old
interfaces.

This patch adds and initializes the effective masks to struct cpuset.
The effective masks of the top cpuset is the same with configured masks,
and a child cpuset inherits its parent's effective masks.

This won't introduce behavior change.

v2:
- s/real_{mems,cpus}_allowed/effective_{mems,cpus}, suggested by Tejun.
- don't init effective masks in cpuset_css_online() if !sane_behavior

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6bf981e..e13fc2a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -81,8 +81,14 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
-	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
+
+	/* user-configured CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t cpus_allowed;
+	nodemask_t mems_allowed;
+
+	/* effective CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t effective_cpus;
+	nodemask_t effective_mems;
 
 	/*
 	 * This is old Memory Nodes tasks took on.
@@ -381,13 +387,20 @@ static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
-	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL)) {
-		kfree(trial);
-		return NULL;
-	}
-	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL))
+		goto free_cs;
+	if (!alloc_cpumask_var(&trial->effective_cpus, GFP_KERNEL))
+		goto free_cpus;
 
+	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+	cpumask_copy(trial->effective_cpus, cs->effective_cpus);
 	return trial;
+
+free_cpus:
+	free_cpumask_var(trial->cpus_allowed);
+free_cs:
+	kfree(trial);
+	return NULL;
 }
 
 /**
@@ -396,6 +409,7 @@ static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
  */
 static void free_trial_cpuset(struct cpuset *trial)
 {
+	free_cpumask_var(trial->effective_cpus);
 	free_cpumask_var(trial->cpus_allowed);
 	kfree(trial);
 }
@@ -1948,18 +1962,26 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
-	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
-		kfree(cs);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL))
+		goto free_cs;
+	if (!alloc_cpumask_var(&cs->effective_cpus, GFP_KERNEL))
+		goto free_cpus;
 
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
+	cpumask_clear(cs->effective_cpus);
+	nodes_clear(cs->effective_mems);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
 	return &cs->css;
+
+free_cpus:
+	free_cpumask_var(cs->cpus_allowed);
+free_cs:
+	kfree(cs);
+	return ERR_PTR(-ENOMEM);
 }
 
 static int cpuset_css_online(struct cgroup_subsys_state *css)
@@ -1982,6 +2004,13 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 
 	number_of_cpusets++;
 
+	mutex_lock(&callback_mutex);
+	if (cgroup_sane_behavior(cs->css.cgroup)) {
+		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
+		cs->effective_mems = parent->effective_mems;
+	}
+	mutex_unlock(&callback_mutex);
+
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
 
@@ -2041,6 +2070,7 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	free_cpumask_var(cs->effective_cpus);
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
 }
@@ -2071,9 +2101,13 @@ int __init cpuset_init(void)
 
 	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
 		BUG();
+	if (!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL))
+		BUG();
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
+	cpumask_setall(top_cpuset.effective_cpus);
+	nodes_setall(top_cpuset.effective_mems);
 
 	fmeter_init(&top_cpuset.fmeter);
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
@@ -2311,6 +2345,9 @@ void __init cpuset_init_smp(void)
 	top_cpuset.mems_allowed = node_states[N_MEMORY];
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
+	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
+	top_cpuset.effective_mems = node_states[N_MEMORY];
+
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 }
 
-- 
1.8.0.2
