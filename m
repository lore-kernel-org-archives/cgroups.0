From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 16:37:02 +0800
Message-ID: <Y1jxrv5/4PxrEt+F@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <22f86189-76fa-61ab-4e80-9c2740ec8e8a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666773454; x=1698309454;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fhNQwmgFxrWhlHo0MKDtd/alGUXXIYpmPZkfj6NbB7o=;
  b=eOfuRe22l1mmeS+eCLBN2f33IoJD62uUlPaHS46vMMW+WXagYhXbbgNy
   nf2vC9IjJ3RipqgjomyMtq9wBPtAGTnu/8vxs/IzAMu8Gxsnx40D2F+DC
   2BS0kL1NMj/EY3AXTR4cAFBVKAvT6uCNJdGImQIjse2L9WXJ9QBPtotnJ
   /hOCf+irhrq2Ys5EU2u13stqfx60kyXJKlK+Z0/J992qfvfCi2ntfzfsZ
   NsIMhtPumMq+KG1cRN74H5dJk7qUL1S9Wu9NDF2PWXHyI1ciB4T02wtN8
   OUaGR0/NHz4UxCkPZYjWRqHYosGYxFW3d5Uzx5GSlmIdGr+SCsmPCYdsr
   Q==;
Content-Disposition: inline
In-Reply-To: <22f86189-76fa-61ab-4e80-9c2740ec8e8a-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Oct 26, 2022 at 04:26:28PM +0800, Yin, Fengwei wrote:
> Hi Feng,
> 
> On 10/26/2022 3:43 PM, Feng Tang wrote:
> > In page reclaim path, memory could be demoted from faster memory tier
> > to slower memory tier. Currently, there is no check about cpuset's
> > memory policy, that even if the target demotion node is not allowd
> > by cpuset, the demotion will still happen, which breaks the cpuset
> > semantics.
> > 
> > So add cpuset policy check in the demotion path and skip demotion
> > if the demotion targets are not allowed by cpuset.
> > 
> > Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > Hi reviewers,
> > 
> > For easy bisectable, I combined the cpuset change and mm change
> > in one patch, if you prefer to separate them, I can turn it into
> > 2 patches.
> > 
> > Thanks,
> > Feng
> > 
> >  include/linux/cpuset.h |  6 ++++++
> >  kernel/cgroup/cpuset.c | 29 +++++++++++++++++++++++++++++
> >  mm/vmscan.c            | 35 ++++++++++++++++++++++++++++++++---
> >  3 files changed, 67 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index d58e0476ee8e..6fcce2bd2631 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -178,6 +178,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
> >  	task_unlock(current);
> >  }
> >  
> > +extern void cpuset_get_allowed_mem_nodes(struct cgroup *cgroup,
> > +						nodemask_t *nmask);
> >  #else /* !CONFIG_CPUSETS */
> >  
> >  static inline bool cpusets_enabled(void) { return false; }
> > @@ -299,6 +301,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
> >  	return false;
> >  }
> >  
> > +static inline void cpuset_get_allowed_mem_nodes(struct cgroup *cgroup,
> > +						nodemask_t *nmask)
> > +{
> > +}
> >  #endif /* !CONFIG_CPUSETS */
> >  
> >  #endif /* _LINUX_CPUSET_H */
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index 3ea2e836e93e..cbb118c0502f 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -3750,6 +3750,35 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
> >  	return mask;
> >  }
> >  
> > +/*
> > + * Retrieve the allowed memory nodemask for a cgroup.
> > + *
> > + * Set *nmask to cpuset's effective allowed nodemask for cgroup v2,
> > + * and NODE_MASK_ALL (means no constraint) for cgroup v1 where there
> > + * is no guaranteed association from a cgroup to a cpuset.
> > + */
> > +void cpuset_get_allowed_mem_nodes(struct cgroup *cgroup, nodemask_t *nmask)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +	struct cpuset *cs;
> > +
> > +	if (!is_in_v2_mode()) {
> > +		*nmask = NODE_MASK_ALL;
> > +		return;
> > +	}
> > +
> > +	rcu_read_lock();
> > +	css = cgroup_e_css(cgroup, &cpuset_cgrp_subsys);
> > +	if (css) {
> > +		css_get(css);
> > +		cs = css_cs(css);
> > +		*nmask = cs->effective_mems;
> > +		css_put(css);
> > +	}
> > +
> > +	rcu_read_unlock();
> > +}
> > +
> >  /**
> >   * cpuset_nodemask_valid_mems_allowed - check nodemask vs. current mems_allowed
> >   * @nodemask: the nodemask to be checked
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 18f6497994ec..c205d98283bc 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1537,9 +1537,21 @@ static struct page *alloc_demote_page(struct page *page, unsigned long private)
> >  {
> >  	struct page *target_page;
> >  	nodemask_t *allowed_mask;
> > -	struct migration_target_control *mtc;
> > +	struct migration_target_control *mtc = (void *)private;
> >  
> > -	mtc = (struct migration_target_control *)private;
> > +#if IS_ENABLED(CONFIG_MEMCG) && IS_ENABLED(CONFIG_CPUSETS)
> > +	struct mem_cgroup *memcg;
> > +	nodemask_t cpuset_nmask;
> > +
> > +	memcg = page_memcg(page);
> > +	cpuset_get_allowed_mem_nodes(memcg->css.cgroup, &cpuset_nmask);
> > +
> > +	if (!node_isset(mtc->nid, cpuset_nmask)) {
> > +		if (mtc->nmask)
> > +			nodes_and(*mtc->nmask, *mtc->nmask, cpuset_nmask);
> > +		return alloc_migration_target(page, (unsigned long)mtc);
> > +	}
> > +#endif
> >  
> >  	allowed_mask = mtc->nmask;
> >  	/*
> > @@ -1649,6 +1661,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> >  		enum folio_references references = FOLIOREF_RECLAIM;
> >  		bool dirty, writeback;
> >  		unsigned int nr_pages;
> > +		bool skip_this_demotion = false;
> >  
> >  		cond_resched();
> >  
> > @@ -1658,6 +1671,22 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> >  		if (!folio_trylock(folio))
> >  			goto keep;
> >  
> > +#if IS_ENABLED(CONFIG_MEMCG) && IS_ENABLED(CONFIG_CPUSETS)
> > +		if (do_demote_pass) {
> > +			struct mem_cgroup *memcg;
> > +			nodemask_t nmask, nmask1;
> > +
> > +			node_get_allowed_targets(pgdat, &nmask);
> > +			memcg = folio_memcg(folio);
> > +			if (memcg)
> Doesn't check memcg in the change to alloc_demote_page(). What's the difference here?
> 
> > +				cpuset_get_allowed_mem_nodes(memcg->css.cgroup,
> > +								&nmask1);
> > +
> > +			if (!nodes_intersects(nmask, nmask1))
> If memcg is NULL, nmask1 will have an uninitialized value. Thanks.
 
Good catch! Yes, it should be initialized to NODE_MASK_ALL.

Actually I was not sure if I need to check 'memcg == NULL' case, while
I was under the impression that for page on LRU list, it's memcg is
either a specific memcg or the 'root_mem_cgroup'. I will double
check that.

Thanks,
Feng

> Regards
> Yin, Fengwei
> 
> > +				skip_this_demotion = true;
> > +		}
> > +#endif
> > +
> >  		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
> >  
> >  		nr_pages = folio_nr_pages(folio);
> > @@ -1799,7 +1828,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> >  		 * Before reclaiming the folio, try to relocate
> >  		 * its contents to another node.
> >  		 */
> > -		if (do_demote_pass &&
> > +		if (do_demote_pass && !skip_this_demotion &&
> >  		    (thp_migration_supported() || !folio_test_large(folio))) {
> >  			list_add(&folio->lru, &demote_folios);
> >  			folio_unlock(folio);
