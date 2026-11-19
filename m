Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=QvIf9SuvPkjHaVSBaMEqX3VxKOaglAzfSbnd+oXGDsph+pqDqBqMh8TLkf46LFPgRGqh
	 Irmmc8aD7qseOnJK0emABz7GcrlrgHSpCMIe82dT6vE1OSj5HmOB77EflV0q7ZxIt5SSs
	 cJn+c7NWoqV0EgznSEf1mBqZ3l64QLZaJuIvSnirItvm2f920xpL02CKpxYywHuDV69K5
	 axnfuUwB+/xAp3favN+aDN1nX2AbYdUs+RR2NBx+5yQxdie4rFNe8h28cQ/7ZSFz0fM76
	 F3xyr+xuFnq9xKPcrkyrjNuPgtO4SI7dS5pZdHmuErUn4RIdsIGCPDcwmZmXwJqVEFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tgh7H+2WFtZ5mB2jhIYsx1nfnkCrP9mRM11xQn6EsR0=;
	b=BYcoGza/q2k3gb08IgqALqfWb5wdA8lirfx/l/JUx/jh/Gwo9iBV6A8PBv91upIaHz2G
	 N9k+AYe3Mn+JCE0M63pLUzPPIOsgM1oFfDC2qVXJ89USrYNOgF67+wa1WBl/fYJR7MKFC
	 IgETb6P4DTqfox5uHespdj2Fkn15Z1dGQaEBR7Y8pAUtq4dZekPzqrXbrUeVTYwX1U3ln
	 W0MjFFQ9fWF2XcsMQ3uxD0nu2/5wM2EfHrAVczD9OZBZyPiF8cBOJckAiZrV9jUGUpqBl
	 w5RWZCEBz+REgAnqqjMZY1vkR0f6qlX2/4l+Q5fzjHJdpc9we6CnBZmEVCSkkkqeabA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UzmQtlxM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7260A6F50;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED7260A6F50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UzmQtlxM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119382;
	bh=tgh7H+2WFtZ5mB2jhIYsx1nfnkCrP9mRM11xQn6EsR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzmQtlxMvp5BL0KovURdxwjTOyhwkcCyR+hQ4iOOSMCN9rCqjAnQiLHbfomwl3+UB
	 xkWZJSBBvkfk3d0DqrP/WsbTjsrprzuZr6KAmRwOmCKwjSN3NDs0WCIOL5jxi9Xkyv
	 mJemB5kqg578SZrlsV2SmnhhfhGKcuwY2t8YTSlIl60zgcnijkbBfBBp0maKc8wyYO
	 jOAZq3kquknvtK5Lx3ftza2cc+7CAV45Lzb75U2ZYmxLej6P6y7dZZ9G6izKnN8YS2
	 qfqWsItRthm603pqqJzjvCikPFeRJnxjbwDVwBJoGyNttWp5JgnUDQ4SOnljrv3JEg
	 /RmBBvnmIKsrA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVZ5WY8zSjd;
	Thu, 19 Nov 2026 15:16:22 -0500 (EST)
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
Subject: [PATCH v8 29/33] sched/deadline: Cancel the replenishment timer with the parameters
Date: Thu, 19 Nov 2026 15:16:08 -0500
Message-Id: <1e9b9a97400aca6a4ae184ab2619680954db11b9.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE has its parameters cleared at its
0-lag time. Its replenishment timer can still be armed then. If the
task comes back and throttles before that timer fires, start_dl_timer()
does not restart it, since it is queued. The replenishment would then
come at the period of the reservation the task left. Too early, it would
give the task runtime it has not earned. Too late, it would delay the
task by up to a period.

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") armed
the replenishment timer when a task leaves the class. The timer then
reset the task if it was still out. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
that reset to the inactive timer, at the 0-lag time. Nothing cancels
the replenishment timer there.

The timer of a throttled task fires at its next period, which can come
after the 0-lag time:
- A task that yielded is throttled with runtime left. Its 0-lag time
  comes before its deadline.
- A constrained-deadline task that overran by little reaches its 0-lag
  time before the end of its period.

Fix this by cancelling the timer where the parameters are cleared. This
includes task_non_contending(). switched_from_dl() calls it to release
the bandwidth of a task that leaves asleep past its 0-lag time. A
constrained task that overran as it blocked has the timer armed there
too.

The Sashiko AI review of this series found this. It has no reproducer.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d284036ecb8a..95db8afd8353 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -788,6 +788,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2643,6 +2644,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
-- 
2.47.3

