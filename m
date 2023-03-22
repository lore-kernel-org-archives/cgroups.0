From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] mm: thp: split huge page to any lower order pages.
Date: Wed, 22 Mar 2023 10:27:59 -0400
Message-ID: <A75E3B03-C00C-45B5-8D8E-688F091B1F4D@nvidia.com>
References: <20230321004829.2012847-1-zi.yan@sent.com>
 <20230321004829.2012847-4-zi.yan@sent.com>
 <e8352d76-29e4-5e4a-063b-60e279e0b070@arm.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_61EBCF05-1BA1-4F02-A4DD-46D41C663989_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZL3IyaYxSK6xfQ0gelaoVpNmPpTFT1cXRPOOGhpbBY=;
 b=L+baqRU7aZJ9OWEHs2l8gDtGWC099xdXtxmCLQdWHHFtrTvOfnlsXmOJMNKdOcfYmecyby95LLsVRlmafMWeAvbQj83OmwSETuIy0rpDRS7EsNY3hlB7bmhNTXwRY8NBl83f59aGG0JfdOkhuaWpsdghRrQwOrBPE/r2mYhD7HW+H25KDhMgvo6CarXRtEmauv1mBoH0LgM8FhJATsr9f56YKEeFqBI/PnXINLaYkQDEkwx1vPE2Up3XiFRGwt/+Hc+42f7WhGcX9myQrz6LQx2OicPLgfTOATZ0VBUrj5YgE4VCzXfkQdhfLIbC9a6lLDuLgH8zQJMlA2kat+ot/Q==
In-Reply-To: <e8352d76-29e4-5e4a-063b-60e279e0b070-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_61EBCF05-1BA1-4F02-A4DD-46D41C663989_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 22 Mar 2023, at 3:55, Ryan Roberts wrote:

> Hi,
>
> I'm working to enable large, variable-order folios for anonymous memory=
 (see
> RFC, replete with bugs at [1]). This patch set is going to be very usef=
ul to me.
> But I have a few questions that I wonder if you can answer, below? I wo=
nder if
> they might relate to the bugs I'm seeing at [1].
>
> [1] https://lore.kernel.org/linux-mm/20230317105802.2634004-1-ryan.robe=
rts-5wv7dgnIgG8@public.gmane.org/
>
>
>
> On 21/03/2023 00:48, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> To split a THP to any lower order pages, we need to reform THPs on
>> subpages at given order and add page refcount based on the new page
>> order. Also we need to reinitialize page_deferred_list after removing
>> the page from the split_queue, otherwise a subsequent split will see
>> list corruption when checking the page_deferred_list again.
>>
>> It has many uses, like minimizing the number of pages after
>> truncating a huge pagecache page. For anonymous THPs, we can only spli=
t
>> them to order-0 like before until we add support for any size anonymou=
s
>> THPs.
>>
>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/huge_mm.h |  10 ++--
>>  mm/huge_memory.c        | 103 +++++++++++++++++++++++++++++----------=
-
>>  2 files changed, 82 insertions(+), 31 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 20284387b841..32c91e1b59cd 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -147,10 +147,11 @@ void prep_transhuge_page(struct page *page);
>>  void free_transhuge_page(struct page *page);
>>
>>  bool can_split_folio(struct folio *folio, int *pextra_pins);
>> -int split_huge_page_to_list(struct page *page, struct list_head *list=
);
>> +int split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> +		unsigned int new_order);
>>  static inline int split_huge_page(struct page *page)
>>  {
>> -	return split_huge_page_to_list(page, NULL);
>> +	return split_huge_page_to_list_to_order(page, NULL, 0);
>>  }
>>  void deferred_split_folio(struct folio *folio);
>>
>> @@ -297,7 +298,8 @@ can_split_folio(struct folio *folio, int *pextra_p=
ins)
>>  	return false;
>>  }
>>  static inline int
>> -split_huge_page_to_list(struct page *page, struct list_head *list)
>> +split_huge_page_to_list_to_order(struct page *page, struct list_head =
*list,
>> +		unsigned int new_order)
>>  {
>>  	return 0;
>>  }
>> @@ -397,7 +399,7 @@ static inline bool thp_migration_supported(void)
>>  static inline int split_folio_to_list(struct folio *folio,
>>  		struct list_head *list)
>>  {
>> -	return split_huge_page_to_list(&folio->page, list);
>> +	return split_huge_page_to_list_to_order(&folio->page, list, 0);
>>  }
>>
>>  static inline int split_folio(struct folio *folio)
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 710189885402..f119b9be33f2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2359,11 +2359,13 @@ void vma_adjust_trans_huge(struct vm_area_stru=
ct *vma,
>>
>>  static void unmap_folio(struct folio *folio)
>>  {
>> -	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
>> -		TTU_SYNC;
>> +	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SYNC;
>>
>>  	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
>>
>> +	if (folio_order(folio) >=3D HPAGE_PMD_ORDER)
>> +		ttu_flags |=3D TTU_SPLIT_HUGE_PMD;
>> +
>
> Why have you changed the code so that this flag is added conditionally =
on the
> folio being large enough? I've previously looked at this in the context=
 of my
> bug, and concluded that the consumer would ignore the flag if the folio=
 wasn't
> PMD mapped. Did I conclude incorrectly?

Since if folio order is not larger than PMD order, there is no way of map=
ping
a PMD to the folio. Thus, TTU_SPLIT_HUGE_PMD does not make sense. Yes, th=
e consumer
will not split any PMD, but will still do page table locks and mmu notifi=
er
work, which cost unnecessary overheads.

I think I better change the if condition to folio_test_pmd_mappable().

>
>
>>  	/*
>>  	 * Anon pages need migration entries to preserve them, but file
>>  	 * pages can simply be left unmapped, then faulted back on demand.
>> @@ -2395,7 +2397,6 @@ static void lru_add_page_tail(struct page *head,=
 struct page *tail,
>>  		struct lruvec *lruvec, struct list_head *list)
>>  {
>>  	VM_BUG_ON_PAGE(!PageHead(head), head);
>> -	VM_BUG_ON_PAGE(PageCompound(tail), head);
>>  	VM_BUG_ON_PAGE(PageLRU(tail), head);
>>  	lockdep_assert_held(&lruvec->lru_lock);
>>
>> @@ -2416,9 +2417,10 @@ static void lru_add_page_tail(struct page *head=
, struct page *tail,
>>  }
>>
>
> [...]
>
>> -int split_huge_page_to_list(struct page *page, struct list_head *list=
)
>> +int split_huge_page_to_list_to_order(struct page *page, struct list_h=
ead *list,
>> +				     unsigned int new_order)
>>  {
>>  	struct folio *folio =3D page_folio(page);
>>  	struct deferred_split *ds_queue =3D get_deferred_split_queue(folio);=

>> -	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>> +	/* reset xarray order to new order after split */
>> +	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_orde=
r);
>>  	struct anon_vma *anon_vma =3D NULL;
>>  	struct address_space *mapping =3D NULL;
>>  	int extra_pins, ret;
>> @@ -2649,6 +2676,18 @@ int split_huge_page_to_list(struct page *page, =
struct list_head *list)
>>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>>  	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
>>
>> +	/* Cannot split THP to order-1 (no order-1 THPs) */
>> +	if (new_order =3D=3D 1) {
>> +		VM_WARN_ONCE(1, "Cannot split to order-1 folio");
>> +		return -EINVAL;
>> +	}
>
> Why can't you split to order-1? I vaguely understand that some data is =
kept in
> the first 3 struct pages, but I would naively expect the allocator to f=
ail to
> allocate compound pages of order-1 if it was a problem? My large anon f=
olios
> patch is currently allocating order-1 in some circumstances. Perhaps it=
s related
> to my bug?
>

Yes, some data is kept in first 3 struct pages, so order-1 THP is not pos=
sible.
The page allocator does not know this restriction, but still allocate an =
order-1
page. That might be related to your bug. You can have order-1 compound pa=
ges,
but it does not mean you can use them for THPs. AFAIK, slab uses order-1 =
compound
pages, but it does not store slab information on the 3rd struct page.

Basically, page allocator can allocate an order-N page, and it can be:
1. 2^N consecutive physical pages (not a compound page),
2. an order-N compound page,
3. an order-N THP (also an order-N compound page),
4. an order-N hugetlb page (also an order-N compound page).

For THP and hugetlb page, there are prep_transhuge_page() and
prep_new_hugetlb_folio() are called respectively after the page is alloca=
ted.
That makes them kinda subclasses of a compound page.

>
>> +
>> +	/* Split anonymous folio to non-zero order not support */
>> +	if (folio_test_anon(folio) && new_order) {
>> +		VM_WARN_ONCE(1, "Split anon folio to non-0 order not support");
>> +		return -EINVAL;
>> +	}
>
> Why don't you support this? What is special about anon folios that mean=
s this
> code doesn't work for them?

split_huge_page() code can split to non-0 order anon folios, but the rest=
 of
the mm code might not have proper support yet.
That is why we need your patchset. :)

>
>
>> +
>>  	is_hzp =3D is_huge_zero_page(&folio->page);
>>  	VM_WARN_ON_ONCE_FOLIO(is_hzp, folio);
>>  	if (is_hzp)
>> @@ -2744,7 +2783,13 @@ int split_huge_page_to_list(struct page *page, =
struct list_head *list)
>>  	if (folio_ref_freeze(folio, 1 + extra_pins)) {
>>  		if (!list_empty(&folio->_deferred_list)) {
>>  			ds_queue->split_queue_len--;
>> -			list_del(&folio->_deferred_list);
>> +			/*
>> +			 * Reinitialize page_deferred_list after removing the
>> +			 * page from the split_queue, otherwise a subsequent
>> +			 * split will see list corruption when checking the
>> +			 * page_deferred_list.
>> +			 */
>> +			list_del_init(&folio->_deferred_list);
>>  		}
>>  		spin_unlock(&ds_queue->split_queue_lock);
>>  		if (mapping) {
>> @@ -2754,14 +2799,18 @@ int split_huge_page_to_list(struct page *page,=
 struct list_head *list)
>>  			if (folio_test_swapbacked(folio)) {
>>  				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
>>  							-nr);
>> -			} else {
>> +			} else if (!new_order) {
>> +				/*
>> +				 * Decrease THP stats only if split to normal
>> +				 * pages
>> +				 */
>>  				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
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
--=_MailMate_61EBCF05-1BA1-4F02-A4DD-46D41C663989_=--
