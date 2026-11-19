Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119386;
	b=WAeiawhVzftp8U6+emZRV7EUDwUexRoEvSQ7VBorW5i5mXmZ74GZvFTwUu+9UTkFgeAj
	 PmikgDE/ZICdrv1QPQGYgC2r0TavmuHVyCgn+hNI96g6+F4uKvEov4hqfY9qsExe7wKId
	 vvnXbEyGjBRB5kQmqkJ2UrDmG0ZBRTndeTaDFl5Z2U4VXnt0oQE/K2x4RWwEec6Ty6KiX
	 G2wrBhqKEJWbVjuRRSOalEkVlW1tZ+NMy2bGwpW8pE6EQ42WYsrvgv3Dc7BaJt5iJp86v
	 Si453ARKEMAvSYqbs3wom/g2rrqDVvixM4EQKoDeeRHEQHFpl6TcVqLvJxv1nxVT+3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119386;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ARZwEE87GgaUUX1mVW8A1EuEtfYACZcNUNdvQu1+hTQ=;
	b=knYZe5uopAJ4c2XHkEXG/KpOlBOsskDGGcjBA7WRlJXI+3f6PbihvyPojy4qBusYlI12
	 vRiJE5ZV62t21Eh0HZoZ3LubEyR2uhsZj72m1a4/kG/pQ94KOz9w6u+uOT4FyXnuqYUaS
	 T+gl1j7xFNV+14XP5w+LxiD85AKAKqrTXkKEmpeOerCWPtM3HsJpCjZP6oFQeQHwaxNCR
	 UlUCi/JvzyJpzqp0UayEVmN8AWhRfk9unP/h7ECVJeTVvo9BRwcUyJQIoAWpVvmpbrY7v
	 7dR6xYIvBxUhKq6fdzQ6yK6nDlfGQjaUhuH0lTcKV8+byfoYrIt662RN5B++i4jmxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tGA39KpY;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EA060A262A;
	Thu, 19 Nov 2026 20:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8EA060A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tGA39KpY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119378;
	bh=ARZwEE87GgaUUX1mVW8A1EuEtfYACZcNUNdvQu1+hTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGA39KpYSDcett0nf6NcBz0kZRzdBTiO8LZ6fluIvu0DpW0qDRCTZE5ywWWSbKcyo
	 iQ5jLrNEDzzPn9lkGLSn+OeOAd+w16fF+R13uyI8EHk+UGdemMuxOG5snWaJCW/BQu
	 tFtPI9BwBCifM1lEDjgu9iMmyluM5V2wPAbv+LaZoNjc1V5Y5AQHc0XdweNMtpLu2a
	 pk1cxqfwTzP094pDe+0LO3XG3J/VJVn+gnGX1eBYM/zFXTdjjhol3Ij95/NDPK8OEj
	 CzBNt66mc+QIomcMVQH/+bg0wu6jN+1bAq3U3uUQTZhMy1rZYEejhSU/Fmez4yZ6jn
	 8j3AmXSdGEF2Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVV5jLXzSrH;
	Thu, 19 Nov 2026 15:16:18 -0500 (EST)
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
Subject: [PATCH v8 07/33] sched/deadline: Move a task's bandwidth only where room was made
Date: Thu, 19 Nov 2026 15:15:46 -0500
Message-Id: <d8af8e266437a8056a55c60a131eea23faa11b8d.1795116790.git.mathieu.desnoyers@efficios.com>
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

Commit 7f51412a415d ("sched/deadline: Fix bandwidth check/update when
migrating tasks between exclusive cpusets") moves a deadline task's
bandwidth in two halves. cpuset_can_attach() reserves it in the
destination root domain. set_cpus_allowed_dl() then frees it in the
source, when the task's affinity changes. Its comment relies on the
first half: "We already made space for us in the destination domain".

But set_cpus_allowed_dl() runs on every change of affinity. It frees the
bandwidth whenever the new mask leaves the task's root domain, with or
without a reservation. sched_setaffinity() gets there too, if the task's
cpuset spans two root domains. With isolcpus="domain", any cpuset that
is not a partition root can hold isolated CPUs and other CPUs, which are
in two root domains. With admission control on, __sched_setaffinity()
refuses such a mask. With sched_rt_runtime_us at -1, nothing refuses it.
The bandwidth is then freed in the source and added nowhere: no root
domain counts it any more. The destination would underflow when the task
leaves.

Fix this by flagging the affinity changes that come with a reservation,
as SCA_DL_BW_RESERVED. cpuset_attach_task() sets it, through the new
set_cpus_allowed_bw_reserved(). set_cpus_allowed_dl() moves the
bandwidth only with the flag. Without it, the bandwidth stays where it
is counted, until the next rebuild of the accounting counts it anew.
The flag also skips the early exit of __set_cpus_allowed_ptr_locked()
for a mask that does not change. The task may already have that mask
from a change that moved no bandwidth, such as a sched_setaffinity()
without admission control.

The attach still flags a task that sched_setattr() made a deadline task
after cpuset_can_attach(), with nothing reserved for it. "sched: Make
deadline policy and affinity changes wait for a cpuset attach" fixes
that.

No case of deadline_bw_test fails before this patch and passes with it.
no_admission_affinity_moves, added later in this series, covers this
path together with "sched/deadline: Move a task's bandwidth to the root
domain it runs in".

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  2 ++
 kernel/cgroup/cpuset.c  | 13 ++++++++++++-
 kernel/sched/core.c     | 26 +++++++++++++++++++++++++-
 kernel/sched/deadline.c | 14 +++++++++-----
 kernel/sched/sched.h    |  2 ++
 5 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4098b4e0f67e..e88616448b85 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1966,6 +1966,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
  * Return: zero if successful, or a negative error code
  */
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
+extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
+					const struct cpumask *new_mask);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7628cf77bdfd..194a438e25c3 100644
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
+	 * deadline tasks that cpuset_can_attach() counted. Flag the move, so
+	 * that the bandwidth of this task moves with it.
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
index 32fe889e02fb..bd5f3dfa50ac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3207,7 +3207,15 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 	}
 
 	if (!(ctx->flags & SCA_MIGRATE_ENABLE)) {
-		if (cpumask_equal(&p->cpus_mask, ctx->new_mask)) {
+		/*
+		 * A move with SCA_DL_BW_RESERVED must reach
+		 * set_cpus_allowed_dl(), even if the mask does not change.
+		 * @p may have this mask from a change that moved no
+		 * bandwidth, such as sched_setaffinity() without admission
+		 * control.
+		 */
+		if (cpumask_equal(&p->cpus_mask, ctx->new_mask) &&
+		    !(ctx->flags & SCA_DL_BW_RESERVED)) {
 			if (ctx->flags & SCA_USER)
 				swap(p->user_cpus_ptr, ctx->user_mask);
 			goto out;
@@ -3280,6 +3288,22 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
+/*
+ * Like set_cpus_allowed_ptr(), for a caller that has made room for the
+ * deadline bandwidth of @p in the root domain of @new_mask. Move that
+ * bandwidth there with @p. Return 0 on success, or a negative error
+ * code.
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
index 40d87cd31d33..56d1f6636edc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3612,12 +3612,16 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	WARN_ON_ONCE(!dl_task(p));
 
 	/*
-	 * Migrating a SCHED_DEADLINE task between exclusive
-	 * cpusets (different root_domains) entails a bandwidth
-	 * update. We already made space for us in the destination
-	 * domain (see cpuset_can_attach()).
+	 * Migrating a SCHED_DEADLINE task between exclusive cpusets
+	 * (different root_domains) entails a bandwidth update. Move the
+	 * bandwidth only if the caller made room for it in the destination,
+	 * as SCA_DL_BW_RESERVED says. Only cpuset_attach_task() sets it.
+	 * Otherwise, the bandwidth stays where it is counted, until the next
+	 * rebuild of the accounting. Moving it without room would leave no
+	 * root domain counting it.
 	 */
-	if (dl_task_needs_bw_move(p, ctx->new_mask)) {
+	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
+	    dl_task_needs_bw_move(p, ctx->new_mask)) {
 		unsigned int src_cpu = dl_task_root_domain_cpu(p);
 		struct dl_bw *src_dl_b = &cpu_rq(src_cpu)->rd->dl_bw;
 		unsigned int cpu;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 20ad13f388cb..61c73c7d3f27 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2973,6 +2973,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
 #define SCA_DL_CHECK		0x10
+/* The caller made room for the deadline bandwidth in the new root domain. */
+#define SCA_DL_BW_RESERVED	0x20
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
-- 
2.47.3

