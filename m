Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655349;
	b=MvwCjq58BfnsH6QtXxkTPDeIikgoKVmJsJZeBpjdfuyCnisRffTqujax2NirDVzBR3/x
	 SzIh8VGdI8R4suEQS3xcosil5bYNQul6fn7PypuQOUJc7NRxzdQ/fzmfIAFgo2k3Y4Ykt
	 IkKazmg5rHZdpHcqjZsJcU20kFfpwly2G4V2w4xXu4tCt+3STxo1Xb1KSl93OskQExagB
	 fSQ3aokxliZPLJV+arW+DRE/7UxUkWnjX1TxZlEud8woJANeLJ0LACAM5uGDUP1k2qHSk
	 p5aspgl7Q1uy5SY+W0cF0eREmVU7JrowMhuguibsv+uMf5Gb7yVlpSqoYY6sc9ewrcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655349;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QA6UABWpTcJvgBDdAPtX6rBCwGO8/qoKShFikhrbTC8=;
	b=JzioO67owK964aaCe8OvxnEyL5ipirD/wWGwbPm6imO7OI248nS3TSd0q8w1R3zwsrOj
	 F4nEbhDNvJQULGST8ZdHR8DCcHO1cMgXajZMVxq6zCg9WMNmjqjQBX+MIhFxWEpCw8DbF
	 qVVtCMvbEj0WvYE2UPSi0KAJSxzQcMfmDTakIOnCnoFGUuApoNYjGSNwqJ9GKjCE+80aF
	 tYwFKPezzheEB9vjJrA5wlp4gmozRmpQRQHmNYS+DftPXO8DrKrsA6jfFSvPE1nJXAQid
	 sd3iuJqtm5+7nCw2oQzPic0IuwXNfw2L50oJZcD7LqMOhzVac9gwD0GXDZoa5RIaiCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vPdNZ+p3;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C0F606BFAC;
	Thu, 26 Nov 2026 01:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96C0F606BFAC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vPdNZ+p3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655347;
	bh=QA6UABWpTcJvgBDdAPtX6rBCwGO8/qoKShFikhrbTC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPdNZ+p3LWkNvSmmMp0/WVpPZk/8Y+hb53SZs7h0Epi7JEEVXLNRCBGpx2nkP+h68
	 vZOJrFya1Le5d+HVfTwB/EROFer4GScKl6Py847g/Qgc6HSYLP9jA8R0+s6ameYLxU
	 oy3hb+iCPbEegPQLVfFyJ2C1Wy6pUoIAkDxQJQvxd6KIFdoX4y0bjF2xKm7NV0jnet
	 5qQypSGOXqGTUFLZrSXct5cT0kuuzIFeftu2TyC2h57lswZuxHMM0/cTxnLREuTjtk
	 QUILy3JWa2kP7amXbWwyVnYsDELeTugChi9FRK9eHupA/30xbqemSVLwJJQswyCFDo
	 1sR525xLTVTsQ==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjb1XJDzWW9;
	Wed, 25 Nov 2026 20:09:07 -0500 (EST)
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
Subject: [PATCH v11 26/43] sched/deadline: Keep a departing constrained task until its next period
Date: Wed, 25 Nov 2026 20:08:25 -0500
Message-ID: <06ad8ff186e425049082d0ee9b6518f85406257d.1795646914.git.mathieu.desnoyers@efficios.com>
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
 kernel/sched/deadline.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1d2dcf478f95..11774b3b9fe9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -759,6 +759,22 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
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
@@ -2598,6 +2614,25 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
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
@@ -4572,7 +4607,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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

