From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: vmscan: do not share cgroup iteration between
 reclaimers
Date: Mon, 12 Aug 2019 19:00:43 -0400
Message-ID: <20190812230043.GA18948@cmpxchg.org>
References: <20190812192316.13615-1-hannes@cmpxchg.org>
 <20190812210723.GA9423@tower.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2ksXWqG62EfbmUuHI0nKd4a7rlKac00A3mrtP5kn5Ls=;
        b=clZMOrgpPeiUsSiOQGc7xPtSCJ1+tYlCEalNf0FrCYLJfEA+0uy4k2IMsGT3jc2cFu
         QPuYWIpFCQhxAals/OKuaPNf8mppQVTkf6D4zIbGyKu4gOrWVhA2o9ZKUIPwXfJVrcoG
         avMIYarRQn3GMlD+OUwXFSElhTGkglyd3QZD1GJQSaZP8jC6QiZ2xLFtEuUdnjR3mnni
         sRQtw5csmi7PfDU+Ql+QaQ1NKyhCIKJ3a40cFUmsKMpgHBOzlU8Y+4Tu8Q9zJCvCmZsb
         tOC9AwuoxVLSsc9XXteA5o+ppMTBTFjDr7sDywYo3lo2UATZPZ7kYu0zrGDtAc9pwsi5
         IbpA==
Content-Disposition: inline
In-Reply-To: <20190812210723.GA9423@tower.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Aug 12, 2019 at 09:07:27PM +0000, Roman Gushchin wrote:
> On Mon, Aug 12, 2019 at 03:23:16PM -0400, Johannes Weiner wrote:
> > @@ -2679,7 +2675,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> >  		nr_reclaimed = sc->nr_reclaimed;
> >  		nr_scanned = sc->nr_scanned;
> >  
> > -		memcg = mem_cgroup_iter(root, NULL, &reclaim);
> > +		memcg = mem_cgroup_iter(root, NULL, NULL);
> 
> I wonder if we can remove the shared memcg tree walking at all? It seems that
> the only use case left is the soft limit, and the same logic can be applied
> to it. The we potentially can remove a lot of code in mem_cgroup_iter().
> Just an idea...

It's so tempting! But soft limit reclaim starts at priority 0 right
out of the gate, so overreclaim is an actual concern there. We could
try to rework it, but it'll be hard to avoid regressions given how
awkward the semantics and behavior around the soft limit already are.

> >  		do {
> >  			unsigned long lru_pages;
> >  			unsigned long reclaimed;
> > @@ -2724,21 +2720,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> >  				   sc->nr_scanned - scanned,
> >  				   sc->nr_reclaimed - reclaimed);
> >  
> > -			/*
> > -			 * Kswapd have to scan all memory cgroups to fulfill
> > -			 * the overall scan target for the node.
> > -			 *
> > -			 * Limit reclaim, on the other hand, only cares about
> > -			 * nr_to_reclaim pages to be reclaimed and it will
> > -			 * retry with decreasing priority if one round over the
> > -			 * whole hierarchy is not sufficient.
> > -			 */
> > -			if (!current_is_kswapd() &&
> > -					sc->nr_reclaimed >= sc->nr_to_reclaim) {
> > -				mem_cgroup_iter_break(root, memcg);
> > -				break;
> > -			}
> > -		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
> > +		} while ((memcg = mem_cgroup_iter(root, memcg, NULL)));
> >  
> >  		if (reclaim_state) {
> >  			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> > -- 
> > 2.22.0
> >
> 
> Otherwise looks good to me!
> 
> Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
