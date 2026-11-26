Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655342;
	b=orIB19pHf5T6l6G1L9PgXj7s4wgu5HHBf7t2ojJMNDRODKVF+uPvl4CjT3h0bM2WC33D
	 +xuwRMHV/KoBVGovjIc/pKMt6hJHHXU6kGusLqCAMY1tcJ3p1cQPlswkRvF7p2SxeFFJd
	 s0NWatd0TLeAxqt+zanLiJ67+vcc6ITCHuNSRo1a7XRVAw+1gxXDpnoQzEjD5dxUL5p3b
	 SNCY0/gxUchz6XkfAaa/S/3nKdgkksE2fR5NuynDynxa4pYjOngHkQ+9Nyt8wb6TKLjvz
	 2OpjZewxiL/V3aq3waroNd0PQEU3dn1pztDMP/269K2zHVE1d43yZaOiPVm6t3wO2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655342;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bZqIyEaBUSCt+Ubg6QOq4hJLK70hNqIDTtwLA420rXc=;
	b=kvJld1joJyBsmT5WTsOAWtRTc1WQyFjXWXg4UXOtBzbp1360QEUfDo1Schtr+8vDEoFE
	 Az8eOfXn4T5i/I6R+qLulqy/d08PjNnPSaviI0T5RwXjzuXg7x3gkf6h4v5ZYfhesc7oN
	 xmX3pSoBaKIUI9ciuBbUZSN+ArT21KTan5sSx5CphsbWkqPldlndXSy4PqSQPPPYxmZn4
	 J/lbbu2razA8ckZyQ1BLDeVDP0NVVKwKFT0tfuw1yKFqxlny58zDMUoF3G2xQGgkNN1jm
	 bKTc0vDWn1daZ4SFRkWx4D/yJnVExerFWu9QAN7VlL8XHYeZUFHYRgcK/6EG1fEvGWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pn7zMi8t;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723D60A260E;
	Thu, 26 Nov 2026 01:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4723D60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pn7zMi8t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655338;
	bh=bZqIyEaBUSCt+Ubg6QOq4hJLK70hNqIDTtwLA420rXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn7zMi8th7UXq5RM5lwohwn5EyQUHjMOroGZqVPku6FenzAsrHrMVQzj+qZ9/IJRi
	 HBS1VU5td1vHjNZqzoDhNUZ64SdC7OyUF0uXHdx5z2ehKSEM1ANVgRD/r4QAT6MfxY
	 GUipY29tFJkQ00PaejRvIyh2o/2/QdckbFQ47q5cqdT1sBmwAv+OTXOc+qOS4pBOsQ
	 c7K6+WceilMNkRpks5Kpmh19MbAF/DtZVZN8TRsoudZDkW1cs5KXDDR1joFVkAsCO8
	 Qx28w9CBl1zftGmjitzkQUwsiFcbxWKreu4N6GdgMotHOWcq84ubdBHSdxbV/f/+Sv
	 ZLHEwiE2NRsyA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjP3VBvzWqg;
	Wed, 25 Nov 2026 20:08:57 -0500 (EST)
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
Subject: [PATCH v11 13/43] sched/deadline: Make a rebuild count a task in the root domain it runs in
Date: Wed, 25 Nov 2026 20:08:12 -0500
Message-ID: <5371025ec9be552256914738f3d6cbf3ba1802cd.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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

A rebuild of the accounting counts each deadline task on the first
active CPU of its cpuset. Commit 318e18ed22e8 ("sched/deadline: Walk up
cpuset hierarchy to decide root domain when hot-unplug") made this
choice. It relies on the bandwidth check to keep such a CPU active.
This guess would go wrong in three ways:

 - A cpuset, like the root one, can hold CPUs isolated by
   isolcpus="domain" beside housekeeping CPUs. If an isolated CPU comes
   first, the task would be counted in the default root domain.
 - A task confined to isolated CPUs can see them all go offline. The
   rebuild would then find no active CPU, and hit its BUG_ON().
 - dl_task_offline_migration() moves a throttled task, with its
   bandwidth, off CPUs that went offline. The rebuild would count it in
   its cpuset, not where it moved.

In the first and third cases, a root domain would admit deadline tasks
beyond its capacity.

Fix this with dl_task_rebuild_cpu(). It counts the task where it runs
or will wake up. It takes the first active CPU in this list:

 1. The CPU the task is on, if it is in the task's mask. Also the CPU
    the task is queued on out of its mask, if the bandwidth is recorded
    there. Without admission control, dl_task_offline_migration() can
    put the task there (third case).
 2. dl_bw_cpu, the CPU recorded with the bandwidth, if it is in the
    mask. A task moved asleep is not on its new CPUs yet.
 3. A CPU of the mask, a housekeeping one first (first case).
 4. With no active CPU in the mask: steps 2 and 3 on the CPUs of the
    cpuset, from dl_get_task_effective_cpus(). A partition change sets
    the task masks before its rebuild, so the mask is up to date.

For the second case, leave out a task with no active CPU, instead of
the BUG_ON(). dl_bw_gen then keeps its release from removing anything.
dl_task_offline_migration() now counts the task when it moves it. A
departed task is not left out: it is still counted on the CPU recorded
with it, if that CPU is active.

Also make dl_get_task_effective_cpus() read the CPUs isolated at boot,
HK_TYPE_DOMAIN_BOOT. HK_TYPE_DOMAIN also leaves out the CPUs of
isolated partitions, and is updated after the rebuild. A CPU that just
left such a partition would still look isolated.

A task that select_fallback_rq() moves to another root domain still
runs where its bandwidth is not counted. The next patch moves the
bandwidth with it.

The Sashiko AI reviews of this series found these cases. The case
rebuild_record_taken, added to deadline_bw_test later in this series,
tests the rule for a task with no active CPU in its mask.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Fixes: 318e18ed22e8 ("sched/deadline: Walk up cpuset hierarchy to decide root domain when hot-unplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 107 ++++++++++++++++++++++++++++++++++------
 1 file changed, 91 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c047169ccdd8..510b0b243257 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -941,8 +941,8 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 	 * The bandwidth of @p is counted in the root domain of the CPU
 	 * recorded with it. That is not the root domain of @rq if @p was
 	 * moved to another cpuset while it was not running. If a rebuild
-	 * dropped the bandwidth, there is nothing to move: the next rebuild
-	 * counts it.
+	 * dropped the bandwidth, the source root domain has nothing to give
+	 * back.
 	 */
 	scoped_guard (raw_spinlock, &dl_departed_lock) {
 		if (p->dl.dl_bw_gen == dl_bw_gen) {
@@ -953,14 +953,20 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			__dl_sub(dl_b, p->dl.dl_bw,
 				 cpumask_weight(src_rq->rd->span));
 			raw_spin_unlock(&dl_b->lock);
-
-			dl_b = &later_rq->rd->dl_bw;
-			raw_spin_lock(&dl_b->lock);
-			__dl_add(dl_b, p->dl.dl_bw,
-				 cpumask_weight(later_rq->rd->span));
-			raw_spin_unlock(&dl_b->lock);
 		}
+		/*
+		 * Count the bandwidth in the root domain the task moves to.
+		 * Do it also when a rebuild left the task out, for want of an
+		 * active CPU. A rebuild that reaches the task after this finds
+		 * its dl_bw_gen current, and leaves it alone.
+		 */
+		dl_b = &later_rq->rd->dl_bw;
+		raw_spin_lock(&dl_b->lock);
+		__dl_add(dl_b, p->dl.dl_bw,
+			 cpumask_weight(later_rq->rd->span));
+		raw_spin_unlock(&dl_b->lock);
 		p->dl.dl_bw_cpu = later_rq->cpu;
+		p->dl.dl_bw_gen = dl_bw_gen;
 	}
 
 	set_task_cpu(p, later_rq->cpu);
@@ -3847,8 +3853,14 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 {
 	const struct cpumask *hk_msk;
 
-	hk_msk = housekeeping_cpumask(HK_TYPE_DOMAIN);
-	if (housekeeping_enabled(HK_TYPE_DOMAIN)) {
+	/*
+	 * Use the CPUs isolated at boot. HK_TYPE_DOMAIN also leaves out the
+	 * CPUs of isolated partitions, and is updated after the rebuild. A
+	 * CPU that just left such a partition is then in a new root domain,
+	 * but HK_TYPE_DOMAIN still says it is isolated.
+	 */
+	hk_msk = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
 		if (!cpumask_intersects(p->cpus_ptr, hk_msk)) {
 			/*
 			 * CPUs isolated by isolcpu="domain" always belong to
@@ -3867,6 +3879,62 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
+/*
+ * Return a CPU of the root domain where a rebuild of the accounting should
+ * count the bandwidth of @p, or nr_cpu_ids if there is none.
+ *
+ * Prefer the CPU @p is on, if it is active and in the mask of @p. The
+ * task runs, or wakes up, in the root domain of that CPU. A mask can hold
+ * CPUs of two root domains: housekeeping CPUs and CPUs isolated by
+ * isolcpus="domain". When every CPU of a mask goes offline,
+ * select_fallback_rq() can widen it to both. It moves no bandwidth.
+ * Prefer that CPU also if @p is queued there, out of its mask, and the
+ * CPU is the one recorded. Without admission control,
+ * dl_task_offline_migration() can put a throttled task and its bandwidth
+ * on any active CPU. The task runs there until it blocks.
+ *
+ * Else prefer the CPU recorded with the bandwidth, if it is active and in
+ * the mask. It is in the root domain that admitted the bandwidth, or that
+ * its last move put it in. A task moved asleep is still on a CPU of the
+ * root domain it left, out of its mask. Else take the first active CPU of
+ * the mask, a housekeeping one if there is one. If no CPU of the mask is
+ * active, use the CPUs of the cpuset instead of the mask. A task on
+ * isolated CPUs that all went offline can have no active CPU at all.
+ */
+static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
+{
+	struct cpumask *msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	/*
+	 * Read the record once. The last schedule of a dead task clears it
+	 * under its rq lock, and the caller holds only the pi_lock.
+	 */
+	int recorded = READ_ONCE(p->dl.dl_bw_cpu);
+	unsigned int cpu;
+
+	/*
+	 * Look at the mask of the task first. A change of the cpusets sets
+	 * the mask of each task before its rebuild. If no CPU of the mask
+	 * is active, ask the cpuset. The task wakes up on one of its CPUs.
+	 * Take the CPU recorded only if it is one of them: a partition root
+	 * can have taken it since it was recorded.
+	 */
+	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
+	cpu = task_cpu(p);
+	if (cpumask_test_cpu(cpu, msk) ||
+	    (cpu == recorded && cpu_active(cpu) && task_on_rq_queued(p)))
+		return cpu;
+	if (cpumask_empty(msk)) {
+		dl_get_task_effective_cpus(p, msk);
+		cpumask_and(msk, msk, cpu_active_mask);
+	}
+	if (recorded >= 0 && cpumask_test_cpu(recorded, msk))
+		return recorded;
+	cpu = cpumask_first_and(msk, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+	if (cpu < nr_cpu_ids)
+		return cpu;
+	return cpumask_first(msk);
+}
+
 /* From dl_rebuild_rd_accounting(), under the locks it asserts. */
 void dl_add_task_root_domain(struct task_struct *p)
 {
@@ -3874,7 +3942,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3889,12 +3956,20 @@ void dl_add_task_root_domain(struct task_struct *p)
 		return;
 	}
 
-	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
-	dl_get_task_effective_cpus(p, msk);
-	cpu = cpumask_first_and(cpu_active_mask, msk);
-	BUG_ON(cpu >= nr_cpu_ids);
-
+	cpu = dl_task_rebuild_cpu(p);
 	raw_spin_lock(&dl_departed_lock);
+	if (cpu >= nr_cpu_ids && list_empty(&p->dl.dl_departed_node)) {
+		/*
+		 * No active CPU can count the bandwidth of this task. Leave it
+		 * out of this rebuild. dl_bw_gen then keeps its release from
+		 * removing anything. A later rebuild, or
+		 * dl_task_offline_migration(), counts it again. Do not leave
+		 * out a departed task: the code below counts it on the CPU
+		 * recorded, if that CPU is active.
+		 */
+		goto unlock;
+	}
+
 	/*
 	 * Skip a task whose dl_bw_gen is current. Either
 	 * dl_clear_root_domains() put it back as a departed task, and
-- 
2.47.3

