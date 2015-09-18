From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix order calculation in try_charge()
Date: Fri, 18 Sep 2015 09:42:17 +0200
Message-ID: <20150918074217.GD15395@cmpxchg.org>
References: <1442318757-7141-1-git-send-email-jmarchan@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442318757-7141-1-git-send-email-jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 15, 2015 at 02:05:57PM +0200, Jerome Marchand wrote:
> Since commit <6539cc05386> (mm: memcontrol: fold mem_cgroup_do_charge()),
> the order to pass to mem_cgroup_oom() is calculated by passing the number
> of pages to get_order() instead of the expected  size in bytes. AFAICT,
> it only affects the value displayed in the oom warning message.
> This patch fix this.
> 
> Signed-off-by: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks, Jerome. One minor thing:

> @@ -2032,7 +2032,8 @@ retry:
>  
>  	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
>  
> -	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
> +	mem_cgroup_oom(mem_over_limit, gfp_mask,
> +		       get_order(nr_pages * PAGE_SIZE));

fls(nr_pages)?

get_order() is basically fls(x / PAGE_SIZE).
