From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Date: Tue, 3 Dec 2013 18:07:17 -0800
Message-ID: <20131203180717.94c013d1.akpm@linux-foundation.org>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
	<1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
	<20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org>
	<20131204015218.GA19709@lge.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131204015218.GA19709-Hm3cg6mZ9cc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Casteyde <casteyde.christian-GANU6spQydw@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On Wed, 4 Dec 2013 10:52:18 +0900 Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org> wrote:

> SLUB already try to allocate high order page with clearing __GFP_NOFAIL.
> But, when allocating shadow page for kmemcheck, it missed clearing
> the flag. This trigger WARN_ON_ONCE() reported by Christian Casteyde.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=65991
> 
> This patch fix this situation by using same allocation flag as original
> allocation.
> 
> Reported-by: Christian Casteyde <casteyde.christian-GANU6spQydw@public.gmane.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 545a170..3dd28b1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1335,11 +1335,12 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	page = alloc_slab_page(alloc_gfp, node, oo);
>  	if (unlikely(!page)) {
>  		oo = s->min;

What is the value of s->min?  Please tell me it's zero.

> +		alloc_gfp = flags;
>  		/*
>  		 * Allocation may have failed due to fragmentation.
>  		 * Try a lower order alloc if possible
>  		 */
> -		page = alloc_slab_page(flags, node, oo);
> +		page = alloc_slab_page(alloc_gfp, node, oo);
>  
>  		if (page)
>  			stat(s, ORDER_FALLBACK);

This change doesn't actually do anything.

> @@ -1349,7 +1350,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>  		int pages = 1 << oo_order(oo);
>  
> -		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
> +		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);

That seems reasonable, assuming kmemcheck can handle the allocation
failure.


Still I dislike this practice of using unnecessarily large allocations.
What does it gain us?  Slightly improved object packing density. 
Anything else?
