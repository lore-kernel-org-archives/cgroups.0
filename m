Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826737;
	b=FA/kZLgojzE/YRPavbYmSSwgbzxzuSzT8wN2FsHK6i2PiYy/kRRVn8T5VYuys/TwuP5U
	 Ub2cCD5GYeprK7HZuexR/2z6gvs8R0dWJ+4O5OYzpwsBci8DT8+iAf5eUzL+RlVOrxbfn
	 D9hOEXKuduBXTjaz0sVxQbsdo13Ks8hM/pujDJN95Sd8hIZyYgNBsARMadeahs2n5xv3l
	 mc8N3vp8JOggN5jy5Ac3Y/j8XCIdrykd8QkGFBxQ5TiCHLh23+tAFcQEun+WHwSg7Guh9
	 SLAGUZowUvrOu41fL7wXt4f5KfEO/cn43wxzKxxvX6odSscnlZHPCpUxd670aiX9W6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826737;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cZ7lYq7wRrxOXUBcfl4DYmRYTDgxPqm00WwFdPSFGO4=;
	b=hATOjJEOUJqmqBq67qixHW5EEp2f7XWJxwsUTXljVpnZeUip7N4M4+etBJEgv7tPHJNB
	 b/kbApIEol/DZMS/LM0Gjt3zZtA/ALDTkTWYXvkGqInnRWrC4Q80qLMM7k9eTrC0oYA7O
	 D+CQI4ob8Rj86JvsZmMvVV+2oXFdSARcYcPKebGX/DrzmxFVA2YJ5hYGghkXQD0LDTXTA
	 0yAejhJ6+tMgcg3s8T+G+V8Ht2XwNbALx/RMs2Ep0Q2vmqwUdZX0Oove2ScJ9T1E9cDiR
	 FPCmBEe9dhcIOdcIElIfVbsuRdYogKeu8q32IXtXeWZmTIGy3BtJSYfI9zaMZfiJY0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RKDPCfQV;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DCC60820AB;
	Wed,  4 Nov 2026 21:12:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74DCC60820AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RKDPCfQV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826734;
	bh=cZ7lYq7wRrxOXUBcfl4DYmRYTDgxPqm00WwFdPSFGO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKDPCfQVs+j0J8+7XBlpmaj2iiIerP4MeXSj1M5QV3CBHmkMCCQeNF+3F6J5t2Y+e
	 ed+jLeX+Z5QfL2EPQZJyavVZt/046UHxK2Ge4myfNnYhXvEZ4naD1mzwJlYOBiy5VQ
	 YYnYEmzXP5DG61BfriYarAT/xGA4atUIA7fD0RFbZ/vj+XYtW+qb1jN2USNauQZQAG
	 0aZEGqbAzAhRq8Uay9e1gTlQbWNKLIeRGj6LiL+vCPs94tqAxDd2da4pWk8Df1YoYw
	 p6gt3YYXbKuWnuOITck3TL2tYZ9UO5z+/BerGyPOG7BkWbgMqnHHNSbILpkClbGeFY
	 66bn5CeAVTyEw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRy4QHwzLXc;
	Wed, 04 Nov 2026 16:12:14 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 13/21] sched/deadline: Rebuild the root domains' accounting without cpusets too
Date: Wed,  4 Nov 2026 16:11:59 -0500
Message-Id: <20261104211207.1392343-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

In 8-CPU VMs built without CONFIG_CPUSETS, the hotplug_sleepers case of
the selftest added later in this series admits 9 tasks of 10ms every
100ms before taking a CPU offline and back, and 0 after, on v7.4-rc1 as
with the patches before this one; hotplug_departed and
hotplug_server_refused fail after it, and two more hotplug cases skip
for want of room. The five pass with this change, in 4 VMs, with no
warning.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/cpuset.h         |  5 ----
 include/linux/sched/deadline.h | 16 ++++++++++++
 kernel/sched/deadline.c        | 48 ++++++++++++++++++++++++++++++++++
 kernel/sched/syscalls.c        | 13 ++++++---
 4 files changed, 74 insertions(+), 8 deletions(-)

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
index cbcc00ea46d3..85df2b0044be 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3685,6 +3685,53 @@ void dl_clear_root_domain(struct root_domain *rd)
 		dl_server_add_bw(rd, i);
 }
 
+#ifndef CONFIG_CPUSETS
+/*
+ * Where cpusets are built in, cpuset_mutex keeps an admission of bandwidth
+ * from running against a rebuild of the accounting, and
+ * __sched_setscheduler() takes it for every change of or into
+ * SCHED_DEADLINE. Where they are not, cpuset_lock() is a stub and this
+ * takes its place.
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
+
+	guard(mutex)(&dl_accounting_mutex);
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
@@ -4112,6 +4159,7 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 */
 	if (!err && dl_policy(policy) && !task_has_dl_policy(p)) {
 		lockdep_assert_cpuset_lock_held();
+		lockdep_assert_dl_accounting_held();
 		if (p->dl.dl_departed_cpu >= 0)
 			dl_task_release_bw(p, -1);
 		p->dl.dl_bw_gen = dl_bw_gen;
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 8eddb9d47d8e..b1fc4fadd689 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -559,6 +559,7 @@ int __sched_setscheduler(struct task_struct *p,
 	if (dl_policy(policy) || dl_policy(p->policy)) {
 		cpuset_locked = true;
 		cpuset_lock();
+		dl_accounting_lock();
 	}
 
 	/*
@@ -650,8 +651,10 @@ int __sched_setscheduler(struct task_struct *p,
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		goto recheck;
 	}
 
@@ -740,8 +743,10 @@ int __sched_setscheduler(struct task_struct *p,
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi) {
-		if (cpuset_locked)
+		if (cpuset_locked) {
+			dl_accounting_unlock();
 			cpuset_unlock();
+		}
 		rt_mutex_adjust_pi(p);
 	}
 
@@ -753,8 +758,10 @@ int __sched_setscheduler(struct task_struct *p,
 
 unlock:
 	task_rq_unlock(rq, p, &rf);
-	if (cpuset_locked)
+	if (cpuset_locked) {
+		dl_accounting_unlock();
 		cpuset_unlock();
+	}
 	return retval;
 }
 
-- 
2.47.3

