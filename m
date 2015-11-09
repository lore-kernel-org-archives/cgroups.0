From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 23:12:18 +0300
Message-ID: <20151109201218.GP31308@esperanza>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
 <20151109185401.GB28507@mtj.duckdns.org>
 <20151109192747.GN31308@esperanza>
 <20151109193253.GC28507@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109193253.GC28507-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 09, 2015 at 02:32:53PM -0500, Tejun Heo wrote:
> On Mon, Nov 09, 2015 at 10:27:47PM +0300, Vladimir Davydov wrote:
> > Of course, we could rework slab merging so that kmem_cache_create
> > returned a new dummy cache even if it was actually merged. Such a cache
> > would point to the real cache, which would be used for allocations. This
> > wouldn't limit slab merging, but this would add one more dereference to
> > alloc path, which is even worse.
> 
> Hmmm, this could be me not really understanding but why can't we let
> all slabs to be merged regardless of SLAB_ACCOUNT flag for root memcg
> and point to per-memcg slabs (may be merged among them but most likely

Because we won't be able to distinguish kmem_cache_alloc calls that
should be accounted from those that shouldn't. The problem is if two
caches

	A = kmem_cache_create(...)

and

	B = kmem_cache_create(...)

happen to be merged, A and B will point to the same kmem_cache struct.
As a result, there is no way to distinguish

	kmem_cache_alloc(A)

which we want to account from

	kmem_cache_alloc(B)

which we don't.

> won't matter) for !root.  We're indirecting once anyway, no?

If kmem accounting is not used, we aren't indirecting. That's why I
don't think we can use dummy kmem_cache struct for merged caches, where
we could store __GFP_ACCOUNT flag.

Thanks,
Vladimir
