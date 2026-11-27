Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790182;
	b=TeBUv1CWE5oVgLTLAEeGgfzdGVMxrsK0mRBhpT/r4LW1oy6l0/IUQ1ZXGJyxnBqPTHdy
	 c1ornFAyRzqdob6o+W5zsCxbwN+Vk5RvycGpE1unu7/DRVJcEA1nSLcMFFIEguaGN7Jdf
	 ciCuqN9ZVkej4cvh6JVNkk8WyClx9tMW2q2NZ6QgucCPdTwDiKn0q75NmLplEcyKUCLN9
	 vtLAB/0OOEPvFzFGE96f07xdMBaeEcaI+v+ZYsRfOto0isdIdhEwo7RvomQdyrRHYAIoR
	 K2aJvJBZfJfbcVlSJ5w3Rcdk7l+dHOb7xIWyN7/JueNlcsVyHBE7ETb0qV6jj/EAZlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790182;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I/4DSZLJitK7JbeX9jIpfme1CL9n7ZeqbAjgJrvv5zM=;
	b=IwmZxCn9ITkobjdfm4dppEpOXqAM8R16m6DcC1jK/JjqJbPQYsdwcR3pkvBY0ogeGsow
	 xqC22poQS/D1EahZzhF0XtnetdGHQafV0GMBPwwbWfJ0FmJJfonAyZ/K4fO80XeFWhXuE
	 /7JH9RK8SYqd6UW4HyCIo28GQasugIrSEm4A1vYOuG5yQlx+M8X4LQ2oLjIFbFOSsxX1A
	 zpufISc/a63oApLfbPCGzjKz2Q8n/HmZ8B0axY81ov10frLRHcmw/YyV3v8V69O6qYqM7
	 wv6qH7wd6aZq8sYzN23weZ/J+TfeZ3dyHIjblR+ewy3BXVlKfAR/rzc/GSJSwLOnydw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=uLHOLiXm;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BED560746EF;
	Fri, 27 Nov 2026 14:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BED560746EF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=uLHOLiXm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790178;
	bh=I/4DSZLJitK7JbeX9jIpfme1CL9n7ZeqbAjgJrvv5zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLHOLiXmj52RrHBXjb9hehmhTXNpxXT9HBpG3xT0sAXRXQ5aTJbCn+9DJTth2CUEh
	 pJ98qHpiqrGN25BE5NEsQbxzQemjUDEm99qC9Z2qYxrvnkVexrQU/AP+mZ5w/q4oPK
	 mXn8CARXJlgXRcfR43DzbtIkZlrQ1zXF6H+Yesku73FS3XbarMvSXvDYJ6DGR2+YU7
	 QqiMYT4oq+vzrhOkcw3ebjQzA9D34CW3tCjB8JMcg8O1mV/chfwumkCUXaCx3mklRd
	 Awudt0jx54ALLS3vG58b+Vzq+s+/C55jebmg5Cg3xeMAQZ33HQuKRHYKRzYUaPzC/s
	 tDzE7L0U8tWFQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZV1gZqzX2G;
	Fri, 27 Nov 2026 09:36:18 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	tommaso.cucinotta@gmail.com,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v12 27/43] sched/deadline: Replenish a throttled task boosted while asleep
Date: Fri, 27 Nov 2026 09:35:54 -0500
Message-ID: <20a888f86e1cf2d286e5848b10e419c0a5e2a3af.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

A deadline task can be throttled as it blocks, with an rt_mutex held.
Its replenishment timer is then armed. A deadline waiter can boost the
task while it sleeps.

Commit feff2e65efd8 ("sched/deadline: Unthrottle PI boosted threads
while enqueuing") lets a boost override the throttle. enqueue_task_dl()
lifts the throttle of a boosted task, and dl_task_timer() ignores a
boosted task. This covers a task that is enqueued while boosted. But a
boost of a sleeping task does not enqueue it.

T is a SCHED_DEADLINE task that holds the rt_mutex L. W is a
SCHED_DEADLINE task with an earlier deadline:

  T                                  W                              T's timer

  uses up its runtime, sleeps
    dl_throttled = 1
    start_dl_timer()
                                     pthread_mutex_timedlock(L)
                                       rt_mutex_setprio(T, W)
                                       T sleeps: no enqueue
                                                                    dl_task_timer()
                                                                      T is boosted: returns
                                     times out
                                       rt_mutex_setprio(T, NULL)
  wakes up
    enqueue_dl_entity()
      dl_throttled: waits for the timer

The timer has already fired. T would never run again, not even to die
of SIGKILL. Every later waiter on L would hang too. This was found by
reading.

Fix this by returning early in dl_task_timer() only for a boosted task
that is queued. A boosted task that sleeps then takes the existing path
for a throttled task that is not queued: it is replenished.

The refill reads the parameters of the donor, from the timer. So this
relies on two earlier patches. "sched/deadline: Do not replenish a boost
from cleared parameters" keeps the refill from looping on cleared
parameters. "rtmutex: Continue the chain walk when a waiter's deadline
donor changes" keeps the donor pointer from going stale. After a
deboost in the class, "sched/deadline: Restore the owner's period at a
deboost in the class", later in this series, gives the task the values
of its own reservation back.

The Sashiko AI review of this series found this.

Fixes: feff2e65efd8 ("sched/deadline: Unthrottle PI boosted threads while enqueuing")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index adcd9c9f8a9d..a6ca7870416e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1690,10 +1690,13 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	}
 
 	/*
-	 * The task might have been boosted by someone else and might be in the
-	 * boosting/deboosting path, its not throttled.
+	 * A boost overrides the throttle. enqueue_task_dl() lifts it when the
+	 * boost enqueues the task, or when the task wakes up boosted. So a
+	 * queued task needs nothing here. A boost of a sleeping task does not
+	 * enqueue it, and it can end before the wakeup. Nothing would lift the
+	 * throttle then. So let a sleeping task reach the !queued case below.
 	 */
-	if (is_dl_boosted(dl_se))
+	if (is_dl_boosted(dl_se) && task_on_rq_queued(p))
 		goto unlock;
 
 	/*
-- 
2.47.3

