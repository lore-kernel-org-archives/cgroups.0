From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 21 Feb 2022 16:19:52 +0100
Message-ID: <YhOtmPQUcqZCKodH@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-6-bigeasy@linutronix.de>
 <YhOlxsLOOU/OVSzu@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645456793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iiqDs9VmzVxtjLGqmwh2wXqRO32y274elUOjlfl5pnA=;
        b=Csp7yKVAgNp7j1ujRn4fDH0+27J/BHkBSyTu/EJaAY+GfA/KxhRzDodQqBp6V3t8F4MjgY
        6T6snrOf3E+o9m0gQZgBI8gQ0XXefphcvdrj65RXqBVGoplkipjbLwzy/bdpRSxVm/TLZP
        p4wyuaV9r0TTDrwMpLNptw2gyswu7MnOdPRLYMWEyQGyoS4VVwmteuMk2fy0MZIc7dedyN
        eJceeBWGyVJT/zXxiRznGpJtPgGYfoOW4ZtPMYxHBt03UiWZeB2561reMAd2BE7ItQ/XhC
        q+yqYN2OoXr7m7Pto+ptKTS+8uIINgaWtuSKyWonAn+LxWn3/49imFouxE51/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645456793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iiqDs9VmzVxtjLGqmwh2wXqRO32y274elUOjlfl5pnA=;
        b=19vfFOgPBN5Px5aR1YBszTg4dPsBy1E6qIzOt/WCzph8OK++1Qt7FQibaqKw9CfSNwoxHi
        iwPTNXgWiS1SbsAQ==
Content-Disposition: inline
In-Reply-To: <YhOlxsLOOU/OVSzu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 2022-02-21 15:46:30 [+0100], Michal Hocko wrote:
> On Thu 17-02-22 10:48:02, Sebastian Andrzej Siewior wrote:
> [...]
> > @@ -2266,7 +2273,6 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
> >  	 * as well as workers from this path always operate on the local
> >  	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
> >  	 */
> > -	curcpu = get_cpu();
> 
> Could you make this a separate patch?

Sure.

> >  	for_each_online_cpu(cpu) {
> >  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> >  		struct mem_cgroup *memcg;
> > @@ -2282,14 +2288,9 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
> >  		rcu_read_unlock();
> >  
> >  		if (flush &&
> > -		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
> > -			if (cpu == curcpu)
> > -				drain_local_stock(&stock->work);
> > -			else
> > -				schedule_work_on(cpu, &stock->work);
> > -		}
> > +		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > +			schedule_work_on(cpu, &stock->work);
> 
> Maybe I am missing but on !PREEMPT kernels there is nothing really
> guaranteeing that the worker runs so there should be cond_resched after
> the mutex is unlocked. I do not think we want to rely on callers to be
> aware of this subtlety.

There is no guarantee on PREEMPT kernels, too. The worker will be made
running and will be put on the CPU when the scheduler sees it fit and
there could be other worker which take precedence (queued earlier).
But I was not aware that the worker _needs_ to run before we return. We
might get migrated after put_cpu() so I wasn't aware that this is
important. Should we attempt best effort and wait for the worker on the
current CPU?

> An alternative would be to split out __drain_local_stock which doesn't
> do local_lock.

but isn't the section in drain_local_stock() unprotected then?

Sebastian
