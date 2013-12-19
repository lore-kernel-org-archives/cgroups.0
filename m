From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 3/6] memcg, slab: cleanup barrier usage when accessing
 memcg_caches
Date: Thu, 19 Dec 2013 13:16:01 +0400
Message-ID: <52B2B951.5080809@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <bd0a7ffc57e4a0b0c3d456c0cf8801e829e14717.1387372122.git.vdavydov@parallels.com> <20131218171411.GD31080@dhcp22.suse.cz> <52B29427.9010909@parallels.com> <20131219091007.GC9331@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131219091007.GC9331@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Glauber Costa <glommer@gmail.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On 12/19/2013 01:10 PM, Michal Hocko wrote:
> On Thu 19-12-13 10:37:27, Vladimir Davydov wrote:
>> On 12/18/2013 09:14 PM, Michal Hocko wrote:
>>> On Wed 18-12-13 17:16:54, Vladimir Davydov wrote:
>>>> First, in memcg_create_kmem_cache() we should issue the write barrier
>>>> after the kmem_cache is initialized, but before storing the pointer to
>>>> it in its parent's memcg_params.
>>>>
>>>> Second, we should always issue the read barrier after
>>>> cache_from_memcg_idx() to conform with the write barrier.
>>>>
>>>> Third, its better to use smp_* versions of barriers, because we don't
>>>> need them on UP systems.
>>> Please be (much) more verbose on Why. Barriers are tricky and should be
>>> documented accordingly. So if you say that we should issue a barrier
>>> always be specific why we should do it.
>> In short, we have kmem_cache::memcg_params::memcg_caches is an array of
>> pointers to per-memcg caches. We access it lock-free so we should use
>> memory barriers during initialization. Obviously we should place a write
>> barrier just before we set the pointer in order to make sure nobody will
>> see a partially initialized structure. Besides there must be a read
>> barrier between reading the pointer and accessing the structure, to
>> conform with the write barrier. It's all that similar to rcu_assign and
>> rcu_deref. Currently the barrier usage looks rather strange:
>>
>> memcg_create_kmem_cache:
>>     initialize kmem
>>     set the pointer in memcg_caches
>>     wmb() // ???
>>
>> __memcg_kmem_get_cache:
>>     <...>
>>     read_barrier_depends() // ???
>>     cachep = root_cache->memcg_params->memcg_caches[memcg_id]
>>     <...>
> Why do we need explicit memory barriers when we can use RCU?
> __memcg_kmem_get_cache already dereferences within rcu_read_lock.

Because it's not RCU, IMO. RCU implies freeing the old version after a
grace period, while kmem_caches are freed immediately. We simply want to
be sure the kmem_cache is fully initialized. And we do not require
calling this in an RCU critical section.

> Btw. cache_from_memcg_idx is desperately asking for a comment about
> required locking.

Actually, I placed a reference to the comment there ;-) but no problem,
I move it to cache_from_memcg_idx().

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
