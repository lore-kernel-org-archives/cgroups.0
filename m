From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Mon, 21 May 2012 20:22:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=2LvqMex1iHh4Ufk7S3KDKLxYBTw3p51UyPnht4raYt8=;
        b=KnAQEDyS7j0+NvPoXqE1FCviAeYpflnku0+1ZEmoXrV7nOFPnmBcFqiEAUqxIXmjLu
         9Aw/NSSBq/0l7k+xYzZKRb5cEegGJQmaOjIk2zx2KelNU+afbYAOW2iMZCfz/CYIF/zv
         gswQzPx/tP8xVsAaJ7tDhK3KKsMsjtV+I7kJyg4uMf9oje+qS8/dZ6Z8n/WPL1InZ03o
         hxp+9byYnxyAJrB1xm7EkYH2gQTBwcHCgtDqIwvdP3tGx7eZrnhO6Et+Kq7OPHbeAJxm
         pJqRxK8HlyOtElUvK01xCoIXObq7YnaEryiXRfF9745M4n2P3UehIC7Oh3tsSxRN+csl
         4DqA==
In-Reply-To: <1337613539-29108-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On Mon, 21 May 2012, Glauber Costa wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index e901a36..cabd217 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>  			kfree(l3);
>  		}
>  	}
> +	kfree(cachep->name);
>  	kmem_cache_free(&cache_cache, cachep);
>  }
>  
> @@ -2526,9 +2527,14 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>  	}
>  	cachep->ctor = ctor;
> -	cachep->name = name;
>  
> -	if (setup_cpu_cache(cachep, gfp)) {
> +	/* Can't do strdup while kmalloc is not up */
> +	if (g_cpucache_up > EARLY)
> +		cachep->name = kstrdup(name, GFP_KERNEL);
> +	else
> +		cachep->name = name;
> +
> +	if (!cachep->name || setup_cpu_cache(cachep, gfp)) {
>  		__kmem_cache_destroy(cachep);
>  		cachep = NULL;
>  		goto oops;

This doesn't work if you kmem_cache_destroy() a cache that was created 
when g_cpucache_cpu <= EARLY, the kfree() will explode.  That never 
happens for any existing cache created in kmem_cache_init(), but this 
would introduce the first roadblock in doing so.  So you'll need some 
magic to determine whether the cache was allocated statically and suppress 
the kfree() in such a case.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
