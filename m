From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: remove synchronize_rcu() from cgroup_attach_{task|proc}()
Date: Mon, 14 Jan 2013 17:23:26 +0800
Message-ID: <50F3CE8E.5000402@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

These 2 syncronize_rcu()s make attaching a task to a cgroup
quite slow, and it can't be ignored in some situations.

A real case from Colin Cross: Android uses cgroups heavily to
manage thread priorities, putting threads in a background group
with reduced cpu.shares when they are not visible to the user,
and in a foreground group when they are. Some RPCs from foreground
threads to background threads will temporarily move the background
thread into the foreground group for the duration of the RPC.
This results in many calls to cgroup_attach_task.

In cgroup_attach_task() it's task->cgroups that is protected by RCU,
and put_css_set() calls kfree_rcu() to free it.

If we remove this synchronize_rcu(), there can be threads in RCU-read
sections accessing their old cgroup via current->cgroups with
concurrent rmdir operation, but this is safe.

 # time for ((i=0; i<50; i++)) { echo $$ > /mnt/sub/tasks; echo $$ > /mnt/tasks; }

real    0m2.524s
user    0m0.008s
sys     0m0.004s

With this patch:

real    0m0.004s
user    0m0.004s
sys     0m0.000s

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5262d9..67b0fa0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1974,7 +1974,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 			ss->attach(cgrp, &tset);
 	}
 
-	synchronize_rcu();
 out:
 	if (retval) {
 		for_each_subsys(root, ss) {
@@ -2143,7 +2142,6 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	/*
 	 * step 5: success! and cleanup
 	 */
-	synchronize_rcu();
 	retval = 0;
 out_put_css_set_refs:
 	if (retval) {
-- 
1.8.0.2
