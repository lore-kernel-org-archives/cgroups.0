From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 01/29] slab: dup name string
Date: Wed, 16 May 2012 10:12:04 +0400
Message-ID: <4FB34534.3070306@parallels.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-2-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205151502000.18595@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1205151502000.18595-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 05/16/2012 02:04 AM, David Rientjes wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index e901a36..91b9c13 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>>   			kfree(l3);
>>   		}
>>   	}
>> +	kfree(cachep->name);
>>   	kmem_cache_free(&cache_cache, cachep);
>>   }
>>
>> @@ -2526,7 +2527,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>   		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>>   	}
>>   	cachep->ctor = ctor;
>> -	cachep->name = name;
>> +	cachep->name = kstrdup(name, GFP_KERNEL);
>>
>>   	if (setup_cpu_cache(cachep, gfp)) {
>>   		__kmem_cache_destroy(cachep);
>
> Couple problems:
>
>   - allocating memory for a string of an unknown, unchecked size, and
>
>   - could potentially return NULL which I suspect will cause problems
>     later.

Well, this is what slub does.

I sent already two patches for it: One removing this from the slub, one 
adding this to the slab.

Right now I am comfortable with this one, because it makes it slightly 
easier in the latest patches of my series.

But note the word: slightest.

I am comfortable with any, provided slub and slab start behaving the same.

So whatever you guys decide between yourselves is fine, provided there 
is a decision.

Thanks for your review, David!
