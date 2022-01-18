From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] cpuset: Fix the bug that subpart_cpus updated wrongly in update_cpumask()
Date: Tue, 18 Jan 2022 18:05:18 +0800
Message-ID: <20220118100518.2381118-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

subparts_cpus should be limited as a subset of cpus_allowed, but it is
updated wrongly by using cpumask_andnot(). Use cpumask_and() instead to
fix it.

Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
Signed-off-by: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bb3531e7fda7..804ff5738c5f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1635,8 +1635,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);
-- 
2.33.0

