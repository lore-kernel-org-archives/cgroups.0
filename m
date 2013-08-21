From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: fix a regression in validating config change
Date: Wed, 21 Aug 2013 10:22:28 +0800
Message-ID: <52142464.1060603@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It's not allowed to clear masks of a cpuset if there're tasks in it,
but it's broken:

  # mkdir /cgroup/sub
  # echo 0 > /cgroup/sub/cpuset.cpus
  # echo 0 > /cgroup/sub/cpuset.mems
  # echo $$ > /cgroup/sub/tasks
  # echo > /cgroup/sub/cpuset.cpus
  (should fail)

This bug was introduced by commit 88fa523bff295f1d60244a54833480b02f775152
("cpuset: allow to move tasks to empty cpusets").

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0b5b9a3..70ab3fd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -425,6 +425,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	struct cgroup_subsys_state *css;
 	struct cpuset *c, *par;
 	int ret;
+	bool make_cpus_empty;
+	bool make_mems_empty;
 
 	rcu_read_lock();
 
@@ -464,12 +466,15 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
+	make_cpus_empty = !cpumask_empty(cur->cpus_allowed) &&
+			  cpumask_empty(trial->cpus_allowed);
+	make_mems_empty = !nodes_empty(cur->mems_allowed) &&
+			  nodes_empty(trial->mems_allowed);
 	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
+	    (make_cpus_empty || make_mems_empty))
 		goto out;
 
 	ret = 0;
-- 
1.8.0.2
