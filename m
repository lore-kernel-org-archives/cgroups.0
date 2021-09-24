From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Fri, 24 Sep 2021 09:17:49 +0200
Message-ID: <YU17nUx+yE8ie38s@dhcp22.suse.cz>
References: <1631590828-25565-1-git-send-email-feng.tang@intel.com>
 <YUBiYgXWSoKSG7f2@dhcp22.suse.cz>
 <20210924061054.GA72911@shbuild999.sh.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632467872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/xNUhf/YAAfEBLYbmN30IOswNJKEbij/dzXJ1d79KM=;
        b=G1cdx9jma92fDdbcKp5DT/9xi4SVGP8sPLb8LJwbQxxgwr6wUWPAlDbwTIAQZO4bQBnzMN
        rfTlQZe27fVS7CYHqxOq59hhqHzUaLz3bUB4DlTtaTJh71pDy0bVhb1nyZRPYfNRA3P++Q
        5z9fCqb4HIcwRLesLHhPYS8MXjb4QDo=
Content-Disposition: inline
In-Reply-To: <20210924061054.GA72911-H4oSubS0T0ZnxsEdoo2cZdh3ngVCH38I@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 24-09-21 14:10:54, Feng Tang wrote:
> Hi Michal,
> 
> On Tue, Sep 14, 2021 at 10:50:42AM +0200, Michal Hocko wrote:
> > On Tue 14-09-21 11:40:28, Feng Tang wrote:
> [SPIN]
> > > The OOM killer cannot help to resolve the situation as there is no
> > > usable memory for the request in the cpuset scope. The only reasonable
> > > measure to take is to fail the allocation right away and have the caller
> > > to deal with it.
> > > 
> > > So add a check for cases like this in the slowpath of allocation, and
> > > bail out early returning NULL for the allocation.
> > > 
> > > As page allocation is one of the hottest path in kernel, this check
> > > will hurt all users with sane cpuset configuration, add a static branch
> > > check and detect the abnormal config in cpuset memory binding setup so
> > > that the extra check in page allocation is not paid by everyone.
> > > 
> > > [thanks to Micho Hocko and David Rientjes for suggesting not handle
> > >  it inside OOM code, adding cpuset check, refining comments]
> > > 
> > > Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>  
> Thank you!
> 
> > Minor nit below
> > [...]
> > > +/* Whether the 'nodes' are all movable nodes */
> > > +static inline bool movable_only_nodes(nodemask_t *nodes)
> > > +{
> > > +	struct zonelist *zonelist;
> > > +	struct zoneref *z;
> > > +
> > > +	if (nodes_empty(*nodes))
> > > +		return false;
> > > +
> > > +	zonelist =
> > > +	    &NODE_DATA(first_node(*nodes))->node_zonelists[ZONELIST_FALLBACK];
> > > +	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> > > +	return (!z->zone) ? true : false;
> > 
> > This would read easier to me
> > 	/*
> > 	 * We can chose arbitrary node from the nodemask to get a
> > 	 * zonelist as they are interlinked. We just need to find
> > 	 * at least one zone that can satisfy kernel allocations.
> > 	 */
> > 	node = NODE_DATA(first_node(*nodes));
> > 	zonelist = node_zonelist(node, GFP_KERNEL);
> > 	z = first_zones_zonelist(zonelist, ZONE_NORMAL, nodes);
> 
> When working on the v4 patch, I see some compile warning
> that 'node_zonelist()' and 'GFP_KERNEL' are either implicit
> or undeclared, as they are from "gfp.h".
> 
> So we may need to move this function to gfp.h or keep the
> current code with slight modification?
> 
> 	nid = first_node(*nodes);
> 	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
> 	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> 	return (!z->zone) ? true : false;

I would put it into gfp.h but I can see how this might be not really
loved there. Both ways work with me.
-- 
Michal Hocko
SUSE Labs
