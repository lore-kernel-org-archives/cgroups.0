From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/27] blk-iocost: restore inuse update tracepoints
Date: Tue,  1 Sep 2020 14:52:55 -0400
Message-ID: <20200901185257.645114-26-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5bqavxbqk85onXAByeypQmTg/sTVdfkgjS7XfGpNMQ=;
        b=am9+85JN4GRBuF8BDWFu1kcmXapeiLESBbeO2JWuzObgkvndOBzUEW5c8Cs3bWO45B
         soo1wZFJVSJgViU3TVF/amCK2K8rK+5eU0g3FyLarODlyKoB7aB5pObEvWDHSAVfjdKn
         7A5fIa8Uep0kNYxTmTEiCxHdbm0pqDTvXTKl0rXbi/726sr87Kc19jUuKMRRz3mNmg6n
         i94zbBVxEVyd6TSJKNe8l5quOIiACN3/rQ1lG19Pw+cKwOLvUqJe02RiOWfyVHNVJ4lp
         O5fh3KrvfgaxTeRr0i2Q80Ymdy+n0Wd//ctPLB5EaYLvtUSInqMCAsJd979AnRbhMasQ
         QWWw==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

Update and restore the inuse update tracepoints.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c            | 16 ++++++++++++++++
 include/trace/events/iocost.h |  6 +++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 0270a504e6b5..9366527d8c12 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1919,6 +1919,12 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		inuse = DIV64_U64_ROUND_UP(
 			parent->child_adjusted_sum * iocg->hweight_after_donation,
 			parent->hweight_inuse);
+
+		TRACE_IOCG_PATH(inuse_transfer, iocg, now,
+				iocg->inuse, inuse,
+				iocg->hweight_inuse,
+				iocg->hweight_after_donation);
+
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
 	}
 
@@ -2076,6 +2082,10 @@ static void ioc_timer_fn(struct timer_list *timer)
 				iocg->hweight_after_donation = new_hwi;
 				list_add(&iocg->surplus_list, &surpluses);
 			} else {
+				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
+						iocg->inuse, iocg->active,
+						iocg->hweight_inuse, new_hwi);
+
 				__propagate_weights(iocg, iocg->active,
 						    iocg->active, true, &now);
 				nr_shortages++;
@@ -2248,11 +2258,13 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq *iocg, u64 vtime,
 	struct ioc *ioc = iocg->ioc;
 	struct ioc_margins *margins = &ioc->margins;
 	u32 adj_step = DIV_ROUND_UP(iocg->active * INUSE_ADJ_STEP_PCT, 100);
+	u32 __maybe_unused old_inuse = iocg->inuse, __maybe_unused old_hwi;
 	u32 hwi;
 	s64 margin;
 	u64 cost, new_inuse;
 
 	current_hweight(iocg, NULL, &hwi);
+	old_hwi = hwi;
 	cost = abs_cost_to_cost(abs_cost, hwi);
 	margin = now->vnow - vtime - cost;
 
@@ -2287,6 +2299,10 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq *iocg, u64 vtime,
 		 iocg->inuse != iocg->active);
 
 	spin_unlock_irq(&ioc->lock);
+
+	TRACE_IOCG_PATH(inuse_adjust, iocg, now,
+			old_inuse, iocg->inuse, old_hwi, hwi);
+
 	return cost;
 }
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index ee024fe8fef6..b350860d2e71 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -95,7 +95,7 @@ DECLARE_EVENT_CLASS(iocg_inuse_update,
 	)
 );
 
-DEFINE_EVENT(iocg_inuse_update, iocost_inuse_takeback,
+DEFINE_EVENT(iocg_inuse_update, iocost_inuse_shortage,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
 		u32 old_inuse, u32 new_inuse,
@@ -105,7 +105,7 @@ DEFINE_EVENT(iocg_inuse_update, iocost_inuse_takeback,
 		old_hw_inuse, new_hw_inuse)
 );
 
-DEFINE_EVENT(iocg_inuse_update, iocost_inuse_giveaway,
+DEFINE_EVENT(iocg_inuse_update, iocost_inuse_transfer,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
 		u32 old_inuse, u32 new_inuse,
@@ -115,7 +115,7 @@ DEFINE_EVENT(iocg_inuse_update, iocost_inuse_giveaway,
 		old_hw_inuse, new_hw_inuse)
 );
 
-DEFINE_EVENT(iocg_inuse_update, iocost_inuse_reset,
+DEFINE_EVENT(iocg_inuse_update, iocost_inuse_adjust,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
 		u32 old_inuse, u32 new_inuse,
-- 
2.26.2

