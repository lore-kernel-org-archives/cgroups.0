Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=FpkOLp+nBQrHqQJ7v1dIXc9gwIZYMTJnZP7p/PMrU2h/ZWAm2129RxH04JRAKnLQHDYy
	 wwNXDCz2BNNm9vcRfPe/iMvxxEMEgu96U8SYW0TwwpKI7OQk+9FWIrEM6jSS1nssHyopB
	 HrnBggHdWZy4G/kNKg5i+DUlgbjVvmzZOFC3iJ185/Hq1FFcfB2OMrLq+9PY9/6INivIN
	 LrAElxfZgcGS/HEvc8ABQXI8PpLkNEHFRoL4gUU5Hm3T7sXYOOg0SgNkSbhFQcTWMMvtp
	 ohyy+AWt65FKiwYmN8tLKFl2Q0SXZXqHK4YBYhdPisdEwv/mBXmNFudixl9wyCs3ARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hcWcaw255+86RvOkQcmXChxCoCdULwFdRdbuZXbjAkY=;
	b=pPP97ePTk25Aq6IX4BZ3USug8TZckuzrtBTCk2e0umHmhc9BR/ixpcd1wgIQAygiqy7H
	 4UgTB0IiEMaxYyKDlzlkA4LseLJzIF/ZPJZQRNoEoWxItlmb6akDOnNfzFgAMz291iArV
	 JHen5t1xUks1dHd1hwwfMI0U7Br6gwh2zH/6rQcTcCWoMIJh5euhlExobQ0AxvnffFVCV
	 cxsbUm6L7rreDaAyw9L+eohvIJ/92LISmKzF9nRUGNy49Dll2Kg0ejKUUW482UFRNn516
	 44zCleYTn1gcHw2wudaRabicsWZKLPaecYfTC4PPJYd6Dd2MtJcot7v4B+CfYGZF4BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CCnpu8bE;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59B3606EEB7;
	Thu,  5 Nov 2026 19:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A59B3606EEB7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=CCnpu8bE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907249;
	bh=hcWcaw255+86RvOkQcmXChxCoCdULwFdRdbuZXbjAkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCnpu8bExKNJ9F/LVsbh6qsr92k68ZGSUGCpgJ30UNmaGRUNXxYTQS0ZbStvxRNsC
	 qkXI4dcjtOZN7wsZNWOpp6XxlB+Wcg9s7WQBg+srpUMTSO9R4P0R/DrXl97SBQZ/Jp
	 +5Ppcl0WLS+88r4pQVYrcUUjZKHpNYY4vn0Pdb9sT11OxhCIw6F/iQGRCDqkzFZ16g
	 rrNZ1DP9lu45aU4DnlEXHDqa9Qihm2jhE7kmYuY/DlocO2yF+PAnyhsu/AhZ0EJGak
	 LiD4/+Ssed+F4XubM8o9qb1OehjkbAiofvc3DjkP/jCTYQMJ2yqdFrOLTQSwnK3CGM
	 8hyD2rubCR9Lw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDK6GSWzLJq;
	Thu, 05 Nov 2026 14:34:09 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 06/24] sched/deadline: Do not lose a throttled task switched out and back
Date: Thu,  5 Nov 2026 14:33:41 -0500
Message-Id: <20261105193359.1450487-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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
case 8 times out of 8, on v7.3 as on v7.4-rc1, and passes it 8 times
out of 8 with this change.
It was found by a cgroup selftest under development,
test_concurrency_deadline, which hung about once in 1350 runs.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4650bed9cc3f..d376cb493a9f 100644
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

