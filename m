Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8214D8D9C
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721216; cv=none; b=Z7ZELlEZcX8XGfivVrpXjUKSu4MUiyTqiNnnCphy9K0VeDN0R+9L0q9pJ0h/ex9tOJJ9nqk7tmCj0gt0b9bC7PXSBd2jUH9cpVhCwQwn7be0Foi6DZhLm5nx6Sh5U4W8R609hoIY14LnFLxdJz0F/g6ZEdyACSD/2IGi4I6obh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721216; c=relaxed/simple;
	bh=7+fwcN9NaXNpkWXppLOssY1H5IABqdNQhNOlr33rJeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxv36jlX02fzOaEDVbfs8VW8BHSAKyMqHPczCKHY9R5m0nsFhgxdjAS6dCAMu5Ws06SRLnZ4O3Z5bjjPNcE6wYSlV/oiFACQSfEjL0C1scso5bZpJ6MS0jsA82C7P/mS/z74ivfpY5+Nza6dUY9PIdaHag8rMR2Q5kZ+fjQrd6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1veDYHK; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1veDYHK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784721211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SP33Qvev1m/W4AQ53CwbMRSLhDuVOFiwNfxjGtC5Fzo=;
	b=Y1veDYHKeTvwnR6MGT+tmIisqNlIKKw8pqG+wzqXFRkZYQK7SZp0FeTObSR6OdIB1fsYPc
	7IJC3trQomj1a0U9Rofh3lsbSI44K0UHNOHzeHufn6K60+iVZU9KY1Hg57WOg8xbA8gA+Y
	UPs0wfMHdDSOfZKYRucxhw54dc/Cv/U=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [RFC PATCH 1/3] sched: Preserve user affinity across frozen CPU fallback
Date: Wed, 22 Jul 2026 19:52:36 +0800
Message-ID: <20260722115238.351821-2-guopeng.zhang@linux.dev>
In-Reply-To: <20260722115238.351821-1-guopeng.zhang@linux.dev>
References: <20260722115238.351821-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

select_fallback_rq() uses set_cpus_allowed_force() when a task has no
allowed active CPU. The forced update normally clears user_cpus_ptr
because the fallback is treated as a permanent affinity override.

CPU freeze is different. freeze_secondary_cpus() removes the secondary
CPUs only for the duration of suspend, and a task restricted to those
CPUs may need a temporary fallback before they are brought online again.
Clearing user_cpus_ptr in this case makes the temporary forced affinity
survive after the secondary CPUs have been brought back online.

Preserve user_cpus_ptr for non-kthreads while a CPU freeze transaction is
in progress and restore the effective affinity after the frozen CPUs have
been brought back online. Stop accepting new temporary fallbacks before
collecting affected tasks, copy each requested mask under the task locks,
and retry the restore if a concurrent explicit affinity update replaces
it. This makes the newer affinity request take precedence.

If immediate restoration fails, retain user_cpus_ptr so that a later
affinity or cpuset update can reapply the requested mask.

Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 include/linux/sched/hotplug.h |   2 +
 kernel/cpu.c                  |   2 +
 kernel/sched/core.c           | 184 ++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h          |   4 +-
 4 files changed, 185 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/hotplug.h b/include/linux/sched/hotplug.h
index 17e04859b9a4..2cfd447b345a 100644
--- a/include/linux/sched/hotplug.h
+++ b/include/linux/sched/hotplug.h
@@ -9,6 +9,8 @@
 extern int sched_cpu_starting(unsigned int cpu);
 extern int sched_cpu_activate(unsigned int cpu);
 extern int sched_cpu_deactivate(unsigned int cpu);
+void sched_cpu_fallback_begin(void);
+void sched_cpu_fallback_end(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern int sched_cpu_wait_empty(unsigned int cpu);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..67828c2158ae 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1902,6 +1902,7 @@ int freeze_secondary_cpus(int primary)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
+	sched_cpu_fallback_begin();
 
 	pr_info("Disabling non-boot CPUs ...\n");
 	for (cpu = nr_cpu_ids - 1; cpu >= 0; cpu--) {
@@ -1978,6 +1979,7 @@ void thaw_secondary_cpus(void)
 
 	cpumask_clear(frozen_cpus);
 out:
+	sched_cpu_fallback_end();
 	cpu_maps_update_done();
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7cde033a31..8160d3287ad9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2771,6 +2771,13 @@ static inline void mm_update_cpus_allowed(struct mm_struct *mm, const cpumask_t
  * sched_class::set_cpus_allowed must do the below, but is not required to
  * actually call this function.
  */
+static void swap_user_cpus_ptr(struct task_struct *p, struct affinity_context *ctx)
+{
+	if (p->migration_flags & MDF_CPUHP_FALLBACK)
+		p->migration_flags |= MDF_CPUHP_AFFINITY_CHANGED;
+	swap(p->user_cpus_ptr, ctx->user_mask);
+}
+
 void set_cpus_allowed_common(struct task_struct *p, struct affinity_context *ctx)
 {
 	if (ctx->flags & (SCA_MIGRATE_ENABLE | SCA_MIGRATE_DISABLE)) {
@@ -2786,7 +2793,7 @@ void set_cpus_allowed_common(struct task_struct *p, struct affinity_context *ctx
 	 * Swap in a new user_cpus_ptr if SCA_USER flag set
 	 */
 	if (ctx->flags & SCA_USER)
-		swap(p->user_cpus_ptr, ctx->user_mask);
+		swap_user_cpus_ptr(p, ctx);
 }
 
 static void
@@ -2796,24 +2803,49 @@ do_set_cpus_allowed(struct task_struct *p, struct affinity_context *ctx)
 		p->sched_class->set_cpus_allowed(p, ctx);
 }
 
+static DEFINE_RAW_SPINLOCK(cpu_fallback_lock);
+static bool cpu_fallback_active;
+
+static bool mark_cpu_fallback(struct task_struct *p)
+{
+	unsigned long flags;
+	bool temporary = false;
+
+	if (p->flags & PF_KTHREAD)
+		return false;
+
+	raw_spin_lock_irqsave(&cpu_fallback_lock, flags);
+	if (cpu_fallback_active) {
+		p->migration_flags |= MDF_CPUHP_FALLBACK;
+		temporary = true;
+	}
+	raw_spin_unlock_irqrestore(&cpu_fallback_lock, flags);
+
+	return temporary;
+}
+
 /*
- * Used for kthread_bind() and select_fallback_rq(), in both cases the user
- * affinity (if any) should be destroyed too.
+ * Used for kthread_bind() and select_fallback_rq().  A user task which is
+ * forcefully moved while CPUs are frozen must retain its requested affinity
+ * so it can be restored when the CPUs come back online.
  */
 void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *new_mask)
 {
 	struct affinity_context ac = {
 		.new_mask  = new_mask,
 		.user_mask = NULL,
-		.flags     = SCA_USER,	/* clear the user requested mask */
+		.flags     = SCA_USER,
 	};
 	union cpumask_rcuhead {
 		cpumask_t cpumask;
 		struct rcu_head rcu;
 	};
 
-	scoped_guard (__task_rq_lock, p)
+	scoped_guard (__task_rq_lock, p) {
+		if (mark_cpu_fallback(p))
+			ac.flags = 0;
 		do_set_cpus_allowed(p, &ac);
+	}
 
 	/*
 	 * Because this is called with p->pi_lock held, it is not possible
@@ -3152,7 +3184,7 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 	if (!(ctx->flags & SCA_MIGRATE_ENABLE)) {
 		if (cpumask_equal(&p->cpus_mask, ctx->new_mask)) {
 			if (ctx->flags & SCA_USER)
-				swap(p->user_cpus_ptr, ctx->user_mask);
+				swap_user_cpus_ptr(p, ctx);
 			goto out;
 		}
 
@@ -3607,6 +3639,145 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	return dest_cpu;
 }
 
+static bool task_has_cpu_fallback(struct task_struct *p)
+{
+	return READ_ONCE(p->migration_flags) & MDF_CPUHP_FALLBACK;
+}
+
+static void restore_cpu_fallback(struct task_struct *p)
+{
+	struct affinity_context ac = { .flags = 0 };
+	cpumask_var_t mask;
+	struct rq_flags rf;
+	struct rq *rq;
+	bool retry;
+	int ret;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		pr_warn_ratelimited("Failed to allocate affinity mask for task %d\n",
+				    task_pid_nr(p));
+		goto clear;
+	}
+
+	for (;;) {
+		rq = task_rq_lock(p, &rf);
+		if (!(p->migration_flags & MDF_CPUHP_FALLBACK) ||
+		    (p->flags & PF_EXITING)) {
+			p->migration_flags &= ~(MDF_CPUHP_FALLBACK |
+						MDF_CPUHP_AFFINITY_CHANGED);
+			task_rq_unlock(rq, p, &rf);
+			break;
+		}
+
+		p->migration_flags &= ~MDF_CPUHP_AFFINITY_CHANGED;
+		cpumask_copy(mask, task_user_cpus(p));
+		task_rq_unlock(rq, p, &rf);
+
+		ac.new_mask = mask;
+		ret = __sched_setaffinity(p, &ac);
+
+		rq = task_rq_lock(p, &rf);
+		retry = p->migration_flags & MDF_CPUHP_AFFINITY_CHANGED;
+		if (!retry)
+			p->migration_flags &= ~MDF_CPUHP_FALLBACK;
+		task_rq_unlock(rq, p, &rf);
+
+		if (!retry) {
+			if (ret)
+				pr_warn_ratelimited("Failed to restore affinity for task %d: %d\n",
+						    task_pid_nr(p), ret);
+			break;
+		}
+	}
+
+	free_cpumask_var(mask);
+	return;
+
+clear:
+	rq = task_rq_lock(p, &rf);
+	p->migration_flags &= ~(MDF_CPUHP_FALLBACK |
+				MDF_CPUHP_AFFINITY_CHANGED);
+	task_rq_unlock(rq, p, &rf);
+}
+
+static struct task_struct *find_cpu_fallback_task(void)
+{
+	struct task_struct *g, *p, *task = NULL;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
+		if (!task_has_cpu_fallback(p))
+			continue;
+		task = get_task_struct(p);
+		break;
+	}
+	read_unlock(&tasklist_lock);
+
+	return task;
+}
+
+static void restore_cpu_fallback_tasks(void)
+{
+	struct task_struct **tasks, *g, *p, *task;
+	unsigned int count = 0, nr = 0, i;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p)
+		count += task_has_cpu_fallback(p);
+	read_unlock(&tasklist_lock);
+
+	if (!count)
+		return;
+
+	tasks = kvcalloc(count, sizeof(*tasks), GFP_KERNEL);
+	if (!tasks)
+		goto scan;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
+		if (!task_has_cpu_fallback(p))
+			continue;
+		tasks[nr++] = get_task_struct(p);
+		if (nr == count)
+			break;
+	}
+	read_unlock(&tasklist_lock);
+
+	for (i = 0; i < nr; i++) {
+		restore_cpu_fallback(tasks[i]);
+		put_task_struct(tasks[i]);
+	}
+	kvfree(tasks);
+
+	/* Catch a child which inherited a fallback while tasks were collected. */
+scan:
+	while ((task = find_cpu_fallback_task())) {
+		restore_cpu_fallback(task);
+		put_task_struct(task);
+	}
+}
+
+void sched_cpu_fallback_begin(void)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&cpu_fallback_lock, flags);
+	WARN_ON_ONCE(cpu_fallback_active);
+	WRITE_ONCE(cpu_fallback_active, true);
+	raw_spin_unlock_irqrestore(&cpu_fallback_lock, flags);
+}
+
+void sched_cpu_fallback_end(void)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&cpu_fallback_lock, flags);
+	WRITE_ONCE(cpu_fallback_active, false);
+	raw_spin_unlock_irqrestore(&cpu_fallback_lock, flags);
+
+	restore_cpu_fallback_tasks();
+}
+
 /*
  * The caller (fork, wakeup) owns p->pi_lock, ->cpus_ptr is stable.
  */
@@ -4612,6 +4783,7 @@ static void __sched_fork(u64 clone_flags, struct task_struct *p)
 	init_numa_balancing(clone_flags, p);
 	p->wake_entry.u_flags = CSD_TYPE_TTWU;
 	p->migration_pending = NULL;
+	p->migration_flags &= ~MDF_CPUHP_AFFINITY_CHANGED;
 	init_sched_mm(p);
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e3e4e68bb0c5..d44dff5186e3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1402,7 +1402,9 @@ static inline int cpu_of(struct rq *rq)
 	return rq->cpu;
 }
 
-#define MDF_PUSH		0x01
+#define MDF_PUSH			0x01
+#define MDF_CPUHP_FALLBACK		0x02
+#define MDF_CPUHP_AFFINITY_CHANGED	0x04
 
 static inline bool is_migration_disabled(struct task_struct *p)
 {
-- 
2.43.0

