From: David Collins <david-GOU7F2WGkdXPplzRYGY9Cw@public.gmane.org>
Subject: [PATCH] cgroup: cpu.stats reset counters support
Date: Mon, 15 Feb 2016 15:14:05 -0600
Message-ID: <56C23F9D.2020705@collins.email>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=collins-email.20150623.gappssmtp.com; s=20150623;
        h=to:subject:from:message-id:date:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=QCj3p1M8jBgjvCGwPUEGcihk150P2MrjQ1JekgDsrp4=;
        b=n+3apKKqMQFK018vL7WriKqg/nCIe18O2gHJyG1iZI6bdr7qsfd0uzmsaXY3EykNtZ
         gU4vR5vpuyKgG+RfZm4+6OD5pFkV6U9x4WdsJMoDWmkTl01XeboakHu1iFdEDaSoIMjy
         9ZQ2+a3avBStU+PMNSSdnrhICfH/tRb3LnMg+gTl3r0p9SAt+GJiaVvd++xWIHJ+gQwq
         L3cjlSM7JB4TVvoYVIqJ9MYXG7taZX+9INhmaEFYK1y1thnP+QE323rS1SxwEPdY3kpV
         IBM1MELNqepfUuyjMUxFzzcVw6cziIOPJ4dsSec0zl4j/xslrMYENANl69ixM2RZtiqx
         BC7w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, david-PnRKb+1yrG7L5xMBEfyS8A@public.gmane.org

This patch allows the cpu.stats values to be reset in cgroups without having to remove and recreate it. I wrote this patch because I've had use cases where resetting the counters made it much easier to read, and it may help with custom userland scripts when parsing statistics.

Many other components of cgroups allows stats to be reset, such as cpuacct.stats. To reset the stats counters, simply `echo 0 > cpu.stats`

--- linux/kernel/sched/core.c.orig    2016-02-15 13:47:22.359443599 -0600
+++ linux/kernel/sched/core.c    2016-02-15 13:48:14.439443599 -0600
@@ -8629,6 +8629,22 @@ static int cpu_stats_show(struct seq_fil
 
     return 0;
 }
+
+static int cpu_stats_reset(struct cgroup_subsys_state *css, struct cftype *cft,
+                u64 reset)
+{
+    struct task_group *tg = css_tg(css);
+    struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+    raw_spin_lock(&cfs_b->lock);
+    cfs_b->nr_periods = 0;
+    cfs_b->nr_throttled = 0;
+    cfs_b->throttled_time = 0;
+    raw_spin_unlock(&cfs_b->lock);
+
+    return 0;
+}
+
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -8680,6 +8696,7 @@ static struct cftype cpu_files[] = {
     {
         .name = "stat",
         .seq_show = cpu_stats_show,
+        .write_u64 = cpu_stats_reset,
     },
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
