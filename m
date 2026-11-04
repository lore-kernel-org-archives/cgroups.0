Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826735;
	b=Ly/cFtH6xGs4TALPBVkDO1Xtt8l7+0JypirS2NMdabq0sGqjy4uw8l7h/8qCYDa8ZA/A
	 YuO6XUPJBJnNjv3MGRnASV4NbhE4C2l8LnGvDLbGS1DbAY0VuX4MH5/8NGVJRQec6CJHp
	 0cz8LFnUPkJswn+MQwabqAGxdR/yFD6BHa40ba2IVa/eeXhLGfHtDHKnUvia7Irkc5Gis
	 QbJ024d+0Yt1BFUCzPohpPDFGTm9+tdIubArtCikKqr2CqhDndppnZt2nA1YzrlNK0n9z
	 Md+Nh/ujlkh0PyV4CH28WpT4AjMlZKVcBrbF1pNVBPKFzkhzAmt7QVAkjjhe6+q3zaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826735;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pQ4XwQPJYV0RYsDzEVrUzJDwpQaQaeKiPcpQINNnok0=;
	b=rxvHWq8lvQ+AIIeFJzjG96LbKVhGAXQ7TQ4i/9ckrdNl8O+Tjxo+ppInxKLLMJtO84IX
	 UEjC3Dhcr+v/RUIcudKwHMmmZ1wGSbHMjH1M9B9p2hQ+V0vJ4E2uDFgPnkD74wjIIb2iI
	 rhplsRqHunWbP1n7kzzxDrwUF2ER0LjTh87NAE65q11cKH825zJw2nQ/GI/aasxSxXr4+
	 Vv8u1DQSiIMnUZxSt71o9SHX00I4gTB4Pf1C9pXA0VTORmhb5naX4phDgGytoovtBjPG2
	 LyyZY0zaDNE1DTTLIcqSj87cho4B0h+0KwPy68PBLadfBknGIW27VaYJTU957W8fYZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=R2dJmGwx;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283436081771;
	Wed,  4 Nov 2026 21:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 283436081771
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=R2dJmGwx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826733;
	bh=pQ4XwQPJYV0RYsDzEVrUzJDwpQaQaeKiPcpQINNnok0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2dJmGwxWBibxwm8wY7v6GQr0SsnFVxWPEAixxGKIoTQPBOXB/4BLMTC2s9+sSBWg
	 nfSSel/Vfry6Xw6FMEd+LM9cfiHezgkRLdr5ieJ1F25dxL6nATyORgzWFbhAkfEKHA
	 n+yJmlY47+7tCFaXNLhhI2NZ9gX5pq+Hc6jTZJ6iLbJ5gCGfe0STvp8GV0LP0l35Md
	 IgnsFb43kkwLd5dfxax+pjL6ySYWbuStLqIaHQLVQXQzfn00YjVc/xKP7qOfkEDbqa
	 w9LIJL84/1X5D5rnrxBLhaNJ7ouVr+7Miky6oEkmd7ayIVDAxkRFZqQa2B79/ujZS3
	 X8TYPS/YUboTA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRx4TLPzLXV;
	Wed, 04 Nov 2026 16:12:13 -0500 (EST)
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
Subject: [PATCH v2 07/21] sched/deadline: Do not release a departing sleeper's bandwidth twice
Date: Wed,  4 Nov 2026 16:11:53 -0500
Message-Id: <20261104211207.1392343-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

Release for a task with parameters of its own, not special, and clear
its bandwidth afterwards, once sub_rq_bw(), which reads it, is done:
every path that would release it again then takes a dl_bw of 0, and a
handler that runs late finds nothing to release. A test of
hrtimer_active() would not tell that handler apart: it stays true after
the handler returns, until the hrtimer code clears its running state,
and the bandwidth of a task switched out meanwhile would never be
released.

The parameters themselves stay, where inactive_task_timer() resets them
along with the bandwidth, because the task may still be the donor of a
priority inheritance boost: rt_mutex_adjust_pi() walks the chain and
deboosts the owner after the runqueue lock of the policy change is
dropped, and until it does, a replenishment of that owner, which
update_curr_dl_se() does at once for a boosted entity, would run
replenish_dl_entity() on a donor whose dl_runtime and dl_period are 0.
It would warn and then never leave

	while (dl_se->runtime <= 0) {
		dl_se->deadline += pi_of(dl_se)->dl_period;
		dl_se->runtime += pi_of(dl_se)->dl_runtime;
	}

with the runqueue lock held and interrupts off. __setparam_dl() sets
the parameters anew if the task comes back, and inactive_task_timer()
resets them at its 0-lag time if it does not.

The deadline_bw_test selftest, added later in this series, reproduces
the first case as pi_former_owner_asleep: in a one-CPU partition with
room, the waiter of its second round is refused as a deadline task,
total_bw having wrapped. The other two were found by reading.

The donor window was found by the Sashiko AI review of the first posting
of this series, and shown with a kernel carrying mdelay(20) before
rt_mutex_adjust_pi() to widen it: a deadline task blocks on a
PTHREAD_PRIO_INHERIT mutex with its runtime unspent, and is switched to
SCHED_OTHER while the owner it boosts spins. Clearing the parameters
there, that kernel warns in replenish_dl_entity() and stops, on round 4
and round 3 of two 8-CPU VMs; clearing the bandwidth alone, both go
through their eight rounds.

Fixes: 41a7968022ca ("sched/deadline: Fix total_bw leak when switching away from SCHED_DEADLINE while !queued")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b646063a7b0d..624cabdec965 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3573,6 +3573,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	dec_dl_tasks_cs(p);
 
 	if (!task_on_rq_queued(p)) {
+		bool released = false;
+
 		if (p->dl.dl_non_contending) {
 			/*
 			 * Inactive timer is armed. However, p is leaving
@@ -3585,12 +3587,18 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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
@@ -3598,8 +3606,29 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
 			raw_spin_unlock(&dl_b->lock);
+			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Released: its bandwidth is no one's to release again, and
+		 * a dl_bw of 0 is what every path that would takes. Kept, it
+		 * would make the task one with bandwidth to task_contending()
+		 * and task_non_contending() once priority inheritance boosts
+		 * it, and a deboost while it sleeps would release it a second
+		 * time. So would the inactive timer's handler when it runs
+		 * late, dl_non_contending cleared under it by
+		 * migrate_task_rq_dl(): it finds !dl_task(p).
+		 *
+		 * The parameters themselves stay, where
+		 * inactive_task_timer() resets them with the bandwidth: the
+		 * task may still be the donor of a priority inheritance
+		 * boost until rt_mutex_adjust_pi() walks the chain, outside
+		 * this runqueue lock, and replenish_dl_entity() of the
+		 * boosted owner would never leave its loop over a dl_period
+		 * and a dl_runtime of 0.
+		 */
+		if (released)
+			p->dl.dl_bw = 0;
 	}
 
 	/*
-- 
2.47.3

