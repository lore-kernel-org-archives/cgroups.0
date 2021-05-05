From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/3] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 19:19:23 -0400
Message-ID: <e27561f4-75ac-77ae-de09-6c7d1cd96967@redhat.com>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210505200610.13943-3-longman@redhat.com>
 <935031de-f177-b49f-2a1d-2af2b519a270@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620256768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42NhY9pIv+uXlb41VZhPnr08pYEJ08Pi29tdv81LhX8=;
        b=Mp5X4gw9sAQN1MsvWogvUs6YaqvOl8JIcDFVZmwOEmDSRj6/uot3a43y2L1cgNl2qKrPl3
        ah30XGb9kbHYVXwZeV3eW+oTSzD9K3Zbc/3OCZLd4F//eufbbgtr+VwgSXzfnBqIbkvHPw
        Uw3EbOkobrfBkUF/6DOGwzv+PCwV0A0=
In-Reply-To: <935031de-f177-b49f-2a1d-2af2b519a270-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 5:41 PM, Vlastimil Babka wrote:
> On 5/5/21 10:06 PM, Waiman Long wrote:
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
>> (KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
>> kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
>> the other caches can still allow a mix of accounted and unaccounted
>> objects.
>>
>> With this change, all the objcg pointer array objects will come from
>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>> both the recursive kfree() problem and non-freeable slab problem are
>> gone.
>>
>> Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
>> mixed accounted and unaccounted objects, this will slightly reduce the
>> number of objcg pointer arrays that need to be allocated and save a bit
>> of memory. On the other hand, creating a new set of kmalloc caches does
>> have the effect of reducing cache utilization. So it is properly a wash.
>>
>> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
>> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
>> will include the newly added caches without change.
>>
>> Suggested-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> A last nitpick: the new caches -cg should perhaps not be created when
> cgroup_memory_nokmem == true because kmemcg was disabled by the respective boot
> param.
>
It is a nice to have feature. However, the nokmem kernel parameter isn't 
used that often. The cgroup_memory_nokmem variable is private to 
memcontrol.c and is not directly accessible. I will take a look on that, 
but it will be a follow-on patch. I am not planning to change the 
current patchset unless there are other issues coming up.

Cheers,
Longman

