From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v10 2/9] sched: Introduce latency-nice as a per-task attribute
Date: Fri, 13 Jan 2023 15:12:27 +0100
Message-ID: <20230113141234.260128-3-vincent.guittot@linaro.org>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kiVS63wbAWm+QNHUVgj2Zht/JYfZt2Iaghb+UJPmGJA=;
        b=Qh85uD1YsNWfsXSd0d73mm0u8hDaGmsaRhIZGgLJv8V9BgvN+HigCnzW5b9dMcw03V
         LcFIYpE7cA4lzuSa8n9vvPMFUvGTtVjfNY9gpmAGy9CGlYRhkqXxwXn8Nl0IrWDqRUhe
         S4uaRLOt5G79qMoW8ItaBtopKB9BDhstDF+PQKqqhRIuTheyU/YuaGxhtjsfZivHQwVl
         5epEhNrXjIJhyXgi3pMDMbwWSwcglnz+3DzHSPNhas1TcW4iyDzZwzhHFYm4S6884GVj
         SszmSBo/CQH+3x+o+201a6zSuaD3xxy9PeGmUEZCnVzq3ykO+k+v8MbDsyoeNyR1JihL
         In1A==
In-Reply-To: <20230113141234.260128-1-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

From: Parth Shah <parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>

Latency-nice indicates the latency requirements of a task with respect
to the other tasks in the system. The value of the attribute can be within
the range of [-20, 19] both inclusive to be in-line with the values just
like task nice values.

latency_nice = -20 indicates the task to have the least latency as
compared to the tasks having latency_nice = +19.

The latency_nice may affect only the CFS SCHED_CLASS by getting
latency requirements from the userspace.

Additionally, add debugging bits for newly added latency_nice attribute.

Signed-off-by: Parth Shah <parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
[rebase, move defines in sched/prio.h]
Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: K Prateek Nayak <kprateek.nayak-5C7GfCeVMHo@public.gmane.org>
---
 include/linux/sched.h      |  1 +
 include/linux/sched/prio.h | 18 ++++++++++++++++++
 kernel/sched/debug.c       |  1 +
 3 files changed, 20 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4df2b3e76b30..6c61bde49152 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -784,6 +784,7 @@ struct task_struct {
 	int				static_prio;
 	int				normal_prio;
 	unsigned int			rt_priority;
+	int				latency_nice;
 
 	struct sched_entity		se;
 	struct sched_rt_entity		rt;
diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ab83d85e1183..bfcd7f1d1e11 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -42,4 +42,22 @@ static inline long rlimit_to_nice(long prio)
 	return (MAX_NICE - prio + 1);
 }
 
+/*
+ * Latency nice is meant to provide scheduler hints about the relative
+ * latency requirements of a task with respect to other tasks.
+ * Thus a task with latency_nice == 19 can be hinted as the task with no
+ * latency requirements, in contrast to the task with latency_nice == -20
+ * which should be given priority in terms of lower latency.
+ */
+#define MAX_LATENCY_NICE	19
+#define MIN_LATENCY_NICE	-20
+
+#define LATENCY_NICE_WIDTH	\
+	(MAX_LATENCY_NICE - MIN_LATENCY_NICE + 1)
+
+/*
+ * Default tasks should be treated as a task with latency_nice = 0.
+ */
+#define DEFAULT_LATENCY_NICE	0
+
 #endif /* _LINUX_SCHED_PRIO_H */
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 1637b65ba07a..68be7a3e42a3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1043,6 +1043,7 @@ void proc_sched_show_task(struct task_struct *p, struct pid_namespace *ns,
 #endif
 	P(policy);
 	P(prio);
+	P(latency_nice);
 	if (task_has_dl_policy(p)) {
 		P(dl.runtime);
 		P(dl.deadline);
-- 
2.34.1

