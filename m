Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855969;
	b=b8qHLuOn5d5PcJT2Drlqxt0DHBzL2LoiLEFb24ZQ1VK73E/nJvYf6RDQ8X9LtrScCzfu
	 DAsrnQtfe46vzJEfajSC8iHf6NxwGPpFr1rTsM5MkaBHP2qE/SWSjMHcHI1OCFHfU6ODq
	 gCKGJyjbzuyyjgFqQGjN3amR4yOpzJ3bJR4e8olZau8j4MDi0JjcuS22rFK/sg6v1gmjI
	 Pl7rAMuBlXgYiZd8VOu7hUy3nmIjWKs/yLq5JpttoL9yRznbgyyRuLxwIdRdhwEQjPpX+
	 6Vgomu32oZ8KwagxKSrSLBTzl9s31POGYBsml/MArIVFDz5xxlVZTLR8bS3sHuOlTFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855969;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2n4jk7PlrVEcpgEOJM3cxrAKyJBj1rAGByXWYUVprcA=;
	b=OsHNh7FbUGblAy76bEM2ERe+6skQzoEoJmftEM3Akxz+ZLBTRAFcA8mRY0yR5WSq9Xs3
	 khLOWEMLHfPRztiCt9sArYZuuXVHWRiFC1S+S+dXmBY8jThot6yjo9OwExBmH8PADKTzD
	 8Bvg/1TgEVc08hUDUxnnXrf+v3/Ug7x6kKhDiaayvE8LpUeGxGQbGBrg2/hAfyMHEsdsr
	 CzuyrdBHb2o0v6uusQDMnnRh3p67p2s0Qbnr6BLpJpetm8yuKuXJql/RSPlO4jUvztDTn
	 wzDt+1WsROmPBAhh3PwTMexgtqKMopMbVtcnlVyO1NlOKBhjUHccLuuhzb5vqFLlonA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="m/jOSW+5";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1568606A8A1;
	Mon, 16 Nov 2026 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1568606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m/jOSW+5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855959;
	bh=2n4jk7PlrVEcpgEOJM3cxrAKyJBj1rAGByXWYUVprcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/jOSW+54viZoK6GFpFiYcOnidA90+EdoubGYJ0JDn753Q7F60o10wMHrDldcpAJY
	 Si9oVb8XWI4PomtTTqZe/tlbl295I1kEfmDgOYKTdnJ9GyQl3YH9zzbh7vtAg1lsLa
	 vZUDAKyEgKnVXdu7eO4IkvkyMIrzCDajRREkaMU4evTSvmsOXTAGFz0ii7knpIwRZP
	 HTT4LtBC6tawGBQseHHKAQyG1vxPbJR2N/m76lDgtwhTGfEQi42HoiHKsK4+qXpKiK
	 ANIXBKOen/7csIaMMzQ+PGHAgsdPFMbNsM1qdDyyS+2qziwy6Xk8+qwGrgdzgWPjvk
	 uuSKOL4TTzqwg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4l5xrtzRM8;
	Mon, 16 Nov 2026 14:05:59 -0500 (EST)
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
Subject: [PATCH v6 33/37] sched/deadline: Check the runtime of a task whose parameters change
Date: Mon, 16 Nov 2026 14:05:45 -0500
Message-Id: <20261116190549.230119-34-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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
back. On v7.4-rc1, a task of 50ms every 100ms changed to 10ms every
100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule after a change of parameters, as
the previous patch does for a task that enters the class.
__setparam_dl() marks a change of the runtime, the deadline or the
period. The next enqueue then calls update_dl_entity(). It starts a new
period, or reduces the runtime of a constrained task, if the runtime
left does not fit. The task gets no more than a wakeup would give it.
A larger reservation still takes effect at the next period.

The enqueue flags cannot tell a change of parameters: a cgroup move
also uses ENQUEUE_MOVE. Without the mark, a task that waited behind
others could fail the check, and get a later deadline for no reason.

The change_running_new_params case of deadline_bw_test, added later in
this series, tests this. It fails on v7.4-rc1 and passes with this
patch.

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 20 +++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2f2f59402f09..f40abe5b9ace 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -715,6 +715,10 @@ struct sched_dl_entity {
 	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
 	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
 	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
+	 * @dl_new_params tells if sched_setattr() changed the runtime, the
+	 * deadline or the period. The next enqueue checks the runtime left
+	 * against them, and clears it.
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
index b47c13c8714d..3b62ee43c209 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2674,7 +2674,10 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
+	bool new_params = dl_se->dl_new_params;
+
 	WARN_ON_ONCE(on_dl_rq(dl_se));
+	dl_se->dl_new_params = 0;
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -2723,12 +2726,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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
@@ -4696,6 +4700,11 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
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
@@ -4828,6 +4837,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

