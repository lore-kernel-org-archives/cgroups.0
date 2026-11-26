Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655346;
	b=ogWDfOJVLLxpd+pNkRXrqOLqOTL/Rl/rxIwjun3a4HgIeiK1BvrBzw6ZQextsb/Te26H
	 07wi+hKZVZos6TIoOcRj71Wf2iJq6/Wxm+J+++Mfxj11zP6ZMv4wF8TtGq8EL5f04xYEc
	 jAThpFt9CK3mb172w1dyHn5SA3ZLLeM92haTKCfj7RZjsfD3NyHLghGzW0V/N4IpOzeEf
	 ddAEvhe1Nu2Aa/Dj7HSeVqzfrY52AsJR2mvruSvOkVLDhKOJemW36jFvoEa3dnhZMrC3B
	 aindrgW+G68SFG6lEGdnHlLIowWCjy4ox4Rsvo48fy8H88H2Ki5WWqTM1sSm0DQMeAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655346;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UNfXRsGfHoyy/U6tpwZgKkZ2HKP6ILdRnxLWKmbUmYg=;
	b=13VpkN7yaBxBS7/uj5cV7C1Tc61br746QAbTExztMA8f/A86cRmh++BwaleGpHFdt2wZ
	 8JO/PHK7/O45cQif9wL5UM0Vd71kUQNY91sM8jumMYQTAX7veO58wuAzlZtSdGA6ogigb
	 pF9bk7hGr6UpazbtH1Bnk36oG0ZbwIVwsBBtAFUSkw+jh57f/0kOEGAxkj/wnUuByAVah
	 51EfIpB7FTE3C075ExUkwciM9gQ6yjG0qBQT2oSDKUNpO6ruUi+zwpQUV7FS20FuTXTY7
	 yHWyNg+6oXSZAwc7c5Vd7JthwjV+V457dt1N02vCssCvXwZq+js8y4Uz6oeLMkGwe/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=q8BQxAlP;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3EB60A6F47;
	Thu, 26 Nov 2026 01:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F3EB60A6F47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=q8BQxAlP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655344;
	bh=UNfXRsGfHoyy/U6tpwZgKkZ2HKP6ILdRnxLWKmbUmYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8BQxAlPGhwEyyGGhUkw+1D74mG8XInjqUaT94YDGCG4ObkIjEQ8seW7W8r3f5Jzx
	 g4ERVyFwxM7mqXX/JLsXUu8VLiMTMuV9/4ESvH0yOrli+16JYocrZpA1rt2QFqJeqP
	 OACIt4XpwmDEB/3w54ND49nyXN1M34JJin+X4tNX5NrjYZX0i9ZI4F6vaXhbuPsSXN
	 VEJG18QOjm+cDozEJnoztx1Oy6NNYP1uJLhrfef8r87pdC/g2YKbr57K/qU/EGotNv
	 nKNmPa/1Uv4zeKDjfi83rBIfxDAh4pQaSkEyDF3RQtdlxiNNdXxBTI616n/VoUxVpU
	 h7JeoUOmZZHuw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjX1HvhzWql;
	Wed, 25 Nov 2026 20:09:04 -0500 (EST)
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
Subject: [PATCH v11 22/43] rtmutex: Do not stop the chain walk at an owner whose top waiter changed
Date: Wed, 25 Nov 2026 20:08:21 -0500
Message-ID: <dc2bce8678399d13d29d87cf346195852c7442d1.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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

rt_mutex_adjust_prio_chain() stops the walk early at an owner in two
cases. Each case misses a change of the owner's priority:
- The owner's top pi waiter is not the top waiter of the lock just
  walked. That lock then does not set the owner's priority, so there is
  nothing to pass on. But the step before can requeue a waiter whose
  priority dropped. The top pi waiter of the owner can then be a waiter
  on another lock. The owner's priority, or its deadline donor, changed.
  With deadlock detection on, the walk went on, but without requeueing.
  It now requeues there too.
- The owner has no pi waiters left. A waiter that left caused this, and
  remove_waiter() walks on from the owner itself. But that walk can be
  preempted and come late.

The walk then stops at the owner, and the next owner keeps the old
priority or the old donor. With deadline tasks, the old donor can exit.
The refill of the next owner would then read its freed task_struct.
When the waiters are SCHED_FIFO tasks, the first case leaves the next
owner boosted to the old priority until it releases its lock.

Fix this by removing both checks. The next check already stops the walk
when the owner's waiter is up to date. An out of date waiter is now
requeued, and the walk goes on to the next owner. A late walk can still
leave an owner on an exited donor for a while. The next patch keeps the
donor's task_struct alive as long as a boost points at it.

The first case, with deadline tasks. O and M are SCHED_OTHER tasks. W
and Z are SCHED_DEADLINE tasks. W has the earlier deadline. X is a
SCHED_FIFO task. It takes the top of L1' from W:

   O         M                 W                                  Z             X

   locks L2  locks L1 and L1'
                               blocks on L1'
                                 M->dl.pi_se = &W->dl
             blocks on L2
               O->dl.pi_se = &W->dl
                                                                  blocks on L1
                               sched_setscheduler(SCHED_OTHER)
                                 rt_mutex_adjust_pi(W)
                                   M->dl.pi_se = &Z->dl
                                   walk at M: L1' is not M's top
                                     stops
                                                                                blocks on L1'
                                                                                  walk stops at M
                               times out on L1'
                                 not the top waiter: no walk
                               exits
   runs out of runtime
     refill reads O->dl.pi_se:
       W's freed task_struct

The second case. O, M and X are SCHED_OTHER tasks. W is a
SCHED_DEADLINE task. Another task, S, changes the policy of W:

  O         M            S                          W                          X

  locks L2  locks L1
            blocks on L2
                                                    blocks on L1
                                                      M, O get W's parameters
                                                                               blocks on L1
                         sched_setscheduler(W)
                           walk at L1: W behind X,
                             M deboosted
                                                    times out on L1
                                                      not top waiter: no walk
                                                                               times out on L1
                                                                                 M: no pi waiters
                                                                                 walk from M:
                                                                                   preempted
                           walk at M:
                             no pi waiters, stops
                                                    exits
  runs out of runtime
    refill reads O->dl.pi_se:
      W's freed task_struct

The cases pi_chain_top_moves and pi_chain_top_moves_rt, added to
deadline_bw_test later in this series, test the first case.
pi_chain_top_moves_rt fails without this patch and passes with it.
pi_chain_top_moves also needs the previous patch. No case tests the
second one: it needs a walk preempted at the right step.

The Sashiko AI review of this series found both cases.

Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/locking/rtmutex.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index c78dfe9c93fc..b09816977d4e 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -818,27 +818,14 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 		detect_deadlock = false;
 
 	/*
-	 * Drop out, when the task has no waiters. Note,
-	 * top_waiter can be NULL, when we are in the deboosting
-	 * mode!
+	 * Do not stop at a task that has no pi waiters, or whose top pi
+	 * waiter is not top_waiter. The previous step can have made a
+	 * waiter on another lock the top pi waiter of the task. A waiter
+	 * can also have left meanwhile, and its own walk can be late. The
+	 * priority of the task changed then, and the next owner must
+	 * follow. The test below tells whether there is something to pass
+	 * on.
 	 */
-	if (top_waiter) {
-		if (!task_has_pi_waiters(task))
-			goto out_unlock_pi;
-		/*
-		 * If deadlock detection is off, we stop here if we
-		 * are not the top pi waiter of the task. If deadlock
-		 * detection is enabled we continue, but stop the
-		 * requeueing in the chain walk.
-		 */
-		if (top_waiter != task_top_pi_waiter(task)) {
-			if (!detect_deadlock)
-				goto out_unlock_pi;
-			else
-				requeue = false;
-		}
-	}
-
 	/*
 	 * If the waiter priority is the same as the task priority
 	 * then there is no further priority adjustment necessary. The
-- 
2.47.3

