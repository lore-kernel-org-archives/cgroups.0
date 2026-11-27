Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790188;
	b=4zPJ3ZQ62DMHcqrCmDnA+vFkWnmEgzSmfh7Jw8PoPNMQIx3Wd8Rb4/xxIGvP0wuTI+rW
	 wHCWBa9cItkHlaSTeef1eZA+qhyH4wdmOjTre/dv1dDn7rH2jMqqEgjL+1LisRfBnBK/U
	 4hkUohdvqCX9g77ze/hMwuAHuYYqO1kHzX3In80KoOeEpYDwzYoB//bXJGFUqShAUzI1/
	 F0a+ALcAOBtDSr+2Q/aoKFwO+g2jGtnQwf+xwIcb3XB0apUI1Hq9mkSxFgNHTOwm0Iqsn
	 Fg7e1Cof+hkJ5JleeNufLHwO31atLIfxe74GnFaasvjuuVvJCY0cDkeBB9VDZrRvC4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790188;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hNpbl+uvuEhHzWjKJUkcB4i7lz9BshWTQ5Pz+msvXJg=;
	b=yY2uaeyh+0IQ8aIT+WCGALI+46qg71r/vOg2cJWSGLfBq+5KDldkmhNp8VL/zagKr3R8
	 yNMlciY2H9U8YfHAhsFC249sGuwoZMZVvxV/nM/r8aGdYfJIk3EHhDbvP8MrswolSwIH4
	 3+uT609AYCmv+YLWQLWPaETDop+ueYotbG9nMxFIcLtPcD+eQixQiQRqPG9NhgcxnLaur
	 E9yLUYkqxEAZ3GcEOgWcQdxOR6mRSnwXv7mtTWeudrT7OlMpzsyBT4gMQYLJkhkf8NhTa
	 U27JfjLDgtR8Zvf6+QID2Ikc9RMSwlyjWtxbbQc1LM+HU8LcV/wFbXXTMUNAqAAB6Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AUgHzD0y;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82510606A31F;
	Fri, 27 Nov 2026 14:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82510606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AUgHzD0y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790180;
	bh=hNpbl+uvuEhHzWjKJUkcB4i7lz9BshWTQ5Pz+msvXJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUgHzD0yfSWGYdm5W1oNfpUSWEt3T9x6Ly8LD9TKojh0E5LI+SOje9NXLFkKQLsow
	 Pv2EpHRmuI4EkgeaDqVknhYUA41rDaOuepA0JVk5MBkP+RPFyiIXbm7WZCnfJLwRyI
	 ykAlbdu+MaQzW2JSWA2Am/53UHJtcSDMQCZQIbKKF8AiyD0V3z3wrrF17jpxyfHFRF
	 +hiobKksjGe7f70foK6AKJjENhHhV2LIVWR4C9Vnf2NCpRJYQJ9c8ACpqAx1LtqDX8
	 gjqaIDQkoZad+48ms9nyCWe8FgJe3g/kpmiRx6I73o0RqYLk/Jennr7hxNJBRf1iY+
	 /afj4FOcb/vNQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZX3wKvzXK7;
	Fri, 27 Nov 2026 09:36:20 -0500 (EST)
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
Subject: [PATCH v12 40/43] sched/deadline: Reschedule a running task throttled at its enqueue
Date: Fri, 27 Nov 2026 09:36:07 -0500
Message-ID: <94263041ca326af0ef5255512b2f54c8c9c5e410.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

A task with a constrained deadline (dl_deadline < dl_period) can wake up
after its deadline but before its next period.
Commit df8eac8cafce ("sched/deadline: Throttle a constrained deadline
task activated after the deadline") throttles it then until that period.
A refill would let it run for dl_runtime every dl_deadline, more than
its reservation.

enqueue_dl_entity() makes this check at every enqueue, not only at a
wakeup. These changes to a running task also dequeue and enqueue it:
- sched_setattr() and sched_setaffinity();
- a cgroup move;
- a deboost in rt_mutex_setprio().

A task can run past its deadline with runtime left, for example after
tasks with earlier deadlines delayed it. The check then throttles it and
leaves it off the dl_rq. But nothing reschedules: prio_changed_dl() sees
the same deadline and returns.

The task keeps the CPU. update_curr_dl() skips a task that is off the
dl_rq, so the tick neither charges it nor preempts it. It runs until it
blocks, until a task with an earlier deadline wakes up, or until its
next period. That is up to dl_period - dl_deadline of CPU time outside
its reservation. The Sashiko AI review of this series found this.

Fix this by rescheduling when the check throttles the current task, as
a throttle in update_curr_dl_se() does.

The task stopped this way can own an rt_mutex. Its deadline waiters
then wait for its next period, unless they boost it. So this patch comes
after "sched/deadline: Boost an owner that cannot run on its own
reservation" and "sched/deadline: Boost an owner throttled after its
waiter blocked".

The constrained_gap_change_running case of deadline_bw_test changes a
running task with sched_setattr(). "sched/deadline: Keep the debt of a
task across a change of parameters", earlier in this series, already
reschedules a task that sched_setattr() throttles. So the case passes
without this patch too. sched_setaffinity(), a cgroup move and a
deboost have no test case. Their effect was found by reading.

Fixes: df8eac8cafce ("sched/deadline: Throttle a constrained deadline task activated after the deadline")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6bb92dfecbb8..b9dd7ec10e7d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2546,6 +2546,13 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 		/* A deadline waiter on an rt_mutex may boost it now. */
 		if (!dl_server(dl_se))
 			dl_request_owner_boost(dl_task_of(dl_se));
+		/*
+		 * A running task is now off the dl_rq: the tick no longer
+		 * charges it or preempts it. Reschedule, as a throttle in
+		 * update_curr_dl_se() does.
+		 */
+		if (!dl_server(dl_se) && task_current_donor(rq, dl_task_of(dl_se)))
+			resched_curr(rq);
 	}
 }
 
-- 
2.47.3

