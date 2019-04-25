From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] memcg: refill_stock for kmem uncharging too
Date: Thu, 25 Apr 2019 08:48:58 +0200
Message-ID: <20190425064858.GL12751@dhcp22.suse.cz>
References: <20190423154405.259178-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190423154405.259178-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 23-04-19 08:44:05, Shakeel Butt wrote:
> The commit 475d0487a2ad ("mm: memcontrol: use per-cpu stocks for socket
> memory uncharging") added refill_stock() for skmem uncharging path to
> optimize workloads having high network traffic. Do the same for the kmem
> uncharging as well. Though we can bypass the refill for the offlined
> memcgs but it may impact the performance of network traffic for the
> sockets used by other cgroups.

While the change makes sense, I would really like to see what kind of
effect on performance does it really have. Do you have any specific
workload that benefits from it?

Thanks!

> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> Changelog since v1:
> - No need to bypass offline memcgs in the refill.
> 
>  mm/memcontrol.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2535e54e7989..2713b45ec3f0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2768,17 +2768,13 @@ void __memcg_kmem_uncharge(struct page *page, int order)
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		page_counter_uncharge(&memcg->kmem, nr_pages);
>  
> -	page_counter_uncharge(&memcg->memory, nr_pages);
> -	if (do_memsw_account())
> -		page_counter_uncharge(&memcg->memsw, nr_pages);
> -
>  	page->mem_cgroup = NULL;
>  
>  	/* slab pages do not have PageKmemcg flag set */
>  	if (PageKmemcg(page))
>  		__ClearPageKmemcg(page);
>  
> -	css_put_many(&memcg->css, nr_pages);
> +	refill_stock(memcg, nr_pages);
>  }
>  #endif /* CONFIG_MEMCG_KMEM */
>  
> -- 
> 2.21.0.593.g511ec345e18-goog
> 

-- 
Michal Hocko
SUSE Labs
