Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924681;
	b=iSTR5Om1aVmog+NVvxWhF63kOjtWMHqnihVDgi415geaJAzCZCtXCdCdkWViZ13EJvQM
	 DfTrSriSuX69tiikm+xfzONxtOLBpMYnMjJFBduoJMIsX3BiCC+vLJtrEMKhtHfyOxbu1
	 ROLNh19sbvf0uAJ+TLj3xt/Z4qfOsEEjkm1qAZeELlCotHG8EhQda6bI+/h9vN7pEvF/z
	 g7dOStOST/0GzvGrc0kDT0rsZxQTxVACt7i92GuFc878Twg1KQPgeUTl0op3t7cHExZKX
	 CFpWY1RgNYkn7GSFDjf0THKTu9JcKP57xQ796K9EtiK4YndYdVi8v5VuZGjK92Z14mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924681;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oZjXPAOPF8m2VsnPeePziDsJ1Q/Hj5FFmshdos7Pn5I=;
	b=IYt6OXV5VlPITlTd7o8z1sf4OVRh6OZDUdik3UpWfUFyv6IeXJX5tblX9SmuNHJt+h20
	 6ZH/zuAzZQ9sX7MbBcwNrjODyMco4tA0P3kwmwxsVNmIgV73RCPZ1xBW2631H55XnVF+9
	 bS0ZggGQ4KrL5knb04TcpOMwdWjtaWNnGA9N0jmAHBRTgVV0HMTLkbMyOKPEtT7/2FrA1
	 XW9X3Zvrsl5FLabp7573KNfVhsjT6GQbjv61eC4iul4vUnjzJwkw8Rvhkhy9ZXxSJn066
	 Gqn4irMgNSVa8fPAVultNkrM3o6Agpa+4GASpLxirk76mYV9qcpfXhLMnqK+CK/c7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p9BlOH2k;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC6606E313;
	Tue, 17 Nov 2026 14:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5AC6606E313
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p9BlOH2k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924670;
	bh=oZjXPAOPF8m2VsnPeePziDsJ1Q/Hj5FFmshdos7Pn5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9BlOH2k4sDlQnqhU0m/xb+nEn/gKdhoBN5DMVdC6Z/d0lxraee2sAHexhQ18rlqT
	 gfkGYZUA/uLZyY9+rMVQGwzQ4T39oGkJLOwnm0503nTMDpNdCYdbDfgyDPTOBdusgy
	 bDqks+p4uHH4D8SJ5TwCHpTPctOP1bM2w+KiiO1scnnkJ0EeHRs/D5UxvtmW5oo8QF
	 qqTgqyvqpgI4LtkAxyCGmWCv84q5cfKZmNkimBQE2rTmFCMqh1+kO2/mHiQnQlECDL
	 ju/rgAKvOitVr7qTWSUz48mLe867Rbnm3TqNLRAxS3EY0x9jxzuvC6R4TAvFN8Z3jL
	 EXhEOQE8W3OZA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV61QtQzRBZ;
	Tue, 17 Nov 2026 09:11:10 -0500 (EST)
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
Subject: [PATCH v7 32/40] sched/deadline: Count the bandwidth a boosted task is given
Date: Tue, 17 Nov 2026 09:10:53 -0500
Message-Id: <a79d666a3170cbcddba23b2387239a958380aa6d.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

sched_setattr(SCHED_DEADLINE) on a sleeping task that priority
inheritance boosted into the class leaves the new bandwidth out of
this_bw. switched_to_dl() does not run, since the task is in the class
already. sched_dl_overflow() changes this_bw only for a task of the
deadline policy. When the task wakes up, __add_running_bw() warns:

	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);

When the task leaves the runqueue, this_bw would stay short by that
bandwidth, and skew GRUB reclaiming on that CPU.

Fix this by changing this_bw in __setparam_dl(), which every task that
gains deadline parameters goes through. If no runqueue counts the
bandwidth of the task, dl_change_utilization() now adds the new one. It
now also runs when the bandwidth does not change. It then returns early,
so that a sleeping task keeps its running_bw and its inactive timer.

A sugov kthread given a reservation of its own now has its bandwidth
counted in this_bw. It reaches dl_change_utilization(), so the
WARN_ON_ONCE() for SCHED_FLAG_SUGOV there goes. sched_dl_overflow()
returned early for an unchanged bandwidth, even if no root domain counts
it. That is the case for such a kthread, and for a task that a rebuild
left out. Admit such a bandwidth as new. Without room, that fails with
EBUSY. The Sashiko AI review of the third posting found this early
return.

A reproducer shows the warning, and this_bw unchanged by the change.
With this patch, this_bw takes the new bandwidth, and nothing warns.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 54 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b9268c52935d..0b3005948313 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -573,22 +573,37 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+/*
+ * Make the runqueue of a sleeping task count @new_bw as the bandwidth of
+ * the task. Do nothing for a queued task. The dequeue and the enqueue
+ * around the change of its parameters update this_bw.
+ */
 static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
-	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq *rq = task_rq(p);
 
 	if (task_on_rq_queued(p))
 		return;
 
 	/*
-	 * The task is waking up on another CPU, and no runqueue counts its
-	 * bandwidth. The enqueue adds it, with the new parameters that
-	 * __setparam_dl() sets right after this.
+	 * No runqueue counts the bandwidth of the task. Add the new one to
+	 * this runqueue, so that add_rq_bw() adds nothing later. A task that
+	 * enters the class asleep comes here, and so does a special entity
+	 * given a reservation of its own. So does a task waking up on
+	 * another CPU: task_cpu() already points at the CPU it wakes on.
 	 */
-	if (!p->dl.dl_bw_oncpu)
+	if (!dl_se->dl_bw_oncpu) {
+		__add_rq_bw(new_bw, &rq->dl);
+		dl_se->dl_bw_oncpu = 1;
+		return;
+	}
+
+	/* Same bandwidth: leave running_bw and the inactive timer alone. */
+	if (new_bw == dl_se->dl_bw)
 		return;
 
-	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
@@ -4677,10 +4692,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (attr->sched_flags & SCHED_FLAG_SUGOV)
 		return 0;
 
-	/* !deadline task may carry old deadline bandwidth */
-	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
-		return 0;
-
 	/*
 	 * Change the bandwidth of a deadline task where it is counted: in
 	 * the root domain of the CPU recorded with it. A task moved asleep
@@ -4695,6 +4706,16 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 */
 	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
 		  p->dl.dl_bw_gen == dl_bw_gen;
+
+	/*
+	 * !deadline task may carry old deadline bandwidth. The same
+	 * bandwidth needs no admission if it is counted. If it is not, admit
+	 * it as new below. A special entity given a reservation of its own
+	 * has no bandwidth counted, nor has a task that a rebuild left out.
+	 */
+	if (new_bw == p->dl.dl_bw && counted)
+		return 0;
+
 	cpu = counted && p->dl.dl_bw ? p->dl.dl_bw_cpu : task_cpu(p);
 	dl_b = dl_bw_of(cpu);
 
@@ -4724,7 +4745,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		if (counted)
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
-		dl_change_utilization(p, new_bw);
 		err = 0;
 	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
 		/*
@@ -4774,8 +4794,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
 	bool held;
 
+	/*
+	 * Change the bandwidth that the runqueue counts here, with the
+	 * parameters. A task that priority inheritance boosted into the
+	 * class is in it already, so switched_to_dl() does not run for it.
+	 *
+	 * A special entity has no bandwidth on a runqueue. Test the flags
+	 * of the request, since those of the entity are still the old ones.
+	 */
+	if (!(attr->sched_flags & SCHED_FLAG_SUGOV))
+		dl_change_utilization(p, to_ratio(period, attr->sched_runtime));
+
 	held = dl_se_holds_bw(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
-- 
2.47.3

