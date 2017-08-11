From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] sched: Misc preps for cgroup unified hierarchy interface
Date: Fri, 11 Aug 2017 09:47:26 -0700
Message-ID: <20170811164727.3980027-2-tj@kernel.org>
References: <20170811164727.3980027-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WJj6yLp2Em3Xdpmst6SU39gXqHDhdOCnRmAW5oizLKc=;
        b=JiLc//rNryFMtKxPHguWIecM82R7uFZSwHUqzCZdk2UMUaU/IuB5bgKdsxZeBAbYaU
         NLxya4LVQ9XelgB4QdCwiD+UXKEzELkEyWo5gui8rNz3fS+AHJJPvfRgzQc8RauHYwvZ
         v/6E0s6u3HWg+RoLKuzj6AylbNTrQemiNyv7E4E7wY4xmjxdhj5eNc8fPBWXxeinHj7c
         nDQASOAdhNVdfwwY+/C2LB9lIcxcGoPr/B6LxpjN1wZMaSUdJ/AiV/TtagVkdujaqlEl
         DIyAdUEX6+n2V1YRkoifbypRH5oPKMfXOw4IoP6a1n6VLQAPWExp+cOwZCrclEFkRzgc
         +yIg==
In-Reply-To: <20170811164727.3980027-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

Make the following changes in preparation for the cpu controller
interface implementation for cgroup2.  This patch doesn't cause any
functional differences.

* s/cpu_stats_show()/cpu_cfs_stat_show()/

* s/cpu_files/cpu_legacy_files/

v2: Dropped cpuacct changes as it won't be used by cpu controller
    interface anymore.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 17c667b..9220391 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6578,7 +6578,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -6618,7 +6618,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -6639,7 +6639,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stat_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -6665,7 +6665,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= true,
 };
 
-- 
2.9.3

