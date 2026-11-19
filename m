Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105507;
	b=prTplWSZ9+Y+bvK4LVPCPNDox7XWNJrFopzOLAXDlfvT5+AqH9Shou6coyJpO6a4MODM
	 bsefxNa50c3lOOcSnKY0Ayyskl2CDY6ti0PiYLNTBfJIKtsXgjSpkxx3oovczISk3F3gm
	 7QJHEd3H3I5xFrhisQm2HukV/EoPpkR8F6hbNYyER+p5IssysbF3oriJVhZoBsY9tx9U+
	 /HNdQhvrK0KaeCf4D/qBsemLgm952KpbVal8GOOUG3hfoo4IhcE9LJfP+BVHBVtbEDSPD
	 PSdd+iI04IsKgJBtCJYXNSnX5GbVWh0VTCuS/NCpxKI6qzrGUrzbOW/xKpxNiiZddvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105507;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=J+xqGM/XTVoLXbet9Pqsqr3DEOW4nOHD7WQm9LFTgGg=;
	b=Cz7EvMc32i55hNe3WngMZHVdNK6X0fFuvTBqBr7aLL/myQEwG8sBhyUUK5POR2DJCkdP
	 G7S+JewTR2D4dhNDHUHzpdu0vM0PdUVSqZV3qPFYiPt4GtnZJqeEZu94BM8ReIna/dOIG
	 XIcu9/aW7U/Ods+DTgEi4LpxSvmeBnOqUQP/3wNrVbQVd8F5SMq44bDpQtB3FRqMVRkhJ
	 /mfvKmrCFx/N87SthGUas9pWNRxTYyZEi+xM0cNfNTZ/3ZJBR5Z/JFV8K3GnwbdN4tC0V
	 JdTjg5pmJIOd0zqhUgdbMLjtH/ibhh4F1a3s2vhX//NDQtW6FNPd9QPUGG4t4TaZJiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vd9vlcw0;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0350606A326;
	Thu, 19 Nov 2026 16:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0350606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vd9vlcw0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795105504;
	bh=J+xqGM/XTVoLXbet9Pqsqr3DEOW4nOHD7WQm9LFTgGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vd9vlcw0wDpYM2V1roLW8f9zgLbxarPsw+uBK+KU62HKBJwZFJVWP7XD9CGBmyXgw
	 9Abd1usbognn4t2JZhOak/2tI+JnQnGtfsNOGnDqL5xaeCTznyR6WcTZViWNB83fPw
	 r77UkUgGQvmSIDQylVGT0cJIvMxQ9VaQjV1SDHusXR+5oeTZDMGSxwoRirRykFtrss
	 jKqoNWyXSRI7Qr+skZ6JJSiWqbmk8onNjpgANTAXVlWUPD5A6VevVLEmbVZUimqjVu
	 W6WLTbh0pXWGM6cFXnZ5uJI24JSA+ohjJzNtJWZNMgGCqCkcxcFnhw49/vrZCD2+y/
	 nSosFh0zDbGtw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVkMh1jmfzSPl;
	Thu, 19 Nov 2026 11:25:04 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
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
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RESEND PATCH v4 14/17] sched/deadline: Check SCHED_DEADLINE affinity under the rq lock
Date: Thu, 19 Nov 2026 11:24:54 -0500
Message-Id: <2051d70ce37924806b86b8883abe9a62ae6fae8d.1795105408.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
References: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
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
index 5ed660f099a5..32fe889e02fb 100644
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
index 92134ce326a4..20ad13f388cb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2972,6 +2972,7 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+#define SCA_DL_CHECK		0x10
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b87b878be63f..5983232476a9 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1225,11 +1225,7 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
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
@@ -1258,6 +1254,12 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
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

