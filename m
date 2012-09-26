From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 18:01:27 +0200
Message-ID: <20120926160126.GF15801@dhcp22.suse.cz>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
 <50631226.9050304@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50631226.9050304-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 26-09-12 18:33:10, Glauber Costa wrote:
> On 09/26/2012 06:03 PM, Michal Hocko wrote:
> > On Tue 18-09-12 18:04:01, Glauber Costa wrote:
[...]
> >> @@ -4961,6 +5015,12 @@ mem_cgroup_create(struct cgroup *cont)
> >>  		int cpu;
> >>  		enable_swap_cgroup();
> >>  		parent = NULL;
> >> +
> >> +#ifdef CONFIG_MEMCG_KMEM
> >> +		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
> >> +					   kmem_cgroup_files));
> >> +#endif
> >> +
> >>  		if (mem_cgroup_soft_limit_tree_init())
> >>  			goto free_out;
> >>  		root_mem_cgroup = memcg;
> >> @@ -4979,6 +5039,7 @@ mem_cgroup_create(struct cgroup *cont)
> >>  	if (parent && parent->use_hierarchy) {
> >>  		res_counter_init(&memcg->res, &parent->res);
> >>  		res_counter_init(&memcg->memsw, &parent->memsw);
> >> +		res_counter_init(&memcg->kmem, &parent->kmem);
> > 
> > Haven't we already discussed that a new memcg should inherit kmem_accounted
> > from its parent for use_hierarchy?
> > Say we have
> > root
> > |
> > A (kmem_accounted = 1, use_hierachy = 1)
> >  \
> >   B (kmem_accounted = 0)
> >    \
> >     C (kmem_accounted = 1)
> > 
> > B find's itself in an awkward situation becuase it doesn't want to
> > account u+k but it ends up doing so becuase C.
> > 
> 
> Ok, I haven't updated it here. But that should be taken care of in the
> lifecycle patch.

I am not sure which patch you are thinking about but I would prefer to
have it here because it is safe wrt. races and it is more obvious as
well.

-- 
Michal Hocko
SUSE Labs
