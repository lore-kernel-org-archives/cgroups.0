Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C354848A2
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 05:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710649; cv=none; b=PyQEqiIcKIAyrO6otiCepHYI1Lf+LIwtMY7VsWU3vQe/C3fgyJfS4Lbp4zVyhbFYVy6acfEZX9U2os18hDLPEEtbWRoBaWT24uGf97pstEgek3gVn3lzsHBibpBVNj1kCVZGvfGR4K0ZLeOYH5kbKbhbTwdLYsg7lHOredofh0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710649; c=relaxed/simple;
	bh=7eayQlUR/7KI93GLbfFgMELcyS1igZwfJBcDOR9G1hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcA0qdr7y/W1RM3F9M0sce6Cmul8FMYscWNceGd47TrgitMMOk62ULevvRVc+lw3dAwVF8q1VY6RgIx5D60CYRjyd233fNh6ZRGPFSLsJNYlZ61Js5+WxMkTYkRTwI51Fu9Gc8u+5Fg5yAAZ21GJ8E/yzwPnU53BLcKsJvOQ9rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xU398WIk; arc=none smtp.client-ip=91.218.175.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xU398WIk"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7eayQlUR/7KI93GLbfFgMELcyS1igZwfJBcDOR9G1hg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789710643; v=1; x=1790315443;
 b=xU398WIkPwwAWC87g6karG+89QL+RLi71kR6NAUU/stBMxqasi9wXNLBND67u5klBh3rC5FH
 a2mjVk2Y/o06zvccoqEpXg036Ul7Tg/V9T/ODZNaJ2F2fM5/FIBiA+6kk1/5XMo47N7CAMjOWP0
 VkftWye77cN3O9wdADhlotiM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ae88cf7a2e256186;
	Fri, 18 Sep 2026 05:50:43 +0000
X-Mizu-Trace-ID: ae88cf7a2e256186
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	ameryhung@gmail.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [RFC PATCH v6 3/5] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Fri, 18 Sep 2026 13:49:59 +0800
Message-ID: <20260918055001.1273840-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918055001.1273840-1-cui.tao@linux.dev>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

The existing iocost tracepoints are state-change driven: vrate_adj
fires only when the adjustment logic runs, inuse_* only on surplus
state transitions, activate/idle only on cgroup state changes.  In a
steady state none of them fire.  The only other way to observe the
controller (period length, vrate, busy level, active cgroup count,
device utilization) is iocost_monitor.py, which reads kernel memory
through drgn and is not usable in most production environments.

Add iocost_ioc_tick, emitted once per period from the tail of
ioc_timer_fn() with the overall controller state: period_us, vrate,
busy_level, active iocg count, usage percentage and running state.
It fires every period the controller runs, including steady states,
plus one final tick before the controller goes idle, which makes
dormancy (e.g. a device saturated entirely by uncharged IO) directly
visible.

Depending on the autop profile this is 2-100 events per second per
device; the added cost outside the tracepoint static key is one
increment per active cgroup per period.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c            | 32 +++++++++++++++++++++++++
 include/trace/events/iocost.h | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 307065c592950..9eb97f38a39cf 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2244,6 +2244,10 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
+	u32 tick_period_us;
+	u64 tick_vrate, tick_dur;
+	int tick_busy, tick_running;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2280,6 +2284,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2441,6 +2447,14 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * vrate and period_us change right below; snapshot the values
+	 * this period ran in so the tick below reports the period's own
+	 * parameters instead of the next period's.
+	 */
+	tick_period_us = ioc->period_us;
+	tick_vrate = ioc->vtime_base_rate;
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
@@ -2448,6 +2462,24 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc_forgive_debts(ioc, usage_us_sum, nr_debtors, &now);
 
+	/*
+	 * Snapshot the state this period ran in before the idle
+	 * transition below wipes it, so the final tick reports the period's
+	 * own busy level (e.g. the saturation that drove the controller
+	 * idle) instead of the cleared one.  usage is normalized by the
+	 * measured period length, captured before ioc_start_period()
+	 * overwrites period_at, the same way the donation loop does.
+	 * Emitted before cur_period is bumped, so the tick carries the
+	 * number of the period it describes.
+	 */
+	tick_busy = ioc->busy_level;
+	tick_running = ioc->running;
+	tick_dur = now.now - ioc->period_at;
+
+	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum,
+			      tick_period_us, tick_vrate,
+			      tick_busy, tick_running, tick_dur);
+
 	/*
 	 * This period is done.  Move onto the next one.  If nothing's
 	 * going on with the device, stop the timer.
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d60..32f19861a78fd 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -178,6 +178,51 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 	)
 );
 
+/*
+ * Periodic per-device summary, emitted once per period from the tail of
+ * ioc_timer_fn().  Unlike the state-change events above, this fires every
+ * period the controller is running, including steady states, and carries
+ * the overall controller state so basic monitoring doesn't require drgn.
+ */
+TRACE_EVENT(iocost_ioc_tick,
+
+	TP_PROTO(struct ioc *ioc, int nr_active, u64 usage_us_sum,
+		 u32 tick_period_us, u64 tick_vrate,
+		 int tick_busy, int tick_running, u64 tick_dur),
+
+	TP_ARGS(ioc, nr_active, usage_us_sum, tick_period_us, tick_vrate,
+		tick_busy, tick_running, tick_dur),
+
+	TP_STRUCT__entry (
+		__string(devname, ioc_name(ioc))
+		__field(u64, cur_period)
+		__field(u32, period_us)
+		__field(u64, vrate)
+		__field(int, busy_level)
+		__field(int, nr_active)
+		__field(u32, usage_pct)
+		__field(int, running)
+	),
+
+	TP_fast_assign(
+		__assign_str(devname);
+		__entry->cur_period = atomic64_read(&ioc->cur_period);
+		__entry->period_us = tick_period_us;
+		__entry->vrate = tick_vrate;
+		__entry->busy_level = tick_busy;
+		__entry->nr_active = nr_active;
+		__entry->usage_pct = tick_dur ?
+			div64_u64(usage_us_sum * 100, tick_dur) : 0;
+		__entry->running = tick_running;
+	),
+
+	TP_printk("[%s] period=%llu:%uus vrate=%llu busy=%d active=%d usage=%u%% running=%d",
+		__get_str(devname), __entry->cur_period, __entry->period_us,
+		__entry->vrate, __entry->busy_level, __entry->nr_active,
+		__entry->usage_pct, __entry->running
+	)
+);
+
 TRACE_EVENT(iocost_iocg_forgive_debt,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
-- 
2.43.0

