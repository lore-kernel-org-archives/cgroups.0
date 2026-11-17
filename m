Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924681;
	b=GyYLDimNEjAfzfyaFPDj/n9T9uE/tfJ1H1lZTK7W2YRYaTPvIGGwWwoEjZWQIHt5qCAn
	 trK1ShzZ8hEgFvODf7V5RkM93XMr1uBdfGSzuMSJ9OILqlUXfkFC8jE25sjnk0frvkzAr
	 NuB+cesA1bw2+ilfEsWXuIfTura6CMh/OCk8KsgLGo6xIRlmrV2gMGsYDBIkCwQkQUUNg
	 Yeznr4mtUeoApxPABroKqC74BWHW01u9XvMYs+bdaAmwEvqb/zfYIq6eFGpt2vQd4IeCe
	 CDsJCHyt4p+QFmn1DF1wZI/wmCuhlgJRFh7sfvhZcM1psecu0RhrXkfY1RUlFFe8mmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924681;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Tg/8mhy1UTntVaEismgGplj1y67KnZAGv1coJ33+l08=;
	b=WV15Cud9cBk56hjKMIIc8saWy7UpICXqhlYF58x2Yxhm+U3QY7QtkVbhDspQv4F3cttB
	 TcDDWZaRW43GhIvGJSsyQrr9D7gweSfXXkqEvXP8Wh5dLrliWFO46X5Pl66p4RIS+TlGM
	 o0LvMP/EFPgL3X40W6pKNhwtXmqGylYfLAKdxNo0ztd4H7bIID4XCEcFul/M9OfFImsPO
	 AcTiQgzzWH7kI442nnZ0Ha4sduEZN2LgJpjY41TKBq+4bhcwSMWe7S05I3C8tsdt2TMIs
	 tz7gsifjS3mb1Mt2fKhSYzc+qgCnCxrr9BOFGJbYgiOJSqSz4pSL2j+mtVRZQ5PhdMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iKx2Kx5f;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FB5606EF9E;
	Tue, 17 Nov 2026 14:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95FB5606EF9E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iKx2Kx5f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924671;
	bh=Tg/8mhy1UTntVaEismgGplj1y67KnZAGv1coJ33+l08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKx2Kx5fWya3PahtOFxqVTNYwi9XU6Qo3f9JCbseh5lWkDtVBp8HztrJ40WpOSMSE
	 XVP98CmpLI8HDXfaq4xpfKom8WWPLOZtqZTkfzo+Js0NAiv2YNQo82YuyWwpXGRPs+
	 Ax7eQMPUT3Ud6wuSBBgDfjPU8Ne6PaXT0haKCaYD+X6u9tecudwT2sqLjHQ/l71qQ/
	 bE4X5i9TTNnuFIhgEHBm55WmhZJyiMbMbqSdwN3++pxOpinfHhAjjGpgHGAeDtnMB+
	 O7NnLAdSv0r72vc/UItbefuHfrNrRZMTPzNZiocUEL22w48Q7RLCryg7KQFylTo/kz
	 1kxB1txicVMtA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV66VwwzRHT;
	Tue, 17 Nov 2026 09:11:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v7 36/40] sched/deadline: Check the runtime of a task whose parameters change
Date: Tue, 17 Nov 2026 09:10:57 -0500
Message-Id: <a7e0d6e42bb46c9304699dbfc63dd24efe842ead.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

Commit 40767b0dc768 ("sched/deadline: Fix deadline parameter
modification handling") lets new parameters take effect at the next
period. So sched_setattr() cannot give a task a fresh runtime.

But admission control counts the new bandwidth at once. When a task
shrinks its reservation, the runtime left from the old one is not
checked against the new one. A comment in sched_dl_overflow() names
the gap: the old bandwidth should stay counted until the 0-lag time.

So a running task can shrink its reservation, and still run on the old
one. Other tasks can meanwhile be admitted into the bandwidth it gave
back. On v7.4-rc2, a task of 50ms every 100ms changed to 10ms every
100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule after a change of parameters, as
the previous patch does for a task that enters the class.
__setparam_dl() marks a change of the runtime, the deadline or the
period. The next enqueue then calls update_dl_entity(). It starts a new
period, or reduces the runtime of a constrained task, if the runtime
left does not fit. The task gets no more than a wakeup would give it. A
boosted task runs on the parameters of its donor. So it keeps the mark
until an enqueue after its deboost.
A larger reservation still takes effect at the next period.

The enqueue flags cannot tell a change of parameters: a cgroup move
also uses ENQUEUE_MOVE. Without the mark, a task that waited behind
others could fail the check, and get a later deadline for no reason.

The change_running_new_params case of deadline_bw_test, added later in
this series, tests this. change_boosted_new_params tests a task that
changes its parameters while boosted. Both fail on v7.4-rc2 and pass
with this patch.

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 26 +++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2f2f59402f09..5bb41f350936 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -715,6 +715,10 @@ struct sched_dl_entity {
 	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
 	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
 	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
+	 * @dl_new_params tells if sched_setattr() changed the runtime, the
+	 * deadline or the period. The next enqueue that is not boosted checks
+	 * the runtime left against them, and clears it.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -729,6 +733,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
 	unsigned int			dl_bw_oncpu       : 1;
+	unsigned int			dl_new_params     : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b650c37ae561..f1d259df8f2a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2785,7 +2785,16 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
+	bool new_params = dl_se->dl_new_params;
+
 	WARN_ON_ONCE(on_dl_rq(dl_se));
+	/*
+	 * A boosted task runs on the parameters of its donor. Keep the mark
+	 * until an enqueue checks the runtime against its own: the one at
+	 * the deboost, or at a wakeup.
+	 */
+	if (!is_dl_boosted(dl_se))
+		dl_se->dl_new_params = 0;
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -2834,12 +2843,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
-	} else if ((flags & ENQUEUE_CLASS) && !is_dl_boosted(dl_se)) {
+	} else if (((flags & ENQUEUE_CLASS) || new_params) &&
+		   !is_dl_boosted(dl_se)) {
 		/*
-		 * The task enters the class runnable. It may come back before
-		 * its deadline, with the runtime left from older parameters.
-		 * Check that runtime against the new parameters, as a wakeup
-		 * does.
+		 * The task enters the class, or its parameters change, while
+		 * it is runnable. It may have runtime left from older
+		 * parameters. Check that runtime against the new parameters,
+		 * as a wakeup does.
 		 */
 		update_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_MOVE) &&
@@ -4866,6 +4876,11 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	u64 period = attr->sched_period ?: attr->sched_deadline;
 	bool held;
 
+	if (attr->sched_runtime != dl_se->dl_runtime ||
+	    attr->sched_deadline != dl_se->dl_deadline ||
+	    period != dl_se->dl_period)
+		dl_se->dl_new_params = 1;
+
 	/*
 	 * Change the bandwidth that the runqueue counts here, with the
 	 * parameters. A task that priority inheritance boosted into the
@@ -4999,6 +5014,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

