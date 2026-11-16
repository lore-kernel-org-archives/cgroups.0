Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855975;
	b=e6m03gkO3pwTPifoa7yF4itGniVuahPnAYGvjEQ2bQTaoW4pR4KruifkLhiew4wntzzC
	 7FGBpkRV2IT8hlRift2GKqoarTz3xsi/lGKc2PZSLwDPemqojbrm3ejEZ0wCUpqR29joy
	 mlcxb2UergC1FyPTwP5yUscCjVsQvl2F6lC3Fx8yA6PKaE8mcToXBNHKizzlszyqFzeuK
	 66YVV8q3WIrAfOKFzOr+lUZzIng0i8dpe8f37b8C39gkuuioiBMpZrljBO6aphEgXDrYF
	 bvRI84auvHstgYNnPAMEO7BQOfiJrxxABcYZzncA98mwr3m0aiUeb4DFDjIzfwDTt8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855975;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gjUmCqAeGpBOlbtdIuHrsrJXrk1BxFmY+bRx3MfFQlU=;
	b=eK16rSdP3eDC8y3tkmQdT0AJmbB5fsBWuKNoN4MMZmW3jw3UdiZXfSGSTe/uwPOU3MqK
	 yDpH8DpTlNktLfVa+ci9l4IABbt0EVkIHH1xCrrlT+BFVjeeLLyRxZDA4VeBcqhHBFV6q
	 1s0iPPSx4kyY88R9DWM28gdeijRhVj8Lcko7Dkt8yE/DE+LAlAAhs9LOLwZDZGzPjbQAT
	 LkgUZW0TYGjxEg8Td9N5ASWarUHnDiBW08sG9L3tq4XutjbbDu/lFbgfvBiY9Ipwl5HYd
	 ahOwmO2+VJLPxVJooJtfoiJE04QDPsKGS4XDcLeyTa7NxewjCII3yKvZssRiVCj9+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=d+OslVZs;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1EC606F141;
	Mon, 16 Nov 2026 19:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E1EC606F141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=d+OslVZs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855958;
	bh=gjUmCqAeGpBOlbtdIuHrsrJXrk1BxFmY+bRx3MfFQlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+OslVZsXtixMs9hp9BA+iWRGJswpMJkhrSR1cYeW/lpXkR7D0OgUgdM6D6f+qPFk
	 BY77OYevCf7EBpuVSrlpxgIFFCkg8JKL1IkSo0pszZl6kiEnhIIPFv23kLc5wq6fFJ
	 cUhEOsakUzJmvbg3ws/gAAQMwVStJbNO2jI80XdXsPIsyYPuOyCgwSlbV5fcsikTLt
	 DLHFhnSveuWZOlgTm+YwV61/DVbzYshNir8G3AKgYHTwOpEJki+X8VloAGWTKBkpxO
	 9TgJ24HdvPesk2ckcLo2m1vad9m6EaU5AnbxPEIcmZ7a0ETBynj4CJiPidp46KWtaD
	 ANlRqbW/hEe6Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4k5108zQtg;
	Mon, 16 Nov 2026 14:05:58 -0500 (EST)
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
Subject: [PATCH v6 27/37] sched/deadline: Keep the last CPU a task has in its root domain
Date: Mon, 16 Nov 2026 14:05:39 -0500
Message-Id: <20261116190549.230119-28-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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
which.

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
series, tests this. Without this patch the offline is accepted.

Fixes: d4742f6ed7ea ("sched/deadline: Correctly account for allocated bandwidth during hotplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h  |  9 +++++++
 kernel/cgroup/cpuset.c  | 20 +++++++++++++++
 kernel/sched/deadline.c | 56 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 1 deletion(-)

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
index 0d55f092d9cb..ef5ad8e38f06 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4305,6 +4305,26 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
+/*
+ * Set @pmask to the active CPUs that the cpuset of @tsk gives it once @cpu
+ * is offline: those of the nearest ancestor that keeps one. Leave it empty
+ * if there is none. The caller holds the CPU hotplug lock for writing,
+ * which keeps the cpusets and their tasks as they are.
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
+			return;
+	}
+}
+
 /**
  * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
  * @tsk: pointer to task_struct with which the scheduler is struggling
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5294546786f1..096c0ec55cdc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -4896,9 +4896,63 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 	return overflow ? -EBUSY : 0;
 }
 
+/*
+ * Return true if @p has CPUs to run on once @cpu is offline, but none in
+ * the root domain of @cpu, which counts its bandwidth.
+ */
+static bool dl_task_leaves_span(struct task_struct *p, int cpu,
+				const struct cpumask *span)
+{
+	struct cpumask *msk;
+
+	guard(raw_spinlock_irqsave)(&p->pi_lock);
+	if (dl_task_bw_span(p) != span)
+		return false;
+	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	cpumask_and(msk, p->cpus_ptr, cpu_active_mask);
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
+ * a task holds CPUs of two root domains only with isolcpus="domain".
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

