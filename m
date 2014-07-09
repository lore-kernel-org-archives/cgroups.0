From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 11/12] cpuset: allow writing offlined masks to cpuset.cpus/mems
Date: Wed, 9 Jul 2014 16:49:12 +0800
Message-ID: <53BD0208.2010302@huawei.com>
References: <53BD0174.4060002@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BD0174.4060002@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

As the configured masks won't be limited by its parent, and the top
cpuset's masks won't change when hotplug happens, it's natural to
allow writing offlined masks to the configured masks.

If on default hierarchy:

	# echo 0 > /sys/devices/system/cpu/cpu1/online
	# mkdir /cpuset/sub
	# echo 1 > /cpuset/sub/cpuset.cpus
	# cat /cpuset/sub/cpuset.cpus
	1

If on legacy hierarchy:

	# echo 0 > /sys/devices/system/cpu/cpu1/online
	# mkdir /cpuset/sub
	# echo 1 > /cpuset/sub/cpuset.cpus
	-bash: echo: write error: Invalid argument

Note the checks don't need to be gated by cgroup_on_dfl, because we've
initialized top_cpuset.{cpus,mems}_allowed accordingly in cpuset_bind().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c47cb94..65878a7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -929,7 +929,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+		if (!cpumask_subset(trialcs->cpus_allowed,
+				    top_cpuset.cpus_allowed))
 			return -EINVAL;
 	}
 
@@ -1186,8 +1187,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			goto done;
 
 		if (!nodes_subset(trialcs->mems_allowed,
-				node_states[N_MEMORY])) {
-			retval =  -EINVAL;
+				  top_cpuset.mems_allowed)) {
+			retval = -EINVAL;
 			goto done;
 		}
 	}
-- 
1.8.0.2
