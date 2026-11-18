Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032412;
	b=x4o10gcIJX2DRZlIjhRCiwVJzngxfRATb8tOFlCe0D1OSIoJRE4IG94MsxLQ00Kd0dy+
	 Z3uvwljS6pJ1z62SkNoCW+NseuzMGtG9KIwkx2SDQakPXk+/yqK1DtjrsY2PyvdMRua0v
	 OX4A9332PRSzr29ixJQehnTy4Df5wR5DZI22b/LR1nK/zaK+F9dBTh2L10iVq8mYnmkYU
	 Feh9OZv9Msyc5hndM0NBlvKzU+GZl0GYMnsL7/ymbvJBTBAHRAAnLeWVNJMW8MKyGs0Fn
	 2G1aLy94hZLVbGrO/AgTFsLpS1ayEhEg9yzjous7Jl2QcWvl4mcxnhfF+LTQM14SiGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032412;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YUpRYsuuZ9zTOzlFogFq/lthSpzrXEJar3Q39+/3IbQ=;
	b=D6f1IxitEYSM0mp198/YbB2ht3crYub430fg+Kdlr1Z20s39tOvmRt4j1LW146Yn1cBh
	 d2kWr8cSf3H92tXvEZP40E4ysazG7J4HemDKzKveOttIOII9TdopIcaFapD19k3wGCRH+
	 SrExqmqIt3IL0aCzqVG+1Z8LmTLXRuCQfVh4irwGvVS4OHucKmcCQpDZV4PdIlgRhJvVS
	 aH4QISJstW7ZwaMJjMBJ6Y/RV6H8F5vLDBZJ5kQwH9GKITJXff0sprBY7UlWtmmPVnhDK
	 zXWnFlcDkoeSYuPDmYP9JMIpVAup8bbfN9pFkXMXxmxutw9SsNXLac+KtvR4ivSGXfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Nm2G+KpH;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0417760A263F;
	Wed, 18 Nov 2026 20:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0417760A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Nm2G+KpH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032405;
	bh=YUpRYsuuZ9zTOzlFogFq/lthSpzrXEJar3Q39+/3IbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm2G+KpHD/BobwLgtt3YGTjAyyTKXYYasq7OAP2MKTzYxHx2RGU7DPgNnEZ04QDrq
	 cLOy6z+k+2baUZs4vvy7a8fZpFDpIZy6rja/lLRqr0jFstpMiIh+7RmdwZgCFNKTfS
	 wQY0Egr7oK14jAggr7ondsW+sq2S23kk+wkhn9hya0GqaM9LbJnU72MH1S23VY32q5
	 Wi6suUFp5wGPl9qlC+GpolneiTaxH6AFIzIADm0n7I1agw0X+0yTvs/Wks4LjP/Vlv
	 w75x39asV4ghsrAai9NStjIni8dfCFgmm/YOO2z/1KsoFbNMWTKpwlcuVI0z9Um9gz
	 KCSVevk0vRHmA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKx1W1qzRJZ;
	Wed, 18 Nov 2026 15:06:45 -0500 (EST)
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
Subject: [PATCH 09/16] sched/deadline: Reset the deadline and the runtime with the parameters
Date: Wed, 18 Nov 2026 15:06:34 -0500
Message-Id: <07a810645c5ab919a52ffe2cc4b63074a84751fb.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
References: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its parameters until its 0-lag
time, so that leaving and coming back gains nothing. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
their reset to that time. Before it, the replenishment timer did the
reset at the deadline. So a task back after the reset found its
deadline passed, and started a new period. But __dl_clear_params()
resets neither the deadline nor the runtime.

Now a task back after its 0-lag time can be enqueued on its old
deadline and runtime. With runtime left, its 0-lag time comes before
its deadline. Back before that deadline, it would first spend the runtime
of the reservation it gave back. Back after it, a constrained task
would be throttled until its old period ends. "sched/deadline: Do not
lose a throttled task switched out and back" moves the deadline of a
throttled task on. This widens the window before the deadline to about
a period.

A task with no parameters of its own, boosted by a deadline waiter,
keeps the donor's deadline and runtime after its deboost. If it then
enters SCHED_DEADLINE before that deadline, it runs on the donor's
runtime. On v7.4-rc2, a task of 10ms per 100ms ran 40ms of its first
period.

Fix this by resetting the deadline and the runtime in
__dl_clear_params(), and in switched_from_dl() at the deboost of a task
with no parameters. The next enqueue then starts a new period.

The Sashiko AI review of this series found the first case and the
deboost. The deboost_resets_period case of deadline_bw_test, added later
in this series, tests the deboost.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 71b1c155c242..d6d2657dcddd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3569,6 +3569,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	if (task_on_rq_queued(p) && p->dl.dl_runtime)
 		task_non_contending(&p->dl, false);
 
+	/*
+	 * A task with no parameters of its own was boosted into the class.
+	 * Its deadline and runtime are the donor's. Reset them, so that its
+	 * next entry into the class starts a new period.
+	 */
+	if (!p->dl.dl_runtime) {
+		p->dl.deadline = 0;
+		p->dl.runtime = 0;
+	}
+
 	/*
 	 * In case a task is setscheduled out from SCHED_DEADLINE we need to
 	 * keep track of that on its cpuset (for correct bandwidth tracking).
@@ -3984,7 +3994,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 }
 
 /*
- * This function clears the sched_dl_entity static params.
+ * Clear the static parameters of @dl_se. Also reset its deadline and its
+ * runtime, so that its next enqueue starts a new period.
  */
 static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
@@ -3995,6 +4006,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
+	dl_se->deadline			= 0;
+	dl_se->runtime			= 0;
+
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
-- 
2.47.3

