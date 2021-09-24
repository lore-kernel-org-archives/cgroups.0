From: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH v3] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Fri, 24 Sep 2021 14:10:54 +0800
Message-ID: <20210924061054.GA72911@shbuild999.sh.intel.com>
References: <1631590828-25565-1-git-send-email-feng.tang@intel.com>
 <YUBiYgXWSoKSG7f2@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <YUBiYgXWSoKSG7f2@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Sep 14, 2021 at 10:50:42AM +0200, Michal Hocko wrote:
> On Tue 14-09-21 11:40:28, Feng Tang wrote:
[SPIN]
> > The OOM killer cannot help to resolve the situation as there is no
> > usable memory for the request in the cpuset scope. The only reasonable
> > measure to take is to fail the allocation right away and have the caller
> > to deal with it.
> > 
> > So add a check for cases like this in the slowpath of allocation, and
> > bail out early returning NULL for the allocation.
> > 
> > As page allocation is one of the hottest path in kernel, this check
> > will hurt all users with sane cpuset configuration, add a static branch
> > check and detect the abnormal config in cpuset memory binding setup so
> > that the extra check in page allocation is not paid by everyone.
> > 
> > [thanks to Micho Hocko and David Rientjes for suggesting not handle
> >  it inside OOM code, adding cpuset check, refining comments]
> > 
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
 
Thank you!

> Minor nit below
> [...]
> > +/* Whether the 'nodes' are all movable nodes */
> > +static inline bool movable_only_nodes(nodemask_t *nodes)
> > +{
> > +	struct zonelist *zonelist;
> > +	struct zoneref *z;
> > +
> > +	if (nodes_empty(*nodes))
> > +		return false;
> > +
> > +	zonelist =
> > +	    &NODE_DATA(first_node(*nodes))->node_zonelists[ZONELIST_FALLBACK];
> > +	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> > +	return (!z->zone) ? true : false;
> 
> This would read easier to me
> 	/*
> 	 * We can chose arbitrary node from the nodemask to get a
> 	 * zonelist as they are interlinked. We just need to find
> 	 * at least one zone that can satisfy kernel allocations.
> 	 */
> 	node = NODE_DATA(first_node(*nodes));
> 	zonelist = node_zonelist(node, GFP_KERNEL);
> 	z = first_zones_zonelist(zonelist, ZONE_NORMAL, nodes);

When working on the v4 patch, I see some compile warning
that 'node_zonelist()' and 'GFP_KERNEL' are either implicit
or undeclared, as they are from "gfp.h".

So we may need to move this function to gfp.h or keep the
current code with slight modification?

	nid = first_node(*nodes);
	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
	return (!z->zone) ? true : false;

Thanks,
Feng

