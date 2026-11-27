Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790179;
	b=CfA9epa+PCOo8CD9Wp1PsD/SMYvAvsC+XBDfqis+sbh5R97qWvbVey69vvl5ygH83z0p
	 bEDgx9xjhY4DS85I3Zt9t61iMz1C6l2ETSGF5175PIerLqvAtO3pbtAJhPb/DoYSqdTwF
	 te8fLiUkRNGWT8omkv6XNDFdUiQcr35R5h5z0U9PxlUEe15dDU1T6tjQ3cmwtoChUo5LK
	 OvcktXonCT/BXvf3tSwOfFHZPO7IwQUv6GvTdiG0uTOCnLJS38+ym+Y2xIBOF4q+vf7oB
	 m/1Opi3+9pYuQis5Dh9TCFnaNoYFKzq/93luvLBzpYAJYgqivhHDYGVEOXXKlcY5eHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790179;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=COl18sm0+oiHcKcxxbiLDdO0NiB2xf8u2otZFMfqJkE=;
	b=M80Sq6U9Ycz6zvxqIufU+Lbc6kavGn98JgR7UD4/+4JyRdUBSf01WXBW7m8qpLaSAPQ0
	 3FNe/6eGYsj7rGnJNfyh6k0yxi5+yt2MGm98p+llM6r6DxFnTDVN+CjRfHpDXoH8YQqgv
	 aoxVH8NJN3c9j7T7QYJ0IFXBXdzDBtbdnhCc4h4xlT2o4MIyQL0IKIaKpulTGFcSJgFRP
	 8Sv2TWBM7lrc1+qH83xsp94xboaErYOBEND3XdCEpXylL7/sbv13XHRQu4by+uwWZejC0
	 cLD8Loh8dMyjIyBr4GibbV7bTzp9q8R1QOD1M1OkFFtDy/r3wnGLLnUfmhJamRWuCog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RFWL0Cve;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A0606A32D;
	Fri, 27 Nov 2026 14:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A1A0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RFWL0Cve
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790176;
	bh=COl18sm0+oiHcKcxxbiLDdO0NiB2xf8u2otZFMfqJkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFWL0CvevqKEygCKvDQl7oUdqxcgBqobvlo5dTUTm5aDOEva2GazshypEZFow3hNX
	 ukHA3c7/D6FeKCtf5ATsiS4aa70u9z2PzzAqQqJCOptxCPa2dC9gvr0S3Sa2jIAGw2
	 SEOcHv8uL7/r99042tfqNILTAXO1J3aEJt3WvWCOQt8IYm8jGR8CWhK/XhKrm5eNA9
	 UypNUfbf+laBnKbvAiJe7oIP+H8V8fm26/HHJSzvGKGyl3pj7jyU1FCPS5OvkdETef
	 FhS6PnIdHxIqmJCLhsT8d5HcGOUkiEfZ1eUMy/himcVLB55iLyFrDWjI0YD2I3tjnC
	 jAmhsEPQN6qlw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZR6g9kzXZG;
	Fri, 27 Nov 2026 09:36:15 -0500 (EST)
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
Subject: [PATCH v12 14/43] sched/deadline: Move a task's bandwidth to the root domain it runs in
Date: Fri, 27 Nov 2026 09:35:41 -0500
Message-ID: <63c72a365acb3ea77a6a38efbae152f086ef6ad5.1795771147.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

A deadline task can run in a root domain that does not count its
bandwidth. Two moves cause this:
- When a CPU goes offline, select_fallback_rq() picks a new CPU for a
  deadline task asleep on it. balance_push() moves a queued task the
  same way. With isolcpus="domain", the isolated CPUs are in the
  default root domain. A cpuset that is not a partition can hold CPUs
  of both root domains.
- Without admission control, sched_setaffinity() can give a task CPUs
  of another root domain. set_cpus_allowed_dl() then moves no
  bandwidth, since no one made room for it.

The root domain the task runs in can then admit deadline tasks beyond
its capacity, until the next rebuild.

Commit 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all
levels after offline migration") fixed this for a throttled task.
dl_task_offline_migration() moves its bandwidth with it. Other moves
still move no bandwidth.

Fix this by moving the bandwidth when the task arrives in a root domain
that does not count it. Check this in two places:
- migrate_task_rq_dl(), when the task moves to another CPU;
- task_woken_dl(), when the task wakes up on its old CPU. A cpuset move
  or a rebuild can move the bandwidth while the task sleeps. A change
  of the mask can then give that CPU back.

dl_task_move_bw() moves the bandwidth and records the new CPU. As
dl_task_offline_migration() does, it adds the bandwidth even without
room, since the task runs there.

No bandwidth moves in these cases:
- The new CPU is not active. A migration-disabled task can wake up on a
  CPU that goes offline, which is in the default root domain by then.
  The task leaves that CPU later, and that move takes the bandwidth.
- The new CPU is not in the mask. A task that slept in a
  migrate_disable() section wakes up on its old CPU. A cpuset attach
  can have moved its mask and its bandwidth meanwhile.
- The sched domains are being rebuilt. The CPUs then change root
  domains one by one, so two CPUs can be in different root domains for
  a moment. dl_bw_rebuild_begin() and dl_clear_root_domains() mark this
  window.
- The walk of the task list that follows has not reached the task. The
  walk counts it where it is. A task that the walk left out, with no
  active CPU, is marked in dl_bw_skip_gen. It moves at once.

Both checks read the record without dl_departed_lock, so a move inside
a root domain takes no lock. dl_task_move_bw() checks again under the
lock.

These cases, added to deadline_bw_test later in this series, fail
without this patch:
- hotplug_fallback, hotplug_fallback_moved and hotplug_fallback_in_mask:
  a task woken on an isolated CPU stays counted in the housekeeping root
  domain.
- no_admission_affinity_moves: without admission control, a task given
  an affinity of one isolated CPU stays counted in the housekeeping root
  domain.

This follows the Sashiko AI reviews of this series.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h          |   6 +
 include/linux/sched/deadline.h |   1 +
 kernel/sched/deadline.c        | 209 ++++++++++++++++++++++++++++++---
 kernel/sched/topology.c        |   3 +
 4 files changed, 200 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8e7aa758d863..e934e2225986 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -753,6 +753,11 @@ struct sched_dl_entity {
 	 * @dl_bw_gen is the value of dl_bw_gen when the bandwidth was last
 	 * counted. If a rebuild dropped it since, there is nothing to remove.
 	 *
+	 * @dl_bw_skip_gen is the value of dl_bw_gen when the walk of the
+	 * task list after a rebuild left the task out: no CPU of it was
+	 * active. A move of the task then counts the bandwidth, even before
+	 * the walk ends.
+	 *
 	 * @dl_bw_resv_cpu is a CPU of the root domain where a cpuset attach
 	 * in progress reserved room for the bandwidth, or -1.
 	 * cpuset_can_attach() sets it, and cpuset_attach() moves the
@@ -761,6 +766,7 @@ struct sched_dl_entity {
 	struct list_head		dl_departed_node;
 	int				dl_bw_cpu;
 	unsigned int			dl_bw_gen;
+	unsigned int			dl_bw_skip_gen;
 	int				dl_bw_resv_cpu;
 
 	/*
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
index 510b0b243257..cd5e3c355829 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -268,6 +268,73 @@ static LIST_HEAD(dl_departed_list);
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
+ * first. A task the walk left out, with no active CPU, can move: no one
+ * else counts it.
+ *
+ * The answer is exact under dl_departed_lock. Without it, the answer is a
+ * hint: dl_task_move_bw() tests again under the lock.
+ */
+static inline bool dl_bw_move_blocked(struct task_struct *p)
+{
+	if (dl_bw_rebuilding())
+		return true;
+	return READ_ONCE(dl_bw_walking) &&
+	       READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen) &&
+	       READ_ONCE(p->dl.dl_bw_skip_gen) != READ_ONCE(dl_bw_gen);
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
@@ -2947,11 +3014,87 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
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
+ * Return false also if @cpu is not in the mask of @p. A task that sleeps
+ * in a migrate_disable() section wakes up on the CPU it slept on. A
+ * cpuset attach can have moved its mask and its bandwidth elsewhere
+ * meanwhile. migrate_enable() then takes the task to its new mask.
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
+	    !cpumask_test_cpu(cpu, &p->cpus_mask) || dl_bw_move_blocked(p))
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
 
@@ -3614,6 +3757,15 @@ static void pull_dl_task(struct rq *this_rq)
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
@@ -3679,9 +3831,10 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3884,10 +4037,11 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
@@ -3962,11 +4116,13 @@ void dl_add_task_root_domain(struct task_struct *p)
 		/*
 		 * No active CPU can count the bandwidth of this task. Leave it
 		 * out of this rebuild. dl_bw_gen then keeps its release from
-		 * removing anything. A later rebuild, or
-		 * dl_task_offline_migration(), counts it again. Do not leave
-		 * out a departed task: the code below counts it on the CPU
-		 * recorded, if that CPU is active.
+		 * removing anything. A later rebuild counts it again. So does
+		 * the move of the task to an active CPU. Mark the task, so
+		 * that the move does not wait for the end of the walk. Do not
+		 * leave out a departed task: the code below counts it on the
+		 * CPU recorded, if that CPU is active.
 		 */
+		WRITE_ONCE(p->dl.dl_bw_skip_gen, dl_bw_gen);
 		goto unlock;
 	}
 
@@ -4124,8 +4280,10 @@ void dl_rebuild_rd_accounting(void)
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
@@ -4139,6 +4297,7 @@ void dl_rebuild_rd_accounting(void)
 			dl_add_task_root_domain(p);
 	}
 	read_unlock(&tasklist_lock);
+	dl_bw_walk_end();
 }
 
 /*
@@ -4157,7 +4316,17 @@ void dl_clear_root_domains(void)
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
@@ -4274,11 +4443,13 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	 * boosts it back into the class before its 0-lag time. (A policy change
 	 * took it off the list in sched_dl_overflow().) The inactive timer no
 	 * longer removes its bandwidth: the task does when it leaves the class
-	 * again. So take it off the list. The task keeps the CPU recorded. It
-	 * takes the bandwidth from the root domain of that CPU, even if it
-	 * moved to another root domain meanwhile. A rebuild while it is
-	 * boosted counts it like any deadline task, and records the CPU it
-	 * picks.
+	 * again. So take it off the list. The task keeps the CPU recorded.
+	 * When it leaves the class, it takes the bandwidth from the root
+	 * domain of that CPU. If the task moved to another root domain
+	 * meanwhile, its next wakeup or migration there first moves the
+	 * bandwidth and the record, as for any deadline task. A rebuild while
+	 * it is boosted counts it like any deadline task, and records the CPU
+	 * it picks.
 	 */
 	dl_task_undepart(p);
 
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

