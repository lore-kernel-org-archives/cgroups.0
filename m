Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119388;
	b=y/65CL5nLmvCn4QSA9Rs9UrZwdMpEKWhx5wO9eyMli/TyQSLvfGcP/sd0wsp3jMApcKM
	 t958nBqSvHuUOePAmED8NabfPcO12kHYf9JdYja7cKQuoHbhiMVu9EBW4feyNZORESDah
	 N1dNs6mL+xZHi9UHMHWpEMfI3eDubDPOS4GcLmMDKNzl159I8nwa8tDejLaibaKKWs/E1
	 j3EaIagMIUI0QC5IEASTYjXE2KznjdMezLagsq3NQ84ox064WcJjZO0Jf9dI7GuD3Q0Qp
	 M1ZQXWSyzfSlAHVgh8rcwri3oQy9NzUNi0lfCw5n5wo1HXhB3eBvzksaDmYVa+xIpsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119388;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eKtPF0D4KeipGVGK8LJzEwVR7p9f+gTu2lblD4xfFnk=;
	b=1Ll8ydZRw28EK/pKG+htwaY7aILoIX0U8NtwpjbyQGMHzxZ+peQxwosw9I4UvQlHQqmM
	 NUSJeBiPvaTq3tApOXxwjddp4GEtW0PN7bUboopQ+1eVDsHa+VE8j6Xg6khMIpkv+CajY
	 sowEk15tecYiR9mX5z2BiqFwP4iatAHlswLlslDcJQp9rH7AJ3XzKcHersJqiuVnU0K2h
	 wKLGxEI+CGmN4ZxY1XBq6J/RUMJSG/hhuzS88yP7CrmYIiZ1BzmHDkpvR9XFC8Ed8J1xO
	 kt9OebkxGlOEhJjPCSMCOA952pfjGk9Lt9f9KIoqo/bb8/v141Ue3NhrcHquY5kTsmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=noZ1z9jn;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF360A5BCD;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BDF360A5BCD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=noZ1z9jn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119381;
	bh=eKtPF0D4KeipGVGK8LJzEwVR7p9f+gTu2lblD4xfFnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noZ1z9jnSM1wqYu9UHDg7dh9yhq/XLNPUSH3sfmWHx5ywJHof4h7Vdm8XgC1kn6Sp
	 TfN8wteJ6T3Gg+8IBPQExFYmMesN0Cmb6ytuP2F2Us6sjEO7bIqfQlHidOXFSiQWED
	 T1W3ClBGVQ9Lq0RemZBE5wOh+fJ7lE831EqJqyYHjTWPsuN3SGO99fdTFygQVkXKsc
	 I5yaVAIsxtCq2+g03An9tSwC9D4426MSFu3rWuP4OxFcx/X+IjcqmHKLHB8MxzH77g
	 WAcHGdHjoAfF3Q5yoUbvJj5y0pr4AmnwSWDdEM7ha5NSUveux5Ok47QMFQ6fziHeg4
	 5tbgIJA04WKaA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVY2dtvzT9g;
	Thu, 19 Nov 2026 15:16:21 -0500 (EST)
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
Subject: [PATCH v8 21/33] rtmutex: Continue the walk when the owner's top waiter changes lock
Date: Thu, 19 Nov 2026 15:16:00 -0500
Message-Id: <705d9352cc611ed8b744e80a75067f112ff1ef3d.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

The chain walk stops at an owner whose top pi waiter is not the top
waiter of the lock just walked. That lock then does not set the
owner's priority, so there is nothing to pass on.

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

O's next refill reads W's freed task_struct. With RT priorities
only, O stays boosted to W's old priority until it unlocks L2.

Remove this test. The next test already stops the walk when the
owner's waiter is up to date. An out of date waiter is now requeued,
and the walk goes on to the next owner.

The cases pi_chain_top_moves and pi_chain_top_moves_rt, added to
deadline_bw_test later in this series, test this. pi_chain_top_moves_rt
fails without this patch and passes with it. pi_chain_top_moves also
needs the previous patch.

The Sashiko AI review of this series found this.

Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/locking/rtmutex.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index c78dfe9c93fc..c06261259a56 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -821,23 +821,15 @@ static int __sched rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * Drop out, when the task has no waiters. Note,
 	 * top_waiter can be NULL, when we are in the deboosting
 	 * mode!
+	 *
+	 * Do not compare top_waiter with the top pi waiter of the
+	 * task here. The previous step can have made a waiter on
+	 * another lock the top pi waiter of the task. The priority of
+	 * the task changed then, and the next owner must follow. The
+	 * test below tells whether there is something to pass on.
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
+	if (top_waiter && !task_has_pi_waiters(task))
+		goto out_unlock_pi;
 
 	/*
 	 * If the waiter priority is the same as the task priority
-- 
2.47.3

