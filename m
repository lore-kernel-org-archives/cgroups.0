From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of kmalloc-cg-<n>
 caches
Date: Wed, 5 May 2021 19:06:24 -0400
Message-ID: <95ab4bdf-f373-f71d-cdf5-05ad6edbb772@redhat.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
 <235f45b4-2d99-f32d-ac2b-18b59fea5a25@suse.cz>
 <YJLk1tmDeGed58yr@carbon.dhcp.thefacebook.com>
 <f73cc1c6-2950-c56d-6a57-8cebb23db65b@suse.cz>
 <YJMZ+542NVnbWgat@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620255988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2UtSfp8BrCUffF0CdlLACo8aqMI+/YAkO0AYQU2b30=;
        b=NA4FDRR7YR9+lvxBSwDmvobyBDqmrOSoy6dhUCKj4Qh/H5bskuWuNoekxIHut3zN29+mqK
        4sKvARzHc75hFmpFZwZ6T77jt7o29cMNEMNUTPs3rmTy5odpXRkJrtpiTNv/pFwu1br5Ed
        Wd0iGvk/WEb5DDsC+DyVopEBd7WMTSI=
In-Reply-To: <YJMZ+542NVnbWgat-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 6:19 PM, Roman Gushchin wrote:
> On Wed, May 05, 2021 at 11:29:54PM +0200, Vlastimil Babka wrote:
>> On 5/5/21 8:32 PM, Roman Gushchin wrote:
>>> On Wed, May 05, 2021 at 08:02:06PM +0200, Vlastimil Babka wrote:
>>>> On 5/5/21 7:30 PM, Roman Gushchin wrote:
>>>>> On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
>>>>>> With this change, all the objcg pointer array objects will come from
>>>>>> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
>>>>>> both the recursive kfree() problem and non-freeable slab problem are
>>>>>> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
>>>>>> have mixed accounted and unaccounted objects, this will slightly reduce
>>>>>> the number of objcg pointer arrays that need to be allocated and save
>>>>>> a bit of memory.
>>>>> Unfortunately the positive effect of this change will be likely
>>>>> reversed by a lower utilization due to a larger number of caches.
>>>>>
>>>>> Btw, I wonder if we also need a change in the slab caches merging procedure?
>>>>> KMALLOC_NORMAL caches should not be merged with caches which can potentially
>>>>> include accounted objects.
>>>> Good point. But looks like kmalloc* caches are extempt from all merging in
>>>> create_boot_cache() via
>>>>
>>>> 	s->refcount = -1;       /* Exempt from merging for now */
>>> Wait, s->refcount is adjusted to 1 in create_kmalloc_cache() after calling
>>> into create_boot_cache?
>> Hmm I missed that
>>
>> Now I wonder why all kmalloc caches on my system have 0 aliases :)
>> cat /sys/kernel/slab/kmalloc-*/aliases
> Yeah, I noticed it too, it's a good question. And I remember a case from
> the past when it wasn't true (kmalloc-32 was shared with something else).
>
The criteria for cache merging require close to exact match in all 
attributes with a size difference of no more than sizeof(void *). So it 
is not easy to find a close match.

Cheers,
Longman

