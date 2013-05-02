From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 17/31] drivers: convert shrinkers to new count/scan API
Date: Thu, 2 May 2013 10:37:44 +0100
Message-ID: <20130502093744.GJ11497@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-18-git-send-email-glommer@openvz.org>
 <20130430215355.GN6415@suse.de>
 <20130430220050.GK9931@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130430220050.GK9931-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Dan Magenheimer <dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 30, 2013 at 03:00:50PM -0700, Kent Overstreet wrote:
> On Tue, Apr 30, 2013 at 10:53:55PM +0100, Mel Gorman wrote:
> > On Sat, Apr 27, 2013 at 03:19:13AM +0400, Glauber Costa wrote:
> > > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > > index 03e44c1..8b9c1a6 100644
> > > --- a/drivers/md/bcache/btree.c
> > > +++ b/drivers/md/bcache/btree.c
> > > @@ -599,11 +599,12 @@ static int mca_reap(struct btree *b, struct closure *cl, unsigned min_order)
> > >  	return 0;
> > >  }
> > >  
> > > -static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> > > +static long bch_mca_scan(struct shrinker *shrink, struct shrink_control *sc)
> > >  {
> > >  	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
> > >  	struct btree *b, *t;
> > >  	unsigned long i, nr = sc->nr_to_scan;
> > > +	long freed = 0;
> > >  
> > >  	if (c->shrinker_disabled)
> > >  		return 0;
> > 
> > -1 if shrinker disabled?
> > 
> > Otherwise if the shrinker is disabled we ultimately hit this loop in
> > shrink_slab_one()
> 
> My memory is very hazy on this stuff, but I recall there being another
> loop that'd just spin if we always returned -1.
> 
> (It might've been /proc/sys/vm/drop_caches, or maybe that was another
> bug..)
> 

It might be worth chasing down what that bug was and fixing it.

> But 0 should certainly be safe - if we're always returning 0, then we're
> claiming we don't have anything to shrink.
> 

It won't crash, but in Glauber's current code, it'll call you a few more
times uselessly and the scanned statistics become misleading. I think
Glauber/Dave's series is a big improvement over what we currently have
and it would be nice to get it ironed out.

-- 
Mel Gorman
SUSE Labs
