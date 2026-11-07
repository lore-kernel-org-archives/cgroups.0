Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015902;
	b=IupsGBKlFTTneOh3ILcV3ZkIaM03wcm5rJHIovBvU9EGHEFK1IaSyqS8u3jnJjY71MqU
	 gwj6nuNQshdQSMKfendrpRqcxmY7VZp+ZcJhVjTg4jpadPhj5A11PyygUSkjc0xK9NpZn
	 XmNffuJ/ntuv0ntdn1LrARPRhLMYM8TVhEG2f4K7G5Q1CS9qrc4wfLSaN0OoydN9R9IRM
	 4Yr7C2AAiuq9h253fpLCW0UwQFO/lrEK0knBZNjB3UgJ8lUdmV9TqV1VTKoqSJq6E5Zyr
	 Vbtemhr0ozFUNGXW7XNTYf7XrxwofGPNkuikETlDBdQ2HWA9xUBJCty0eE0lQsHWfwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015902;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mXEXU8BgCGkfxWKg44d05xQRF+kpIQW/+tKVM/5dsvo=;
	b=H85tbMykrfdnsFgdTsC2RCcIS1BXNkI11nOlSg3ShwHAYw4vVcjXhD2atWhaQib511Ru
	 PzN/Sf7y1J1wJSYpRYKKiM69wjDH1o3kvRdWSH/5Jbz8Io3ykuOOC26XiS6r08Nj4GYeQ
	 ErEFG2+6HHTzLJBYfzXW+x5T+WutMdLfaYLyPHcOWWqN6QEQpwBKyVg71a8hk6hp81ZLO
	 +gjNoM/DBV7l8RFxO+gkNxFHEk0zH6rnoqRP0GFluKMJS0d17g9R7j2+rclXMCvbhNuF2
	 D9HVMtoRhuFfGqMwTiZt1cF0b+EhW+K49G68ngUyXODlypaEFK4o6tzeetbR/BSARUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pL0aq4Q3;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCCE606D824;
	Sat,  7 Nov 2026 01:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BCCE606D824
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pL0aq4Q3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015901;
	bh=mXEXU8BgCGkfxWKg44d05xQRF+kpIQW/+tKVM/5dsvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL0aq4Q3CC9Zzdwe5Q5lW1UmUmmfBrwQ63sbUg/khWeqwkXXR+unh6ieYhrr2rZeW
	 AlFXzCb5Bo0CXkdEdU+f2hGtIPfITqQk4T2kUWAM9k+MOvdP5nNHpfKFulYwgycB48
	 0i1prCpCRCU9D3++aY2k79+iIqFLeXVHExn5gn9ktW1x5ZtDUFgYEcI5q4HOGBR8lb
	 5trVlLcyKdBcfGsM84erACFfqFGCXRHRg/Hi3H+VslfDtpyz8cBsls4KDsfEbH+XXg
	 Un5lImz09yZw2rBI4LJGu132Wc5tTSzNwrp2OGSPyQR7QS17Ew1HRP+FW2sbQJBpWT
	 blsjtdgqy+xoQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPn0QchzLgT;
	Fri, 06 Nov 2026 20:45:01 -0500 (EST)
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
Subject: [PATCH v4 07/26] sched/deadline: Do not lose a throttled task switched out and back
Date: Fri,  6 Nov 2026 20:44:32 -0500
Message-Id: <20261107014451.1487825-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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
to replenish it: on no dl_rq and with no timer pending, it never runs
again, not even for a fatal signal, until another switch out of
SCHED_DEADLINE requeues it:

 1. the task exhausts its runtime: dl_throttled is set, and the
    replenishment timer armed;
 2. a switch to SCHED_OTHER arms the inactive timer for the 0-lag time,
    task_non_contending(), the parameters staying until then;
 3. the replenishment timer fires, finds a task out of the class and
    returns, dl_throttled still set;
 4. a switch back before the 0-lag time cancels the inactive timer, and
    enqueue_dl_entity() leaves a throttled task to its replenishment
    timer, which fired already.

The window is the overrun scaled by period/runtime: about 100us for an
overrun of 20us at 20% bandwidth. The replenishment timer reset a task
it found out of the class until commit 209a0cbda7a0 ("sched/deadline:
Improve the tracking of active utilization") moved that reset to the
inactive timer.

Give the task the replenishment the timer owes it, as the timer does for
a throttled task that is not queued: the overrun comes off the periods
that follow, the deadline moves past it, and dl_throttled and dl_yielded
are cleared. Clearing dl_throttled alone, as the first version of this
patch did, left the overrun, the deadline and a yield to throttle the
task again, as the Sashiko AI review of the first posting of this series
pointed out.

The deadline_switch_test selftest added later in this series fails its
throttled_round_trip case 8 times out of 8 on v7.3 and v7.4-rc1, and
passes it 8 of 8 with this change. A cgroup selftest under development
found it, hanging about once in 1350 runs.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 00983487bff3..6cf33045d93a 100644
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

