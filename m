Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792669643;
	b=vAo3Gl4VvNAvXffvartS8fpxF9V3VUy6HHC60UtLEXl4+WwVf8ZAcLEBE6BD2c4+0+A+
	 BUz+PxgA9KSs9OvKx2XvkubZUunj8kC6f623Q+Pnv9T7lKgk2DkwI3WtYC54Dwy2oIadG
	 09MNYJswSDQfyrnjya2KTk3WJ8mcXw5jBuIKZlnpzi2ZFxcwe3fGZCrnk5EDhKQkTi16p
	 rm/T9xr2embKXgPwCN78d2kKM32q6a/0gzA9fXP0r4tzkA5zBafuptYNU0zkxpl6Ao0pl
	 WkCTwXfrZqEim2metNGo7hwD6hQWsE+PykG9Wu6vqZ1/SlaEJxfGw4cx+HSqHn7ghqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669643;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=X0q0asLQ1P+foLiFIFQVaoruoMf89GJKPIhMNti/xXw=;
	b=h3Z5ODVzoDD1S7WTQSlLlF2+P4HULKlEAZx2UpEm25cOH3jJiMlzxVdGRQVVQr1PZuGc
	 OCe9XxSPaAYU6vfkQNGGj8SeNgdTup2HqXAhA6tzwgBL0YppjgsQj6vjwf//wjcVfrKhH
	 /mF7ZhxjSaFY341ljXVuKoJJG8DgU5dYafxWwkiprh5ioJ+jwWUAJI6oonwIIo7/YS4wx
	 EHEQPBSBDJqt0V1sWe5m1hCGTRlQ7vW7uLbZUgwq/KfJKyZe92i1lc3UTa7AvnwEWxXbD
	 uBKQsvcWmDJtVM8G4xblUHeB21yANTryH0YpZt+GWZgkGfkND+AduCl8uMxyG2uwiEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=RQD6kKT0;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A522606A322;
	Thu, 22 Oct 2026 11:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A522606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=RQD6kKT0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=X0q0asLQ1P+foLiFIFQVaoruoMf89GJKPIhMNti/xXw=; b=RQD6kKT04QH+OtEFpovh875dK+
	RTOlJO9JMw146d4rPIVBjE2zVBfHFzOjszqHDGldkEHu4wdGKpEaGcp/CWBEiJf6KxX4dF5rtuw+T
	Kme8u4gFlSvyzXjo+DbE2b3xFOF+qTp3L9UPw3Ns62JrnSTDAKWdzdQtRS1fFQCLGI9exfQYO8Moe
	6AipHPxZKFK9YQLlk2RMKI7npLViPhP+m4y74pMTZqOeG5HjZu/luEOtenX0uCavfk2Ij4Ch5UFAQ
	Oyi4whrDRF1PkpLIBpDfQErrM8sjQJ4QtqrFgGP928E39kMa2tTAVuMf5r07EwGAWS8C/pHM1SCxR
	/mLavBQw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xJrGE-00000000ozc-39Qc;
	Thu, 22 Oct 2026 11:47:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A07AC300385; Thu, 22 Oct 2026 13:47:05 +0200 (CEST)
Date: Thu, 22 Oct 2026 13:47:05 +0200
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
Message-ID: <20261022114705.GW88198@noisy.programming.kicks-ass.net>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
 <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
 <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>

On Wed, Oct 21, 2026 at 09:39:52AM -0700, Josh Don wrote:
> On Wed, Oct 21, 2026 at 7:50 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, Oct 21, 2026 at 04:41:52PM +0300, Kayra Cizmeci wrote:
> > > On Wed, Oct 21, 2026 at 03:32:59PM +0200, Vincent Guittot wrote:
> > > > On Wed, 21 Oct 2026 at 15:13, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > > > What is the actual semantics of cpu.idle nonsense? Why do we care about
> > > > > this common ancestor?
> > > >
> > > > AFAICT, cpu.idle applied to one level and against entities at the same level
> > > >
> > >
> > > Yeah. Like on here:
> > >
> > >     ROOT
> > >      /\
> > >     /  \
> > >    /    \
> > >   GA*   GB
> > >    |    /\
> > >    V   /  \
> > >   TA  GC*  GD
> > >       |    |
> > >       V    V
> > >       TB   TC
> >
> > (marked GA and GC with * to denote their 'idleness')
> >
> > > If GA is idle and GB is not, while GC is idle and were looking to TA and
> > > TB we gotta choose TB. But if we just look to GC and GA we would choose
> > > neither. .idle just applies to one level as Vincent says.
> >
> > Yeah, that's what we used to do, but the more I think about this, the
> > less sense it makes!
> >
> > Josh added this (added to Cc now), but we have a number of Google folks
> > on Cc already. It would be good to hear how this is actually used.
> >
> >
> > So in your example TA and TB are both inside an idle group, and
> > therefore one can argue their behaviour should be like !idle. But their
> > common ancestor is root, and so the fact that they're contained in idle
> > groups gets lost (which seems crazeh).
> 
> TA and TB have a matching se of GA and GB, since those entities are
> siblings under the common ancestor. Since GB is not idle but GA is, I
> would argue that TB should preempt TA.

So I find this 'weird', at the end both TA and TB are marked idle,
albeit at different levels in the hierarchy. And yes, with the old code
this would lead to TB preempting TA, but I really don't see why that's a
good thing.

> Consider GA and GB as groups representing different users, and user GB
> has internally decided to create an idle cgroup GC to adjust
> competition between its own tasks (TB and TC). This should not affect
> GB's overall preemption ability against other users.

It doesn't; TC is not idle and will preempt just fine. But by marking
GB, and thus TB, as idle, we basically say we don't care about it, so
preempting should also be irrelevant.

Consider this:

     ROOT
      /\
     /  \
    /    \
   GA*   GB
    |    /\
    V   /  \
   TA  GC*  GD
       |    |
       v    V
       GE   TB
       /\
      /  \
     TC   TD

Suppose TC runs and TD wakes, with the strict LCA rules we'd find that
neither is idle and have one preempt the other. Even though they're well
part of an 'idle' sub-tree.

> However in practice doing the exact computation to determine
> preemption for relative idle properties (especially on wakeup) is
> expensive and perhaps not strictly required. This is also why e.g. the
> whole sched_idle_rq stuff is imprecise. We keep an overall tally of
> the number of tasks that have a cpu.idle ancestor cgroup and use that
> for wakeup placement, but if we were trying to be perfect we would
> need to consider the matching_se stuff for that as well. What I'd say
> there though is that imprecise placement is better than imprecise
> preemption.
> 
> So overall, I would say the find_matching_se() stuff gives the more
> ideal preemption decision; my first preference would be to keep it. It
> avoids a regression with users who delegate cpu.idle internally within
> their own cgroup hierarchy. FWIW wakeup preemption already does a
> cgroup ancestor walk via update_curr; find_matching_se is similar in
> spirit.

So its probably not the end of the world -- and we sort of still have
one in put_prev_task_fair(), but still, I find the semantics weird.

> But to be clear I also don't think it would be terrible if we did
> something like you suggest, cache whether a cgroup has _any_ cpu.idle
> ancestor and then just make a single decision on wakeup comparing this
> for the two tasks. The result of which is TC preempts T{AB}, but TA
> and TB don't preempt each other. In which case I would suggest we
> cache that as a part of updating cpu.idle so that we can avoid a
> pointer chasing loop in se_is_idle().

Just so. Let me try and implement that, see how horrible it looks.

> Either of these two will at least also restore some semblance of
> respecting cgroup cpu.idle in wakeup, as the flattening made it only
> consider task level SCHED_IDLE.

Right; I agree the current situation is somewhat broken.

Something like so ...

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b5546cd27dba..779fcd5a2830 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -15767,6 +15767,40 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	return ret;
 }
 
+struct tg_set_idle_struct {
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
+	if (!!old_idle == !!grp_cfs_rq->idle)
+		return 0;
+
+	task_delta = grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
+	if (!task_delta)
+		return 0;
+
+	task_delta *= tsi->idle;
+
+	for_each_sched_entity(se) {
+		if (!se->on_rq)
+			break;
+
+		cfs_rq_of(se)->h_nr_idle += task_delta;
+	}
+
+	return 0;
+}
+
 int sched_group_set_idle(struct task_group *tg, long idle)
 {
 	int i;
@@ -15777,49 +15811,22 @@ int sched_group_set_idle(struct task_group *tg, long idle)
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
 		struct rq *rq = cpu_rq(i);
-		struct sched_entity *se = tg_se(tg, i);
-		struct cfs_rq *grp_cfs_rq = tg_cfs_rq(tg, i);
-		bool was_idle = cfs_rq_is_idle(grp_cfs_rq);
-		long idle_task_delta;
-		struct rq_flags rf;
 
-		rq_lock_irqsave(rq, &rf);
+		guard(rq_lock_irqsave)(rq);
 
-		grp_cfs_rq->idle = idle;
-		if (WARN_ON_ONCE(was_idle == cfs_rq_is_idle(grp_cfs_rq)))
-			goto next_cpu;
-
-		idle_task_delta = grp_cfs_rq->h_nr_queued -
-				  grp_cfs_rq->h_nr_idle;
-		if (!cfs_rq_is_idle(grp_cfs_rq))
-			idle_task_delta *= -1;
-
-		for_each_sched_entity(se) {
-			struct cfs_rq *cfs_rq = cfs_rq_of(se);
-
-			if (!se->on_rq)
-				break;
-
-			cfs_rq->h_nr_idle += idle_task_delta;
-
-			/* Already accounted at parent level and above. */
-			if (cfs_rq_is_idle(cfs_rq))
-				break;
-		}
-
-next_cpu:
-		rq_unlock_irqrestore(rq, &rf);
+		struct tg_set_idle_struct tsi = {
+			.idle = idle ? 1 : -1,
+			.cpu = i,
+		};
+		walk_tg_tree_from(tg, tg_nop, tg_set_idle_up, &tsi);
 	}
 
 	/* Idle groups have minimum weight. */
@@ -15828,7 +15835,6 @@ int sched_group_set_idle(struct task_group *tg, long idle)
 	else
 		__sched_group_set_shares(tg, NICE_0_LOAD);
 
-	mutex_unlock(&shares_mutex);
 	return 0;
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 499a5649582e..06bcee5bb89f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -751,7 +751,7 @@ struct cfs_rq {
 	struct list_head	leaf_cfs_rq_list;
 	struct task_group	*tg;	/* Group that "owns" this runqueue */
 
-	/* Locally cached copy of our task_group's idle value */
+	/* Sum of all ancestor tg->idle. */
 	int			idle;
 
 # ifdef CONFIG_CFS_BANDWIDTH
