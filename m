From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 13:57:20 +0800
Message-ID: <Y1odwO1/5fxqvQNn@feng-clx>
References: <20221026074343.6517-1-feng.tang@intel.com>
 <da533477-da08-88cb-1e76-46364f1a6151@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666850255; x=1698386255;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PpyW5P1A1nyfaGrNFMcz1Qt4uf1ujLGkCzaNkQuQ8XI=;
  b=JFQaO4pbI0VbcG8uFk1GLkR5MemxjrOoZ23BgpsKaysb3fXJ5EUXIGMG
   3XASjPDi1ETWslG1Mbzh4CNlvjTB8kE/uuw9P1LZS1N8UwJO1Q74++rp3
   1k8RnWMrOXrzwoRA49hKT55ViCy0nh3js/QGrankP1JDA1L/hSzTwO6jS
   MqI0PHFF7EIHa1SpJksqo12AMDHiBF/nWptx4FaILak5yE8BjXReoXLO8
   cxV3JHDL+ffFPSf656iyPLh1CMcNRUBJaLRepkM7on+IOVYWcKL02KO+K
   sdCV48HDcsMcM6+IVzQO5SIUUjBHOLGmSl/GdkiZ/hEQXmpK9qVgrLsxJ
   g==;
Content-Disposition: inline
In-Reply-To: <da533477-da08-88cb-1e76-46364f1a6151-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Hocko, Michal" <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Oct 26, 2022 at 10:36:32PM +0800, Waiman Long wrote:
> On 10/26/22 03:43, Feng Tang wrote:
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
> >   include/linux/cpuset.h |  6 ++++++
> >   kernel/cgroup/cpuset.c | 29 +++++++++++++++++++++++++++++
> >   mm/vmscan.c            | 35 ++++++++++++++++++++++++++++++++---
> >   3 files changed, 67 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index d58e0476ee8e..6fcce2bd2631 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -178,6 +178,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
> >   	task_unlock(current);
> >   }
> >   
> > +extern void cpuset_get_allowed_mem_nodes(struct cgroup *cgroup,
> > +						nodemask_t *nmask);
> >   #else /* !CONFIG_CPUSETS */
> >   
> >   static inline bool cpusets_enabled(void) { return false; }
> > @@ -299,6 +301,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
> >   	return false;
> >   }
> >   
> > +static inline void cpuset_get_allowed_mem_nodes(struct cgroup *cgroup,
> > +						nodemask_t *nmask)
> > +{
> > +}
> >   #endif /* !CONFIG_CPUSETS */
> >   
> >   #endif /* _LINUX_CPUSET_H */
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index 3ea2e836e93e..cbb118c0502f 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -3750,6 +3750,35 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
> >   	return mask;
> >   }
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
> 
> You are allowing all nodes to be used for cgroup v1. Is there a reason 
> why you ignore v1?
 
The use case for the API is, for a memory control group, user want to
get its associated cpuset controller's memory policy, so it tries
the memcg --> cgroup --> cpuset chain. IIUC, there is no a reliable
chain for cgroup v1, plus cgroup v2 is the default option for many
distros, the cgroup v1 is bypassed here.

> > +
> > +	rcu_read_lock();
> > +	css = cgroup_e_css(cgroup, &cpuset_cgrp_subsys);
> > +	if (css) {
> > +		css_get(css);
> > +		cs = css_cs(css);
> > +		*nmask = cs->effective_mems;
> > +		css_put(css);
> > +	}
> Since you are holding an RCU read lock and copying out the whole 
> nodemask, you probably don't need to do a css_get/css_put pair.

Thanks for the note!

Thanks,
Feng

> > +
> > +	rcu_read_unlock();
> > +}
> > +
> Cheers,
> 
> Longman
> 
