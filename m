Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924677;
	b=dnUK7O0F/FmCezyakABDPqnsHtOFq7k8xZxjyuMh1oWS/yBVzKdFlttfZP4VVjCWWFVF
	 68W9YLrzal3kDbpAHYciAqH9BhGWMJA1JYMuXu4i5o5YCwLIjeGhqEuXX7pm8ct4lwiYK
	 GoWW1rxLWT9+DB1OQn/GVZM2MUlhIVo5gCEITw3uGW36Ry4z71HE6l7H9P3qHekXXgYxi
	 DcUqDefOGSAOYyAIFHN8GrUFIy4n8iIZDiBldMSKXG7BEf3L2fR54dkinr6dMI63zWouU
	 WuVFYBcMw8Bi6o6s9r9c/V1ZRlhWPmnfxhMBqGbiNfPMkbtaOs1/LLASk+0nnQ7uF+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924677;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=38HllpwGINlr8TaSOfoijZdf0P6BEc81gCwRUIC6O28=;
	b=iPGobxzZRWaJzS5aI+fc4P9jRi/DSW6z4oe07TmEQ0fzBI2j+6Jld+VHDnVqW7T57vdx
	 0cq6hNsC6ZyIPkpo7jAa4CKpl+1xtyBLyOBJzcoVrJ6LotmFmG1w4KDO8baveKICVGSy4
	 8OAyl7jAP/WTGyVNG/RAcBSUNboiFwB3uhCttKUzzcBNDbb5Lrwb8aniiX2+jsuaGAMLz
	 UO+ziYiqYNvRgbwPbK/bnq9aVe+46sLoQ/gQoMKiUWMsZydUpAeaDT11p05+e/gfxliUq
	 XfGPHLBr18YtrZbfG0Cl7L3alE+2eWMQed2aLvAkP44cCySyo3Euq3UKPUr4vgQvyBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=BEeL0wuD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37861606BD1E;
	Tue, 17 Nov 2026 14:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37861606BD1E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=BEeL0wuD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924669;
	bh=38HllpwGINlr8TaSOfoijZdf0P6BEc81gCwRUIC6O28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEeL0wuDvnE9KphWLqgaS9aKVCIgYP2T+FdJ3B3xj6AmYP63Tc1jyn6N9MnoeOm19
	 BC9TYrX4TLq0mFGiSyjh3NKjrrJADeVkEI00W1ocJHmV0TFSbXvkuQLBHawoNayEaD
	 +64bf1y5r0PKwKiPf7HCdqBldRRvXxIw+9Fz6ZcLtUVMclIzn/OVmor6j/dToxjiHk
	 HIC91mhCGE6XG9UFK0Ia7V5zTzUDP8S1FheXgyYApRXR1VoeiCI26ENhk+SYqh/lD0
	 8A8OdTXaVb8rNbjmyLizI0osIddvLu6C7ShAk8xVi+Mloir/Uzs2x+tvaTyIbzJ5Wm
	 gjRauK0L6ZOIQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV537dNzRHR;
	Tue, 17 Nov 2026 09:11:09 -0500 (EST)
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
Subject: [PATCH v7 28/40] sched/deadline: Keep a task in the root domain that counts its bandwidth
Date: Tue, 17 Nov 2026 09:10:49 -0500
Message-Id: <2c1a48adf25ac3528a1f88632bda53826db5399e.1794922146.git.mathieu.desnoyers@efficios.com>
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

dl_task_bw_span() returns NULL while the sched domains are rebuilt. The
CPUs then change root domains one by one. A housekeeping CPU passes
through the default root domain, which holds the isolated CPUs. Its
span would send a housekeeping task to an isolated CPU. So inside a
rebuild, the CPU is picked as it was before this patch. If that CPU is
in the other root domain, the next wakeup brings the task back.

A known limit remains. A wakeup can pick its CPU inside a rebuild, and
be queued after the rebuild. Its bandwidth can then still move to the
other root domain, with no admission test. This was found by reading,
not reproduced.

A task with no CPU left in its root domain still moves, and its
bandwidth with it. The next two patches refuse the changes that lead
to that.

The case hotplug_keeps_root_domain of deadline_bw_test, added later in
this series, tests this. A cpuset holds two isolated CPUs and two
housekeeping CPUs, H and K. A deadline task counted in the housekeeping
root domain sleeps on H. Then H goes offline. The task must wake up on
K. Without this patch it woke up on an isolated CPU: CPU 0, in a guest
with isolcpus=domain,0,1.

These cases test the other paths:
 - hotplug_spinner_keeps: a running task whose CPU goes offline;
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
 kernel/sched/core.c     |  38 ++++++++++
 kernel/sched/deadline.c | 156 +++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h    |   1 +
 3 files changed, 171 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e9f80407f75b..dc270a23179d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3264,6 +3264,23 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
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
+		 * mask holds one of its CPUs.
+		 */
+		if (span && !cpumask_test_cpu(dest_cpu, span))
+			cpu = cpumask_first_and_and(cpu_valid_mask,
+						    ctx->new_mask, span);
+		if (cpu < nr_cpu_ids) {
+			dest_cpu = cpu;
+			if (!task_on_rq_queued(p))
+				p->wake_cpu = dest_cpu;
+		}
 	}
 
 	do_set_cpus_allowed(p, ctx);
@@ -3668,8 +3685,21 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int nid = cpu_to_node(cpu);
 	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
+	const struct cpumask *span;
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
@@ -3686,6 +3716,14 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	}
 
 	for (;;) {
+		/* The mask is wider now: look again in that root domain. */
+		if (span && state != cpuset) {
+			for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+				if (is_cpu_allowed(p, dest_cpu))
+					goto out;
+			}
+		}
+
 		/* Any allowed, online CPU? */
 		for_each_cpu(dest_cpu, p->cpus_ptr) {
 			if (!is_cpu_allowed(p, dest_cpu))
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6c6a4d9cd054..e5f77d3c5fa0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -313,8 +313,8 @@ static unsigned int dl_bw_gen;
  * where its bandwidth is counted. The new root domains count no task
  * yet.
  *
- * Changed under dl_departed_lock. dl_task_bw_elsewhere() reads it
- * without the lock.
+ * Changed under dl_departed_lock. dl_task_bw_span() and
+ * dl_task_bw_elsewhere() read it without the lock.
  */
 static unsigned int dl_bw_rebuild_seq;
 
@@ -333,6 +333,8 @@ void dl_bw_rebuild_begin(void)
 	lockdep_assert_held(&sched_domains_mutex);
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
 	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+	/* Before the first write of rq->rd: see dl_task_bw_span(). */
+	smp_wmb();
 }
 
 static void dl_bw_rebuild_end(void)
@@ -901,18 +903,36 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 
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
@@ -2923,6 +2943,7 @@ static int
 select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 {
 	struct task_struct *curr, *donor;
+	const struct cpumask *span;
 	bool select_rq;
 	struct rq *rq;
 
@@ -2963,6 +2984,20 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
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
@@ -3744,6 +3779,58 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
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
@@ -3953,23 +4040,24 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
+ *
+ * With no CPU on that side, or no CPU recorded, prefer the CPU @p is on.
+ * Else take the first active CPU of the mask, a housekeeping one if there
+ * is one. A task on isolated CPUs that all went offline can have no
+ * active CPU at all.
  *
- * Else prefer the CPU recorded with the bandwidth, if it is active and in
- * the mask. It is in the root domain that admitted the bandwidth, or that
- * its last move put it in. A task moved asleep is still on a CPU of the
- * root domain it left, out of its mask. Else take the first active CPU of
- * the mask, a housekeeping one if there is one. A task on isolated CPUs
- * that all went offline can have no active CPU at all.
+ * One case comes before all of these. Take the CPU @p is on if @p is
+ * queued there, out of its mask, and the CPU is the one recorded. Without
+ * admission control, dl_task_offline_migration() can put a throttled task
+ * and its bandwidth on any active CPU. The task runs there until it
+ * blocks.
  */
 static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 {
@@ -3987,17 +4075,37 @@ static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 	 */
 	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
 	cpu = task_cpu(p);
-	if (cpumask_test_cpu(cpu, msk) ||
-	    (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p)))
+	if (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p))
 		return cpu;
 	if (cpumask_empty(msk)) {
 		if (recorded >= 0 && cpu_active(recorded))
 			return recorded;
 		dl_get_task_effective_cpus(p, msk);
 		cpumask_and(msk, msk, cpu_active_mask);
-	} else if (recorded >= 0 && cpumask_test_cpu(recorded, msk)) {
-		return recorded;
 	}
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
index 3cc287785b91..f80ea5541b3f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -371,6 +371,7 @@ extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
+extern const struct cpumask *dl_task_bw_span(struct task_struct *p);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
-- 
2.47.3

