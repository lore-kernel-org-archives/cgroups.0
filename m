From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 4 May 2015 08:54:36 +0800
Message-ID: <5546C34C.7050202@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It's allowed to promote a task from normal to realtime after it has been
attached to a non-root cgroup, but it will fail if the attaching happens
after it has become realtime. I don't see how this restriction is useful.

We are moving toward unified hierarchy where all the cgroup controllers
are bound together, so it would make cgroups easier to use if we have less
restrictions on attaching tasks between cgroups.

Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fe22f75..55c21f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7800,6 +7800,11 @@ static int sched_rt_global_constraints(void)
 
 	return ret;
 }
+
+static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+{
+	return 1;
+}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static int sched_dl_global_validate(void)
@@ -8002,16 +8007,9 @@ static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
 {
 	struct task_struct *task;
 
-	cgroup_taskset_for_each(task, tset) {
-#ifdef CONFIG_RT_GROUP_SCHED
+	cgroup_taskset_for_each(task, tset)
 		if (!sched_rt_can_attach(css_tg(css), task))
 			return -EINVAL;
-#else
-		/* We don't support RT-tasks being in separate groups */
-		if (task->sched_class != &fair_sched_class)
-			return -EINVAL;
-#endif
-	}
 	return 0;
 }
 
-- 
1.9.1
