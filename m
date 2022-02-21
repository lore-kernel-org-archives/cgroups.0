From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 4/5] mm/memcg: Opencode the inner part of
 obj_cgroup_uncharge_pages() in drain_obj_stock()
Date: Mon, 21 Feb 2022 15:30:14 +0100
Message-ID: <YhOh9jr9mBpMFmSn@dhcp22.suse.cz>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-5-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645453814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xm5m5YiRWNUhvkICSeUY+DU1RylDk3jyPhrK51qcDfU=;
        b=RI+5ECT2uxILC9RTBymw2xV51hIRlXaYMtIXbM3ktUPQUicUDNCR7d1vERywSgHfdUd7n0
        AgTDm8Lc6+1ZeJhJV2fPialDUPlHZB8eyDXBj1QUcnHZ55bTgR/fFlDb4lZ4oMWZTnlyWq
        545ns6J9/mvk9C8peXnTcNCen1lZz90=
Content-Disposition: inline
In-Reply-To: <20220217094802.3644569-5-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu 17-02-22 10:48:01, Sebastian Andrzej Siewior wrote:
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Provide the inner part of refill_stock() as __refill_stock() without
> disabling interrupts. This eases the integration of local_lock_t where
> recursive locking must be avoided.
> Open code obj_cgroup_uncharge_pages() in drain_obj_stock() and use
> __refill_stock(). The caller of drain_obj_stock() already disables
> interrupts.
> 
> [bigeasy: Patch body around Johannes' diff ]
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 36ab3660f2c6d..a3225501cce36 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2224,12 +2224,9 @@ static void drain_local_stock(struct work_struct *dummy)
>   * Cache charges(val) to local per_cpu area.
>   * This will be consumed by consume_stock() function, later.
>   */
> -static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> +static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>  	struct memcg_stock_pcp *stock;
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
>  	if (stock->cached != memcg) { /* reset if necessary */
> @@ -2241,7 +2238,14 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
>  		drain_stock(stock);
> +}
>  
> +static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__refill_stock(memcg, nr_pages);
>  	local_irq_restore(flags);
>  }
>  
> @@ -3158,8 +3162,16 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
>  		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
>  
> -		if (nr_pages)
> -			obj_cgroup_uncharge_pages(old, nr_pages);
> +		if (nr_pages) {
> +			struct mem_cgroup *memcg;
> +
> +			memcg = get_mem_cgroup_from_objcg(old);
> +
> +			memcg_account_kmem(memcg, -nr_pages);
> +			__refill_stock(memcg, nr_pages);
> +
> +			css_put(&memcg->css);
> +		}
>  
>  		/*
>  		 * The leftover is flushed to the centralized per-memcg value.
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
