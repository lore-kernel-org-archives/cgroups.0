From: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 0/1] cgroup/cpuset: Rebuild sched domains if isolated partition changed
Date: Fri, 15 Sep 2023 17:45:03 +0200
Message-ID: <20230915154505.363754-1-pierre.gondois@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

The patch aims to rebuild the sched domains if the cpus of an isolated
partition are updated. Another issue might have been found, but it
seemed to involve more complex modifications. To reproduce this issue:

# mkdir cgroup
# mount -t cgroup2 none cgroup/
# mkdir cgroup/A1 cgroup/B1
# echo "+cpuset" > cgroup/cgroup.subtree_control 
# echo 0-3 > cgroup/A1/cpuset.cpus
# echo isolated > cgroup/A1/cpuset.cpus.partition 
# echo 4-6 > cgroup/B1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition 
isolated

// Make the isolated partition invalid as not having
// an exclusive cpuset
# echo 0-4 > A1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition 
isolated invalid (Cpu list in cpuset.cpus not exclusive)
// Expected result, internal state of the cgroup:
//  - prs_err: PERR_NOTEXCL
//  - flags: CS_CPU_EXCLUSIVE | CS_MEMORY_MIGRATE | CS_SCHED_LOAD_BALANCE

// Make the isolated partition valid:
# echo 0-3 > A1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition 
isolated invalid (Cpu list in cpuset.cpus not exclusive)
// Unexpected result, internal state of the cgroup:
//  - prs_err: PERR_NOTEXCL
//  - flags: CS_CPU_EXCLUSIVE | CS_MEMORY_MIGRATE | CS_SCHED_LOAD_BALANCE

The issue seems to be that in update_cpumask(), the cgroup tree is
only traversed if there is a need to invalidate the partitions.
Cf. the case above, I think it should also be traversed if there
is an invalid state that might be re-validated.

Regards,
Pierre

Pierre Gondois (1):
  cgroup/cpuset: Rebuild sched domains if isolated partition changed

 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.25.1

