From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH-next v3] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Fri, 17 Dec 2021 12:42:49 +0100
Message-ID: <Ybx3ubNFfGpCqhn0@linutronix.de>
References: <20211214144412.447035-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639741371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/ancgIFgkXeO3NDEPeVGpgn07wkYNrxt0m0tDBAo20=;
        b=r9nEpz+wZp4vfF/Gu2Vs1J8cQGszY5GTzaCwHMLoUcdK3QhP58IZzWaQFpOl+Ez/g+yCDV
        eL/PwjSebD3D9tVO0d90NcbkeO5fuNs7862UwJMTdZAWnjZ8R8qQqHzTkzkKdDp7zqiXIq
        rLLI/ShKnpmtSAlFha/c+luhZDNoXDSsst+e4bBBauovDVvfRAqXQ1F4R6aakFAcvHt7Ow
        EGjtvUzpTu17fPvqlkxE68I18P3FNsJRsu4ZW6Fk7eu90NOJfYi5wnKF+daB8+NXUk/Wvo
        O/f7RsowfsQxUmnbG3+uzA/zWnxCTJcaqyg339qiPsuTRQP1+Ly3bLAMLsY/OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639741371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3/ancgIFgkXeO3NDEPeVGpgn07wkYNrxt0m0tDBAo20=;
        b=ExKsbpBJPazNTYPG4oRZ2RNYzMs9Rfo2Vd/yrEk6XGqBqAS5LzFrUd0qDG1XzlNZGMUfFQ
        L/wNcK/zVkl+fJAQ==
Content-Disposition: inline
In-Reply-To: <20211214144412.447035-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 2021-12-14 09:44:12 [-0500], Waiman Long wrote:
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2096,7 +2096,12 @@ struct obj_stock {
>  #endif
>  };
>  
> +/*
> + * The local_lock protects the whole memcg_stock_pcp structure including
> + * the embedded obj_stock structures.
> + */
>  struct memcg_stock_pcp {
> +	local_lock_t lock;
>  	struct mem_cgroup *cached; /* this never be root cgroup */
>  	unsigned int nr_pages;
>  	struct obj_stock task_obj;
> @@ -2145,7 +2150,7 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  	if (nr_pages > MEMCG_CHARGE_BATCH)
>  		return ret;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.lock, flags);

This still does not explain why the lock is acquired here where it
appears to be unrelated to memcg_stock.lock.

>  
>  	stock = this_cpu_ptr(&memcg_stock);
>  	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
> @@ -2779,29 +2784,34 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>   * which is cheap in non-preempt kernel. The interrupt context object stock
>   * can only be accessed after disabling interrupt. User context code can
>   * access interrupt object stock, but not vice versa.
> + *
> + * This task and interrupt context optimization is disabled for PREEMPT_RT
> + * as there is no performance gain in this case and changes will be made to
> + * irq_obj only.
> + *
> + * For non-PREEMPT_RT, we are not replacing preempt_disable() by local_lock()
> + * as nesting of task_obj and irq_obj are allowed which may cause lockdep
> + * splat if local_lock() is used. Using separate local locks will complicate
> + * the interaction between obj_stock and the broader memcg_stock object.
>   */
>  static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
>  {
> -	struct memcg_stock_pcp *stock;
> -
> -	if (likely(in_task())) {
> +	if (likely(in_task()) && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
>  		*pflags = 0UL;
>  		preempt_disable();
> -		stock = this_cpu_ptr(&memcg_stock);
> -		return &stock->task_obj;
> +		return this_cpu_ptr(&memcg_stock.task_obj);

Do we need to keep the memcg_stock.task_obj for !RT?
I'm not really convinced that disabling either preemption or interrupts
is so much better compared to actual locking locking with lockdep
annotation. Looking at the history, I'm also impressed by that fact that
disabling/ enabling interrupts is *so* expensive that all this is
actually worth it.

>  	}
>  
> -	local_irq_save(*pflags);
> -	stock = this_cpu_ptr(&memcg_stock);
> -	return &stock->irq_obj;
> +	local_lock_irqsave(&memcg_stock.lock, *pflags);
> +	return this_cpu_ptr(&memcg_stock.irq_obj);
>  }
>  

Sebastian
