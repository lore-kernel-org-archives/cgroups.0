Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2224642A149
	for <cgroups@vger.kernel.org>; Sat,  3 Oct 2026 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791031297; cv=none; b=fQD2HoJinOwnz1qgVBp1J9r0gPr6uMiFS5U9bAcEXGNf9qdjXjVlJ/aEl14GF00frQXvYfSUw2Y8SMua8o22K1y431wyUTRPvdoeT3P5+88K3LqEFufpy9/QBi8tpqb3nhOtUVXDuNgGPdfV0HJQ8yTF5UowJBVziBGw+PAlQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791031297; c=relaxed/simple;
	bh=hpDdSYxNaA0VddVe2upzKYq8d9H+b1b342TFmSJuqKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvV6ZokirR40ORbaJ5zFuKvuR26aRNA7PAMydJO6BzNaSoVY+gxw+cHyy3LMTAg9GiDEKtlW0d7A6s/VLQ7lYTurRiWhvBHV8AgR1pxUqEu6YI2c+T7vyn7JRbhZLNNqh+1qpBezolo+sgdtkpC92DNLU1Au7RYma2fetz59RA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O0O9mkKW; arc=none smtp.client-ip=91.218.175.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O0O9mkKW"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hpDdSYxNaA0VddVe2upzKYq8d9H+b1b342TFmSJuqKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791031293; v=1; x=1791636093;
 b=O0O9mkKWYWDxVrLcDv+jKSxk8P9mnWPpONgWmykIAqAWjsgln4BI6ABhm4F3nX2OpZUqMIks
 a/rcQTEETO1sdV1aoqC64ue/AAn0b0u4BEbGe/SUVBzp6XX6rIYhblXeKu3AOaucoaF/PhiP1q0
 4uAaST0VkkZb8sNF7W7+pgQ4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ffe0a7b16a3057b6;
	Sat, 03 Oct 2026 12:41:32 +0000
X-Mizu-Trace-ID: ffe0a7b16a3057b6
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
Subject: [RFC PATCH v10 3/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Sat,  3 Oct 2026 20:40:44 +0800
Message-ID: <20261003124045.1289305-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003124045.1289305-1-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add iocost_ioc_tick, emitted once per period from ioc_timer_fn()
with the overall controller state: period_us, vrate, busy_level,
active iocg count, usage percentage and whether the controller
still has active iocgs.  It reads the values the period ran in:
the event is emitted before the vrate adjustment and the period
transition, so each tick reports the completed period.  ioc->running
has not transitioned to IOC_IDLE at the emit point, so the running
field reports the active iocg list instead.

It fires every period the controller is running, including steady
states, plus one final tick before the controller goes idle, which
reads active=0 running=0, making the transition to dormancy (e.g. a
device saturated entirely by uncharged IO) directly visible.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c            | 14 +++++++++++
 include/trace/events/iocost.h | 45 +++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 509ae36f99edf..a565892b1be07 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2278,6 +2278,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2314,6 +2315,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2475,6 +2478,17 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * Everything the tick reports is final here: busy_level was just
+	 * computed, cur_period hasn't changed, nr_active and usage_us_sum
+	 * are complete, and vrate and period_us still hold the values
+	 * this period ran in.  Emit before the refresh below so the
+	 * event reads the completed period directly; ioc->running has
+	 * not transitioned to IOC_IDLE yet, so the running field reports
+	 * the active iocg list instead.
+	 */
+	trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d60..dc14c574894de 100644
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
+	TP_PROTO(struct ioc *ioc, const struct ioc_now *now,
+		 int nr_active, u64 usage_us_sum),
+
+	TP_ARGS(ioc, now, nr_active, usage_us_sum),
+
+	TP_STRUCT__entry (
+		__string(devname, ioc_name(ioc))
+		__field(u64, cur_period)
+		__field(u32, period_us)
+		__field(u64, vrate)
+		__field(int, busy_level)
+		__field(int, nr_active)
+		__field(u32, usage_pct)
+		/* whether the controller still has active iocgs */
+		__field(int, running)
+	),
+
+	TP_fast_assign(
+		__assign_str(devname);
+		__entry->cur_period = atomic64_read(&ioc->cur_period);
+		__entry->period_us = ioc->period_us;
+		__entry->vrate = ioc->vtime_base_rate;
+		__entry->busy_level = ioc->busy_level;
+		__entry->nr_active = nr_active;
+		__entry->usage_pct = now->now > ioc->period_at ?
+			div64_u64(usage_us_sum * 100,
+				  now->now - ioc->period_at) : 0;
+		__entry->running = !list_empty(&ioc->active_iocgs);
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

