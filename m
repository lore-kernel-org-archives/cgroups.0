Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=d2dr7JaKJfSF3dmieXSljQw42HF8GaUo8qRZIpyHbVKvIuEFJdsIAMYuanjUUojtaZGe
	 81wR3vVuM7V1lc7eabw0VmOPNLSybRXCErcRaJ3o8GSdqguKxzHuqxpzan1lc9NkO5WJo
	 ktRXQ6EM6zhNLqST+AE39jpOQdoiS2RaMp6lntO+bMHTs8A9DMMQK15pOgQ/eBfzISDv8
	 JON9eSV0hLUFHuQ+43kfb47BtyCRpMYUfcYKOXrnrp0SMG28ILpKLsKaS/1GCV5HFNNsk
	 2R4LT810TRExhk4D83mX85hNINMBqdeCCe+YTgoFm+VFQXcUpCZfO+z3emPD+gptFaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BaNU1dyyWgd5+o7vmTa4QxAfsAyIfCxykkKOFsWU7ic=;
	b=ohM080ZK+Bwf8Fs0Kq055S06JSNTkQuP6/AKMnsRk4/iYwcoUGzaEHPuo7agIZQDfBT4
	 Mq0720EhEyY6byGKt6iZti63I0KQWs9zSku9o7DxL62yXbxnhptGh3GGzrVualPs5eFKN
	 BNvT/7db5Y5y4Zq+hyOUJa8iA2bFCxW8tgw34OaPfpvfB8MezfCnEIK+crvxtjTLqnMZC
	 Hg9Koqz7Fbiex535Jqzd3gVQyu0AJJJGwJyrn83kDt6FR8qknL9k4p8t6/OlghPH+HgoT
	 Jttgdx8pcpTI5BKNLE9Z0H7DMKfc5s04+dPpVoQ1W4JFsyJK1NUev6MqdWpwWv/cigw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=D93Mejey;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EC460A3826;
	Thu, 19 Nov 2026 20:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5EC460A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=D93Mejey
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119380;
	bh=BaNU1dyyWgd5+o7vmTa4QxAfsAyIfCxykkKOFsWU7ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D93MejeyZGgOCnYUZtZwqO1QqqtTr4i2JTG4NB4XGHmEUnjpcpV2mI7WHLWl7Ocmb
	 kiRxnKXb33Cu+Pv+sP1+YZclh28wr8sHnOInwydKvIDtWI41eFYAyxndVsyJcnI7ge
	 x+vamn7MiZoGr0lu3SS/3BzhMS29QU2SoNr9RQSqrNVx1LoCcHAT5Pqeg9IAM2J9Xh
	 tL3WdqjHTPZ+pkuFMNA8neNn7fTL+TCI2iIAFqTUTbClO5RZq3k0XLTjSOFisCJtJ5
	 0PpPUGewjiqanukMGXEL0iBwzKdieStTN1nK0T5laDiw4PBMOubOO8pqYMjXAKhk7+
	 rbDanRAb6kNGg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVX3P5dzTpn;
	Thu, 19 Nov 2026 15:16:20 -0500 (EST)
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
Subject: [PATCH v8 16/33] sched/deadline: Keep the last CPU a task has in its root domain
Date: Thu, 19 Nov 2026 15:15:55 -0500
Message-Id: <6e555ba3ad1013206d77ded129a127dadfd3b983.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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
holds a bandwidth. A task whose mask holds no other CPU gets the CPUs
its cpuset has after the offline. With no CPU left in a cpuset, cgroup
v2 gives it the CPUs of its parent, worked out from the top down. A
partition root that holds a task and has no CPU of its own left takes
the CPUs of a child partition instead. cgroup v1 moves its tasks to the
nearest ancestor with CPUs. Add cpuset_cpus_allowed_without(), which
works out the CPUs the same way. Like __set_cpus_allowed_ptr(), it keeps
them within the affinity set by the user, if they intersect. If the
cpuset gives no CPU the task can run on, select_fallback_rq() picks one.
The previous patch makes it keep a deadline task in its root domain when
it can. Skip a dead task: it runs no more.

When a partition root takes the CPUs of a child partition, cpuset makes
that child invalid, with its own child partitions. Their CPUs then join
the root domain of the parent, with their tasks. So a deadline task can
change root domain even if another root domain than that of the CPU
counts it. The walk above does not see it. In testing without this
check, an offline put three deadline tasks of 40% in a root domain of
one CPU. That is over its limit. Refuse the offline if one of these
cpusets holds a deadline task. Add cpuset_offline_moves_dl() for this.
The CPUs keep their root domain in two cases, and the offline is then
accepted. Both partitions are isolated: the CPUs stay in the default
root domain. Or neither is isolated, and the parent takes all the CPUs
of its child: its root domain then spans the same CPUs. When the last
CPU left to the top cpuset goes offline, cpuset makes every partition
invalid. Refuse that offline if a partition holds a deadline task.

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

The case hotplug_last_refused, added to deadline_bw_test later in this
series, tests this. Without this patch the offline is accepted. The
cases hotplug_user_mask_refused, hotplug_nested_refused and
hotplug_dead_accepted test the affinity set by the user, nested cpusets
and a dead task. hotplug_child_partition_kept and
hotplug_partition_invalid_refused test a child partition made invalid.

Fixes: d4742f6ed7ea ("sched/deadline: Correctly account for allocated bandwidth during hotplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h  |  17 +++
 kernel/cgroup/cpuset.c  | 250 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/deadline.c |  72 +++++++++++-
 3 files changed, 338 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 5d0c01a25354..d3fceb919c46 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -16,6 +16,7 @@
 #include <linux/nodemask.h>
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
+#include <linux/sched/isolation.h>
 #include <linux/jump_label.h>
 
 extern bool lockdep_is_cpuset_held(void);
@@ -79,6 +80,9 @@ extern void lockdep_assert_cpuset_lock_held(void);
 extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern bool cpuset_cpus_allowed_without(struct task_struct *p, int cpu,
+					struct cpumask *mask);
+extern bool cpuset_offline_moves_dl(int cpu);
 extern int cpuset_num_cpus(struct cgroup *cgroup);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
@@ -214,6 +218,19 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
 	return false;
 }
 
+static inline bool cpuset_cpus_allowed_without(struct task_struct *p, int cpu,
+					       struct cpumask *mask)
+{
+	cpumask_and(mask, task_cpu_fallback_mask(p), cpu_active_mask);
+	cpumask_clear_cpu(cpu, mask);
+	return false;
+}
+
+static inline bool cpuset_offline_moves_dl(int cpu)
+{
+	return false;
+}
+
 static inline int cpuset_num_cpus(struct cgroup *cgroup)
 {
 	return num_online_cpus();
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7bdb9e21a7ed..5299652d47b6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1126,6 +1126,28 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 		cpuset_force_rebuild();
 }
 
+/*
+ * Set @new_cpus to the effective CPUs that @cp gets. On entry, @new_cpus
+ * holds those that @from gets. @from is @cp or one of its ancestors. Work
+ * down from the child of @from to @cp, as compute_effective_cpumask() does
+ * for a cpuset that is not a valid partition root.
+ */
+static void effective_cpus_below(struct cpuset *cp, struct cpuset *from,
+				 struct cpumask *new_cpus)
+{
+	struct cpuset *a;
+	int depth = 0, i;
+
+	for (a = cp; a != from; a = parent_cs(a))
+		depth++;
+	while (depth--) {
+		for (a = cp, i = 0; i < depth; i++)
+			a = parent_cs(a);
+		if (cpumask_intersects(new_cpus, a->cpus_allowed) || !is_in_v2_mode())
+			cpumask_and(new_cpus, new_cpus, a->cpus_allowed);
+	}
+}
+
 /*
  * tasks_nocpu_error - Return true if tasks will have no effective_cpus
  */
@@ -4312,6 +4334,234 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
+/*
+ * Return true if @cs holds a task, or one of its cpusets that is not a
+ * valid partition root does. This is partition_is_populated() for the
+ * offline path, which holds the CPU hotplug lock for writing instead of
+ * cpuset_mutex. That lock keeps tasks from moving to another cgroup:
+ * cgroup_attach_lock() takes it. The caller holds rcu_read_lock().
+ */
+static bool partition_populated_offline(struct cpuset *cs)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp;
+
+	if (cgroup_has_tasks(cs->css.cgroup))
+		return true;
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		if (cp == cs)
+			continue;
+		if (is_partition_valid(cp)) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
+		}
+		if (cgroup_is_populated(cp->css.cgroup))
+			return true;
+	}
+	return false;
+}
+
+/*
+ * Return the child partition of the valid partition root @p that the
+ * offline of @cpu makes invalid, or NULL. Set @new_cpus to the active CPUs
+ * that @p then has. This follows compute_partition_effective_cpumask().
+ * The offline can leave a populated @p no CPU of its own. The child
+ * partition that holds the last CPUs left then becomes invalid, and @p
+ * takes its CPUs. The caller holds rcu_read_lock().
+ */
+static struct cpuset *partition_child_lost(struct cpuset *p, int cpu,
+					   struct cpumask *new_cpus)
+{
+	bool populated = partition_populated_offline(p);
+	struct cgroup_subsys_state *css;
+	struct cpuset *child, *lost = NULL;
+
+	cpumask_and(new_cpus, p->effective_xcpus, cpu_active_mask);
+	cpumask_clear_cpu(cpu, new_cpus);
+	if (cpumask_empty(new_cpus))
+		return NULL;
+	cpuset_for_each_child(child, css, p) {
+		if (!is_partition_valid(child))
+			continue;
+		if (populated && cpumask_subset(new_cpus, child->effective_xcpus)) {
+			lost = child;
+			continue;
+		}
+		cpumask_andnot(new_cpus, new_cpus, child->effective_xcpus);
+	}
+	return lost;
+}
+
+/*
+ * Set @pmask to the active CPUs that the cpuset of @tsk gives it once @cpu
+ * is offline. Keep the CPUs possible for @tsk, as
+ * cpuset_update_tasks_cpumask() does. As __set_cpus_allowed_ptr() does,
+ * keep those of the affinity the user set, if one is left. Return true.
+ *
+ * If no CPU possible for @tsk is left, the cpuset cannot set the mask of
+ * @tsk. select_fallback_rq() then picks the CPU. It widens the mask to
+ * cpuset.cpus first, on cgroup v2, then to task_cpu_fallback_mask(): the
+ * housekeeping CPUs. It drops the affinity the user set. Give the active
+ * CPUs of that wider mask, and return false. For a deadline task,
+ * select_fallback_rq() may then pick a CPU of its root domain instead.
+ * The caller checks for that.
+ *
+ * The caller holds the CPU hotplug lock for writing, which keeps the
+ * cpusets and their tasks as they are. It does not keep the housekeeping
+ * CPUs: housekeeping_update() does not take that lock. The caller holds
+ * the pi_lock of @tsk, which keeps its user affinity.
+ */
+bool cpuset_cpus_allowed_without(struct task_struct *tsk, int cpu,
+				 struct cpumask *pmask)
+{
+	const struct cpumask *possible = task_cpu_possible_mask(tsk);
+	struct cpuset *cs = task_cs(tsk), *from;
+
+	guard(rcu)();
+	if (!is_in_v2_mode()) {
+		/*
+		 * cgroup v1 moves the tasks of a cpuset left with no CPU to
+		 * the nearest ancestor that keeps one.
+		 */
+		for (from = cs; from; from = parent_cs(from)) {
+			cpumask_and(pmask, from->effective_cpus, cpu_active_mask);
+			cpumask_clear_cpu(cpu, pmask);
+			if (cpumask_intersects(pmask, possible))
+				break;
+		}
+	} else {
+		/*
+		 * cgroup v2 works out the CPUs of each cpuset from the top
+		 * down. A cpuset keeps those of its parent that cpuset.cpus
+		 * holds, or takes all of them if there are none. Start from
+		 * the nearest partition root that keeps an active CPU, or from
+		 * the top cpuset. A partition root left with no CPU of its own
+		 * can take those of a child partition.
+		 */
+		for (from = cs; ; from = parent_cs(from)) {
+			if (from != &top_cpuset && !is_partition_valid(from))
+				continue;
+			cpumask_and(pmask, from->effective_cpus, cpu_active_mask);
+			cpumask_clear_cpu(cpu, pmask);
+			if (cpumask_empty(pmask) && from != &top_cpuset &&
+			    !partition_child_lost(from, cpu, pmask))
+				cpumask_clear(pmask);
+			if (!cpumask_empty(pmask) || from == &top_cpuset)
+				break;
+		}
+		effective_cpus_below(cs, from, pmask);
+	}
+	if (!cpumask_and(pmask, pmask, possible)) {
+		if (is_in_v2_mode() && cpumask_subset(cs->cpus_allowed, possible)) {
+			cpumask_and(pmask, cs->cpus_allowed, cpu_active_mask);
+			cpumask_clear_cpu(cpu, pmask);
+			if (!cpumask_empty(pmask))
+				return false;
+		}
+		cpumask_and(pmask, task_cpu_fallback_mask(tsk), cpu_active_mask);
+		cpumask_clear_cpu(cpu, pmask);
+		return false;
+	}
+	if (tsk->user_cpus_ptr && cpumask_intersects(pmask, tsk->user_cpus_ptr))
+		cpumask_and(pmask, pmask, tsk->user_cpus_ptr);
+	return true;
+}
+
+/*
+ * Scratch mask of cpuset_offline_moves_dl(). The CPU hotplug lock
+ * protects it.
+ */
+static cpumask_t dl_offline_cpus;
+
+/*
+ * Return true if a task of @cs has the deadline policy. A dead task does
+ * not count: it runs no more.
+ */
+static bool dl_task_in_cpuset(struct cpuset *cs)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+	bool found = false;
+
+	css_task_iter_start(&cs->css, 0, &it);
+	while (!found && (task = css_task_iter_next(&it)))
+		found = task->policy == SCHED_DEADLINE &&
+			READ_ONCE(task->__state) != TASK_DEAD;
+	css_task_iter_end(&it);
+	return found;
+}
+
+/*
+ * Return true if the offline of @cpu makes a partition invalid, and a
+ * deadline task of its cpusets then runs in another root domain. That root
+ * domain did not admit the task.
+ *
+ * The partition root @p that holds @cpu can be left with no CPU of its
+ * own. It then takes the CPUs of a child partition, which becomes invalid
+ * with its own child partitions. A task of these cpusets keeps its root
+ * domain in two cases only. Its partition is isolated, and so is @p: the
+ * CPUs stay in the default root domain. Or its partition is the child
+ * whose CPUs @p takes, and neither is isolated. The root domain of @p
+ * then spans the same CPUs. If @cpu is the last CPU left to the top
+ * cpuset, every partition becomes invalid, and every task of a partition
+ * changes root domain.
+ *
+ * The caller holds the CPU hotplug lock for writing, which keeps the
+ * cpusets and their tasks as they are.
+ */
+bool cpuset_offline_moves_dl(int cpu)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp, *a, *p = &top_cpuset, *lost = NULL;
+	bool found = false;
+
+	if (!is_in_v2_mode())
+		return false;
+	rcu_read_lock();
+	cpuset_for_each_descendant_pre(cp, pos_css, &top_cpuset) {
+		if (cp != &top_cpuset && is_partition_valid(cp) &&
+		    cpumask_test_cpu(cpu, cp->effective_cpus)) {
+			p = cp;
+			break;
+		}
+	}
+	if (p != &top_cpuset) {
+		lost = partition_child_lost(p, cpu, &dl_offline_cpus);
+	} else {
+		cpumask_and(&dl_offline_cpus, top_cpuset.effective_cpus, cpu_active_mask);
+		cpumask_clear_cpu(cpu, &dl_offline_cpus);
+		if (cpumask_empty(&dl_offline_cpus) && !cpumask_empty(subpartitions_cpus))
+			lost = &top_cpuset;
+	}
+	if (!lost) {
+		rcu_read_unlock();
+		return false;
+	}
+	cpuset_for_each_descendant_pre(cp, pos_css, lost) {
+		if (cp == &top_cpuset)
+			continue;
+		/* The partition that gives @cp its CPUs. */
+		for (a = cp; a != lost && !is_partition_valid(a); a = parent_cs(a))
+			;
+		if (a == &top_cpuset ||
+		    (a->partition_root_state == PRS_ISOLATED &&
+		     p->partition_root_state == PRS_ISOLATED) ||
+		    (a == lost && a->partition_root_state != PRS_ISOLATED &&
+		     p->partition_root_state != PRS_ISOLATED))
+			continue;
+		if (!css_tryget_online(&cp->css))
+			continue;
+		rcu_read_unlock();
+		found = dl_task_in_cpuset(cp);
+		rcu_read_lock();
+		css_put(&cp->css);
+		if (found)
+			break;
+	}
+	rcu_read_unlock();
+	return found;
+}
+
 /**
  * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
  * @tsk: pointer to task_struct with which the scheduler is struggling
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c33e73e920eb..eead45a0c119 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -5066,9 +5066,79 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
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
+	/* With no CPU left, ask which CPUs the cpuset gives @p. */
+	if (cpumask_empty(msk) && !cpuset_cpus_allowed_without(p, cpu, msk)) {
+		/*
+		 * select_fallback_rq() picks the CPU. It gives @p the CPUs of
+		 * @span if one of them is active and @p can run on all of them.
+		 */
+		if (cpumask_any_and_but(span, cpu_active_mask, cpu) < nr_cpu_ids &&
+		    cpumask_subset(span, task_cpu_possible_mask(p)))
+			return false;
+	}
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
+ * Also return true if the offline makes a cpuset partition invalid, and a
+ * deadline task then runs in another root domain.
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
+	if (cpuset_offline_moves_dl(cpu))
+		return true;
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

