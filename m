Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207368;
	b=QT11rGO631R0Go3LS6bZ5rK5BK9cLsp9YY555HVnXLQX3SfUEdUZYiCiR+JEJp9eK1ta
	 DBh4kT1nmPzwx3xc0QoDJNghv8BkqlJppCLrDto/EAzNl/6L6rBHZtdp4Dwg/2u8VhDar
	 YaOaSXY0/iYkEfrY8XqE9Gw6HGGXmn8oJpSIdt9Jo+cwdtrr5dT5QwG8Ola/9UlAq0XJn
	 N1SdMH5z6WAcS7ad8G7yOVTpBBkFNYvCHhy/+gspVbi0UHozH8nltzTtC8ZSUDpEL6e2I
	 exImmlUs38tdsbvuRwHrsLbYIFIpSO/6ezcf0u2LcXqxrz2j0sqokjvDn3HP932+j7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207368;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JdA6KJBD0W2HA4KuFzZe2bFxIHk6k9Hvw3UfI0kXFuw=;
	b=lBYRgX+u2+5gR93OdszT2bsJOr7qV4VV6wpyZYuEo2NM59d+5iZZ5OwgtHbHoDgusG/G
	 b6XXwFfPH1tskVRthtKVbV7QWPrMjlCOWwaVA9nni/bvO7b4a9MMNbc8qzSWrdX1rW4JZ
	 BeGr0aymCdDis36OeSaq7LTsDPXT+3CGJAftSxXSV7iZIvhcaAq05Afa+Tfa8IAY+ZYGU
	 NLuWpGSrtnfPH7txMlxSTKg6mmahVyBC15Aoiaz0bIy927HO/96jC07vqr/d/JN1uuGjp
	 uSX4ijiS8sUbvfpw82Z9s21lUeqsR2XWbbh5ZFlRc5EvBe80uUj3+n04koRZSUxMhqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=L5NrvSob;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1BD60A2633;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC1BD60A2633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=L5NrvSob
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207358;
	bh=JdA6KJBD0W2HA4KuFzZe2bFxIHk6k9Hvw3UfI0kXFuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5NrvSobhCXIlWy//GetqGit6RBkbOsU7Ar9rAu1eQx5J7s7wIdy5FeBowZ4sE7Qg
	 UfhEhD7XrB4j/WaB0QX9uPZ9ZHU0TaXRbyOS2CQ3SypHYLiXx7Rbu2cD413LHzpci9
	 T/XQPLzofgEXHI6wzpy+SBpijrEdxA/p7XZAtrPhrqT1gXTMUvUg+Ml8sQ3CQzF0AT
	 Nl27/YCbExMGFVf5TA3aH9kTSieQn9gEQUj6LMJ1yAFtgEQRrnxojhFRd6OUwglO4Q
	 Zv7LCV+XkUIWqxkqKkcTte7rp0nkJjeXyOZr1kezp0d4d//iT0Xjx62CzwCePaL++v
	 JcnJXsOcfG0gA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2Q2MyrzTqk;
	Fri, 20 Nov 2026 15:42:38 -0500 (EST)
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
Subject: [PATCH v10 32/40] sched/deadline: Cancel the replenishment timer with the parameters
Date: Fri, 20 Nov 2026 15:42:09 -0500
Message-Id: <803b73dee61be1e60135b2e22f5ee51e9097da3a.1795207233.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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
index 1c5888b1717d..9f87315d3d6e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -851,6 +851,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2744,6 +2745,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
-- 
2.47.3

