From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] slub: Don't panic for memcg kmem cache creation failure
Date: Thu, 20 Jun 2019 07:50:28 +0200
Message-ID: <20190620055028.GA12083@dhcp22.suse.cz>
References: <20190619232514.58994-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190619232514.58994-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>

On Wed 19-06-19 16:25:14, Shakeel Butt wrote:
> Currently for CONFIG_SLUB, if a memcg kmem cache creation is failed and
> the corresponding root kmem cache has SLAB_PANIC flag, the kernel will
> be crashed. This is unnecessary as the kernel can handle the creation
> failures of memcg kmem caches.

AFAICS it will handle those by simply not accounting those objects
right?

> Additionally CONFIG_SLAB does not
> implement this behavior. So, to keep the behavior consistent between
> SLAB and SLUB, removing the panic for memcg kmem cache creation
> failures. The root kmem cache creation failure for SLAB_PANIC correctly
> panics for both SLAB and SLUB.

I do agree that panicing is really dubious especially because it opens
doors to shut the system down from a restricted environment. So the
patch makes sesne to me.

I am wondering whether SLAB_PANIC makes sense in general though. Why is
it any different from any other essential early allocations? We tend to
not care about allocation failures for those on bases that the system
must be in a broken state to fail that early already. Do you think it is
time to remove SLAB_PANIC altogether?

> Reported-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/slub.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6a5174b51cd6..84c6508e360d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3640,10 +3640,6 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
>  
>  	free_kmem_cache_nodes(s);
>  error:
> -	if (flags & SLAB_PANIC)
> -		panic("Cannot create slab %s size=%u realsize=%u order=%u offset=%u flags=%lx\n",
> -		      s->name, s->size, s->size,
> -		      oo_order(s->oo), s->offset, (unsigned long)flags);
>  	return -EINVAL;
>  }
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog

-- 
Michal Hocko
SUSE Labs
