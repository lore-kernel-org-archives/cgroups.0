From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] sched: remove redundant NULL cgroup check in task_group_path()
Date: Thu, 17 Jan 2013 16:03:47 +0800
Message-ID: <50F7B063.6040004@huawei.com>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F7B040.2020906-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

cpu_cgroup_css_online() is called after cgroup is fully created,
and it makes this check redundant.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/debug.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..38df0db 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -110,13 +110,6 @@ static char *task_group_path(struct task_group *tg)
 	if (autogroup_path(tg, group_path, PATH_MAX))
 		return group_path;
 
-	/*
-	 * May be NULL if the underlying cgroup isn't fully-created yet
-	 */
-	if (!tg->css.cgroup) {
-		group_path[0] = '\0';
-		return group_path;
-	}
 	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
 	return group_path;
 }
-- 
1.8.0.2
