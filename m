From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 5/6] mm/memcg: Protect memcg_stock with a local_lock_t
Date: Tue, 22 Feb 2022 10:52:29 +0100
Message-ID: <YhSyXbxaMcgBJJtT@dhcp22.suse.cz>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-6-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645523550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h6mieIgEvjyuDAfc7uOkZ5vr5OU0GNLS9TFS5R7LVsQ=;
        b=aJA8FHfv0IKytKEygDLo9BQNAOhxHiT/0nlxPGdGed+2nmb2vntin3IE6p57PatDYvqfSi
        76v0c2W0u/X14Kv3T1/nMtTishSMfHOfhHo9YbpJmWy+tKyue+UfZwg06d/WlKZtfk8/AT
        C4ZAQbd6rhsMPGgKXRgy1lKYH5U5XqI=
Content-Disposition: inline
In-Reply-To: <20220221182540.380526-6-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon 21-02-22 19:25:39, Sebastian Andrzej Siewior wrote:
> The members of the per-CPU structure memcg_stock_pcp are protected by
> disabling interrupts. This is not working on PREEMPT_RT because it
> creates atomic context in which actions are performed which require
> preemptible context. One example is obj_cgroup_release().
> 
> The IRQ-disable sections can be replaced with local_lock_t which
> preserves the explicit disabling of interrupts while keeps the code
> preemptible on PREEMPT_RT.
> 
> drain_obj_stock() drops a reference on obj_cgroup which leads to an invocation
> of obj_cgroup_release() if it is the last object. This in turn leads to
> recursive locking of the local_lock_t. To avoid this, obj_cgroup_release() is
> invoked outside of the locked section.
> 
> obj_cgroup_uncharge_pages() can be invoked with the local_lock_t acquired and
> without it. This will lead later to a recursion in refill_stock(). To
> avoid the locking recursion provide obj_cgroup_uncharge_pages_locked()
> which uses the locked version of refill_stock().
> 
> - Replace disabling interrupts for memcg_stock with a local_lock_t.
> 
> - Let drain_obj_stock() return the old struct obj_cgroup which is passed
>   to obj_cgroup_put() outside of the locked section.
> 
> - Provide obj_cgroup_uncharge_pages_locked() which uses the locked
>   version of refill_stock() to avoid recursive locking in
>   drain_obj_stock().
> 
> Link: https://lkml.kernel.org/r/20220209014709.GA26885@xsang-OptiPlex-9020
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Thank you, this looks much more straightforward. I am not super fan of
the requirement to call obj_cgroup_put oudside of drain_obj_stock but
I can live with that. A comment in drain_obj_stock to call that out
explicitly would be nice (can be done as a follow up and have Andrew
fold it in if there is no new resubmission).

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 55 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cd3950256519d..3d7ccb104374c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2128,6 +2128,7 @@ void unlock_page_memcg(struct page *page)
>  }
>  
>  struct memcg_stock_pcp {
> +	local_lock_t stock_lock;
>  	struct mem_cgroup *cached; /* this never be root cgroup */
>  	unsigned int nr_pages;
>  
> @@ -2143,18 +2144,21 @@ struct memcg_stock_pcp {
>  	unsigned long flags;
>  #define FLUSHING_CACHED_CHARGE	0
>  };
> -static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
> +static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
> +	.stock_lock = INIT_LOCAL_LOCK(stock_lock),
> +};
>  static DEFINE_MUTEX(percpu_charge_mutex);
>  
>  #ifdef CONFIG_MEMCG_KMEM
> -static void drain_obj_stock(struct memcg_stock_pcp *stock);
> +static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock);
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  				     struct mem_cgroup *root_memcg);
>  static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>  
>  #else
> -static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
> +static inline struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
>  {
> +	return NULL;
>  }
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  				     struct mem_cgroup *root_memcg)
> @@ -2186,7 +2190,7 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  	if (nr_pages > MEMCG_CHARGE_BATCH)
>  		return ret;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
>  	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
> @@ -2194,7 +2198,7 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  		ret = true;
>  	}
>  
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
>  
>  	return ret;
>  }
> @@ -2223,6 +2227,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  static void drain_local_stock(struct work_struct *dummy)
>  {
>  	struct memcg_stock_pcp *stock;
> +	struct obj_cgroup *old = NULL;
>  	unsigned long flags;
>  
>  	/*
> @@ -2230,14 +2235,16 @@ static void drain_local_stock(struct work_struct *dummy)
>  	 * drain_stock races is that we always operate on local CPU stock
>  	 * here with IRQ disabled
>  	 */
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
> -	drain_obj_stock(stock);
> +	old = drain_obj_stock(stock);
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
> +	if (old)
> +		obj_cgroup_put(old);
>  }
>  
>  /*
> @@ -2264,9 +2271,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  {
>  	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  	__refill_stock(memcg, nr_pages);
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
>  }
>  
>  /*
> @@ -3093,10 +3100,11 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  		     enum node_stat_item idx, int nr)
>  {
>  	struct memcg_stock_pcp *stock;
> +	struct obj_cgroup *old = NULL;
>  	unsigned long flags;
>  	int *bytes;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  	stock = this_cpu_ptr(&memcg_stock);
>  
>  	/*
> @@ -3105,7 +3113,7 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  	 * changes.
>  	 */
>  	if (stock->cached_objcg != objcg) {
> -		drain_obj_stock(stock);
> +		old = drain_obj_stock(stock);
>  		obj_cgroup_get(objcg);
>  		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
>  				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
> @@ -3149,7 +3157,9 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  	if (nr)
>  		mod_objcg_mlstate(objcg, pgdat, idx, nr);
>  
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
> +	if (old)
> +		obj_cgroup_put(old);
>  }
>  
>  static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
> @@ -3158,7 +3168,7 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  	unsigned long flags;
>  	bool ret = false;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
>  	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
> @@ -3166,17 +3176,17 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  		ret = true;
>  	}
>  
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
>  
>  	return ret;
>  }
>  
> -static void drain_obj_stock(struct memcg_stock_pcp *stock)
> +static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
>  {
>  	struct obj_cgroup *old = stock->cached_objcg;
>  
>  	if (!old)
> -		return;
> +		return NULL;
>  
>  	if (stock->nr_bytes) {
>  		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> @@ -3226,8 +3236,8 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  		stock->cached_pgdat = NULL;
>  	}
>  
> -	obj_cgroup_put(old);
>  	stock->cached_objcg = NULL;
> +	return old;
>  }
>  
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
> @@ -3248,14 +3258,15 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  			     bool allow_uncharge)
>  {
>  	struct memcg_stock_pcp *stock;
> +	struct obj_cgroup *old = NULL;
>  	unsigned long flags;
>  	unsigned int nr_pages = 0;
>  
> -	local_irq_save(flags);
> +	local_lock_irqsave(&memcg_stock.stock_lock, flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
>  	if (stock->cached_objcg != objcg) { /* reset if necessary */
> -		drain_obj_stock(stock);
> +		old = drain_obj_stock(stock);
>  		obj_cgroup_get(objcg);
>  		stock->cached_objcg = objcg;
>  		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> @@ -3269,7 +3280,9 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  		stock->nr_bytes &= (PAGE_SIZE - 1);
>  	}
>  
> -	local_irq_restore(flags);
> +	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
> +	if (old)
> +		obj_cgroup_put(old);
>  
>  	if (nr_pages)
>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
> -- 
> 2.35.1

-- 
Michal Hocko
SUSE Labs
