From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 14:11:52 -0400
Message-ID: <f14a263b-10ea-ef2b-eefa-066591a4b637@redhat.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620238316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nw/NXWJf7YefMV4xFftmS9WnDS1NhKlaE8hzMyBIij0=;
        b=Ja9IWhvqR+R7g0HFM0Rot7+v4B9/Vnr+Q3gJqLhjodJ6G8kIhen2LvT4GL0QI2hdSp8Rrr
        fTmQrz1DXlygp4CVYbJp5hPze+BqWhQXsAvahBVgX3FGTexniw3YMBN5q6/dxsS9n9N+lN
        1FahD9MjAUzeAmYwtyahpSYNZVvP8tg=
In-Reply-To: <YJLWN6bNBYyKRPEN-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 1:30 PM, Roman Gushchin wrote:
> On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
>> There are currently two problems in the way the objcg pointer array
>> (memcg_data) in the page structure is being allocated and freed.
>>
>> On its allocation, it is possible that the allocated objcg pointer
>> array comes from the same slab that requires memory accounting. If this
>> happens, the slab will never become empty again as there is at least
>> one object left (the obj_cgroup array) in the slab.
>>
>> When it is freed, the objcg pointer array object may be the last one
>> in its slab and hence causes kfree() to be called again. With the
>> right workload, the slab cache may be set up in a way that allows the
>> recursive kfree() calling loop to nest deep enough to cause a kernel
>> stack overflow and panic the system.
>>
>> One way to solve this problem is to split the kmalloc-<n> caches
>> (KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
>> (KMALLOC_NORMAL) caches for non-accounted objects only and a new set of
>> kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
>> the other caches can still allow a mix of accounted and non-accounted
>> objects.
> I agree that it's likely the best approach here. Thanks for discovering
> and fixing the problem!
>
>> With this change, all the objcg pointer array objects will come from
>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>> both the recursive kfree() problem and non-freeable slab problem are
>> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
>> have mixed accounted and unaccounted objects, this will slightly reduce
>> the number of objcg pointer arrays that need to be allocated and save
>> a bit of memory.
> Unfortunately the positive effect of this change will be likely
> reversed by a lower utilization due to a larger number of caches.

That is also true, will mention that.

>
> Btw, I wonder if we also need a change in the slab caches merging procedure?
> KMALLOC_NORMAL caches should not be merged with caches which can potentially
> include accounted objects.

Thank for catching this omission.

I will take a look and modify the merging procedure in a new patch. 
Accounting is usually specified at kmem_cache_create() time. Though, I 
did find one instance of setting ACCOUNT flag in kmem_cache_alloc(), I 
will ignore this case and merge accounted, but unreclaimable caches to 
KMALLOC_CGROUP.

>
>> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
>> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
>> will include the newly added caches without change.
>>
>> Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   include/linux/slab.h | 42 ++++++++++++++++++++++++++++++++++--------
>>   mm/slab_common.c     | 23 +++++++++++++++--------
>>   2 files changed, 49 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 0c97d788762c..f2d9ebc34f5c 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -305,9 +305,16 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>>   /*
>>    * Whenever changing this, take care of that kmalloc_type() and
>>    * create_kmalloc_caches() still work as intended.
>> + *
>> + * KMALLOC_NORMAL is for non-accounted objects only whereas KMALLOC_CGROUP
>> + * is for accounted objects only. All the other kmem caches can have both
>> + * accounted and non-accounted objects.
>>    */
>>   enum kmalloc_cache_type {
>>   	KMALLOC_NORMAL = 0,
>> +#ifdef CONFIG_MEMCG_KMEM
>> +	KMALLOC_CGROUP,
>> +#endif
>>   	KMALLOC_RECLAIM,
>>   #ifdef CONFIG_ZONE_DMA
>>   	KMALLOC_DMA,
>> @@ -315,28 +322,47 @@ enum kmalloc_cache_type {
>>   	NR_KMALLOC_TYPES
>>   };
>>   
>> +#ifndef CONFIG_MEMCG_KMEM
>> +#define KMALLOC_CGROUP	KMALLOC_NORMAL
>> +#endif
>> +#ifndef CONFIG_ZONE_DMA
>> +#define KMALLOC_DMA	KMALLOC_NORMAL
>> +#endif
>> +
>>   #ifndef CONFIG_SLOB
>>   extern struct kmem_cache *
>>   kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
>>   
>> +/*
>> + * Define gfp bits that should not be set for KMALLOC_NORMAL.
>> + */
>> +#define KMALLOC_NOT_NORMAL_BITS					\
>> +	(__GFP_RECLAIMABLE |					\
>> +	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
>> +	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
>> +
>>   static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
>>   {
>> -#ifdef CONFIG_ZONE_DMA
>>   	/*
>>   	 * The most common case is KMALLOC_NORMAL, so test for it
>>   	 * with a single branch for both flags.
>>   	 */
>> -	if (likely((flags & (__GFP_DMA | __GFP_RECLAIMABLE)) == 0))
>> +	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
>>   		return KMALLOC_NORMAL;
> Likely KMALLOC_CGROUP is also very popular, so maybe we want to change the
> optimization here a bit.

I doubt this optimization is really noticeable and whether 
KMALLOC_CGROUP is really popular will depend on the workloads. I am not 
planning to spend additional time to micro-optimize this part of the code.

Cheers,
Longman

