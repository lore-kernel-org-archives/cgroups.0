From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Wed, 26 Oct 2022 20:20:01 +0800
Message-ID: <Y1kl8VbPE0RYdyEB@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
 <Y1jpDfwBQId3GkJC@feng-clx>
 <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666786815; x=1698322815;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UWStb3Hq9K2VYjGnDiKV0VeG96RDPegWwO3DvjRkO4E=;
  b=jbtPwjwbwbOhu7+Bnat7NHXEJP5WHHZCSOOJMXunif+Cm0N519/jx+IS
   upbIaWXmlFGjfkb1DAtePVoXAz9GmVnkO0HyHBgd2QGUvcneXejrybaJr
   XpZdt6/amnM7qWYo3HNlR1muJfdfa4UFXPIxWKkFNd7mRcBPh40zoxBx/
   9F8ABwAo3IflzLtlTYBDv2YBy1ZzkjC7HbuGAo1l/loQIrJHCeGUoX6SX
   Z1IW5yZf33ai8l+ZjuAYJ+yiS6sA4GaAkoIpjol9jmVUhz5JXl5nXws6p
   lsN9QQrdi+I8OiuwC0Z5htMi4g5FcQ3+l63I198HeLW1j7EBIVgbydY7U
   g==;
Content-Disposition: inline
In-Reply-To: <Y1j7tsj5M0Md/+Er-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Oct 26, 2022 at 05:19:50PM +0800, Michal Hocko wrote:
> On Wed 26-10-22 16:00:13, Feng Tang wrote:
> > On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
> > > On 10/26/22 1:13 PM, Feng Tang wrote:
> > > > In page reclaim path, memory could be demoted from faster memory tier
> > > > to slower memory tier. Currently, there is no check about cpuset's
> > > > memory policy, that even if the target demotion node is not allowd
> > > > by cpuset, the demotion will still happen, which breaks the cpuset
> > > > semantics.
> > > > 
> > > > So add cpuset policy check in the demotion path and skip demotion
> > > > if the demotion targets are not allowed by cpuset.
> > > > 
> > > 
> > > What about the vma policy or the task memory policy? Shouldn't we respect
> > > those memory policy restrictions while demoting the page? 
> >  
> > Good question! We have some basic patches to consider memory policy
> > in demotion path too, which are still under test, and will be posted
> > soon. And the basic idea is similar to this patch.
> 
> For that you need to consult each vma and it's owning task(s) and that
> to me sounds like something to be done in folio_check_references.
> Relying on memcg to get a cpuset cgroup is really ugly and not really
> 100% correct. Memory controller might be disabled and then you do not
> have your association anymore.
 
You are right, for cpuset case, the solution depends on 'CONFIG_MEMCG=y',
and the bright side is most of distribution have it on.

> This all can get quite expensive so the primary question is, does the
> existing behavior generates any real issues or is this more of an
> correctness exercise? I mean it certainly is not great to demote to an
> incompatible numa node but are there any reasonable configurations when
> the demotion target node is explicitly excluded from memory
> policy/cpuset?

We haven't got customer report on this, but there are quite some customers
use cpuset to bind some specific memory nodes to a docker (You've helped
us solve a OOM issue in such cases), so I think it's practical to respect
the cpuset semantics as much as we can.

Your concern about the expensive cost makes sense! Some raw ideas are:
* if the shrink_folio_list is called by kswapd, the folios come from
  the same per-memcg lruvec, so only one check is enough
* if not from kswapd, like called form madvise or DAMON code, we can
  save a memcg cache, and if the next folio's memcg is same as the
  cache, we reuse its result. And due to the locality, the real
  check is rarely performed.

Thanks,
Feng

> -- 
> Michal Hocko
> SUSE Labs
> 
