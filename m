Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=xzXR1JxR3R1JNZaJE1+i+A/eanTaDhbR7FydM7NwXQDuKnhVhf4tzIcScK0+jGRNcCZK
	 Z3H++dR9m7TNkokELsYnn+uXkMwps1WuQYMe2+atYCvDV+n0WfOtvkJGW+iZv6I9rAhU5
	 bc7C+kA8i4FHWXMVn22YQLGEdJb5oca3itfKrM9ex51PhIQJ3BeVSs5gj3bZ1lREzp/zC
	 tg85JhmcePLNyEDtG3O6m+Cu6LF41XqhZ3xlQLt/lO2SI+66c2OkITA/iHdbs3YsrtvWK
	 A9x9h7dNOBgRRHSYnbTfFY1tZ68sdasrZ1Cx76ENwwP8juRhIlHfUIQLXcKytQH9yCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7e1hUpgeep/gmyGwtwEXJxDr+p6ixMsPOQQieebwx0Y=;
	b=YS4SuR5HYeAxKd7W+DvmYhucc0VlHa8KxiiffD9WZPN1Vwi3Bxf3UY1+k8CuV1dUkShK
	 S/kfTIRZLKo+dhYKPgCMSWZgKyUQTM/Wo2ZNKCyLjZ4FNYlyh9fbkfLTCl3+B9afKaVnK
	 jXPMdIb5pbW7iY1/Ny87AtROa7QGADomjveLkPB56Np3Uer3iETx+U8Sx9bFBSprHMeIh
	 +i/SK5QOBLJx2WYkY9gOTj2HdGX2LYole8SKb4L4TccoI9AGdQnXqcWBO7kdlw+Rps3eM
	 UCIyxB3rkDiUBBq+GOwSQI/6qAWG8y8tXMrvxvSJbgpChOjwRnjqQm4jyn9XrStMNKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sshxNB6o;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E90606A9D3;
	Thu, 19 Nov 2026 20:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94E90606A9D3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sshxNB6o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119383;
	bh=7e1hUpgeep/gmyGwtwEXJxDr+p6ixMsPOQQieebwx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sshxNB6okYOcE4mGjpsaCB5CNxX8zgB8q/pPlPzrsoNeMQS0lnFli0GVcVQyllm04
	 y3GHsewDbxBXrfKEfU3fjL5qbITnHKEmgiVVHwo1ffNZtbkcLwxxGCREc1cfH1Kwqa
	 nnXd7n9L+odNTmKh5+OVX9+Y7Gs+oALwuC9xXBmzhGD2Nf4cB8wRJJMakD073BCr92
	 RB7mjio/3O/Z0aL+XW+OhSW6AyB71TMZRz++NT49QALI4FlbIku26+6VPEmGyLkddA
	 fJzTqq9TlwmYZ09OTjOiS7v2f6BxREz2A+sID+fHEtzBLdPtJYkO2ZPQWJzgnvG5l7
	 YmeuCKDKaCcHw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVb25ZfzT9k;
	Thu, 19 Nov 2026 15:16:23 -0500 (EST)
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
Subject: [PATCH v8 32/33] sched/deadline: Check the runtime of a task whose parameters change
Date: Thu, 19 Nov 2026 15:16:11 -0500
Message-Id: <efcd611a473f0da0161243c58f4af7c7ca73e2ba.1795116791.git.mathieu.desnoyers@efficios.com>
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
until its deboost. dl_deboost() checks it there, before
rt_mutex_setprio() compares the task with its top waiter.
A larger reservation still takes effect at the next period.

The enqueue flags cannot tell a change of parameters: a cgroup move
also uses ENQUEUE_MOVE. Without the mark, a task that waited behind
others could fail the check, and get a later deadline for no reason.

The change_running_new_params case, added to deadline_bw_test later in
this series, tests this. change_boosted_new_params tests a task that
changes its parameters while boosted. Both fail on v7.4-rc2 and pass
with this patch. deboost_new_params_reboost tests the check at the
deboost.

Fixes: 40767b0dc768 ("sched/deadline: Fix deadline parameter modification handling")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2f2f59402f09..86585c663e4b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -715,6 +715,10 @@ struct sched_dl_entity {
 	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
 	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
 	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
+	 * @dl_new_params tells if sched_setattr() changed the runtime, the
+	 * deadline or the period. The next enqueue that is not boosted, or
+	 * the deboost, checks the runtime left against them, and clears it.
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
index 7ed2f525b883..2849484428c6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -114,6 +114,8 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
 		dl_se->dl_donor_refill = 1;
 }
 
+static void update_dl_entity(struct sched_dl_entity *dl_se);
+
 /*
  * End the boost of @dl_se, whose task stays in the class. If the boost
  * refilled its runtime from the donor's parameters, start a new period
@@ -122,6 +124,10 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
  * first. Without a refill, the task keeps the runtime and the deadline
  * of its own reservation.
  *
+ * If sched_setattr() changed the parameters during the boost, check the
+ * runtime left against them now, for the same reason. rt_mutex_setprio()
+ * then compares the result with the top waiter.
+ *
  * The caller holds the rq lock and the pi_lock of the task, and has
  * updated the rq clock.
  */
@@ -130,6 +136,12 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	if (dl_se->dl_donor_refill)
 		dl_start_own_period(dl_se);
 	dl_drop_boost(dl_se);
+
+	if (dl_se->dl_new_params) {
+		dl_se->dl_new_params = 0;
+		if (!dl_se->dl_throttled)
+			update_dl_entity(dl_se);
+	}
 }
 
 /* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
@@ -2864,7 +2876,16 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 static void
 enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
+	bool new_params = dl_se->dl_new_params;
+
 	WARN_ON_ONCE(on_dl_rq(dl_se));
+	/*
+	 * A boosted task is refilled from its donor. Keep the mark until the
+	 * runtime is checked against its own parameters. dl_deboost() checks
+	 * it at the deboost, and an enqueue that is not boosted checks it.
+	 */
+	if (!is_dl_boosted(dl_se))
+		dl_se->dl_new_params = 0;
 
 	update_stats_enqueue_dl(dl_rq_of_se(dl_se), dl_se, flags);
 
@@ -2913,12 +2934,13 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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
@@ -4971,6 +4993,11 @@ void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
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
@@ -5104,6 +5131,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
+	dl_se->dl_new_params		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

