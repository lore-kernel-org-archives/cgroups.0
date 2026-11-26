Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655342;
	b=PHP0+bBQbPgBnA3xUvx4IFKTciMa9YyzlMtMjkESkqObV68fhg6W0J+pDFEXmNphBdiS
	 6bmfoaj9/WIFfWoPkeTwLn8OxiPqOyES2pzj1iJjDUyLvejSW7sVnM+Vo3X+8d1taf2oP
	 EZu2EYY67vpo/DFd5D/4vBJEfnd8i4Dc1KfixIN/n6wHEENY3J5qXjLGEzPvR9jscWw3s
	 EfhV7nduUxhsJATyIb2Kgi4IGWQoCpGx2OefQZqq5X7jDpBNRuWo0Y0mLqyU6KaKeaRrZ
	 4ZqhQgV2xL2MdUCetCelAQjSXuDrX7lYXB+u+xsLo8gm+uQSZTPTw21bWOTfAd6bpzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655342;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YL5lkNCZRhcWgQ2Eu0RfaHXh5Wdjd1HAwK2jRvA5/E8=;
	b=tcvN7HTqv/gib/jdXZw4xgvjghgHyHoqRCJjRssU3+XJNET6Zfe1l+WdJS71xWdW6ikj
	 n3LXi38WRwzJF1NpWxneE0JVeldnVWyyoSafJ9hAob6vW6U7m1rh1VFSHo1+kuS3IkSKl
	 /yqOQNl59V/2bMviVVdPyvuPMJOj3VtYOnyGkWF9ZyaxwHJ7ieYV0Pt+Pkmnp+sMF02H+
	 Hxl4DwH9q/s89V4DyWbVFJMjOWmyA2dORi6zMS/5orTfZFE1vu7RWwnqDYz/7Xxg4MrQL
	 3w8y0tsvn+y4D0uHbtsX3UjeQvwwFyC/0xvpjYARjp5YwEcBxt85YOPWtp5BcF+WFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Xbyh7l+a;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB04F60A263A;
	Thu, 26 Nov 2026 01:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB04F60A263A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Xbyh7l+a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655339;
	bh=YL5lkNCZRhcWgQ2Eu0RfaHXh5Wdjd1HAwK2jRvA5/E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xbyh7l+axdFSH/YSYK7wvkYrzRZVMgCwe5u9AOEvIHTxTO+Vg4VF4Eto6VwjMSkUz
	 VqoBTmzuigjuo14kAMibCR2IwbAQPPMy3g+objv14YvvIpLqNieMXiuPy93NJV1jVM
	 owHFp9p2FGZPPKqmaUQMsaDzaSvBxNOI/dzjhwKOitE6cwV+W/UWoHi33gNJp9sSk+
	 ptSSyjOAcCZNYDwMbN1qhqsWcGI56ZBggakQldwkzy3ghX9umQ+T4/h0kxMqAHCn8D
	 kydiyPtodI3ih0jcjh4KtYAxm/3r11Dc8z/OCygJs6AZK00ldQkctefBzJNQs/zAvO
	 ui78uFsmmbk7w==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjQ6P3lzW9x;
	Wed, 25 Nov 2026 20:08:58 -0500 (EST)
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
Subject: [PATCH v11 15/43] sched/deadline: Keep a task in the root domain that counts its bandwidth
Date: Wed, 25 Nov 2026 20:08:14 -0500
Message-ID: <1b7d48df779794ceece2155c0080722932f2c3cd.1795646914.git.mathieu.desnoyers@efficios.com>
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

The root domain that admits a deadline task counts its bandwidth. The
mask of the task can hold CPUs of another root domain. With
isolcpus="domain", the isolated CPUs are in the default root domain. A
cpuset that is not a partition root can hold isolated and housekeeping
CPUs.

The code that picks a CPU for a task does not look at the root domain
that counts it:

 - select_fallback_rq() and dl_task_offline_migration() pick a CPU when
   the CPU of the task goes offline.
 - __set_cpus_allowed_ptr_locked() picks one when the mask changes.
 - select_task_rq_dl() can leave a task on the CPU it slept on, which
   can be in the other root domain.
 - dl_task_rebuild_cpu() picks the CPU that a rebuild counts a task
   with. It prefers the CPU the task is on, then a housekeeping CPU.

Each can take the task, or its bandwidth, to the other root domain
while its own root domain still has a CPU for it. The bandwidth then
moves with no admission test, and the root domain it arrives in can
exceed its limit.

Fix this with dl_task_bw_span(), which returns the CPUs of the root
domain that counts a task. Make each of these places try one of those
CPUs first.

A CPU offline and the rebuild of the sched domains need more than this,
at five points:

 - The CPU recorded with the bandwidth can be the one going offline.
   Its root domain still counts the task until the rebuild attaches
   that CPU to the default root domain. So dl_task_bw_span() still
   returns that root domain until then. This covers the common case: a
   task that runs on the CPU when it goes offline, which balance_push()
   moves.

 - At an offline, select_fallback_rq() can widen the mask of the task
   before the cpuset update. It first gives the task the CPUs of its
   cpuset, then the housekeeping CPUs. The wider mask can hold no
   active CPU of the root domain that counts the task. The task then
   leaves that root domain, and stays out after the cpuset update. So
   in that case, allow the CPUs of that root domain instead. The cpuset
   update that comes next sets the real mask. If no CPU of that root
   domain is allowed, select_fallback_rq() still tries its fallback
   mask. Without this, in testing, a deadline task that spun on the CPU
   going offline left its root domain in every run.

 - dl_task_offline_migration() has the same window, for a throttled
   task whose timer fires on the CPU going offline. When no CPU of its
   mask was active, it warned and took any active CPU. It now takes an
   active CPU of the root domain that counts the task first. It warns
   only if that root domain has none either.

 - Inside a rebuild, dl_task_bw_span() returns NULL. The CPUs then
   change root domains one by one. A housekeeping CPU passes through
   the default root domain, which holds the isolated CPUs. Its span
   would send a housekeeping task to an isolated CPU. So inside a
   rebuild, the CPU is picked as before this patch. If that CPU is in
   the other root domain, the next wakeup brings the task back.
   dl_task_offline_migration() moves no bandwidth inside a rebuild.

 - After a rebuild, a walk of the task list counts each deadline task
   on the CPU that dl_task_rebuild_cpu() picks. Until the walk reaches
   a task, dl_task_bw_span() returns NULL for it, and
   dl_task_offline_migration() moves none of its bandwidth. The root
   domains are new, and the CPU recorded can be offline. So
   dl_task_rebuild_cpu() cannot use the root domain of that CPU. Record
   in dl_bw_def whether the default root domain counted the task.
   dl_task_rebuild_cpu() then prefers a CPU of the mask on the same
   side: in the default root domain or not. The side cannot come from
   the CPUs isolated at boot: a CPU of an isolated partition is in the
   default root domain too.

A known limit remains. A wakeup can pick its CPU inside a rebuild. If
the walk counts the task before it is queued, its bandwidth can still
move to the other root domain, with no admission test. This was found
by reading, not reproduced.

A task with no CPU left in its root domain still moves, and its
bandwidth with it. The next two patches refuse the changes that lead
to that.

The case hotplug_keeps_root_domain, added to deadline_bw_test later in
this series, tests this. A cpuset holds two isolated CPUs and two
housekeeping CPUs, H and K. A deadline task counted in the housekeeping
root domain sleeps on H. Then H goes offline. The task must wake up on
K. Without this patch it woke up on an isolated CPU, with
isolcpus=domain,0,1.

These cases test the other paths:
 - hotplug_spinner_keeps: a running task whose CPU goes offline.
 - hotplug_fallback_running: the same, when the cpuset of the task has
   no CPU left.
 - hotplug_waking_keeps: a task that wakes up often, at the offline.
 - hotplug_isolated_keeps: the same, for a task counted on the isolated
   side.
 - rebuild_waking_keeps: a wakeup inside a rebuild. It fails in most
   runs if dl_task_bw_span() does not return NULL there. That needs
   isolcpus=domain,0,1.
 - hotplug_isolated_partition_falls_back: a task counted on the CPU of
   an isolated partition, which goes offline. When the side came from
   the CPUs isolated at boot, the rebuild moved the bandwidth to the
   housekeeping root domain. This failed in testing with
   isolcpus=domain.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |   7 ++
 kernel/sched/core.c     |  70 +++++++++++
 kernel/sched/deadline.c | 271 ++++++++++++++++++++++++++++++++++------
 kernel/sched/sched.h    |   3 +
 4 files changed, 314 insertions(+), 37 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e934e2225986..0c89263b1db9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -762,6 +762,12 @@ struct sched_dl_entity {
 	 * in progress reserved room for the bandwidth, or -1.
 	 * cpuset_can_attach() sets it, and cpuset_attach() moves the
 	 * bandwidth there.
+	 *
+	 * @dl_bw_def is true if def_root_domain counted the bandwidth when
+	 * @dl_bw_cpu was recorded. A rebuild changes the root domains, and
+	 * the CPU recorded can go offline. A rebuild then keeps the
+	 * bandwidth on that side: in def_root_domain or not. It is the last
+	 * member, so that no hole is left.
 	 */
 	struct list_head		dl_departed_node;
 	int				dl_bw_cpu;
@@ -786,6 +792,7 @@ struct sched_dl_entity {
 	 */
 	struct sched_dl_entity *pi_se;
 #endif
+	bool				dl_bw_def;
 };
 
 #ifdef CONFIG_UCLAMP_TASK
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7615ba02d52b..3dd42581cc17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3264,6 +3264,27 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 			dest_cpu = ctx->dl_bw_cpu;
 		if (!task_on_rq_queued(p))
 			p->wake_cpu = dest_cpu;
+	} else {
+		const struct cpumask *span = dl_task_bw_span(p);
+		unsigned int cpu = nr_cpu_ids;
+
+		/*
+		 * No room was made for @p in another root domain. Keep @p
+		 * in the root domain that counts its bandwidth, if the new
+		 * mask holds one of its CPUs. Also wake a sleeping @p up
+		 * there. A wakeup during a rebuild of the sched domains has
+		 * no span to prefer.
+		 */
+		if (span && cpumask_test_cpu(dest_cpu, span))
+			cpu = dest_cpu;
+		else if (span)
+			cpu = cpumask_first_and_and(cpu_valid_mask,
+						    ctx->new_mask, span);
+		if (cpu < nr_cpu_ids) {
+			dest_cpu = cpu;
+			if (!task_on_rq_queued(p))
+				p->wake_cpu = dest_cpu;
+		}
 	}
 
 	do_set_cpus_allowed(p, ctx);
@@ -3668,8 +3689,22 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int nid = cpu_to_node(cpu);
 	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
+	const struct cpumask *span;
+	bool span_forced = false;
 	int dest_cpu;
 
+	/*
+	 * Keep a deadline task in the root domain that counts its
+	 * bandwidth, if one of its CPUs is allowed and online.
+	 */
+	span = dl_task_bw_span(p);
+	if (span) {
+		for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+			if (is_cpu_allowed(p, dest_cpu))
+				return dest_cpu;
+		}
+	}
+
 	/*
 	 * If the node that the CPU is on has been offlined, cpu_to_node()
 	 * will return -1. There is no CPU on the node, and we should
@@ -3686,6 +3721,32 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	}
 
 	for (;;) {
+		/* The mask is wider now: look again in that root domain. */
+		if (span && state != cpuset) {
+			for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+				if (is_cpu_allowed(p, dest_cpu))
+					goto out;
+			}
+			/*
+			 * The wider mask has no active CPU in that root
+			 * domain. Allow the CPUs of the root domain instead.
+			 * At an offline, the cpuset update comes next and sets
+			 * the real mask. Give @p a copy of the span: a rebuild
+			 * can change the span itself.
+			 */
+			if (!span_forced) {
+				struct cpumask *msk = dl_fallback_mask();
+
+				span_forced = true;
+				if (dl_task_bw_span_copy(p, msk) &&
+				    cpumask_intersects(msk, cpu_active_mask) &&
+				    cpumask_subset(msk, task_cpu_possible_mask(p))) {
+					set_cpus_allowed_force(p, msk);
+					continue;
+				}
+			}
+		}
+
 		/* Any allowed, online CPU? */
 		for_each_cpu(dest_cpu, p->cpus_ptr) {
 			if (!is_cpu_allowed(p, dest_cpu))
@@ -3707,6 +3768,15 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 			state = fail;
 			break;
 		case fail:
+			/*
+			 * The span replaced the fallback mask, and has no
+			 * allowed CPU. Try the fallback mask before giving up.
+			 */
+			if (span_forced && span) {
+				span = NULL;
+				set_cpus_allowed_force(p, task_cpu_fallback_mask(p));
+				break;
+			}
 			BUG();
 			break;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cd5e3c355829..dbf709fd0fd4 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -277,8 +277,8 @@ static unsigned int dl_bw_gen;
  * where its bandwidth is counted. The new root domains count no task
  * yet.
  *
- * Changed under dl_departed_lock. dl_task_bw_elsewhere() reads it
- * without the lock.
+ * Changed under dl_departed_lock. dl_task_bw_span() and
+ * dl_task_bw_elsewhere() read it without the lock.
  */
 static unsigned int dl_bw_rebuild_seq;
 
@@ -316,6 +316,23 @@ static inline bool dl_bw_move_blocked(struct task_struct *p)
 	       READ_ONCE(p->dl.dl_bw_skip_gen) != READ_ONCE(dl_bw_gen);
 }
 
+/* Return true if @cpu is in def_root_domain. */
+static inline bool dl_cpu_in_def(int cpu)
+{
+	return cpu_rq(cpu)->rd == &def_root_domain;
+}
+
+/*
+ * Record @cpu with @dl_se: the root domain of @cpu counts its bandwidth.
+ * Call it outside a rebuild of the sched domains, when that root domain
+ * is final.
+ */
+static inline void dl_record_bw_cpu(struct sched_dl_entity *dl_se, int cpu)
+{
+	WRITE_ONCE(dl_se->dl_bw_cpu, cpu);
+	WRITE_ONCE(dl_se->dl_bw_def, dl_cpu_in_def(cpu));
+}
+
 /*
  * Start a rebuild of the sched domains. Call it before the first CPU
  * leaves its root domain. dl_clear_root_domains() ends the rebuild.
@@ -325,6 +342,8 @@ void dl_bw_rebuild_begin(void)
 	lockdep_assert_held(&sched_domains_mutex);
 	guard(raw_spinlock_irqsave)(&dl_departed_lock);
 	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+	/* Before the first write of rq->rd: see dl_task_bw_span(). */
+	smp_wmb();
 }
 
 /* End the walk of the task list that dl_clear_root_domains() started. */
@@ -372,9 +391,9 @@ static void dl_task_depart(struct task_struct *p)
 	 * departs from instead, if it is active and the same root domain
 	 * counts the bandwidth.
 	 */
-	if (dl_se->dl_bw_gen == dl_bw_gen && cpu_active(cpu) &&
+	if (dl_se->dl_bw_gen == dl_bw_gen && !dl_bw_rebuilding() && cpu_active(cpu) &&
 	    cpu_rq(cpu)->rd == cpu_rq(dl_se->dl_bw_cpu)->rd)
-		dl_se->dl_bw_cpu = cpu;
+		dl_record_bw_cpu(dl_se, cpu);
 	list_add(&dl_se->dl_departed_node, &dl_departed_list);
 }
 
@@ -956,18 +975,44 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 
 static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p)
 {
+	const struct cpumask *span;
 	struct rq *later_rq = NULL;
 	struct dl_bw *dl_b;
 
 	later_rq = find_lock_later_rq(p, rq);
+	/*
+	 * find_lock_later_rq() looks in the root domain of @rq. Once @rq is
+	 * offline, a rebuild attaches it to def_root_domain. That root domain
+	 * may not count @p. Do not take @p out of the root domain that counts
+	 * it while @p has an active CPU there.
+	 */
+	span = dl_task_bw_span(p);
+	if (later_rq && span && !cpumask_test_cpu(later_rq->cpu, span) &&
+	    cpumask_first_and_and(cpu_active_mask, p->cpus_ptr, span) < nr_cpu_ids) {
+		double_unlock_balance(rq, later_rq);
+		later_rq = NULL;
+	}
 	if (!later_rq) {
 		int cpu;
 
 		/*
 		 * If we cannot preempt any rq, fall back to pick any
-		 * online CPU:
+		 * online CPU. Try the root domain that counts @p first.
 		 */
-		cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
+		cpu = nr_cpu_ids;
+		if (span)
+			cpu = cpumask_first_and_and(cpu_active_mask,
+						    p->cpus_ptr, span);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
+		/*
+		 * No CPU of its mask is active: the CPU goes offline before
+		 * cpuset updates the mask. Keep the task in the root domain
+		 * that counts it, if a CPU of it is active. The task runs
+		 * there until cpuset gives it a new mask.
+		 */
+		if (cpu >= nr_cpu_ids && span)
+			cpu = cpumask_first_and(cpu_active_mask, span);
 		if (cpu >= nr_cpu_ids) {
 			/*
 			 * Failed to find any suitable CPU.
@@ -1010,8 +1055,15 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	 * moved to another cpuset while it was not running. If a rebuild
 	 * dropped the bandwidth, the source root domain has nothing to give
 	 * back.
+	 *
+	 * Move nothing while the sched domains are rebuilt, or before the
+	 * walk that follows has counted @p, as dl_task_move_bw() does. The
+	 * CPU picked above then had no span to prefer. The walk counts @p
+	 * on the side of the CPU recorded.
 	 */
 	scoped_guard (raw_spinlock, &dl_departed_lock) {
+		if (dl_bw_move_blocked(p))
+			break;
 		if (p->dl.dl_bw_gen == dl_bw_gen) {
 			struct rq *src_rq = cpu_rq(dl_task_root_domain_cpu(p));
 
@@ -1032,7 +1084,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 		__dl_add(dl_b, p->dl.dl_bw,
 			 cpumask_weight(later_rq->rd->span));
 		raw_spin_unlock(&dl_b->lock);
-		p->dl.dl_bw_cpu = later_rq->cpu;
+		dl_record_bw_cpu(&p->dl, later_rq->cpu);
 		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
@@ -2969,6 +3021,7 @@ static int
 select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 {
 	struct task_struct *curr, *donor;
+	const struct cpumask *span;
 	bool select_rq;
 	struct rq *rq;
 
@@ -3009,6 +3062,20 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 		    dl_task_is_earliest_deadline(p, cpu_rq(target)))
 			cpu = target;
 	}
+
+	/*
+	 * Keep @p in the root domain that counts its bandwidth. Its mask
+	 * can hold CPUs of another root domain, with isolcpus="domain",
+	 * and @p can sleep on one of them.
+	 */
+	span = dl_task_bw_span(p);
+	if (span && !cpumask_test_cpu(cpu, span)) {
+		unsigned int in_span;
+
+		in_span = cpumask_first_and_and(span, p->cpus_ptr, cpu_active_mask);
+		if (in_span < nr_cpu_ids)
+			cpu = in_span;
+	}
 	rcu_read_unlock();
 
 	return cpu;
@@ -3077,7 +3144,7 @@ static void dl_task_move_bw(struct task_struct *p, int new_cpu)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(new_cpu));
 	raw_spin_unlock(&dl_b->lock);
-	p->dl.dl_bw_cpu = new_cpu;
+	dl_record_bw_cpu(&p->dl, new_cpu);
 	p->dl.dl_bw_gen = dl_bw_gen;
 }
 
@@ -3375,6 +3442,13 @@ static struct task_struct *pick_earliest_pushable_dl_task(struct rq *rq, int cpu
 
 /* Access rule: must be called on local CPU with preemption disabled */
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
+static DEFINE_PER_CPU(cpumask_var_t, dl_fallback_mask_pcpu);
+
+/* Return a mask for select_fallback_rq() alone. Interrupts are off. */
+struct cpumask *dl_fallback_mask(void)
+{
+	return this_cpu_cpumask_var_ptr(dl_fallback_mask_pcpu);
+}
 
 static int find_later_rq(struct task_struct *task)
 {
@@ -3821,6 +3895,100 @@ static unsigned int dl_task_admit_cpu(struct task_struct *p)
 	return cpu;
 }
 
+/*
+ * Return the root domain that counts the bandwidth of @p, or NULL if none
+ * does. Set *@seq to the value of dl_bw_rebuild_seq it was found under.
+ * The mask of @p can hold CPUs of another root domain, with
+ * isolcpus="domain". Where a CPU is picked for @p, a CPU of this root
+ * domain comes first: no other root domain admitted @p.
+ *
+ * Return NULL while the sched domains are rebuilt. The CPU recorded can
+ * then sit in def_root_domain on its way to a new root domain. The span
+ * of def_root_domain holds the isolated CPUs, and no longer the
+ * housekeeping CPUs that already left it. A caller would send a
+ * housekeeping task to an isolated CPU.
+ *
+ * Return NULL also for a task that the walk of the task list after the
+ * rebuild has not reached yet. Its dl_bw_gen is not current.
+ *
+ * The caller holds the pi_lock or the rq lock of @p. With interrupts
+ * off, the root domain is not freed.
+ */
+static struct root_domain *dl_task_bw_rd(struct task_struct *p, unsigned int *seq)
+{
+	struct root_domain *rd;
+	int cpu;
+
+	/* Pairs with the release in dl_clear_root_domains(). */
+	*seq = smp_load_acquire(&dl_bw_rebuild_seq);
+	if (!task_has_dl_policy(p) || dl_entity_is_special(&p->dl) ||
+	    !p->dl.dl_bw || (*seq & 1))
+		return NULL;
+	cpu = READ_ONCE(p->dl.dl_bw_cpu);
+	if (cpu < 0 || READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen))
+		return NULL;
+	/*
+	 * The CPU recorded can be going offline. It keeps its root domain
+	 * until the rebuild attaches it to def_root_domain. The rebuild then
+	 * records an active CPU with @p, or leaves @p out. Until then, the
+	 * root domain of the CPU recorded still counts @p.
+	 *
+	 * The CPUs that isolcpus="domain" isolates are in def_root_domain.
+	 * So are the CPUs of an isolated partition. def_root_domain then
+	 * counts @p. A CPU that is not active, and in def_root_domain while
+	 * @p was counted elsewhere, was attached there by the rebuild.
+	 * def_root_domain does not count @p then.
+	 */
+	rd = READ_ONCE(cpu_rq(cpu)->rd);
+	if (!cpu_active(cpu) && rd == &def_root_domain && !READ_ONCE(p->dl.dl_bw_def))
+		return NULL;
+	return rd;
+}
+
+/*
+ * Return true if a rebuild of the sched domains started since @seq was
+ * read. A rebuild writes rq->rd, and the spans, after it makes
+ * dl_bw_rebuild_seq odd.
+ */
+static inline bool dl_bw_rebuild_since(unsigned int seq)
+{
+	/* Pairs with the smp_wmb() in dl_bw_rebuild_begin(). */
+	smp_rmb();
+	return READ_ONCE(dl_bw_rebuild_seq) != seq;
+}
+
+/*
+ * Return the CPUs of the root domain that counts the bandwidth of @p, or
+ * NULL: see dl_task_bw_rd(). The mask is that of the root domain. A
+ * rebuild that starts after the return can change it. Test bits of it
+ * only. To give the mask to @p, use dl_task_bw_span_copy().
+ */
+const struct cpumask *dl_task_bw_span(struct task_struct *p)
+{
+	unsigned int seq;
+	struct root_domain *rd = dl_task_bw_rd(p, &seq);
+
+	if (!rd || dl_bw_rebuild_since(seq))
+		return NULL;
+	return rd->span;
+}
+
+/*
+ * Copy into @dst the CPUs of the root domain that counts the bandwidth of
+ * @p: see dl_task_bw_rd(). Return false if none does, or if a rebuild of
+ * the sched domains changed the span during the copy.
+ */
+bool dl_task_bw_span_copy(struct task_struct *p, struct cpumask *dst)
+{
+	unsigned int seq;
+	struct root_domain *rd = dl_task_bw_rd(p, &seq);
+
+	if (!rd)
+		return false;
+	cpumask_copy(dst, rd->span);
+	return !dl_bw_rebuild_since(seq);
+}
+
 static void set_cpus_allowed_dl(struct task_struct *p,
 				struct affinity_context *ctx)
 {
@@ -3875,7 +4043,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 			}
 
 			/* Record the CPU the caller made room on. */
-			p->dl.dl_bw_cpu = ctx->dl_bw_cpu;
+			dl_record_bw_cpu(&p->dl, ctx->dl_bw_cpu);
 			p->dl.dl_bw_gen = dl_bw_gen;
 			ctx->dl_bw_moved = p->dl.dl_bw;
 		}
@@ -3992,9 +4160,12 @@ void __init init_sched_dl_class(void)
 {
 	unsigned int i;
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask_dl, i),
 					GFP_KERNEL, cpu_to_node(i));
+		zalloc_cpumask_var_node(&per_cpu(dl_fallback_mask_pcpu, i),
+					GFP_KERNEL, cpu_to_node(i));
+	}
 }
 
 /*
@@ -4036,24 +4207,25 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
  * Return a CPU of the root domain where a rebuild of the accounting should
  * count the bandwidth of @p, or nr_cpu_ids if there is none.
  *
- * Prefer the CPU @p is on, if it is active and in the mask of @p. The
- * task runs, or most often wakes up, in the root domain of that CPU. A
- * mask can hold CPUs of two root domains: housekeeping CPUs and CPUs
- * isolated by isolcpus="domain". When every CPU of a mask goes offline,
- * select_fallback_rq() can widen it to both. A task that then runs in
- * the other root domain takes its bandwidth along.
- * Prefer that CPU also if @p is queued there, out of its mask, and the
- * CPU is the one recorded. Without admission control,
- * dl_task_offline_migration() can put a throttled task and its bandwidth
- * on any active CPU. The task runs there until it blocks.
+ * A mask can hold CPUs of two root domains: housekeeping CPUs and CPUs
+ * isolated by isolcpus="domain". Keep the bandwidth on the side of the
+ * CPU recorded with it. That CPU is in the root domain that admitted the
+ * bandwidth, or that its last move put it in. Take the CPU @p is on if it
+ * is active, in the mask of @p and on that side. Else take the CPU
+ * recorded, if it is active and in the mask. Else take a CPU of the mask
+ * on that side.
  *
- * Else prefer the CPU recorded with the bandwidth, if it is active and in
- * the mask. It is in the root domain that admitted the bandwidth, or that
- * its last move put it in. A task moved asleep is still on a CPU of the
- * root domain it left, out of its mask. Else take the first active CPU of
- * the mask, a housekeeping one if there is one. If no CPU of the mask is
- * active, use the CPUs of the cpuset instead of the mask. A task on
- * isolated CPUs that all went offline can have no active CPU at all.
+ * With no CPU on that side, or no CPU recorded, prefer the CPU @p is on.
+ * Else take the first active CPU of the mask, a housekeeping one if there
+ * is one. A task on isolated CPUs that all went offline can have no
+ * active CPU at all.
+ *
+ * One case comes before all of these. Take the CPU @p is on if @p is
+ * queued there, and the CPU is the one recorded or out of the mask of @p.
+ * Without admission control, dl_task_offline_migration() can put a
+ * throttled task and its bandwidth on any active CPU. The task runs there
+ * until it blocks. Inside a rebuild, that move leaves the record on the
+ * CPU that went offline.
  */
 static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 {
@@ -4068,21 +4240,42 @@ static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 	/*
 	 * Look at the mask of the task first. A change of the cpusets sets
 	 * the mask of each task before its rebuild. If no CPU of the mask
-	 * is active, ask the cpuset. The task wakes up on one of its CPUs.
-	 * Take the CPU recorded only if it is one of them: a partition root
-	 * can have taken it since it was recorded.
+	 * is active, ask the cpuset. The CPU recorded is taken below only if
+	 * the cpuset holds it: a partition root can have taken it since it
+	 * was recorded.
 	 */
 	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
 	cpu = task_cpu(p);
-	if (cpumask_test_cpu(cpu, msk) ||
-	    (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p)))
+	if (cpu_active(cpu) && task_on_rq_queued(p) &&
+	    (cpu == recorded || !cpumask_test_cpu(cpu, &p->cpus_mask)))
 		return cpu;
 	if (cpumask_empty(msk)) {
 		dl_get_task_effective_cpus(p, msk);
 		cpumask_and(msk, msk, cpu_active_mask);
 	}
-	if (recorded >= 0 && cpumask_test_cpu(recorded, msk))
-		return recorded;
+	/*
+	 * Keep the bandwidth where it was counted: in def_root_domain or
+	 * not. The root domains are new, and the CPU recorded can be offline
+	 * or in another root domain now. So prefer a CPU of the mask on the
+	 * side recorded with @p. Do not use the CPUs that isolcpus="domain"
+	 * isolates for this: a CPU of an isolated partition is in
+	 * def_root_domain too.
+	 */
+	if (recorded >= 0) {
+		bool def = READ_ONCE(p->dl.dl_bw_def);
+		unsigned int same;
+
+		if (cpumask_test_cpu(cpu, msk) && dl_cpu_in_def(cpu) == def)
+			return cpu;
+		if (cpumask_test_cpu(recorded, msk) && dl_cpu_in_def(recorded) == def)
+			return recorded;
+		for_each_cpu(same, msk) {
+			if (dl_cpu_in_def(same) == def)
+				return same;
+		}
+	}
+	if (cpumask_test_cpu(cpu, msk))
+		return cpu;
 	cpu = cpumask_first_and(msk, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 	if (cpu < nr_cpu_ids)
 		return cpu;
@@ -4169,7 +4362,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	raw_spin_lock(&dl_b->lock);
 	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
 	raw_spin_unlock(&dl_b->lock);
-	p->dl.dl_bw_cpu = cpu;
+	dl_record_bw_cpu(&p->dl, cpu);
 	p->dl.dl_bw_gen = dl_bw_gen;
 unlock:
 	raw_spin_unlock(&dl_departed_lock);
@@ -4325,7 +4518,11 @@ void dl_clear_root_domains(void)
 	 * has not reached still waits for it: see dl_bw_move_blocked().
 	 */
 	WARN_ON_ONCE(!(dl_bw_rebuild_seq & 1));
-	WRITE_ONCE(dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
+	/*
+	 * After the writes of rq->rd and of dl_bw_gen: pairs with the
+	 * acquire in dl_task_bw_rd().
+	 */
+	smp_store_release(&dl_bw_rebuild_seq, dl_bw_rebuild_seq + 1);
 	WRITE_ONCE(dl_bw_walking, true);
 	for_each_possible_cpu(cpu) {
 		if (!dl_bw_visited(cpu, cookie))
@@ -4745,7 +4942,7 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 			if (p->dl.dl_bw_cpu >= 0)
 				dl_task_release_bw(p);
 		}
-		p->dl.dl_bw_cpu = cpu;
+		dl_record_bw_cpu(&p->dl, cpu);
 		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a719b62dc114..e2bb192f1ee6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -361,6 +361,9 @@ extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
+extern const struct cpumask *dl_task_bw_span(struct task_struct *p);
+extern bool dl_task_bw_span_copy(struct task_struct *p, struct cpumask *dst);
+extern struct cpumask *dl_fallback_mask(void);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
-- 
2.47.3

