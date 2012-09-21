From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
Date: Fri, 21 Sep 2012 13:31:55 +0400
Message-ID: <505C340B.4020009@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-16-git-send-email-glommer@parallels.com> <CAAmzW4NyK6gqqXHttUE35=-=h0Eve-smiYJCj3i+mHFFysQE4A@mail.gmail.com> <505C27E4.90509@parallels.com> <CAAmzW4PRPBgySUpNsj=RP6VR3KLcVWv3G7rRtX=r+wiWUTDchw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAmzW4PRPBgySUpNsj=RP6VR3KLcVWv3G7rRtX=r+wiWUTDchw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: JoonSoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/21/2012 01:28 PM, JoonSoo Kim wrote:
> Hi, Glauber.
> 
>>> 2012/9/18 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index 0b68d15..9d79216 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -2602,6 +2602,7 @@ redo:
>>>>         } else
>>>>                 __slab_free(s, page, x, addr);
>>>>
>>>> +       kmem_cache_verify_dead(s);
>>>>  }
>>>
>>> As far as u know, I am not a expert and don't know anything about memcg.
>>> IMHO, this implementation may hurt system performance in some case.
>>>
>>> In case of memcg is destoried, remained kmem_cache is marked "dead".
>>> After it is marked,
>>> every free operation to this "dead" kmem_cache call
>>> kmem_cache_verify_dead() and finally call kmem_cache_shrink().
>>
>> As long as it is restricted to that cache, this is a non issue.
>> dead caches are exactly what they name imply: dead.
>>
>> Means that we actively want them to go away, and just don't kill them
>> right away because they have some inflight objects - which we expect not
>> to be too much.
> 
> Hmm.. I don't think so.
> We can destroy memcg whenever we want, is it right?

wrong.

it is impossible to track objects to a task, so when tasks are moved,
objects stay. Which means that some objects are still referenced by the
cache.
> If it is right, there is many inflight objects when we destory memcg.
> If there is so many inflight objects, performance of these processes
> can be hurt too much.
> 
There are in-flight objects. It is not expected to have "many inflight
objects", which is a different statement.

We are assuming all the time that the workloads that goes into a cgroup
are mostly nature. When it goes away, most of the objects that were
referenced are expected to go away. Because we can't guarantee all of
them will, the references stay.

When we are able to call shrink_slab() directly on a memcg slab, which
is WIP, we'll be able make those objects even rarer.

>>> And, I found one case that destroying memcg's kmem_cache don't works properly.
>>> If we destroy memcg after all object is freed, current implementation
>>> doesn't destroy kmem_cache.
>>> kmem_cache_destroy_work_func() check "cachep->memcg_params.nr_pages == 0",
>>> but in this case, it return false, because kmem_cache may have
>>> cpu_slab, and cpu_partials_slabs.
>>> As we already free all objects, kmem_cache_verify_dead() is not invoked forever.
>>> I think that we need another kmem_cache_shrink() in
>>> kmem_cache_destroy_work_func().
>>
>> I'll take a look here. What you describe makes sense, and can
>> potentially happen. I tried to handle this case with care in
>> destroy_all_caches, but I may have always made a mistake...
>>
>> Did you see this actively happening, or are you just assuming this can
>> happen from your read of the code?
> 
> Just read of the code.
> 

I will go through it again, just in case. This is indeed subtle and it
is in my best interest to sort out those issues early.

