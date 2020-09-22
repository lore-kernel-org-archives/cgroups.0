From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 25/32] mm/mlock: remove lru_lock on TestClearPageMlocked
 in munlock_vma_page
Date: Mon, 21 Sep 2020 23:13:17 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009212253320.6434@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-26-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=WBUjk5sa2qSjZc05mc4Eihluz20Uyb3yXZp0vXYSAao=;
        b=WB/3I6zQHZvM8TfVLEJMlPFQrTIpfsU1zdOf1VurZPu72ZMZEaoo7SH356HOoSJJOw
         EKwBCy7d/TyKnNeXXKOUW5zk+bqIOjLHCJ6ZiSFyYEnC+Euj4h8fo14+jrnzeu2jgIBF
         53xrD3/b4xTaGC/iTpL/ulzQHeY26XpyZ/b+299hSLzBpDXltk+x+4eBjq7eYELQzz1x
         gKXJ+0lEUiZNnjiD6gENrAppDXE/pvR++XVaVbjUnX2tjQsXzoGS6TdcYZ0EtsVe4Bw3
         JcV/h1yIyD756SHiiB2UFeko7C0okLxWUaCBg6mcoEecwVx0KqJHQp0ZLszZ9HV/C8F7
         8bpw==
In-Reply-To: <1598273705-69124-26-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Mon, 24 Aug 2020, Alex Shi wrote:

> In the func munlock_vma_page, the page must be PageLocked as well as
> pages in split_huge_page series funcs. Thus the PageLocked is enough
> to serialize both funcs.
> 
> So we could relief the TestClearPageMlocked/hpage_nr_pages which are not
> necessary under lru lock.
> 
> As to another munlock func __munlock_pagevec, which no PageLocked
> protection and should remain lru protecting.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

I made some comments on the mlock+munlock situation last week:
I won't review this 24/32 and 25/32 now, but will take a look
at your github tree tomorrow instead.  Perhaps I'll find you have
already done the fixes, perhaps I'll find you have merged these back
into earlier patches.  And I won't be reviewing beyond this point:
this is enough for now, I think.

Hugh

> Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/mlock.c | 41 +++++++++++++++--------------------------
>  1 file changed, 15 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 0448409184e3..46a05e6ec5ba 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -69,9 +69,9 @@ void clear_page_mlock(struct page *page)
>  	 *
>  	 * See __pagevec_lru_add_fn for more explanation.
>  	 */
> -	if (!isolate_lru_page(page)) {
> +	if (!isolate_lru_page(page))
>  		putback_lru_page(page);
> -	} else {
> +	else {
>  		/*
>  		 * We lost the race. the page already moved to evictable list.
>  		 */
> @@ -178,7 +178,6 @@ static void __munlock_isolation_failed(struct page *page)
>  unsigned int munlock_vma_page(struct page *page)
>  {
>  	int nr_pages;
> -	struct lruvec *lruvec;
>  
>  	/* For try_to_munlock() and to serialize with page migration */
>  	BUG_ON(!PageLocked(page));
> @@ -186,37 +185,22 @@ unsigned int munlock_vma_page(struct page *page)
>  	VM_BUG_ON_PAGE(PageTail(page), page);
>  
>  	/*
> -	 * Serialize split tail pages in __split_huge_page_tail() which
> -	 * might otherwise copy PageMlocked to part of the tail pages before
> -	 * we clear it in the head page. It also stabilizes thp_nr_pages().
> -	 * TestClearPageLRU can't be used here to block page isolation, since
> -	 * out of lock clear_page_mlock may interfer PageLRU/PageMlocked
> -	 * sequence, same as __pagevec_lru_add_fn, and lead the page place to
> -	 * wrong lru list here. So relay on PageLocked to stop lruvec change
> -	 * in mem_cgroup_move_account().
> +	 * Serialize split tail pages in __split_huge_page_tail() by
> +	 * lock_page(); Do TestClearPageMlocked/PageLRU sequence like
> +	 * clear_page_mlock().
>  	 */
> -	lruvec = lock_page_lruvec_irq(page);
> -
> -	if (!TestClearPageMlocked(page)) {
> +	if (!TestClearPageMlocked(page))
>  		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
> -		nr_pages = 1;
> -		goto unlock_out;
> -	}
> +		return 0;
>  
>  	nr_pages = thp_nr_pages(page);
>  	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
>  
> -	if (__munlock_isolate_lru_page(page, lruvec, true)) {
> -		unlock_page_lruvec_irq(lruvec);
> +	if (!isolate_lru_page(page))
>  		__munlock_isolated_page(page);
> -		goto out;
> -	}
> -	__munlock_isolation_failed(page);
> -
> -unlock_out:
> -	unlock_page_lruvec_irq(lruvec);
> +	else
> +		__munlock_isolation_failed(page);
>  
> -out:
>  	return nr_pages - 1;
>  }
>  
> @@ -305,6 +289,11 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
>  
>  		/* block memcg change in mem_cgroup_move_account */
>  		lock_page_memcg(page);
> +		/*
> +		 * Serialize split tail pages in __split_huge_page_tail() which
> +		 * might otherwise copy PageMlocked to part of the tail pages
> +		 * before we clear it in the head page.
> +		 */
>  		lruvec = relock_page_lruvec_irq(page, lruvec);
>  		if (TestClearPageMlocked(page)) {
>  			/*
> -- 
> 1.8.3.1
> 
> 
