From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 11/12] cpuset: allow writing offlined masks to cpuset.cpus/mems
Date: Fri, 11 Oct 2013 17:51:54 +0800
Message-ID: <5257CA3A.2040705@huawei.com>
References: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

As the configured masks won't be limited by its parent, and the top
cpuset's masks won't change when hotplug happens, it's natural to
allow writing offlined masks to the configured masks.

Signed-off-by; Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e71c04f..a98723d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -960,7 +960,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+		if (!cpumask_subset(trialcs->cpus_allowed,
+				    top_cpuset.cpus_allowed))
 			return -EINVAL;
 	}
 
@@ -1238,8 +1239,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
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
