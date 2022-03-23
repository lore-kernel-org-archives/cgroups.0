From: Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC PATCH 3/5] mm: thp: split huge page to any lower order pages.
Date: Wed, 23 Mar 2022 18:10:30 -0400
Message-ID: <87E48455-3FDD-47FC-A953-CBAB52FD3889@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-4-zi.yan@sent.com>
 <165ec1a8-2b35-f6fb-82d3-b94613dd437a@huawei.com>
 <D03D6945-8BFE-4137-BDB6-BD884656B65B@nvidia.com>
 <ed175cd4-1411-459e-e892-7d889e1253c0@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_DC4B50B5-6DCA-4CAA-8B60-62A7AC8DC6E9_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJwHhkjndhwwO4R9mAn4FNMo4+wYfhcZh9Yp1hLZu+I=;
 b=n6aHPUnYEyqqZABD4dPksQWrFKCOViKJPUIo6Yc2bYXychFMOUoMwOgrFhUJijHAxF9Kyqwjrm0h7TakMi73MBiAC4anAr4pee61j7/bVmMMj02DBhhKUf2eBAZEQxKL3ixlbfVhcbZKwC69fb8/NK/RevVmUxlEWZ9ljQRt2Ii4le2ilP46hVcy+FwEX5YlMYHS3nqO0M7damHerObto38yCjUfdAfFCUaO72m+csdpHXHm+ORN/qtJKkqYhcl8rOQC8HdlY+v7JDQgesYRgGzL89wAaKLzUK/HKUEpk7Qj91/4EuDnCx509FpscuTO0Vh1WeJk7JTJ3k5qmN1oAA==
In-Reply-To: <ed175cd4-1411-459e-e892-7d889e1253c0@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Shuah Khan <shuah@kernel.org>, Yang Shi <shy828301@gmail.com>, Hugh Dickins <hughd@google.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, Yu Zhao <yuzhao@google.com>

--=_MailMate_DC4B50B5-6DCA-4CAA-8B60-62A7AC8DC6E9_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22 Mar 2022, at 22:31, Miaohe Lin wrote:

> On 2022/3/22 22:30, Zi Yan wrote:
>> On 21 Mar 2022, at 23:21, Miaohe Lin wrote:
>>
>>> On 2022/3/21 22:21, Zi Yan wrote:
>>>> From: Zi Yan <ziy@nvidia.com>
>>>>
>>>> To split a THP to any lower order pages, we need to reform THPs on
>>>> subpages at given order and add page refcount based on the new page
>>>> order. Also we need to reinitialize page_deferred_list after removin=
g
>>>> the page from the split_queue, otherwise a subsequent split will see=

>>>> list corruption when checking the page_deferred_list again.
>>>>
>>>> It has many uses, like minimizing the number of pages after
>>>> truncating a pagecache THP. For anonymous THPs, we can only split th=
em
>>>> to order-0 like before until we add support for any size anonymous T=
HPs.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  include/linux/huge_mm.h |   8 +++
>>>>  mm/huge_memory.c        | 111 ++++++++++++++++++++++++++++++-------=
---
>>>>  2 files changed, 91 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 2999190adc22..c7153cd7e9e4 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -186,6 +186,8 @@ void free_transhuge_page(struct page *page);
>>>>
>>>>  bool can_split_folio(struct folio *folio, int *pextra_pins);
>>>>  int split_huge_page_to_list(struct page *page, struct list_head *li=
st);
>>>> +int split_huge_page_to_list_to_order(struct page *page, struct list=
_head *list,
>>>> +		unsigned int new_order);
>>>>  static inline int split_huge_page(struct page *page)
>>>>  {
>>>>  	return split_huge_page_to_list(page, NULL);
>>>> @@ -355,6 +357,12 @@ split_huge_page_to_list(struct page *page, stru=
ct list_head *list)
>>>>  {
>>>>  	return 0;
>>>>  }
>>>> +static inline int
>>>> +split_huge_page_to_list_to_order(struct page *page, struct list_hea=
d *list,
>>>> +		unsigned int new_order)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>>  static inline int split_huge_page(struct page *page)
>>>>  {
>>>>  	return 0;
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index fcfa46af6c4c..3617aa3ad0b1 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2236,11 +2236,13 @@ void vma_adjust_trans_huge(struct vm_area_st=
ruct *vma,
>>>>  static void unmap_page(struct page *page)
>>>>  {
>>>>  	struct folio *folio =3D page_folio(page);
>>>> -	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD =
|
>>>> -		TTU_SYNC;
>>>> +	enum ttu_flags ttu_flags =3D TTU_RMAP_LOCKED | TTU_SYNC;
>>>>
>>>>  	VM_BUG_ON_PAGE(!PageHead(page), page);
>>>>
>>>> +	if (folio_order(folio) >=3D HPAGE_PMD_ORDER)
>>>> +		ttu_flags |=3D TTU_SPLIT_HUGE_PMD;
>>>> +
>>>>  	/*
>>>>  	 * Anon pages need migration entries to preserve them, but file
>>>>  	 * pages can simply be left unmapped, then faulted back on demand.=

>>>> @@ -2254,9 +2256,9 @@ static void unmap_page(struct page *page)
>>>>  	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
>>>>  }
>>>>
>>>> -static void remap_page(struct folio *folio, unsigned long nr)
>>>> +static void remap_page(struct folio *folio, unsigned short nr)
>>>>  {
>>>> -	int i =3D 0;
>>>> +	unsigned int i;
>>>>
>>>>  	/* If unmap_page() uses try_to_migrate() on file, remove this chec=
k */
>>>>  	if (!folio_test_anon(folio))
>>>> @@ -2274,7 +2276,6 @@ static void lru_add_page_tail(struct page *hea=
d, struct page *tail,
>>>>  		struct lruvec *lruvec, struct list_head *list)
>>>>  {
>>>>  	VM_BUG_ON_PAGE(!PageHead(head), head);
>>>> -	VM_BUG_ON_PAGE(PageCompound(tail), head);
>>>>  	VM_BUG_ON_PAGE(PageLRU(tail), head);
>>>>  	lockdep_assert_held(&lruvec->lru_lock);
>>>>
>>>> @@ -2295,9 +2296,10 @@ static void lru_add_page_tail(struct page *he=
ad, struct page *tail,
>>>>  }
>>>>
>>>>  static void __split_huge_page_tail(struct page *head, int tail,
>>>> -		struct lruvec *lruvec, struct list_head *list)
>>>> +		struct lruvec *lruvec, struct list_head *list, unsigned int new_o=
rder)
>>>>  {
>>>>  	struct page *page_tail =3D head + tail;
>>>> +	unsigned long compound_head_flag =3D new_order ? (1L << PG_head) :=
 0;
>>>>
>>>>  	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) !=3D -1, page_ta=
il);
>>>>
>>>> @@ -2321,6 +2323,7 @@ static void __split_huge_page_tail(struct page=
 *head, int tail,
>>>>  #ifdef CONFIG_64BIT
>>>>  			 (1L << PG_arch_2) |
>>>>  #endif
>>>> +			 compound_head_flag |
>>>>  			 (1L << PG_dirty)));
>>>>
>>>>  	/* ->mapping in first tail page is compound_mapcount */
>>>> @@ -2329,7 +2332,10 @@ static void __split_huge_page_tail(struct pag=
e *head, int tail,
>>>>  	page_tail->mapping =3D head->mapping;
>>>>  	page_tail->index =3D head->index + tail;
>>>>
>>>> -	/* Page flags must be visible before we make the page non-compound=
=2E */
>>>> +	/*
>>>> +	 * Page flags must be visible before we make the page non-compound=
 or
>>>> +	 * a compound page in new_order.
>>>> +	 */
>>>>  	smp_wmb();
>>>>
>>>>  	/*
>>>> @@ -2339,10 +2345,15 @@ static void __split_huge_page_tail(struct pa=
ge *head, int tail,
>>>>  	 * which needs correct compound_head().
>>>>  	 */
>>>>  	clear_compound_head(page_tail);
>>>> +	if (new_order) {
>>>> +		prep_compound_page(page_tail, new_order);
>>>> +		prep_transhuge_page(page_tail);
>>>> +	}
>>>
>>> Many thanks for your series. It looks really good. One question:
>>> IIUC, It seems there has assumption that LRU compound_pages should
>>> be PageTransHuge. So PageTransHuge just checks PageHead:
>>>
>>> static inline int PageTransHuge(struct page *page)
>>> {
>>> 	VM_BUG_ON_PAGE(PageTail(page), page);
>>> 	return PageHead(page);
>>> }
>>>
>>> So LRU pages with any order( > 0) will might be wrongly treated as TH=
P which
>>> has order =3D HPAGE_PMD_ORDER. We should ensure thp_nr_pages is used =
instead of
>>> hard coded HPAGE_PMD_ORDER.
>>>
>>> Looks at the below code snippet:
>>> mm/mempolicy.c:
>>> static struct page *new_page(struct page *page, unsigned long start)
>>> {
>>> ...
>>> 	} else if (PageTransHuge(page)) {
>>> 		struct page *thp;
>>>
>>> 		thp =3D alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
>>> 					 HPAGE_PMD_ORDER);
>>> 					 ^^^^^^^^^^^^^^^^
>>> 		if (!thp)
>>> 			return NULL;
>>> 		prep_transhuge_page(thp);
>>> 		return thp;
>>> 	}
>>> ...
>>> }
>>>
>>> HPAGE_PMD_ORDER is used instead of thp_nr_pages. So the lower order p=
ages might be
>>> used as if its order is HPAGE_PMD_ORDER. All of such usage might need=
 to be fixed.
>>> Or am I miss something ?
>>>
>>> Thanks again for your work. :)
>>
>> THP will still only have HPAGE_PMD_ORDER and will not be split into an=
y order
>> other than 0. This series only allows to split huge page cache folio (=
added by Matthew)
>> into any lower order. I have an explicit VM_BUG_ON() to ensure new_ord=
er
>> is only 0 when non page cache page is the input. Since there is still =
non-trivial
>> amount of work to add any order THP support in the kernel. IIRC, Yu Zh=
ao (cc=E2=80=99d) was
>> planning to work on that.
>>
>
> Many thanks for clarifying. I'm sorry but I haven't followed Matthew's =
patches. I am
> wondering could huge page cache folio be treated as THP ? If so, how to=
 ensure the
> correctness of huge page cache ?

You are right. All these HPAGE_PMD_ORDRE locations should be replaced by =
thp_nr_pages().
I will look into it.

Thanks a lot.

--
Best Regards,
Yan, Zi

--=_MailMate_DC4B50B5-6DCA-4CAA-8B60-62A7AC8DC6E9_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmI7mtYPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUI5gP/Rvk/hHI+7xsU6xD2usmKWf/LlfFO5xSlLhe
57lN7MXq+sT4chNs2cTVdpb/ew9Oj/sUVQ8nj2mNlYMardQcRHNQOPVwOmqYbnKs
wyzSqbv9t5OtPoGmRhS3YSmq9b4PcBcF2NCB99dWQz8m7ksBaUO8hnKXGOql7Q3T
QqemZNWe14k4qKIdolNuQT/XwQEGL5Bo2eb/KNgkvIii+tB907gj7melrxWOvqdo
iovfDegRS0+Cd93+Q27OUP/tAzJftINtOnfbN5+ltZekRrWyEhLH+uBc9b4k8Ac/
f2xPd4sfoiqXOfSTp8ejzfFznxOQCjo9+w8Dc/OwsgB8a7ZrlRRmCA7q4FChQHdX
0tgXjoPwxQbpNQrqcMIhKPZvIp4dKpTllk9Oq9VyLpE/RRsOUJ1YvZGAz/MC+LR0
1Y6lSeb/Fed91WDkpBvoSf7UVXg7FnxRzHsbcepsroouPLcXYoz0LC2AvY9DvrVl
n5TPO0JZLCjK13SUoDgxMVQEt1HkRZCdz+b/32YCLcJhkki9bZGm9sem69ehLfvk
dte+ix1LJOdqrucntX1IE45V/W4ZRRQqNxo6jfLSJ+xK92B78EX9W6+wMvKMZQLy
PizwyZDGYa7bH5T/br62X6uojT1z/tmu5Ldez8S9TnTrrkrmIoN0M5+gtw9aE5MK
JoLtHZM2
=gBi+
-----END PGP SIGNATURE-----

--=_MailMate_DC4B50B5-6DCA-4CAA-8B60-62A7AC8DC6E9_=--
