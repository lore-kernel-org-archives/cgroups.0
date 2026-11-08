Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164064;
	b=Jes1X6Yj4vz/QdU7jw22MDifD5qVd+10Qxh8Sj5QWHm6hTAHJd8Awn75tqA+UtaZi7tL
	 RBzFO4RsnTwZIEzOy8pgYgQr6eVNYLv7YjHoeh9o6lr3snh8p2Ug6JrtqRGOBPFBO14zR
	 gRIM1tb5KCFI7vlRqq/Lu17MU4PBLSxEKUjPLhhIOSbJ7VW/A/ocSkPWdkeIRK8YhnlBz
	 xjCY4PJbgt+7Fjf5LMj6ghGqejEyvaFbA8vcOP3ijxQZATNTAKZiFNT4oKsJHj6qFwrIb
	 3GvyyJC9vmGQsEJRuUbDq1MuhjWdkW25eYxkW5ldEJ9Jh1JrXcAQ2s+52XrU6x9G5bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164064;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IPff3Sq0mPJG1ZY9oxBGrKgAnCk/oWwG7AuTGqpXglw=;
	b=1gckRqilsOyd4mNr1EwSSPth1VWEIqFkV7y2Np2PrdQaJWAtH95fOcuCv9CaBEmfcsaj
	 T7vXT9Cndc1UK1g2hpAEv2QPeaI1U4OID1Vh9UYnzGKo6DKipBCNetoKZvluWxplgDpLg
	 8/c3ZeuyLAsTI3xTO9ukjbo8Vd2OlSgRs82Uvc29PST+P6AHqh6yBocs6j8T34ajFJr2g
	 fmDNGQC28dQ8spHPL871CwYnn8PmWZDPmOgzz8ujd8Nut7K8jl3M5fs3WX4qjj2cindRv
	 6rrcEJUtUHDb5MUN8kLAiTDwMk77/akAaXbGaHgWfDOpaHf0hq9RsZRAaz/YkzCU8nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KEfVRlDl;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF86082BC5;
	Sun,  8 Nov 2026 18:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BDF86082BC5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KEfVRlDl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164063;
	bh=IPff3Sq0mPJG1ZY9oxBGrKgAnCk/oWwG7AuTGqpXglw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEfVRlDltd0re9RxTUWBoZHpis2crRxTBqXPkltb1Eph2Yfz15OgKy6w4TzCCme8Z
	 /9hzFr9sny9c6TF7cIhPOD935C3Ig+e+TIUN2Ob//V1WZE4O/1x7N718+5djcacPg+
	 GXFOD2K2cBYOZtfsiG1k/7X8dLo0Dw0re7qDULqsGtzhy86FDWFKo1ho4CIsDJDKL5
	 qNdLkaph+okgQFCBoEuZ5smj6628GDXOgJXlxF5hP7kOBO/M7uDz+X/xQXZoi8L/N8
	 mx5/9ac0CCzBtwTo5fPytlipfdaHNEU99Lj7GhK3BB9kK8emugfaFy5AP9R+Sq9QhY
	 FPD/iDDn7qCCg==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C274FszMJy;
	Sun, 08 Nov 2026 13:54:22 -0500 (EST)
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
Subject: [PATCH v5 16/29] sched/deadline: Record the root domain holding a task's bandwidth
Date: Sun,  8 Nov 2026 13:53:53 -0500
Message-Id: <20261108185406.1549770-17-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

Admission, moves and releases of a deadline task's bandwidth find the
root domain that counts it from the CPU the task is on. That CPU can be
in another root domain. Two cases show it.

Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
migrating tasks between exclusive cpusets") moves a deadline task's
bandwidth in two halves. cpuset_can_attach() reserves it in the
destination. set_cpus_allowed_dl() frees it in the root domain of the
task's runqueue. Both halves now move nothing when that root domain
overlaps the destination. But a sleeping task stays on the CPU it last
ran on. So a sleeping task moved to a partition and back leaves its
bandwidth in the partition:

  admin                                       task T

  makes P a partition root of CPU 3
    CPU 3 is now in root domain B
    CPUs 0-2 are in root domain A
                                              sched_setattr(SCHED_DEADLINE)
                                                A: total_bw += bw of T
                                              runs on CPU 0, then sleeps
  echo T > P/cgroup.procs
    cpuset_can_attach()
      dl_task_needs_bw_move(): true,
      A does not overlap P
      B: total_bw += bw of T
    set_cpus_allowed_dl()
      dl_task_needs_bw_move(): true
      A: total_bw -= bw of T
                                              still asleep on CPU 0
  echo T > cgroup.procs of the root cgroup
    cpuset_can_attach()
      dl_task_needs_bw_move(): false,
      A overlaps the root cpuset
    set_cpus_allowed_dl()
      dl_task_needs_bw_move(): false
  kill -9 T
                                              wakes up on a CPU of A
                                              exits
                                                A: total_bw -= bw of T

B keeps the bandwidth of T. A does not count T while T is in A, so A
admits beyond its capacity. When T exits, A loses the bandwidth of T a
second time. Its total_bw can underflow.

A rebuild of the accounting counts a task in the root domain of its
cpuset. With admission control off, a task can be pinned to one CPU.
When that CPU goes offline, it joins the default root domain, and the
release takes the bandwidth from there. The root domain of the cpuset
keeps it until the next rebuild.

The first case was reproduced on v7.4-rc1. The second was reproduced
with the earlier patches of this series. Without "sched/deadline:
Release the bandwidth of a task that leaves the class asleep", nothing
releases the bandwidth of that sleeping task.

Fix this by recording, in dl_bw_cpu, a CPU of the root domain that
counts the bandwidth. Each site that counts it sets the record. Each
release or move reads it, and the release clears it. A move skips a
bandwidth of 0, so sched_dl_overflow() does not use its record. The
move_zero_bw case of deadline_bw_test, added later in this series, tests
this. The record replaces dl_departed_cpu. If dl_bw_gen shows that a
rebuild dropped the bandwidth, nothing is taken back.

A move now leaves out a sugov kthread and a task boosted into the class
with no bandwidth of its own. The rebuild leaves them out too: no root
domain counts theirs. A move would take a sugov kthread's bandwidth
from a root domain that never held it.

Weiheng Qiu reported the moved sleeper, and Juri Lelli analysed it. His
fix, linked below, took the first active CPU of the task's mask. A mask
can have none during CPU hotplug. Tip dropped the fix after a sugov
kthread hit its BUG_ON() there. The Sashiko AI reviews of this series
found the other cases.

Reported-by: Weiheng Qiu <weihengqiuu@gmail.com>
Closes: https://lore.kernel.org/all/14508cb2-805f-41ac-9f6b-bfd7c3d7cb1c@gmail.com/
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-1-dd761fe005b4@redhat.com/
Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |   9 +-
 kernel/sched/deadline.c | 227 +++++++++++++++++++++++++++-------------
 2 files changed, 162 insertions(+), 74 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8412fcedb03b..942d9acff203 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -755,14 +755,17 @@ struct sched_dl_entity {
 	 * time" keeps its bandwidth in its root domain until the inactive
 	 * timer removes it. Meanwhile, @dl_departed_node links the task on
 	 * the list that a rebuild of the root domains' accounting reads.
-	 * @dl_departed_cpu is a CPU of the root domain that counts the
-	 * bandwidth. Otherwise @dl_departed_cpu is -1.
+	 * Otherwise that node is empty.
+	 *
+	 * @dl_bw_cpu is a CPU of the root domain that counts the bandwidth,
+	 * or -1. Each site that counts the bandwidth sets it. Each site that
+	 * removes or moves the bandwidth reads it.
 	 *
 	 * @dl_bw_gen is the value of dl_bw_gen when the bandwidth was last
 	 * counted. If a rebuild dropped it since, there is nothing to remove.
 	 */
 	struct list_head		dl_departed_node;
-	int				dl_departed_cpu;
+	int				dl_bw_cpu;
 	unsigned int			dl_bw_gen;
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 62b96ce8c2a4..4b3713e192b9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -284,14 +284,17 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * dl_add_task_root_domain()) does not count such a task as a deadline
  * task. So dl_departed_list holds these tasks, from their departure to
  * their timer. The rebuild puts their bandwidth back in the root domain
- * of the CPU each one was on when it left.
+ * of the CPU recorded with each task's bandwidth.
  *
  * dl_bw_gen counts the rebuilds. Each task records its value when its
  * bandwidth is counted. If a rebuild dropped the bandwidth since, there
  * is nothing to remove. A rebuild drops it when the CPU recorded is no
  * longer active. It also drops the bandwidth of a task that dies while
  * the rebuild runs. The walk of the task list does not find that task,
- * and it was not dead yet when the list was put back.
+ * and it was not dead yet when the list was put back. The same happens
+ * to a task that priority inheritance deboosts while the rebuild runs.
+ * It was in the class when the list was put back, and out of it when the
+ * walk reaches it.
  *
  * dl_departed_lock protects the list and both counts. Take it with
  * interrupts disabled, under the task's rq lock or pi_lock or in the
@@ -302,20 +305,19 @@ static DEFINE_RAW_SPINLOCK(dl_departed_lock);
 static unsigned int dl_bw_gen;
 
 /*
- * Put @p on dl_departed_list with @cpu, a CPU of the root domain that
+ * Put @p on dl_departed_list. The root domain of the CPU recorded with it
  * keeps its bandwidth. @p leaves SCHED_DEADLINE, or dies, before its
  * 0-lag time. Do nothing if @p is on the list already. The caller holds
  * the rq lock of @p.
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
 
@@ -329,37 +331,39 @@ static void dl_task_undepart(struct task_struct *p)
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
  * Remove the bandwidth of @p from the root domain that counts it. That is
- * the root domain of the CPU recorded when @p departed, or else of @cpu.
+ * the root domain of the CPU recorded with @p. Clear the record.
  * Take @p off dl_departed_list. Remove nothing if a rebuild dropped the
  * bandwidth since it was counted. Then record the current dl_bw_gen in
  * @p, so that a rebuild in progress does not count it again. The caller
  * holds the rq lock of @p.
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
 
@@ -522,6 +526,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
 /*
  * Return the 0-lag time of @dl_se, relative to the clock of its runqueue.
@@ -631,7 +636,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				dl_task_release_bw(p, task_cpu(p));
+				dl_task_release_bw(p);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -645,12 +650,13 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 		get_task_struct(p);
 		/*
-		 * A dying task keeps its bandwidth in the root domain of the
-		 * CPU it runs on. Record that CPU. switched_from_dl() records
-		 * a task that leaves SCHED_DEADLINE.
+		 * A dying task keeps its bandwidth until its 0-lag time. Put
+		 * it on the departed list. The CPU recorded with its bandwidth
+		 * tells the root domain that counts it. switched_from_dl() does
+		 * the same for a task that leaves SCHED_DEADLINE.
 		 */
 		if (READ_ONCE(p->__state) == TASK_DEAD)
-			dl_task_depart(p, task_cpu(p));
+			dl_task_depart(p);
 	}
 
 	hrtimer_start(timer, ns_to_ktime(zerolag_time), HRTIMER_MODE_REL_HARD);
@@ -888,19 +894,31 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	}
 
 	/*
-	 * And we finally need to fix up root_domain(s) bandwidth accounting,
-	 * since p is still hanging out in the old (now moved to default) root
-	 * domain.
+	 * And we finally need to fix up root_domain(s) bandwidth accounting.
+	 * The bandwidth of @p is counted in the root domain of the CPU
+	 * recorded with it. That is not the root domain of @rq if @p was
+	 * moved to another cpuset while it was not running. If a rebuild
+	 * dropped the bandwidth, there is nothing to move: the next rebuild
+	 * counts it.
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
@@ -2378,7 +2396,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 			dl_se->dl_non_contending = 0;
 		}
 
-		dl_task_release_bw(p, task_cpu(p));
+		dl_task_release_bw(p);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3526,14 +3544,25 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	}
 }
 
+/*
+ * Return a CPU of the root domain that counts the bandwidth of @p: the
+ * CPU recorded with it. Without a record, no root domain counts that
+ * bandwidth. Return the CPU @p is on then.
+ */
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
+{
+	int cpu = p->dl.dl_bw_cpu;
+
+	if (cpu < 0)
+		return task_cpu(p);
+	return cpu;
+}
+
 static void set_cpus_allowed_dl(struct task_struct *p,
 				struct affinity_context *ctx)
 {
-	struct rq *rq;
-
 	WARN_ON_ONCE(!dl_task(p));
 
-	rq = task_rq(p);
 	/*
 	 * Migrating a SCHED_DEADLINE task between exclusive
 	 * cpusets (different root_domains) entails a bandwidth
@@ -3541,17 +3570,29 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * domain (see cpuset_can_attach()).
 	 */
 	if (dl_task_needs_bw_move(p, ctx->new_mask)) {
-		struct dl_bw *src_dl_b;
+		unsigned int src_cpu = dl_task_root_domain_cpu(p);
+		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
+		unsigned int cpu;
 
-		src_dl_b = dl_bw_of(cpu_of(rq));
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
+		 * cpuset_can_attach() made room in the root domain of the new
+		 * mask. That root domain counts the bandwidth from now on.
 		 */
-		raw_spin_lock(&src_dl_b->lock);
-		__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
-		raw_spin_unlock(&src_dl_b->lock);
+		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
+		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_cpus_allowed_common(p, ctx);
@@ -3560,10 +3601,18 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 bool dl_task_needs_bw_move(struct task_struct *p,
 			   const struct cpumask *new_mask)
 {
-	if (!dl_task(p))
+	unsigned int cpu;
+
+	/*
+	 * Nothing to move for a special entity, or for a task boosted into
+	 * the class with no bandwidth of its own. No root domain counts
+	 * their bandwidth: dl_add_task_root_domain() leaves them out.
+	 */
+	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
 		return false;
 
-	return !cpumask_intersects(task_rq(p)->rd->span, new_mask);
+	cpu = dl_task_root_domain_cpu(p);
+	return !cpumask_intersects(cpu_rq(cpu)->rd->span, new_mask);
 }
 
 /* Assumes rq->lock is held */
@@ -3639,7 +3688,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 * Count nothing for a special entity, or for a task with no
 	 * bandwidth. The walk of the task list also finds exited tasks. An
 	 * exited task whose bandwidth went with its parameters has a dl_bw
-	 * of 0.
+	 * of 0. So has a task boosted into the class with no bandwidth of
+	 * its own, which gets no record.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
@@ -3663,7 +3713,9 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 */
 	if (p->dl.dl_bw_gen == dl_bw_gen)
 		goto unlock;
-	if (p->dl.dl_departed_cpu >= 0) {
+	if (!list_empty(&p->dl.dl_departed_node)) {
+		int recorded = p->dl.dl_bw_cpu;
+
 		/*
 		 * The walk also finds a dead task that departed before an
 		 * earlier rebuild, if it is not reaped yet. If that rebuild
@@ -3672,9 +3724,9 @@ void dl_add_task_root_domain(struct task_struct *p)
 		 */
 		if (p->dl.dl_bw_gen != dl_bw_gen - 1)
 			goto unlock;
-		cpu = p->dl.dl_departed_cpu;
-		if (!cpu_active(cpu))
+		if (recorded < 0 || !cpu_active(recorded))
 			goto unlock;
+		cpu = recorded;
 	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
@@ -3682,6 +3734,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -3821,7 +3874,7 @@ void dl_clear_root_domains(void)
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
 	}
 	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
-		cpu = dl_se->dl_departed_cpu;
+		cpu = dl_se->dl_bw_cpu;
 		/*
 		 * Skip bandwidth that an earlier rebuild dropped. It is not
 		 * counted now, and its release removes nothing
@@ -3829,7 +3882,7 @@ void dl_clear_root_domains(void)
 		 */
 		if (dl_se->dl_bw_gen != dl_bw_gen - 1)
 			continue;
-		if (!cpu_active(cpu))
+		if (cpu < 0 || !cpu_active(cpu))
 			continue;
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
@@ -3908,7 +3961,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * parameters of its own, has no bandwidth in total_bw.
 			 * Neither has a special task.
 			 */
-			dl_task_release_bw(p, task_cpu(p));
+			dl_task_release_bw(p);
 			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
@@ -3932,15 +3985,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * For the same reason, the timer cannot take the task's bandwidth
 	 * from the root domain of the CPU the task is on by then. And a
 	 * rebuild of the root domains meanwhile would not find the task
-	 * among the deadline tasks. So record a CPU of the root domain that
-	 * keeps the bandwidth until the timer removes it (dl_task_depart()).
+	 * among the deadline tasks. So put the task on the departed list
+	 * until the timer removes the bandwidth (dl_task_depart()). The CPU
+	 * recorded with the bandwidth tells the root domain that keeps it.
 	 * Test dl_non_contending: it tells that the timer is armed and its
 	 * handler has not run. hrtimer_active() stays true for a while after
 	 * the handler returns.
 	 */
 	if (p->dl.dl_non_contending) {
 		p->dl.dl_non_contending = 0;
-		dl_task_depart(p, task_cpu(p));
+		dl_task_depart(p);
 	}
 
 	/*
@@ -3966,12 +4020,13 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	 * boosts it back into the class before its 0-lag time. (A policy change
 	 * took it off the list in sched_dl_overflow().) The inactive timer no
 	 * longer removes its bandwidth: the task does when it leaves the class
-	 * again. So take it off the list. If the task moved to another root
-	 * domain meanwhile, it then takes the bandwidth from that root domain
-	 * instead.
+	 * again. So take it off the list. The task keeps the CPU recorded. It
+	 * takes the bandwidth from the root domain of that CPU, even if it
+	 * moved to another root domain meanwhile. A rebuild while it is
+	 * boosted counts it like any deadline task, and records the CPU it
+	 * picks.
 	 */
-	if (p->dl.dl_departed_cpu >= 0)
-		dl_task_undepart(p);
+	dl_task_undepart(p);
 
 	/* If p is not queued we will update its parameters at next wakeup. */
 	if (!task_on_rq_queued(p)) {
@@ -4178,9 +4233,10 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4189,6 +4245,23 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
 		return 0;
 
+	/*
+	 * Change the bandwidth of a deadline task where it is counted: in
+	 * the root domain of the CPU recorded with it. A task moved asleep
+	 * has not run there yet, so the CPU it is on can be elsewhere. No
+	 * bandwidth is counted if a rebuild dropped it, or if the task
+	 * enters the class. A runtime below about a millionth of the period
+	 * gives a bandwidth of 0. It counts for nothing, and no move updates
+	 * its record. In these three cases, the root domain of the CPU the
+	 * task is on takes the new bandwidth. The caller holds cpuset_mutex,
+	 * or dl_accounting_mutex without cpusets, so no rebuild runs
+	 * meanwhile.
+	 */
+	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
+		  p->dl.dl_bw_gen == dl_bw_gen;
+	cpu = counted && p->dl.dl_bw ? p->dl.dl_bw_cpu : task_cpu(p);
+	dl_b = dl_bw_of(cpu);
+
 	/*
 	 * Either if a task, enters, leave, or stays -deadline but changes
 	 * its parameters, we may need to update accordingly the total
@@ -4203,7 +4276,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, counted ? p->dl.dl_bw : 0,
+				  new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4211,7 +4285,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		 * But this would require to set the task's "inactive
 		 * timer" when the task is not inactive.
 		 */
-		__dl_sub(dl_b, p->dl.dl_bw, cpus);
+		if (counted)
+			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		dl_change_utilization(p, new_bw);
 		err = 0;
@@ -4232,11 +4307,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 * No rebuild can run meanwhile: the caller holds cpuset_mutex, or
 	 * dl_accounting_mutex without cpusets.
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
+			 * The new bandwidth replaces any the task still has
+			 * counted. That one may be on the departed list, or
+			 * taken off it by a boost into the class
+			 * (switched_to_dl()). The record says where it is.
+			 */
+			if (p->dl.dl_bw_cpu >= 0)
+				dl_task_release_bw(p);
+		}
+		p->dl.dl_bw_cpu = cpu;
 		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
@@ -4377,7 +4461,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
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

