Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924676;
	b=G/bs4O1UUIxpMffIA5ZyUcEbm0lKXQqpUO6lSzcCU+48g4KAoM7KblfsEfjNpNpTZ166
	 dAMJPwu+ENG9hLCwqt23skeEak1q58875EonaLFTB3YbVKCZaQ9A3n9gOSbOdia8zr4/0
	 kLVAqbdn0RXeUaPNv/VrgSV8Gf8oZs6FQFl6p/xLDWbS6eSUGQTmOsknn4DG0vCtZPqh5
	 u1Jz7K50vudgKQ8TnZQgzNbO2jsGtjMnop/BXQSczyD0XPReWKLpkFgCwbc3miqu5PybO
	 ZWapsJGI7rqCy9wsQVCjUkSQ48CQogF47gWAxLyaXBWxuXdvncgrLDu6pcrs9NdkoPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924676;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XHF6fbYR2e5DOlTVnhrZPCWPzn9uRL7X1zyWH2Iwktw=;
	b=nisFOTi6OIaonmPXR+u0sp7tmO/Iz9CH5fC7BXGVd3LInliItH3rY06PuG8HtD5I7vPs
	 Gg5PJYoa970OTpfscT9ZfEy3UhWw4XEuRQ1IRxM23hys3k7DFUp22CYqu/P4DWbYui38H
	 8GZyXbb1wdASBa7MWiA6IFRu7d1Emd5a4babBnJ5YvlRmwH5eYDR1JpJUxtXkKtR6StW5
	 zLYQSOPvpIFB3dVVZP8XYdOqErSBGEQw+h41ujTRfa8cr9Rz1k2bG99GDXXZknvg8Q5nn
	 Zn5t3rmguiuExY8GGAOqZfwZUy04OOoB8vaueQSIknjcYldba5xqWCMV3GwBjg+pIXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XBlxhVYf;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649C9606B09D;
	Tue, 17 Nov 2026 14:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 649C9606B09D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XBlxhVYf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924669;
	bh=XHF6fbYR2e5DOlTVnhrZPCWPzn9uRL7X1zyWH2Iwktw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBlxhVYfDXvHeToIH8hvQly6Ikn7vWGXq3qtzRWPQyXUkCESQQ3n1t0nw9szqdUZu
	 06qFqxw6c2v9PY3V6zSvdgBDuEmbWNu4MqhtW17u55KQncecENnXdWBPEq3iKCc+v1
	 hSaPpjPauP4LmOVEQa/ua8Ev5mdQ/YYXLWcSG6/BWCvuw++F6P+deZU6i1rbBDaCXn
	 zQVMXjIkL/JIx3r1zljFMWiCCRo7Su9w5ugvoCY/qzonf1uJfg7V8+2jRIx9GDTB1h
	 dhj6u/CBfpOQOX+6GLZB3KZg6TuLB/L34X5P8Ao+875WjrnpbO9Djbhih2sU8CTRGI
	 cr2/1KK7uaItA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV51mpjzRHQ;
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
Subject: [PATCH v7 27/40] sched/deadline: Move a task's bandwidth to the root domain it runs in
Date: Tue, 17 Nov 2026 09:10:48 -0500
Message-Id: <3292905cac4b511f515b4d353f02a41d747b8015.1794922146.git.mathieu.desnoyers@efficios.com>
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
first. The rebuild of the accounting that follows counts the task.
dl_bw_rebuild_begin() opens this window in
partition_sched_domains_locked(). dl_rebuild_rd_accounting() closes it.

Move no bandwidth for a task blocked on a mutex while it is migrated.
Proxy execution queues such a task on the CPU of the mutex owner, which
can be in another root domain. The task does not run there. It goes
back when it is woken. proxy_set_task_cpu() does not call
migrate_task_rq_dl() today. A proxy execution fix makes it do so, as
set_task_cpu() does [1]. If the task then wakes up in another root
domain, the wake-up moves the bandwidth.

These cases of deadline_bw_test, added later in this series, fail
without this patch:
 - hotplug_fallback, hotplug_fallback_moved and
   hotplug_fallback_in_mask: a task woken on an isolated CPU stays
   counted in the housekeeping root domain.
 - no_admission_affinity_moves: without admission control, a task
   given an affinity of one isolated CPU stays counted in the
   housekeeping root domain.

This follows the Sashiko AI reviews of v4 and v5.

[1] https://lore.kernel.org/all/20261116192638.233125-5-mathieu.desnoyers@efficios.com/

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h |   1 +
 kernel/sched/deadline.c        | 152 ++++++++++++++++++++++++++++++---
 kernel/sched/topology.c        |   3 +
 3 files changed, 144 insertions(+), 12 deletions(-)

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
index 9ff79141c630..6c6a4d9cd054 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -304,6 +304,44 @@ static LIST_HEAD(dl_departed_list);
 static DEFINE_RAW_SPINLOCK(dl_departed_lock);
 static unsigned int dl_bw_gen;
 
+/*
+ * Odd while the sched domains are rebuilt: from before the first CPU
+ * leaves its root domain until the accounting is rebuilt. Meanwhile the
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
+/* Return true while the sched domains are rebuilt. */
+static inline bool dl_bw_rebuilding(void)
+{
+	return READ_ONCE(dl_bw_rebuild_seq) & 1;
+}
+
+/*
+ * Start a rebuild of the sched domains. Call it before the first CPU
+ * leaves its root domain. dl_rebuild_rd_accounting() ends the rebuild.
+ */
+void dl_bw_rebuild_begin(void)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+	guard(raw_spinlock_irqsave)(&dl_departed_lock);
+	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+}
+
+static void dl_bw_rebuild_end(void)
+{
+	guard(raw_spinlock_irqsave)(&dl_departed_lock);
+	WARN_ON_ONCE(!(dl_bw_rebuild_seq & 1));
+	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+}
+
 /*
  * The number of tasks with a bandwidth: those whose dl_bw is not 0. A
  * special entity and a server are not counted. __setparam_dl() and
@@ -2930,11 +2968,86 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
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
+ * domains differ. The rebuild of the accounting
+ * that follows counts @p.
+ */
+static bool dl_task_bw_elsewhere(struct task_struct *p, int cpu)
+{
+	int bw_cpu = READ_ONCE(p->dl.dl_bw_cpu);
+
+	if (bw_cpu < 0 || !p->dl.dl_bw || !cpu_active(cpu) || dl_bw_rebuilding())
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
+	if (cpu < 0 || dl_bw_rebuilding())
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
+	 *
+	 * Not for a task that is blocked on a mutex and only queued for
+	 * proxy execution. It does not run on the new CPU, so its bandwidth
+	 * stays in its root domain. If its wake-up then picks a CPU of another
+	 * root domain, the bandwidth moves at that time.
+	 */
+	if (unlikely(dl_task_bw_elsewhere(p, new_cpu)) &&
+	    !(p->is_blocked && task_on_rq_migrating(p)))
+		dl_task_move_bw(p, new_cpu);
+
 	if (READ_ONCE(p->__state) != TASK_WAKING)
 		return;
 
@@ -3597,6 +3710,15 @@ static void pull_dl_task(struct rq *this_rq)
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
@@ -3632,9 +3754,10 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3831,10 +3954,11 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
@@ -3906,8 +4030,8 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -4068,8 +4192,10 @@ void dl_rebuild_rd_accounting(void)
 	 * a resume run one for each CPU. A task gets a bandwidth under the
 	 * locks this rebuild holds, so the count cannot leave 0 meanwhile.
 	 */
-	if (!atomic_read(&dl_nr_bw_tasks))
+	if (!atomic_read(&dl_nr_bw_tasks)) {
+		dl_bw_rebuild_end();
 		return;
+	}
 
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
@@ -4083,6 +4209,7 @@ void dl_rebuild_rd_accounting(void)
 			dl_add_task_root_domain(p);
 	}
 	read_unlock(&tasklist_lock);
+	dl_bw_rebuild_end();
 }
 
 /*
@@ -4101,7 +4228,8 @@ void dl_clear_root_domains(void)
 	int cpu;
 
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
-	dl_bw_gen++;
+	/* dl_task_bw_elsewhere() reads it without the lock. */
+	WRITE_ONCE(dl_bw_gen, dl_bw_gen + 1);
 	for_each_possible_cpu(cpu) {
 		if (!dl_bw_visited(cpu, cookie))
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 35e56a45c238..9ec5f38afd28 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3430,6 +3430,9 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 		n = ndoms_new;
 	}
 
+	/* dl_rebuild_rd_accounting() ends it. */
+	dl_bw_rebuild_begin();
+
 	/* Destroy deleted domains: */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
-- 
2.47.3

