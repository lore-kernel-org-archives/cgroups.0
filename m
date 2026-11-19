Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119387;
	b=dq1bREEteclIWdBjLxfBQRXgTqrkFXZD7LonS27dcx94lJfZH9JHwy1E/SUMPQ2P57X5
	 WwSVXFCArD0CzNgvq81n0yxrW3iDZZfNIGDWeyDaOqxDRNWl7NKfVIg57hPyGqWSkU1Yo
	 K9rPeoDDzG2GmeYs4ugGM8tWbLTi30gtrSRF5KJVBsmVgcBf2LLZf0+Xc9aX8qLtHsSDv
	 W1OckfPOFhsr8MM+AjjwZuWPGcudgMmc3Q+UurPt3jhRhCbZZlVVarX9oQfNNYwTX1aT1
	 En/UXkPFqAEwql4LQkHmZUOpMumOyVKM4X+4M/affoI7cK6yAENf4n4UWIPDSHlGrvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119387;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TPBLD45uObnKjISvtmzPcNUnndHxVr6tH4y1oIwstWk=;
	b=DnbjLesAL/Y0n4Z1O2Ijw8iASo0GWPA84/9P9hG9F9e6YZEdNJPQvko5pwVBnVCmmoFR
	 7hn5/63g7MRHMVedHIH0XFTiAJ/wBUCKlhaEjEZXcI1CPwwNhvJt7Wvt+y3+6XPpBmvxx
	 wjKZvfbYlFV+m1TjutHt7P7+HE1eXaFfDdw2R7uoRcKBo1CtxHqn1gdLPF62nPt16O5Kb
	 QOXm6JZ7NHrx5lHI8jxfwif2TcQEWmpJkiDdQJfocY8PptFY7Pkun8Q439nIBpDz/XDLw
	 3Jab7RuEFxGncFleWjhGZJoGzqf1uKCmQYUHLUsxSb3U/+GW19m0V2+CZsw5Mm7iH3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=J9X1gfjz;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE56560A3814;
	Thu, 19 Nov 2026 20:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE56560A3814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=J9X1gfjz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119380;
	bh=TPBLD45uObnKjISvtmzPcNUnndHxVr6tH4y1oIwstWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9X1gfjzXzDAtSZNroMcnHULu3bh/OhKdEGWP9V6C/QJ+bMe8B92Me8lAeXNQXbZe
	 YoXUrFvkiMVGq6+lVHbJzLZQia+4lXQ7ozcGpMIp4cbZuGHNJjrxC9F9LHyvV+SIkN
	 t/O/fCsmZ32EciJsbdLb0OWHNd1QJNI3p2w05d11uUrQ/yaOgMqRxfZXkcdU38ks+8
	 1IzK4oV2Wz/OU8MpjfkMvAGzn1+xoPIh0iPIvGpu0uPy1UtWWgUrS2pfnf/C5HX7gJ
	 ssFefTvQ9vHsI2hnLzeIA0S9H2ZlnYgG3xc6KmlNZPEATExIBKPdscrtx3DNclDlLF
	 5FHF49CbVwj6g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVX0lWxzSjY;
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
Subject: [PATCH v8 14/33] sched/deadline: Move a task's bandwidth to the root domain it runs in
Date: Thu, 19 Nov 2026 15:15:53 -0500
Message-Id: <b4bddc11bb05352bb1eca11dd5e0060479aa2e5a.1795116791.git.mathieu.desnoyers@efficios.com>
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
Do not move it to a CPU that is not active. A migration-disabled task
can wake up on a CPU that goes offline. That CPU is in the default root
domain by then. The task leaves it before it runs anywhere else.

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

Move no bandwidth while the sched domains are rebuilt. The CPUs then
change root domains one by one. Two CPUs can be in different root
domains only because one of them was attached to its new root domain
first. dl_bw_rebuild_begin() opens this window in
partition_sched_domains_locked(). dl_clear_root_domains() closes it.
Then the walk of the task list counts each task. Until it reaches a
task, no move of that task is made: the walk counts it where it is.
Once the walk counted the task, its bandwidth moves again.

These cases, added to deadline_bw_test later in this series, fail
without this patch: - hotplug_fallback, hotplug_fallback_moved and
hotplug_fallback_in_mask: a task woken on an isolated CPU stays counted
in the housekeeping root domain. - no_admission_affinity_moves: without
admission control, a task given an affinity of one isolated CPU stays
counted in the housekeeping root domain.

This follows the Sashiko AI reviews of this series.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h |   1 +
 kernel/sched/deadline.c        | 184 ++++++++++++++++++++++++++++++---
 kernel/sched/topology.c        |   3 +
 3 files changed, 176 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index cbb7cd71db58..bdabd54af729 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -33,6 +33,7 @@ struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domains(void);
+extern void dl_bw_rebuild_begin(void);
 extern void dl_rebuild_rd_accounting(void);
 /*
  * Keep a rebuild of the root domains' accounting and an admission of
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index df55aba27ddc..fb8f32a31cf9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -268,6 +268,71 @@ static LIST_HEAD(dl_departed_list);
 static DEFINE_RAW_SPINLOCK(dl_departed_lock);
 static unsigned int dl_bw_gen;
 
+/*
+ * Odd while the sched domains are rebuilt: from before the first CPU
+ * leaves its root domain until dl_clear_root_domains(). Meanwhile the
+ * CPUs change root domains one by one. Housekeeping CPUs pass through
+ * def_root_domain, next to the CPUs that isolcpus="domain" isolates. So
+ * the root domain of the CPU recorded with a task says nothing about
+ * where its bandwidth is counted. The new root domains count no task
+ * yet.
+ *
+ * Changed under dl_departed_lock. dl_task_bw_elsewhere() reads it
+ * without the lock.
+ */
+static unsigned int dl_bw_rebuild_seq;
+
+/*
+ * True while dl_rebuild_rd_accounting() walks the task list: from
+ * dl_clear_root_domains() until the walk ends. The root domains are final
+ * by then. A task the walk has not reached yet has a dl_bw_gen that is
+ * not current. Changed under dl_departed_lock. dl_task_bw_elsewhere()
+ * reads it without the lock.
+ */
+static bool dl_bw_walking;
+
+/* Return true while the sched domains are rebuilt. */
+static inline bool dl_bw_rebuilding(void)
+{
+	return READ_ONCE(dl_bw_rebuild_seq) & 1;
+}
+
+/*
+ * Return true if the bandwidth of @p must not move now. Either the sched
+ * domains are rebuilt, or the walk of the task list that follows has not
+ * reached @p yet. The walk then counts @p. A move must not count it
+ * first.
+ *
+ * The answer is exact under dl_departed_lock. Without it, the answer is a
+ * hint: dl_task_move_bw() tests again under the lock.
+ */
+static inline bool dl_bw_move_blocked(struct task_struct *p)
+{
+	if (dl_bw_rebuilding())
+		return true;
+	return READ_ONCE(dl_bw_walking) &&
+	       READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen);
+}
+
+/*
+ * Start a rebuild of the sched domains. Call it before the first CPU
+ * leaves its root domain. dl_clear_root_domains() ends the rebuild.
+ */
+void dl_bw_rebuild_begin(void)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+	guard(raw_spinlock_irqsave)(&dl_departed_lock);
+	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+}
+
+/* End the walk of the task list that dl_clear_root_domains() started. */
+static void dl_bw_walk_end(void)
+{
+	guard(raw_spinlock_irqsave)(&dl_departed_lock);
+	WARN_ON_ONCE(!dl_bw_walking);
+	WRITE_ONCE(dl_bw_walking, false);
+}
+
 /*
  * The number of tasks with a bandwidth: those whose dl_bw is not 0. A
  * special entity and a server are not counted. __setparam_dl() and
@@ -2920,11 +2985,82 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 	return cpu;
 }
 
-static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused)
+/*
+ * Return true if the root domain of @cpu may not count the bandwidth of
+ * @p. Either another root domain counts it, or a rebuild left @p out.
+ * Test without dl_departed_lock, so that a move inside a root domain
+ * takes no lock. dl_task_move_bw() tests again under it.
+ *
+ * Return false if @cpu is not active. A migration-disabled task can wake
+ * up on a CPU that goes offline, after it joined the default root domain.
+ * Keep the bandwidth where it is counted. balance_push() moves the task
+ * off that CPU once it enables migration, or its next wakeup does once
+ * the CPU is offline. That migration moves the bandwidth if needed.
+ *
+ * Return false while the sched domains are rebuilt. The CPUs then move
+ * to their new root domains one by one. That alone can make the two root
+ * domains differ. The rebuild of the accounting that follows counts @p.
+ * Return false also while that rebuild has not reached @p. Once it has
+ * counted @p, the root domains are final, and a move is right again.
+ */
+static bool dl_task_bw_elsewhere(struct task_struct *p, int cpu)
+{
+	int bw_cpu = READ_ONCE(p->dl.dl_bw_cpu);
+
+	if (bw_cpu < 0 || !p->dl.dl_bw || !cpu_active(cpu) ||
+	    dl_bw_move_blocked(p))
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
+	if (cpu < 0 || dl_bw_move_blocked(p))
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
 
@@ -3587,6 +3723,15 @@ static void pull_dl_task(struct rq *this_rq)
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
@@ -3622,9 +3767,10 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3827,10 +3973,11 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
  * Prefer that CPU also if @p is queued there, out of its mask, and the
  * CPU is the one recorded. Without admission control,
  * dl_task_offline_migration() can put a throttled task and its bandwidth
@@ -3904,8 +4051,8 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -4066,8 +4213,10 @@ void dl_rebuild_rd_accounting(void)
 	 * a resume run one for each CPU. A task gets a bandwidth under the
 	 * locks this rebuild holds, so the count cannot leave 0 meanwhile.
 	 */
-	if (!atomic_read(&dl_nr_bw_tasks))
+	if (!atomic_read(&dl_nr_bw_tasks)) {
+		dl_bw_walk_end();
 		return;
+	}
 
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
@@ -4081,6 +4230,7 @@ void dl_rebuild_rd_accounting(void)
 			dl_add_task_root_domain(p);
 	}
 	read_unlock(&tasklist_lock);
+	dl_bw_walk_end();
 }
 
 /*
@@ -4099,7 +4249,17 @@ void dl_clear_root_domains(void)
 	int cpu;
 
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
-	dl_bw_gen++;
+	/* dl_task_bw_elsewhere() reads it without the lock. */
+	WRITE_ONCE(dl_bw_gen, dl_bw_gen + 1);
+	/*
+	 * The root domains are final. End the rebuild of the sched domains,
+	 * and start the walk of the task list. From now on, a task that the
+	 * walk has counted moves its bandwidth again. A task that the walk
+	 * has not reached still waits for it: see dl_bw_move_blocked().
+	 */
+	WARN_ON_ONCE(!(dl_bw_rebuild_seq & 1));
+	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+	WRITE_ONCE(dl_bw_walking, true);
 	for_each_possible_cpu(cpu) {
 		if (!dl_bw_visited(cpu, cookie))
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 35e56a45c238..754756d2db00 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3430,6 +3430,9 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 		n = ndoms_new;
 	}
 
+	/* dl_clear_root_domains() ends it, in dl_rebuild_rd_accounting(). */
+	dl_bw_rebuild_begin();
+
 	/* Destroy deleted domains: */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
-- 
2.47.3

