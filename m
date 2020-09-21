From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 15/32] mm/lru: move lock into lru_note_cost
Date: Mon, 21 Sep 2020 14:36:52 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009211434490.5214@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-16-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YEHhXiwYGhR5s4kQG6zgTm8dChdzwLCMqEBAcwVay/I=;
        b=FHdmoZMn2GtG6M6npCvulWXP2W6zbv9j1/3z4NpqqPF4CZZIAljfJOMpLr/AU2uRnh
         MLdveaSRjUzPSvkKU/DlErd+prAWEQjXExuohssIxy9UltoW3ysPdWIcSIUp4LyWW1Jw
         f9iXMdTfFs8PZRMKMKNmrEqTZxqpk0pSNflZqnROIW4x8CU5+zxWAyPrd0JTK2S8usf5
         cPqbz7Dc5xC0sbOIcjVCnLcaK19VJiXht1ypF+z6GM1rUOhGT94Xfp0glBhXVfcUjwkE
         e+DCEVKAkYABqQqwtM6XQipNbujsVCq/177MSRg4OGLiC12Cy+yZJVoAvFcWKn21ctnh
         nh9A==
In-Reply-To: <1598273705-69124-16-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, 24 Aug 2020, Alex Shi wrote:

> We have to move lru_lock into lru_note_cost, since it cycle up on memcg
> tree, for future per lruvec lru_lock replace. It's a bit ugly and may
> cost a bit more locking, but benefit from multiple memcg locking could
> cover the lost.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

In your lruv19 github tree, you have merged 14/32 into this one: thanks.

> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/swap.c   | 5 +++--
>  mm/vmscan.c | 4 +---
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 906255db6006..f80ccd6f3cb4 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -269,7 +269,9 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
>  {
>  	do {
>  		unsigned long lrusize;
> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  
> +		spin_lock_irq(&pgdat->lru_lock);
>  		/* Record cost event */
>  		if (file)
>  			lruvec->file_cost += nr_pages;
> @@ -293,15 +295,14 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
>  			lruvec->file_cost /= 2;
>  			lruvec->anon_cost /= 2;
>  		}
> +		spin_unlock_irq(&pgdat->lru_lock);
>  	} while ((lruvec = parent_lruvec(lruvec)));
>  }
>  
>  void lru_note_cost_page(struct page *page)
>  {
> -	spin_lock_irq(&page_pgdat(page)->lru_lock);
>  	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
>  		      page_is_file_lru(page), thp_nr_pages(page));
> -	spin_unlock_irq(&page_pgdat(page)->lru_lock);
>  }
>  
>  static void __activate_page(struct page *page, struct lruvec *lruvec)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ffccb94defaf..7b7b36bd1448 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1971,19 +1971,17 @@ static int current_may_throttle(void)
>  				&stat, false);
>  
>  	spin_lock_irq(&pgdat->lru_lock);
> -
>  	move_pages_to_lru(lruvec, &page_list);
>  
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
> -	lru_note_cost(lruvec, file, stat.nr_pageout);
>  	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
>  	if (!cgroup_reclaim(sc))
>  		__count_vm_events(item, nr_reclaimed);
>  	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
>  	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> -
>  	spin_unlock_irq(&pgdat->lru_lock);
>  
> +	lru_note_cost(lruvec, file, stat.nr_pageout);
>  	mem_cgroup_uncharge_list(&page_list);
>  	free_unref_page_list(&page_list);
>  
> -- 
> 1.8.3.1
> 
> 
