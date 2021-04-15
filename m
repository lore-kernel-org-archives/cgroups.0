From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 5/5] mm/memcg: Optimize user context object stock
 access
Date: Thu, 15 Apr 2021 15:06:28 -0400
Message-ID: <d4d4de9b-5020-fe62-3709-bcd97e9b54ba@redhat.com>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-6-longman@redhat.com> <YHh9l1+TUIzzFBtO@cmpxchg.org>
 <8dbd3505-9c51-362f-82d8-5efa5773e020@redhat.com>
 <YHiLmxE9oCOfmbS3@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618513593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gEe76+1lfitRLX7ayQ138JdnojjAHhZEepE6oK4fMzM=;
        b=H67Muo1X73tlPmia4K7LglApEuG1s2zaApj3eA+e1bLPoY2vDLqovBatsNJ2gPs4FCBX5f
        3zHO7uRxEjPLDuJcLrW/2LlPK8VBAj6W6ZI9u+NpaRZRogJd8AEGWXPpRgXNTM2/8VSMl4
        W2KweDrwHJGG5ICPwclJkX+acPy/w5c=
In-Reply-To: <YHiLmxE9oCOfmbS3-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On 4/15/21 2:53 PM, Johannes Weiner wrote:
> On Thu, Apr 15, 2021 at 02:16:17PM -0400, Waiman Long wrote:
>> On 4/15/21 1:53 PM, Johannes Weiner wrote:
>>> On Tue, Apr 13, 2021 at 09:20:27PM -0400, Waiman Long wrote:
>>>> Most kmem_cache_alloc() calls are from user context. With instrumentation
>>>> enabled, the measured amount of kmem_cache_alloc() calls from non-task
>>>> context was about 0.01% of the total.
>>>>
>>>> The irq disable/enable sequence used in this case to access content
>>>> from object stock is slow.  To optimize for user context access, there
>>>> are now two object stocks for task context and interrupt context access
>>>> respectively.
>>>>
>>>> The task context object stock can be accessed after disabling preemption
>>>> which is cheap in non-preempt kernel. The interrupt context object stock
>>>> can only be accessed after disabling interrupt. User context code can
>>>> access interrupt object stock, but not vice versa.
>>>>
>>>> The mod_objcg_state() function is also modified to make sure that memcg
>>>> and lruvec stat updates are done with interrupted disabled.
>>>>
>>>> The downside of this change is that there are more data stored in local
>>>> object stocks and not reflected in the charge counter and the vmstat
>>>> arrays.  However, this is a small price to pay for better performance.
>>>>
>>>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>>>> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> This makes sense, and also explains the previous patch a bit
>>> better. But please merge those two.
>> The reason I broke it into two is so that the patches are individually
>> easier to review. I prefer to update the commit log of patch 4 to explain
>> why the obj_stock structure is introduced instead of merging the two.
> Well I did not find them easier to review separately.
>
>>>> @@ -2327,7 +2365,9 @@ static void drain_local_stock(struct work_struct *dummy)
>>>>    	local_irq_save(flags);
>>>>    	stock = this_cpu_ptr(&memcg_stock);
>>>> -	drain_obj_stock(&stock->obj);
>>>> +	drain_obj_stock(&stock->irq_obj);
>>>> +	if (in_task())
>>>> +		drain_obj_stock(&stock->task_obj);
>>>>    	drain_stock(stock);
>>>>    	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>>>> @@ -3183,7 +3223,7 @@ static inline void mod_objcg_state(struct obj_cgroup *objcg,
>>>>    	memcg = obj_cgroup_memcg(objcg);
>>>>    	if (pgdat)
>>>>    		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>> -	__mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
>>>> +	mod_memcg_lruvec_state(memcg, lruvec, idx, nr);
>>>>    	rcu_read_unlock();
>>> This is actually a bug introduced in the earlier patch, isn't it?
>>> Calling __mod_memcg_lruvec_state() without irqs disabled...
>>>
>> Not really, in patch 3, mod_objcg_state() is called only in the stock update
>> context where interrupt had already been disabled. But now, that is no
>> longer the case, that is why i need to update mod_objcg_state() to make sure
>> irq is disabled before updating vmstat data array.
> Oh, I see it now. Man, that's subtle. We've had several very hard to
> track down preemption bugs in those stats, because they manifest as
> counter imbalances and you have no idea if there is a leak somewhere.
>
> The convention for these functions is that the __ prefix indicates
> that preemption has been suitably disabled. Please always follow this
> convention, even if the semantic change is temporary.
I see. I will fix that in the next version.
>
> Btw, is there a reason why the stock caching isn't just part of
> mod_objcg_state()? Why does the user need to choose if they want the
> caching or not? It's not like we ask for this when charging, either.
>
Yes, I can revert it to make mod_objcg_state() to call 
mod_obj_stock_state() internally instead of the other way around.

Cheers,
Longman

