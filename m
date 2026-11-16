Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855970;
	b=SuhwGZWCk8gALx3XqShYj0Akh+roU/W8/0lAYeADjis4L+k/IkuAMkhEsngX0PmF6Xq/
	 tLRNamUi8pKyKwPkb/BaZGJyyKX3G/KiVZSpp1OBo7CeoAUyYrMU45SzExaPuP/PF/eky
	 Fm8r9MZt01WHyjq4lusluFh/tH8h//bhbHsWkOEsnoTUJoCaZpycwtsP4ZyOAqMSQw6q4
	 Of0ZtjZ8hJiUg/DG6iXPmqLmCOHTT1lPgImLcePgnJGJQQuIVjne9hSg8SZ+mTVrjLicc
	 2WBIg+HkOG5Ot/NlrN2rne+NNdRwyKxSitzFvBgSN+Xj8BtWMKmUn8eFAk4u3n55A1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=07axKCAvBvylXCVZykXTOjrHUk6u+gIxJcjBEfqD/3U=;
	b=Om9aXl9qgduFjvqf6uRI4h6haMl81nOaKOY3Ryo5hTwJDosn2cDfYplp0afRodAh3rLz
	 WfQfvdI2W1uP+UZ3oety7uQNMyiw3+Xv1gRdFkvH4mCnvrpoTCuHsCnVzOYddKnsMvqWx
	 sHSIC1DbsBsAQyPukEIvLEI1KfyVN8WGUpX88swk9L8fHGMVY94QM1ewvjkwbu4cpcnzX
	 psmGNi6D+lXgcwD/qNUyVyC5WR/Ii4d5i3oT953HjUPM9IM7wARkWKeUdDhRmoO/rIpfb
	 RhngHhx13Sl9m1t6+VBHgYzf1V8Kr7LbZaeWTufLujX75hEXpeLLsRz2vY1jEIOrfTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p3uAtQHx;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D27F60A3810;
	Mon, 16 Nov 2026 19:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D27F60A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=p3uAtQHx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855956;
	bh=07axKCAvBvylXCVZykXTOjrHUk6u+gIxJcjBEfqD/3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3uAtQHxi7WRYXAk21cFvAPHYX3Os0nxCzXlc5ly5PuGON5gnVgLt03QRxFP9cpsc
	 hBQkI2TLncMr9bYdbegShkxlemij3BNiI8AGynCWUVbcEgpVevm4DxdnTcR0ao/Krz
	 fvp+JQYArZR5N5iBZkEtTWN8bSAIFgcpgEohCodQetCGwKciKiAJLiutXku4DsTflu
	 n2c3JRqNpusQWSmTYBl4xKdytSgPXLUakNhR1vkeKE59LOw0d7R3jbmz8fkF0bvE56
	 UP5K+wwV2EOI6gQ5Y/VQtApHg94cGYK2nF0vxDO7skieIffz7ISU2YtidqiTKWIDTR
	 R3fH1JBXM/S3g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4h0H5dzQtc;
	Mon, 16 Nov 2026 14:05:56 -0500 (EST)
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
Subject: [PATCH v6 13/37] sched/deadline: Keep departing bandwidth across a root domain rebuild
Date: Mon, 16 Nov 2026 14:05:25 -0500
Message-Id: <20261116190549.230119-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE, or dies, keeps its bandwidth in
total_bw until its 0-lag time. This keeps admission control on the safe
side. Then inactive_task_timer() removes it from the root domain of the
task's CPU. Two things break this:

 - A rebuild of the accounting clears every root domain, then adds back
   the deadline tasks of the cpusets. It misses a task that left
   SCHED_DEADLINE, or a dead one. Their bandwidth is dropped, and the
   timer removes it again.
 - A task that left SCHED_DEADLINE can also move to another root
   domain. The timer then takes total_bw from that one, which never
   had it.

Either way, a root domain admits deadline tasks beyond its capacity
until the next rebuild.

Fix this with dl_departed_list. A departing task goes on it with the
CPU it is on. A rebuild puts its bandwidth back in that CPU's root
domain. The timer removes it from there, and so does
sched_dl_overflow() for a task that returns to SCHED_DEADLINE.

Priority inheritance can boost a departed task back into the class,
after it moved to another root domain. The boost cancels the timer and
takes the task off the list. Keep the CPU recorded then. When the boost
ends, the bandwidth is taken from the root domain that counts it, not
from the one the task runs in. The pi_departed_moved case of
deadline_bw_test, added later in this series, tests this.

A rebuild still drops the bandwidth of a task whose CPU is inactive, or
that dies during the rebuild. Each task records a count of the rebuilds,
dl_bw_gen, with its bandwidth. The timer removes nothing if a rebuild
dropped the bandwidth since.

Make dl_cookie and dl_bw_visited() static: only deadline.c uses them.

deadline_rebuild_test, added later in this series, fails every time on
v7.3 and v7.4-rc1 kernels. A one-CPU partition root admits two tasks of
600ms every second there, where it has room for one. It passes with
this patch.

Fixes: 387e31300b57 ("sched/deadline: Fix the update of the total -deadline utilization")
Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h          |  16 +++
 include/linux/sched/deadline.h |   5 +-
 kernel/cgroup/cpuset.c         |  11 +-
 kernel/sched/deadline.c        | 254 +++++++++++++++++++++++++++++----
 4 files changed, 249 insertions(+), 37 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 96b498f79484..063e49690658 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -740,6 +740,22 @@ struct sched_dl_entity {
 	 */
 	struct hrtimer			inactive_timer;
 
+	/*
+	 * A task that leaves SCHED_DEADLINE, or dies, before its "0-lag
+	 * time" keeps its bandwidth in its root domain until the inactive
+	 * timer removes it. Meanwhile, @dl_departed_node links the task on
+	 * the list that a rebuild of the root domains' accounting reads.
+	 * @dl_departed_cpu is a CPU of the root domain that counts the
+	 * bandwidth. It stays recorded while priority inheritance boosts the
+	 * task back into the class. Otherwise @dl_departed_cpu is -1.
+	 *
+	 * @dl_bw_gen is the value of dl_bw_gen when the bandwidth was last
+	 * counted. If a rebuild dropped it since, there is nothing to remove.
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
index 09188a28b3a1..cbdfa0793703 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -195,7 +195,13 @@ static inline unsigned long dl_bw_capacity(int i)
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
 
@@ -249,6 +255,112 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
 	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw;
 }
 
+/*
+ * A task that leaves SCHED_DEADLINE, or dies, before its 0-lag time keeps
+ * its bandwidth in total_bw until that time. Then the inactive timer
+ * removes it. Meanwhile the task may run anywhere, under another policy.
+ * The timer holds a reference to it.
+ *
+ * A rebuild of the root domains' accounting (dl_clear_root_domains() and
+ * dl_add_task_root_domain()) does not find such a task among the deadline
+ * tasks of the cpusets. So dl_departed_list holds these tasks, from their
+ * departure to their timer. The rebuild puts their bandwidth back in the
+ * root domain of the CPU each one was on when it left.
+ *
+ * dl_bw_gen numbers the rebuilds of the accounting: how many times the
+ * root domains were wiped and reconstructed (dl_clear_root_domains()
+ * increments it). A task records the number of its last definite
+ * state, counted or settled. That number dates the state:
+ *
+ *  - Current: the bandwidth is counted, or a release settled it since
+ *    the rebuild began. A release subtracts; the walk of the cpusets
+ *    skips.
+ *  - One behind: the clear that just ran wiped it. The rebuild puts
+ *    it back.
+ *  - Older: an earlier rebuild dropped it. A task on the departed list
+ *    stays out, and its release removes nothing. A task that is in the
+ *    class is counted again.
+ *
+ * Only equalities are compared, so the wrap of the counter is
+ * harmless.
+ *
+ * A rebuild drops the bandwidth when the CPU recorded is no longer
+ * active. It also drops the bandwidth of a task that dies while the
+ * rebuild runs. The cpuset walk skips that task, and it was not dead yet
+ * when the list was put back.
+ *
+ * dl_departed_lock protects the list and both counts. Take it with
+ * interrupts disabled, under the task's rq lock or pi_lock or in the
+ * rebuild, and before any dl_bw lock.
+ */
+static LIST_HEAD(dl_departed_list);
+static DEFINE_RAW_SPINLOCK(dl_departed_lock);
+static unsigned int dl_bw_gen;
+
+/*
+ * Put @p on dl_departed_list with @cpu, a CPU of the root domain that
+ * keeps its bandwidth. @p leaves SCHED_DEADLINE, or dies, before its
+ * 0-lag time. Do nothing if @p is on the list already. Keep the CPU
+ * recorded if @p has one: priority inheritance boosted @p back into the
+ * class and its boost ends. The caller holds the rq lock of @p.
+ */
+static void dl_task_depart(struct task_struct *p, int cpu)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	lockdep_assert_irqs_disabled();
+	guard(raw_spinlock)(&dl_departed_lock);
+	if (!list_empty(&dl_se->dl_departed_node))
+		return;
+	if (dl_se->dl_departed_cpu < 0)
+		dl_se->dl_departed_cpu = cpu;
+	list_add(&dl_se->dl_departed_node, &dl_departed_list);
+}
+
+/*
+ * Take @p off dl_departed_list. Priority inheritance boosts @p back into
+ * the deadline class. Keep the CPU recorded: its root domain still counts
+ * the bandwidth, wherever @p runs now. The caller holds the rq lock of
+ * @p.
+ */
+static void dl_task_undepart(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	lockdep_assert_irqs_disabled();
+	guard(raw_spinlock)(&dl_departed_lock);
+	list_del_init(&dl_se->dl_departed_node);
+}
+
+/*
+ * Remove the bandwidth of @p from the root domain that counts it. That is
+ * the root domain of the CPU recorded when @p departed, or else of @cpu.
+ * Clear the record. Take @p off dl_departed_list. Remove nothing if a
+ * rebuild dropped the bandwidth since it was counted. Then record the
+ * current dl_bw_gen in @p, so that a rebuild in progress does not count it
+ * again. The caller holds the rq lock of @p.
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
+		list_del_init(&dl_se->dl_departed_node);
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
@@ -481,13 +593,9 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				sub_running_bw(dl_se, dl_rq);
 
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
-				struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				raw_spin_lock(&dl_b->lock);
-				__dl_sub(dl_b, dl_se->dl_bw, dl_bw_cpus(task_cpu(p)));
-				raw_spin_unlock(&dl_b->lock);
+				dl_task_release_bw(p, task_cpu(p));
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -496,8 +604,18 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 	}
 
 	dl_se->dl_non_contending = 1;
-	if (!dl_server(dl_se))
-		get_task_struct(dl_task_of(dl_se));
+	if (!dl_server(dl_se)) {
+		struct task_struct *p = dl_task_of(dl_se);
+
+		get_task_struct(p);
+		/*
+		 * A dying task keeps its bandwidth in the root domain of the
+		 * CPU it runs on. Record that CPU. switched_from_dl() records
+		 * a task that leaves SCHED_DEADLINE.
+		 */
+		if (READ_ONCE(p->__state) == TASK_DEAD)
+			dl_task_depart(p, task_cpu(p));
+	}
 
 	hrtimer_start(timer, ns_to_ktime(zerolag_time), HRTIMER_MODE_REL_HARD);
 }
@@ -2242,17 +2360,13 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
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
@@ -3513,12 +3627,33 @@ void dl_add_task_root_domain(struct task_struct *p)
 	dl_get_task_effective_cpus(p, msk);
 	cpu = cpumask_first_and(cpu_active_mask, msk);
 	BUG_ON(cpu >= nr_cpu_ids);
+
+	raw_spin_lock(&dl_departed_lock);
+	/*
+	 * Skip a task whose dl_bw_gen is current. Either
+	 * dl_clear_root_domains() put it back as a departed task, and
+	 * priority inheritance boosted it into the class since. Or it died
+	 * since the rebuild started, and dl_task_release_bw() released its
+	 * bandwidth. A task that died since with its 0-lag time ahead is on
+	 * the departed list. Count it in the root domain of the CPU
+	 * recorded, if that CPU is active.
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
 
@@ -3576,9 +3711,51 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
-void dl_clear_root_domain_cpu(int cpu)
+/*
+ * Clear every root domain before a rebuild of their accounting, and count
+ * the rebuild in dl_bw_gen. Put back the bandwidth of their servers. Put
+ * back the bandwidth of the tasks on dl_departed_list, which no cpuset
+ * holds as deadline tasks. Put each in the root domain of the CPU
+ * recorded for it, or drop it if that CPU is not active.
+ * dl_add_task_root_domain() then adds the deadline tasks of the cpusets.
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
+		/*
+		 * Skip bandwidth that an earlier rebuild dropped. It is not
+		 * counted now, and its release removes nothing
+		 * (dl_task_release_bw()).
+		 */
+		if (dl_se->dl_bw_gen != dl_bw_gen - 1)
+			continue;
+		/*
+		 * Drop the bandwidth of a task whose CPU is inactive. A CPU
+		 * that goes offline is in the default root domain by then.
+		 * The root domain that counted the task cannot be found
+		 * from the recorded number. The release then removes
+		 * nothing, and no later rebuild restores it.
+		 */
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
@@ -3634,9 +3811,20 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * We cannot use inactive_task_timer() to invoke sub_running_bw()
 	 * at the 0-lag time, because the task could have been migrated
 	 * while SCHED_OTHER in the meanwhile.
+	 *
+	 * For the same reason, the timer cannot take the task's bandwidth
+	 * from the root domain of the CPU the task is on by then. And a
+	 * rebuild of the root domains meanwhile would not find the task
+	 * among the deadline tasks. So record a CPU of the root domain that
+	 * keeps the bandwidth until the timer removes it (dl_task_depart()).
+	 * Test dl_non_contending: it tells that the timer is armed and its
+	 * handler has not run. hrtimer_active() stays true for a while after
+	 * the handler returns.
 	 */
-	if (p->dl.dl_non_contending)
+	if (p->dl.dl_non_contending) {
 		p->dl.dl_non_contending = 0;
+		dl_task_depart(p, task_cpu(p));
+	}
 
 	/*
 	 * Since this might be the only -deadline task on the rq,
@@ -3656,6 +3844,17 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 static void switched_to_dl(struct rq *rq, struct task_struct *p)
 {
 	cancel_inactive_timer(&p->dl);
+	/*
+	 * A task on the departed list gets here when priority inheritance
+	 * boosts it back into the class before its 0-lag time. (A policy change
+	 * took it off the list in sched_dl_overflow().) The inactive timer no
+	 * longer removes its bandwidth: the task does when it leaves the class
+	 * again. So take it off the list. The task keeps the CPU recorded. It
+	 * takes the bandwidth from the root domain of that CPU, even if it
+	 * moved to another root domain meanwhile.
+	 */
+	if (!list_empty(&p->dl.dl_departed_node))
+		dl_task_undepart(p);
 
 	/*
 	 * In case a task is setscheduled to SCHED_DEADLINE we need to keep
@@ -3770,12 +3969,6 @@ DEFINE_SCHED_CLASS(dl) = {
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
@@ -3896,8 +4089,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 
 	if (dl_policy(policy) && !task_has_dl_policy(p) &&
 	    !__dl_overflow(dl_b, cap, 0, new_bw)) {
-		if (hrtimer_active(&p->dl.inactive_timer))
-			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
@@ -3923,6 +4114,19 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	}
 	raw_spin_unlock(&dl_b->lock);
 
+	/*
+	 * A task that comes back before its 0-lag time still has the
+	 * bandwidth it left with. The new bandwidth replaces it, so remove the
+	 * old one from the root domain that keeps it (dl_task_release_bw()).
+	 * No rebuild can run meanwhile: the caller holds cpuset_mutex.
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
 
@@ -4062,6 +4266,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	init_dl_task_timer(dl_se);
 	init_dl_inactive_task_timer(dl_se);
 	__dl_clear_params(dl_se);
+	INIT_LIST_HEAD(&dl_se->dl_departed_node);
+	dl_se->dl_departed_cpu = -1;
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
-- 
2.47.3

