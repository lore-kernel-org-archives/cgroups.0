Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94064CC27C
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861738; cv=none; b=SderWhKJeNbYxYV2DkmXeDavxA/imSVdL43/jMeu7zZ4pM5ruTBt52BzAedOPZGa69dmQ73YSjpJ8Tevgf9OSpnvOYWq1qdu94b/5pxsmEsqJQmghFbdyTe3BjsDHhrlqmCDE5WN+k9dWKbnNuWYuOTZf9lgHUI0/IMqWQUwPSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861738; c=relaxed/simple;
	bh=6Er5qYt+ZL2rO4NlQ1VevHRE6P5HGnDAn+0Yr/dg/0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvX2ZB6JHsRCAcMZJpMnc2Yp/K28h6WquUn3qccaXRGDI0HZTG/TUeVJIaI3/KOpu7RgFnJFpv3lvyHlxgzd/6PPx/w2qS9IE0SZY2k1VlS0pKYC5+VE8TuZYTpWd1ilzpl9it/luL6OvloObUfIPz/Y9ZSR9BHwgMl7EBSWbcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JWvNfjWg; arc=none smtp.client-ip=91.218.175.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JWvNfjWg"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6Er5qYt+ZL2rO4NlQ1VevHRE6P5HGnDAn+0Yr/dg/0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861733; v=1; x=1789466533;
 b=JWvNfjWgf7ukrdt4gC6LENfTtGxf6hReZebMLhAlTcqQa2PvtyEQBUDY8MWYY3173C2Fp8OP
 t+8h7beDta2ewHRVOAXWvVkfB0dA6u2HpmCuaUfMi853g5EVYC4RpLJ02quSXHekNm8cZ7ZAEwD
 i5XvSTaJDLFWdpL8RJiblY58=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f280b3f1737e38a0;
	Tue, 08 Sep 2026 10:02:13 +0000
X-Mizu-Trace-ID: f280b3f1737e38a0
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
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 1/8] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Tue,  8 Sep 2026 18:01:36 +0800
Message-ID: <20260908100143.47598-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
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

At the default period this is a couple of events per second per
device; the cost is zero while the static key is off.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c            |  5 +++++
 include/trace/events/iocost.h | 40 +++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2745bffcd5eef..c24daa9d72ee9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2238,6 +2238,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2274,6 +2275,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2460,6 +2463,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		ioc_refresh_vrate(ioc, &now);
 	}
 
+	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum);
+
 	spin_unlock_irq(&ioc->lock);
 }
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d60..2b9ff348a4f51 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -178,6 +178,46 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
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
+	TP_PROTO(struct ioc *ioc, int nr_active, u64 usage_us_sum),
+
+	TP_ARGS(ioc, nr_active, usage_us_sum),
+
+	TP_STRUCT__entry (
+		__string(devname, ioc_name(ioc))
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
+		__entry->period_us = ioc->period_us;
+		__entry->vrate = ioc->vtime_base_rate;
+		__entry->busy_level = ioc->busy_level;
+		__entry->nr_active = nr_active;
+		__entry->usage_pct = ioc->period_us ?
+			div_u64(usage_us_sum * 100, ioc->period_us) : 0;
+		__entry->running = ioc->running;
+	),
+
+	TP_printk("[%s] period=%uus vrate=%llu busy=%d active=%d usage=%u%% running=%d",
+		__get_str(devname), __entry->period_us, __entry->vrate,
+		__entry->busy_level, __entry->nr_active, __entry->usage_pct,
+		__entry->running
+	)
+);
+
 TRACE_EVENT(iocost_iocg_forgive_debt,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
-- 
2.43.0

