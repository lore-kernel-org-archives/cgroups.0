Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119387;
	b=Hh8ZFQzsJ8Nfl3sMX4mcX+0uyOLIAazNAdE2akHb35j4MC2g4PBNcfo3CXSzBo94+ybx
	 yY2PdzI/G4uGHVvUjE1zF8WCtsL4aOncWXyy/kgZw//rTJSNJcIo49fP2bpcYhn/SbLrm
	 Xd95MQ1bVCgEJp4PeH0BLuRYrAxsmUTYTtxHAgpbfE0MyKO6YSbVHw8j1YpUYEAbazhay
	 loPyvYBc/zDdcySAe721xDMtmnsUAT2nxTJ0caziy4AR73ZDQ37m/9HUPP2RJcfB+jAcJ
	 UxYLeAFxaL40owDdbdoc2jF67SqMxmE2jle9cFZuuMH7hF+7jeQ9kMh9fKKafe6ujHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119387;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IF6xLgpDR+cYBgBr0r24RfegPL+ADN1T/XB6++x54RU=;
	b=oUG6lPQUgSM6ZLOzhBe1O0xJv2nmXEYcXlvJ7RSfbBzgESV0mzx6hSwvgrBSRtPRUKfD
	 yeAzyJLoS7argmPZctVx9bYuoc5XbT+zVBnW4LdxSISnH7zugTz5ETzub2mUNF1RK8uzm
	 rlQyiGaPXR9+abhxigKPE/ZQ0y/Im+rhwTJHYsJJlqS64u9dmYBNr0HxhrWHIiQOrWrUL
	 Vxq/s5lpEvJC7hmMwgsD/28qS88vTcwr9FmOdRMw0KCRgfvFgSaijNyrmWddcIKoJVFLt
	 aYDy0MRzaI4cXdvG//l2GzG45bGNHg9E/PUsRmgtlDPB/UVtu86qYqlr2eosKe8qLJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="FJW17UD/";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50FC60A3819;
	Thu, 19 Nov 2026 20:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B50FC60A3819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FJW17UD/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119380;
	bh=IF6xLgpDR+cYBgBr0r24RfegPL+ADN1T/XB6++x54RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJW17UD/DeAYsALIej9TPRnr8cf/oxTshjgTZsAnRgT21YnTeSEE+c89WzLMGQnpe
	 gGnGnJ8730AIxqSYC7bT79BRc190gF03lLFtDFokMuPOlgoaCviCEQSZcz7POnclTa
	 c/Kq0iI0eRj76bUxTiN0LUYnnXp6CGIdY2F6177DixE4kuC0PTm31JITclzQw4uUho
	 ks0eZbmnofInUUcSrOgbGo7v0ykMftcJtNNPjrwUNUvhdpno2T4Q7UkFPeRSmo9Aq4
	 2VPqV8pOgFPjMHHyOUhMTSo+4kLuKiYvHwkkDLI/CtTJ7dGETgM5tUrn6Kewkl5E8b
	 RAMb3vt33pygg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVW6ZVFzS4p;
	Thu, 19 Nov 2026 15:16:19 -0500 (EST)
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
Subject: [PATCH v8 13/33] sched/deadline: Make a rebuild count a task in the root domain it runs in
Date: Thu, 19 Nov 2026 15:15:52 -0500
Message-Id: <1255358e4eac19eb768c5242ea920a9e57a30224.1795116791.git.mathieu.desnoyers@efficios.com>
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

A rebuild of the accounting counts each deadline task on the first
active CPU of its cpuset. Commit 318e18ed22e8 ("sched/deadline: Walk up
cpuset hierarchy to decide root domain when hot-unplug") made this
choice. It relies on the bandwidth check to keep such a CPU active.
This guess would go wrong in three ways:

 - A cpuset, like the root one, can hold CPUs isolated by
   isolcpus="domain" beside housekeeping CPUs. If an isolated CPU comes
   first, the task would be counted in the default root domain. Its own
   root domain would then be short of that bandwidth.
 - A task confined to isolated CPUs can see them all go offline. The
   rebuild would then find no active CPU, and hit its BUG_ON().
 - dl_task_offline_migration() moves a throttled task, with its
   bandwidth, off CPUs that went offline. The rebuild would count it in
   its cpuset, not where it moved.

In the first and third cases, a root domain would admit deadline tasks
beyond its capacity.

Fix this by choosing the CPU in this order:

 1. The CPU the task is on, if it is active and in the task's mask. A
    mask can hold CPUs of two root domains, for instance after
    select_fallback_rq() widened it. Also the CPU the task is queued on
    out of its mask, if it is active and recorded with the bandwidth.
    Without admission control, dl_task_offline_migration() can put a
    throttled task there. It runs there until it blocks.
 2. dl_bw_cpu, the CPU recorded with the bandwidth, if it is active and
    in the mask. A task moved asleep is not on its new CPUs yet.
 3. The first active CPU of the mask, a housekeeping one if any.
 4. With no active CPU in the mask: the task falls back to its cpuset.
    Count it there. Keep dl_bw_cpu if the cpuset holds it.

The mask of the task comes before its cpuset. A partition change sets
the task masks before its rebuild. dl_get_task_effective_cpus() reads
the CPUs isolated at boot, HK_TYPE_DOMAIN_BOOT. HK_TYPE_DOMAIN also
leaves out the CPUs of isolated partitions, and is updated after the
rebuild.

Leave out a task with no active CPU, instead of the BUG_ON(). dl_bw_gen
then keeps its release from removing anything.
dl_task_offline_migration() counts it again when it moves it.

A task that select_fallback_rq() moves to another root domain still runs
where its bandwidth is not counted. The next patch moves the bandwidth
with it.

The Sashiko AI reviews of this series found these cases. The case
rebuild_record_taken, added to deadline_bw_test later in this series,
tests the rule for a task with no active CPU in its mask.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Fixes: 318e18ed22e8 ("sched/deadline: Walk up cpuset hierarchy to decide root domain when hot-unplug")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 100 ++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 915c02bc6432..df55aba27ddc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -926,14 +926,20 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
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
@@ -3790,8 +3796,14 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
@@ -3810,6 +3822,62 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
@@ -3817,7 +3885,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3832,10 +3899,17 @@ void dl_add_task_root_domain(struct task_struct *p)
 		return;
 	}
 
-	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
-	dl_get_task_effective_cpus(p, msk);
-	cpu = cpumask_first_and(cpu_active_mask, msk);
-	BUG_ON(cpu >= nr_cpu_ids);
+	cpu = dl_task_rebuild_cpu(p);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * No active CPU can count the bandwidth of this task. Leave it
+		 * out of this rebuild. dl_bw_gen then keeps its release from
+		 * removing anything. A later rebuild, or
+		 * dl_task_offline_migration(), counts it again.
+		 */
+		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
+		return;
+	}
 
 	raw_spin_lock(&dl_departed_lock);
 	/*
-- 
2.47.3

