From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [RFC PATCH 3/3] cgroup: Add new cacheqos cgroup subsys to support Cache QoS Monitoring
Date: Thu, 26 Dec 2013 13:34:39 -0800
Message-ID: <1388093679-26952-4-git-send-email-peter.p.waskiewicz.jr@intel.com>
References: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388093679-26952-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, x86@kernel.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com

This patch adds a new cgroup subsystem, named cacheqos.  This cgroup
controller is intended to manage task groups to track cache occupancy
and usage of a CPU.

This patch also adds the scheduler functions to the Intel uncore events
to implement Cache QoS Monitoring.  This needs to be added along with
the cgroup subsystem since events from the cgroup trigger when a task
needs to be tracked on the underlying CPU.

The patch also adds the Kconfig option for enabling/disabling the
CGROUP_CACHEQOS subsystem.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  52 ++++
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/perf_event.h                    |  15 +
 init/Kconfig                                  |   6 +
 kernel/sched/core.c                           | 432 ++++++++++++++++++++++++++
 kernel/sched/sched.h                          |  55 ++++
 6 files changed, 564 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..6f06d68 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1633,6 +1633,58 @@ static struct intel_uncore_type *snb_msr_uncores[] = {
 };
 /* end of Sandy Bridge uncore support */
 
+#ifdef CONFIG_CGROUP_CACHEQOS
+
+/* needed for the cacheqos cgroup structs */
+#include "../../../kernel/sched/sched.h"
+
+void cacheqos_map_schedule_out(void)
+{
+	/*
+	 * cacheqos_map_schedule_in() will set the MSR correctly, but
+	 * clearing the MSR here will prevent occupancy counts against this
+	 * task during the context switch.  In other words, this gives a
+	 * "better" representation of what's happening in the cache.
+	 */
+	wrmsrl(IA32_PQR_ASSOC, 0);
+}
+
+void cacheqos_map_schedule_in(struct cacheqos *cq)
+{
+	u64 map;
+
+	map = cq->rmid & IA32_RMID_PQR_MASK;
+	wrmsrl(IA32_PQR_ASSOC, map);
+}
+
+void cacheqos_read(void *arg)
+{
+	struct cacheqos *cq = arg;
+	u64 config;
+	u64 result = 0;
+	int cpu, node;
+
+	cpu = smp_processor_id();
+	node = cpu_to_node(cpu);
+
+	config = cq->rmid;
+	config = ((config & IA32_RMID_PQR_MASK) <<
+		   IA32_QM_EVTSEL_RMID_POSITION) |
+		   IA32_QM_EVTSEL_EVTID_READ_OCC;
+	wrmsrl(IA32_QM_EVTSEL, config);
+	rdmsrl(IA32_QM_CTR, result);
+
+	/* place results in sys_wide_info area for recovery */
+	if (result & IA32_QM_CTR_ERR)
+		result = -1;
+	else
+		result &= ~IA32_QM_CTR_ERR;
+
+	cq->subsys_wide_info->node_results[node] =
+		result * cq->subsys_wide_info->cache_occ_scale;
+}
+#endif /* CONFIG_CGROUP_CACHEQOS */
+
 /* Nehalem uncore support */
 static void nhm_uncore_msr_disable_box(struct intel_uncore_box *box)
 {
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index b613ffd..14b97e4 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -50,6 +50,10 @@ SUBSYS(net_prio)
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_HUGETLB)
 SUBSYS(hugetlb)
 #endif
+
+#if IS_SUBSYS_ENABLED(CONFIG_CGROUP_CACHEQOS)
+SUBSYS(cacheqos)
+#endif
 /*
  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..18a9c43 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -670,12 +670,22 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 }
 
 extern struct static_key_deferred perf_sched_events;
+#ifdef CONFIG_CGROUP_CACHEQOS
+extern int cacheqos_cgroup_is_active;
+inline void cacheqos_sched_out(void);
+inline void cacheqos_sched_in(struct task_struct *task);
+#endif /* CONFIG_CGROUP_CACHEQOS */
 
 static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
 	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_in(prev, task);
+
+#ifdef CONFIG_CGROUP_CACHEQOS
+	if (cacheqos_cgroup_is_active)
+		cacheqos_sched_in(task);
+#endif /* CONFIG_CGROUP_CACHEQOS */
 }
 
 static inline void perf_event_task_sched_out(struct task_struct *prev,
@@ -685,6 +695,11 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 
 	if (static_key_false(&perf_sched_events.key))
 		__perf_event_task_sched_out(prev, next);
+
+#ifdef CONFIG_CGROUP_CACHEQOS
+	if (cacheqos_cgroup_is_active)
+		cacheqos_sched_out();
+#endif /* CONFIG_CGROUP_CACHEQOS */
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
diff --git a/init/Kconfig b/init/Kconfig
index 4e5d96a..5dc35f9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -905,6 +905,12 @@ config PROC_PID_CPUSET
 	depends on CPUSETS
 	default y
 
+config CGROUP_CACHEQOS
+	bool "Simple Cache QoS Monitoring cgroup subsystem"
+	help
+	  Provides a simple Resource Controller for monitoring the
+	  total cache occupancy by the tasks in a cgroup.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	help
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a4..da49c42 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7354,6 +7354,438 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CGROUP_CACHEQOS
+
+/* Cache QoS code for task cgroups. */
+static struct cftype cacheqos_files[];
+struct cacheqos_subsys_wide_info cacheqos_wide_info = {{0},};
+struct cacheqos root_cacheqos_group;
+int cacheqos_cgroup_is_active = 0;
+
+/*
+ * This mutex guards the subsys_wide_info unused and inuse lists as well as
+ * the node results array.
+ */
+static DEFINE_MUTEX(cacheqos_mutex);
+
+extern void cacheqos_map_schedule_out(void);
+extern void cacheqos_map_schedule_in(struct cacheqos *);
+extern void cacheqos_read(void *);
+
+/* return cacheqos feature flags and assign constants */
+static __init int cacheqos_late_init(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct rmid_list_element *elem;
+	int i;
+
+	mutex_lock(&cacheqos_mutex);
+
+	cacheqos_wide_info.cache_max_rmid = c->x86_cache_max_rmid;
+	cacheqos_wide_info.cache_occ_scale = c->x86_cache_occ_scale;
+	cacheqos_wide_info.cache_size = c->x86_cache_size;
+
+	/* Populate the unused rmid list with all rmids. */
+	INIT_LIST_HEAD(&cacheqos_wide_info.rmid_unused_fifo);
+	INIT_LIST_HEAD(&cacheqos_wide_info.rmid_inuse_list);
+	elem = kzalloc(sizeof(*elem), GFP_KERNEL);
+	if (!elem)
+		return -ENOMEM;
+
+	elem->rmid = 0;
+	list_add_tail(&elem->list, &cacheqos_wide_info.rmid_inuse_list);
+	for (i = 1; i < cacheqos_wide_info.cache_max_rmid; i++) {
+		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
+		if (!elem)
+			return -ENOMEM;
+
+		elem->rmid = i;
+		INIT_LIST_HEAD(&elem->list);
+		list_add_tail(&elem->list,
+			      &cacheqos_wide_info.rmid_unused_fifo);
+	}
+
+	mutex_unlock(&cacheqos_mutex);
+	return 0;
+}
+late_initcall(cacheqos_late_init);
+
+inline void cacheqos_sched_out(void)
+{
+	/*
+	 * Assumption is that this thread is running on the logical processor
+	 * from which the task is being scheduled out.
+	 *
+	 * As the task is scheduled out mapping goes back to default map.
+	 */
+	cacheqos_map_schedule_out();
+}
+
+inline void cacheqos_sched_in(struct task_struct *task)
+{
+	struct cacheqos *cq;
+	/*
+	 * Assumption is that this thread is running on the logical processor
+	 * of which this task is being scheduled onto.
+	 *
+	 * As the task is scheduled in, the cgroup's rmid is loaded
+	 */
+	cq = task_cacheqos(task);
+	cacheqos_map_schedule_in(cq);
+}
+
+static void cacheqos_adjust_children_rmid(struct cacheqos *cq)
+{
+	struct cgroup_subsys_state *css, *pos;
+	struct cacheqos *p_cq, *pos_cq;
+
+	css = &cq->css;
+	rcu_read_lock();
+
+	css_for_each_descendant_pre(pos, css) {
+		pos_cq = css_cacheqos(pos);
+		if (pos_cq->monitor_cache == 0) {
+			/* monitoring is disabled, so use the parent's RMID */
+			p_cq = parent_cacheqos(pos_cq);
+			spin_lock_irq(&pos_cq->lock);
+			pos_cq->rmid = p_cq->rmid;
+			spin_unlock_irq(&pos_cq->lock);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static int cacheqos_move_rmid_to_unused_list(struct cacheqos *cq)
+{
+	struct rmid_list_element *elem;
+
+	/*
+	 * Assumes only called when cq->rmid is valid (ie, it is on the
+	 * inuse list) and cacheqos_mutex is held.
+	 */
+	lockdep_assert_held(&cacheqos_mutex);
+	list_for_each_entry(elem, &cq->subsys_wide_info->rmid_inuse_list,
+			    list) {
+		if (cq->rmid == elem->rmid) {
+			/* Move rmid from inuse to unused list */
+			list_del_init(&elem->list);
+			list_add_tail(&elem->list,
+				&cq->subsys_wide_info->rmid_unused_fifo);
+			goto quick_exit;
+		}
+	}
+	return -ELIBBAD;
+
+quick_exit:
+	return 0;
+}
+
+static int cacheqos_deallocate_rmid(struct cacheqos *cq)
+{
+	struct cacheqos *cq_parent = parent_cacheqos(cq);
+	int err;
+
+	mutex_lock(&cacheqos_mutex);
+	err = cacheqos_move_rmid_to_unused_list(cq);
+	if (err)
+		return err;
+	/* assign parent's rmid to cgroup */
+	cq->monitor_cache = 0;
+	cq->rmid = cq_parent->rmid;
+
+	/* Check for children using this cgroup's rmid, iterate */
+	cacheqos_adjust_children_rmid(cq);
+
+	mutex_unlock(&cacheqos_mutex);
+	return 0;
+}
+
+static int cacheqos_allocate_rmid(struct cacheqos *cq)
+{
+	struct rmid_list_element *elem;
+	struct list_head *item;
+
+	mutex_lock(&cacheqos_mutex);
+
+	if (list_empty(&cq->subsys_wide_info->rmid_unused_fifo)) {
+		mutex_unlock(&cacheqos_mutex);
+		return -EAGAIN;
+	}
+
+	/* Move rmid from unused to inuse list */
+	item = cq->subsys_wide_info->rmid_unused_fifo.next;
+	list_del_init(item);
+	list_add_tail(item, &cq->subsys_wide_info->rmid_inuse_list);
+
+	/* assign rmid to cgroup */
+	elem = list_entry(item, struct rmid_list_element, list);
+	cq->rmid = elem->rmid;
+	cq->monitor_cache = 1;
+
+	/* Check for children using this cgroup's rmid, iterate */
+	cacheqos_adjust_children_rmid(cq);
+
+	mutex_unlock(&cacheqos_mutex);
+
+	return 0;
+}
+
+/* create a new cacheqos cgroup */
+static struct cgroup_subsys_state *
+cacheqos_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct cacheqos *parent = css_cacheqos(parent_css);
+	struct cacheqos *cq;
+
+	if (!parent) {
+		/* enable monitoring for root w/ rmid = 0 */
+		root_cacheqos_group.monitor_cache = 1;
+		root_cacheqos_group.rmid = 0;
+		root_cacheqos_group.subsys_wide_info = &cacheqos_wide_info;
+		return &root_cacheqos_group.css;
+	}
+
+	cq = kzalloc(sizeof(struct cacheqos), GFP_KERNEL);
+	if (!cq)
+		goto out;
+
+	cq->subsys_wide_info = NULL;
+
+	cq->cgrp = parent_css->cgroup;
+	cq->monitor_cache = 0;		/* disabled i.e., use parent's RMID */
+	cq->rmid = parent->rmid;	/* Start by using parent's RMID*/
+	cq->subsys_wide_info = &cacheqos_wide_info;
+	return &cq->css;
+
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+/* destroy an existing cacheqos task group */
+static void cacheqos_css_free(struct cgroup_subsys_state *css)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+
+	if (cq->monitor_cache) {
+		mutex_lock(&cacheqos_mutex);
+		cacheqos_move_rmid_to_unused_list(cq);
+		mutex_unlock(&cacheqos_mutex);
+	}
+	kfree(cq);
+}
+
+/* return task group's monitoring state */
+static u64 cacheqos_monitor_read(struct cgroup_subsys_state *css,
+				 struct cftype *cft)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+
+	return cq->monitor_cache;
+}
+
+/* set the task group's monitoring state */
+static int cacheqos_monitor_write(struct cgroup_subsys_state *css,
+				  struct cftype *cftype, u64 enable)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+	int err = 0;
+
+	if (enable != 0 && enable != 1) {
+		err = -EINVAL;
+		goto monitor_out;
+	}
+
+	if (enable == cq->monitor_cache)
+		goto monitor_out;
+
+	if (cq->monitor_cache)
+		err = cacheqos_deallocate_rmid(cq);
+	else
+		err = cacheqos_allocate_rmid(cq);
+
+monitor_out:
+	return err;
+}
+
+static int cacheqos_get_occupancy_data(struct cacheqos *cq)
+{
+	unsigned int cpu;
+	unsigned int node;
+	const struct cpumask *node_cpus;
+	int err = 0;
+
+	/* Assumes cacheqos_mutex is held */
+	lockdep_assert_held(&cacheqos_mutex);
+	for_each_node_with_cpus(node) {
+		node_cpus = cpumask_of_node(node);
+		cpu = any_online_cpu(*node_cpus);
+		err = smp_call_function_single(cpu, cacheqos_read, cq, 1);
+
+		if (err) {
+			break;
+		} else if (cq->subsys_wide_info->node_results[node] == -1) {
+			err = -EPROTO;
+			break;
+		}
+	}
+	return err;
+}
+
+/* return total system LLC occupancy in bytes of a task group */
+static int cacheqos_occupancy_read(struct cgroup_subsys_state *css,
+				   struct cftype *cft, struct seq_file *m)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+	u64 total_occupancy = 0;
+	int err, node;
+
+	mutex_lock(&cacheqos_mutex);
+	err = cacheqos_get_occupancy_data(cq);
+	if (err) {
+		mutex_unlock(&cacheqos_mutex);
+		return err;
+	}
+
+	for_each_node_with_cpus(node)
+		total_occupancy += cq->subsys_wide_info->node_results[node];
+
+	mutex_unlock(&cacheqos_mutex);
+
+	seq_printf(m, "%llu\n", total_occupancy);
+	return 0;
+}
+
+/* return display each LLC's occupancy in bytes of a task group */
+static int
+cacheqos_occupancy_persocket_seq_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft, struct seq_file *m)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+	int err, node;
+
+	mutex_lock(&cacheqos_mutex);
+	err = cacheqos_get_occupancy_data(cq);
+	if (err) {
+		mutex_unlock(&cacheqos_mutex);
+		return err;
+	}
+
+	for_each_node_with_cpus(node) {
+		seq_printf(m, "%llu\n",
+			   cq->subsys_wide_info->node_results[node]);
+	}
+
+	mutex_unlock(&cacheqos_mutex);
+
+	return 0;
+}
+
+/* return total system LLC occupancy as a %of system LLC for the task group */
+static int cacheqos_occupancy_percent_read(struct cgroup_subsys_state *css,
+					   struct cftype *cft,
+					   struct seq_file *m)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+	u64 total_occupancy = 0;
+	int err, node;
+	int node_cnt = 0;
+	int parts_of_100, parts_of_10000;
+	int cache_size;
+
+	mutex_lock(&cacheqos_mutex);
+	err = cacheqos_get_occupancy_data(cq);
+	if (err) {
+		mutex_unlock(&cacheqos_mutex);
+		return err;
+	}
+
+	for_each_node_with_cpus(node) {
+		++node_cnt;
+		total_occupancy += cq->subsys_wide_info->node_results[node];
+	}
+
+	mutex_unlock(&cacheqos_mutex);
+
+	cache_size = cq->subsys_wide_info->cache_size * node_cnt;
+	parts_of_100 = (total_occupancy * 100) / (cache_size * 1024);
+	parts_of_10000 = (total_occupancy * 10000) / (cache_size * 1024) -
+				parts_of_100 * 100;
+	seq_printf(m, "%d.%02d\n", parts_of_100, parts_of_10000);
+
+	return 0;
+}
+
+/* return display each LLC's % occupancy of the socket's LLC for task group */
+static int
+cacheqos_occupancy_percent_persocket_seq_read(struct cgroup_subsys_state *css,
+					      struct cftype *cft,
+					      struct seq_file *m)
+{
+	struct cacheqos *cq = css_cacheqos(css);
+	u64 total_occupancy;
+	int err, node;
+	int cache_size;
+	int parts_of_100, parts_of_10000;
+
+	mutex_lock(&cacheqos_mutex);
+	err = cacheqos_get_occupancy_data(cq);
+	if (err) {
+		mutex_unlock(&cacheqos_mutex);
+		return err;
+	}
+
+	cache_size = cq->subsys_wide_info->cache_size;
+	for_each_node_with_cpus(node) {
+		total_occupancy = cq->subsys_wide_info->node_results[node];
+		parts_of_100 = (total_occupancy * 100) / (cache_size * 1024);
+		parts_of_10000 = (total_occupancy * 10000) /
+				 (cache_size * 1024) - parts_of_100 * 100;
+
+		seq_printf(m, "%d.%02d\n", parts_of_100, parts_of_10000);
+	}
+
+	mutex_unlock(&cacheqos_mutex);
+
+	return 0;
+}
+
+static struct cftype cacheqos_files[] = {
+	{
+		.name = "monitor_cache",
+		.read_u64 = cacheqos_monitor_read,
+		.write_u64 = cacheqos_monitor_write,
+		.mode = 0666,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "occupancy_persocket",
+		.read_seq_string = cacheqos_occupancy_persocket_seq_read,
+	},
+	{
+		.name = "occupancy",
+		.read_seq_string = cacheqos_occupancy_read,
+	},
+	{
+		.name = "occupancy_percent_persocket",
+		.read_seq_string = cacheqos_occupancy_percent_persocket_seq_read,
+	},
+	{
+		.name = "occupancy_percent",
+		.read_seq_string = cacheqos_occupancy_percent_read,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys cacheqos_subsys = {
+	.name			= "cacheqos",
+	.css_alloc		= cacheqos_css_alloc,
+	.css_free		= cacheqos_css_free,
+	.subsys_id		= cacheqos_subsys_id,
+	.base_cftypes		= cacheqos_files,
+};
+
+#endif	/* CONFIG_CGROUP_CACHEQOS */
+
 void dump_cpu_task(int cpu)
 {
 	pr_info("Task dump for CPU %d:\n", cpu);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b2..f6f463f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -246,6 +246,61 @@ struct cfs_bandwidth { };
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_CGROUP_CACHEQOS
+
+#include <linux/cgroup.h>
+
+struct rmid_list_element {
+	int rmid;
+	struct list_head list;
+};
+
+struct cacheqos_subsys_wide_info {
+	struct list_head rmid_unused_fifo;
+	struct list_head rmid_inuse_list;
+	int cache_max_rmid;
+	int cache_occ_scale;
+	int cache_size;
+	u64 node_results[MAX_NUMNODES];
+};
+
+struct cacheqos {
+	struct cgroup_subsys_state css;
+	struct cacheqos_subsys_wide_info *subsys_wide_info;
+	struct cgroup *cgrp;
+	u64 monitor_cache; /* 0/1 (disable (parent RMID)/enable (fresh RMID))*/
+	/*
+	 * This lock is use for walking this cgroups children cgroups
+	 * and updating their rmid values based on changes to this cgroup's
+	 * monitor_cache value. If monitor_cache is 1 then this cgroup has its
+	 * own rmid value but if 0 it will use its parent's rmid value.
+	 */
+	spinlock_t lock;
+	u32 rmid;
+};
+
+extern struct cgroup_subsys cacheqos_subsys;
+extern struct cacheqos root_cacheqos;
+
+/* return cacheqos group corresponding to this container */
+static inline struct cacheqos *css_cacheqos(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct cacheqos, css) : NULL;
+}
+
+/* return cacheqos group to which this task belongs */
+static inline struct cacheqos *task_cacheqos(struct task_struct *task)
+{
+	return css_cacheqos(task_css(task, cacheqos_subsys_id));
+}
+
+static inline struct cacheqos *parent_cacheqos(struct cacheqos *cacheqos)
+{
+	return css_cacheqos(css_parent(&cacheqos->css));
+}
+
+#endif /* CONFIG_CGROUP_CACHEQOS */
+
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-- 
1.8.3.1
