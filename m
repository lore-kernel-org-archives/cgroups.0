From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 13:49:25 +0800
Message-ID: <Y1ob5XxqJzTDjBYy@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <878rl1luh1.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666849788; x=1698385788;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=75y0P6V1OYHRCfS/qMOaXMWuDPb16+hqAgnNzT8B47E=;
  b=BXn4IPpVszXzuc9fJHCsOcorXT/NiTyUlcPDRhJ41Pw4J6AAJFK5uQfy
   6xWJJCP+4JPpgwrrmbWZ7JGvp/T7ghZjqaLQfSa3UOJItkvSSyRGFrc6e
   jRHK7L/fIcIXAlB0r/Ood0JdK6XSmPfXC1R4wjoN0XrH8XvFwJXEy5ey2
   kA5Qtt7v0JOBYYU0UnIzQV8q2Cml5eQ6FqGSSKPraxxzF8Gs9ySATcN/w
   0nZ7HIqAcjnCtckrZ8U9sO8LWE0s76tDYmdzpev9rbXAcgv2Ts7fA4T3F
   USXNARVnlvjfQ6DfHkit0AF2t9vM6tCCQkzE0xKA8esBh2Yix+11KzUUX
   Q==;
Content-Disposition: inline
In-Reply-To: <878rl1luh1.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Oct 27, 2022 at 01:13:30PM +0800, Huang, Ying wrote:
> Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> 
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
[...]
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
> 
> I think we should avoid (void *) conversion here.

OK, will change back.

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
> 
> If node_isset(mtc->nid, cpuset_nmask) == true, we should keep the
> original 2 steps allocation and apply nodes_and() on node mask.

Good catch! Yes, the nodes_and() call should be taken out from this
check and done before calling node_isset().

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
> 
> pgdat will not change in the loop, so we can move this out of the loop?
 
Yes

> > +			memcg = folio_memcg(folio);
> > +			if (memcg)
> > +				cpuset_get_allowed_mem_nodes(memcg->css.cgroup,
> > +								&nmask1);
> > +
> > +			if (!nodes_intersects(nmask, nmask1))
> > +				skip_this_demotion = true;
> > +		}
> 
> If nodes_intersects() == true, we will call
> cpuset_get_allowed_mem_nodes() twice.  Better to pass the intersecting
> mask to demote_folio_list()?
 
The pages in the loop may come from different mem control group, and
the cpuset's nodemask could be different, I don't know how to save
this per-page info to be used later in demote_folio_list.

Thanks,
Feng

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
> 
> Best Regards,
> Huang, Ying
