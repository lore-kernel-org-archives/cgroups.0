Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924680;
	b=iR/A0bQzTMMSp0gMQTTtx3cQRj9bZsNFTC4yKUnuK6LE1j3zKtYvS62SXaxr9uswrKJd
	 ZsHUV17eyMcG6SYNkMZt9UKxKMoIcLkyBVsV3Jmd1w4tu4q6ukFwnMR75VgNQr4ou2M4g
	 vt5xjFfJVnDm/44rmD6rsE7hnL93XsV9kaMrAymPzpQvcxxL3BoN37kozCWY15+yXknhh
	 WN6Om9vgmbh2WE/98mQPvzTRb8Uhcpym0uSR/nkVwf9rt1QaXmwEJbbu4IfPmsgXWMq5p
	 t6peUBNzaDhY4YWflU24BHxq4BmEc2EFUU4hFA4E9VMEn3WPmzR8YKHRFjib/PwggcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924680;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KqRB2fUoQdvMAgjnahxWAzykLWpjNoV8n8Li6/lrrPI=;
	b=AXK0d7qZ8CrZXVYPDuEUKdySkPrhL9oTghUXMweYAJKLliqu3OoAWZJbwJV5lqCrCona
	 L2KHPBirJi3/FucII08VNYJL4fARwJpVLRADCiLWBsafLlBbvy54PQWWTXXbA5Aadnjkn
	 D09JIbL/7dn771ZlEnxJdtMyZyMgdJcRqsWHE/FdpEG1GEo6XugQI3Me7Tfv3B6S5CqUF
	 ntkdnzy1MVDsppM+I/l1x3iI4eJZNF2hpeBUt42pXEfo/cEShIIhhCjLl34cHtMKz1yU2
	 NrBnf/V5QHY/kWr0z84QxOUyq6KGfT5nvCyftvYmTx0vJHhE33R7sQHnIvBoZNGTvgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Q11l9hCf;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F41606BDA3;
	Tue, 17 Nov 2026 14:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F41606BDA3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Q11l9hCf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924669;
	bh=KqRB2fUoQdvMAgjnahxWAzykLWpjNoV8n8Li6/lrrPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q11l9hCfnwThZYZ6PkKciT9Qs9tV/93zZseyRwGZt/7zFzN4W/c6lyqsSn5zTqtLU
	 a9Y4RPQUtlWTSb/6WNKIBAyYP/ktWya6yCVb1Iu3v3gAa97cEbNf6h6b6dibknROuj
	 582psWubJiqzyIPWLasX9FlWaiKtwjvrS5bBMp2XG/R9lRU7Mm2ZiQQksO0JOqPDd0
	 79rMnwe2sOybg4UQ05iGVQ5ZLvQJ2psHp1qAHp5/L/pMpO1SQjF46d6DfaD7V4TEdl
	 rdO4rOBjCZhBUlaI3/G4Yz+DlQ2FaF5TZsAmXmHxpfy6ZnJ+8u0G7MMry6Ps8Vw5O9
	 UOPbhbStG9DEQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV54Xs6zR8K;
	Tue, 17 Nov 2026 09:11:09 -0500 (EST)
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
Subject: [PATCH v7 29/40] sched/deadline: Keep the last CPU a task has in its root domain
Date: Tue, 17 Nov 2026 09:10:50 -0500
Message-Id: <a075dad17300a5b31dc3d99bef81fb9dadd6cbcd.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

dl_bw_deactivate() refuses to take a CPU offline when the rest of its
root domain cannot hold the deadline bandwidth counted there. It also
keeps the last CPU of a root domain that counts a deadline task. That
test comes from commit d4742f6ed7ea ("sched/deadline: Correctly account
for allocated bandwidth during hotplug").

That test looks at the root domain, not at the mask of each task. With
isolcpus="domain", a cpuset that is not a partition root can hold one
housekeeping CPU and some isolated CPUs. A deadline task in it can be
counted in the housekeeping root domain. When that housekeeping CPU
goes offline, the root domain keeps its other CPUs, so the offline is
accepted. But the task has only isolated CPUs left. It runs in the
default root domain, which did not admit it. Its bandwidth follows with
no admission test, and the default root domain can exceed its limit.

Refuse the offline with EBUSY in that case. Walk the deadline tasks
counted in the root domain of the CPU. Refuse if one of them has CPUs
left to run on, but none in that root domain. Skip the walk if no task
holds a bandwidth. A task whose mask holds no other CPU gets the CPUs of
an ancestor of its cpuset: add cpuset_cpus_allowed_without() to tell
which. Like __set_cpus_allowed_ptr(), it keeps them within the affinity
set by the user, if they intersect. Skip a dead task: it runs no more.

Do not refuse during a suspend. It takes the CPUs offline with the
tasks frozen, and the resume puts them back. Do not refuse without
admission control either: there is no limit to exceed.

An administrator who needs the CPU offline can first give the cpuset of
the task another CPU of that root domain. The offline is then accepted,
and the task wakes up on that CPU: the hotplug_keeps_root_domain case
tests this. The administrator can also turn admission control off, by
writing -1 to /proc/sys/kernel/sched_rt_runtime_us.

The walk cannot miss a task. sched_setattr() only makes a deadline task
of a task whose mask holds its whole root domain. sched_setaffinity()
only gives a deadline task such a mask. A mask also gets smaller by a
cpuset change or a cpuset move, and both exclude CPU hotplug.

For user-space, the refused offline is a write of 0 to
/sys/devices/system/cpu/cpuN/online that fails with EBUSY. An offline
that leaves each deadline task a CPU in its root domain is accepted as
before.

The case hotplug_last_refused of deadline_bw_test, added later in this
series, tests this. Without this patch the offline is accepted. The
cases hotplug_user_mask_refused and hotplug_dead_accepted test the
affinity set by the user and a dead task.

Fixes: d4742f6ed7ea ("sched/deadline: Correctly account for allocated bandwidth during hotplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h  |  9 +++++++
 kernel/cgroup/cpuset.c  | 26 ++++++++++++++++++
 kernel/sched/deadline.c | 60 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 5d0c01a25354..68849539cc8b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -79,6 +79,8 @@ extern void lockdep_assert_cpuset_lock_held(void);
 extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern void cpuset_cpus_allowed_without(struct task_struct *p, int cpu,
+					struct cpumask *mask);
 extern int cpuset_num_cpus(struct cgroup *cgroup);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
@@ -214,6 +216,13 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
 	return false;
 }
 
+static inline void cpuset_cpus_allowed_without(struct task_struct *p, int cpu,
+					       struct cpumask *mask)
+{
+	cpumask_and(mask, task_cpu_possible_mask(p), cpu_active_mask);
+	cpumask_clear_cpu(cpu, mask);
+}
+
 static inline int cpuset_num_cpus(struct cgroup *cgroup)
 {
 	return num_online_cpus();
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7bdb9e21a7ed..3ccd61a37d30 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4312,6 +4312,32 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
+/*
+ * Set @pmask to the active CPUs that the cpuset of @tsk gives it once @cpu
+ * is offline: those of the nearest ancestor that keeps one. Leave it empty
+ * if there is none. As cpuset_update_tasks_cpumask() does, keep the CPUs
+ * possible for @tsk. As __set_cpus_allowed_ptr() does, keep those of the
+ * affinity the user set, if one is left. The caller holds the CPU hotplug
+ * lock for writing, which keeps the cpusets and their tasks as they are.
+ * It holds the pi_lock of @tsk, which keeps its user affinity.
+ */
+void cpuset_cpus_allowed_without(struct task_struct *tsk, int cpu,
+				 struct cpumask *pmask)
+{
+	struct cpuset *cs;
+
+	guard(rcu)();
+	for (cs = task_cs(tsk); cs; cs = parent_cs(cs)) {
+		cpumask_and(pmask, cs->effective_cpus, cpu_active_mask);
+		cpumask_clear_cpu(cpu, pmask);
+		if (!cpumask_empty(pmask))
+			break;
+	}
+	cpumask_and(pmask, pmask, task_cpu_possible_mask(tsk));
+	if (tsk->user_cpus_ptr && cpumask_intersects(pmask, tsk->user_cpus_ptr))
+		cpumask_and(pmask, pmask, tsk->user_cpus_ptr);
+}
+
 /**
  * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
  * @tsk: pointer to task_struct with which the scheduler is struggling
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5f77d3c5fa0..47264640de14 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -5028,9 +5028,67 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 	return overflow ? -EBUSY : 0;
 }
 
+/*
+ * Return true if @p has CPUs to run on once @cpu is offline, but none in
+ * the root domain of @cpu, which counts its bandwidth. A dead task runs no
+ * more. It can wait for its 0-lag time, or for its parent to reap it.
+ * Return false for it.
+ */
+static bool dl_task_leaves_span(struct task_struct *p, int cpu,
+				const struct cpumask *span)
+{
+	struct cpumask *msk;
+
+	guard(raw_spinlock_irqsave)(&p->pi_lock);
+	if (READ_ONCE(p->__state) == TASK_DEAD || dl_task_bw_span(p) != span)
+		return false;
+	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	/* A task in a migrate_disable() section has a cpus_ptr of one CPU. */
+	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
+	cpumask_clear_cpu(cpu, msk);
+	/* With no CPU left, the cpuset gives @p the CPUs of an ancestor. */
+	if (cpumask_empty(msk))
+		cpuset_cpus_allowed_without(p, cpu, msk);
+	return !cpumask_empty(msk) && !cpumask_intersects(msk, span);
+}
+
+/*
+ * Return true if @cpu is the last CPU that a deadline task can run on in
+ * the root domain that counts its bandwidth. With @cpu offline, the task
+ * would run in another root domain, which did not admit it. The mask of
+ * a task can hold CPUs of two root domains: with isolcpus="domain", or on
+ * cgroup v1 with sched_load_balance off.
+ *
+ * A suspend takes the CPUs offline with the tasks frozen, and the resume
+ * puts them back. Without admission control, there is no limit to exceed.
+ * Return false in both cases.
+ */
+static bool dl_cpu_last_of_task(int cpu)
+{
+	const struct cpumask *span;
+	struct task_struct *g, *p;
+
+	if (cpuhp_tasks_frozen || !dl_bandwidth_enabled())
+		return false;
+	/* No task holds a bandwidth: do not walk the task list. */
+	if (!atomic_read(&dl_nr_bw_tasks))
+		return false;
+	guard(rcu)();
+	span = cpu_rq(cpu)->rd->span;
+	for_each_process_thread(g, p) {
+		if (task_has_dl_policy(p) && dl_task_leaves_span(p, cpu, span))
+			return true;
+	}
+	return false;
+}
+
 int dl_bw_deactivate(int cpu)
 {
-	return dl_bw_manage(dl_bw_req_deactivate, cpu, 0);
+	int ret = dl_bw_manage(dl_bw_req_deactivate, cpu, 0);
+
+	if (!ret && dl_cpu_last_of_task(cpu))
+		ret = -EBUSY;
+	return ret;
 }
 
 int dl_bw_alloc(int cpu, u64 dl_bw)
-- 
2.47.3

