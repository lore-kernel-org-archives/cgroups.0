From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Mon, 13 Sep 2021 20:12:33 +0800
Message-ID: <20210913121233.GD56674@shbuild999.sh.intel.com>
References: <1631518709-42881-1-git-send-email-feng.tang@intel.com>
 <YT8WygPhuORJC6Pn@dhcp22.suse.cz>
 <20210913113423.GC56674@shbuild999.sh.intel.com>
 <YT8576cL4tSqmUKI@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YT8576cL4tSqmUKI-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 13, 2021 at 01:45:51PM +0200, Michal Hocko wrote:
> On Mon 13-09-21 19:34:23, Feng Tang wrote:
> > On Mon, Sep 13, 2021 at 11:15:54AM +0200, Michal Hocko wrote:
> [...] 
> > > > +/* Whether the 'nodes' are all movable nodes */
> > > > +static inline bool movable_only_nodes(nodemask_t *nodes)
> > > > +{
> > > > +	struct zonelist *zonelist;
> > > > +	struct zoneref *z;
> > > > +
> > > > +	zonelist = &(first_online_pgdat())->node_zonelists[ZONELIST_FALLBACK];
> > > 
> > > This will work but it just begs a question why you haven't chosen a node
> > > from the given nodemask. So I believe it would be easier to read if you
> > > did
> > > 	zonelist = NODE_DATA(first_node(nodes))->node_zonelists[ZONELIST_FALLBACK]
> > 
> > This was also my first try to get the 'zonelist', but from the
> > update_nodemask(), the nodemask could be NULL.
> 
> I guess you meant to say s@NULL@empty@
> While this complicates things a bit it is nothing really hard to work
> around. You simply check for nodes_empty() and return false because such
> a nodemask cannot by definition be movable only.

Yes, a nodes_empty() check can solve it, thanks,

- Feng

> -- 
> Michal Hocko
> SUSE Labs
