From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/13] mm: use page_off_lru()
Date: Fri, 18 Sep 2020 09:37:00 +0200
Message-ID: <20200918073700.GE28827@dhcp22.suse.cz>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918030051.650890-3-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600414621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IerR+PY+4rUTIGV+zw/7iB09Mc+/bTYrczgrwaDRFBc=;
        b=nLnFRe/mcq7skGBJw+mM5/YGg8I+WZlkCTqLblWIL7NmP9BSPZzBnMgpJGm5x7QMYdFbEq
        M38wC0ove+2L4QhGe/vtZ6h+2fd8Ue8dEJek+ZnGJDjllL8BM9JQ/c/LXZKM/XTAb30uUI
        dvxpBGx5TWqU8EAEab9oOFkPCAuJU2PTESytTNuHjGx3sLJeBwK/az1M6c+E48YV/YrBTt
        qq+x1NW4lOnpw+43wb9F/RFEQBxZgGQRcNZv4Xku7+bbxRwGjEFEN9pb4sy2NZnU/NpTmw
        2Uu0njttXkDQpvx9oypTd1Bei+J4LThOtZ9U7GzglBVy3nvlMYGCQzBYKR/YOw==
Content-Disposition: inline
In-Reply-To: <20200918030051.650890-3-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-09-20 21:00:40, Yu Zhao wrote:
> This patch replaces the only open-coded __ClearPageActive() with
> page_off_lru(). There is no open-coded __ClearPageUnevictable()s.
> 
> Before this patch, we have:
> 	__ClearPageActive()
> 	add_page_to_lru_list()
> 
> After this patch, we have:
> 	page_off_lru()
> 		if PageUnevictable()
> 			__ClearPageUnevictable()
> 		else if PageActive()
> 			__ClearPageActive()
> 	add_page_to_lru_list()
> 
> Checking PageUnevictable() shouldn't be a problem because these two
> flags are mutually exclusive. Leaking either will trigger bad_page().

I am sorry but the changelog is really hard to grasp. What are you
trying to achieve, why and why it is safe. This should be a general
outline for any patch. I have already commented on the previous patch
and asked you for the explanation why removing __ClearPageActive from
this path is desirable and safe. I have specifically asked to clarify
the compound page situation as that is using its oen destructor in the
freeing path and that might result in page_off_lru to be not called.
 
> Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/vmscan.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 503fc5e1fe32..f257d2f61574 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1845,7 +1845,6 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  	int nr_pages, nr_moved = 0;
>  	LIST_HEAD(pages_to_free);
>  	struct page *page;
> -	enum lru_list lru;
>  
>  	while (!list_empty(list)) {
>  		page = lru_to_page(list);
> @@ -1860,14 +1859,11 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  
>  		SetPageLRU(page);
> -		lru = page_lru(page);
> -
>  		add_page_to_lru_list(page, lruvec, lru);
>  
>  		if (put_page_testzero(page)) {
>  			__ClearPageLRU(page);
> -			__ClearPageActive(page);
> -			del_page_from_lru_list(page, lruvec, lru);
> +			del_page_from_lru_list(page, lruvec, page_off_lru(page));
>  
>  			if (unlikely(PageCompound(page))) {
>  				spin_unlock_irq(&pgdat->lru_lock);
> -- 
> 2.28.0.681.g6f77f65b4e-goog

-- 
Michal Hocko
SUSE Labs
