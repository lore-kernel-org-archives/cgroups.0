From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 21 Feb 2022 17:44:13 +0100
Message-ID: <YhPBXUmIIHeXI/Gz@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-6-bigeasy@linutronix.de>
 <YhOlxsLOOU/OVSzu@dhcp22.suse.cz>
 <YhOtmPQUcqZCKodH@linutronix.de>
 <YhO8yQrdVX04T8/n@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645461854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FanYIpzuzO2OIQcmAbO6hr4IzLwYQWIb8ljFjp/SrAs=;
        b=nEVg+O/ZK98mEFQmhOseYs8lnNeH5TrEg8Jk3+iUr8PcEMutyi03fcN4iEX1GRo/t6b5kP
        M0/7n71mvbQcDqNA4E0EaAKsrrHsbFuXh/G1zUTGDUYIYTCjx7ieNkZMQCZe/ca9sPFUic
        FLWmNSrJanZEvxyyrbbSt4g9jc3EhbqYQXlbtdcjtwjIir3GCsRDkqJElKIK3LYp+LEhzz
        tSN+uyKedReEmpi29ETFV9cNizYc8UFGLtTSAIxgcqWf91lLoQKUFgmFiDozkQ9nBXptIb
        LjWHqYIUBuiCX7vEuXAZkGSfdVWuYdDm3o5kFLpF9QwOEvTDwBMRv4NSlpGluQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645461854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FanYIpzuzO2OIQcmAbO6hr4IzLwYQWIb8ljFjp/SrAs=;
        b=9tF2cGidY7GBkRFBiGZEcrVfwFXWtCNGIFcUkRa6oYaw4qWA9vVi5q3/DKgNjJtrllkuIh
        lu9RvHESpOVbA/BA==
Content-Disposition: inline
In-Reply-To: <YhO8yQrdVX04T8/n@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 2022-02-21 17:24:41 [+0100], Michal Hocko wrote:
> > > > @@ -2282,14 +2288,9 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
> > > >  		rcu_read_unlock();
> > > >  
> > > >  		if (flush &&
> > > > -		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
> > > > -			if (cpu == curcpu)
> > > > -				drain_local_stock(&stock->work);
> > > > -			else
> > > > -				schedule_work_on(cpu, &stock->work);
> > > > -		}
> > > > +		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > > > +			schedule_work_on(cpu, &stock->work);
> > > 
> > > Maybe I am missing but on !PREEMPT kernels there is nothing really
> > > guaranteeing that the worker runs so there should be cond_resched after
> > > the mutex is unlocked. I do not think we want to rely on callers to be
> > > aware of this subtlety.
> > 
> > There is no guarantee on PREEMPT kernels, too. The worker will be made
> > running and will be put on the CPU when the scheduler sees it fit and
> > there could be other worker which take precedence (queued earlier).
> > But I was not aware that the worker _needs_ to run before we return.
> 
> A lack of draining will not be a correctness problem (sorry I should
> have made that clear). It is more about subtlety than anything. E.g. the
> charging path could be forced to memory reclaim because of the cached
> charges which are still waiting for their draining. Not really something
> to lose sleep over from the runtime perspective. I was just wondering
> that this makes things more complex than necessary.

So it is no strictly wrong but it would be better if we could do
drain_local_stock() on the local CPU.

> > We
> > might get migrated after put_cpu() so I wasn't aware that this is
> > important. Should we attempt best effort and wait for the worker on the
> > current CPU?
> 
> 
> > > An alternative would be to split out __drain_local_stock which doesn't
> > > do local_lock.
> > 
> > but isn't the section in drain_local_stock() unprotected then?
> 
> local_lock instead of {get,put}_cpu would handle that right?

It took a while, but it clicked :)
If we acquire the lock_lock_t, that we would otherwise acquire in
drain_local_stock(), before the for_each_cpu loop (as you say
get,pu_cpu) then we would indeed need __drain_local_stock() and things
would work. But it looks like an abuse of the lock to avoid CPU
migration since there is no need to have it acquired at this point. Also
the whole section would run with disabled interrupts and there is no
need for it.

What about if replace get_cpu() with migrate_disable()? 

Sebastian
