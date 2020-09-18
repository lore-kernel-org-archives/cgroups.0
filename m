From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 01/13] mm: use add_page_to_lru_list()
Date: Fri, 18 Sep 2020 09:32:40 +0200
Message-ID: <20200918073240.GD28827@dhcp22.suse.cz>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918030051.650890-2-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600414361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WgNBJtQybUt+aLQlWkB/4yJbkuXmXsDcz8/9t/Jw7us=;
        b=XZPvSCfLPNA9NPNZeW8OYl6SToHj1z2xudwJVjZarJ7zPWa3KAYW8zHxkryTkcv5ODNrM0
        ujQQWcWMcG2b0KnHXk4BBGf3m6TmFQ4LUmA/VHvnMeSW2WmwnJRm/qFCfpGIM0yLShH9Ag
        dg17dOnjgp5v/gDFEKAdstA6Hz64b87yp3A+mn8ydYeOnCGqXFTHSgwokBUHtazJ//CzBM
        xvGf5k80AoNDvkK444ScJqOSO9PygCAYTYTprw4jf9xKPnM/iJkGi3ALe9PGkLuornjOYZ
        JG2Dl/E40rf/W2NnBUgud+kZ7HTs3noIos5cYQyghtXmVWeukJvCyw4+aqY4Xg==
Content-Disposition: inline
In-Reply-To: <20200918030051.650890-2-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-09-20 21:00:39, Yu Zhao wrote:
> This patch replaces the only open-coded lru list addition with
> add_page_to_lru_list().
> 
> Before this patch, we have:
> 	update_lru_size()
> 	list_move()
> 
> After this patch, we have:
> 	list_del()
> 	add_page_to_lru_list()
> 		update_lru_size()
> 		list_add()
> 
> The only side effect is that page->lru is temporarily poisoned
> after a page is deleted from its old list, which shouldn't be a
> problem.

"because the lru lock is held" right?

Please always be explicit about your reasoning. "It shouldn't be a
problem" without further justification is just pointless for anybody
reading the code later on.
 
> Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/vmscan.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9727dd8e2581..503fc5e1fe32 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1850,8 +1850,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  	while (!list_empty(list)) {
>  		page = lru_to_page(list);
>  		VM_BUG_ON_PAGE(PageLRU(page), page);
> +		list_del(&page->lru);
>  		if (unlikely(!page_evictable(page))) {
> -			list_del(&page->lru);
>  			spin_unlock_irq(&pgdat->lru_lock);
>  			putback_lru_page(page);
>  			spin_lock_irq(&pgdat->lru_lock);
> @@ -1862,9 +1862,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  		SetPageLRU(page);
>  		lru = page_lru(page);
>  
> -		nr_pages = thp_nr_pages(page);
> -		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
> -		list_move(&page->lru, &lruvec->lists[lru]);
> +		add_page_to_lru_list(page, lruvec, lru);
>  
>  		if (put_page_testzero(page)) {
>  			__ClearPageLRU(page);
> @@ -1878,6 +1876,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  			} else
>  				list_add(&page->lru, &pages_to_free);
>  		} else {
> +			nr_pages = thp_nr_pages(page);
>  			nr_moved += nr_pages;
>  			if (PageActive(page))
>  				workingset_age_nonresident(lruvec, nr_pages);
> -- 
> 2.28.0.681.g6f77f65b4e-goog

-- 
Michal Hocko
SUSE Labs
