From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 3/5] mm/memcg: Cache vmstat data in percpu memcg_stock_pcp
Date: Mon, 12 Apr 2021 11:22:49 -0700
Message-ID: <YHSP+U/I52zx/JWZ@carbon.dhcp.thefacebook.com>
References: <20210409231842.8840-1-longman@redhat.com>
 <20210409231842.8840-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z0C2fVCoh5GAkWzMVNfetvtwqQoyVEtZ1ZOo5uVKilY=;
 b=Kf47sJln+376K4t0+Oo8rERDz1DZD5CSOEbz+4du5ctnRzUYcTtZ0ZR94RfDCRVmXU8+
 uJCMImrV8SYlh8WCd7U/UMC+yTOnmmaOo363pdqrcpFG1QRfVjb8LjeM9mkrv+ihc8Zp
 3bb85rOwZN98dIywKn2z108NEvHqebC90Zc= 
Content-Disposition: inline
In-Reply-To: <20210409231842.8840-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8@public.gmane.org>

On Fri, Apr 09, 2021 at 07:18:40PM -0400, Waiman Long wrote:
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
> data change.

The idea makes total sense to me and also gives a hope to remove
byte-sized vmstats in the long-term.

> 
> On a 2-socket Cascade Lake server with instrumentation enabled and this
> patch applied, it was found that about 17% (946796 out of 5515184) of the
> time when __mod_obj_stock_state() is called leads to an actual call to
> mod_objcg_state() after initial boot. When doing parallel kernel build,
> the figure was about 16% (21894614 out of 139780628). So caching the
> vmstat data reduces the number of calls to mod_objcg_state() by more
> than 80%.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 78 +++++++++++++++++++++++++++++++++++++++++++------
>  mm/slab.h       | 26 +++++++----------
>  2 files changed, 79 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b19100c68aa0..539c3b632e47 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2220,7 +2220,10 @@ struct memcg_stock_pcp {
>  
>  #ifdef CONFIG_MEMCG_KMEM
>  	struct obj_cgroup *cached_objcg;
> +	struct pglist_data *cached_pgdat;
>  	unsigned int nr_bytes;
> +	int vmstat_idx;
> +	int vmstat_bytes;
>  #endif

Because vmstat_idx can realistically take only 3 values (slab_reclaimable,
slab_unreclaimable and percpu), I wonder if it's better to have
vmstat_bytes[3] and save a bit more on the reduced number of flushes?
It must be an often case when a complex (reclaimable) kernel object has
non-reclaimable parts (e.g. kmallocs) or percpu counters.
If the difference will be too small, maybe the current form is better.

>  
>  	struct work_struct work;
> @@ -3157,6 +3160,21 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  	css_put(&memcg->css);
>  }
>  
> +static inline void mod_objcg_state(struct obj_cgroup *objcg,
> +				   struct pglist_data *pgdat,
> +				   enum node_stat_item idx, int nr)
> +{
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec = NULL;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	if (pgdat)
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	__mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
> +	rcu_read_unlock();
> +}
> +
>  static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  {
>  	struct memcg_stock_pcp *stock;
> @@ -3207,6 +3225,14 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  		stock->nr_bytes = 0;
>  	}
>  
> +	if (stock->vmstat_bytes) {
> +		mod_objcg_state(old, stock->cached_pgdat, stock->vmstat_idx,
> +				stock->vmstat_bytes);
> +		stock->vmstat_bytes = 0;
> +		stock->vmstat_idx = 0;
> +		stock->cached_pgdat = NULL;
> +	}
> +
>  	obj_cgroup_put(old);
>  	stock->cached_objcg = NULL;
>  }
> @@ -3251,6 +3277,48 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  	local_irq_restore(flags);
>  }
>  
> +static void __mod_obj_stock_state(struct obj_cgroup *objcg,
> +				  struct pglist_data *pgdat, int idx, int nr)
> +{
> +	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> +
> +	if (stock->cached_objcg != objcg) {
> +		/* Output the current data as is */
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
> +	} else {
> +		stock->vmstat_bytes += nr;
> +		if (abs(nr) > PAGE_SIZE) {
> +			nr = stock->vmstat_bytes;
> +			stock->vmstat_bytes = 0;
> +		} else {
> +			nr = 0;
> +		}
> +	}
> +	if (nr)
> +		mod_objcg_state(objcg, pgdat, idx, nr);
> +}
> +
> +void mod_obj_stock_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> +			 int idx, int nr)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__mod_obj_stock_state(objcg, pgdat, idx, nr);
> +	local_irq_restore(flags);
> +}
> +
>  int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
>  {
>  	struct mem_cgroup *memcg;
> @@ -3300,18 +3368,10 @@ void obj_cgroup_uncharge_mod_state(struct obj_cgroup *objcg, size_t size,
>  				   struct pglist_data *pgdat, int idx)
>  {
>  	unsigned long flags;
> -	struct mem_cgroup *memcg;
> -	struct lruvec *lruvec = NULL;
>  
>  	local_irq_save(flags);
>  	__refill_obj_stock(objcg, size);
> -
> -	rcu_read_lock();
> -	memcg = obj_cgroup_memcg(objcg);
> -	if (pgdat)
> -		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	__mod_memcg_lruvec_state(memcg, lruvec, idx, -(int)size);
> -	rcu_read_unlock();
> +	__mod_obj_stock_state(objcg, pgdat, idx, -(int)size);
>  	local_irq_restore(flags);
>  }
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index 677cdc52e641..ae971975d9fc 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -239,6 +239,8 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
>  #ifdef CONFIG_MEMCG_KMEM
>  int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>  				 gfp_t gfp, bool new_page);
> +void mod_obj_stock_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> +			 int idx, int nr);
>  
>  static inline void memcg_free_page_obj_cgroups(struct page *page)
>  {
> @@ -283,20 +285,6 @@ static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
>  	return true;
>  }
>  
> -static inline void mod_objcg_state(struct obj_cgroup *objcg,
> -				   struct pglist_data *pgdat,
> -				   enum node_stat_item idx, int nr)
> -{
> -	struct mem_cgroup *memcg;
> -	struct lruvec *lruvec;
> -
> -	rcu_read_lock();
> -	memcg = obj_cgroup_memcg(objcg);
> -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
> -	rcu_read_unlock();
> -}
> -
>  static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
>  					      struct obj_cgroup *objcg,
>  					      gfp_t flags, size_t size,
> @@ -324,8 +312,9 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
>  			off = obj_to_index(s, page, p[i]);
>  			obj_cgroup_get(objcg);
>  			page_objcgs(page)[off] = objcg;
> -			mod_objcg_state(objcg, page_pgdat(page),
> -					cache_vmstat_idx(s), obj_full_size(s));
> +			mod_obj_stock_state(objcg, page_pgdat(page),
> +					    cache_vmstat_idx(s),
> +					    obj_full_size(s));
>  		} else {
>  			obj_cgroup_uncharge(objcg, obj_full_size(s));
>  		}
> @@ -408,6 +397,11 @@ static inline void memcg_slab_free_hook(struct kmem_cache *s,
>  					void **p, int objects)
>  {
>  }
> +
> +static void mod_obj_stock_state(struct obj_cgroup *objcg,
> +				struct pglist_data *pgdat, int idx, int nr)
> +{
> +}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  static inline struct kmem_cache *virt_to_cache(const void *obj)
> -- 
> 2.18.1
> 
