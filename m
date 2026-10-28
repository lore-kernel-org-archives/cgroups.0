Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.202
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198185;
	b=mVxxJ1fwtp6JQz/6pDb8KSDv1tPdRq8ZcV/1N8grTHVFcgwXsUuJVhz+pmnw4T6Tf9XR
	 BbEPHo5RRjZQWBmj4qYIFyvpmP9SNkA45IT0SsN/OPRv7xiYrCc4aljVJR0v4BiXocRhm
	 lxSHuiTQzB0j/xTdNxBFbUQnRr5MwJkt24eALQwVew46UuCXqMcy6Dlzv5obC4JFHZq9e
	 LQ/0dvZ6IFo2H97UZmrn+cfirqsi/g2rRwZahRIxj+nxichU18nXkZxyg43KzxYyInS8/
	 GnA9AkIbfj52vPGYNOhl+1WLtDY4kc8CpSnr3G3Oyk4xokPaDucEasUt7UQtTLCHV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198185;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Fb6/26WA939AMYDIj8vbwu42PlzOHlRCw3Lo25skONU=;
	b=mhSp9LhOQ7X4JSF9JwQ/MMOn9JmWbfW+HcmFlF335Qx2hYiu3B7meI6oCZvciWtMzL1l
	 y+Yo4Cukd1n9wRml73iw87Owi8wv0xF58TsxJuzE51jqPtussQ4QApWl4j5sFSNvnv/Et
	 ksXMpjwBMmnaw44mirdQEwdEE0Rnuk4eoVhymNdv0L3dHnNJbPAd+DalLB7MQ4CGGJc8w
	 2tVhuIaMIsnTIabYc1hbVl0hCRRD7PDl73dEAbIdFLfXMpSuSAvMWXXQF5h8AZBlb+VDw
	 ERXL5bjWxVqZf6kIBWxVvK1Kg3p9+bCuYx2etqvziSirBo6numnOhjAmhpeqO7rksLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W5iUN83u;
	arc=none smtp.remote-ip=95.215.58.202
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2C2606A333
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 14:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED2C2606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W5iUN83u
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=69I1hqUqyZ5FLhAiygZ4lbg2me7OFFPxt1wO9/rvtLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793198183; v=1; x=1793802983;
 b=W5iUN83uBYeykhY7n8JRMNUzPH7ANNOvMN19oSMo6IasGjaDblMulxH/bYkQVh0Fu5ihQknM
 mF8Va8wpAqtPTVpQN+NCN6aqmSfxUEPqvbhF8E+U6MRoDznI/1yu6I1jaUezGTMGd61IcEzMcdb
 bqd7uS0qYW5UkCNeSPa2/WlQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4bde4a18922df54b;
	Wed, 28 Oct 2026 14:36:23 +0000
X-Mizu-Trace-ID: 4bde4a18922df54b
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
Subject: [PATCH 4/5] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Wed, 28 Oct 2026 22:35:33 +0800
Message-ID: <20261028143534.135968-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028143534.135968-1-cui.tao@linux.dev>
References: <20261028143534.135968-1-cui.tao@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add iocost_ioc_tick, emitted once per period from ioc_timer_fn()
with the overall controller state: period_us, vrate, busy_level,
active iocg count and usage percentage.  It reads the values the
period ran in: the event is emitted before the vrate adjustment and
the period transition, so each tick reports the completed period.

It fires every period the controller is running, including steady
states, plus one final tick before the controller goes idle, which
reads active=0, making the transition to dormancy (e.g. a device
saturated entirely by uncharged IO) directly visible.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 MAINTAINERS                   |  1 +
 block/blk-iocost.c            | 13 +++++++++++
 include/trace/events/iocost.h | 43 +++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 598a5f65423d..a6a39279d266 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6832,6 +6832,7 @@ F:	block/blk-iocost.h
 F:	block/blk-iolatency.c
 F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
+F:	include/trace/events/iocost.h
 
 CONTROL GROUP - CPUSET
 M:	Waiman Long <longman@redhat.com>
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1e84232e6740..9f7f5e5f0ebb 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1839,6 +1839,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -1875,6 +1876,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse;
 
+		nr_active++;
+
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
 		 * iocgs from accumulating a large amount of budget.
@@ -2036,6 +2039,16 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * Everything the tick reports is final here: busy_level was just
+	 * computed, cur_period hasn't changed, nr_active and usage_us_sum are
+	 * complete, and vrate and period_us still hold the values this period
+	 * ran in. usage is wall time over wall time, summed over iocgs, and is
+	 * not capped at 100. Emit before the refresh below so the event reads
+	 * the completed period directly.
+	 */
+	trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d6..39229605f499 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -178,6 +178,49 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 	)
 );
 
+/*
+ * Periodic per-device summary, emitted once per period before the vrate
+ * adjustment and the period transition in ioc_timer_fn(). Unlike the
+ * state-change events above, this fires every period the controller is
+ * running, including steady states, and carries the overall controller state
+ * so basic monitoring doesn't require drgn.
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
+	),
+
+	TP_printk("[%s] period=%llu:%uus vrate=%llu busy=%d active=%d usage=%u%%",
+		__get_str(devname), __entry->cur_period, __entry->period_us,
+		__entry->vrate, __entry->busy_level, __entry->nr_active,
+		__entry->usage_pct
+	)
+);
+
 TRACE_EVENT(iocost_iocg_forgive_debt,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
-- 
2.43.0

