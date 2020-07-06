From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v14 07/20] mm/thp: narrow lru locking
Date: Mon, 6 Jul 2020 17:15:09 +0800
Message-ID: <124eeef1-ff2b-609e-3bf6-a118100c3f2a@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1593752873-4493-8-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi Kirill & Johannes & Matthew,

Would you like to give some comments or share your concern of this patchset,
specialy for THP part?=20

Many Thanks
Alex

=D4=DA 2020/7/3 =CF=C2=CE=E71:07, Alex Shi =D0=B4=B5=C0:
> lru_lock and page cache xa_lock have no reason with current sequence,
> put them together isn't necessary. let's narrow the lru locking, but
> left the local_irq_disable to block interrupt re-entry and statistic upda=
te.
>=20
> Hugh Dickins point: split_huge_page_to_list() was already silly,to be
> using the _irqsave variant: it's just been taking sleeping locks, so
> would already be broken if entered with interrupts enabled.
> so we can save passing flags argument down to __split_huge_page().
>=20
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public=
.gmane.org>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gm=
ane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/huge_memory.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b18f21da4dac..607869330329 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2433,7 +2433,7 @@ static void __split_huge_page_tail(struct page *hea=
d, int tail,
>  }
> =20
>  static void __split_huge_page(struct page *page, struct list_head *list,
> -		pgoff_t end, unsigned long flags)
> +			      pgoff_t end)
>  {
>  	struct page *head =3D compound_head(page);
>  	pg_data_t *pgdat =3D page_pgdat(head);
> @@ -2442,8 +2442,6 @@ static void __split_huge_page(struct page *page, st=
ruct list_head *list,
>  	unsigned long offset =3D 0;
>  	int i;
> =20
> -	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
> -
>  	/* complete memcg works before add pages to LRU */
>  	mem_cgroup_split_huge_fixup(head);
> =20
> @@ -2455,6 +2453,11 @@ static void __split_huge_page(struct page *page, s=
truct list_head *list,
>  		xa_lock(&swap_cache->i_pages);
>  	}
> =20
> +	/* lock lru list/PageCompound, ref freezed by page_ref_freeze */
> +	spin_lock(&pgdat->lru_lock);
> +
> +	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
> +
>  	for (i =3D HPAGE_PMD_NR - 1; i >=3D 1; i--) {
>  		__split_huge_page_tail(head, i, lruvec, list);
>  		/* Some pages can be beyond i_size: drop them from page cache */
> @@ -2474,6 +2477,8 @@ static void __split_huge_page(struct page *page, st=
ruct list_head *list,
>  	}
> =20
>  	ClearPageCompound(head);
> +	spin_unlock(&pgdat->lru_lock);
> +	/* Caller disabled irqs, so they are still disabled here */
> =20
>  	split_page_owner(head, HPAGE_PMD_ORDER);
> =20
> @@ -2491,8 +2496,7 @@ static void __split_huge_page(struct page *page, st=
ruct list_head *list,
>  		page_ref_add(head, 2);
>  		xa_unlock(&head->mapping->i_pages);
>  	}
> -
> -	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +	local_irq_enable();
> =20
>  	remap_page(head);
> =20
> @@ -2631,12 +2635,10 @@ bool can_split_huge_page(struct page *page, int *=
pextra_pins)
>  int split_huge_page_to_list(struct page *page, struct list_head *list)
>  {
>  	struct page *head =3D compound_head(page);
> -	struct pglist_data *pgdata =3D NODE_DATA(page_to_nid(head));
>  	struct deferred_split *ds_queue =3D get_deferred_split_queue(head);
>  	struct anon_vma *anon_vma =3D NULL;
>  	struct address_space *mapping =3D NULL;
>  	int count, mapcount, extra_pins, ret;
> -	unsigned long flags;
>  	pgoff_t end;
> =20
>  	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
> @@ -2697,9 +2699,7 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  	unmap_page(head);
>  	VM_BUG_ON_PAGE(compound_mapcount(head), head);
> =20
> -	/* prevent PageLRU to go away from under us, and freeze lru stats */
> -	spin_lock_irqsave(&pgdata->lru_lock, flags);
> -
> +	local_irq_disable();
>  	if (mapping) {
>  		XA_STATE(xas, &mapping->i_pages, page_index(head));
> =20
> @@ -2729,7 +2729,7 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  				__dec_node_page_state(head, NR_FILE_THPS);
>  		}
> =20
> -		__split_huge_page(page, list, end, flags);
> +		__split_huge_page(page, list, end);
>  		if (PageSwapCache(head)) {
>  			swp_entry_t entry =3D { .val =3D page_private(head) };
> =20
> @@ -2748,7 +2748,7 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  		spin_unlock(&ds_queue->split_queue_lock);
>  fail:		if (mapping)
>  			xa_unlock(&mapping->i_pages);
> -		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
> +		local_irq_enable();
>  		remap_page(head);
>  		ret =3D -EBUSY;
>  	}
>=20
