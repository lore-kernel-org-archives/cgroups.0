From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Try charging a page before setting page
 up to date
Date: Wed, 20 May 2015 17:15:21 +0100
Message-ID: <20150520161520.GR2462@suse.de>
References: <1432126245-10908-1-git-send-email-mgorman@suse.de>
 <1432126245-10908-2-git-send-email-mgorman@suse.de>
 <20150520152923.GA2874@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520152923.GA2874-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 20, 2015 at 11:29:23AM -0400, Johannes Weiner wrote:
> On Wed, May 20, 2015 at 01:50:44PM +0100, Mel Gorman wrote:
> > Historically memcg overhead was high even if memcg was unused. This has
> > improved a lot but it still showed up in a profile summary as being a
> > problem.
> > 
> > /usr/src/linux-4.0-vanilla/mm/memcontrol.c                           6.6441   395842
> >   mem_cgroup_try_charge                                                        2.950%   175781
> >   __mem_cgroup_count_vm_event                                                  1.431%    85239
> >   mem_cgroup_page_lruvec                                                       0.456%    27156
> >   mem_cgroup_commit_charge                                                     0.392%    23342
> >   uncharge_list                                                                0.323%    19256
> >   mem_cgroup_update_lru_size                                                   0.278%    16538
> >   memcg_check_events                                                           0.216%    12858
> >   mem_cgroup_charge_statistics.isra.22                                         0.188%    11172
> >   try_charge                                                                   0.150%     8928
> >   commit_charge                                                                0.141%     8388
> >   get_mem_cgroup_from_mm                                                       0.121%     7184
> > 
> > That is showing that 6.64% of system CPU cycles were in memcontrol.c and
> > dominated by mem_cgroup_try_charge. The annotation shows that the bulk of
> > the cost was checking PageSwapCache which is expected to be cache hot but is
> > very expensive. The problem appears to be that __SetPageUptodate is called
> > just before the check which is a write barrier. It is required to make sure
> > struct page and page data is written before the PTE is updated and the data
> > visible to userspace. memcg charging does not require or need the barrier
> > but gets unfairly hit with the cost so this patch attempts the charging
> > before the barrier.  Aside from the accidental cost to memcg there is the
> > added benefit that the barrier is avoided if the page cannot be charged.
> > When applied the relevant profile summary is as follows.
> > 
> > /usr/src/linux-4.0-chargefirst-v2r1/mm/memcontrol.c                  3.7907   223277
> >   __mem_cgroup_count_vm_event                                                  1.143%    67312
> 
> Out of curiosity, I'm still consistently reading this function at
> around 0.7%.  Are you profiling this single-threadedly or for the
> entire run?  For profiling 80 single-threaded iterations, I get:
> 

Single-threaded. The mmtests benchmark in question supports gathering one
profile per thread count so it's just the 1 thread profile I included in
the changelog. The CPU in question is a i7-3770

-- 
Mel Gorman
SUSE Labs
