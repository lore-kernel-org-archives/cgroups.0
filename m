From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] sched/deadline: Add helpers to get the correct root domain/span/dl_bw
Date: Tue, 12 Jan 2021 16:53:44 +0100
Message-ID: <645f20a3fc9287aff2c5e8ca1a08ec1cb32996d5.1610463999.git.bristot@redhat.com>
References: <cover.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfgtcL4F5AYD3v5kDSOmx2qMlgaNuM9QROpZ54Xxzng=;
        b=eAmV7qyEPrnqcZZl59IZb+TbtDYPR59Zyu5h4YBYXIAdSdHMUrhOL+v3Aqw9YwJnsufFRo
        R5RKUq2UF0p2k2QtyjwatWrVQ+D7GSxJYCA7+piIIGkLb0GMjV1u+yZV1H8L5ePJL2gFsd
        S1Ls0ClGK5Tnl4M3C6zqbD6dV53EL6M=
In-Reply-To: <cover.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

task_cpu() is often used on SCHED_DEADLINE to access the root_domain
and associated information. However, the task_cpu() does not always
reflect the correct CPU. The reason being is shown in the code:

From kernel/sched/core:
----- %< -----
 * p->on_rq <- { 0, 1 = TASK_ON_RQ_QUEUED, 2 = TASK_ON_RQ_MIGRATING }:
 *
 *   is set by activate_task() and cleared by deactivate_task(), under
 *   rq->lock. Non-zero indicates the task is runnable, the special
 *   ON_RQ_MIGRATING state is used for migration without holding both
 *   rq->locks. It indicates task_cpu() is not stable, see task_rq_lock().
[...]
 * task_cpu(p): is changed by set_task_cpu(), the rules are:
 *
 *  - Don't call set_task_cpu() on a blocked task:
 *
 *    We don't care what CPU we're not running on, this simplifies hotplug,
 *    the CPU assignment of blocked tasks isn't required to be valid.
----- >% -----

So, a sleeping task will not have its task_cpu() stable, and this is
causing problems on SCHED_DEADLINE.

In preparation for fixing this problems, we need to add helper functions
that return the dl_task_cpu, root_domain, and "root" dl_bw that
reflects the current placement/affinity of the task.

Note that these functions are only required on the code path that
can happen when the task is not queued.

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
 kernel/sched/sched.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 54881d99cebd..5f3f3cb5a6ff 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2393,6 +2393,37 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
 		rq->dl.extra_bw += bw;
 	}
 }
+
+static inline
+int dl_task_cpu(struct task_struct *p)
+{
+	/*
+	 * We can only rely on task_cpu() of runnable tasks.
+	 */
+	if (p->on_rq)
+		return task_cpu(p);
+
+	/*
+	 * The task_cpu() of non-runnable task migth be pointing a CPU
+	 * it cannot run anymore (see set_task_cpu()). Hence, let's
+	 * get a possible cpu from the current cpu_mask.
+	 */
+	return cpumask_any(p->cpus_ptr);
+
+}
+
+static inline
+struct root_domain *dl_task_rd(struct task_struct *p)
+{
+	int cpu = dl_task_cpu(p);
+	return cpu_rq(cpu)->rd;
+}
+
+static inline
+struct dl_bw *dl_task_root_bw(struct task_struct *p)
+{
+	return &dl_task_rd(p)->dl_bw;
+}
 #else
 static inline
 void __dl_update(struct dl_bw *dl_b, s64 bw)
@@ -2401,6 +2432,18 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
 
 	dl->extra_bw += bw;
 }
+
+static inline
+int dl_task_cpu(struct task_struct *p)
+{
+	return 0;
+}
+
+static inline
+struct dl_bw *dl_task_root_bw(struct task_struct *p)
+{
+	return &task_rq(p)->dl.dl_bw;
+}
 #endif
 
 
-- 
2.29.2

