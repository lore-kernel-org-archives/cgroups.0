From: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] cpuset: Fix kernel-doc
Date: Wed, 16 Feb 2022 11:17:53 +0800
Message-ID: <20220216031753.8298-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Fix the following W=1 kernel warnings:

kernel/cgroup/cpuset.c:3718: warning: expecting prototype for
cpuset_memory_pressure_bump(). Prototype was for
__cpuset_memory_pressure_bump() instead.

kernel/cgroup/cpuset.c:3568: warning: expecting prototype for
cpuset_node_allowed(). Prototype was for __cpuset_node_allowed()
instead.

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 97c53f3cc917..5de18448016c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3524,8 +3524,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
 	return cs;
 }
 
-/**
- * cpuset_node_allowed - Can we allocate on a memory node?
+/*
+ * __cpuset_node_allowed - Can we allocate on a memory node?
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
@@ -3696,8 +3696,8 @@ void cpuset_print_current_mems_allowed(void)
 
 int cpuset_memory_pressure_enabled __read_mostly;
 
-/**
- * cpuset_memory_pressure_bump - keep stats of per-cpuset reclaims.
+/*
+ * __cpuset_memory_pressure_bump - keep stats of per-cpuset reclaims.
  *
  * Keep a running average of the rate of synchronous (direct)
  * page reclaim efforts initiated by tasks in each cpuset.
@@ -3712,7 +3712,7 @@ int cpuset_memory_pressure_enabled __read_mostly;
  * "memory_pressure".  Value displayed is an integer
  * representing the recent rate of entry into the synchronous
  * (direct) page reclaim by any task attached to the cpuset.
- **/
+ */
 
 void __cpuset_memory_pressure_bump(void)
 {
-- 
2.20.1.7.g153144c

