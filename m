From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/31] drivers: convert shrinkers to new count/scan API
Date: Tue, 30 Apr 2013 15:00:50 -0700
Message-ID: <20130430220050.GK9931@google.com>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-18-git-send-email-glommer@openvz.org>
 <20130430215355.GN6415@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ehGWz6Mc1mQiUJdOufXCoAirt2LPSq/YnG2hky/ZwWA=;
        b=o9gAZqaEYEJe1vpmveFd0xD8hewN5G22jbxoB1+pB/ccDhCMocOSyLXWW7pQuHM2Wh
         1FgOYOXy8WBYWApWEAm6y4DIHS8xbzy3KcJQwLwsvgzT2MPvQtgpnRlSstWq9NZB7gwr
         3bNyVFyR7BU5a8T/D2gZl0gBXbX9dSMsQkpDOX9/asbC5zD6IXnwEie4bBviBVzbQFDu
         mpX6a1rZeIERUI0TCTX8FwwowV7wokNjUjmS2v3zok9QE+0CFaIziz3q1jAqcer6p2L4
         lpob+v+iS0m+ZOx2Ox0kcmMhztyJ1SXxa8KkVxPZPiQ8lUNiai2GolGMmycd+DgWm/sp
         l+Qw==
Content-Disposition: inline
In-Reply-To: <20130430215355.GN6415-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Dan Magenheimer <dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 30, 2013 at 10:53:55PM +0100, Mel Gorman wrote:
> On Sat, Apr 27, 2013 at 03:19:13AM +0400, Glauber Costa wrote:
> > diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> > index 03e44c1..8b9c1a6 100644
> > --- a/drivers/md/bcache/btree.c
> > +++ b/drivers/md/bcache/btree.c
> > @@ -599,11 +599,12 @@ static int mca_reap(struct btree *b, struct closure *cl, unsigned min_order)
> >  	return 0;
> >  }
> >  
> > -static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> > +static long bch_mca_scan(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >  	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
> >  	struct btree *b, *t;
> >  	unsigned long i, nr = sc->nr_to_scan;
> > +	long freed = 0;
> >  
> >  	if (c->shrinker_disabled)
> >  		return 0;
> 
> -1 if shrinker disabled?
> 
> Otherwise if the shrinker is disabled we ultimately hit this loop in
> shrink_slab_one()

My memory is very hazy on this stuff, but I recall there being another
loop that'd just spin if we always returned -1.

(It might've been /proc/sys/vm/drop_caches, or maybe that was another
bug..)

But 0 should certainly be safe - if we're always returning 0, then we're
claiming we don't have anything to shrink.

> do {
> 	ret = shrinker->scan_objects(shrinker, sc);
> 	if (ret == -1)
> 		break
> 	....
>         count_vm_events(SLABS_SCANNED, batch_size);
>         total_scan -= batch_size;
> 
>         cond_resched();
> } while (total_scan >= batch_size);
> 
> which won't break as such but we busy loop until total_scan drops and
> account for SLABS_SCANNED incorrectly.
> 
> More using of mutex_lock in here which means that multiple direct reclaimers
> will contend on each other. bch_mca_shrink() checks for __GFP_WAIT but an
> atomic caller does not direct reclaim so it'll always try and contend.
> 
> > @@ -611,12 +612,6 @@ static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> >  	if (c->try_harder)
> >  		return 0;
> >  
> > -	/*
> > -	 * If nr == 0, we're supposed to return the number of items we have
> > -	 * cached. Not allowed to return -1.
> > -	 */
> > -	if (!nr)
> > -		return mca_can_free(c) * c->btree_pages;
> >  
> >  	/* Return -1 if we can't do anything right now */
> >  	if (sc->gfp_mask & __GFP_WAIT)
> > @@ -629,14 +624,14 @@ static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> >  
> >  	i = 0;
> >  	list_for_each_entry_safe(b, t, &c->btree_cache_freeable, list) {
> > -		if (!nr)
> > +		if (freed >= nr)
> >  			break;
> >  
> >  		if (++i > 3 &&
> >  		    !mca_reap(b, NULL, 0)) {
> >  			mca_data_free(b);
> >  			rw_unlock(true, b);
> > -			--nr;
> > +			freed++;
> >  		}
> >  	}
> >  
> > @@ -647,7 +642,7 @@ static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> >  	if (list_empty(&c->btree_cache))
> >  		goto out;
> >  
> > -	for (i = 0; nr && i < c->bucket_cache_used; i++) {
> > +	for (i = 0; i < c->bucket_cache_used; i++) {
> >  		b = list_first_entry(&c->btree_cache, struct btree, list);
> >  		list_rotate_left(&c->btree_cache);
> >  
> > @@ -656,14 +651,20 @@ static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
> >  			mca_bucket_free(b);
> >  			mca_data_free(b);
> >  			rw_unlock(true, b);
> > -			--nr;
> > +			freed++;
> >  		} else
> >  			b->accessed = 0;
> >  	}
> >  out:
> > -	nr = mca_can_free(c) * c->btree_pages;
> >  	mutex_unlock(&c->bucket_lock);
> > -	return nr;
> > +	return freed;
> > +}
> > +
> > +static long bch_mca_count(struct shrinker *shrink, struct shrink_control *sc)
> > +{
> > +	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
> > +
> > +	return mca_can_free(c) * c->btree_pages;
> >  }
> >  
> >  void bch_btree_cache_free(struct cache_set *c)
> > @@ -732,7 +733,8 @@ int bch_btree_cache_alloc(struct cache_set *c)
> >  		c->verify_data = NULL;
> >  #endif
> >  
> > -	c->shrink.shrink = bch_mca_shrink;
> > +	c->shrink.count_objects = bch_mca_count;
> > +	c->shrink.scan_objects = bch_mca_scan;
> >  	c->shrink.seeks = 4;
> >  	c->shrink.batch = c->btree_pages * 2;
> >  	register_shrinker(&c->shrink);
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index 4d9cca4..fa8d048 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -535,7 +535,7 @@ STORE(__bch_cache_set)
> >  		struct shrink_control sc;
> >  		sc.gfp_mask = GFP_KERNEL;
> >  		sc.nr_to_scan = strtoul_or_return(buf);
> > -		c->shrink.shrink(&c->shrink, &sc);
> > +		c->shrink.scan_objects(&c->shrink, &sc);
> >  	}
> >  
> >  	sysfs_strtoul(congested_read_threshold_us,
