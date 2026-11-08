Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164061;
	b=n3+0GGvaqu9TXJ1FbNHyPtyRw0uPTJfqtocThWp3x20Zzh5TbgV8zIAf868RXMMXKAiE
	 sqgm989pqmhlSGsMm54oTppVI5pq7bZid++ycbHL2xkcC15NbAWlYNRa32TuFB2u89aTX
	 gRabzSCyeLtRQ44AGOYrKiEq1nTztG5jUgra63rDBIeVXR7to1KBCluoXVLKYk6VlrpWK
	 18Y+vlro2Di18+McC8L+nIey/pY6QQ+mfgHbjCX1XSgQ/8DhP8RUI0ZSJcI0RalxBlV22
	 ypUe9Pc+OUOLNzfZfMAOKAqENknsfHdlfotb8DecO+GDKg43g5bX1yMD8CTw0otURCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164061;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZakrGDU7I0ExJ+KsVeivJYa9jehu6sRGSrwXujtmW+M=;
	b=cQyaBGhZjLKC5TnLMkoZjmSOCLO9hjFP+mzIQANMhk+8ZlH1YGMGN4HbSwwLm15DUSnL
	 19Y48CW0DXT/M9GoJWNazT9SU/FotYo8iBFChR/8XEnyMq0TMBh6TouRZWLWvbgY5xZX3
	 Y6bsKeF2nyTNrulmzqDQjLaKMXnV/8Gr9NIZZMpMUwFqWCOxs/kaQ1EAkJnSNkwcZd+p/
	 N/soVVJaQVw5jy0QJBpZFEw6+g2gf1hmOYzqErMgzYwIXZQ6MMgq0yRtTe3oMJFpda/wF
	 dWoZIL1OvqXzxqjEHtZDJqs2z80m0MrljkSKo/27x/BsnIgc22/ovE7o7DDTnIs0Niw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=drqRaDVy;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A02606D82F;
	Sun,  8 Nov 2026 18:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2A02606D82F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=drqRaDVy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164059;
	bh=ZakrGDU7I0ExJ+KsVeivJYa9jehu6sRGSrwXujtmW+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drqRaDVyNLo5x4GCCIda908c3NaoHJdWD8NIippOkrtttlGeGkcLz7k+YQ0mxbrM6
	 eNdiPpYIcZVbQuynvrDMHgA3pqpgR3B+kiKBEjkyRABm5npJF84Orkw0Tk4g49SVPa
	 PoHNK2Eq6KwIf+NlDqKpC1FlOozA+YlRRUhuvNtv4W3xEIFxxHGVE6scGJ5OfAu0IH
	 i9FoUcLlw29ca03Fb2DLKehMPi9UzspsRUWq1eS3SKV8hpoZdsFMKoxkF9NsvuuQlZ
	 QgnvHio1cHJ4g0I6cWCJtNZ7DEWi5LO5DeETKC98t/IpqDUK+13hJh1SCxUme4SWRY
	 fayfVBGlETZQQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2Bz1rjrzMqv;
	Sun, 08 Nov 2026 13:54:19 -0500 (EST)
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
Subject: [PATCH v5 07/29] sched/deadline: Do not lose a throttled task switched out and back
Date: Sun,  8 Nov 2026 13:53:44 -0500
Message-Id: <20261108185406.1549770-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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
later in this series, fails 8 times out of 8 on v7.3 and v7.4-rc1. It
passes with this patch.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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

