From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/2] sched: add throttled time stat for throttled children
Date: Tue, 20 Jun 2023 11:32:47 -0700
Message-ID: <20230620183247.737942-2-joshdon@google.com>
References: <20230620183247.737942-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687285984; x=1689877984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RCaOAN1lAgFX63nyqwqYs4paj62tn+2HK5slSbPJUks=;
        b=Inu+37zqf+xqVO90CaUGqjRGPqQl9Wdhyj9ZNMYgA8LimfGK0MuzHhG0c9J01rXMnZ
         sCOlDztWnQa/zeQ7WinObNQviCcQC2hTDAeA3mlIa2T/UOf5kIpu+zfTQLrTGXOAnbu3
         yuhnxbaozl/KopC8Fb4KpMnjCtSphJIlpzwiHjK3JzFF7uK1J3WK4Gk07Qp+lxY4IhuT
         czS35YL1cKqJLd9/bpO8k0cklSaM7ZUTNmZLJIABfFSWEgXolY4ZC6wihqGQ7Q/spMol
         EEay8r9zsoMhavsJXVl6sE6+CS8SuBGgbbu/lefYpY/Qgt88tbaqnV92ZkVeet5eJrNz
         e8Aw==
In-Reply-To: <20230620183247.737942-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We currently export the total throttled time for cgroups that are given
a bandwidth limit. This patch extends this accounting to also account
the total time that each children cgroup has been throttled.

This is useful to understand the degree to which children have been
affected by the throttling control. Children which are not runnable
during the entire throttled period, for example, will not show any
self-throttling time during this period.

Expose this in a new interface, 'cpu.stat.local', which is similar to
how non-hierarchical events are accounted in 'memory.events.local'.

Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
v3: fix bug with nested limits
v2:
- moved export to new cpu.stat.local file, per Tejun's recommendation
 include/linux/cgroup-defs.h |  2 ++
 kernel/cgroup/cgroup.c      | 34 ++++++++++++++++++++++++++++
 kernel/sched/core.c         | 44 +++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c         | 21 +++++++++++++++++-
 kernel/sched/sched.h        |  2 ++
 5 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a0d5466c7be..ae20dbb885d6 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -661,6 +661,8 @@ struct cgroup_subsys {
 	void (*css_rstat_flush)(struct cgroup_subsys_state *css, int cpu);
 	int (*css_extra_stat_show)(struct seq_file *seq,
 				   struct cgroup_subsys_state *css);
+	int (*css_local_stat_show)(struct seq_file *seq,
+				   struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2d3d13e52333..bfe063225d3b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3726,6 +3726,36 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 	return ret;
 }
 
+static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
+						 struct cgroup *cgrp, int ssid)
+{
+	struct cgroup_subsys *ss = cgroup_subsys[ssid];
+	struct cgroup_subsys_state *css;
+	int ret;
+
+	if (!ss->css_local_stat_show)
+		return 0;
+
+	css = cgroup_tryget_css(cgrp, ss);
+	if (!css)
+		return 0;
+
+	ret = ss->css_local_stat_show(seq, css);
+	css_put(css);
+	return ret;
+}
+
+static int cpu_local_stat_show(struct seq_file *seq, void *v)
+{
+	struct cgroup __maybe_unused *cgrp = seq_css(seq)->cgroup;
+	int ret = 0;
+
+#ifdef CONFIG_CGROUP_SCHED
+	ret = cgroup_local_stat_show(seq, cgrp, cpu_cgrp_id);
+#endif
+	return ret;
+}
+
 #ifdef CONFIG_PSI
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
@@ -5276,6 +5306,10 @@ static struct cftype cgroup_base_files[] = {
 		.name = "cpu.stat",
 		.seq_show = cpu_stat_show,
 	},
+	{
+		.name = "cpu.stat.local",
+		.seq_show = cpu_local_stat_show,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9a04faa48a1..0de483190a57 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11140,6 +11140,27 @@ static int cpu_cfs_stat_show(struct seq_file *sf, void *v)
 
 	return 0;
 }
+
+static u64 throttled_time_self(struct task_group *tg)
+{
+	int i;
+	u64 total = 0;
+
+	for_each_possible_cpu(i) {
+		total += READ_ONCE(tg->cfs_rq[i]->throttled_clock_self_time);
+	}
+
+	return total;
+}
+
+static int cpu_cfs_local_stat_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+
+	seq_printf(sf, "throttled_time %llu\n", throttled_time_self(tg));
+
+	return 0;
+}
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -11216,6 +11237,10 @@ static struct cftype cpu_legacy_files[] = {
 		.name = "stat",
 		.seq_show = cpu_cfs_stat_show,
 	},
+	{
+		.name = "stat.local",
+		.seq_show = cpu_cfs_local_stat_show,
+	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
@@ -11272,6 +11297,24 @@ static int cpu_extra_stat_show(struct seq_file *sf,
 	return 0;
 }
 
+static int cpu_local_stat_show(struct seq_file *sf,
+			       struct cgroup_subsys_state *css)
+{
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		struct task_group *tg = css_tg(css);
+		u64 throttled_self_usec;
+
+		throttled_self_usec = throttled_time_self(tg);
+		do_div(throttled_self_usec, NSEC_PER_USEC);
+
+		seq_printf(sf, "throttled_usec %llu\n",
+			   throttled_self_usec);
+	}
+#endif
+	return 0;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static u64 cpu_weight_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
@@ -11450,6 +11493,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_released	= cpu_cgroup_css_released,
 	.css_free	= cpu_cgroup_css_free,
 	.css_extra_stat_show = cpu_extra_stat_show,
+	.css_local_stat_show = cpu_local_stat_show,
 #ifdef CONFIG_RT_GROUP_SCHED
 	.can_attach	= cpu_cgroup_can_attach,
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 72571d48559a..b1bccef78b90 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4878,8 +4878,12 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 			list_add_leaf_cfs_rq(cfs_rq);
 		} else {
 #ifdef CONFIG_CFS_BANDWIDTH
+			struct rq *rq = rq_of(cfs_rq);
+
 			if (cfs_rq_throttled(cfs_rq) && !cfs_rq->throttled_clock)
-				cfs_rq->throttled_clock = rq_clock(rq_of(cfs_rq));
+				cfs_rq->throttled_clock = rq_clock(rq);
+			if (!cfs_rq->throttled_clock_self)
+				cfs_rq->throttled_clock_self = rq_clock(rq);
 #endif
 		}
 	}
@@ -5384,6 +5388,17 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		/* Add cfs_rq with load or one or more already running entities to the list */
 		if (!cfs_rq_is_decayed(cfs_rq))
 			list_add_leaf_cfs_rq(cfs_rq);
+
+		if (cfs_rq->throttled_clock_self) {
+			u64 delta = rq_clock(rq) - cfs_rq->throttled_clock_self;
+
+			cfs_rq->throttled_clock_self = 0;
+
+			if (SCHED_WARN_ON((s64)delta < 0))
+				delta = 0;
+
+			cfs_rq->throttled_clock_self_time += delta;
+		}
 	}
 
 	return 0;
@@ -5398,6 +5413,10 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	if (!cfs_rq->throttle_count) {
 		cfs_rq->throttled_clock_pelt = rq_clock_pelt(rq);
 		list_del_leaf_cfs_rq(cfs_rq);
+
+		SCHED_WARN_ON(cfs_rq->throttled_clock_self);
+		if (cfs_rq->nr_running)
+			cfs_rq->throttled_clock_self = rq_clock(rq);
 	}
 	cfs_rq->throttle_count++;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 556496c77dc2..46f8a01ff405 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -636,6 +636,8 @@ struct cfs_rq {
 	u64			throttled_clock;
 	u64			throttled_clock_pelt;
 	u64			throttled_clock_pelt_time;
+	u64			throttled_clock_self;
+	u64			throttled_clock_self_time;
 	int			throttled;
 	int			throttle_count;
 	struct list_head	throttled_list;
-- 
2.41.0.162.gfafddb0af9-goog

