From: Waiman Long <longman@redhat.com>
Subject: [PATCH v9 6/7] cpuset: Don't rebuild sched domains if cpu changes in non-domain root
Date: Tue, 29 May 2018 09:41:33 -0400
Message-ID: <1527601294-3444-7-git-send-email-longman@redhat.com>
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

With the cpuset v1, any changes to the list of allowable CPUs in a cpuset
may cause changes in the sched domain configuration depending on the
load balancing states and the cpu lists of its parent and its children.

With cpuset v2 (on default hierarchy), there are more restrictions
on how the load balancing state of a cpuset can change. As a result,
only changes made in a sched domain root will cause possible changes
to the corresponding sched domain. CPU changes to any of the non-domain
root cpusets will not cause changes in the sched domain configuration.
As a result, we don't need to call rebuild_sched_domains_locked()
for changes in a non-domain root cpuset saving precious cpu cycles.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f6ae483..9513f90 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -971,11 +971,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		update_tasks_cpumask(cp);
 
 		/*
-		 * If the effective cpumask of any non-empty cpuset is changed,
-		 * we need to rebuild sched domains.
+		 * On legacy hierarchy, if the effective cpumask of any non-
+		 * empty cpuset is changed, we need to rebuild sched domains.
+		 * On default hiearchy, the cpuset needs to be a sched
+		 * domain root as well.
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
-		    is_sched_load_balance(cp))
+		    is_sched_load_balance(cp) &&
+		   (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+		    is_sched_domain_root(cp)))
 			need_rebuild_sched_domains = true;
 
 		rcu_read_lock();
-- 
1.8.3.1

