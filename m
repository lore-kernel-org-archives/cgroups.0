From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v10 6/9] sched/fair: Add sched group latency support
Date: Fri, 13 Jan 2023 15:12:31 +0100
Message-ID: <20230113141234.260128-7-vincent.guittot@linaro.org>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wKU8uiBTq3EBSEKs7HoauBnDIh2Fc9iGzBeoPlJTDY=;
        b=Y4VJe97fZY3loO27wJAyXfrN3a+KVh5Zuffg0d4rOcwZDSmq3CSYIZFG3xDZcfwMYo
         xwxgY1zulnkbJyf9oSgwf0zje7+WKqKSmyU6BOvPTy03kxdFJ+x5eeqsqRoLbY5Edb+s
         VMOoJefJhpGY+yjXT18tQ+KPR9GLt3BE51lpmpUE3E9cHbDvnukSoaD6w0N0dyEGOXgp
         GvVkFtpBnJblg1D2oxP7hByCNefNkcHOE5eQgEvRLFhxVZfbFETpyopGlEcY5G0nLWPU
         GiqDDJX6Cj6VUBbx0uHbxewx4vQXY5oOMQcv3P5FBERiMmSeYeLGzW0739e3uZnDvMQj
         mLdg==
In-Reply-To: <20230113141234.260128-1-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Task can set its latency priority with sched_setattr(), which is then used
to set the latency offset of its sched_enity, but sched group entities
still have the default latency offset value.

Add a latency.nice field in cpu cgroup controller to set the latency
priority of the group similarly to sched_setattr(). The latency priority
is then used to set the offset of the sched_entities of the group.

Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: K Prateek Nayak <kprateek.nayak-5C7GfCeVMHo@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 10 +++++
 kernel/sched/core.c                     | 52 +++++++++++++++++++++++++
 kernel/sched/fair.c                     | 33 ++++++++++++++++
 kernel/sched/sched.h                    |  4 ++
 4 files changed, 99 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 1b3ed1c3b3f1..c08424593e4a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1121,6 +1121,16 @@ All time durations are in microseconds.
         values similar to the sched_setattr(2). This maximum utilization
         value is used to clamp the task specific maximum utilization clamp.
 
+  cpu.latency.nice
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	The nice value is in the range [-20, 19].
+
+	This interface file allows reading and setting latency using the
+	same values used by sched_setattr(2). The latency_nice of a group is
+	used to limit the impact of the latency_nice of a task outside the
+	group.
 
 
 Memory
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 402c8d622b76..6798c9a297d6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11007,6 +11007,47 @@ static int cpu_idle_write_s64(struct cgroup_subsys_state *css,
 {
 	return sched_group_set_idle(css_tg(css), idle);
 }
+
+static s64 cpu_latency_nice_read_s64(struct cgroup_subsys_state *css,
+				    struct cftype *cft)
+{
+	int prio, delta, last_delta = INT_MAX;
+	s64 weight;
+
+	weight = css_tg(css)->latency_offset * NICE_LATENCY_WEIGHT_MAX;
+	weight = div_s64(weight, get_sleep_latency(false));
+
+	/* Find the closest nice value to the current weight */
+	for (prio = 0; prio < ARRAY_SIZE(sched_latency_to_weight); prio++) {
+		delta = abs(sched_latency_to_weight[prio] - weight);
+		if (delta >= last_delta)
+			break;
+		last_delta = delta;
+	}
+
+	return LATENCY_TO_NICE(prio-1);
+}
+
+static int cpu_latency_nice_write_s64(struct cgroup_subsys_state *css,
+				     struct cftype *cft, s64 nice)
+{
+	s64 latency_offset;
+	long weight;
+	int idx;
+
+	if (nice < MIN_LATENCY_NICE || nice > MAX_LATENCY_NICE)
+		return -ERANGE;
+
+	idx = NICE_TO_LATENCY(nice);
+	idx = array_index_nospec(idx, LATENCY_NICE_WIDTH);
+	weight = sched_latency_to_weight[idx];
+
+	latency_offset = weight * get_sleep_latency(false);
+	latency_offset = div_s64(latency_offset, NICE_LATENCY_WEIGHT_MAX);
+
+	return sched_group_set_latency(css_tg(css), latency_offset);
+}
+
 #endif
 
 static struct cftype cpu_legacy_files[] = {
@@ -11021,6 +11062,11 @@ static struct cftype cpu_legacy_files[] = {
 		.read_s64 = cpu_idle_read_s64,
 		.write_s64 = cpu_idle_write_s64,
 	},
+	{
+		.name = "latency.nice",
+		.read_s64 = cpu_latency_nice_read_s64,
+		.write_s64 = cpu_latency_nice_write_s64,
+	},
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	{
@@ -11238,6 +11284,12 @@ static struct cftype cpu_files[] = {
 		.read_s64 = cpu_idle_read_s64,
 		.write_s64 = cpu_idle_write_s64,
 	},
+	{
+		.name = "latency.nice",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_s64 = cpu_latency_nice_read_s64,
+		.write_s64 = cpu_latency_nice_write_s64,
+	},
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	{
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e87a863a2aa6..80ad27ddb4a1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12296,6 +12296,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
+	tg->latency_offset = 0;
 
 	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
 
@@ -12394,6 +12395,9 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 	}
 
 	se->my_q = cfs_rq;
+
+	se->latency_offset = tg->latency_offset;
+
 	/* guarantee group entities always have weight */
 	update_load_set(&se->load, NICE_0_LOAD);
 	se->parent = parent;
@@ -12524,6 +12528,35 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 	return 0;
 }
 
+int sched_group_set_latency(struct task_group *tg, s64 latency)
+{
+	int i;
+
+	if (tg == &root_task_group)
+		return -EINVAL;
+
+	if (abs(latency) > sysctl_sched_latency)
+		return -EINVAL;
+
+	mutex_lock(&shares_mutex);
+
+	if (tg->latency_offset == latency) {
+		mutex_unlock(&shares_mutex);
+		return 0;
+	}
+
+	tg->latency_offset = latency;
+
+	for_each_possible_cpu(i) {
+		struct sched_entity *se = tg->se[i];
+
+		WRITE_ONCE(se->latency_offset, latency);
+	}
+
+	mutex_unlock(&shares_mutex);
+	return 0;
+}
+
 #else /* CONFIG_FAIR_GROUP_SCHED */
 
 void free_fair_sched_group(struct task_group *tg) { }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fd099f3961e4..5a4ce8e61f47 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -383,6 +383,8 @@ struct task_group {
 
 	/* A positive value indicates that this is a SCHED_IDLE group. */
 	int			idle;
+	/* latency constraint of the group. */
+	int			latency_offset;
 
 #ifdef	CONFIG_SMP
 	/*
@@ -493,6 +495,8 @@ extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 
 extern int sched_group_set_idle(struct task_group *tg, long idle);
 
+extern int sched_group_set_latency(struct task_group *tg, s64 latency);
+
 #ifdef CONFIG_SMP
 extern void set_task_rq_fair(struct sched_entity *se,
 			     struct cfs_rq *prev, struct cfs_rq *next);
-- 
2.34.1

