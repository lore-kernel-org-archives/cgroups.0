Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164064;
	b=ZXDGQy3c1wd8AScepI2VpOM0ngo57Mh0BD8s9d84p+G14RrGwoU92pPqVI9C6bFLpCsS
	 efz+r4UsjCTSgQPkjfQoE2eKpXnyblHcITgocKHIldgDvg2Q/mIcGE8uFVcMtDs1bhE02
	 N7mVtth0eJ4gFC6/hERV9sZtwnykUh/L94KexjLjPwRVpERP65JEllfM61j9l3uqkxhSe
	 79VagHGWVljJjDkLhCbtt2OsE4imuB4zNK0M7BSJe6Spy4x7PAo7SNH1+iqku9uvnCBUe
	 NPcF5PgNiuhwmHL5DGPC5dvSyQO5w/ZM7S/YsCNBIuzqZxO+oqp2dduubX2SeXDMsQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164064;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D2FpFxCQDpWKmZC+MUt97uEnOHiNEzqVFaTK3CEor74=;
	b=eZYKeZYlwR3OMDzeFtuUtK8lYQYSqykqomVVAFRrH2caObZF0SKM6kA9D9kEpcNu+0X4
	 rgTgL5Dgvdq0SQBq6aS2JOe/65lQrZmq1VXh7QMuS0jb42xcctf0kXqS0lhurwtN+BM49
	 hAd+atASNfhVGzC+501LvxsQFWRrQVDaR7aOJSZV5VkPMbk8tWcFeSHtl6kNc7HPn6B+S
	 w9A1inQ6iO2g6l5sGDzW+EItWsfRv4KDhtI2Uou+YZozClzt2Ne7l7vOQfM7pKIXxom5j
	 hEvnrk0/RDUh4OMG7GPXqEwjKlQOg0xD2qZDkDNNLn9fhYVEsdvCWV8nXDJoBYD66cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=luEVSjaM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89169606EEB3;
	Sun,  8 Nov 2026 18:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89169606EEB3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=luEVSjaM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164062;
	bh=D2FpFxCQDpWKmZC+MUt97uEnOHiNEzqVFaTK3CEor74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luEVSjaM/tnWrezFxXLkCO8kIPDnP9Fx7MqKSATIwVRIOGZBQZ65Sq+IXpl7HYS2f
	 LAdMxMwwX41vZLjxbBciP4R/PCwmtvpCoNaFg1E0H9wCHQpwea4c9Q3vyZLTcUC9di
	 aeZKR+Cew0b0fW8rk898FTD8kXZ5xv2nDxP8cxFwyOrbV9+KrFCtV3RDnMxznQaO+G
	 0GiqZtZJ13cUlGsfSwftI7miaFvtmqnpl0DclPeCpHPKSqgzK5yPjK+WOOoJ7WJmmK
	 5JrQ4JdNSj+0leF+qfD1eMXl3OT9Vkrj41IlG9uxHR76HYFzhEoawut4rcdFy3iO6q
	 xaMSLc7qYts4A==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C24Fj9zMJx;
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
Subject: [PATCH v5 15/29] sched/deadline: Rebuild the root domains' accounting from the task list
Date: Sun,  8 Nov 2026 13:53:52 -0500
Message-Id: <20261108185406.1549770-16-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains, as on CPU hotplug, clears their deadline
accounting. dl_rebuild_rd_accounting() then adds back the deadline tasks
of each cpuset. Without CONFIG_CPUSETS, it is a stub. So the first
hotplug drops every deadline task's bandwidth, and their releases wrap
total_bw around. In testing, a root domain admitted 9 tasks of 10ms
every 100ms before a hotplug with deadline sleepers, and none after.

With cpusets, the rebuild skips a cpuset whose nr_deadline_tasks is 0.
This count spares suspend and resume a costly walk of all tasks. An
attach moves it by a tally taken in cpuset_can_attach(). A task that
leaves the class between the tally and the move is taken off the old
cpuset twice. Its count can then reach 0 with a deadline task in it.
Every rebuild would then drop that task's bandwidth.

Fix both by walking the task list, with or without cpusets. The walk
finds every deadline task, so the count and its hooks go. It holds
tasklist_lock for reading, so fork and exit wait meanwhile. It locks
only deadline tasks, where the walk that the count avoided took the
pi_lock of every task. It leaves out an exited task with a dl_bw of 0.
It also leaves out a zombie whose bandwidth an earlier rebuild dropped,
as dl_clear_root_domains() does.

Without cpusets, a new dl_accounting_mutex keeps admissions out of a
rebuild, as cpuset_mutex does with them.

Three hotplug cases of deadline_bw_test, added later in this series,
fail without cpusets. With this patch, its five hotplug cases pass, in 4
VMs. Its death_zombie_hotplug case tests the zombie. The Sashiko AI
reviews of v3, and of v4 before posting, found the drift and the exited
tasks. Its review of v4 found the zombie.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/cpuset.h          |   9 ---
 include/linux/sched/deadline.h  |  16 +++++
 kernel/cgroup/cgroup.c          |   3 -
 kernel/cgroup/cpuset-internal.h |   6 +-
 kernel/cgroup/cpuset.c          |  67 +------------------
 kernel/sched/deadline.c         | 111 +++++++++++++++++++++++++-------
 kernel/sched/syscalls.c         |  14 ++--
 kernel/sched/topology.c         |   8 +++
 8 files changed, 121 insertions(+), 113 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 914983387e95..db1cc2fc0324 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -72,8 +72,6 @@ extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
-extern void inc_dl_tasks_cs(struct task_struct *task);
-extern void dec_dl_tasks_cs(struct task_struct *task);
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
 extern void lockdep_assert_cpuset_lock_held(void);
@@ -129,7 +127,6 @@ static inline int cpuset_do_page_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
-extern void dl_rebuild_rd_accounting(void);
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -194,8 +191,6 @@ static inline void cpuset_update_active_cpus(void)
 	partition_sched_domains(1, NULL, NULL);
 }
 
-static inline void inc_dl_tasks_cs(struct task_struct *task) { }
-static inline void dec_dl_tasks_cs(struct task_struct *task) { }
 static inline void cpuset_lock(void) { }
 static inline void cpuset_unlock(void) { }
 static inline void lockdep_assert_cpuset_lock_held(void) { }
@@ -273,10 +268,6 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
-static inline void dl_rebuild_rd_accounting(void)
-{
-}
-
 static inline void rebuild_sched_domains(void)
 {
 	guard(cpus_read_lock)();
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index a2671cd950b9..5fb57fd7f7a3 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -51,6 +51,22 @@ struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domains(void);
+extern void dl_rebuild_rd_accounting(void);
+/*
+ * Keep a rebuild of the root domains' accounting and an admission of
+ * bandwidth from running at the same time. With cpusets, cpuset_mutex
+ * does it, since every rebuild comes from the cpuset code. Without
+ * cpusets, dl_accounting_lock() takes a mutex of its own.
+ */
+#ifdef CONFIG_CPUSETS
+static inline void dl_accounting_lock(void) { }
+static inline void dl_accounting_unlock(void) { }
+static inline void lockdep_assert_dl_accounting_held(void) { }
+#else
+extern void dl_accounting_lock(void);
+extern void dl_accounting_unlock(void);
+extern void lockdep_assert_dl_accounting_held(void);
+#endif
 /*
  * Return whether moving DL task @p to @new_mask requires moving DL
  * bandwidth accounting between root domains. This helper is specific to
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a284225f8dc9..2cfa770c2dcb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -7240,9 +7240,6 @@ static void do_cgroup_task_dead(struct task_struct *tsk)
 	if (thread_group_leader(tsk) && atomic_read(&tsk->signal->live))
 		list_add_tail(&tsk->cg_list, &cset->dying_tasks);
 
-	if (dl_task(tsk))
-		dec_dl_tasks_cs(tsk);
-
 	WARN_ON_ONCE(cgroup_task_frozen(tsk));
 	if (unlikely(!(tsk->flags & PF_KTHREAD) &&
 		     test_bit(CGRP_FREEZE, &task_dfl_cgroup(tsk)->flags)))
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 1ba94ffaff9d..bf847953c78d 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -166,11 +166,7 @@ struct cpuset {
 	 */
 	bool remote_partition_updating;
 
-	/*
-	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
-	 * know when to rebuild associated root domain bandwidth information.
-	 */
-	atomic_t nr_deadline_tasks;
+	/* Number of SCHED_DEADLINE tasks the attach in progress moves here. */
 	int nr_migrate_dl_tasks;
 	/* DL bandwidth that needs destination reservation for this attach. */
 	u64 sum_migrate_dl_bw;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4159abfbbbb5..7628cf77bdfd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -225,20 +225,6 @@ struct tmpmasks {
 	cpumask_var_t new_cpus;		/* For update_cpumasks_hier() */
 };
 
-void inc_dl_tasks_cs(struct task_struct *p)
-{
-	struct cpuset *cs = task_cs(p);
-
-	atomic_inc(&cs->nr_deadline_tasks);
-}
-
-void dec_dl_tasks_cs(struct task_struct *p)
-{
-	struct cpuset *cs = task_cs(p);
-
-	atomic_dec(&cs->nr_deadline_tasks);
-}
-
 static inline bool is_partition_valid(const struct cpuset *cs)
 {
 	return cs->partition_root_state > 0;
@@ -965,54 +951,6 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	return ndoms;
 }
 
-static void dl_update_tasks_root_domain(struct cpuset *cs)
-{
-	struct css_task_iter it;
-	struct task_struct *task;
-
-	if (atomic_read(&cs->nr_deadline_tasks) == 0)
-		return;
-
-	css_task_iter_start(&cs->css, 0, &it);
-
-	while ((task = css_task_iter_next(&it)))
-		dl_add_task_root_domain(task);
-
-	css_task_iter_end(&it);
-}
-
-void dl_rebuild_rd_accounting(void)
-{
-	struct cpuset *cs = NULL;
-	struct cgroup_subsys_state *pos_css;
-
-	lockdep_assert_cpuset_lock_held();
-	lockdep_assert_cpus_held();
-	lockdep_assert_held(&sched_domains_mutex);
-
-	dl_clear_root_domains();
-
-	rcu_read_lock();
-
-	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
-
-		if (cpumask_empty(cs->effective_cpus)) {
-			pos_css = css_rightmost_descendant(pos_css);
-			continue;
-		}
-
-		css_get(&cs->css);
-
-		rcu_read_unlock();
-
-		dl_update_tasks_root_domain(cs);
-
-		rcu_read_lock();
-		css_put(&cs->css);
-	}
-	rcu_read_unlock();
-}
-
 /*
  * Rebuild scheduler domains.
  *
@@ -3181,9 +3119,7 @@ static void clear_attach_data(struct llist_head *head, bool cancel)
 	llist_for_each_entry_safe(cs, next, lnode, attach_node) {
 		init_llist_node(&cs->attach_node);
 		if (cs->nr_migrate_dl_tasks) {
-			if (!cancel)
-				atomic_add(cs->nr_migrate_dl_tasks, &cs->nr_deadline_tasks);
-			else if (cs->dl_bw_cpu >= 0) /* && cancel */
+			if (cancel && cs->dl_bw_cpu >= 0)
 				dl_bw_free(cs->dl_bw_cpu, cs->sum_migrate_dl_bw);
 			cs->nr_migrate_dl_tasks = 0;
 			cs->sum_migrate_dl_bw = 0;
@@ -3272,7 +3208,6 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 			 * contribute to sum_migrate_dl_bw.
 			 */
 			cs->nr_migrate_dl_tasks++;
-			oldcs->nr_migrate_dl_tasks--;
 			if (dl_task_needs_bw_move(task, cs->effective_cpus))
 				cs->sum_migrate_dl_bw += task->dl.dl_bw;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9ced697da07c..62b96ce8c2a4 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -281,17 +281,17 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * The timer holds a reference to it.
  *
  * A rebuild of the root domains' accounting (dl_clear_root_domains() and
- * dl_add_task_root_domain()) does not find such a task among the deadline
- * tasks of the cpusets. So dl_departed_list holds these tasks, from their
- * departure to their timer. The rebuild puts their bandwidth back in the
- * root domain of the CPU each one was on when it left.
+ * dl_add_task_root_domain()) does not count such a task as a deadline
+ * task. So dl_departed_list holds these tasks, from their departure to
+ * their timer. The rebuild puts their bandwidth back in the root domain
+ * of the CPU each one was on when it left.
  *
  * dl_bw_gen counts the rebuilds. Each task records its value when its
  * bandwidth is counted. If a rebuild dropped the bandwidth since, there
  * is nothing to remove. A rebuild drops it when the CPU recorded is no
  * longer active. It also drops the bandwidth of a task that dies while
- * the rebuild runs. The cpuset walk skips that task, and it was not dead
- * yet when the list was put back.
+ * the rebuild runs. The walk of the task list does not find that task,
+ * and it was not dead yet when the list was put back.
  *
  * dl_departed_lock protects the list and both counts. Take it with
  * interrupts disabled, under the task's rq lock or pi_lock or in the
@@ -3625,7 +3625,7 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
-/* The caller should hold cpuset_mutex */
+/* From dl_rebuild_rd_accounting(), under the locks it asserts. */
 void dl_add_task_root_domain(struct task_struct *p)
 {
 	struct rq_flags rf;
@@ -3635,7 +3635,13 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	if (!dl_task(p) || dl_entity_is_special(&p->dl)) {
+	/*
+	 * Count nothing for a special entity, or for a task with no
+	 * bandwidth. The walk of the task list also finds exited tasks. An
+	 * exited task whose bandwidth went with its parameters has a dl_bw
+	 * of 0.
+	 */
+	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
 	}
@@ -3658,6 +3664,14 @@ void dl_add_task_root_domain(struct task_struct *p)
 	if (p->dl.dl_bw_gen == dl_bw_gen)
 		goto unlock;
 	if (p->dl.dl_departed_cpu >= 0) {
+		/*
+		 * The walk also finds a dead task that departed before an
+		 * earlier rebuild, if it is not reaped yet. If that rebuild
+		 * dropped its bandwidth, dl_clear_root_domains() skipped it,
+		 * and its release removes nothing. Skip it here too.
+		 */
+		if (p->dl.dl_bw_gen != dl_bw_gen - 1)
+			goto unlock;
 		cpu = p->dl.dl_departed_cpu;
 		if (!cpu_active(cpu))
 			goto unlock;
@@ -3728,13 +3742,70 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
+#ifndef CONFIG_CPUSETS
+/*
+ * With cpusets, cpuset_mutex keeps an admission of bandwidth from running
+ * against a rebuild of the accounting. __sched_setscheduler() takes it for
+ * every change of or into SCHED_DEADLINE. The callers of
+ * partition_sched_domains() hold it from the attachment of the new root
+ * domains to the rebuild. Without cpusets, cpuset_lock() is a stub, and
+ * this mutex takes its place in both.
+ */
+static DEFINE_MUTEX(dl_accounting_mutex);
+
+void dl_accounting_lock(void)
+{
+	mutex_lock(&dl_accounting_mutex);
+}
+
+void dl_accounting_unlock(void)
+{
+	mutex_unlock(&dl_accounting_mutex);
+}
+
+void lockdep_assert_dl_accounting_held(void)
+{
+	lockdep_assert_held(&dl_accounting_mutex);
+}
+#endif /* !CONFIG_CPUSETS */
+
+/*
+ * Rebuild the root domains' accounting. Clear it, then walk all tasks and
+ * count each deadline task again. The caller holds the locks that this
+ * function asserts.
+ */
+void dl_rebuild_rd_accounting(void)
+{
+	struct task_struct *g, *p;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_held(&sched_domains_mutex);
+	lockdep_assert_cpuset_lock_held();
+	lockdep_assert_dl_accounting_held();
+
+	dl_clear_root_domains();
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
+		/*
+		 * Test the class without the task's locks, and take them only
+		 * for a deadline task. A task enters the class under the locks
+		 * this rebuild holds, or by a boost. A boost brings no
+		 * bandwidth of its own to count.
+		 */
+		if (dl_task(p))
+			dl_add_task_root_domain(p);
+	}
+	read_unlock(&tasklist_lock);
+}
+
 /*
  * Clear every root domain before a rebuild of their accounting, and count
  * the rebuild in dl_bw_gen. Put back the bandwidth of their servers. Put
- * back the bandwidth of the tasks on dl_departed_list, which no cpuset
- * holds as deadline tasks. Put each in the root domain of the CPU
- * recorded for it, or drop it if that CPU is not active.
- * dl_add_task_root_domain() then adds the deadline tasks of the cpusets.
+ * back the bandwidth of the tasks on dl_departed_list, which the walk of
+ * the deadline tasks does not count. Put each in the root domain of the
+ * CPU recorded for it, or drop it if that CPU is not active.
+ * dl_add_task_root_domain() then adds the deadline tasks.
  */
 void dl_clear_root_domains(void)
 {
@@ -3791,12 +3862,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		p->dl.runtime = 0;
 	}
 
-	/*
-	 * In case a task is setscheduled out from SCHED_DEADLINE we need to
-	 * keep track of that on its cpuset (for correct bandwidth tracking).
-	 */
-	dec_dl_tasks_cs(p);
-
 	if (!task_on_rq_queued(p)) {
 		bool released = false;
 
@@ -3908,12 +3973,6 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (p->dl.dl_departed_cpu >= 0)
 		dl_task_undepart(p);
 
-	/*
-	 * In case a task is setscheduled to SCHED_DEADLINE we need to keep
-	 * track of that on its cpuset (for correct bandwidth tracking).
-	 */
-	inc_dl_tasks_cs(p);
-
 	/* If p is not queued we will update its parameters at next wakeup. */
 	if (!task_on_rq_queued(p)) {
 		add_rq_bw(&p->dl, &rq->dl);
@@ -4170,10 +4229,12 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 * A task that comes back before its 0-lag time still has the
 	 * bandwidth it left with. The new bandwidth replaces it, so remove the
 	 * old one from the root domain that keeps it (dl_task_release_bw()).
-	 * No rebuild can run meanwhile: the caller holds cpuset_mutex.
+	 * No rebuild can run meanwhile: the caller holds cpuset_mutex, or
+	 * dl_accounting_mutex without cpusets.
 	 */
 	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
 		lockdep_assert_cpuset_lock_held();
+		lockdep_assert_dl_accounting_held();
 		if (p->dl.dl_departed_cpu >= 0)
 			dl_task_release_bw(p, -1);
 		p->dl.dl_bw_gen = dl_bw_gen;
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index c71208b7f9f2..7a76e5f6b0ff 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -568,6 +568,7 @@ int __sched_setscheduler(struct task_struct *p,
 	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
 		cpuset_lock();
+		dl_accounting_lock();
 	}
 
 	/*
@@ -596,9 +597,7 @@ int __sched_setscheduler(struct task_struct *p,
 	 * Reject SCHED_DEADLINE on exited tasks. A zombie will never be
 	 * scheduled again, so sched_dl_overflow() would charge total_bw
 	 * that nothing will ever release. And reject a change of policy of
-	 * one in the class: cgroup_task_dead() took it off the count of
-	 * deadline tasks of its cpuset, which switched_from_dl() would
-	 * decrement a second time.
+	 * one in the class: its bandwidth went at its last schedule.
 	 */
 	if ((dl_policy(policy) || dl_task(p)) && p->exit_state) {
 		retval = -ESRCH;
@@ -663,6 +662,7 @@ int __sched_setscheduler(struct task_struct *p,
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
 		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
 			cpuset_locked = false;
 		}
@@ -767,8 +767,10 @@ int __sched_setscheduler(struct task_struct *p,
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		rt_mutex_adjust_pi(p);
 	}
 
@@ -780,8 +782,10 @@ int __sched_setscheduler(struct task_struct *p,
 
 unlock:
 	task_rq_unlock(rq, p, &rf);
-	if (cpuset_locked)
+	if (cpuset_locked) {
+		dl_accounting_unlock();
 		cpuset_unlock();
+	}
 	return retval;
 }
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 9d3a1b8dd393..35e56a45c238 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3528,7 +3528,15 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			     struct sched_domain_attr *dattr_new)
 {
+	/*
+	 * The root domains attached here count no task's bandwidth until
+	 * dl_rebuild_rd_accounting() at the end. No admission of bandwidth may
+	 * run meanwhile. With cpusets, the callers hold cpuset_mutex, which
+	 * keeps admissions out. Without cpusets, dl_accounting_lock() does it.
+	 */
+	dl_accounting_lock();
 	sched_domains_mutex_lock();
 	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
 	sched_domains_mutex_unlock();
+	dl_accounting_unlock();
 }
-- 
2.47.3

