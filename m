From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Mon, 21 Feb 2022 15:46:30 +0100
Message-ID: <YhOlxsLOOU/OVSzu@dhcp22.suse.cz>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-6-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645454791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EqsD0+PUucg5iQZfEeVVmjRSWohazjOc9cWwEfg7gWQ=;
        b=S9RSPoFRigrL5qMv/KMVZC7pUGpUkd/8yaw0GTN00pBHVYNtVUVkqFaUKo5sOpLFxhaNEP
        C3MbcBsSyVJnzwDSA0jGAX/qFbmIl7vZ4hdBnEY4g+Jvez705ER6wV3LCJSOJurw8Enq1u
        b5Rasq4exl90T33lXZSWWnyCQbWx40w=
Content-Disposition: inline
In-Reply-To: <20220217094802.3644569-6-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu 17-02-22 10:48:02, Sebastian Andrzej Siewior wrote:
[...]
> @@ -2266,7 +2273,6 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  	 * as well as workers from this path always operate on the local
>  	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
>  	 */
> -	curcpu = get_cpu();

Could you make this a separate patch?

>  	for_each_online_cpu(cpu) {
>  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
>  		struct mem_cgroup *memcg;
> @@ -2282,14 +2288,9 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  		rcu_read_unlock();
>  
>  		if (flush &&
> -		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
> -			if (cpu == curcpu)
> -				drain_local_stock(&stock->work);
> -			else
> -				schedule_work_on(cpu, &stock->work);
> -		}
> +		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> +			schedule_work_on(cpu, &stock->work);

Maybe I am missing but on !PREEMPT kernels there is nothing really
guaranteeing that the worker runs so there should be cond_resched after
the mutex is unlocked. I do not think we want to rely on callers to be
aware of this subtlety.

An alternative would be to split out __drain_local_stock which doesn't
do local_lock.

-- 
Michal Hocko
SUSE Labs
