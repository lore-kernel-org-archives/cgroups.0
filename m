Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032413;
	b=1vBhN1kmuwLt/exovKJgWfDOp9blaqS+U2P3ndmvwHQFSkjlKdcKJjgTBOXgOgsTgrIM
	 JF0WgzOz5BNsn2f1WZ3doFq9Lzv5Fpm/hEF51begEXA2q1ORaDVRn7bWj40iWhR9tGA/c
	 eeFIyzSjC6vTjXhB/ogrBIvXmZkhyzQbjsZhOWbfOaaPMm3Jb5dVEgkHaiiLG0sqgo7e7
	 YFMuhxpQbhaJJCRJn4yrIymJ+Gm3pTGYQvkX6eaMZPZVaNgWL7cnXULI6GsKwLtMvsWS5
	 vk+pDDAylHGlngJGsqs3Vfm0l6ZVORu/dhOutYXx+VKrSMAX4qZVl1Rx1Fax82UzWOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032413;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=J786XyzD4Ejqh0xQe33CLgYWo2dkNfSw+M+NLmT/DuM=;
	b=sjCh1dqvfYVYBSII00oVMtv91LryiFs0r2xEjFPpZeiQ+dvI/9heUXecEw70p/MkyyhY
	 DQD0q+s4Vhzgetq4zBOG3p8QS2+HRfofQoK6Ns3AM0Vbq9ihrpJk6cyrybsPcH75+gDHO
	 JMLhmLmkoVU2VhwY9VQcagsGooajbcjOKo2qwN+fIJZluCTW0npydTY0Dxh6ahhtKhN2N
	 6UN2PGNMLj6i/rdUZrXp8V2UhBhG2mttODFbePG3TAPNSoNruZUsM6VAAOCsD/e5TxmvE
	 SnCvY/JemWKc+JAQzOaPzaz5QYNt9bhJpN1j6vxbf2Y3ixw2mclpBUjzIyWigg9KnHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XfqVNjKp;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3388460A380D;
	Wed, 18 Nov 2026 20:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3388460A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XfqVNjKp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032405;
	bh=J786XyzD4Ejqh0xQe33CLgYWo2dkNfSw+M+NLmT/DuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfqVNjKpx8se3Exm8qS3KdEx4USXzVqQp5LGl1YlR7eQoOoWNEOsZuc/u+5q/mHoG
	 1q6fO4DU3g6v7wsstcmz374ba12IS5BowPIEMdHXhqtZEMI/hBBAo+3/EL0pZP+KV+
	 Rj3ideXwB2fJLm2JTwENRMO2mv1h65g4U72pTgMYSW2MQ/emWSZ8OVGmTl5CZH1qpJ
	 XdTN3KQj15XM0Gljf2ec21iGpdI2BphUtboPxkq0ngbJbfzQ5WYrbdIevAm1EUBHMo
	 7DsbC/D3IahB0opmhNk1B+cJB/axJqx4FRJwGp83f4waxxfizyjNBwBtBbfYj0fRaS
	 1PKxKu4fyoRyQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKx5S26zRph;
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
Subject: [PATCH 12/16] sched/deadline: Fix this_bw when a task is changed during a remote wakeup
Date: Wed, 18 Nov 2026 15:06:37 -0500
Message-Id: <dfe9865764c347295703c25e9a781438784f061b.1795031605.git.mathieu.desnoyers@efficios.com>
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

The this_bw of a runqueue is the bandwidth of the deadline tasks
assigned to it, running or not. GRUB uses it to compute the inactive
utilization of the runqueue. When a task wakes up on another CPU,
migrate_task_rq_dl() takes its bandwidth off the old runqueue. The
enqueue adds it to the new one.

Between these two steps, no runqueue counts the bandwidth.
try_to_wake_up() can leave the enqueue to the wake list of the new CPU,
and return before it runs. task_cpu() already points at the new CPU. A
change of the task in that window gets this_bw wrong.

In this example, T is a deadline task. S is another task. It changes
the bandwidth of T from "old bw" to "new bw":

  CPU 0                               CPU 1                       CPU 2
  T blocks
  this_bw of CPU 0 counts T
  <timer> try_to_wake_up(T)
    set_task_cpu(T, 1)
      migrate_task_rq_dl()
        sub_rq_bw(): CPU 0 drops T
    T on the wake list of CPU 1
    return
                                                                  S: sched_setattr(T)
                                                                    task_rq_lock(T): CPU 1
                                                                    T is not queued
                                                                    dl_change_utilization()
                                                                      this_bw of CPU 1:
                                                                      - old bw + new bw
                                      sched_ttwu_pending()
                                        enqueue_task_dl(T)
                                          task_contending()
                                            add_rq_bw():
                                            this_bw of CPU 1:
                                            + new bw

CPU 1 then counts the new bandwidth twice, less the old one. Repeated,
this makes this_bw drift until it underflows. If T left the class in
that window, switched_from_dl() would take its bandwidth off CPU 1 the
same way. A task that enters the class in that window would be counted
twice, by switched_to_dl() and by the enqueue.

This needs a wakeup that moves the task, so a root domain of more than
one CPU, with busy CPUs. CONFIG_SCHED_PROXY_EXEC=y makes such wakeups
more common. In testing, a task sleeps and wakes in a busy two-CPU
partition root, and another CPU changes its runtime. The kernel warns
within a second in each of 8 VMs:

  WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
   __sub_rq_bw(): this_bw underflow
  WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
   __add_running_bw(): running_bw overflow

Fix this with a new bit, dl_bw_oncpu, that tells whether a runqueue
counts the bandwidth of the task. add_rq_bw() adds the bandwidth only if
no runqueue counts it. sub_rq_bw() takes it off only if one does.
dl_change_utilization() does nothing while no runqueue counts the
bandwidth. The enqueue adds the new one.

With this patch, none of the 8 VMs warns. deadline_bw_test, added later
in this series, tests this in params_waking. The Sashiko
AI review of this series found the double count, and a bit that the
first version of this patch left set.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..88cda9c10cb8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -706,6 +706,10 @@ struct sched_dl_entity {
 	 * contributes to the root domain's total_bw. Only meaningful for server
 	 * entities (@dl_server == 1). Allows toggling the reservation on/off
 	 * without losing the configured @dl_runtime/@dl_period.
+	 *
+	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
+	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
+	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;
@@ -718,6 +722,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_bw_oncpu       : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f0e03f97fd82..c36516210669 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -267,18 +267,35 @@ void __sub_rq_bw(u64 dl_bw, struct dl_rq *dl_rq)
 	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);
 }
 
+/*
+ * @dl_se->dl_bw_oncpu tells whether the this_bw of a runqueue counts the
+ * bandwidth of @dl_se. add_rq_bw() adds the bandwidth only if no runqueue
+ * counts it. sub_rq_bw() subtracts it only if one does.
+ *
+ * A wakeup on another CPU takes the bandwidth off the old runqueue. The
+ * enqueue on the new CPU adds it back later. A change of the task in
+ * between must not count the bandwidth twice, nor take it off a runqueue
+ * that does not count it.
+ *
+ * The servers track their bandwidth with dl_bw_attached. They call
+ * __add_rq_bw() and __sub_rq_bw() directly.
+ */
 static inline
 void add_rq_bw(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
-	if (!dl_entity_is_special(dl_se))
-		__add_rq_bw(dl_se->dl_bw, dl_rq);
+	if (dl_entity_is_special(dl_se) || dl_se->dl_bw_oncpu)
+		return;
+	__add_rq_bw(dl_se->dl_bw, dl_rq);
+	dl_se->dl_bw_oncpu = 1;
 }
 
 static inline
 void sub_rq_bw(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
-	if (!dl_entity_is_special(dl_se))
-		__sub_rq_bw(dl_se->dl_bw, dl_rq);
+	if (dl_entity_is_special(dl_se) || !dl_se->dl_bw_oncpu)
+		return;
+	__sub_rq_bw(dl_se->dl_bw, dl_rq);
+	dl_se->dl_bw_oncpu = 0;
 }
 
 static inline
@@ -347,6 +364,14 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	if (task_on_rq_queued(p))
 		return;
 
+	/*
+	 * The task is waking up on another CPU, and no runqueue counts its
+	 * bandwidth. The enqueue adds it, with the new parameters that
+	 * __setparam_dl() sets right after this.
+	 */
+	if (!p->dl.dl_bw_oncpu)
+		return;
+
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
@@ -2726,6 +2751,11 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 		 */
 		cancel_inactive_timer(&p->dl);
 	}
+	/*
+	 * set_task_cpu() points task_cpu() at the new CPU next. The runqueue
+	 * of that CPU counts this bandwidth only once the enqueue there adds
+	 * it. Until then, no runqueue counts it, as dl_bw_oncpu now says.
+	 */
 	sub_rq_bw(&p->dl, &rq->dl);
 	rq_unlock(rq, &rf);
 }
@@ -4025,6 +4055,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_bw_oncpu		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

