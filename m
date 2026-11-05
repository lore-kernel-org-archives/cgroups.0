Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=vuHebz5WV5PzoHDa9DmODCLFEfIJCrm7m15fu/6E8nnsNoLVhinp68XcNIpieAPM+JKS
	 Xz4uLryctPprhGOYGC0sL5piPnxpwYBRSL6HqPlm9s4gwkGgYsb8bLGabihJ0oXZrTUYZ
	 ossl/7uwrrJpmAv6mQNUYiFkDJOysMaUYGnbIiD2Tgj9NYj/bHgn94rQxzUSNKDszsE5Y
	 sP6Ex5qOP2+DD+64xUamYQTJABqpJTqJ2nn7TX1jCmUqS+A5Tet1ZhLqgxLUAcnzQ5l/W
	 vu5fjRpUNq7oPE593PakgFCs4G8q/XQW29U00g+F/mZaZedgNPW/Skd/wbkVSB+wp7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KeWVp44tQ8DyNXQ7uuJiQvoSDj7guT6jw16kawQ+gbE=;
	b=lCUzL15UCtai3FtxwI0upDZqU1SqSAE1zEzKgMBEPhDAc0IMDdrBQFv2GQBXlu9XIwJM
	 zsPrvvbOv/Qbygf1hVJSg2N0jTgvy0qWW6t16YWwaecFm0ppFY6m3Ok7si5rqoWSL2Dov
	 y+e1ddkp0dE8wsFHiNNAIOczIOAYj4Ddv4guds3lztU/tAQbFifawtpt+lDzzNNniX04S
	 Dbz4swnxkH59Yssjx6WfsrtbuDs3SWDLvnj+O30f7yIEKXmscBhPOqOViS9cdQm592D9i
	 8JqEJ0f+kUHblkkxZ7XKjFnsI/jMELu6oHOh6XBf+PPPivL+gmWW9MPNHLFEPIXi/zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v2lcwzBg;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEED36082BCE;
	Thu,  5 Nov 2026 19:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEED36082BCE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v2lcwzBg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907251;
	bh=KeWVp44tQ8DyNXQ7uuJiQvoSDj7guT6jw16kawQ+gbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2lcwzBgiFLjMmgOFDbAoeg2vsmq1m3vmWB7OZdn9fIfUCX6QWdz5+B2REhIzLGGa
	 ZmdvgYwrmk9GoKNo9SAYOzJBIuZkicyQl3++W6R3eCQMKchdSOF9ocwdrBV0WuCM71
	 95fJ4r7Ty3yqig1sUckDHdLl677+fCzBOGMtM8I8LvdOUEYWTUEcvLgQXdcioUY1Fy
	 LeJWR+v6DlTGW3ROCxby5R6RK3ZdUVMfopGzUP9Pvef1OVAecyTZEDqyzakI1fvHQL
	 fUoC/JHqlFsSQj12fbZ0Vl8HKFRWWuwFeQLYnvtly6EAN7h+N91uBXIexMelp7ciab
	 yt1sXAeqoMTQg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDM2W48zLYH;
	Thu, 05 Nov 2026 14:34:11 -0500 (EST)
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
Subject: [PATCH v3 15/24] sched/deadline: Move a task's bandwidth only where room was made
Date: Thu,  5 Nov 2026 14:33:50 -0500
Message-Id: <20261105193359.1450487-16-mathieu.desnoyers@efficios.com>
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
index 6a9b9791ddad..de1f6a39e60c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3493,12 +3493,17 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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
index 6c7c5633524a..25cb4228b203 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2953,6 +2953,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_MIGRATE_DISABLE	0x02
 #define SCA_MIGRATE_ENABLE	0x04
 #define SCA_USER		0x08
+/* The caller made room for @p's deadline bandwidth where the mask points. */
+#define SCA_DL_BW_RESERVED	0x20
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
-- 
2.47.3

