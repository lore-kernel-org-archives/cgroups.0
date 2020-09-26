From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v19 07/20] mm/vmscan: remove unnecessary lruvec adding
Date: Sat, 26 Sep 2020 14:14:56 +0800
Message-ID: <30c65309-df19-b83b-5879-cce860ce55ef@linux.alibaba.com>
References: <1600918115-22007-1-git-send-email-alex.shi@linux.alibaba.com>
 <1600918115-22007-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1600918115-22007-8-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aaron.lwe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This patch has some conflict on akpm. But since Yu Zhao ask for
revert his patch 'mm: use add_page_to_lru_list()/page_lru()/page_off_lru()'
we should not needs for rebase on it.

Thanks
Alex

=D4=DA 2020/9/24 =C9=CF=CE=E711:28, Alex Shi =D0=B4=B5=C0:
> We don't have to add a freeable page into lru and then remove from it.
> This change saves a couple of actions and makes the moving more clear.
>=20
> The SetPageLRU needs to be kept before put_page_testzero for list
> integrity, otherwise:
>=20
>   #0 move_pages_to_lru             #1 release_pages
>   if !put_page_testzero
>      			           if (put_page_testzero())
>      			              !PageLRU //skip lru_lock
>      SetPageLRU()
>      list_add(&page->lru,)
>                                          list_add(&page->lru,)
>=20
> [akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org: coding style fix=
es]
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public=
.gmane.org>
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/vmscan.c | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 466fc3144fff..32102e5d354d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1850,26 +1850,30 @@ static unsigned noinline_for_stack move_pages_to_=
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
> +		 * The SetPageLRU needs to be kept here for list integrity.
> +		 * Otherwise:
> +		 *   #0 move_pages_to_lru             #1 release_pages
> +		 *   if !put_page_testzero
> +		 *				      if (put_page_testzero())
> +		 *				        !PageLRU //skip lru_lock
> +		 *     SetPageLRU()
> +		 *     list_add(&page->lru,)
> +		 *                                        list_add(&page->lru,)
> +		 */
>  		SetPageLRU(page);
> -		lru =3D page_lru(page);
> =20
> -		nr_pages =3D thp_nr_pages(page);
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
> @@ -1877,11 +1881,19 @@ static unsigned noinline_for_stack move_pages_to_=
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
> +		nr_pages =3D thp_nr_pages(page);
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
