From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v17 01/21] mm/vmscan: remove unnecessary lruvec adding
Date: Thu, 6 Aug 2020 11:47:53 +0800
Message-ID: <d4eb6520-e1ee-9202-49d0-a9216a96a488@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1595681998-19193-2-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com



=D4=DA 2020/7/25 =CF=C2=CE=E78:59, Alex Shi =D0=B4=B5=C0:
> We don't have to add a freeable page into lru and then remove from it.
> This change saves a couple of actions and makes the moving more clear.
>=20
> The SetPageLRU needs to be kept here for list intergrity.
> Otherwise:
>  #0 mave_pages_to_lru              #1 release_pages
>                                    if (put_page_testzero())
>  if !put_page_testzero
>                                      !PageLRU //skip lru_lock
>                                        list_add(&page->lru,)
>    list_add(&page->lru,) //corrupt

The race comments should be corrected to this:
                /*
                 * The SetPageLRU needs to be kept here for list intergrity.
                 * Otherwise:
                 *   #0 mave_pages_to_lru             #1 release_pages
                 *   if !put_page_testzero
                 *                                    if (put_page_testzero=
())
                 *                                      !PageLRU //skip lru=
_lock
                 *     SetPageLRU()
                 *     list_add(&page->lru,)
                 *                                        list_add(&page->l=
ru,)
                 */

>=20
> [akpm@linux-foundation.org: coding style fixes]
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/vmscan.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 749d239c62b2..ddb29d813d77 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1856,26 +1856,29 @@ static unsigned noinline_for_stack move_pages_to_=
lru(struct lruvec *lruvec,
>  	while (!list_empty(list)) {
>  		page =3D lru_to_page(list);
>  		VM_BUG_ON_PAGE(PageLRU(page), page);
> +		list_del(&page->lru);
>  		if (unlikely(!page_evictable(page))) {
> -			list_del(&page->lru);
>  			spin_unlock_irq(&pgdat->lru_lock);
>  			putback_lru_page(page);
>  			spin_lock_irq(&pgdat->lru_lock);
>  			continue;
>  		}
> -		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> =20
> +		/*
> +		 * The SetPageLRU needs to be kept here for list intergrity.
> +		 * Otherwise:
> +		 *   #0 mave_pages_to_lru             #1 release_pages
> +		 *				      if (put_page_testzero())
> +		 *   if !put_page_testzero
> +		 *				        !PageLRU //skip lru_lock
> +		 *                                        list_add(&page->lru,)
> +		 *     list_add(&page->lru,) //corrupt
> +		 */

                /*
                 * The SetPageLRU needs to be kept here for list intergrity.
                 * Otherwise:
                 *   #0 mave_pages_to_lru             #1 release_pages
                 *   if !put_page_testzero
                 *                                    if (put_page_testzero=
())
                 *                                      !PageLRU //skip lru=
_lock
                 *     SetPageLRU()
                 *     list_add(&page->lru,)
                 *                                        list_add(&page->l=
ru,)
                 */

>  		SetPageLRU(page);
> -		lru =3D page_lru(page);
> =20
> -		nr_pages =3D hpage_nr_pages(page);
> -		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
> -		list_move(&page->lru, &lruvec->lists[lru]);
> -
> -		if (put_page_testzero(page)) {
> +		if (unlikely(put_page_testzero(page))) {
>  			__ClearPageLRU(page);
>  			__ClearPageActive(page);
> -			del_page_from_lru_list(page, lruvec, lru);
> =20
>  			if (unlikely(PageCompound(page))) {
>  				spin_unlock_irq(&pgdat->lru_lock);
> @@ -1883,11 +1886,19 @@ static unsigned noinline_for_stack move_pages_to_=
lru(struct lruvec *lruvec,
>  				spin_lock_irq(&pgdat->lru_lock);
>  			} else
>  				list_add(&page->lru, &pages_to_free);
> -		} else {
> -			nr_moved +=3D nr_pages;
> -			if (PageActive(page))
> -				workingset_age_nonresident(lruvec, nr_pages);
> +
> +			continue;
>  		}
> +
> +		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
> +		lru =3D page_lru(page);
> +		nr_pages =3D hpage_nr_pages(page);
> +
> +		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
> +		list_add(&page->lru, &lruvec->lists[lru]);
> +		nr_moved +=3D nr_pages;
> +		if (PageActive(page))
> +			workingset_age_nonresident(lruvec, nr_pages);
>  	}
> =20
>  	/*
>=20
