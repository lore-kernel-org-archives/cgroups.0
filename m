Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164066;
	b=TjggZp83V1o3vCPkAbsUO9W1kha1NOYiLwkyJTEdxZ5mfv/rYxVeRqxXVOVjpKgKuLk4
	 bMSsugyEm9fbX+B6eHes6iO9XZRsK06iLimxVScGK4v+9z4+SDQyK8qiK8IU039hn0YrV
	 KdO3OOY62M9nJrgQk68kWyIvDO1ydMYZj+Mk7G/F8eGt/7oeRPplxznZV0Jnr0yu0RE5a
	 e7eZ8JYTp5XcLJtxstvtUMKBBuEaqpPiBMYspwTfLbtqADRH6MsAZOzwEe0lr1ikNC/mN
	 Q49aoz3wOfKkccFQFIJj6Dozchi1sut5LgRn2K5koBPt8IeSROTmDJWTTH1eZoD8sLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164066;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9NMsjwBQGcJC4IdPflBEJkyg89Y/aTOtZLr36/lx2ic=;
	b=YeFU9+GsvTuQaTFWMQp73HdZh4wC6X9GNTQ2Oy+4H5a4NVtpbiqnwjbRlsQZ61Vb5tVL
	 wC1ujSuuXe/b9XTZfP58LwOp65pVSDVjhZg3YTFwRkzql74TVgXJWHDppnSFPRGLAcwdh
	 x12W7yij+rEkwTrLdac/f2Zex6ZqcKg49QggRTbescLEu3rai2xg5gBtnPx8vDKEopCdl
	 6zZVfPS9+rqsQcMp+8qsykzlbJslA7t5MP2M/BDv0XzSr1MG6YHIz3CsYe7o5pBhpsy4j
	 0Fn2w78YyuRT3O1uYEueeTLT6gJGrZRAoOvuP/KaqfJ72Q+5dpSWcjFpgeXTnZTpgDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KzohEtQJ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6A46083610;
	Sun,  8 Nov 2026 18:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D6A46083610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KzohEtQJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164065;
	bh=9NMsjwBQGcJC4IdPflBEJkyg89Y/aTOtZLr36/lx2ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzohEtQJgYCWoglGcmfqVJ/Y19uIyaNjf7FGBceyo5dnmi7yUvZ7pD2KWZxaV2HJ9
	 BNVT5uA2BmQCPMMkou1H6UmLoo2BjaXwCX7XETGfFIl1IVHUM5CkvBQ4qmw5hdW1lR
	 BpgRc714AYvOb4vagNMgYO90CQPZg+NllGk4xfiwa8HMHIEF8Qk7GFEAGl8iwHvSAv
	 AjBcZ6kZzEtccQV04h5s3Q3zPxGhPCVscWqrxCQUtm8bdS2k2sKC6ZKTjvqSLB+Z+o
	 iJFyoBNIxm4WILn7C4k4j/NrX41e28LvOQ9w87CLsjd5OxiJO6ckJTm7BaHWS03VG5
	 +cDwppaE3nm0A==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C52thqzMvd;
	Sun, 08 Nov 2026 13:54:25 -0500 (EST)
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
Subject: [PATCH v5 22/29] sched/deadline: Make a rebuild use the CPU recorded with a task's bandwidth
Date: Sun,  8 Nov 2026 13:53:59 -0500
Message-Id: <20261108185406.1549770-23-mathieu.desnoyers@efficios.com>
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

Use the CPU the task is on, if it is active and in the task's mask. A
mask can hold CPUs of both root domains, for instance after
select_fallback_rq() widened it. Else use dl_bw_cpu, the CPU recorded
with the bandwidth, if it is active and in the mask. A task moved asleep
is not on its new CPUs yet. Else take the first active CPU of the mask,
a housekeeping one if any. A partition change sets the task masks before
its rebuild, and the housekeeping mask after, so the mask comes first.
With no active CPU in the mask, take dl_bw_cpu if active, else ask the
cpuset.

Leave out a task with no active CPU, instead of the BUG_ON(). dl_bw_gen
then keeps its release from removing anything.
dl_task_offline_migration() counts it again when it moves it.

A task that select_fallback_rq() moves to another root domain still runs
where its bandwidth is not counted. The next patch moves the bandwidth
with it.

The Sashiko AI reviews of v1 to v4 found these cases.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 83 +++++++++++++++++++++++++++++++++++------
 1 file changed, 72 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8d9e55bca943..bc31045e4686 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -910,14 +910,20 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
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
@@ -3720,6 +3726,55 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
+ *
+ * Else prefer the CPU recorded with the bandwidth, if it is active and in
+ * the mask. It is in the root domain that admitted the bandwidth, or that
+ * its last move put it in. A task moved asleep is still on a CPU of the
+ * root domain it left, out of its mask. Else take the first active CPU of
+ * the mask, a housekeeping one if there is one. A task on isolated CPUs
+ * that all went offline can have no active CPU at all.
+ */
+static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
+{
+	struct cpumask *msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	int recorded = p->dl.dl_bw_cpu;
+	unsigned int cpu;
+
+	/*
+	 * Look at the mask of the task first. A change of the cpusets sets
+	 * the mask of each task before its rebuild. The housekeeping mask
+	 * that dl_get_task_effective_cpus() reads is updated after it. If no
+	 * CPU of the mask is active, take the CPU recorded if it is active:
+	 * dl_task_offline_migration() moved the task there. Else ask the
+	 * cpuset.
+	 */
+	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
+	cpu = task_cpu(p);
+	if (cpumask_test_cpu(cpu, msk))
+		return cpu;
+	if (cpumask_empty(msk)) {
+		if (recorded >= 0 && cpu_active(recorded))
+			return recorded;
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
@@ -3727,7 +3782,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3742,10 +3796,17 @@ void dl_add_task_root_domain(struct task_struct *p)
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

