From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: Fix dropped memcg from mem cgroup soft limit
 tree
Date: Thu, 18 Feb 2021 09:24:55 +0100
Message-ID: <YC4kV7dkJpxjW+df@dhcp22.suse.cz>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613636696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KUTYu5268imgiklm3bMZR/IfsonyJHTyi5EUt0/rAyg=;
        b=iA+FoNDqGJJyNKtrQaOYMuz2zt2bVm9M0Jbw7OFp5H7WPLCYJ+S5i7/An/7VTj2rxjQyOj
        6RCbmW8ACQ9JNr0EIN2W7nefIfXopiOgBFGS/gACHv3vLHu5KHwpQMezQMz9YLHkYgqB7l
        PB0f6FnQeAe8E5zL2G2CKFoX+bgg4WA=
Content-Disposition: inline
In-Reply-To: <8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 17-02-21 12:41:34, Tim Chen wrote:
> During soft limit memory reclaim, we will temporarily remove the target
> mem cgroup from the cgroup soft limit tree.  We then perform memory
> reclaim, update the memory usage excess count and re-insert the mem
> cgroup back into the mem cgroup soft limit tree according to the new
> memory usage excess count.
> 
> However, when memory reclaim failed for a maximum number of attempts
> and we bail out of the reclaim loop, we forgot to put the target mem
> cgroup chosen for next reclaim back to the soft limit tree. This prevented
> pages in the mem cgroup from being reclaimed in the future even though
> the mem cgroup exceeded its soft limit.  Fix the logic and put the mem
> cgroup back on the tree when page reclaim failed for the mem cgroup.
> 
> Reviewed-by: Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I have already acked this patch in the previous version along with Fixes
tag. It seems that my review feedback has been completely ignored also
for other patches in this series.

> ---
>  mm/memcontrol.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed5cc78a8dbf..a51bf90732cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3505,8 +3505,12 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
>  			break;
>  	} while (!nr_reclaimed);
> -	if (next_mz)
> +	if (next_mz) {
> +		spin_lock_irq(&mctz->lock);
> +		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
> +		spin_unlock_irq(&mctz->lock);
>  		css_put(&next_mz->memcg->css);
> +	}
>  	return nr_reclaimed;
>  }
>  
> -- 
> 2.20.1

-- 
Michal Hocko
SUSE Labs
