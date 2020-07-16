From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 05/22] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Thu, 16 Jul 2020 16:59:48 +0800
Message-ID: <924c187c-d4cb-4458-9a71-63f79e0a66c8@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-6-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1594429136-20002-6-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org

Hi Kirill & Matthew,

Is there any concern from for the THP involved patches?

Thanks
Alex


=D4=DA 2020/7/11 =C9=CF=CE=E78:58, Alex Shi =D0=B4=B5=C0:
> The func is only used in huge_memory.c, defining it in other file with a
> CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.
>=20
> Let's move it THP. And make it static as Hugh Dickin suggested.
>=20
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public=
.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/swap.h |  2 --
>  mm/huge_memory.c     | 30 ++++++++++++++++++++++++++++++
>  mm/swap.c            | 33 ---------------------------------
>  3 files changed, 30 insertions(+), 35 deletions(-)
>=20
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 5b3216ba39a9..2c29399b29a0 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -339,8 +339,6 @@ extern void lru_note_cost(struct lruvec *lruvec, bool=
 file,
>  			  unsigned int nr_pages);
>  extern void lru_note_cost_page(struct page *);
>  extern void lru_cache_add(struct page *);
> -extern void lru_add_page_tail(struct page *page, struct page *page_tail,
> -			 struct lruvec *lruvec, struct list_head *head);
>  extern void activate_page(struct page *);
>  extern void mark_page_accessed(struct page *);
>  extern void lru_add_drain(void);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 78c84bee7e29..9e050b13f597 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2340,6 +2340,36 @@ static void remap_page(struct page *page)
>  	}
>  }
> =20
> +static void lru_add_page_tail(struct page *page, struct page *page_tail,
> +				struct lruvec *lruvec, struct list_head *list)
> +{
> +	VM_BUG_ON_PAGE(!PageHead(page), page);
> +	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
> +	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
> +	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
> +
> +	if (!list)
> +		SetPageLRU(page_tail);
> +
> +	if (likely(PageLRU(page)))
> +		list_add_tail(&page_tail->lru, &page->lru);
> +	else if (list) {
> +		/* page reclaim is reclaiming a huge page */
> +		get_page(page_tail);
> +		list_add_tail(&page_tail->lru, list);
> +	} else {
> +		/*
> +		 * Head page has not yet been counted, as an hpage,
> +		 * so we must account for each subpage individually.
> +		 *
> +		 * Put page_tail on the list at the correct position
> +		 * so they all end up in order.
> +		 */
> +		add_page_to_lru_list_tail(page_tail, lruvec,
> +					  page_lru(page_tail));
> +	}
> +}
> +
>  static void __split_huge_page_tail(struct page *head, int tail,
>  		struct lruvec *lruvec, struct list_head *list)
>  {
> diff --git a/mm/swap.c b/mm/swap.c
> index a82efc33411f..7701d855873d 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -933,39 +933,6 @@ void __pagevec_release(struct pagevec *pvec)
>  }
>  EXPORT_SYMBOL(__pagevec_release);
> =20
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -/* used by __split_huge_page_refcount() */
> -void lru_add_page_tail(struct page *page, struct page *page_tail,
> -		       struct lruvec *lruvec, struct list_head *list)
> -{
> -	VM_BUG_ON_PAGE(!PageHead(page), page);
> -	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
> -	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
> -	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
> -
> -	if (!list)
> -		SetPageLRU(page_tail);
> -
> -	if (likely(PageLRU(page)))
> -		list_add_tail(&page_tail->lru, &page->lru);
> -	else if (list) {
> -		/* page reclaim is reclaiming a huge page */
> -		get_page(page_tail);
> -		list_add_tail(&page_tail->lru, list);
> -	} else {
> -		/*
> -		 * Head page has not yet been counted, as an hpage,
> -		 * so we must account for each subpage individually.
> -		 *
> -		 * Put page_tail on the list at the correct position
> -		 * so they all end up in order.
> -		 */
> -		add_page_to_lru_list_tail(page_tail, lruvec,
> -					  page_lru(page_tail));
> -	}
> -}
> -#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> -
>  static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruve=
c,
>  				 void *arg)
>  {
>=20
