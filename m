From: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCHv2] cgroup: introduce dynamic protection for memcg
Date: Mon, 4 Apr 2022 10:43:13 +0800
Message-ID: <1649040193-10073-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

For some kind of memcg, the usage is varies greatly from scenarios. Such as
multimedia app could have the usage range from 50MB to 500MB, which generated
by loading an special algorithm into its virtual address space and make it hard
to protect the expanded usage without userspace's interaction. Furthermore, fixed
memory.low is a little bit against its role of soft protection as it will response
any system's memory pressure in same way.

Taking all above into consideration, we introduce a kind of dynamic protection
based on group's watermark and system's memory pressure in this patch. Our aims are:
1. dynamic protection with no fixed setting
2. proper protection value on memory.current
3. time based decay protection
4. memory pressue related protection

The basic concept could be descripted as bellowing, where we take group->watermark
as a representative of usage
		group->memory.low = decayed_watermark * decay_factor
		decayed_watermark = group->watermark * func_wm_decay(time)
		decay_factor = psi_system[PSI_MEM][time]

func_wm_decay could be deemed as a linear decay funcion that will decay 1/2 in
68s(36bit).If we take 2048 as "1", it could be descripted as:
		decayed_watermark = time >> (group->wm_dec_factor - 10)
		decayed_watermark = new_usage(if new_usage > decayed_watermark)

decay_factor is as simple as a table lookingup and compose the final value by
weight of some and full as
		some = psi_system.avg[PSI_MEM * 2][time]
		full = psi_system.avg[PSI_MEM * 2 + 1][time]
		decay_factor = some  + full * 2

We simply test above change by comparing it with current design on a v5.4 based
system in 3GB RAM in bellowing steps, via which we can find that fixed
memory.low have the system experience high memory pressure with holding too
much memory.

1. setting up the topology seperatly as [1]
2. place a memory cost process into B and have it consume 1GB memory from userspace.
3. generating global memory pressure via mlock 1GB memory.
4. watching B's memory.current and PSI_MEM.
5. repeat 3,4 twice.

[1]. setting fixed low=500MB; low=600MB; wm_decay_factor=36(68s decay 1/2)
      A(low=500MB)
     /
    B(low=500MB)

What we observed are:

            PSI_MEM, usage          PSI_MEM,usage	PSI_MEM,usage
            (Mlock 1GB)             (Mlock 2GB)		(stable)
low=600MB   s=23 f=17 u=720/600MB   s=91 f=48 u=202MB   s=68 f=32 u=106MB
low=500MB   s=22 f=13 u=660/530MB   s=88 f=50 u=156MB   s=30 f=20 u=120MB
patch       s=23 f=12 u=692/470MB   s=40 f=23 u=67MB    s=21 f=18 u=45MB

Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
---
changes for v2:introduce opt-in logic and update test data on comments
---
---
 include/linux/memcontrol.h   | 52 +++++++++++++++++++++++++++++++
 include/linux/page_counter.h |  4 +++
 include/linux/psi.h          |  3 ++
 kernel/sched/psi.c           | 18 +++++++++++
 mm/memcontrol.c              | 74 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c            |  4 +++
 6 files changed, 155 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c5c403..f18a700 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -21,6 +21,9 @@
 #include <linux/vmstat.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
+#include <linux/sched/loadavg.h>
+#include <linux/sched/clock.h>
+#include <linux/psi.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -28,6 +31,8 @@
 struct mm_struct;
 struct kmem_cache;
 
+#define MEMCG_INTERVAL	(2*HZ+1)	/* 2 sec intervals */
+
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
@@ -340,6 +345,12 @@ struct mem_cgroup {
 	struct deferred_split deferred_split_queue;
 #endif
 
+	u64 wm_decay_fact;
+	u64 some_prop;
+	u64 full_prop;
+	u64 avg_next_update;
+	u64 avg_last_update;
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
@@ -608,6 +619,47 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+/*
+ * calculate memory.low based on the historic watermark and memory pressure
+ */
+static inline void calc_protected_low(struct mem_cgroup *group)
+{
+	u64 now, decay_factor;
+	u64 decayed_watermark;
+	u64 delta_time;
+
+	now = sched_clock();
+
+	if (!group->avg_next_update) {
+		group->avg_next_update = now + jiffies_to_nsecs(5*HZ);
+		return;
+	}
+
+	if (time_before((unsigned long)now, (unsigned long)group->avg_next_update))
+		return;
+
+	delta_time = group->avg_last_update ? now - group->avg_last_update : 0;
+	/*
+	 * we take 2048 as "1" and 68s decay 1/2(36bit) by default
+	 * decay_factor = 1024 * delta_time / 68s(0x1000000000)
+	 * 0.5(1024)/68s = decay_factor/delta_time ==> decay_factor = delta_time >> 26
+	 */
+	decay_factor = (2048 - min(2048ULL, delta_time >> (group->wm_decay_fact - 10)));
+	decayed_watermark = group->memory.decayed_watermark * decay_factor / 2048;
+	/* decay_factor: based on average memory pressure over elapsed time */
+	decay_factor = psi_mem_get(delta_time);
+	group->memory.low = decayed_watermark * (100 - decay_factor) / 100;
+
+	/*
+	 * avg_next_update: expected expire time according to current status
+	 */
+	group->memory.decayed_watermark = decayed_watermark;
+	group->avg_last_update = now;
+	group->avg_next_update = now + jiffies_to_nsecs(2*HZ);
+
+	return;
+}
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 6795913..2720eb9f 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -25,8 +25,12 @@ struct page_counter {
 
 	/* legacy */
 	unsigned long watermark;
+	unsigned long decayed_watermark;
 	unsigned long failcnt;
 
+	/* proportional protection */
+	unsigned long min_prop;
+	unsigned long low_prop;
 	/*
 	 * 'parent' is placed here to be far from 'usage' to reduce
 	 * cache false sharing, as 'usage' is written mostly while
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 65eb147..b6e468a 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -25,6 +25,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 
+unsigned long psi_mem_get(unsigned long time);
+
 #ifdef CONFIG_CGROUPS
 int psi_cgroup_alloc(struct cgroup *cgrp);
 void psi_cgroup_free(struct cgroup *cgrp);
@@ -45,6 +47,7 @@ static inline void psi_init(void) {}
 static inline void psi_memstall_enter(unsigned long *flags) {}
 static inline void psi_memstall_leave(unsigned long *flags) {}
 
+static unsigned long psi_mem_get(unsigned long time) {}
 #ifdef CONFIG_CGROUPS
 static inline int psi_cgroup_alloc(struct cgroup *cgrp)
 {
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index dd80bd2..e6788c7 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -291,6 +291,24 @@ static void get_recent_times(struct psi_group *group, int cpu,
 	}
 }
 
+unsigned long psi_mem_get(unsigned long time_ns)
+{
+	unsigned long time_sec = time_ns / (1000 * 1000 * 1000);
+	unsigned long some, full;
+	if (time_sec < 10) {
+		some = LOAD_INT(psi_system.avg[PSI_MEM * 2][0]);
+		full = LOAD_INT(psi_system.avg[PSI_MEM * 2 + 1][0]);
+	} else if (time_sec < 60) {
+		some = LOAD_INT(psi_system.avg[PSI_MEM * 2][1]);
+		full = LOAD_INT(psi_system.avg[PSI_MEM * 2 + 1][1]);
+	} else {
+		some = LOAD_INT(psi_system.avg[PSI_MEM * 2][2]);
+		full = LOAD_INT(psi_system.avg[PSI_MEM * 2 + 1][2]);
+	}
+
+	return max(100UL, some + full * 2);
+}
+
 static void calc_avgs(unsigned long avg[3], int missed_periods,
 		      u64 time, u64 period)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 508bcea..f177d4e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5188,6 +5188,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+	memcg->wm_decay_fact = 0;
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
@@ -6410,6 +6411,57 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_wm_df_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%llu\n", (u64)READ_ONCE(mem_cgroup_from_seq(m)->wm_decay_fact));
+	return 0;
+}
+
+static ssize_t memory_wm_df_write(struct kernfs_open_file *of,
+		char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	buf = strstrip(buf);
+	memcg->wm_decay_fact = simple_strtoull(buf, NULL, 10);
+
+	return nbytes;
+}
+
+static int memory_some_prop_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%llu\n", (u64)READ_ONCE(mem_cgroup_from_seq(m)->some_prop));
+	return 0;
+}
+
+static ssize_t memory_some_prop_write(struct kernfs_open_file *of,
+		char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	buf = strstrip(buf);
+	memcg->some_prop = simple_strtoull(buf, NULL, 10);
+
+	return nbytes;
+}
+
+static int memory_full_prop_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%llu\n", (u64)READ_ONCE(mem_cgroup_from_seq(m)->full_prop));
+	return 0;
+}
+
+static ssize_t memory_full_prop_write(struct kernfs_open_file *of,
+		char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+
+	buf = strstrip(buf);
+	memcg->full_prop = simple_strtoull(buf, NULL, 10);
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6468,6 +6520,24 @@ static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
 		.seq_show = memory_oom_group_show,
 		.write = memory_oom_group_write,
 	},
+	{
+		.name = "wm_decay_factor",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_wm_df_show,
+		.write = memory_wm_df_write,
+	},
+	{
+		.name = "some_prop",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_some_prop_show,
+		.write = memory_some_prop_write,
+	},
+	{
+		.name = "full_prop",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_full_prop_show,
+		.write = memory_full_prop_write,
+	},
 	{ }	/* terminate */
 };
 
@@ -6616,6 +6686,7 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 	unsigned long usage, parent_usage;
 	struct mem_cgroup *parent;
+	unsigned long watermark;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -6642,6 +6713,9 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	if (!parent)
 		return;
 
+	if (memcg->wm_decay_fact)
+		calc_protected_low(memcg);
+
 	if (parent == root) {
 		memcg->memory.emin = READ_ONCE(memcg->memory.min);
 		memcg->memory.elow = READ_ONCE(memcg->memory.low);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 7d83641..18abfdd 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -83,6 +83,8 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 		 */
 		if (new > READ_ONCE(c->watermark))
 			WRITE_ONCE(c->watermark, new);
+		if (new > READ_ONCE(c->decayed_watermark))
+			WRITE_ONCE(c->decayed_watermark, new);
 	}
 }
 
@@ -137,6 +139,8 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 */
 		if (new > READ_ONCE(c->watermark))
 			WRITE_ONCE(c->watermark, new);
+		if (new > READ_ONCE(c->decayed_watermark))
+			WRITE_ONCE(c->decayed_watermark, new);
 	}
 	return true;
 
-- 
1.9.1

