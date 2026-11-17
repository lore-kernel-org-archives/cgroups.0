Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924675;
	b=nzDM8e9zqsrX50X/EBZhWRdb+OhrH2BH+usygOnV9YmxQ1l9AuKapggD+f/fvjQS4vBd
	 7myEgEU+BWfgxaeTUbL1lT6cVNO6CuGya+uu84ImIAaHSm8MeVtqGvZro81x1AJK3aDzO
	 Zmkja7psaqJYDIOJbNg31W3L41L94PCwm1wvOKhq2QWQiQRmIGTzXjqx7L3AmwPAaYW3S
	 FvnWMVKvS2j0tsDXKlEEJlbdZnMk2BovEHCH+GKbfAEmY7iQWhdw+kf1kewR3kZ6GRIfq
	 TYL5nmOeG/iNERhAkyhSkmX/CNqCoUZrpbOct5P+lA7OGpp4xjw+u0LLB/c5kumMqlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924675;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5wt9cdL65XSjBKiu1SsRg1YB9uWtBbPpJAu+VSaRnSs=;
	b=qCtLjq+HcAmUfKdGrn7Yo1acwkOEOOBwq8sB5rMPUhv8KWfEChBj7M1fqJcT9Okt/+a4
	 Li/lE3OuyloC1dFzo3aYBgmdN47xuRlVwQaYkhqzwnprdDsBnrzz90fxvitF9SCjdgf9j
	 rEKCjobkbP8J+za4w2fSuWiVgkH6G420uw2vwFRehBZS+h3zrCqLVqYVcse7jz8UmIYdO
	 dVVMeaqUK9FWSSE7kvFsg36gvJ/Yhy9y0MpYJyJvEnBhPoEzi2jg1awFSn/fSIRj84lOl
	 YQ17AoKw0JysrkrlS2CiE8l7592Q7aYXUpF68psgoBa7EiM2TAP/kxMfzn2osPXKTrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NiX7Wlfo;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2460A3819;
	Tue, 17 Nov 2026 14:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9C2460A3819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NiX7Wlfo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924667;
	bh=5wt9cdL65XSjBKiu1SsRg1YB9uWtBbPpJAu+VSaRnSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiX7Wlfo2keP9TXFinPHdv6JKJepC9GhAsEjOJvwQM/xeAXI0Vk5krjlK6gJI1XH5
	 mEtRt1njdwkecU3XD0WZHS5p/WRXLAPLewjCWDpQg07fbR6Z/NwvaW6KUlGzMdKplm
	 MTAdhkFYLqgmQdT17PTBP+2ReHIG5DTw69dp3394nAFaiyhSnyX8s72cN0D6/K1T/K
	 oXKOtEjOLpMPY22H0IfS8YJ/ApoSi+up7A6k4pL+pBCxzhw1ihjnwHIkn2bZmQjzdt
	 Ze7iui1LTgJ9F0GjF9tJ1htS30jKt89wT0jUzwAdLXGP+kpIrB8hZKmoLF1m+Tgxt+
	 3NfGT9YI1fU2g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV34WRNzRTM;
	Tue, 17 Nov 2026 09:11:07 -0500 (EST)
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
Subject: [PATCH v7 18/40] sched/deadline: Record the root domain holding a task's bandwidth
Date: Tue, 17 Nov 2026 09:10:39 -0500
Message-Id: <81044090393551a0c264a8f3a7d1c3c22321c395.1794922146.git.mathieu.desnoyers@efficios.com>
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

Admission, moves and releases of a deadline task's bandwidth find the
root domain that counts it from the CPU the task is on. That CPU can be
in another root domain. Two cases show it.

Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
migrating tasks between exclusive cpusets") moves a deadline task's
bandwidth in two halves. cpuset_can_attach() reserves it in the
destination. set_cpus_allowed_dl() frees it in the root domain of the
task's runqueue. Since commit 5dd74441cbf4 ("cgroup/cpuset: Reserve DL
bandwidth only for root-domain moves"), both halves move nothing when
that root domain overlaps the destination. But a sleeping task stays on
the CPU it last ran on. So a sleeping task moved to a partition and back
leaves its bandwidth in the partition:

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
admits beyond its capacity. After T exits, the total_bw of A is short
by the bandwidth of T, and can underflow.

The second case needs no move:

 1. A deadline task T sleeps on a CPU of root domain A.
 2. That CPU goes offline, and joins the default root domain.
 3. The rebuild counts T in A, the root domain of its cpuset.
 4. sched_setattr() takes the sleeping T out of SCHED_DEADLINE.
 5. The release takes the bandwidth from the root domain of the CPU T
    is on: the default one.

A keeps the bandwidth of T until the next rebuild, and refuses deadline
tasks that would fit.

The first case was reproduced on v7.4-rc2. The second needs the earlier
patches of this series: without "sched/deadline: Release the bandwidth
of a task that leaves the class asleep", nothing releases the bandwidth
of that sleeping task. The hotplug_sleeper_switched case of
deadline_bw_test, added later in this series, tests it. Without this
patch and with the CPU still offline, A admitted 63 tasks of 10% where
it had room for 66, in 3 guests of 3.

Fix this by recording, in dl_bw_cpu, a CPU of the root domain that
counts the bandwidth. The record replaces dl_departed_cpu. It is used
as follows:
- Each site that counts the bandwidth sets the record.
- Each release or move reads it. The release clears it.
- If dl_bw_gen shows that a rebuild dropped the bandwidth, nothing is
  taken back. set_cpus_allowed_dl() makes that test under
  dl_departed_lock, so that a rebuild cannot change dl_bw_gen
  meanwhile.
- A move skips a bandwidth of 0, and does not update its record. So
  sched_dl_overflow() uses the CPU the task is on for it. The
  move_zero_bw case of deadline_bw_test, added later in this series,
  tests this.
- A rebuild drops departed bandwidth whose CPU is inactive. So a
  departing task records the CPU it departs from, if that CPU is
  active and in the same root domain.

The affinity check of sched_setaffinity() reads the record too. A task
moved asleep is still on a CPU of the root domain it left. Testing that
root domain let a new mask take the task out of the one that counts it.
The affinity_moved_asleep case tests this.

A move now leaves out a sugov kthread and a task boosted into the class
with no bandwidth of its own. The rebuild leaves them out too: no root
domain counts theirs. A move would take a sugov kthread's bandwidth
from a root domain that never held it.

Weiheng Qiu reported the moved sleeper, and Juri Lelli analysed it. His
fix, linked below, took the first active CPU of the task's mask. A mask
can have none during CPU hotplug. Tip dropped the fix after a sugov
kthread hit its BUG_ON() there. The Sashiko AI reviews of this series
found the other cases.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Reported-by: Weiheng Qiu <weihengqiuu@gmail.com>
Closes: https://lore.kernel.org/all/14508cb2-805f-41ac-9f6b-bfd7c3d7cb1c@gmail.com/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-1-dd761fe005b4@redhat.com/
---
 include/linux/sched.h   |  10 +-
 kernel/sched/deadline.c | 247 +++++++++++++++++++++++++++-------------
 kernel/sched/syscalls.c |  11 +-
 3 files changed, 187 insertions(+), 81 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33e2d9492aa2..4a1cb869facc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -750,15 +750,17 @@ struct sched_dl_entity {
 	 * time" keeps its bandwidth in its root domain until the inactive
 	 * timer removes it. Meanwhile, @dl_departed_node links the task on
 	 * the list that a rebuild of the root domains' accounting reads.
-	 * @dl_departed_cpu is a CPU of the root domain that counts the
-	 * bandwidth. It stays recorded while priority inheritance boosts the
-	 * task back into the class. Otherwise @dl_departed_cpu is -1.
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
index 8e8c62c574d5..01fbbd02cf8d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -269,7 +269,7 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * dl_add_task_root_domain()) does not count such a task as a deadline
  * task. So dl_departed_list holds these tasks, from their departure to
  * their timer. The rebuild puts their bandwidth back in the root domain
- * of the CPU each one was on when it left.
+ * of the CPU recorded with each task's bandwidth.
  *
  * dl_bw_gen numbers the rebuilds of the accounting: how many times the
  * root domains were wiped and reconstructed (dl_clear_root_domains()
@@ -291,7 +291,10 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * A rebuild drops the bandwidth when the CPU recorded is no longer
  * active. It also drops the bandwidth of a task that dies while the
  * rebuild runs. The walk of the task list does not find that task, and
- * it was not dead yet when the list was put back.
+ * it was not dead yet when the list was put back. The same happens to a
+ * task that priority inheritance deboosts while the rebuild runs. It was
+ * in the class when the list was put back, and out of it when the walk
+ * reaches it.
  *
  * dl_departed_lock protects the list and both counts. Take it with
  * interrupts disabled, under the task's rq lock or pi_lock or in the
@@ -318,66 +321,75 @@ static inline bool dl_se_holds_bw(struct sched_dl_entity *dl_se)
 }
 
 /*
- * Put @p on dl_departed_list with @cpu, a CPU of the root domain that
+ * Put @p on dl_departed_list. The root domain of the CPU recorded with it
  * keeps its bandwidth. @p leaves SCHED_DEADLINE, or dies, before its
- * 0-lag time. Do nothing if @p is on the list already. Keep the CPU
- * recorded if @p has one: priority inheritance boosted @p back into the
- * class and its boost ends. The caller holds the rq lock of @p.
+ * 0-lag time. Do nothing if @p is on the list already. The caller holds
+ * the rq lock of @p.
  */
-static void dl_task_depart(struct task_struct *p, int cpu)
+static void dl_task_depart(struct task_struct *p)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	int cpu = task_cpu(p);
 
 	lockdep_assert_irqs_disabled();
 	guard(raw_spinlock)(&dl_departed_lock);
-	if (!list_empty(&dl_se->dl_departed_node))
+	if (!list_empty(&dl_se->dl_departed_node) || dl_se->dl_bw_cpu < 0)
 		return;
-	if (dl_se->dl_departed_cpu < 0)
-		dl_se->dl_departed_cpu = cpu;
+	/*
+	 * A rebuild drops the bandwidth if the CPU recorded is not active.
+	 * That CPU can be one that @p left long ago. Record the CPU @p
+	 * departs from instead, if it is active and the same root domain
+	 * counts the bandwidth.
+	 */
+	if (dl_se->dl_bw_gen == dl_bw_gen && cpu_active(cpu) &&
+	    cpu_rq(cpu)->rd == cpu_rq(dl_se->dl_bw_cpu)->rd)
+		dl_se->dl_bw_cpu = cpu;
 	list_add(&dl_se->dl_departed_node, &dl_departed_list);
 }
 
 /*
- * Take @p off dl_departed_list. Priority inheritance boosts @p back into
- * the deadline class. Keep the CPU recorded: its root domain still counts
- * the bandwidth, wherever @p runs now. The caller holds the rq lock of
- * @p.
+ * Take @p off dl_departed_list. @p comes back to the deadline class, and
+ * its bandwidth is that of a deadline task again. The caller holds the rq
+ * lock of @p.
  */
 static void dl_task_undepart(struct task_struct *p)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
 
 	lockdep_assert_irqs_disabled();
+	if (list_empty(&dl_se->dl_departed_node))
+		return;
 	guard(raw_spinlock)(&dl_departed_lock);
 	list_del_init(&dl_se->dl_departed_node);
 }
 
 /*
  * Remove the bandwidth of @p from the root domain that counts it. That is
- * the root domain of the CPU recorded when @p departed, or else of @cpu.
- * Clear the record. Take @p off dl_departed_list. Remove nothing if a
- * rebuild dropped the bandwidth since it was counted. Then record the
- * current dl_bw_gen in @p, so that a rebuild in progress does not count it
- * again. The caller holds the rq lock of @p.
+ * the root domain of the CPU recorded with @p. Clear the record.
+ * Take @p off dl_departed_list. Remove nothing if a rebuild dropped the
+ * bandwidth since it was counted. Then record the current dl_bw_gen in
+ * @p, so that a rebuild in progress does not count it again. The caller
+ * holds the rq lock of @p.
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
+	if (!list_empty(&dl_se->dl_departed_node))
 		list_del_init(&dl_se->dl_departed_node);
-	}
-	if (dl_se->dl_bw_gen == dl_bw_gen) {
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
 
@@ -540,6 +552,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
 /*
  * The utilization of a task cannot be immediately removed from
@@ -640,7 +653,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				dl_task_release_bw(p, task_cpu(p));
+				dl_task_release_bw(p);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -654,12 +667,13 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
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
@@ -897,19 +911,31 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
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
@@ -2427,7 +2453,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 			dl_se->dl_non_contending = 0;
 		}
 
-		dl_task_release_bw(p, task_cpu(p));
+		dl_task_release_bw(p);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3575,14 +3601,26 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	}
 }
 
+/*
+ * Return a CPU of the root domain that counts the bandwidth of @p: the
+ * CPU recorded with it. Without a record, no root domain counts that
+ * bandwidth. Return the CPU @p is on then. Read the record once:
+ * dl_task_check_affinity() holds no lock.
+ */
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
+{
+	int cpu = READ_ONCE(p->dl.dl_bw_cpu);
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
@@ -3590,17 +3628,31 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
+		 * bandwidth of @p leaves nothing to free. dl_departed_lock
+		 * keeps a rebuild from changing dl_bw_gen meanwhile.
 		 */
-		raw_spin_lock(&src_dl_b->lock);
-		__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
-		raw_spin_unlock(&src_dl_b->lock);
+		guard(raw_spinlock)(&dl_departed_lock);
+		if (p->dl.dl_bw_gen == dl_bw_gen) {
+			raw_spin_lock(&src_dl_b->lock);
+			__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(src_cpu));
+			raw_spin_unlock(&src_dl_b->lock);
+		}
+
+		/*
+		 * cpuset_can_attach() made room in the root domain of the new
+		 * mask. That root domain counts the bandwidth from now on.
+		 */
+		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
+		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_cpus_allowed_common(p, ctx);
@@ -3609,10 +3661,18 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3688,7 +3748,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 * Count nothing for a special entity, or for a task with no
 	 * bandwidth. The walk of the task list also finds exited tasks. An
 	 * exited task whose bandwidth went with its parameters has a dl_bw
-	 * of 0.
+	 * of 0. So has a task boosted into the class with no bandwidth of
+	 * its own, which gets no record.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
@@ -3712,7 +3773,9 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3721,9 +3784,9 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3731,6 +3794,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -3880,7 +3944,7 @@ void dl_clear_root_domains(void)
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
 	}
 	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
-		cpu = dl_se->dl_departed_cpu;
+		cpu = dl_se->dl_bw_cpu;
 		/*
 		 * Skip bandwidth that an earlier rebuild dropped. It is not
 		 * counted now, and its release removes nothing
@@ -3895,7 +3959,7 @@ void dl_clear_root_domains(void)
 		 * from the recorded number. The release then removes
 		 * nothing, and no later rebuild restores it.
 		 */
-		if (!cpu_active(cpu))
+		if (cpu < 0 || !cpu_active(cpu))
 			continue;
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
@@ -3956,15 +4020,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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
@@ -3992,10 +4057,11 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	 * longer removes its bandwidth: the task does when it leaves the class
 	 * again. So take it off the list. The task keeps the CPU recorded. It
 	 * takes the bandwidth from the root domain of that CPU, even if it
-	 * moved to another root domain meanwhile.
+	 * moved to another root domain meanwhile. A rebuild while it is
+	 * boosted counts it like any deadline task, and records the CPU it
+	 * picks.
 	 */
-	if (!list_empty(&p->dl.dl_departed_node))
-		dl_task_undepart(p);
+	dl_task_undepart(p);
 
 	/* If p is not queued we will update its parameters at next wakeup. */
 	if (!task_on_rq_queued(p)) {
@@ -4202,9 +4268,10 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4213,6 +4280,23 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4227,7 +4311,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, counted ? p->dl.dl_bw : 0,
+				  new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4235,7 +4320,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		 * But this would require to set the task's "inactive
 		 * timer" when the task is not inactive.
 		 */
-		__dl_sub(dl_b, p->dl.dl_bw, cpus);
+		if (counted)
+			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		dl_change_utilization(p, new_bw);
 		err = 0;
@@ -4256,11 +4342,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
 
@@ -4420,8 +4515,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	dl_se->dl_bw = 0;
 	__dl_clear_params(dl_se);
+	dl_se->dl_bw_cpu = -1;
 	INIT_LIST_HEAD(&dl_se->dl_departed_node);
-	dl_se->dl_departed_cpu = -1;
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 4c013caa2471..306cd8d32173 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1185,6 +1185,8 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 
 int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
 {
+	unsigned int cpu;
+
 	/*
 	 * If the task isn't a deadline task or admission control is
 	 * disabled then we don't care about affinity changes.
@@ -1204,9 +1206,16 @@ int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
 	 * if admission test is enabled, we only admit -deadline
 	 * tasks allowed to run on all the CPUs in the task's
 	 * root_domain.
+	 *
+	 * That is the root domain that counts the bandwidth of the task:
+	 * the one of the CPU recorded with it. A task moved asleep to
+	 * another cpuset is still on a CPU of the root domain it left. A
+	 * bandwidth of 0 is counted nowhere, and no move updates its
+	 * record: use the CPU the task is on.
 	 */
+	cpu = READ_ONCE(p->dl.dl_bw) ? dl_task_root_domain_cpu(p) : task_cpu(p);
 	guard(rcu)();
-	if (!cpumask_subset(task_rq(p)->rd->span, mask))
+	if (!cpumask_subset(cpu_rq(cpu)->rd->span, mask))
 		return -EBUSY;
 
 	return 0;
-- 
2.47.3

