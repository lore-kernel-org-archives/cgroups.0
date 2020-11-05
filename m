From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Thu, 5 Nov 2020 13:03:18 +0800
Message-ID: <1e8f0162-cf2e-03eb-e7e0-ccc9f6a3eaf2@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
 <20201102202003.GA740958@cmpxchg.org>
 <b4038b87-cf5a-fcb7-06f4-b98874029615@linux.alibaba.com>
 <20201104174603.GB744831@cmpxchg.org>
 <6eea82d8-e406-06ee-2333-eb6e2f1944e5@linux.alibaba.com>
 <20201105045702.GI17076@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20201105045702.GI17076@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>



=D4=DA 2020/11/5 =CF=C2=CE=E712:57, Matthew Wilcox =D0=B4=B5=C0:
> On Thu, Nov 05, 2020 at 12:52:05PM +0800, Alex Shi wrote:
>> @@ -1054,8 +1054,27 @@ static void __page_set_anon_rmap(struct page *pag=
e,
>>  	if (!exclusive)
>>  		anon_vma =3D anon_vma->root;
>> =20
>> +	/*
>> +	 * w/o the WRITE_ONCE here the following scenario may happens due to
>> +	 * store reordering.
>> +	 *
>> +	 *      CPU 0                                          CPU 1
>> +	 *
>> +	 * do_anonymous_page				page_idle_clear_pte_refs
>> +	 *   __page_set_anon_rmap
>> +	 *     page->mapping =3D anon_vma + PAGE_MAPPING_ANON
>> +	 *   lru_cache_add_inactive_or_unevictable()
>> +	 *     SetPageLRU(page)
>> +	 *                                               rmap_walk
>> +	 *                                                if PageAnon(page)
>> +	 *
>> +	 *  The 'SetPageLRU' may reordered before page->mapping setting, and
>> +	 *  page->mapping may set with anon_vma, w/o anon bit, then rmap_walk
>> +	 *  may goes to rmap_walk_file() for a anon page.
>> +	 */
>> +
>>  	anon_vma =3D (void *) anon_vma + PAGE_MAPPING_ANON;
>> -	page->mapping =3D (struct address_space *) anon_vma;
>> +	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
>>  	page->index =3D linear_page_index(vma, address);
>>  }
>=20
> I don't like these verbose comments with detailed descriptions in
> the source code.  They're fine in changelogs, but they clutter the
> code, and they get outdated really quickly.  My preference is for
> something more brief:
>=20
> 	/*
> 	 * Prevent page->mapping from pointing to an anon_vma without
> 	 * the PAGE_MAPPING_ANON bit set.  This could happen if the
> 	 * compiler stores anon_vma and then adds PAGE_MAPPING_ANON to it.
> 	 */
>=20

Yes, it's reansonble. So is the following fine?

From f166f0d5df350c5eae1218456b9e6e1bd43434e7 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Thu, 5 Nov 2020 11:38:24 +0800
Subject: [PATCH] mm/rmap: stop store reordering issue on page->mapping

Hugh Dickins and Minchan Kim observed a long time issue which
discussed here, but actully the mentioned fix missed.
https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop/
The store reordering may cause problem in the scenario:

	CPU 0						CPU1
   do_anonymous_page
	page_add_new_anon_rmap()
	  page->mapping =3D anon_vma + PAGE_MAPPING_ANON
	lru_cache_add_inactive_or_unevictable()
	  spin_lock(lruvec->lock)
	  SetPageLRU()
	  spin_unlock(lruvec->lock)
						/* idletacking judged it as LRU
						 * page so pass the page in
						 * page_idle_clear_pte_refs
						 */
						page_idle_clear_pte_refs
						  rmap_walk
						    if PageAnon(page)

Johannes give detailed examples how the store reordering could cause
a trouble:
The concern is the SetPageLRU may get reorder before 'page->mapping'
setting, That would make CPU 1 will observe at page->mapping after
observing PageLRU set on the page.

1. anon_vma + PAGE_MAPPING_ANON

   That's the in-order scenario and is fine.

2. NULL

   That's possible if the page->mapping store gets reordered to occur
   after SetPageLRU. That's fine too because we check for it.

3. anon_vma without the PAGE_MAPPING_ANON bit

   That would be a problem and could lead to all kinds of undesirable
   behavior including crashes and data corruption.

   Is it possible? AFAICT the compiler is allowed to tear the store to
   page->mapping and I don't see anything that would prevent it.

That said, I also don't see how the reader testing PageLRU under the
lru_lock would prevent that in the first place. AFAICT we need that
WRITE_ONCE() around the page->mapping assignment.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/rmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c050dab2ae65..73788505aa0a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1054,8 +1054,13 @@ static void __page_set_anon_rmap(struct page *page,
 	if (!exclusive)
 		anon_vma =3D anon_vma->root;
=20
+	/*
+	 * Prevent page->mapping from pointing to an anon_vma without
+	 * the PAGE_MAPPING_ANON bit set.  This could happen if the
+	 * compiler stores anon_vma and then adds PAGE_MAPPING_ANON to it.
+	 */
 	anon_vma =3D (void *) anon_vma + PAGE_MAPPING_ANON;
-	page->mapping =3D (struct address_space *) anon_vma;
+	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 	page->index =3D linear_page_index(vma, address);
 }
=20
--=20
1.8.3.1

