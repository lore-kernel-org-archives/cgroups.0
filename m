From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v18 16/32] mm/lru: introduce TestClearPageLRU
Date: Tue, 22 Sep 2020 11:53:37 +0800
Message-ID: <d3a3cee4-2680-8a04-edaf-4ddcc2e95058@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-17-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2009211504200.5214@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.2009211504200.5214@eggly.anvils>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>



=D4=DA 2020/9/22 =C9=CF=CE=E77:16, Hugh Dickins =D0=B4=B5=C0:
> On Mon, 24 Aug 2020, Alex Shi wrote:
>=20
>> Currently lru_lock still guards both lru list and page's lru bit, that's
>> ok. but if we want to use specific lruvec lock on the page, we need to
>> pin down the page's lruvec/memcg during locking. Just taking lruvec
>> lock first may be undermined by the page's memcg charge/migration. To
>> fix this problem, we could clear the lru bit out of locking and use
>> it as pin down action to block the page isolation in memcg changing.
>>
>> So now a standard steps of page isolation is following:
>> 	1, get_page(); 	       #pin the page avoid to be free
>> 	2, TestClearPageLRU(); #block other isolation like memcg change
>> 	3, spin_lock on lru_lock; #serialize lru list access
>> 	4, delete page from lru list;
>> The step 2 could be optimzed/replaced in scenarios which page is
>> unlikely be accessed or be moved between memcgs.
>>
>> This patch start with the first part: TestClearPageLRU, which combines
>> PageLRU check and ClearPageLRU into a macro func TestClearPageLRU. This
>> function will be used as page isolation precondition to prevent other
>> isolations some where else. Then there are may !PageLRU page on lru
>> list, need to remove BUG() checking accordingly.
>>
>> There 2 rules for lru bit now:
>> 1, the lru bit still indicate if a page on lru list, just in some
>>    temporary moment(isolating), the page may have no lru bit when
>>    it's on lru list.  but the page still must be on lru list when the
>>    lru bit set.
>> 2, have to remove lru bit before delete it from lru list.
>>
>> Hugh Dickins pointed that when a page is in free path and no one is
>> possible to take it, non atomic lru bit clearing is better, like in
>> __page_cache_release and release_pages.
>> And no need get_page() before lru bit clear in isolate_lru_page,
>> since it '(1) Must be called with an elevated refcount on the page'.
>=20
> Delete that paragraph: you're justifying changes made during the
> course of earlier review, but not needed here.  If we start to
> comment on everything that is not done...!
>=20

Will delete it!

>>
>> As Andrew Morton mentioned this change would dirty cacheline for page
>> isn't on LRU. But the lost would be acceptable with Rong Chen
>> <rong.a.chen@intel.com> report:
>> https://lkml.org/lkml/2020/3/4/173
>=20
> Please use a lore link instead, lkml.org is nice but unreliable:
> https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/

Yes, will replace the link.

>=20
>>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
>=20
> Acked-by: Hugh Dickins <hughd@google.com>
> when you make the changes suggested above and below.

Thanks!

>=20
> I still have long-standing reservations about this TestClearPageLRU
> technique (it's hard to reason about, and requires additional atomic ops
> in some places); but it's working, so I'd like it to go in, then later
> we can experiment with whether lock_page_memcg() does a better job, or
> rechecking memcg when getting the lru_lock (my original technique).
>=20
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: cgroups@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  include/linux/page-flags.h |  1 +
>>  mm/mlock.c                 |  3 +--
>>  mm/swap.c                  |  5 ++---
>>  mm/vmscan.c                | 18 +++++++-----------
>>  4 files changed, 11 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index 6be1aa559b1e..9554ed1387dc 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -326,6 +326,7 @@ static inline void page_init_poison(struct page *pag=
e, size_t size)
>>  PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
>>  	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
>>  PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
>> +	TESTCLEARFLAG(LRU, lru, PF_HEAD)
>>  PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HE=
AD)
>>  	TESTCLEARFLAG(Active, active, PF_HEAD)
>>  PAGEFLAG(Workingset, workingset, PF_HEAD)
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index 93ca2bf30b4f..3762d9dd5b31 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -107,13 +107,12 @@ void mlock_vma_page(struct page *page)
>>   */
>>  static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
>>  {
>> -	if (PageLRU(page)) {
>> +	if (TestClearPageLRU(page)) {
>>  		struct lruvec *lruvec;
>> =20
>>  		lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
>>  		if (getpage)
>>  			get_page(page);
>> -		ClearPageLRU(page);
>>  		del_page_from_lru_list(page, lruvec, page_lru(page));
>>  		return true;
>>  	}
>> diff --git a/mm/swap.c b/mm/swap.c
>> index f80ccd6f3cb4..446ffe280809 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -83,10 +83,9 @@ static void __page_cache_release(struct page *page)
>>  		struct lruvec *lruvec;
>>  		unsigned long flags;
>> =20
>> +		__ClearPageLRU(page);
>>  		spin_lock_irqsave(&pgdat->lru_lock, flags);
>>  		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> -		VM_BUG_ON_PAGE(!PageLRU(page), page);
>> -		__ClearPageLRU(page);
>>  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
>>  		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>>  	}
>> @@ -880,9 +879,9 @@ void release_pages(struct page **pages, int nr)
>>  				spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
>>  			}
>> =20
>> -			lruvec =3D mem_cgroup_page_lruvec(page, locked_pgdat);
>>  			VM_BUG_ON_PAGE(!PageLRU(page), page);
>>  			__ClearPageLRU(page);
>> +			lruvec =3D mem_cgroup_page_lruvec(page, locked_pgdat);
>>  			del_page_from_lru_list(page, lruvec, page_off_lru(page));
>>  		}
>> =20
>=20
> Please delete all those mods to mm/swap.c from this patch.  This patch
> is about introducing TestClearPageLRU, but that is not involved here.
> Several versions ago, yes it was, then I pointed out that these are
> operations on refcount 0 pages, and we don't want to add unnecessary
> atomic operations on them.  I expect you want to keep the rearrangements,
> but do them where you need them later (I expect that's in 20/32).

When I look into the 20th patch, replace lru_lock, it seems this change isn=
't
belong there too. And I try to reduce more code changes from 20th patch, si=
nce
it's already big enough. that make it hard to do bisect if anything wrong.

So the same dilemma is here to this patch. For the bisection friendly, may =
it's
better to split this part out?

Thanks!

>=20
> And I notice that one VM_BUG_ON_PAGE was kept and the other deleted:
> though one can certainly argue that they're redundant (as all BUGs
> should be), I think most people will feel safer to keep them both.

Right, will keep the BUG check here.

>=20
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 7b7b36bd1448..1b3e0eeaad64 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1665,8 +1665,6 @@ static unsigned long isolate_lru_pages(unsigned lo=
ng nr_to_scan,
>>  		page =3D lru_to_page(src);
>>  		prefetchw_prev_lru_page(page, src, flags);
>> =20
>> -		VM_BUG_ON_PAGE(!PageLRU(page), page);
>> -
>>  		nr_pages =3D compound_nr(page);
>>  		total_scan +=3D nr_pages;
>> =20
>=20
> It is not enough to remove just that one VM_BUG_ON_PAGE there.
> This is a patch series, and we don't need it to be perfect at every
> bisection point between patches, but we do need it to be reasonably
> robust, so as not to waste unrelated bughunters' time.  It didn't
> take me very long to crash on the "default: BUG()" further down
> isolate_lru_pages(), because now PageLRU may get cleared at any
> instant, whatever locks are held.
>=20
> (But you're absolutely right to leave the compaction and pagevec
> mods to subsequent patches: it's fairly safe to separate those out,
> and much easier for reviewers that you did so.)
>=20
> This patch is much more robust with __isolate_lru_page() mods below
> on top.  I agree there's other ways to do it, but given that nobody
> cares what the error return is from __isolate_lru_page(), except for
> the isolate_lru_pages() switch statement BUG() which has become
> invalid, I suggest just use -EBUSY throughout __isolate_lru_page().
> Yes, we can and should change that switch statement to an
> "if {} else {}" without any BUG(), but I don't want to mess
> you around at this time, leave cleanup like that until later.
> Please fold in this patch on top:
>=20

Thanks a lot! will merge it.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1540,7 +1540,7 @@ unsigned int reclaim_clean_pages_from_list(struct z=
one *zone,
>   */
>  int __isolate_lru_page(struct page *page, isolate_mode_t mode)
>  {
> -	int ret =3D -EINVAL;
> +	int ret =3D -EBUSY;
> =20
>  	/* Only take pages on the LRU. */
>  	if (!PageLRU(page))
> @@ -1550,8 +1550,6 @@ int __isolate_lru_page(struct page *page, isolate_m=
ode_t mode)
>  	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
>  		return ret;
> =20
> -	ret =3D -EBUSY;
> -
>  	/*
>  	 * To minimise LRU disruption, the caller can indicate that it only
>  	 * wants to isolate pages it will be able to operate on without
> @@ -1598,8 +1596,10 @@ int __isolate_lru_page(struct page *page, isolate_=
mode_t mode)
>  		 * sure the page is not being freed elsewhere -- the
>  		 * page release code relies on it.
>  		 */
> -		ClearPageLRU(page);
> -		ret =3D 0;
> +		if (TestClearPageLRU(page))
> +			ret =3D 0;
> +		else
> +			put_page(page);
>  	}

this code will finally be removed in next patch, but it's better in here no=
w.
Thanks!

> =20
>  	return ret;
>=20
>> @@ -1763,21 +1761,19 @@ int isolate_lru_page(struct page *page)
>>  	VM_BUG_ON_PAGE(!page_count(page), page);
>>  	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
>> =20
>> -	if (PageLRU(page)) {
>> +	if (TestClearPageLRU(page)) {
>>  		pg_data_t *pgdat =3D page_pgdat(page);
>>  		struct lruvec *lruvec;
>> +		int lru =3D page_lru(page);
>> =20
>> -		spin_lock_irq(&pgdat->lru_lock);
>> +		get_page(page);
>>  		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> -		if (PageLRU(page)) {
>> -			int lru =3D page_lru(page);
>> -			get_page(page);
>> -			ClearPageLRU(page);
>> -			del_page_from_lru_list(page, lruvec, lru);
>> -			ret =3D 0;
>> -		}
>> +		spin_lock_irq(&pgdat->lru_lock);
>> +		del_page_from_lru_list(page, lruvec, lru);
>>  		spin_unlock_irq(&pgdat->lru_lock);
>> +		ret =3D 0;
>>  	}
>> +
>>  	return ret;
>>  }
>=20
> And a small mod to isolate_lru_page() to be folded in.  I had
> never noticed this before, but here you are evaluating page_lru()
> after clearing PageLRU, but before getting lru_lock: that seems unsafe.
> I'm pretty sure it's unsafe at this stage of the series; I did once
> persuade myself that it becomes safe by the end of the series,
> but I've already forgotten the argument for that (I have already
> said TestClearPageLRU is difficult to reason about).  Please don't
> force us to have to think about this! Just get page_lru after lru_lock.
>=20
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1764,12 +1764,11 @@ int isolate_lru_page(struct page *page)
>  	if (TestClearPageLRU(page)) {
>  		pg_data_t *pgdat =3D page_pgdat(page);
>  		struct lruvec *lruvec;
> -		int lru =3D page_lru(page);
> =20
>  		get_page(page);
>  		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>  		spin_lock_irq(&pgdat->lru_lock);
> -		del_page_from_lru_list(page, lruvec, lru);
> +		del_page_from_lru_list(page, lruvec, page_lru(page));
>  		spin_unlock_irq(&pgdat->lru_lock);
>  		ret =3D 0;
>  	}
>=20

took thanks!

> And lastly, please do check_move_unevictable_pages()'s TestClearPageLRU
> mod here at the end of mm/vmscan.c in this patch: I noticed that your
> lruv19 branch is doing it in a later patch, but it fits better here.
>=20

will move that part change here
Thanks!
Alex
