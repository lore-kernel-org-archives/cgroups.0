From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcg/slab: Don't create unfreeable slab
Date: Mon, 3 May 2021 17:32:24 +0200
Message-ID: <d767ff72-711d-976c-d897-9cea0375c827@suse.cz>
References: <20210502180755.445-1-longman@redhat.com>
 <20210502180755.445-2-longman@redhat.com>
 <699e5ac8-9044-d664-f73f-778fe72fd09b@suse.cz>
 <4c90cf79-9c61-8964-a6fd-2da087893339@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4c90cf79-9c61-8964-a6fd-2da087893339-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/3/21 4:20 PM, Waiman Long wrote:
> On 5/3/21 8:22 AM, Vlastimil Babka wrote:
>> On 5/2/21 8:07 PM, Waiman Long wrote:
>>> The obj_cgroup array (memcg_data) embedded in the page structure is
>>> allocated at the first instance an accounted memory allocation happens.
>>> With the right size object, it is possible that the allocated obj_cgroup
>>> array comes from the same slab that requires memory accounting. If this
>>> happens, the slab will never become empty again as there is at least one
>>> object left (the obj_cgroup array) in the slab.
>>>
>>> With instructmentation code added to detect this situation, I got 76
>>> hits on the kmalloc-192 slab when booting up a test kernel on a VM.
>>> So this can really happen.
>>>
>>> To avoid the creation of these unfreeable slabs, a check is added to
>>> memcg_alloc_page_obj_cgroups() to detect that and double the size
>>> of the array in case it happens to make sure that it comes from a
>>> different kmemcache.
>>>
>>> This change, however, does not completely eliminate the presence
>>> of unfreeable slabs which can still happen if a circular obj_cgroup
>>> array dependency is formed.
>> Hm this looks like only a half fix then.
>> I'm afraid the proper fix is for kmemcg to create own set of caches for the
>> arrays. It would also solve the recursive kfree() issue.
> 
> Right, this is a possible solution. However, the objcg pointers array should
> need that much memory. Creating its own set of kmemcaches may seem like an
> overkill.

Well if we go that way, there might be additional benefits:

depending of gfp flags, kmalloc() would allocate from:

kmalloc-* caches that never have kmemcg objects, thus can be used for the objcg
pointer arrays
kmalloc-cg-* caches that have only kmemcg unreclaimable objects
kmalloc-rcl-* and dma-kmalloc-* can stay with on-demand
memcg_alloc_page_obj_cgroups()

This way we fully solve the issues that this patchset solves. In addition we get
better separation between kmemcg and !kmemcg thus save memory - no allocation of
the array as soon as a single object appears in slab. For "kmalloc-8" we now
have 8 bytes for the useful data and 8 bytes for the obj_cgroup  pointer.

Vlastimil

> Cheers,
> Longman
> 

