From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [Devel] [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
Date: Thu, 19 Dec 2013 12:39:00 +0400
Message-ID: <52B2B0A4.8050009@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <52B2AB7C.1010803@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B2AB7C.1010803-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12/19/2013 12:17 PM, Vasily Averin wrote:
> On 12/18/2013 05:16 PM, Vladimir Davydov wrote:
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
>>  	get_online_cpus();
>>  	mutex_lock(&slab_mutex);
>>  
>> -	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
>> -		goto out_locked;
>> +	err = kmem_cache_sanity_check(memcg, name, size);
>> +	if (err)
>> +		goto out_unlock;
>>  
>>  	/*
>>  	 * Some allocators will constraint the set of valid flags to a subset
> Theoretically in future kmem_cache_sanity_check() can return positive value.
> Probably it's better to check (err < 0) in caller ?

Hmm, why? What information could positive retval carry here? We have
plenty of places throughout the code where we check for (err), not
(err<0), simply because it looks clearer, e.g. look at
__kmem_cache_create() calls. If it returns a positive value one day, we
will have to parse every place where it's called. Anyway, if someone
wants to change a function behavior, he must check every place where
this function is called and fix them accordingly.

Thanks.
