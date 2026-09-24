Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79718DB1F
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 05:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228787; cv=none; b=CdNP68gduP+ldXHvxDgBcb2ibF3VwEV096bT83p8jNCvWsiLSEhwQw+Px1eeM+zNd95kseA6OuV14N3t+kTOdQqwWsyxYRf9xdxNtB/u/SjFwcj/92YqKZvGQU35zVDD7ROn+7TM0PHYxQx4BAtv6T0jAlJlm4XE45NI5N6zykE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228787; c=relaxed/simple;
	bh=RAOZKp8Q/Q0tA/184GLvyRwTPE2lSRMx6XcDAUCpv+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAAd99agXWFTVyQ9oCmjRYDCnUnI32dBjqCrv3/ZOVPROLYH7rkCfILbkJEcC8zgI3re39tKeYY3qTZ0/VUggFY8FgzYRH2yKhDg7JFztMat0MGIGOOZEe9INaFpkW7+nHK1qdhdL2zXESVBKfEaieq81gsc4mxv+uXJPrHg1Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tGHLGWjo; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tGHLGWjo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=RAOZKp8Q/Q0tA/184GLvyRwTPE2lSRMx6XcDAUCpv+k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790228783; v=1; x=1790833583;
 b=tGHLGWjoYkjJzLZNzidGKEnsYU8h7oi+IMNqAugjYvnmk9P19YeD22RCLbQs9g0J33KSfzFW
 CAazR4+LwU5q280aHNrszs+8jMelZE9/K+BRm/HYCiv0UmgSB/RB/RSbacAsNfFtcc8E08ZX2EJ
 Hp06OAiKLyMX3YQfRKrKfaE4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6eb70ab8b56be155;
	Thu, 24 Sep 2026 05:46:23 +0000
X-Mizu-Trace-ID: 6eb70ab8b56be155
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
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
	cuitao@kylinos.cn,
	ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: [RFC PATCH v7 3/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Thu, 24 Sep 2026 13:45:48 +0800
Message-ID: <20260924054549.2271705-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924054549.2271705-1-cui.tao@linux.dev>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add iocost_ioc_tick, emitted once per period from the tail of
ioc_timer_fn() with the overall controller state: period_us, vrate,
busy_level, active iocg count, usage percentage and running state.
It fires every period the controller is running, including steady
states, plus one final tick before the controller goes idle, which
makes dormancy (e.g. a device saturated entirely by uncharged IO)
directly visible.

Unlike the existing iocost tracepoints, which are state-change
driven and silent in steady state, this allows a bound cost model's
behaviour to be evaluated without drgn.

Depending on the autop profile this is 2-100 events per second per
device; the added cost outside the tracepoint static key is one
increment per active cgroup per period.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c            | 15 ++++++++++++
 include/trace/events/iocost.h | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 21e4f8cbd9f2..a48751b6dbdd 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2252,6 +2252,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2288,6 +2289,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2449,6 +2452,18 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * Everything the tick reports is final here: busy_level was just
+	 * computed, running and cur_period haven't changed, nr_active and
+	 * usage_us_sum are complete, and vrate and period_us still hold
+	 * the values this period ran in.  Emit before the refresh below
+	 * so the event reads the completed period directly.
+	 */
+	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum,
+			      ioc->period_us, ioc->vtime_base_rate,
+			      ioc->busy_level, ioc->running,
+			      now.now - ioc->period_at);
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d6..32f19861a78f 100644
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

