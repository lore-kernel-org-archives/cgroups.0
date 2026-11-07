Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015906;
	b=1pdQyKKnXDcrCl7tBnh9vtyBdCh54BlhEjcLZvnMc/b6UBR5secU4iybgT22tijhHzb9
	 HAOjJ/uBiLIGLoctPxvXuiOzWiKNmaIfbMEcAhx7urjkAFHQOnqiaGuVKi5UUDjFBn/uk
	 bMK6B+MfFCR402As47RJE5Yr6R9+sJ0+Bka8HDk5XtuEXwfGobzHP2C0BHM3ZhewQjhZ/
	 WYrPSn6+0pbry8Fj+gIzCluKf1lR/RGXgpd7tDGKmZW5P3o1tNexhO9MIhBbqx67EBjpg
	 /cRTfEAlJ1oqDe4hIwF9JlwMQ1ZjmDCEiQd9FBpwciTIoNjwcyTLbd4lDS8+yJ8tstg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015906;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JXZfaW9Lar1Gkiazzp8FGJjGBiCBkYsOvB2j7t4ztJw=;
	b=xn29rQnfGla32r9HcJbKLFP5yulsNKnDmGUvUbObikYpekKGtT+CjFJTQaQsxm326Yzf
	 z+8ccUhsmllHXmbYbtfxN8IrIvxUcCsHvJlJNmW+FVa6XFTHa+FeyS+X+1hi68hqoUuoP
	 8VI95QLcIpCCw1tos/W9GA1PIMZVtIamKIyxWYDg1vMni+8CfuzeElpLEvDrScbAfPsIq
	 hozQW1H6VlmP9nvug6IF/lhzqWaVEVukDxhDaYYDjx2tlXW4Ejxtx9iXnCCYDEqslsMac
	 tzZ8pN7oj99BB/qCNg5q/0bkRC86SMS+p+EAbN+w9iZDPbghwFKma0Qj7R1QOhLThoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QeJm9aEo;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F25606EEA5;
	Sat,  7 Nov 2026 01:45:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56F25606EEA5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QeJm9aEo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015905;
	bh=JXZfaW9Lar1Gkiazzp8FGJjGBiCBkYsOvB2j7t4ztJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeJm9aEoXsxniMc6Hbv21sU5GH/yLRfriMCFfSZnxGIk0jIuBrHggYtYceJs356z6
	 iTMiSyaV74y613ciajU4XKxaO+UxBLP5jb2b9GW2gFR6EOqCi+TIrDdwG1J6dtMWoJ
	 HDB5C71gZE/NO7Xp2zDycvvvf2xloAal7x1Q2CjH8Lqd0+rGRHryryUt2MvFxvEqMi
	 1unb58/s68UFIYOE8QA5Go2SahF7GMupDSWtteKPjfhjpnLbTP/NktPpADHJMkliyK
	 VtX3t43alwTFQrwT1i3CAQCEi9QFfCNL9FPr417AbiHR0FXvkPVre11FAlL7NO1XI7
	 e5KVvXtoicX0g==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPs1m8PzMFG;
	Fri, 06 Nov 2026 20:45:05 -0500 (EST)
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
Subject: [PATCH v4 17/26] sched/deadline: Move a task's bandwidth only where room was made
Date: Fri,  6 Nov 2026 20:44:42 -0500
Message-Id: <20261107014451.1487825-18-mathieu.desnoyers@efficios.com>
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
   drives total_bw of that partition to 2^64 - 262144 in 8-CPU VMs of
   v7.4-rc1, in 2 VMs of 2;
 - sched_setaffinity() of a deadline task takes the same path. With
   admission control on, a mask that does not cover the task's root
   domain is refused before this (__sched_setaffinity()), but with
   sched_rt_runtime_us at -1 nothing refuses it.

Say in the affinity context whether the caller made that room, as
SCA_DL_BW_RESERVED, and move the bandwidth only then. The bandwidth of a
task whose move no one made room for stays where it is counted, and the
next rebuild of the accounting attributes it to the root domain of the
task's cpuset.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  2 ++
 kernel/cgroup/cpuset.c  | 13 ++++++++++++-
 kernel/sched/core.c     | 14 ++++++++++++++
 kernel/sched/deadline.c | 15 ++++++++++-----
 kernel/sched/sched.h    |  2 ++
 5 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 28b579bff9e1..b0c36891415d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1979,6 +1979,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
  * Return: zero if successful, or a negative error code
  */
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
+extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
+					const struct cpumask *new_mask);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7628cf77bdfd..bf9a7f88c0ed 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3261,6 +3261,7 @@ static cpumask_var_t cpus_attach;
 
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
+	bool reserved = false;
 	struct mm_struct *mm;
 
 	lockdep_assert_cpuset_lock_held();
@@ -3270,11 +3271,21 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
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
index 55a4f2d8294e..6a2d660ffea1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3272,6 +3272,20 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
index 7a7101e6f7a0..1b730e22ee6c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3537,12 +3537,17 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
index a06cf2e0d983..57aadc5b1ba6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2956,6 +2956,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+/* The caller made room for @p's deadline bandwidth where the mask points. */
+#define SCA_DL_BW_RESERVED	0x20
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
-- 
2.47.3

