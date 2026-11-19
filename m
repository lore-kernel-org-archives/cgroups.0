Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115240;
	b=vHOgt55e8jZxadJjYJbkz7N3lblWE4B8K6QHZp393DIAmPUi1saJw6AvL6y8UNUinD0n
	 XJlLevJJRcZ1233pFFaRcpa/UiqvX5WUl5i4Wz2Su4aSKc/H1/TeZmzLDqtfAaxYc0k0L
	 Mrq5zja5rvHfuaBg8cMLn/RIqsRZ+pNaX0mtZ2ZnPRVfHJ6zMWIeWRkAd86mabZx+ibXC
	 WKf0B9OGzlM/JFFEfXIXDM7Y6IWJdNOjIKIGngvET0Apjyl6o/sDp/VsMNMO6zkjlxZeM
	 gQ8zeM1ncPRZ3Nn69yl6lRKZjrNz9vveFlQr8ntPb/NGlxQvONp0rfPqQT0b2GZt+xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115240;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=75YT1rSYLxN+Fk1EC7oP5nO7oKoLSYufllSPuvLp5X8=;
	b=iJxoMLxFUJ18rwsXtotPTN+iZ7/JlJkYQtHtwoQBwBLYf4Pyb9/EPcFqxGCrIME1yByD
	 P0zcbe1rbnId+YjitosQd6T0HI7CGxHA9gfLSm4hqJfoiwg/EcOoIwyk8Q0RMSJq/y+VS
	 xSDEkApNjr2sYTFuhwbOThJLhF8mf8oFbuMQAX9lnV4p0Y1JIDPmrv3ZQYiDf8Z5PWMSa
	 OHD+fGGhn2Ljqo+lRGYnKm70bIC7qOlXpk/KZgRggCrMT2Wv8IaXGjvfVJdc2kVZU2EgB
	 vZpz6X3V8I9Z98nYGXR9SZTHWJ0/yrpEiRGnqDjrGtU7lbZTYyM17Ej0ZgC1r74EZIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=mVa2Iuth;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D5606A338;
	Thu, 19 Nov 2026 19:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC8D5606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=mVa2Iuth
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795115238;
	bh=75YT1rSYLxN+Fk1EC7oP5nO7oKoLSYufllSPuvLp5X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVa2IuthtQoUZWQKl4qd/BH2MJ966/Vnr2pL5YKt2N8CPQ78zXurGpTZv6E02LLCA
	 T3oKbNNnNPc0/8cxXTJCZmZJkGk4msMjPyhRPHs2D+x/ymqCiEqBu60MoOO8bxdX59
	 i2RgJJwonvj+XUdTAzI170sXp7aB8Adu9ecRAySILtLNNXKHydCqmDSYZtoSF0OuUF
	 f9ECiKWf03CNCFMhd4HnuYirY/PP6iiP93bRhgH+0sH7QzO1AFD20y07TPZqrmxm77
	 +IRil9aqr45e8IJ+xpI+CefLcG/DbVCJ8+jt61SYr1XcYO3jw/qgU/e2THwzNrj//b
	 ccoE2GQ/RnsUQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVnyt4cDtzSSy;
	Thu, 19 Nov 2026 14:07:18 -0500 (EST)
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
Subject: [PATCH v5 10/17] sched/deadline: Fix an overflow of the 0-lag time with long periods
Date: Thu, 19 Nov 2026 14:07:07 -0500
Message-Id: <2be3813af9e997f5f7d9d3161d0b65b8d4ab917c.1795115075.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
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

When a deadline task blocks, task_non_contending() computes its 0-lag
time:

  zerolag_time = deadline - runtime * dl_period / dl_runtime

A task that ran at its reserved bandwidth would use up its runtime left
at that time. Until then, the task still counts in running_bw. A task
that leaves SCHED_DEADLINE also keeps its bandwidth in total_bw until
then. This comes from commit 209a0cbda7a0 ("sched/deadline: Improve the
tracking of active utilization"), which adds the inactive timer of the
GRUB algorithm.

The product runtime * dl_period is computed on 64 bits, then divided as
an s64 by div64_long(). With a period of 4s, it passes S64_MAX once the
runtime left is above 2.3s. The default limit on the period is about
4.2s, so no sysctl change is needed. The quotient is then negative, and
the 0-lag time lands after the deadline.

On 32-bit, div64_long() also truncates dl_runtime to an s32. A
dl_runtime above about 2.1s then gives a wrong 0-lag time too. If root
raises the period limit, a dl_runtime that is a multiple of 2^32 ns
would divide by zero. This was found by reading.

The bandwidth is then released seconds late. Until then, the root domain
refuses deadline tasks that would fit. In an x86-64 guest, a task took a
reservation of 3.1s every 4s, then went back to SCHED_OTHER at once.
Another task asking for the same reservation got EBUSY for 5.95s.

Fix this by multiplying on 128 bits with mul_u64_u64_div_u64(). Its
operands are unsigned. So take the magnitude of the runtime, which is
negative after an overrun, and add or subtract the result. With the fix,
the second task got its reservation at once.

The quotient must still fit in 64 bits. On x86-64, mul_u64_u64_div_u64()
traps with a divide error otherwise. After a change of parameters, the
runtime and the deadline stay those of the old parameters until the
next period. The 0-lag time uses the new dl_runtime and dl_period. So
the runtime left can be far above dl_runtime. For example, root can
raise the period limit and give a task 150s every 300s. The task can
then shrink its runtime to 1024ns. Before the division, compare the
runtime left with the runtime that the parameters give until the
deadline. If it is larger, the 0-lag time has passed, and the bandwidth
is released at once. Otherwise, the quotient is at most the time to the
deadline.

A negative runtime is an overrun. It lasts at most about a tick, unless
the CPU stalls. A vCPU preempted on the host can stall for seconds. Say
root raised the period limit to about an hour, and the task has a
dl_runtime of 1024ns. A stall of a few seconds then pushes the quotient
past S64_MAX. The 0-lag time would be centuries away. Release the
bandwidth at once in that case. This was found by reading.

The params_switched_asleep and params_shrunk_long_period cases of
deadline_bw_test, added later in this series, test the check of the
runtime left. No case tests the overrun, which needs a stall.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 51 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d6d2657dcddd..75c82a255070 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -411,7 +411,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	struct hrtimer *timer = &dl_se->inactive_timer;
 	struct rq *rq = rq_of_dl_se(dl_se);
 	struct dl_rq *dl_rq = &rq->dl;
-	s64 zerolag_time;
+	s64 zerolag_time, left;
 
 	/*
 	 * If this is a non-deadline task that has been boosted,
@@ -425,15 +425,50 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
-	zerolag_time = dl_se->deadline -
-		 div64_long((dl_se->runtime * dl_se->dl_period),
-			dl_se->dl_runtime);
-
 	/*
-	 * Using relative times instead of the absolute "0-lag time"
-	 * allows to simplify the code
+	 * The 0-lag time is the deadline minus the runtime left, scaled by
+	 * dl_period / dl_runtime. The product of the runtime and dl_period
+	 * can overflow s64 with periods of a few seconds, so multiply on 128
+	 * bits. Compute the 0-lag time relative to now.
+	 *
+	 * After a change of parameters, the runtime and the deadline stay
+	 * those of the old parameters until the next period. The 0-lag time
+	 * uses the new dl_runtime and dl_period. The runtime left can then be
+	 * far above dl_runtime, and the quotient too large for 64 bits. So
+	 * first compare the runtime left with the runtime that the new
+	 * parameters give until the deadline:
+	 *
+	 *   (deadline - now) * dl_runtime / dl_period
+	 *
+	 * If it is larger, the 0-lag time has passed, and the bandwidth is
+	 * released now.
+	 *
+	 * The runtime is negative after an overrun. An overrun lasts at most
+	 * about a tick, unless the CPU stalls. After a stall of seconds, with
+	 * a long period and a short dl_runtime, the 0-lag time can overflow
+	 * s64. It would be centuries away. In that case, release the bandwidth
+	 * now.
 	 */
-	zerolag_time -= rq_clock(rq);
+	left = dl_se->deadline - rq_clock(rq);
+	if (dl_se->runtime < 0) {
+		u64 room = S64_MAX - max(left, 0LL);
+
+		if (-dl_se->runtime > mul_u64_u64_div_u64(room, dl_se->dl_runtime,
+							  dl_se->dl_period))
+			zerolag_time = -1;
+		else
+			zerolag_time = left +
+				mul_u64_u64_div_u64(-dl_se->runtime,
+						    dl_se->dl_period,
+						    dl_se->dl_runtime);
+	} else if (left < 0 ||
+		 dl_se->runtime > mul_u64_u64_div_u64(left, dl_se->dl_runtime,
+						      dl_se->dl_period))
+		zerolag_time = -1;
+	else
+		zerolag_time = left -
+			mul_u64_u64_div_u64(dl_se->runtime, dl_se->dl_period,
+					    dl_se->dl_runtime);
 
 	/*
 	 * If the "0-lag time" already passed, decrease the active
-- 
2.47.3

