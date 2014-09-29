From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 3/3] mm: memcontrol: fix transparent huge page
 allocations under pressure
Date: Mon, 29 Sep 2014 13:57:00 -0400
Message-ID: <20140929175700.GA20053@cmpxchg.org>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-4-git-send-email-hannes@cmpxchg.org>
 <20140929135707.GA25956@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140929135707.GA25956-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On Mon, Sep 29, 2014 at 03:57:07PM +0200, Michal Hocko wrote:
> On Wed 24-09-14 11:08:58, Johannes Weiner wrote:
> > In a memcg with even just moderate cache pressure, success rates for
> > transparent huge page allocations drop to zero, wasting a lot of
> > effort that the allocator puts into assembling these pages.
> > 
> > The reason for this is that the memcg reclaim code was never designed
> > for higher-order charges.  It reclaims in small batches until there is
> > room for at least one page.  Huge page charges only succeed when these
> > batches add up over a series of huge faults, which is unlikely under
> > any significant load involving order-0 allocations in the group.
> > 
> > Remove that loop on the memcg side in favor of passing the actual
> > reclaim goal to direct reclaim, which is already set up and optimized
> > to meet higher-order goals efficiently.
> 
> I had concerns the last time you were posting similar patch
> (http://marc.info/?l=linux-mm&m=140803277013080&w=2) but I do not see
> any of them neither mentioned nor addressed here.

I actually made several attempts to address your concerns, but it's
hard to discern technical objections from what you write.  Example:

> Especially unexpected long stalls and excessive swapout. 512 pages
> target for direct reclaim is too much. Especially for smaller memcgs
> where we would need to drop the priority considerably to even scan
> that many pages.  THP charges close to the limit are definitely a
> problem but this is way too risky to fix this problem IMO.

Every change we make is a trade-off and bears a certain risk.  THP is
a trade-off, it's pretty pointless to ignore the upsides and ride
around on the downsides.  Of course there are downsides.  This patch
makes THP work properly inside memcg, which invites both the upsides
as well as the downsides of THP into memcg.  But they are well known
and we can deal with them.  Why is THP inside memcg special?

Sure, the smaller the memcg, the bigger the THP fault and scan target
in comparison.  We don't have control over the THP size, but the user
can always increase the size of the memcg, iff THP leads to increased
fragmentation and memory consumption for the given workload.

[ Until he can't, at which point he has to decide whether the cost of
  THP outweighs the benefits on a system-wide level.  For now - we
  could certainly consider making a THP-knob available per memcg, I'm
  just extrapolating from the fact that we don't have a per-process
  knob that it's unlikely that we need one per memcg. ]

> Maybe a better approach
> would be to limit the reclaim to (clean) page cache (aka
> MEM_CGROUP_RECLAIM_NOSWAP). The risk of long stalls should be much
> lower and excessive swapouts shouldn't happen at all. What is the point
> to swap out a large number of pages just to allow THP charge which can
> be used very sparsely?

THP can lead to thrashing, that's not news.  Preventing THP faults
from swapping is a reasonable proposal, but again has nothing to do
with memcg.

As for this patch, we don't have sufficient data on existing
configurations to know if this will lead to noticable regressions.  It
might, but everything we do might cause a regression, that's just our
reality.  That alone can't be grounds for rejecting a patch.  However,
in this particular case a regression is trivial to pinpoint (comparing
vmstat, profiles), and trivial to rectify in the field by changing the
memcg limits or disabling THP.

What we DO know is that there are very good use cases for THP, but THP
inside memcg is broken: THP does worse inside a memcg when compared to
bare metal environments of the same size, both in terms of success
rate, as well as in fault latency due to wasted page allocator work.
Plus, the code is illogical, redundant, and full of magic numbers.

Based on this, this patch seems like a net improvement.

> > This brings memcg's THP policy in line with the system policy: if the
> > allocator painstakingly assembles a hugepage, memcg will at least make
> > an honest effort to charge it.  As a result, transparent hugepage
> > allocation rates amid cache activity are drastically improved:
> > 
> >                                       vanilla                 patched
> > pgalloc                 4717530.80 (  +0.00%)   4451376.40 (  -5.64%)
> > pgfault                  491370.60 (  +0.00%)    225477.40 ( -54.11%)
> > pgmajfault                    2.00 (  +0.00%)         1.80 (  -6.67%)
> > thp_fault_alloc               0.00 (  +0.00%)       531.60 (+100.00%)
> > thp_fault_fallback          749.00 (  +0.00%)       217.40 ( -70.88%)
> 
> What is the load and configuration that you have measured?

It's just a single linear disk writer and another thread that faults
in an anonymous range in 4k steps.

> > [ Note: this may in turn increase memory consumption from internal
> >   fragmentation, which is an inherent risk of transparent hugepages.
> >   Some setups may have to adjust the memcg limits accordingly to
> >   accomodate this - or, if the machine is already packed to capacity,
> >   disable the transparent huge page feature. ]
