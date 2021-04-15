From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/5] mm/memcg: Separate out object stock data into its
 own struct
Date: Wed, 14 Apr 2021 23:28:20 -0400
Message-ID: <20210415032820.coutviukiyieiysm@gabell>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GdhHYsB8bOsa0eVuM5ITMWOP/eGp5o+C93zFwUv80RI=;
        b=ZX8WWiYfe9ouAFYnUCatkW3kFti2km6xAK/jSGgTiTdTc2K18FI6zAorC7CA5wE2CN
         +DE70z6Pa/oY35NHF+/pTm51zbCUXPfI6VQT7lEKc8tj7AxIe/hJIBFHIwu7ejtNQ2h/
         flyV+dLY/XR9dV8cVrdqZBbqZ+zbO10663BLQo5S32lrGzbJxPIDgr5gD4izz3w6/Mro
         31GxQRer8ofsumn6fMeSSqdt90rRYd9Q5lQ3b74aIKYMpXtYIHAc8rO9nN3FfX4rVCXN
         IOB6DHt+cuKDLRa4vfSTKiPXqgzcZN4HdUYexdmER71oMsDpRviW2rKkSoYLM4wzJr+J
         TQ/A==
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Tue, Apr 13, 2021 at 09:20:26PM -0400, Waiman Long wrote:
> The object stock data stored in struct memcg_stock_pcp are independent
> of the other page based data stored there. Separating them out into
> their own struct to highlight the independency.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 41 ++++++++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 539c3b632e47..69f728383efe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2214,17 +2214,22 @@ void unlock_page_memcg(struct page *page)
>  }
>  EXPORT_SYMBOL(unlock_page_memcg);
>  
> -struct memcg_stock_pcp {
> -	struct mem_cgroup *cached; /* this never be root cgroup */
> -	unsigned int nr_pages;
> -
> +struct obj_stock {
>  #ifdef CONFIG_MEMCG_KMEM
>  	struct obj_cgroup *cached_objcg;
>  	struct pglist_data *cached_pgdat;
>  	unsigned int nr_bytes;
>  	int vmstat_idx;
>  	int vmstat_bytes;
> +#else
> +	int dummy[0];
>  #endif
> +};
> +
> +struct memcg_stock_pcp {
> +	struct mem_cgroup *cached; /* this never be root cgroup */
> +	unsigned int nr_pages;
> +	struct obj_stock obj;
>  
>  	struct work_struct work;
>  	unsigned long flags;
> @@ -2234,12 +2239,12 @@ static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
>  static DEFINE_MUTEX(percpu_charge_mutex);
>  
>  #ifdef CONFIG_MEMCG_KMEM
> -static void drain_obj_stock(struct memcg_stock_pcp *stock);
> +static void drain_obj_stock(struct obj_stock *stock);
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  				     struct mem_cgroup *root_memcg);
>  
>  #else
> -static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
> +static inline void drain_obj_stock(struct obj_stock *stock)
>  {
>  }
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
> @@ -2249,6 +2254,13 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  }
>  #endif
>  
> +static inline struct obj_stock *current_obj_stock(void)
> +{
> +	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> +
> +	return &stock->obj;
> +}
> +
>  /**
>   * consume_stock: Try to consume stocked charge on this cpu.
>   * @memcg: memcg to consume from.
> @@ -2315,7 +2327,7 @@ static void drain_local_stock(struct work_struct *dummy)
>  	local_irq_save(flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
> -	drain_obj_stock(stock);
> +	drain_obj_stock(&stock->obj);
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  
> @@ -3177,13 +3189,13 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
>  
>  static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  {
> -	struct memcg_stock_pcp *stock;
> +	struct obj_stock *stock;
>  	unsigned long flags;
>  	bool ret = false;
>  
>  	local_irq_save(flags);
>  
> -	stock = this_cpu_ptr(&memcg_stock);
> +	stock = current_obj_stock();
>  	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
>  		stock->nr_bytes -= nr_bytes;
>  		ret = true;
> @@ -3194,7 +3206,7 @@ static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  	return ret;
>  }
>  
> -static void drain_obj_stock(struct memcg_stock_pcp *stock)
> +static void drain_obj_stock(struct obj_stock *stock)
>  {
>  	struct obj_cgroup *old = stock->cached_objcg;
>  
> @@ -3242,8 +3254,8 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  {
>  	struct mem_cgroup *memcg;
>  
> -	if (stock->cached_objcg) {
> -		memcg = obj_cgroup_memcg(stock->cached_objcg);
> +	if (stock->obj.cached_objcg) {
> +		memcg = obj_cgroup_memcg(stock->obj.cached_objcg);
>  		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
>  			return true;
>  	}
> @@ -3253,9 +3265,8 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  
>  static void __refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  {
> -	struct memcg_stock_pcp *stock;
> +	struct obj_stock *stock = current_obj_stock();
>  
> -	stock = this_cpu_ptr(&memcg_stock);
>  	if (stock->cached_objcg != objcg) { /* reset if necessary */
>  		drain_obj_stock(stock);
>  		obj_cgroup_get(objcg);
> @@ -3280,7 +3291,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  static void __mod_obj_stock_state(struct obj_cgroup *objcg,
>  				  struct pglist_data *pgdat, int idx, int nr)
>  {
> -	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> +	struct obj_stock *stock = current_obj_stock();
>  
>  	if (stock->cached_objcg != objcg) {
>  		/* Output the current data as is */
> -- 
> 2.18.1
> 
Please feel free to add:

Tested-by: Masayoshi Mizuma <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Thanks!
Masa
