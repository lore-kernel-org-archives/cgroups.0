From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Optimize user context object stock
 access
Date: Thu, 15 Apr 2021 13:53:27 -0400
Message-ID: <YHh9l1+TUIzzFBtO@cmpxchg.org>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-6-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=INGh5k1Yj8szNl1l5Z8qYaD8P6YvvcJTSCldK0t4pLE=;
        b=q+VO14PGTuNSIxED5tGGeUakeYctoqOQ0nJkbh0Vvp7quHEzTPE5abUN2YsdznM5oi
         mXTFT434TbT7mysw7yWGazDjFqRq+YmsxrjpomEQAuHY96tmqCLoZt7lqa4LSklgrn9e
         uRS8Dp45ihliK04vKKPAdld1KQQ8qm+2NHe3vYYeu4UyWirtudNSFErs29T78GJ5CPjs
         wWwqc/PKCWJfxwTi5zqIU7TqrW6iJZcOQST2Om59t0knllllekcuN9GVeodH7qf/zBjG
         vlkhN+abb/sMuFNbNaCiRCTNmyGsiuzKUuCtDMAtF/1y4UXWAHmF0/mC0tMCBJ0rIwiC
         psKQ==
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-6-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linux.intel.com>

On Tue, Apr 13, 2021 at 09:20:27PM -0400, Waiman Long wrote:
> Most kmem_cache_alloc() calls are from user context. With instrumentation
> enabled, the measured amount of kmem_cache_alloc() calls from non-task
> context was about 0.01% of the total.
> 
> The irq disable/enable sequence used in this case to access content
> from object stock is slow.  To optimize for user context access, there
> are now two object stocks for task context and interrupt context access
> respectively.
> 
> The task context object stock can be accessed after disabling preemption
> which is cheap in non-preempt kernel. The interrupt context object stock
> can only be accessed after disabling interrupt. User context code can
> access interrupt object stock, but not vice versa.
> 
> The mod_objcg_state() function is also modified to make sure that memcg
> and lruvec stat updates are done with interrupted disabled.
> 
> The downside of this change is that there are more data stored in local
> object stocks and not reflected in the charge counter and the vmstat
> arrays.  However, this is a small price to pay for better performance.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

This makes sense, and also explains the previous patch a bit
better. But please merge those two.

> @@ -2229,7 +2229,8 @@ struct obj_stock {
>  struct memcg_stock_pcp {
>  	struct mem_cgroup *cached; /* this never be root cgroup */
>  	unsigned int nr_pages;
> -	struct obj_stock obj;
> +	struct obj_stock task_obj;
> +	struct obj_stock irq_obj;
>  
>  	struct work_struct work;
>  	unsigned long flags;
> @@ -2254,11 +2255,48 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  }
>  #endif
>  
> +/*
> + * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
> + * sequence used in this case to access content from object stock is slow.
> + * To optimize for user context access, there are now two object stocks for
> + * task context and interrupt context access respectively.
> + *
> + * The task context object stock can be accessed by disabling preemption only
> + * which is cheap in non-preempt kernel. The interrupt context object stock
> + * can only be accessed after disabling interrupt. User context code can
> + * access interrupt object stock, but not vice versa.
> + */
>  static inline struct obj_stock *current_obj_stock(void)
>  {
>  	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
>  
> -	return &stock->obj;
> +	return in_task() ? &stock->task_obj : &stock->irq_obj;
> +}
> +
> +#define get_obj_stock(flags)				\
> +({							\
> +	struct memcg_stock_pcp *stock;			\
> +	struct obj_stock *obj_stock;			\
> +							\
> +	if (in_task()) {				\
> +		preempt_disable();			\
> +		(flags) = -1L;				\
> +		stock = this_cpu_ptr(&memcg_stock);	\
> +		obj_stock = &stock->task_obj;		\
> +	} else {					\
> +		local_irq_save(flags);			\
> +		stock = this_cpu_ptr(&memcg_stock);	\
> +		obj_stock = &stock->irq_obj;		\
> +	}						\
> +	obj_stock;					\
> +})
> +
> +static inline void put_obj_stock(unsigned long flags)
> +{
> +	if (flags == -1L)
> +		preempt_enable();
> +	else
> +		local_irq_restore(flags);
>  }

Please make them both functions and use 'unsigned long *flags'.

Also I'm not sure doing in_task() twice would actually be more
expensive than the == -1 special case, and easier to understand.

> @@ -2327,7 +2365,9 @@ static void drain_local_stock(struct work_struct *dummy)
>  	local_irq_save(flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
> -	drain_obj_stock(&stock->obj);
> +	drain_obj_stock(&stock->irq_obj);
> +	if (in_task())
> +		drain_obj_stock(&stock->task_obj);
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  
> @@ -3183,7 +3223,7 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
>  	memcg = obj_cgroup_memcg(objcg);
>  	if (pgdat)
>  		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	__mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
> +	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
>  	rcu_read_unlock();

This is actually a bug introduced in the earlier patch, isn't it?
Calling __mod_memcg_lruvec_state() without irqs disabled...
