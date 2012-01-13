From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Fri, 13 Jan 2012 17:34:23 +0100
Message-ID: <20120113163423.GG17060@tiehlicka.suse.cz>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
 <1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
 <20120113120406.GC17060@tiehlicka.suse.cz>
 <20120113155001.GB1653@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120113155001.GB1653-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 13-01-12 16:50:01, Johannes Weiner wrote:
> On Fri, Jan 13, 2012 at 01:04:06PM +0100, Michal Hocko wrote:
> > On Tue 10-01-12 16:02:52, Johannes Weiner wrote:
[...]
> > > +bool mem_cgroup_over_softlimit(struct mem_cgroup *root,
> > > +			       struct mem_cgroup *memcg)
> > > +{
> > > +	if (mem_cgroup_disabled())
> > > +		return false;
> > > +
> > > +	if (!root)
> > > +		root = root_mem_cgroup;
> > > +
> > > +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> > > +		/* root_mem_cgroup does not have a soft limit */
> > > +		if (memcg == root_mem_cgroup)
> > > +			break;
> > > +		if (res_counter_soft_limit_excess(&memcg->res))
> > > +			return true;
> > > +		if (memcg == root)
> > > +			break;
> > > +	}
> > > +	return false;
> > > +}
> > 
> > Well, this might be little bit tricky. We do not check whether memcg and
> > root are in a hierarchy (in terms of use_hierarchy) relation. 
> > 
> > If we are under global reclaim then we iterate over all memcgs and so
> > there is no guarantee that there is a hierarchical relation between the
> > given memcg and its parent. While, on the other hand, if we are doing
> > memcg reclaim then we have this guarantee.
> > 
> > Why should we punish a group (subtree) which is perfectly under its soft
> > limit just because some other subtree contributes to the common parent's
> > usage and makes it over its limit?
> > Should we check memcg->use_hierarchy here?
> 
> We do, actually.  parent_mem_cgroup() checks the res_counter parent,
> which is only set when ->use_hierarchy is also set.  

Of course I am blind.. We do not setup res_counter parent for
!use_hierarchy case. Sorry for noise...
Now it makes much better sense. I was wondering how !use_hierarchy could
ever work, this should be a signal that I am overlooking something
terribly.

[...]
> > > @@ -2121,8 +2121,16 @@ static void shrink_zone(int priority, struct zone *zone,
> > >  			.mem_cgroup = memcg,
> > >  			.zone = zone,
> > >  		};
> > > +		int epriority = priority;
> > > +		/*
> > > +		 * Put more pressure on hierarchies that exceed their
> > > +		 * soft limit, to push them back harder than their
> > > +		 * well-behaving siblings.
> > > +		 */
> > > +		if (mem_cgroup_over_softlimit(root, memcg))
> > > +			epriority = 0;
> > 
> > This sounds too aggressive to me. Shouldn't we just double the pressure
> > or something like that?
> 
> That's the historical value.  When I tried priority - 1, it was not
> aggressive enough.

Probably because we want to reclaim too much. Maybe we should do
reduce nr_to_reclaim (ugly) or reclaim only overlimit groups until certain
priority level as Ying suggested in her patchset.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
