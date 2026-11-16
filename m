Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855964;
	b=WepFAnzu9hL0eInJ9OcsgNx8llAwV2oTv+Hnp3OpOzwiXHxdCjnHStnlEcLdqg8NxQC2
	 VsJe7VQvG13pBX7PvXVwkMq1SBfPKQoFJsaMN39tTqvBF9x7voMDtoWvLX0A0lXi7ZgrQ
	 pq551ay3WCgQDRjWgSZnSg9U+NKFtnaGztvjEmypj3RpITrxR/+Vlrjry6qne4kauBJWY
	 ttUsg9tpZkKQwe6swnAIc2Pu2lLeEkAvkr8m0A3BZmzFh0x+XQZvmktGuQBO68n6EpT9S
	 GJxtDGAo+XgMRn8Cjc6BEAYZxwLwO5VPRoWfQ8HKfiG7iEcePcxqmtIOeE9SWZUJaAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855964;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1dWSPzWSmrrDPm5GEFxYGW2hGJHMUlu9fb/gyhQjuvA=;
	b=zuR9zcgo14UQi7DOYovBf/WLTQ41PCIO08MftQvrreFmWM+oDLgVvxCd2c4tO1WJiH8N
	 PKOzguvTpxE/a88BnWXp2IXjLRrKB5sy/ohbMnFO/ImwJuPCSvWvn/GnV6aQeZCFnc+s6
	 trRzkF2EhIJnZw9oXXv8Z93IUTTE3bQzOG8eJ5ELF9lJLeSbCwWTTk9+3t5ckH6mKk+1/
	 BwCnVYm0jpX8NVlDPT8i44IdwaY+XzNuGBRz+EE8fTajSzhodMybJQQobB7URgjCExZrw
	 AyaBKKJrLNasb5CU67zHgMDPO+xysSszmkoX03DxuPcGoipN4QFcSTNK8qK/CInIkqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TJu9HT2p;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9AA606A899;
	Mon, 16 Nov 2026 19:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D9AA606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TJu9HT2p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855955;
	bh=1dWSPzWSmrrDPm5GEFxYGW2hGJHMUlu9fb/gyhQjuvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJu9HT2pCOiKIIU/tBdQ3eIgS+GH1WbXRsGc8cJv5Gl8ZpPQ2EnCqg7/xOmnbycE1
	 CgU5lYsRZBuZV2rQZ5oZOdl7bDTUL0680y11XYlTZ25fqExeZP3rROZuggQs71hFUo
	 oJNNw/DZJu7/UgS71WGqlKQQQb96LsCFzM2vjP4Roy5gXGvDs/NSktEOUqVO+AQ/4R
	 FzaFeJPcJb0AID7nULFoh6nulpyqZr5j3yGKfQBbDewA/z7d6UH5HYuvrKHAaPk8FG
	 b7XTtPnlKdesbtRk/ua1GrNbLYH2olF0u1yBQGYnhgYPkvB5/WEFLjdeO31q4ZxV50
	 P/XdE2nVEYVrw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4g27lLzQSt;
	Mon, 16 Nov 2026 14:05:55 -0500 (EST)
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
Subject: [PATCH v6 09/37] sched/deadline: Reset the deadline and the runtime with the parameters
Date: Mon, 16 Nov 2026 14:05:21 -0500
Message-Id: <20261116190549.230119-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its parameters until its 0-lag
time, so that leaving and coming back gains nothing. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
their reset to that time. Before it, the replenishment timer did the
reset at the deadline. So a task back after the reset found its
deadline passed, and started a new period. But __dl_clear_params()
resets neither the deadline nor the runtime.

Now a task back after its 0-lag time can be enqueued on its old
deadline and runtime. With runtime left, its 0-lag time comes before
its deadline. Back before that deadline, it would first spend the runtime
of the reservation it gave back. Back after it, a constrained task
would be throttled until its old period ends. "sched/deadline: Do not
lose a throttled task switched out and back" moves the deadline of a
throttled task on. This widens the window before the deadline to about
a period.

A task with no parameters of its own, boosted by a deadline waiter,
keeps the donor's deadline and runtime after its deboost. If it then
enters SCHED_DEADLINE before that deadline, it runs on the donor's
runtime. On v7.4-rc1, a task of 10ms per 100ms ran 40ms of its first
period.

Fix this by resetting the deadline and the runtime in
__dl_clear_params(), and in switched_from_dl() at the deboost of a task
with no parameters. The next enqueue then starts a new period.

The Sashiko AI review found the first case in the second posting of
this series, and the deboost in the third. The deboost_resets_period
case of deadline_bw_test, added later in this series, tests the
deboost.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c4ea51059941..dd48f74412b8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3557,6 +3557,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	if (task_on_rq_queued(p) && p->dl.dl_runtime)
 		task_non_contending(&p->dl, false);
 
+	/*
+	 * A task with no parameters of its own was boosted into the class.
+	 * Its deadline and runtime are the donor's. Reset them, so that its
+	 * next entry into the class starts a new period.
+	 */
+	if (!p->dl.dl_runtime) {
+		p->dl.deadline = 0;
+		p->dl.runtime = 0;
+	}
+
 	/*
 	 * In case a task is setscheduled out from SCHED_DEADLINE we need to
 	 * keep track of that on its cpuset (for correct bandwidth tracking).
@@ -3972,7 +3982,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 }
 
 /*
- * This function clears the sched_dl_entity static params.
+ * Clear the static parameters of @dl_se. Also reset its deadline and its
+ * runtime, so that its next enqueue starts a new period.
  */
 static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
@@ -3983,6 +3994,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
+	dl_se->deadline			= 0;
+	dl_se->runtime			= 0;
+
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
-- 
2.47.3

