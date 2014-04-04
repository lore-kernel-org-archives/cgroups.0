From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 4/8] hrtimer: update timer->state with 'pinned' information
Date: Fri,  4 Apr 2014 14:05:31 +0530
Message-ID: <489558160713494c5e8840aa5d6c22a8064aa603.1396599474.git.viresh.kumar@linaro.org>
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

'Pinned' information would be required in migrate_hrtimers() now, as we can
migrate non-pinned timers away without a hotplug (i.e. with cpuset.quiesce). And
so we may need to identify pinned timers now, as we can't migrate them.

This patch reuses the timer->state variable for setting this flag as there were
enough number of free bits available in this variable. And there is no point
increasing size of this struct by adding another field.

Signed-off-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/hrtimer.h |  3 +++
 kernel/hrtimer.c        | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 435ac4c..9fdb67b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -55,6 +55,7 @@ enum hrtimer_restart {
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
  * 0x04		timer is migrated to another cpu
+ * 0x08		timer is pinned to a cpu
  *
  * Special cases:
  * 0x03		callback function running and enqueued
@@ -81,6 +82,8 @@ enum hrtimer_restart {
 #define HRTIMER_STATE_ENQUEUED	0x01
 #define HRTIMER_STATE_CALLBACK	0x02
 #define HRTIMER_STATE_MIGRATE	0x04
+#define HRTIMER_PINNED_SHIFT	3
+#define HRTIMER_STATE_PINNED	(1 << HRTIMER_PINNED_SHIFT)
 
 /**
  * struct hrtimer - the basic hrtimer structure
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d62fe32..c5a4bf4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -905,7 +905,11 @@ static void __remove_hrtimer(struct hrtimer *timer, unsigned long newstate,
 			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
 #endif
-	timer->state = newstate;
+	/*
+	 * We need to preserve PINNED state here, otherwise we may end up
+	 * migrating pinned hrtimers as well.
+	 */
+	timer->state = newstate | (timer->state & HRTIMER_STATE_PINNED);
 }
 
 /* remove hrtimer, called with base lock held */
@@ -970,6 +974,10 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	timer_stats_hrtimer_set_start_info(timer);
 
+	/* Update pinned state */
+	timer->state &= ~HRTIMER_STATE_PINNED;
+	timer->state |= !!(mode & HRTIMER_MODE_PINNED) << HRTIMER_PINNED_SHIFT;
+
 	enqueue_hrtimer(timer);
 
 	/*
@@ -1227,7 +1235,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
 	 */
 	if (restart != HRTIMER_NORESTART) {
-		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+		BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
 		enqueue_hrtimer(timer);
 	}
 
-- 
1.7.12.rc2.18.g61b472e
