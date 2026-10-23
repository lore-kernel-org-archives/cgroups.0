Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792762212;
	b=m9TP0V0TQO6Kxuv/DsTapunOf1kOgY2tkTpixAS7czYJJH2/UOTRsUfMjhkePBQ4wMHC
	 WqIc60viosweHZf0KIMSrRfQuMhWKoG6QQK7XqSGbpufHVtqNHMmiUcsA105zjFwQ3+Q0
	 fNDyg1A288jUzW+qVvhXqp5vf4auaJ2b80zkxTn6rcRHW9jwjmYMJjN+/CRPdEIAE4EZL
	 rlzzjKoP2AGjy/69os2jgkB7J5c8/OMq3/4PmpCTnySsljfnHgykw4PRdg+kozL7EeUpX
	 cmPPWva/4iPRuCHJKKANIS9VSllL1YyEoJ7Ndl7aEV+lWDhWHhduL+ZAWbL2iM4hviA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792762212;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=veYm9aMFfh+nnmbBGsPXQNi+N78Gor71e/y5UgObl1A=;
	b=47ujTxDeBFHVNkVjRm+FwvCBLZgnWkPaB7uG3myEtYslpXSC8rkCioZ3vDrkfj7mBdYk
	 N82zS9CP2DL3ZyV5wWkPueLLotkf868H5qTCNFyy7LL8XkjtYndXXu+N8PyXNesGUSUPb
	 Hz6fvecbSVNSz4Td5P9AXsL9FaZzSRlCbL7wfsGhRKXsXY39kCxAAmYbnedT7db/Ic0He
	 GAQkD/N55VCT/fiCKmrpu9dbUwh8emq3MikZd5M6aG0BLRj/jJAuffGKFfz24cbR5VsEC
	 /NV379y0BcbN4LYElf0Qygc1txRk/z7IucoBBcFi0yK54GIgN+yyDrTSHIK6YDzqdUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=cZzmdR8T;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812CD606A31D;
	Fri, 23 Oct 2026 13:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 812CD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=cZzmdR8T
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=veYm9aMFfh+nnmbBGsPXQNi+N78Gor71e/y5UgObl1A=; b=cZzmdR8TVdPivTnziWH1/gW1a6
	7mZBWMRBXLqd0qS6ksxlEbJ7KnI0z/addRm/p9AkTpdvIZQmUpfustzwzwjq4YL0uIwDxaT6r4Uwt
	q0LeuATdzyUy9hPAdVRfnt8y/350pPFhMdQF9M1yyMCQPsytmHmZ8qu2TokwZzNf61GmxyCWSxCtV
	n4Dl//7mykEBAkXBB/SqSZmiutqsla8bxmS/copgmagOMkC33sj7Z8loTnKz4kCBGruIyOCZufMEf
	YB73zCO4XmxDZKP9tvQHyV4Ee5uolKJwUqt8XeHb52qA2NDeHPnnrahe8InrK5Dx/MsJWBxf+8vy+
	unrtxtPw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xKFLK-00000009hV0-2And;
	Fri, 23 Oct 2026 13:29:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 85E45300720; Fri, 23 Oct 2026 15:29:56 +0200 (CEST)
Date: Fri, 23 Oct 2026 15:29:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Don <joshdon@google.com>
Cc: Kayra Cizmeci <kayracizmeci@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org, jakub@okonski.org, longman@redhat.com,
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <20261023132956.GD409038@noisy.programming.kicks-ass.net>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
 <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
 <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>
 <20261022114705.GW88198@noisy.programming.kicks-ass.net>
 <CABk29NviVUAK6B_deQ7qah8eABiCikbFpTwDEO2hdproGLdLwQ@mail.gmail.com>
 <20261022212150.GW2823843@noisy.programming.kicks-ass.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022212150.GW2823843@noisy.programming.kicks-ass.net>

On Thu, Oct 22, 2026 at 11:21:50PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 22, 2026 at 10:49:36AM -0700, Josh Don wrote:

> > Took me a bit to parse this double traversal. I think this is broken
> > for the clear side?
> > 
> > root
> >   |
> >  A ( 2 tasks)
> >  |
> >  B (3 tasks)
> > 
> > If we start out with A marked as idle, then we have
> > root: h_nr_idle = 5
> > A: h_nr_idle = 3
> > B: h_nr_idle = 0
> > 
> > When we clear, we'll first start with B and subtract 3...
> > root: h_nr_idle = 2
> > A: h_nr_idle = 0
> > B: h_nr_idle = 0
> > 
> > Then we go to A and try to subtract 5 leading to
> > root: h_nr_idle = -3
> > 
> 
> Argh. Yes, I seem to have gotten it wrong. I'll try again in the
> morning.

Bah, so I can't operate cgroup well enough to actually set up the above
scenario. I think I'm stuck in cgroup-v2 mode which disallows this. I
should probably ask one of the AI thingies to write me a script.

Anyway, I think the below *should* work. It seems to behave for the
simple cases I did test.

This also fixes that init thing you noted, and yes, we can use this as
an optimization for the find_matching_se() -- although I still think
those semantics are weird, but whatever. If that's what people really
want.

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0ab15f03cb94..731befb0f671 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8970,7 +8970,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
-		init_cfs_rq(&rq->cfs);
+		init_cfs_rq(&rq->cfs, NULL);
 		init_rt_rq(&rq->rt);
 		init_dl_rq(&rq->dl);
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..9914498df0e2 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1090,6 +1090,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_runnable", cfs_rq->h_nr_runnable);
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_queued", cfs_rq->h_nr_queued);
 	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_idle", cfs_rq->h_nr_idle);
+	SEQ_printf(m, "  .%-30s: %d\n", "idle", cfs_rq->idle);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 	SEQ_printf(m, "  .%-30s: %lu\n", "load_avg",
 			cfs_rq->avg.load_avg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b5546cd27dba..2fcb01a514c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -15581,8 +15581,10 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, enum snt_e
 		hrtick_start_fair(rq, p);
 }
 
-void init_cfs_rq(struct cfs_rq *cfs_rq)
+void init_cfs_rq(struct cfs_rq *cfs_rq, struct cfs_rq *parent)
 {
+	if (parent)
+		cfs_rq->idle = parent->idle;
 	cfs_rq->tasks_timeline = RB_ROOT_CACHED;
 	cfs_rq->zero_vruntime = (u64)(-(1LL << 20));
 	raw_spin_lock_init(&cfs_rq->removed.lock);
@@ -15633,7 +15635,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 			goto err;
 
 		se = tg_se(tg, i);
-		init_cfs_rq(cfs_rq);
+		init_cfs_rq(cfs_rq, tg_cfs_rq(parent, i));
 		init_tg_cfs_entry(tg, cfs_rq, se, i, tg_se(parent, i));
 		init_entity_runnable_average(se);
 	}
@@ -15767,6 +15769,37 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	return ret;
 }
 
+struct tg_set_idle_struct {
+	struct task_group *tg;
+	long idle;
+	int cpu;
+};
+
+static int tg_set_idle_up(struct task_group *tg, void *data)
+{
+	struct tg_set_idle_struct *tsi = data;
+	struct cfs_rq *grp_cfs_rq = tg_cfs_rq(tg, tsi->cpu);
+	struct sched_entity *se = tg_se(tg, tsi->cpu);
+	int old_idle = grp_cfs_rq->idle;
+	long task_delta;
+
+	grp_cfs_rq->idle += tsi->idle;
+
+	if (tg == tsi->tg)
+		return 0;
+
+	if (!!old_idle == !!grp_cfs_rq->idle)
+		return 0;
+
+	task_delta = grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
+	if (!task_delta)
+		return 0;
+
+	task_delta *= tsi->idle;
+	cfs_rq_of(se)->h_nr_idle += task_delta;
+	return 0;
+}
+
 int sched_group_set_idle(struct task_group *tg, long idle)
 {
 	int i;
@@ -15777,33 +15810,37 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 	if (idle < 0 || idle > 1)
 		return -EINVAL;
 
-	mutex_lock(&shares_mutex);
-
-	if (tg->idle == idle) {
-		mutex_unlock(&shares_mutex);
+	guard(mutex)(&shares_mutex);
+	if (tg->idle == idle)
 		return 0;
-	}
 
 	tg->idle = idle;
 
 	for_each_possible_cpu(i) {
-		struct rq *rq = cpu_rq(i);
-		struct sched_entity *se = tg_se(tg, i);
 		struct cfs_rq *grp_cfs_rq = tg_cfs_rq(tg, i);
-		bool was_idle = cfs_rq_is_idle(grp_cfs_rq);
-		long idle_task_delta;
-		struct rq_flags rf;
+		struct sched_entity *se = tg_se(tg, i);
+		int old_idle = grp_cfs_rq->idle;
+		unsigned long task_delta;
 
-		rq_lock_irqsave(rq, &rf);
+		struct rq *rq = cpu_rq(i);
 
-		grp_cfs_rq->idle = idle;
-		if (WARN_ON_ONCE(was_idle == cfs_rq_is_idle(grp_cfs_rq)))
-			goto next_cpu;
+		guard(rq_lock_irqsave)(rq);
 
-		idle_task_delta = grp_cfs_rq->h_nr_queued -
-				  grp_cfs_rq->h_nr_idle;
-		if (!cfs_rq_is_idle(grp_cfs_rq))
-			idle_task_delta *= -1;
+		struct tg_set_idle_struct tsi = {
+			.tg = tg,
+			.idle = idle ? 1 : -1,
+			.cpu = i,
+		};
+		walk_tg_tree_from(tg, tg_nop, tg_set_idle_up, &tsi);
+
+		if (!!old_idle == !!grp_cfs_rq->idle)
+			continue;
+
+		task_delta = grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
+		if (!task_delta)
+			continue;
+
+		task_delta *= tsi.idle;
 
 		for_each_sched_entity(se) {
 			struct cfs_rq *cfs_rq = cfs_rq_of(se);
@@ -15811,15 +15848,11 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 			if (!se->on_rq)
 				break;
 
-			cfs_rq->h_nr_idle += idle_task_delta;
+			cfs_rq->h_nr_idle += task_delta;
 
-			/* Already accounted at parent level and above. */
 			if (cfs_rq_is_idle(cfs_rq))
 				break;
 		}
-
-next_cpu:
-		rq_unlock_irqrestore(rq, &rf);
 	}
 
 	/* Idle groups have minimum weight. */
@@ -15828,7 +15861,6 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 	else
 		__sched_group_set_shares(tg, NICE_0_LOAD);
 
-	mutex_unlock(&shares_mutex);
 	return 0;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 499a5649582e..ae4eca092586 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -751,7 +751,7 @@ struct cfs_rq {
 	struct list_head	leaf_cfs_rq_list;
 	struct task_group	*tg;	/* Group that "owns" this runqueue */
 
-	/* Locally cached copy of our task_group's idle value */
+	/* Sum of all ancestor tg->idle. */
 	int			idle;
 
 # ifdef CONFIG_CFS_BANDWIDTH
@@ -3499,7 +3499,7 @@ print_numa_stats(struct seq_file *m, int node, unsigned long tsf,
 		 unsigned long tpf, unsigned long gsf, unsigned long gpf);
 #endif /* CONFIG_NUMA_BALANCING */
 
-extern void init_cfs_rq(struct cfs_rq *cfs_rq);
+extern void init_cfs_rq(struct cfs_rq *cfs_rq, struct cfs_rq *parent);
 extern void init_rt_rq(struct rt_rq *rt_rq);
 extern void init_dl_rq(struct dl_rq *dl_rq);
 
