From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cpuset: fix a warning when clearing configured masks
 in old hierarchy
Date: Fri, 13 Feb 2015 11:20:30 +0800
Message-ID: <54DD6D7E.4020804@huawei.com>
References: <54DD6D55.2070603@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54DD6D55.2070603-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

When we clear cpuset.cpus, cpuset.effective_cpus won't be cleared:

  # mount -t cgroup -o cpuset xxx /mnt
  # mkdir /mnt/tmp
  # echo 0 > /mnt/tmp/cpuset.cpus
  # echo > /mnt/tmp/cpuset.cpus
  # cat cpuset.cpus

  # cat cpuset.effective_cpus
  0-15

And a kernel warning in update_cpumasks_hier() is triggered:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 4028 at kernel/cpuset.c:894 update_cpumasks_hier+0x471/0x650()

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.17+
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7e9d711..29463c2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -873,7 +873,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some CPUs.
 		 */
-		if (cpumask_empty(new_cpus))
+		if (cgroup_on_dfl(cp->css.cgroup) && cpumask_empty(new_cpus))
 			cpumask_copy(new_cpus, parent->effective_cpus);
 
 		/* Skip the whole subtree if the cpumask remains the same. */
@@ -1129,7 +1129,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (nodes_empty(*new_mems))
+		if (cgroup_on_dfl(cp->css.cgroup) && nodes_empty(*new_mems))
 			*new_mems = parent->effective_mems;
 
 		/* Skip the whole subtree if the nodemask remains the same. */
-- 
1.8.0.2
