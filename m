Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015900;
	b=l+nKiM8gOdIZEMA9jg4NEtVNfV1gQk0Qo1K5pEg4uRyaDXubUerbo5rA/m9qjzADHYyy
	 oT+baUV4hDYHzdwlD6qAne1QgYCQ2ibx9002w+4pTh0dE/eWxp0dOojSyn1M16wSodRIg
	 Z115jkz8M7+qu0Ec4oErL7oSaR4u68CWc/XD6/4f0PHzne4t9eauwyD10wjdBHRhwE/Ii
	 vnmuybNARLhgOGeMGO+WgQKGGcDuSyXkesQEoBN9onE1uP0s1YxgxI5uOVlyhhuhOr8F7
	 N3Fpu2NScIw9yH+q6cBUBRzjPhkzEqizIhBnPBrwYwa7oXDRg3p69L5HU5W7DH4VQ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015900;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oJrZ/XR2HiFstwx5GpsmznXLz0IyXlH94OZ3vU0MTyc=;
	b=JLLnfZ9poQKDsi6u7MbNY98BsJJeRoDG52TmmgjiXojnlNYQqZekDmaUzvIpMcqIdjL0
	 u3QI+UPab+VSJG4QTI/9FQFxmkX7TxyBDbCTdguI48LLQ6mdU14+5paKJRAWS/m6T2evx
	 MOzG1AS1TTfNZr8yUIyhZuUVv+jyTorWaRN8YeOYsgPX1RvW1+Nx2u7nOEenJI7/XsZ5e
	 qW4pqL4F6711xkLG7DfUSTZU7CQHRKRrVT3oq08Xx7FXHOq+f903hd2N8ZeJpkXLdWpy5
	 wNvTUlQJ4rPRwszqMQkXNxYiMburyfxwrTsVbLvbNYniPp4WabqFQfFxHk8FI5SP/Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LiPhHFn6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A36606A330;
	Sat,  7 Nov 2026 01:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8A36606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LiPhHFn6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015899;
	bh=oJrZ/XR2HiFstwx5GpsmznXLz0IyXlH94OZ3vU0MTyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiPhHFn6dw9JtPAj6H9uu8m+gE9Y06RoKfCA/ez6YC8YY5YBUElM4Dfxn2cHZhB/N
	 tH3i5hrUT4IHSQ9vCcQWdfgRWI5EQDa/vwEmJvEePh+EHeTFoA6SM6Fdbpa3iZecne
	 d1GfsxDBxmnQKw29C4QbbEo2XbeU5IYlPOmLDPzFSdzxTGWhZO0PI++lBxFVNNaTSr
	 TpMy9HrS0FrQlpW8b4AhHxnjeTDAvEUCJqWgw8rvKSzYs1f6V2KOSq3Sur3JQNBRme
	 yM392utK9LJkI06IjXdehwZ2b0yXMAFZFOD1xUFTODmL7ozytCo9MEhkwWnpIwY3Ll
	 h9zh+aPJSgHkQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPk63vRzLgQ;
	Fri, 06 Nov 2026 20:44:58 -0500 (EST)
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
Subject: [PATCH v4 02/26] sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or the class
Date: Fri,  6 Nov 2026 20:44:27 -0500
Message-Id: <20261107014451.1487825-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

SCHED_FLAG_KEEP_PARAMS keeps the parameters of a task:
__sched_setscheduler() skips __setscheduler_params(), which is what sets
p->policy, and the sched_class assignment with it. A request that asks
for another policy is then carried out by half, and succeeds:

 - a class change, SCHED_DEADLINE to SCHED_OTHER, sets DEQUEUE_CLASS:
   sched_change_begin() runs switched_from_dl() on a task that stays in
   the class, and sched_change_end() switched_to_dl(). A sleeping task
   has its bandwidth taken off its runqueue there, and taken off again
   when it does leave: this_bw underflows;
 - a policy change within the class, SCHED_OTHER to SCHED_BATCH, returns
   0 and leaves the task where it was;
 - a task that priority inheritance boosted into the deadline class is
   of that class already, and a request for SCHED_DEADLINE finds
   prev_class == next_class: sched_dl_overflow() admits it and adds its
   bandwidth, which the skipped __setscheduler_params() never gives to
   the task. It keeps SCHED_NORMAL and a dl_bw of 0, so nothing releases
   that bandwidth, and total_bw of the root domain holds it for good.

Refuse a request for another policy or another class, before
sched_dl_overflow() reserves bandwidth, since nothing gives back what it
reserves: a refusal after it would leak the runtime that sched_setattr()
fills in from the task's slice, up to 100ms with a custom one, into
total_bw. A refused request also leaves sched_reset_on_fork as it was.

A SCHED_OTHER owner of a PTHREAD_PRIO_INHERIT mutex with a slice of
40ms, boosted by a deadline waiter blocked on it, leaves 0.4 of a CPU
behind at every such call: total_bw 419424 -> 838854 and there to stay,
in 8-CPU VMs of v7.4-rc1. With this change the call is refused and
total_bw is as it was. The selftest added later in this series has the
case, params_keep_boosted.

The class change was found by Juri Lelli from a report of Tejun Heo, and
refused, after the reservation, by his "sched: Reject
SCHED_FLAG_KEEP_PARAMS when it would change scheduling class", since
dropped from tip. The policy change and the boosted case were found by
the Sashiko AI review of the first posting of this series.

Link: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-3-dd761fe005b4@redhat.com/
Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 2af550f92ac6..6819f0fea3c5 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -647,17 +647,6 @@ int __sched_setscheduler(struct task_struct *p,
 		goto recheck;
 	}
 
-	/*
-	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
-	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
-	 * is available.
-	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
-		retval = -EBUSY;
-		goto unlock;
-	}
-
-	p->sched_reset_on_fork = reset_on_fork;
 	oldprio = p->prio;
 
 	newprio = __normal_prio(policy, attr->sched_priority, attr->sched_nice);
@@ -677,9 +666,38 @@ int __sched_setscheduler(struct task_struct *p,
 	prev_class = p->sched_class;
 	next_class = __setscheduler_class(policy, newprio);
 
+	/*
+	 * SCHED_FLAG_KEEP_PARAMS prevents the policy and the class change
+	 * from actually happening: it skips __setscheduler_params() and the
+	 * sched_class assignment. Reject the contradictory requests that
+	 * ask for either, rather than carry out half of what they ask.
+	 *
+	 * A class change with the policy kept is one of them: the class of a
+	 * policy depends on the priority that priority inheritance leaves,
+	 * and on whether a BPF scheduler is in charge.
+	 */
+	if ((attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (policy != p->policy || prev_class != next_class)) {
+		retval = -EINVAL;
+		goto unlock;
+	}
+
 	if (prev_class != next_class)
 		queue_flags |= DEQUEUE_CLASS;
 
+	/*
+	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
+	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
+	 * is available. Last of the checks: nothing gives back the
+	 * bandwidth it reserves.
+	 */
+	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+		retval = -EBUSY;
+		goto unlock;
+	}
+
+	p->sched_reset_on_fork = reset_on_fork;
+
 	scx_prepare_setscheduler(p, policy);
 
 	scoped_guard (sched_change, p, queue_flags) {
-- 
2.47.3

