From: Waiman Long <longman@redhat.com>
Subject: [PATCH v9 2/7] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Tue, 29 May 2018 09:41:29 -0400
Message-ID: <1527601294-3444-3-git-send-email-longman@redhat.com>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527601294-3444-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

A new cpuset.sched.domain_root boolean flag is added to cpuset
v2. This new flag, if set, indicates that the cgroup is the root of
a new scheduling domain or partition that includes itself and all its
descendants except those that are scheduling domain roots themselves
and their descendants.

With this new flag, one can directly create as many partitions as
necessary without ever using the v1 trick of turning off load balancing
in specific cpusets to create partitions as a side effect.

This new flag is owned by the parent and will cause the CPUs in the
cpuset to be removed from the effective CPUs of its parent.

This is implemented internally by adding a new isolated_cpus mask that
holds the CPUs belonging to child scheduling domain cpusets so that:

	isolated_cpus | effective_cpus = cpus_allowed
	isolated_cpus & effective_cpus = 0

This new flag can only be turned on in a cpuset if its parent is a
scheduling domain root itself. The state of this flag cannot be changed
if the cpuset has children.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  28 +++++
 kernel/cgroup/cpuset.c      | 246 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 271 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index cf7bac6..e7534c5 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1514,6 +1514,34 @@ Cpuset Interface Files
 	it is a subset of "cpuset.mems".  Its value will be affected
 	by memory nodes hotplug events.
 
+  cpuset.sched.domain_root
+	A read-write single value file which exists on non-root
+	cpuset-enabled cgroups.  It is a binary value flag that accepts
+	either "0" (off) or "1" (on).  This flag is set by the parent
+	and is not delegatable.
+
+	If set, it indicates that the current cgroup is the root of a
+	new scheduling domain or partition that comprises itself and
+	all its descendants except those that are scheduling domain
+	roots themselves and their descendants.  The root cgroup is
+	always a scheduling domain root.
+
+	There are constraints on where this flag can be set.  It can
+	only be set in a cgroup if all the following conditions are true.
+
+	1) The "cpuset.cpus" is not empty and the list of CPUs are
+	   exclusive, i.e. they are not shared by any of its siblings.
+	2) The parent cgroup is also a scheduling domain root.
+	3) There is no child cgroups with cpuset enabled.  This is
+	   for eliminating corner cases that have to be handled if such
+	   a condition is allowed.
+
+	Setting this flag will take the CPUs away from the effective
+	CPUs of the parent cgroup.  Once it is set, this flag cannot
+	be cleared if there are any child cgroups with cpuset enabled.
+	Further changes made to "cpuset.cpus" is allowed as long as
+	the first condition above is still true.
+
 
 Device controller
 -----------------
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 419b758..405b072 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -109,6 +109,9 @@ struct cpuset {
 	cpumask_var_t effective_cpus;
 	nodemask_t effective_mems;
 
+	/* Isolated CPUs for scheduling domain children */
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
@@ -175,6 +181,7 @@ static inline bool task_has_mempolicy(struct task_struct *task)
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_SCHED_DOMAIN_ROOT,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -203,6 +210,11 @@ static inline int is_sched_load_balance(const struct cpuset *cs)
 	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 }
 
+static inline int is_sched_domain_root(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_DOMAIN_ROOT, &cs->flags);
+}
+
 static inline int is_memory_migrate(const struct cpuset *cs)
 {
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
@@ -220,7 +232,7 @@ static inline int is_spread_slab(const struct cpuset *cs)
 
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
-		  (1 << CS_MEM_EXCLUSIVE)),
+		  (1 << CS_MEM_EXCLUSIVE) | (1 << CS_SCHED_DOMAIN_ROOT)),
 };
 
 /**
@@ -902,7 +914,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
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
@@ -948,6 +972,162 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 }
 
 /**
+ * update_isolated_cpumask - update the isolated_cpus mask of parent cpuset
+ * @cpuset:  The cpuset that requests CPU isolation
+ * @oldmask: The old isolated cpumask to be removed from the parent
+ * @newmask: The new isolated cpumask to be added to the parent
+ * Return: 0 if successful, an error code otherwise
+ *
+ * Changes to the isolated CPUs are not allowed if any of CPUs changing
+ * state are in any of the child cpusets of the parent except the requesting
+ * child.
+ *
+ * If the sched_domain_root flag changes, either the oldmask (0=>1) or the
+ * newmask (1=>0) will be NULL.
+ *
+ * Called with cpuset_mutex held.
+ */
+static int update_isolated_cpumask(struct cpuset *cpuset,
+	struct cpumask *oldmask, struct cpumask *newmask)
+{
+	int retval;
+	int adding, deleting;
+	cpumask_var_t addmask, delmask;
+	struct cpuset *parent = parent_cs(cpuset);
+	struct cpuset *sibling;
+	struct cgroup_subsys_state *pos_css;
+	int old_count = parent->isolation_count;
+	bool dying = cpuset->css.flags & CSS_DYING;
+
+	/*
+	 * The new cpumask, if present, mut not be empty and its parent
+	 * must be a scheduling domain root.
+	 */
+	if ((newmask && cpumask_empty(newmask)) ||
+	   !is_sched_domain_root(parent))
+		return -EINVAL;
+
+	/*
+	 * The oldmask, if present, must be a subset of parent's isolated
+	 * CPUs.
+	 */
+	if (oldmask && !cpumask_empty(oldmask) && (!parent->isolation_count ||
+		       !cpumask_subset(oldmask, parent->isolated_cpus))) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/*
+	 * A sched_domain_root state change is not allowed if there are
+	 * online children and the cpuset is not dying.
+	 */
+	if (!dying && (!oldmask || !newmask) &&
+	    css_has_online_children(&cpuset->css))
+		return -EBUSY;
+
+	if (!zalloc_cpumask_var(&addmask, GFP_KERNEL))
+		return -ENOMEM;
+	if (!zalloc_cpumask_var(&delmask, GFP_KERNEL)) {
+		free_cpumask_var(addmask);
+		return -ENOMEM;
+	}
+
+	if (!old_count) {
+		if (!zalloc_cpumask_var(&parent->isolated_cpus, GFP_KERNEL)) {
+			retval = -ENOMEM;
+			goto out;
+		}
+		old_count = 1;
+	}
+
+	retval = -EBUSY;
+	adding = deleting = false;
+	if (newmask)
+		cpumask_copy(addmask, newmask);
+	if (oldmask)
+		deleting = cpumask_andnot(delmask, oldmask, addmask);
+	if (newmask)
+		adding = cpumask_andnot(addmask, newmask, delmask);
+
+	if (!adding && !deleting)
+		goto out_ok;
+
+	/*
+	 * The cpus to be added must be in the parent's effective_cpus mask
+	 * but not in the isolated_cpus mask.
+	 */
+	if (!cpumask_subset(addmask, parent->effective_cpus))
+		goto out;
+	if (parent->isolation_count &&
+	    cpumask_intersects(parent->isolated_cpus, addmask))
+		goto out;
+
+	/*
+	 * Check if any CPUs in addmask or delmask are in a sibling cpuset.
+	 * An empty sibling cpus_allowed means it is the same as parent's
+	 * effective_cpus. This checking is skipped if the cpuset is dying.
+	 */
+	if (dying)
+		goto updated_isolated_cpus;
+
+	rcu_read_lock();
+	cpuset_for_each_child(sibling, pos_css, parent) {
+		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
+			continue;
+		if (cpumask_empty(sibling->cpus_allowed))
+			goto out_unlock;
+		if (adding &&
+		    cpumask_intersects(sibling->cpus_allowed, addmask))
+			goto out_unlock;
+		if (deleting &&
+		    cpumask_intersects(sibling->cpus_allowed, delmask))
+			goto out_unlock;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Change the isolated CPU list.
+	 * Newly added isolated CPUs will be removed from effective_cpus
+	 * and newly deleted ones will be added back if they are online.
+	 */
+updated_isolated_cpus:
+	spin_lock_irq(&callback_lock);
+	if (adding)
+		cpumask_or(parent->isolated_cpus,
+			   parent->isolated_cpus, addmask);
+
+	if (deleting)
+		cpumask_andnot(parent->isolated_cpus,
+			       parent->isolated_cpus, delmask);
+
+	/*
+	 * New effective_cpus = (cpus_allowed & ~isolated_cpus) &
+	 *			 cpu_online_mask
+	 */
+	cpumask_andnot(parent->effective_cpus, parent->cpus_allowed,
+		       parent->isolated_cpus);
+	cpumask_and(parent->effective_cpus, parent->effective_cpus,
+		    cpu_online_mask);
+
+	parent->isolation_count = cpumask_weight(parent->isolated_cpus);
+	spin_unlock_irq(&callback_lock);
+
+out_ok:
+	retval = 0;
+out:
+	free_cpumask_var(addmask);
+	free_cpumask_var(delmask);
+	if (old_count && !parent->isolation_count)
+		free_cpumask_var(parent->isolated_cpus);
+
+	return retval;
+
+out_unlock:
+	rcu_read_unlock();
+	goto out;
+}
+
+/**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
  * @trialcs: trial cpuset
@@ -988,6 +1168,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
+	if (is_sched_domain_root(cs)) {
+		retval = update_isolated_cpumask(cs, cs->cpus_allowed,
+						 trialcs->cpus_allowed);
+		if (retval < 0)
+			return retval;
+	}
+
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
@@ -1316,6 +1503,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	struct cpuset *trialcs;
 	int balance_flag_changed;
 	int spread_flag_changed;
+	int domain_flag_changed;
 	int err;
 
 	trialcs = alloc_trial_cpuset(cs);
@@ -1327,6 +1515,18 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	else
 		clear_bit(bit, &trialcs->flags);
 
+	/*
+	 *  Turning on sched.domain flag (default hierarchy only) implies
+	 *  an implicit cpu_exclusive. Turning off sched.domain will clear
+	 *  the cpu_exclusive flag.
+	 */
+	if (bit == CS_SCHED_DOMAIN_ROOT) {
+		if (turning_on)
+			set_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
+		else
+			clear_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
+	}
+
 	err = validate_change(cs, trialcs);
 	if (err < 0)
 		goto out;
@@ -1337,11 +1537,27 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	domain_flag_changed = (is_sched_domain_root(cs) !=
+			       is_sched_domain_root(trialcs));
+
+	if (domain_flag_changed) {
+		err = turning_on
+		    ? update_isolated_cpumask(cs, NULL, cs->cpus_allowed)
+		    : update_isolated_cpumask(cs, cs->cpus_allowed, NULL);
+		if (err < 0)
+			goto out;
+		/*
+		 * At this point, the state has been changed.
+		 * So we can't back out with error anymore.
+		 */
+	}
+
 	spin_lock_irq(&callback_lock);
 	cs->flags = trialcs->flags;
 	spin_unlock_irq(&callback_lock);
 
-	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
+	if (!cpumask_empty(trialcs->cpus_allowed) &&
+	   (balance_flag_changed || domain_flag_changed))
 		rebuild_sched_domains_locked();
 
 	if (spread_flag_changed)
@@ -1596,6 +1812,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
 	FILE_SCHED_LOAD_BALANCE,
+	FILE_SCHED_DOMAIN_ROOT,
 	FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
@@ -1629,6 +1846,9 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
+	case FILE_SCHED_DOMAIN_ROOT:
+		retval = update_flag(CS_SCHED_DOMAIN_ROOT, cs, val);
+		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
@@ -1790,6 +2010,8 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
 		return is_mem_hardwall(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
+	case FILE_SCHED_DOMAIN_ROOT:
+		return is_sched_domain_root(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
@@ -1966,6 +2188,14 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
+	{
+		.name = "sched.domain_root",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_DOMAIN_ROOT,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2075,6 +2305,9 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
  * will call rebuild_sched_domains_locked().
+ *
+ * If the cpuset has the 'sched_domain_root' flag enabled, simulate
+ * turning sched_domain_root off.
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
@@ -2083,6 +2316,13 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 
 	mutex_lock(&cpuset_mutex);
 
+	/*
+	 * Calling update_flag() may fail, so we have to call
+	 * update_isolated_cpumask directly to be sure.
+	 */
+	if (is_sched_domain_root(cs))
+		update_isolated_cpumask(cs, cs->cpus_allowed, NULL);
+
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
-- 
1.8.3.1

