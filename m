Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207372;
	b=s21L59QIRnaeLtW6LjTcWrCAsoxldzDZlvmcLbiLgn1id3buVlvAEolwyj/Ny4Aiyz0d
	 XrYHRN0P5+/CpGr0KlskUcEywzZtNrudFG0U50asArhna9X3uwwPgBFvbbOUJKuMOlFbm
	 c+seOjqORgSfE3NHHJIywtMO238CHx+AbsZCoLh0rgsKWElvy+v0Jgan99TK4VFrE6XAU
	 WkuafoXMzYnQWlFuVuD5Rk0InKy9g8sb2fFajoWE1Srxx6HWSrESLoNLymwnAtsD3oC3o
	 +c740mzJx7K440fYyvrTjT7Dzxx4FtxLVscrHcyEOCY7gWWQwJZqMRumYzsr0m6D+Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207372;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L5CwUnGCqkImF7EPBO5cwC1DAtzuwAyqeEc/qm9ijis=;
	b=XV9pzDKRZyZhpPBSH6C2VyySZV1l1lZ71AZ8SCZHlrDQkBQB73O/Yib3PT4p3XZl7NfH
	 BiMK3U/QANCyKwX23zcb7mfqjIg67HuoRF5ma2c6wIXOXeafj8WLz2mxs5BaD6NF68XkZ
	 NIF9VDr+fQvSaIRKKDDfGCorjIRKFBnP0J2teU2sFHq8PscT6WkX61NKCyS6Sjnpc8CLX
	 zyjgu/RO94cDb5ZmS/Hx/tesDo+1txW2H2QF6EyzgVhCB1E77gM5C36ZLj8mAzS39PrKf
	 y4Bwf+3vcApAmMdKeRsFhI7qAOAcPL7fLlfjqnodrk2iANtiZDdcC1X4WMjSTWLLeCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bn1vH3kL;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1287A60A3831;
	Fri, 20 Nov 2026 20:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1287A60A3831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bn1vH3kL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207356;
	bh=L5CwUnGCqkImF7EPBO5cwC1DAtzuwAyqeEc/qm9ijis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bn1vH3kLOolCyGz+Qs6YVdJfyvfg3giQIVYJ6EmAJaYyjLNKSdmN4kmXkd2tyjtEe
	 VMny7xQ7xwTpWw+7ZXHOKMmjj2K9BjhgUAvbYovVtoONKgP5wGLgGVqUU2aY6AwLwm
	 hUJlaPV2ALhDZ49f0THt6mbhnoI3rmV3tqF5nVCBFfcWZZnN+eoYbxCr+UgMC7kOWf
	 rG5EkEWVqxrDieNSDWj/IaTqwC3vBy1lj6UUfuVlEn23Oft2i+vMXWYQMslpTPx5AV
	 xtVP7uppO6MCgU/d/F+o7HE8MvfF/pb4t2Ioch/OMVN+icBGs1JMX69lyKkmkJ6pCF
	 7x8t5VplCJBZg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2M6l7JzTqb;
	Fri, 20 Nov 2026 15:42:35 -0500 (EST)
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
Subject: [PATCH v10 22/40] rtmutex: Do not stop the chain walk at an owner whose top waiter changed
Date: Fri, 20 Nov 2026 15:41:59 -0500
Message-Id: <91a8c5f34dd71897a54e70a01d132c4403e0564b.1795207232.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

rt_mutex_adjust_prio_chain() stops the walk at an owner whose top pi
waiter is not the top waiter of the lock just walked. That lock then
does not set the owner's priority, so there is nothing to pass on.

But the step before can change the owner's top pi waiter. It
requeues a waiter whose priority dropped. The top pi waiter of the
owner can then be a waiter on another lock. The owner's priority, or
its deadline donor, changed. The walk still stops at it, and the next
owner keeps the old ones.

O and M are SCHED_OTHER tasks. W and Z are SCHED_DEADLINE tasks. W
has the earlier deadline. X is a SCHED_FIFO task:

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

If W and Z are SCHED_FIFO tasks instead, O stays boosted to W's old
priority until it unlocks L2.

A second check next to it stops the walk at an owner that has no pi
waiters left. A waiter that leaves can cause this. remove_waiter() then
walks on from the owner, but that walk can be preempted and come late.

O, M and X are SCHED_OTHER tasks. W is a SCHED_DEADLINE task. Another
task, S, changes the policy of W:

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

The next patch keeps the donor's task_struct alive as long as a boost
points at it.

Remove both checks. The next check already stops the walk when the
owner's waiter is up to date. An out of date waiter is now requeued,
and the walk goes on to the next owner.

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

