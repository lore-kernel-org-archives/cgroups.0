Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037120;
	b=zZ1w9hsAQygAAkEXbERhp1/lQnCTaeuHpYR8urFV9dOhU07RiqJW7IwLyk94E4R95GFc
	 58fPQs+iztL/R9vRQNJynlrkkNdQEqXKPiKkRaEUfaq3Tf/UfpV9Dne0M3zHYRExtZFat
	 sWenV14htuFl2uQrqVxHoESMglIOoPC+PceTqOkbwgxnDqitkyAKIgXI4v3H6cf+suJJ8
	 4VCoSNC0uPnCUHmaTlVQ24gBFZjXMvI3i8XkmA+M1kgL3YAq3j8ghwg/r8HkHSlrvaFX6
	 e2UKHEm1OqWJXTFxQcLdb/sAjKd3O5mT7r3WjAPmI5jjABv0cUok1Hf0DlzGXgLeGDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=schCkJgVSGiRxCPk76qh6qIbje+oX3udn8Gxxhdusb0=;
	b=ykEkArhh4Oqs78ydUa/Pb/6pzgLoYccbbQVBaNGdlvbiVRBPuyByRiHgXUYmxCcsYAmL
	 0poZFhQJaOl3rLkFgWqTLQGdqUepES5NY5mBARnRxZHpMvFm8Jl0EJJtFU//zT206crdW
	 1TDjQrRgG2Y4GI0VZLVHj1r113a3wC1BYCH7/RJZRBo1id6hsoqWtcRHYfMQaS/cex6AD
	 j1ZbjDdKO/3bgiRVGmacI104PxKMEhbtEUHRp+MnCP6y4BoXxmFpksIfhvBs5MhWBBogG
	 WfqTsdk87kRVcX6nry1YCk47yKE8FUlJIrqZqQNf+pwUez51jD/4Wa8YSK6gw6aoUlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Z7ayIaWI;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E560A2630;
	Wed, 18 Nov 2026 21:25:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A2E560A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Z7ayIaWI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795037117;
	bh=schCkJgVSGiRxCPk76qh6qIbje+oX3udn8Gxxhdusb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7ayIaWIGQBlt2lodQZgW/t+PDbWKHCK67pU7bwpJRGOuq2xJPD7jHzvr3QWPfXxP
	 T48cQN9nIWrS0yJmKcoD3cPc4DWq8ihe/IArRVvShntsQH2jOHZCtt5xX/RN27E9O3
	 LZaOcx7ApYrdNhZ6bFeg9UeDgjd7Vwo8wVRzs0N2GpNIBMwSo71SGf7FcXJ8RMRYdX
	 B24JFqMs2jac5FX6I8UsVTqZ3Dx2NEB2jC2TqdjtcjLCXSx5RDJx8B0myAgm7XXzpF
	 9/uZtxm3xGUTvpmolxIj0F0ovVGC3aF/dXSkG4I1ELp5IqUwrFyCby8JWvqXzdxddm
	 +uml4MeK6I/OA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVF4X6VvczRLh;
	Wed, 18 Nov 2026 16:25:16 -0500 (EST)
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
Subject: [PATCH v2 08/16] sched/deadline: Do not replenish a boost from cleared parameters
Date: Wed, 18 Nov 2026 16:25:04 -0500
Message-Id: <ae7a53ee206a422a9debf0cbbeb241c8b233d160.1795037078.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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

When a SCHED_DEADLINE waiter boosts the owner of an rt_mutex, the owner
runs on the waiter's parameters, through dl.pi_se. Commit 2d3d891d3344
("sched/deadline: Add SCHED_DEADLINE inheritance logic") calls this a
temporary solution. The owner is never throttled. When its runtime runs
out, replenish_dl_entity() refills it at once from the waiter's
dl_runtime.

The waiter can leave SCHED_DEADLINE before the chain walk deboosts the
owner. Its parameters can be cleared in between, at its 0-lag time.
replenish_dl_entity() then loops forever on a dl_runtime of 0. It
holds the rq lock with interrupts off, so the owner's CPU locks up.

O is a SCHED_OTHER task that holds the rt_mutex L. W is a SCHED_DEADLINE
task. T is any other task:

  CPU 0 (O)                         CPU 1 (W)                     CPU 2 (T)

  locks L
                                    blocks on L
                                      rt_mutex_setprio(O, W)
                                        O->dl.pi_se = &W->dl
                                    sleeps
                                      task_non_contending()
                                        arms W's inactive timer
                                                                  sched_setscheduler(W)
                                                                    W leaves SCHED_DEADLINE
                                                                    task_rq_unlock(W)
                                    <W's inactive timer>
                                    inactive_task_timer()
                                      __dl_clear_params()
                                        W->dl.dl_runtime = 0
  <tick>
  update_curr_dl_se()
    enqueue_task_dl()
      replenish_dl_entity()
        runtime += W->dl.dl_runtime
        loops forever
                                                                    rt_mutex_adjust_pi(W)
                                                                      rt_mutex_setprio(O, W)
                                                                        spins on O's rq lock

Fix this by not refilling from cleared parameters. The donor's
parameters are cleared under the donor's rq lock, not the owner's, so
replenish_dl_entity() can see them change under it. Read dl_runtime,
dl_deadline and dl_period once, and bail out if any of them is 0.

On bailing out, the owner gets no new runtime, but stays runnable and
unthrottled. It runs until the chain walk deboosts it, or until it
releases the lock. Keeping it runnable also covers sysrq-n:
normalize_rt_tasks() changes the waiter without a chain walk, so a
throttled owner might never get to release the lock.

The bandwidth the owner consumed while boosted belongs to the donor, so
a negative runtime is reset to 0 rather than charged to the owner's own
reservation. An owner with no parameters of its own gets a deadline of
now. Its deadline must not stay 0: the dl_rq uses an earliest deadline
of 0 to mean that no deadline entity is queued (see inc_dl_deadline()).

Until the deboost (which should happen "soon enough"), such an owner
sorts first on its CPU's dl_rq and runs ahead of the other deadline
tasks there.

The warning is kept for an entity that is not boosted.

The reset bounds the overrun. But a runtime of 0 still counts as
exceeded. So until the deboost, update_curr_dl_se() still requeues the
owner at each update. An owner with SCHED_FLAG_DL_OVERRUN still gets
SIGXCPU.

With a 300ms debug delay before rt_mutex_adjust_pi(), v7.4-rc2 locks
up in 8-CPU VMs. A kernel with this patch does not.

The Sashiko AI review of this series found the lockup.

Fixes: a5e7be3b28a2 ("sched/deadline: Clear dl_entity params when setscheduling to different class")
Suggested-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/avL8oOtjKqVNR7-l@jlelli-thinkpadt14gen4.remote.csb/
---
 kernel/sched/deadline.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e4d7cbf4861d..71b1c155c242 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -807,8 +807,38 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
+	struct sched_dl_entity *pi_se = pi_of(dl_se);
+	u64 runtime = READ_ONCE(pi_se->dl_runtime);
+	u64 deadline = READ_ONCE(pi_se->dl_deadline);
+	u64 period = READ_ONCE(pi_se->dl_period);
 
-	WARN_ON_ONCE(pi_of(dl_se)->dl_runtime <= 0);
+	/*
+	 * A boosted entity runs on the parameters of its donor, the top
+	 * waiter of an rt_mutex. The donor can leave the class and have them
+	 * cleared before the chain walk deboosts this entity. They are
+	 * cleared under the donor's rq lock, which can be another one. So
+	 * read each of them once, and check all three. Refilling from a
+	 * runtime of 0 would loop forever. Leave the entity runnable
+	 * instead: the walk deboosts it, or its task releases the lock.
+	 *
+	 * Add no runtime. Do not keep a negative one: the overrun comes
+	 * from the boost, and the entity's own reservation does not pay for
+	 * it. A task with no parameters of its own gets a deadline of now,
+	 * as a donor's relative deadline of 0 would give. A deadline of 0
+	 * means an empty dl_rq to inc_dl_deadline().
+	 */
+	if (unlikely(!runtime || !deadline || !period)) {
+		WARN_ON_ONCE(!is_dl_boosted(dl_se));
+		if (!dl_se->dl_deadline) {
+			dl_se->deadline = rq_clock(rq);
+			dl_se->runtime = 0;
+		}
+		if (dl_se->runtime < 0 || dl_se->dl_yielded)
+			dl_se->runtime = 0;
+		dl_se->dl_yielded = 0;
+		dl_se->dl_throttled = 0;
+		return;
+	}
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
@@ -822,8 +852,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
-		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
-		dl_se->runtime = pi_of(dl_se)->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + deadline;
+		dl_se->runtime = runtime;
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -836,8 +866,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_of(dl_se)->dl_period;
-		dl_se->runtime += pi_of(dl_se)->dl_runtime;
+		dl_se->deadline += period;
+		dl_se->runtime += runtime;
 	}
 
 	/*
-- 
2.47.3

