Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207367;
	b=Yn2Y6KsRA06Ihtr7gZx1XxyNYmi8nNUh0pOl8Oa5TKEO3Np7SI249o581qlCN0lOYKps
	 K4kTja7lXXJPbRO5udGRDd+RYGnzQWiYgNHLzCSEIHyy8b6hZPMY/IbL1nMsD0cXK5DKH
	 oqFN1IDQp8GDvJGL1C0nz3T5I5UKHeYlrDYrvXj5Yrc4Q7yMkkd5ucq7Jn9CfJ48/7myS
	 E14JRw5H1cURW7neREb845hwugl1UYGtv0J1GK8tG8Z3G9OTgSxWYC1dWwh0Md0MXix2F
	 PUJ+izGgVfEBfUn0pgHol4YgrJbTQUP7uGnQl0Dq/UIkVBvEYRqFdACAFAiyvSJJmhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207367;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kKyiD7FHFgIYWRX4t4LiS2y4r69/huBh9nxHCzpiCvw=;
	b=TCwuF9FDKhrVxJSwJa9SnFgbXDBVhW0wXS0M75MkzT1nXNFnP3FUP7WLTisE/o725AlS
	 /GHk5FoH52rwHVStMcOr4Y2OpjvPDHvBpHy0KkBVOAw06/kXXI02t71PP2lQ2XLix7evT
	 LxEKO3uhIi4/B7hI8F2hYcjEhj20dT2dWbvI2Su3C4H7Caf/NC2bDNLZCtGEd+G9G2/4m
	 Tc4C8oBY42iDu+AP5EtR0+tdUCDdx+yssJrADRcON9IC6y6G6z1v18eZY2aUCQ81IUgYv
	 EXFx4HQmGJaPiuWQ/UOlHoKiC12tenqC8Qe6M2hmsMaz4XiFBMaLTSv4ALhPSEJc/8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xfRpkDyz;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E2760A3830;
	Fri, 20 Nov 2026 20:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96E2760A3830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xfRpkDyz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207357;
	bh=kKyiD7FHFgIYWRX4t4LiS2y4r69/huBh9nxHCzpiCvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfRpkDyzPsWtCwDNP3Akij33m+ZIDETsY4KAhkRdZpn0auk3TOPRklwlwEdQter51
	 iAuyYV2S8lfqAhVt3KLvUHM6XswaiLQ1sLBGfW6ZoXEclMPvUkp27wvQysmToJV9r2
	 xLX1qs7FELsq5I27zSpXGNcJOEwZb9mgtGkTEaYh18yuW+ciMbk7RYMCYKzh726aUR
	 l+dme0kPAQvdnlkeok4cRxCc7X+cRNV4kGL9LR+Hm+uyd9vss8Vj5F+WrlwnMu/6JM
	 BrPdJ6vIWAubRq6+Ic0WfgY7vO65gYWPBNMhcAEe1LyZzYvTmYE4YXnQ17UAC8uDUD
	 hqaPYX8HZk4Zw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2P47hQzTqh;
	Fri, 20 Nov 2026 15:42:37 -0500 (EST)
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
Subject: [PATCH v10 30/40] sched/deadline: Start a period for a task requeued onto an rt_mutex
Date: Fri, 20 Nov 2026 15:42:07 -0500
Message-Id: <6c7be87e201d405bdf589989cb45afca9160c2e4.1795207232.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

The waiter node of an rt_mutex holds the deadline of its task, as a sort
key. task_blocks_on_rt_mutex() copies it when the task blocks. A task
that blocks by itself is running, so its deadline is a current one.

FUTEX_CMP_REQUEUE_PI is different. It makes a task that sleeps in
FUTEX_WAIT_REQUEUE_PI wait on the rt_mutex of a PI futex, with
rt_mutex_start_proxy_lock(). That task is not running. Its deadline can
be one that it would never run with:
- 0, if sched_setattr() made it SCHED_DEADLINE while it slept.
  switched_to_dl() leaves its deadline to its next wakeup.
- one that has passed, if it slept past it.

The waiter then sorts before the waiters with a real deadline. At the
unlock, it gets the lock before waiters with earlier deadlines. Its
deadline also decides the boost of the owner.

Fix this in task_blocks_on_rt_mutex(): dl_proxy_block() starts a new
period for such a task, as its wakeup would. A task past its
deadline and before its next period keeps its deadline: its wakeup
throttles it until that period.

The Sashiko AI review of this series found this. The case
requeue_pi_new_period of deadline_bw_test, added later in this series,
tests the deadline of 0. It fails without this patch.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h |  1 +
 kernel/locking/rtmutex.c       |  3 +++
 kernel/sched/deadline.c        | 30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index a2479c6ddbf0..377f00aec6d9 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -62,6 +62,7 @@ extern int dl_task_bw_reserve_cpu(struct task_struct *p,
 				  const struct cpumask *new_mask);
 extern int dl_task_bw_reserved_cpu(struct task_struct *p);
 extern void dl_task_bw_unreserve(struct task_struct *p);
+extern void dl_proxy_block(struct task_struct *p);
 extern bool dl_task_keeps_root_domain(struct task_struct *p,
 				      const struct cpumask *new_mask,
 				      const struct cpumask *pending);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index b09816977d4e..5ff123d24b2a 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1245,6 +1245,9 @@ static int __sched task_blocks_on_rt_mutex(struct rt_mutex_base *lock,
 		return -EDEADLK;
 
 	raw_spin_lock(&task->pi_lock);
+	/* A proxy lock: @task sleeps, and its deadline can be stale. */
+	if (task != current)
+		dl_proxy_block(task);
 	waiter->task = task;
 	waiter->lock = lock;
 	waiter_update_prio(waiter, task);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b1346be9e81d..1c5888b1717d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1573,6 +1573,36 @@ static inline u64 dl_next_period(struct sched_dl_entity *dl_se)
 	return dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period;
 }
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * FUTEX_CMP_REQUEUE_PI makes @p wait on an rt_mutex while @p sleeps.
+ * The waiter node of @p takes its deadline, before any wakeup. @p would
+ * not run with a deadline of 0, which it has if it entered the class
+ * asleep. Nor would it run with a deadline that has passed. Start a new
+ * period then, as its wakeup would. Leave a task past its deadline and
+ * before its next period: its wakeup throttles it until that period.
+ *
+ * The caller holds the pi_lock of @p.
+ */
+void dl_proxy_block(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq_flags rf;
+	struct rq *rq;
+
+	if (!dl_task(p) || is_dl_boosted(dl_se) || !dl_se->dl_runtime)
+		return;
+	rq = __task_rq_lock(p, &rf);
+	update_rq_clock(rq);
+	if (!task_on_rq_queued(p) && !dl_se->dl_throttled &&
+	    dl_time_before(dl_se->deadline, rq_clock(rq)) &&
+	    (dl_is_implicit(dl_se) ||
+	     !dl_time_before(rq_clock(rq), dl_next_period(dl_se))))
+		replenish_dl_new_period(dl_se, rq);
+	__task_rq_unlock(rq, p, &rf);
+}
+#endif
+
 /*
  * If the entity depleted all its runtime, and if we want it to sleep
  * while waiting for some new execution time to become available, we
-- 
2.47.3

