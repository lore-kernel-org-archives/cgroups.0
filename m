From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 06/32] mm/thp: narrow lru locking
Date: Fri, 11 Sep 2020 11:37:50 +0800
Message-ID: <514f6afa-dbf7-11c5-5431-1d558d2c20c9@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-7-git-send-email-alex.shi@linux.alibaba.com>
 <20200910134923.GR6583@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200910134923.GR6583-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



=D4=DA 2020/9/10 =CF=C2=CE=E79:49, Matthew Wilcox =D0=B4=B5=C0:
> On Mon, Aug 24, 2020 at 08:54:39PM +0800, Alex Shi wrote:
>> lru_lock and page cache xa_lock have no reason with current sequence,
>> put them together isn't necessary. let's narrow the lru locking, but
>> left the local_irq_disable to block interrupt re-entry and statistic upd=
ate.
>=20
> What stats are you talking about here?

Hi Matthew,

Thanks for comments!

like __dec_node_page_state(head, NR_SHMEM_THPS); will have preemptive warni=
ng...

>=20
>> +++ b/mm/huge_memory.c
>> @@ -2397,7 +2397,7 @@ static void __split_huge_page_tail(struct page *he=
ad, int tail,
>>  }
>> =20
>>  static void __split_huge_page(struct page *page, struct list_head *list,
>> -		pgoff_t end, unsigned long flags)
>> +			      pgoff_t end)
>=20
> Please don't change this whitespace.  It's really annoying having to
> adjust the whitespace when renaming a function.  Just two tabs indentation
> to give a clear separation of arguments from code is fine.
>=20
>=20
> How about this patch instead?  It occurred to me we already have
> perfectly good infrastructure to track whether or not interrupts are
> already disabled, and so we should use that instead of ensuring that
> interrupts are disabled, or tracking that ourselves.

So your proposal looks like;
1, xa_lock_irq(&mapping->i_pages); (optional)
2, spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
3, spin_lock_irqsave(&pgdat->lru_lock, flags);

Is there meaningful for the 2nd and 3rd flags?

IIRC, I had a similar proposal as your, the flags used in xa_lock_irqsave(),
but objected by Hugh.

Thanks
Alex

>=20
> But I may have missed something else that's relying on having
> interrupts disabled.  Please check carefully.
>=20
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2ccff8472cd4..74cae6c032f9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2376,17 +2376,16 @@ static void __split_huge_page_tail(struct page *h=
ead, int tail,
>  }
> =20
>  static void __split_huge_page(struct page *page, struct list_head *list,
> -		pgoff_t end, unsigned long flags)
> +		pgoff_t end)
>  {
>  	struct page *head =3D compound_head(page);
>  	pg_data_t *pgdat =3D page_pgdat(head);
>  	struct lruvec *lruvec;
>  	struct address_space *swap_cache =3D NULL;
>  	unsigned long offset =3D 0;
> +	unsigned long flags;
>  	int i;
> =20
> -	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
> -
>  	/* complete memcg works before add pages to LRU */
>  	mem_cgroup_split_huge_fixup(head);
> =20
> @@ -2395,9 +2394,13 @@ static void __split_huge_page(struct page *page, s=
truct list_head *list,
> =20
>  		offset =3D swp_offset(entry);
>  		swap_cache =3D swap_address_space(entry);
> -		xa_lock(&swap_cache->i_pages);
> +		xa_lock_irq(&swap_cache->i_pages);
>  	}
> =20
> +	/* prevent PageLRU to go away from under us, and freeze lru stats */
> +	spin_lock_irqsave(&pgdat->lru_lock, flags);
> +	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
> +
>  	for (i =3D HPAGE_PMD_NR - 1; i >=3D 1; i--) {
>  		__split_huge_page_tail(head, i, lruvec, list);
>  		/* Some pages can be beyond i_size: drop them from page cache */
> @@ -2417,6 +2420,7 @@ static void __split_huge_page(struct page *page, st=
ruct list_head *list,
>  	}
> =20
>  	ClearPageCompound(head);
> +	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> =20
>  	split_page_owner(head, HPAGE_PMD_ORDER);
> =20
> @@ -2425,18 +2429,16 @@ static void __split_huge_page(struct page *page, =
struct list_head *list,
>  		/* Additional pin to swap cache */
>  		if (PageSwapCache(head)) {
>  			page_ref_add(head, 2);
> -			xa_unlock(&swap_cache->i_pages);
> +			xa_unlock_irq(&swap_cache->i_pages);
>  		} else {
>  			page_ref_inc(head);
>  		}
>  	} else {
>  		/* Additional pin to page cache */
>  		page_ref_add(head, 2);
> -		xa_unlock(&head->mapping->i_pages);
> +		xa_unlock_irq(&head->mapping->i_pages);
>  	}
> =20
> -	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> -
>  	remap_page(head);
> =20
>  	for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> @@ -2574,7 +2576,6 @@ bool can_split_huge_page(struct page *page, int *pe=
xtra_pins)
>  int split_huge_page_to_list(struct page *page, struct list_head *list)
>  {
>  	struct page *head =3D compound_head(page);
> -	struct pglist_data *pgdata =3D NODE_DATA(page_to_nid(head));
>  	struct deferred_split *ds_queue =3D get_deferred_split_queue(head);
>  	struct anon_vma *anon_vma =3D NULL;
>  	struct address_space *mapping =3D NULL;
> @@ -2640,9 +2641,6 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  	unmap_page(head);
>  	VM_BUG_ON_PAGE(compound_mapcount(head), head);
> =20
> -	/* prevent PageLRU to go away from under us, and freeze lru stats */
> -	spin_lock_irqsave(&pgdata->lru_lock, flags);
> -
>  	if (mapping) {
>  		XA_STATE(xas, &mapping->i_pages, page_index(head));
> =20
> @@ -2650,13 +2648,13 @@ int split_huge_page_to_list(struct page *page, st=
ruct list_head *list)
>  		 * Check if the head page is present in page cache.
>  		 * We assume all tail are present too, if head is there.
>  		 */
> -		xa_lock(&mapping->i_pages);
> +		xa_lock_irq(&mapping->i_pages);
>  		if (xas_load(&xas) !=3D head)
>  			goto fail;
>  	}
> =20
>  	/* Prevent deferred_split_scan() touching ->_refcount */
> -	spin_lock(&ds_queue->split_queue_lock);
> +	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>  	count =3D page_count(head);
>  	mapcount =3D total_mapcount(head);
>  	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
> @@ -2664,7 +2662,7 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  			ds_queue->split_queue_len--;
>  			list_del(page_deferred_list(head));
>  		}
> -		spin_unlock(&ds_queue->split_queue_lock);
> +		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>  		if (mapping) {
>  			if (PageSwapBacked(head))
>  				__dec_node_page_state(head, NR_SHMEM_THPS);
> @@ -2672,7 +2670,7 @@ int split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>  				__dec_node_page_state(head, NR_FILE_THPS);
>  		}
> =20
> -		__split_huge_page(page, list, end, flags);
> +		__split_huge_page(page, list, end);
>  		if (PageSwapCache(head)) {
>  			swp_entry_t entry =3D { .val =3D page_private(head) };
> =20
> @@ -2688,10 +2686,9 @@ int split_huge_page_to_list(struct page *page, str=
uct list_head *list)
>  			dump_page(page, "total_mapcount(head) > 0");
>  			BUG();
>  		}
> -		spin_unlock(&ds_queue->split_queue_lock);
> +		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
>  fail:		if (mapping)
> -			xa_unlock(&mapping->i_pages);
> -		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
> +			xa_unlock_irq(&mapping->i_pages);
>  		remap_page(head);
>  		ret =3D -EBUSY;
>  	}
>=20
