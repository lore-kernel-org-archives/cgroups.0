From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 15:51:07 +0800
Message-ID: <Y1o4a0HzYTZRArhU@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx>
 <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
 <Y1kl8VbPE0RYdyEB@feng-clx>
 <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
 <CAHbLzkppDPm87dx9-a7t3oP9DuZ0xCPC1UWr+E-s+vh12Gwb+w@mail.gmail.com>
 <Y1ovOeEPXT1fxCuc@feng-clx>
 <87k04lk8vr.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666857082; x=1698393082;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=no6JZxzuKIXDL1nI+sQ6MVtarCowvwN2y8ViNLYssKs=;
  b=PPSQ+oU8eZDo+70S3IEmF/NhrOxtc/ExF46tFq0sfVdUPeeNS1wV14Ok
   KegK79dhW70GuxscINmdhieegFjVTU4rhZwIaKYnV9Y12GB1UwYGNjUK6
   EPAhVdX853O8XiHZ8uk3AKY9SqVXEF+kQWlIdNkNMq6h96TiaTI7vkEG+
   aBU0bLXfNAUygkrdvdEGUFYq38ZFGlU2lqpESQGeow9JwpPMEKdQUrMgR
   O1O9vI0nybE83sTwsOX0Taf5tKzJwM5RTQyPrXSUqRY4OBTqrmmj0+c1s
   QB1WIHmnQNWd3K/BE2LoAAp9ypIeEK3nmJcqf1iC+ORL6o5k/WaPN/mtj
   Q==;
Content-Disposition: inline
In-Reply-To: <87k04lk8vr.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Oct 27, 2022 at 03:45:12PM +0800, Huang, Ying wrote:
> Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> 
> > On Thu, Oct 27, 2022 at 01:57:52AM +0800, Yang Shi wrote:
> >> On Wed, Oct 26, 2022 at 8:59 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > [...]
> >> > > > This all can get quite expensive so the primary question is, does the
> >> > > > existing behavior generates any real issues or is this more of an
> >> > > > correctness exercise? I mean it certainly is not great to demote to an
> >> > > > incompatible numa node but are there any reasonable configurations when
> >> > > > the demotion target node is explicitly excluded from memory
> >> > > > policy/cpuset?
> >> > >
> >> > > We haven't got customer report on this, but there are quite some customers
> >> > > use cpuset to bind some specific memory nodes to a docker (You've helped
> >> > > us solve a OOM issue in such cases), so I think it's practical to respect
> >> > > the cpuset semantics as much as we can.
> >> >
> >> > Yes, it is definitely better to respect cpusets and all local memory
> >> > policies. There is no dispute there. The thing is whether this is really
> >> > worth it. How often would cpusets (or policies in general) go actively
> >> > against demotion nodes (i.e. exclude those nodes from their allowes node
> >> > mask)?
> >> >
> >> > I can imagine workloads which wouldn't like to get their memory demoted
> >> > for some reason but wouldn't it be more practical to tell that
> >> > explicitly (e.g. via prctl) rather than configuring cpusets/memory
> >> > policies explicitly?
> >> >
> >> > > Your concern about the expensive cost makes sense! Some raw ideas are:
> >> > > * if the shrink_folio_list is called by kswapd, the folios come from
> >> > >   the same per-memcg lruvec, so only one check is enough
> >> > > * if not from kswapd, like called form madvise or DAMON code, we can
> >> > >   save a memcg cache, and if the next folio's memcg is same as the
> >> > >   cache, we reuse its result. And due to the locality, the real
> >> > >   check is rarely performed.
> >> >
> >> > memcg is not the expensive part of the thing. You need to get from page
> >> > -> all vmas::vm_policy -> mm -> task::mempolicy
> >> 
> >> Yeah, on the same page with Michal. Figuring out mempolicy from page
> >> seems quite expensive and the correctness can't be guranteed since the
> >> mempolicy could be set per-thread and the mm->task depends on
> >> CONFIG_MEMCG so it doesn't work for !CONFIG_MEMCG.
> >
> > Yes, you are right. Our "working" psudo code for mem policy looks like
> > what Michal mentioned, and it can't work for all cases, but try to
> > enforce it whenever possible:
> >
> > static bool  __check_mpol_demotion(struct folio *folio, struct vm_area_struct *vma,
> > 		unsigned long addr, void *arg)
> > {
> > 	bool *skip_demotion = arg;
> > 	struct mempolicy *mpol;
> > 	int nid, dnid;
> > 	bool ret = true;
> >
> > 	mpol = __get_vma_policy(vma, addr);
> > 	if (!mpol) {
> > 		struct task_struct *task;
> 
>                 task = NULL;
> 
> > 		if (vma->vm_mm)
> > 			task = vma->vm_mm->owner;
> >
> > 		if (task) {
> > 			mpol = get_task_policy(task);
> > 			if (mpol)
> > 				mpol_get(mpol);
> > 		}
> > 	}
> >
> > 	if (!mpol)
> > 		return ret;
> >
> > 	if (mpol->mode != MPOL_BIND)
> > 		goto put_exit;
> >
> > 	nid = folio_nid(folio);
> > 	dnid = next_demotion_node(nid);
> > 	if (!node_isset(dnid, mpol->nodes)) {
> > 		*skip_demotion = true;
> > 		ret = false;
> > 	}
> 
> I think that you need to get a node mask instead.  Even if
> !node_isset(dnid, mpol->nodes), you may demote to other node in the node
> mask.

Yes, you are right. This code was written/tested about 2 months ago,
before Aneesh's memory tiering interface patchset. It was listed
to demonstrate idea of solution. 

Thanks,
Feng

> Best Regards,
> Huang, Ying
