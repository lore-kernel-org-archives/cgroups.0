Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164065;
	b=QnHYkIl0C4cVump3MnvV3l1S9K5MBhiHmI+hwepafDtD6ld9ZQsZeiUW1Df+Y1OeNG0P
	 fPrp4THUN++Aj1gl8oqXdoRGUAPe2lxgSz57ySpEZ84pcVINOVxpFojVnQh338GB55maa
	 b1ol0VRnKzdyIxqIwHhAE/3iu8hYO7JdwoUw+dPQ/evNOczfszXgwFeFJYsSQy5Ym3czY
	 5lej5UfaQF224c45emtWXsL/kNIXH0UHjQawavXLXSCvIMf5+3DX8PG2We6oKauVXBf+/
	 KLEa9QPSIsP7VmXAZSWJjUAz/Jv/69Odz+VczCCwkDdZdDrfjjElyiosXR82Coy2TaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164065;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kT+YabbCj7H599GyIGzvLRt85QG4dIHsUt6mSz31Zhc=;
	b=p/cC/ZqR0jMU+xUR7XFLalM2Z4n1YsnGwlAHlp7/lV3gqNj2PSxZOkOX1y2/Rb/1FAtI
	 yZ/pLdSP1zrmBsEdZiZMBNXg+F3+suov5YZO0JBtwQSGW6CnHKw+XBnASDdB4SWihfXRW
	 BkWrKJsb3jlGb3CzIFNSJ/5UdBHEXEWkjVfYljyUAfK0d8Ed8fuFCJEbEUtW9tacIYRYk
	 hBlz72kEtEdYineid23OutH0h0ExKpKFC5E5Riya4lmry0Fm8YoVXRBuabELm5CtRZtGD
	 9NNN3qYAOUDUM9r7Ayo010I/10/J6P2LHYuVIap2rROZdEP7mjIaE59kbqG4bx9ymlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m49tq+TM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1CB606D816;
	Sun,  8 Nov 2026 18:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF1CB606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m49tq+TM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164064;
	bh=kT+YabbCj7H599GyIGzvLRt85QG4dIHsUt6mSz31Zhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m49tq+TMj/nYRs4s+AEK6Tm5G14ZEANSdE3DU7YUjwBHEB/aKGnHBJf0CbBoiqYT5
	 VQOEyJbUhY6H2Eryt/MmidwLRm1yWLyiIf8SwrJyy0LwfpQ/+eau4479jMqdn+R7pW
	 eBrVPDwwuC11o7ssi78gPE+tcivLetw513XuKRJlNQD/1G0VqXMMz5JV/w1xfIPfxY
	 YLPVFuqS3DFBVqkFX99r42LGuSJL4m0pBFEu48kGIL958Fuyj6hqo27Stm6PEnG622
	 Hzp9en6DnalCEhO3YVSDDB6ZrSWIZuEkLataUrcbJfQPuYPKaWJFHvUT1L1OnF3o/j
	 jdoZ+6dv/9v+A==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C35Z80zMtr;
	Sun, 08 Nov 2026 13:54:23 -0500 (EST)
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
Subject: [PATCH v5 18/29] sched/deadline: Move a task's bandwidth only where room was made
Date: Sun,  8 Nov 2026 13:53:55 -0500
Message-Id: <20261108185406.1549770-19-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

But set_cpus_allowed_dl() runs on every change of affinity. It frees
the bandwidth whenever the new mask leaves the task's root domain, with
or without a reservation. sched_setaffinity() gets there too, if the
task's cpuset spans two root domains. With admission control on,
__sched_setaffinity() refuses such a mask. With sched_rt_runtime_us
at -1, nothing refuses it. The bandwidth then moves with no room made,
and no root domain counts it any more. The destination would underflow
when the task leaves.

Fix this by flagging the affinity changes that come with a reservation,
as SCA_DL_BW_RESERVED. cpuset_attach_task() sets it, through the new
set_cpus_allowed_bw_reserved(). set_cpus_allowed_dl() moves the
bandwidth only with the flag. Without it, the bandwidth stays where it
is counted, until the next rebuild of the accounting counts it anew.

The attach still flags a task that became a deadline task after
cpuset_can_attach(), with nothing reserved for it. "cgroup/cpuset: Give
back the bandwidth an attach did not move" fixes that.

Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  2 ++
 kernel/cgroup/cpuset.c  | 13 ++++++++++++-
 kernel/sched/core.c     | 16 ++++++++++++++++
 kernel/sched/deadline.c | 14 +++++++++-----
 kernel/sched/sched.h    |  2 ++
 5 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 942d9acff203..5f14005d737e 100644
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
index bf722f5ff97e..030106b3d97f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3272,6 +3272,22 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
index 84102368822c..b365401e7148 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3564,12 +3564,16 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
index d0f5ed98ef48..d7b4cad28262 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2957,6 +2957,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+/* The caller made room for the deadline bandwidth in the new root domain. */
+#define SCA_DL_BW_RESERVED	0x20
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
-- 
2.47.3

