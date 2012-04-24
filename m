From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 11/23] slub: consider a memcg parameter in
 kmem_create_cache
Date: Tue, 24 Apr 2012 16:03:31 +0200
Message-ID: <20120424140326.GA8626@somewhere>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
 <1334959051-18203-12-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gaIqYj20eNHxJIjOTeU2yNEb1AVgAAgre5WRCvZvtcg=;
        b=phA24AMIr23A36qGMdLduNf7NqG0yWbyf1wA5o7stNCK3jlziKDwDJu/G83wtVJSam
         t3IEomPeCsSL+RZez5ZhUr4yUcEwOhmM5w2nmnGzIaKkQuWzjyqMDP01QlNSUlLsja8s
         IBPNIERFbvhnYl6Fdq2fzBvdrPUhc2BzOcs+npKbgMLUiFIvMY8toc30qumuKsw4y6SV
         0AYG1X6Xrr2v2m3jSJgRgPBjP8oHwZjItmlxfF710NFqQyOVgi0YBHOa63ACdZ7eU0+I
         PAMeaNexaP6qUoyi4kfLs0VsSDjI/tIsCDxNeIu2s6flV1iDtEDSCZm/pkXI7yEVYHqb
         o0HQ==
Content-Disposition: inline
In-Reply-To: <1334959051-18203-12-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, Apr 20, 2012 at 06:57:19PM -0300, Glauber Costa wrote:
> diff --git a/mm/slub.c b/mm/slub.c
> index 2652e7c..86e40cc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -32,6 +32,7 @@
>  #include <linux/prefetch.h>
>  
>  #include <trace/events/kmem.h>
> +#include <linux/memcontrol.h>
>  
>  /*
>   * Lock order:
> @@ -3880,7 +3881,7 @@ static int slab_unmergeable(struct kmem_cache *s)
>  	return 0;
>  }
>  
> -static struct kmem_cache *find_mergeable(size_t size,
> +static struct kmem_cache *find_mergeable(struct mem_cgroup *memcg, size_t size,
>  		size_t align, unsigned long flags, const char *name,
>  		void (*ctor)(void *))
>  {
> @@ -3916,21 +3917,29 @@ static struct kmem_cache *find_mergeable(size_t size,
>  		if (s->size - size >= sizeof(void *))
>  			continue;
>  
> +		if (memcg && s->memcg_params.memcg != memcg)
> +			continue;
> +

This probably won't build without CONFIG_CGROUP_MEM_RES_CTLR_KMEM ?

>  		return s;
>  	}
>  	return NULL;
>  }
>  
> -struct kmem_cache *kmem_cache_create(const char *name, size_t size,
> -		size_t align, unsigned long flags, void (*ctor)(void *))
> +struct kmem_cache *
> +kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,

Does that build without CONFIG_CGROUP_MEM_RES_CTLR ?

> +			size_t align, unsigned long flags, void (*ctor)(void *))
>  {
>  	struct kmem_cache *s;
>  
>  	if (WARN_ON(!name))
>  		return NULL;
>  
> +#ifndef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +	WARN_ON(memcg != NULL);
> +#endif
> +
>  	down_write(&slub_lock);
> -	s = find_mergeable(size, align, flags, name, ctor);
> +	s = find_mergeable(memcg, size, align, flags, name, ctor);
>  	if (s) {
>  		s->refcount++;
>  		/*
> @@ -3954,12 +3963,15 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  				size, align, flags, ctor)) {
>  			list_add(&s->list, &slab_caches);
>  			up_write(&slub_lock);
> +			mem_cgroup_register_cache(memcg, s);

How do you handle when the memcg cgroup gets destroyed? Also that means only one
memcg cgroup can be accounted for a given slab cache? What if that memcg cgroup has
children? Hmm, perhaps this is handled in a further patch in the series, I saw a
patch title with "children" inside :)

Also my knowledge on memory allocators is near zero, so I may well be asking weird
questions...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
