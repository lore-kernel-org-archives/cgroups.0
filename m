Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855972;
	b=Z7r44NPTlpDHEpZyp1/uLOFeYFCw/J3mXPx3FGVypMLJZBJePg9+fNvqcaZzBNFZO1EN
	 3InS6dA2z1gs2Oxod9vUo+1zczqxtdArEzCxYwAKZYSODYh+JZ2ogrNJy7i+W8RqNNITW
	 wGqk/ktQucKMGizRzK9PfwkwK3q8aQBBWbzzzVr3NKwgWrhST1bIznVMq+EVQLcQEiqMD
	 5ghYqPV5bi2KYfQ/C06wZbFikKi26l8RDOw99awLx/GSQUhBj8t2Ul1J0yHk332IsDVhp
	 ebKMx9JMvilg9znFjhur6txM924vKOjxgAoiu73CuUamdt6psf7mfU1Yl9EwwkSB9qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855972;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kw44htmBdWBUE+0dTkGuLk0zZygT9kU7rocysry7L4c=;
	b=gf0TgmRJ2iMrGKg4mUiABpLC6n9N595/5wQpOG8YB8mh+4rtvqlBuW66qS8Yzz6f8snb
	 rGeRXP5/xAe8wEv6kbXMyWLYK7A2CiCR5DlNAWvIs52V1M6Js8Qsbq+UqlpJWn9/45n4a
	 PlYCVRp1PVskvTVXuu+Rpm4eA4feUvj+yw3D7WBSf/sJel5tEu2V1xUxeseC5OMd7q1ES
	 /aA6FuNH0d4qQ/6han63xKpOP3EYubbPGXsmJsRLmaqg9fQ8nvBtrA41egD1COrqJh8hW
	 BX8BUEW3RcaHTFHGw6eF6tcXrxf1/fmK1DeFt5J9x40k25pmV187iLLsGrzNZEgxjNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U20xZCsD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AAB60A262E;
	Mon, 16 Nov 2026 19:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70AAB60A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U20xZCsD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855958;
	bh=Kw44htmBdWBUE+0dTkGuLk0zZygT9kU7rocysry7L4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U20xZCsD5SbyEkxgsA3aaGVM2pbGtQ+MAb62x6xW+hPjSU9uuy6rLaJdnYvn3W6ac
	 1heiR2jAiwp0i9BFjv+4U85m1PWHOaMXhyfh3g6p/iT/3JvZW4LlpK36/JvkWNbxXQ
	 5fH79rNJvP51zQMtAYSAqRftsOrpk7iep+4DMCr27s4lx6vixwPWVg9r6XO05QBJf4
	 Sbsfu1JVqiZnB+nY/UJ9ZdvJCcaBreEExLEVADJ1O0RytOcYGkswUgre/BR46HPTQG
	 HQ1DqH0nptFlJv5dSmlu84cBaY9Gf7MeBiHTNQgLOcLdhBlqRoDyfN/QSpTx0mVRha
	 ShgcPSwSTaBZw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4k3dVgzR14;
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
Subject: [PATCH v6 26/37] sched/deadline: Keep a task in the root domain that counts its bandwidth
Date: Mon, 16 Nov 2026 14:05:38 -0500
Message-Id: <20261116190549.230119-27-mathieu.desnoyers@efficios.com>
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

The root domain that admits a deadline task counts its bandwidth. The
mask of the task can hold CPUs of another root domain. With
isolcpus="domain", the isolated CPUs are in the default root domain. A
cpuset that is not a partition root can hold isolated and housekeeping
CPUs.

The code that picks a CPU for a task does not look at the root domain
that counts it:

 - select_fallback_rq() and dl_task_offline_migration() pick a CPU when
   the CPU of the task goes offline.
 - __set_cpus_allowed_ptr_locked() picks one when the mask changes.
 - select_task_rq_dl() can leave a task on the CPU it slept on, which
   can be in the other root domain.
 - dl_task_rebuild_cpu() picks the CPU that a rebuild counts a task
   with. It prefers the CPU the task is on, then a housekeeping CPU.

Each can take the task, or its bandwidth, to the other root domain
while its own root domain still has a CPU for it. The bandwidth then
moves with no admission test, and the root domain it arrives in can
exceed its limit.

Add dl_task_bw_span(), which returns the CPUs of the root domain that
counts a task. Make each of these places try one of those CPUs first.
After a rebuild the root domains are new, and the CPU recorded with the
bandwidth can be offline. So dl_task_rebuild_cpu() cannot use the root
domain. It looks at the kind of the CPU recorded, housekeeping or
isolated. It prefers a CPU of the mask of the same kind.

A task with no CPU left in its root domain still moves, and its
bandwidth with it. The next two patches refuse the changes that lead
to that.

The case hotplug_keeps_root_domain of deadline_bw_test, added later in
this series, tests this. A cpuset holds two isolated CPUs and two
housekeeping CPUs, H and K. A deadline task counted in the housekeeping
root domain sleeps on H. Then H goes offline. The task must wake up on
K. Without this patch it woke up on an isolated CPU: CPU 0, in a guest
with isolcpus=domain,0,1.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c     | 38 +++++++++++++++++++++++
 kernel/sched/deadline.c | 69 +++++++++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h    |  1 +
 3 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e9f80407f75b..dc270a23179d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3264,6 +3264,23 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 			dest_cpu = ctx->dl_bw_cpu;
 		if (!task_on_rq_queued(p))
 			p->wake_cpu = dest_cpu;
+	} else {
+		const struct cpumask *span = dl_task_bw_span(p);
+		unsigned int cpu = nr_cpu_ids;
+
+		/*
+		 * No room was made for @p in another root domain. Keep @p
+		 * in the root domain that counts its bandwidth, if the new
+		 * mask holds one of its CPUs.
+		 */
+		if (span && !cpumask_test_cpu(dest_cpu, span))
+			cpu = cpumask_first_and_and(cpu_valid_mask,
+						    ctx->new_mask, span);
+		if (cpu < nr_cpu_ids) {
+			dest_cpu = cpu;
+			if (!task_on_rq_queued(p))
+				p->wake_cpu = dest_cpu;
+		}
 	}
 
 	do_set_cpus_allowed(p, ctx);
@@ -3668,8 +3685,21 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int nid = cpu_to_node(cpu);
 	const struct cpumask *nodemask = NULL;
 	enum { cpuset, possible, fail } state = cpuset;
+	const struct cpumask *span;
 	int dest_cpu;
 
+	/*
+	 * Keep a deadline task in the root domain that counts its
+	 * bandwidth, if one of its CPUs is allowed and online.
+	 */
+	span = dl_task_bw_span(p);
+	if (span) {
+		for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+			if (is_cpu_allowed(p, dest_cpu))
+				return dest_cpu;
+		}
+	}
+
 	/*
 	 * If the node that the CPU is on has been offlined, cpu_to_node()
 	 * will return -1. There is no CPU on the node, and we should
@@ -3686,6 +3716,14 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	}
 
 	for (;;) {
+		/* The mask is wider now: look again in that root domain. */
+		if (span && state != cpuset) {
+			for_each_cpu_and(dest_cpu, span, p->cpus_ptr) {
+				if (is_cpu_allowed(p, dest_cpu))
+					goto out;
+			}
+		}
+
 		/* Any allowed, online CPU? */
 		for_each_cpu(dest_cpu, p->cpus_ptr) {
 			if (!is_cpu_allowed(p, dest_cpu))
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 35f40185953a..5294546786f1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -864,13 +864,19 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 
 	later_rq = find_lock_later_rq(p, rq);
 	if (!later_rq) {
+		const struct cpumask *span = dl_task_bw_span(p);
 		int cpu;
 
 		/*
 		 * If we cannot preempt any rq, fall back to pick any
-		 * online CPU:
+		 * online CPU. Try the root domain that counts @p first.
 		 */
-		cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
+		cpu = nr_cpu_ids;
+		if (span)
+			cpu = cpumask_first_and_and(cpu_active_mask,
+						    p->cpus_ptr, span);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_any_and(cpu_active_mask, p->cpus_ptr);
 		if (cpu >= nr_cpu_ids) {
 			/*
 			 * Failed to find any suitable CPU.
@@ -2865,6 +2871,7 @@ static int
 select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 {
 	struct task_struct *curr, *donor;
+	const struct cpumask *span;
 	bool select_rq;
 	struct rq *rq;
 
@@ -2905,6 +2912,20 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 		    dl_task_is_earliest_deadline(p, cpu_rq(target)))
 			cpu = target;
 	}
+
+	/*
+	 * Keep @p in the root domain that counts its bandwidth. Its mask
+	 * can hold CPUs of another root domain, with isolcpus="domain",
+	 * and @p can sleep on one of them.
+	 */
+	span = dl_task_bw_span(p);
+	if (span && !cpumask_test_cpu(cpu, span)) {
+		unsigned int in_span;
+
+		in_span = cpumask_first_and_and(span, p->cpus_ptr, cpu_active_mask);
+		if (in_span < nr_cpu_ids)
+			cpu = in_span;
+	}
 	rcu_read_unlock();
 
 	return cpu;
@@ -3669,6 +3690,29 @@ static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
 	return cpu;
 }
 
+/*
+ * Return the CPUs of the root domain that counts the bandwidth of @p, or
+ * NULL if none does. The mask of @p can hold CPUs of another root domain,
+ * with isolcpus="domain". Where a CPU is picked for @p, a CPU of this
+ * root domain comes first: no other root domain admitted @p.
+ *
+ * The caller holds the pi_lock or the rq lock of @p. With interrupts
+ * off, the root domain is not freed.
+ */
+const struct cpumask *dl_task_bw_span(struct task_struct *p)
+{
+	int cpu;
+
+	if (!task_has_dl_policy(p) || dl_entity_is_special(&p->dl) ||
+	    !p->dl.dl_bw)
+		return NULL;
+	cpu = READ_ONCE(p->dl.dl_bw_cpu);
+	if (cpu < 0 || !cpu_active(cpu) ||
+	    READ_ONCE(p->dl.dl_bw_gen) != READ_ONCE(dl_bw_gen))
+		return NULL;
+	return cpu_rq(cpu)->rd->span;
+}
+
 static void set_cpus_allowed_dl(struct task_struct *p,
 				struct affinity_context *ctx)
 {
@@ -3903,6 +3947,27 @@ static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
 	 */
 	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
 	cpu = task_cpu(p);
+	/*
+	 * Keep the bandwidth where it was counted: with the housekeeping
+	 * CPUs, or with the CPUs that isolcpus="domain" isolates. The root
+	 * domains are new, and the CPU recorded can be offline. So prefer a
+	 * CPU of the mask of the same kind as the CPU recorded: housekeeping
+	 * or not.
+	 */
+	if (recorded >= 0) {
+		const struct cpumask *hk = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+		bool rec_hk = cpumask_test_cpu(recorded, hk);
+		unsigned int same;
+
+		if (cpumask_test_cpu(cpu, msk) && cpumask_test_cpu(cpu, hk) == rec_hk)
+			return cpu;
+		if (cpumask_test_cpu(recorded, msk))
+			return recorded;
+		for_each_cpu(same, msk) {
+			if (cpumask_test_cpu(same, hk) == rec_hk)
+				return same;
+		}
+	}
 	if (cpumask_test_cpu(cpu, msk))
 		return cpu;
 	if (cpumask_empty(msk)) {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3cc287785b91..f80ea5541b3f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -371,6 +371,7 @@ extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
+extern const struct cpumask *dl_task_bw_span(struct task_struct *p);
 extern s64 dl_scaled_delta_exec(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec);
 /*
  * SCHED_DEADLINE supports servers (nested scheduling) with the following
-- 
2.47.3

