Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790179;
	b=QTqszMjo2KvJE6CMS4jatWTYApymEGckR+zmfEX9wTbOWRownxbnF9ohxqCIjQfA6bnw
	 mVFrOQJY3Urr+l80inBkW9uCBvAXEWB8GnZWXt9UpTjyPg/B8R62oZqw+7BZRHHemwugy
	 nqNzFAG54gqK1mit5Ha1rwmN9POnZ5YevgwQrYU89mrI9MHW9hSEApt8HmmbfACA77ewt
	 4S9cJdlPAkR70N6/SWaYNpd/+kOI+U8INFzPvacK58PN72OutE8QXKLt3zMexEcUsLCLT
	 azQK6tVMOGgohaCF+5ywDtCDuiaW//eP1zyMSJxfFIoPdtA8AJaKUlIy6IqvZqupgHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790179;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dTOjNSySRc1sjmCxrnEVq/A7RHHWE9DcAn9XWdaIaXY=;
	b=bJnFqfqhCsVHGyPpsh6t8vVDESf9Pi07KNiqUmCkETAe3SeZAGiXAg1EB4wLnIQzz/9G
	 Q869vAWxUsvardbbrzmh6vyMCBSXYNHOS10irvh2qORH4nu+cqgSW6EOXUgTNWmoVwKIx
	 snnt6kaD4i2HvmUrcH6A/nMTmI6be6QTHelyf3cJqTndBZp4T4TiXzbPeVFfjV8hzAYjT
	 ol7t85HFK/atIH5kgD3fBiNuSorW7k3VqXhEbNFwE8Q1YF7Ygy38KEuVWHgkLbrL3aNKy
	 MkQyrqoXdHRnkXberS31JGfWFvqRuP7ja/f1xW4QZSA1uVp/xfGub9U6oX/JlUOgMLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=dffDZobM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464A860A3804;
	Fri, 27 Nov 2026 14:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 464A860A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=dffDZobM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790176;
	bh=dTOjNSySRc1sjmCxrnEVq/A7RHHWE9DcAn9XWdaIaXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dffDZobMXhPXFJmY6XFbmaHCqFnYdH1WfNumcykP4v8IcPKRK9jMO17Q4yFcjfUKi
	 S+ya8aA03nXA8pRN0XZr/3GHVB6LPhqtnVdvdjv8FwbPou2Lggvq4CMIQFHD6yaJ2A
	 vgUO5AOzKpaDqXBni9qNtEl7sVIwDw+x+4JTGW1PKt+rFWjWnpf4O6a9+xAat+tBK5
	 TJ4nOb1I2V7dptp9pbzFUYNaOOOwzBucMbeRPDNn/pMbfijfg/6scCwBTVtojAbrXd
	 6DS6C++EKCKjcHw4SD0Y12RCk4k9IJ7CFKjV7gkY7yRQ7+iz+K6lNRSE0n1+BGfSEk
	 QIbeDfLoDcfdQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZS2BGSzXZJ;
	Fri, 27 Nov 2026 09:36:16 -0500 (EST)
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
Subject: [PATCH v12 16/43] sched/deadline: Keep the last CPU a task has in its root domain
Date: Fri, 27 Nov 2026 09:35:43 -0500
Message-ID: <c58504d3bb6de3c19a52599bdac936c311c30265.1795771147.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

That test looks only at the root domain of the CPU going offline, not
at the mask of each task. It misses two ways in which an offline takes
a deadline task out of the root domain that admitted it:

 - The task loses the last CPU of its mask in that root domain. With
   isolcpus="domain", a cpuset that is not a partition root can hold one
   housekeeping CPU and some isolated CPUs. A deadline task in it can be
   counted in the housekeeping root domain. When that housekeeping CPU
   goes offline, the root domain keeps its other CPUs, so the offline is
   accepted. But the task has only isolated CPUs left. It runs in the
   default root domain.
 - The offline makes a cpuset partition invalid. Its CPUs then join the
   root domain of its parent, with its tasks. These tasks can be counted
   in another root domain than that of the CPU going offline. A test of
   that root domain does not see them. In testing, an offline put three
   deadline tasks of 40% in a root domain of one CPU this way.

Either way, the bandwidth of the task follows it with no admission
test, and the root domain it arrives in can exceed its limit.

Fix this by refusing such an offline with EBUSY. dl_bw_deactivate()
gets one check for each way.

The first check walks the deadline tasks counted in the root domain of
the CPU. It refuses if one of them has CPUs left to run on, but none in
that root domain. A task whose mask holds no other active CPU gets the
CPUs that its cpuset gives it after the offline. Add
cpuset_cpus_allowed_without(), which works them out as cpuset does, on
cgroup v1 and v2. Like __set_cpus_allowed_ptr(), it keeps them within
the affinity set by the user, if they intersect. If the cpuset gives no
CPU the task can run on, select_fallback_rq() picks one. The previous
patch makes it keep a deadline task in its root domain when it can.

The second check is cpuset_offline_moves_dl(). It refuses the offline
in these cases:

 - The partition root of the CPU has tasks and no CPU of its own left.
   It takes the CPUs of a child partition. cpuset makes that child
   invalid, with its own child partitions. Refuse if one of these
   cpusets holds a deadline task. Accept the two cases where the CPUs
   keep their root domain. Either the parent and the child are both
   isolated: the CPUs stay in the default root domain. Or neither is
   isolated. The parent takes all the CPUs of the child, so its root
   domain spans the root domain of the child. It counts the bandwidth
   admitted there. A child partition of that child had a root domain
   of its own, so this exception does not cover its tasks.
 - The partition root of the CPU has tasks and no CPU of its own left,
   and takes none from a child partition. cpuset makes it invalid, and
   its tasks count in its parent. If the parent keeps a CPU of its own,
   the first check sees these tasks. Otherwise, the order of the cpuset
   updates decides where the tasks end. cpuset updates a parent before
   its children, so the parent stays valid with no CPU. It takes the
   CPUs of the next child partition that cpuset updates, if there is
   one. Else a later hotplug event decides. The check does not model
   this. It goes up from the parent while each partition has no CPU of
   its own. It refuses if a deadline task is under the last of these
   partitions. This can refuse an offline that keeps each task in its
   root domain. That needs nested partitions, whose parents gave all
   their CPUs to their children or have them offline. The offline must
   also take the last CPU of a child that holds tasks.
 - The CPU is the last one left to the top cpuset, and partitions exist.
   cpuset then makes every partition invalid, and every deadline task
   changes root domain. Refuse if any cpuset holds a deadline task.

Both checks skip a dead task: it runs no more. They also skip a task
whose bandwidth no root domain counts, such as a sugov kthread. Add
dl_task_holds_bw() for that test.

Neither check runs during a suspend: a suspend takes the CPUs offline
with the tasks frozen, and the resume puts them back. Neither runs
without admission control either: there is no limit to exceed.

An administrator who needs the CPU offline can first give the cpuset of
the task another CPU of that root domain. The offline is then accepted,
and the task wakes up on that CPU: the hotplug_keeps_root_domain case
tests this. The administrator can also turn admission control off, by
writing -1 to /proc/sys/kernel/sched_rt_runtime_us.

The first check cannot miss a task. Only a cpuset change or a cpuset
move gives a deadline task a mask that misses part of its root domain.
sched_setattr() refuses the deadline policy to a task with such a mask.
sched_setaffinity() refuses such a mask to a deadline task. A cpuset
change and a cpuset move both exclude CPU hotplug.

This holds for the tasks that are deadline tasks when the walk runs.
The walk runs before set_cpu_active(false), and sched_setattr() does
not exclude CPU hotplug. So sched_setattr() can admit a new deadline
task in between. The task is on the last CPU of a root domain, and has
an isolated CPU in its mask. After the offline, it would run on the
isolated CPU. That CPU is in the default root domain, which did not
admit it. The bandwidth test of dl_bw_deactivate() has the same
window, from before this series.

An accepted offline can still leave a parent partition valid, with
tasks and no CPU of its own. This happens when no deadline task is
under it. A deadline task can later join one of its child partitions.
The next hotplug event, an online too, can then give the CPUs of that
child to the parent. The task then changes root domain with no
admission test. cpuset could reach that state before this series.

For user-space, the refused offline is a write of 0 to
/sys/devices/system/cpu/cpuN/online that fails with EBUSY. An offline
that leaves each deadline task a CPU in its root domain is accepted as
before.

The case hotplug_last_refused, added to deadline_bw_test later in this
series, tests this. Without this patch the offline is accepted. These
cases test the other paths:
- hotplug_user_mask_refused: the affinity set by the user.
- hotplug_nested_refused: nested cpusets.
- hotplug_dead_accepted: a dead task.
- hotplug_child_partition_kept and hotplug_partition_invalid_refused: a
  child partition made invalid.
- hotplug_sibling_partition_refused: a sibling partition that the
  offline makes invalid.
- hotplug_first_sibling_refused, hotplug_nested_partition_refused and
  hotplug_isolated_child_refused: a parent partition left with no CPU
  of its own.
- hotplug_top_last_refused: the last CPU of the top cpuset.

Fixes: d4742f6ed7ea ("sched/deadline: Correctly account for allocated bandwidth during hotplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h         |  17 ++
 include/linux/sched/deadline.h |   1 +
 kernel/cgroup/cpuset.c         | 308 +++++++++++++++++++++++++++++++++
 kernel/sched/deadline.c        |  78 ++++++++-
 4 files changed, 403 insertions(+), 1 deletion(-)

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
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index bdabd54af729..8eb5cd13b9dd 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -35,6 +35,7 @@ extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domains(void);
 extern void dl_bw_rebuild_begin(void);
 extern void dl_rebuild_rd_accounting(void);
+extern bool dl_task_holds_bw(struct task_struct *p);
 /*
  * Keep a rebuild of the root domains' accounting and an admission of
  * bandwidth from running at the same time. With cpusets, cpuset_mutex
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7bdb9e21a7ed..9461277ed0fa 100644
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
@@ -4312,6 +4334,292 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
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
+	struct cpuset *cs = task_cs(tsk), *from, *gone = NULL;
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
+			if (!cpumask_empty(pmask))
+				break;
+		}
+	} else {
+		/*
+		 * cgroup v2 works out the CPUs of each cpuset from the top
+		 * down. A cpuset keeps those of its parent that cpuset.cpus
+		 * holds, or takes all of them if there are none. Start from
+		 * the nearest partition root that keeps an active CPU, or from
+		 * the top cpuset. A partition root left with no CPU of its own
+		 * can take those of a child partition. One left with tasks and
+		 * no CPU becomes invalid, and its tasks count in its parent. If
+		 * that parent has no CPU of its own either, where the tasks end
+		 * depends on the order of the hotplug walk. Stop there, with no
+		 * CPU from the cpuset: cpuset_offline_moves_dl() refuses that
+		 * offline if a deadline task is under that parent.
+		 */
+		for (from = cs; ; from = parent_cs(from)) {
+			if (from != &top_cpuset && !is_partition_valid(from))
+				continue;
+			cpumask_and(pmask, from->effective_cpus, cpu_active_mask);
+			cpumask_clear_cpu(cpu, pmask);
+			if (cpumask_empty(pmask) && from != &top_cpuset && !gone &&
+			    !partition_child_lost(from, cpu, pmask))
+				cpumask_clear(pmask);
+			if (!cpumask_empty(pmask) || from == &top_cpuset || gone)
+				break;
+			if (partition_populated_offline(from))
+				gone = from;
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
+ * Return true if a task of @cs has the deadline policy and holds a
+ * bandwidth. A dead task does not count: it runs no more.
+ */
+static bool dl_task_in_cpuset(struct cpuset *cs)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+	bool found = false;
+
+	css_task_iter_start(&cs->css, 0, &it);
+	while (!found && (task = css_task_iter_next(&it)))
+		found = task->policy == SCHED_DEADLINE && dl_task_holds_bw(task) &&
+			READ_ONCE(task->__state) != TASK_DEAD;
+	css_task_iter_end(&it);
+	return found;
+}
+
+/*
+ * A child partition of @pp is left with tasks and no CPU by the offline of
+ * @cpu. It becomes invalid, and its tasks count in @pp. Return true if a
+ * deadline task can then change root domain, as far as this can be told
+ * before the offline.
+ *
+ * If @pp keeps a CPU of its own, return false: the walk of the deadline
+ * tasks in dl_cpu_last_of_task() checks the tasks of that child.
+ * Otherwise, where they end depends on the order of the cpuset hotplug
+ * walk, and on later hotplug events. Do not predict it. Go up from @pp
+ * while each partition has no CPU of its own. Return true if a deadline
+ * task is in the last of them, or in a cpuset under it. The caller holds
+ * rcu_read_lock().
+ */
+static bool dl_offline_order_dependent(struct cpuset *pp, int cpu)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp, *top = NULL;
+	bool found = false;
+
+	for (cp = pp; cp != &top_cpuset && is_partition_valid(cp);
+	     cp = parent_cs(cp)) {
+		cpumask_and(&dl_offline_cpus, cp->effective_cpus, cpu_active_mask);
+		cpumask_clear_cpu(cpu, &dl_offline_cpus);
+		if (!cpumask_empty(&dl_offline_cpus))
+			break;
+		top = cp;
+	}
+	if (!top)
+		return false;
+	cpuset_for_each_descendant_pre(cp, pos_css, top) {
+		if (!css_tryget_online(&cp->css))
+			continue;
+		rcu_read_unlock();
+		found = dl_task_in_cpuset(cp);
+		rcu_read_lock();
+		css_put(&cp->css);
+		if (found)
+			break;
+	}
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
+ * then spans all the CPUs of the root domain of that child, and counts
+ * the bandwidth admitted there. A child partition of that child had a
+ * root domain of its own: this case does not cover its tasks.
+ * If @cpu is the last CPU left to the top cpuset, every partition becomes
+ * invalid. The top cpuset takes their CPUs, and every deadline task
+ * changes root domain, those of the top cpuset too.
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
+		if (!lost && cpumask_empty(&dl_offline_cpus) &&
+		    partition_populated_offline(p) &&
+		    parent_cs(p) != &top_cpuset && is_partition_valid(parent_cs(p))) {
+			found = dl_offline_order_dependent(parent_cs(p), cpu);
+			rcu_read_unlock();
+			return found;
+		}
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
+		/* The partition that gives @cp its CPUs. */
+		for (a = cp; a != lost && !is_partition_valid(a); a = parent_cs(a))
+			;
+		if (lost != &top_cpuset &&
+		    ((a->partition_root_state == PRS_ISOLATED &&
+		      p->partition_root_state == PRS_ISOLATED) ||
+		     (a == lost && a->partition_root_state != PRS_ISOLATED &&
+		      p->partition_root_state != PRS_ISOLATED)))
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
index dbf709fd0fd4..cb738ad23b12 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -370,6 +370,12 @@ static inline bool dl_se_holds_bw(struct sched_dl_entity *dl_se)
 	       !(dl_se->flags & SCHED_FLAG_SUGOV);
 }
 
+/* Return true if a root domain counts the bandwidth of @p. */
+bool dl_task_holds_bw(struct task_struct *p)
+{
+	return dl_se_holds_bw(&p->dl);
+}
+
 /*
  * Put @p on dl_departed_list. The root domain of the CPU recorded with it
  * keeps its bandwidth. @p leaves SCHED_DEADLINE, or dies, before its
@@ -5215,9 +5221,79 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
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

