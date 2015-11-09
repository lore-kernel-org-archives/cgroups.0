From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 22:27:47 +0300
Message-ID: <20151109192747.GN31308@esperanza>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
 <20151109185401.GB28507@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109185401.GB28507-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 09, 2015 at 01:54:01PM -0500, Tejun Heo wrote:
> On Mon, Nov 09, 2015 at 09:28:40PM +0300, Vladimir Davydov wrote:
> > > I am _all_ for this semantic I am just not sure what to do with the
> > > legacy kmem controller. Can we change its semantic? If we cannot do that
> > 
> > I think we can. If somebody reports a "bug" caused by this change, i.e.
> > basically notices that something that used to be accounted is not any
> > longer, it will be trivial to fix by adding __GFP_ACCOUNT where
> > appropriate. If it is not, e.g. if accounting of objects of a particular
> > type leads to intense false-sharing, we would end up disabling
> > accounting for it anyway.
> 
> I agree too, if anything is meaningfully broken by the flip, it just
> indicates that the whitelist needs to be expanded; however, I wonder
> whether this would be done better at slab level rather than per
> allocation site.

I'd like to, but this is not as simple as it seems at first glance. The
problem is that slab caches of the same size are actively merged with
each other. If we just added SLAB_ACCOUNT flag, which would be passed to
kmem_cache_create to enable accounting, we'd divide all caches into two
groups that couldn't be merged with each other even if kmem accounting
was not used at all. This would be a show stopper.

Of course, we could rework slab merging so that kmem_cache_create
returned a new dummy cache even if it was actually merged. Such a cache
would point to the real cache, which would be used for allocations. This
wouldn't limit slab merging, but this would add one more dereference to
alloc path, which is even worse.

That's why I decided to go with marking individual allocations.

Thanks,
Vladimir
