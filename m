Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207378;
	b=zyEQAXpoT3MBeuIH5iqmUMd9Fa0oK0HtRx2T6EZaohCaxcoEFBKXxv4ub/b3ypP9iGDm
	 tDkK/NbDmG07GUl3udVHZ8vBzozQjm5QagY5yUbNuuZyjk32uMz7CEq8uGk2MjZzVw1Bw
	 LQ6jwSF0iPieiUhVHmyGD4EOJcKhkcs0nKhuCh/Odau/CB4q4gdxK0uaZaa13noN6ntOx
	 9clOae3GPq4Nv2AyGajVUyLLHfvJAYo2chk0L+w6u9y/2zQ6RItxkIsZSwvd1rGRpGxLi
	 nn/H/U159kZWmMzcRgPcJypHUKnO0mi+tnbbQLzD6pJfFq0GNYfYFMVfQswTB1EcUbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207378;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/WfV8vGSyqQt7k7lOokOJoO6ZkJTLOy+uFOX22pJNBY=;
	b=1fo/1IB36aW+F7Z0SydHhqwaRzbrXgTXbiifw/r3cuPyz4SLVIkmIrUdsbKpOEtDfxWx
	 Z1Zg9J2OonSRwye6Y1aLRMFvE6MjCWOs6PKQq/gf8Tbbuwz2aN/QKRLmPN+NdtdE7xBVa
	 ExueHJabpruwEy6MzMaZrdrYct7vvHCFGqnq1ZiiFYTqzoq/nMSyD77CyOT2OpUYv8riU
	 F0/HdKcn7EG4S3Zaioowa3ql+7XB2GjWO4psKnCG9SjdwYht5hWV1KJB32TUD4qUlt6wH
	 K+nUuts8HGBOTDaN9i9dmYLclbGDe8m4OIBHN0ZUmpPThH4GeyXSaxNyKWCvVhnq5Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nQW4xbIx;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C360A2620;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE5C360A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nQW4xbIx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207357;
	bh=/WfV8vGSyqQt7k7lOokOJoO6ZkJTLOy+uFOX22pJNBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQW4xbIxUPHnGpgDojDFsc+h/50MQMrO40ygmLz8bMvrfA5slRsoXyzx9zCEr23VN
	 urGJBrp5bbs3xsfMdWSZuGiY1e732O7PvuceCgRaSRggcgEaYcfu1KbJXhshqbC/NQ
	 fw30J5fSy3k/suROMDeAdE6gTbH7i+gVQeze9wlmZTPfkTlkj7ChrS1cfoFz0lcOzr
	 YhHSfz6g4isHK1BIJivdws4D0WEQpRQQ55/Jqd9dGX55MvBQqLvPpNRX9vq7Ae6SQ+
	 PZHIQADaQTB+yHomzP5huZXfLaAGk82fQbROgwMMvRvECZIApryMdrJo/zA9l3z7vu
	 9U9P6RojCr3gQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2P0KB1zTqf;
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
Subject: [PATCH v10 28/40] sched/deadline: Start a period for a task that enters the class blocked
Date: Fri, 20 Nov 2026 15:42:05 -0500
Message-Id: <0557a76f35a09f1caa281777e3926d3446a7c74e.1795207232.git.mathieu.desnoyers@efficios.com>
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

Commit fb00aca47440 ("rtmutex: Turn the plist into an rb-tree") sorts
the waiters of an rt_mutex by priority. For deadline tasks, "the one
with the earliest deadline wins". A waiter takes the deadline of its
task.

A task can enter the class while it waits on an rt_mutex.
sched_setattr() can make it SCHED_DEADLINE. A priority inheritance
boost can also put it in the class, if it owns another rt_mutex.
switched_to_dl() does not set up a task that is not queued. Its wakeup
does. But the chain walk reads the deadline before that wakeup, and
copies it into the waiter. A task new to the class has a deadline of 0.

So the waiter goes before every other deadline waiter. It takes the
rt_mutex first, whatever their deadlines. Those waiters can then miss
their deadlines. It also boosts a deadline owner whose own deadline is
earlier.

Fix this by starting a new period in switched_to_dl() for a task that
waits on an rt_mutex, if its deadline has passed. The period uses the
reservation the task runs on: its own, or the copy a boost made. This
is what setup_new_dl_entity() does at an enqueue. At the wakeup,
update_dl_entity() then checks that period as for any wakeup.

A new donor of a task with no parameters of its own needs the same. For
a queued task, the enqueue of the boost starts a period from the new
donor. For a blocked task, dl_boost_blocked() starts it at the boost.

The setattr_blocked_keeps_order and boost_blocked_keeps_order cases,
added to deadline_bw_test later in this series, test this. Both fail on
v7.4-rc2 and on the series without this patch. The triage of the Sashiko
AI review of this series found the bug.

Fixes: fb00aca47440 ("rtmutex: Turn the plist into an rb-tree")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c     |  4 ++++
 kernel/sched/deadline.c | 46 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  1 +
 3 files changed, 51 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 94099ebb6246..75bfde7046fb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7969,8 +7969,12 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
 			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
+				struct sched_dl_entity *old_donor = p->dl.pi_se;
+
 				dl_set_donor(&p->dl, pi_task);
 				scope->flags |= ENQUEUE_REPLENISH;
+				if (!scope->queued && p->dl.pi_se != old_donor)
+					dl_boost_blocked(p);
 			} else {
 				dl_deboost(&p->dl);
 				/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aa12908aeaea..ee3a08ff3345 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -139,6 +139,12 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	}
 	dl_drop_boost(dl_se);
 }
+
+/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return p->pi_blocked_on;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -153,6 +159,11 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
 }
+
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return false;
+}
 #endif /* !CONFIG_RT_MUTEXES */
 
 static inline u8 dl_get_type(struct sched_dl_entity *dl_se, struct rq *rq)
@@ -1184,6 +1195,30 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 	trace_sched_dl_replenish_tp(dl_se, cpu_of(rq), dl_get_type(dl_se, rq));
 }
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * Start a period from the new donor of @p, if @p has no reservation of its
+ * own and waits on an rt_mutex. The enqueue does this for a queued task, in
+ * replenish_dl_entity(). A blocked task is not enqueued, but the chain walk
+ * copies its deadline into its waiter.
+ *
+ * The caller calls it only when the donor changes. A new period changes the
+ * deadline, so the chain walk finds the waiter out of date and goes on. In a
+ * ww_mutex cycle, a new period at each step would never let the walk stop.
+ *
+ * The caller holds the rq lock and the pi_lock of @p, and has updated the
+ * rq clock.
+ */
+void dl_boost_blocked(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	if (!dl_se->dl_deadline && !dl_se->dl_throttled &&
+	    dl_task_pi_blocked(p))
+		replenish_dl_new_period(dl_se, task_rq(p));
+}
+#endif
+
 /*
  * We are being explicitly informed that a new instance is starting,
  * and this means that:
@@ -4725,6 +4760,17 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (!task_on_rq_queued(p)) {
 		add_rq_bw(&p->dl, &rq->dl);
 
+		/*
+		 * A task that waits on an rt_mutex cannot wait for its wakeup.
+		 * The chain walk sorts its waiter by its deadline first. A task
+		 * new to the class has a deadline of 0, which goes before every
+		 * real one. Start a new period now, as setup_new_dl_entity()
+		 * does at an enqueue.
+		 */
+		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
+		    dl_time_before(p->dl.deadline, rq_clock(rq)))
+			replenish_dl_new_period(&p->dl, rq);
+
 		return;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 516a49370713..e512091ce5ed 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -413,6 +413,7 @@ static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
 }
 
 extern void dl_deboost(struct sched_dl_entity *dl_se);
+extern void dl_boost_blocked(struct task_struct *p);
 
 /* End the boost of @dl_se. The caller holds the rq lock of its task. */
 static inline void dl_drop_boost(struct sched_dl_entity *dl_se)
-- 
2.47.3

