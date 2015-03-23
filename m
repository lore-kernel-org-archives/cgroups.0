From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/18] writeback: implement wb_domain
Date: Mon, 23 Mar 2015 01:07:32 -0400
Message-ID: <1427087267-16592-4-git-send-email-tj@kernel.org>
References: <1427087267-16592-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e1oUgzJQ3x9Ze578qEHo/9O7+cigqzk+uoYKtWl26Sk=;
        b=H38MUR+ppnFBnToM9RhI2VyYRyQ3RAZ0FWtveHFARbLgUg52ZzsVgHUna3CQIm9P5k
         RznA6cRdu1mq1xLtUULhW94xC+jdhgn/Md9l2U+rGAEIrUxOviubxmnbdTFyPaB6zLYJ
         +PTshVG4TXvxnYqm54xUubTbMRsk4czOBRCIhBL8tCXcxww2Fk+feKlfRCbUowlpcRfP
         c+1peh9rdnFX0xijT2kEolW6en+4U9+YtsA/KPoh+dtwpgfUskOtS2RzYokfRYevQQlq
         oKblkm5cqvXJF9FcucHjNa3nosNoV5TEhzwQ+zTBU1PvO42JMYBXv4gf3NN+xg1gkN7N
         CysA==
In-Reply-To: <1427087267-16592-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Dirtyable memory is distributed to a wb (bdi_writeback) according to
the relative bandwidth the wb is writing out in the whole system.
This distribution is global - each wb is measured against all other
wb's and gets the proportinately sized portion of the memory in the
whole system.

For cgroup writeback, the amount of dirtyable memory is scoped by
memcg and thus each wb would need to be measured and controlled in its
memcg.  IOW, a wb will belong to two writeback domains - the global
and memcg domains.

Currently, what constitutes the global writeback domain are scattered
across a number of global states.  This patch starts collecting them
into struct wb_domain.

* fprop_global which serves as the basis for proportional bandwidth
  measurement and its period timer are moved into struct wb_domain.

* global_wb_domain hosts the states for the global domain.

* While at it, flatten wb_writeout_fraction() into its callers.  This
  thin wrapper doesn't provide any actual benefits while getting in
  the way.

This is pure reorganization and doesn't introduce any behavioral
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 include/linux/writeback.h | 32 +++++++++++++++++++++
 mm/page-writeback.c       | 72 ++++++++++++++++++-----------------------------
 2 files changed, 59 insertions(+), 45 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 82e0e39..5af0a57e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/fs.h>
+#include <linux/flex_proportions.h>
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
 
@@ -87,6 +88,36 @@ struct writeback_control {
 };
 
 /*
+ * A wb_domain represents a domain that wb's (bdi_writeback's) belong to
+ * and are measured against each other in.  There always is one global
+ * domain, global_wb_domain, that every wb in the system is a member of.
+ * This allows measuring the relative bandwidth of each wb to distribute
+ * dirtyable memory accordingly.
+ */
+struct wb_domain {
+	/*
+	 * Scale the writeback cache size proportional to the relative
+	 * writeout speed.
+	 *
+	 * We do this by keeping a floating proportion between BDIs, based
+	 * on page writeback completions [end_page_writeback()]. Those
+	 * devices that write out pages fastest will get the larger share,
+	 * while the slower will get a smaller share.
+	 *
+	 * We use page writeout completions because we are interested in
+	 * getting rid of dirty pages. Having them written out is the
+	 * primary goal.
+	 *
+	 * We introduce a concept of time, a period over which we measure
+	 * these events, because demand can/will vary over time. The length
+	 * of this period itself is measured in page writeback completions.
+	 */
+	struct fprop_global completions;
+	struct timer_list period_timer;	/* timer for aging of completions */
+	unsigned long period_time;
+};
+
+/*
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
@@ -120,6 +151,7 @@ static inline void laptop_sync_completion(void) { }
 #endif
 void throttle_vm_writeout(gfp_t gfp_mask);
 bool zone_dirty_ok(struct zone *zone);
+int wb_domain_init(struct wb_domain *dom, gfp_t gfp);
 
 extern unsigned long global_dirty_limit;
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d9ebabe..3c6ccc7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -124,29 +124,7 @@ EXPORT_SYMBOL(laptop_mode);
 
 unsigned long global_dirty_limit;
 
-/*
- * Scale the writeback cache size proportional to the relative writeout speeds.
- *
- * We do this by keeping a floating proportion between BDIs, based on page
- * writeback completions [end_page_writeback()]. Those devices that write out
- * pages fastest will get the larger share, while the slower will get a smaller
- * share.
- *
- * We use page writeout completions because we are interested in getting rid of
- * dirty pages. Having them written out is the primary goal.
- *
- * We introduce a concept of time, a period over which we measure these events,
- * because demand can/will vary over time. The length of this period itself is
- * measured in page writeback completions.
- *
- */
-static struct fprop_global writeout_completions;
-
-static void writeout_period(unsigned long t);
-/* Timer for aging of writeout_completions */
-static struct timer_list writeout_period_timer =
-		TIMER_DEFERRED_INITIALIZER(writeout_period, 0, 0);
-static unsigned long writeout_period_time = 0;
+static struct wb_domain global_wb_domain;
 
 /*
  * Length of period for aging writeout fractions of bdis. This is an
@@ -433,24 +411,26 @@ static unsigned long wp_next_time(unsigned long cur_time)
 }
 
 /*
- * Increment the BDI's writeout completion count and the global writeout
+ * Increment the wb's writeout completion count and the global writeout
  * completion count. Called from test_clear_page_writeback().
  */
 static inline void __wb_writeout_inc(struct bdi_writeback *wb)
 {
+	struct wb_domain *dom = &global_wb_domain;
+
 	__inc_wb_stat(wb, WB_WRITTEN);
-	__fprop_inc_percpu_max(&writeout_completions, &wb->completions,
+	__fprop_inc_percpu_max(&dom->completions, &wb->completions,
 			       wb->bdi->max_prop_frac);
 	/* First event after period switching was turned off? */
-	if (!unlikely(writeout_period_time)) {
+	if (!unlikely(dom->period_time)) {
 		/*
 		 * We can race with other __bdi_writeout_inc calls here but
 		 * it does not cause any harm since the resulting time when
 		 * timer will fire and what is in writeout_period_time will be
 		 * roughly the same.
 		 */
-		writeout_period_time = wp_next_time(jiffies);
-		mod_timer(&writeout_period_timer, writeout_period_time);
+		dom->period_time = wp_next_time(jiffies);
+		mod_timer(&dom->period_timer, dom->period_time);
 	}
 }
 
@@ -465,37 +445,37 @@ void wb_writeout_inc(struct bdi_writeback *wb)
 EXPORT_SYMBOL_GPL(wb_writeout_inc);
 
 /*
- * Obtain an accurate fraction of the BDI's portion.
- */
-static void wb_writeout_fraction(struct bdi_writeback *wb,
-				 long *numerator, long *denominator)
-{
-	fprop_fraction_percpu(&writeout_completions, &wb->completions,
-				numerator, denominator);
-}
-
-/*
  * On idle system, we can be called long after we scheduled because we use
  * deferred timers so count with missed periods.
  */
 static void writeout_period(unsigned long t)
 {
-	int miss_periods = (jiffies - writeout_period_time) /
+	struct wb_domain *dom = (void *)t;
+	int miss_periods = (jiffies - dom->period_time) /
 						 VM_COMPLETIONS_PERIOD_LEN;
 
-	if (fprop_new_period(&writeout_completions, miss_periods + 1)) {
-		writeout_period_time = wp_next_time(writeout_period_time +
+	if (fprop_new_period(&dom->completions, miss_periods + 1)) {
+		dom->period_time = wp_next_time(dom->period_time +
 				miss_periods * VM_COMPLETIONS_PERIOD_LEN);
-		mod_timer(&writeout_period_timer, writeout_period_time);
+		mod_timer(&dom->period_timer, dom->period_time);
 	} else {
 		/*
 		 * Aging has zeroed all fractions. Stop wasting CPU on period
 		 * updates.
 		 */
-		writeout_period_time = 0;
+		dom->period_time = 0;
 	}
 }
 
+int wb_domain_init(struct wb_domain *dom, gfp_t gfp)
+{
+	memset(dom, 0, sizeof(*dom));
+	init_timer_deferrable(&dom->period_timer);
+	dom->period_timer.function = writeout_period;
+	dom->period_timer.data = (unsigned long)dom;
+	return fprop_global_init(&dom->completions, gfp);
+}
+
 /*
  * bdi_min_ratio keeps the sum of the minimum dirty shares of all
  * registered backing devices, which, for obvious reasons, can not
@@ -579,6 +559,7 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
  */
 unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
 {
+	struct wb_domain *dom = &global_wb_domain;
 	u64 wb_dirty;
 	long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
@@ -586,7 +567,8 @@ unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
 	/*
 	 * Calculate this BDI's share of the dirty ratio.
 	 */
-	wb_writeout_fraction(wb, &numerator, &denominator);
+	fprop_fraction_percpu(&dom->completions, &wb->completions,
+			      &numerator, &denominator);
 
 	wb_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
 	wb_dirty *= numerator;
@@ -1831,7 +1813,7 @@ void __init page_writeback_init(void)
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
-	fprop_global_init(&writeout_completions, GFP_KERNEL);
+	BUG_ON(wb_domain_init(&global_wb_domain, GFP_KERNEL));
 }
 
 /**
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
