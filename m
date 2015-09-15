From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix order calculation in try_charge()
Date: Tue, 15 Sep 2015 15:56:23 +0200
Message-ID: <20150915135623.GA26649@dhcp22.suse.cz>
References: <1442318757-7141-1-git-send-email-jmarchan@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442318757-7141-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 15-09-15 14:05:57, Jerome Marchand wrote:
> Since commit <6539cc05386> (mm: memcontrol: fold mem_cgroup_do_charge()),
> the order to pass to mem_cgroup_oom() is calculated by passing the number
> of pages to get_order() instead of the expected  size in bytes. AFAICT,
> it only affects the value displayed in the oom warning message.
> This patch fix this.

We haven't noticed that just because the OOM is enabled only for page
faults of order-0 (single page) and get_order work just fine. Thanks for
noticing this. If we ever start triggering OOM on different orders this
would be broken.
 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Btw. a quick git grep shows that at least gart_iommu_init is using
number of pages as well. I haven't checked it does that intentionally,
though.

Thanks!

> ---
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1742a2d..91bf094 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2032,7 +2032,8 @@ retry:
>  
>  	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
>  
> -	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
> +	mem_cgroup_oom(mem_over_limit, gfp_mask,
> +		       get_order(nr_pages * PAGE_SIZE));
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
>  		return -ENOMEM;
> -- 
> 1.9.3

-- 
Michal Hocko
SUSE Labs
