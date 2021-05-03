From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 2/2] mm: memcg/slab: Don't create unfreeable slab
Date: Mon, 3 May 2021 16:15:11 -0400
Message-ID: <59afa489-3db5-3881-92a4-59b5ee82fc1b@redhat.com>
References: <20210502180755.445-1-longman@redhat.com>
 <20210502180755.445-2-longman@redhat.com>
 <699e5ac8-9044-d664-f73f-778fe72fd09b@suse.cz>
 <4c90cf79-9c61-8964-a6fd-2da087893339@redhat.com>
 <d767ff72-711d-976c-d897-9cea0375c827@suse.cz>
 <CALvZod4aW0P2a5ZG4JO4YH2oQ8a1kM9_Tsjz-tAGP_-9hLyOpw@mail.gmail.com>
 <fc59cce6-71af-890e-030c-46357e0f0343@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620072915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqgS52YwzVDVjfWlq3e547UMU0Zz7FIEHtvfbJqFZ2w=;
        b=WTbIqySH2Rk2Il6xqti2JkZKxvQhSwdDKyRIYiAXLPaPRvZoFaSnYVeXFQONnw11JUs+a0
        qcr67AEUwrUwGJmcKK97woxFLJUqJaYiOJtNpLMPrPgQ7Q/djL9sWJyNxxzDX0lAFNk41E
        6ypCUlOwfNBAwsQxCxTG2UKNZDMKZMw=
In-Reply-To: <fc59cce6-71af-890e-030c-46357e0f0343@redhat.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <llong@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Roman Gushchin <guro@fb.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On 5/3/21 1:21 PM, Waiman Long wrote:
> On 5/3/21 12:24 PM, Shakeel Butt wrote:
>> On Mon, May 3, 2021 at 8:32 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>> On 5/3/21 4:20 PM, Waiman Long wrote:
>>>> On 5/3/21 8:22 AM, Vlastimil Babka wrote:
>>>>> On 5/2/21 8:07 PM, Waiman Long wrote:
>>>>>> The obj_cgroup array (memcg_data) embedded in the page structure is
>>>>>> allocated at the first instance an accounted memory allocation=20
>>>>>> happens.
>>>>>> With the right size object, it is possible that the allocated=20
>>>>>> obj_cgroup
>>>>>> array comes from the same slab that requires memory accounting.=20
>>>>>> If this
>>>>>> happens, the slab will never become empty again as there is at=20
>>>>>> least one
>>>>>> object left (the obj_cgroup array) in the slab.
>>>>>>
>>>>>> With instructmentation code added to detect this situation, I got 76
>>>>>> hits on the kmalloc-192 slab when booting up a test kernel on a VM.
>>>>>> So this can really happen.
>>>>>>
>>>>>> To avoid the creation of these unfreeable slabs, a check is added to
>>>>>> memcg_alloc_page_obj_cgroups() to detect that and double the size
>>>>>> of the array in case it happens to make sure that it comes from a
>>>>>> different kmemcache.
>>>>>>
>>>>>> This change, however, does not completely eliminate the presence
>>>>>> of unfreeable slabs which can still happen if a circular obj_cgroup
>>>>>> array dependency is formed.
>>>>> Hm this looks like only a half fix then.
>>>>> I'm afraid the proper fix is for kmemcg to create own set of=20
>>>>> caches for the
>>>>> arrays. It would also solve the recursive kfree() issue.
>>>> Right, this is a possible solution. However, the objcg pointers=20
>>>> array should
>>>> need that much memory. Creating its own set of kmemcaches may seem=20
>>>> like an
>>>> overkill.
>>> Well if we go that way, there might be additional benefits:
>>>
>>> depending of gfp flags, kmalloc() would allocate from:
>>>
>>> kmalloc-* caches that never have kmemcg objects, thus can be used=20
>>> for the objcg
>>> pointer arrays
>>> kmalloc-cg-* caches that have only kmemcg unreclaimable objects
>>> kmalloc-rcl-* and dma-kmalloc-* can stay with on-demand
>>> memcg_alloc_page_obj_cgroups()
>>>
>>> This way we fully solve the issues that this patchset solves. In=20
>>> addition we get
>>> better separation between kmemcg and !kmemcg thus save memory - no=20
>>> allocation of
>>> the array as soon as a single object appears in slab. For=20
>>> "kmalloc-8" we now
>>> have 8 bytes for the useful data and 8 bytes for the obj_cgroup=C2=A0=20
>>> pointer.
>>>
>> Yes this seems like a better approach.
>>
> OK, I will try to go this route then if there is no objection from=20
> others.
>
> From slabinfo, the objs/slab numbers range from 4-512. That means we=20
> need kmalloc-cg-{32,64,128,256,512,1k,2k,4k}. A init function to set=20
> up the new kmemcaches and an allocation function that use the proper=20
> kmemcaches to allocate from.=20

I think I had misinterpreted the kmalloc-* setup. In this case, the=20
kmalloc-cg-* should have the same set of sizes as kmalloc-*.

Cheers,
Longman

