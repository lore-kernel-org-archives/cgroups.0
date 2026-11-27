Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790181;
	b=AFkRQXGCmOCSM3CiYAiKkya8Ii0Vrqi4eXsiC0TLZ7GaQjaewiDyDswBtFgqcRX1oYCl
	 vpoSqxuzGdLriIoD7C080yjYeYcuwxjNujmotjURl7NesjU7L5pkkiRUU96HlPsVMFWzH
	 rv/Qqr1uNlx0xl7ztDDqEaFieSuuTbD8TkSALzD4/nwRW0eNJbbRDRhWioE3xx58oA+1b
	 ulF8DWCk/ic3VDCjJz48PPQG47e5wIrg1svIDPs2llV1AXdzmlSuRy2VFePRDpTHwX5zT
	 U7GpyuGTPJMEJO8us480mHeqByFSN5lQ7wZRHA4DSu5Gjx9OaXRT3Ld7Id/sFPaUECw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790181;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nV+8nJCVCkwKQM93407IXbRq7/HtWRuqNm/z94RNMUY=;
	b=5fKh2srqS2GNbNDYxnBVEGCtJmBRUi67VzbrInk6U9cbkf3nIPHb2vhZ8Alj0xyg7G5u
	 dpU2yoLYu8+VlxnrOXHwt5WPBlhIo/aujeI+k6qIc/TpskfmV6id1SgDpLji6H2h3iH1X
	 48OX8AHax+SbZKG+wFuREo7hsuSMOstpfqUePV3PUw9P22LBxYRJyXtMP40gvRYZ3Qjsk
	 k0nVSUtFjr/DIf8B4Ump5LGG3TKmZwqyaupwW9wDEqyirEK85NiXczTgk9aRO/I7oTYwv
	 DS2K8jWReaDSshHfCykdw+BBS9LE3TnC8oN9ZxxYvUFmUqgMItiYH9GxDLTa7n5e0PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FqXkhIt6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A6860746E3;
	Fri, 27 Nov 2026 14:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51A6860746E3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FqXkhIt6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790178;
	bh=nV+8nJCVCkwKQM93407IXbRq7/HtWRuqNm/z94RNMUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqXkhIt6yixLUpcvbchLYvWqEO2Pe95W1dijr3gMnXhYEwKvOlKsB15ha4iUFPJcW
	 qOEzLT0n0L6M9Ixd3afKqnXHID+7cPjlYGCI8lGWJgH8pEuFSYAgJm4hGnghnnWYsM
	 ctgumFkvQhJmUvBWw8iJps1rXEPZ94qc0k4a5CDfAx8N1lKGrn62OjAWaWyLmQWu+q
	 khgHtdRiHHMnw/s4X5vj3AOa+A3c0NLxELVWF7O24rS3g518ZKnri+Rv5q8BDaaoZv
	 yHI3slHTDMe8EFuurR6ePY6MaDVjKEqvC9YpuswlApKuHJkhJXq1DgaRobw42FGTsp
	 S8vz0VraH0TQQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZV0PQbzXZS;
	Fri, 27 Nov 2026 09:36:18 -0500 (EST)
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
Subject: [PATCH v12 26/43] sched/deadline: Keep a departing constrained task until its next period
Date: Fri, 27 Nov 2026 09:35:53 -0500
Message-ID: <54e41332aec6ddeb1d060c892cbac401c936df86.1795771148.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its bandwidth until its 0-lag
time, so that leaving and coming back gains nothing. Until the series
this one builds on, it also kept its deadline. For an implicit
deadline, losing it after the 0-lag time changes nothing: a wakeup in
the class then starts a new period anyway. A constrained task in the
class keeps its deadline until its next period. Past its deadline, its
wakeup throttles it until then.

That series clears the deadline of a task when it releases its
bandwidth:
- "sched/deadline: Reset the deadline and the runtime with the
  parameters" resets the deadline in __dl_clear_params().
- "sched/deadline: Release the bandwidth of a task that leaves the class
  asleep" adds this release for a task that leaves the class asleep
  with no timer pending.

So a constrained task that leaves the class between its 0-lag time and
its next period now loses its deadline. If it comes back before its
next period, it gets a new period at once. Repeated, this gives the
task more than its bandwidth. Other deadline tasks could then miss
their deadlines.

For example, take a task with a runtime of 10ms, a deadline of 20ms and
a period of 500ms. Its period starts at 0ms.
 1. It runs 2ms, then sleeps with 8ms left. Its 0-lag time is
    500 - 8 * 500 / 10 = 100ms.
 2. At 200ms, it is past its 0-lag time and before its next period.
    Another thread calls sched_setattr() to make it SCHED_OTHER, then
    SCHED_DEADLINE again. Leaving the class releases its bandwidth and
    clears its deadline.
 3. At 205ms, it wakes up. Its wakeup starts a new period at once, not
    at 500ms. Between 0ms and 500ms, it can run 12ms, not 10ms.

Fix this by keeping the bandwidth and the deadline of a constrained
task that leaves the class until its next period. task_non_contending()
and inactive_task_timer() wait for the later of the 0-lag time and the
next period. In the example, the task keeps its deadline at 200ms. Its
wakeup throttles it until 500ms.

inactive_task_timer() restarts itself until the next period.
switched_to_dl() cannot cancel it while its handler runs. So the timer
can stay queued after the task comes back to the class. The next
task_non_contending() would then take the 0-lag time as passed. It now
cancels such a timer first.

The proof of Lemma 5.1 in [1] uses the same rule for its H-CBSD-W
server. A server that used up its budget while idle stays throttled
until the end of its period, as a sporadic task would.

The cost: a constrained task that leaves the class keeps its bandwidth
in total_bw up to one period longer. Until then, sched_setattr() can
fail with EBUSY for a new deadline task.

A backport of the two patches above needs this one, and
"sched/deadline: Count the 0-lag time from the next period" before it.

"selftests/sched: Test parameter changes in deadline_bw_test", later in
this series, adds the reenter_asleep_late_in_gap case. It runs the
example above, with the round trip at 150ms. The case fails without
this patch, and passes with it.

[1] D. Casini, L. Abeni, A. Biondi, T. Cucinotta, G. Buttazzo,
    "Constant Bandwidth Servers with Constrained Deadlines", RTNS 2017,
    https://retis.santannapisa.it/~a.biondi/papers/CBS_CD_RTNS17.pdf

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 49 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7dc0b71e7cce..adcd9c9f8a9d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -761,8 +761,35 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
+	/*
+	 * inactive_task_timer() restarts itself for a constrained task that
+	 * has left the class. If the task came back while the handler ran,
+	 * switched_to_dl() could not cancel the timer, and it is still
+	 * queued. Cancel it here, so that the test below sees only a handler
+	 * that is running.
+	 */
+	if (!dl_server(dl_se) && hrtimer_try_to_cancel(timer) == 1)
+		put_task_struct(dl_task_of(dl_se));
+
 	zerolag_time = dl_time_to_zerolag(dl_se, rq);
 
+	/*
+	 * A constrained task that leaves the class keeps its bandwidth and its
+	 * deadline until its next period, if that comes after its 0-lag time.
+	 * Back in the class before then, it goes on with its current period,
+	 * as if it had stayed. A new period at once would give it more than
+	 * its runtime in this period. A dying task does not come back, so it
+	 * releases its bandwidth at its 0-lag time.
+	 */
+	if (!dl_task && !dl_server(dl_se) && !dl_is_implicit(dl_se) &&
+	    dl_se->deadline &&
+	    READ_ONCE(dl_task_of(dl_se)->__state) != TASK_DEAD) {
+		s64 next = dl_next_period(dl_se) - rq_clock(rq);
+
+		if (next > zerolag_time)
+			zerolag_time = next;
+	}
+
 	/*
 	 * If the "0-lag time" already passed, decrease the active
 	 * utilization now, instead of starting a timer
@@ -2602,6 +2629,25 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 	if (dl_server(dl_se))
 		goto no_task;
 
+	/*
+	 * A constrained task which has left the class keeps its bandwidth
+	 * and its deadline until its next period, as in
+	 * task_non_contending(). This timer may have been armed for the
+	 * 0-lag time while the task was still in the class.
+	 */
+	if (!dl_task(p) && READ_ONCE(p->__state) != TASK_DEAD &&
+	    !dl_is_implicit(dl_se)) {
+		s64 left = dl_next_period(dl_se) - rq_clock(rq);
+
+		if (left > 0) {
+			ktime_t at = ktime_add_ns(hrtimer_cb_get_time(timer), left);
+
+			hrtimer_set_expires(timer, at);
+			task_rq_unlock(rq, p, &rf);
+			return HRTIMER_RESTART;
+		}
+	}
+
 	if (!dl_task(p) || READ_ONCE(p->__state) == TASK_DEAD) {
 		if (READ_ONCE(p->__state) == TASK_DEAD && dl_se->dl_non_contending) {
 			sub_running_bw(&p->dl, dl_rq_of_se(&p->dl));
@@ -4576,7 +4622,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * the "inactive timer" fires, it can continue to consume its current
 	 * runtime using its current deadline. If it stays outside of
 	 * SCHED_DEADLINE until the 0-lag time passes, inactive_task_timer()
-	 * will reset the task parameters.
+	 * will reset the task parameters. For a constrained task, the reset
+	 * waits for its next period, if that is later.
 	 */
 	if (task_on_rq_queued(p) && p->dl.dl_runtime)
 		task_non_contending(&p->dl, false);
-- 
2.47.3

