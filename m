Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907260;
	b=QyBQ7zsqEtR3y+HUCW1kWflie//YmZZJgP64KNnRcF+YZPy8NWXTN9GKR+FGD0ONDA8u
	 niZu2w6uXQuEZAttGfxr2rzwvNWy4mfe53Gt6k9RJ5QkzXwzW4JuJhgKgWOjeRtVqQKM3
	 dKV2sv1qSX5bl2qWw+KcUfS3yHUSYYR23zS6OWVs85Ou/+ckr38dQAAS/F7CuZRUve+uC
	 9MKzZ0d0kyOrOQu+5c0jMphIT3fzRfbKZpIQx1F8xSva+CDVmFMRAFngBjtGVi8/dC3pg
	 MkH4alcsSuQ3YfAs7QCcfU9xANJktWEd8InwvHnYJQ8e4D+b49Kj2bzAUEUXFtPmWfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907260;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZDauTg8gKMEyI5TlSf5nU88RVwmY9xMl46WsxT/Kql0=;
	b=g+p2bCGXyVP8vvXI34ApqIv0WjImNwrpGiGYSThyHEiTLsU/8zTlSI8+imGJ7vJHtwrr
	 abaVg5BnCSw7myGcGymXCoQrJ2t6wKOlRrwy5lNFm3PvRG5gRekTtCxmuprHWJB9NdQXw
	 i9Rc3hzpmBguhZD/91CBo/gbVJ8/QbGfIF0spoFp78aII+qWubGDbR8meQNU8n3tRDr4d
	 0EkB3lYXpEnetmGlXP7bmmxoLPtleEI9TtBh8GmYXhLR2kM84p6gEBhFMiYHeHjo02j3W
	 IYj2Eywy/SyAGXXX7hjXd5OZXQUdA8fViX9sBtmxctDznik50q6MvpQCVOYZ1bZcbBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MxUMWdVd;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A36082BFB;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 585A36082BFB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MxUMWdVd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907252;
	bh=ZDauTg8gKMEyI5TlSf5nU88RVwmY9xMl46WsxT/Kql0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxUMWdVd6/pklGok+d+2pr8LCG7Da1OkwGinGCiulCKd2hIdDh9TYu869i232OIsm
	 QdKAOQmhoUCNREpVKOM0ou8rcvk9vdRxSPl98kMQp3XrcLIZcZ90q5jBl1w0NsPgRO
	 to4ktXfkemmarOGDrXL7JxL/2QPnKEeOoiEoXRI+CBL94il8CDG7nmBEQabTEYsVXK
	 L1igVVVzrBrAhUujjYwEDOf+HFvCXsU6Zv/5F+zTRcioAjncQYQDjjVOLnK3xIijMB
	 KHzk1RICiwEueDWTftboNrNr/G1CFucBXhPFLPKWuVgjYBBHpYDjVaEddru2vaDTr0
	 ll+ugCNo1C7VA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDN1NXpzKVJ;
	Thu, 05 Nov 2026 14:34:12 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 20/24] sched/deadline: Count the bandwidth a boosted task is given
Date: Thu,  5 Nov 2026 14:33:55 -0500
Message-Id: <20261105193359.1450487-21-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

The runqueue a sleeping deadline task is on counts the bandwidth of
that task in this_bw, which switched_to_dl() hands it as the task
enters the class. A task that priority inheritance boosted into the
class is in it already: __sched_setscheduler() neither dequeues it nor
enqueues it back, so switched_to_dl() does not run, and sched_setattr()
of SCHED_DEADLINE on such a task leaves this_bw without the bandwidth
the task now has. Its wake-up gives that bandwidth to running_bw alone:

	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);

and the two sums GRUB reclaims from disagree by the bandwidth of the
task until it migrates, where the enqueue adds it (add_rq_bw()).

Change the bandwidth the runqueue counts where the parameters change,
in __setparam_dl(), which every task that gains deadline parameters
goes through, rather than in sched_dl_overflow(), which only a task of
the class reaches that way. A runqueue that counts nothing of the task
takes the new bandwidth, where the previous patch left it to the
enqueue to come: that enqueue finds the bandwidth there and leaves it
(add_rq_bw() of a task a runqueue counts), and a task waking up has
task_cpu() pointing at the runqueue it wakes on. The bandwidth of a
special entity stays counted nowhere, and the request tells one, since
the flags of the entity are those of the parameters it had: a sugov
kthread given a reservation of its own gets that one counted.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f772a944a3e5..746bffb03b7c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -440,22 +440,32 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+/*
+ * The runqueue a sleeping task is on counts the bandwidth the task has:
+ * give it @new_bw in place of what it counts of the task's.
+ */
 static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
-	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq *rq = task_rq(p);
 
 	if (task_on_rq_queued(p))
 		return;
 
 	/*
-	 * Waking up on another CPU, the task has its bandwidth on no
-	 * runqueue: the enqueue to come charges the new one, with the new
-	 * parameters, which __setparam_dl() sets right after this.
+	 * No runqueue counts bandwidth of the task's: this one takes the
+	 * new one, and the enqueue to come leaves it there (add_rq_bw() of
+	 * a task a runqueue counts). A task waking up on another CPU has
+	 * none of its bandwidth on a runqueue, and task_cpu() points at the
+	 * one it wakes on.
 	 */
-	if (!p->dl.dl_bw_oncpu)
+	if (!dl_se->dl_bw_oncpu) {
+		__add_rq_bw(new_bw, &rq->dl);
+		dl_se->dl_bw_oncpu = 1;
 		return;
+	}
 
-	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
 }
 
 static void __dl_clear_state(struct sched_dl_entity *dl_se);
@@ -4234,7 +4244,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		if (counted)
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
-		dl_change_utilization(p, new_bw);
 		err = 0;
 	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
 		/*
@@ -4283,6 +4292,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
+
+	/*
+	 * The bandwidth of a special entity is counted on no runqueue, and
+	 * the request tells one, the flags of the entity being those of the
+	 * parameters it had. The rest have theirs changed here, where their
+	 * parameters are:
+	 * switched_to_dl() hands it to the runqueue of a task that enters
+	 * the class, and a task that priority inheritance boosted into the
+	 * class is in it already, so nothing dequeues it and enqueues it
+	 * back for that.
+	 */
+	if (!(attr->sched_flags & SCHED_FLAG_SUGOV))
+		dl_change_utilization(p, to_ratio(period, attr->sched_runtime));
 
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
-- 
2.47.3

