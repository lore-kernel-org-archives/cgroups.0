Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182968;
	b=HDXdWEpeFJ75TI2caiWqV3r4eysBPvGtwot49y/7kJzZ3zh6yBUng9p+bgAdWx2k6rKw
	 VD2pqAL1mC7oj29CTtnQXJiNRzKblF4eUGiIt8uyB7yE4WYuI/EQKscyo5smJyci/Gg+/
	 79REavI/7Gr2Z5wntXoIVyE8NFTQovZaCHGWHhCoCh1UPZtAiRcqQGSzMz1/WqMJP7431
	 Ejqs7DFaMWZg2PmDO3sKSPHNdBzh6lxUxMIf0YIs7Sbw8/lkJwsgX5Yvuzzlg8h7yhxGj
	 Qo8V2xOKq9GSMys/CXmcSW0/7n1UfoZbnhKk3m+YytDEPqDgCNZhneo07chVuBc208A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7O8lq12mhqo/c9CfIQsmbeiXyer93eAcvVX1SxUyTI0=;
	b=MNCF6hQ6x+oHkSSxe4m6+ViRiyR2j4bUlMpxh3De3zeLcjHkwG+Xb5K7xsnTcTRz329u
	 d2NkHIqZOnVStJknqFQZEohNcmplJ6a0SnhHQN3jJ8pFtGnoMBRQPWRIcs8nA4xWqYpqc
	 flYbQHPVCqriR13Il5cP7BKYMJZv4pqeKLv60x2QpgMQoUcM5QrnfKFiqR11Y7aE5Qjiu
	 H6adNVwr3q1BPanmmdPhudRDALQetaHtNPCYlNSC4h3MnDKZdQ5FTylC2lVK1FPiXCR38
	 h6UkMoo6NLxSGJAYFbzS/SNUx+gEIgzVjbjL3Nh/yhHtgz4QjhSD3t4HRTyV5sH9D/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bf0PTVEW;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8511D606DF53;
	Fri, 20 Nov 2026 13:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8511D606DF53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bf0PTVEW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182964;
	bh=7O8lq12mhqo/c9CfIQsmbeiXyer93eAcvVX1SxUyTI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf0PTVEW04ZOBXOcA0zh0E2Ew5lHL9ZOms6D/FXC5H+02Q9YGp7T+WWww+6Wnu79y
	 qUBSkCcerfNknbuuHDu+1yeMjj5k90+bd82Q5QWzbRgZgBucRzWRSXfNZ3lEdiwWQP
	 9TDWyft/MFBtQV4eCH7GqGiRHgkPv4tqUiE05qj9W5CsaQlPgV82iPa+BhuaKd7lSO
	 V+0JgeeBoE/KruN8ItDKztl4ochC7iT1xQvWO+O5PBhi/kxycw5QuP6Po+GPzyHa66
	 CR90eB/AyBdExME8qoi+2s3NRhYpY/7EBze33CohfSsoLjD6tGpjtlo4faSRDejtHa
	 pZUDQ32MmRD0Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1J2v9XzV4T;
	Fri, 20 Nov 2026 08:56:04 -0500 (EST)
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
Subject: [PATCH v9 29/33] sched/deadline: Cancel the replenishment timer with the parameters
Date: Fri, 20 Nov 2026 08:55:52 -0500
Message-Id: <8176ddd70961234526e210f1a0513eace7d54d82.1795181240.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
References: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
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
index 4c46a7aa2709..a76982c59bae 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -836,6 +836,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2691,6 +2692,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
-- 
2.47.3

