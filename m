From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 1/6] don't call cpuacct_charge in stop_task.c
Date: Tue, 20 Nov 2012 12:31:59 +0400
Message-ID: <1353400324-10897-2-git-send-email-glommer@parallels.com>
References: <1353400324-10897-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353400324-10897-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Mike Galbraith <mgalbraith-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Commit 8f618968 changed stop_task to do the same bookkeping as the
other classes. However, the call to cpuacct_charge() doesn't affect
the scheduler decisions at all, and doesn't need to be moved over.

Moreover, being a kthread, the migration thread won't belong to any
cgroup anyway, rendering this call quite useless.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Mike Galbraith <mgalbraith-l3A5Bk7waGM@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 kernel/sched/stop_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index da5eb5b..fda1cbe 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -68,7 +68,6 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock_task;
-	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
-- 
1.7.11.7
