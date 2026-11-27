Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790183;
	b=1JmUZngUXIwkOm3rKoI8BdtF1uG5YZ4uoofFMOMEfOTZCvKj6+5rhZL4LfmHqKETM3jO
	 Y8ejeTVYiGuGuE3OoKAWDgSimuL+PQOZFTPJ+u/NOQQpaYDUTwGyzTdbMMfzYtzwCiicA
	 l1WMHOi87z7MykrnqpAC8sFrDSfZeBYDnOdyNa5FPoMQiA6whC7gjyRJXoPG7wHzVF/dj
	 b3O0Ag/+9AK4HcfQdniKJ2WaUcnSiknG6n8DHHB88Gpf9ShEwl7i/oqmwtz9tLyBk9xuZ
	 hIaG/hmWhSkpxh/CRuTF28HztHZOQJR4RNzHQZGMdJPiu/+0awgZS3S3KcwQiONHx1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790183;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qHvuKECXl6M91WK5Ep3OzYNOvGFQAU+yoRfcJqadTO8=;
	b=nNhqc5if5aOnLLPOMhNkygoLfr9b7Q+KK7hJxXtGq71+AsZIfXUQ0RYE5nwluZcxxS7H
	 +ZwyRse25uWeq/CG7XLrHkfugrPPMYaBGRtt4M6YTFQcYdlYbG2GiGDvs2ek1UQxoK4CQ
	 s08+10Fg27o1SeOrDDg5rcYANeVgtAvJf93dmuMSUKDY+AO28cbLEKs/HiLcSRFQfQ2x+
	 IEqn0NrAtVxaZgmiXzkDmodPC77RAJZ0ScJKdyBEm5IM+1Q0Z+NCREextwfS9SfaMkeQ6
	 cKSkeGGAzSJO4uMxJnk/JTGqo8EC9j2/eaA9Nr70uoAraWpuAh2wVZ4nY5ORWPEzPPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=EOhpoJa1;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AE3606BAB7;
	Fri, 27 Nov 2026 14:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0AE3606BAB7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=EOhpoJa1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790179;
	bh=qHvuKECXl6M91WK5Ep3OzYNOvGFQAU+yoRfcJqadTO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOhpoJa10cVHlOyzFa6LnLfAl0JXQSHzeJ6HbihIAPPkKPFa6pb1bcdN5dwSeKW53
	 GdNpqF5oM4xNFeOWlyZz9FJgv0kC1YW7pad4tlCV2cQZ46PLDtpb2Hn3wetMNnp37R
	 QXpwMEzyQzMDkPtz7NCULUnqVFFcocN1BdXVzx6npxloNAWSQE9kNqQIXS23oRNebq
	 sgMIv95oTYHk0Z7Yk9/ZVSpa1B39Z6jrKHcRYW+I3n8HzX6UR25TpSJX4uXDW6NDDB
	 EpAqG2f6rl0limRse0gnicHR8EIaSdhb3VwUTuk7DKiA4ZQ+EDA3Kwk1mkiE8TNt/n
	 U3YhVROkZrPdw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZV6S28zX2J;
	Fri, 27 Nov 2026 09:36:18 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
Subject: [PATCH v12 31/43] sched/deadline: Restore the owner's period at a deboost out of the class
Date: Fri, 27 Nov 2026 09:35:58 -0500
Message-ID: <a802201284a7bff640a793ee06356eda187bf59e.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its runtime and deadline, so
that leaving the class and coming back gains nothing. Commit
a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") did this.
Its bandwidth also stays in total_bw until its 0-lag time.

Such a task can hold an rt_mutex. A deadline task that blocks on the
lock before the 0-lag time boosts it back into the class. A task that
switches to SCHED_OTHER while boosted also stays in the class. Either
way, it leaves the class at the deboost, with parameters of its own.

A boosted task is not throttled. When it runs out of runtime,
replenish_dl_entity() refills it from the donor's parameters. Its
runtime and deadline are then the donor's. For a task that stays in
the class, "sched/deadline: Restore the owner's period at a deboost in
the class" saves the task's own values at the first refill. This holds
the boost. At the deboost, dl_deboost() puts the values back.

A deboost out of the class is missed. task_non_contending(), called
from switched_from_dl(), mixes the donor's runtime and deadline with
the task's own dl_runtime and dl_period. The bandwidth then stays in
total_bw too long, or would leave it too early. Until it leaves,
sched_setattr() refuses new deadline tasks that would fit, with EBUSY.

Fix this in switched_from_dl(), as dl_deboost() does:
- After a held boost, dl_end_held_boost() puts back the saved deadline
  and runtime. If the task's own period has ended, it starts the next
  one instead. The 0-lag time is then that of the task's own period.
- A task with no parameters at the first refill has nothing saved. If
  it got parameters later in the boost, start a period of its own. Its
  0-lag time is then now.

The task can leave the class this way with no runtime left, before its
own deadline. Its first refill came when its runtime ran out, so the
saved runtime is often used up. In the class, dl_deboost() throttles
such a task. Out of the class, nothing does. If it comes back to the
class before that deadline, it would run until the next tick. Fix this
too: its enqueue now throttles it until its next period. A task can
then reach the cancel of the replenishment timer at the end of
enqueue_dl_entity(), which only servers reached before. It now drops
the reference that a queued timer holds on the task.

A task can also sleep while boosted, after a refill. Its dequeue then
arms the inactive timer from the mixed values. If the boost ends while
it sleeps, switched_from_dl() keeps that timer. Fix this too: cancel
the timer, and compute the 0-lag time from the task's own values.

The Sashiko AI review found this, on "sched/deadline: Reset the
deadline and the runtime with the parameters" of the first series.
These cases of deadline_bw_test, added later in this series, test it:
- deboost_out_asleep_after_refill: the owner sleeps when the boost
  ends, and its own period has ended. Without this patch, its bandwidth
  was still in total_bw after the boost ended, in every run.
- deboost_out_after_donor_refill: the owner runs when the boost ends.
  Its bandwidth must still be in total_bw right after the unlock. It
  passes without this patch too.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 45 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9c707512d93d..6e20efb86359 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3132,6 +3132,21 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 		setup_new_dl_entity(dl_se);
 	}
 
+	/*
+	 * A task can come back to the class with no runtime left, before its
+	 * deadline. It would run until the next tick. Throttle it now, until
+	 * its next period, as update_curr_dl_se() would.
+	 */
+	if (!dl_server(dl_se) && !is_dl_boosted(dl_se) &&
+	    !dl_entity_is_special(dl_se) && dl_se->dl_runtime &&
+	    !dl_se->dl_throttled && dl_se->runtime <= 0) {
+		struct rq *rq = rq_of_dl_se(dl_se);
+
+		dl_se->dl_throttled = 1;
+		if (task_current_donor(rq, dl_task_of(dl_se)))
+			resched_curr(rq);
+	}
+
 	/*
 	 * If the reservation is still throttled, e.g., it got replenished but is a
 	 * deferred task and still got to wait, don't enqueue.
@@ -3146,7 +3161,7 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	 * Also cancel earlier timers, since letting those run is pointless.
 	 */
 	if (dl_se->dl_throttled) {
-		hrtimer_try_to_cancel(&dl_se->dl_timer);
+		cancel_replenish_timer(dl_se);
 		dl_se->dl_defer_armed = 0;
 		dl_se->dl_throttled = 0;
 	}
@@ -4837,6 +4852,22 @@ void dl_clear_root_domains(void)
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
+	bool held = dl_end_held_boost(&p->dl, false);
+	bool own_period = held || (p->dl.dl_runtime && p->dl.dl_donor_refill);
+
+	/*
+	 * After a refill from the donor, the runtime and deadline are the
+	 * donor's. task_non_contending() would mix them with the task's own
+	 * dl_runtime and dl_period. So give the task values of its own first,
+	 * as dl_deboost() does. After a held boost, dl_end_held_boost() above
+	 * has put back the saved ones. A task with nothing saved starts a
+	 * period of its own. Its 0-lag time is then now. A constrained task
+	 * still keeps its bandwidth until its next period: see
+	 * task_non_contending().
+	 */
+	if (own_period && !held)
+		dl_start_own_period(&p->dl);
+
 	/*
 	 * task_non_contending() can start the "inactive timer" (if the 0-lag
 	 * time is in the future). If the task switches back to dl before
@@ -4869,6 +4900,18 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		if (p->dl.dl_non_contending)
 			sub_running_bw(&p->dl, &rq->dl);
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * If the task blocked while boosted, its inactive timer can be
+		 * armed from the donor's runtime and deadline. Cancel it, so
+		 * that the code below computes the 0-lag time again from the
+		 * values set above. If the timer handler is already running,
+		 * it releases the bandwidth.
+		 */
+		if (own_period && p->dl.dl_non_contending &&
+		    hrtimer_try_to_cancel(&p->dl.inactive_timer) == 1) {
+			p->dl.dl_non_contending = 0;
+			put_task_struct(p);
+		}
 		/*
 		 * Without an armed timer, nothing releases total_bw. Do as for
 		 * a queued task: arm the timer if the 0-lag time is ahead, or
-- 
2.47.3

