Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967872;
	b=nsUc0uQr8DBAwrw3jUWTyiVahDLQhwBb9jdhZFA2hKzXmyDYzA/N4M8knwiqKpOgVh5r
	 5hGxgv7oPDPH0umw/uXi4wA6axeEwX3fe9T9ZZNDakLXLwSL76I1YNuYecY5yHzz0N9Jn
	 EdAUBWC2IbH8DsrM3NO14+MBn9qs1DTOuEKzaXpUpULNUcpZTNhBEHeRaMvmcnxmeyFkU
	 PY1psw+jJ0Vi3OVlQlVw/TH9k60oHOnYPPnUHMq5r4IaSc9fyGuIFjqiPZ9M+3plaL7zU
	 vu0VAAJKCEPLjHG4HQgYfjdf/lBXC1OPyEqoaF0BUNbtNGkj0vlBnyqe/CzFstxfjlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967872;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=M7w+lcMd84BXD94nDGUSUppgCI2FJeMKCZLUv/sEq4k=;
	b=hL0+ovbhCY2kmsE9ydlaccj7gM1NGSPEf9YkVuSPu6Eak2SuffobChk6WQlMYhHisouZ
	 jJxz/mW6DOT2DYSw7AD71BoZ0//6Ijq/ZXgGxy8uq9CccRKbHaAjm87YsA2gQHGyEgFRk
	 dZzY8ZyRbc/2/P5APbV1c0NNEknyD3ycuCJ8Zey9OxIwASEd4awZ0umXbY7b+3LSCgOHD
	 4cTSEs03fQqpKoq865skFjHJtOXziuGdXkIeFVpq6Q/R5Ciz52llIUjzUccjd6y+XVVNK
	 uDjVR2TaDe0IHokCSCWzT44IcgvbKZSjkvgGpHYsMKKSeLRbOfTSTkJAU3NjfN+eH5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xYK5G+il;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E7D606A334
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 12:24:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22E7D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xYK5G+il
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=I+VC3zuj70/Ggc+NF+80ECDOvzawMqRE1+AbZCfHpoU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793967870; v=1; x=1794572670;
 b=xYK5G+ilob8/el9FwfbpiyHs544QedxsjztuIFqX6OmAvjkI0nURA+DZjhHGJZG9ds7p+8lH
 WEkjOPpz6KIt81psN6oyqbj8y+e/uSewVm7m7QBg9UWdWkGa06tRsn86kVkfzTtEhg0ZnXBm/nq
 sSQIQlXARcU7o+GhIwRxGFM0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3cf06a67f39bf5f0;
	Fri, 06 Nov 2026 12:24:30 +0000
X-Mizu-Trace-ID: 3cf06a67f39bf5f0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	alexei.starovoitov@gmail.com
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
	ameryhung@gmail.com
Subject: [RFC PATCH v13 2/4] blk-iocost: add iocost_ioc_tick tracepoint for per-period device summary
Date: Fri,  6 Nov 2026 20:23:54 +0800
Message-ID: <20261106122356.3224638-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106122356.3224638-1-cui.tao@linux.dev>
References: <20261106122356.3224638-1-cui.tao@linux.dev>
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

Add iocost_ioc_tick, emitted once per period from ioc_timer_fn() with
the overall controller state: period_us, vrate, busy_level, active iocg
count and usage percentage.  busy_level, cur_period, nr_active and
usage_us_sum are complete at the emission point.  usage is wall time
over wall time, summed over iocgs, and is not capped at 100.  vrate and
period_us reflect the current controller state, which an io.cost.qos
write may have changed mid-period.

The event fires every period the controller is running, including
steady states, plus one final tick before the controller goes idle, so
the transition to dormancy is directly visible.  The active iocg count
is only gathered when the tracepoint is enabled.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 MAINTAINERS                   |  1 +
 block/blk-iocost.c            | 18 +++++++++++++++
 include/trace/events/iocost.h | 43 +++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa647f5d37dd..2000a38dbc9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6852,6 +6852,7 @@ F:	block/blk-iocost.c
 F:	block/blk-iolatency.c
 F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
+F:	include/trace/events/iocost.h
 
 CONTROL GROUP - CPUSET
 M:	Waiman Long <longman@redhat.com>
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c3d195fe4a89..d2007b7b73bf 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2349,6 +2349,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc_now now;
 	LIST_HEAD(surpluses);
 	int nr_debtors, nr_shortages = 0, nr_lagging = 0;
+	int nr_active = 0;
 	u64 usage_us_sum = 0;
 	u32 ppm_rthr;
 	u32 ppm_wthr;
@@ -2546,6 +2547,23 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
+	/*
+	 * busy_level, cur_period, nr_active and usage_us_sum are complete
+	 * here. usage is wall time over wall time, summed over iocgs, and
+	 * is not capped at 100. vrate and period_us reflect the current
+	 * controller state, which an io.cost.qos write may have changed
+	 * mid-period. Emit before the refresh and the period transition.
+	 */
+	if (trace_iocost_ioc_tick_enabled()) {
+		struct ioc_gq *active_iocg;
+
+		list_for_each_entry(active_iocg, &ioc->active_iocgs,
+				    active_list)
+			nr_active++;
+
+		trace_iocost_ioc_tick(ioc, &now, nr_active, usage_us_sum);
+	}
+
 	ioc_adjust_base_vrate(ioc, rq_wait_pct, nr_lagging, nr_shortages,
 			      prev_busy_level, missed_ppm);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index eb711343ce4f..ea7ec3c1da5c 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -181,6 +181,49 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
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
+		__field(u64, usage_pct)
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
+	TP_printk("[%s] period=%llu:%uus vrate=%llu busy=%d active=%d usage=%llu%%",
+		__get_str(devname), __entry->cur_period, __entry->period_us,
+		__entry->vrate, __entry->busy_level, __entry->nr_active,
+		__entry->usage_pct
+	)
+);
+
 TRACE_EVENT(iocost_iocg_forgive_debt,
 
 	TP_PROTO(struct ioc_gq *iocg, const char *path, struct ioc_now *now,
-- 
2.53.0

