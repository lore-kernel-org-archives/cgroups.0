Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015906;
	b=tbpy1AnuvcTs5FMYCtiu/CkkzqerUAtyKwZG91YzWItoiFrZWSmb9EHCj9MQjhyl7gqd
	 H+Z+M8ONCTnsh7YakFUD8pI6yd9XYcOFzd+mhcskYcp900uuu6EC2igOnKdBwvIztOxbt
	 cq3q7AeJA7zF5M8EgCjDVYCvNRhcTe9HZMM+aewpHxKW4d04bkoH3LG/jHGCbStu1PmMR
	 xr2LMEGRu8UWbIp9f4tnviDDKhhesglJbntWHVMjynI7uLNk0xxmTPV+1rbbT3kGb1T+c
	 GAC1n8h8KaELGpPRLkypOYwijVoDAfXyQ7GLF/DIKlgYyplMU+bvn+4+vUcc0LetOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015906;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=USEPFPYYS3d02ZuyUo6/FW7jmOveYVibXKAccJoSYrA=;
	b=sKvBox5juhl8QKpwCUr6bICEh/0qiVErWiITyDiGFfJRe5jeEWyOpP85PB/FG1tT6Dkd
	 OAXS21v8fcNBZHClRJfdu+PN5pl/MGuc+OhUBZYUo8JtM2yFGRMPlijBE0Cb5UpkA/xOu
	 0iNibai1LrfGiIVkS5X0ycvlTnux5IjDPitjQAc77b318O1At4Qj5WbvWOaCkT9YJ/Vt9
	 O8Hm4UhMb2L+bGMJeLOrZK+b4k2rtnR8lUBTP/pG8tVxLwc277+xkHgflKOstonvDxEet
	 JokDMHuF/hDKgtkDl/LN9Yeay3JqdrwYb+tnKTpv6BU1xWq3eWl3X7U/1/E/b9omFCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=K0H9ogRZ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EC606EE98;
	Sat,  7 Nov 2026 01:45:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD9EC606EE98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=K0H9ogRZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015905;
	bh=USEPFPYYS3d02ZuyUo6/FW7jmOveYVibXKAccJoSYrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0H9ogRZh6LTEoB+ZjB34aV3DPtwccJkOWpbImAC9vR9LlMniGj8jFtqicGotY5Hv
	 0KWdV+1wiz+99EK0ImxAVUwBkFbURMSZFxQBDD2uQl7eo4k5JDN0dzf0nI/vkLYsBh
	 72ZGVvBAiVQwafYcjhfHzVcH0hRzsNucSyCjS9rU4Sa1qM9yRu8B/Aohv5sm6n2lSa
	 JTQ9TjQLeqIQTgt5QPQ9mCpNG9SZMbe9z3JerjSOzghL3dklbAnxHf9mtHpidVdW0J
	 Zb5+3BA/E5P8aweJXHB5sYVnBr7skjhhSCkNtANIWmJSX5zsqNOsFk4Q5ADKX25/ek
	 OBqhiqh9taqOQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPr5zRvzM1B;
	Fri, 06 Nov 2026 20:45:04 -0500 (EST)
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
Subject: [PATCH v4 16/26] sched/deadline: Record the root domain holding a task's bandwidth
Date: Fri,  6 Nov 2026 20:44:41 -0500
Message-Id: <20261107014451.1487825-17-mathieu.desnoyers@efficios.com>
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

A task's bandwidth can be taken from a root domain that never held it.
Three answers to "which root domain counts this task's bandwidth" live
side by side: admission and the release at the 0-lag time take the root
domain of the CPU the task is on, a move between cpusets that of its
runqueue, and a rebuild of the accounting that of its cpuset. They part
ways where the task's CPU and its cpuset are in different root domains:

 - a sleeping task moved to another partition and back before it runs
   has no move seen the second time: its bandwidth stays in the
   partition, and the root domain it returns to admits deadline tasks
   beyond its capacity, and underflows when the task exits;
 - a task pinned to a CPU that goes offline, admission control off, is
   counted by the rebuild in its cpuset's root domain and released from
   the default one.

Record, wherever a task is handed bandwidth, a CPU of the root domain
that counts it: admission, the rebuild, and the moves of
set_cpus_allowed_dl() and dl_task_offline_migration(). Every release or
move of the bandwidth reads that CPU, dl_task_root_domain_cpu(), and the
release clears it. Where dl_bw_gen says a rebuild dropped the bandwidth,
a change of parameters or a move takes nothing back, and records where
the new bandwidth goes. A task counted nowhere has the CPU it is on
answer for it, and a task boosted back into the class keeps its record.
The departed list of "sched/deadline: Keep departing bandwidth across a
root domain rebuild" uses the record in place of a CPU of its own. A
special entity, a sugov kthread counted nowhere, and a task boosted into
the class with no bandwidth of its own are left out of the moves, as the
rebuild leaves them out: a move took a sugov kthread's bandwidth from a
root domain that never held it.

The moved sleeper was reported by Weiheng Qiu and analysed by Juri
Lelli, whose "sched/deadline: Fix stale root domain in cpuset bandwidth
transfer", since dropped from tip, took the first active CPU of the
task's mask instead, which a mask lacks during CPU hotplug: a sugov
kthread then crashed on its BUG_ON(). The Sashiko AI reviews of this
series found the rest: a mask naming a root domain no rebuild had
credited, sched_dl_overflow() and dl_task_offline_migration() keeping
the CPU the task is on, and the special and boosted tasks moved.

Reported-by: Weiheng Qiu <weihengqiuu@gmail.com>
Closes: https://lore.kernel.org/all/14508cb2-805f-41ac-9f6b-bfd7c3d7cb1c@gmail.com/
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-1-dd761fe005b4@redhat.com/
Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  20 ++--
 kernel/sched/deadline.c | 212 +++++++++++++++++++++++++++-------------
 2 files changed, 155 insertions(+), 77 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6df7d20cbb97..28b579bff9e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -751,17 +751,21 @@ struct sched_dl_entity {
 	struct hrtimer			inactive_timer;
 
 	/*
+	 * @dl_bw_cpu is a CPU of the root domain that counts @dl_bw, -1
+	 * where none does: every site that hands that bandwidth out records
+	 * it, and every site that takes it back or moves it reads it.
+	 * @dl_bw_gen is the rebuild of the root domains' accounting that
+	 * last counted it: one since then dropped it, and there is nothing
+	 * to take back.
+	 *
 	 * A task that leaves SCHED_DEADLINE, or dies, before its "0-lag
-	 * time" keeps its bandwidth in its root domain until the inactive
-	 * timer removes it. @dl_departed_cpu is then a CPU of the root domain
-	 * that counts that bandwidth, and @dl_departed_node links it on the
-	 * list that a rebuild of the root domains' accounting puts that
-	 * bandwidth back from; -1 otherwise. @dl_bw_gen is the
-	 * rebuild that last counted the task's bandwidth: one since then
-	 * dropped it, and nothing is to be removed.
+	 * time" keeps its bandwidth until the inactive timer removes it:
+	 * @dl_departed_node links it meanwhile on the list that a rebuild
+	 * puts that bandwidth back from, and tells of that by not being
+	 * empty.
 	 */
 	struct list_head		dl_departed_node;
-	int				dl_departed_cpu;
+	int				dl_bw_cpu;
 	unsigned int			dl_bw_gen;
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3f3de4b74a2d..7a7101e6f7a0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -286,17 +286,16 @@ static unsigned int dl_bw_gen;
 
 /*
  * @p leaves SCHED_DEADLINE, or dies, its bandwidth kept for now in the root
- * domain of @cpu. Under its rq lock.
+ * domain of the CPU recorded with it. Under its rq lock.
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
 
@@ -309,35 +308,37 @@ static void dl_task_undepart(struct task_struct *p)
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
- * Remove @p's bandwidth from the root domain that counts it: that of the
- * CPU recorded when it departed, else that of @cpu. Nothing to remove
- * when a rebuild of the accounting has dropped it; and no rebuild running
- * counts it again. Under @p's rq lock.
+ * Remove @p's bandwidth from the root domain that counts it, that of the
+ * CPU recorded with it, and clear the record. Nothing to remove when a
+ * rebuild of the accounting has dropped it; and no rebuild running counts
+ * it again. Under @p's rq lock.
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
 
@@ -496,6 +497,7 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
+static unsigned int dl_task_root_domain_cpu(struct task_struct *p);
 
 /*
  * The 0-lag time of @dl_se, relative to the clock of its runqueue: its
@@ -604,7 +606,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 			if (!dl_task || READ_ONCE(p->__state) == TASK_DEAD) {
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
-				dl_task_release_bw(p, task_cpu(p));
+				dl_task_release_bw(p);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -623,7 +625,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 		 * SCHED_DEADLINE.
 		 */
 		if (READ_ONCE(p->__state) == TASK_DEAD)
-			dl_task_depart(p, task_cpu(p));
+			dl_task_depart(p);
 	}
 
 	hrtimer_start(timer, ns_to_ktime(zerolag_time), HRTIMER_MODE_REL_HARD);
@@ -861,19 +863,30 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	}
 
 	/*
-	 * And we finally need to fix up root_domain(s) bandwidth accounting,
-	 * since p is still hanging out in the old (now moved to default) root
-	 * domain.
+	 * And we finally need to fix up root_domain(s) bandwidth accounting:
+	 * the bandwidth of @p is counted in the root domain that took it,
+	 * which is not the one of the runqueue it leaves if it was moved
+	 * asleep. A rebuild that dropped it has nothing here to move, and
+	 * the record left behind is what makes the next one count it.
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
@@ -2355,7 +2368,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 			dl_se->dl_non_contending = 0;
 		}
 
-		dl_task_release_bw(p, task_cpu(p));
+		dl_task_release_bw(p);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -3503,14 +3516,26 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
 	}
 }
 
+/*
+ * A CPU of the root domain that counts the bandwidth of @p: the one
+ * recorded with it. None where no bandwidth of @p's is counted anywhere:
+ * nothing to take back or to move then, and the CPU @p is on answers for
+ * its root domain.
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
@@ -3518,17 +3543,30 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
+		 * The room in the root domain of the mask to come was made
+		 * by cpuset_can_attach(): that one counts the bandwidth from
+		 * here on.
 		 */
-		raw_spin_lock(&src_dl_b->lock);
-		__dl_sub(src_dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
-		raw_spin_unlock(&src_dl_b->lock);
+		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
+		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_cpus_allowed_common(p, ctx);
@@ -3537,10 +3575,18 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 bool dl_task_needs_bw_move(struct task_struct *p,
 			   const struct cpumask *new_mask)
 {
-	if (!dl_task(p))
+	unsigned int cpu;
+
+	/*
+	 * Nothing to move for a special entity, nor for a task boosted into
+	 * the class with no bandwidth of its own: neither is counted, as
+	 * dl_add_task_root_domain() leaves them out.
+	 */
+	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
 		return false;
 
-	return !cpumask_intersects(task_rq(p)->rd->span, new_mask);
+	cpu = dl_task_root_domain_cpu(p);
+	return !cpumask_intersects(cpu_rq(cpu)->rd->span, new_mask);
 }
 
 /* Assumes rq->lock is held */
@@ -3614,8 +3660,9 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
 	 * Nothing to count for a special entity, nor for a task with no
-	 * bandwidth, such as an exited one whose bandwidth went with its
-	 * parameters, which the walk of the task list finds too.
+	 * bandwidth: an exited one whose bandwidth went with its
+	 * parameters, which the walk of the task list finds too, and a task
+	 * boosted into the class with none of its own, which gets no record.
 	 */
 	if (!dl_task(p) || dl_entity_is_special(&p->dl) || !p->dl.dl_bw) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
@@ -3639,10 +3686,12 @@ void dl_add_task_root_domain(struct task_struct *p)
 	 */
 	if (p->dl.dl_bw_gen == dl_bw_gen)
 		goto unlock;
-	if (p->dl.dl_departed_cpu >= 0) {
-		cpu = p->dl.dl_departed_cpu;
-		if (!cpu_active(cpu))
+	if (!list_empty(&p->dl.dl_departed_node)) {
+		int recorded = p->dl.dl_bw_cpu;
+
+		if (recorded < 0 || !cpu_active(recorded))
 			goto unlock;
+		cpu = recorded;
 	} else if (READ_ONCE(p->__state) == TASK_DEAD) {
 		/*
 		 * Dead and not departed: its bandwidth was released at its
@@ -3659,6 +3708,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -3799,7 +3849,7 @@ void dl_clear_root_domains(void)
 			dl_clear_root_domain(cpu_rq(cpu)->rd);
 	}
 	list_for_each_entry(dl_se, &dl_departed_list, dl_departed_node) {
-		cpu = dl_se->dl_departed_cpu;
+		cpu = dl_se->dl_bw_cpu;
 		/*
 		 * Counted in the generation that ends here, and nowhere
 		 * since: one a rebuild dropped, for want of an active CPU to
@@ -3808,7 +3858,7 @@ void dl_clear_root_domains(void)
 		 */
 		if (dl_se->dl_bw_gen != dl_bw_gen - 1)
 			continue;
-		if (!cpu_active(cpu))
+		if (cpu < 0 || !cpu_active(cpu))
 			continue;
 		dl_b = dl_bw_of(cpu);
 		raw_spin_lock(&dl_b->lock);
@@ -3883,7 +3933,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			 * deboosted from priority inheritance, nor for a
 			 * special one: neither has bandwidth in total_bw.
 			 */
-			dl_task_release_bw(p, task_cpu(p));
+			dl_task_release_bw(p);
 			released = true;
 		}
 		sub_rq_bw(&p->dl, &rq->dl);
@@ -3918,7 +3968,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 */
 	if (p->dl.dl_non_contending) {
 		p->dl.dl_non_contending = 0;
-		dl_task_depart(p, task_cpu(p));
+		dl_task_depart(p);
 	}
 
 	/*
@@ -3942,13 +3992,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	/*
 	 * Boosted back into the class before its 0-lag time (a policy change
 	 * released that bandwidth in sched_dl_overflow()): the inactive
-	 * timer will not remove it, but its leaving the class again. That
-	 * forgets the CPU recorded: moved to another root domain meanwhile,
-	 * the task then removes the bandwidth from that one, as it did
-	 * before departures were recorded.
+	 * timer will not remove it, but its leaving the class again, from
+	 * the root domain of the CPU recorded, which it keeps.
 	 */
-	if (p->dl.dl_departed_cpu >= 0)
-		dl_task_undepart(p);
+	dl_task_undepart(p);
 
 	/* If p is not queued we will update its parameters at next wakeup. */
 	if (!task_on_rq_queued(p)) {
@@ -4155,9 +4202,10 @@ int sched_dl_overflow(struct task_struct *p, int policy,
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
@@ -4166,6 +4214,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
 		return 0;
 
+	/*
+	 * The bandwidth of a task of the class is counted in the root
+	 * domain that took it, which the CPU the task is on does not tell:
+	 * moved asleep, it has not run there yet. Change it where it is
+	 * counted; a rebuild that dropped it, and a task that enters the
+	 * class, have the root domain of that CPU take the new one. The
+	 * caller holds cpuset_mutex, or the lock of dl_accounting_lock()
+	 * without cpusets, so no rebuild runs meanwhile.
+	 */
+	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
+		  p->dl.dl_bw_gen == dl_bw_gen;
+	cpu = counted ? p->dl.dl_bw_cpu : task_cpu(p);
+	dl_b = dl_bw_of(cpu);
+
 	/*
 	 * Either if a task, enters, leave, or stays -deadline but changes
 	 * its parameters, we may need to update accordingly the total
@@ -4180,7 +4242,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, counted ? p->dl.dl_bw : 0,
+				  new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4188,7 +4251,8 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		 * But this would require to set the task's "inactive
 		 * timer" when the task is not inactive.
 		 */
-		__dl_sub(dl_b, p->dl.dl_bw, cpus);
+		if (counted)
+			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		dl_change_utilization(p, new_bw);
 		err = 0;
@@ -4209,11 +4273,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 * run meanwhile: the caller holds cpuset_mutex, or the lock of
 	 * dl_accounting_lock() without cpusets.
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
+			 * Whatever bandwidth the task still has counted
+			 * somewhere, the new one replaces: on the departed
+			 * list, or taken off it by a boost into the class
+			 * (switched_to_dl()), the record says where.
+			 */
+			if (p->dl.dl_bw_cpu >= 0)
+				dl_task_release_bw(p);
+		}
+		p->dl.dl_bw_cpu = cpu;
 		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
@@ -4354,7 +4427,8 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
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

