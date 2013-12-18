From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [Devel] Race in memcg kmem?
Date: Wed, 18 Dec 2013 11:51:30 +0400
Message-ID: <52B15402.4060907@parallels.com>
References: <52A71E43.9040200@parallels.com> <CAA6-i6oyraHQ7_1GBKxgupS12_QFx708Niu93nyNFLrbQBXE5A@mail.gmail.com> <52A8048E.4020806@parallels.com> <20131212132113.GG2630@dhcp22.suse.cz> <52A9BC91.5020105@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52A9BC91.5020105-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12/12/2013 05:39 PM, Vladimir Davydov wrote:
> On 12/12/2013 05:21 PM, Michal Hocko wrote:
>> On Wed 11-12-13 10:22:06, Vladimir Davydov wrote:
>>> On 12/11/2013 03:13 AM, Glauber Costa wrote:
>>>> On Tue, Dec 10, 2013 at 5:59 PM, Vladimir Davydov
>> [...]
>>>>> -- memcg_update_cache_size(s, num_groups) --
>>>>> grows s->memcg_params to accomodate data for num_groups memcg's
>>>>> @s is the root cache whose memcg_params we want to grow
>>>>> @num_groups is the new number of kmem-active cgroups (defines the new
>>>>> size of memcg_params array).
>>>>>
>>>>> The function:
>>>>>
>>>>> B1) allocates and assigns a new cache:
>>>>>     cur_params = s->memcg_params;
>>>>>     s->memcg_params = kzalloc(size, GFP_KERNEL);
>>>>>
>>>>> B2) copies per-memcg cache ptrs from the old memcg_params array to the
>>>>> new one:
>>>>>     for (i = 0; i < memcg_limited_groups_array_size; i++) {
>>>>>         if (!cur_params->memcg_caches[i])
>>>>>             continue;
>>>>>         s->memcg_params->memcg_caches[i] =
>>>>>                     cur_params->memcg_caches[i];
>>>>>     }
>>>>>
>>>>> B3) frees the old array:
>>>>>     kfree(cur_params);
>>>>>
>>>>>
>>>>> Since these two functions do not share any mutexes, we can get the
>>>> They do share a mutex, the slab mutex.
>> Worth sticking in a lock_dep_assert?
> AFAIU, lockdep_assert_held() is not applicable here:
> memcg_create_kmem_cache() is called w/o the slab_mutex held, but it
> calls kmem_cache_create_kmemcg(), which takes and releases this mutex,
> working as a barrier. Placing lockdep_assert_held() into the latter
> won't make things any clearer. IMO, we need a big good comment in
> memcg_create_kmem_cache() proving its correctness.

After a bit of thinking on the comment explaining why the race is
impossible I seem to have found another one in these two functions.

Assume two threads schedule kmem_cache creation works for the same
kmem_cache of the same memcg from __memcg_kmem_get_cache(). One of the
works successfully creates it. Another work should fail then, but if it
interleaves with memcg_update_cache_size() as follows, it does not:

memcg_create_kmem_cache()                       memcg_update_cache_size()
(called w/o mutexes held)                       (called with slab_mutex
held)
-------------------------                       -------------------------
mutex_lock(&memcg_cache_mutex)
                                                s->memcg_params=kzalloc(...)
new_cachep=cache_from_memcg_idx(cachep,idx)
// new_cachep==NULL => proceed to creation
                                                // initialize
s->memcg_params;
                                                // sets s->memcg_params
                                                //       
->memcg_caches[idx]
new_cachep = kmem_cache_dup(memcg, cachep)
// nothing prevents kmem_cache_dup from
// succeeding so ...
cachep->memcg_params->memcg_caches[idx]=new_cachep
// we've overwritten an existing cache ptr!

slab_mutex won't help here...

Anyway, I'm going to move check and initialization of memcg_caches[idx]
from memcg_create_kmem_cache() to kmem_cache_create_memcg() under the
slab_mutex eliminating every possibility of race there. Will send the
patch soon.

Thanks.
