From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/5] mm: thp: split huge page to any lower order pages.
Date: Tue, 22 Mar 2022 10:30:14 -0400
Message-ID: <D03D6945-8BFE-4137-BDB6-BD884656B65B@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-4-zi.yan@sent.com>
 <165ec1a8-2b35-f6fb-82d3-b94613dd437a@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_11772522-6D16-4F1C-A239-DD3624EE149B_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwxShZGCwWXCNPsPx+oqb4+cktxK1cKHRiDUIG3iwd0=;
 b=TSpTOhpHwR3klIXmcbmE4VbXvD4voo+h5tw7SMyVioBMtkmVsLTLF197L3G23lfqUybVbOOYWzwh5HkDpL26HQev8g/Uu4WHwmFns8kZxo8Dbl8NvU+Ule+qvFORW/CNcC78nl342M50B8s/CC/DrMOdqLsKPGKnh2cPwa+qjdazznplxgf5+qs4+fFURYKRxfCOt9i2qOxM76h90WTlT39nLZ9QIlZWq6uAdvTSGQU4bAIGGnTTiIew0kh+lnKDBUec3Iyhd4bai5I4Sv5Z5hoFwUriQ+qddY61kEPCa5qldCWMcHUA/8L7u7Nd2L0wg9+cJkV8U3bZQKwkfvTRZw==
In-Reply-To: <165ec1a8-2b35-f6fb-82d3-b94613dd437a-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

--=_MailMate_11772522-6D16-4F1C-A239-DD3624EE149B_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21 Mar 2022, at 23:21, Miaohe Lin wrote:

> On 2022/3/21 22:21, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> To split a THP to any lower order pages, we need to reform THPs on
>> subpages at given order and add page refcount based on the new page
>> order. Also we need to reinitialize page_deferred_list after removing
>> the page from the split_queue, otherwise a subsequent split will see
>> list corruption when checking the page_deferred_list again.
>>
>> It has many uses, like minimizing the number of pages after
>> truncating a pagecache THP. For anonymous THPs, we can only split them=

>> to order-0 like before until we add support for any size anonymous THP=
s.
>>
>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/huge_mm.h |   8 +++
>>  mm/huge_memory.c        | 111 ++++++++++++++++++++++++++++++---------=
-
>>  2 files changed, 91 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 2999190adc22..c7153cd7e9e4 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -186,6 +186,8 @@ void free_transhuge_page(struct page *page);
>>
>>  bool can_split_folio(struct folio *folio, int *pextra_pins);
>>  int split_huge_page_to_list(struct page *page, struct list_head *list=
);
>> +int split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> +		unsigned int new_order);
>>  static inline int split_huge_page(struct page *page)
>>  {
>>  	return split_huge_page_to_list(page, NULL);
>> @@ -355,6 +357,12 @@ split_huge_page_to_list(struct page *page, struct=
 list_head *list)
>>  {
>>  	return 0;
>>  }
>> +static inline int
>> +split_huge_page_to_list_to_order(struct page *page, struct list_head =
*list,
>> +		unsigned int new_order)
>> +{
>> +	return 0;
>> +}
>>  static inline int split_huge_page(struct page *page)
>>  {
>>  	return 0;
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index fcfa46af6c4c..3617aa3ad0b1 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2236,11 +2236,13 @@ void vma_adjust_trans_huge(struct vm_area_stru=
ct *vma,
>>  static void unmap_page(struct page *page)
>>  {
>>  	struct folio *folio =3D page_folio(page);
>> -	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
>> -		TTU_SYNC;
>> +	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SYNC;
>>
>>  	VM_BUG_ON_PAGE(!PageHead(page), page);
>>
>> +	if (folio_order(folio) >=3D HPAGE_PMD_ORDER)
>> +		ttu_flags |=3D TTU_SPLIT_HUGE_PMD;
>> +
>>  	/*
>>  	 * Anon pages need migration entries to preserve them, but file
>>  	 * pages can simply be left unmapped, then faulted back on demand.
>> @@ -2254,9 +2256,9 @@ static void unmap_page(struct page *page)
>>  	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
>>  }
>>
>> -static void remap_page(struct folio *folio, unsigned long nr)
>> +static void remap_page(struct folio *folio, unsigned short nr)
>>  {
>> -	int i =3D 0;
>> +	unsigned int i;
>>
>>  	/* If unmap_page() uses try_to_migrate() on file, remove this check =
*/
>>  	if (!folio_test_anon(folio))
>> @@ -2274,7 +2276,6 @@ static void lru_add_page_tail(struct page *head,=
 struct page *tail,
>>  		struct lruvec *lruvec, struct list_head *list)
>>  {
>>  	VM_BUG_ON_PAGE(!PageHead(head), head);
>> -	VM_BUG_ON_PAGE(PageCompound(tail), head);
>>  	VM_BUG_ON_PAGE(PageLRU(tail), head);
>>  	lockdep_assert_held(&lruvec->lru_lock);
>>
>> @@ -2295,9 +2296,10 @@ static void lru_add_page_tail(struct page *head=
, struct page *tail,
>>  }
>>
>>  static void __split_huge_page_tail(struct page *head, int tail,
>> -		struct lruvec *lruvec, struct list_head *list)
>> +		struct lruvec *lruvec, struct list_head *list, unsigned int new_ord=
er)
>>  {
>>  	struct page *page_tail =3D head + tail;
>> +	unsigned long compound_head_flag =3D new_order ? (1L << PG_head) : 0=
;
>>
>>  	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) !=3D -1, page_tail=
);
>>
>> @@ -2321,6 +2323,7 @@ static void __split_huge_page_tail(struct page *=
head, int tail,
>>  #ifdef CONFIG_64BIT
>>  			 (1L << PG_arch_2) |
>>  #endif
>> +			 compound_head_flag |
>>  			 (1L << PG_dirty)));
>>
>>  	/* ->mapping in first tail page is compound_mapcount */
>> @@ -2329,7 +2332,10 @@ static void __split_huge_page_tail(struct page =
*head, int tail,
>>  	page_tail->mapping =3D head->mapping;
>>  	page_tail->index =3D head->index + tail;
>>
>> -	/* Page flags must be visible before we make the page non-compound. =
*/
>> +	/*
>> +	 * Page flags must be visible before we make the page non-compound o=
r
>> +	 * a compound page in new_order.
>> +	 */
>>  	smp_wmb();
>>
>>  	/*
>> @@ -2339,10 +2345,15 @@ static void __split_huge_page_tail(struct page=
 *head, int tail,
>>  	 * which needs correct compound_head().
>>  	 */
>>  	clear_compound_head(page_tail);
>> +	if (new_order) {
>> +		prep_compound_page(page_tail, new_order);
>> +		prep_transhuge_page(page_tail);
>> +	}
>
> Many thanks for your series. It looks really good. One question:
> IIUC, It seems there has assumption that LRU compound_pages should
> be PageTransHuge. So PageTransHuge just checks PageHead:
>
> static inline int PageTransHuge(struct page *page)
> {
> 	VM_BUG_ON_PAGE(PageTail(page), page);
> 	return PageHead(page);
> }
>
> So LRU pages with any order( > 0) will might be wrongly treated as THP =
which
> has order =3D HPAGE_PMD_ORDER. We should ensure thp_nr_pages is used in=
stead of
> hard coded HPAGE_PMD_ORDER.
>
> Looks at the below code snippet:
> mm/mempolicy.c:
> static struct page *new_page(struct page *page, unsigned long start)
> {
> ...
> 	} else if (PageTransHuge(page)) {
> 		struct page *thp;
>
> 		thp =3D alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
> 					 HPAGE_PMD_ORDER);
> 					 ^^^^^^^^^^^^^^^^
> 		if (!thp)
> 			return NULL;
> 		prep_transhuge_page(thp);
> 		return thp;
> 	}
> ...
> }
>
> HPAGE_PMD_ORDER is used instead of thp_nr_pages. So the lower order pag=
es might be
> used as if its order is HPAGE_PMD_ORDER. All of such usage might need t=
o be fixed.
> Or am I miss something ?
>
> Thanks again for your work. :)

THP will still only have HPAGE_PMD_ORDER and will not be split into any o=
rder
other than 0. This series only allows to split huge page cache folio (add=
ed by Matthew)
into any lower order. I have an explicit VM_BUG_ON() to ensure new_order
is only 0 when non page cache page is the input. Since there is still non=
-trivial
amount of work to add any order THP support in the kernel. IIRC, Yu Zhao =
(cc=E2=80=99d) was
planning to work on that.

Thanks for checking the patches.

>>
>>  	/* Finally unfreeze refcount. Additional reference from page cache. =
*/
>> -	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
>> -					  PageSwapCache(head)));
>> +	page_ref_unfreeze(page_tail, 1 + ((!PageAnon(head) ||
>> +					   PageSwapCache(head)) ?
>> +						thp_nr_pages(page_tail) : 0));
>>
>>  	if (page_is_young(head))
>>  		set_page_young(page_tail);
>> @@ -2360,7 +2371,7 @@ static void __split_huge_page_tail(struct page *=
head, int tail,
>>  }
>>
>>  static void __split_huge_page(struct page *page, struct list_head *li=
st,
>> -		pgoff_t end)
>> +		pgoff_t end, unsigned int new_order)
>>  {
>>  	struct folio *folio =3D page_folio(page);
>>  	struct page *head =3D &folio->page;
>> @@ -2369,10 +2380,11 @@ static void __split_huge_page(struct page *pag=
e, struct list_head *list,
>>  	unsigned long offset =3D 0;
>>  	unsigned int order =3D thp_order(head);
>>  	unsigned int nr =3D thp_nr_pages(head);
>> +	unsigned int new_nr =3D 1 << new_order;
>>  	int i;
>>
>>  	/* complete memcg works before add pages to LRU */
>> -	split_page_memcg(head, nr, 0);
>> +	split_page_memcg(head, nr, new_order);
>>
>>  	if (PageAnon(head) && PageSwapCache(head)) {
>>  		swp_entry_t entry =3D { .val =3D page_private(head) };
>> @@ -2387,42 +2399,50 @@ static void __split_huge_page(struct page *pag=
e, struct list_head *list,
>>
>>  	ClearPageHasHWPoisoned(head);
>>
>> -	for (i =3D nr - 1; i >=3D 1; i--) {
>> -		__split_huge_page_tail(head, i, lruvec, list);
>> +	for (i =3D nr - new_nr; i >=3D new_nr; i -=3D new_nr) {
>> +		__split_huge_page_tail(head, i, lruvec, list, new_order);
>>  		/* Some pages can be beyond EOF: drop them from page cache */
>>  		if (head[i].index >=3D end) {
>>  			ClearPageDirty(head + i);
>>  			__delete_from_page_cache(head + i, NULL);
>>  			if (shmem_mapping(head->mapping))
>> -				shmem_uncharge(head->mapping->host, 1);
>> +				shmem_uncharge(head->mapping->host, new_nr);
>>  			put_page(head + i);
>>  		} else if (!PageAnon(page)) {
>>  			__xa_store(&head->mapping->i_pages, head[i].index,
>>  					head + i, 0);
>>  		} else if (swap_cache) {
>> +			/*
>> +			 * split anonymous THPs (including swapped out ones) to
>> +			 * non-zero order not supported
>> +			 */
>> +			VM_BUG_ON(new_order);
>>  			__xa_store(&swap_cache->i_pages, offset + i,
>>  					head + i, 0);
>>  		}
>>  	}
>>
>> -	ClearPageCompound(head);
>> +	if (!new_order)
>> +		ClearPageCompound(head);
>> +	else
>> +		set_compound_order(head, new_order);
>>  	unlock_page_lruvec(lruvec);
>>  	/* Caller disabled irqs, so they are still disabled here */
>>
>> -	split_page_owner(head, order, 0);
>> +	split_page_owner(head, order, new_order);
>>
>>  	/* See comment in __split_huge_page_tail() */
>>  	if (PageAnon(head)) {
>>  		/* Additional pin to swap cache */
>>  		if (PageSwapCache(head)) {
>> -			page_ref_add(head, 2);
>> +			page_ref_add(head, 1 + new_nr);
>>  			xa_unlock(&swap_cache->i_pages);
>>  		} else {
>>  			page_ref_inc(head);
>>  		}
>>  	} else {
>>  		/* Additional pin to page cache */
>> -		page_ref_add(head, 2);
>> +		page_ref_add(head, 1 + new_nr);
>>  		xa_unlock(&head->mapping->i_pages);
>>  	}
>>  	local_irq_enable();
>> @@ -2435,7 +2455,14 @@ static void __split_huge_page(struct page *page=
, struct list_head *list,
>>  		split_swap_cluster(entry);
>>  	}
>>
>> -	for (i =3D 0; i < nr; i++) {
>> +	/*
>> +	 * set page to its compound_head when split to THPs, so that GUP pin=
 and
>> +	 * PG_locked are transferred to the right after-split page
>> +	 */
>> +	if (new_order)
>> +		page =3D compound_head(page);
>> +
>> +	for (i =3D 0; i < nr; i +=3D new_nr) {
>>  		struct page *subpage =3D head + i;
>>  		if (subpage =3D=3D page)
>>  			continue;
>> @@ -2472,36 +2499,60 @@ bool can_split_folio(struct folio *folio, int =
*pextra_pins)
>>   * This function splits huge page into normal pages. @page can point =
to any
>>   * subpage of huge page to split. Split doesn't change the position o=
f @page.
>>   *
>> + * See split_huge_page_to_list_to_order() for more details.
>> + *
>> + * Returns 0 if the hugepage is split successfully.
>> + * Returns -EBUSY if the page is pinned or if anon_vma disappeared fr=
om under
>> + * us.
>> + */
>> +int split_huge_page_to_list(struct page *page, struct list_head *list=
)
>> +{
>> +	return split_huge_page_to_list_to_order(page, list, 0);
>> +}
>> +
>> +/*
>> + * This function splits huge page into pages in @new_order. @page can=
 point to
>> + * any subpage of huge page to split. Split doesn't change the positi=
on of
>> + * @page.
>> + *
>>   * Only caller must hold pin on the @page, otherwise split fails with=
 -EBUSY.
>>   * The huge page must be locked.
>>   *
>>   * If @list is null, tail pages will be added to LRU list, otherwise,=
 to @list.
>>   *
>> - * Both head page and tail pages will inherit mapping, flags, and so =
on from
>> - * the hugepage.
>> + * Pages in new_order will inherit mapping, flags, and so on from the=
 hugepage.
>>   *
>> - * GUP pin and PG_locked transferred to @page. Rest subpages can be f=
reed if
>> - * they are not mapped.
>> + * GUP pin and PG_locked transferred to @page or the compound page @p=
age belongs
>> + * to. Rest subpages can be freed if they are not mapped.
>>   *
>>   * Returns 0 if the hugepage is split successfully.
>>   * Returns -EBUSY if the page is pinned or if anon_vma disappeared fr=
om under
>>   * us.
>>   */
>> -int split_huge_page_to_list(struct page *page, struct list_head *list=
)
>> +int split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> +				     unsigned int new_order)
>>  {
>>  	struct folio *folio =3D page_folio(page);
>>  	struct page *head =3D &folio->page;
>>  	struct deferred_split *ds_queue =3D get_deferred_split_queue(head);
>> -	XA_STATE(xas, &head->mapping->i_pages, head->index);
>> +	/* reset xarray order to new order after split */
>> +	XA_STATE_ORDER(xas, &head->mapping->i_pages, head->index, new_order)=
;
>>  	struct anon_vma *anon_vma =3D NULL;
>>  	struct address_space *mapping =3D NULL;
>>  	int extra_pins, ret;
>>  	pgoff_t end;
>>
>> +	VM_BUG_ON(thp_order(head) <=3D new_order);
>>  	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
>>  	VM_BUG_ON_PAGE(!PageLocked(head), head);
>>  	VM_BUG_ON_PAGE(!PageCompound(head), head);
>>
>> +	/* Cannot split THP to order-1 (no order-1 THPs) */
>> +	VM_BUG_ON(new_order =3D=3D 1);
>> +
>> +	/* Split anonymous THP to non-zero order not support */
>> +	VM_BUG_ON(PageAnon(head) && new_order);
>> +
>>  	if (PageWriteback(head))
>>  		return -EBUSY;
>>
>> @@ -2582,7 +2633,7 @@ int split_huge_page_to_list(struct page *page, s=
truct list_head *list)
>>  	if (page_ref_freeze(head, 1 + extra_pins)) {
>>  		if (!list_empty(page_deferred_list(head))) {
>>  			ds_queue->split_queue_len--;
>> -			list_del(page_deferred_list(head));
>> +			list_del_init(page_deferred_list(head));
>>  		}
>>  		spin_unlock(&ds_queue->split_queue_lock);
>>  		if (mapping) {
>> @@ -2592,14 +2643,18 @@ int split_huge_page_to_list(struct page *page,=
 struct list_head *list)
>>  			if (PageSwapBacked(head)) {
>>  				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
>>  							-nr);
>> -			} else {
>> +			} else if (!new_order) {
>> +				/*
>> +				 * Decrease THP stats only if split to normal
>> +				 * pages
>> +				 */
>>  				__mod_lruvec_page_state(head, NR_FILE_THPS,
>>  							-nr);
>>  				filemap_nr_thps_dec(mapping);
>>  			}
>>  		}
>>
>> -		__split_huge_page(page, list, end);
>> +		__split_huge_page(page, list, end, new_order);
>>  		ret =3D 0;
>>  	} else {
>>  		spin_unlock(&ds_queue->split_queue_lock);
>>

--=_MailMate_11772522-6D16-4F1C-A239-DD3624EE149B_=--
