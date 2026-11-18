Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037117;
	b=y3+a6V9AA7MefmzxP9w4WSU7DwrlQaFoChA5etutnPBPXXjQp2WWPJ8mEj9F9rVXztnm
	 GdZPWDmpZo41yzipp2hgyj725r4yljErYdUFviOyym43TXgoSXVPOJ0Gms6M3Tss61lLb
	 DRvv1dcvj8lHSx3fxyfYuZ/EPoOMi3kCqFzyZ5q755zjuVpZ7NzGiVTu4lmRlMg27e4eR
	 59kD1RkAYgZShNHtM1TfzxdotzqQyBySefaNOBPjddiybWVUKEQQ92g1ngzE4a8mGeM8Y
	 +1rdWH9kp4VsV+7slWl3WY6mFNcWbgxITI4z5ub8C+HyXF9gljzSe2CQyMi4cx2/ULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037117;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/0vNi3WzQ0meDFvL7gP2Mj945lYjPQyLZhg0rrA4/Ew=;
	b=hPttXkJhfKttJKTGN/OsXSBjx6wEANUK99hAaKOkOLDKi5MuUyZcaUNdg1SfJydLTMQ1
	 SATCB39Almc999PXSRZfTE11BEGVMLFExDllKql6Qkiz8bwRxkZiPZk4Tz+TOjjfElBKd
	 A8B0ML6atOaSjEh0k2KyTzjFnoVKFfyQs/oSxjKdkuQY1e4TtIF9WPvge1Dg7ZSP3/S+9
	 25kTUbh9ngNB6pvOpW+7rON7rfMe0k/gD2kc9YD9iLlbj64OOSTLjIWxJSaJSctilmDn2
	 V+Tg1Rc7U1dM33hf5fNQVIQ6/cXamy8J+wZgVgdJhWrqRh0gXCzFcwU1e+5L7CX5F0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FAoKPi9h;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99AF606A32A;
	Wed, 18 Nov 2026 21:25:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A99AF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FAoKPi9h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795037115;
	bh=/0vNi3WzQ0meDFvL7gP2Mj945lYjPQyLZhg0rrA4/Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAoKPi9hKgEnAcvfe6uwXihMHOYGbYKSr/s27OhfWzazRhni2+I9G3EKEEQZ74WJY
	 ts1NDpqfep7bkgZpi5T1XawZop+xLbpdXFlvdgFP0tzD+q0MO+cSlQsfoyvSPmMOe0
	 i5M9Qxw71Ag+yhnJ3HEu+pSm/rNHc5iGlyBagAuZn4uDhbIrJSEgRu+epeHT2rXzmF
	 wawoD8i4ZCy4BQmfE7ehMG6lFJEj+oT7R2OrxpNudcLHEVe0ElL29JWk9mWd7Cqev2
	 OAdTdf0E7WQp2VuAWiVCIiDlnJMiiOc/hEK8Z7LLFcjfqUCW4dP19cU2u4PVljvb8H
	 ff5J6SVgmCkzg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVF4W4lQszSNv;
	Wed, 18 Nov 2026 16:25:15 -0500 (EST)
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
Subject: [PATCH v2 01/16] sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or the class
Date: Wed, 18 Nov 2026 16:24:57 -0500
Message-Id: <ba41e54ddc52f13b1889c204220882fb79e9099d.1795037078.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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

