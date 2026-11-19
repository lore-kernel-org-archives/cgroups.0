Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119388;
	b=jfIzfuNlLu31WcVdg19iZ9eGve3sRous9JCPfo1oF+jGNHFXxuObcS2pixGtFMhX0Q0P
	 SrIuUDSAuOHFVM8LnvQ6pVJHDkpAOZR8pcixzMACcMRYoTN4B79wJ2/DKqHscB/EfD4sO
	 P3fn989E+QeqTk8bOajnnu9AhLiHTjxL6hIyPKRWe+wj8g9fWXgS99hjEmO8/eBxjcogO
	 Ig4JSPl678KnZe20yzMLViepYxVqTVvJAY72B16qUYOvdMocZU0XnUNVQCjXdQkFpH42h
	 bSvVx5Jsoa7e+e3QNtDa4SGUBlT0Q6xyXk1ryE66L+PEhjMms2kl0xzaQeDn0kp2VMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119388;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GezWjWrQJ5IW6qykfDU7HVQbVcRc8oRe51PIbCtx9s8=;
	b=BkQvYevnCfTmEeoTwXgFVhlk+yJUBgE0YNq1qUe3/4/Ep5AzWuBIa9b8KopAy/QB3GbK
	 3vpHZk81T4XYXv73abYGbDbrZT3x9WOIVum0Z/RP5x1fEdkg+9yid7ErlT4ejj4eIn+FG
	 Xb0dPgBBStyfV5rjVtJPs4M9/aWoQy06c8SbqNQrEhUXy6JGNjf8VxMSZ+u7XGsR73yOh
	 Evwnzm+Goc24LHH4pL3JyEvsmB/OPu1WJ6PWELPENvKMNi9q+UWczXJshVlD5wbNbC03H
	 x9zLia+Q7vaxTVleMsdG7GTx5bH8XwYXPw8ER+SQBcvDCz8ZzFSx8Dt4rozcnJAToSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pbPeCFF9;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D398560A6F52;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D398560A6F52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pbPeCFF9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119383;
	bh=GezWjWrQJ5IW6qykfDU7HVQbVcRc8oRe51PIbCtx9s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbPeCFF9Kv5NkvldH6jwNBjXRW8uJaaPtfylPYaeN92lEqkNK3mZvAwwC34q6v1Tm
	 vI5DQVAzCEhoPaJmeq5oEFWb9Ccw/BvG14/TQdEmuC906vsrBwhVVwLW1FhNolHHSV
	 eiGFV0CX/2HzGWIVxiA50f/chAKCLMJKK/rIkD7c8mozCDu6/IaM6EGg5HBqMlPLWB
	 qT7aIfiOY+lJbzO6lLD4IzHIESLrrrOcU12hMXods/9hlBVEpPbm+ILPoFjrqoMdSn
	 t4uTSafk5RiWtDlnhECtLZ+3nJa0cMasNnGv5ntOkTahIe0tx404D+w8SeMszUViS8
	 yq+LHwy0RydCg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVZ6hxlzT9h;
	Thu, 19 Nov 2026 15:16:22 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v8 30/33] sched/deadline: Cap the runtime left of a constrained task at dl_runtime
Date: Thu, 19 Nov 2026 15:16:09 -0500
Message-Id: <886008fc50ab6666b44b8e5ec32db5a7c4b1230f.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

sched_setattr() can change the parameters of a SCHED_DEADLINE task. The
task keeps its runtime and its absolute deadline: the new parameters
take effect at the next period. At the next wakeup, update_dl_entity()
checks the runtime left against the new parameters.

For a constrained task, that check uses the density, dl_runtime /
dl_deadline. Commit 2317d5f1c349 ("sched/deadline: Use deadline instead
of period when calculating overflow") made dl_entity_overflow() compare
with it: "We care about if the runtime can make its deadline, not its
period." Commit 3effcb4247e7 ("sched/deadline: Use the revised wakeup
rule for suspending constrained dl tasks") then cut the runtime of a
constrained task that overflows to density * laxity. Both bound the
runtime by dl_runtime only while the deadline is at most dl_deadline
ahead.

A change to a shorter dl_deadline breaks that. The old deadline can be
farther ahead. The check then keeps more runtime than the new
dl_runtime, or computes more. For example, take a task of 50ms every
100ms with 49ms left. Changed to 8ms in 20ms every 100ms, it would wake
with 39.6ms. It would then run far more than its new runtime in this
period. Admission control already counts the new, smaller bandwidth. So
other deadline tasks could miss their deadlines.

An implicit task is not affected. Its check compares with its
bandwidth, which bounds the runtime for any deadline.

Fix this by keeping no more than dl_runtime before the check, for a
constrained task. A boosted task runs on the parameters of its donor,
and is left alone. The runtime is signed and can be negative there, so
compare it as signed.

The cases change_constrained_new_params and wake_constrained_new_params,
added to deadline_bw_test later in this series, test this. The first
changes a running task, the second a sleeping one. Both fail without
this patch.

The Sashiko AI review of this series found this.

Fixes: 2317d5f1c349 ("sched/deadline: Use deadline instead of period when calculating overflow")
Fixes: 3effcb4247e7 ("sched/deadline: Use the revised wakeup rule for suspending constrained dl tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 95db8afd8353..01497171919d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1468,6 +1468,25 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
 
+	/*
+	 * The checks below compare the runtime left with the density,
+	 * dl_runtime / dl_deadline. That bounds the runtime by dl_runtime
+	 * only while the deadline is at most dl_deadline ahead. After a
+	 * change to a shorter dl_deadline, the deadline can be farther
+	 * ahead, and the runtime left larger than dl_runtime. A constrained
+	 * task would then run more than dl_runtime in a period. Keep no
+	 * more than dl_runtime.
+	 *
+	 * An implicit task is checked against its bandwidth, which holds
+	 * for any deadline. A boosted task runs on the parameters of its
+	 * donor. Leave both alone.
+	 *
+	 * The runtime is signed, and can be negative here.
+	 */
+	if (!dl_is_implicit(dl_se) && !is_dl_boosted(dl_se) &&
+	    dl_se->runtime > (s64)dl_se->dl_runtime)
+		dl_se->runtime = dl_se->dl_runtime;
+
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
 	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
-- 
2.47.3

