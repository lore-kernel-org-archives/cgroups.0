Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655341;
	b=UscsFTOKE+N7B9DWstIYv777TQHhZ+mNgTEmDz3A1VhCbNy3aEyxabhyHiVnZlV/GtJY
	 lVaQIMgTReKI+NDg6Th9eRN/4YaDUiZMRvgWxdiOrx8dwrIQ+YxlpKkPPR2w4BixzV2NT
	 gvwefEbkTEuQH5fNwnMFW18yAKCfQCjswNkR474viJnPCxE5RP6KbaCrG71m9lCcD2Q/E
	 FyKuLAA6luxE2vvT5WXGZ518ZQ//9ox8wpdrWfTHEgnPKdoU60rEwKQTDp4dZ2qHucm3p
	 /1UG0QyAwINRFptUbcQzIzq1/kzhoiM6SokMRkJ30r4IlOqJzBE6Ovtt3105ZeC06Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655341;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tb6ANpfSJOZNE5w9GuLlm1e+xOfOQaoJaJvsIXYcwrg=;
	b=MzB2RFzSKZ5XycoIyryHFblwaYbW037lTqEB2bdag6m+Wn85j7Rdwh04tYntSQR6BSVe
	 SmhUh2i/iAhFyMAZTelu5Ezp3cvi67CY9CQ6TWnk8OGfJoB6kMlaBtkSAGCEyp7gqEvq2
	 ZlLVuvHcSZ95MtbAUHUjJ8A6KASUKJe8PSMS95y+XXNGNk7801GjJeNKCmFE8c3aa/kxA
	 vO3fYLD0AEoJMG7aJpgHfzgtl4HRvsOk8m9UDLA6CUeXKMW+VHIEaALFtnOXdoKj/Uxts
	 pHkqyCa/d33vfiS2yW1GEBPHdKe19BFQC1BUUjdz1x1xVTMdm0fPM4jDD8OqzVImHng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ms6vR7wp;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016B4606A6BB;
	Thu, 26 Nov 2026 01:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 016B4606A6BB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ms6vR7wp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655336;
	bh=tb6ANpfSJOZNE5w9GuLlm1e+xOfOQaoJaJvsIXYcwrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ms6vR7wpjbWVr7nypYj7WxB7YtJOIgdWIwFTE68dTnheSfSzr6z/71O3J5JCyC4TU
	 wPQ5PKQ5oubZfq0yu6FcLsvRvrn3adIoZLhMf4r7n5ejWKT5LC/Oa/3z6AFLGHXU9O
	 aiOEkcfjnFm0fjzB8VdlY+htRkEukdHLsWvL/KC5q2laP8WiFs1IAy5kK+zTmA8RWR
	 MWuMJ9nbqk0OQ6JJ1rtdI+qUQJMTT8Emv6ddvSZU5UTWrGgcgwdb+MMtzvUtaVJrL4
	 VNOxbjJ0M+rechG6b1OtYGPMXxOcrjELS7/yt0WeHCy7QoR15u2uwTwWPg5id40TSj
	 yTIjNXFfx3uow==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjN0F1PzW9v;
	Wed, 25 Nov 2026 20:08:56 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
Subject: [PATCH v11 11/43] cgroup/cpuset: Reserve the bandwidth in the root domain a task moves to
Date: Wed, 25 Nov 2026 20:08:10 -0500
Message-ID: <8ab09c88f7b08f6f8e58ebe9c9dfb87ab11bf04f.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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
domain. A move also keeps the task within the affinity set by
sched_setaffinity(). The task's new CPUs can then all be in a root
domain that got no reservation. The task runs there, and its bandwidth
is reserved in the other root domain.

Take a machine with CPUs 0-4, booted with isolcpus=domain,1,2. P is a
partition root of CPU 4. A deadline task T, pinned to CPUs 1-2, is moved
into P and back to the root cgroup. set_cpus_allowed_dl() records with
the bandwidth a CPU of the root domain that counts it:

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
    __set_cpus_allowed_ptr()
      keeps T's affinity: CPUs 1-2
    set_cpus_allowed_dl()
      frees where recorded, CPU 4                              - bw
      records CPU 1
  T runs on CPU 1
  T exits
    releases where recorded, CPU 1                 - bw
                                       ---------   ---------   ---------
  left after T exits                   + bw        - bw        0

T ran in the root domain of CPUs 1 and 2 without being counted there.
In testing, the total_bw of that root domain went below zero when T
died. It then refused every deadline task, until the next rebuild of
the accounting.

Fix this by choosing in cpuset_can_attach() the CPU that the move
records. The new dl_task_bw_reserve_cpu() works it out from the task's
new mask, and saves it in the new task field dl_bw_resv_cpu. The attach
then uses that CPU:
 - cpuset_can_attach() sums the bandwidth per such CPU, not per cpuset:
   one cpuset can need room in two root domains. It reserves each sum,
   and refuses with EBUSY as before.
 - cpuset_attach_task() moves the bandwidth to that CPU, and
   set_cpus_allowed_dl() records it. The CPU is not worked out again:
   the task may have run on another CPU since. No bandwidth moves for
   a task without dl_bw_resv_cpu. Juri Lelli suggested this: a task
   that cpuset_can_attach() did not count cannot use the room made for
   another task.
 - cpuset_attach() gives back the rest.

The CPU is the one the task is on, if the task can stay there. Else it
is the first active CPU of the new mask, a housekeeping one if any.
Only active CPUs count. The rebuild of the accounting makes the same
choice, later in this series.

A new mask can also span both root domains. A running task would then
go to the CPU that cpumask_any_and_distribute() picks. A sleeping one
would wake up where select_fallback_rq() picks. Either CPU can be in
the root domain without the reservation. So
__set_cpus_allowed_ptr_locked() takes the CPU with the reservation
instead, if cpumask_any_and_distribute() picked a CPU of the other root
domain. A sleeping task gets the chosen CPU as its wakeup CPU.

A new mask that still holds an active CPU of the root domain counting
the task moves no bandwidth at the attach. The task can still land in
the other root domain, if it must leave its CPU. A later patch of this
series moves the bandwidth there, without a check for room. It is
"sched/deadline: Move a task's bandwidth to the root domain it runs in".

cpuset_can_attach() works out the CPUs of the destination before the
task is in it. So guarantee_active_cpus() now takes the cpuset to start
from.

Later in this series, deadline_bw_test gets four cases for this:
move_isolated, move_isolated_refused, move_isolated_asleep and
move_spanning. Without this patch, they fail with these boot options:
 - isolcpus=domain,1,2: all four fail.
 - isolcpus=domain,0,1: move_isolated and move_spanning fail, and six
   other move cases too.
The case move_back_cpu_offline tests a mask that holds an offline CPU.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Suggested-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h           |   8 +-
 include/linux/sched/deadline.h  |  15 ++-
 kernel/cgroup/cpuset-internal.h |  12 --
 kernel/cgroup/cpuset.c          | 216 +++++++++++++++++++-------------
 kernel/sched/core.c             |  27 +++-
 kernel/sched/deadline.c         | 133 ++++++++++++++++----
 kernel/sched/sched.h            |   2 +
 kernel/sched/syscalls.c         |   5 +-
 8 files changed, 282 insertions(+), 136 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a8d80a1aee..8e7aa758d863 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -752,10 +752,16 @@ struct sched_dl_entity {
 	 *
 	 * @dl_bw_gen is the value of dl_bw_gen when the bandwidth was last
 	 * counted. If a rebuild dropped it since, there is nothing to remove.
+	 *
+	 * @dl_bw_resv_cpu is a CPU of the root domain where a cpuset attach
+	 * in progress reserved room for the bandwidth, or -1.
+	 * cpuset_can_attach() sets it, and cpuset_attach() moves the
+	 * bandwidth there.
 	 */
 	struct list_head		dl_departed_node;
 	int				dl_bw_cpu;
 	unsigned int			dl_bw_gen;
+	int				dl_bw_resv_cpu;
 
 	/*
 	 * Bits for DL-server functionality. Also see the comment near
@@ -1968,7 +1974,7 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
 					const struct cpumask *new_mask,
-					u64 *moved);
+					int cpu, u64 *moved);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 60be226699bb..cbb7cd71db58 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -50,14 +50,17 @@ extern void dl_accounting_unlock(void);
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
+extern int dl_task_bw_reserve_cpu(struct task_struct *p,
 				  const struct cpumask *new_mask);
+extern int dl_task_bw_reserved_cpu(struct task_struct *p);
+extern void dl_task_bw_unreserve(struct task_struct *p);
 
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
index 2f39c3d12550..7bdb9e21a7ed 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -272,7 +272,6 @@ struct cpuset top_cpuset = {
 	.flags = BIT(CS_CPU_EXCLUSIVE) |
 		 BIT(CS_MEM_EXCLUSIVE) | BIT(CS_SCHED_LOAD_BALANCE),
 	.partition_root_state = PRS_ROOT,
-	.dl_bw_cpu = -1,
 };
 
 /**
@@ -487,28 +486,24 @@ static inline bool partition_is_populated(struct cpuset *cs,
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
@@ -630,7 +625,6 @@ struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
-	trial->dl_bw_cpu = -1;
 	init_llist_node(&trial->attach_node);
 
 	/* Setup cpumask pointer array */
@@ -3106,61 +3100,89 @@ static int cpuset_can_attach_check(struct cpuset *cs, struct cpuset *oldcs,
 	return 0;
 }
 
+/*
+ * The deadline bandwidth of the attach in progress, per CPU. When the
+ * bandwidth of a deadline task moves to another root domain,
+ * dl_task_bw_reserve_cpu() returns the CPU that the move records with it.
+ * It also records that CPU with the task. cpuset_can_attach() sums the
+ * bandwidth of these tasks per such CPU. It reserves each sum in the root
+ * domain of its CPU. cpuset_attach_task() moves the bandwidth of each task
+ * to the CPU recorded with it. It counts what it moves, and cpuset_attach()
+ * gives back the rest.
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
+	for_each_cpu(cpu, dl_attach_cpus) {
+		struct cpuset_dl_bw *b = per_cpu_ptr(&cpuset_dl_bw, cpu);
 
-		cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
-		if (unlikely(cpu >= nr_cpu_ids))
-			return -EINVAL;
-
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
@@ -3170,7 +3192,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	struct cpuset *cs, *oldcs;
 	struct task_struct *task;
 	bool setsched_check;
-	int ret;
+	int cpu, ret;
 
 	cs = oldcs = NULL;
 	mutex_lock(&cpuset_mutex);
@@ -3236,15 +3258,20 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
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
+		cpu = dl_task_bw_reserve_cpu(task, cpus_attach);
+		if (cpu >= 0) {
+			per_cpu_ptr(&cpuset_dl_bw, cpu)->sum += task->dl.dl_bw;
+			cpumask_set_cpu(cpu, dl_attach_cpus);
 		}
 	}
 
@@ -3268,8 +3295,11 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 
 out_unlock:
 	if (ret) {
-		clear_attach_data(&src_cs_head, true);
-		clear_attach_data(&dst_cs_head, true);
+		clear_attach_data(&src_cs_head);
+		clear_attach_data(&dst_cs_head);
+		cpuset_free_dl_bw();
+		cgroup_taskset_for_each(task, css, tset)
+			dl_task_bw_unreserve(task);
 	} else {
 		attach_ctx.in_progress++;
 	}
@@ -3280,50 +3310,59 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
+	struct cgroup_subsys_state *css;
+	struct task_struct *task;
+
 	mutex_lock(&cpuset_mutex);
 	dec_attach_in_progress_locked();
-	clear_attach_data(&src_cs_head, true);
-	clear_attach_data(&dst_cs_head, true);
+	clear_attach_data(&src_cs_head);
+	clear_attach_data(&dst_cs_head);
+	cpuset_free_dl_bw();
+	cgroup_taskset_for_each(task, css, tset)
+		dl_task_bw_unreserve(task);
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
+	 * cpuset_can_attach() made room for the bandwidth of each deadline
+	 * task it moves, in the root domain of the CPU it recorded with the
+	 * task. Flag the move with that CPU, so that the bandwidth goes
+	 * there. The task may have run on another CPU since: the CPU is not
+	 * worked out again.
+	 *
+	 * A task with no CPU recorded needs no move, or was not a deadline
+	 * task in cpuset_can_attach(). Its move is not flagged, so that it
+	 * cannot use the room made for another task. Its bandwidth stays
+	 * where it is counted.
 	 */
-	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus))
-		reserved = true;
+	cpu = dl_task_bw_reserved_cpu(task);
+	if (cpu >= 0)
+		b = per_cpu_ptr(&cpuset_dl_bw, cpu);
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
+		/*
+		 * set_cpus_allowed_dl() cleared the record, unless the task
+		 * left SCHED_DEADLINE. Clear it then too.
+		 */
+		dl_task_bw_unreserve(task);
 	} else {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 	}
@@ -3397,6 +3436,13 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	if (cpuset_v2() && !attach_ctx.cpus_updated && !attach_ctx.mems_updated) {
 		llist_for_each_entry(cs, dst_cs_head.first, attach_node)
 			cs->old_mems_allowed = attach_ctx.nodemask_to;
+		/*
+		 * No mask changes, so no bandwidth moves. Forget the CPU
+		 * that cpuset_can_attach() recorded with a deadline task, as
+		 * cpuset_attach_task() does. A later attach must not find it.
+		 */
+		cgroup_taskset_for_each(task, css, tset)
+			dl_task_bw_unreserve(task);
 		goto out;
 	}
 
@@ -3407,8 +3453,9 @@ static void cpuset_attach(struct cgroup_taskset *tset)
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
@@ -3913,6 +3960,7 @@ int __init cpuset_init(void)
 	cpuset1_init(&top_cpuset);
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&dl_attach_cpus, GFP_KERNEL));
 
 	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		cpumask_andnot(isolated_cpus, cpu_possible_mask,
@@ -4211,7 +4259,7 @@ static void __cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask
 
 	cs = task_cs(tsk);
 	if (cs != &top_cpuset)
-		guarantee_active_cpus(tsk, pmask);
+		guarantee_active_cpus(cs, tsk, pmask);
 	/*
 	 * Tasks in the top cpuset won't get update to their cpumasks
 	 * when a hotplug online/offline event happens. So we include all
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fff2725a4cd5..7615ba02d52b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3250,6 +3250,22 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
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
@@ -3300,15 +3316,18 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
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
index e2ffdb23ba3e..c047169ccdd8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3677,44 +3677,63 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * rebuild of the accounting. Moving it without room would leave no
 	 * root domain counting it.
 	 *
-	 * Report in @ctx the bandwidth moved. The caller made its own test
-	 * without the runqueue lock, so it must count only what this reports.
+	 * cpuset_can_attach() made room for @p in the root domain of
+	 * ctx->dl_bw_cpu, and recorded that CPU with @p. Move the bandwidth
+	 * there. Do not work out the CPU again: @p may have run on another
+	 * CPU since. __set_cpus_allowed_ptr_locked() keeps @p in that root
+	 * domain.
+	 *
+	 * Report in @ctx the bandwidth moved. The caller gives back the room
+	 * that no move used.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
-	    dl_task_needs_bw_move(p, ctx->new_mask)) {
+	    p->dl.dl_bw_resv_cpu == ctx->dl_bw_cpu) {
 		unsigned int src_cpu = dl_task_root_domain_cpu(p);
 		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
-		unsigned int cpu;
 
+		p->dl.dl_bw_resv_cpu = -1;
 		/*
-		 * We now free resources of the root_domain we are migrating
-		 * off. In the worst case, sched_setattr() may temporary fail
-		 * until we complete the update. A rebuild that dropped the
-		 * bandwidth of @p leaves nothing to free. dl_departed_lock
-		 * keeps a rebuild from changing dl_bw_gen meanwhile.
+		 * Nothing moves if @p left the CPUs it was to move to, or if
+		 * its root domain already counts it: @p ran there since.
 		 */
-		guard(raw_spinlock)(&dl_departed_lock);
-		if (p->dl.dl_bw_gen == dl_bw_gen) {
-			raw_spin_lock(&src_dl_b->lock);
-			__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(src_cpu));
-			raw_spin_unlock(&src_dl_b->lock);
+		if (p->dl.dl_bw && !dl_entity_is_special(&p->dl) &&
+		    cpu_active(ctx->dl_bw_cpu) &&
+		    cpumask_test_cpu(ctx->dl_bw_cpu, ctx->new_mask) &&
+		    cpu_rq(src_cpu)->rd != cpu_rq(ctx->dl_bw_cpu)->rd) {
+			/*
+			 * We now free resources of the root_domain we are
+			 * migrating off. In the worst case, sched_setattr()
+			 * may temporary fail until we complete the update. A
+			 * rebuild that dropped the bandwidth of @p leaves
+			 * nothing to free. dl_departed_lock keeps a rebuild
+			 * from changing dl_bw_gen meanwhile.
+			 */
+			guard(raw_spinlock)(&dl_departed_lock);
+			if (p->dl.dl_bw_gen == dl_bw_gen) {
+				raw_spin_lock(&src_dl_b->lock);
+				__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(src_cpu));
+				raw_spin_unlock(&src_dl_b->lock);
+			}
+
+			/* Record the CPU the caller made room on. */
+			p->dl.dl_bw_cpu = ctx->dl_bw_cpu;
+			p->dl.dl_bw_gen = dl_bw_gen;
+			ctx->dl_bw_moved = p->dl.dl_bw;
 		}
-
-		/*
-		 * cpuset_can_attach() made room in the root domain of the new
-		 * mask. That root domain counts the bandwidth from now on.
-		 */
-		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
-		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
-		p->dl.dl_bw_gen = dl_bw_gen;
-		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
 
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
 
@@ -3724,10 +3743,69 @@ bool dl_task_needs_bw_move(struct task_struct *p,
 	 * their bandwidth: dl_add_task_root_domain() leaves them out.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
-		return false;
+		return -1;
 
+	/*
+	 * Test the active CPUs only. The default root domain also holds the
+	 * offline CPUs, and the mask of the top cpuset holds them too.
+	 */
 	cpu = dl_task_root_domain_cpu(p);
-	return !cpumask_intersects(cpu_rq(cpu)->rd->span, new_mask);
+	if (cpumask_intersects_and(cpu_rq(cpu)->rd->span, new_mask,
+				   cpu_active_mask))
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
+/*
+ * Work out the CPU that a move of @p to the CPUs of @new_mask records
+ * with its bandwidth. Record it with @p: a cpuset attach reserves room
+ * on it. Return it, or -1 if the bandwidth stays where it is.
+ */
+int dl_task_bw_reserve_cpu(struct task_struct *p, const struct cpumask *new_mask)
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
+	p->dl.dl_bw_resv_cpu = cpu;
+	task_rq_unlock(rq, p, &rf);
+	return cpu;
+}
+
+/* Return the CPU that dl_task_bw_reserve_cpu() recorded with @p, or -1. */
+int dl_task_bw_reserved_cpu(struct task_struct *p)
+{
+	return READ_ONCE(p->dl.dl_bw_resv_cpu);
+}
+
+/* Forget the CPU that dl_task_bw_reserve_cpu() recorded with @p. */
+void dl_task_bw_unreserve(struct task_struct *p)
+{
+	struct rq_flags rf;
+	struct rq *rq;
+
+	if (READ_ONCE(p->dl.dl_bw_resv_cpu) < 0)
+		return;
+	rq = task_rq_lock(p, &rf);
+	p->dl.dl_bw_resv_cpu = -1;
+	task_rq_unlock(rq, p, &rf);
 }
 
 /* Assumes rq->lock is held */
@@ -4581,6 +4659,7 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	dl_se->dl_bw = 0;
 	__dl_clear_params(dl_se);
 	dl_se->dl_bw_cpu = -1;
+	dl_se->dl_bw_resv_cpu = -1;
 	INIT_LIST_HEAD(&dl_se->dl_departed_node);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 65fc17909d56..a719b62dc114 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2680,6 +2680,8 @@ struct affinity_context {
 	struct cpumask		*user_mask;
 	/* Out: the deadline bandwidth moved to the new root domain. */
 	u64			dl_bw_moved;
+	/* In, with SCA_DL_BW_RESERVED: the CPU the caller made room on. */
+	int			dl_bw_cpu;
 	unsigned int		flags;
 };
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 4e0e6a326e5b..16fd65825367 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1354,8 +1354,9 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	/*
 	 * Wait for a cpuset attach in progress before changing the affinity
 	 * of a deadline task. cpuset_can_attach() reserved the bandwidth of
-	 * the task for the CPUs it moves to, and cpuset_attach() moves it
-	 * there. A new affinity in between could change those CPUs.
+	 * the task on one CPU, and recorded that CPU with the task.
+	 * cpuset_attach() moves the bandwidth there. A new affinity in
+	 * between could leave that CPU out, and the bandwidth would not move.
 	 *
 	 * The policy is tested here with no lock. A task that becomes a
 	 * deadline task after this test is found under its runqueue lock,
-- 
2.47.3

