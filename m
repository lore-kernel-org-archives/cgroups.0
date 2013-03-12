From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cpuset: fix RCU lockdep splat in cpuset_print_task_mems_allowed()
Date: Tue, 12 Mar 2013 10:28:39 +0800
Message-ID: <513E92D7.9050903@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Sasha reported a lockdep warning when OOM was triggered. The reason
is cgroup_name() should be called with rcu_read_lock() held.

Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

This fix is for 3.10

---
 kernel/cpuset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c55763b..98d458a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2599,6 +2599,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 
 	struct cgroup *cgrp = task_cs(tsk)->css.cgroup;
 
+	rcu_read_lock();
 	spin_lock(&cpuset_buffer_lock);
 
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
@@ -2607,6 +2608,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 	       tsk->comm, cgroup_name(cgrp), cpuset_nodelist);
 
 	spin_unlock(&cpuset_buffer_lock);
+	rcu_read_unlock();
 }
 
 /*
-- 
1.8.0.2
