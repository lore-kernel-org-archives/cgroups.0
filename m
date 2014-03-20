From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 3/4] timer: create timer_quiesce_cpu() for cpusets.quiesce option
Date: Thu, 20 Mar 2014 19:19:00 +0530
Message-ID: <f4089caeaef95cde80bbbf3afdb36dcd5122c558.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

Cpusets would be using timer migration code to isolate/quiese a CPU. And hence
that should be changed a bit as the CPU in question would be online now. Also we
need to make sure that we don't remove pinned timers.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 54 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index a7f8b99..81d64e0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1602,18 +1602,27 @@ static int init_timers_cpu(int cpu)
 	return 0;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-static void migrate_timer_list(struct tvec_base *new_base, struct list_head *head)
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_CPUSETS)
+static void migrate_timer_list(struct tvec_base *new_base,
+			       struct list_head *head, bool remove_pinned)
 {
 	struct timer_list *timer;
+	struct list_head pinned_list;
 	int is_pinned;
 
+	INIT_LIST_HEAD(&pinned_list);
+
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
-		/* We ignore the accounting on the dying cpu */
-		detach_timer(timer, false);
 
 		is_pinned = tbase_get_pinned(timer->base);
+		if (!remove_pinned && is_pinned) {
+			list_move_tail(&timer->entry, &pinned_list);
+			continue;
+		} else {
+			/* We ignore the accounting on the dying cpu */
+			detach_timer(timer, false);
+		}
 
 		/* Check if CPU still has pinned timers */
 		if (is_pinned) {
@@ -1625,15 +1634,18 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
+
+	if (!list_empty(&pinned_list))
+		list_splice_tail(&pinned_list, head);
 }
 
-static void migrate_timers(int cpu)
+/* Migrate timers from 'cpu' to this_cpu */
+static void __migrate_timers(int cpu, bool remove_pinned)
 {
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
 	int i;
 
-	BUG_ON(cpu_online(cpu));
 	old_base = per_cpu(tvec_bases, cpu);
 	new_base = get_cpu_var(tvec_bases);
 	/*
@@ -1646,20 +1658,40 @@ static void migrate_timers(int cpu)
 	BUG_ON(old_base->running_timer);
 
 	for (i = 0; i < TVR_SIZE; i++)
-		migrate_timer_list(new_base, old_base->tv1.vec + i);
+		migrate_timer_list(new_base, old_base->tv1.vec + i,
+				remove_pinned);
 	for (i = 0; i < TVN_SIZE; i++) {
-		migrate_timer_list(new_base, old_base->tv2.vec + i);
-		migrate_timer_list(new_base, old_base->tv3.vec + i);
-		migrate_timer_list(new_base, old_base->tv4.vec + i);
-		migrate_timer_list(new_base, old_base->tv5.vec + i);
+		migrate_timer_list(new_base, old_base->tv2.vec + i,
+				remove_pinned);
+		migrate_timer_list(new_base, old_base->tv3.vec + i,
+				remove_pinned);
+		migrate_timer_list(new_base, old_base->tv4.vec + i,
+				remove_pinned);
+		migrate_timer_list(new_base, old_base->tv5.vec + i,
+				remove_pinned);
 	}
 
 	spin_unlock(&old_base->lock);
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(tvec_bases);
 }
+#endif /* CONFIG_HOTPLUG_CPU || CONFIG_CPUSETS */
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void migrate_timers(int cpu)
+{
+	BUG_ON(cpu_online(cpu));
+	__migrate_timers(cpu, true);
+}
 #endif /* CONFIG_HOTPLUG_CPU */
 
+#ifdef CONFIG_CPUSETS
+void timer_quiesce_cpu(void *data)
+{
+	__migrate_timers((int)data, false);
+}
+#endif /* CONFIG_CPUSETS */
+
 static int timer_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
-- 
1.7.12.rc2.18.g61b472e
