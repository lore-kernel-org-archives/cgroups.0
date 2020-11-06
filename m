From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v21 06/19] mm/rmap: stop store reordering issue on
 page->mapping
Date: Fri, 6 Nov 2020 09:20:04 +0800
Message-ID: <e66ef2e5-c74c-6498-e8b3-56c37b9d2d15@linux.alibaba.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-7-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1604566549-62481-7-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>



updated for comments change from Johannes


From 2fd278b1ca6c3e260ad249808b62f671d8db5a7b Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Thu, 5 Nov 2020 11:38:24 +0800
Subject: [PATCH v21 06/19] mm/rmap: stop store reordering issue on
 page->mapping

Hugh Dickins and Minchan Kim observed a long time issue which
discussed here, but actully the mentioned fix missed.
https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop/
The store reordering may cause problem in the scenario:

	CPU 0						CPU1
   do_anonymous_page
	page_add_new_anon_rmap()
	  page->mapping = anon_vma + PAGE_MAPPING_ANON
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
"The concern is the SetPageLRU may get reorder before 'page->mapping'
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
WRITE_ONCE() around the page->mapping assignment."

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 mm/rmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1b84945d655c..380c6b9956c2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1054,8 +1054,14 @@ static void __page_set_anon_rmap(struct page *page,
 	if (!exclusive)
 		anon_vma = anon_vma->root;
 
+	/*
+	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
+	 * Make sure the compiler doesn't split the stores of anon_vma and
+	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
+	 * could mistake the mapping for a struct address_space and crash.
+	 */
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
-	page->mapping = (struct address_space *) anon_vma;
+	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 	page->index = linear_page_index(vma, address);
 }
 
-- 
1.8.3.1

