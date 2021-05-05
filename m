From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 12:31:09 -0400
Message-ID: <a93ee868-24ed-73ad-543c-5fba19c934e8@redhat.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <4c1a0436-2d46-d23a-2eef-d558e37373bf@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620232274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81DdwLuppEsne8dGMXcwRqVz38oxfrnLdDs7rg3uPgM=;
        b=a65U/VOdhBbIQB/m3vpi+3wT15YOxGG0dzzRtZZfhBxSfaVgDcoAUOlb1pS/O8+Mr5gZhJ
        qzbT2w/eKZAStnpSXcpZ+lEQl9KlnOQjbX3WjHYnd/Ux0Rjz/3eoHwXeKadh0o3CnMAuUe
        MSzJtk2VTlPGq135IPYOqx0BuCQu9ao=
In-Reply-To: <4c1a0436-2d46-d23a-2eef-d558e37373bf-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 12:06 PM, Vlastimil Babka wrote:
> On 5/5/21 5:46 PM, Waiman Long wrote:
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
>>
>> With this change, all the objcg pointer array objects will come from
>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>> both the recursive kfree() problem and non-freeable slab problem are
>> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
>> have mixed accounted and unaccounted objects, this will slightly reduce
>> the number of objcg pointer arrays that need to be allocated and save
>> a bit of memory.
>>
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
> You could move this to the enum definition itself? E.g.:
>
> #ifdef CONFIG_MEMCG_KMEM
> 	KMALLOC_CGROUP,
> #else
> 	KMALLOC_CGROUP = KMALLOC_NORMAL,
> #endif
>
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
> Not "both flags" anymore. Something like "so test with a single branch that
> there are none of the flags that would select a different type"
Right. I just left the comment there without taking a deeper look. My bad.

Cheers,
Longman

