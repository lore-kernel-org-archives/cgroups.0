Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207357;
	b=CJRufDzSXgAXAuAVr3GYzHJ4/fZKXUciR1hxabittbY0GDbjXx9xC8EEEthXYrVo44i7
	 D8/4wmExs9JPxqn3CkVefDCysqErPgKZs/pU9koUHaGReySfdIIdb7ep+iQFq+hd1io8z
	 OPUvv7PoNtOqCoyEztg/x6U+ZdYuNjz+5oM3sceoan5fPgxwGL/brcqZEzU5GRT6/u2p8
	 oXGg6tVeLMreqomYvTIA2IvQva36l6zfktHAWIpBUeVpZ5lmUVHxbFpFgfMRem/rhwvgY
	 n2BxuKuxSJIG5PxxDPVdVqwdoDSXdXLq5vbaR+z2Oxz9tuqy1R2dWgB6CKAJQUXzlqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207357;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5LDbk/EDroJEfEAwBG/k308gzx8iQTS70NoTJperMko=;
	b=08Bu/XfpQFmucKbSTyu/I7eYviZ9hhfyEwvnaGVpKLCmqj2zkml8hrq/Bd+Vg4w8FliR
	 0MHlX+FQfmSEOag1MIU12q1BMVVVoF/uHca79QkQy+x6ZngL4BZX7r30IohEyByN2ay+I
	 Sg1gQFBjE+eORlz2yaia88XCbDqAp4fcStwhwRPDCrZA2ln/QYBQ/aKF6+CvVzzqtjKt0
	 Lowz4DOpHljPPTs5RY6fSqnrwPd/R4KTiS+mQ3x3vDaMRwTV2Z8yjrX7UKLHiSL56ZBi7
	 I+0SiGzdigaoXIFFDTZhyRdRdpNbFUciBt2O1fkCn1ng4Xg4jZ2sx+NHQC2SBTdKMZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nCcKyHbo;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64EB606A6ED;
	Fri, 20 Nov 2026 20:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C64EB606A6ED
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nCcKyHbo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207347;
	bh=5LDbk/EDroJEfEAwBG/k308gzx8iQTS70NoTJperMko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCcKyHbojb6cr5BXW+YlYrBlXS+KmWEPHF+88I0DZNkm4L6UbB/6HbSapOnAtMgRN
	 1QzavAjdJiF+1mNx8DT8Dl7tWT1/D6jke3deWT4XF0vmxrMNE0sL1q7amto3ZjLX4h
	 VugfFZDXuUo+FXldO2QolGNBdDT0uv1iFT+SD2tsAYoEXLB5ZBSGtwCdG3S2b18A3O
	 UPAUn7EzQdLLLAFCEyE8u7jxP2XPhmS62CJWKX6t6LmR550llTW00vK7PehSsjAvcg
	 kbFHHbmVsl5p/tobbqd9/KBJBxyFPbGOb26xh+vW0VEY6motj8HjftdxfJg0OE0gLk
	 HaObUQHOaQcmA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2972QNzTqV;
	Fri, 20 Nov 2026 15:42:25 -0500 (EST)
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
Subject: [PATCH v10 02/40] sched/deadline: Rebuild the root domains' accounting from the task list
Date: Fri, 20 Nov 2026 15:41:39 -0500
Message-Id: <377326298c82a348a70968f9a3515d0454c1abdb.1795207232.git.mathieu.desnoyers@efficios.com>
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
tasklist_lock for reading, so fork and exit wait meanwhile. It takes
the pi_lock of deadline tasks only. The walk that the count avoided
took the pi_lock of every task. It leaves out an exited task with a
dl_bw of 0. It also leaves out a zombie whose bandwidth an earlier
rebuild dropped, as dl_clear_root_domains() does.

The walk visits every thread, and a suspend or a resume runs one
rebuild for each CPU. So keep one count for the whole system,
dl_nr_bw_tasks: the number of tasks whose dl_bw is not 0.
__setparam_dl() and __dl_clear_params() are the only places that change
the dl_bw of a task, and they update the count. With a count of 0, the
rebuild does not walk the task list, as Juri Lelli suggested.

In testing, a 64-vCPU guest held 10000 threads and no deadline task. A
rebuild took 0.7 to 1.2 ms without the count, and 0.03 ms with it.

Without cpusets, a new dl_accounting_mutex keeps admissions out of a
rebuild, as cpuset_mutex does with them.

Three hotplug cases, added to deadline_bw_test later in this series,
fail without cpusets. With this patch, its five hotplug cases pass, in 4
VMs. Its death_zombie_hotplug case tests the zombie. The Sashiko AI
reviews of this series found the wrong count, the exited tasks and the
zombie.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h          |   9 --
 include/linux/sched/deadline.h  |  16 ++++
 kernel/cgroup/cgroup.c          |   3 -
 kernel/cgroup/cpuset-internal.h |   6 +-
 kernel/cgroup/cpuset.c          |  67 +-------------
 kernel/sched/deadline.c         | 154 ++++++++++++++++++++++++++------
 kernel/sched/syscalls.c         |  14 +--
 kernel/sched/topology.c         |   8 ++
 8 files changed, 163 insertions(+), 114 deletions(-)

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
index bdf39ac1d43d..60be226699bb 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -33,6 +33,22 @@ struct root_domain;
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
index c2b5b5fdf1b9..d1a2ae9ab75f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -230,10 +230,10 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
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
  * dl_bw_gen numbers the rebuilds of the accounting: how many times the
  * root domains were wiped and reconstructed (dl_clear_root_domains()
@@ -241,7 +241,7 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * state, counted or settled. That number dates the state:
  *
  *  - Current: the bandwidth is counted, or a release settled it since
- *    the rebuild began. A release subtracts; the walk of the cpusets
+ *    the rebuild began. A release subtracts; the walk of the task list
  *    skips.
  *  - One behind: the clear that just ran wiped it. The rebuild puts
  *    it back.
@@ -254,8 +254,8 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  *
  * A rebuild drops the bandwidth when the CPU recorded is no longer
  * active. It also drops the bandwidth of a task that dies while the
- * rebuild runs. The cpuset walk skips that task, and it was not dead yet
- * when the list was put back.
+ * rebuild runs. The walk of the task list does not find that task, and
+ * it was not dead yet when the list was put back.
  *
  * dl_departed_lock protects the list and both counts. Take it with
  * interrupts disabled, under the task's rq lock or pi_lock or in the
@@ -265,6 +265,22 @@ static LIST_HEAD(dl_departed_list);
 static DEFINE_RAW_SPINLOCK(dl_departed_lock);
 static unsigned int dl_bw_gen;
 
+/*
+ * The number of tasks with a bandwidth: those whose dl_bw is not 0. A
+ * special entity and a server are not counted. __setparam_dl() and
+ * __dl_clear_params() are the only places that change the dl_bw of a
+ * task, and they update the count. With a count of 0, a rebuild of the
+ * accounting has no task to count, and does not walk the task list.
+ */
+static atomic_t dl_nr_bw_tasks;
+
+/* Return true if @dl_se is a task that holds a bandwidth. */
+static inline bool dl_se_holds_bw(struct sched_dl_entity *dl_se)
+{
+	return dl_se->dl_bw && !dl_se->dl_server &&
+	       !(dl_se->flags & SCHED_FLAG_SUGOV);
+}
+
 /*
  * Put @p on dl_departed_list with @cpu, a CPU of the root domain that
  * keeps its bandwidth. @p leaves SCHED_DEADLINE, or dies, before its
@@ -3675,7 +3691,7 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
-/* The caller should hold cpuset_mutex */
+/* From dl_rebuild_rd_accounting(), under the locks it asserts. */
 void dl_add_task_root_domain(struct task_struct *p)
 {
 	struct rq_flags rf;
@@ -3685,7 +3701,13 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3708,6 +3730,14 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3778,13 +3808,80 @@ void dl_clear_root_domain(struct root_domain *rd)
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
+	/*
+	 * Without a task that holds a bandwidth, there is nothing to count.
+	 * The walk would still visit every thread of the system. A CPU
+	 * that goes offline or comes back runs a rebuild, so a suspend and
+	 * a resume run one for each CPU. A task gets a bandwidth under the
+	 * locks this rebuild holds, so the count cannot leave 0 meanwhile.
+	 */
+	if (!atomic_read(&dl_nr_bw_tasks))
+		return;
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
@@ -3848,12 +3945,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		p->dl.runtime = 0;
 	}
 
-	/*
-	 * In case a task is setscheduled out from SCHED_DEADLINE we need to
-	 * keep track of that on its cpuset (for correct bandwidth tracking).
-	 */
-	dec_dl_tasks_cs(p);
-
 	if (!task_on_rq_queued(p)) {
 		/*
 		 * Inactive timer is armed. However, p is leaving DEADLINE and
@@ -3923,12 +4014,6 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (!list_empty(&p->dl.dl_departed_node))
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
@@ -4185,10 +4270,12 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4208,12 +4295,18 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	bool held;
 
+	held = dl_se_holds_bw(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
 	dl_se->flags = attr->sched_flags & SCHED_DL_FLAGS;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
+	if (dl_se_holds_bw(dl_se) && !held)
+		atomic_inc(&dl_nr_bw_tasks);
+	else if (!dl_se_holds_bw(dl_se) && held)
+		atomic_dec(&dl_nr_bw_tasks);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
 }
 
@@ -4303,6 +4396,9 @@ bool __checkparam_dl(const struct sched_attr *attr)
  */
 static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
+	if (dl_se_holds_bw(dl_se))
+		WARN_ON_ONCE(atomic_dec_return(&dl_nr_bw_tasks) < 0);
+
 	dl_se->dl_runtime		= 0;
 	dl_se->dl_deadline		= 0;
 	dl_se->dl_period		= 0;
@@ -4333,6 +4429,12 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	RB_CLEAR_NODE(&dl_se->rb_node);
 	init_dl_task_timer(dl_se);
 	init_dl_inactive_task_timer(dl_se);
+	/*
+	 * A new task has a copy of the entity of its parent. That copy
+	 * holds no bandwidth, and dl_nr_bw_tasks does not count it. Clear
+	 * dl_bw first, so that __dl_clear_params() leaves the count alone.
+	 */
+	dl_se->dl_bw = 0;
 	__dl_clear_params(dl_se);
 	INIT_LIST_HEAD(&dl_se->dl_departed_node);
 	dl_se->dl_departed_cpu = -1;
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 5983232476a9..96a5f0a7adbc 100644
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
@@ -669,6 +668,7 @@ int __sched_setscheduler(struct task_struct *p,
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
 		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
 			cpuset_locked = false;
 		}
@@ -779,8 +779,10 @@ int __sched_setscheduler(struct task_struct *p,
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		rt_mutex_adjust_pi(p);
 	}
 
@@ -792,8 +794,10 @@ int __sched_setscheduler(struct task_struct *p,
 
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

