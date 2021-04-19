From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 2/5] mm/memcg: Cache vmstat data in percpu
 memcg_stock_pcp
Date: Mon, 19 Apr 2021 12:38:27 -0400
Message-ID: <YH2yA1oZoyQoMhAH@cmpxchg.org>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vpCqSo1bi/Itljn0ARQBAE88SdcDOq4CLh+u6Q1ryxk=;
        b=U/sz0/KTAjVUZKU3ywblEqS+Xfp7IcXV20jwhosV0NhrBK3OLhAEz3ZxHF6YkzX2s5
         SLXvchft5Wow+756f0u3h9h1ovxymMTNqN09gzC7FMXeZ/RBj13ZWfXItLyWZAYWD2qt
         FXbF6BnRW/P8WyVHirhaHvhRGLDPUFpKj36Qs12Ug3/UaW9w0y2CfQ2NbKPa+KjQYVtW
         AXkyuJMsyoOLXhgXL+1OknkZ/wQJy/L+tSQn/XSUVXULwS7qn2ui7ZqRQKNA35oz4NM3
         Fr3KahNRnWKD6FRQLlQKD+Gt0C7IV8uTn+VsMoL0uran9OHtkyFSZ4GEsQ5BwK1a3SEL
         rqNA==
Content-Disposition: inline
In-Reply-To: <20210419000032.5432-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <>

On Sun, Apr 18, 2021 at 08:00:29PM -0400, Waiman Long wrote:
> Before the new slab memory controller with per object byte charging,
> charging and vmstat data update happen only when new slab pages are
> allocated or freed. Now they are done with every kmem_cache_alloc()
> and kmem_cache_free(). This causes additional overhead for workloads
> that generate a lot of alloc and free calls.
> 
> The memcg_stock_pcp is used to cache byte charge for a specific
> obj_cgroup to reduce that overhead. To further reducing it, this patch
> makes the vmstat data cached in the memcg_stock_pcp structure as well
> until it accumulates a page size worth of update or when other cached
> data change. Caching the vmstat data in the per-cpu stock eliminates two
> writes to non-hot cachelines for memcg specific as well as memcg-lruvecs
> specific vmstat data by a write to a hot local stock cacheline.
> 
> On a 2-socket Cascade Lake server with instrumentation enabled and this
> patch applied, it was found that about 20% (634400 out of 3243830)
> of the time when mod_objcg_state() is called leads to an actual call
> to __mod_objcg_state() after initial boot. When doing parallel kernel
> build, the figure was about 17% (24329265 out of 142512465). So caching
> the vmstat data reduces the number of calls to __mod_objcg_state()
> by more than 80%.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dc9032f28f2e..693453f95d99 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2213,7 +2213,10 @@ struct memcg_stock_pcp {
>  
>  #ifdef CONFIG_MEMCG_KMEM
>  	struct obj_cgroup *cached_objcg;
> +	struct pglist_data *cached_pgdat;
>  	unsigned int nr_bytes;
> +	int vmstat_idx;
> +	int vmstat_bytes;
>  #endif
>  
>  	struct work_struct work;
> @@ -3150,8 +3153,9 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  	css_put(&memcg->css);
>  }
>  
> -void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> -		     enum node_stat_item idx, int nr)
> +static inline void __mod_objcg_state(struct obj_cgroup *objcg,
> +				     struct pglist_data *pgdat,
> +				     enum node_stat_item idx, int nr)

This naming is dangerous, as the __mod_foo naming scheme we use
everywhere else suggests it's the same function as mod_foo() just with
preemption/irqs disabled.

> @@ -3159,10 +3163,53 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(objcg);
>  	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	mod_memcg_lruvec_state(lruvec, idx, nr);
> +	__mod_memcg_lruvec_state(lruvec, idx, nr);
>  	rcu_read_unlock();
>  }
>  
> +void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> +		     enum node_stat_item idx, int nr)
> +{
> +	struct memcg_stock_pcp *stock;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	stock = this_cpu_ptr(&memcg_stock);
> +
> +	/*
> +	 * Save vmstat data in stock and skip vmstat array update unless
> +	 * accumulating over a page of vmstat data or when pgdat or idx
> +	 * changes.
> +	 */
> +	if (stock->cached_objcg != objcg) {
> +		/* Output the current data as is */

When you get here with the wrong objcg and hit the cold path, it's
usually immediately followed by an uncharge -> refill_obj_stock() that
will then flush and reset cached_objcg.

Instead of doing two cold paths, why not flush the old objcg right
away and set the new so that refill_obj_stock() can use the fast path?

> +	} else if (!stock->vmstat_bytes) {
> +		/* Save the current data */
> +		stock->vmstat_bytes = nr;
> +		stock->vmstat_idx = idx;
> +		stock->cached_pgdat = pgdat;
> +		nr = 0;
> +	} else if ((stock->cached_pgdat != pgdat) ||
> +		   (stock->vmstat_idx != idx)) {
> +		/* Output the cached data & save the current data */
> +		swap(nr, stock->vmstat_bytes);
> +		swap(idx, stock->vmstat_idx);
> +		swap(pgdat, stock->cached_pgdat);

Is this optimization worth doing?

You later split vmstat_bytes and idx doesn't change anymore.

How often does the pgdat change? This is a per-cpu cache after all,
and the numa node a given cpu allocates from tends to not change that
often. Even with interleaving mode, which I think is pretty rare, the
interleaving happens at the slab/page level, not the object level, and
the cache isn't bigger than a page anyway.

> +	} else {
> +		stock->vmstat_bytes += nr;
> +		if (abs(stock->vmstat_bytes) > PAGE_SIZE) {
> +			nr = stock->vmstat_bytes;
> +			stock->vmstat_bytes = 0;
> +		} else {
> +			nr = 0;
> +		}

..and this is the regular overflow handling done by the objcg and
memcg charge stock as well.

How about this?

	if (stock->cached_objcg != objcg ||
	    stock->cached_pgdat != pgdat ||
	    stock->vmstat_idx != idx) {
		drain_obj_stock(stock);
		obj_cgroup_get(objcg);
		stock->cached_objcg = objcg;
		stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
		stock->vmstat_idx = idx;
	}
	stock->vmstat_bytes += nr_bytes;

	if (abs(stock->vmstat_bytes > PAGE_SIZE))
		drain_obj_stock(stock);

(Maybe we could be clever, here since the charge and stat caches are
the same size: don't flush an oversized charge cache from
refill_obj_stock in the charge path, but leave it to the
mod_objcg_state() that follows; likewise don't flush an undersized
vmstat stock from mod_objcg_state() in the uncharge path, but leave it
to the refill_obj_stock() that follows. Could get a bit complicated...)

> @@ -3213,6 +3260,17 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  		stock->nr_bytes = 0;
>  	}
>  
> +	/*
> +	 * Flush the vmstat data in current stock
> +	 */
> +	if (stock->vmstat_bytes) {
> +		__mod_objcg_state(old, stock->cached_pgdat, stock->vmstat_idx,
> +				  stock->vmstat_bytes);

... then inline __mod_objcg_state() here into the only caller, and
there won't be any need to come up with a better name.

> +		stock->cached_pgdat = NULL;
> +		stock->vmstat_bytes = 0;
> +		stock->vmstat_idx = 0;
> +	}
> +
>  	obj_cgroup_put(old);
>  	stock->cached_objcg = NULL;
