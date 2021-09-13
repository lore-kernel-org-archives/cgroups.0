From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Mon, 13 Sep 2021 19:34:23 +0800
Message-ID: <20210913113423.GC56674@shbuild999.sh.intel.com>
References: <1631518709-42881-1-git-send-email-feng.tang@intel.com>
 <YT8WygPhuORJC6Pn@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YT8WygPhuORJC6Pn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 13, 2021 at 11:15:54AM +0200, Michal Hocko wrote:
[...] 
> > +/*
> > + * This will get enabled whenever a cpuset configuration is considered
> > + * unsupportable in general. E.g. movable only node which cannot satisfy
> > + * any non movable allocations (see update_nodemask). Page allocator
> > + * needs to make additional checks for those configurations and this
> > + * check is meant to guard those checks without any overhead for sane
> > + * configurations.
> > + */
> > +static inline bool cpusets_insane_config(void)
> > +{
> > +	return static_branch_unlikely(&cpusets_insane_config_key);
> > +}
> > +
> >  extern int cpuset_init(void);
> >  extern void cpuset_init_smp(void);
> >  extern void cpuset_force_rebuild(void);
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 6a1d79d..b69b871 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1220,6 +1220,18 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
> >  #define for_each_zone_zonelist(zone, z, zlist, highidx) \
> >  	for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, NULL)
> >  
> > +/* Whether the 'nodes' are all movable nodes */
> > +static inline bool movable_only_nodes(nodemask_t *nodes)
> > +{
> > +	struct zonelist *zonelist;
> > +	struct zoneref *z;
> > +
> > +	zonelist = &(first_online_pgdat())->node_zonelists[ZONELIST_FALLBACK];
> 
> This will work but it just begs a question why you haven't chosen a node
> from the given nodemask. So I believe it would be easier to read if you
> did
> 	zonelist = NODE_DATA(first_node(nodes))->node_zonelists[ZONELIST_FALLBACK]

This was also my first try to get the 'zonelist', but from the
update_nodemask(), the nodemask could be NULL.

	/*
	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
	 * Since nodelist_parse() fails on an empty mask, we special case
	 * that parsing.  The validate_change() call ensures that cpusets
	 * with tasks have memory.
	 */
	if (!*buf) {
		nodes_clear(trialcs->mems_allowed);
	
> > +	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> > +	return (!z->zone) ? true : false;
> > +}
> > +
> > +
> >  #ifdef CONFIG_SPARSEMEM
> >  #include <asm/sparsemem.h>
> >  #endif
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index df1ccf4..03eb40c 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -69,6 +69,13 @@
> >  DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
> >  DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
> >  
> > +/*
> > + * There could be abnormal cpuset configurations for cpu or memory
> > + * node binding, add this key to provide a quick low-cost judgement
> > + * of the situation.
> > + */
> > +DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
> > +
> >  /* See "Frequency meter" comments, below. */
> >  
> >  struct fmeter {
> > @@ -1868,6 +1875,13 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
> >  	if (retval < 0)
> >  		goto done;
> >  
> > +	if (movable_only_nodes(&trialcs->mems_allowed)) {
> 
> You can skip the check if cpusets_insane_config(). The question is
> whether you want to report all potential users or only the first one.

Yes, I missed that, will add this check

> > +		static_branch_enable(&cpusets_insane_config_key);
> > +		pr_info("Unsupported (movable nodes only) cpuset configuration detected (nmask=%*pbl)! "
> > +			"Cpuset allocations might fail even with a lot of memory available.\n",
> > +			nodemask_pr_args(&trialcs->mems_allowed));
> > +	}
> > +
> >  	spin_lock_irq(&callback_lock);
> >  	cs->mems_allowed = trialcs->mems_allowed;
> >  	spin_unlock_irq(&callback_lock);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b37435c..a7e0854 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4914,6 +4914,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >  	if (!ac->preferred_zoneref->zone)
> >  		goto nopage;
> >  
> > +	/*
> > +	 * Check for insane configurations where the cpuset doesn't contain
> > +	 * any suitable zone to satisfy the request - e.g. non-movable
> > +	 * GFP_HIGHUSER allocations from MOVABLE nodes only.
> > +	 */
> > +	if (cpusets_insane_config() && (gfp_mask & __GFP_HARDWALL)) {
> > +		struct zoneref *z = first_zones_zonelist(ac->zonelist,
> > +					ac->highest_zoneidx,
> > +					&cpuset_current_mems_allowed);
> > +		if (!z->zone)
> > +			goto nopage;
> > +	}
> > +
> >  	if (alloc_flags & ALLOC_KSWAPD)
> >  		wake_all_kswapds(order, gfp_mask, ac);
> 
> The rest looks sensible to me.

Thanks for the review!

- Feng

> -- 
> Michal Hocko
> SUSE Labs
