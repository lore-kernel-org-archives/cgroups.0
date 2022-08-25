From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4 01/10] sched/psi: fix periodic aggregation shut off
Date: Fri, 26 Aug 2022 00:41:02 +0800
Message-ID: <20220825164111.29534-2-zhouchengming@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=WejlGClWGOz4bz39sTGrt+zcC+1FgtAJxwc+yuBUn+0=;
        b=SaF4V56o98RwyKm4Dd9nmZJgCPmnYVFL9biZ4nY7UVTw8PLe9hkPGSpcJ7JhVfqSpo
         4Wo2DhNt0zt75QS2NiNriICjnCg1VwUFXEob4tUMn/HzRN25XnP5BQ3NdSdTuuTw+yqj
         KkRjfGpl/qxuQFhWvAkxvrVYfcbhK81Tz5EbiAv2/S7TSUPhu6fOCtNq/S1TWZl1dH9j
         +xgN+KslrcRgYvGpWPuev08WdqzlH5Ou2+VlEBeDAvirALpBkB1aoKLSDbV+X/cgJXyb
         iKSkaBMNgF9qnMpkMopBugxFvSY80G2kqQd0XHsNV/yZi5cDYTNgzgo6lsVxvm/BlRvL
         SBgw==
In-Reply-To: <20220825164111.29534-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We don't want to wake periodic aggregation work back up if the
task change is the aggregation worker itself going to sleep, or
we'll ping-pong forever.

Previously, we would use psi_task_change() in psi_dequeue() when
task going to sleep, so this check was put in psi_task_change().

But commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
defer task sleep handling to psi_task_switch(), won't go through
psi_task_change() anymore.

So this patch move this check to psi_task_switch().

Fixes: 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/sched/psi.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ecb4b4ff4ce0..39463dcc16bb 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -796,7 +796,6 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 {
 	int cpu = task_cpu(task);
 	struct psi_group *group;
-	bool wake_clock = true;
 	void *iter = NULL;
 	u64 now;
 
@@ -806,19 +805,9 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 	psi_flags_change(task, clear, set);
 
 	now = cpu_clock(cpu);
-	/*
-	 * Periodic aggregation shuts off if there is a period of no
-	 * task changes, so we wake it back up if necessary. However,
-	 * don't do this if the task change is the aggregation worker
-	 * itself going to sleep, or we'll ping-pong forever.
-	 */
-	if (unlikely((clear & TSK_RUNNING) &&
-		     (task->flags & PF_WQ_WORKER) &&
-		     wq_worker_last_func(task) == psi_avgs_work))
-		wake_clock = false;
 
 	while ((group = iterate_groups(task, &iter)))
-		psi_group_change(group, cpu, clear, set, now, wake_clock);
+		psi_group_change(group, cpu, clear, set, now, true);
 }
 
 void psi_task_switch(struct task_struct *prev, struct task_struct *next,
@@ -854,6 +843,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 
 	if (prev->pid) {
 		int clear = TSK_ONCPU, set = 0;
+		bool wake_clock = true;
 
 		/*
 		 * When we're going to sleep, psi_dequeue() lets us
@@ -867,13 +857,23 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 				clear |= TSK_MEMSTALL_RUNNING;
 			if (prev->in_iowait)
 				set |= TSK_IOWAIT;
+
+			/*
+			 * Periodic aggregation shuts off if there is a period of no
+			 * task changes, so we wake it back up if necessary. However,
+			 * don't do this if the task change is the aggregation worker
+			 * itself going to sleep, or we'll ping-pong forever.
+			 */
+			if (unlikely((prev->flags & PF_WQ_WORKER) &&
+				     wq_worker_last_func(prev) == psi_avgs_work))
+				wake_clock = false;
 		}
 
 		psi_flags_change(prev, clear, set);
 
 		iter = NULL;
 		while ((group = iterate_groups(prev, &iter)) && group != common)
-			psi_group_change(group, cpu, clear, set, now, true);
+			psi_group_change(group, cpu, clear, set, now, wake_clock);
 
 		/*
 		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
@@ -882,7 +882,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		if (sleep) {
 			clear &= ~TSK_ONCPU;
 			for (; group; group = iterate_groups(prev, &iter))
-				psi_group_change(group, cpu, clear, set, now, true);
+				psi_group_change(group, cpu, clear, set, now, wake_clock);
 		}
 	}
 }
-- 
2.37.2

