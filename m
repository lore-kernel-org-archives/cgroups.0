From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cpuset: use rebuild_sched_domains() in cpuset_hotplug_workfn()
Date: Sat, 27 Apr 2013 17:53:32 +0800
Message-ID: <517BA01C.6060806@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

In cpuset_hotplug_workfn(), partition_sched_domains() is called without
hotplug lock held, which is actually needed (stated in the function
header of partition_sched_domains()).

This patch tries to use rebuild_sched_domains() to solve the above
issue, and makes the code looks a little simpler.

Signed-off-by: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 943968d..b0f18ba 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2184,17 +2184,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	flush_workqueue(cpuset_propagate_hotplug_wq);
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated) {
-		struct sched_domain_attr *attr;
-		cpumask_var_t *doms;
-		int ndoms;
-
-		mutex_lock(&cpuset_mutex);
-		ndoms = generate_sched_domains(&doms, &attr);
-		mutex_unlock(&cpuset_mutex);
-
-		partition_sched_domains(ndoms, doms, attr);
-	}
+	if (cpus_updated)
+		rebuild_sched_domains();
 }
 
 void cpuset_update_active_cpus(bool cpu_online)
-- 
1.8.0.2
