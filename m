From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Date: Wed, 4 Dec 2013 15:17:08 +0000
Message-ID: <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org> <1381265890-11333-2-git-send-email-hannes@cmpxchg.org> <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org> <20131204015218.GA19709@lge.com>
 <20131203180717.94c013d1.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131203180717.94c013d1.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Casteyde <casteyde.christian-GANU6spQydw@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 3 Dec 2013, Andrew Morton wrote:

> >  	page = alloc_slab_page(alloc_gfp, node, oo);
> >  	if (unlikely(!page)) {
> >  		oo = s->min;
>
> What is the value of s->min?  Please tell me it's zero.

It usually is.

> > @@ -1349,7 +1350,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
> >  		int pages = 1 << oo_order(oo);
> >
> > -		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
> > +		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
>
> That seems reasonable, assuming kmemcheck can handle the allocation
> failure.
>
>
> Still I dislike this practice of using unnecessarily large allocations.
> What does it gain us?  Slightly improved object packing density.
> Anything else?

The fastpath for slub works only within the bounds of a single slab page.
Therefore a larger frame increases the number of allocation possible from
the fastpath without having to use the slowpath and also reduces the
management overhead in the partial lists.

There is a kernel parameter that can be used to control the maximum order

	slub_max_order

The default is PAGE_ALLOC_COSTLY_ORDER. See also
Documentation/vm/slub.txt.

Booting with slub_max_order=1 will force order 0/1 pages.
