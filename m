From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] sched/deadline: Consolidate the SCHED_DL task_can_attach() check on its own function
Date: Tue, 12 Jan 2021 16:53:40 +0100
Message-ID: <2d68af58a64b9141a84f7a76a3840e2e4a54f133.1610463999.git.bristot@redhat.com>
References: <cover.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNrX2cCpCMWJHbf1S/ll7Ao4YqIHU0K4MvkLQc/laIc=;
        b=h5Q2H4rfb7jrOVJbN6QcZZ0JG5Nquu2CZZ1wD134+1QlNCJx4tkydO1AuFJrOz4MnYGUkL
        Pl4ZDiDtxP8jdIw/Dph7bSlAwMXEbUCxB6ltlekcgIEuiuqPUgT930IfASvfxdMA21GF6P
        ABJ855N7Lhs7Dz6eK9M0iHCc1mDXLqk=
In-Reply-To: <cover.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It is easier to track the restrictions imposed on SCHED_DEADLINE
tasks if we keep them all together in a single function.

No function changes.

Signed-off-by: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/sched/core.c     | 3 +--
 kernel/sched/deadline.c | 7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7af80c3fce12..f4aede34449c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7142,8 +7142,7 @@ int task_can_attach(struct task_struct *p,
 		goto out;
 	}
 
-	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
-					      cs_cpus_allowed))
+	if (dl_task(p))
 		ret = dl_task_can_attach(p, cs_cpus_allowed);
 
 out:
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 75686c6d4436..c97d2c707b98 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2870,6 +2870,13 @@ int dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allo
 	bool overflow;
 	int ret;
 
+	/*
+	 * The task is not moving to another root domain, so it is
+	 * already accounted.
+	 */
+	if (cpumask_intersects(task_rq(p)->rd->span, cs_cpus_allowed))
+		return 0;
+
 	dest_cpu = cpumask_any_and(cpu_active_mask, cs_cpus_allowed);
 
 	rcu_read_lock_sched();
-- 
2.29.2

