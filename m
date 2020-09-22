From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 17/32] mm/compaction: do page isolation first in
 compaction
Date: Tue, 22 Sep 2020 12:57:00 +0800
Message-ID: <a9024c46-c344-0f6f-7e1b-a96e3c803201@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-18-git-send-email-alex.shi@linux.alibaba.com>
 <alpine.LSU.2.11.2009211617080.5214@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009211617080.5214-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/9/22 =C9=CF=CE=E77:49, Hugh Dickins =D0=B4=B5=C0:
> On Mon, 24 Aug 2020, Alex Shi wrote:
>=20
>> Currently, compaction would get the lru_lock and then do page isolation
>> which works fine with pgdat->lru_lock, since any page isoltion would
>> compete for the lru_lock. If we want to change to memcg lru_lock, we
>> have to isolate the page before getting lru_lock, thus isoltion would
>> block page's memcg change which relay on page isoltion too. Then we
>> could safely use per memcg lru_lock later.
>>
>> The new page isolation use previous introduced TestClearPageLRU() +
>> pgdat lru locking which will be changed to memcg lru lock later.
>>
>> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> fixed follo=
wing bugs in this patch's
>> early version:
>>
>> Fix lots of crashes under compaction load: isolate_migratepages_block()
>> must clean up appropriately when rejecting a page, setting PageLRU again
>> if it had been cleared; and a put_page() after get_page_unless_zero()
>> cannot safely be done while holding locked_lruvec - it may turn out to
>> be the final put_page(), which will take an lruvec lock when PageLRU.
>> And move __isolate_lru_page_prepare back after get_page_unless_zero to
>> make trylock_page() safe:
>> trylock_page() is not safe to use at this time: its setting PG_locked
>> can race with the page being freed or allocated ("Bad page"), and can
>> also erase flags being set by one of those "sole owners" of a freshly
>> allocated page who use non-atomic __SetPageFlag().
>>
>> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gman=
e.org>
>> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.o=
rg>
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@publi=
c.gmane.org>
>=20
> Okay, whatever. I was about to say
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks!

> With my signed-off-by there, someone will ask if it should say
> "From: Hugh ..." at the top: no, it should not, this is Alex's patch,
> but I proposed some fixes to it, as you already acknowledged.

I guess you prefer to remove your signed off here, don't you?

>=20
> A couple of comments below on the mm/vmscan.c part of it.
>=20
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.or=
g>
>> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>> ---
>>  include/linux/swap.h |  2 +-
>>  mm/compaction.c      | 42 +++++++++++++++++++++++++++++++++---------
>>  mm/vmscan.c          | 46 ++++++++++++++++++++++++++--------------------
>>  3 files changed, 60 insertions(+), 30 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 43e6b3458f58..550fdfdc3506 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -357,7 +357,7 @@ extern void lru_cache_add_inactive_or_unevictable(st=
ruct page *page,
>>  extern unsigned long zone_reclaimable_pages(struct zone *zone);
>>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int o=
rder,
>>  					gfp_t gfp_mask, nodemask_t *mask);
>> -extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
>> +extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t=
 mode);
>>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *me=
mcg,
>>  						  unsigned long nr_pages,
>>  						  gfp_t gfp_mask,
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 4e2c66869041..253382d99969 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -887,6 +887,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
>>  			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
>>  				low_pfn =3D end_pfn;
>> +				page =3D NULL;
>>  				goto isolate_abort;
>>  			}
>>  			valid_page =3D page;
>> @@ -968,6 +969,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
>>  			goto isolate_fail;
>> =20
>> +		/*
>> +		 * Be careful not to clear PageLRU until after we're
>> +		 * sure the page is not being freed elsewhere -- the
>> +		 * page release code relies on it.
>> +		 */
>> +		if (unlikely(!get_page_unless_zero(page)))
>> +			goto isolate_fail;
>> +
>> +		if (__isolate_lru_page_prepare(page, isolate_mode) !=3D 0)
>> +			goto isolate_fail_put;
>> +
>> +		/* Try isolate the page */
>> +		if (!TestClearPageLRU(page))
>> +			goto isolate_fail_put;
>> +
>>  		/* If we already hold the lock, we can skip some rechecking */
>>  		if (!locked) {
>>  			locked =3D compact_lock_irqsave(&pgdat->lru_lock,
>> @@ -980,10 +996,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  					goto isolate_abort;
>>  			}
>> =20
>> -			/* Recheck PageLRU and PageCompound under lock */
>> -			if (!PageLRU(page))
>> -				goto isolate_fail;
>> -
>>  			/*
>>  			 * Page become compound since the non-locked check,
>>  			 * and it's on LRU. It can only be a THP so the order
>> @@ -991,16 +1003,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  			 */
>>  			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
>>  				low_pfn +=3D compound_nr(page) - 1;
>> -				goto isolate_fail;
>> +				SetPageLRU(page);
>> +				goto isolate_fail_put;
>>  			}
>>  		}
>> =20
>>  		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
>> =20
>> -		/* Try isolate the page */
>> -		if (__isolate_lru_page(page, isolate_mode) !=3D 0)
>> -			goto isolate_fail;
>> -
>>  		/* The whole page is taken off the LRU; skip the tail pages. */
>>  		if (PageCompound(page))
>>  			low_pfn +=3D compound_nr(page) - 1;
>> @@ -1029,6 +1038,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  		}
>> =20
>>  		continue;
>> +
>> +isolate_fail_put:
>> +		/* Avoid potential deadlock in freeing page under lru_lock */
>> +		if (locked) {
>> +			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>> +			locked =3D false;
>> +		}
>> +		put_page(page);
>> +
>>  isolate_fail:
>>  		if (!skip_on_failure)
>>  			continue;
>> @@ -1065,9 +1083,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>  	if (unlikely(low_pfn > end_pfn))
>>  		low_pfn =3D end_pfn;
>> =20
>> +	page =3D NULL;
>> +
>>  isolate_abort:
>>  	if (locked)
>>  		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>> +	if (page) {
>> +		SetPageLRU(page);
>> +		put_page(page);
>> +	}
>> =20
>>  	/*
>>  	 * Updated the cached scanner pfn once the pageblock has been scanned
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 1b3e0eeaad64..48b50695f883 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1538,20 +1538,20 @@ unsigned int reclaim_clean_pages_from_list(struc=
t zone *zone,
>>   *
>>   * returns 0 on success, -ve errno on failure.
>>   */
>> -int __isolate_lru_page(struct page *page, isolate_mode_t mode)
>> +int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
>>  {
>>  	int ret =3D -EINVAL;
>> =20
>> -	/* Only take pages on the LRU. */
>> -	if (!PageLRU(page))
>> -		return ret;
>> -
>>  	/* Compaction should not handle unevictable pages but CMA can do so */
>>  	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
>>  		return ret;
>> =20
>>  	ret =3D -EBUSY;
>> =20
>> +	/* Only take pages on the LRU. */
>> +	if (!PageLRU(page))
>> +		return ret;
>> +
>=20
> So here you do deal with that BUG() issue.  But I'd prefer you to leave
> it as I suggested in 16/32, just start with "int ret =3D -EBUSY;" and
> don't rearrange the checks here at all.  I say that partly because
> the !PageLRU check is very important (when called for compaction), and
> the easier it is to find (at the very start), the less anxious I get!

yes, have done as your suggestion.

>=20
>>  	/*
>>  	 * To minimise LRU disruption, the caller can indicate that it only
>>  	 * wants to isolate pages it will be able to operate on without
>> @@ -1592,20 +1592,9 @@ int __isolate_lru_page(struct page *page, isolate=
_mode_t mode)
>>  	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
>>  		return ret;
>> =20
>> -	if (likely(get_page_unless_zero(page))) {
>> -		/*
>> -		 * Be careful not to clear PageLRU until after we're
>> -		 * sure the page is not being freed elsewhere -- the
>> -		 * page release code relies on it.
>> -		 */
>> -		ClearPageLRU(page);
>> -		ret =3D 0;
>> -	}
>> -
>> -	return ret;
>> +	return 0;
>>  }
>> =20
>> -
>>  /*
>>   * Update LRU sizes after isolating pages. The LRU size updates must
>>   * be complete before mem_cgroup_update_lru_size due to a sanity check.
>> @@ -1685,17 +1674,34 @@ static unsigned long isolate_lru_pages(unsigned =
long nr_to_scan,
>>  		 * only when the page is being freed somewhere else.
>>  		 */
>>  		scan +=3D nr_pages;
>> -		switch (__isolate_lru_page(page, mode)) {
>> +		switch (__isolate_lru_page_prepare(page, mode)) {
>>  		case 0:
>> +			/*
>> +			 * Be careful not to clear PageLRU until after we're
>> +			 * sure the page is not being freed elsewhere -- the
>> +			 * page release code relies on it.
>> +			 */
>> +			if (unlikely(!get_page_unless_zero(page)))
>> +				goto busy;
>> +
>> +			if (!TestClearPageLRU(page)) {
>> +				/*
>> +				 * This page may in other isolation path,
>> +				 * but we still hold lru_lock.
>> +				 */
>> +				put_page(page);
>> +				goto busy;
>> +			}
>> +
>>  			nr_taken +=3D nr_pages;
>>  			nr_zone_taken[page_zonenum(page)] +=3D nr_pages;
>>  			list_move(&page->lru, dst);
>>  			break;
>> -
>> +busy:
>>  		case -EBUSY:
>=20
> It's a long time since I read a C manual. I had to try that out in a
> little test program: and it does seem to do the right thing.  Maybe
> I'm just very ignorant, and everybody else finds that natural: but I'd
> feel more comfortable with the busy label on the line after the
> "case -EBUSY:" - wouldn't you?

will move down. Thanks!

>=20
> You could, of course, change that "case -EBUSY" to "default",
> and delete the "default: BUG();" that follows: whatever you prefer.
>=20

yes, the default is enough after last patch's change.

>>  			/* else it is being freed elsewhere */
>>  			list_move(&page->lru, src);
>> -			continue;
>> +			break;
>=20
> Aha. Yes, I like that change, I'm not going to throw a tantrum,
> accusing you of sneaking in unrelated changes etc. You made me look
> back at the history: it was "continue" from back in the days of
> lumpy reclaim, when there was stuff after the switch statement
> which needed to be skipped in the -EBUSY case.  "break" looks
> more natural to me now.

Thanks!
with above 'default' change, the break could be saved finally. :)

Thanks!

>=20
>> =20
>>  		default:
>>  			BUG();
>> --=20
>> 1.8.3.1
