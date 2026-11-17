Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924676;
	b=ZKAhKm1i8jbNkDNAooGdDD7skEweXPU8bMXGtBQ511379SVFykT+LSV5pQMwM/mE9FdI
	 YUQiYRRnhsMy6GSgORwUaOmZxVVFs85cgJ3IBju8RyPzY2aDAUoT+qGbjPag8ylKVb2td
	 HHffwCt6box47QrB4wm4zQYNSmWl29bAqyCFb076hKLpGIk2M18NzfOwvz5gtHkLVvW+6
	 c4g813ToJ1DJo4KspS1PZjU5f7ySvamUiG8BIJST0wH+gc6gpuz5h9XXIT894kHCPhp4b
	 MwWdU8zUo7TZrZWeKVcMlb7h89vAmYGSNo/+nS776WbdIlp0rtSP2/p4HBbWndgNk4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924676;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jnFa78rUjtTG/tfWtGZnX8Qs907JGvyWaK5R6QvkTmg=;
	b=2UQNEeaj25ix99w+13mcKJAZnVC79gdhsGxKUNYep836Jc4a8hcqFx03o1hu4QKpJI7S
	 lVdovAxiObfPjdDt9qnRhedAJCPAhkuDAYpFKZkxm3iaX8ssHj5Y6MkqPIDrKyNrUBhcy
	 r2QEv5qjuLBru0CbWwvqvj0KZZtJ13BB6vCURyqoFKAHofRzvzhKPAY7/u3DobQPrlhKO
	 BariWMZsbniThdzsCadwiCPv/9/xLO1IFu7039o1ToYEiZvtkQBlswlIy13o1rLCgONA3
	 MVtM4mygshgTM4SE3378fIb6EmqlCnqqDimgc+V+idBEknyOGTzbcUzT8LgASVT2bLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MpGb2Elh;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF1A60A263F;
	Tue, 17 Nov 2026 14:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FF1A60A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MpGb2Elh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924666;
	bh=jnFa78rUjtTG/tfWtGZnX8Qs907JGvyWaK5R6QvkTmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpGb2ElhgK2od6MKqcfReKO00rHsYtc+W1JZAhtUzer30JzjE0xmas/OHOCdNp7Bf
	 gwq05uNGJ014gk3xlnwqo1D9qeF6lPMVzx63odcN7IpPKRT9nZgJEv/GAZcdE7g5qt
	 PywY9dE2mL+Lo3Xuc3ZtrI3kRvc9dRxhLwYWdqgGUNzflyYKz2zQT5UYGr6uuFGGrS
	 GiXJzVCRt+zXv/9Bjb85d3CPcMKTMUISLUfLoJQ40lSDeNLtOy93MKw0fk2TpGWbL9
	 9cGNrm7VGgl0KPrWMdhEpaxBZ2U6f4MbdlwHuPTtZKoW3Nyy6njULJNelbQpXztHPA
	 uSCExVZU8KAzg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV24sHszRZP;
	Tue, 17 Nov 2026 09:11:06 -0500 (EST)
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
Subject: [PATCH v7 13/40] sched/deadline: Release the bandwidth of a task that leaves the class asleep
Date: Tue, 17 Nov 2026 09:10:34 -0500
Message-Id: <a809425266acca7cfadd2e8187a7b5a815ba32cb.1794922146.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE while it is not queued can keep its
bandwidth in total_bw until the next rebuild of the root domains.
Repeated, this fills total_bw up to the admission limit. Then
sched_setattr(SCHED_DEADLINE) and CPU offlining fail with EBUSY.

A task that leaves the class keeps its bandwidth until its 0-lag time.
Releasing it earlier would allow temporary overloads. For a queued task,
switched_from_dl() calls task_non_contending(). It releases the
bandwidth if the 0-lag time is past. Otherwise it arms the inactive
timer, which releases it then. For a task that is not queued,
switched_from_dl() relies on the timer armed when the task blocked.

But the timer is not always pending when the task leaves the class:
- The task blocked after its 0-lag time. The timer was not armed.
- The timer fired while the task was still in the class. It only
  removed running_bw.
- The task was woken up on another CPU and is not enqueued there yet.
  The wakeup cancelled the timer.
- The task came back to the class asleep. switched_to_dl() cancelled
  the timer.

Then nothing releases total_bw.

Fix this in switched_from_dl(). For a task that is not queued and has
no timer pending, call task_non_contending(), as for a queued task. It
arms the timer if the 0-lag time is ahead. Otherwise it releases the
bandwidth now and clears the parameters, as inactive_task_timer() does.

Clearing the parameters keeps later paths from releasing the bandwidth
again:
- A timer handler that already started finds a dl_bw of 0.
- The deboost of a later priority inheritance boost finds no
  parameters.

An owner that the task boosts as a waiter can find the parameters
cleared too. "sched/deadline: Do not replenish a boost from cleared
parameters" handles this, so a backport needs it first. Without it, the
owner's CPU can lock up as soon as the waiter leaves the class.

Juri Lelli's first fix, since dropped from tip, released the bandwidth
here without clearing dl_bw. The bandwidth of a boosted task was then
released twice.

Juri Lelli suggested the call to task_non_contending() in review.

The Sashiko AI review of the third posting found the two cases with the
0-lag time ahead. deadline_bw_test, added later in this series, tests
this in pi_former_owner_asleep and deboost_released_resets_period.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Reported-by: Tejun Heo <tj@kernel.org>
Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
---
 kernel/sched/deadline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2b5a2a43addf..67cb1b1abbb8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3640,6 +3640,14 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		if (p->dl.dl_non_contending)
 			sub_running_bw(&p->dl, &rq->dl);
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Without an armed timer, nothing releases total_bw. Do as for
+		 * a queued task: arm the timer if the 0-lag time is ahead, or
+		 * release the bandwidth and clear the parameters now. Call
+		 * task_non_contending() after sub_rq_bw(), which needs dl_bw.
+		 */
+		if (!p->dl.dl_non_contending)
+			task_non_contending(&p->dl, false);
 	}
 
 	/*
-- 
2.47.3

