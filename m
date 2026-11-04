Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826737;
	b=p0x2S/raLpwdsAz0fMi+RIFFsfPqGa/iy82B0o4FBZhOncE8s3VJb79QIKejYbaugHYe
	 JwrrywCAbRwVbbWftAB3pF58gXOtRtoVGSFngkDXDJnpEyHkjOZlWD8yu+rQzbq6F2Wgr
	 DDiU4QQ8h/qYjChcOEV40Fd/L1sekWZQWthkxh8vHERDYe2PnCOXNMbvs7rXpJGZvnI4+
	 flmMlwX99qgxzee0urx9wDUnUk4jK/Xw2+Q23bwIQ2byaFUMfPC16stITs1YTRTuTEfC+
	 U8wqNeWTNA4ph6gaPIiYPONWL1UshwFhrsvVFNG5iN0qWP1lvoJzJ1h5EiNnZ5PTGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826737;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LdVky3vPE3EETNK5JdN/0riThUNOYn1kCAGxUiTCfOc=;
	b=0JbGoYQQfUtnfU3JyKyUuXUOuiSDUMCnw1tsnfxQ34PMwKXlDkskKSgOjIG7sq7BIk3c
	 xysi3yAntUvQ+5Pz3mCuJKUQtQBXahSSZNwgC1u1aYYKDIJdrtAPHwAoez/DH6YqH9G/D
	 fpk/9jZt/JKqVB4jwFNRRk/pjD2v5UiFEVPWE5cLoK47LGb8clG9hFRxeokeFKpOzDgAW
	 WNMq3Dve8u5blW03c1VhlfH8+zQgaC0yKecyLAhLAQxVJsagV1DeDjXqmA8Am4FAtF4M8
	 By4i7aT5MiGPByeFmWz2Ym8O+TcxGB9eDOHWVuaZaKOUKSB5ON7y5P6XZq72+xRpcUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MtX2eQq1;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABCE6082BC1;
	Wed,  4 Nov 2026 21:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ABCE6082BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MtX2eQq1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826735;
	bh=LdVky3vPE3EETNK5JdN/0riThUNOYn1kCAGxUiTCfOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtX2eQq1jUMkByBCl67SAGVtSlZ+RPwh50dONxUXsdxVtZZV+5qrB/CcWpK7weDL7
	 kFFTwUUcDklvTPFWtPlrGY8+onBkT4B63VKlvBzRc/ziih8x8M7lKK8BjN+rvPYMx3
	 lmTcYUW/Yl/NkjyiZkTV3i6KRhcTzKhxDp0OKcdbXnSF2x2sFKqhx3lE6Mg807hndq
	 SiORE3h9mG0NcaNAKpDdzB7yeHkZ6RyLqh39R0MDik/oncNFhMuWsdEgVhwwB+RJpn
	 kxcHPzJEkpZSmQcs2GDZgaT5T2LT7bbAlw0o/C2ayRWek5UE6b/maIZckrhZmes02v
	 UtPiHMSUeWUYQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRz11yZzLXg;
	Wed, 04 Nov 2026 16:12:15 -0500 (EST)
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
Subject: [PATCH v2 16/21] sched/deadline: Move a task's bandwidth only where room was made
Date: Wed,  4 Nov 2026 16:12:02 -0500
Message-Id: <20261104211207.1392343-17-mathieu.desnoyers@efficios.com>
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

set_cpus_allowed_dl() moves the bandwidth of a deadline task off the
root domain that counts it whenever the new mask leaves that root
domain, on the strength of the room cpuset_can_attach() made in the one
the task moves to, as its comment says. Nothing checks that the room
was made, and two paths reach it without any:

 - cpuset_can_attach() counts the deadline tasks of the attach it is
   asked about. A task that becomes one after that has nothing set
   aside, and the attach moves its bandwidth all the same: the root
   domain it lands in ends short of what its tasks hold, and underflows
   when they leave. A task that flips between SCHED_DEADLINE and
   SCHED_OTHER while it is moved in and out of a one-CPU partition root
   drives total_bw of that partition to 2^64 - 576716 in 8-CPU VMs of
   v7.4-rc1 with the four deadline fixes of sched/urgent, in 1 VM of 4;
 - sched_setaffinity() of a deadline task takes the same path. With
   admission control on, a mask that does not cover the task's root
   domain is refused before this (__sched_setaffinity()), but with
   sched_rt_runtime_us at -1 nothing refuses it.

Say in the affinity context whether the caller made that room, as
SCA_DL_BW_RESERVED, and move the bandwidth only then. The bandwidth of a
task whose move no one made room for stays where it is counted, and the
next rebuild of the accounting attributes it to the root domain of the
task's cpuset.

Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  2 ++
 kernel/cgroup/cpuset.c  | 13 ++++++++++++-
 kernel/sched/core.c     | 14 ++++++++++++++
 kernel/sched/deadline.c | 15 ++++++++++-----
 kernel/sched/sched.h    |  2 ++
 5 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index da3a3a4f7246..52b450d212c6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1960,6 +1960,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
  * Return: zero if successful, or a negative error code
  */
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
+extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
+					const struct cpumask *new_mask);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4159abfbbbb5..5b8f1d9552a6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3326,6 +3326,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
+	bool reserved = false;
 	struct mm_struct *mm;
 
 	lockdep_assert_cpuset_lock_held();
@@ -3335,11 +3336,21 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	else
 		cpumask_andnot(cpus_attach, task_cpu_possible_mask(task),
 			       subpartitions_cpus);
+	/*
+	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
+	 * deadline tasks cpuset_can_attach() counted: say so, so that this
+	 * task's bandwidth moves there with it.
+	 */
+	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus))
+		reserved = true;
 	/*
 	 * can_attach beforehand should guarantee that this doesn't
 	 * fail.  TODO: have a better way to handle failure here
 	 */
-	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+	if (reserved)
+		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach));
+	else
+		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
 	if (cpuset_v2() && !attach_ctx.mems_updated)
 		return;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 04b62c16fa8c..0ff07258cf0c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3269,6 +3269,20 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
+/*
+ * The same, for a caller that has made room in the root domain of @new_mask
+ * for the deadline bandwidth of @p: that bandwidth moves there with it.
+ */
+int set_cpus_allowed_bw_reserved(struct task_struct *p, const struct cpumask *new_mask)
+{
+	struct affinity_context ac = {
+		.new_mask  = new_mask,
+		.flags     = SCA_DL_BW_RESERVED,
+	};
+
+	return __set_cpus_allowed_ptr(p, &ac);
+}
+
 /*
  * Change a given task's CPU affinity to the intersection of its current
  * affinity mask and @subset_mask, writing the resulting mask to @new_mask.
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1dbde0fd199b..7a58e78ac5ce 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3505,12 +3505,17 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	WARN_ON_ONCE(!dl_task(p));
 
 	/*
-	 * Migrating a SCHED_DEADLINE task between exclusive
-	 * cpusets (different root_domains) entails a bandwidth
-	 * update. We already made space for us in the destination
-	 * domain (see cpuset_can_attach()).
+	 * Migrating a SCHED_DEADLINE task between exclusive cpusets
+	 * (different root_domains) entails a bandwidth update, and only
+	 * where the caller has made room for it: cpuset_attach_task() says
+	 * so of the tasks cpuset_can_attach() counted, and of no others.
+	 * The bandwidth of a task whose move no one made room for stays
+	 * where it is counted, for the next rebuild of the accounting to
+	 * attribute, rather than leaving the root domain it moves to short
+	 * of what its tasks hold.
 	 */
-	if (dl_task_needs_bw_move(p, ctx->new_mask)) {
+	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
+	    dl_task_needs_bw_move(p, ctx->new_mask)) {
 		unsigned int src_cpu = dl_task_root_domain_cpu(p);
 		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
 		unsigned int cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a..3e5bc8b6f887 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2953,6 +2953,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+/* The caller made room for @p's deadline bandwidth where the mask points. */
+#define SCA_DL_BW_RESERVED	0x10
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
-- 
2.47.3

