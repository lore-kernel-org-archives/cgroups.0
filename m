From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 14:31:28 -0400
Message-ID: <4e4b6903-2444-f4ed-f589-26d5beae3120@redhat.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
 <235f45b4-2d99-f32d-ac2b-18b59fea5a25@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620239495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iZZoApOePTacyMEHxFVuuuLNE5NT9++VAw5gEmX09no=;
        b=ilnuFycs6bStZQjDdmkK5zXPburUYFAfaVme3f/odPCOx7e3xrOCCs/7lee8XNxX4kEo3w
        8+TT9XxkekzgdlPi4irQjvsxY6gz1h61OF3sZlmKItvSqHRt3ZvXW5l358PnTO2IC51aJF
        zCozo36+ULii6eNpOdmi2t8b1aFlUUs=
In-Reply-To: <235f45b4-2d99-f32d-ac2b-18b59fea5a25-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 2:02 PM, Vlastimil Babka wrote:
> On 5/5/21 7:30 PM, Roman Gushchin wrote:
>> On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
>>> With this change, all the objcg pointer array objects will come from
>>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>>> both the recursive kfree() problem and non-freeable slab problem are
>>> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
>>> have mixed accounted and unaccounted objects, this will slightly reduce
>>> the number of objcg pointer arrays that need to be allocated and save
>>> a bit of memory.
>> Unfortunately the positive effect of this change will be likely
>> reversed by a lower utilization due to a larger number of caches.
>>
>> Btw, I wonder if we also need a change in the slab caches merging procedure?
>> KMALLOC_NORMAL caches should not be merged with caches which can potentially
>> include accounted objects.
> Good point. But looks like kmalloc* caches are extempt from all merging in
> create_boot_cache() via
>
> 	s->refcount = -1;       /* Exempt from merging for now */
>
> It wouldn't hurt though to create the kmalloc-cg-* caches with SLAB_ACCOUNT flag
> to prevent accidental merging in case the above is ever removed. It would also
> better reflect reality, and ensure that the array is allocated immediately with
> the page, AFAICS.
>
I am not sure if this is really true.

struct kmem_cache *__init create_kmalloc_cache(const char *name,
                 unsigned int size, slab_flags_t flags,
                 unsigned int useroffset, unsigned int usersize)
{
         struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);

         if (!s)
                 panic("Out of memory when creating slab %s\n", name);

         create_boot_cache(s, name, size, flags, useroffset, usersize);
         kasan_cache_create_kmalloc(s);
         list_add(&s->list, &slab_caches);
         s->refcount = 1;
         return s;
}

Even though refcount is set to -1 initially, it is set back to 1 
afterward. So merging can still happen AFAICS.

Cheers,
Longman

