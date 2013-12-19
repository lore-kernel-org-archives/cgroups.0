From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/6] memcg, slab: cleanup barrier usage when accessing
 memcg_caches
Date: Thu, 19 Dec 2013 13:53:17 +0400
Message-ID: <52B2C20D.1030302@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <bd0a7ffc57e4a0b0c3d456c0cf8801e829e14717.1387372122.git.vdavydov@parallels.com> <20131218171411.GD31080@dhcp22.suse.cz> <52B29427.9010909@parallels.com> <20131219091007.GC9331@dhcp22.suse.cz> <52B2B951.5080809@parallels.com> <20131219092137.GG9331@dhcp22.suse.cz> <52B2BC97.4010506@parallels.com> <20131219093619.GA10855@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131219093619.GA10855-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 12/19/2013 01:36 PM, Michal Hocko wrote:
> On Thu 19-12-13 13:29:59, Vladimir Davydov wrote:
>> On 12/19/2013 01:21 PM, Michal Hocko wrote:
>>> On Thu 19-12-13 13:16:01, Vladimir Davydov wrote:
>>>> On 12/19/2013 01:10 PM, Michal Hocko wrote:
>>>>> On Thu 19-12-13 10:37:27, Vladimir Davydov wrote:
>>>>>> On 12/18/2013 09:14 PM, Michal Hocko wrote:
>>>>>>> On Wed 18-12-13 17:16:54, Vladimir Davydov wrote:
>>>>>>>> First, in memcg_create_kmem_cache() we should issue the write barrier
>>>>>>>> after the kmem_cache is initialized, but before storing the pointer to
>>>>>>>> it in its parent's memcg_params.
>>>>>>>>
>>>>>>>> Second, we should always issue the read barrier after
>>>>>>>> cache_from_memcg_idx() to conform with the write barrier.
>>>>>>>>
>>>>>>>> Third, its better to use smp_* versions of barriers, because we don't
>>>>>>>> need them on UP systems.
>>>>>>> Please be (much) more verbose on Why. Barriers are tricky and should be
>>>>>>> documented accordingly. So if you say that we should issue a barrier
>>>>>>> always be specific why we should do it.
>>>>>> In short, we have kmem_cache::memcg_params::memcg_caches is an array of
>>>>>> pointers to per-memcg caches. We access it lock-free so we should use
>>>>>> memory barriers during initialization. Obviously we should place a write
>>>>>> barrier just before we set the pointer in order to make sure nobody will
>>>>>> see a partially initialized structure. Besides there must be a read
>>>>>> barrier between reading the pointer and accessing the structure, to
>>>>>> conform with the write barrier. It's all that similar to rcu_assign and
>>>>>> rcu_deref. Currently the barrier usage looks rather strange:
>>>>>>
>>>>>> memcg_create_kmem_cache:
>>>>>>     initialize kmem
>>>>>>     set the pointer in memcg_caches
>>>>>>     wmb() // ???
>>>>>>
>>>>>> __memcg_kmem_get_cache:
>>>>>>     <...>
>>>>>>     read_barrier_depends() // ???
>>>>>>     cachep = root_cache->memcg_params->memcg_caches[memcg_id]
>>>>>>     <...>
>>>>> Why do we need explicit memory barriers when we can use RCU?
>>>>> __memcg_kmem_get_cache already dereferences within rcu_read_lock.
>>>> Because it's not RCU, IMO. RCU implies freeing the old version after a
>>>> grace period, while kmem_caches are freed immediately. We simply want to
>>>> be sure the kmem_cache is fully initialized. And we do not require
>>>> calling this in an RCU critical section.
>>> And you can use rcu_dereference and rcu_assign for that as well.
>> rcu_dereference() will complain if called outside an RCU critical
>> section, while cache_from_memcg_idx() is called w/o RCU protection from
>> some places.
> Does anything prevents us from using RCU from those callers as well?

Yes, take a look at kmem_cache_destroy_memcg_children(), for instance.
We call cancel_work_sync() there on a cache obtained via
cache_from_memcg_idx().

Thanks.
