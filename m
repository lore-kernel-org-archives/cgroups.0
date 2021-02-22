From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Mon, 22 Feb 2021 09:41:40 +0100
Message-ID: <YDNuRFgJPH4bPEbq@dhcp22.suse.cz>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
 <YC+B2KvJVSgfVDTe@dhcp22.suse.cz>
 <1ecd277e-c236-08e1-f068-3dd65ee0e640@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613983386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BGr3u1/QiWkqeNGAS3nuSf2LPGyseFbACm8rcGmaFMU=;
        b=jyTfTBszQLX9et73++r8X7IxIMrqlNpH9jZPmxVJzzdhnlZPOwgMlrZ6YcBxmmoy7ZqRr5
        qbnq8T2JOps4nShL425LoAycwSUXe1OHGYvGk+eF2wrI48AKF5j2qyuB2JUpW6u+PxgFj3
        WJ04qlNgi/dXFFcAUlVp1OXf9kWxaTc=
Content-Disposition: inline
In-Reply-To: <1ecd277e-c236-08e1-f068-3dd65ee0e640-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 19-02-21 11:28:47, Tim Chen wrote:
> 
> 
> On 2/19/21 1:16 AM, Michal Hocko wrote:
> 
> >>
> >> Something like this?
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 8bddee75f5cb..b50cae3b2a1a 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -3472,6 +3472,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
> >>                 if (!mz)
> >>                         break;
> >>
> >> +               /*
> >> +                * Soft limit tree is updated based on memcg events sampling.
> >> +                * We could have missed some updates on page uncharge and
> >> +                * the cgroup is below soft limit.  Skip useless soft reclaim.
> >> +                */
> >> +               if (!soft_limit_excess(mz->memcg))
> >> +                       continue;
> >> +
> >>                 nr_scanned = 0;
> >>                 reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
> > 
> > Yes I meant something like this but then I have looked more closely and
> > this shouldn't be needed afterall. __mem_cgroup_largest_soft_limit_node
> > already does all the work
> >         if (!soft_limit_excess(mz->memcg) ||
> >             !css_tryget(&mz->memcg->css))
> >                 goto retry;
> > so this shouldn't really happen.
> > 
> 
> Ah, that's true.  The added check for soft_limit_excess is not needed.
> 
> Do you think it is still a good idea to add patch 3 to
> restrict the uncharge update in page batch of the same node and cgroup?

I would rather drop it. The less the soft limit reclaim code is spread
around the better.
-- 
Michal Hocko
SUSE Labs
