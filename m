Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907260;
	b=eJ2PPq9UEn37fZFfdPhH6FWY8lFrK+JrKeRJVQxDVCbSc83VA0iqXj+PDAiYrTfzMY/T
	 TW6JLYN2bs8qfUpnqbRXItA5hrT+J5NQhgeoHjR3BejRFhrk+TN1I2HyOE0VJXZo4oosw
	 B6CQXxrDzQ1wsme+3C++pbotMGQOvszQkuh2gmImhpzlmph0hSYe7Kt0ED4oKCDXEbzlV
	 Lm3AcoVBwoJZivLUDNrRJJ9KeH5zGihatW3EFDYqXuPk+Ai0+xJfSk4083XRHiZegPmZa
	 4LcYh0x/lLGonI/DXLxwwVCvcsgBiR54UPCcvSJe+EfjEIpv3HULl1dL9qeOTfdBxMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907260;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5I0MGRfIHb9a31QQO7f1KWRo5HJ6SKe48VAjGg842FU=;
	b=HneLIL62ypmTFI99iMd9tfer9+/pSrBYvxhmx/nTZDrHc2suWBnjSIOAU3s17ktutUDO
	 7eDai02NhSAjPbyAUc2tp/f0vc60t/ONt+zGWhcCUV0PLFuutXxmNX60mYVy8Ur/LAUJJ
	 OlVUR8mIrV0QndEXjL5ZN/Dg/9j+4LIJ/r4qVQsbKazXSab3p+SPQW5XFcpz85lkt+yDL
	 lGSIzLPTgL3UvuZx73iqDW943jvTc5CzIYtD65uxdzUz4VssO/rWNdNdYkddsfbxa8/Hy
	 F/l0eVB3IyVz/ZzWKlNctzM9CztfsyD0mszdr3a4Ll+MoCDsx7u3BP/6lDTD1M9O6Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fBuASQXa;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E36083608;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D8E36083608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fBuASQXa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907252;
	bh=5I0MGRfIHb9a31QQO7f1KWRo5HJ6SKe48VAjGg842FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBuASQXa+cu0lkhuIDH0kHTgwChAGk5nuYh2cNfGaomxKalLMniTuouGl3webBsg5
	 MhdsjOUuSCmbTmGx8p0wtWt61kWDsShc6qFZ3fbz68CkBo7IO/AqVp+rAd0PhiTd/x
	 pc2/ODuvtQLkJZnDbH0YRqvIvmTFwPge/OkQJbWhxG/AYX0kBL8Yzav5DS5Nrgq2Kr
	 6PANfRJm1Huzm1/nMMYB9eGHJ1ZcXTxgfk0PpB7tUlu30DPmqUox7BCLmTM8ocembn
	 89O8meXb31DpNpGg5z8h1nEKd56x8a07EO4H8IB1IOWAIhLtQ8L9XnyaN7UH+pTLI0
	 Rl+RazyQPLiYw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDN0G5hzKVG;
	Thu, 05 Nov 2026 14:34:12 -0500 (EST)
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
Subject: [PATCH v3 19/24] sched/deadline: Cancel the replenishment timer with the parameters
Date: Thu,  5 Nov 2026 14:33:54 -0500
Message-Id: <20261105193359.1450487-20-mathieu.desnoyers@efficios.com>
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

The replenishment timer of a throttled task is armed for its next
period, which can come after its 0-lag time: a task that yielded keeps
runtime, and a constrained-deadline task that overruns by little
reaches its 0-lag time within the same period. Leaving SCHED_DEADLINE,
such a task has its parameters cleared at the 0-lag time with that
timer still armed.

Back in the class before it fires, the task throttles again, and
start_dl_timer() leaves the armed timer where it is:

	if (!hrtimer_is_queued(timer)) {
		if (!dl_server(dl_se))
			get_task_struct(dl_task_of(dl_se));
		hrtimer_start(timer, act, HRTIMER_MODE_ABS_HARD);
	}

so the replenishment comes at the period of the reservation the task
left: too early, which hands it runtime it has not earned, or up to a
period too late.

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") left
that timer armed on purpose, as what reset a task that stayed out of
the class. The 0-lag time took that over and left the timer behind:
cancel it where the parameters go, and where switched_from_dl()
releases the bandwidth of a task that leaves asleep past its 0-lag
time, a constrained task that overran as it blocked having the timer
armed there too.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index bcf7f88b204a..f772a944a3e5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -562,6 +562,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2325,6 +2326,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3920,8 +3922,10 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		 * boosted owner would never leave its loop over a dl_period
 		 * and a dl_runtime of 0.
 		 */
-		if (released)
+		if (released) {
+			cancel_replenish_timer(&p->dl);
 			__dl_clear_state(&p->dl);
+		}
 	}
 
 	/*
-- 
2.47.3

