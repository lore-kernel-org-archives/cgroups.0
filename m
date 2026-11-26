Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655358;
	b=3L4KZ3iPKIQ+wRULBe845dWQS2ri5XUoDTSMkAX0PatawiI1bd4mXQsswUB5OaftW7Ec
	 lJ9RboSB60TH5oNHMLJ2042FQHRL2XUbRmWXaCLYf427/0NdhuvjbGRRhk54fMKdT/3O2
	 /30vC4tlt58QkHSi5pbGjGQV8gbPonkSWA7UJtHYYw5BXU9AZdXrFRIfvEBIgddV49oM4
	 0XzSSKiE/8z+KeAoCB29puKlZdP3ANyT/3fsrb+gnPcWrmCg4cmXH6AgZ5mEaAOy581t7
	 kxPsP5r386dchQacm31e+hf90113LYqfiPNB5bAxxOhOlZHBNJylD1GT6SxuXtDS58w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655358;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=O6MZiD775MG+mO0OJ94L4mvlKGGFJ/6GTsh+Rh/lBg4=;
	b=VXi77NJ/8bu4LTZF9qeqol5EKN1CnUYbACno1d9Up/hslP/nHZLwyBYXVQeEWRqzYJRY
	 Lgq4A0FzwSg74RjuDLOf+4AmNKKWYG6837JSe6I1KKYEQpchM3Tn3vqvFUXm1Prgdib8A
	 TCzX7Zyh4bQ3Mq2cG+MmtEPNnkhjAPZLciGYD8SBChaud3kVNvmBFl6I9ECOy8uxpmcfL
	 CDg1nenX5idFjJR8/pgwPhV5WPwrvvFh2pwgJQpS7+plcKehYvvks6NHLZrv4lrjChF2q
	 jejsN6H3OfjY102AqL7oX61c89QZxpVzbNld8wFKG8pc2E8vHRsgHXoIjfsWv65t+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AKiwW5L1;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A57606BA3D;
	Thu, 26 Nov 2026 01:09:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77A57606BA3D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AKiwW5L1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655357;
	bh=O6MZiD775MG+mO0OJ94L4mvlKGGFJ/6GTsh+Rh/lBg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKiwW5L1MGImAY75Oz+OxUJVSD24YAmM7ZSVcS2Ss7bU2t+zxhWjXa7in1oLCao6I
	 AB64nX4sOxeRVE4uVXkW8Hz/phl3ZlF2bUdKaMZY/39cAqpiq438dJSiuLsZzslvGN
	 5tovdTMwsshk4qX/LejLFrPbTXqnROgPfzJcal242CbMpKxK713UhvsJ949ZbueEnp
	 2jHFpF2JbVB7SpqiIr6NBdkicsw9QszZDelTJkAsHbgiZ/oXuhESMuvSj3ZE7l1jdR
	 79T8/3C4LVoc9til2btf/kD4KKHhid5ENHu+ZQE3V4X5qLk7QH2p2mvXTj+mDaczYr
	 gQPDu75pQvcBg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjn0FWDzWx6;
	Wed, 25 Nov 2026 20:09:17 -0500 (EST)
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
Subject: [PATCH v11 40/43] sched/deadline: Reschedule a running task throttled at its enqueue
Date: Wed, 25 Nov 2026 20:08:39 -0500
Message-ID: <29a5f53e9f5dc0f5f9a554796e4528a0e6226f5b.1795646915.git.mathieu.desnoyers@efficios.com>
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
index 7a1beec2d95e..52095e24638c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2465,6 +2465,13 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
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

