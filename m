Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805149;
	b=RVsAJLfBmo3Z4IdK5w1hFpkU3ggutg1L50wWJg0SNkm0/us4zEtAkgBfn/PAp5jVUGOx
	 zsCGIXlXjwGmg1paTof5dlF0WVMcDx2QL8qMFx8q5coxp3qrQiU8Xnj0QcQsGSABtawIc
	 tbhGkXHvwrEN2rAgva1uhyg+/yar/t44+kEn5dn14ZgJb5FoJPZUpunsrEM3RFB1HExrD
	 gWcmS7lXN238R4eEVeeXShNPlsqiAEIf8wsTnbGNtR3wk2o5dNC2bU26tyjz7qigowz+E
	 rjUzPDB2rJ0mPO3daN6AKnQ2haqhx0FkgpfCQemj1PIoEUBN4AyFIXtKIkREq+hIilA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805149;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R/w5ujGIrw6u8hZCPvihsdmDgjiowOcByoqpRDE9Z+Q=;
	b=LYDkjemd1OOH5I/gFFY1L2N6QnU5SIpivYIY5bNffwMrxMpIVsGFa2Z4pPhaubF1pcsr
	 Lae5rqpv2qE8U8PuHimwtYHsoqYK2L9o5EXfeCCmCIPj7PI6TzrerTJhNCyppEzY15e6o
	 9LT9+07LAtPiRvZTmTVVsI8dmg5g6uSV19T3PqGEsT0L4jkMt3hMV1xouTFg9qOMyVFd/
	 r/unJuTOwgFhtark/YQmA07+/E7Mci33p8rKP1w+uZ4S7HzQyV5eV0+CcmykT6aYVyk2C
	 wgYHkYYr3+4PwYqedBXXzj1uM7oWiBgs5BkSK2YDE4fvsEDr8Kq74CkP8VAWH9sWe9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MGcKx9rg;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFD606D81E;
	Wed,  4 Nov 2026 15:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEEFD606D81E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MGcKx9rg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805140;
	bh=R/w5ujGIrw6u8hZCPvihsdmDgjiowOcByoqpRDE9Z+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGcKx9rgbZidwenDUW4puVcyapqupmgFyxuu15WFNOcd3g9zkF6bx3gzVXpsiBDHG
	 FILYB3U1HjAIEo4okY2ztz5GlMfxMt3PwG8fpVnGE1xWbMtwhaudIPiZO5tQ9ETZlv
	 nnizI+ruszfzdAKmVI0ftBg91puXV7vbx5YCb2EuYG9t2aNUTdVrYFsCORjR/Ra1xK
	 InoIyypCmWiylHiwq4eRoIES6Rdzv26bvKgXIgaR7+LzYTOVO9jxXzJXQ3NFVlS2W+
	 DEg9GAY6DsDaehurgfEq0Sf8RA8Ybclx/omiGWH1p6f9JWMN4wQ/3eQo6SSTi+W1Sh
	 s/0REhgAMjCoQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSh4CxlzL1P;
	Wed, 04 Nov 2026 10:12:20 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Claudio Scordino <claudio@evidence.eu.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 05/12] sched/deadline: Do not release a departing sleeper's bandwidth twice
Date: Wed,  4 Nov 2026 10:10:26 -0500
Message-Id: <21f538f65f013a71920547ac92c76ca8ba544d19.1793804635.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
References: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
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

Commit 41a7968022ca ("sched/deadline: Fix total_bw leak when switching
away from SCHED_DEADLINE while !queued") releases the bandwidth of a
task that leaves SCHED_DEADLINE asleep with no inactive timer pending.
Three cases release what the root domain no longer holds, or never held:

 - the task keeps its parameters. inactive_task_timer() resets them
   once it has released the bandwidth (__dl_clear_params()); left in
   place, task_contending() and task_non_contending() take the task,
   now of another policy, for one with bandwidth when priority
   inheritance boosts it into the deadline class, and a deboost while
   it sleeps releases that bandwidth from total_bw a second time. The
   root domain then admits deadline tasks beyond its capacity;
 - a task deboosted from priority inheritance with no parameters of its
   own, and a special one (SCHED_FLAG_SUGOV), have no bandwidth in
   total_bw. Releasing 0 changes nothing, and the root domain that
   dl_task_root_domain_cpu() finds from the task's mask means nothing
   either: a sleeping task of another policy may have no active CPU in
   its mask, a CPU it is pinned to having gone offline, until its next
   wakeup widens it;
 - migrate_task_rq_dl() clears dl_non_contending when it cannot cancel
   the inactive timer because its handler runs. That handler, once it
   takes the task's locks, finds it out of SCHED_DEADLINE and releases
   total_bw itself.

Release for a task with parameters of its own, not special, and reset
its parameters afterwards, once sub_rq_bw(), which reads its dl_bw, is
done: a handler that runs late then finds no bandwidth to release. A
test of hrtimer_active() would not tell that handler apart: it stays
true after the handler returns, until the hrtimer code clears its
running state, and the bandwidth of a task switched out meanwhile would
never be released.

The deadline_bw_test selftest, added later in this series, reproduces
the first case as pi_former_owner_asleep: in a one-CPU partition with
room, the waiter of its second round is refused as a deadline task,
total_bw having wrapped. The other two were found by reading.

Fixes: 41a7968022ca ("sched/deadline: Fix total_bw leak when switching away from SCHED_DEADLINE while !queued")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d474fbfd9be6..3c57e5f5fc05 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3567,6 +3567,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	dec_dl_tasks_cs(p);
 
 	if (!task_on_rq_queued(p)) {
+		bool released = false;
+
 		if (p->dl.dl_non_contending) {
 			/*
 			 * Inactive timer is armed. However, p is leaving
@@ -3579,12 +3581,18 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * release total_bw via __dl_sub().
 			 */
 			sub_running_bw(&p->dl, &rq->dl);
-		} else {
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
 			/*
 			 * No pending inactive timer: the task never ran as
 			 * DEADLINE or the timer already fired while still
 			 * DEADLINE (only dropping running_bw at that time).
 			 * Nobody else will release total_bw, do it now.
+			 *
+			 * Not for a task without parameters of its own, one
+			 * deboosted from priority inheritance, whose mask may
+			 * have no active CPU for dl_task_root_domain_cpu(),
+			 * nor for a special one: neither has bandwidth in
+			 * total_bw.
 			 */
 			unsigned int cpu = dl_task_root_domain_cpu(p);
 			struct dl_bw *dl_b = &cpu_rq(cpu)->rd->dl_bw;
@@ -3592,8 +3600,20 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
 			raw_spin_unlock(&dl_b->lock);
+			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Released: reset the parameters, as inactive_task_timer()
+		 * does. Kept, they would make the task one with bandwidth to
+		 * task_contending() and task_non_contending() once priority
+		 * inheritance boosts it, and a deboost while it sleeps would
+		 * release that bandwidth again. So would the inactive timer's
+		 * handler when it runs late, dl_non_contending cleared under
+		 * it by migrate_task_rq_dl(): it finds !dl_task(p).
+		 */
+		if (released)
+			__dl_clear_params(&p->dl);
 	}
 
 	/*
-- 
2.47.3

