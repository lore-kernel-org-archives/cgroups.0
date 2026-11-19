Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119390;
	b=ebPVXkODkaJRIBOOqelh45bHbJFrQVDU3ado0ucobGPfOjnmVPjahZel3Ju2YwobWaBQ
	 HfK+z2xZg3KEZKW2HLTFGD/gry0/zOUO0SIxvdpYUxbO6PeIqfaC3TLJnc7cl22cvJ+iP
	 m1xiGcU6WmwXgsjHP/fwoGg5Q92Od3oBVNV1Zqm7OIwaXWFkQFF4O7w4KNjTr4YuHUS48
	 12WS/HnpvAJKpHkdLlHHN2vBP2iwlghSgsDP49agJ5cryZKoxMUy8KS5iH+gWYKXuyTLr
	 YlVHAdwSQAV8eV7zta1S+CLUeL/wqdB8gf7Kqebeo87SMk4lH4619jVyFR7uC9SdevA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119390;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vMDJACvSgjggax6sneYhMVTocdyWj3n9llw94CkfTik=;
	b=i9bpua/LRQs1HO87haD/SdmXP1/U1wMHYYJgl2NqNY3Jkqkrz5WlpQXwYj0hvZxsI0kp
	 i4rF/aE9cK+XcLL7XM5sbAoaFj3h2y2J0KHmBUK5YDeiUgHI4vrsa87hw4ty7SiIHzJP9
	 s//Gbm3khrTSouu9NvMgaC+xokUafgqiautpOR/igIDANTF7sxuKYXkQBMvmB1QYTWPhe
	 yq0tvqoVhm4qMp24ceQ2VZruLeo0cGZTvbjObxHxXjtsCYpgeFVCyQJCC4cjIkOnZ13i+
	 tMlpp3AQ5WN5Ioq7/L4i7DRri2Wuble39KqHcpGpfnXrxuUj3uVA9GgQJdyFLqCPB6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vJG6B9iK;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DAF60A3821;
	Thu, 19 Nov 2026 20:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9DAF60A3821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vJG6B9iK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119380;
	bh=vMDJACvSgjggax6sneYhMVTocdyWj3n9llw94CkfTik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJG6B9iKB1AAzVG/Tfm3kN5W3beM9zX1VA6RnL6Ty/tTVSW6J5mtAszivmk9KKXgT
	 PcfSzQ4hRpiScUJuxuMUWRSQbwuil4wicMkZBHqwKTPMHmobpg6JWS2wVBdrJjpPZ2
	 sHL0r6Hca3/iL/Sw5rMvp0Ng7AwJtlncmClXCuwPYZRdkRFcLkuB/XpJProLFflRie
	 y33jdE/AWeqxDyHQO36Bbyfz6EDr9HTwfXP97is2tUR1refWySsOYFIm93SnVtz09N
	 G+5lWQycrs5zb1JrGTnJH1krSTXCtFYuiI7pVysMloTAsOerzybzM1WW7K2i1ELDR4
	 IXa+KnQVS2Ltg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVX25B9zSjZ;
	Thu, 19 Nov 2026 15:16:20 -0500 (EST)
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
Subject: [PATCH v8 15/33] sched/deadline: Keep a task in the root domain that counts its bandwidth
Date: Thu, 19 Nov 2026 15:15:54 -0500
Message-Id: <35ed0190c119025d684ab89cd51e4805c7f7dbad.1795116791.git.mathieu.desnoyers@efficios.com>
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

The root domain that admits a deadline task counts its bandwidth. The
mask of the task can hold CPUs of another root domain. With
isolcpus="domain", the isolated CPUs are in the default root domain. A
cpuset that is not a partition root can hold isolated and housekeeping
CPUs.

The code that picks a CPU for a task does not look at the root domain
that counts it:

 - select_fallback_rq() and dl_task_offline_migration() pick a CPU when
   the CPU of the task goes offline.
 - __set_cpus_allowed_ptr_locked() picks one when the mask changes.
 - select_task_rq_dl() can leave a task on the CPU it slept on, which
   can be in the other root domain.
 - dl_task_rebuild_cpu() picks the CPU that a rebuild counts a task
   with. It prefers the CPU the task is on, then a housekeeping CPU.

Each can take the task, or its bandwidth, to the other root domain
while its own root domain still has a CPU for it. The bandwidth then
moves with no admission test, and the root domain it arrives in can
exceed its limit.

Add dl_task_bw_span(), which returns the CPUs of the root domain that
counts a task. Make each of these places try one of those CPUs first.
After a rebuild the root domains are new, and the CPU recorded with the
bandwidth can be offline. So dl_task_rebuild_cpu() cannot use the root
domain. It looks at the kind of the CPU recorded, housekeeping or
isolated. It prefers a CPU of the mask of the same kind.

The CPU recorded can be the one going offline. Its root domain still
counts the task until the rebuild attaches that CPU to the default root
domain. So dl_task_bw_span() still returns that root domain until then.
This covers the common case: a task that runs on the CPU when it goes
offline, which balance_push() moves.

select_fallback_rq() can also widen the mask of the task. It first gives
the task the CPUs of its cpuset, then the housekeeping CPUs. At an
offline, this happens before the cpuset update. The wider mask can then
hold no active CPU of the root domain that counts the task. The task
then leaves that root domain, and its bandwidth moves with no admission
test. It stays out after the cpuset update. In testing without the rule
below, a deadline task with a period of 2ms spun on the CPU going
offline. It left this way in every run. So when the wider mask has no
active CPU of that root domain, allow the CPUs of the root domain
instead. The cpuset update that comes next sets the real mask.

dl_task_bw_span() returns NULL while the sched domains are rebuilt. The
CPUs then change root domains one by one. A housekeeping CPU passes
through the default root domain, which holds the isolated CPUs. Its
span would send a housekeeping task to an isolated CPU. So inside a
rebuild, the CPU is picked as it was before this patch. If that CPU is
in the other root domain, the next wakeup brings the task back.
dl_task_offline_migration() moves no bandwidth then either, nor
before the walk that follows counts the task. The walk counts it on
the side of the CPU recorded.

A known limit remains. A wakeup can pick its CPU inside a rebuild,
before the walk of the task list that follows reaches the task. If it
is queued after the walk counted the task, its bandwidth can still
move to the other root domain, with no admission test. This was found
by reading, not reproduced.

A task with no CPU left in its root domain still moves, and its
bandwidth with it. The next two patches refuse the changes that lead
to that.

The case hotplug_keeps_root_domain, added to deadline_bw_test later in
this series, tests this. A cpuset holds two isolated CPUs and two
housekeeping CPUs, H and K. A deadline task counted in the housekeeping
root domain sleeps on H. Then H goes offline. The task must wake up on
K. Without this patch it woke up on an isolated CPU: CPU 0, in a guest
with isolcpus=domain,0,1.

These cases test the other paths:
 - hotplug_spinner_keeps: a running task whose CPU goes offline;
 - hotplug_fallback_running: the same, when the cpuset of the task has
   no CPU left;
 - hotplug_waking_keeps: a task that wakes up often, at the offline;
 - hotplug_isolated_keeps: the same, for a task counted on the isolated
   side;
 - rebuild_waking_keeps: a wakeup inside a rebuild. It fails in most
   runs if dl_task_bw_span() does not return NULL there. That needs
   isolcpus=domain,0,1.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c     |  55 +++++++++++++
 kernel/sched/deadline.c | 173 +++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h    |   1 +
 3 files changed, 201 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7615ba02d52b..fe2919be3775 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3264,6 +3264,27 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 			dest_cpu = ctx->dl_bw_cpu;
 		if (!task_on_rq_queued(p))
 			p->wake_cpu = dest_cpu;
+	} else {
+		const struct cpumask *span = dl_task_bw_span(p);
+		unsigned int cpu = nr_cpu_ids;
+
+		/*
+		 * No room was made for @p in another root domain. Keep @p
+		 * in the root domain that counts its bandwidth, if the new
+		 * mask holds one of its CPUs. Also wake a sleeping @p up
+		 * there. A wakeup during a rebuild of the sched domains has
+		 * no span to prefer.
+		 */
+		if (span && cpumask_test_cpu(dest_cpu, span))
+			cpu = dest_cpu;
+		else if (span)
+			cpu = cpumask_first_and_and(cpu_valid_mask,
+						    ctx->new_mask, span);
+		if (cpu < nr_cpu_ids) {
+			dest_cpu = cpu;
+			if (!task_on_rq_queued(p))
+				p->wake_cpu = dest_cpu;
+		}
 	}
 
 	do_set_cpus_allowed(p, ctx);
@@ -3668,8 +3689,22 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int nid = cpu_to_node(cpu);
 	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
+	const struct cpumask *span;
+	bool span_forced = false;
 	int dest_cpu;
 
+	/*
+	 * Keep a deadline task in the root domain that counts its
+	 * bandwidth, if one of its CPUs is allowed and online.
+	 */
+	span = dl_task_bw_span(p);
+	if (span) {
+		for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+			if (is_cpu_allowed(p, dest_cpu))
+				return dest_cpu;
+		}
+	}
+
 	/*
 	 * If the node that the CPU is on has been offlined, cpu_to_node()
 	 * will return -1. There is no CPU on the node, and we should
@@ -3686,6 +3721,26 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	}
 
 	for (;;) {
+		/* The mask is wider now: look again in that root domain. */
+		if (span && state != cpuset) {
+			for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+				if (is_cpu_allowed(p, dest_cpu))
+					goto out;
+			}
+			/*
+			 * The wider mask has no active CPU in that root
+			 * domain. Allow the CPUs of the root domain instead.
+			 * At an offline, the cpuset update comes next and sets
+			 * the real mask.
+			 */
+			if (!span_forced && cpumask_intersects(span, cpu_active_mask) &&
+			    cpumask_subset(span, task_cpu_possible_mask(p))) {
+				span_forced = true;
+				set_cpus_allowed_force(p, span);
+				continue;
+			}
+		}
+
 		/* Any allowed, online CPU? */
 		for_each_cpu(dest_cpu, p->cpus_ptr) {
 			if (!is_cpu_allowed(p, dest_cpu))
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fb8f32a31cf9..c33e73e920eb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -277,8 +277,8 @@ static unsigned int dl_bw_gen;
  * where its bandwidth is counted. The new root domains count no task
  * yet.
  *
- * Changed under dl_departed_lock. dl_task_bw_elsewhere() reads it
- * without the lock.
+ * Changed under dl_departed_lock. dl_task_bw_span() and
+ * dl_task_bw_elsewhere() read it without the lock.
  */
 static unsigned int dl_bw_rebuild_seq;
 
@@ -323,6 +323,8 @@ void dl_bw_rebuild_begin(void)
 	lockdep_assert_held(&sched_domains_mutex);
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
 	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+	/* Before the first write of rq->rd: see dl_task_bw_span(). */
+	smp_wmb();
 }
 
 /* End the walk of the task list that dl_clear_root_domains() started. */
@@ -927,18 +929,36 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 
 static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p)
 {
+	const struct cpumask *span;
 	struct rq *later_rq = NULL;
 	struct dl_bw *dl_b;
 
 	later_rq = find_lock_later_rq(p, rq);
+	/*
+	 * find_lock_later_rq() looks in the root domain of @rq. Once @rq is
+	 * offline, a rebuild attaches it to def_root_domain. That root domain
+	 * may not count @p. Do not take @p out of the root domain that counts
+	 * it while @p has an active CPU there.
+	 */
+	span = dl_task_bw_span(p);
+	if (later_rq && span && !cpumask_test_cpu(later_rq->cpu, span) &&
+	    cpumask_first_and_and(cpu_active_mask, p->cpus_ptr, span) < nr_cpu_ids) {
+		double_unlock_balance(rq, later_rq);
+		later_rq = NULL;
+	}
 	if (!later_rq) {
 		int cpu;
 
 		/*
 		 * If we cannot preempt any rq, fall back to pick any
-		 * online CPU:
+		 * online CPU. Try the root domain that counts @p first.
 		 */
-		cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
+		cpu = nr_cpu_ids;
+		if (span)
+			cpu = cpumask_first_and_and(cpu_active_mask,
+						    p->cpus_ptr, span);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
 		if (cpu >= nr_cpu_ids) {
 			/*
 			 * Failed to find any suitable CPU.
@@ -981,8 +1001,15 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	 * moved to another cpuset while it was not running. If a rebuild
 	 * dropped the bandwidth, there is nothing to move: the next rebuild
 	 * counts it.
+	 *
+	 * Move nothing while the sched domains are rebuilt, or before the
+	 * walk that follows has counted @p, as dl_task_move_bw() does. The
+	 * CPU picked above then had no span to prefer. The walk counts @p
+	 * on the side of the CPU recorded.
 	 */
 	scoped_guard (raw_spinlock, &dl_departed_lock) {
+		if (dl_bw_move_blocked(p))
+			break;
 		if (p->dl.dl_bw_gen == dl_bw_gen) {
 			struct rq *src_rq = cpu_rq(dl_task_root_domain_cpu(p));
 
@@ -2940,6 +2967,7 @@ static int
 select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 {
 	struct task_struct *curr, *donor;
+	const struct cpumask *span;
 	bool select_rq;
 	struct rq *rq;
 
@@ -2980,6 +3008,20 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 		    dl_task_is_earliest_deadline(p, cpu_rq(target)))
 			cpu = target;
 	}
+
+	/*
+	 * Keep @p in the root domain that counts its bandwidth. Its mask
+	 * can hold CPUs of another root domain, with isolcpus="domain",
+	 * and @p can sleep on one of them.
+	 */
+	span = dl_task_bw_span(p);
+	if (span && !cpumask_test_cpu(cpu, span)) {
+		unsigned int in_span;
+
+		in_span = cpumask_first_and_and(span, p->cpus_ptr, cpu_active_mask);
+		if (in_span < nr_cpu_ids)
+			cpu = in_span;
+	}
 	rcu_read_unlock();
 
 	return cpu;
@@ -3757,6 +3799,61 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
 	return cpu;
 }
 
+/*
+ * Return the CPUs of the root domain that counts the bandwidth of @p, or
+ * NULL if none does. The mask of @p can hold CPUs of another root domain,
+ * with isolcpus="domain". Where a CPU is picked for @p, a CPU of this
+ * root domain comes first: no other root domain admitted @p.
+ *
+ * Return NULL while the sched domains are rebuilt. The CPU recorded can
+ * then sit in def_root_domain on its way to a new root domain. The span
+ * of def_root_domain holds the isolated CPUs, and no longer the
+ * housekeeping CPUs that already left it. A caller would send a
+ * housekeeping task to an isolated CPU.
+ *
+ * Return NULL also for a task that the walk of the task list after the
+ * rebuild has not reached yet. Its dl_bw_gen is not current.
+ *
+ * The caller holds the pi_lock or the rq lock of @p. With interrupts
+ * off, the root domain is not freed.
+ */
+const struct cpumask *dl_task_bw_span(struct task_struct *p)
+{
+	unsigned int seq = READ_ONCE(dl_bw_rebuild_seq);
+	struct root_domain *rd;
+	int cpu;
+
+	if (!task_has_dl_policy(p) || dl_entity_is_special(&p->dl) ||
+	    !p->dl.dl_bw || (seq & 1))
+		return NULL;
+	cpu = READ_ONCE(p->dl.dl_bw_cpu);
+	if (cpu < 0 || READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen))
+		return NULL;
+	/*
+	 * The CPU recorded can be going offline. It keeps its root domain
+	 * until the rebuild attaches it to def_root_domain. The rebuild then
+	 * records an active CPU with @p, or leaves @p out. Until then, the
+	 * root domain of the CPU recorded still counts @p.
+	 *
+	 * A CPU that isolcpus="domain" isolates is always in
+	 * def_root_domain, which then counts @p. A housekeeping CPU that is
+	 * not active and in def_root_domain was attached there by the
+	 * rebuild. def_root_domain does not count @p then.
+	 */
+	rd = cpu_rq(cpu)->rd;
+	/*
+	 * A rebuild that started since writes rq->rd after it made
+	 * dl_bw_rebuild_seq odd. Use this root domain only if none did.
+	 */
+	smp_rmb();
+	if (READ_ONCE(dl_bw_rebuild_seq) != seq)
+		return NULL;
+	if (!cpu_active(cpu) && rd == &def_root_domain &&
+	    housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN_BOOT))
+		return NULL;
+	return rd->span;
+}
+
 static void set_cpus_allowed_dl(struct task_struct *p,
 				struct affinity_context *ctx)
 {
@@ -3972,24 +4069,24 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
  * Return a CPU of the root domain where a rebuild of the accounting should
  * count the bandwidth of @p, or nr_cpu_ids if there is none.
  *
- * Prefer the CPU @p is on, if it is active and in the mask of @p. The
- * task runs, or most often wakes up, in the root domain of that CPU. A
- * mask can hold CPUs of two root domains: housekeeping CPUs and CPUs
- * isolated by isolcpus="domain". When every CPU of a mask goes offline,
- * select_fallback_rq() can widen it to both. A task that then runs in
- * the other root domain takes its bandwidth along.
- * Prefer that CPU also if @p is queued there, out of its mask, and the
- * CPU is the one recorded. Without admission control,
- * dl_task_offline_migration() can put a throttled task and its bandwidth
- * on any active CPU. The task runs there until it blocks.
+ * A mask can hold CPUs of two root domains: housekeeping CPUs and CPUs
+ * isolated by isolcpus="domain". Keep the bandwidth on the side of the
+ * CPU recorded with it. That CPU is in the root domain that admitted the
+ * bandwidth, or that its last move put it in. Take the CPU @p is on if it
+ * is active, in the mask of @p and on that side. Else take the CPU
+ * recorded, if it is active and in the mask. Else take a CPU of the mask
+ * on that side.
  *
- * Else prefer the CPU recorded with the bandwidth, if it is active and in
- * the mask. It is in the root domain that admitted the bandwidth, or that
- * its last move put it in. A task moved asleep is still on a CPU of the
- * root domain it left, out of its mask. Else take the first active CPU of
- * the mask, a housekeeping one if there is one. If no CPU of the mask is
- * active, use the CPUs of the cpuset instead of the mask. A task on
- * isolated CPUs that all went offline can have no active CPU at all.
+ * With no CPU on that side, or no CPU recorded, prefer the CPU @p is on.
+ * Else take the first active CPU of the mask, a housekeeping one if there
+ * is one. A task on isolated CPUs that all went offline can have no
+ * active CPU at all.
+ *
+ * One case comes before all of these. Take the CPU @p is on if @p is
+ * queued there, out of its mask, and the CPU is the one recorded. Without
+ * admission control, dl_task_offline_migration() can put a throttled task
+ * and its bandwidth on any active CPU. The task runs there until it
+ * blocks.
  */
 static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 {
@@ -4004,21 +4101,41 @@ static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 	/*
 	 * Look at the mask of the task first. A change of the cpusets sets
 	 * the mask of each task before its rebuild. If no CPU of the mask
-	 * is active, ask the cpuset. The task wakes up on one of its CPUs.
-	 * Take the CPU recorded only if it is one of them: a partition root
-	 * can have taken it since it was recorded.
+	 * is active, ask the cpuset. The CPU recorded is taken below only if
+	 * the cpuset holds it: a partition root can have taken it since it
+	 * was recorded.
 	 */
 	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
 	cpu = task_cpu(p);
-	if (cpumask_test_cpu(cpu, msk) ||
-	    (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p)))
+	if (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p))
 		return cpu;
 	if (cpumask_empty(msk)) {
 		dl_get_task_effective_cpus(p, msk);
 		cpumask_and(msk, msk, cpu_active_mask);
 	}
-	if (recorded >= 0 && cpumask_test_cpu(recorded, msk))
-		return recorded;
+	/*
+	 * Keep the bandwidth where it was counted: with the housekeeping
+	 * CPUs, or with the CPUs that isolcpus="domain" isolates. The root
+	 * domains are new, and the CPU recorded can be offline. So prefer a
+	 * CPU of the mask of the same kind as the CPU recorded: housekeeping
+	 * or not.
+	 */
+	if (recorded >= 0) {
+		const struct cpumask *hk = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+		bool rec_hk = cpumask_test_cpu(recorded, hk);
+		unsigned int same;
+
+		if (cpumask_test_cpu(cpu, msk) && cpumask_test_cpu(cpu, hk) == rec_hk)
+			return cpu;
+		if (cpumask_test_cpu(recorded, msk))
+			return recorded;
+		for_each_cpu(same, msk) {
+			if (cpumask_test_cpu(same, hk) == rec_hk)
+				return same;
+		}
+	}
+	if (cpumask_test_cpu(cpu, msk))
+		return cpu;
 	cpu = cpumask_first_and(msk, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 	if (cpu < nr_cpu_ids)
 		return cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a719b62dc114..4f1e7ad94f80 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -361,6 +361,7 @@ extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
+extern const struct cpumask *dl_task_bw_span(struct task_struct *p);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
-- 
2.47.3

