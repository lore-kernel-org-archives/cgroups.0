From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/4] memcg: unify force charging conditions
Date: Thu, 10 Feb 2022 12:03:12 -0800
Message-ID: <YgVvgCbbTrDPb5tT@carbon.dhcp.thefacebook.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
 <20220210081437.1884008-3-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QcUqs6tEqdHP+OehbZpd4QHEqKhTch9yyV5pMVi5Xa8=;
 b=p76Gr3iEMYyiTUi2aIrmik7e89wgRwQNNmyAr2hBf8pX5+5NQ2mT8+pUNgI5Ms0oFAA0
 ansWUN60XPHPqDHEpUO56WbYZigf3K33DYCOGj8bug2BA7RC/PJgBbwHke46pkbCaEyF
 AbiK4T5thPOIIooK/i2RM4c+sOLk5gej87A= 
Content-Disposition: inline
In-Reply-To: <20220210081437.1884008-3-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 10, 2022 at 12:14:35AM -0800, Shakeel Butt wrote:
> Currently the kernel force charges the allocations which have __GFP_HIGH
> flag without triggering the memory reclaim. __GFP_HIGH indicates that
> the caller is high priority and since commit 869712fd3de5 ("mm:
> memcontrol: fix network errors from failing __GFP_ATOMIC charges") the
> kernel let such allocations do force charging. Please note that
> __GFP_ATOMIC has been replaced by __GFP_HIGH.
> 
> __GFP_HIGH does not tell if the caller can block or can trigger reclaim.
> There are separate checks to determine that. So, there is no need to
> skip reclaim for __GFP_HIGH allocations. So, handle __GFP_HIGH together
> with __GFP_NOFAIL which also does force charging.

This sounds very reasonable. But shouldn't we check if __GFP_DIRECT_RECLAIM
is set and bail out otherwise?

Thanks!

> 
> Please note that this is a noop change as there are no __GFP_HIGH
> allocators in kernel which also have __GFP_ACCOUNT (or SLAB_ACCOUNT) and
> does not allow reclaim for now. The reason for this patch is to simplify
> the reasoning of the following patches.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c40c27822802..ae73a40818b0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2560,15 +2560,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> -	/*
> -	 * Memcg doesn't have a dedicated reserve for atomic
> -	 * allocations. But like the global atomic pool, we need to
> -	 * put the burden of reclaim on regular allocation requests
> -	 * and let these go through as privileged allocations.
> -	 */
> -	if (gfp_mask & __GFP_HIGH)
> -		goto force;
> -
>  	/*
>  	 * Prevent unbounded recursion when reclaim operations need to
>  	 * allocate memory. This might exceed the limits temporarily,
> @@ -2642,7 +2633,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  nomem:
> -	if (!(gfp_mask & __GFP_NOFAIL))
> +	/*
> +	 * Memcg doesn't have a dedicated reserve for atomic
> +	 * allocations. But like the global atomic pool, we need to
> +	 * put the burden of reclaim on regular allocation requests
> +	 * and let these go through as privileged allocations.
> +	 */
> +	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
>  	/*
> -- 
> 2.35.1.265.g69c8d7142f-goog
> 
