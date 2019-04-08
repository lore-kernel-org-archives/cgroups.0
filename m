From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 4/7] sched, cgroup: add entry cpu.headroom
Date: Mon, 8 Apr 2019 14:45:36 -0700
Message-ID: <20190408214539.2705660-5-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ACgvZPaeTU8nNMOD0KLy3exkPgAKVxC9JEOxMnEfY6c=;
 b=GTezBYASqB4GxFfsTStdomm0TstbfbciSjIsGGQP7O/ywoBpAqjOfJlEiS6Zwg2SW4M3
 DfBNXTHePgxHjuLEyXGF/VUm3drc9RtTenj00annxfudpqyguKi2NHFKcqwqAqoSOLcs
 ZYzosRM1fevyuPfW3NHGVz4Bw5bWFL0upVw= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch introduces a new cgroup cpu controller knob: cpu.headroom.
cpu.headroom is a mechanism for latency sensitive applications (or the
main workkload) to enforce latency requirements by reserving cpu cycle
headroom. Only the latency sensitive application can use the cpu cycle
headroom.

cpu controller has two existing knobs: cpu.weight(.nice) and cpu.max.
These two knobs are not sufficient to ensure latency of the main workload.
With interference from shared CPU and scheduling resources, assigning
very low cpu.weight to side workload cannot guarantee good latency of the
main workload. While cpu.max provides mechanism to throttle side workload,
it cannot react to changes in the load level of the main workload. For
example, on a system where the main workload consumes 50% to 70% of
overall CPU. It is necessary to adjust cpu.max for the side workload
according to the main workload traffice. When the main workload consumes
50%, the side workload should get cpu.max of 25%; when the main workload
consumes 70%, the side workload should only get cpu.max of 5%.
cpu.headroom, on the other hand, can react fast when load level changes.
In the example above, we can set cpu.headroom of the main workload to 25%.
Then, the side workload would honor this headroom, and adjust its cpu.max
accordingly.

For example, in a system with two cgroups: cgA with cpu.headroom of 30%
and cgB with cpu.headroom of 0%. 30% of the cpu cycles are reserved for
cgA. If cgA uses 50% of cpu cycles, cgB will run at most 20%. If cgA uses
more than 70% of cpu cycles, cgB will only run with a configurable small
bandwidth, to avoid starvation and deadlock. This configurable small
bandwidth is referred as tolerance.

cpu.headroom knob has two percentage numbers: headroom and tolerance.
headroom is how much idle cpu this cgroup would claim. Other cgroups with
lower headrooms are throttled to preserve this much idle cpu for this
cgroup. When the system is running into the headroom (idle < headroom),
cgroups with less than maximal headroom will be throttled down to use at
most tolerance % cpu. In other words, cgroup with maximal headroom could
tolerate other cgroups to run at tolerance % cpu.

Here is an example how the knob is used. To configure headroom of 40% and
tolerance of 10%:

    root@virt-test:/sys/fs/cgroup/t# echo 40 10 > cpu.headroom

To show the setting:

    root@virt-test:/sys/fs/cgroup/t# cat cpu.headroom
    40.00 10.00

It is possible to configure a cgroup with headroom of "max", which means
exemption from throttling due to other cgroups' cpu.headroom. The user can
also configure a cgroup with tolerance of "max", which means do not really
throttle other tasks.

Similar to cpu.max, the tolerance % cpu works hierarchically. For example,
in the configuration below, when the main workload runs into its headroom,
both side-A and side-B get at most 10% of runtime. However, their parent
"side-workload" also get at most 10% of runtime. Therefore, side-A and
side-B combined can consume at most 10% of CPU.

     side-workload       main-workload (tolerance 10%)
         /    \
    side-A    side-B

Typical cgroup configuration of cpu.headroom looks like:
 1. A main-workload slice with workload specific cpu.headroom (e.g.
 20.00 3.00), containing latency sensitive applications (e.g. web
 server);
 2. A side-workload slice with cpu.headroom of "0.00 max" (default
 setting), containing batch workloads that are insensitive to long
 latencies.

cpu.headroom achieves the throttling of side workload by computing a
"target idle percentage" number for side-workload. In the example above,
the side-workload slice has target idle percentage of 20%. If global idle
cpu is below 20%, side-workload slice can only run 3%.

With cgroup hierachies, children cgroups cannot have more cpu.headroom
than the parent cgroup. Parent cgroups without direct attached tasks will
only claim max headroom of children tasks.

Tasks attached to root_task_group is exempted from throttling.

For more details of how headroom and tolerance are used, please refer to
comments before cpu_headroom_update_config().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 kernel/sched/core.c  | 358 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c  |  12 ++
 kernel/sched/sched.h |  26 ++++
 3 files changed, 392 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b8f220860dc7..3cfd8e009ae6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6579,14 +6579,17 @@ const u64 min_cfs_quota_period = 1 * NSEC_PER_MSEC; /* 1ms */
 static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
 /* need get_online_cpus() and hold cfs_constraints_mutex */
-static void tg_switch_cfs_runtime(struct task_group *tg, u64 period, u64 quota)
+static void tg_switch_cfs_runtime(struct task_group *tg, u64 period, u64 quota,
+				  unsigned long target_idle,
+				  unsigned long min_runtime)
 {
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 	int runtime_enabled, runtime_was_enabled;
 	int i;
 
-	runtime_enabled = quota != RUNTIME_INF;
-	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
+	runtime_enabled = (quota != RUNTIME_INF) || (target_idle != 0);
+	runtime_was_enabled = (cfs_b->quota != RUNTIME_INF) ||
+		(cfs_b->target_idle != 0);
 	/*
 	 * If we need to toggle cfs_bandwidth_used, off->on must occur
 	 * before making related changes, and on->off must occur afterwards
@@ -6596,6 +6599,8 @@ static void tg_switch_cfs_runtime(struct task_group *tg, u64 period, u64 quota)
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
+	cfs_b->target_idle = target_idle;
+	cfs_b->min_runtime = min_runtime;
 
 	__refill_cfs_bandwidth_runtime(cfs_b);
 
@@ -6653,7 +6658,9 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	mutex_lock(&cfs_constraints_mutex);
 	ret = __cfs_schedulable(tg, period, quota);
 	if (!ret)
-		tg_switch_cfs_runtime(tg, period, quota);
+		tg_switch_cfs_runtime(tg, period, quota,
+				      tg->cfs_bandwidth.target_idle,
+				      tg->cfs_bandwidth.min_runtime);
 
 	mutex_unlock(&cfs_constraints_mutex);
 	put_online_cpus();
@@ -7042,6 +7049,340 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 		ret = tg_set_cfs_bandwidth(tg, period, quota);
 	return ret ?: nbytes;
 }
+
+/*
+ * Configure headroom, down pass, cap children's allowed value with
+ * parent's values:
+ *
+ *   allowed_headroom = min(configured_headroom,
+ *                              parent->allowed_headroom);
+ *   allowed_tolerance = max(configured_tolerance,
+ *                              parent->allowed_tolerance);
+ */
+static int cpu_headroom_configure_down(struct task_group *tg, void *data)
+{
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+	/* skip non-cgroup task_group and root cgroup */
+	if (!tg->css.cgroup || !tg->parent)
+		return 0;
+
+	cfs_b->allowed_headroom =
+		min_t(unsigned long, cfs_b->configured_headroom,
+		      tg->parent->cfs_bandwidth.allowed_headroom);
+	cfs_b->allowed_tolerance =
+		max_t(unsigned long, cfs_b->configured_tolerance,
+		      tg->parent->cfs_bandwidth.allowed_tolerance);
+	return 0;
+}
+
+/*
+ * Configure headroom, up pass, calculate effective values only for
+ * populated cgroups:
+ *   if (cgroup has tasks) {
+ *        effective_headroom = allowed_headroom
+ *        effective_tolerance = allowed_tolerance
+ *   } else {
+ *        effective_headroom =  max(children's effective_headroom)
+ *        effective_tolerance =  min(children's effective_tolerance)
+ *   }
+ */
+static int cpu_headroom_configure_up(struct task_group *tg, void *data)
+{
+	struct cfs_bandwidth *cfs_b_p;
+
+	/* skip non-cgroup task_group and root cgroup */
+	if (!tg->css.cgroup || !tg->parent)
+		return 0;
+
+	cfs_b_p = &tg->cfs_bandwidth;
+
+	if (tg->css.cgroup->nr_populated_csets > 0) {
+		cfs_b_p->effective_headroom = cfs_b_p->allowed_headroom;
+		cfs_b_p->effective_tolerance = cfs_b_p->allowed_tolerance;
+	} else {
+		struct task_group *child;
+
+		cfs_b_p->effective_headroom = 0;
+		cfs_b_p->effective_tolerance = CFS_BANDWIDTH_MAX_HEADROOM;
+
+		list_for_each_entry_rcu(child, &tg->children, siblings) {
+			struct cfs_bandwidth *cfs_b_c = &child->cfs_bandwidth;
+
+			cfs_b_p->effective_headroom =
+				max_t(unsigned long,
+				      cfs_b_p->effective_headroom,
+				      cfs_b_c->effective_headroom);
+
+			cfs_b_p->effective_tolerance =
+				min_t(unsigned long,
+				      cfs_b_p->effective_tolerance,
+				      cfs_b_c->effective_tolerance);
+		}
+	}
+
+	return 0;
+}
+
+/* update target_idle, down pass */
+static int cpu_headroom_target_idle_down(struct task_group *tg, void *data)
+{
+	struct cfs_bandwidth *cfs_b_root = &root_task_group.cfs_bandwidth;
+	unsigned long root_headroom = cfs_b_root->effective_headroom;
+	unsigned long root_tolerance = cfs_b_root->effective_tolerance;
+	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+	unsigned long target_idle;
+
+	/* skip non-cgroup task_group and root cgroup */
+	if (!tg->css.cgroup || !tg->parent)
+		return 0;
+
+	if (cfs_b->effective_headroom == CFS_BANDWIDTH_MAX_HEADROOM)
+		target_idle = 0;
+	else
+		target_idle = root_headroom -
+			tg->cfs_bandwidth.effective_headroom;
+
+	tg_switch_cfs_runtime(tg, cfs_b->period, cfs_b->quota,
+			      target_idle, root_tolerance);
+	return 0;
+}
+
+/*
+ * Calculate global max headroom and tolerance based on effective_* values
+ * of top task_groups. This global max headroom is stored in
+ * root_task_group.
+ *
+ * If new global max headroom is different from previous settings, update
+ * target_idle for all task_groups.
+ *
+ * Returns whether target_idle are updated.
+ */
+static bool cpu_headroom_calculate_global_headroom(void)
+{
+	struct cfs_bandwidth *cfs_b_root = &root_task_group.cfs_bandwidth;
+	unsigned long tolerance = CFS_BANDWIDTH_MAX_HEADROOM;
+	unsigned long headroom = 0;
+	bool update_target_idle;
+	struct task_group *tg;
+
+	list_for_each_entry_rcu(tg, &root_task_group.children, siblings) {
+		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+		/* skip "max", which means exempt from throttle */
+		if (cfs_b->effective_headroom == CFS_BANDWIDTH_MAX_HEADROOM)
+			continue;
+		if (cfs_b->effective_headroom > headroom) {
+			headroom = cfs_b->effective_headroom;
+			tolerance = cfs_b->effective_tolerance;
+		} else if (cfs_b->effective_headroom == headroom) {
+			if (cfs_b->effective_tolerance < tolerance)
+				tolerance = cfs_b->effective_tolerance;
+		}
+	}
+	update_target_idle =
+		(cfs_b_root->effective_headroom != headroom) ||
+		(cfs_b_root->effective_tolerance != tolerance);
+	cfs_b_root->effective_headroom = headroom;
+	cfs_b_root->effective_tolerance = tolerance;
+	if (update_target_idle)
+		walk_tg_tree(cpu_headroom_target_idle_down, tg_nop, NULL);
+
+	return update_target_idle;
+}
+
+/*
+ * Update allowed_*, effective_*, target_idle, and min_runtime. This is
+ * called when cpu.headroom configuration changes.
+ *
+ * headroom is how much idle cpu this tg would claim. Other tgs with lower
+ * headrooms are throttled to preserve this much idle cpu for this tg.
+ *
+ * When the system is running into the headroom (idle < headroom),
+ * tolerance is cpu _other_ tgs are throttled down to. In other words,
+ * this tg could tolerate other tgs to run tolerance % cpu.
+ *
+ * Note that, higher headroom and lower tolerance indicates more
+ * aggressive throttling of other task_groups. By default, each cgroup
+ * gets 0% headroom and max tolerance, which means no headroom. For
+ * headroom to be affective, the user has to configure both headroom and
+ * tolerance.
+ *
+ * Here is an example:
+ *    workload-slice: headroom = 30% tolerance = 5%
+ *    system-slice:   headroom =  0% tolerance = max
+ *
+ * In this configuration, system-slice will be throttled to try to give
+ * workload-slice 30%: if workload-slice uses 50% cpu, system-slice will
+ * use at most 20%. In case the system runs into the headroom, e.g.
+ * workload-slice uses 80% cpu, system-slice will use at most 5%
+ * (throttled).
+ *
+ * The throttling is achieved by assigning target_idle and min_runtime.
+ * In this example, the setting looks like:
+ *    workload-slice: headroom    = 30%  tolerance    = 5%
+ *                    target_idle =  0%  min_runtime = max
+ *    system-slice:   headroom    =  0%  tolerance    = max
+ *                    target_idle = 30%  min_runtime = 5%
+ *
+ * Note that, when target_idle is 0%, value of min_runtime is ignored.
+ * Also, when headroom is 0%, tolerance is ignored.
+ *
+ * headroom and tolerance follows the following hierarchical rules.
+ *   1. task_group may not use higher headroom than parent task_group;
+ *   2. task_group may not use lower tolerance than parent task_group;
+ *   3. headroom and tolerance oftask_groups without directly
+ *      attached tasks are not considered effective.
+ *
+ * To follow these rules, we expand each of headroom and tolerance into 3
+ * variables configured_, allowed_, and effective_.
+ *
+ * configured_headroom is directly assigned by user. As a child task_group
+ * may not have higher headroom than the parent, allowed_headroom is the
+ * minimum of configured_headroom and parent->allowed_headroom.
+ * effective_headroom only considers task_groups with directly attached
+ * tasks. For task_groups with directly attached tasks, effective_headroom
+ * is same as allowed_headroom; for task_groups without directly attached
+ * tasks, effective_headroom is the maximum of all child task_groups'
+ * effective headroom.
+ *
+ * tolerance follows similar logic as headroom, except that tolerance uses
+ * minimum for where headroom uses maximum, and vice versa.
+ *
+ * When headroom and tolerance are calculated for all task_groups, we pick
+ * the highest effective_headroom and corresponding effective_tolerance,
+ * namely, global_headroom and global_tolerance. Then all task_groups are
+ * assigned with target_idle and min_runtime as:
+ *     tg->target_idle =
+ *         global_headroom - tg->effective_headroom
+ *     tg->min_runtime = global_tolerance
+ *
+ * Note that, tg with effective_headroom equals to global_headroom has
+ * target_idle of 0%, which means no throttling.
+ *
+ * In summary, target_idle and min_runtime are calculated by the following
+ * steps:
+ *    1. Walk down tg tree and calculate allowed_* and effective_* values;
+ *    2. Walk up tg tree and calculate effective_* values;
+ *    3. Find global_headroom and global_tolerance;
+ *    4. If necessary, update target_idle and min_runtime.
+ *
+ * For changes of cpu.headroom configurations, we need all these steps;
+ * for changes in task_group has_task, we only need step 2 to 4.
+ */
+static void cpu_headroom_update_config(struct task_group *tg,
+				       bool config_change)
+{
+	struct task_group *orig_tg = tg;
+
+	get_online_cpus();
+	mutex_lock(&cfs_constraints_mutex);
+	rcu_read_lock();
+
+	/*
+	 * If this is configuration change, update allowed_* and
+	 * effective_*values from this tg down
+	 */
+	if (config_change)
+		walk_tg_tree_from(tg, cpu_headroom_configure_down,
+				  cpu_headroom_configure_up, NULL);
+
+	/* Update effective_* values from this tg up */
+	while (tg) {
+		cpu_headroom_configure_up(tg, NULL);
+		tg = tg->parent;
+	}
+
+	/*
+	 * Update global headroom, and (if necessary) target_idle.
+	 *
+	 * If target_idle is not updated for all task_groups, at least
+	 * update it from this task_group down.
+	 */
+	if (!cpu_headroom_calculate_global_headroom())
+		walk_tg_tree_from(orig_tg, cpu_headroom_target_idle_down,
+				  tg_nop, NULL);
+
+	rcu_read_unlock();
+	mutex_unlock(&cfs_constraints_mutex);
+	put_online_cpus();
+}
+
+void cfs_bandwidth_has_tasks_changed_work(struct work_struct *work)
+{
+	struct cfs_bandwidth *cfs_b = container_of(work, struct cfs_bandwidth,
+						   has_tasks_changed_work);
+	struct task_group *tg = container_of(cfs_b, struct task_group,
+					     cfs_bandwidth);
+
+	cpu_headroom_update_config(tg, false);
+}
+
+/*
+ * For has_task updates, no change to allowed_* values. Only update
+ * effective_* values and calculate global headroom
+ */
+static void
+cpu_cgroup_css_has_tasks_changed(struct cgroup_subsys_state *css,
+				 bool has_tasks)
+{
+	struct task_group *tg = css_tg(css);
+
+	/*
+	 * We held css_set_lock here, so we cannot call
+	 * cpu_headroom_update_config(), which calls mutex_lock() and
+	 * get_online_cpus(). Instead, call cpu_headroom_update_config()
+	 * in an async work.
+	 */
+	schedule_work(&tg->cfs_bandwidth.has_tasks_changed_work);
+}
+
+static int cpu_headroom_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+	unsigned long val;
+
+	val = tg->cfs_bandwidth.configured_headroom;
+
+	if (val == CFS_BANDWIDTH_MAX_HEADROOM)
+		seq_printf(sf, "max ");
+	else
+		seq_printf(sf, "%lu.%02lu ", LOAD_INT(val), LOAD_FRAC(val));
+
+	val = tg->cfs_bandwidth.configured_tolerance;
+
+	if (val == CFS_BANDWIDTH_MAX_HEADROOM)
+		seq_printf(sf, "max\n");
+	else
+		seq_printf(sf, "%lu.%02lu\n", LOAD_INT(val), LOAD_FRAC(val));
+	return 0;
+}
+
+static ssize_t cpu_headroom_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
+{
+	long headroom, tolerance;
+	struct task_group *tg = css_tg(of_css(of));
+	char tok_a[7], tok_b[7]; /* longest valid input is 100.00 */
+
+	if (sscanf(buf, "%6s %6s", tok_a, tok_b) != 2)
+		return -EINVAL;
+
+	headroom = cgroup_parse_percentage(tok_a, FIXED_1);
+	if (headroom < 0)
+		return -EINVAL;
+
+	tolerance = cgroup_parse_percentage(tok_b, FIXED_1);
+	if (tolerance < 0)
+		return -EINVAL;
+
+	tg->cfs_bandwidth.configured_headroom = headroom;
+	tg->cfs_bandwidth.configured_tolerance = tolerance;
+
+	cpu_headroom_update_config(tg, true);
+
+	return nbytes;
+}
 #endif
 
 static struct cftype cpu_files[] = {
@@ -7066,6 +7407,12 @@ static struct cftype cpu_files[] = {
 		.seq_show = cpu_max_show,
 		.write = cpu_max_write,
 	},
+	{
+		.name = "headroom",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cpu_headroom_show,
+		.write = cpu_headroom_write,
+	},
 #endif
 	{ }	/* terminate */
 };
@@ -7079,6 +7426,9 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
+#ifdef CONFIG_CFS_BANDWIDTH
+	.css_has_tasks_changed = cpu_cgroup_css_has_tasks_changed,
+#endif
 	.legacy_cftypes	= cpu_legacy_files,
 	.dfl_cftypes	= cpu_files,
 	.early_init	= true,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea74d43924b2..65aa9d3b665f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4915,6 +4915,18 @@ void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	cfs_b->quota = RUNTIME_INF;
 	cfs_b->period = ns_to_ktime(default_cfs_period());
 
+	if (cfs_b == &root_task_group.cfs_bandwidth) {
+		/* allowed_* values for root tg */
+		cfs_b->allowed_headroom = CFS_BANDWIDTH_MAX_HEADROOM;
+		cfs_b->allowed_tolerance = 0;
+	} else {
+		/* default configured_* values for other tg */
+		cfs_b->configured_headroom = 0;
+		cfs_b->configured_tolerance = CFS_BANDWIDTH_MAX_HEADROOM;
+	}
+	INIT_WORK(&cfs_b->has_tasks_changed_work,
+		  cfs_bandwidth_has_tasks_changed_work);
+
 	INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
 	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
 	cfs_b->period_timer.function = sched_cfs_period_timer;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index efa686eeff26..9309bf05ff0c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -154,6 +154,8 @@ static inline void cpu_load_update_active(struct rq *this_rq) { }
  */
 #define RUNTIME_INF		((u64)~0ULL)
 
+#define CFS_BANDWIDTH_MAX_HEADROOM (100UL << FSHIFT)	/* 100% */
+
 static inline int idle_policy(int policy)
 {
 	return policy == SCHED_IDLE;
@@ -334,6 +336,10 @@ struct rt_rq;
 
 extern struct list_head task_groups;
 
+#ifdef CONFIG_CFS_BANDWIDTH
+extern void cfs_bandwidth_has_tasks_changed_work(struct work_struct *work);
+#endif
+
 struct cfs_bandwidth {
 #ifdef CONFIG_CFS_BANDWIDTH
 	raw_spinlock_t		lock;
@@ -344,6 +350,26 @@ struct cfs_bandwidth {
 	u64			runtime_expires;
 	int			expires_seq;
 
+	/*
+	 * The following values are all fixed-point. For more information
+	 * about these values, please refer to comments before
+	 * cpu_headroom_update_config().
+	 */
+	/* values configured by user */
+	unsigned long		configured_headroom;
+	unsigned long		configured_tolerance;
+	/* values capped by configuration of parent group */
+	unsigned long		allowed_headroom;
+	unsigned long		allowed_tolerance;
+	/* effective values for cgroups with tasks */
+	unsigned long		effective_headroom;
+	unsigned long		effective_tolerance;
+	/* values calculated for runtime based throttling */
+	unsigned long		target_idle;
+	unsigned long		min_runtime;
+	/* work_struct to adjust settings asynchronously */
+	struct work_struct	has_tasks_changed_work;
+
 	short			idle;
 	short			period_active;
 	struct hrtimer		period_timer;
-- 
2.17.1

