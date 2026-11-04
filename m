Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805149;
	b=oZRlyuISemVJP8iiH+JcNInlZoO9onSrbrsT47CZmrdx6jci4Gsij+1K1hGfLLT6HLDA
	 VRVXfv4HGfbPEKUUYbbL/Aqu7SxYeb0M/jCRRse23zPnOymdQiLO4wNfvrpAH4/b7s80v
	 pdRxqdb1czxZg8SStZxvg5FEG1z8Zdsx30yTLuspz1H9UXQoqI0CC6QvZsyp5ZYO/LaKa
	 E1v4rAFiSAiWyDrIjXJxGmVxFbSFjRjg2fku+OoNVZR+1Kvi7B8He8WJl9uLTMDZ35oc1
	 N/wCoJ9Kq4FTZdEhA4ASQfCfx1t07G/4kRzhFe3UMSFm71XB9WJoVKw6EcviTKOcgGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805149;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kbgbt2xhqOL3sSM1/Im7JnXIhn8dbfgcSyxLhqV0zI4=;
	b=dGYFwbdu1ByDW/0XWQ67RDrDHCcquPVwLupHYS11x1GYa8ZyQ9Wl7GiwFiyUvaDxiYkQ
	 tW4j1FgQ9QwnJ3xsUAL/RSsv1nDGx8/gIKyrBTayza15+waDc3fvIECCgviThjAdpUgNe
	 mp34QxoNgDrNW3BiWbIpZUIUdNNGagYMgSIEGQo1zu+MVYkqbXsYGP4AL4lDxF8uGDp4Z
	 LXYL+gpl15QqP07ETF0eaNGbLBobNU+/F9UfwBVvhB6vwIOF7W3X61fEBRGnBl7dYhukP
	 7Nu4Aj8C5dPGzrcjgt5UNEJdrr7otx4phq9DdV7tLD74mHQYYmloswYsCewFulVn8Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="bu5/fPWe";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8B8606D812;
	Wed,  4 Nov 2026 15:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD8B8606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=bu5/fPWe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805141;
	bh=Kbgbt2xhqOL3sSM1/Im7JnXIhn8dbfgcSyxLhqV0zI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu5/fPWe2zypaBGu5oA8I8551AbwUw6V0npvsupkdYbtoI+mKM1vo7jjxvu7BbVZf
	 A8Rn+Ylv53T78wyDw56qHo/jLx9KTWxvDEZVNfXxHBAgAEkCDa97Vm8awt31SC8k3n
	 gbZN1zojZ4z9KSza9rjxIB/wEbUGujZV2vd86YHHBJDOisQHt75H+tXgc5xOA6qWnm
	 LMFzrumWeljBgfxA7irImZofKTH0O+lNldyLfDqD7G+lqJ9qs64H/Cw7h0oakfUTem
	 MmF7da6jrbgcdv0HhuXkn/Jqi2sNJ5SiZ/UJYgwRFEkDq62RM3uYRHzK43WtSaKs5t
	 SC7Tq+RTy10DA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSh6clqzLMD;
	Wed, 04 Nov 2026 10:12:20 -0500 (EST)
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
	Claudio Scordino <claudio@evidence.eu.com>,
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
Subject: [PATCH 07/12] sched/deadline: Keep departing bandwidth across a root domain rebuild
Date: Wed,  4 Nov 2026 10:10:28 -0500
Message-Id: <9a2c58b84302e5ed3765f773eca3c71c7d5ea7bb.1793804635.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
References: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE, or dies, before its 0-lag time keeps
its bandwidth in the total_bw of its root domain until that time, when
inactive_task_timer() removes it from the root domain of the CPU the
task is on (commit 387e31300b57 ("sched/deadline: Fix the update of the
total -deadline utilization")). Two things break that:

 1. a rebuild of the root domains' accounting,
    dl_rebuild_rd_accounting() on any change of the cpuset partitions
    and on CPU hotplug, clears every root domain and adds back the
    bandwidth of the deadline tasks it finds in the cpusets. A task out
    of the policy is not one, and a dead one is in no cpuset any more:
    its bandwidth is dropped, and the timer then removes it again, from
    whichever root domain its CPU is in by then. total_bw wraps around,
    and that root domain admits deadline tasks beyond its capacity
    until the next rebuild;
 2. a task out of the policy may move meanwhile, as any other task, to
    a CPU of another root domain, moved to another cpuset partition:
    the timer then removes the bandwidth from that root domain, which
    never had it, and leaves it for good in the one that has it.

Keep each departing task on a list, from its departure to its timer,
with a CPU of the root domain that holds its bandwidth: the CPU a dying
task runs on, and for one that leaves the policy, a CPU of its mask
(dl_task_root_domain_cpu()), since the CPU it last ran on may be of
another root domain, when it was moved asleep. A rebuild puts that
bandwidth back in the root domain of that CPU, and the timer removes it
from there.

dl_non_contending tells a task departed, its inactive timer armed and
that timer's handler yet to run; hrtimer_active() stays true for a
while after the handler returns, and would leave the task on the list
with nothing to take it off. A count of the rebuilds, which each task
records when its bandwidth is counted, settles the races with a death
and with a CPU going inactive: a rebuild that dropped the bandwidth
since leaves nothing to remove, as for a task that exits while a
rebuild runs, which neither the cpuset walk, skipping exiting tasks,
nor the list, if it is not dead yet when the list is put back, finds. A
switch back to SCHED_DEADLINE before the timer has sched_dl_overflow()
release the old bandwidth from the root domain that keeps it, the new
one reserved in the task's current root domain; a boost into
the deadline class by priority inheritance in that window, whose
switched_to_dl() cancels the timer, takes the task off the list, its
bandwidth removed when it leaves the class again, from the root domain
of its mask by then, as before. The list's lock nests inside the rq and
pi locks, and outside the root domains' dl_bw locks.

dl_cookie and dl_bw_visited() have no user outside deadline.c left:
make them static.

The selftest added by the next patch fails its three cases every time
without this change, and passes them with it. A standalone reproducer,
a task of 400ms every second that runs 380ms and then exits, switches
to SCHED_OTHER or moves, a partition root made or unmade before its
0-lag time, has a one-CPU partition root admit two tasks of 600ms every
second on v7.3, every time, and refuse the second with this change, in
36 runs out of 36. It was found by a cgroup selftest under development,
test_concurrency_deadline_domain, which failed about once in ten runs
when it followed a test whose deadline task had died just before.

Fixes: 387e31300b57 ("sched/deadline: Fix the update of the total -deadline utilization")
Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h          |  14 +++
 include/linux/sched/deadline.h |   5 +-
 kernel/cgroup/cpuset.c         |  11 +-
 kernel/sched/deadline.c        | 222 ++++++++++++++++++++++++++++-----
 4 files changed, 208 insertions(+), 44 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..0633a73579db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -734,6 +734,20 @@ struct sched_dl_entity {
 	 */
 	struct hrtimer			inactive_timer;
 
+	/*
+	 * A task that leaves SCHED_DEADLINE, or dies, before its "0-lag
+	 * time" keeps its bandwidth in its root domain until the inactive
+	 * timer removes it. @dl_departed_cpu is then a CPU of the root domain
+	 * that counts that bandwidth, and @dl_departed_node links it on the
+	 * list that a rebuild of the root domains' accounting puts that
+	 * bandwidth back from; -1 otherwise. @dl_bw_gen is the
+	 * rebuild that last counted the task's bandwidth: one since then
+	 * dropped it, and nothing is to be removed.
+	 */
+	struct list_head		dl_departed_node;
+	int				dl_departed_cpu;
+	unsigned int			dl_bw_gen;
+
 	/*
 	 * Bits for DL-server functionality. Also see the comment near
 	 * dl_server_update().
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 273538200a44..bdf39ac1d43d 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -32,7 +32,7 @@ static inline bool dl_time_before(u64 a, u64 b)
 struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
-extern void dl_clear_root_domain_cpu(int cpu);
+extern void dl_clear_root_domains(void);
 /*
  * Return whether moving DL task @p to @new_mask requires moving DL
  * bandwidth accounting between root domains. This helper is specific to
@@ -43,9 +43,6 @@ extern void dl_clear_root_domain_cpu(int cpu);
 extern bool dl_task_needs_bw_move(struct task_struct *p,
 				  const struct cpumask *new_mask);
 
-extern u64 dl_cookie;
-extern bool dl_bw_visited(int cpu, u64 cookie);
-
 static inline bool dl_server(struct sched_dl_entity *dl_se)
 {
 	return dl_se->dl_server;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..4159abfbbbb5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -985,21 +985,14 @@ void dl_rebuild_rd_accounting(void)
 {
 	struct cpuset *cs = NULL;
 	struct cgroup_subsys_state *pos_css;
-	int cpu;
-	u64 cookie = ++dl_cookie;
 
 	lockdep_assert_cpuset_lock_held();
 	lockdep_assert_cpus_held();
 	lockdep_assert_held(&sched_domains_mutex);
 
-	rcu_read_lock();
-
-	for_each_possible_cpu(cpu) {
-		if (dl_bw_visited(cpu, cookie))
-			continue;
+	dl_clear_root_domains();
 
-		dl_clear_root_domain_cpu(cpu);
-	}
+	rcu_read_lock();
 
 	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3c57e5f5fc05..8ead9b050dfc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -163,7 +163,13 @@ static inline unsigned long dl_bw_capacity(int i)
 	}
 }
 
-bool dl_bw_visited(int cpu, u64 cookie)
+/*
+ * Used for dl_bw check and update, used under sched_rt_handler()::mutex and
+ * sched_domains_mutex.
+ */
+static u64 dl_cookie;
+
+static bool dl_bw_visited(int cpu, u64 cookie)
 {
 	struct root_domain *rd = cpu_rq(cpu)->rd;
 
@@ -217,6 +223,88 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
 	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw;
 }
 
+/*
+ * A task that leaves SCHED_DEADLINE, or dies, before its 0-lag time keeps
+ * its bandwidth in total_bw until then: the inactive timer removes it. A
+ * rebuild of the root domains' accounting meanwhile (dl_clear_root_domains()
+ * and dl_add_task_root_domain(), on any change of the partitions or CPU
+ * hotplug) finds no such task among the deadline tasks of the cpusets: it
+ * puts that bandwidth back from dl_departed_list, which holds them from
+ * their departure to their timer, in the root domain each left, found by
+ * its mask then (dl_task_root_domain_cpu()), or by the CPU it dies on: the
+ * CPU it last ran on may be of another one, when it was moved asleep. The
+ * task may run anywhere meanwhile, as another policy; its timer holds a
+ * reference to it.
+ *
+ * dl_bw_gen counts the rebuilds, and each task records the one that last
+ * counted its bandwidth. A rebuild that dropped it since then leaves
+ * nothing to remove: the CPU recorded was no longer active, or the task
+ * exited while the rebuild ran, which the cpuset walk skips, and was not
+ * dead yet when the list was put back. Both counts, and the list, are under
+ * dl_departed_lock, taken with interrupts disabled (under the task's rq
+ * lock or pi_lock, or by the rebuild) and before any dl_bw lock.
+ */
+static LIST_HEAD(dl_departed_list);
+static DEFINE_RAW_SPINLOCK(dl_departed_lock);
+static unsigned int dl_bw_gen;
+
+/*
+ * @p leaves SCHED_DEADLINE, or dies, its bandwidth kept for now in the root
+ * domain of @cpu. Under its rq lock.
+ */
+static void dl_task_depart(struct task_struct *p, int cpu)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	lockdep_assert_irqs_disabled();
+	if (dl_se->dl_departed_cpu >= 0)
+		return;
+	guard(raw_spinlock)(&dl_departed_lock);
+	dl_se->dl_departed_cpu = cpu;
+	list_add(&dl_se->dl_departed_node, &dl_departed_list);
+}
+
+/*
+ * @p comes back to the deadline class, its bandwidth kept as a deadline
+ * task's again. Under its rq lock.
+ */
+static void dl_task_undepart(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	lockdep_assert_irqs_disabled();
+	guard(raw_spinlock)(&dl_departed_lock);
+	dl_se->dl_departed_cpu = -1;
+	list_del(&dl_se->dl_departed_node);
+}
+
+/*
+ * Remove @p's bandwidth from the root domain that counts it: that of the
+ * CPU recorded when it departed, else that of @cpu. Nothing to remove
+ * when a rebuild of the accounting has dropped it; and no rebuild running
+ * counts it again. Under @p's rq lock.
+ */
+static void dl_task_release_bw(struct task_struct *p, int cpu)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct dl_bw *dl_b;
+
+	lockdep_assert_irqs_disabled();
+	guard(raw_spinlock)(&dl_departed_lock);
+	if (dl_se->dl_departed_cpu >= 0) {
+		cpu = dl_se->dl_departed_cpu;
+		dl_se->dl_departed_cpu = -1;
+		list_del(&dl_se->dl_departed_node);
+	}
+	if (dl_se->dl_bw_gen == dl_bw_gen) {
+		dl_b = dl_bw_of(cpu);
+		raw_spin_lock(&dl_b->lock);
+		__dl_sub(dl_b, dl_se->dl_bw, dl_bw_cpus(cpu));
+		raw_spin_unlock(&dl_b->lock);
+	}
+	dl_se->dl_bw_gen = dl_bw_gen;
+}
+
 static inline
 void __add_running_bw(u64 dl_bw, struct dl_rq *dl_rq)
 {
@@ -449,13 +537,9 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				sub_running_bw(dl_se, dl_rq);
 
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
-				struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-
 				if (READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				raw_spin_lock(&dl_b->lock);
-				__dl_sub(dl_b, dl_se->dl_bw, dl_bw_cpus(task_cpu(p)));
-				raw_spin_unlock(&dl_b->lock);
+				dl_task_release_bw(p, task_cpu(p));
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -464,8 +548,18 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	}
 
 	dl_se->dl_non_contending = 1;
-	if (!dl_server(dl_se))
-		get_task_struct(dl_task_of(dl_se));
+	if (!dl_server(dl_se)) {
+		struct task_struct *p = dl_task_of(dl_se);
+
+		get_task_struct(p);
+		/*
+		 * Dying: its bandwidth is in the root domain of the CPU it
+		 * runs on. switched_from_dl() records one that leaves
+		 * SCHED_DEADLINE.
+		 */
+		if (READ_ONCE(p->__state) == TASK_DEAD)
+			dl_task_depart(p, task_cpu(p));
+	}
 
 	hrtimer_start(timer, ns_to_ktime(zerolag_time), HRTIMER_MODE_REL_HARD);
 }
@@ -2185,17 +2279,13 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		goto no_task;
 
 	if (!dl_task(p) || READ_ONCE(p->__state) == TASK_DEAD) {
-		struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-
 		if (READ_ONCE(p->__state) == TASK_DEAD && dl_se->dl_non_contending) {
 			sub_running_bw(&p->dl, dl_rq_of_se(&p->dl));
 			sub_rq_bw(&p->dl, dl_rq_of_se(&p->dl));
 			dl_se->dl_non_contending = 0;
 		}
 
-		raw_spin_lock(&dl_b->lock);
-		__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
-		raw_spin_unlock(&dl_b->lock);
+		dl_task_release_bw(p, task_cpu(p));
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3479,12 +3569,33 @@ void dl_add_task_root_domain(struct task_struct *p)
 	dl_get_task_effective_cpus(p, msk);
 	cpu = cpumask_first_and(cpu_active_mask, msk);
 	BUG_ON(cpu >= nr_cpu_ids);
+
+	raw_spin_lock(&dl_departed_lock);
+	/*
+	 * Counted already by this rebuild: put back by
+	 * dl_clear_root_domains() as a departed task, which priority
+	 * inheritance boosted into the class since, or its bandwidth
+	 * gone since (dl_task_release_bw()), as that of one that died
+	 * after the walk found it. One that died since with its 0-lag
+	 * time ahead goes back to the root domain of the CPU recorded
+	 * (dl_task_depart()), if active.
+	 */
+	if (p->dl.dl_bw_gen == dl_bw_gen)
+		goto unlock;
+	if (p->dl.dl_departed_cpu >= 0) {
+		cpu = p->dl.dl_departed_cpu;
+		if (!cpu_active(cpu))
+			goto unlock;
+	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
 
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_gen = dl_bw_gen;
+unlock:
+	raw_spin_unlock(&dl_departed_lock);
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 }
 
@@ -3542,9 +3653,37 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
-void dl_clear_root_domain_cpu(int cpu)
+/*
+ * Clear every root domain ahead of a rebuild of their accounting, which
+ * dl_add_task_root_domain() then fills with the deadline tasks of the
+ * cpusets: put back their servers, and the bandwidth of the tasks that
+ * left SCHED_DEADLINE, or died, before their 0-lag time, which no cpuset
+ * holds as a deadline task, in the root domain of the CPU recorded for
+ * each; dropped if it is no longer active.
+ */
+void dl_clear_root_domains(void)
 {
-	dl_clear_root_domain(cpu_rq(cpu)->rd);
+	struct sched_dl_entity *dl_se;
+	u64 cookie = ++dl_cookie;
+	struct dl_bw *dl_b;
+	int cpu;
+
+	guard(raw_spinlock_irqsave)(&dl_departed_lock);
+	dl_bw_gen++;
+	for_each_possible_cpu(cpu) {
+		if (!dl_bw_visited(cpu, cookie))
+			dl_clear_root_domain(cpu_rq(cpu)->rd);
+	}
+	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
+		cpu = dl_se->dl_departed_cpu;
+		if (!cpu_active(cpu))
+			continue;
+		dl_b = dl_bw_of(cpu);
+		raw_spin_lock(&dl_b->lock);
+		__dl_add(dl_b, dl_se->dl_bw, dl_bw_cpus(cpu));
+		raw_spin_unlock(&dl_b->lock);
+		dl_se->dl_bw_gen = dl_bw_gen;
+	}
 }
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
@@ -3578,7 +3717,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * or sub_rq_bw (below) will complain.
 			 *
 			 * inactive_task_timer() will find !dl_task(p) and
-			 * release total_bw via __dl_sub().
+			 * release total_bw (dl_task_release_bw()).
 			 */
 			sub_running_bw(&p->dl, &rq->dl);
 		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
@@ -3594,12 +3733,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * nor for a special one: neither has bandwidth in
 			 * total_bw.
 			 */
-			unsigned int cpu = dl_task_root_domain_cpu(p);
-			struct dl_bw *dl_b = &cpu_rq(cpu)->rd->dl_bw;
-
-			raw_spin_lock(&dl_b->lock);
-			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
-			raw_spin_unlock(&dl_b->lock);
+			dl_task_release_bw(p, dl_task_root_domain_cpu(p));
 			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
@@ -3620,9 +3754,19 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * We cannot use inactive_task_timer() to invoke sub_running_bw()
 	 * at the 0-lag time, because the task could have been migrated
 	 * while SCHED_OTHER in the meanwhile.
+	 *
+	 * Nor can it take the task's bandwidth from the root domain of the
+	 * CPU the task is on by then, and a rebuild of the root domains
+	 * meanwhile would not find it among the deadline tasks: record a
+	 * CPU of the root domain that keeps that bandwidth until the
+	 * inactive timer removes it (dl_task_depart()). dl_non_contending
+	 * tells that timer armed, its handler yet to run; hrtimer_active()
+	 * stays true for a while after that handler returns.
 	 */
-	if (p->dl.dl_non_contending)
+	if (p->dl.dl_non_contending) {
 		p->dl.dl_non_contending = 0;
+		dl_task_depart(p, dl_task_root_domain_cpu(p));
+	}
 
 	/*
 	 * Since this might be the only -deadline task on the rq,
@@ -3642,6 +3786,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 static void switched_to_dl(struct rq *rq, struct task_struct *p)
 {
 	cancel_inactive_timer(&p->dl);
+	/*
+	 * Boosted back into the class before its 0-lag time (a policy change
+	 * released that bandwidth in sched_dl_overflow()): the inactive
+	 * timer will not remove it, but its leaving the class again. That
+	 * forgets the CPU recorded: moved to another root domain meanwhile,
+	 * the task then removes the bandwidth from that one, as it did
+	 * before departures were recorded.
+	 */
+	if (p->dl.dl_departed_cpu >= 0)
+		dl_task_undepart(p);
 
 	/*
 	 * In case a task is setscheduled to SCHED_DEADLINE we need to keep
@@ -3756,12 +3910,6 @@ DEFINE_SCHED_CLASS(dl) = {
 #endif
 };
 
-/*
- * Used for dl_bw check and update, used under sched_rt_handler()::mutex and
- * sched_domains_mutex.
- */
-u64 dl_cookie;
-
 int sched_dl_global_validate(void)
 {
 	u64 runtime = global_rt_runtime();
@@ -3882,8 +4030,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 
 	if (dl_policy(policy) && !task_has_dl_policy(p) &&
 	    !__dl_overflow(dl_b, cap, 0, new_bw)) {
-		if (hrtimer_active(&p->dl.inactive_timer))
-			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
@@ -3909,6 +4055,19 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	}
 	raw_spin_unlock(&dl_b->lock);
 
+	/*
+	 * Back before its 0-lag time, the task still has the bandwidth it
+	 * left with, which the new one replaces: removed from the root
+	 * domain that keeps it (dl_task_release_bw()). A rebuild cannot
+	 * run meanwhile: the caller holds cpuset_mutex.
+	 */
+	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
+		lockdep_assert_cpuset_lock_held();
+		if (p->dl.dl_departed_cpu >= 0)
+			dl_task_release_bw(p, -1);
+		p->dl.dl_bw_gen = dl_bw_gen;
+	}
+
 	return err;
 }
 
@@ -4044,6 +4203,7 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	init_dl_task_timer(dl_se);
 	init_dl_inactive_task_timer(dl_se);
 	__dl_clear_params(dl_se);
+	dl_se->dl_departed_cpu = -1;
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
-- 
2.47.3

