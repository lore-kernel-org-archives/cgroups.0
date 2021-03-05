From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: Fix dropped memcg from mem cgroup soft limit
 tree
Date: Fri, 5 Mar 2021 10:11:32 +0100
Message-ID: <YEH1xF8xm9MCsQ+q@dhcp22.suse.cz>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen@linux.intel.com>
 <YC68Xo9+R2msn/ul@dhcp22.suse.cz>
 <72cb8618-73af-ce08-d5d5-30cab30755a3@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614935493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EzbUJaQzdHyWQWYArhmveTTGFRarGR/POWGz43IcYds=;
        b=WRAaCcQBvs+ROf3f9UYV/D5gQd6QjIR+GA8FQRtJa9yLj8pNsiAOX+ib91QiwXx0hYx4RR
        mn/4s+tYkhD/511Jt70xhn81DN9x2VKzKHKpFTYjldQOsPKUbcNBryoZvo3dIj3w0LXlXm
        RMeKmKWNxJzpK7WkhmjVLRsp90kFNSs=
Content-Disposition: inline
In-Reply-To: <72cb8618-73af-ce08-d5d5-30cab30755a3-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 04-03-21 09:35:08, Tim Chen wrote:
> 
> 
> On 2/18/21 11:13 AM, Michal Hocko wrote:
> 
> > 
> > Fixes: 4e41695356fb ("memory controller: soft limit reclaim on contention")
> > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > 
> > Thanks!
> >> ---
> >>  mm/memcontrol.c | 6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index ed5cc78a8dbf..a51bf90732cb 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -3505,8 +3505,12 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
> >>  			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
> >>  			break;
> >>  	} while (!nr_reclaimed);
> >> -	if (next_mz)
> >> +	if (next_mz) {
> >> +		spin_lock_irq(&mctz->lock);
> >> +		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
> >> +		spin_unlock_irq(&mctz->lock);
> >>  		css_put(&next_mz->memcg->css);
> >> +	}
> >>  	return nr_reclaimed;
> >>  }
> >>  
> >> -- 
> >> 2.20.1
> > 
> 
> Mel,
> 
> Reviewing this patch a bit more, I realize that there is a chance that the removed
> next_mz could be inserted back to the tree from a memcg_check_events
> that happen in between.  So we need to make sure that the next_mz
> is indeed off the tree and update the excess value before adding it
> back.  Update the patch to the patch below.

This scenario is certainly possible but it shouldn't really matter much
as __mem_cgroup_insert_exceeded bails out when the node is on the tree
already.
-- 
Michal Hocko
SUSE Labs
