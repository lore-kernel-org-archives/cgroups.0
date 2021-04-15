From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Optimize user context object stock
 access
Date: Thu, 15 Apr 2021 14:16:17 -0400
Message-ID: <8dbd3505-9c51-362f-82d8-5efa5773e020@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-6-longman@redhat.com> <YHh9l1+TUIzzFBtO@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618510582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1h8IZFi1Z3bjnp2kfdUz2arusyoZa29FI3VehSm75Y=;
        b=QjGb/L9dpr42TbC4egnSBcenVmkuoqSpoL+R96RGnAPci93jyExuSzel05ybC+oppUQRJl
        vls2E9hyc6Va4J1IYcp7Z9hBp7d/e9atSackf3Go3Qxa6rCBiCTpoWUi9um4XtdqbPk1sQ
        ewZT3HnU68muMyAggbPGipbw1wyTnHQ=
In-Reply-To: <YHh9l1+TUIzzFBtO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/15/21 1:53 PM, Johannes Weiner wrote:
> On Tue, Apr 13, 2021 at 09:20:27PM -0400, Waiman Long wrote:
>> Most kmem_cache_alloc() calls are from user context. With instrumentation
>> enabled, the measured amount of kmem_cache_alloc() calls from non-task
>> context was about 0.01% of the total.
>>
>> The irq disable/enable sequence used in this case to access content
>> from object stock is slow.  To optimize for user context access, there
>> are now two object stocks for task context and interrupt context access
>> respectively.
>>
>> The task context object stock can be accessed after disabling preemption
>> which is cheap in non-preempt kernel. The interrupt context object stock
>> can only be accessed after disabling interrupt. User context code can
>> access interrupt object stock, but not vice versa.
>>
>> The mod_objcg_state() function is also modified to make sure that memcg
>> and lruvec stat updates are done with interrupted disabled.
>>
>> The downside of this change is that there are more data stored in local
>> object stocks and not reflected in the charge counter and the vmstat
>> arrays.  However, this is a small price to pay for better performance.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> This makes sense, and also explains the previous patch a bit
> better. But please merge those two.
The reason I broke it into two is so that the patches are individually 
easier to review. I prefer to update the commit log of patch 4 to 
explain why the obj_stock structure is introduced instead of merging the 
two.
>
>> @@ -2229,7 +2229,8 @@ struct obj_stock {
>>   struct memcg_stock_pcp {
>>   	struct mem_cgroup *cached; /* this never be root cgroup */
>>   	unsigned int nr_pages;
>> -	struct obj_stock obj;
>> +	struct obj_stock task_obj;
>> +	struct obj_stock irq_obj;
>>   
>>   	struct work_struct work;
>>   	unsigned long flags;
>> @@ -2254,11 +2255,48 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>>   }
>>   #endif
>>   
>> +/*
>> + * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
>> + * sequence used in this case to access content from object stock is slow.
>> + * To optimize for user context access, there are now two object stocks for
>> + * task context and interrupt context access respectively.
>> + *
>> + * The task context object stock can be accessed by disabling preemption only
>> + * which is cheap in non-preempt kernel. The interrupt context object stock
>> + * can only be accessed after disabling interrupt. User context code can
>> + * access interrupt object stock, but not vice versa.
>> + */
>>   static inline struct obj_stock *current_obj_stock(void)
>>   {
>>   	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
>>   
>> -	return &stock->obj;
>> +	return in_task() ? &stock->task_obj : &stock->irq_obj;
>> +}
>> +
>> +#define get_obj_stock(flags)				\
>> +({							\
>> +	struct memcg_stock_pcp *stock;			\
>> +	struct obj_stock *obj_stock;			\
>> +							\
>> +	if (in_task()) {				\
>> +		preempt_disable();			\
>> +		(flags) = -1L;				\
>> +		stock = this_cpu_ptr(&memcg_stock);	\
>> +		obj_stock = &stock->task_obj;		\
>> +	} else {					\
>> +		local_irq_save(flags);			\
>> +		stock = this_cpu_ptr(&memcg_stock);	\
>> +		obj_stock = &stock->irq_obj;		\
>> +	}						\
>> +	obj_stock;					\
>> +})
>> +
>> +static inline void put_obj_stock(unsigned long flags)
>> +{
>> +	if (flags == -1L)
>> +		preempt_enable();
>> +	else
>> +		local_irq_restore(flags);
>>   }
> Please make them both functions and use 'unsigned long *flags'.
Sure, I can do that.
>
> Also I'm not sure doing in_task() twice would actually be more
> expensive than the == -1 special case, and easier to understand.
I can make that change too. Either way is fine with me.
>
>> @@ -2327,7 +2365,9 @@ static void drain_local_stock(struct work_struct *dummy)
>>   	local_irq_save(flags);
>>   
>>   	stock = this_cpu_ptr(&memcg_stock);
>> -	drain_obj_stock(&stock->obj);
>> +	drain_obj_stock(&stock->irq_obj);
>> +	if (in_task())
>> +		drain_obj_stock(&stock->task_obj);
>>   	drain_stock(stock);
>>   	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>>   
>> @@ -3183,7 +3223,7 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
>>   	memcg = obj_cgroup_memcg(objcg);
>>   	if (pgdat)
>>   		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>> -	__mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
>> +	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
>>   	rcu_read_unlock();
> This is actually a bug introduced in the earlier patch, isn't it?
> Calling __mod_memcg_lruvec_state() without irqs disabled...
>
Not really, in patch 3, mod_objcg_state() is called only in the stock 
update context where interrupt had already been disabled. But now, that 
is no longer the case, that is why i need to update mod_objcg_state() to 
make sure irq is disabled before updating vmstat data array.

Cheers,
Longman

