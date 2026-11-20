Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207370;
	b=gbex+lowGaQrxoATQgU8SIQvPoWVKNEIxB1xSnMs9kz0UoMFYQo4sW/GSSQYBXp/dv7h
	 eHFJAWdbdW6l7Lb2hMeaxFYviPQCuedcX2ylDNbz7SfiZDaZBoufsmWz9IR2WJJG9nl/M
	 a3ms2LLRPefQX3IDg6kRb4IO0zlKI9Xl6gBEIbYCXf7R+obZUtfaE1tMGHykTV7B43HyD
	 hFrM+dJUn4riE8oq+D0R7lHUjlz/H8omlXCDrWIZu42L2U/pJ3pjUDh5fBGcApOs96Ml7
	 H40pPAEOXwGW6Mwwc9oCHG4TNiwxFg07l4o+912qexX1zz7guQHAEpaj2zRNJpwXvAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207370;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TuqbUt3dF8KeZFj1XULIA3nImhV/03hNHHXoWUu0XEM=;
	b=iq/YtzcDJr/t/FLoQx6J7vgK5awzg1OvN+W+EekMIT8io/bivuA9jHrq7yNLf5LbRnap
	 eIX1TJTsAyTEj+Qg+0uGTMe6zyb4e/2q1Nq3JobkFWcNlsPuGGYRIpG1GNzpGaK2soeuh
	 EYXLo5vjK/CCE7Lee9f7ODfB4LkoVk5k1fcAYSdBsyd824YekzuN5atKDtKtcoFWq+z0t
	 PLCNHniOzPmDdCkaUP2+VyKEMm+0D1OAMyA9/hOoaVVN3RZksyY9oVsqFkTKfVkjRiwRz
	 wUw89glq49K4H7SnFHxKS2oCQOlzHE28K0ziEHvkRavhiEBg+kVJA/8NU0GtR36bPQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PQ498Pfj;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550E606A6DF;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A550E606A6DF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PQ498Pfj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207360;
	bh=TuqbUt3dF8KeZFj1XULIA3nImhV/03hNHHXoWUu0XEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ498Pfjlj3frwagk4/jqPUJLQ7C/MJ/OMnJruTHWcY2Tvbae7KSUjKwyIR9freOy
	 EZ2LlYWWleJ7+Q12W+E9JAZuS/eWpHBmBRIiam1VwPJCnyg8yNU//bMN8PLhvksU+e
	 m6W0WWYXL10fGYTEFIoazKOTv9cYRiPYGm74bxWkiBqXoLvNTTykkwb7nM53wHSB7p
	 qPggs+GOoBwJKw5AraIwD/LFFq9sw8cXxD0OMBUX8KPYCfRlFMpzGJu0yPp363ODgA
	 Pau1r/aO+AIvebksESPPL6DnJz2A0w84JJAbVJMVtOnAJViItV4yD7Cq506hDIf8tA
	 vS3s9a5PjNpKQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2S1f0YzV51;
	Fri, 20 Nov 2026 15:42:40 -0500 (EST)
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
Subject: [PATCH v10 36/40] sched/deadline: Reschedule a running task throttled at its enqueue
Date: Fri, 20 Nov 2026 15:42:13 -0500
Message-Id: <c7168c45c66d37cca17851f827681c83f913191c.1795207233.git.mathieu.desnoyers@efficios.com>
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
its reservation. The Sashiko AI review of this series found this. The
constrained_gap_change_running case, added to deadline_bw_test later
in this series, tests this. It fails without this patch.

Fix this by rescheduling when the check throttles the current task, as
a throttle in update_curr_dl_se() does.

Fixes: df8eac8cafce ("sched/deadline: Throttle a constrained deadline task activated after the deadline")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fe48137509ad..b9c206a59c16 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1996,6 +1996,13 @@ static inline void dl_check_constrained_dl(struct sched_dl_entity *dl_se)
 		dl_se->dl_throttled = 1;
 		if (dl_se->runtime > 0)
 			dl_se->runtime = 0;
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

