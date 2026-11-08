Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164063;
	b=2UP2gpPrx3hqVrUXCFU35uNYZgwer7rW0h2H7lVgtNuZSqsOkTivZ3vZkFr7VAewJROS
	 6rt9my4I3KhSwk3qDfz/igOZs98k9MQzIz+D7mjoAU9xpZXFpW+Dk4h3+8kGzyE7xMj63
	 4jkAspkErsIrlaAvVQv+hUF97NmBZe22Tv0wPanG/FhR3Ze7yMSCEU3uGNZ+viJeDXmD9
	 GI2sWB/FIMRyhRzPeInKv/Z6R5hMNOvz1Zpd0hL3N7+EP98xE0oX3ixfDCbUVSGRBzpew
	 9hTC3dgWYgICH1nklljC5Ev7lfW7PgKmtzACPLv1VClszqZ2wL/FvkwFRlhdIvGNXuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164063;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9uig5ZwLtSCENSHUOsETH0vcZlIH+P2qYjeKgnomDkg=;
	b=B854Gpoh9YJvft3koKmI5IJRfGHFm0AxtQ1ZPIENVQbBdmHU+jmQud0co30w2I5B0eSM
	 +ajhcO7Np68nblTnr8jKR5/w1Z6e6WjRS0cKDuC7yogQfJ0Yo6o8j4Bl9aTYPVM58pCFk
	 bAioKBJfzsgjc1U3fNmq/oE4AfkYUSJjzamOPqFd96IHqnriSXOOItD+KgXIR62lsxLTe
	 qv4kviPL7ZL09RIBRTb3J+9vOwIu97v+N5Q6cchZ7D5I6iuIO6Duw6MQjRwq5lcNRvsXu
	 JJRVUByCP2YsNg3iHB5/cNl9EqAgUFl8XaiowpobIh+HLTx7NL9+l9fI8fBfFgkc6Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QFgj+TP1;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF16A606EE8C;
	Sun,  8 Nov 2026 18:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF16A606EE8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QFgj+TP1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164061;
	bh=9uig5ZwLtSCENSHUOsETH0vcZlIH+P2qYjeKgnomDkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFgj+TP1FbCVYOvIShz6G1OerSPVUnDKQON1x9DYC9Gv9Pp0iDAT84qTdUxHfAoE9
	 qTcL2RCO9Eot08uIJOfly0JzIJb2Y2TlW3hB9O3xxkGP1Uk7u9/KflB7iukYOjCYHN
	 kEMAtgemNBHP1IW02Mp8/kSU2Q00ckdY5rKZQvXCs583xJvC7Gu6tXU112T286h7pZ
	 ix7rgDa6bysWzcTH1oqtlI7Ossx9wVuGc2rGLZGgOC4kkLblIg4BbdGjup0pe/EcdB
	 CUafzMrkvqpuR40iE4bRQl0hU4UKtURVxc5oJ1MyJds1AS6jI4/iBUOuTMx+/2z0hV
	 vqP5XRF2zPenA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C06ZGJzM5v;
	Sun, 08 Nov 2026 13:54:20 -0500 (EST)
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
Subject: [PATCH v5 11/29] sched/deadline: Release the bandwidth of a task that leaves the class asleep
Date: Sun,  8 Nov 2026 13:53:48 -0500
Message-Id: <20261108185406.1549770-12-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE while it is not queued can keep its
bandwidth in total_bw until the next rebuild of the root domains.
Repeated, this fills total_bw up to the admission limit. Then
sched_setattr(SCHED_DEADLINE) and CPU offlining fail with EBUSY.

A task that leaves the class keeps its bandwidth until its 0-lag time.
Releasing it earlier would allow temporary overloads. For a queued task,
switched_from_dl() calls task_non_contending(). It releases the
bandwidth if the 0-lag time is past. Otherwise it arms the inactive
timer, which releases it then. For a task that is not queued,
switched_from_dl() relies on the timer armed when the task blocked.

But that timer is not always armed. The task may have blocked after its
0-lag time. Or the timer fired while the task was still in the class,
and only removed running_bw. Then nothing releases total_bw. The timer
is also cancelled before the 0-lag time when the task wakes up on
another CPU, or comes back to the class asleep.

Fix this in switched_from_dl(), for a task that is not queued and has no
timer pending. If the 0-lag time is ahead, arm the timer. If it is past,
release the bandwidth now. Then clear the parameters, as
inactive_task_timer() does, so that no later path releases the bandwidth
again. A timer handler that already started finds a dl_bw of 0. The
deboost of a later priority inheritance boost finds no parameters. Since
"sched/deadline: Take a deadline boost from the waiter's rt_mutex node",
a boost that the task gives as a waiter does not read them.

Juri Lelli's first fix, since dropped from tip, released the bandwidth
here without clearing dl_bw. The bandwidth of a boosted task was then
released twice.

The Sashiko AI review of the third posting found the two cases with the
0-lag time ahead. deadline_bw_test, added later in this series, tests
this in pi_former_owner_asleep and deboost_released_resets_period.

Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Reported-by: Tejun Heo <tj@kernel.org>
Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 98 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 81 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e6c55afcfd01..d5d0f87d3a94 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -403,6 +403,23 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 
+/*
+ * Return the 0-lag time of @dl_se, relative to the clock of its runqueue.
+ * After @dl_se blocks or leaves the class, its utilization counts until
+ * that time.
+ */
+static s64 dl_zero_lag(struct sched_dl_entity *dl_se)
+{
+	struct rq *rq = rq_of_dl_se(dl_se);
+
+	/*
+	 * Using relative times instead of the absolute "0-lag time"
+	 * allows to simplify the code
+	 */
+	return dl_se->deadline - rq_clock(rq) -
+	       div64_long((dl_se->runtime * dl_se->dl_period), dl_se->dl_runtime);
+}
+
 /*
  * The utilization of a task cannot be immediately removed from
  * the rq active utilization (running_bw) when the task blocks.
@@ -476,15 +493,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
-	zerolag_time = dl_se->deadline -
-		 div64_long((dl_se->runtime * dl_se->dl_period),
-			dl_se->dl_runtime);
-
-	/*
-	 * Using relative times instead of the absolute "0-lag time"
-	 * allows to simplify the code
-	 */
-	zerolag_time -= rq_clock(rq);
+	zerolag_time = dl_zero_lag(dl_se);
 
 	/*
 	 * If the "0-lag time" already passed, decrease the active
@@ -3606,15 +3615,69 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	dec_dl_tasks_cs(p);
 
 	if (!task_on_rq_queued(p)) {
-		/*
-		 * Inactive timer is armed. However, p is leaving DEADLINE and
-		 * might migrate away from this rq while continuing to run on
-		 * some other class. We need to remove its contribution from
-		 * this rq running_bw now, or sub_rq_bw (below) will complain.
-		 */
-		if (p->dl.dl_non_contending)
+		bool released = false;
+
+		if (p->dl.dl_non_contending) {
+			/*
+			 * Inactive timer is armed. However, p is leaving
+			 * DEADLINE and might migrate away from this rq while
+			 * continuing to run on some other class. We need to
+			 * remove its contribution from this rq running_bw now,
+			 * or sub_rq_bw (below) will complain.
+			 *
+			 * inactive_task_timer() will find !dl_task(p) and
+			 * release total_bw via __dl_sub().
+			 */
 			sub_running_bw(&p->dl, &rq->dl);
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl) &&
+			   dl_zero_lag(&p->dl) >= 0 &&
+			   !hrtimer_active(&p->dl.inactive_timer)) {
+			/*
+			 * No inactive timer is armed, but the 0-lag time is
+			 * ahead. Either the task is waking up on another CPU,
+			 * and migrate_task_rq_dl() cancelled the timer. Or it
+			 * came back to the class asleep, and switched_to_dl()
+			 * cancelled it. Arm the timer, as for a queued task.
+			 * Its handler finds the task out of the class and
+			 * releases total_bw. running_bw is already off this
+			 * runqueue, or was never on it.
+			 */
+			task_non_contending(&p->dl, false);
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
+			/*
+			 * No inactive timer is armed, and the 0-lag time is
+			 * past. Either the task never ran in the class, or it
+			 * blocked after its 0-lag time. Or the timer fired
+			 * while the task was still in the class. Nothing else
+			 * releases total_bw, so release it now.
+			 *
+			 * A timer whose handler already runs also leads here,
+			 * since hrtimer_active() is true. The handler waits
+			 * for the runqueue lock, then finds a dl_bw of 0,
+			 * cleared below.
+			 *
+			 * A task deboosted from priority inheritance, with no
+			 * parameters of its own, has no bandwidth in total_bw.
+			 * Neither has a special task.
+			 */
+			struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
+
+			raw_spin_lock(&dl_b->lock);
+			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
+			raw_spin_unlock(&dl_b->lock);
+			released = true;
+		}
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Clear the parameters too, as inactive_task_timer() does at
+		 * the 0-lag time. Then no later path releases the bandwidth
+		 * again. A later priority inheritance boost sees a task with no
+		 * parameters of its own. task_contending() and
+		 * task_non_contending() skip it, and its deboost releases
+		 * nothing.
+		 */
+		if (released)
+			__dl_clear_params(&p->dl);
 	}
 
 	/*
@@ -4014,7 +4077,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 }
 
 /*
- * This function clears the sched_dl_entity static params.
+ * This function clears the sched_dl_entity static params, and the state
+ * of its current period.
  */
 static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
-- 
2.47.3

