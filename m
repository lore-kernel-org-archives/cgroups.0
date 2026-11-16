Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855968;
	b=HW0+rNaNxwOUvQQjJ/pNCC8lQXOPjfL4WTV+ugQ8zPZ/yx5axr0KueOnBa32JU58Nns3
	 832BFCdBf1dXN+KYv6WfNLLiWU1AZT2+A/OG8tlD2gFlbzv4LoCQc2iVkgZj2fJzzTkDF
	 9z6/MWmqCrHKcDNGya1UUczyXDffjoRCmtH7fQ3XvIZCr5KT4/tS8IcooTwX7x+t+YWsh
	 s+SjT5JHlrZ+sARHF/8vlE2WaTfbnV2aFLo4XlPfbrXvonR1zx+UXO4Q74pjB4UuRHWwC
	 cN4F5q15Hgp4n/imQc4QYvMvYPUoDBR5wbVL3QRIXyfJaqxM1TNy/Jzh0ShRw3xvYCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jJ4TJgnTADdTkzPG1Tf8obqekT6REPhvch3DXj7ESUY=;
	b=ATBzgRAlODuaE+R3e0ua01+qcXD9nrLw3Vrfsb7aqGsBhalDgS169OnqhEa855MTEd0F
	 mtwDEfs3Z7cZzvLk/g1jpSNxj9VcYrEHhKsM/59aqcPJIOqFQjLVNHAxlRYo0qNg+ZDUd
	 o2nQl3JKX10WS/XcBRocqrjmV0gJw9jGNsk3JOiBlkJxs5U8yU/rGDJxZ8eXsTMHxvIyH
	 zqm/AARJnVx9ldJNeIxwJohhJykSvAAP3pC2z35Eu3/hfxeymK0A3xV/JfqmBM7ZI3RcK
	 8kGInRS4d/A9Owd0uUrg/RsWBOt6IZxUD2IkI+brtldHpFIpS8+Pg9Wq/pIYFBVaCGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=G1Q8l2XR;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68F606A334;
	Mon, 16 Nov 2026 19:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E68F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=G1Q8l2XR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855957;
	bh=jJ4TJgnTADdTkzPG1Tf8obqekT6REPhvch3DXj7ESUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1Q8l2XRkC/qww7GztOxZGcnCsDfvwekDpTHG7uwQ/6Fm0jv9ltCADZFSM/J7+UJ2
	 uLJHpEK3JebalZhgDbWS8xbbz8o3TLxVH4XNjM98pjOj62CpESJ7+ChsryKr2BJ2jn
	 7Xz4eVAUbJtlKerWa3RF6jPDVThyY6rMiCaaOzMCPi7VcVnHcTj0G5sg8ouRH5RY9R
	 OlLMol+bn9gE32gaOiIEWEYlw/N1XM2kg9XV7E3nh+HG0va9L1cAOJzg9arCyZEIKB
	 QSSs+ph9NwsXZAAt5oXLnQefsLLnuow5UZMoIMx3d6KMmrdRcjJG0QcdRl9X/QrV05
	 nO/OF7xl1hkzg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4j0714zR7M;
	Mon, 16 Nov 2026 14:05:57 -0500 (EST)
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
Subject: [PATCH v6 18/37] sched/deadline: Check SCHED_DEADLINE affinity under the rq lock
Date: Mon, 16 Nov 2026 14:05:30 -0500
Message-Id: <20261116190549.230119-19-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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

From: Andrea Parri <parri.andrea@gmail.com>

A task can end up SCHED_DEADLINE with an affinity narrower than its root
domain when sched_setaffinity() and sched_setattr() race on it. Both
calls succeed, although each fails when made after the other:
sched_setattr() with -EPERM, sched_setaffinity() with -EBUSY.

__sched_setaffinity() calls dl_task_check_affinity() before
__set_cpus_allowed_ptr() takes task_rq_lock(), whereas
__sched_setscheduler() runs its admission test and switches the policy
under a single task_rq_lock(). So both calls can pass their checks:

  CPU 1: sched_setaffinity(p, cpu0)    CPU 2: sched_setattr(p, DEADLINE)

  dl_task_check_affinity()
    !task_has_dl_policy(p): return 0
                                       task_rq_lock()
                                       admission test passes
                                       p->policy = SCHED_DEADLINE
                                       task_rq_unlock()
  __set_cpus_allowed_ptr()
    task_rq_lock()
    p->cpus_mask = cpu0

The window includes CPU 1 spinning on task_rq_lock() while CPU 2 holds
it. With one thread narrowing a sleeping task to CPU 0 while another
makes it SCHED_DEADLINE, 923514, 959547 and 983997 of 1000000 rounds
ended with both calls succeeding on three boots of a 4-CPU guest.

Move the check into __set_cpus_allowed_ptr_locked(), next to the
PF_NO_SETAFFINITY re-check, under the same lock as the admission test.
Whichever call takes task_rq_lock() second then sees the other's
result: sched_setaffinity() fails with -EBUSY if p is already
SCHED_DEADLINE, and sched_setattr() fails with -EPERM if p's affinity
is already cpu0.

A new SCA_DL_CHECK flag selects the check, and only
__sched_setaffinity() sets it, so sched_setaffinity() and
relax_compatible_cpus_allowed_ptr() keep the check and other callers
stay unchecked. restrict_cpus_allowed_ptr() already does its deadline
check this way.

__sched_setaffinity() clears SCA_DL_CHECK before the second
__set_cpus_allowed_ptr() call it makes after racing with a cpuset
update, so the cpuset mask still wins there, as it does when
cpuset_update_tasks_cpumask() narrows a deadline task. SCA_CHECK stays
set for the PF_NO_SETAFFINITY re-check.

With this applied, the same test ends with both calls succeeding in 0
of 1000000 rounds on each of three boots, and sched_setaffinity()
fails with -EBUSY whenever it loses.

The race was reported by Sebastian. The fix was written with the help
of an LLM.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/20261103081149.DuyWNhVe@linutronix.de
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/core.c     | 11 +++++++++++
 kernel/sched/sched.h    |  1 +
 kernel/sched/syscalls.c | 12 +++++++-----
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a22df8b43a1a..c77cae5d1be1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3195,6 +3195,17 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 		goto out;
 	}
 
+	/*
+	 * Check under the same lock that __sched_setscheduler() holds for
+	 * its admission test, so that p cannot become SCHED_DEADLINE
+	 * between this check and the mask update below.
+	 */
+	if (ctx->flags & SCA_DL_CHECK) {
+		ret = dl_task_check_affinity(p, ctx->new_mask);
+		if (ret)
+			goto out;
+	}
+
 	if (!(ctx->flags & SCA_MIGRATE_ENABLE)) {
 		if (cpumask_equal(&p->cpus_mask, ctx->new_mask)) {
 			if (ctx->flags & SCA_USER)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d87296abec4c..fd6d36b6b1e2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2982,6 +2982,7 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+#define SCA_DL_CHECK		0x10
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 306cd8d32173..4f47b17151ed 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1238,11 +1238,7 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 	cpumask_and(new_mask, ctx->new_mask, cpus_allowed);
 
 	ctx->new_mask = new_mask;
-	ctx->flags |= SCA_CHECK;
-
-	retval = dl_task_check_affinity(p, new_mask);
-	if (retval)
-		goto out_free_new_mask;
+	ctx->flags |= SCA_CHECK | SCA_DL_CHECK;
 
 	retval = __set_cpus_allowed_ptr(p, ctx);
 	if (retval)
@@ -1271,6 +1267,12 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 			if (empty)
 				cpumask_copy(new_mask, cpus_allowed);
 		}
+
+		/*
+		 * The cpuset mask must win here, as it does when
+		 * cpuset_update_tasks_cpumask() sets it on a deadline task.
+		 */
+		ctx->flags &= ~SCA_DL_CHECK;
 		__set_cpus_allowed_ptr(p, ctx);
 		retval = -EINVAL;
 	}
-- 
2.47.3

