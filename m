Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826735;
	b=3kYTnKsNla4HjTISB2ktoF3KM1Es65YONnhZzbwaKIjG2rBaXS+up91KvCZDFWM6j4kG
	 qVCEIGdBbwLC+AMNK6APG599vQVzszUC1fzD9CKKD6h3YyQGKz8zWHYd7cnO8CTKcUzDK
	 rlLiFwBv8W2tqTa26or4LyUJh5WnHCeQMuyyCh+dD7VJz+tKCUxVTOFhTJxuzIjG/Yl+Z
	 ZiJMnz+Sr94TMbl7dSo655F33m0xzo1yUDoX9qBLK3Hpl2BqFFbwk/TBG//a/YJ9MzSyT
	 BxkjzSmJLqAYPUYEvxOt2flQ6+BBFwKAzprGF4uKWkRQooqhAAs1eHCvpmuc57cfGQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826735;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sWPlGrtoENRtv1Qn/Jmt5SSK5q5qz3CWqDLDGE+bsjs=;
	b=hflLL7w6rLa4UQ7KkDt5EDHR4Urx5fxCv/27HAW3B7frZsJ+2CnxftDDw3lM/z4QfHio
	 nMCgWtCtQGrQWjb02dOSdia78cStu5vIZyxu1RgCNLOAU8EKqJZTdQJfRMEUO+F/n5xOJ
	 FaOK7rBa8WpBHygVjxHXbQeiG23Rjc0qYvrltYJ4j4oiPYPw/Po1FdGep9PQ3PC2daFwh
	 qF48zdFyoE97k7L+bmWI1H3kknkN8AYNL1rbL0yN+0165uprINgZQv4jCcWmFDMHoDxW2
	 XQjvQ+Gy5wlCc2OpoAagYfO1tAxUnedSoAWWvL8b8MQdI5L+GutIN1J3Yzxbm7+aB2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZoAgffMz;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2006081761;
	Wed,  4 Nov 2026 21:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB2006081761
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZoAgffMz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826733;
	bh=sWPlGrtoENRtv1Qn/Jmt5SSK5q5qz3CWqDLDGE+bsjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoAgffMzY3yMslrpmmX/rYkqDcmD0jV/8+vl4bL9hTL7Km62W6EB8vOri28NRX/u5
	 145a3O51Nyjs8+GVd3KbGWEI/cRuorVHr3LHG6GFoAcRMR5QoayBrKMdC1fhOTgD6t
	 sKSbvBmHTHsHe8ai23qKecPCkOH5yrrw/nWG+D++8AgNswNDhwid9attZ83BUQC3EA
	 RMPumS4t+dr1QZkJc5s58y2SvebC+hKRVbbl+2M1va1vV1HsR/3L6aKSo8yuMmfdpA
	 MjKCja8TicXNrhF+VDrn2+BoCW+b3GrYkO8du6pWxMPaH1zPZ8V1ZyZQBP9pQ2aspK
	 4prM8GS/gY3NQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRx3QyvzLXT;
	Wed, 04 Nov 2026 16:12:13 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 06/21] sched/deadline: Do not lose a throttled task switched out and back
Date: Wed,  4 Nov 2026 16:11:52 -0500
Message-Id: <20261104211207.1392343-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

A SCHED_DEADLINE task that is throttled, switched to another policy and
switched back before its 0-lag time can be left throttled with nothing
to replenish it: runnable, queued as far as the core is concerned, but
on no dl_rq and with no timer pending. It never runs again, and a fatal
signal cannot make it run; only another switch out of SCHED_DEADLINE
requeues it.

 1. the task exhausts its runtime: dl_throttled is set, and the
    replenishment timer armed for the start of its next period;
 2. sched_setscheduler() switches it to SCHED_OTHER: switched_from_dl()
    calls task_non_contending(), which arms the inactive timer for the
    0-lag time; the parameters are kept until then, so that leaving and
    reentering SCHED_DEADLINE gains no bandwidth;
 3. the replenishment timer fires: dl_task_timer() finds a task that is
    not a deadline task and returns, dl_throttled still set;
 4. sched_setattr() switches it back before the 0-lag time:
    switched_to_dl() cancels the inactive timer, and enqueue_dl_entity()
    leaves a throttled task to its replenishment timer, which has fired
    already.

The window between the deadline and the 0-lag time is the overrun
scaled by period/runtime: about 100us for an overrun of 20us at 20%
bandwidth. The replenishment timer cleared the parameters, dl_throttled
included, of a task it found out of SCHED_DEADLINE until
commit 209a0cbda7a0 ("sched/deadline: Improve the tracking of active
utilization") moved that reset to the inactive timer, at the 0-lag
time.

Give the task the replenishment the timer owes it, as the timer already
does for one that is throttled and not queued: the overrun comes off the
periods that follow, the deadline moves past it, and dl_throttled and
dl_yielded are cleared. A return before the 0-lag time then finds an
entity it can run on, and a return after it finds the parameters reset
by the inactive timer, as before.

Clearing dl_throttled alone would leave the overrun in the runtime, for
the new period of the enqueue to forgive, the deadline behind, for
dl_check_constrained_dl() to throttle the task on again, and a yield of
that period set, for update_curr_dl_se() to throttle it at once. The
first version of this patch did, and the Sashiko AI review of the first
posting of this series pointed the three out.

The selftest added two patches later fails its throttled_round_trip
case 8 times out of 8, on v7.3 as on v7.4-rc1 with the four deadline
fixes of sched/urgent, and passes it 8 times out of 8 with this change.
It was found by a cgroup selftest under development,
test_concurrency_deadline, which hung about once in 1350 runs.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 30a52e42c26d..b646063a7b0d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1232,10 +1232,23 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 
 	/*
 	 * The task might have changed its scheduling policy to something
-	 * different than SCHED_DEADLINE (through switched_from_dl()).
+	 * different than SCHED_DEADLINE (through switched_from_dl()). It
+	 * keeps its parameters until its 0-lag time and may come back to
+	 * SCHED_DEADLINE before then, switched_to_dl() cancelling the
+	 * inactive timer: give it the replenishment this timer owes it, as
+	 * the !queued case below does, and leave the enqueue to its return.
+	 * A throttle left behind would never be lifted; an overrun left in
+	 * its runtime would be forgiven by the new period its enqueue
+	 * starts; and a yield left set would throttle it again at once.
 	 */
-	if (!dl_task(p))
+	if (!dl_task(p)) {
+		if (dl_se->dl_throttled && !is_dl_boosted(dl_se)) {
+			sched_clock_tick();
+			update_rq_clock(rq);
+			replenish_dl_entity(dl_se);
+		}
 		goto unlock;
+	}
 
 	/*
 	 * The task might have been boosted by someone else and might be in the
-- 
2.47.3

