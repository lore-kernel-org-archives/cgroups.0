Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242186;
	b=IiFUPIuJhnOdZCrkv2txZW4iBA4RulqVWzLJFCyQyCQ04RBTGC0Mv1GhnqvJg5zLed3m
	 +LjSl65EEr6UGSNVcBJxesLtw3KHkJrVJ/pxy0XSyx+68Bf4sOdmOEn6jZyJwH71wW8Tc
	 OFQiXZ4cxxAYiATZwJnJGnkG8rINpaunhmuEWl5I659EhzUvC9kN9y0lVc/gSphLuygFv
	 v2Iw0+Gg5JaHAFOTO4smni+et8vbm20zJgpvJV20iwvsZFZsbrw9QSWbrujSOQpa6+3xL
	 JMPjb+VoRaoEWipaWPgNpCi1Arjai8yk7HFDWwRb/mB8Ktzxyb9bj+vIqpYXWb8Jzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vX/Ij4B+c+ygkXkYe3AnRw/EZD7Awd9zH7+Rm7r2cHs=;
	b=xpbenNsvcFek3HsbPaS0y/oCucbS0E562uv4QjFcdU9sza9fgtt0+wOsdVyfnM4Ugtty
	 AdcOmtDL8eqY0SyEODq1H/x7/KviEOemYwwqAwuaIQLsQjCd/kFdofAjFzkv2VA3yYh8M
	 W63M7a2GX4sqPnpMqdGyznNTdBi4VeRo9D5dniJWajJ4K3k+2w8w5BB0cJILJDbWTLUwx
	 xyqKsahf6HgoMNWY1tzNK+OVAWtPNvbzNnDBQQv7Fl3HJnNAhSyUnF7TCi0po4Img1EAH
	 xQbFi/JhmS7jYGk20U5mN+0uAQ58iFTEVFXKGIc2xdPkSUh2I1pDn6vGUSIHxi80wkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXb7r4BA;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3E606EE80
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEE3E606EE80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXb7r4BA
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so11776605e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242184; x=1794846984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vX/Ij4B+c+ygkXkYe3AnRw/EZD7Awd9zH7+Rm7r2cHs=;
        b=PXb7r4BAUYHVB11xOTCwg70XBVpyKICRH4gDHGkCFyLFKrzpNnfzGs7QBlZDvX6T6e
         ZQgzt5PGdBg0hnCW1hTd/JXEsFozylta4SWID31BWnYC8X/A9SN64pp31yx06JKh9EBq
         J/W8RfH3QHrlbOI676TPQTCa9ZGqkmlR+WuuaBHs5hMfg/e74UJR8B0e1cnPYJXDEgou
         W4uyv7MqDDNM/ehNzpY0QMb1XNKx6ZZX6c1R4DoNX3b/Ed3V9wNyx+mpfCctDucyatx5
         5FCpz9Rp92+YDUXaLjP7jXwaCohedqRL2/1DyKasi/lg1c5X+Y+hxPsCI55yJIK/7MoW
         U5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242184; x=1794846984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vX/Ij4B+c+ygkXkYe3AnRw/EZD7Awd9zH7+Rm7r2cHs=;
        b=NbwNhzPG+lTk53XemHtGexhIPuYV3xy6mfP47TdFGwwwQRUB4Q+/Wc8IvHOwhFfnvV
         xE4TPhBRYwTQL6lVUyC6QExSVM0niLsZQTqB2uIdK+QpDFs9EGwQwevogoOWpKmQNdTN
         zgqYXrrMY5f1cgClVQQl+doGdRieA246zaFMj6pgWz8MxOxWpDZj2SvjPJ9xEijRdb5z
         oS1/VcaZYcK3I6B8b4ihXBW2GTq6psBn4RmMXL+Z7i6mcctrXwBATnxuCaKIx9GSDhc2
         tofm4fhVy1Jrn7SgXKqO03e33w4fnAiJdjY7zD8CEgwwXSLWAPtoucC8ToJExiHcUj2l
         TkEQ==
X-Gm-Message-State: APuU4Z/piShmeN+2o9nsmr1Q8RRPbJSCoxbFIdyDdoX2ZkTICCUApyRB
	ut7CqsQfUQ156xOQIp2T2hxjPMSWstLDEZAkY5lMCEXPZeblhFAOXSIf
X-Gm-Gg: AYBFou2mbme6YId2GU83os5kCEXH1jZAYicqy7fDjyNtWusi1K6AHLY/sZv4HmDRspp
	5U6SerxrkVRejFO7TlnMRAt/uM23O0XYfIrUshCrs7WAQEYMCskqDc3CrdErovPQeDbcYdqiL0j
	5PXPJ+r008LExfNdeyBnTcTLhGbZ+HrLwGEeikmzZMlldGN9xzDqAsMHFPdk0E+iBlRxY6htIib
	reDphx1rF7Eyd+wENJ8XnYowC1Ng9rlikMVoF98m8o60AK6eho/mZxX0VQdxK1ASOmRGeKR11T7
	Q7WRnChLX7fDu4BtTqvQtPGpRdsIoitBsWt+6lXeYFjh55i8qnP/0pyfN8/4dVWC1LPdmjQGBUt
	yr+nkn/CWAju1hssDN97iUtkEO1LRrH1fU/MJRaBbg2sIFIeO7YgPLAchdGsy0ceV9N/a+4YFVZ
	0ZNMN2CpmJ+V5D8+xFW78CLZaxnUBq9y0HpvP9R4msOAw9vu6ZrCmfd+5cPjRvI9CTyT4kqfzzT
	RIOZ4Y/u9a1p60C8fh87PEfxBbQbYa1u0wVMS8xJPpmELEX5SNFTJkt4ebaP65iwKoBG0q/ona4
	H/KXaTQ6w6S+AsndzTata0lDCg==
X-Received: by 2002:a05:600c:800e:b0:4b3:ad9d:e21 with SMTP id 5b1f17b1804b1-4b963c7f2f2mr85628795e9.12.1794242183820;
        Mon, 09 Nov 2026 08:36:23 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:23 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 02/29] sched/deadline: Do not access dl_se->rq directly
Date: Mon,  9 Nov 2026 17:35:48 +0100
Message-ID: <20261109163616.195264-3-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com>
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

From: luca abeni <luca.abeni@santannapisa.it>

Make deadline.c code access the runqueue of a scheduling entity saved in
the sched_dl_entity data structure. This allows future patches to save
different runqueues in sched_dl_entity other than the global runqueues.

Move dl_server_apply_params call in sched_init_dl_servers as the rq_of_dl_se
function will return the correct deadline entity only if the dl_server flag
is set.

Add a WARN_ON on the return value of dl_server_apply_params in
sched_init_dl_servers as this function may fail if the kernel is not
configured correctly.

Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/deadline.c | 46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 57c7a8802d8e..00f584c7bbd5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -869,7 +869,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * and arm the defer timer.
 	 */
 	if (dl_se->dl_defer && !dl_se->dl_defer_running &&
-	    dl_time_before(rq_clock(dl_se->rq), dl_se->deadline - dl_se->runtime)) {
+	    dl_time_before(rq_clock(rq), dl_se->deadline - dl_se->runtime)) {
 		if (!is_dl_boosted(dl_se)) {
 
 			/*
@@ -1171,11 +1171,11 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 			 * of time. The dl_server_min_res serves as a limit to avoid
 			 * forwarding the timer for a too small amount of time.
 			 */
-			if (dl_time_before(rq_clock(dl_se->rq),
+			if (dl_time_before(rq_clock(rq),
 					   (dl_se->deadline - dl_se->runtime - dl_server_min_res))) {
 
 				/* reset the defer timer */
-				fw = dl_se->deadline - rq_clock(dl_se->rq) - dl_se->runtime;
+				fw = dl_se->deadline - rq_clock(rq) - dl_se->runtime;
 
 				hrtimer_forward_now(timer, ns_to_ktime(fw));
 				return HRTIMER_RESTART;
@@ -1186,7 +1186,7 @@ static enum hrtimer_restart dl_server_timer(struct hrtimer *timer, struct sched_
 
 		enqueue_dl_entity(dl_se, ENQUEUE_REPLENISH);
 
-		if (!dl_task(dl_se->rq->curr) || dl_entity_preempt(dl_se, &dl_se->rq->curr->dl))
+		if (!dl_task(rq->curr) || dl_entity_preempt(dl_se, &rq->curr->dl))
 			resched_curr(rq);
 
 		__push_dl_task(rq, rf);
@@ -1482,7 +1482,7 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 
 		hrtimer_try_to_cancel(&dl_se->dl_timer);
 
-		replenish_dl_new_period(dl_se, dl_se->rq);
+		replenish_dl_new_period(dl_se, rq);
 
 		if (idle)
 			dl_se->dl_defer_idle = 1;
@@ -1579,14 +1579,14 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
 void dl_server_update_idle(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	if (dl_se->dl_server_active && dl_se->dl_runtime && dl_se->dl_defer)
-		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
+		update_curr_dl_se(rq_of_dl_se(dl_se), dl_se, delta_exec);
 }
 
 void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
 	/* 0 runtime = fair server disabled */
 	if (dl_se->dl_server_active && dl_se->dl_runtime)
-		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
+		update_curr_dl_se(rq_of_dl_se(dl_se), dl_se, delta_exec);
 }
 
 /*
@@ -1795,7 +1795,7 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  */
 void dl_server_start(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = dl_se->rq;
+	struct rq *rq;
 
 	dl_se->dl_defer_idle = 0;
 	if (!dl_server(dl_se) || dl_se->dl_server_active || !dl_se->dl_runtime ||
@@ -1805,16 +1805,16 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 	/*
 	 * Update the current task to 'now'.
 	 */
+	rq = rq_of_dl_se(dl_se);
 	rq->donor->sched_class->update_curr(rq);
-
 	if (WARN_ON_ONCE(!cpu_online(cpu_of(rq))))
 		return;
 
 	trace_sched_dl_server_start_tp(dl_se, cpu_of(rq), dl_get_type(dl_se, rq));
 	dl_se->dl_server_active = 1;
 	enqueue_dl_entity(dl_se, ENQUEUE_WAKEUP);
-	if (!dl_task(dl_se->rq->curr) || dl_entity_preempt(dl_se, &rq->curr->dl))
-		resched_curr(dl_se->rq);
+	if (!dl_task(rq->curr) || dl_entity_preempt(dl_se, &rq->curr->dl))
+		resched_curr(rq);
 }
 
 void dl_server_stop(struct sched_dl_entity *dl_se)
@@ -1858,9 +1858,9 @@ void sched_init_dl_servers(void)
 
 		WARN_ON(dl_server(dl_se));
 
-		dl_server_apply_params(dl_se, runtime, period, 1);
-
 		dl_se->dl_server = 1;
+		WARN_ON(dl_server_apply_params(dl_se, runtime, period, 1));
+
 		dl_se->dl_defer = 1;
 		dl_se->dl_freq_invariant = 1;
 		setup_new_dl_entity(dl_se);
@@ -1870,9 +1870,9 @@ void sched_init_dl_servers(void)
 
 		WARN_ON(dl_server(dl_se));
 
-		dl_server_apply_params(dl_se, runtime, period, 1);
-
 		dl_se->dl_server = 1;
+		WARN_ON(dl_server_apply_params(dl_se, runtime, period, 1));
+
 		dl_se->dl_defer = 1;
 		dl_se->dl_freq_invariant = 1;
 		setup_new_dl_entity(dl_se);
@@ -1910,7 +1910,7 @@ int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 perio
 	u64 old_bw = (init || !dl_se->dl_bw_attached) ? 0 :
 		     to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	u64 new_bw = to_ratio(period, runtime);
-	struct rq *rq = dl_se->rq;
+	struct rq *rq = rq_of_dl_se(dl_se);
 	int cpu = cpu_of(rq);
 	struct dl_bw *dl_b;
 	unsigned long cap;
@@ -1957,7 +1957,7 @@ int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 perio
 static int __dl_server_attach_bw_locked(struct sched_dl_entity *dl_se,
 					struct dl_bw *dl_b, int cpus)
 {
-	struct rq *rq = dl_se->rq;
+	struct rq *rq = rq_of_dl_se(dl_se);
 	unsigned long cap;
 
 	/*
@@ -1985,7 +1985,7 @@ static int __dl_server_attach_bw_locked(struct sched_dl_entity *dl_se,
 static void __dl_server_detach_bw_locked(struct sched_dl_entity *dl_se,
 					 struct dl_bw *dl_b, int cpus)
 {
-	struct rq *rq = dl_se->rq;
+	struct rq *rq = rq_of_dl_se(dl_se);
 
 	/*
 	 * If the server is still active (on_rq), dequeue it via
@@ -2030,7 +2030,7 @@ static void __dl_server_detach_bw_locked(struct sched_dl_entity *dl_se,
  */
 int dl_server_attach_bw(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = dl_se->rq;
+	struct rq *rq = rq_of_dl_se(dl_se);
 	int cpu = cpu_of(rq);
 	struct dl_bw *dl_b;
 	int cpus, ret;
@@ -2071,7 +2071,7 @@ int dl_server_attach_bw(struct sched_dl_entity *dl_se)
  */
 void dl_server_detach_bw(struct sched_dl_entity *dl_se)
 {
-	int cpu = cpu_of(dl_se->rq);
+	int cpu = cpu_of(rq_of_dl_se(dl_se));
 	struct dl_bw *dl_b;
 	int cpus;
 
@@ -2096,12 +2096,12 @@ void dl_server_detach_bw(struct sched_dl_entity *dl_se)
 int dl_server_swap_bw(struct sched_dl_entity *detach_se,
 		      struct sched_dl_entity *attach_se)
 {
-	struct rq *rq = detach_se->rq;
+	struct rq *rq = rq_of_dl_se(detach_se);
 	int cpu = cpu_of(rq);
 	struct dl_bw *dl_b;
 	int cpus, ret;
 
-	WARN_ON_ONCE(attach_se->rq != rq);
+	WARN_ON_ONCE(rq_of_dl_se(attach_se) != rq);
 
 	scoped_guard (raw_spinlock, &dl_bw_of(cpu)->lock) {
 		dl_b = dl_bw_of(cpu);
@@ -2162,7 +2162,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		p = dl_task_of(dl_se);
 		rq = task_rq_lock(p, &rf);
 	} else {
-		rq = dl_se->rq;
+		rq = rq_of_dl_se(dl_se);
 		rq_lock(rq, &rf);
 	}
 
-- 
2.56.0

