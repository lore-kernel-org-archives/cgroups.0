Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924670;
	b=HmbToVIg8KMSff51lWbxa5rWv5dsOFQ+gwM4l5sOVGxGNcFoBHAJvXPTwOj/vCWlMSJU
	 1uHj5ZSptXRI1FC2e5+HYmZm3JbcPPXqkguIcxTJTqY9O+TrglQYoY4F/OMYEVb0sCAZQ
	 d+0MvFnfcZpty4Cfu+ECvrz5pjXVlWdxzbTtu88R3U8brYz4iIfDM/7cigsz2xjY07R9O
	 xuwDYoY9lZ5dMCK0W1hTms5NMNX/i/i8fpTa/EuWyTq4rx316OOjU0W8o6HidrlHlrWzO
	 y7L/3GMj8WEFJfHpFBest7wrVbxHfFwsy6C1VaU/Ehs9HMInnpCCZLDGLplAXXwJm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924670;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4wCddsQmKRg8jkXOvnUL7ZbEG/CVweneCikWsFnbL+c=;
	b=nf2iNkG6vfwWkB/lq+urKDfDCrcuCe+uLtQlFbwr+51vIxRJ94w1t9D3cj5f/DYY4HUj
	 2L2M0Y30iYANCAK+GM08/wugh8pFHtU1m17nPntcZBd/gXgjDo1nGjoEo/QG3QxKx6KJm
	 CX9dLAtUQH+tnNHWusetHog2MP6c0TQv3EtT0u+Cy9E1HTgRCxEY0tX1N1UZtSQW1iAIR
	 yA8PbTfO3ITize+jwg+MyIc0cgsZHCBZwc3jE0WSn2Y2tVeTIwpQbkdMch9gXQXQmU5QK
	 7Z860OUKcTDW5frTDUzdNYh2cJRDkZuBuy5InmQCJjW5piJvS5BdU8RKsu5zhPjiU/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GXf+LdiI;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F3A60A261F;
	Tue, 17 Nov 2026 14:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2F3A60A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GXf+LdiI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924666;
	bh=4wCddsQmKRg8jkXOvnUL7ZbEG/CVweneCikWsFnbL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXf+LdiIYslCKS792pMHbb4/k6mty6Q+Ou3NKLnsQUC7mgOHXpdGQs6b09bmObbJQ
	 3aaQNrQdeBc4vmpAzMI11VmVbVOLZgFqaEjrFi0yUL/SjqNwqrBkqj9k2hijqQdMt/
	 KEwcPzI/ctlYGFMjk/8ceSI+QPdfGAXCRpufFR0qQsW0SMIdK54GKgsok8zxxx9hBK
	 bRsHsZzhsuJL5EGupsglnnSp97LjqkjkhAdiYuBHjPXKUJ8OyL+CS2evBJwbLnsCU9
	 F4mi/Hjfc84ZW4PBTOHJFhSbYXr0FSUEkRWzzRGBRMk+exkCjFkYCm6dxhuaLTyLQu
	 xdwU0LFRf37Gg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV23R6RzRBR;
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
Subject: [PATCH v7 12/40] sched/deadline: Replenish a throttled task boosted while asleep
Date: Tue, 17 Nov 2026 09:10:33 -0500
Message-Id: <7bb821fa298ce41c9f6e49b5b6f5e462b41db8d5.1794922146.git.mathieu.desnoyers@efficios.com>
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
donor changes" keeps the donor pointer from going stale. After a deboost in
the class, "sched/deadline: Reset the donor's runtime at a deboost in
the class" starts a period of the task's own reservation.

The Sashiko AI review of the sixth posting of this series found this.

Fixes: feff2e65efd8 ("sched/deadline: Unthrottle PI boosted threads while enqueuing")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 989e7e7d3f8f..2b5a2a43addf 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1319,10 +1319,13 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
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

