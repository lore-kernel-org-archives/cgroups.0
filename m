From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove unneeded nr_scanned
Date: Mon, 28 Mar 2022 14:01:32 +0200
Message-ID: <YkGjnAOidFD8bA3a@dhcp22.suse.cz>
References: <20220328114144.53389-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1648468893; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c6Z5kgi2wB4asWItH9cY1KuHpvBDFVgytOlK7MLeiuA=;
        b=Gog9U0tdKPz+Wl+YHWZ8KNw1A2fwCjwtYp9Q+XJJJNcvkWmFWqyrbmiUHjSlgjYzBI9y0J
        R6gzG0GJ2Tj4tUSrSMqZkjJvpYL2NKDYqOXZGRaD8Eiof5wjPpJUf7xPAYYbI/9EWoEXpI
        4Y/n/ZiTuszwootYfN1QRb8I1uNjI4s=
Content-Disposition: inline
In-Reply-To: <20220328114144.53389-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 28-03-22 19:41:44, Miaohe Lin wrote:
> The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim always
> does *total_scanned += nr_scanned. So we can pass total_scanned directly to
> the mem_cgroup_soft_reclaim to simplify the code and save some cpu cycles
> of adding nr_scanned to total_scanned.

Maybe the compiler could be clever enough to generate a good code.
mem_cgroup_soft_reclaim doesn't have other caller so it could be
inlined. But I do agree that the change makes sense because it makes the
code more consistent as mem_cgroup_soft_limit_reclaim already uses
total_scanned this way.

> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks

> ---
>  mm/memcontrol.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b686ec4f42c6..79341365ec90 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3384,7 +3384,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  	int loop = 0;
>  	struct mem_cgroup_tree_per_node *mctz;
>  	unsigned long excess;
> -	unsigned long nr_scanned;
>  
>  	if (order > 0)
>  		return 0;
> @@ -3412,11 +3411,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  		if (!mz)
>  			break;
>  
> -		nr_scanned = 0;
>  		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
> -						    gfp_mask, &nr_scanned);
> +						    gfp_mask, total_scanned);
>  		nr_reclaimed += reclaimed;
> -		*total_scanned += nr_scanned;
>  		spin_lock_irq(&mctz->lock);
>  		__mem_cgroup_remove_exceeded(mz, mctz);
>  
> -- 
> 2.23.0

-- 
Michal Hocko
SUSE Labs
