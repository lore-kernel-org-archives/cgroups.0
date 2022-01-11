From: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 1/3] sched/core: Accounting forceidle time for all tasks except idle task
Date: Tue, 11 Jan 2022 17:55:59 +0800
Message-ID: <1641894961-9241-2-git-send-email-CruzZhao@linux.alibaba.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1641894961-9241-1-git-send-email-CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There are two types of forced idle time: forced idle time from cookie'd
task and forced idle time form uncookie'd task. The forced idle time from
uncookie'd task is actually caused by the cookie'd task in runqueue
indirectly, and it's more accurate to measure the capacity loss with the
sum of both.

Assuming cpu x and cpu y are a pair of SMT siblings, consider the
following scenarios:
  1.There's a cookie'd task running on cpu x, and there're 4 uncookie'd
    tasks running on cpu y. For cpu x, there will be 80% forced idle time
    (from uncookie'd task); for cpu y, there will be 20% forced idle time
    (from cookie'd task).
  2.There's a uncookie'd task running on cpu x, and there're 4 cookie'd
    tasks running on cpu y. For cpu x, there will be 80% forced idle time
    (from cookie'd task); for cpu y, there will be 20% forced idle time
    (from uncookie'd task).

The scenario1 can recurrent by stress-ng(scenario2 can recurrent similary):
    (cookie'd)taskset -c x stress-ng -c 1 -l 100
    (uncookie'd)taskset -c y stress-ng -c 4 -l 100

In the above two scenarios, the total capacity loss is 1 cpu, but in
scenario1, the cookie'd forced idle time tells us 20% cpu capacity loss, in
scenario2, the cookie'd forced idle time tells us 80% cpu capacity loss,
which are not accurate. It'll be more accurate to measure with cookie'd
forced idle time and uncookie'd forced idle time.

Signed-off-by: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/sched/core.c       | 3 +--
 kernel/sched/core_sched.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e4ae00..e8187e7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5822,8 +5822,7 @@ static inline struct task_struct *pick_task(struct rq *rq)
 	}
 
 	if (schedstat_enabled() && rq->core->core_forceidle_count) {
-		if (cookie)
-			rq->core->core_forceidle_start = rq_clock(rq->core);
+		rq->core->core_forceidle_start = rq_clock(rq->core);
 		rq->core->core_forceidle_occupation = occ;
 	}
 
diff --git a/kernel/sched/core_sched.c b/kernel/sched/core_sched.c
index 1fb4567..c8746a9 100644
--- a/kernel/sched/core_sched.c
+++ b/kernel/sched/core_sched.c
@@ -277,7 +277,7 @@ void __sched_core_account_forceidle(struct rq *rq)
 		rq_i = cpu_rq(i);
 		p = rq_i->core_pick ?: rq_i->curr;
 
-		if (!p->core_cookie)
+		if (p == rq_i->idle)
 			continue;
 
 		__schedstat_add(p->stats.core_forceidle_sum, delta);
-- 
1.8.3.1

