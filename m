Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855970;
	b=bOE6CmpFZT4Qfo2BjE/bPfLVdCBckZcDjTeEzbtwmxtPKsAW/cs0OPMCmqbJxS6FGD4j
	 N6AANnq3MzEXiHWXKSHzb2Bw2RreEs15ZmRUFQqkPxrGoAelxH8spsSi5X4QZQLFsOlHw
	 qwHlcTyHYSFNgHgApK9ikqVi/4rjKd3akVBPRkJ6KE2+YZPPnc9OPuZ9x7pSo151mZzBe
	 f0Hu6guCkJ/Y3EFWHMEYuJFOB1NSXk6OkVOKBqa76Pg2y3aPenNAFygGzdB3n1bVAyWe6
	 FbGYtrHUeb0VEZ0hleKT2blDELXUP2t7MJNn6zcTtkkjV0tRa3f6Fc6uMjf7FSRs3eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9hg/XLb/8rXmcE81BwPZ5cEsKDZju0f1hHk/xV/boBc=;
	b=OztAtWOc9HPu5UQi4f3lJ7yA+sxEvumdmWznlfJrcCiHDPdn2aTgBYHTKaSo6o5Cqg7G
	 Sw76nKNve00+GjKDgEBBYwru1p2kvYfagVKmrUQripAPhWGdwFo0k3Tnpa4IaLBNiN01X
	 tdfD5OXmUnzypHynYqxkWkeoBHuf5NhW2w6iLZwcQOSdWr5l0Q6Eg1Cz61pBnEUFoOpSU
	 sDGHrn6VkgDzcpZCwRtlptEhODh7uWMiAIfdNviwMzhvocUN8tnhCu2Ro8DxX89Yg7Owq
	 gs0vWB4bjzZmwlLe3p7oETsmXuVhDtAI9kc6VBZBsVmxktOILkhgtHbhILf4dDcl1XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=l1yetUyV;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6D606A89A;
	Mon, 16 Nov 2026 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55D6D606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=l1yetUyV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855959;
	bh=9hg/XLb/8rXmcE81BwPZ5cEsKDZju0f1hHk/xV/boBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1yetUyVQNZCrfWh624sFw68CGai9DZefTbHnAjna5xTzTPu8GMv20KH0eysBbszA
	 Qjqa1GWbkefsoduHx6AFdyBJAUSkKPczIFJqzkgv3R+0enkjYswkajsP7DoUq8TM0d
	 WwjmTU5jy96XPn4VRo0IwewFjvF+oCg9ZLMDVnCoWyMStdYHAxZB6F0BnKjlAGiPdv
	 QQo0xkKLFWyYIQcaVJf2BYaD8hRD/tc8ipGtF6Dq0+swEAq0kKVyDL8mCcC0cu35Z5
	 KEDgTILDgTRMWsWstj5SqfsI8uUuf6JrZF8QdEFyIbvEHWMBSh+E5l33OWBpDdBw7q
	 ug8T6Zbp2HlCA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4l0dlwzQth;
	Mon, 16 Nov 2026 14:05:59 -0500 (EST)
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
Subject: [PATCH v6 29/37] sched/deadline: Cancel the replenishment timer with the parameters
Date: Mon, 16 Nov 2026 14:05:41 -0500
Message-Id: <20261116190549.230119-30-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE has its parameters cleared at its
0-lag time. Its replenishment timer can still be armed then. If the
task comes back and throttles before that timer fires, start_dl_timer()
does not restart it, since it is queued. The replenishment would then
come at the period of the reservation the task left. Too early, it would
give the task runtime it has not earned. Too late, it would delay the
task by up to a period.

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") armed
the replenishment timer when a task leaves the class. The timer then
reset the task if it was still out. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
that reset to the inactive timer, at the 0-lag time. Nothing cancels
the replenishment timer there.

The timer of a throttled task fires at its next period, which can come
after the 0-lag time:
- A task that yielded is throttled with runtime left. Its 0-lag time
  comes before its deadline.
- A constrained-deadline task that overran by little reaches its 0-lag
  time before the end of its period.

Fix this by cancelling the timer where the parameters are cleared. This
includes task_non_contending(). switched_from_dl() calls it to release
the bandwidth of a task that leaves asleep past its 0-lag time. A
constrained task that overran as it blocked has the timer armed there
too.

The Sashiko AI review of the first posting of this series found this.
It has no reproducer.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 61b50266468f..72bafa46ae41 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -650,6 +650,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2446,6 +2447,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
-- 
2.47.3

