Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655352;
	b=JIBJuGcu7hb7xggvif7kg5na8ygYhaEQNI29+M8bYS/8JMET4VNSLi+QKdglVbXVMQPQ
	 eMSTuVunx3ATYln0llxlMs+PlJQ2fC7b09ZIIEyDReggiGobS1Gppu/j3hLD3iMt0tXv2
	 dJt8f7UDb49KX3vKjC6mJGT4jCxzU82BIRtJ+wC1OzXG0iWMvGcRffaqC3aOM1+McMOQi
	 zPNO9wNW6QbTABsUhpArIRyK0KIersJk39Z5WkwO6fJlg4pduJY4qdrjcYa4BiTwdgJhw
	 JmvpI3+9lXo6CNca9VCbLcvNmR3XAFQ4ohxuhDhz9b9I+4ajn/CiImf2smhmujLNXwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655352;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=33IVI8W+Du+zoA/45uuJo7hQB/ORJnwai0cDoVHHy2A=;
	b=P1aaEI0MkMk1IB0tXw6ji923YFv0Fy+YoWWjmwta/RzdTkmhKlGZaThehhm/FPnoDGgI
	 8r0fgM6GFhGRhCu8K78vrFtrueJqo53njIiqRttpUdw3dqwu8WJfHEx5Rlln+4wToFtf4
	 lQn+lxet5jcD4uBNf1VERWg3JMrrOwuWjeqXT6CntE+1vH30pAq/zpID977B8ecTRmLlq
	 Tf5b5FBXldKT/TayUB/DTwENByfWBUROaN0mCyVVEoelwc6F3N9Vci5qfjiVwYWeI6CPS
	 aYXdJY2AdAdlqBSMN3IiOEizgFfdNkIFzvudchofZkg7dqiHxrOBeYvYCQ1ouqWHimA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vOUUPQgB;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3671606B75C;
	Thu, 26 Nov 2026 01:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3671606B75C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vOUUPQgB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655351;
	bh=33IVI8W+Du+zoA/45uuJo7hQB/ORJnwai0cDoVHHy2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOUUPQgBZZ1HxgLD7GmK9ToiB33M11iYHiXn+eNxhvcFRLUY0uIf0av6wXfPdaMEC
	 21mBwMQdWFKIBUVADcatnAMgpwuxILlWzEJ2Th3Av+FC98fad1AtlCjNnwcR8HPOgS
	 kKXFRFB+J8DXfO/RockrOwlt+0/QqWJuVm5lLQG0+uhmblihrOgXazWhTlFLrfOsvU
	 dHeGWXlp+oS+bqy+YBYqf9vlJg4wc77J88qXyBdAHhHyqKQPH7o1kDDN+fEYBQ7dJn
	 10M/JM4dVG4zPr0L8kaaBMKouxs2Vnh8dsWq0NyesDliMw5FU79Uzs+/8flrS60sk3
	 3De5kU6iIlY4w==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjf3mYzzWWC;
	Wed, 25 Nov 2026 20:09:10 -0500 (EST)
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
Subject: [PATCH v11 31/43] sched/deadline: Restore the owner's period at a deboost out of the class
Date: Wed, 25 Nov 2026 20:08:30 -0500
Message-ID: <c53e032decdc0ae447feecd391faa770e683dd89.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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
 kernel/sched/deadline.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4d46d1c9c698..5d1d4ea28878 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -4802,6 +4802,22 @@ void dl_clear_root_domains(void)
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
+	bool held = dl_end_held_boost(&p->dl);
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
@@ -4834,6 +4850,18 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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

