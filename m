From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 3/8] timer: create timer_quiesce_cpu() to isolate CPU from timers
Date: Fri,  4 Apr 2014 14:05:30 +0530
Message-ID: <12833475ef32cb4ee832e40dbbc0445c4d8ab3e7.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
References: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linaro-networking-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Arvind.Chauhan-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

To isolate CPUs (isolate from timers) from sysfs using cpusets, we need some
support from the timer core. i.e. A routine timer_quiesce_cpu() which would
migrate away all the unpinned timers, but shouldn't touch the pinned ones.

This patch creates this routine.

Signed-off-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/timer.h |  3 +++
 kernel/timer.c        | 54 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 2962403..1588a4f 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -196,6 +196,9 @@ extern void set_timer_slack(struct timer_list *time, int slack_hz);
  */
 extern unsigned long get_next_timer_interrupt(unsigned long now);
 
+/* To be used from cpusets, only */
+extern void timer_quiesce_cpu(void *cpup);
+
 /*
  * Timer-statistics info:
  */
diff --git a/kernel/timer.c b/kernel/timer.c
index 6c3a371..4676a07 100644
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
 		if (unlikely(WARN(is_pinned,
@@ -1624,15 +1633,18 @@ static void migrate_timer_list(struct tvec_base *new_base, struct list_head *hea
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
@@ -1645,20 +1657,40 @@ static void migrate_timers(int cpu)
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
+void timer_quiesce_cpu(void *cpup)
+{
+	__migrate_timers(*(int *)cpup, false);
+}
+#endif /* CONFIG_CPUSETS */
+
 static int timer_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
-- 
1.7.12.rc2.18.g61b472e
