From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 3/6] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 17 May 2018 16:55:42 -0400
Message-ID: <1526590545-3350-4-git-send-email-longman@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526590545-3350-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

The sched.load_balance flag is needed to enable CPU isolation similar to
what can be done with the "isolcpus" kernel boot parameter. Its value
can only be changed in a scheduling domain with no child cpusets. On
a non-scheduling domain cpuset, the value of sched.load_balance is
inherited from its parent.

This flag is set by the parent and is not delegatable.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 24 ++++++++++++++++++++
 kernel/cgroup/cpuset.c      | 53 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 54d9e22..071b634d 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1536,6 +1536,30 @@ Cpuset Interface Files
 	CPUs of the parent cgroup. Once it is set, this flag cannot be
 	cleared if there are any child cgroups with cpuset enabled.
 
+	A parent cgroup cannot distribute all its CPUs to child
+	scheduling domain cgroups unless its load balancing flag is
+	turned off.
+
+  cpuset.sched.load_balance
+	A read-write single value file which exists on non-root
+	cpuset-enabled cgroups.  It is a binary value flag that accepts
+	either "0" (off) or a non-zero value (on).  This flag is set
+	by the parent and is not delegatable.
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
+	The initial value of this flag is "1".	This flag is then
+	inherited by child cgroups with cpuset enabled.  Its state
+	can only be changed on a scheduling domain cgroup with no
+	cpuset-enabled children.
+
 
 Device controller
 -----------------
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e1a1af0..368e1b7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -510,7 +510,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/* On legacy hiearchy, we must be a subset of our parent cpuset. */
+	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
 	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
 		goto out;
@@ -1061,6 +1061,14 @@ static int update_isolated_cpumask(struct cpuset *cpuset,
 		goto out;
 
 	/*
+	 * A parent can't distribute all its CPUs to child scheduling
+	 * domain cpusets unless load balancing is off.
+	 */
+	if (adding & !deleting && is_sched_load_balance(parent) &&
+	    cpumask_equal(addmask, parent->effective_cpus))
+		goto out;
+
+	/*
 	 * Check if any CPUs in addmask or delmask are in a sibling cpuset.
 	 * An empty sibling cpus_allowed means it is the same as parent's
 	 * effective_cpus. This checking is skipped if the cpuset is dying.
@@ -1531,6 +1539,16 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 
 	domain_flag_changed = (is_sched_domain(cs) != is_sched_domain(trialcs));
 
+	/*
+	 * On default hierachy, a load balance flag change is only allowed
+	 * in a scheduling domain with no child cpuset.
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) && balance_flag_changed &&
+	   (!is_sched_domain(cs) || css_has_online_children(&cs->css))) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (domain_flag_changed) {
 		err = turning_on
 		    ? update_isolated_cpumask(cs, NULL, cs->cpus_allowed)
@@ -2187,6 +2205,14 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
+	{
+		.name = "sched.load_balance",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_LOAD_BALANCE,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2200,19 +2226,38 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct cpuset *cs;
+	struct cgroup_subsys_state *errptr = ERR_PTR(-ENOMEM);
 
 	if (!parent_css)
 		return &top_cpuset.css;
 
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
-		return ERR_PTR(-ENOMEM);
+		return errptr;
 	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL))
 		goto free_cs;
 	if (!alloc_cpumask_var(&cs->effective_cpus, GFP_KERNEL))
 		goto free_cpus;
 
-	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	/*
+	 * On default hierarchy, inherit parent's CS_SCHED_LOAD_BALANCE flag.
+	 * Creating new cpuset is also not allowed if the effective_cpus of
+	 * its parent is empty.
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
+		struct cpuset *parent = css_cs(parent_css);
+
+		if (test_bit(CS_SCHED_LOAD_BALANCE, &parent->flags))
+			set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+
+		if (cpumask_empty(parent->effective_cpus)) {
+			errptr = ERR_PTR(-EINVAL);
+			goto free_cpus;
+		}
+	} else {
+		set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	}
+
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	cpumask_clear(cs->effective_cpus);
@@ -2226,7 +2271,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	free_cpumask_var(cs->cpus_allowed);
 free_cs:
 	kfree(cs);
-	return ERR_PTR(-ENOMEM);
+	return errptr;
 }
 
 static int cpuset_css_online(struct cgroup_subsys_state *css)
-- 
1.8.3.1

