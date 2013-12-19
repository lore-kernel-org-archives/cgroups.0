From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
Date: Thu, 19 Dec 2013 10:31:43 +0400
Message-ID: <52B292CF.5030002@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <20131218165603.GB31080@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131218165603.GB31080-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 12/18/2013 08:56 PM, Michal Hocko wrote:
> On Wed 18-12-13 17:16:52, Vladimir Davydov wrote:
>> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Dunno, is this really better to be worth the code churn?
>
> It even makes the generated code tiny bit bigger:
> text    data     bss     dec     hex filename
> 4355     171     236    4762    129a mm/slab_common.o.after
> 4342     171     236    4749    128d mm/slab_common.o.before
>
> Or does it make the further changes much more easier? Be explicit in the
> patch description if so.

Hi, Michal

IMO, undoing under labels looks better than inside conditionals, because
we don't have to repeat the same deinitialization code then, like this
(note three calls to kmem_cache_free()):

    s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
    if (s) {
        s->object_size = s->size = size;
        s->align = calculate_alignment(flags, align, size);
        s->ctor = ctor;

        if (memcg_register_cache(memcg, s, parent_cache)) {
            kmem_cache_free(kmem_cache, s);
            err = -ENOMEM;
            goto out_locked;
        }

        s->name = kstrdup(name, GFP_KERNEL);
        if (!s->name) {
            kmem_cache_free(kmem_cache, s);
            err = -ENOMEM;
            goto out_locked;
        }

        err = __kmem_cache_create(s, flags);
        if (!err) {
            s->refcount = 1;
            list_add(&s->list, &slab_caches);
            memcg_cache_list_add(memcg, s);
        } else {
            kfree(s->name);
            kmem_cache_free(kmem_cache, s);
        }
    } else
        err = -ENOMEM;

The next patch, which fixes the memcg_params leakage on error, would
make it even worse introducing two calls to memcg_free_cache_params()
after kstrdup and __kmem_cache_create.

If you think it isn't worthwhile applying this patch, just let me know,
I don't mind dropping it.

Anyway, I'll improve the comment and resend.

Thanks.

>
>> ---
>>  mm/slab_common.c |   66 +++++++++++++++++++++++++++---------------------------
>>  1 file changed, 33 insertions(+), 33 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 0b7bb39..5d6f743 100644
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
>> @@ -189,45 +190,41 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
>>  
>>  	s = __kmem_cache_alias(memcg, name, size, align, flags, ctor);
>>  	if (s)
>> -		goto out_locked;
>> +		goto out_unlock;
>>  
>>  	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
>> -	if (s) {
>> -		s->object_size = s->size = size;
>> -		s->align = calculate_alignment(flags, align, size);
>> -		s->ctor = ctor;
>> -
>> -		if (memcg_register_cache(memcg, s, parent_cache)) {
>> -			kmem_cache_free(kmem_cache, s);
>> -			err = -ENOMEM;
>> -			goto out_locked;
>> -		}
>> +	if (!s) {
>> +		err = -ENOMEM;
>> +		goto out_unlock;
>> +	}
>>  
>> -		s->name = kstrdup(name, GFP_KERNEL);
>> -		if (!s->name) {
>> -			kmem_cache_free(kmem_cache, s);
>> -			err = -ENOMEM;
>> -			goto out_locked;
>> -		}
>> +	s->object_size = s->size = size;
>> +	s->align = calculate_alignment(flags, align, size);
>> +	s->ctor = ctor;
>>  
>> -		err = __kmem_cache_create(s, flags);
>> -		if (!err) {
>> -			s->refcount = 1;
>> -			list_add(&s->list, &slab_caches);
>> -			memcg_cache_list_add(memcg, s);
>> -		} else {
>> -			kfree(s->name);
>> -			kmem_cache_free(kmem_cache, s);
>> -		}
>> -	} else
>> +	s->name = kstrdup(name, GFP_KERNEL);
>> +	if (!s->name) {
>>  		err = -ENOMEM;
>> +		goto out_free_cache;
>> +	}
>> +
>> +	err = memcg_register_cache(memcg, s, parent_cache);
>> +	if (err)
>> +		goto out_free_cache;
>>  
>> -out_locked:
>> +	err = __kmem_cache_create(s, flags);
>> +	if (err)
>> +		goto out_free_cache;
>> +
>> +	s->refcount = 1;
>> +	list_add(&s->list, &slab_caches);
>> +	memcg_cache_list_add(memcg, s);
>> +
>> +out_unlock:
>>  	mutex_unlock(&slab_mutex);
>>  	put_online_cpus();
>>  
>>  	if (err) {
>> -
>>  		if (flags & SLAB_PANIC)
>>  			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
>>  				name, err);
>> @@ -236,11 +233,14 @@ out_locked:
>>  				name, err);
>>  			dump_stack();
>>  		}
>> -
>>  		return NULL;
>>  	}
>> -
>>  	return s;
>> +
>> +out_free_cache:
>> +	kfree(s->name);
>> +	kmem_cache_free(kmem_cache, s);
>> +	goto out_unlock;
>>  }
>>  
>>  struct kmem_cache *
>> -- 
>> 1.7.10.4
>>
