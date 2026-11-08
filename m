Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164058;
	b=LnFQhv/4rAWGLhymkSM7oo7KVLKMVrqHcGCJlASdvvvveTL1w705y7+cauODXUgsnjVy
	 OxKAu9KrjCld+dcuMBtxi32MjigcVK/r3dZr6myqGxkGo1O/YtKpFUOJDDs5Gv5XFLVPZ
	 Y3lmW0hZ6HeMc9zOwnLl5EU3DGLwBvpKepcB85J0qxEWoVtxeSmCEMNBXbiIitpfNEK79
	 Rh13w0JRUwEQiEnaZU74heCmOLnsoHRnveLuRcA7eiaJ+ZEk0xLAnlN8Icb5Wls9tq5bq
	 H+Xpjr/hQfPhjzMUV/VyYWhC2yTQxY2+TvHZYeIHJldP2hWf3cOKBjb7tJM7/ikkx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164058;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f0GKwe6pmNm/iGeYeocXp7LK8NNH3bf7ZbbzjdGwH8A=;
	b=XTaTeCnjfGnFxALh4gugFYBKqq9At0RMnworg9dbTPJ4Ny/A4Q0z19y+gRWCzgFtXMhd
	 8fRPh3MXe0kzBJZyaTiQMeqMHVCTwjWojNkJBf1VkxRZGblXl3dj+Y25mFDRJmKfGujSf
	 XI5zOosqEsyUVaHTdRmBcJ24ZFNXbHS2BzTuos8+R0fXrVbRak8smMqbw5ZyqYxAdFj/6
	 BywtyRzv+5i5KyprX9M3dA9glmh5acchwpI5tjScEQsc6ucYxNsMD536rKbfohlylfU59
	 7RCLoPG8l/OjQOChREIQK/VI2t3v7Scr2LYn+xgLR6A7k+wkIdVES2a6FPPATh2Msug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Vq1E3I1e;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADEA606A326;
	Sun,  8 Nov 2026 18:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ADEA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Vq1E3I1e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164057;
	bh=f0GKwe6pmNm/iGeYeocXp7LK8NNH3bf7ZbbzjdGwH8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vq1E3I1eY0MHyUxAvpo6/GyHG2PBp8w68d+BBzc/JStjbBtvKqwieQCb2X7bGykze
	 iUnshSylJl302G18y2Aj6kBNLeGl5BmAQygiS6lTPLadrmFZtDx22k8SPg8Z72hVo6
	 RD0f+v8BnchzUE5oM3AfYRSm4TV01YlpvP6fA1dHSHXrCrEXx928K9CQ5LilJMdJtG
	 oeSfFRyXSTQ3UgUhvqh1p3/lJSgyiPN3MzVAcUfhIU0MVhXBBE4D6BLMlwXfl09OF3
	 pLntQy7X14aF4+kk3Fb4qQwRrrFDYUmT5EjGMrQlVlqnHyy9l/hTcgrrfb3/ahyujO
	 Q+kfwUBhClEhA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2Bx0dryzMcr;
	Sun, 08 Nov 2026 13:54:17 -0500 (EST)
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
Subject: [PATCH v5 02/29] sched: Refuse SCHED_FLAG_KEEP_PARAMS that would change the policy or the class
Date: Sun,  8 Nov 2026 13:53:39 -0500
Message-Id: <20261108185406.1549770-3-mathieu.desnoyers@efficios.com>
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

In testing on v7.4-rc1, a deadline waiter boosted a SCHED_OTHER mutex
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
Sashiko AI review of the first posting of this series found the policy
change and the boosted case.

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
index 2af550f92ac6..0e8b5c7324f6 100644
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

