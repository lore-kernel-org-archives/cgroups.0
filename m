From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 19/23] slab: per-memcg accounting of slab caches
Date: Wed, 2 May 2012 12:40:37 -0300
Message-ID: <4FA15575.6020209@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-8-git-send-email-glommer@parallels.com> <CABCjUKCX6MvOaS5s_n6tYcmfyDCgW60aXTG8ZbznmZOAfS=joA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKCX6MvOaS5s_n6tYcmfyDCgW60aXTG8ZbznmZOAfS=joA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>


>> @@ -3834,11 +3866,15 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
>>   */
>>   void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>>   {
>> -       void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
>> +       void *ret;
>> +
>> +       rcu_read_lock();
>> +       cachep = mem_cgroup_get_kmem_cache(cachep, flags);
>> +       rcu_read_unlock();
>
> Don't we need to check in_interrupt(), current, __GFP_NOFAIL every
> time we call mem_cgroup_cgroup_get_kmem_cache()?
>
> I would personally prefer if those checks were put inside
> mem_cgroup_get_kmem_cache() instead of having to check for every
> caller.
>

in_interrupt() yes, __GFP_NOFAIL I don't think so.

__GFP_NOFAIL should lead to a res_counter_charge_nofail() in the end. 
The name similarity is no coincidence...

 From a code style PoV, it makes sense to bundle an in_interrupt() check 
here, but from a performance PoV, putting it in the callers can help us 
avoid the price of a function call.

But well, looking at the code, I see it is not there as well... =(

I plan to change memcontrol.h to look like this:

static __always_inline struct kmem_cache *
mem_cgroup_get_kmem_cache(struct kmem_cache *cachep, gfp_t gfp)
{
         if (mem_cgroup_kmem_on && current->mm && !in_interrupt())
                 return __mem_cgroup_get_kmem_cache(cachep, gfp);
         return cachep;
}


