From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: swap: fix update_page_reclaim_stat for huge pages
Date: Fri, 8 May 2020 17:51:22 -0400
Message-ID: <20200508215122.GB226164@cmpxchg.org>
References: <20200508212215.181307-1-shakeelb@google.com>
 <20200508212215.181307-3-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hKXRONb+n2QBaUWyV/lYpYzKCQdxSGuUXqvfdv5OsKY=;
        b=rSGufhOWI5GJ6rCz1J39rS/t2dS6ZoQ36aA2y3RXn5bAZ7046RBX6rQnu8ISFEZaMD
         MH3QH8Zj79L5MHtEygX2sQIkEpEfpHec8ju4KgtrK9eU1RZhdZ2ADOsWM9iz88vgttuh
         lIhGIaHkK5GccMZd4UVybv9snSfren/bg4uecEExUUcmw5JEP2cbA+xbtKbRVjuz2FQ4
         5zJAHOSx0PxNJo9D0F6/NfqJoHwOJJQB/+dObv66HynblLg5aIM6hTSAhuPo4+e/VtTq
         KBTGSBVIHMtUAqfiBAW8agqP824GFhS2GZ9MnXXsirMXAHLSoEyNDOrCQaUbdjxmCZw+
         Susw==
Content-Disposition: inline
In-Reply-To: <20200508212215.181307-3-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 08, 2020 at 02:22:15PM -0700, Shakeel Butt wrote:
> Currently update_page_reclaim_stat() updates the lruvec.reclaim_stats
> just once for a page irrespective if a page is huge or not. Fix that by
> passing the hpage_nr_pages(page) to it.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

https://lore.kernel.org/patchwork/patch/685703/

Laughs, then cries.

> @@ -928,7 +928,7 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
>  	}
>  
>  	if (!PageUnevictable(page))
> -		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
> +		update_page_reclaim_stat(lruvec, file, PageActive(page_tail), 1);

The change to __pagevec_lru_add_fn() below makes sure the tail pages
are already accounted. This would make them count twice.

>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> @@ -973,7 +973,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
>  	if (page_evictable(page)) {
>  		lru = page_lru(page);
>  		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
> -					 PageActive(page));
> +					 PageActive(page), nr_pages);
>  		if (was_unevictable)
>  			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
>  	} else {
