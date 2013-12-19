From: Vasily Averin <vvs@parallels.com>
Subject: Re: [Devel] [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
Date: Thu, 19 Dec 2013 12:17:00 +0400
Message-ID: <52B2AB7C.1010803@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@gmail.com>, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org

On 12/18/2013 05:16 PM, Vladimir Davydov wrote:
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
>  	get_online_cpus();
>  	mutex_lock(&slab_mutex);
>  
> -	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
> -		goto out_locked;
> +	err = kmem_cache_sanity_check(memcg, name, size);
> +	if (err)
> +		goto out_unlock;
>  
>  	/*
>  	 * Some allocators will constraint the set of valid flags to a subset

Theoretically in future kmem_cache_sanity_check() can return positive value.
Probably it's better to check (err < 0) in caller ?

Thank you,
	Vasily Averin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
