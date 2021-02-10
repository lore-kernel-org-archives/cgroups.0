From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: Fix dropped memcg from mem cgroup soft limit tree
Date: Wed, 10 Feb 2021 10:47:44 +0100
Message-ID: <YCOrwHvktsN5Kuc+@dhcp22.suse.cz>
References: <cover.1612902157.git.tim.c.chen@linux.intel.com>
 <d50e3bb513845d1f7816b94733576ce6f798682a.1612902157.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612950468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fdOKlGdBQ+hhHPE98TkFop+2UQxW0u+WMNNhnyafX9Q=;
        b=TH4zS6eBWoevbm4jAsK0+oZMMY2MFI6CHMoLEJY2Jj0ho1cPXvNBVdNcmpQz+y80cOz2pb
        lT5RtH88wV0Q+o3pZSJjNtoCvVw7QPP5KzSk4hyJZqBNGWhjiGGgqEoySHGkUceUMYIZal
        b3CKioh8b9ixkAWkmkaSPdNs/EKGI9A=
Content-Disposition: inline
In-Reply-To: <d50e3bb513845d1f7816b94733576ce6f798682a.1612902157.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 09-02-21 12:29:45, Tim Chen wrote:
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

It seems this goes all the way to when it has been introduced by 
4e41695356fb ("memory controller: soft limit reclaim on contention").
Please add a Fixes tag pointing to the above one. While this looks like
a rare event to happen because there should be some reclaimable memory
usually.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

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
