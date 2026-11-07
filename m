Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015905;
	b=aYU2jM530HlipFOgA+WJx7sbQ8sIy1/gH3WN+pzkmaMrehWlYDVriZD2C7FK1bFym0Zw
	 zXoeqV/wT1l1WdczksVRH+tMB5pAR/l1OvU15++rzlgnDiE2aRf/mpRfBGavQIgQh+Y/j
	 uN171JDo2v+Y+0ZjXwyBybTP5TOeI9XQoynm+ICcfGbWns11pXPKTqWHXpNMeczSNmmK2
	 KcAB4pZ71RWGzEqve88u9MIE2Bhm6lzzr8/DoFz9724HrWCczhxSAh4X6kCfwK/xUb8VT
	 AdTXgyHgqWtg1bgUBKFYLyKC1QgU4HdZ3A9RRa5+ok2M4Y9dZpZeemWzcRniqALIiVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015905;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=beDNlzSc2sY3LTylHAcyZ3fJeJuMrMYzWyqbuqHHc1k=;
	b=0gpXo5yN6wFu9oE/mYdhkdl9LRMmO9aLQJtnXckAqPBUVvXvB25VoA8MO5pIqkEAqA0L
	 rlTQALodVrzDADhVJRhdLu+GDxJsHD0mwAwqrbhYUlsdhTx3xWKuc00RkqPyXiUgyYUzF
	 JZkNY6/rfaFqcSfp3ohp9SDTDBJpPcqcyzYfgoirLvyqQGEwRAodecAjehA6PuyT2Uw2k
	 6n8x1UD7z3slTC5uEDSyu94deRAOM5MdDqoplDasAPz4WXhsTNkhSkEePGiT+PN98wSAb
	 lJpHJ0EGSE1cy27uzllNc04jmN3mVHmOQ00vR0/wskvHnStxmk+43cC78jC/cOAwlNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ugRfYIYy;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DF606EE96;
	Sat,  7 Nov 2026 01:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C6DF606EE96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ugRfYIYy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015904;
	bh=beDNlzSc2sY3LTylHAcyZ3fJeJuMrMYzWyqbuqHHc1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugRfYIYyukxCCc2Xh311KKOKzwKtIbtfDFTWON40X4DGN9+W4SLdeR9rkr/7jLTWB
	 g0jEa8+GbrpIz6YebZ/BWR7+Ww/WnOQeU3b9psowabdzVU/MTgEBd+eoyvMAbbCRDd
	 mZXRHGZTtq74XaiKPWITE5YT692PjQ1m2PPX+BlVq81YGwgS2yJwUlCyFReOX+sW0t
	 8TNOTE5u2QMs1nOGrpQkdghToKhr2L7fyKg5cczwyRC1cZ3SoW8DOay2BLEB0Nz1zj
	 PfYXdgh4/2Ok+yS6vjFOGRlt0ivI3jyuXvm2/vLHZjk3NOpYeqftHJ6RQ+2uFk+ScE
	 NiIWSXBat6pvw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPq6rHlzLKf;
	Fri, 06 Nov 2026 20:45:03 -0500 (EST)
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
Subject: [PATCH v4 14/26] sched/deadline: Rebuild the root domains' accounting from the task list
Date: Fri,  6 Nov 2026 20:44:39 -0500
Message-Id: <20261107014451.1487825-15-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

A change of the root domains, which CPU hotplug and suspend and resume
make, clears their deadline accounting and fills it back with the
servers of each CPU and the deadline tasks of each cpuset. The task walk
lives in the cpuset code, dl_rebuild_rd_accounting(), and is a stub
without CONFIG_CPUSETS: such a kernel loses the bandwidth of every
deadline task at the first hotplug. Each task still takes its bandwidth
out of total_bw once it leaves SCHED_DEADLINE, or dies: total_bw
underflows, and admission afterwards refuses every deadline task of the
root domain.

With cpusets, the walk skips a cpuset whose nr_deadline_tasks is 0. An
attach moves that count by a tally taken in cpuset_can_attach(), while a
change of class counts the task on the cpuset it is in at the time: a
task that leaves the class between the tally and the move is taken off
the old cpuset twice, and the next deadline task there brings the count
to 0. Every rebuild then drops the bandwidth of the deadline tasks of
that cpuset, for good. A boost into the class and its deboost count
without cpuset_mutex, so nothing orders them against the attach.

Walk the tasks instead, with or without cpusets, under tasklist_lock
held for reading, which fork and exit wait for meanwhile: the walk finds
every deadline task, and the count goes, with the hooks that kept it. A
rebuild then tests the class of every task, without its lock, where the
count let it skip a cpuset with no deadline task. The walk finds exited
tasks too: one whose dl_bw is 0 is left out, as the cpuset walk left it.
Admission must not run against the rebuild: cpuset_mutex sees to it with
cpusets, held by __sched_setscheduler() over sched_dl_overflow() and by
the cpuset code from partition_sched_domains() to the rebuild, and a
mutex of the deadline code's own takes its place at both without.

In 8-CPU VMs built without CONFIG_CPUSETS, the hotplug_sleepers case of
the selftest added later in this series admits 9 tasks of 10ms every
100ms before taking a CPU offline and back, and 0 after, on v7.4-rc1 as
with the patches before this one; hotplug_departed and
hotplug_server_refused fail after it, and two more hotplug cases skip
for want of room. The five pass with this change, in 4 VMs, with no
warning. The drift of the count was found by the Sashiko AI review of
the third posting of this series, and the exited tasks by its review of
v4 before posting.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/cpuset.h          |  9 ---
 include/linux/sched/deadline.h  | 16 ++++++
 kernel/cgroup/cgroup.c          |  3 -
 kernel/cgroup/cpuset-internal.h |  6 +-
 kernel/cgroup/cpuset.c          | 67 +----------------------
 kernel/sched/deadline.c         | 97 +++++++++++++++++++++++++--------
 kernel/sched/syscalls.c         | 14 +++--
 kernel/sched/topology.c         |  9 +++
 8 files changed, 111 insertions(+), 110 deletions(-)

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
index 12c5d8486b09..7c99776af136 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -50,6 +50,22 @@ struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domains(void);
+extern void dl_rebuild_rd_accounting(void);
+/*
+ * The lock that keeps a rebuild of the root domains' accounting from running
+ * against an admission of bandwidth: cpuset_mutex where cpusets are built in,
+ * since every rebuild comes from there, and a lock of the deadline class's own
+ * where they are not.
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
index 1ba94ffaff9d..153067b164c1 100644
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
+	/* SCHED_DEADLINE tasks of the attach in progress moving here. */
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
index 6b0ec2003857..45a896a4f461 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -266,7 +266,7 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * its bandwidth in total_bw until then: the inactive timer removes it. A
  * rebuild of the root domains' accounting meanwhile (dl_clear_root_domains()
  * and dl_add_task_root_domain(), on any change of the partitions or CPU
- * hotplug) finds no such task among the deadline tasks of the cpusets: it
+ * hotplug) finds no such task among the deadline tasks: it
  * puts that bandwidth back from dl_departed_list, which holds them from
  * their departure to their timer, in the root domain of the CPU each was
  * on when it left, or died. The task may run anywhere meanwhile, as
@@ -275,7 +275,7 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * dl_bw_gen counts the rebuilds, and each task records the one that last
  * counted its bandwidth. A rebuild that dropped it since then leaves
  * nothing to remove: the CPU recorded was no longer active, or the task
- * exited while the rebuild ran, which the cpuset walk skips, and was not
+ * exited while the rebuild ran, which the walk does not find, and was not
  * dead yet when the list was put back. Both counts, and the list, are under
  * dl_departed_lock, taken with interrupts disabled (under the task's rq
  * lock or pi_lock, or by the rebuild) and before any dl_bw lock.
@@ -3602,7 +3602,7 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
-/* The caller should hold cpuset_mutex */
+/* From dl_rebuild_rd_accounting(), under the locks it asserts. */
 void dl_add_task_root_domain(struct task_struct *p)
 {
 	struct rq_flags rf;
@@ -3612,7 +3612,12 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	if (!dl_task(p) || dl_entity_is_special(&p->dl)) {
+	/*
+	 * Nothing to count for a special entity, nor for a task with no
+	 * bandwidth, such as an exited one whose bandwidth went with its
+	 * parameters, which the walk of the task list finds too.
+	 */
+	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
 	}
@@ -3705,13 +3710,71 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
+#ifndef CONFIG_CPUSETS
+/*
+ * Where cpusets are built in, cpuset_mutex keeps an admission of bandwidth
+ * from running against a rebuild of the accounting: __sched_setscheduler()
+ * takes it for every change of or into SCHED_DEADLINE, and the callers of
+ * partition_sched_domains() hold it from the attachment of the new root
+ * domains to the rebuild. Where they are not, cpuset_lock() is a stub and
+ * this takes its place, in both.
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
+ * Rebuild the root domains' accounting: clear it, then count every
+ * deadline task of the system again, found by walking them all. No
+ * cpuset tells which hold any: a count of theirs went wrong across an
+ * attach.
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
+		 * Tested without the task's lock first, to spare the others
+		 * the locks: a task enters the class under the locks this
+		 * rebuild holds, or by a boost, which brings it no bandwidth
+		 * of its own to count.
+		 */
+		if (dl_task(p))
+			dl_add_task_root_domain(p);
+	}
+	read_unlock(&tasklist_lock);
+}
+
 /*
  * Clear every root domain ahead of a rebuild of their accounting, which
- * dl_add_task_root_domain() then fills with the deadline tasks of the
- * cpusets: put back their servers, and the bandwidth of the tasks that
- * left SCHED_DEADLINE, or died, before their 0-lag time, which no cpuset
- * holds as a deadline task, in the root domain of the CPU recorded for
- * each; dropped if it is no longer active.
+ * dl_add_task_root_domain() then fills with the deadline tasks: put back
+ * their servers, and the bandwidth of the tasks that left SCHED_DEADLINE,
+ * or died, before their 0-lag time, which that walk does not count, in
+ * the root domain of the CPU recorded for each; dropped if it is no
+ * longer active.
  */
 void dl_clear_root_domains(void)
 {
@@ -3769,12 +3832,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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
 
@@ -3884,12 +3941,6 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
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
@@ -4146,10 +4197,12 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 * Back before its 0-lag time, the task still has the bandwidth it
 	 * left with, which the new one replaces: removed from the root
 	 * domain that keeps it (dl_task_release_bw()). A rebuild cannot
-	 * run meanwhile: the caller holds cpuset_mutex.
+	 * run meanwhile: the caller holds cpuset_mutex, or the lock of
+	 * dl_accounting_lock() without cpusets.
 	 */
 	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
 		lockdep_assert_cpuset_lock_held();
+		lockdep_assert_dl_accounting_held();
 		if (p->dl.dl_departed_cpu >= 0)
 			dl_task_release_bw(p, -1);
 		p->dl.dl_bw_gen = dl_bw_gen;
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 12830e4f8842..29a2c1db2343 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -560,6 +560,7 @@ int __sched_setscheduler(struct task_struct *p,
 	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
 		cpuset_lock();
+		dl_accounting_lock();
 	}
 
 	/*
@@ -588,9 +589,7 @@ int __sched_setscheduler(struct task_struct *p,
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
@@ -655,6 +654,7 @@ int __sched_setscheduler(struct task_struct *p,
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
 		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
 			cpuset_locked = false;
 		}
@@ -759,8 +759,10 @@ int __sched_setscheduler(struct task_struct *p,
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		rt_mutex_adjust_pi(p);
 	}
 
@@ -772,8 +774,10 @@ int __sched_setscheduler(struct task_struct *p,
 
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
index 9d3a1b8dd393..2fce33783e81 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3528,7 +3528,16 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			     struct sched_domain_attr *dattr_new)
 {
+	/*
+	 * The root domains attached here count no task's bandwidth until
+	 * dl_rebuild_rd_accounting() at the end: no admission of bandwidth
+	 * may run meanwhile. The callers of this hold cpuset_mutex, which
+	 * keeps admissions out, where cpusets are built in; the lock
+	 * dl_accounting_lock() takes stands in for it where they are not.
+	 */
+	dl_accounting_lock();
 	sched_domains_mutex_lock();
 	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
 	sched_domains_mutex_unlock();
+	dl_accounting_unlock();
 }
-- 
2.47.3

