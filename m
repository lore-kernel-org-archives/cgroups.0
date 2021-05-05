From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Tue, 4 May 2021 21:55:59 -0400
Message-ID: <26ef8e5d-3a72-324f-4ef9-ead8c6251e70@redhat.com>
References: <20210504132350.4693-1-longman@redhat.com>
 <20210504132350.4693-3-longman@redhat.com>
 <3c952b24-94e4-3c54-b668-cac778ff5a77@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620179764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XcTx3FgEa0ZtpV+h7gNoIIwMYnfs3k07HI6rrP4pOSc=;
        b=COprRlNYztG4D6fmRj4XbVBo1xqIMaa1V9HNtVvh+2S3W+3Se1SaTqz2MNpDHWpsW/PURo
        fjurJRG2+45Db0PlsrJjkas7LBdyteR3a2Ovpd0OSiTd/2+eMwTQeLaOwl7A1mhilHaNo6
        eAzGUlHmFgxBGRz5L6MaEZ7qgkNNUOg=
In-Reply-To: <3c952b24-94e4-3c54-b668-cac778ff5a77-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/4/21 12:01 PM, Vlastimil Babka wrote:
> On 5/4/21 3:23 PM, Waiman Long wrote:
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
>> the other caches can allow a mix of accounted and non-accounted objects.
>>
>> With this change, all the objcg pointer array objects will come from
>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>> both the recursive kfree() problem and non-freeable slab problem
>> are gone.
>>
>> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
>> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
>> will include the newly added caches without change.
> Great, thanks I hope there would be also benefits to objcg arrays not
> created for all the normal caches anymore (possibly poorly used due to
> mix of accounted and non-accounted objects in the same cache) and perhaps
> it's possible for you to quantify the reduction of those?
Right, I will update the commit log to mention that as well. Thanks!
>> Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ...
>
>> @@ -321,6 +328,14 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
>>   
>>   static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
>>   {
>> +#ifdef CONFIG_MEMCG_KMEM
>> +	/*
>> +	 * KMALLOC_CGROUP for non-reclaimable and non-DMA object with
>> +	 * accounting enabled.
>> +	 */
>> +	if ((flags & (__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)) == __GFP_ACCOUNT)
>> +		return KMALLOC_CGROUP;
>> +#endif
> This function was designed so that KMALLOC_NORMAL would be the first tested and
> returned possibility, as it's expected to be the most common. What about the
> following on top?
>
> ----8<----
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index fca03c22ea7c..418c5df0305b 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -328,30 +328,40 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
>   
>   static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
>   {
> -#ifdef CONFIG_MEMCG_KMEM
>   	/*
> -	 * KMALLOC_CGROUP for non-reclaimable and non-DMA object with
> -	 * accounting enabled.
> +	 * The most common case is KMALLOC_NORMAL, so test for it
> +	 * with a single branch for all flags that might affect it
>   	 */
> -	if ((flags & (__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)) == __GFP_ACCOUNT)
> -		return KMALLOC_CGROUP;
> +	if (likely((flags & (__GFP_RECLAIMABLE
> +#ifdef CONFIG_MEMCG_KMEM
> +			     | __GFP_ACCOUNT
>   #endif
>   #ifdef CONFIG_ZONE_DMA
> -	/*
> -	 * The most common case is KMALLOC_NORMAL, so test for it
> -	 * with a single branch for both flags.
> -	 */
> -	if (likely((flags & (__GFP_DMA | __GFP_RECLAIMABLE)) == 0))
> +			     | __GFP_DMA
> +#endif
> +			    )) == 0))
>   		return KMALLOC_NORMAL;
>   
> +#ifdef CONFIG_MEMCG_KMEM
>   	/*
> -	 * At least one of the flags has to be set. If both are, __GFP_DMA
> -	 * is more important.
> +	 * KMALLOC_CGROUP for non-reclaimable and non-DMA object with
> +	 * accounting enabled.
>   	 */
> -	return flags & __GFP_DMA ? KMALLOC_DMA : KMALLOC_RECLAIM;
> -#else
> -	return flags & __GFP_RECLAIMABLE ? KMALLOC_RECLAIM : KMALLOC_NORMAL;
> +	if ((flags & (__GFP_ACCOUNT | __GFP_RECLAIMABLE
> +#ifdef CONFIG_ZONE_DMApropose this to the customer as proposing this will create a lot of confusion
> +		      | __GFP_DMA
> +#endif
> +		     )) == __GFP_ACCOUNT)
> +		return KMALLOC_CGROUP;
>   #endif
> +
> +#ifdef CONFIG_ZONE_DMA
> +	if (flags & __GFP_DMA)
> +		return KMALLOC_DMA;
> +#endif
> +
> +	/* if we got here, it has to be __GFP_RECLAIMABLE */
> +	return KMALLOC_RECLAIM;
>   }
>   
>   /*
>
OK, I will make KMALLOC_NORMAL the first in the test. However the 
proposed change is a bit hard to read, so I will probably change it a bit.

Thanks,
Longman

