Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474084570EC
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 07:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754748; cv=none; b=UG0rD2FYcwm8ShzaEYhnjlZ8xXdoaMaY/Bimn2WPCjgFU3OKJiVn+pm/ul2NZK2rCzYWGSCu5/Fe0yKxn2Qg4khCtX58OnhtpGrD+iRFl1L7jHFTDP/ub0Wj8ApYYSUS4ltC//6WweJlPNLu+ZC4S+6i9NzaGpIM6Pl/tz6yPg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754748; c=relaxed/simple;
	bh=abmLV1yM6w4vl9g/CWfHiQmvAmJFhF9d+95Vf3hTPhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkWdq8Ko9Uy/GHNlze6GQJWgdJNKRa5WyQTe5NdQcVLOUfQiJPvh18k9Fg7NhwyxOspsyKjy5N+S03GtP9jm6DLvlS4qfZ4uW3+R2p/ZzQFbzpWr/CLPWK13OgUQyaAM7OGxogFcLL+y395vMbZBEXpybnjK283/0x1sT0pqvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RaMX5AOb; arc=none smtp.client-ip=95.215.58.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RaMX5AOb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=abmLV1yM6w4vl9g/CWfHiQmvAmJFhF9d+95Vf3hTPhc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790754743; v=1; x=1791359543;
 b=RaMX5AOb2i30G2pf3cMXTBGDkps1T9xpfJ+yX6PtsHHL+QuIwxYS7Y8mNk3HeMBRbGSmK/9m
 EIFmT3TYMtjDfgMww/EdS55c1RzjP9CFi1MyHI7kIxeCcsnZBtpVvZ+pnuQSqbcx0lSvz7bOwXC
 ZbASWrBtQkiZBGwY9AJmPIVA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f1a53e62aaa0a347;
	Wed, 30 Sep 2026 07:52:23 +0000
X-Mizu-Trace-ID: f1a53e62aaa0a347
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
Subject: [RFC PATCH v8 3/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Wed, 30 Sep 2026 15:51:53 +0800
Message-ID: <20260930075154.189958-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930075154.189958-1-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 block/blk-iocost.c            | 12 ++++++++++
 include/trace/events/iocost.h | 44 +++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index bc83827cced9..64744266cfd3 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2290,6 +2290,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2326,6 +2327,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2487,6 +2490,15 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * Everything the tick reports is final here: busy_level was just
+	 * computed, running and cur_period haven't changed, nr_active and
+	 * usage_us_sum are complete, and vrate and period_us still hold
+	 * the values this period ran in.  Emit before the refresh below
+	 * so the event reads the completed period directly.
+	 */
+	trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d6..79773e82d42c 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -178,6 +178,50 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
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
+		__entry->running = ioc->running;
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

