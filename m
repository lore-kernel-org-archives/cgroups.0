From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] sched: Misc preps for cgroup unified hierarchy interface
Date: Mon, 25 Sep 2017 09:00:18 -0700
Message-ID: <20170925160019.683562-2-tj@kernel.org>
References: <20170925160019.683562-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NjhoJy8LLB1eRJQ8j6sdtXQydp0Z+nyI4BSq1bqPdeo=;
        b=k/Y3PpMtGC+6DMsDNAb1ohm1eYzYNmKfgybhY8YL21kLC63dh/BfebXAqhYR61ROOU
         0MgmhAL++1mKBiW1TEX6KLEPPXVDzr1H0uWJliaeZfgko01M0l21L9eoPr6TdAS3gc8z
         407V30cGeD50kMkraMfb+aFw0dCNnzerkJ9r0KAu8RH9D4Ua0ZYnT6WdKIiZUDszP46N
         HhjQTq2Y+na6w2D4uaFy6ZS3o0W8Wd2REL9RHYQhDRN9XkxsadM/486lSp7QAHb5T2HM
         onCMRhF2uKGnHTNVZfFaNMltt/ASoEz16G44KxJevwU99hB1cvnDrh44O/+xQY9F4Yyx
         +6lA==
In-Reply-To: <20170925160019.683562-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Make the following changes in preparation for the cpu controller
interface implementation for cgroup2.  This patch doesn't cause any
functional differences.

* s/cpu_stats_show()/cpu_cfs_stat_show()/

* s/cpu_files/cpu_legacy_files/

v2: Dropped cpuacct changes as it won't be used by cpu controller
    interface anymore.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 18a6966..6815fa4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6599,7 +6599,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -6639,7 +6639,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -6660,7 +6660,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stat_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -6686,7 +6686,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= true,
 };
 
-- 
2.9.5
