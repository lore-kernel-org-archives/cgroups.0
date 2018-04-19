From: Waiman Long <longman@redhat.com>
Subject: [PATCH v7 4/5] cpuset: Restrict load balancing off cpus to subset of cpus.isolated
Date: Thu, 19 Apr 2018 09:47:03 -0400
Message-ID: <1524145624-23655-5-git-send-email-longman@redhat.com>
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

With the addition of "cpuset.cpus.isolated", it makes sense to add the
restriction that load balancing can only be turned off if the CPUs in
the isolated cpuset are subset of "cpuset.cpus.isolated".

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  7 ++++---
 kernel/cgroup/cpuset.c      | 29 ++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 8d89dc2..c4227ee 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1554,9 +1554,10 @@ Cpuset Interface Files
 	and will not be moved to other CPUs.
 
 	This flag is hierarchical and is inherited by child cpusets. It
-	can be turned off only when the CPUs in this cpuset aren't
-	listed in the cpuset.cpus of other sibling cgroups, and all
-	the child cpusets, if present, have this flag turned off.
+	can be explicitly turned off only when it is a direct child of
+	the root cgroup and the CPUs in this cpuset are subset of the
+	root's "cpuset.cpus.isolated".	Moreover, the CPUs cannot be
+	listed in the "cpuset.cpus" of other sibling cgroups.
 
 	Once it is off, it cannot be turned back on as long as the
 	parent cgroup still has this flag in the off state.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c746b18..d05c4c8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -511,6 +511,16 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
+	/*
+	 * On default hierarchy with sched_load_balance flag off, the cpu
+	 * list must be a subset of the parent's isolated CPU list, if
+	 * defined (root).
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    !is_sched_load_balance(trial) && par->isolation_count &&
+	    !cpumask_subset(trial->cpus_allowed, par->isolated_cpus))
+		goto out;
+
 	/* On legacy hierarchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
 	if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
@@ -1431,10 +1441,16 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	else
 		clear_bit(bit, &trialcs->flags);
 
+	balance_flag_changed = (is_sched_load_balance(cs) !=
+				is_sched_load_balance(trialcs));
+
 	/*
 	 * On default hierarchy, turning off sched_load_balance flag implies
 	 * an implicit cpu_exclusive. Turning on sched_load_balance will
 	 * clear the cpu_exclusive flag.
+	 *
+	 * sched_load_balance can only be turned off if all the CPUs are
+	 * in the parent's isolated CPU list.
 	 */
 	if ((bit == CS_SCHED_LOAD_BALANCE) &&
 	    cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
@@ -1442,15 +1458,22 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 			clear_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
 		else
 			set_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
+
+		if (balance_flag_changed && !turning_on) {
+			struct cpuset *parent = parent_cs(cs);
+
+			err = -EBUSY;
+			if (!parent->isolation_count ||
+			    !cpumask_subset(trialcs->cpus_allowed,
+					    parent->cpus_allowed))
+				goto out;
+		}
 	}
 
 	err = validate_change(cs, trialcs);
 	if (err < 0)
 		goto out;
 
-	balance_flag_changed = (is_sched_load_balance(cs) !=
-				is_sched_load_balance(trialcs));
-
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-- 
1.8.3.1

