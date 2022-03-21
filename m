From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 2/5] mm: page_owner: add support for splitting to any order in split page_owner.
Date: Mon, 21 Mar 2022 15:08:15 -0400
Message-ID: <364AEDD0-1BA2-4F36-877A-C5CD4BEC74B3@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-3-zi.yan@sent.com>
 <YjjLzvT2if2JDbGE@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_694D7C14-1DB8-4269-B827-50B94088E4B7_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjES0IBRyTMPyFfNR/HhBSxjxOXhQb6WWZFOTXrYuSs=;
 b=PUleaI2X3FxPYCmHzo1lCD8GyC515gD0c6ClL+NkEgO3jHr+ZPNmSTitcI2qj24DcyNHVFBle/mx8DCRKsbGsofpaAmIO8HnaQjwn0gFjdeqZe42kudjIsEGa9nl2Fpv+T5qIIfpTSX8HrCRdP7yTH8BfCTWiQiDVF+kIQvZilQbQtzuG98zhqBFKiqHMxWNz4PUy7LoBp1CnliJjkVTevn6OMmhaGsWRvzMXzw9ELrmWpCg+DhQSBzGc1p1+zqtIJXgdsaq1epfE6Z/I3gd8kb9hLOLzAdEleBq0qk216yaN0uAqteIx3p/5Z6yCVLixZmXxuzywREaW3rc06BClQ==
In-Reply-To: <YjjLzvT2if2JDbGE-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_694D7C14-1DB8-4269-B827-50B94088E4B7_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 21 Mar 2022, at 15:02, Roman Gushchin wrote:

> On Mon, Mar 21, 2022 at 10:21:25AM -0400, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> It adds a new_order parameter to set new page order in page owner and
>> uses old_order instead of nr to make the parameters look consistent.
>> It prepares for upcoming changes to support split huge page to any
>> lower order.
>>
>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/page_owner.h | 12 +++++++-----
>>  mm/huge_memory.c           |  3 ++-
>>  mm/page_alloc.c            |  2 +-
>>  mm/page_owner.c            | 13 +++++++------
>>  4 files changed, 17 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
>> index 119a0c9d2a8b..16050cc89274 100644
>> --- a/include/linux/page_owner.h
>> +++ b/include/linux/page_owner.h
>> @@ -11,7 +11,8 @@ extern struct page_ext_operations page_owner_ops;
>>  extern void __reset_page_owner(struct page *page, unsigned short orde=
r);
>>  extern void __set_page_owner(struct page *page,
>>  			unsigned short order, gfp_t gfp_mask);
>> -extern void __split_page_owner(struct page *page, unsigned int nr);
>> +extern void __split_page_owner(struct page *page, unsigned short old_=
order,
>> +			unsigned short new_order);
>
> Unsigned short here,
>
>>  extern void __folio_copy_owner(struct folio *newfolio, struct folio *=
old);
>>  extern void __set_page_owner_migrate_reason(struct page *page, int re=
ason);
>>  extern void __dump_page_owner(const struct page *page);
>> @@ -31,10 +32,11 @@ static inline void set_page_owner(struct page *pag=
e,
>>  		__set_page_owner(page, order, gfp_mask);
>>  }
>>
>> -static inline void split_page_owner(struct page *page, unsigned int n=
r)
>> +static inline void split_page_owner(struct page *page, unsigned int o=
ld_order,
>> +			unsigned int new_order)
>
> but unsigned int here.
>
>>  {
>>  	if (static_branch_unlikely(&page_owner_inited))
>> -		__split_page_owner(page, nr);
>> +		__split_page_owner(page, old_order, new_order);
>>  }
>>  static inline void folio_copy_owner(struct folio *newfolio, struct fo=
lio *old)
>>  {
>> @@ -56,11 +58,11 @@ static inline void reset_page_owner(struct page *p=
age, unsigned short order)
>>  {
>>  }
>>  static inline void set_page_owner(struct page *page,
>> -			unsigned int order, gfp_t gfp_mask)
>> +			unsigned short order, gfp_t gfp_mask)
>>  {
>>  }
>>  static inline void split_page_owner(struct page *page,
>> -			unsigned short order)
>> +			unsigned short old_order, unsigned short new_order)
>>  {
>>  }
>>  static inline void folio_copy_owner(struct folio *newfolio, struct fo=
lio *folio)
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 640040c386f0..fcfa46af6c4c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2367,6 +2367,7 @@ static void __split_huge_page(struct page *page,=
 struct list_head *list,
>>  	struct lruvec *lruvec;
>>  	struct address_space *swap_cache =3D NULL;
>>  	unsigned long offset =3D 0;
>> +	unsigned int order =3D thp_order(head);
>>  	unsigned int nr =3D thp_nr_pages(head);
>>  	int i;
>>
>> @@ -2408,7 +2409,7 @@ static void __split_huge_page(struct page *page,=
 struct list_head *list,
>>  	unlock_page_lruvec(lruvec);
>>  	/* Caller disabled irqs, so they are still disabled here */
>>
>> -	split_page_owner(head, nr);
>> +	split_page_owner(head, order, 0);
>>
>>  	/* See comment in __split_huge_page_tail() */
>>  	if (PageAnon(head)) {
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d982919b9e51..9cac40c26c58 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3514,7 +3514,7 @@ void split_page(struct page *page, unsigned int =
order)
>>
>>  	for (i =3D 1; i < (1 << order); i++)
>>  		set_page_refcounted(page + i);
>> -	split_page_owner(page, 1 << order);
>> +	split_page_owner(page, order, 0);
>>  	split_page_memcg(page, 1 << order, 0);
>>  }
>>  EXPORT_SYMBOL_GPL(split_page);
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 0a9588506571..52013c846d19 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -202,19 +202,20 @@ void __set_page_owner_migrate_reason(struct page=
 *page, int reason)
>>  	page_owner->last_migrate_reason =3D reason;
>>  }
>>
>> -void __split_page_owner(struct page *page, unsigned int nr)
>> +void __split_page_owner(struct page *page, unsigned short old_order,
>> +			unsigned short new_order)
>
> And short again here. Please, make it consistent.
>
> Other than that, looks good to me. Please, feel free to add
> Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> after fixing the type inconsistency.

Sure. Will fix all the inconsistent types. Thanks.

--=_MailMate_694D7C14-1DB8-4269-B827-50B94088E4B7_=--
