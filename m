Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164067;
	b=Lena/8BSr8Pv3/oqNxoFjuXOaCfjt3cxb/9o+dAw8aWLaAC/dEMOP3e1wd7INKAwZo0m
	 aQdE/hjRCUKaDS6FX/1TkxYegkeLEN4q/8gw4nOJg9W/q80KAb7y129yR3VIQJgKua3n3
	 IociBZT3YLWP8kWpPv++iriwtECcL+fPOD1b5uFdhA0V1fa4fT+NtvsnJJU4oLVNg1KUj
	 4KZjpNXP7FVQLdtUZBLAdcuCTyjYChh+9YIKlypjkyUbMsSnQ+f16zOw13L0/yczWn4CU
	 nRjsRJ9H0QMwRRkfSUyg+A42zHrj2OQ3+XN4Fb4Bk9u37eXjIb+9u5Zn31PtSpnj3Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164067;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TTPG/eCYA6s/HmjnR+O4ajZMrgtX9tw4HbmAxRg2LCg=;
	b=rY229xhG7dVICV2uX92Ts248bWbPog1s55c0zOqYMv4MOFNdmhGubdEKfoyHkj22hpcP
	 lCeeBlPa3jWnp1Aj3fkCQWiuSI38lucnys1ON/bgPfvgVGmTkxPawvEjkr4MFUw3UFPlG
	 szbW0ONqDJ++LBnL3nTfNtwgY5TnawyheukgWzC8i812b7nA6IuytRPCVNggDdglhHEUX
	 Z77hyaetEH821YHloJX3pQX7/W60CvnOKubDEb8TcamRMUfu5dxFCNTKmawj9Xp+n3oLk
	 f7ecu4Qr9peCDzBvIAoHefFE0aI/MXkVazXtsRa1VL7kLe3MNl/5o5VNflQ6kqhXU9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Kqw6YKNc;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27286083601;
	Sun,  8 Nov 2026 18:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F27286083601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Kqw6YKNc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164065;
	bh=TTPG/eCYA6s/HmjnR+O4ajZMrgtX9tw4HbmAxRg2LCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqw6YKNctAficGx4ZIF1otUbbn9MyB8q/1382B+ZoUc2RWXtQiLXlbokV/BCtKeyQ
	 0wkQPiD/Csk+hFkvmLc3h+T2BpdT5YZKgY9Uq/S54OlCS+fc1f6lLsyLmuiCXBx+2Y
	 frQ0K0Z6nvuzD4YRy3ZglEy7SIIu65h6blJJxQ5xnJpvSFdH4RWjA5VVepyqsv8fqF
	 kJB5Hv7v2XOAm+MmP0v1QAe+WW7nZVlQhE5xwRZra5IH6VbIn4vytyziPX/1bXUrPo
	 ikbTKlVqmZk2SSa8t/M0E70uvoSRX60fAbmdckXvhLut6ksZXAvjE1lt65rOcZyemP
	 J/N2vZqbbmJIw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C46w1LzM5x;
	Sun, 08 Nov 2026 13:54:24 -0500 (EST)
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
Subject: [PATCH v5 21/29] cgroup/cpuset: Reserve the bandwidth in the root domain a task moves to
Date: Sun,  8 Nov 2026 13:53:58 -0500
Message-Id: <20261108185406.1549770-22-mathieu.desnoyers@efficios.com>
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

Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
migrating tasks between exclusive cpusets") moves a deadline task's
bandwidth in two halves. cpuset_can_attach() reserves it in the
destination. set_cpus_allowed_dl() frees it in the source when the
task's affinity changes. The reservation goes to the root domain of the
first active CPU of the destination cpuset. So cpuset_can_attach()
treats the cpuset as one root domain.

But a cpuset can span more than one root domain. With isolcpus=domain,
the root cpuset holds the isolated CPUs, which are in the default root
domain. A task also keeps the affinity set by sched_setaffinity(). Its
new CPUs can then all be in a root domain that got no reservation. That
root domain counts the task.

Take isolcpus=domain,1,2 and a partition root P of CPU 4. A deadline
task T, pinned to CPUs 1-2, is moved into P and back to the root cgroup:

                                       total_bw of the root domain of
  admin, task T                        CPUs 0, 3   CPUs 1, 2   CPU 4 (P)

  sched_setaffinity(T, CPUs 1-2)
  sched_setattr(T, SCHED_DEADLINE)                 + bw
  echo T > P/cgroup.procs
    cpuset_can_attach()
      reserves on CPU 4                                        + bw
    set_cpus_allowed_dl()
      frees where recorded, CPU 1                  - bw
      records CPU 4
  T runs on CPU 4
  echo T > cgroup.procs of the root
    cpuset_can_attach()
      reserves on CPU 0                + bw
    set_cpus_allowed_dl()
      keeps T's affinity: CPUs 1-2
      frees where recorded, CPU 4                              - bw
      records CPU 1
  T runs on CPU 1
  T exits
    releases where recorded, CPU 1                 - bw
                                       ---------   ---------   ---------
  left after T exits                   + bw        - bw        0

The root domain of CPUs 0 and 3 keeps a reservation that nothing uses.
The root domain of CPUs 1 and 2 counts T, but reserved nothing for it.
In testing, its total_bw went below zero when T died. It then refused
every deadline task, until the next rebuild of the accounting.

Fix this by reserving the bandwidth on the CPU that the move records
with it. The new dl_task_bw_move_cpu() returns that CPU. It is the CPU
the task is on, if the task can stay there. Else it is the first active
CPU of the new mask, a housekeeping one if any. The rebuild of the
accounting makes the same choice, later in this series.
cpuset_can_attach() reserves the bandwidth per such CPU, and refuses
with EBUSY as before. A task's bandwidth then moves only to a CPU whose
sum still covers it. cpuset_attach() gives back the rest.

A new mask can also span both root domains. A running task would then go
to the CPU that cpumask_any_and_distribute() picks. A sleeping one would
wake up where select_fallback_rq() picks. Either CPU can be in the root
domain without the reservation. So __set_cpus_allowed_ptr_locked() takes
the CPU with the reservation, if distribute picked a CPU of the other
root domain. A sleeping task gets the CPU chosen as its wakeup CPU.

The sums are per CPU, since one cpuset can need room in two root
domains. They are global: cgroup_mutex lets one attach run at a time.
guarantee_active_cpus() now takes the cpuset to start from.

Later in this series, deadline_bw_test gets four cases for this:
move_isolated, move_isolated_refused, move_isolated_asleep and
move_spanning. Without this patch, all four fail with
isolcpus=domain,1,2. With isolcpus=domain,0,1, move_isolated,
move_spanning and six other move cases fail.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           |   2 +-
 include/linux/sched/deadline.h  |  15 +--
 kernel/cgroup/cpuset-internal.h |  12 --
 kernel/cgroup/cpuset.c          | 200 ++++++++++++++++++--------------
 kernel/sched/core.c             |  27 ++++-
 kernel/sched/deadline.c         |  62 ++++++++--
 kernel/sched/sched.h            |   2 +
 7 files changed, 196 insertions(+), 124 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2afa50aa3e54..78d3b931d82b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1981,7 +1981,7 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
 					const struct cpumask *new_mask,
-					u64 *moved);
+					int cpu, u64 *moved);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 5fb57fd7f7a3..a62c86c48974 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -68,14 +68,15 @@ extern void dl_accounting_unlock(void);
 extern void lockdep_assert_dl_accounting_held(void);
 #endif
 /*
- * Return whether moving DL task @p to @new_mask requires moving DL
- * bandwidth accounting between root domains. This helper is specific to
- * DL bandwidth move accounting semantics and is shared by
- * cpuset_can_attach() and set_cpus_allowed_dl() so both paths use the
- * same source root-domain test.
+ * Return the CPU that a move of DL task @p to the CPUs of @new_mask
+ * records with its DL bandwidth. Return -1 if the bandwidth stays in the
+ * root domain that counts it. Like the move, keep the CPUs within the
+ * affinity set by the user. cpuset_can_attach() reserves the bandwidth in
+ * the root domain of that CPU. cpuset_attach_task() then moves it there,
+ * and set_cpus_allowed_dl() makes the same test.
  */
-extern bool dl_task_needs_bw_move(struct task_struct *p,
-				  const struct cpumask *new_mask);
+extern int dl_task_bw_move_cpu(struct task_struct *p,
+			       const struct cpumask *new_mask);
 
 static inline bool dl_server(struct sched_dl_entity *dl_se)
 {
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 93aa46d76b04..a83443dfb788 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -166,18 +166,6 @@ struct cpuset {
 	 */
 	bool remote_partition_updating;
 
-	/* Number of SCHED_DEADLINE tasks the attach in progress moves here. */
-	int nr_migrate_dl_tasks;
-	/* DL bandwidth that needs destination reservation for this attach. */
-	u64 sum_migrate_dl_bw;
-	/* The part of sum_migrate_dl_bw moved. The rest is given back. */
-	u64 sum_moved_dl_bw;
-	/*
-	 * CPU used for temporary DL bandwidth allocation during attach;
-	 * -1 if no DL bandwidth was allocated in the current attach.
-	 */
-	int dl_bw_cpu;
-
 	/* Invalid partition error code, not lock protected */
 	enum prs_errcode prs_err;
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ed77fc915261..d865903cc5cb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -272,7 +272,6 @@ struct cpuset top_cpuset = {
 	.flags = BIT(CS_CPU_EXCLUSIVE) |
 		 BIT(CS_MEM_EXCLUSIVE) | BIT(CS_SCHED_LOAD_BALANCE),
 	.partition_root_state = PRS_ROOT,
-	.dl_bw_cpu = -1,
 };
 
 /**
@@ -476,28 +475,24 @@ static inline bool partition_is_populated(struct cpuset *cs,
 }
 
 /*
- * Return in pmask the portion of a task's cpusets's cpus_allowed that
- * are online and are capable of running the task.  If none are found,
- * walk up the cpuset hierarchy until we find one that does have some
- * appropriate cpus.
+ * Return in pmask the portion of the cpus_allowed of @cs that are online
+ * and are capable of running @tsk.  If none are found, walk up the cpuset
+ * hierarchy until we find one that does have some appropriate cpus.
  *
  * One way or another, we guarantee to return some non-empty subset
  * of cpu_active_mask.
  *
  * Call with callback_lock or cpuset_mutex held.
  */
-static void guarantee_active_cpus(struct task_struct *tsk,
+static void guarantee_active_cpus(struct cpuset *cs, struct task_struct *tsk,
 				  struct cpumask *pmask)
 {
 	const struct cpumask *possible_mask = task_cpu_possible_mask(tsk);
-	struct cpuset *cs;
 
 	if (WARN_ON(!cpumask_and(pmask, possible_mask, cpu_active_mask)))
 		cpumask_copy(pmask, cpu_active_mask);
 
 	rcu_read_lock();
-	cs = task_cs(tsk);
-
 	while (!cpumask_intersects(cs->effective_cpus, pmask)) {
 		cs = parent_cs(cs);
 		if (unlikely(!cs)) {
@@ -619,7 +614,6 @@ struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
-	trial->dl_bw_cpu = -1;
 	init_llist_node(&trial->attach_node);
 
 	/* Setup cpumask pointer array */
@@ -3095,61 +3089,87 @@ static int cpuset_can_attach_check(struct cpuset *cs, struct cpuset *oldcs,
 	return 0;
 }
 
+/*
+ * The deadline bandwidth of the attach in progress, per CPU. When the
+ * bandwidth of a deadline task moves to another root domain, the move
+ * records it with the CPU that dl_task_bw_move_cpu() returns.
+ * cpuset_can_attach() sums the bandwidth of these tasks per such CPU. It
+ * reserves each sum in the root domain of its CPU. cpuset_attach_task()
+ * counts what it moves, and cpuset_attach() gives back the rest.
+ * dl_attach_cpus holds the CPUs with a sum. cgroup_mutex lets one attach
+ * run at a time, and cpuset_mutex protects these.
+ */
+struct cpuset_dl_bw {
+	u64	sum;
+	u64	moved;		/* the part of sum moved */
+	bool	reserved;	/* dl_bw_alloc() took sum */
+};
+
+static DEFINE_PER_CPU(struct cpuset_dl_bw, cpuset_dl_bw);
+static cpumask_var_t dl_attach_cpus;
+
 static int cpuset_reserve_dl_bw(void)
 {
-	struct cpuset *cs;
 	int cpu, ret;
 
-	llist_for_each_entry(cs, dst_cs_head.first, attach_node) {
-		if (!cs->sum_migrate_dl_bw)
-			continue;
-
-		cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
-		if (unlikely(cpu >= nr_cpu_ids))
-			return -EINVAL;
+	for_each_cpu(cpu, dl_attach_cpus) {
+		struct cpuset_dl_bw *b = per_cpu_ptr(&cpuset_dl_bw, cpu);
 
-		ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
+		ret = dl_bw_alloc(cpu, b->sum);
 		if (ret)
 			return ret;
-
-		cs->dl_bw_cpu = cpu;
+		b->reserved = true;
 	}
 	return 0;
 }
 
 /*
- * Clear and optionally apply (@cancel is false) the attach related data in the
- * source or destination cpuset.
+ * Give back the bandwidth the attach reserved and did not move. If the
+ * attach is cancelled, that is all of the reservation. Otherwise, it is
+ * what no move used, such as the part for a task that left
+ * SCHED_DEADLINE. The class it left releases its own bandwidth, from the
+ * root domain that counts it.
  */
-static void clear_attach_data(struct llist_head *head, bool cancel)
+static void cpuset_free_dl_bw(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, dl_attach_cpus) {
+		struct cpuset_dl_bw *b = per_cpu_ptr(&cpuset_dl_bw, cpu);
+
+		if (b->reserved && b->sum != b->moved)
+			dl_bw_free(cpu, b->sum - b->moved);
+		*b = (struct cpuset_dl_bw){ };
+	}
+	cpumask_clear(dl_attach_cpus);
+}
+
+/* Empty @head, the list of the source or destination cpusets. */
+static void clear_attach_data(struct llist_head *head)
 {
 	struct cpuset *cs, *next;
 	struct llist_node *lnode = __llist_del_all(head);
 
-	llist_for_each_entry_safe(cs, next, lnode, attach_node) {
+	llist_for_each_entry_safe(cs, next, lnode, attach_node)
 		init_llist_node(&cs->attach_node);
-		if (cs->nr_migrate_dl_tasks) {
-			/*
-			 * Give back the bandwidth the attach did not move.
-			 * If the attach is cancelled, that is all of the
-			 * reservation. Otherwise, it is what no move used,
-			 * such as the part for a task that left
-			 * SCHED_DEADLINE. The class it left releases its own
-			 * bandwidth, from the root domain that counts it.
-			 */
-			if (cs->dl_bw_cpu >= 0) {
-				u64 bw = cancel ? cs->sum_migrate_dl_bw :
-					 cs->sum_migrate_dl_bw - cs->sum_moved_dl_bw;
+}
 
-				if (bw)
-					dl_bw_free(cs->dl_bw_cpu, bw);
-			}
-			cs->nr_migrate_dl_tasks = 0;
-			cs->sum_migrate_dl_bw = 0;
-			cs->sum_moved_dl_bw = 0;
-			cs->dl_bw_cpu = -1;
-		}
-	}
+/*
+ * Protected by cpuset_mutex. cpus_attach is used by cpuset_can_attach() and
+ * cpuset_attach_task(), but we can't allocate it dynamically there. Define
+ * it global and allocate from cpuset_init().
+ */
+static cpumask_var_t cpus_attach;
+
+/* Set @mask to the CPUs that an attach to @cs gives @task. */
+static void cpuset_attach_cpus(struct cpuset *cs, struct task_struct *task,
+			       struct cpumask *mask)
+{
+	if (cs != &top_cpuset)
+		guarantee_active_cpus(cs, task, mask);
+	else
+		cpumask_andnot(mask, task_cpu_possible_mask(task),
+			       subpartitions_cpus);
 }
 
 /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
@@ -3159,7 +3179,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	struct cpuset *cs, *oldcs;
 	struct task_struct *task;
 	bool setsched_check;
-	int ret;
+	int cpu, ret;
 
 	cs = oldcs = NULL;
 	mutex_lock(&cpuset_mutex);
@@ -3225,15 +3245,20 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 				goto out_unlock;
 		}
 
-		if (dl_task(task)) {
-			/*
-			 * Count all migrating DL tasks for cpuset task accounting.
-			 * Only tasks that need a root-domain bandwidth move
-			 * contribute to sum_migrate_dl_bw.
-			 */
-			cs->nr_migrate_dl_tasks++;
-			if (dl_task_needs_bw_move(task, cs->effective_cpus))
-				cs->sum_migrate_dl_bw += task->dl.dl_bw;
+		if (!dl_task(task))
+			continue;
+		/*
+		 * Sum the bandwidth of the deadline tasks that move to another
+		 * root domain, per CPU that the move records. That CPU depends
+		 * on the CPUs the task gets. A cpuset can span more than one
+		 * root domain, and the affinity of a task can keep it in any
+		 * of them.
+		 */
+		cpuset_attach_cpus(cs, task, cpus_attach);
+		cpu = dl_task_bw_move_cpu(task, cpus_attach);
+		if (cpu >= 0) {
+			per_cpu_ptr(&cpuset_dl_bw, cpu)->sum += task->dl.dl_bw;
+			cpumask_set_cpu(cpu, dl_attach_cpus);
 		}
 	}
 
@@ -3257,8 +3282,9 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 
 out_unlock:
 	if (ret) {
-		clear_attach_data(&src_cs_head, true);
-		clear_attach_data(&dst_cs_head, true);
+		clear_attach_data(&src_cs_head);
+		clear_attach_data(&dst_cs_head);
+		cpuset_free_dl_bw();
 	} else {
 		attach_ctx.in_progress++;
 	}
@@ -3271,53 +3297,49 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	mutex_lock(&cpuset_mutex);
 	dec_attach_in_progress_locked();
-	clear_attach_data(&src_cs_head, true);
-	clear_attach_data(&dst_cs_head, true);
+	clear_attach_data(&src_cs_head);
+	clear_attach_data(&dst_cs_head);
+	cpuset_free_dl_bw();
 	mutex_unlock(&cpuset_mutex);
 }
 
-/*
- * Protected by cpuset_mutex. cpus_attach is used only by cpuset_attach_task()
- * but we can't allocate it dynamically there.  Define it global and
- * allocate from cpuset_init().
- */
-static cpumask_var_t cpus_attach;
-
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
-	bool reserved = false;
+	struct cpuset_dl_bw *b = NULL;
 	struct mm_struct *mm;
+	int cpu = -1;
 
 	lockdep_assert_cpuset_lock_held();
 
-	if (cs != &top_cpuset)
-		guarantee_active_cpus(task, cpus_attach);
-	else
-		cpumask_andnot(cpus_attach, task_cpu_possible_mask(task),
-			       subpartitions_cpus);
+	cpuset_attach_cpus(cs, task, cpus_attach);
 	/*
-	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
-	 * deadline tasks that cpuset_can_attach() counted. Flag the move, so
-	 * that the bandwidth of this task moves with it.
+	 * cpuset_reserve_dl_bw() made room for the bandwidth of the deadline
+	 * tasks that cpuset_can_attach() counted, on the CPU each move
+	 * records. Flag the move, so that the bandwidth of this task moves
+	 * with it.
 	 *
-	 * Nothing was reserved for a task that became a deadline task since.
-	 * Flag its move only if the rest of the reservation covers its
-	 * bandwidth.
+	 * Nothing was reserved for a task that became a deadline task since,
+	 * or that changed its affinity. Flag its move only if the rest of the
+	 * reservation on its CPU covers its bandwidth.
 	 */
-	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus) &&
-	    cs->sum_moved_dl_bw + task->dl.dl_bw <= cs->sum_migrate_dl_bw)
-		reserved = true;
+	if (dl_task(task))
+		cpu = dl_task_bw_move_cpu(task, cpus_attach);
+	if (cpu >= 0) {
+		b = per_cpu_ptr(&cpuset_dl_bw, cpu);
+		if (b->moved + task->dl.dl_bw > b->sum)
+			b = NULL;
+	}
 	/*
 	 * can_attach beforehand should guarantee that this doesn't
 	 * fail.  TODO: have a better way to handle failure here
 	 */
-	if (reserved) {
+	if (b) {
 		u64 moved;
 
 		/* Count what the move reports it moved. */
 		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach,
-							  &moved));
-		cs->sum_moved_dl_bw += moved;
+							  cpu, &moved));
+		b->moved += moved;
 	} else {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 	}
@@ -3401,8 +3423,9 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		schedule_flush_migrate_mm();
 	cs->old_mems_allowed = attach_ctx.nodemask_to;
 out:
-	clear_attach_data(&src_cs_head, false);
-	clear_attach_data(&dst_cs_head, false);
+	clear_attach_data(&src_cs_head);
+	clear_attach_data(&dst_cs_head);
+	cpuset_free_dl_bw();
 	dec_attach_in_progress_locked();
 
 	mutex_unlock(&cpuset_mutex);
@@ -3907,6 +3930,7 @@ int __init cpuset_init(void)
 	cpuset1_init(&top_cpuset);
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&dl_attach_cpus, GFP_KERNEL));
 
 	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		cpumask_andnot(isolated_cpus, cpu_possible_mask,
@@ -4205,7 +4229,7 @@ static void __cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask
 
 	cs = task_cs(tsk);
 	if (cs != &top_cpuset)
-		guarantee_active_cpus(tsk, pmask);
+		guarantee_active_cpus(cs, tsk, pmask);
 	/*
 	 * Tasks in the top cpuset won't get update to their cpumasks
 	 * when a hotplug online/offline event happens. So we include all
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a538b42dcdd..7df1ee4afb55 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3224,6 +3224,22 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 		goto out;
 	}
 
+	/*
+	 * The caller made room for the deadline bandwidth of @p in the root
+	 * domain of ctx->dl_bw_cpu. The new mask can span two root domains:
+	 * keep @p in that one. Also wake a sleeping @p up on dest_cpu, since
+	 * select_fallback_rq() could pick a CPU of the other one.
+	 */
+	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
+	    cpumask_test_cpu(ctx->dl_bw_cpu, cpu_valid_mask) &&
+	    cpumask_test_cpu(ctx->dl_bw_cpu, ctx->new_mask)) {
+		if (!cpumask_test_cpu(dest_cpu,
+				      cpu_rq(ctx->dl_bw_cpu)->rd->span))
+			dest_cpu = ctx->dl_bw_cpu;
+		if (!task_on_rq_queued(p))
+			p->wake_cpu = dest_cpu;
+	}
+
 	do_set_cpus_allowed(p, ctx);
 
 	return affine_move_task(rq, p, rf, dest_cpu, ctx->flags);
@@ -3274,15 +3290,18 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
  * Like set_cpus_allowed_ptr(), for a caller that has made room for the
- * deadline bandwidth of @p in the root domain of @new_mask. Move that
- * bandwidth there with @p, and set @moved to the bandwidth moved, 0
- * if none. Return 0 on success, or a negative error code.
+ * deadline bandwidth of @p in the root domain of @cpu. If the move records
+ * @cpu with that bandwidth, move the bandwidth there with @p. Set @moved
+ * to the bandwidth moved, 0 if none. Return 0 on success, or a negative
+ * error code.
  */
 int set_cpus_allowed_bw_reserved(struct task_struct *p,
-				 const struct cpumask *new_mask, u64 *moved)
+				 const struct cpumask *new_mask, int cpu,
+				 u64 *moved)
 {
 	struct affinity_context ac = {
 		.new_mask  = new_mask,
+		.dl_bw_cpu = cpu,
 		.flags     = SCA_DL_BW_RESERVED,
 	};
 	int ret;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0326527dd2d1..8d9e55bca943 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3558,6 +3558,9 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
 	return cpu;
 }
 
+static int __dl_task_bw_move_cpu(struct task_struct *p,
+				 const struct cpumask *new_mask);
+
 static void set_cpus_allowed_dl(struct task_struct *p,
 				struct affinity_context *ctx)
 {
@@ -3572,14 +3575,17 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * rebuild of the accounting. Moving it without room would leave no
 	 * root domain counting it.
 	 *
+	 * The caller made room in the root domain of ctx->dl_bw_cpu, the CPU
+	 * it expects the move to record. Move the bandwidth only if the move
+	 * records that CPU. The affinity or the CPU of @p may have changed.
+	 *
 	 * Report in @ctx the bandwidth moved. The caller read the record
 	 * without the runqueue lock, so it must count only what this reports.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
-	    dl_task_needs_bw_move(p, ctx->new_mask)) {
+	    __dl_task_bw_move_cpu(p, ctx->new_mask) == ctx->dl_bw_cpu) {
 		unsigned int src_cpu = dl_task_root_domain_cpu(p);
 		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
-		unsigned int cpu;
 
 		/*
 		 * We now free resources of the root_domain we are migrating
@@ -3593,12 +3599,8 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 			raw_spin_unlock(&src_dl_b->lock);
 		}
 
-		/*
-		 * cpuset_can_attach() made room in the root domain of the new
-		 * mask. That root domain counts the bandwidth from now on.
-		 */
-		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
-		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
+		/* Record the CPU the caller made room on. */
+		p->dl.dl_bw_cpu = ctx->dl_bw_cpu;
 		p->dl.dl_bw_gen = dl_bw_gen;
 		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
@@ -3606,8 +3608,15 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	set_cpus_allowed_common(p, ctx);
 }
 
-bool dl_task_needs_bw_move(struct task_struct *p,
-			   const struct cpumask *new_mask)
+/*
+ * Return the CPU that a move of @p to the CPUs of @new_mask records with
+ * its bandwidth. That is the CPU @p is on, if @p can stay there. Else it
+ * is the first active CPU of @new_mask, a housekeeping one if there is
+ * one. Return -1 if the bandwidth stays in the root domain that counts
+ * it. The caller holds the rq lock of @p.
+ */
+static int __dl_task_bw_move_cpu(struct task_struct *p,
+				 const struct cpumask *new_mask)
 {
 	unsigned int cpu;
 
@@ -3617,10 +3626,39 @@ bool dl_task_needs_bw_move(struct task_struct *p,
 	 * their bandwidth: dl_add_task_root_domain() leaves them out.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
-		return false;
+		return -1;
 
 	cpu = dl_task_root_domain_cpu(p);
-	return !cpumask_intersects(cpu_rq(cpu)->rd->span, new_mask);
+	if (cpumask_intersects(cpu_rq(cpu)->rd->span, new_mask))
+		return -1;
+	/*
+	 * A task moved asleep is still on a CPU of the root domain it left.
+	 * If the new mask holds that CPU, the task wakes up there.
+	 */
+	cpu = task_cpu(p);
+	if (cpu_active(cpu) && cpumask_test_cpu(cpu, new_mask))
+		return cpu;
+	cpu = cpumask_first_and_and(new_mask, cpu_active_mask,
+				    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+	if (cpu >= nr_cpu_ids)
+		cpu = cpumask_any_and(new_mask, cpu_active_mask);
+	return cpu < nr_cpu_ids ? (int)cpu : -1;
+}
+
+int dl_task_bw_move_cpu(struct task_struct *p, const struct cpumask *new_mask)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+	int cpu;
+
+	/* Like __set_cpus_allowed_ptr(), keep within the user affinity. */
+	rq = task_rq_lock(p, &rf);
+	if (p->user_cpus_ptr &&
+	    cpumask_and(rq->scratch_mask, new_mask, p->user_cpus_ptr))
+		new_mask = rq->scratch_mask;
+	cpu = __dl_task_bw_move_cpu(p, new_mask);
+	task_rq_unlock(rq, p, &rf);
+	return cpu;
 }
 
 /* Assumes rq->lock is held */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ed84b7b7161f..7221809ae8ef 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2665,6 +2665,8 @@ struct affinity_context {
 	struct cpumask		*user_mask;
 	/* Out: the deadline bandwidth moved to the new root domain. */
 	u64			dl_bw_moved;
+	/* In, with SCA_DL_BW_RESERVED: the CPU the caller made room on. */
+	int			dl_bw_cpu;
 	unsigned int		flags;
 };
 
-- 
2.47.3

