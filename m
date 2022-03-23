From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/5] mm: thp: split huge page to any lower order
 pages.
Date: Wed, 23 Mar 2022 10:31:06 +0800
Message-ID: <ed175cd4-1411-459e-e892-7d889e1253c0@huawei.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-4-zi.yan@sent.com>
 <165ec1a8-2b35-f6fb-82d3-b94613dd437a@huawei.com>
 <D03D6945-8BFE-4137-BDB6-BD884656B65B@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D03D6945-8BFE-4137-BDB6-BD884656B65B-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 2022/3/22 22:30, Zi Yan wrote:
> On 21 Mar 2022, at 23:21, Miaohe Lin wrote:
>=20
>> On 2022/3/21 22:21, Zi Yan wrote:
>>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>>
>>> To split a THP to any lower order pages, we need to reform THPs on
>>> subpages at given order and add page refcount based on the new page
>>> order. Also we need to reinitialize page_deferred_list after removing
>>> the page from the split_queue, otherwise a subsequent split will see
>>> list corruption when checking the page_deferred_list again.
>>>
>>> It has many uses, like minimizing the number of pages after
>>> truncating a pagecache THP. For anonymous THPs, we can only split them
>>> to order-0 like before until we add support for any size anonymous THPs.
>>>
>>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  include/linux/huge_mm.h |   8 +++
>>>  mm/huge_memory.c        | 111 ++++++++++++++++++++++++++++++----------
>>>  2 files changed, 91 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 2999190adc22..c7153cd7e9e4 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -186,6 +186,8 @@ void free_transhuge_page(struct page *page);
>>>
>>>  bool can_split_folio(struct folio *folio, int *pextra_pins);
>>>  int split_huge_page_to_list(struct page *page, struct list_head *list);
>>> +int split_huge_page_to_list_to_order(struct page *page, struct list_he=
ad *list,
>>> +		unsigned int new_order);
>>>  static inline int split_huge_page(struct page *page)
>>>  {
>>>  	return split_huge_page_to_list(page, NULL);
>>> @@ -355,6 +357,12 @@ split_huge_page_to_list(struct page *page, struct =
list_head *list)
>>>  {
>>>  	return 0;
>>>  }
>>> +static inline int
>>> +split_huge_page_to_list_to_order(struct page *page, struct list_head *=
list,
>>> +		unsigned int new_order)
>>> +{
>>> +	return 0;
>>> +}
>>>  static inline int split_huge_page(struct page *page)
>>>  {
>>>  	return 0;
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index fcfa46af6c4c..3617aa3ad0b1 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2236,11 +2236,13 @@ void vma_adjust_trans_huge(struct vm_area_struc=
t *vma,
>>>  static void unmap_page(struct page *page)
>>>  {
>>>  	struct folio *folio =3D page_folio(page);
>>> -	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
>>> -		TTU_SYNC;
>>> +	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SYNC;
>>>
>>>  	VM_BUG_ON_PAGE(!PageHead(page), page);
>>>
>>> +	if (folio_order(folio) >=3D HPAGE_PMD_ORDER)
>>> +		ttu_flags |=3D TTU_SPLIT_HUGE_PMD;
>>> +
>>>  	/*
>>>  	 * Anon pages need migration entries to preserve them, but file
>>>  	 * pages can simply be left unmapped, then faulted back on demand.
>>> @@ -2254,9 +2256,9 @@ static void unmap_page(struct page *page)
>>>  	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
>>>  }
>>>
>>> -static void remap_page(struct folio *folio, unsigned long nr)
>>> +static void remap_page(struct folio *folio, unsigned short nr)
>>>  {
>>> -	int i =3D 0;
>>> +	unsigned int i;
>>>
>>>  	/* If unmap_page() uses try_to_migrate() on file, remove this check */
>>>  	if (!folio_test_anon(folio))
>>> @@ -2274,7 +2276,6 @@ static void lru_add_page_tail(struct page *head, =
struct page *tail,
>>>  		struct lruvec *lruvec, struct list_head *list)
>>>  {
>>>  	VM_BUG_ON_PAGE(!PageHead(head), head);
>>> -	VM_BUG_ON_PAGE(PageCompound(tail), head);
>>>  	VM_BUG_ON_PAGE(PageLRU(tail), head);
>>>  	lockdep_assert_held(&lruvec->lru_lock);
>>>
>>> @@ -2295,9 +2296,10 @@ static void lru_add_page_tail(struct page *head,=
 struct page *tail,
>>>  }
>>>
>>>  static void __split_huge_page_tail(struct page *head, int tail,
>>> -		struct lruvec *lruvec, struct list_head *list)
>>> +		struct lruvec *lruvec, struct list_head *list, unsigned int new_orde=
r)
>>>  {
>>>  	struct page *page_tail =3D head + tail;
>>> +	unsigned long compound_head_flag =3D new_order ? (1L << PG_head) : 0;
>>>
>>>  	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) !=3D -1, page_tail);
>>>
>>> @@ -2321,6 +2323,7 @@ static void __split_huge_page_tail(struct page *h=
ead, int tail,
>>>  #ifdef CONFIG_64BIT
>>>  			 (1L << PG_arch_2) |
>>>  #endif
>>> +			 compound_head_flag |
>>>  			 (1L << PG_dirty)));
>>>
>>>  	/* ->mapping in first tail page is compound_mapcount */
>>> @@ -2329,7 +2332,10 @@ static void __split_huge_page_tail(struct page *=
head, int tail,
>>>  	page_tail->mapping =3D head->mapping;
>>>  	page_tail->index =3D head->index + tail;
>>>
>>> -	/* Page flags must be visible before we make the page non-compound. */
>>> +	/*
>>> +	 * Page flags must be visible before we make the page non-compound or
>>> +	 * a compound page in new_order.
>>> +	 */
>>>  	smp_wmb();
>>>
>>>  	/*
>>> @@ -2339,10 +2345,15 @@ static void __split_huge_page_tail(struct page =
*head, int tail,
>>>  	 * which needs correct compound_head().
>>>  	 */
>>>  	clear_compound_head(page_tail);
>>> +	if (new_order) {
>>> +		prep_compound_page(page_tail, new_order);
>>> +		prep_transhuge_page(page_tail);
>>> +	}
>>
>> Many thanks for your series. It looks really good. One question:
>> IIUC, It seems there has assumption that LRU compound_pages should
>> be PageTransHuge. So PageTransHuge just checks PageHead:
>>
>> static inline int PageTransHuge(struct page *page)
>> {
>> 	VM_BUG_ON_PAGE(PageTail(page), page);
>> 	return PageHead(page);
>> }
>>
>> So LRU pages with any order( > 0) will might be wrongly treated as THP w=
hich
>> has order =3D HPAGE_PMD_ORDER. We should ensure thp_nr_pages is used ins=
tead of
>> hard coded HPAGE_PMD_ORDER.
>>
>> Looks at the below code snippet:
>> mm/mempolicy.c:
>> static struct page *new_page(struct page *page, unsigned long start)
>> {
>> ...
>> 	} else if (PageTransHuge(page)) {
>> 		struct page *thp;
>>
>> 		thp =3D alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
>> 					 HPAGE_PMD_ORDER);
>> 					 ^^^^^^^^^^^^^^^^
>> 		if (!thp)
>> 			return NULL;
>> 		prep_transhuge_page(thp);
>> 		return thp;
>> 	}
>> ...
>> }
>>
>> HPAGE_PMD_ORDER is used instead of thp_nr_pages. So the lower order page=
s might be
>> used as if its order is HPAGE_PMD_ORDER. All of such usage might need to=
 be fixed.
>> Or am I miss something ?
>>
>> Thanks again for your work. :)
>=20
> THP will still only have HPAGE_PMD_ORDER and will not be split into any o=
rder
> other than 0. This series only allows to split huge page cache folio (add=
ed by Matthew)
> into any lower order. I have an explicit VM_BUG_ON() to ensure new_order
> is only 0 when non page cache page is the input. Since there is still non=
-trivial
> amount of work to add any order THP support in the kernel. IIRC, Yu Zhao =
(cc=E2=80=99d) was
> planning to work on that.
>=20

Many thanks for clarifying. I'm sorry but I haven't followed Matthew's patc=
hes. I am
wondering could huge page cache folio be treated as THP ? If so, how to ens=
ure the
correctness of huge page cache ?

Thanks again!

> Thanks for checking the patches.

BTW: I like your patches. It's really interesting. :)

>=20
