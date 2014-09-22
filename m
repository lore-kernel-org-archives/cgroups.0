From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: support transparent huge pages under
 pressure
Date: Mon, 22 Sep 2014 14:18:03 +0400
Message-ID: <20140922101803.GB20398@esperanza>
References: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411132840-16025-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 19, 2014 at 09:20:40AM -0400, Johannes Weiner wrote:
> In a memcg with even just moderate cache pressure, success rates for
> transparent huge page allocations drop to zero, wasting a lot of
> effort that the allocator puts into assembling these pages.
> 
> The reason for this is that the memcg reclaim code was never designed
> for higher-order charges.  It reclaims in small batches until there is
> room for at least one page.  Huge pages charges only succeed when
> these batches add up over a series of huge faults, which is unlikely
> under any significant load involving order-0 allocations in the group.
> 
> Remove that loop on the memcg side in favor of passing the actual
> reclaim goal to direct reclaim, which is already set up and optimized
> to meet higher-order goals efficiently.
> 
> This brings memcg's THP policy in line with the system policy: if the
> allocator painstakingly assembles a hugepage, memcg will at least make
> an honest effort to charge it.  As a result, transparent hugepage
> allocation rates amid cache activity are drastically improved:
> 
>                                       vanilla                 patched
> pgalloc                 4717530.80 (  +0.00%)   4451376.40 (  -5.64%)
> pgfault                  491370.60 (  +0.00%)    225477.40 ( -54.11%)
> pgmajfault                    2.00 (  +0.00%)         1.80 (  -6.67%)
> thp_fault_alloc               0.00 (  +0.00%)       531.60 (+100.00%)
> thp_fault_fallback          749.00 (  +0.00%)       217.40 ( -70.88%)
> 
> [ Note: this may in turn increase memory consumption from internal
>   fragmentation, which is an inherent risk of transparent hugepages.
>   Some setups may have to adjust the memcg limits accordingly to
>   accomodate this - or, if the machine is already packed to capacity,
>   disable the transparent huge page feature. ]
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Looks like a really nice change to me. FWIW,

Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
