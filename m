Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032411;
	b=Jdn6tNAUonWH9h6u5Rj4nTqMvWj991T5EObIp53VkjTJ8HAGVMDKxY0OJ3XiZfmWMwGo
	 a00Aq8gFyMAg5DiOEJasYuBM3zf0ko5vMLeOua41z/K3Wlb3kSbiGcj1A7GzBAzA8360E
	 jf/TTKGgj4jJZMqUZA/jOMtmnKJYDtoUI5pvvQLA3Ax6Rg5g8STJdebPY618ygulRcLPP
	 WCzxavkj60DcmY1j8B+aNY/4z9tOzrrtN3lF1LUVHzFxLV/PVPuLE9ATNSYzAhax0tHyx
	 vRh1z5xAAvgzXJM41IYld+9gc1pnckLxxCLOr5dTtOXDFAkHbmovgwXQDlw7Pfn9OKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032411;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/0vNi3WzQ0meDFvL7gP2Mj945lYjPQyLZhg0rrA4/Ew=;
	b=KULzG6tnOEi9D4uKawJnCk6rsi1bwilItV0IOHgs0kjI1fdkXXIwHBsrWUc+I2MjzJ7A
	 kPf7jGT6YbnN77FzMORBbyhFvxpqsaGBoRUtiN9DM7RxHVEQlGABtgfznZVIx/9xaU7f0
	 ELo3SNF9SASAODaPpyVTWF0quWpx7gkz6PDx4xzvDkf5rit9u33Pav5GV73kzTTCJIzpX
	 RAg20ozh26Hu96Q3ZhbdTj4d3VMAnOisTgYuQW/aMATB9CfIf20bEsbIEgu6Zlb6Yidjs
	 rr5Ky+x3/eZ2/Tfb06DwX24Si0nlKEemK/gy7fPl2ABKdfxD9LLFqrTEgrf9SGfT6MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="qg/AF5xa";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD345606A331;
	Wed, 18 Nov 2026 20:06:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD345606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qg/AF5xa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032403;
	bh=/0vNi3WzQ0meDFvL7gP2Mj945lYjPQyLZhg0rrA4/Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg/AF5xaEiuhy/JpTfD6Uk56kAEMV4FXQhtx9QOxmqZVgznluLshFm6jMbG6CLzm0
	 qylW9AyfgaCEdJVaKz0E2zBxJkNkWIgyC1WOamvDEJQlyPpuROQPHhU73e5xq/c92b
	 g59OOewRBs0uBOPNgPdSMrHJpMOEB+hyvp3wd/fZvHRbmVWSrYOyud2+RbMwG65y6k
	 d4O66byd/rMn6aH6x9cUncn+RLFs+1vLhO0/kw6qACCStyrnP+RJ9/mtwag4SuBc4C
	 sulXJ2opC17ymxdHo8cyb7plugX0ZIL8Jb5mVdZcOkxMsKL7LgM2B2u/PLRUel+Gdk
	 EwYLe2eyd6z7g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKv5LNWzSJ7;
	Wed, 18 Nov 2026 15:06:43 -0500 (EST)
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
Subject: [PATCH 01/16] sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or the class
Date: Wed, 18 Nov 2026 15:06:26 -0500
Message-Id: <ba41e54ddc52f13b1889c204220882fb79e9099d.1795031605.git.mathieu.desnoyers@efficios.com>
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

A sched_setattr() request with SCHED_FLAG_KEEP_PARAMS can ask for
another policy. __sched_setscheduler() then applies only half of the
change, and returns 0:
- SCHED_OTHER to SCHED_BATCH leaves the policy as it was.
- SCHED_DEADLINE to SCHED_OTHER sets DEQUEUE_CLASS. switched_from_dl()
  then runs on a task that stays in the class. It would release
  bandwidth the task still uses.
- SCHED_DEADLINE on a task of another policy reserves bandwidth in
  sched_dl_overflow(). The task keeps its policy and a dl_bw of 0, so
  nothing releases that bandwidth. For a task boosted into the deadline
  class, it is not even a class change.

SCHED_FLAG_KEEP_PARAMS came with utilization clamping. With
SCHED_FLAG_KEEP_POLICY, it lets sched_setattr() change only the clamps
of a task. So __sched_setscheduler() skips __setscheduler_params(),
which sets p->policy, and the sched_class assignment. Nothing checks
that the request keeps the policy.

In testing on v7.4-rc2, a deadline waiter boosted a SCHED_OTHER mutex
owner with a 40ms slice. One such call on the owner left 0.4 CPU in
total_bw, until the next rebuild of the root domains.

Fix this by refusing a request for another policy or class with
EINVAL. Move sched_dl_overflow() after it, as the last check. Nothing
gives back the bandwidth it reserves. A refused request also leaves
sched_reset_on_fork alone.

With this patch, that call is refused and total_bw does not change. The
params_keep_boosted case of deadline_bw_test, added later in this
series, tests it.

Juri Lelli found the class change, from a report by Tejun Heo. The
Sashiko AI review of this series found the policy change and the boosted
case.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-3-dd761fe005b4@redhat.com/
---
 kernel/sched/syscalls.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 0ec401af80d1..89b0d5787f45 100644
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
+	 * With SCHED_FLAG_KEEP_PARAMS, the change below skips
+	 * __setscheduler_params() and the sched_class assignment. The
+	 * policy and the class stay as they are. Refuse a request for
+	 * another policy or class, rather than carry out half of it.
+	 *
+	 * The class depends on the priority, which priority inheritance
+	 * can raise. It also depends on whether a BPF scheduler is in
+	 * charge. So test the class too, not only the policy.
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
+	 * is available. Keep this check last. If a later check failed,
+	 * nothing would give back the bandwidth it reserves.
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

