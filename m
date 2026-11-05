Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=pkOVP/QYebmcuJbvmACF3su8Wsy3DvVyyA+n2vndtC8SCb0kuWtSpOHpvV8V0XrvIaMT
	 FmjasoZMbjt2Vg3NqWe53a6uJBkswqIhrSUuq5DsFzcryRy139f1VblAqOzv0IMXbxgVH
	 WKDe8onSx5lcSD+urm7hNPsFZOLVrZFrXXrYjAu9yP6Pqxuzjn+n2zuEIwCpfeDK1P8KL
	 41umv/URmv55UOhB2bCx06sb7xY71o8sG2zG7Sbm4gdczU6wuM4BxqUTTGD8e6AUH/sVI
	 zU7Y/LdwpXgDheaIxQ9ZDWrpFXq3rGho9VkSzn5NsSA4XIxtn6MVN4ImJI3niq6/n0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NoC2zAIkoVjKX/vWrf9dz8engB12YIaGq6z5KLIjDe4=;
	b=vnLjvv+JV5DdbqnUnA/NNym7V7kEXrRgeQFUr5CV5RSADVes1SNWet6uVn9QbORTYOYm
	 mkPCTD80h8MSWBLDxBp4WgybE9LR/qXFEoijBSgKMRhXY+LwaiQk/jSuT8DV/ReAbEEsc
	 5O8JuKLUqPUaZhdtsToMAINv4U3it891sKn6Pk76tP5oVW9GIqwa+6SJt9s508gd2y9zj
	 9bzomZh18w6d7ECLZRkONEQbu2aXc3UZ6VaFFwsYACJF/zn8lz0/4bdY80DMI4EbzyI0P
	 LrDCjv6DOCx/Hb/Sg4XAN1iqa0I+TlEAO8y/Ms0XD7AODAulYZpJue+UIjL9xkwnlVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TYuaAV8m;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0F96082BE2;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F0F96082BE2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=TYuaAV8m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907251;
	bh=NoC2zAIkoVjKX/vWrf9dz8engB12YIaGq6z5KLIjDe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYuaAV8mcQJ26HWhwytJj/7UJdigAMGWiEsxVjVTXlPtqJd1aqzbVJAQ19oWhfcTE
	 K3ibgODmXYuWtk6TwtQBvxPss70Vg42xR7oV9H/6epsl+yaPRe0fIM4UjnflIab4cO
	 Uq9ltJERINboji8ZAiC2ORXBrWmP4/JEjZelKN5L5BAdb9pVDmr2hwep9te7aXzwho
	 pDOS5HmIlpHdsnYDkq7LMDx13F3ewb6YAC7qyQoAQWdlnL0qF1ylCJU5cx1ulrgpaQ
	 FOd19QnlzlnONKD8sTzCs4eeizZ1FzPUm+os5tXpCyk7YdnUgmA51r2wxBGSD2Bj0c
	 1Evs1PAcnBOEg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDM619MzLYJ;
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
Subject: [PATCH v3 18/24] sched/deadline: Credit a rebuild to the CPU recorded with the task's bandwidth
Date: Thu,  5 Nov 2026 14:33:53 -0500
Message-Id: <20261105193359.1450487-19-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting takes a CPU of the task's
cpuset for each deadline task it finds, dl_add_task_root_domain()
through dl_get_task_effective_cpus(), the first active one: a guess
that admission did not make, and three things go wrong with it.

 - The CPUs isolated by isolcpus="domain" belong to the default root
   domain, and the cpuset of a task that runs on a housekeeping CPU can
   hold them beside its housekeeping CPUs, as the root cpuset does;
   without cpusets the mask is every CPU the task may run on. The first
   active CPU of either is an isolated one where it comes first, and the
   task's bandwidth is counted in the default root domain instead of the
   one that admitted it, which underflows when the task leaves the
   class, or dies.
 - A task confined to isolated CPUs has them all taken offline, which
   nothing refuses: a deadline task of the default root domain does not
   keep the last of its CPUs online, dl_bw_deactivate() asking the root
   domain of the CPU going offline. The rebuild then finds no active CPU
   for it and BUG()s.
 - A throttled task whose CPUs went offline is moved by
   dl_task_offline_migration() to an active CPU, with its bandwidth,
   while its mask still names the offline ones: the rebuild counts it
   where the cpuset says, which is not where the move put it.

Take the CPU recorded with the task's bandwidth where it is active and
the task's cpuset still allows it: the rebuild then counts the bandwidth
where admission did, or where the last move put it, and the CPU that
dl_task_offline_migration() recorded answers for a task whose own CPUs
are offline. Where the record is of no use, its CPU offline or the
cpuset changed, take the first active CPU the cpuset allows, a
housekeeping one where it has any. The CPUs isolated at boot,
HK_TYPE_DOMAIN_BOOT, are the ones a cpuset can hold beside housekeeping
CPUs: those an isolated cpuset partition takes have a cpuset of their
own, and HK_TYPE_DOMAIN, which excludes them too, lags a change of
partitions by the rebuild that change makes,
cpuset_update_sd_hk_unlock() updating it after. Leave out a task with
no active CPU at all: the generation of "sched/deadline: Keep departing
bandwidth across a root domain rebuild" keeps the release of its
bandwidth out as well, so that nothing is taken from a root domain that
no longer counts it, and the next rebuild counts it again where it can.

Found by the Sashiko AI reviews of the first posting of this series,
the BUG() and the isolated CPU coming first, and of the second, the
housekeeping mask lagging a change of partitions and the task that
dl_task_offline_migration() moved.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 45 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a058e0c65eca..bcf7f88b204a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3607,6 +3607,36 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
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
+	dl_get_task_effective_cpus(p, msk);
+	cpumask_and(msk, msk, cpu_active_mask);
+	if (recorded >= 0 && cpu_active(recorded) &&
+	    (cpumask_test_cpu(recorded, msk) || cpumask_empty(msk)))
+		return recorded;
+	cpu = cpumask_first_and(msk, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+	if (cpu < nr_cpu_ids)
+		return cpu;
+	return cpumask_first(msk);
+}
+
 /* The caller should hold cpuset_mutex */
 void dl_add_task_root_domain(struct task_struct *p)
 {
@@ -3614,7 +3644,6 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct rq *rq;
 	struct dl_bw *dl_b;
 	unsigned int cpu;
-	struct cpumask *msk;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	/*
@@ -3626,10 +3655,16 @@ void dl_add_task_root_domain(struct task_struct *p)
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

