Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=CXZkcYas9gkk6Yf+lsxlb0EcCUrbDDLGEtOUMo4EnUHyU0odzLypmLB7RGi1qOcjz5Kg
	 Cg0xn+ZnYVBE+DUXuSMIWGfwGT2tuJzK6kTF8/RqvUt7nRO/FOI2mtY/cLonIzcIuAN4a
	 pW1eaQmH5Wboj5EFjOxnLSlrc00cDT9oLohUyJJLkhHQGFZYW7aZBJ7VxJLSSZT5Wp3OF
	 9K6FzURlbXDThSYFuzdmglQStK9jZlX8B8iPe9K1GlUEtWBc41jX8OkgnJuAWXfMfcA9X
	 W/3mgJYrOpUmVf/92RI2YqcVZFONv1RikinyHqfzvLmZ/Ew8D+EjtDVGmmzxWke61vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0LxcqJusdAa5/KVMCvu6BcM2o5qX12uk52R9g3CBBt8=;
	b=nRfbIqYqUqLzu7wCmdLfUcQ0/HeCAF2IyDyZo1bTKmQN8sbAw33Dt2a6mUr/9ola34D4
	 SIc+UUzCBzRwaiA3TEn9CO+Bo3GPRPWhAQma+4yDjJvt8ffOu1JYE06dAOkH5nm2XVKMm
	 jwg95qFj+0NbddzIOQwso9Q3PBpaF5Rb5h668yagkk+qoA8eUPDYlLoJTDVO9JyMZYdEN
	 b19fLrFfHVIABNP+81ssO39+5JpRi/IgfEopuusKHdM41VwSzA5+LUJGgwFFjahgleDII
	 BxaWLdINRx8HgNfKldBd7j+puemg/HRnH6ZskBR1YBt72QvIetNvNYoQk6d+nwIT0iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xS2SU3YZ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36109606F5A9;
	Thu,  5 Nov 2026 19:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36109606F5A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xS2SU3YZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907250;
	bh=0LxcqJusdAa5/KVMCvu6BcM2o5qX12uk52R9g3CBBt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS2SU3YZvg0V5nF8mYLKqEXYvBkOFNMo/aJtDohn/eFn63/iS7mzVOOm8eYboEq/q
	 AKSYhpwwpUdt69IfAl5eAvk++wc2QE+A174DHZYpI3rfBYbYF+pgUM7p/ru8rxDtDk
	 8cTVe2ywstZx9FfJvoaF1kpGIFqtk424xkSth/67XagQFBAZdbLX7HlQMhSLcwbpwd
	 mVef5eQoWnLQpsIdV+tWDEgjnC3XRS3cH0217N1WQdaGmGVVi9PPH1af/xpiUm3GPV
	 S+MkwnhtEjQo4epgZu9r07VrKZJBQ3MvEBi0bkaMzVVfSTCjw1VFWmi6lK1XlkaaCQ
	 BlE51N7xoEcRQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDL65hhzLJw;
	Thu, 05 Nov 2026 14:34:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 12/24] sched/deadline: Rebuild the root domains' accounting without cpusets too
Date: Thu,  5 Nov 2026 14:33:47 -0500
Message-Id: <20261105193359.1450487-13-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

A change of the root domains, which CPU hotplug and suspend and resume
make, clears their deadline bandwidth accounting and fills it back: the
servers of each CPU, and the bandwidth of the deadline tasks of each
cpuset. The walk that puts the tasks back lives in the cpuset code,
dl_rebuild_rd_accounting(), and is a stub without CONFIG_CPUSETS: such
a kernel loses the bandwidth of every deadline task at the first
hotplug, total_bw of the new root domain holding its servers alone.

The tasks are never told. Each still takes its bandwidth out of
total_bw once it leaves SCHED_DEADLINE, or dies: it underflows, and
admission afterwards refuses every deadline task of the root domain.

Walk the tasks instead of the cpusets, which is all there is without
them, and keep one declaration beside dl_clear_root_domains() for both.
An admission of bandwidth must not run against the rebuild, which
cpuset_mutex sees to where cpusets are built in: __sched_setscheduler()
holds it over sched_dl_overflow(), and the cpuset code holds it from the
attachment of the new root domains in partition_sched_domains() to the
rebuild that fills them. Where they are not, cpuset_lock() is a stub: a
mutex of the deadline code's own takes its place, at both.

In 8-CPU VMs built without CONFIG_CPUSETS, the hotplug_sleepers case of
the selftest added later in this series admits 9 tasks of 10ms every
100ms before taking a CPU offline and back, and 0 after, on v7.4-rc1 as
with the patches before this one; hotplug_departed and
hotplug_server_refused fail after it, and two more hotplug cases skip
for want of room. The five pass with this change, in 4 VMs, with no
warning.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/cpuset.h         |  5 ----
 include/linux/sched/deadline.h | 16 +++++++++++
 kernel/sched/deadline.c        | 49 ++++++++++++++++++++++++++++++++++
 kernel/sched/syscalls.c        | 10 +++++--
 kernel/sched/topology.c        |  9 +++++++
 5 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 914983387e95..608c3c5a9535 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -129,7 +129,6 @@ static inline int cpuset_do_page_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
-extern void dl_rebuild_rd_accounting(void);
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -273,10 +272,6 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
-static inline void dl_rebuild_rd_accounting(void)
-{
-}
-
 static inline void rebuild_sched_domains(void)
 {
 	guard(cpus_read_lock)();
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index bdf39ac1d43d..d69c461a3eda 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -33,6 +33,22 @@ struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
 extern void dl_clear_root_domains(void);
+extern void dl_rebuild_rd_accounting(void);
+/*
+ * The lock that keeps a rebuild of the root domains' accounting from running
+ * against an admission of bandwidth: cpuset_mutex where cpusets are built in,
+ * since every rebuild comes from there, and a lock of the deadline class's own
+ * where they are not.
+ */
+#ifdef CONFIG_CPUSETS
+static inline void dl_accounting_lock(void) { }
+static inline void dl_accounting_unlock(void) { }
+static inline void lockdep_assert_dl_accounting_held(void) { }
+#else
+extern void dl_accounting_lock(void);
+extern void dl_accounting_unlock(void);
+extern void lockdep_assert_dl_accounting_held(void);
+#endif
 /*
  * Return whether moving DL task @p to @new_mask requires moving DL
  * bandwidth accounting between root domains. This helper is specific to
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d4cd5b5fb27b..7a0c27e76028 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3661,6 +3661,54 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
+#ifndef CONFIG_CPUSETS
+/*
+ * Where cpusets are built in, cpuset_mutex keeps an admission of bandwidth
+ * from running against a rebuild of the accounting: __sched_setscheduler()
+ * takes it for every change of or into SCHED_DEADLINE, and the callers of
+ * partition_sched_domains() hold it from the attachment of the new root
+ * domains to the rebuild. Where they are not, cpuset_lock() is a stub and
+ * this takes its place, in both.
+ */
+static DEFINE_MUTEX(dl_accounting_mutex);
+
+void dl_accounting_lock(void)
+{
+	mutex_lock(&dl_accounting_mutex);
+}
+
+void dl_accounting_unlock(void)
+{
+	mutex_unlock(&dl_accounting_mutex);
+}
+
+void lockdep_assert_dl_accounting_held(void)
+{
+	lockdep_assert_held(&dl_accounting_mutex);
+}
+
+/*
+ * Rebuild the root domains' accounting, where no cpuset holds the
+ * deadline tasks of each: they are found by walking them all, which
+ * dl_rebuild_rd_accounting() of the cpusets does per cpuset instead.
+ */
+void dl_rebuild_rd_accounting(void)
+{
+	struct task_struct *g, *p;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_held(&sched_domains_mutex);
+	lockdep_assert_held(&dl_accounting_mutex);
+
+	dl_clear_root_domains();
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p)
+		dl_add_task_root_domain(p);
+	read_unlock(&tasklist_lock);
+}
+#endif /* !CONFIG_CPUSETS */
+
 /*
  * Clear every root domain ahead of a rebuild of their accounting, which
  * dl_add_task_root_domain() then fills with the deadline tasks of the
@@ -4089,6 +4137,7 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 */
 	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
 		lockdep_assert_cpuset_lock_held();
+		lockdep_assert_dl_accounting_held();
 		if (p->dl.dl_departed_cpu >= 0)
 			dl_task_release_bw(p, -1);
 		p->dl.dl_bw_gen = dl_bw_gen;
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index c143b7d02efc..c36b05719de9 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -560,6 +560,7 @@ int __sched_setscheduler(struct task_struct *p,
 	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
 		cpuset_lock();
+		dl_accounting_lock();
 	}
 
 	/*
@@ -655,6 +656,7 @@ int __sched_setscheduler(struct task_struct *p,
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
 		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
 			cpuset_locked = false;
 		}
@@ -746,8 +748,10 @@ int __sched_setscheduler(struct task_struct *p,
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		rt_mutex_adjust_pi(p);
 	}
 
@@ -759,8 +763,10 @@ int __sched_setscheduler(struct task_struct *p,
 
 unlock:
 	task_rq_unlock(rq, p, &rf);
-	if (cpuset_locked)
+	if (cpuset_locked) {
+		dl_accounting_unlock();
 		cpuset_unlock();
+	}
 	return retval;
 }
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 919d0fb00bd9..7e2944c398f8 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3516,7 +3516,16 @@ static void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new
 void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 			     struct sched_domain_attr *dattr_new)
 {
+	/*
+	 * The root domains attached here count no task's bandwidth until
+	 * dl_rebuild_rd_accounting() at the end: no admission of bandwidth
+	 * may run meanwhile. The callers of this hold cpuset_mutex, which
+	 * keeps admissions out, where cpusets are built in; the lock
+	 * dl_accounting_lock() takes stands in for it where they are not.
+	 */
+	dl_accounting_lock();
 	sched_domains_mutex_lock();
 	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
 	sched_domains_mutex_unlock();
+	dl_accounting_unlock();
 }
-- 
2.47.3

