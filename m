From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/3] =?UTF-8?q?sched/isolation:=20Add=20housekeep=C3=AD?= =?UTF-8?q?ng=5Fany=5Fcpu=5Ffrom()?=
Date: Tue,  1 Nov 2022 23:02:41 -0300
Message-ID: <20221102020243.522358-2-leobras@redhat.com>
References: <20221102020243.522358-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667354625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMSAt3GthE2zWUBTJjLiVIVQICwCKfwnNgpg1Ix0oWM=;
        b=VTYqX+oBfJTKfIr/hUEjVrAwQ5eU1flJmRBcaqpCDAKndBHpTohSyN9M/xdqQPVsW0W1n9
        sR6WEXNoTSgFCFsSuzry8kmWI1ObrPUQvEohVE1R1FdBJT3vmbpLjYTNA7xHTolSyUqLP/
        rvl5DBdMR/Df5t2j3mPMmdGk5H0+X0U=
In-Reply-To: <20221102020243.522358-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mt>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

As of today, there is a function called housekeepíng_any_cpu() that
returns a housekeeping cpu near the current one. This function is very
useful to help delegate tasks to other cpus when the current one is
isolated.

It also comes with the benefit of looking for cpus in the same NUMA node
as the current cpu, so any memory activity could be faster in NUMA systems.

On the other hand, there is no function like that to find housekeeping cpus
in the same NUMA node of another CPU.

Change housekeepíng_any_cpu() into housekeepíng_any_cpu_from(), so it
accepts a cpu_start parameter and can find cpus in the same NUMA node as
any given CPU.

Also, reimplements housekeepíng_any_cpu() as an inline function that calls
housekeepíng_any_cpu_from() with cpu_start = current cpu.

Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched/isolation.h | 11 ++++++++---
 kernel/sched/isolation.c        |  8 ++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 8c15abd67aed9..95b65be44f19f 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -20,7 +20,7 @@ enum hk_type {
 
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
-extern int housekeeping_any_cpu(enum hk_type type);
+extern int housekeeping_any_cpu_from(enum hk_type type, int cpu_start);
 extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
@@ -29,9 +29,9 @@ extern void __init housekeeping_init(void);
 
 #else
 
-static inline int housekeeping_any_cpu(enum hk_type type)
+static inline int housekeeping_any_cpu_from(enum hk_type type, int cpu_start)
 {
-	return smp_processor_id();
+	return cpu_start;
 }
 
 static inline const struct cpumask *housekeeping_cpumask(enum hk_type type)
@@ -58,4 +58,9 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline int housekeeping_any_cpu(enum hk_type type)
+{
+	return housekeeping_any_cpu_from(type, smp_processor_id());
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 373d42c707bc5..6ebeac11bb350 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -36,22 +36,22 @@ bool housekeeping_enabled(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
-int housekeeping_any_cpu(enum hk_type type)
+int housekeeping_any_cpu_from(enum hk_type type, int cpu_start)
 {
 	int cpu;
 
 	if (static_branch_unlikely(&housekeeping_overridden)) {
 		if (housekeeping.flags & BIT(type)) {
-			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
+			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], cpu_start);
 			if (cpu < nr_cpu_ids)
 				return cpu;
 
 			return cpumask_any_and(housekeeping.cpumasks[type], cpu_online_mask);
 		}
 	}
-	return smp_processor_id();
+	return cpu_start;
 }
-EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
+EXPORT_SYMBOL_GPL(housekeeping_any_cpu_from);
 
 const struct cpumask *housekeeping_cpumask(enum hk_type type)
 {
-- 
2.38.1

