From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/8] timer: track pinned timers with TIMER_PINNED flag
Date: Fri,  4 Apr 2014 14:05:28 +0530
Message-ID: <7236b1fccb011d9863403b544e8272171446b4fe.1396599474.git.viresh.kumar@linaro.org>
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

In order to quiesce a CPU on which Isolation might be required, we need to move
away all the timers queued on that CPU. There are two types of timers queued on
any CPU: ones that are pinned to that CPU and others can run on any CPU but are
queued on CPU in question. And we need to migrate only the second type of timers
away from the CPU entering quiesce state.

For this we need some basic infrastructure in timer core to identify which
timers are pinned and which are not.

Hence, this patch adds another flag bit TIMER_PINNED which will be set only for
the timers which are pinned to a CPU.

It also removes 'pinned' parameter of __mod_timer() as it is no more required.

NOTE: One functional change worth mentioning

Existing Behavior: add_timer_on() followed by multiple mod_timer() wouldn't pin
the timer on CPU mentioned in add_timer_on()..

New Behavior: add_timer_on() followed by multiple mod_timer() would pin the
timer on CPU running mod_timer().

I didn't gave much attention to this as we should call mod_timer_on() for the
timers queued with add_timer_on(). Though if required we can simply clear the
TIMER_PINNED flag in mod_timer().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/timer.h | 10 ++++++----
 kernel/timer.c        | 27 ++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 8c5a197..2962403 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -49,7 +49,7 @@ extern struct tvec_base boot_tvec_bases;
 #endif
 
 /*
- * Note that all tvec_bases are at least 4 byte aligned and lower two bits
+ * Note that all tvec_bases are at least 8 byte aligned and lower three bits
  * of base in timer_list is guaranteed to be zero. Use them for flags.
  *
  * A deferrable timer will work normally when the system is busy, but
@@ -61,14 +61,18 @@ extern struct tvec_base boot_tvec_bases;
  * the completion of the running instance from IRQ handlers, for example,
  * by calling del_timer_sync().
  *
+ * A pinned timer is allowed to run only on the cpu mentioned and shouldn't be
+ * migrated to any other CPU.
+ *
  * Note: The irq disabled callback execution is a special case for
  * workqueue locking issues. It's not meant for executing random crap
  * with interrupts disabled. Abuse is monitored!
  */
 #define TIMER_DEFERRABLE		0x1LU
 #define TIMER_IRQSAFE			0x2LU
+#define TIMER_PINNED			0x4LU
 
-#define TIMER_FLAG_MASK			0x3LU
+#define TIMER_FLAG_MASK			0x7LU
 
 #define __TIMER_INITIALIZER(_function, _expires, _data, _flags) { \
 		.entry = { .prev = TIMER_ENTRY_STATIC },	\
@@ -179,8 +183,6 @@ extern int mod_timer_pinned(struct timer_list *timer, unsigned long expires);
 
 extern void set_timer_slack(struct timer_list *time, int slack_hz);
 
-#define TIMER_NOT_PINNED	0
-#define TIMER_PINNED		1
 /*
  * The jiffies value which is added to now, when there is no timer
  * in the timer wheel:
diff --git a/kernel/timer.c b/kernel/timer.c
index d13eb56..e8bcaff 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -104,6 +104,11 @@ static inline unsigned int tbase_get_irqsafe(struct tvec_base *base)
 	return ((unsigned int)(unsigned long)base & TIMER_IRQSAFE);
 }
 
+static inline unsigned int tbase_get_pinned(struct tvec_base *base)
+{
+	return ((unsigned int)(unsigned long)base & TIMER_PINNED);
+}
+
 static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
 {
 	return ((struct tvec_base *)((unsigned long)base & ~TIMER_FLAG_MASK));
@@ -117,6 +122,13 @@ timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
 	timer->base = (struct tvec_base *)((unsigned long)(new_base) | flags);
 }
 
+static inline void
+timer_set_flags(struct timer_list *timer, unsigned int flags)
+{
+	timer->base = (struct tvec_base *)((unsigned long)(timer->base) |
+					   flags);
+}
+
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
 		bool force_up)
 {
@@ -742,8 +754,7 @@ static struct tvec_base *lock_timer_base(struct timer_list *timer,
 }
 
 static inline int
-__mod_timer(struct timer_list *timer, unsigned long expires,
-						bool pending_only, int pinned)
+__mod_timer(struct timer_list *timer, unsigned long expires, bool pending_only)
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
@@ -760,7 +771,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = get_nohz_timer_target(pinned);
+	cpu = get_nohz_timer_target(tbase_get_pinned(timer->base));
 	new_base = per_cpu(tvec_bases, cpu);
 
 	if (base != new_base) {
@@ -802,7 +813,7 @@ out_unlock:
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
-	return __mod_timer(timer, expires, true, TIMER_NOT_PINNED);
+	return __mod_timer(timer, expires, true);
 }
 EXPORT_SYMBOL(mod_timer_pending);
 
@@ -877,7 +888,7 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
-	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
+	return __mod_timer(timer, expires, false);
 }
 EXPORT_SYMBOL(mod_timer);
 
@@ -905,7 +916,8 @@ int mod_timer_pinned(struct timer_list *timer, unsigned long expires)
 	if (timer->expires == expires && timer_pending(timer))
 		return 1;
 
-	return __mod_timer(timer, expires, false, TIMER_PINNED);
+	timer_set_flags(timer, TIMER_PINNED);
+	return __mod_timer(timer, expires, false);
 }
 EXPORT_SYMBOL(mod_timer_pinned);
 
@@ -944,6 +956,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
+	timer_set_flags(timer, TIMER_PINNED);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	debug_activate(timer, timer->expires);
@@ -1493,7 +1506,7 @@ signed long __sched schedule_timeout(signed long timeout)
 	expire = timeout + jiffies;
 
 	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire, false, TIMER_NOT_PINNED);
+	__mod_timer(&timer, expire, false);
 	schedule();
 	del_singleshot_timer_sync(&timer);
 
-- 
1.7.12.rc2.18.g61b472e
