Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096186;
	b=xbnm3pYLhWZbpUztLuHueuIJHm3KpW4w+R08gEo2e6CXazmP2VvP8Y1dEu/CJbaVJx5z
	 wIPD4yvlDwGNmM8KuOF0+bZ9TjLQwFXXdAJUpuSQImtWowHJCLUyYjmhjl6Mu09a+tLM7
	 qfcGQyw6ylDDjM/bjV8ppQnH9O8IizOOZJa4RZc+eKb0axICrfIAHzWYCzDTsCPX9nKSm
	 nttinNTLN3fPzPWb4aj4KFLmAzmgwBoZoXaKrh5wI4YH+JZI3PdgDmnAFr3/dL0nUxH6V
	 updfXyZCdMx4cThVkjx3KOP345xEOnRt69/r9CciMlvggx9MXgOSM/0zbLzXRQl96IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096186;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yELx13sHyQWYBuXOk3KPYcOlyO+WVTh5MRWDnlhFvwU=;
	b=banrFB2heRTmZAutOO8d+kQjYLsznOnqd+1YCvZopZiMMGBTEftXOl3xobtcYaxAx3jQ
	 GGtZq+7kBfRH38n7nPmTFkuiV6ZxKzEVoMHDVyjFeJW3Tmzy6zt+iRZEVFuBj9xP2IAo+
	 DQm9Got9G9lnYJUiI0TxSTBj5yrBSaNB+SouZPo5Ek/auSVvR1WG+PiJ7mt+BZSXIAAzs
	 e9KawKagqlUhPnhTYIXudTcfzrwx56qPZk/NysH2Plwl3Lq1CvvAkJM/GC7B27aBo/Imu
	 Z8+wXMgcZQo7TILxe++cmC8ve5gHwslDtWNlSRa8F9MFx9yNEKj0KL39lOczKE6EPQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Y6HsqoW6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162160A3809;
	Thu, 19 Nov 2026 13:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7162160A3809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Y6HsqoW6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795096185;
	bh=yELx13sHyQWYBuXOk3KPYcOlyO+WVTh5MRWDnlhFvwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6HsqoW6SaPCOZre6XxjRqYvNygSVQw30QUedcRP3hUfE+YSUFdWvfTbgiX7tHBWA
	 I5TbNCoMOdE+ozkqR4NuSv0fnI1b7C9HxzdEF9YJKFY+9p484ajML7XOp9DRsyPrn4
	 OJCwHV25hAbwWrAMNOVIp603h5d3EqEVs43X4IjdTjbrZ5OCRv4qgc0DbIwvJbtedN
	 YUsLAw5PFE85reQzP1HwEJIiuLrwTnVM5bX5aGhi68P7Qyay+Zq0kS9By/axSqzSnD
	 h1Nqfqe+YCrEL3Uty2uuhCD7JMoDRoZtusUIRv0pCHYE9xPEOfXzhjkNZu74s22GSK
	 bw5mzP/3td28w==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVfwT2x2pzSDY;
	Thu, 19 Nov 2026 08:49:45 -0500 (EST)
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
Subject: [PATCH v3 10/17] sched/deadline: Fix an overflow of the 0-lag time with long periods
Date: Thu, 19 Nov 2026 08:49:33 -0500
Message-Id: <b341033dd787d5bd4a5259cf654fb725f57629c2.1795092090.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
References: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
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
4.2s, so this needs no sysctl change. The quotient is then negative, and
the 0-lag time lands after the deadline.

On 32-bit, div64_long() also truncates dl_runtime to an s32. A
dl_runtime above about 2.1s then gives a wrong 0-lag time too. If root
raises the period limit, a dl_runtime that is a multiple of 2^32 ns
would divide by zero. This was found by reading.

The bandwidth is then released seconds late. Until then, the root domain
refuses deadline tasks that would fit. I tested this in an x86-64 guest
with one CPU. A task took a reservation of 3.1s every 4s, then went back
to SCHED_OTHER at once. A second task that asked for the same
reservation got EBUSY for 5.95s, in 6 tries of 6. That is the deadline
at 4s, plus the 1.95s that the wrapped product adds.

Fix this by multiplying on 128 bits with mul_u64_u64_div_u64().
cputime_adjust() uses the same helper. Its operands are unsigned. So
take the magnitude of the runtime, which is negative after an overrun,
and add or subtract the result. With the fix, the second task got its
reservation at once.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d6d2657dcddd..86297ef5ac07 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -425,9 +425,20 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
-	zerolag_time = dl_se->deadline -
-		 div64_long((dl_se->runtime * dl_se->dl_period),
-			dl_se->dl_runtime);
+	/*
+	 * The 0-lag time is the deadline minus the runtime left, scaled by
+	 * dl_period / dl_runtime. The product of the runtime and dl_period
+	 * can overflow s64 with periods of a few seconds, so multiply on 128
+	 * bits. The runtime is negative after an overrun.
+	 */
+	if (dl_se->runtime >= 0)
+		zerolag_time = dl_se->deadline -
+			mul_u64_u64_div_u64(dl_se->runtime, dl_se->dl_period,
+					    dl_se->dl_runtime);
+	else
+		zerolag_time = dl_se->deadline +
+			mul_u64_u64_div_u64(-dl_se->runtime, dl_se->dl_period,
+					    dl_se->dl_runtime);
 
 	/*
 	 * Using relative times instead of the absolute "0-lag time"
-- 
2.47.3

