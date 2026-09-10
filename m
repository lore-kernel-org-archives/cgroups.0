Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85552453A5E
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 12:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045129; cv=none; b=eoaI1PGYh5iI6cMsAJQqwkylHI9Q2tpLlPcyemWq5qteauG/jEizk3OjYi8UNjJAOJYPbkx8TzgzExH1RWaA5AA1WBNwejOzUChECejfoqVEOLYERURC0HCqkigdul++i+ljIgTPiExwWx1yozhqYdhb5kfFfVuwQ3KHEZm3ZCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045129; c=relaxed/simple;
	bh=0fJmoDVgXoCT6wg71trk+r4GMKglV+8D+hnxVKMiMh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZrbdwtcPOh+8Y+5BvzRjNElkYIYspozVBxSbCxUj/Th7J3towrfBXYEHhH023pUvsebT6ULvHMbHBStWFTF/Oqs9Ddautv+b0S5YuXBHWp9VUDFMZ7atGnk8zQs7PC/23uDStO9IbG4mcJ38LAQX7SFqQC79kqDnB6ALa0R1e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j6axNBtV; arc=none smtp.client-ip=95.215.58.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j6axNBtV"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0fJmoDVgXoCT6wg71trk+r4GMKglV+8D+hnxVKMiMh8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789045123; v=1; x=1789649923;
 b=j6axNBtVTV97ABwliYcSHsaak+4cZhBU4WSPGel1gWMOo3ldJzE9nlcG2ldSXxj8kz3F5MEM
 z594oHJBO6Yqv9UgLriMM0qEUhIq1CH4uMnQlDbT4PN8o4zFGBN/9aEPHsbcKZLDA0VMglRUXZp
 N8TBE7oHd+qGYsfZmPLFe1+s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4fa7f97bbfba81e3;
	Thu, 10 Sep 2026 12:58:43 +0000
X-Mizu-Trace-ID: 4fa7f97bbfba81e3
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
	cuitao@kylinos.cn
Subject: [RFC PATCH v2 3/5] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Thu, 10 Sep 2026 20:58:15 +0800
Message-ID: <20260910125817.223354-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910125817.223354-1-cui.tao@linux.dev>
References: <20260910125817.223354-1-cui.tao@linux.dev>
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
index 182601ad783f..bccdbd2496d8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2244,6 +2244,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2280,6 +2281,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2466,6 +2469,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		ioc_refresh_vrate(ioc, &now);
 	}
 
+	trace_iocost_ioc_tick(ioc, nr_active, usage_us_sum);
+
 	spin_unlock_irq(&ioc->lock);
 }
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d6..2b9ff348a4f5 100644
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

