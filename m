Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924670;
	b=qWwyrIE889VFUy7guNbgbcuGzy/yIrc3bBy8QyexbyIQn7ByntvSoaoHbJajwOK3rpGY
	 oT97B9S/4/knJ0iqCnVTNxR1HTlnyBdS8oVA5oe6UjBPT0A8+0PidT/42xDwUU3KUhlMt
	 iRjO5Jn2f5WKtdPk1dRK4JQ9y6ZDSvdX76vxJMJnP7niGWu6vD3UZ6qQuxOZ4w1ex+yhC
	 vmp20JgG1C17VpwDXYpHHveQADveidprkLMNnL0ZaOkmASTDB3sX639k8KL8aGky7DbJl
	 U4MSNlYo9vXUBrT5ORQELlc5iMYS3oPTQwbwLqgC+5gZNx3ru+1EnMvXxwTh0A/kt8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924670;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dwAObomZzGA+pB4rpfVbRBlrWAVJNYNde8t9PhYvqno=;
	b=QxNX5++UNzvtJ4X+fS7SRLurSNKcfu81wyKXr35jgxn9qi215ysQLNCp6DRNZRwmqmct
	 Du+TlxYF4gvlpW5SgreEmdlCwmtoYmE2SeVpsdGNz6jociPxP36cBx3YR2bJvLDGRP6t5
	 cnnOmCF5Na2JNQWxMHrkc+W0PsadksbYNsuOgJF1wfBNX73qAW2FXB0Qz495cbUNguSNg
	 /d6xX6ES4/EQ2imJLlmPzH/f1Sy4z/M/6kARlaUjwA0YKO5kCbAQpmy3Z0EAzMfWrfgYt
	 F/AcTbA2BqVKhWJd0R3wQerivgKe464yxsbWjQiq/VbnvmQeyBeD9p68NvigEvB3aFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ju49XRPz;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484E260A2613;
	Tue, 17 Nov 2026 14:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 484E260A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ju49XRPz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924665;
	bh=dwAObomZzGA+pB4rpfVbRBlrWAVJNYNde8t9PhYvqno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju49XRPzsG0qblxTBaoAV9dxprI/MfYS4IxO+xasre2TGvIn8prJhGN6SbwX890Jd
	 +oAIfmi1qQXZFBxpcp3XhbxsN8DL1hvvCPIk4FZ9ZjI8YkzqOO3JgKlGNFE3FFnyIw
	 0Lt/tWitOooIDIMI1RpUvzMftaMufK4/U7wM4J/OWFVQHklbdT0m+6oa4HyXaSkRqC
	 MWrXTBiqJfPK5ELTLJcKwPyVLYSu1q3MFGwHHcnwalZxZ5iWpYmFtPaWR2qWHtL137
	 tc8uOG3rdfMxveB8a/XL/xWlVEvvEAx4aB9bF8PUeL7qUivh6K9m/fl7kgeasNFM9s
	 BwYm0duAp0uVw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV13HT0zR8G;
	Tue, 17 Nov 2026 09:11:05 -0500 (EST)
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
Subject: [PATCH v7 07/40] sched/deadline: Do not lose a throttled task switched out and back
Date: Tue, 17 Nov 2026 09:10:28 -0500
Message-Id: <82e3973fb86fb3cb5b9d131a142c25f0b00af18f.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

A SCHED_DEADLINE task can be throttled, switched to another policy, and
switched back before its 0-lag time. It may then never run again, not
even to die of a fatal signal.

A task that leaves SCHED_DEADLINE keeps its parameters until its 0-lag
time, so that leaving and coming back gains nothing. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
their reset from the replenishment timer to the inactive timer, which
switched_to_dl() cancels.

This misses a task that was throttled when it left. An overrun can put
its 0-lag time after its replenishment timer. That timer fires while
the task is out of the class, and does nothing. On the return of the
task, enqueue_dl_entity() leaves it to that timer, which has fired. The
task is then on no dl_rq, with no timer pending, until it leaves
SCHED_DEADLINE again.

Fix this by replenishing the task when the timer finds it out of the
class, as for a throttled task that is not queued. Its return then
enqueues it.

Clearing dl_throttled alone would not do. It would forgive the overrun.
A yield left set, or the old deadline of a constrained task, would
throttle the task again. The Sashiko AI review of the first posting
found this in the first version of this patch.

A cgroup selftest under development hung on this bug about once in
1350 runs. The throttled_round_trip case of deadline_switch_test, added
later in this series, fails 8 times out of 8 on v7.3 and v7.4-rc2. It
passes with this patch.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b614d5fc1a1a..e4d7cbf4861d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1233,9 +1233,18 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	/*
 	 * The task might have changed its scheduling policy to something
 	 * different than SCHED_DEADLINE (through switched_from_dl()).
+	 * It keeps its parameters until its 0-lag time. If it comes back
+	 * before then, nothing else would lift its throttle. So replenish
+	 * it now, as the !queued case below does. Its return enqueues it.
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

