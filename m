From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH-next v2] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 10 Dec 2021 14:01:32 +0100
Message-ID: <YbNPrGEjtKjzEjQa@linutronix.de>
References: <20211210025228.158196-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639141294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNlggrwdxU2IO35iIw34nGX4eaR6cSUi5G5TgF7sVRU=;
        b=FxdZ93dzBwccssU1Jn4Fw0Q+frnksamu020mgTYBG7dsvQY/AOQX3CzvAjaZLDOD9IMXvb
        GePbIbeGm45IefXJs6/wz6KizHVylKCTSy5gbmQfof64Tb3cZXOW8qX5zLn4F0+ol5+ZY4
        Ln9XSVz4Wt/ReZ+81ZNgp933y8hjkuP2zbWyjLlN1Vo+4Pje+1Fn4Z4fSDQElZ5rvKsQ1K
        wFvJ3KzkgRGj97JuQQPGnEFVLFQIVZPBL2dc3Ewt+7WnHIBRELmdqSrWhayk9K6p2FrV1m
        BZpP5nAbCv91mpAcPYmGlNBUCTqjFBVtw/02gb8t0uNKS7gqwqRpeRIbZP9KCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639141294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNlggrwdxU2IO35iIw34nGX4eaR6cSUi5G5TgF7sVRU=;
        b=mEULxooEnU4502J3ZNOj8iBBPuXwd1P1XAtsCS5qSs54GrXINbBoe1fOeeYzUdY3JxFmN4
        TUekS4bmjzb1YQBw==
Content-Disposition: inline
In-Reply-To: <20211210025228.158196-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2021-12-09 21:52:28 [-0500], Waiman Long wrote:
=E2=80=A6
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
=E2=80=A6
> @@ -2210,7 +2211,7 @@ static void refill_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
>  	struct memcg_stock_pcp *stock;
>  	unsigned long flags;
> =20
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.lock, flags);

Why is this one using the lock? It isn't accessing irq_obj, right?

>  	stock =3D this_cpu_ptr(&memcg_stock);
>  	if (stock->cached !=3D memcg) { /* reset if necessary */
> @@ -2779,29 +2780,28 @@ static struct mem_cgroup *get_mem_cgroup_from_obj=
cg(struct obj_cgroup *objcg)
>   * which is cheap in non-preempt kernel. The interrupt context object st=
ock
>   * can only be accessed after disabling interrupt. User context code can
>   * access interrupt object stock, but not vice versa.
> + *
> + * This task and interrupt context optimization is disabled for PREEMPT_=
RT
> + * as there is no performance gain in this case.
>   */
>  static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
>  {
> -	struct memcg_stock_pcp *stock;
> -
> -	if (likely(in_task())) {
> +	if (likely(in_task()) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
>  		*pflags =3D 0UL;
>  		preempt_disable();
> -		stock =3D this_cpu_ptr(&memcg_stock);
> -		return &stock->task_obj;
> +		return this_cpu_ptr(&memcg_stock.task_obj);
>  	}

We usually add the local_lock_t to the object it protects, struct
obj_stock it this case.
That would give you two different locks (instead of one) so you wouldn't
have to use preempt_disable() to avoid lockdep's complains. Also it
would warn you if you happen to use that obj_stock in !in_task() which
is isn't possible now.
The only downside would be that drain_local_stock() needs to acquire two
locks.

> =20
> -	local_irq_save(*pflags);
> -	stock =3D this_cpu_ptr(&memcg_stock);
> -	return &stock->irq_obj;
> +	local_lock_irqsave(&memcg_stock.lock, *pflags);
> +	return this_cpu_ptr(&memcg_stock.irq_obj);
>  }
> =20
>  static inline void put_obj_stock(unsigned long flags)
>  {
> -	if (likely(in_task()))
> +	if (likely(in_task()) && !IS_ENABLED(CONFIG_PREEMPT_RT))
>  		preempt_enable();
>  	else
> -		local_irq_restore(flags);
> +		local_unlock_irqrestore(&memcg_stock.lock, flags);
>  }
> =20
>  /*

Sebastian
