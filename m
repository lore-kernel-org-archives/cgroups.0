From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 6/8] hrtimer: create hrtimer_quiesce_cpu() to isolate CPU from hrtimers
Date: Fri,  4 Apr 2014 14:05:33 +0530
Message-ID: <3d9c01fcc1b628ebc47c0ccdd17f9dc3e9e54614.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org, Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

To isolate CPUs (isolate from hrtimers) from sysfs using cpusets, we need some
support from the hrtimer core. i.e. A routine hrtimer_quiesce_cpu() which would
migrate away all the unpinned hrtimers, but shouldn't touch the pinned ones.

This patch creates this routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h |  3 +++
 kernel/hrtimer.c        | 47 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 9fdb67b..0718753 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -350,6 +350,9 @@ DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
 /* Exported timer functions: */
 
+/* To be used from cpusets, only */
+extern void hrtimer_quiesce_cpu(void *cpup);
+
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 853dd8c..e8cd1db 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1633,17 +1633,21 @@ static void init_hrtimers_cpu(int cpu)
 	hrtimer_init_hres(cpu_base);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_CPUSETS)
 static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
-				struct hrtimer_clock_base *new_base)
+				struct hrtimer_clock_base *new_base,
+				bool remove_pinned)
 {
 	struct hrtimer *timer;
 	struct timerqueue_node *node;
+	struct timerqueue_head pinned;
 	int is_pinned;
 
+	timerqueue_init_head(&pinned);
+
 	while ((node = timerqueue_getnext(&old_base->active))) {
 		timer = container_of(node, struct hrtimer, node);
+
 		BUG_ON(hrtimer_callback_running(timer));
 		debug_deactivate(timer);
 
@@ -1655,6 +1659,10 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		__remove_hrtimer(timer, HRTIMER_STATE_MIGRATE, 0);
 
 		is_pinned = timer->state & HRTIMER_STATE_PINNED;
+		if (!remove_pinned && is_pinned) {
+			timerqueue_add(&pinned, &timer->node);
+			continue;
+		}
 
 		/* Check if CPU still has pinned timers */
 		if (unlikely(WARN(is_pinned,
@@ -1676,18 +1684,24 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
 	}
+
+	/* Re-queue pinned timers for non-hotplug usecase */
+	while ((node = timerqueue_getnext(&pinned))) {
+		timer = container_of(node, struct hrtimer, node);
+
+		timerqueue_del(&pinned, &timer->node);
+		enqueue_hrtimer(timer);
+		timer->state &= ~HRTIMER_STATE_MIGRATE;
+	}
 }
 
-static void migrate_hrtimers(int scpu)
+static void __migrate_hrtimers(int scpu, bool remove_pinned)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
 	struct hrtimer_clock_base *clock_base;
 	unsigned int active_bases;
 	int i;
 
-	BUG_ON(cpu_online(scpu));
-	tick_cancel_sched_timer(scpu);
-
 	local_irq_disable();
 	old_base = &per_cpu(hrtimer_bases, scpu);
 	new_base = &__get_cpu_var(hrtimer_bases);
@@ -1700,7 +1714,8 @@ static void migrate_hrtimers(int scpu)
 
 	for_each_active_base(i, clock_base, old_base, active_bases)
 		migrate_hrtimer_list(clock_base,
-				     &new_base->clock_base[clock_base->index]);
+				     &new_base->clock_base[clock_base->index],
+				     remove_pinned);
 
 	raw_spin_unlock(&old_base->lock);
 	raw_spin_unlock(&new_base->lock);
@@ -1709,9 +1724,25 @@ static void migrate_hrtimers(int scpu)
 	__hrtimer_peek_ahead_timers();
 	local_irq_enable();
 }
+#endif /* CONFIG_HOTPLUG_CPU || CONFIG_CPUSETS */
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void migrate_hrtimers(int scpu)
+{
+	BUG_ON(cpu_online(scpu));
+	tick_cancel_sched_timer(scpu);
+
+	__migrate_hrtimers(scpu, true);
+}
 #endif /* CONFIG_HOTPLUG_CPU */
 
+#ifdef CONFIG_CPUSETS
+void hrtimer_quiesce_cpu(void *cpup)
+{
+	__migrate_hrtimers(*(int *)cpup, false);
+}
+#endif /* CONFIG_CPUSETS */
+
 static int hrtimer_cpu_notify(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
-- 
1.7.12.rc2.18.g61b472e
