From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/5] mm: memcontrol: take a css reference for each
 charged page
Date: Wed, 15 Oct 2014 17:18:36 +0200
Message-ID: <20141015151836.GG23547@dhcp22.suse.cz>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413303637-23862-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 14-10-14 12:20:34, Johannes Weiner wrote:
> Charges currently pin the css indirectly by playing tricks during
> css_offline(): user pages stall the offlining process until all of
> them have been reparented, whereas kmemcg acquires a keep-alive
> reference if outstanding kernel pages are detected at that point.
> 
> In preparation for removing all this complexity, make the pinning
> explicit and acquire a css references for every charged page.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/cgroup.h          | 26 +++++++++++++++++++++++
>  include/linux/percpu-refcount.h | 47 +++++++++++++++++++++++++++++++++--------
>  mm/memcontrol.c                 | 21 ++++++++++++++----
>  3 files changed, 81 insertions(+), 13 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 67dabe8b0aa6..a3feead6be15 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2256,6 +2256,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  		page_counter_uncharge(&old->memory, stock->nr_pages);
>  		if (do_swap_account)
>  			page_counter_uncharge(&old->memsw, stock->nr_pages);
> +		css_put_many(&old->css, stock->nr_pages);

I have suggested to add a comment about pairing css_get here because the
corresponding refill_stock doesn't take any reference which might be
little bit confusing. Nothing earth shattering of course...

>  		stock->nr_pages = 0;
>  	}
>  	stock->cached = NULL;
> @@ -2513,6 +2514,7 @@ bypass:
>  	return -EINTR;
>  
>  done_restock:
> +	css_get_many(&memcg->css, batch);
>  	if (batch > nr_pages)
>  		refill_stock(memcg, batch - nr_pages);
>  done:
[...]
-- 
Michal Hocko
SUSE Labs
