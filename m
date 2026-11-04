Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826737;
	b=pKucY8bwyWDdTITaoMVY4ZYgxaaP3zm+4ltd1s017TJqwjk5SAVA+9/QdRl4+hdQWT5T
	 7u+iGyNfzRYQCI1vpbU+lY/dMTOkUSjHaGu1mtTQJ1/IvGNSa5Hv2XL+0HUlayDYcJcPI
	 KehYKTLJHK+/8IuyMoKGqCIgkKe+XDWiLcemR1sPcdlbfpH9oPEQ7tndDyPIbrRivEV2n
	 kqxysokheECjs7OsywRI7vbZPtTytjQiZMJBr8l2vYdJ67Jd+wCzJyt7Fu62O/YdbjbPa
	 n6LcyffYMkz9wKbNHPwgkugVrbD4N30TOCl7PJDbSNExBe5Fn7wMaYhGwVxKa0jGRBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826737;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ntpA+m6DJ01doX9aY3FKcBjSCGpfdIjb06X7YPYzvKQ=;
	b=G0iq0g4DYe8dEthrqs8Z3yELCjWI1EFUFxIYIx01qaOzXnDBCKend8AmE11K0GYuD3Wx
	 9dWl82Rn/63iPv31leYN4i0yiiqjdLFF6y+8/M8AWDKOhLOkxenq/1N57irW0678L3TBf
	 3zIur+MssOmeocbUHdcRkL/fr0qsaIu086vU4E0EKFjXh4ulSqh7eDIkAHoMiAd3lWxQk
	 zLvb8bQfh24shWt9gk1k0iyNFuuiH6alZDxQab1eiR3VI7LP7AeUNfpjVFQ2sNSko4Kz1
	 aC+ZBGiYDVbG4fk5jXSOIWnfJ5nsj3/DIfqFoq+HjSijrRB4hm75RdTa4tSUnAVbHNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UpR3XfX6;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2847660820A9;
	Wed,  4 Nov 2026 21:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2847660820A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UpR3XfX6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826735;
	bh=ntpA+m6DJ01doX9aY3FKcBjSCGpfdIjb06X7YPYzvKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpR3XfX6yjfw4aL41CZLVdmi58f6Fs1YSoolzsZX19BySkadPlFfNPHPsWQlQs11H
	 jZ8zkSCC8r4vn5ocITfZC/OiD6VAt7ZsiDIMBtZA24J6ifdXa2om7fjqEkMndapeMl
	 U7PMrr01b8QxEG4QR3GSvJP53swQk7FF2hm3Odh1QhRs10TvKaZz4n3xtZKJHOmvJH
	 kId2J9l+WrpwsjQOiglJFyM3/4A8S02dVeHnNyP2IQndEOQwQno+L06QcC50QRLLur
	 rrqOVho2hw/QL0JwWdl7ugtxkr8fZYNJ2VCbxRCAt7TEK90b+KTRxMYGZW0Z6tmQCu
	 Z/DVsbBBfdo8Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRy6tw3zLXf;
	Wed, 04 Nov 2026 16:12:14 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 15/21] sched/deadline: Record the root domain holding a task's bandwidth
Date: Wed,  4 Nov 2026 16:12:01 -0500
Message-Id: <20261104211207.1392343-16-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

Three answers to "which root domain counts this task's bandwidth" live
side by side:

 - admission takes the root domain of the CPU the task is on,
   sched_dl_overflow() through dl_bw_of(task_cpu(p));
 - a rebuild of the accounting takes the one of the task's cpuset,
   dl_add_task_root_domain() through dl_get_task_effective_cpus();
 - a release and a move take the one of the first active CPU of the
   task's own mask, dl_task_root_domain_cpu().

They agree while the task's mask, its cpuset and the CPU it last ran on
belong to one root domain, and part ways where they do not: a task
pinned to a CPU that goes offline, which admission control off allows,
has its bandwidth put by the rebuild in the root domain of its cpuset
while its mask has no active CPU and the CPU it is on belongs to the
default root domain; a sleeping task moved to another partition has it
in the destination's root domain while the CPU it last ran on is in the
one it left. The release then takes the bandwidth from a root domain
that never had it, which underflows, and leaves it in the one that has
it.

Record the CPU instead. Every site that hands bandwidth to a task
records a CPU of the root domain that counts it, in the entity:
admission, the rebuild, the move between root domains of
set_cpus_allowed_dl() (whose room was made by cpuset_can_attach()), and
the move of dl_task_offline_migration(). Every site that takes it back
or moves it reads that CPU, and the release clears it. Where dl_bw_gen
says a rebuild dropped the bandwidth of a task, a change of its
parameters and a move take nothing back, and record where the new
bandwidth is for the next rebuild. The mask is no longer consulted, so
dl_task_root_domain_cpu() has nothing left to guess and nothing to fall
back on but the CPU of a task whose bandwidth is counted nowhere.

The record is also what the departed list of "sched/deadline: Keep
departing bandwidth across a root domain rebuild" needs, which carried
a CPU of its own until here, and a task boosted back into the class
keeps it now, where dropping it left the release to the mask again.

Found by the Sashiko AI review of the first posting of this series,
which pointed at the fallback of "sched/deadline: Do not BUG() on a
deadline task with no active CPU allowed" pointing at a root domain that
rebuild had not credited. A review of this patch found the two sites
that kept taking the root domain of the CPU the task is on: the change
of parameters of sched_dl_overflow(), and the move of
dl_task_offline_migration().

Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  20 +++--
 kernel/sched/deadline.c | 167 +++++++++++++++++++++++++++-------------
 2 files changed, 124 insertions(+), 63 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6803df5ab13c..da3a3a4f7246 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -736,17 +736,21 @@ struct sched_dl_entity {
 	struct hrtimer			inactive_timer;
 
 	/*
+	 * @dl_bw_cpu is a CPU of the root domain that counts @dl_bw, -1
+	 * where none does: every site that hands that bandwidth out records
+	 * it, and every site that takes it back or moves it reads it.
+	 * @dl_bw_gen is the rebuild of the root domains' accounting that
+	 * last counted it: one since then dropped it, and there is nothing
+	 * to take back.
+	 *
 	 * A task that leaves SCHED_DEADLINE, or dies, before its "0-lag
-	 * time" keeps its bandwidth in its root domain until the inactive
-	 * timer removes it. @dl_departed_cpu is then a CPU of the root domain
-	 * that counts that bandwidth, and @dl_departed_node links it on the
-	 * list that a rebuild of the root domains' accounting puts that
-	 * bandwidth back from; -1 otherwise. @dl_bw_gen is the
-	 * rebuild that last counted the task's bandwidth: one since then
-	 * dropped it, and nothing is to be removed.
+	 * time" keeps its bandwidth until the inactive timer removes it:
+	 * @dl_departed_node links it meanwhile on the list that a rebuild
+	 * puts that bandwidth back from, and tells of that by not being
+	 * empty.
 	 */
 	struct list_head		dl_departed_node;
-	int				dl_departed_cpu;
+	int				dl_bw_cpu;
 	unsigned int			dl_bw_gen;
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 85df2b0044be..1dbde0fd199b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -252,15 +252,14 @@ static unsigned int dl_bw_gen;
  * @p leaves SCHED_DEADLINE, or dies, its bandwidth kept for now in the root
  * domain of @cpu. Under its rq lock.
  */
-static void dl_task_depart(struct task_struct *p, int cpu)
+static void dl_task_depart(struct task_struct *p)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 
 	lockdep_assert_irqs_disabled();
-	if (dl_se->dl_departed_cpu >= 0)
-		return;
 	guard(raw_spinlock)(&dl_departed_lock);
-	dl_se->dl_departed_cpu = cpu;
+	if (!list_empty(&dl_se->dl_departed_node) || dl_se->dl_bw_cpu < 0)
+		return;
 	list_add(&dl_se->dl_departed_node, &dl_departed_list);
 }
 
@@ -273,9 +272,10 @@ static void dl_task_undepart(struct task_struct *p)
 	struct sched_dl_entity *dl_se = &p->dl;
 
 	lockdep_assert_irqs_disabled();
+	if (list_empty(&dl_se->dl_departed_node))
+		return;
 	guard(raw_spinlock)(&dl_departed_lock);
-	dl_se->dl_departed_cpu = -1;
-	list_del(&dl_se->dl_departed_node);
+	list_del_init(&dl_se->dl_departed_node);
 }
 
 /*
@@ -284,24 +284,25 @@ static void dl_task_undepart(struct task_struct *p)
  * when a rebuild of the accounting has dropped it; and no rebuild running
  * counts it again. Under @p's rq lock.
  */
-static void dl_task_release_bw(struct task_struct *p, int cpu)
+static void dl_task_release_bw(struct task_struct *p)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 	struct dl_bw *dl_b;
+	int cpu;
 
 	lockdep_assert_irqs_disabled();
 	guard(raw_spinlock)(&dl_departed_lock);
-	if (dl_se->dl_departed_cpu >= 0) {
-		cpu = dl_se->dl_departed_cpu;
-		dl_se->dl_departed_cpu = -1;
-		list_del(&dl_se->dl_departed_node);
-	}
-	if (dl_se->dl_bw_gen == dl_bw_gen) {
+	if (!list_empty(&dl_se->dl_departed_node))
+		list_del_init(&dl_se->dl_departed_node);
+	cpu = dl_se->dl_bw_cpu;
+	WARN_ON_ONCE(dl_se->dl_bw && cpu < 0);
+	if (cpu >= 0 && dl_se->dl_bw_gen == dl_bw_gen) {
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
 		__dl_sub(dl_b, dl_se->dl_bw, dl_bw_cpus(cpu));
 		raw_spin_unlock(&dl_b->lock);
 	}
+	dl_se->dl_bw_cpu = -1;
 	dl_se->dl_bw_gen = dl_bw_gen;
 }
 
@@ -460,6 +461,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
 /*
  * The utilization of a task cannot be immediately removed from
@@ -560,7 +562,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				if (READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				dl_task_release_bw(p, task_cpu(p));
+				dl_task_release_bw(p);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -579,7 +581,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 		 * SCHED_DEADLINE.
 		 */
 		if (READ_ONCE(p->__state) == TASK_DEAD)
-			dl_task_depart(p, task_cpu(p));
+			dl_task_depart(p);
 	}
 
 	hrtimer_start(timer, ns_to_ktime(zerolag_time), HRTIMER_MODE_REL_HARD);
@@ -817,19 +819,30 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	}
 
 	/*
-	 * And we finally need to fix up root_domain(s) bandwidth accounting,
-	 * since p is still hanging out in the old (now moved to default) root
-	 * domain.
+	 * And we finally need to fix up root_domain(s) bandwidth accounting:
+	 * the bandwidth of @p is counted in the root domain that took it,
+	 * which is not the one of the runqueue it leaves if it was moved
+	 * asleep. A rebuild that dropped it has nothing here to move, and
+	 * the record left behind is what makes the next one count it.
 	 */
-	dl_b = &rq->rd->dl_bw;
-	raw_spin_lock(&dl_b->lock);
-	__dl_sub(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
-	raw_spin_unlock(&dl_b->lock);
-
-	dl_b = &later_rq->rd->dl_bw;
-	raw_spin_lock(&dl_b->lock);
-	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(later_rq->rd->span));
-	raw_spin_unlock(&dl_b->lock);
+	scoped_guard (raw_spinlock, &dl_departed_lock) {
+		if (p->dl.dl_bw_gen == dl_bw_gen) {
+			struct rq *src_rq = cpu_rq(dl_task_root_domain_cpu(p));
+
+			dl_b = &src_rq->rd->dl_bw;
+			raw_spin_lock(&dl_b->lock);
+			__dl_sub(dl_b, p->dl.dl_bw,
+				 cpumask_weight(src_rq->rd->span));
+			raw_spin_unlock(&dl_b->lock);
+
+			dl_b = &later_rq->rd->dl_bw;
+			raw_spin_lock(&dl_b->lock);
+			__dl_add(dl_b, p->dl.dl_bw,
+				 cpumask_weight(later_rq->rd->span));
+			raw_spin_unlock(&dl_b->lock);
+		}
+		p->dl.dl_bw_cpu = later_rq->cpu;
+	}
 
 	set_task_cpu(p, later_rq->cpu);
 	double_unlock_balance(later_rq, rq);
@@ -2312,7 +2325,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 			dl_se->dl_non_contending = 0;
 		}
 
-		dl_task_release_bw(p, task_cpu(p));
+		dl_task_release_bw(p);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3475,11 +3488,14 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
  */
 static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
 {
-	unsigned int cpu;
+	int cpu = p->dl.dl_bw_cpu;
 
-	cpu = cpumask_first_and(&p->cpus_mask, cpu_active_mask);
-	if (cpu >= nr_cpu_ids)
-		cpu = task_cpu(p);
+	/*
+	 * No bandwidth of @p's counted anywhere: nothing to take back or to
+	 * move, and the CPU it is on answers for its root domain.
+	 */
+	if (cpu < 0)
+		return task_cpu(p);
 	return cpu;
 }
 
@@ -3497,15 +3513,28 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	if (dl_task_needs_bw_move(p, ctx->new_mask)) {
 		unsigned int src_cpu = dl_task_root_domain_cpu(p);
 		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
+		unsigned int cpu;
 
 		/*
 		 * We now free resources of the root_domain we are migrating
 		 * off. In the worst case, sched_setattr() may temporary fail
-		 * until we complete the update.
+		 * until we complete the update. A rebuild that dropped the
+		 * bandwidth of @p leaves nothing to free.
+		 */
+		if (p->dl.dl_bw_gen == dl_bw_gen) {
+			raw_spin_lock(&src_dl_b->lock);
+			__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(src_cpu));
+			raw_spin_unlock(&src_dl_b->lock);
+		}
+
+		/*
+		 * The room in the root domain of the mask to come was made
+		 * by cpuset_can_attach(): that one counts the bandwidth from
+		 * here on.
 		 */
-		raw_spin_lock(&src_dl_b->lock);
-		__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(src_cpu));
-		raw_spin_unlock(&src_dl_b->lock);
+		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
+		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_cpus_allowed_common(p, ctx);
@@ -3614,10 +3643,12 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 */
 	if (p->dl.dl_bw_gen == dl_bw_gen)
 		goto unlock;
-	if (p->dl.dl_departed_cpu >= 0) {
-		cpu = p->dl.dl_departed_cpu;
-		if (!cpu_active(cpu))
+	if (!list_empty(&p->dl.dl_departed_node)) {
+		int recorded = p->dl.dl_bw_cpu;
+
+		if (recorded < 0 || !cpu_active(recorded))
 			goto unlock;
+		cpu = recorded;
 	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
@@ -3625,6 +3656,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -3754,7 +3786,7 @@ void dl_clear_root_domains(void)
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
 	}
 	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
-		cpu = dl_se->dl_departed_cpu;
+		cpu = dl_se->dl_bw_cpu;
 		/*
 		 * Counted in the generation that ends here, and nowhere
 		 * since: one a rebuild dropped, for want of an active CPU to
@@ -3763,7 +3795,7 @@ void dl_clear_root_domains(void)
 		 */
 		if (dl_se->dl_bw_gen != dl_bw_gen - 1)
 			continue;
-		if (!cpu_active(cpu))
+		if (cpu < 0 || !cpu_active(cpu))
 			continue;
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
@@ -3820,7 +3852,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * nor for a special one: neither has bandwidth in
 			 * total_bw.
 			 */
-			dl_task_release_bw(p, dl_task_root_domain_cpu(p));
+			dl_task_release_bw(p);
 			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
@@ -3861,7 +3893,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 */
 	if (p->dl.dl_non_contending) {
 		p->dl.dl_non_contending = 0;
-		dl_task_depart(p, dl_task_root_domain_cpu(p));
+		dl_task_depart(p);
 	}
 
 	/*
@@ -3890,8 +3922,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	 * the task then removes the bandwidth from that one, as it did
 	 * before departures were recorded.
 	 */
-	if (p->dl.dl_departed_cpu >= 0)
-		dl_task_undepart(p);
+	dl_task_undepart(p);
 
 	/*
 	 * In case a task is setscheduled to SCHED_DEADLINE we need to keep
@@ -4104,9 +4135,10 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	u64 period = attr->sched_period ?: attr->sched_deadline;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
-	int cpus, err = -1, cpu = task_cpu(p);
-	struct dl_bw *dl_b = dl_bw_of(cpu);
+	int cpus, err = -1, cpu;
+	struct dl_bw *dl_b;
 	unsigned long cap;
+	bool counted;
 
 	if (attr->sched_flags & SCHED_FLAG_SUGOV)
 		return 0;
@@ -4115,6 +4147,19 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
 		return 0;
 
+	/*
+	 * The bandwidth of a task of the class is counted in the root
+	 * domain that took it, which the CPU the task is on does not tell:
+	 * moved asleep, it has not run there yet. Change it where it is
+	 * counted; a rebuild that dropped it, and a task that enters the
+	 * class, have the root domain of that CPU take the new one. The
+	 * caller holds cpuset_mutex, so no rebuild runs meanwhile.
+	 */
+	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
+		  p->dl.dl_bw_gen == dl_bw_gen;
+	cpu = counted ? p->dl.dl_bw_cpu : task_cpu(p);
+	dl_b = dl_bw_of(cpu);
+
 	/*
 	 * Either if a task, enters, leave, or stays -deadline but changes
 	 * its parameters, we may need to update accordingly the total
@@ -4129,7 +4174,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, counted ? p->dl.dl_bw : 0,
+				  new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4137,7 +4183,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		 * But this would require to set the task's "inactive
 		 * timer" when the task is not inactive.
 		 */
-		__dl_sub(dl_b, p->dl.dl_bw, cpus);
+		if (counted)
+			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		dl_change_utilization(p, new_bw);
 		err = 0;
@@ -4157,11 +4204,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 * domain that keeps it (dl_task_release_bw()). A rebuild cannot
 	 * run meanwhile: the caller holds cpuset_mutex.
 	 */
-	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
-		lockdep_assert_cpuset_lock_held();
-		lockdep_assert_dl_accounting_held();
-		if (p->dl.dl_departed_cpu >= 0)
-			dl_task_release_bw(p, -1);
+	if (!err && dl_policy(policy)) {
+		if (!task_has_dl_policy(p)) {
+			lockdep_assert_cpuset_lock_held();
+			lockdep_assert_dl_accounting_held();
+			/*
+			 * Whatever bandwidth the task still has counted
+			 * somewhere, the new one replaces: on the departed
+			 * list, or taken off it by a boost into the class
+			 * (switched_to_dl()), the record says where.
+			 */
+			if (p->dl.dl_bw_cpu >= 0)
+				dl_task_release_bw(p);
+		}
+		p->dl.dl_bw_cpu = cpu;
 		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
@@ -4301,7 +4357,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	init_dl_task_timer(dl_se);
 	init_dl_inactive_task_timer(dl_se);
 	__dl_clear_params(dl_se);
-	dl_se->dl_departed_cpu = -1;
+	dl_se->dl_bw_cpu = -1;
+	INIT_LIST_HEAD(&dl_se->dl_departed_node);
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
-- 
2.47.3

