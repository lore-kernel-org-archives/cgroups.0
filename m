Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855973;
	b=ITu0K7EE3EF8IAc9nuQNNjA5tM8qSQQLLyRWQC40U6XiHJGL6BkkG0rOAbSztUFU3onE
	 PTsyEV7AirXSPu2gUBBXWdA9nfxEjlpK6KPX+q1geLtpq2WvWAApxsVlc4r5Um5fGFeHl
	 t2vi8TOfJg1bD4EdUSAvUf+zO5GKAbcQOYnXRsdGceNgbl3+N54zIWQmcZk9DJh7kI+p8
	 vfh7/nC9n99TvrBRTSUrZjML2zSY7Z8FTafr8fh5hwznisPETim3Vs2yJsm/EvWkIJkHv
	 mzXXvYJoXEq9N+tndmcQqx6jcb448bmJwXiwjVhutIokz3zuzISJN88S3hasDAzuqZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855973;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qQiz0ffu5j3T93VAJ6PXQQU0rOQU5j62feJXAPgzObs=;
	b=Y4/Xm5nec9O0z7mW6NUqfA4eKnajpFXvdAMbTndU/cDILOSnUVOWrzjP3cnIkFR056fE
	 orDF/BIBLVJK7tfoDjFa0XQ2ffEM3ihu4Cg2v0d8lWIxgjHmJK4oBn6Hx2OiVAVLk/2T8
	 afsVaTqiAEnVOsPsmVA+rQ4AEn8J++DqtrZC3UKXrlsPHD+BuoK6pdSnOz8nTTmR0PNku
	 Cnt8e2cDh6wrXiNG7Bahz8nn8hPgNHN7329lALGBBCMk2wbpGPpcWl3fiSwmSgskuz8G1
	 iaI1RfFdOUMRZTJrOKQJp0h3CKYtJFWHkR6dAoYyQtOutt+j2dQgUfEum2SbfN/JLOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=erg7oCKX;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C929606F14B;
	Mon, 16 Nov 2026 19:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C929606F14B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=erg7oCKX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855958;
	bh=qQiz0ffu5j3T93VAJ6PXQQU0rOQU5j62feJXAPgzObs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erg7oCKXIx3osYycRoHz5rR7nGhPiMiqUf9KqUPOlQDjcarcPdMCN8JOxj1OAiiP+
	 BE0gb29qtP9pxVsHHYWf5ifoDnm0ke1Yu1NvgWoo9P8DmYUcHJchB1ESAdgXLIc3xk
	 J6TwX3td5CWY4cI0ZTEXwtHtQWNR7LY4sxARDDeV8/u7LohZuxmOb0hcsYuGgEDz2I
	 IOFBLIgTtOqwrW1kYcoOeGyoFTvbyKg74qP9VrvVThvgm2y9So8ON1oHEPbNz5pDSs
	 Y5UdCwVYgFNf/APejyuFUZ3vCblUXFHxOu8d6UTdiwTOarULtKJnripCxp1tPYtEwc
	 uqlyVlUt1KdQw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4k2GH2zQSw;
	Mon, 16 Nov 2026 14:05:58 -0500 (EST)
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
Subject: [PATCH v6 25/37] sched/deadline: Move a task's bandwidth to the root domain it runs in
Date: Mon, 16 Nov 2026 14:05:37 -0500
Message-Id: <20261116190549.230119-26-mathieu.desnoyers@efficios.com>
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

When a CPU goes offline, select_fallback_rq() picks a new CPU for a
deadline task asleep on it. balance_push() moves a queued task the same
way. The new CPU can be in another root domain. With isolcpus="domain",
the isolated CPUs are in the default root domain. A cpuset that is not
a partition can hold CPUs of both root domains.

Commit 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all
levels after offline migration") fixed this for a throttled task.
dl_task_offline_migration() moves its bandwidth with it. A task that
select_fallback_rq() places still moves no bandwidth. So it runs in a
root domain that does not count its bandwidth, until the next rebuild.
That root domain can admit deadline tasks beyond its capacity.

Fix this in migrate_task_rq_dl(). The CPU recorded with the bandwidth
gives the root domain that counts it. If the new CPU is in another root
domain, move the bandwidth there. Record the new CPU. As
dl_task_offline_migration() does, add the bandwidth even without room,
since the task runs there. Add it also if a rebuild left the task out.

Compare the root domains, not the CPU the task leaves. That CPU can
still be in the mask when select_fallback_rq() picks a CPU of the other
root domain. A task can also wake up on its CPU with no migration while
another root domain counts its bandwidth. A cpuset move or a rebuild can
move the bandwidth while the task sleeps. A change of the mask can then
give that CPU back. So task_woken_dl() makes the same check.

Both checks read the record without dl_departed_lock, so a move inside
a root domain takes no lock. dl_task_move_bw() checks again under
dl_departed_lock. Its caller holds the pi_lock or the rq lock of the
task. Together, the two locks keep the record stable.

These cases of deadline_bw_test, added later in this series, fail
without this patch:
 - hotplug_fallback, hotplug_fallback_moved and
   hotplug_fallback_in_mask: a task woken on an isolated CPU stays
   counted in the housekeeping root domain.
 - no_admission_affinity_moves: without admission control, a task
   given an affinity of one isolated CPU stays counted in the
   housekeeping root domain.

This follows the Sashiko AI reviews of v4 and v5.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 92 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 81 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c765a403014a..35f40185953a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2910,11 +2910,69 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 	return cpu;
 }
 
-static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused)
+/*
+ * Return true if the root domain of @cpu may not count the bandwidth of
+ * @p. Either another root domain counts it, or a rebuild left @p out.
+ * Test without dl_departed_lock, so that a move inside a root domain
+ * takes no lock. dl_task_move_bw() tests again under it.
+ */
+static bool dl_task_bw_elsewhere(struct task_struct *p, int cpu)
+{
+	int bw_cpu = READ_ONCE(p->dl.dl_bw_cpu);
+
+	if (bw_cpu < 0 || !p->dl.dl_bw)
+		return false;
+	return READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen) ||
+	       cpu_rq(bw_cpu)->rd != cpu_rq(cpu)->rd;
+}
+
+/*
+ * Move the bandwidth of @p to the root domain of @new_cpu. Count it there
+ * also if a rebuild left @p out. Add it even without room, since @p runs
+ * there. The caller holds the rq lock of @p, or its pi_lock for a wakeup.
+ */
+static void dl_task_move_bw(struct task_struct *p, int new_cpu)
+{
+	struct dl_bw *dl_b;
+	int cpu;
+
+	if (dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
+		return;
+
+	guard(raw_spinlock)(&dl_departed_lock);
+	cpu = p->dl.dl_bw_cpu;
+	if (cpu < 0)
+		return;
+	if (p->dl.dl_bw_gen == dl_bw_gen) {
+		if (cpu_rq(cpu)->rd == cpu_rq(new_cpu)->rd)
+			return;
+		dl_b = dl_bw_of(cpu);
+		raw_spin_lock(&dl_b->lock);
+		__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
+		raw_spin_unlock(&dl_b->lock);
+	}
+	dl_b = dl_bw_of(new_cpu);
+	raw_spin_lock(&dl_b->lock);
+	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(new_cpu));
+	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = new_cpu;
+	p->dl.dl_bw_gen = dl_bw_gen;
+}
+
+static void migrate_task_rq_dl(struct task_struct *p, int new_cpu)
 {
 	struct rq_flags rf;
 	struct rq *rq;
 
+	/*
+	 * The new CPU can be in another root domain than the one that counts
+	 * the bandwidth. A mask can hold CPUs of two root domains, and
+	 * select_fallback_rq() can widen it. Move the bandwidth there, as
+	 * dl_task_offline_migration() does for a throttled task.
+	 */
+	if (unlikely(dl_task_bw_elsewhere(p, new_cpu)))
+		dl_task_move_bw(p, new_cpu);
+
 	if (READ_ONCE(p->__state) != TASK_WAKING)
 		return;
 
@@ -3577,6 +3635,15 @@ static void pull_dl_task(struct rq *this_rq)
  */
 static void task_woken_dl(struct rq *rq, struct task_struct *p)
 {
+	/*
+	 * A task can wake up on the CPU it slept on, with no migration,
+	 * while another root domain counts its bandwidth. The bandwidth
+	 * moved while the task slept out of its mask, and the mask then got
+	 * that CPU back. Move the bandwidth to this root domain.
+	 */
+	if (unlikely(dl_task_bw_elsewhere(p, cpu_of(rq))))
+		dl_task_move_bw(p, cpu_of(rq));
+
 	if (!task_on_cpu(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    p->nr_cpus_allowed > 1 &&
@@ -3612,9 +3679,10 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * (different root_domains) entails a bandwidth update. Move the
 	 * bandwidth only if the caller made room for it in the destination,
 	 * as SCA_DL_BW_RESERVED says. Only cpuset_attach_task() sets it.
-	 * Otherwise, the bandwidth stays where it is counted, until the next
-	 * rebuild of the accounting. Moving it without room would leave no
-	 * root domain counting it.
+	 * Otherwise, the bandwidth stays where it is counted, until the task
+	 * runs in another root domain (migrate_task_rq_dl(), task_woken_dl()),
+	 * or the next rebuild of the accounting. Freeing it here without room
+	 * would leave no root domain counting it.
 	 *
 	 * cpuset_can_attach() made room for @p in the root domain of
 	 * ctx->dl_bw_cpu, and recorded that CPU with @p. Move the bandwidth
@@ -3806,10 +3874,11 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
  * count the bandwidth of @p, or nr_cpu_ids if there is none.
  *
  * Prefer the CPU @p is on, if it is active and in the mask of @p. The
- * task runs, or wakes up, in the root domain of that CPU. A mask can hold
- * CPUs of two root domains: housekeeping CPUs and CPUs isolated by
- * isolcpus="domain". When every CPU of a mask goes offline,
- * select_fallback_rq() can widen it to both. It moves no bandwidth.
+ * task runs, or most often wakes up, in the root domain of that CPU. A
+ * mask can hold CPUs of two root domains: housekeeping CPUs and CPUs
+ * isolated by isolcpus="domain". When every CPU of a mask goes offline,
+ * select_fallback_rq() can widen it to both. A task that then runs in
+ * the other root domain takes its bandwidth along.
  *
  * Else prefer the CPU recorded with the bandwidth, if it is active and in
  * the mask. It is in the root domain that admitted the bandwidth, or that
@@ -3876,8 +3945,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 		/*
 		 * No active CPU can count the bandwidth of this task. Leave it
 		 * out of this rebuild. dl_bw_gen then keeps its release from
-		 * removing anything. A later rebuild, or
-		 * dl_task_offline_migration(), counts it again.
+		 * removing anything. A later rebuild counts it again. So does
+		 * the move of the task to an active CPU.
 		 */
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
@@ -4071,7 +4140,8 @@ void dl_clear_root_domains(void)
 	int cpu;
 
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
-	dl_bw_gen++;
+	/* dl_task_bw_elsewhere() reads it without the lock. */
+	WRITE_ONCE(dl_bw_gen, dl_bw_gen + 1);
 	for_each_possible_cpu(cpu) {
 		if (!dl_bw_visited(cpu, cookie))
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
-- 
2.47.3

