From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/19] writeback: make __wb_writeout_inc() and hard_dirty_limit() take wb_domaas a parameter
Date: Fri, 22 May 2015 18:23:29 -0400
Message-ID: <1432333416-6221-13-git-send-email-tj@kernel.org>
References: <1432333416-6221-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jDsd6gIbDUP9W2HYtAACOHK52fk6efWfYRvbJPpmvhg=;
        b=udfX1Ns0E7kotSXy5cIVXjORLdjcLKMYQIPcCn25bODy3kwV7AhhvSPP4Cm2HuoUH1
         sqfngt05NcCpZE1NemCkne120YrFpzZ8WQrFaajzqnqWXlmPXUDIa/zVJbczQ28mUMND
         WdrPNAuAmfbRtotO/Q/3sZsMChVjK5X9iPLEKz2M2YkRIU0RpR4fLmneCoxaUGoGiqbc
         Svz106jZayayMuZCXh/IuXo/2G5ieV+V8ro9KuioIcClugMwXm9dfh+Wi2BQNW1RVK34
         mHJ0QhqP2dIVkB/GjFtMN7H6ktr4EMJqUlpRVfo1rFqjJIcPt3RMQNA5LhO4itFl2FGJ
         j2pg==
In-Reply-To: <1432333416-6221-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

Currently __wb_writeout_inc() and hard_dirty_limit() assume
global_wb_domain; however, cgroup writeback support requires
considering per-memcg wb_domain too.

This patch separates out domain-specific part of __wb_writeout_inc()
into wb_domain_writeout_inc() which takes wb_domain as a parameter and
adds the parameter to hard_dirty_limit().  This will allow these two
functions to handle per-memcg wb_domains.

This patch doesn't introduce any behavioral changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 mm/page-writeback.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 38d45d8..a4d0cee 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -445,17 +445,12 @@ static unsigned long wp_next_time(unsigned long cur_time)
 	return cur_time;
 }
 
-/*
- * Increment the wb's writeout completion count and the global writeout
- * completion count. Called from test_clear_page_writeback().
- */
-static inline void __wb_writeout_inc(struct bdi_writeback *wb)
+static void wb_domain_writeout_inc(struct wb_domain *dom,
+				   struct fprop_local_percpu *completions,
+				   unsigned int max_prop_frac)
 {
-	struct wb_domain *dom = &global_wb_domain;
-
-	__inc_wb_stat(wb, WB_WRITTEN);
-	__fprop_inc_percpu_max(&dom->completions, &wb->completions,
-			       wb->bdi->max_prop_frac);
+	__fprop_inc_percpu_max(&dom->completions, completions,
+			       max_prop_frac);
 	/* First event after period switching was turned off? */
 	if (!unlikely(dom->period_time)) {
 		/*
@@ -469,6 +464,17 @@ static inline void __wb_writeout_inc(struct bdi_writeback *wb)
 	}
 }
 
+/*
+ * Increment @wb's writeout completion count and the global writeout
+ * completion count. Called from test_clear_page_writeback().
+ */
+static inline void __wb_writeout_inc(struct bdi_writeback *wb)
+{
+	__inc_wb_stat(wb, WB_WRITTEN);
+	wb_domain_writeout_inc(&global_wb_domain, &wb->completions,
+			       wb->bdi->max_prop_frac);
+}
+
 void wb_writeout_inc(struct bdi_writeback *wb)
 {
 	unsigned long flags;
@@ -571,10 +577,9 @@ static unsigned long dirty_freerun_ceiling(unsigned long thresh,
 	return (thresh + bg_thresh) / 2;
 }
 
-static unsigned long hard_dirty_limit(unsigned long thresh)
+static unsigned long hard_dirty_limit(struct wb_domain *dom,
+				      unsigned long thresh)
 {
-	struct wb_domain *dom = &global_wb_domain;
-
 	return max(thresh, dom->dirty_limit);
 }
 
@@ -744,7 +749,7 @@ static void wb_position_ratio(struct dirty_throttle_control *dtc)
 	struct bdi_writeback *wb = dtc->wb;
 	unsigned long write_bw = wb->avg_write_bandwidth;
 	unsigned long freerun = dirty_freerun_ceiling(dtc->thresh, dtc->bg_thresh);
-	unsigned long limit = hard_dirty_limit(dtc->thresh);
+	unsigned long limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
 	unsigned long wb_thresh = dtc->wb_thresh;
 	unsigned long x_intercept;
 	unsigned long setpoint;		/* dirty pages' target balance point */
@@ -1029,7 +1034,7 @@ static void wb_update_dirty_ratelimit(struct dirty_throttle_control *dtc,
 	struct bdi_writeback *wb = dtc->wb;
 	unsigned long dirty = dtc->dirty;
 	unsigned long freerun = dirty_freerun_ceiling(dtc->thresh, dtc->bg_thresh);
-	unsigned long limit = hard_dirty_limit(dtc->thresh);
+	unsigned long limit = hard_dirty_limit(dtc_dom(dtc), dtc->thresh);
 	unsigned long setpoint = (freerun + limit) / 2;
 	unsigned long write_bw = wb->avg_write_bandwidth;
 	unsigned long dirty_ratelimit = wb->dirty_ratelimit;
@@ -1681,7 +1686,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 
         for ( ; ; ) {
 		global_dirty_limits(&background_thresh, &dirty_thresh);
-		dirty_thresh = hard_dirty_limit(dirty_thresh);
+		dirty_thresh = hard_dirty_limit(&global_wb_domain, dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
