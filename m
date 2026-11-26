Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655355;
	b=bSwYoJcgPmCphI9PT9qp1JYn2rA2xwKYY1EmmvyRv2258V6voPVeCjsexgvEq1AtCYLw
	 R5G/AuharM8/qElz4cA/T6NDYtfH2MtOri9Od5Kdeyc8qTu9XVLN93WIuyHSHDEDORUWI
	 CC+poocP3KntljnC7HIXBSO/kANLtDX1bQs2tf1d/JXv23uTEYTB9wzUqY3oJ9w0+draP
	 8cPC9tFicJcn7ngqWldNT+15stBUDfbEQjiBc5cy+rqOL4IftuTn9FY7BQa+jEfht6Y5R
	 rtw/Np1XHBGUQxwtjpppPsnw8iQPlsrUS0AJzdq3eNaP18bFK81j9/j7DJuYRjD5xCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655355;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rDsdqsFU0t7wSZ8PDeaU4Rw/7femn7GJ7dpoYcQ2Ldo=;
	b=Hp51uQ9goI5S+f8DxUwYQxUixlph9MYThpSNiS2kXpNHu78ShT58cEaprSJQDzeYnSBA
	 LTz3jO5st08npph7UIdeYTjyzMByInw8DbPvfQOHxyRIk7+/ZWEw7U/jRifYbzqU0Ve8S
	 TJ0DO4a76f7mBnqETr8+V6FyU5YBZyMu3Kew/ERtk8HFfWdUvVwjGbNwEpvCgKbihLiNq
	 CchDGfUfBfY8vBnZ/gCWBOlK9KJAYII6RaVIu89umE8B1JVuFWcUrX1/6/glG/K2LsSPm
	 PKIw3keSpgkhRnMWKTeuk5R2i9Szzjut3VB7SVXGThXEnsVzqkWxZAECeuPvvj2hZAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="fqb2E/KQ";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E49606EC50;
	Thu, 26 Nov 2026 01:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6E49606EC50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fqb2E/KQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655353;
	bh=rDsdqsFU0t7wSZ8PDeaU4Rw/7femn7GJ7dpoYcQ2Ldo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqb2E/KQhgAmoM2DOVrYrRw61x3ndmyTuGLkKachVas3OG/hEmFjeGXWYN7tsd7k7
	 kqiHKNmDI137IOnVa3QmA3A88r3weTCtYLFn6CJrdJWP+j/wchnwekS1p1GrWJAU4U
	 GtNS7gx4i6qvAOtAAumobbZLg6r9hslKxQWsaZPmTJDm1zBPiwA2mMIKa2PP+lo15T
	 dc88LuYi/qg7ivfumTLthkYIVRzMVpln5QsTDESThDANYnJ1EbM1BjmY/qZzUtK5t5
	 INu3WKSN73dunIv/Ljj5NGlChqEBBT80vIZIf8LtGTJNs7FxAIQiQBtg9U712Cw3ru
	 nxwevC/4anJQw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjh3jrfzWB0;
	Wed, 25 Nov 2026 20:09:12 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
Subject: [PATCH v11 34/43] sched/deadline: Cancel the replenishment timer with the parameters
Date: Wed, 25 Nov 2026 20:08:33 -0500
Message-ID: <85ae6bb1ce221469c21c31a352a703aceed394ed.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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
index c59953e80b1a..828923a77107 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -959,6 +959,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2895,6 +2896,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
-- 
2.47.3

