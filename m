Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015908;
	b=4Ix1KdlAPRivLl8VCvGYZa2LHNTem9avhLBM3kkUeVZqsiMdKq8YrXmNAC5p+PwTEQJx
	 k5+/KY8QWovR5ttt9Fj70srezXGsLgoR47wj+APEVnn+EMfwIJ7MhWpUCnm8gCPFx0WZA
	 PTW8Glc1qpvroh/gnewme1AWnZZffSE3LFfN6Ea1cSg+rhXuEj5E02JZqyHGAgJZoz3DC
	 PDZJyAuUe7H/5x2V8feTEOPC7lu1kyQ4GK8JzgGxzvH6VqEZhI6WwyNMoZKlCaomAd5/X
	 mgiU0cUXbj0WjwkVUaG9y6NUMCRcfnj3Lk1aNkPqmz+6Uk//C/ktkw5xcaeU9i2yIeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015908;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aU6jN2r+8yRSTgHrrUWHXBCfiAztbUEfpMJtmTd0QqM=;
	b=NEgrjgRZnqLSk4B4dl5e/A2E6LX+yHRJgvn7N58TcDZ34Ir5kttfof8N5/9nwb+sb0ON
	 1ythKmVOnKg2MeqElpbPNKJe0z7eVglX0j9wz9gnCTPo65qRS2YKWJItRz8s7XXlfuEYh
	 GMusJcbsI+XBPKao8OTK0fbHMWTa/75QfzAISpkii49Nhoum5VyJ2UhKuxSmLYq40jZP9
	 4Qz2pnSmluAcg1kRsfm3OgUosHWiBflvXkcN/EMItQ0GVj95ZP78TdxZ8jwKDJ3Wh12Sw
	 qkeGlzT8AWPbUxVersz2INOkJ+VlGf/A+TgOKcxXG/cV7jhkK+YnklVXyFCMvRDYIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xXOUpSpP;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A326082BD2;
	Sat,  7 Nov 2026 01:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73A326082BD2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xXOUpSpP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015906;
	bh=aU6jN2r+8yRSTgHrrUWHXBCfiAztbUEfpMJtmTd0QqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXOUpSpPqITNh0ni9NbOK/M6m2xLxwXP6paxbD7YdLR+G76Z+26b3LoRTm8+mxaGh
	 +3HPeKcmsGBt/ERrcRfDsJeTWi043GLwEbzd2afCtwTs7YVt98QlHS6RwRCqyIraUZ
	 4teRe7puXz/IfSr6S7ZkcNDgDA044HJZO//CSetMdY9aFn40lT73o5Jb5c/lHG/Dot
	 cG6E7xBejWfSDZP3c7nPhdTiF0KAlSDr1E9WhyfTWsCie6XApMAw0Sa5IofNEj2UAC
	 hlGCs8utUr3IUd1nQxBUPVA1XQLY2sF3PC/aVVmqKU5XwvTeaN1Hsl698DfabBF/AK
	 7CRjRr2SWR1fA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPt33TXzLxQ;
	Fri, 06 Nov 2026 20:45:06 -0500 (EST)
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
Subject: [PATCH v4 20/26] sched/deadline: Credit a rebuild to the CPU recorded with the task's bandwidth
Date: Fri,  6 Nov 2026 20:44:45 -0500
Message-Id: <20261107014451.1487825-21-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting counts each deadline task in
the root domain of the first active CPU of its cpuset,
dl_add_task_root_domain() through dl_get_task_effective_cpus(): a guess
that admission did not make, wrong three ways:

 - the cpuset of a task on a housekeeping CPU can hold CPUs isolated by
   isolcpus="domain" beside it, as the root cpuset does, and without
   cpusets the mask is every CPU the task may run on: an isolated CPU
   coming first has the task counted in the default root domain, which
   underflows when the task leaves the class, or dies;
 - a task confined to isolated CPUs that all go offline, which nothing
   refuses, has no active CPU left, and the rebuild BUG()s;
 - a throttled task whose CPUs went offline is moved, with its
   bandwidth, to an active CPU by dl_task_offline_migration(), and the
   rebuild counts it again where its cpuset says.

Take the CPU recorded with the task's bandwidth where it is active and
the task's mask allows it: the rebuild counts the bandwidth where
admission, or the last move, put it. Otherwise take the first active CPU
of the task's own mask, a housekeeping one where it has any: a change of
partitions sets the masks of its tasks before its rebuild, while the
housekeeping mask that dl_get_task_effective_cpus() reads lags it. The
cpuset answers for a task with no active CPU of its own, as before, and
a task with no active CPU at all is left out: the generation of
"sched/deadline: Keep departing bandwidth across a root domain rebuild"
keeps its release out as well, and dl_task_offline_migration() counts it
where it moves it.

Found by the Sashiko AI reviews of the first three postings of this
series.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 74 +++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f169cf35e313..ed951246e3d2 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -878,14 +878,20 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
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
+		 * Counted from here in the root domain the task moves to,
+		 * also where a rebuild left it out for want of an active
+		 * CPU: a walk that reaches it after this finds the
+		 * generation current and leaves it alone.
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
@@ -3656,6 +3662,47 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	cpuset_cpus_allowed_locked(p, cpus);
 }
 
+/*
+ * A CPU of the root domain that a rebuild of the accounting counts @p's
+ * bandwidth in. The one recorded with it, where it is active and the
+ * cpuset of @p allows it: that of the root domain that admitted the
+ * bandwidth, or that the last move put it in, which the cpuset alone does
+ * not tell where it holds CPUs of two root domains, housekeeping ones
+ * beside the ones isolcpus="domain" leaves to the default root domain. The
+ * record answers as well for a task whose own CPUs went offline, moved to
+ * an active one by dl_task_offline_migration(). Else the first active CPU
+ * the cpuset allows, a housekeeping one where it has any; and nr_cpu_ids
+ * where it allows none, which the isolated CPUs allow, no deadline task
+ * of theirs keeping the last of them online.
+ */
+static unsigned int dl_task_rebuild_cpu(struct task_struct *p)
+{
+	struct cpumask *msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+	int recorded = p->dl.dl_bw_cpu;
+	unsigned int cpu;
+
+	/*
+	 * The task's own CPUs first: a change of cpusets sets the mask of
+	 * each task before the rebuild it makes, where the housekeeping mask
+	 * that dl_get_task_effective_cpus() reads lags that change. With
+	 * none of them active, the CPU recorded is where
+	 * dl_task_offline_migration() moved the task; else its cpuset says.
+	 */
+	cpumask_and(msk, &p->cpus_mask, cpu_active_mask);
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
@@ -3663,7 +3710,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3677,10 +3723,16 @@ void dl_add_task_root_domain(struct task_struct *p)
 		return;
 	}
 
-	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
-	dl_get_task_effective_cpus(p, msk);
-	cpu = cpumask_first_and(cpu_active_mask, msk);
-	BUG_ON(cpu >= nr_cpu_ids);
+	cpu = dl_task_rebuild_cpu(p);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * No active CPU to count this task's bandwidth: leave it out
+		 * of this rebuild, where dl_bw_gen keeps its release out as
+		 * well, until one has a CPU for it.
+		 */
+		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
+		return;
+	}
 
 	raw_spin_lock(&dl_departed_lock);
 	/*
-- 
2.47.3

