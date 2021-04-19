From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 4/5] mm/memcg: Save both reclaimable & unreclaimable
 bytes in object stock
Date: Mon, 19 Apr 2021 12:55:07 -0400
Message-ID: <YH216/wnyEOcxATl@cmpxchg.org>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zk/sp40ccYRx2WOjOuziU8/bUWKXs2YHeaI5ZDdPDPI=;
        b=myzKF9uZT1H+cgfSxn1jOdSsvWzrqzudomITjhtn9FDtGADN3tXQke1hCP4wlgdRf0
         5HX95g51uPseo0+nFjTTF2PR1JjCHWrLLpUzFZYeFAbo1JoMD8a17o+GGMvHl+PKhat+
         l/uMpPTaRajd7H8iACtsfOyNCo6Td/JG4FvjTmoEsl+F4rfAT/MD34dsRPHeZjSR7RkP
         BBRdAhyiLjoi5tHbTD2NQOclMK0esAxezvnR2mMICCqC0BZuZJUkqHLQC084nW96WXF3
         14EfLu58GyE8MKxe8cNl1fASHtfj5wRcCQk2iiishUDfEIOJ+29yhqunDEzgFo5eH/Zg
         Lcjw==
Content-Disposition: inline
In-Reply-To: <20210419000032.5432-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <>

On Sun, Apr 18, 2021 at 08:00:31PM -0400, Waiman Long wrote:
> Currently, the object stock structure caches either reclaimable vmstat
> bytes or unreclaimable vmstat bytes in its object stock structure. The
> hit rate can be improved if both types of vmstat data can be cached
> especially for single-node system.
> 
> This patch supports the cacheing of both type of vmstat data, though
> at the expense of a slightly increased complexity in the caching code.
> For large object (>= PAGE_SIZE), vmstat array is done directly without
> going through the stock caching step.
> 
> On a 2-socket Cascade Lake server with instrumentation enabled, the
> miss rates are shown in the table below.
> 
>   Initial bootup:
> 
>   Kernel       __mod_objcg_state    mod_objcg_state    %age
>   ------       -----------------    ---------------    ----
>   Before patch      634400              3243830        19.6%
>   After patch       419810              3182424        13.2%
> 
>   Parallel kernel build:
> 
>   Kernel       __mod_objcg_state    mod_objcg_state    %age
>   ------       -----------------    ---------------    ----
>   Before patch      24329265           142512465       17.1%
>   After patch       24051721           142445825       16.9%
> 
> There was a decrease of miss rate after initial system bootup. However,
> the miss rate for parallel kernel build remained about the same probably
> because most of the touched kmemcache objects were reclaimable inodes
> and dentries.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 79 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 51 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c13502eab282..a6dd18f6d8a8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2212,8 +2212,8 @@ struct obj_stock {
>  	struct obj_cgroup *cached_objcg;
>  	struct pglist_data *cached_pgdat;
>  	unsigned int nr_bytes;
> -	int vmstat_idx;
> -	int vmstat_bytes;
> +	int reclaimable_bytes;		/* NR_SLAB_RECLAIMABLE_B */
> +	int unreclaimable_bytes;	/* NR_SLAB_UNRECLAIMABLE_B */

How about

	int nr_slab_reclaimable_b;
	int nr_slab_unreclaimable_b;

so you don't need the comments?

>  #else
>  	int dummy[0];
>  #endif
> @@ -3217,40 +3217,56 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  		     enum node_stat_item idx, int nr)
>  {
>  	unsigned long flags;
> -	struct obj_stock *stock = get_obj_stock(&flags);
> +	struct obj_stock *stock;
> +	int *bytes, *alt_bytes, alt_idx;
> +
> +	/*
> +	 * Directly update vmstat array for big object.
> +	 */
> +	if (unlikely(abs(nr) >= PAGE_SIZE))
> +		goto update_vmstat;

This looks like an optimization independent of the vmstat item split?

> +	stock = get_obj_stock(&flags);
> +	if (idx == NR_SLAB_RECLAIMABLE_B) {
> +		bytes = &stock->reclaimable_bytes;
> +		alt_bytes = &stock->unreclaimable_bytes;
> +		alt_idx = NR_SLAB_UNRECLAIMABLE_B;
> +	} else {
> +		bytes = &stock->unreclaimable_bytes;
> +		alt_bytes = &stock->reclaimable_bytes;
> +		alt_idx = NR_SLAB_RECLAIMABLE_B;
> +	}
>  
>  	/*
> -	 * Save vmstat data in stock and skip vmstat array update unless
> -	 * accumulating over a page of vmstat data or when pgdat or idx
> +	 * Try to save vmstat data in stock and skip vmstat array update
> +	 * unless accumulating over a page of vmstat data or when pgdat
>  	 * changes.
>  	 */
>  	if (stock->cached_objcg != objcg) {
>  		/* Output the current data as is */
> -	} else if (!stock->vmstat_bytes) {
> -		/* Save the current data */
> -		stock->vmstat_bytes = nr;
> -		stock->vmstat_idx = idx;
> -		stock->cached_pgdat = pgdat;
> -		nr = 0;
> -	} else if ((stock->cached_pgdat != pgdat) ||
> -		   (stock->vmstat_idx != idx)) {
> -		/* Output the cached data & save the current data */
> -		swap(nr, stock->vmstat_bytes);
> -		swap(idx, stock->vmstat_idx);
> +	} else if (stock->cached_pgdat != pgdat) {
> +		/* Save the current data and output cached data, if any */
> +		swap(nr, *bytes);
>  		swap(pgdat, stock->cached_pgdat);
> +		if (*alt_bytes) {
> +			__mod_objcg_state(objcg, pgdat, alt_idx,
> +					  *alt_bytes);
> +			*alt_bytes = 0;
> +		}

As per the other email, I really don't think optimizing the pgdat
switch (in a percpu cache) is worth this level of complexity.

>  	} else {
> -		stock->vmstat_bytes += nr;
> -		if (abs(stock->vmstat_bytes) > PAGE_SIZE) {
> -			nr = stock->vmstat_bytes;
> -			stock->vmstat_bytes = 0;
> +		*bytes += nr;
> +		if (abs(*bytes) > PAGE_SIZE) {
> +			nr = *bytes;
> +			*bytes = 0;
>  		} else {
>  			nr = 0;
>  		}
>  	}
> -	if (nr)
> -		__mod_objcg_state(objcg, pgdat, idx, nr);
> -
>  	put_obj_stock(flags);
> +	if (!nr)
> +		return;
> +update_vmstat:
> +	__mod_objcg_state(objcg, pgdat, idx, nr);
>  }
>  
>  static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
> @@ -3303,12 +3319,19 @@ static void drain_obj_stock(struct obj_stock *stock)
>  	/*
>  	 * Flush the vmstat data in current stock
>  	 */
> -	if (stock->vmstat_bytes) {
> -		__mod_objcg_state(old, stock->cached_pgdat, stock->vmstat_idx,
> -				  stock->vmstat_bytes);
> +	if (stock->reclaimable_bytes || stock->unreclaimable_bytes) {
> +		int bytes;
> +
> +		if ((bytes = stock->reclaimable_bytes))
> +			__mod_objcg_state(old, stock->cached_pgdat,
> +					  NR_SLAB_RECLAIMABLE_B, bytes);
> +		if ((bytes = stock->unreclaimable_bytes))
> +			__mod_objcg_state(old, stock->cached_pgdat,
> +					  NR_SLAB_UNRECLAIMABLE_B, bytes);

The int bytes indirection isn't necessary. It's easier to read even
with the extra lines required to repeat the long stock member names,
because that is quite a common pattern (if (stuff) frob(stuff)).

__mod_objcg_state() also each time does rcu_read_lock() toggling and a
memcg lookup that could be batched, which I think is further proof
that it should just be inlined here.
