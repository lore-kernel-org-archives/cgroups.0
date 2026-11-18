Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037118;
	b=XvF5pqPkpYliJ2r/yGIP+aa0KUMBC04n+PYYCGIU40ae/gxVsUQPTMgwUyT3RFuujHV0
	 371fiDvezUwkpZDo9jDgW7t4GQiFvhQvIt+Yi8df5TOvBb5XdycZfQ6RtEb3i514LROqF
	 esTFjT/EZUxGoxUyeFx9WoIwYh5zoahPi1oGSIQlcht9njKzBQaWBQqAyr1aqrO/hAvzA
	 avh4g5UTGS1VegRFjKobGjlNA2jnEVmEQUkwlkK9LmeeaIRrTkt28s/RoSp1ZPjCAQI/g
	 +eUOu5a1hpanR7+deEWbYbwrpaV+1JyExWbQcxvr1KpKLEeMcLj6xJH25bm5F9u9qOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037118;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=18ZdUzzadRsL6aFCNsE+0dn3GNsx1KvXA2R8ZIV+JwY=;
	b=WbG9BtjlkioJGIRIKjKgwUhjQotiHMTNApB/vujH7Yqg0rYhfpj70OG8ePguRde2O4cD
	 ir/CvdFGzxLgpUDZUhP8O2+aDg5rt98k6Qn7G3WaFMTHzw0ai7G1dt0TQ6iBiDykrmWW+
	 8IoWtMWkWSSjOWQ9qaH8mm5RBnLV4F4w52VgJpwBvHVIeiaOTudjYP45+icP309E0WEwE
	 mF+g7jQo1/xHYgUlBPzi2YlKPQfdOhhf9el3r/3ptEsqe4mskFtBWPmalw7oYVYWei2mD
	 Zcvs/frEXGYQR/hZeikl0pEye54Pgq0jloaQ1EBmDSmCF2FQiOp/L4uMsfiBBBw4YYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U6HEZCrz;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E65F60A262F;
	Wed, 18 Nov 2026 21:25:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E65F60A262F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U6HEZCrz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795037116;
	bh=18ZdUzzadRsL6aFCNsE+0dn3GNsx1KvXA2R8ZIV+JwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6HEZCrzzjKnv3q5OX0WVbnj6Hijf0+glRgjnDDMS9OXiiT0Yh7ClvbnfgmbTmpJA
	 w3joTR/ml/JPiPRxELtdZI7Md9cTOodIUpf+kpHLcvoaD4uphH1vu0xoM/nhX45w5W
	 vNHBY2RTJkawTMqGieZ1yWzQpQzpt6z+9r1hXRy+b6vm532+lkUlgIfFtJqkiUtjUN
	 NCdPimeft65nGx9DYHV+i+2ESRyO9Z7h0DzaVZNLeiQoO8fTvxa85fbXJzcSIRI5s5
	 KumXltVseV7eKoCOX9YBUISXZRAQ8iAmn1qPvyStDtpjSbZ6cXrGObRp6JqzmhBR9d
	 /NoGTVjWWwdnA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVF4X57YwzSRS;
	Wed, 18 Nov 2026 16:25:16 -0500 (EST)
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
Subject: [PATCH v2 07/16] sched/deadline: Do not lose a throttled task switched out and back
Date: Wed, 18 Nov 2026 16:25:03 -0500
Message-Id: <e58738e763010632a024a6874a97f1d980b90ce3.1795037078.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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

