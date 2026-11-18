Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032412;
	b=Z8xeW04ce/BOu9GyEHjH/HOs8+4UNhImC9A9tUx0g2hD+YFXNxWBneuPshkSDEP6+ekG
	 B3wtg4sWI82oytWNZL+9oEl4CLbxMvARuRlO15+DeVe0/SgiqXppC1OX8Vog+g6OWgW9K
	 F12RCeRXjqvYeAKM209WdLk/sAGnRhV1UpbxCA8KZrPN9EEVT5T4tcRiu/Nu8jqhCFxde
	 b3C/hQ7wItYVic9DkqpcqMrDdk+Nvn8vg28x7LzhqLlZEwpdqKTffH3HAThPtKzv/dpx5
	 VdSPwN8Z6o1/ZpMssDOnPSNAFvjJKpdpgHqEg0UIfW5jvhW8rF3dx3uLkr3zoqThrMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032412;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=18ZdUzzadRsL6aFCNsE+0dn3GNsx1KvXA2R8ZIV+JwY=;
	b=zsw6olosHBIHxG8WDYUB0+k7zzPuuI+zxyKac2Edym2bYjHgmF8mLIu2kppKhSQ1xwOX
	 /7f7hABke92l6mDShKmYEYE1SV22/huCK2dbDGGtWJKcku4ZkzO3jZR46OdMsBh76O15e
	 Mmg3ydUwiZkoAjQju4C8PVIHqnlFQOE4AqLl3Q7Ymi5uVbi428OxZX58v5crDSyZ6k73Q
	 6p6t0XNfcSX4B/Bm6E+ivFunTaNoAWSrRAW0fBT6wjt2qtp6hgXT6as1+uj0bexSh2nTL
	 SvP7cPUrZ384JmZm+t1Lpwn0o23XHLmOc62YHcwgD2LuQyK+GEgdrYFJEJttQD/F5Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TY67OB7z;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB160A2629;
	Wed, 18 Nov 2026 20:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCCB160A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TY67OB7z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032404;
	bh=18ZdUzzadRsL6aFCNsE+0dn3GNsx1KvXA2R8ZIV+JwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TY67OB7z5X+Pxg3A0kdWh2AL6KGbxL1NDEPZNppY8UCjUWEArwEdIvUSdjFN+ZYIm
	 dceZS2/Q3c9D2RNCAdK0UJqBVpLI53gslIDGZzCC7nOzTXf9MWsAMHYwPocVVnZIm0
	 Qe0oDMOf5/cFwO1iMSfyDFJy96iPqv/1if+zF0Kh0vmhDLm2a6iPh54UN4ySVAvb4d
	 4+Qxan78doqMygSiWQZs+xef1gICo4nnegGL1eSdkO9wSFKbPrHiX7i1tbpI2PQKXM
	 uz1FrXT+OAKMXCcYkmq1j7Tqqwzz27SF9ZnTeveLwgWPlyng51w5mPJGfR0jhA1e92
	 jbcrJevnttCJQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKw5vf4zSNs;
	Wed, 18 Nov 2026 15:06:44 -0500 (EST)
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
Subject: [PATCH 07/16] sched/deadline: Do not lose a throttled task switched out and back
Date: Wed, 18 Nov 2026 15:06:32 -0500
Message-Id: <e58738e763010632a024a6874a97f1d980b90ce3.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
References: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
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
throttle the task again. The Sashiko AI review of this series found this
in the first version of this patch.

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

