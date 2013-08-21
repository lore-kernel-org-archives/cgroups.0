From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/11] cpuset: allow writing offlined masks to cpuset.cpus/mems
Date: Wed, 21 Aug 2013 18:01:21 +0800
Message-ID: <52148FF1.5060503@huawei.com>
References: <52148F52.0@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52148F52.0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

As the configured masks won't be limited by its parent, and the top
cpuset's masks won't change when hotplug happens, it's natural to
allow writing offlined masks to the configured masks.

Signed-off-by; Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 20fc109..c302979 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -933,7 +933,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+		if (!cpumask_subset(trialcs->cpus_allowed,
+				    top_cpuset.cpus_allowed))
 			return -EINVAL;
 	}
 
@@ -1207,8 +1208,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
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
