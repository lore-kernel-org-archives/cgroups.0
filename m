From: Waiman Long <longman@redhat.com>
Subject: [PATCH v7 3/5] cpuset: Add a root-only cpus.isolated v2 control file
Date: Thu, 19 Apr 2018 09:47:02 -0400
Message-ID: <1524145624-23655-4-git-send-email-longman@redhat.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524145624-23655-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

In order to better support CPU isolation as well as multiple root
domains for deadline scheduling, the ability to carve out a set of CPUs
specifically for isolation or for another root domain will be useful.

A new root-only "cpuset.cpus.isolated" control file is now added for
holding the list of CPUs that will not be participating in load balancing
within the root cpuset. The root's effective cpu list will not contain
any CPUs that are in "cpuset.cpus.isolated" file.  These isolated CPUs,
however, can still be put into child cpusets and load balanced within
them if necessary.

For CPU isolation, putting the CPUs into this new control file and not
having them in any of the child cpusets should be enough. Those isolated
CPUs can also be put into a child cpuset with load balancing disabled
for finer-grained control.

For creating additional root domains for scheduling, a child cpuset
should only select an exclusive set of CPUs within the isolated set.

The "cpuset.cpus.isolated" control file should be set up before
any child cpusets are created. If child cpusets are present, changes
to this control file will not be allowed if any CPUs that will change
state are in any of the child cpusets.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  25 ++++++++++
 kernel/cgroup/cpuset.c      | 119 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index c970bd7..8d89dc2 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1484,6 +1484,31 @@ Cpuset Interface Files
 	a subset of "cpuset.cpus".  Its value will be affected by CPU
 	hotplug events.
 
+  cpuset.cpus.isolated
+	A read-write multiple values file which exists on root cgroup
+	only.
+
+	It lists the CPUs that have been withdrawn from the root cgroup
+	for load balancing.  These CPUs can still be allocated to child
+	cpusets with load balancing enabled, if necessary.
+
+	If a child cpuset contains only an exclusive set of CPUs that are
+	a subset of the isolated CPUs and with load balancing enabled,
+	these CPUs will be load balanced on a separate root domain from
+	the one in the root cgroup.
+
+	Just putting the CPUs into "cpuset.cpus.isolated" will be
+	enough to disable load balancing on those CPUs as long as they
+	do not appear in a child cpuset with load balancing enabled.
+	Fine-grained control of cpu isolation can also be done by
+	putting these isolated CPUs into child cpusets with load
+	balancing disabled.
+
+	The "cpuset.cpus.isolated" should be set up before child
+	cpusets are created.  Once child cpusets are present, changes
+	to "cpuset.cpus.isolated" will not be allowed if the CPUs that
+	change their states are in any of the child cpusets.
+
   cpuset.mems
 	A read-write multiple values file which exists on non-root
 	cgroups.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 50c9254..c746b18 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -109,6 +109,9 @@ struct cpuset {
 	cpumask_var_t effective_cpus;
 	nodemask_t effective_mems;
 
+	/* Isolated CPUs - root cpuset only */
+	cpumask_var_t isolated_cpus;
+
 	/*
 	 * This is old Memory Nodes tasks took on.
 	 *
@@ -134,6 +137,9 @@ struct cpuset {
 
 	/* for custom sched domain */
 	int relax_domain_level;
+
+	/* for isolated_cpus */
+	int isolation_count;
 };
 
 static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
@@ -909,7 +915,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 
-		cpumask_and(new_cpus, cp->cpus_allowed, parent->effective_cpus);
+		/*
+		 * If parent has isolated CPUs, include them in the list
+		 * of allowable CPUs.
+		 */
+		if (parent->isolation_count) {
+			cpumask_or(new_cpus, parent->effective_cpus,
+				   parent->isolated_cpus);
+			cpumask_and(new_cpus, new_cpus, cpu_online_mask);
+			cpumask_and(new_cpus, new_cpus, cp->cpus_allowed);
+		} else {
+			cpumask_and(new_cpus, cp->cpus_allowed,
+				    parent->effective_cpus);
+		}
 
 		/*
 		 * If it becomes empty, inherit the effective mask of the
@@ -1004,6 +1022,85 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	return 0;
 }
 
+/**
+ * update_isolated_cpumask - update the isolated_cpus mask of the top cpuset
+ * @buf: buffer of cpu numbers written to this cpuset
+ *
+ * Changes to the isolated CPUs are not allowed if any of CPUs changing
+ * state are in any of the child cpusets. Called with cpuset_mutex held.
+ */
+static int update_isolated_cpumask(const char *buf)
+{
+	int retval;
+	int adding, deleting;
+	cpumask_var_t addmask, delmask;
+	struct cpuset *child;
+	struct cgroup_subsys_state *pos_css;
+
+	if (!alloc_cpumask_var(&addmask, GFP_KERNEL))
+		return -ENOMEM;
+	if (!alloc_cpumask_var(&delmask, GFP_KERNEL)) {
+		free_cpumask_var(addmask);
+		return -ENOMEM;
+	}
+	retval = cpulist_parse(buf, addmask);
+	if (retval)
+		goto out;
+
+	retval = -EINVAL;
+	if (!cpumask_subset(addmask, top_cpuset.cpus_allowed))
+		goto out;
+
+	retval = -EBUSY;
+	deleting = cpumask_andnot(delmask, top_cpuset.isolated_cpus, addmask);
+	adding   = cpumask_andnot(addmask, addmask, top_cpuset.isolated_cpus);
+
+	if (!adding && !deleting)
+		goto out_ok;
+
+	/*
+	 * Check if any CPUs in addmask or delmask are in a child cpuset.
+	 * An empty child cpus_allowed means it is the same as parent's
+	 * effective_cpus.
+	 */
+	cpuset_for_each_child(child, pos_css, &top_cpuset) {
+		if (cpumask_empty(child->cpus_allowed))
+			goto out;
+		if (adding && cpumask_intersects(child->cpus_allowed, addmask))
+			goto out;
+		if (deleting &&
+		    cpumask_intersects(child->cpus_allowed, delmask))
+			goto out;
+	}
+
+	/*
+	 * Change the isolated CPU list.
+	 * Newly added isolated CPUs will be removed from effective_cpus
+	 * and newly deleted ones will be added back if they are online.
+	 */
+	spin_lock_irq(&callback_lock);
+	if (adding)
+		cpumask_or(top_cpuset.isolated_cpus,
+			   top_cpuset.isolated_cpus, addmask);
+
+	if (deleting)
+		cpumask_andnot(top_cpuset.isolated_cpus,
+			       top_cpuset.isolated_cpus, delmask);
+
+	cpumask_andnot(top_cpuset.effective_cpus, cpu_online_mask,
+		       top_cpuset.isolated_cpus);
+
+	top_cpuset.isolation_count = cpumask_weight(top_cpuset.isolated_cpus);
+	spin_unlock_irq(&callback_lock);
+
+out_ok:
+	retval = 0;
+out:
+	free_cpumask_var(addmask);
+	free_cpumask_var(delmask);
+	return retval;
+}
+
 /*
  * Migrate memory region from one set of nodes to another.  This is
  * performed asynchronously as it can be called from process migration path
@@ -1612,6 +1709,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEMLIST,
 	FILE_EFFECTIVE_CPULIST,
 	FILE_EFFECTIVE_MEMLIST,
+	FILE_ISOLATED_CPULIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
@@ -1733,6 +1831,12 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
 
+	if (of_cft(of)->private == FILE_ISOLATED_CPULIST) {
+		WARN_ON_ONCE(cs != &top_cpuset);
+		retval = update_isolated_cpumask(buf);
+		goto out_unlock;
+	}
+
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs) {
 		retval = -ENOMEM;
@@ -1789,6 +1893,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
+	case FILE_ISOLATED_CPULIST:	/* Root only */
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->isolated_cpus));
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1994,6 +2101,15 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
+	{
+		.name = "cpus.isolated",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * NR_CPUS),
+		.private = FILE_ISOLATED_CPULIST,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2204,6 +2320,7 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL));
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&top_cpuset.isolated_cpus, GFP_KERNEL));
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
-- 
1.8.3.1

