From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/7] per-cgroup slab caches
Date: Wed, 22 Feb 2012 18:08:06 +0400
Message-ID: <4F44F6C6.8060302@parallels.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com> <1329824079-14449-4-git-send-email-glommer@parallels.com> <CABCjUKAmjGS1j6kNgj8it_QZSPKJiCmgpme6BTxAGkoJ=DSR7w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKAmjGS1j6kNgj8it_QZSPKJiCmgpme6BTxAGkoJ=DSR7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On 02/22/2012 03:50 AM, Suleiman Souhlal wrote:
> On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 26fda11..2aa35b0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> +struct kmem_cache *
>> +kmem_cache_dup(struct mem_cgroup *memcg, struct kmem_cache *base)
>> +{
>> +       struct kmem_cache *s;
>> +       unsigned long pages;
>> +       struct res_counter *fail;
>> +       /*
>> +        * TODO: We should use an ida-like index here, instead
>> +        * of the kernel address
>> +        */
>> +       char *kname = kasprintf(GFP_KERNEL, "%s-%p", base->name, memcg);
>
> Would it make more sense to use the memcg name instead of the pointer?

Well, yes. But at this point in creation time, we still don't have this 
all setup. The css pointer is NULL, so I could not derive the name from 
it. Instead of keep fighting what seemed to be a minor issue, I opted to 
kick the patches out and be clear with a comment that this is not what I 
intend in the way.

Do you know about any good way to grab the cgroup name at create() time ?

>> +
>> +       WARN_ON(mem_cgroup_is_root(memcg));
>> +
>> +       if (!kname)
>> +               return NULL;
>> +
>> +       s = kmem_cache_create_cg(memcg, kname, base->size,
>> +                                base->align, base->flags, base->ctor);
>> +       if (WARN_ON(!s))
>> +               goto out;
>> +
>> +
>> +       pages = slab_nr_pages(s);
>> +
>> +       if (res_counter_charge(memcg_kmem(memcg), pages<<  PAGE_SHIFT,&fail)) {
>> +               kmem_cache_destroy(s);
>> +               s = NULL;
>> +       }
>
> What are we charging here? Does it ever get uncharged?

We're charging the slab initial pages, that comes from allocations 
outside allocate_slab(). But in this sense, it is not very different 
than tin foil hats to protect against mind reading. Probably works, but 
I am not sure the threat is real (also remembering we can probably want 
to port it to the original slab allocator later - and let me be honest - 
I know 0 about how that works).

So if the slab starts with 0 pages, this is a nop. If in any case it 
does not, it gets uncharged when the cgroup is destroyed.

In all my tests, this played no role. If we can be sure that this won't 
be an issue, I'll be happy to remove it.

