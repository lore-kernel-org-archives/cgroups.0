From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 1/3] mm: memcontrol: take a css reference for each
 charged page
Date: Wed, 8 Oct 2014 15:27:54 +0200
Message-ID: <20141008132754.GB4592@dhcp22.suse.cz>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
 <1411243235-24680-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411243235-24680-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 20-09-14 16:00:33, Johannes Weiner wrote:
> Charges currently pin the css indirectly by playing tricks during
> css_offline(): user pages stall the offlining process until all of
> them have been reparented, whereas kmemcg acquires a keep-alive
> reference if outstanding kernel pages are detected at that point.
> 
> In preparation for removing all this complexity, make the pinning
> explicit and acquire a css references for every charged page.

OK, all the added {un}charges/atomics happen in a page_counter paths so
there shouldn't be any noticeable overhead.

I cannot judge the percpu counter part but the rest seems OK to me.
Two minor suggestions below.

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

For the memcg part
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/cgroup.h          | 26 +++++++++++++++++++++++++
>  include/linux/percpu-refcount.h | 43 ++++++++++++++++++++++++++++++++---------
>  mm/memcontrol.c                 | 17 +++++++++++++++-
>  3 files changed, 76 insertions(+), 10 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 154161bb7d4c..b832c87ec43b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2317,6 +2317,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  		page_counter_uncharge(&old->memory, stock->nr_pages);
>  		if (do_swap_account)
>  			page_counter_uncharge(&old->memsw, stock->nr_pages);

		/* pairs with css_get_many in try_charge */
> +		css_put_many(&old->css, stock->nr_pages);
>  		stock->nr_pages = 0;
>  	}
>  	stock->cached = NULL;
[...]
> @@ -2803,8 +2808,10 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
>  		page_counter_uncharge(&memcg->memsw, nr_pages);
>  

Wouldn't a single out_css_put be more readable? I was quite confused
when I start reading the patch before I saw the next hunk.

>  	/* Not down to 0 */
> -	if (page_counter_uncharge(&memcg->kmem, nr_pages))
		goto out_css_put;

> +	if (page_counter_uncharge(&memcg->kmem, nr_pages)) {
> +		css_put_many(&memcg->css, nr_pages);
>  		return;
> +	}
>  
>  	/*
>  	 * Releases a reference taken in kmem_cgroup_css_offline in case
> @@ -2816,6 +2823,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
>  	 */
>  	if (memcg_kmem_test_and_clear_dead(memcg))
>  		css_put(&memcg->css);
> +

out_css_put:
> +	css_put_many(&memcg->css, nr_pages);
>  }
>  
>  /*
-- 
Michal Hocko
SUSE Labs
