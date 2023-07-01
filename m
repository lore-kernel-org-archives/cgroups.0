From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: update parent subparts cpumask while holding css refcnt
Date: Sat, 1 Jul 2023 14:50:49 +0800
Message-ID: <20230701065049.1758266-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

update_parent_subparts_cpumask() is called outside RCU read-side critical
section without holding extra css refcnt of cp. In theroy, cp could be
freed at any time. Holding extra css refcnt to ensure cp is valid while
updating parent subparts cpumask.

Fixes: d7c8142d5a55 ("cgroup/cpuset: Make partition invalid if cpumask change violates exclusivity rule")
Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58e6f18f01c1..632a9986d5de 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		cpuset_for_each_child(cp, css, parent)
 			if (is_partition_valid(cp) &&
 			    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
+				if (!css_tryget_online(&cp->css))
+					continue;
 				rcu_read_unlock();
 				update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
 				rcu_read_lock();
+				css_put(&cp->css);
 			}
 		rcu_read_unlock();
 		retval = 0;
-- 
2.33.0

