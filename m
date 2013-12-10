From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Race in memcg kmem?
Date: Tue, 10 Dec 2013 17:59:31 +0400
Message-ID: <52A71E43.9040200@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hi,

Looking through the per-memcg kmem_cache initialization code, I have a
bad feeling that it is prone to a race. Before getting to fixing it, I'd
like to ensure this race is not only in my imagination. Here it goes.

We keep per-memcg kmem caches in the memcg_params field of each root
cache. The memcg_params array is grown dynamically by
memcg_update_cache_size(). I guess that if this function is executed
concurrently with memcg_create_kmem_cache() we can get a race resulting
in a memory leak.

-- memcg_create_kmem_cache(memcg, cachep) --
creates a new kmem_cache corresponding to a memcg and assigns it to the
root cache; called in the background - it is OK to have several such
functions trying to create a cache for the same memcg concurrently, but
only one of them should succeed.
@cachep is the root cache
@memcg is the memcg we want to create a cache for.

The function:

A1) assures there is no cache corresponding to the memcg (if it is we
have nothing to do):
    idx = memcg_cache_id(memcg);
    if (cachep->memcg_params[idx])
        goto out;

A2) creates and assigns a new cache:
    new_cachep = kmem_cache_dup(memcg, cachep);
    // init new_cachep
    cachep->memcg_params->memcg_caches[idx] = new_cachep;


-- memcg_update_cache_size(s, num_groups) --
grows s->memcg_params to accomodate data for num_groups memcg's
@s is the root cache whose memcg_params we want to grow
@num_groups is the new number of kmem-active cgroups (defines the new
size of memcg_params array).

The function:

B1) allocates and assigns a new cache:
    cur_params = s->memcg_params;
    s->memcg_params = kzalloc(size, GFP_KERNEL);

B2) copies per-memcg cache ptrs from the old memcg_params array to the
new one:
    for (i = 0; i < memcg_limited_groups_array_size; i++) {
        if (!cur_params->memcg_caches[i])
            continue;
        s->memcg_params->memcg_caches[i] =
                    cur_params->memcg_caches[i];
    }

B3) frees the old array:
    kfree(cur_params);


Since these two functions do not share any mutexes, we can get the
following race:

Assume, by the time Cpu0 gets to memcg_create_kmem_cache(), the memcg
cache has already been created by another thread, so this function
should do nothing.

Cpu0    Cpu1
----    ----
        B1
A1              we haven't initialized memcg_params yet so Cpu0 will
                proceed to A2 to alloc and assign a new cache
A2
        B2      Cpu1 rewrites the memcg cache ptr set by Cpu0 at A2
                - a memory leak?
        B3

I'd like to add that even if I'm right about the race, this is rather
not critical, because memcg_update_cache_sizes() is called very rarely.


BTW, it seems to me that the way we update memcg_params in
memcg_update_cache_size() make cache_from_memcg_idx() prone to
use-after-free:

> static inline struct kmem_cache *
> cache_from_memcg_idx(struct kmem_cache *s, int idx)
> {
>     if (!s->memcg_params)
>         return NULL;
>     return s->memcg_params->memcg_caches[idx];
> }

This is equivalent to

1) struct memcg_cache_params *params = s->memcg_params;
2) return params->memcg_caches[idx];

If memcg_update_cache_size() is executed between steps 1 and 2 on
another CPU, at step 2 we will dereference memcg_params that has already
been freed. This is very unlikely, but still possible. Perhaps, we
should free old memcg params only after a sync_rcu()?

Thanks.
