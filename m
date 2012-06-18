From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 00/25] kmem limitation for memcg
Date: Mon, 18 Jun 2012 16:14:35 +0400
Message-ID: <4FDF1BAB.9050205@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <4FDF1ABE.7070200@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDF1ABE.7070200-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/18/2012 04:10 PM, Kamezawa Hiroyuki wrote:
> (2012/06/18 19:27), Glauber Costa wrote:
>> Hello All,
>>
>> This is my new take for the memcg kmem accounting. This should merge
>> all of the previous comments from you guys, specially concerning the big churn
>> inside the allocators themselves.
>>
>> My focus in this new round was to keep the changes in the cache internals to
>> a minimum. To do that, I relied upon two main pillars:
>>
>>    * Cristoph's unification series, that allowed me to put must of the changes
>>      in a common file. Even then, the changes are not too many, since the overal
>>      level of invasiveness was decreased.
>>    * Accounting is done directly from the page allocator. This means some pages
>>      can fail to be accounted, but that can only happen when the task calling
>>      kmem_cache_alloc or kmalloc is not the same task allocating a new page.
>>      This never happens in steady state operation if the tasks are kept in the
>>      same memcg. Naturally, if the page ends up being accounted to a memcg that
>>      is not limited (such as root memcg), that particular page will simply not
>>      be accounted.
>>
>> The dispatcher code stays (mem_cgroup_get_kmem_cache), being the mechanism who
>> guarantees that, during steady state operation, all objects allocated in a page
>> will belong to the same memcg. I consider this a good compromise point between
>> strict and loose accounting here.
>>
> 
> 2 questions.
> 
>    - Do you have performance numbers ?

Not extensive. I've run some microbenchmarks trying to determine the
effect of my code on kmem_cache_alloc, and found it to be in the order
of 2 to 3 %. I would expect that to vanish in a workload benchmark.

> 
>    - Do you think user-memory memcg should be switched to page-allocator level accounting ?
>      (it will require some study for modifying current bached-freeing and per-cpu-stock
>       logics...)

I don't see a reason for that. My main goal by doing that was to reduce
the churn in the cache internal structures, but specially because there
is at least two of them, obeying a stable interface. The way I
understand it, memcg for user pages is already pretty well integrated to
the page allocator, so the benefit of it is questionable.
