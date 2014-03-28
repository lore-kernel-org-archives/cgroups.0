From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: fix spurious lockdep warning in cgroup_exit()
Date: Fri, 28 Mar 2014 15:18:27 +0800
Message-ID: <53352243.80805@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

cgroup_exit() is called in fork and exit path. If it's called in the
failure path during fork, PF_EXITING isn't set, and then lockdep will
complain.

Fix this by removing cgroup_exit() in that failure path. cgroup_fork()
does nothing that needs cleanup.

Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 +--
 kernel/fork.c   | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8f4ddbe..a53dbc6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4339,8 +4339,7 @@ void cgroup_post_fork(struct task_struct *child)
  * notify_on_release(), then leave the task attached to the root cgroup in
  * each hierarchy for the remainder of its exit.  No need to bother with
  * init_css_set refcnting.  init_css_set never goes away and we can't race
- * with migration path - either PF_EXITING is visible to migration path or
- * @tsk never got on the tasklist.
+ * with migration path - PF_EXITING is visible to migration path.
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 3e02737..0477657 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1274,7 +1274,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (IS_ERR(p->mempolicy)) {
 		retval = PTR_ERR(p->mempolicy);
 		p->mempolicy = NULL;
-		goto bad_fork_cleanup_cgroup;
+		goto bad_fork_cleanup_threadgroup_lock;
 	}
 #endif
 #ifdef CONFIG_CPUSETS
@@ -1526,11 +1526,10 @@ bad_fork_cleanup_policy:
 	perf_event_free_task(p);
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
-bad_fork_cleanup_cgroup:
+bad_fork_cleanup_threadgroup_lock:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
-	cgroup_exit(p, 0);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.8.0.2
