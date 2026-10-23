Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763347;
	b=hmMpRe+lRkMYNY49eOA4KCRN9P86u027n6YI1VExWGwR89D6eWRl1fBeyNwz/rnwBQ5r
	 FaovY5qwMRlIgMUtDkxBl1/0EBtLDkbLZwZTireWMubkrhrY1HPnUTv5MmkysnTlFM5Kn
	 lHtLRdmX0Su6gSK3jLNQJDN4oRbIFlOopmiHQ8S55PDfsMEpNGhaau2d+ho+gxPf43l4w
	 nLv8ZEAhtQirklLbn9c/qtoJ81F6CRSa6lGQxywCvOLp6wp5hwxQ8JQOfLhGAlGCcQ3M2
	 9DJs3wvgPvVfeioTPXRBTu6I8xIAs6yeKpzX/ybAlTn+qTts5kITr9OAkkxhEkmS8hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=lADM6itUBZwyMq6HdMlP1DiVjIl458v5XJJQdVmxpDU=;
	b=ORmJOgaGfHr2Bv08whPo05FMfS5Se/k/BP/Ja0HwlzWeX9yM93fcmc7mP6OgOEVoCrUS
	 YLn/d0Ah2LOGVqZ/yG1UJA4T6ts4wFviRytF2oLZlKW7jDJYtEmf6fkQlW81LOffNUeuR
	 nPfWDXZ6w03at+Z7yftmX+vZ1JB2H8eFUohYVykLm89FOcJTV1IgLpo8DNbbll8K0SoIg
	 OTSQT0WdX2F2N3th/sS7r1coVhOR3YwZVKJ613AozksFfu5jbYMB5OMdmTc2aa5YREF6/
	 usFwFDAQrXn3FeJGTZw/FeRgT6Z72fGiIX+ouyfunTqlW61XYsKksgWurqAay8tY8Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ck3SHypY;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC14606A31D
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 13:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAC14606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ck3SHypY
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a20be3b39eso1015685e9.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 06:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792763345; x=1793368145; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lADM6itUBZwyMq6HdMlP1DiVjIl458v5XJJQdVmxpDU=;
        b=Ck3SHypYRrk1suhVZfWywGwBzo9joU0vXQYeXrJVBKm6jKF1uVNjRXOzHMq+ZnGzud
         BAnYM0P8/uGJV1ZbiarlSGrZYQkNbZ+HSqIzgZ4oHpVizEMxuUEyP9yWJXn1flZa9Dp3
         jjvWHQ/Js+9q3ws3qDXHgZwbL0I1OWsbnER4NZDZftOMRbHyu8e1Fpj1SqMsSNO3Bbez
         BwTQhMuryU5ZrnnDMUaFlgwAs8TqP7UJ+7iN6J5b6XY6KBA8cKeVjnaZy5Dp8TO9VgdT
         R4Gsv8EF6x0CD4cCfG0/22csmHUWlFHhEe6LN3HOCjO8W+v7QWYBCHLji0mlRLYbb8JG
         KwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792763345; x=1793368145;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lADM6itUBZwyMq6HdMlP1DiVjIl458v5XJJQdVmxpDU=;
        b=t5G4Mlf8I7MzhIt/QoOpXtn73dPYMVNq8i7cAWRFKGyDjGrJ9g8gaI2iSVZ2DJ2f+g
         zElfmZy/kuoBhTYh6rfgnBAGemlVELKSEwVsU51IfsMkfJ29YxAOLFlcy6WNOugUK11e
         A5Tl4nZkdVQcV8Qb564QhE1Vv4bRdlf6/KMBTI20S3Qmbh0+eW5v9qo3k6lWhO2YyPDi
         ojSyx2WP+d0gCA0R0gNj9hbdtqY55sH2cDuvOQPpJ5Wrdt/qEC2xe+qiyOEa+ou2z6ET
         ogiCfXvetkTijZrMYRmXtnpsp1dexKOjljuqV957HHY+NesbGs+Pch1MJWTG7pEGhNuf
         675Q==
X-Forwarded-Encrypted: i=1; AKwUvBxpevRtQgBTHdm+c/pzzLY1FLdRGvfpC9IJqgULYTjbxSXKphi/kZr3rH21T6HAMorc6S++r8Dd@vger.kernel.org
X-Gm-Message-State: AFq9FYIQk9BIdCNSCr6R1oEoIpZyCULReHhACjSRlPrKJTLB1qejFNbK
	ck4zGApOvF4KEYAtyIRZKb0F9YnEUmJBP4WymzFynDwKxjVGvhk7PYjE
X-Gm-Gg: AYBFou2no//HbCb8VnVLO2k+uIW8DcM038+kTWm4MTCiY3vJjiewCnafSpRsMysAlal
	bkof01qXl9+Q/VnpLwPDBvx9+WgrcG6Zn2Hmmb4P6+x4Py6mi0wGjZ+1A7ooXwx8kR7UCKXvUVO
	CVhEOC+Cr9UXDQAx8DKbCs8neuGWOax9+d61JqtaVusqkFYEoSUjvfn2eXupDhwFsgWiPRau6rC
	PBGfs7W+fSWyuXPlA0sVi9F9otTuN7fzapbjHzhtR2Pa1fHtB+xArpP+7MtQYs1CiE9QSyb4PBz
	7UhXBJP/R8+gFoIfdvtlLiJMGHpjQ/j+BEqIWzE1fnKvCLAM3bJQpVoobycTQCpFcZ/M8nCC0MY
	inowAKLEAkBv2N4RNBZqkgpH6VqPfLxop6raAd0n7R9AbBoAHF1d2l0ydcSi7omPNUJCvUAwomB
	EZ7mNlXcMrKvU3bKl7NG1ghQQw6LH9FWQAeNrDpL1SFJM3e7izKCudVC6ikOhQzQuMi9C0w5Dqr
	e3jpXpFuOq9T1bgza/mKppQ4xfk8L4NaqFXse9tgyscM8rRrZpO6jpXWl2vxovCAFRHzcFfovU+
	M3axfe4x
X-Received: by 2002:a05:600c:5955:b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4a211cb40f2mr28461605e9.2.1792763344664;
        Fri, 23 Oct 2026 06:49:04 -0700 (PDT)
Received: from scheduler.schedules ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2a92a42adsm5970285e9.3.2026.10.23.06.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 06:49:04 -0700 (PDT)
Date: Fri, 23 Oct 2026 16:49:00 +0300
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Don <joshdon@google.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com, juri.lelli@redhat.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, 
	jakub@okonski.org, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, cgroups@vger.kernel.org, jstultz@google.com, qyousef@layalina.io
Subject: Re: [PATCH v2] sched/eevdf: Fix sched idle task group preemption
Message-ID: <attitenhAXB86seS@scheduler.schedules>
References: <20261019182622.1584454-1-vincent.guittot@linaro.org>
 <20261021131313.GM2823843@noisy.programming.kicks-ass.net>
 <CAKfTPtDOZ0=nrQe1-WSTamgU0qqdJVvD3KZPtnsqwwnE53BSKA@mail.gmail.com>
 <ati_o5c-SoiOp529@scheduler.schedules>
 <20261021145042.GQ2823843@noisy.programming.kicks-ass.net>
 <CABk29Nv2ZzB1KGEuPmx4VmxTJ6pKmikGMr8cvzzDhHZSKpkgvg@mail.gmail.com>
 <20261022114705.GW88198@noisy.programming.kicks-ass.net>
 <CABk29NviVUAK6B_deQ7qah8eABiCikbFpTwDEO2hdproGLdLwQ@mail.gmail.com>
 <20261022212150.GW2823843@noisy.programming.kicks-ass.net>
 <20261023132956.GD409038@noisy.programming.kicks-ass.net>
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
In-Reply-To: <20261023132956.GD409038@noisy.programming.kicks-ass.net>

On Fri, Oct 23, 2026 at 03:29:56PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 22, 2026 at 11:21:50PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 22, 2026 at 10:49:36AM -0700, Josh Don wrote:
> 
> > > Took me a bit to parse this double traversal. I think this is broken
> > > for the clear side?
> > > 
> > > root
> > >   |
> > >  A ( 2 tasks)
> > >  |
> > >  B (3 tasks)
> > > 
> > > If we start out with A marked as idle, then we have
> > > root: h_nr_idle = 5
> > > A: h_nr_idle = 3
> > > B: h_nr_idle = 0
> > > 
> > > When we clear, we'll first start with B and subtract 3...
> > > root: h_nr_idle = 2
> > > A: h_nr_idle = 0
> > > B: h_nr_idle = 0
> > > 
> > > Then we go to A and try to subtract 5 leading to
> > > root: h_nr_idle = -3
> > > 
> > 
> > Argh. Yes, I seem to have gotten it wrong. I'll try again in the
> > morning.
> 
> Bah, so I can't operate cgroup well enough to actually set up the above
> scenario. I think I'm stuck in cgroup-v2 mode which disallows this. I
> should probably ask one of the AI thingies to write me a script.
> 
> Anyway, I think the below *should* work. It seems to behave for the
> simple cases I did test.
> 
> This also fixes that init thing you noted, and yes, we can use this as
> an optimization for the find_matching_se() -- although I still think
> those semantics are weird, but whatever. If that's what people really
> want.
> 
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0ab15f03cb94..731befb0f671 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -8970,7 +8970,7 @@ void __init sched_init(void)
>  		rq->nr_running = 0;
>  		rq->calc_load_active = 0;
>  		rq->calc_load_update = jiffies + LOAD_FREQ;
> -		init_cfs_rq(&rq->cfs);
> +		init_cfs_rq(&rq->cfs, NULL);
>  		init_rt_rq(&rq->rt);
>  		init_dl_rq(&rq->dl);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index e6a3b516c703..9914498df0e2 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -1090,6 +1090,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_runnable", cfs_rq->h_nr_runnable);
>  	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_queued", cfs_rq->h_nr_queued);
>  	SEQ_printf(m, "  .%-30s: %d\n", "h_nr_idle", cfs_rq->h_nr_idle);
> +	SEQ_printf(m, "  .%-30s: %d\n", "idle", cfs_rq->idle);
>  	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
>  	SEQ_printf(m, "  .%-30s: %lu\n", "load_avg",
>  			cfs_rq->avg.load_avg);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b5546cd27dba..2fcb01a514c5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -15581,8 +15581,10 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, enum snt_e
>  		hrtick_start_fair(rq, p);
>  }
>  
> -void init_cfs_rq(struct cfs_rq *cfs_rq)
> +void init_cfs_rq(struct cfs_rq *cfs_rq, struct cfs_rq *parent)
>  {
> +	if (parent)
> +		cfs_rq->idle = parent->idle;
>  	cfs_rq->tasks_timeline = RB_ROOT_CACHED;
>  	cfs_rq->zero_vruntime = (u64)(-(1LL << 20));
>  	raw_spin_lock_init(&cfs_rq->removed.lock);
> @@ -15633,7 +15635,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  			goto err;
>  
>  		se = tg_se(tg, i);
> -		init_cfs_rq(cfs_rq);
> +		init_cfs_rq(cfs_rq, tg_cfs_rq(parent, i));
>  		init_tg_cfs_entry(tg, cfs_rq, se, i, tg_se(parent, i));
>  		init_entity_runnable_average(se);
>  	}
> @@ -15767,6 +15769,37 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
>  	return ret;
>  }
>  
> +struct tg_set_idle_struct {
> +	struct task_group *tg;
> +	long idle;
> +	int cpu;
> +};
> +
> +static int tg_set_idle_up(struct task_group *tg, void *data)
> +{
> +	struct tg_set_idle_struct *tsi = data;
> +	struct cfs_rq *grp_cfs_rq = tg_cfs_rq(tg, tsi->cpu);
> +	struct sched_entity *se = tg_se(tg, tsi->cpu);
> +	int old_idle = grp_cfs_rq->idle;
> +	long task_delta;
> +
> +	grp_cfs_rq->idle += tsi->idle;
> +
> +	if (tg == tsi->tg)
> +		return 0;
> +
> +	if (!!old_idle == !!grp_cfs_rq->idle)
> +		return 0;
> +
> +	task_delta = grp_cfs_rq->h_nr_queued - grp_cfs_rq->h_nr_idle;
> +	if (!task_delta)
> +		return 0;
> +
> +	task_delta *= tsi->idle;
> +	cfs_rq_of(se)->h_nr_idle += task_delta;
> +	return 0;
> +}

I think this works wrong again on here AFAICT :-):

ROOT
  |
  A (3 Tasks)
  |
  B (2 Tasks)

When we do A idle, it should be:

B = 0, A = 2, ROOT = 5.

We start from B, We add +2 to A. Now, B = 0, A = 2, ROOT = 0.
Then we get to A. 5 - 2 is 3, we add h_nr_idle 3 and ROOT = 3.
While it should be 5, no?

Thanks!

Kayra
