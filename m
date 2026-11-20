Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207362;
	b=mZSI5QomkVTC657UBeV/nmAvZJPBTXmDu5tge/29ZeUG2IVAXMsTS6d4cGG1WocA2RYj
	 QN1xjMqWuRuNjHluzXCRAP4lelg96J0/YwG44mMgxumMfidQ05k6qVPdYLMqSq5h2uptA
	 iyLb7/0VhTLjjP10w8hPGAjp1S2dojrjZXAhT/FUPLSPJuSTPxRCRGhbCgEFKT94pBQoE
	 5thwYpRzCzVzefiwaVloOF1gVZFmbTtjG7z/OcwAtWEZgWEQoofpIhkADGh4ugz3sJ7C8
	 iffVmOZ6ZkYylBt1Z5hZ4atnyC9d2pezWhNoljUk6s7v6K+cRwvTzY9xWvIuY2nABvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207362;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IRjoIHEJ+dDfLC6Xaroyn7OlG4HCJbkjas4AC6eaFvo=;
	b=HEmVXz6RZyYDJo0zVBASpW/6HjXwVlI61YFZTdHbb7BJA1QJcYsj8BNux5GeHPtf1sXe
	 lJpsX5Frg1og42DUG7BbuPYpOfe6uaZxN1Yg8XESq0vLa23H5/dJDexJMuddbsax1XY4c
	 sy2toH2Rprb5gf64VSJaPSbf30Dc4fYuuMGNAv+Tj/Prnn5Ab3m2QPfeVTcP+7LkiVm5k
	 8okflAt5A5lLWYdnYvATTOA4ug3Y/dBJrvEhvBk5hAiUpW6YFSHhjDvoi3tcXg9dTQxrO
	 7LmiFOUqu6C23rdKVGssPhx+rYQnAByqdMBIMskTPEWt5qvIhbVivZS0LhOAux2yUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MerE5IH9;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086E60A261D;
	Fri, 20 Nov 2026 20:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9086E60A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MerE5IH9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207354;
	bh=IRjoIHEJ+dDfLC6Xaroyn7OlG4HCJbkjas4AC6eaFvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MerE5IH9LDFYDQUPeCJF1S1V+j2IQKDA1YrMGGYvmcTs+N56qZuTRmp1tpQuVfJvg
	 F26U+PY3ftDtu02T+DZMA4pIRvX2/UzWf3rlX7AWC1iBDQhvMBGCwNaTRGyDyA5aqT
	 +p4kyu1P4NqAWT6k7B2GuimMUeBddNA9maJoP+Q5cqd6EfD0WCZujC2SpWxvWd7duh
	 6970QS1p0qi3m3wOCItjWyD+mnyAKUwPpDN6Zl+t9X1U14hZFj/QKqrtm1Js8XmSa/
	 vzL82WA4IZbs3VlmJ71wMDZ/vEqOgLPHAu+IeY+A7YkczatTB4iaEmq753XKfzWdwT
	 MMQa+j6GrusOQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2L0qnJzVCl;
	Fri, 20 Nov 2026 15:42:34 -0500 (EST)
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
Subject: [PATCH v10 13/40] sched/deadline: Make a rebuild count a task in the root domain it runs in
Date: Fri, 20 Nov 2026 15:41:50 -0500
Message-Id: <c7c27e2c74c13bb8580f84ac9ed12a5a8001947a.1795207232.git.mathieu.desnoyers@efficios.com>
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

A rebuild of the accounting counts each deadline task on the first
active CPU of its cpuset. Commit 318e18ed22e8 ("sched/deadline: Walk up
cpuset hierarchy to decide root domain when hot-unplug") made this
choice. It relies on the bandwidth check to keep such a CPU active.
This guess would go wrong in three ways:

 - A cpuset, like the root one, can hold CPUs isolated by
   isolcpus="domain" beside housekeeping CPUs. If an isolated CPU comes
   first, the task would be counted in the default root domain. Its own
   root domain would then be short of that bandwidth.
 - A task confined to isolated CPUs can see them all go offline. The
   rebuild would then find no active CPU, and hit its BUG_ON().
 - dl_task_offline_migration() moves a throttled task, with its
   bandwidth, off CPUs that went offline. The rebuild would count it in
   its cpuset, not where it moved.

In the first and third cases, a root domain would admit deadline tasks
beyond its capacity.

Fix this by choosing the CPU in this order:

 1. The CPU the task is on, if it is active and in the task's mask. A
    mask can hold CPUs of two root domains, for instance after
    select_fallback_rq() widened it. Also the CPU the task is queued on
    out of its mask, if it is active and recorded with the bandwidth.
    Without admission control, dl_task_offline_migration() can put a
    throttled task there. It runs there until it blocks.
 2. dl_bw_cpu, the CPU recorded with the bandwidth, if it is active and
    in the mask. A task moved asleep is not on its new CPUs yet.
 3. The first active CPU of the mask, a housekeeping one if any.
 4. With no active CPU in the mask: the task falls back to its cpuset.
    Count it there. Keep dl_bw_cpu if the cpuset holds it.

The mask of the task comes before its cpuset. A partition change sets
the task masks before its rebuild. dl_get_task_effective_cpus() reads
the CPUs isolated at boot, HK_TYPE_DOMAIN_BOOT. HK_TYPE_DOMAIN also
leaves out the CPUs of isolated partitions, and is updated after the
rebuild.

Leave out a task with no active CPU, instead of the BUG_ON(). dl_bw_gen
then keeps its release from removing anything.
dl_task_offline_migration() counts it again when it moves it.

A task that select_fallback_rq() moves to another root domain still runs
where its bandwidth is not counted. The next patch moves the bandwidth
with it.

The Sashiko AI reviews of this series found these cases. The case
rebuild_record_taken, added to deadline_bw_test later in this series,
tests the rule for a task with no active CPU in its mask.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Fixes: 318e18ed22e8 ("sched/deadline: Walk up cpuset hierarchy to decide root domain when hot-unplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 100 ++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0ece0f7d5e1a..1e7168241e9c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -953,14 +953,20 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			__dl_sub(dl_b, p->dl.dl_bw,
 				 cpumask_weight(src_rq->rd->span));
 			raw_spin_unlock(&dl_b->lock);
-
-			dl_b = &later_rq->rd->dl_bw;
-			raw_spin_lock(&dl_b->lock);
-			__dl_add(dl_b, p->dl.dl_bw,
-				 cpumask_weight(later_rq->rd->span));
-			raw_spin_unlock(&dl_b->lock);
 		}
+		/*
+		 * Count the bandwidth in the root domain the task moves to.
+		 * Do it also when a rebuild left the task out, for want of an
+		 * active CPU. A rebuild that reaches the task after this finds
+		 * its dl_bw_gen current, and leaves it alone.
+		 */
+		dl_b = &later_rq->rd->dl_bw;
+		raw_spin_lock(&dl_b->lock);
+		__dl_add(dl_b, p->dl.dl_bw,
+			 cpumask_weight(later_rq->rd->span));
+		raw_spin_unlock(&dl_b->lock);
 		p->dl.dl_bw_cpu = later_rq->cpu;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_task_cpu(p, later_rq->cpu);
@@ -3843,8 +3849,14 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 {
 	const struct cpumask *hk_msk;
 
-	hk_msk = housekeeping_cpumask(HK_TYPE_DOMAIN);
-	if (housekeeping_enabled(HK_TYPE_DOMAIN)) {
+	/*
+	 * Use the CPUs isolated at boot. HK_TYPE_DOMAIN also leaves out the
+	 * CPUs of isolated partitions, and is updated after the rebuild. A
+	 * CPU that just left such a partition is then in a new root domain,
+	 * but HK_TYPE_DOMAIN still says it is isolated.
+	 */
+	hk_msk = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
 		if (!cpumask_intersects(p->cpus_ptr, hk_msk)) {
 			/*
 			 * CPUs isolated by isolcpu="domain" always belong to
@@ -3863,6 +3875,62 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
+/*
+ * Return a CPU of the root domain where a rebuild of the accounting should
+ * count the bandwidth of @p, or nr_cpu_ids if there is none.
+ *
+ * Prefer the CPU @p is on, if it is active and in the mask of @p. The
+ * task runs, or wakes up, in the root domain of that CPU. A mask can hold
+ * CPUs of two root domains: housekeeping CPUs and CPUs isolated by
+ * isolcpus="domain". When every CPU of a mask goes offline,
+ * select_fallback_rq() can widen it to both. It moves no bandwidth.
+ * Prefer that CPU also if @p is queued there, out of its mask, and the
+ * CPU is the one recorded. Without admission control,
+ * dl_task_offline_migration() can put a throttled task and its bandwidth
+ * on any active CPU. The task runs there until it blocks.
+ *
+ * Else prefer the CPU recorded with the bandwidth, if it is active and in
+ * the mask. It is in the root domain that admitted the bandwidth, or that
+ * its last move put it in. A task moved asleep is still on a CPU of the
+ * root domain it left, out of its mask. Else take the first active CPU of
+ * the mask, a housekeeping one if there is one. If no CPU of the mask is
+ * active, use the CPUs of the cpuset instead of the mask. A task on
+ * isolated CPUs that all went offline can have no active CPU at all.
+ */
+static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
+{
+	struct cpumask *msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	/*
+	 * Read the record once. The last schedule of a dead task clears it
+	 * under its rq lock, and the caller holds only the pi_lock.
+	 */
+	int recorded = READ_ONCE(p->dl.dl_bw_cpu);
+	unsigned int cpu;
+
+	/*
+	 * Look at the mask of the task first. A change of the cpusets sets
+	 * the mask of each task before its rebuild. If no CPU of the mask
+	 * is active, ask the cpuset. The task wakes up on one of its CPUs.
+	 * Take the CPU recorded only if it is one of them: a partition root
+	 * can have taken it since it was recorded.
+	 */
+	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
+	cpu = task_cpu(p);
+	if (cpumask_test_cpu(cpu, msk) ||
+	    (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p)))
+		return cpu;
+	if (cpumask_empty(msk)) {
+		dl_get_task_effective_cpus(p, msk);
+		cpumask_and(msk, msk, cpu_active_mask);
+	}
+	if (recorded >= 0 && cpumask_test_cpu(recorded, msk))
+		return recorded;
+	cpu = cpumask_first_and(msk, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+	if (cpu < nr_cpu_ids)
+		return cpu;
+	return cpumask_first(msk);
+}
+
 /* From dl_rebuild_rd_accounting(), under the locks it asserts. */
 void dl_add_task_root_domain(struct task_struct *p)
 {
@@ -3870,7 +3938,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3885,10 +3952,17 @@ void dl_add_task_root_domain(struct task_struct *p)
 		return;
 	}
 
-	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
-	dl_get_task_effective_cpus(p, msk);
-	cpu = cpumask_first_and(cpu_active_mask, msk);
-	BUG_ON(cpu >= nr_cpu_ids);
+	cpu = dl_task_rebuild_cpu(p);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * No active CPU can count the bandwidth of this task. Leave it
+		 * out of this rebuild. dl_bw_gen then keeps its release from
+		 * removing anything. A later rebuild, or
+		 * dl_task_offline_migration(), counts it again.
+		 */
+		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
+		return;
+	}
 
 	raw_spin_lock(&dl_departed_lock);
 	/*
-- 
2.47.3

