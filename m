From: Waiman Long <longman@redhat.com>
Subject: [PATCH v6 2/2] cpuset: Add cpuset.sched_load_balance to v2
Date: Wed, 21 Mar 2018 12:21:49 -0400
Message-ID: <1521649309-26690-3-git-send-email-longman@redhat.com>
References: <1521649309-26690-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521649309-26690-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

The sched_load_balance flag is needed to enable CPU isolation similar
to what can be done with the "isolcpus" kernel boot parameter.

The sched_load_balance flag implies an implicit !cpu_exclusive as
it doesn't make sense to have an isolated CPU being load-balanced in
another cpuset.

For v2, this flag is hierarchical and is inherited by child cpusets. It
is not allowed to have this flag turn off in a parent cpuset, but on
in a child cpuset.

This flag is set by the parent and is not delegatable.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 22 ++++++++++++++++++
 kernel/cgroup/cpuset.c      | 56 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index ed8ec66..c970bd7 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1514,6 +1514,28 @@ Cpuset Interface Files
 	it is a subset of "cpuset.mems".  Its value will be affected
 	by memory nodes hotplug events.
 
+  cpuset.sched_load_balance
+	A read-write single value file which exists on non-root cgroups.
+	The default is "1" (on), and the other possible value is "0"
+	(off).
+
+	When it is on, tasks within this cpuset will be load-balanced
+	by the kernel scheduler.  Tasks will be moved from CPUs with
+	high load to other CPUs within the same cpuset with less load
+	periodically.
+
+	When it is off, there will be no load balancing among CPUs on
+	this cgroup.  Tasks will stay in the CPUs they are running on
+	and will not be moved to other CPUs.
+
+	This flag is hierarchical and is inherited by child cpusets. It
+	can be turned off only when the CPUs in this cpuset aren't
+	listed in the cpuset.cpus of other sibling cgroups, and all
+	the child cpusets, if present, have this flag turned off.
+
+	Once it is off, it cannot be turned back on as long as the
+	parent cgroup still has this flag in the off state.
+
 
 Device controller
 -----------------
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 419b758..d675c4f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -407,15 +407,22 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
  *
  * One cpuset is a subset of another if all its allowed CPUs and
  * Memory Nodes are a subset of the other, and its exclusive flags
- * are only set if the other's are set.  Call holding cpuset_mutex.
+ * are only set if the other's are set (on legacy hierarchy) or
+ * its sched_load_balance flag is only set if the other is set
+ * (on default hierarchy).  Caller holding cpuset_mutex.
  */
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
 {
-	return	cpumask_subset(p->cpus_allowed, q->cpus_allowed) &&
-		nodes_subset(p->mems_allowed, q->mems_allowed) &&
-		is_cpu_exclusive(p) <= is_cpu_exclusive(q) &&
-		is_mem_exclusive(p) <= is_mem_exclusive(q);
+	if (!cpumask_subset(p->cpus_allowed, q->cpus_allowed) ||
+	    !nodes_subset(p->mems_allowed, q->mems_allowed))
+		return false;
+
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		return is_sched_load_balance(p) <= is_sched_load_balance(q);
+	else
+		return is_cpu_exclusive(p) <= is_cpu_exclusive(q) &&
+		       is_mem_exclusive(p) <= is_mem_exclusive(q);
 }
 
 /**
@@ -498,7 +505,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/* On legacy hiearchy, we must be a subset of our parent cpuset. */
+	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
 	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
 		goto out;
@@ -1327,6 +1334,19 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	else
 		clear_bit(bit, &trialcs->flags);
 
+	/*
+	 * On default hierarchy, turning off sched_load_balance flag implies
+	 * an implicit cpu_exclusive. Turning on sched_load_balance will
+	 * clear the cpu_exclusive flag.
+	 */
+	if ((bit == CS_SCHED_LOAD_BALANCE) &&
+	    cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
+		if (turning_on)
+			clear_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
+		else
+			set_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
+	}
+
 	err = validate_change(cs, trialcs);
 	if (err < 0)
 		goto out;
@@ -1966,6 +1986,14 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
+	{
+		.name = "sched_load_balance",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_LOAD_BALANCE,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -1991,7 +2019,21 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	if (!alloc_cpumask_var(&cs->effective_cpus, GFP_KERNEL))
 		goto free_cpus;
 
-	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	/*
+	 * On default hierarchy, inherit parent's CS_SCHED_LOAD_BALANCE and
+	 * CS_CPU_EXCLUSIVE flag.
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
+		struct cpuset *parent = css_cs(parent_css);
+
+		if (test_bit(CS_SCHED_LOAD_BALANCE, &parent->flags))
+			set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+		else
+			set_bit(CS_CPU_EXCLUSIVE, &cs->flags);
+	} else {
+		set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	}
+
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	cpumask_clear(cs->effective_cpus);
-- 
1.8.3.1

