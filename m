Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655340;
	b=xV9FuY5QQKsX3mDmKdcengr4mhaNhNLiCe6vwjmBcrNq6MlCUAcJ5oyRShhSl+cyVf1x
	 syGE2+4vJFrXCxRpxB8JXJzUin4yFuA9mIeTSIU6MqjLJhZeI6cRaWaMzvvrZImsFNUIR
	 BXNbbJPcFnFMEzMxF41Ju/1h8H1gn2134subwrFMlCIFVGRxjrMsO1cvgUBYRZL84XSaG
	 D6zFtLUUounN1/85aQJv76yrHGP4g9QRMnhpJtaRuZBDkvYps3DWkZsciRDeYgDqei4vs
	 +E9RTcfKlcBvOSLvRzU2awVhy6rt/FNcgLYecJDkpgzKQ3iv617gbaJca0CN/rRb3YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655340;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uZFstzC0w08XFSsuRIjBsyweYaSR5csouR0jv11XyAY=;
	b=hOagVq1NUJB7XyF2iV3TMAO1pieRrr43l5Lg6mBdSlZRWZPkZZ2sf1j013yiqeer95pB
	 rNsm1lLg7uhTJD8YQER4vVfBMQtnO66pny4FfVCEAt3jifJckSyWQiEsY/Ff8EDMgky1a
	 4y/X6QyUsvMzQxGwkDFEQkECvjIRdPN4H7GRskRERZEAVHjNPOh/UFSU0OEzoTSc3pf1X
	 P5tUxnMWJdanrkiRkdrQWSyA8T8qSH8oKyX3R/SHGrjGTUj6BAMwGEBD/LwdT5WWGag2h
	 DVIVTb4VqcOjT40KXilItgBEd29yiFCXSsBnvEaGzTdkGJbNWUAr84RtgYH4u/9dUGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="cx+VP/EB";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FB606A333;
	Thu, 26 Nov 2026 01:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 943FB606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=cx+VP/EB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655331;
	bh=uZFstzC0w08XFSsuRIjBsyweYaSR5csouR0jv11XyAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cx+VP/EBkiA43xIDCqj0FgaEorOkNOWrtUCr+ihDs1LMelPvVBBnHQE1G2Qvd84JJ
	 LODVafNguqv8qvsWkfYZ9XcACZ+79kDz0wuf8baABU/7U0DLqOP+uE91ApRyMckljC
	 UHW8aF3xpbBtBEMZxJexZf3cbGPjZKkS31AnmpeMoNeRNVqpghfTfT0z4KNNVJ6e7C
	 JuZz2gg7+mdhOwRSHCHxpxf9ZmmSqCrQdlOR2QV8NrSwYNksVA4UZJNObiSM8zbdU8
	 RtbrPNxQIXvVDHnXj0mOX3ccG22f+NrBaIFInrjgD/bVlN4mJk7y6ipnCZICDCe5Qj
	 SMkqG11EDfANQ==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjG56SKzWx5;
	Wed, 25 Nov 2026 20:08:50 -0500 (EST)
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
Subject: [PATCH v11 03/43] sched/deadline: Record the root domain holding a task's bandwidth
Date: Wed, 25 Nov 2026 20:08:02 -0500
Message-ID: <15966b50511752111bbedf34c5fe2331c4e54546.1795646914.git.mathieu.desnoyers@efficios.com>
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

Admission, moves and releases of a deadline task's bandwidth find the
root domain that counts it from the CPU the task is on. But a sleeping
task stays on the CPU it last ran on. That CPU can be in another root
domain. Two cases show it.

First case: a sleeping task moved to a partition and back.
Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
migrating tasks between exclusive cpusets") moves a deadline task's
bandwidth in two halves. cpuset_can_attach() reserves it in the
destination. set_cpus_allowed_dl() frees it in the root domain of the
task's runqueue. Since commit 5dd74441cbf4 ("cgroup/cpuset: Reserve DL
bandwidth only for root-domain moves"), both halves move nothing when
that root domain overlaps the destination:

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

Second case: a sleeping task whose CPU goes offline. It needs no move:

 1. A deadline task T sleeps on a CPU of root domain A.
 2. That CPU goes offline, and joins the default root domain.
 3. The rebuild counts T in A, the root domain of its cpuset.
 4. sched_setattr() takes the sleeping T out of SCHED_DEADLINE.
 5. The release takes the bandwidth from the root domain of the CPU T
    is on: the default one.

A keeps the bandwidth of T until the next rebuild, and refuses deadline
tasks that would fit.

Fix this by recording with the bandwidth a CPU of the root domain that
counts it, in the new field dl_bw_cpu. It replaces dl_departed_cpu.
Each site that counts the bandwidth sets the record. Each release or
move reads it, and the release clears it.

These rules keep the record right:
- If dl_bw_gen shows that a rebuild dropped the bandwidth, nothing is
  taken back.
- A move skips a bandwidth of 0, and does not update its record. The
  admission tests treat such a task like one that enters the class
  (move_zero_bw).
- A rebuild drops departed bandwidth whose CPU is inactive. So a
  departing task records the CPU it departs from, if that CPU is
  active and in the same root domain.

A move now also leaves out a sugov kthread, and a task boosted into the
class with no bandwidth of its own. The rebuild leaves them out
already. Before, a move would take their bandwidth from a root domain
that never held it.

The admission tests of sched_setattr() and sched_setaffinity() now use
the record. This changes their result in these cases:
- sched_setattr() on a deadline task moved asleep into a partition
  failed with EPERM until the task woke up (move_asleep_setattr).
- sched_setattr() that makes a sleeping task a deadline task tested the
  CPU the task is on. It now tests an active CPU of the task's mask, if
  that CPU is not one. Before, it failed with EPERM after a move into a
  partition (move_asleep_fair_setattr). It also failed with EBUSY on a
  CPU that went offline, when the default root domain had no active CPU
  (hotplug_asleep_setattr).
- sched_setaffinity() tested the root domain of the CPU the task is on.
  A new mask could then take a task moved asleep out of the root domain
  that counts it (affinity_moved_asleep).

The first case was reproduced on v7.4-rc2. The second case also needs
"sched/deadline: Release the bandwidth of a task that leaves the class
asleep", of the first series. Before it, nothing released the bandwidth
of that sleeping task. The hotplug_sleeper_switched case of
deadline_bw_test, added later in this series, tests it. Without this
patch, A then admitted 63 tasks of 10% where it had room for 66. This
held in each of 3 guests, with the CPU still offline.

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
 kernel/sched/deadline.c | 275 +++++++++++++++++++++++++++++-----------
 kernel/sched/syscalls.c |  23 +++-
 3 files changed, 226 insertions(+), 82 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b6d4e365afee..4098b4e0f67e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -744,15 +744,17 @@ struct sched_dl_entity {
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
index d1a2ae9ab75f..28fa8f0bc81b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -233,7 +233,7 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
  * dl_add_task_root_domain()) does not count such a task as a deadline
  * task. So dl_departed_list holds these tasks, from their departure to
  * their timer. The rebuild puts their bandwidth back in the root domain
- * of the CPU each one was on when it left.
+ * of the CPU recorded with each task's bandwidth.
  *
  * dl_bw_gen numbers the rebuilds of the accounting: how many times the
  * root domains were wiped and reconstructed (dl_clear_root_domains()
@@ -255,7 +255,10 @@ __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
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
@@ -282,66 +285,75 @@ static inline bool dl_se_holds_bw(struct sched_dl_entity *dl_se)
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
 
@@ -504,6 +516,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
 /*
  * Return the time from now to the 0-lag time of @dl_se, or a negative
@@ -666,7 +679,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				dl_task_release_bw(p, task_cpu(p));
+				dl_task_release_bw(p);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -680,12 +693,13 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
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
@@ -923,19 +937,31 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
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
+	scoped_guard (raw_spinlock, &dl_departed_lock) {
+		if (p->dl.dl_bw_gen == dl_bw_gen) {
+			struct rq *src_rq = cpu_rq(dl_task_root_domain_cpu(p));
 
-	dl_b = &later_rq->rd->dl_bw;
-	raw_spin_lock(&dl_b->lock);
-	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(later_rq->rd->span));
-	raw_spin_unlock(&dl_b->lock);
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
@@ -2444,7 +2470,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 			dl_se->dl_non_contending = 0;
 		}
 
-		dl_task_release_bw(p, task_cpu(p));
+		dl_task_release_bw(p);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3592,14 +3618,56 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	}
 }
 
+/*
+ * Return a CPU of the root domain that counts the bandwidth of @p: the
+ * CPU recorded with it. Without a record, no root domain counts that
+ * bandwidth. Return the CPU @p is on then. Read the record once:
+ * cpuset_can_attach() calls this through dl_task_needs_bw_move() without
+ * the rq lock of @p.
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
+/*
+ * Return a CPU of the root domain that admits new parameters for @p.
+ * sched_dl_overflow() picks the same one. It is the CPU recorded with
+ * the bandwidth of a deadline task, if that bandwidth is counted. Else it
+ * is the CPU @p is on. A task moved asleep to another cpuset is still on
+ * a CPU it can no longer use. A task asleep on a CPU that went offline
+ * is still on that CPU, now in the default root domain. In both cases,
+ * take an active CPU of the mask of @p. The task runs in that root
+ * domain once it wakes. The caller holds the rq lock of @p. To read the
+ * record, it also holds cpuset_mutex, or dl_accounting_mutex without
+ * cpusets.
+ */
+static unsigned int dl_task_admit_cpu(struct task_struct *p)
+{
+	unsigned int cpu;
+
+	if (task_has_dl_policy(p) && p->dl.dl_bw && p->dl.dl_bw_cpu >= 0 &&
+	    p->dl.dl_bw_gen == dl_bw_gen)
+		return p->dl.dl_bw_cpu;
+	cpu = task_cpu(p);
+	if (!cpumask_test_cpu(cpu, &p->cpus_mask) || !cpu_active(cpu)) {
+		unsigned int other = cpumask_first_and(cpu_active_mask, &p->cpus_mask);
+
+		if (other < nr_cpu_ids)
+			cpu = other;
+	}
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
@@ -3607,17 +3675,31 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3626,10 +3708,18 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
@@ -3705,7 +3795,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 * Count nothing for a special entity, or for a task with no
 	 * bandwidth. The walk of the task list also finds exited tasks. An
 	 * exited task whose bandwidth went with its parameters has a dl_bw
-	 * of 0.
+	 * of 0. So has a task boosted into the class with no bandwidth of
+	 * its own, which gets no record.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
@@ -3729,7 +3820,9 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3738,9 +3831,9 @@ void dl_add_task_root_domain(struct task_struct *p)
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
@@ -3748,6 +3841,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -3897,7 +3991,7 @@ void dl_clear_root_domains(void)
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
 	}
 	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
-		cpu = dl_se->dl_departed_cpu;
+		cpu = dl_se->dl_bw_cpu;
 		/*
 		 * Skip bandwidth that an earlier rebuild dropped. It is not
 		 * counted now, and its release removes nothing
@@ -3912,7 +4006,7 @@ void dl_clear_root_domains(void)
 		 * from the recorded number. The release then removes
 		 * nothing, and no later rebuild restores it.
 		 */
-		if (!cpu_active(cpu))
+		if (cpu < 0 || !cpu_active(cpu))
 			continue;
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
@@ -3973,15 +4067,16 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
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
@@ -4009,10 +4104,11 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
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
@@ -4219,9 +4315,10 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4230,6 +4327,23 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
+	cpu = dl_task_admit_cpu(p);
+	dl_b = dl_bw_of(cpu);
+
 	/*
 	 * Either if a task, enters, leave, or stays -deadline but changes
 	 * its parameters, we may need to update accordingly the total
@@ -4244,7 +4358,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, counted ? p->dl.dl_bw : 0,
+				  new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4252,7 +4367,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		 * But this would require to set the task's "inactive
 		 * timer" when the task is not inactive.
 		 */
-		__dl_sub(dl_b, p->dl.dl_bw, cpus);
+		if (counted)
+			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		dl_change_utilization(p, new_bw);
 		err = 0;
@@ -4273,11 +4389,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
 
@@ -4436,8 +4561,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	dl_se->dl_bw = 0;
 	__dl_clear_params(dl_se);
+	dl_se->dl_bw_cpu = -1;
 	INIT_LIST_HEAD(&dl_se->dl_departed_node);
-	dl_se->dl_departed_cpu = -1;
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 96a5f0a7adbc..41c568fc514e 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -642,7 +642,14 @@ int __sched_setscheduler(struct task_struct *p,
 #endif /* CONFIG_RT_GROUP_SCHED */
 		if (dl_bandwidth_enabled() && dl_policy(policy) &&
 				!(attr->sched_flags & SCHED_FLAG_SUGOV)) {
-			cpumask_t *span = rq->rd->span;
+			/*
+			 * The root domain that admits the change: that of the
+			 * CPU recorded with the bandwidth of a deadline task.
+			 * A task moved asleep to another cpuset is still on a
+			 * CPU of the root domain it left.
+			 */
+			struct root_domain *rd = cpu_rq(dl_task_admit_cpu(p))->rd;
+			cpumask_t *span = rd->span;
 
 			/*
 			 * Don't allow tasks with an affinity mask smaller than
@@ -650,7 +657,7 @@ int __sched_setscheduler(struct task_struct *p,
 			 * will also fail if there's no bandwidth available.
 			 */
 			if (!cpumask_subset(span, &p->cpus_mask) ||
-			    rq->rd->dl_bw.bw == 0) {
+			    rd->dl_bw.bw == 0) {
 				retval = -EPERM;
 				goto unlock;
 			}
@@ -1185,6 +1192,8 @@ SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 
 int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
 {
+	unsigned int cpu;
+
 	/*
 	 * If the task isn't a deadline task or admission control is
 	 * disabled then we don't care about affinity changes.
@@ -1204,9 +1213,17 @@ int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
 	 * if admission test is enabled, we only admit -deadline
 	 * tasks allowed to run on all the CPUs in the task's
 	 * root_domain.
+	 *
+	 * That is the root domain that counts the bandwidth of the task:
+	 * the one of the CPU recorded with it. A task moved asleep to
+	 * another cpuset is still on a CPU of the root domain it left. A
+	 * bandwidth of 0 is counted nowhere, and no move updates its
+	 * record. Pick the CPU for it as sched_setattr() does.
 	 */
+	cpu = READ_ONCE(p->dl.dl_bw) ? dl_task_root_domain_cpu(p) :
+				       dl_task_admit_cpu(p);
 	guard(rcu)();
-	if (!cpumask_subset(task_rq(p)->rd->span, mask))
+	if (!cpumask_subset(cpu_rq(cpu)->rd->span, mask))
 		return -EBUSY;
 
 	return 0;
-- 
2.47.3

