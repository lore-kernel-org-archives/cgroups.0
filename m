From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 2/9] cpuset: Add new v2 cpuset.sched.domain_root flag
Date: Mon, 18 Jun 2018 12:14:01 +0800
Message-ID: <1529295249-5207-3-git-send-email-longman@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
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

This is implemented internally by adding a new reserved_cpus mask that
holds the CPUs belonging to child scheduling domain cpusets so that:

	reserved_cpus | effective_cpus = cpus_allowed
	reserved_cpus & effective_cpus = 0

This new flag can only be turned on in a cpuset if its parent is a
scheduling domain root itself. The state of this flag cannot be changed
if the cpuset has children.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  33 +++++
 kernel/cgroup/cpuset.c                  | 209 +++++++++++++++++++++++++++++++-
 2 files changed, 239 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index fbc30b6..d5e25a0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1584,6 +1584,39 @@ Cpuset Interface Files
 
 	Its value will be affected by memory nodes hotplug events.
 
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
+	2) The "cpuset.cpus" is also a proper subset of the parent's
+	   "cpuset.cpus.effective".
+	3) The parent cgroup is a scheduling domain root.
+	4) There is no child cgroups with cpuset enabled.  This is
+	   for eliminating corner cases that have to be handled if such
+	   a condition is allowed.
+
+	Setting this flag will take the CPUs away from the effective
+	CPUs of the parent cgroup.  Once it is set, this flag cannot be
+	cleared if there are any child cgroups with cpuset enabled.
+
+	A parent scheduling domain root cgroup cannot distribute
+	all its CPUs to its child scheduling domain root cgroups.
+	There must be at least one cpu left in the parent scheduling
+	domain root cgroup.
+
 
 Device controller
 -----------------
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2b5c447..68a9c25 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -109,6 +109,9 @@ struct cpuset {
 	cpumask_var_t effective_cpus;
 	nodemask_t effective_mems;
 
+	/* CPUs reserved for child scheduling domains */
+	cpumask_var_t reserved_cpus;
+
 	/*
 	 * This is old Memory Nodes tasks took on.
 	 *
@@ -134,6 +137,9 @@ struct cpuset {
 
 	/* for custom sched domain */
 	int relax_domain_level;
+
+	/* number of CPUs in reserved_cpus */
+	int nr_reserved;
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
@@ -881,6 +893,27 @@ static void update_tasks_cpumask(struct cpuset *cs)
 	css_task_iter_end(&it);
 }
 
+/**
+ * compute_effective_cpumask - Compute the effective cpumask of the cpuset
+ * @new_cpus: the temp variable for the new effective_cpus mask
+ * @cs: the cpuset the need to recompute the new effective_cpus mask
+ * @parent: the parent cpuset
+ *
+ * If the parent has reserved CPUs, include them in the list of allowable
+ * CPUs in computing the new effective_cpus mask.
+ */
+static void compute_effective_cpumask(struct cpumask *new_cpus,
+				      struct cpuset *cs, struct cpuset *parent)
+{
+	if (parent->nr_reserved) {
+		cpumask_or(new_cpus, parent->effective_cpus,
+			   parent->reserved_cpus);
+		cpumask_and(new_cpus, new_cpus, cs->cpus_allowed);
+	} else {
+		cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
+	}
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs: the cpuset to consider
@@ -903,7 +936,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 
-		cpumask_and(new_cpus, cp->cpus_allowed, parent->effective_cpus);
+		compute_effective_cpumask(new_cpus, cp, parent);
 
 		/*
 		 * If it becomes empty, inherit the effective mask of the
@@ -949,6 +982,130 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 }
 
 /**
+ * update_reserved_cpumask - update the reserved_cpus mask of parent cpuset
+ * @cpuset:  The cpuset that requests CPU reservation
+ * @delmask: The old reserved cpumask to be removed from the parent
+ * @addmask: The new reserved cpumask to be added to the parent
+ * Return: 0 if successful, an error code otherwise
+ *
+ * Changes to the reserved CPUs are not allowed if any of CPUs changing
+ * state are in any of the child cpusets of the parent except the requesting
+ * child.
+ *
+ * If the sched_domain_root flag changes, either the delmask (0=>1) or the
+ * addmask (1=>0) will be NULL.
+ *
+ * Called with cpuset_mutex held.
+ */
+static int update_reserved_cpumask(struct cpuset *cpuset,
+	struct cpumask *delmask, struct cpumask *addmask)
+{
+	int retval;
+	struct cpuset *parent = parent_cs(cpuset);
+	struct cpuset *sibling;
+	struct cgroup_subsys_state *pos_css;
+	int old_count = parent->nr_reserved;
+
+	/*
+	 * The parent must be a scheduling domain root.
+	 * The new cpumask, if present, must not be empty.
+	 */
+	if (!is_sched_domain_root(parent) ||
+	   (addmask && cpumask_empty(addmask)))
+		return -EINVAL;
+
+	/*
+	 * The delmask, if present, must be a subset of parent's reserved
+	 * CPUs.
+	 */
+	if (delmask && !cpumask_empty(delmask) && (!parent->nr_reserved ||
+		       !cpumask_subset(delmask, parent->reserved_cpus))) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/*
+	 * A sched_domain_root state change is not allowed if there are
+	 * online children.
+	 */
+	if (css_has_online_children(&cpuset->css))
+		return -EBUSY;
+
+	if (!old_count) {
+		if (!zalloc_cpumask_var(&parent->reserved_cpus, GFP_KERNEL)) {
+			retval = -ENOMEM;
+			goto out;
+		}
+		old_count = 1;
+	}
+
+	retval = -EBUSY;
+
+	/*
+	 * The cpus to be added must be a proper subset of the parent's
+	 * effective_cpus mask but not in the reserved_cpus mask.
+	 */
+	if (addmask) {
+		if (!cpumask_subset(addmask, parent->effective_cpus) ||
+		     cpumask_equal(addmask, parent->effective_cpus))
+			goto out;
+		if (parent->nr_reserved &&
+		    cpumask_intersects(parent->reserved_cpus, addmask))
+			goto out;
+	}
+
+	/*
+	 * Check if any CPUs in addmask or delmask are in the effective_cpus
+	 * of a sibling cpuset. The implied cpu_exclusive of a scheduling
+	 * domain root will ensure there are no overlap in cpus_allowed.
+	 */
+	rcu_read_lock();
+	cpuset_for_each_child(sibling, pos_css, parent) {
+		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
+			continue;
+		if (addmask &&
+		    cpumask_intersects(sibling->effective_cpus, addmask))
+			goto out_unlock;
+		if (delmask &&
+		    cpumask_intersects(sibling->effective_cpus, delmask))
+			goto out_unlock;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Change the reserved CPU list.
+	 * Newly added reserved CPUs will be removed from effective_cpus
+	 * and newly deleted ones will be added back if they are online.
+	 */
+	spin_lock_irq(&callback_lock);
+	if (addmask) {
+		cpumask_or(parent->reserved_cpus,
+			   parent->reserved_cpus, addmask);
+		cpumask_andnot(parent->effective_cpus,
+			       parent->effective_cpus, addmask);
+	}
+	if (delmask) {
+		cpumask_andnot(parent->reserved_cpus,
+			       parent->reserved_cpus, delmask);
+		cpumask_or(parent->effective_cpus,
+			   parent->effective_cpus, delmask);
+	}
+
+	parent->nr_reserved = cpumask_weight(parent->reserved_cpus);
+	spin_unlock_irq(&callback_lock);
+	retval = 0;
+out:
+	if (old_count && !parent->nr_reserved)
+		free_cpumask_var(parent->reserved_cpus);
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
@@ -989,6 +1146,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
+	if (is_sched_domain_root(cs))
+		return -EBUSY;
+
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
@@ -1317,6 +1477,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	struct cpuset *trialcs;
 	int balance_flag_changed;
 	int spread_flag_changed;
+	int domain_flag_changed;
 	int err;
 
 	trialcs = alloc_trial_cpuset(cs);
@@ -1328,6 +1489,18 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
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
@@ -1338,11 +1511,27 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
+	domain_flag_changed = (is_sched_domain_root(cs) !=
+			       is_sched_domain_root(trialcs));
+
+	if (domain_flag_changed) {
+		err = turning_on
+		    ? update_reserved_cpumask(cs, NULL, cs->cpus_allowed)
+		    : update_reserved_cpumask(cs, cs->cpus_allowed, NULL);
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
@@ -1597,6 +1786,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
 	FILE_SCHED_LOAD_BALANCE,
+	FILE_SCHED_DOMAIN_ROOT,
 	FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
@@ -1630,6 +1820,9 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
+	case FILE_SCHED_DOMAIN_ROOT:
+		retval = update_flag(CS_SCHED_DOMAIN_ROOT, cs, val);
+		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
@@ -1791,6 +1984,8 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
 		return is_mem_hardwall(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
+	case FILE_SCHED_DOMAIN_ROOT:
+		return is_sched_domain_root(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
@@ -1967,6 +2162,14 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
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
 
-- 
1.8.3.1

