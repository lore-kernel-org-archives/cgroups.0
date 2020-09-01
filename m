From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 14/27] blk-iocost: calculate iocg->usages[] from iocg->local_stat.usage_us
Date: Tue,  1 Sep 2020 14:52:44 -0400
Message-ID: <20200901185257.645114-15-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NloDMWjJsS+bjuVz49pvrmKeqmF57hT1Nr3il/HqC2g=;
        b=ebPycDI+XWZGaFDnilsFlFrO5OVRhPj02XE4tDGuTN9237wIwia46lmRS1W2nMJhik
         zR1HAWIuad9uIjhNnsSePxMD5XGEI6Q8/NREEl5F4p4IBE5fM3oSnvPmcc6jUSJ8QExc
         Mp3p1SEwURyxEYhH39CIMotzqp5qZLEMCzF25Q9bgPBYsBHrU7/0lWl/ve66RJalb6RT
         JoQD3dtRJEXHsXjCCLEj8/QS6tx3hpzqNKCNhCjef606UXNGxuvqU4aACNEIP+97TFjm
         redHzPSYcT+mPAn2MvffRlJPUXZjC91D3SAuZd95aPJ91PjM88PHsYERepmt8PFGTKwQ
         vuEA==
In-Reply-To: <20200901185257.645114-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, iocg->usages[] which are used to guide inuse adjustments are
calculated from vtime deltas. This, however, assumes that the hierarchical
inuse weight at the time of calculation held for the entire period, which
often isn't true and can lead to significant errors.

Now that we have absolute usage information collected, we can derive
iocg->usages[] from iocg->local_stat.usage_us so that inuse adjustment
decisions are made based on actual absolute usage. The calculated usage is
clamped between 1 and WEIGHT_ONE and WEIGHT_ONE is also used to signal
saturation regardless of the current hierarchical inuse weight.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c            | 72 ++++++++++++++++++++++-------------
 include/trace/events/iocost.h |  7 +---
 2 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index f30f9b37fcf0..2496674bbbf4 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -476,14 +476,10 @@ struct ioc_gq {
 	 * `vtime_done` is the same but progressed on completion rather
 	 * than issue.  The delta behind `vtime` represents the cost of
 	 * currently in-flight IOs.
-	 *
-	 * `last_vtime` is used to remember `vtime` at the end of the last
-	 * period to calculate utilization.
 	 */
 	atomic64_t			vtime;
 	atomic64_t			done_vtime;
 	u64				abs_vdebt;
-	u64				last_vtime;
 
 	/*
 	 * The period this iocg was last active in.  Used for deactivation
@@ -506,6 +502,9 @@ struct ioc_gq {
 	struct hrtimer			waitq_timer;
 	struct hrtimer			delay_timer;
 
+	/* timestamp at the latest activation */
+	u64				activated_at;
+
 	/* statistics */
 	struct iocg_pcpu_stat __percpu	*pcpu_stat;
 	struct iocg_stat		local_stat;
@@ -514,6 +513,7 @@ struct ioc_gq {
 	u64				last_stat_abs_vusage;
 
 	/* usage is recorded as fractions of WEIGHT_ONE */
+	u32				usage_delta_us;
 	int				usage_idx;
 	u32				usages[NR_USAGE_SLOTS];
 
@@ -1159,7 +1159,7 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 	TRACE_IOCG_PATH(iocg_activate, iocg, now,
 			last_period, cur_period, vtime);
 
-	iocg->last_vtime = vtime;
+	iocg->activated_at = now->now;
 
 	if (ioc->running == IOC_IDLE) {
 		ioc->running = IOC_RUNNING;
@@ -1451,7 +1451,8 @@ static void iocg_flush_stat_one(struct ioc_gq *iocg, struct ioc_now *now)
 	vusage_delta = abs_vusage - iocg->last_stat_abs_vusage;
 	iocg->last_stat_abs_vusage = abs_vusage;
 
-	iocg->local_stat.usage_us += div64_u64(vusage_delta, now->vrate);
+	iocg->usage_delta_us = div64_u64(vusage_delta, now->vrate);
+	iocg->local_stat.usage_us += iocg->usage_delta_us;
 
 	new_stat.usage_us =
 		iocg->local_stat.usage_us + iocg->desc_stat.usage_us;
@@ -1558,8 +1559,9 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	/* calc usages and see whether some weights need to be moved around */
 	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
-		u64 vdone, vtime, vusage, vmin;
+		u64 vdone, vtime, usage_us, vmin;
 		u32 hw_active, hw_inuse, usage;
+		int uidx;
 
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
@@ -1583,27 +1585,44 @@ static void ioc_timer_fn(struct timer_list *timer)
 		    time_before64(vdone, now.vnow - period_vtime))
 			nr_lagging++;
 
-		if (waitqueue_active(&iocg->waitq))
-			vusage = now.vnow - iocg->last_vtime;
-		else if (time_before64(iocg->last_vtime, vtime))
-			vusage = vtime - iocg->last_vtime;
-		else
-			vusage = 0;
-
-		iocg->last_vtime += vusage;
 		/*
-		 * Factor in in-flight vtime into vusage to avoid
-		 * high-latency completions appearing as idle.  This should
-		 * be done after the above ->last_time adjustment.
+		 * Determine absolute usage factoring in pending and in-flight
+		 * IOs to avoid stalls and high-latency completions appearing as
+		 * idle.
 		 */
-		vusage = max(vusage, vtime - vdone);
-
-		/* calculate hweight based usage ratio and record */
-		if (vusage) {
-			usage = DIV64_U64_ROUND_UP(vusage * hw_inuse,
-						   period_vtime);
-			iocg->usage_idx = (iocg->usage_idx + 1) % NR_USAGE_SLOTS;
-			iocg->usages[iocg->usage_idx] = usage;
+		usage_us = iocg->usage_delta_us;
+		if (waitqueue_active(&iocg->waitq) && time_before64(vtime, now.vnow))
+			usage_us += DIV64_U64_ROUND_UP(
+				cost_to_abs_cost(now.vnow - vtime, hw_inuse),
+				now.vrate);
+		if (vdone != vtime) {
+			u64 inflight_us = DIV64_U64_ROUND_UP(
+				cost_to_abs_cost(vtime - vdone, hw_inuse),
+				now.vrate);
+			usage_us = max(usage_us, inflight_us);
+		}
+
+		/* convert to hweight based usage ratio and record */
+		uidx = (iocg->usage_idx + 1) % NR_USAGE_SLOTS;
+
+		if (time_after64(vtime, now.vnow - ioc->margins.min)) {
+			iocg->usage_idx = uidx;
+			iocg->usages[uidx] = WEIGHT_ONE;
+		} else if (usage_us) {
+			u64 started_at, dur;
+
+			if (time_after64(iocg->activated_at, ioc->period_at))
+				started_at = iocg->activated_at;
+			else
+				started_at = ioc->period_at;
+
+			dur = max_t(u64, now.now - started_at, 1);
+			usage = clamp_t(u32,
+				DIV64_U64_ROUND_UP(usage_us * WEIGHT_ONE, dur),
+				1, WEIGHT_ONE);
+
+			iocg->usage_idx = uidx;
+			iocg->usages[uidx] = usage;
 		} else {
 			usage = 0;
 		}
@@ -1620,7 +1639,6 @@ static void ioc_timer_fn(struct timer_list *timer)
 			/* throw away surplus vtime */
 			atomic64_add(delta, &iocg->vtime);
 			atomic64_add(delta, &iocg->done_vtime);
-			iocg->last_vtime += delta;
 			/* if usage is sufficiently low, maybe it can donate */
 			if (surplus_adjusted_hweight_inuse(usage, hw_inuse)) {
 				iocg->has_surplus = true;
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index c2f580fd371b..a905ecc0342f 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -26,7 +26,6 @@ TRACE_EVENT(iocost_iocg_activate,
 		__field(u64, vrate)
 		__field(u64, last_period)
 		__field(u64, cur_period)
-		__field(u64, last_vtime)
 		__field(u64, vtime)
 		__field(u32, weight)
 		__field(u32, inuse)
@@ -42,7 +41,6 @@ TRACE_EVENT(iocost_iocg_activate,
 		__entry->vrate = now->vrate;
 		__entry->last_period = last_period;
 		__entry->cur_period = cur_period;
-		__entry->last_vtime = iocg->last_vtime;
 		__entry->vtime = vtime;
 		__entry->weight = iocg->weight;
 		__entry->inuse = iocg->inuse;
@@ -51,13 +49,12 @@ TRACE_EVENT(iocost_iocg_activate,
 	),
 
 	TP_printk("[%s:%s] now=%llu:%llu vrate=%llu "
-		  "period=%llu->%llu vtime=%llu->%llu "
+		  "period=%llu->%llu vtime=%llu "
 		  "weight=%u/%u hweight=%llu/%llu",
 		__get_str(devname), __get_str(cgroup),
 		__entry->now, __entry->vnow, __entry->vrate,
 		__entry->last_period, __entry->cur_period,
-		__entry->last_vtime, __entry->vtime,
-		__entry->inuse, __entry->weight,
+		__entry->vtime, __entry->inuse, __entry->weight,
 		__entry->hweight_inuse, __entry->hweight_active
 	)
 );
-- 
2.26.2

