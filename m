From: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 1/1] cgroup/cpuset: Rebuild sched domains if isolated partition changed
Date: Fri, 15 Sep 2023 17:45:04 +0200
Message-ID: <20230915154505.363754-2-pierre.gondois@arm.com>
References: <20230915154505.363754-1-pierre.gondois@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230915154505.363754-1-pierre.gondois-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When an isolated parition is created, the sched domains (sds) are
rebuilt and the sds of the isolated CPUs are detached. This only
happens at the creation of the isolated parition. Updating
the cpuset of the partition doesn't rebuild the sds:

To reproduce:
  # ls /sys/kernel/debug/sched/domains/cpu0/
  domain0
  # ls /sys/kernel/debug/sched/domains/cpu1/
  domain0
  #
  # mkdir cgroup
  # mount -t cgroup2 none cgroup/
  # mkdir cgroup/A1/
  # echo "+cpuset" > cgroup/cgroup.subtree_control
  # echo 0-3 > cgroup/A1/cpuset.cpus
  # echo isolated > cgroup/A1/cpuset.cpus.partition
  #
  # ls /sys/kernel/debug/sched/domains/cpu0/
  # ls /sys/kernel/debug/sched/domains/cpu1/
  #
  # echo 0 > cgroup/A1/cpuset.cpus
  # ls /sys/kernel/debug/sched/domains/cpu0/
  # ls /sys/kernel/debug/sched/domains/cpu1/
  #

Here CPU1 should have a sched domain re-attached.

Signed-off-by: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58e6f18f01c1..e3eb27ff9b68 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1680,11 +1680,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * empty cpuset is changed, we need to rebuild sched domains.
 		 * On default hierarchy, the cpuset needs to be a partition
 		 * root as well.
+		 * Also rebuild sched domains if the cpuset of an isolated
+		 * partition changed.
 		 */
-		if (!cpumask_empty(cp->cpus_allowed) &&
-		    is_sched_load_balance(cp) &&
-		   (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
-		    is_partition_valid(cp)))
+		if ((!cpumask_empty(cp->cpus_allowed) &&
+		     is_sched_load_balance(cp) &&
+		     (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+		      is_partition_valid(cp))) ||
+		    (cp->partition_root_state == PRS_ISOLATED ||
+		     cp->partition_root_state == PRS_INVALID_ISOLATED))
 			need_rebuild_sched_domains = true;
 
 		rcu_read_lock();
-- 
2.25.1

