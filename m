Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164061;
	b=z7YR3X0E+hdVegoD2JbUsxDf3xbiItByYPsrROd0/4to8Gzrb97C+zW4xLJsIKeF0yYa
	 Pxt/I6kxqeLpthhECDtPcNWXuUVe9K3V0BHRIw4hT4+tACZAF/5b2xUUSVYKzQLbVn58n
	 K204zMmYM9+OrHJRImODQFcFevbE4FcmAse5xsCE1i9TZ+TlH/XUl8bZ+dlbNaa2HuQ1q
	 dCaDfMW1GHRGixM3KwrSsSCcocpY1HreDwX0ls6ahrEgoqLYvP7tCE18+Wza26XPH2mFW
	 ZQQh8FPIP7qHOiwnPjITegWrjcPQHqx29dmG0utfG4gRts/G43z0Ne6KbE9iQ3BDhFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164061;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nPbPKPRbXcEofKYqokd7VQKwOPfUx31CS6vwr7Chvh8=;
	b=REPSOWXFEY/ZEgmI7OuZUTz0FsXBF4S3vgvTVny3Hbtn6xYNt2nRmsac1F8GzA911sn7
	 niusD7H4DkOaCNn1n0XcDqiudKcbcrzW9l6c+BguMfV99hLOrQMecFRp6GD0+NhWWcIGL
	 lU/LPGswlUO5R+mV7OkavEJu+vVIZSgta4fjWoocnEsMeyhttN0vmFhXXuwdUdQDvl781
	 Mj94Jzt1bIphxeGqcnnbVwo1+X6c1LuVmI1GNyTv95+67WtVqi6mpEuO83M0WavVbRje3
	 u2L1SlhvUkh3od3ifKeFDTv9T0H7wJ5q+44XkmUz28rkJNR3pc4Rpmz3NbKPpA10dWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iwLnYk8u;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58932606EE82;
	Sun,  8 Nov 2026 18:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58932606EE82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iwLnYk8u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164060;
	bh=nPbPKPRbXcEofKYqokd7VQKwOPfUx31CS6vwr7Chvh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwLnYk8uRhesVnEMo+A/UQF9oGJGydZG/bbZjIgajLapcK5CEZivNX9VvJr6PUDUE
	 JGuVPlZBzxoZEA0YW0iYSfRkA1efyRZi+sbU851ehrngOSrnPANocfzM2oFXZWS7xl
	 2ddZmNIMlLJ83anNZVFRgIUErI9i6t4KPqK2wz+coVjdmtbm8TvMGb2VQ57C3wdXP5
	 maYLEhUBfKDmZPIATRLzlINM/gSAI5S5m8vGXhucoTZZg3WlzAzR878ptTLLhZMZv3
	 FbUolev+PRUDqdoSCQNvb6ppPBrC1R1V8IyJE1L7H3kloMsoGSoF2SNr6PkMRoomam
	 uKqZMbYkrU40A==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C00c4VzMqx;
	Sun, 08 Nov 2026 13:54:20 -0500 (EST)
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
Subject: [PATCH v5 09/29] sched/deadline: Reset the deadline and the runtime with the parameters
Date: Sun,  8 Nov 2026 13:53:46 -0500
Message-Id: <20261108185406.1549770-10-mathieu.desnoyers@efficios.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cf24d2df6bfc..cc43c5eeae51 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3573,6 +3573,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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
@@ -3999,6 +4009,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
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

