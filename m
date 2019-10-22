From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/8] mm: vmscan: replace shrink_node() loop with a retry
 jump
Date: Tue, 22 Oct 2019 17:42:49 -0400
Message-ID: <20191022214249.GB361040@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-6-hannes@cmpxchg.org>
 <20191022195629.GA24142@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UkVKcIoIjwq/4A0nvuIrRwIJe7BfuWm5uRD47GZUEfM=;
        b=RH2e1j+TaBj5hLQezyCMTCJMMgTJv8iyXFP6oi7yBda7boYLxE/75IqlCvdSqkfjKo
         UI0vJQI+QQgcRd86+pdAoij4fnL4PuIwY/xMdr7ya84mJKI0lQl+3HHjmDEiOVGMS4UY
         FGtgYoOm+eWSvAhmhs/crmTiyzht0NFTlsEAjD5ZNL99YfRZhBz50+Lqf9f80deynnWG
         Wx1Su905GSpJZxfD/2akXjNl4UKi9cWGl9eZccJhfeO16I/VQoWCRLH7nqV1MWwqgVVr
         l/LP3JAJr5reGl4bakvVttU+XEWyxTVQtiUne915oAXSj34XHfRjYFmxaI2K1135QTii
         ZlbQ==
Content-Disposition: inline
In-Reply-To: <20191022195629.GA24142@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 07:56:33PM +0000, Roman Gushchin wrote:
> On Tue, Oct 22, 2019 at 10:48:00AM -0400, Johannes Weiner wrote:
> > -			/* Record the group's reclaim efficiency */
> > -			vmpressure(sc->gfp_mask, memcg, false,
> > -				   sc->nr_scanned - scanned,
> > -				   sc->nr_reclaimed - reclaimed);
> > -
> > -		} while ((memcg = mem_cgroup_iter(root, memcg, NULL)));
> > +		reclaimed = sc->nr_reclaimed;
> > +		scanned = sc->nr_scanned;
> > +		shrink_node_memcg(pgdat, memcg, sc);
> >  
> > -		if (reclaim_state) {
> > -			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> > -			reclaim_state->reclaimed_slab = 0;
> > -		}
> > +		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
> > +			    sc->priority);
> >  
> > -		/* Record the subtree's reclaim efficiency */
> > -		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> > -			   sc->nr_scanned - nr_scanned,
> > -			   sc->nr_reclaimed - nr_reclaimed);
> > +		/* Record the group's reclaim efficiency */
> > +		vmpressure(sc->gfp_mask, memcg, false,
> > +			   sc->nr_scanned - scanned,
> > +			   sc->nr_reclaimed - reclaimed);
> 
> It doesn't look as a trivial change. I'd add some comments to the commit message
> why it's safe to do.

It's an equivalent change - it's just really misleading because the
+++ lines are not the counter-part of the --- lines here!

There are two vmpressure calls in this function: one against the
individual cgroups, and one against the tree. The diff puts them
adjacent here, but the counter-part for the --- lines is here:

> > +	/* Record the subtree's reclaim efficiency */
> > +	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> > +		   sc->nr_scanned - nr_scanned,
> > +		   sc->nr_reclaimed - nr_reclaimed);

And the counter-part to the +++ lines is further up (beginning of the
quoted diff).
