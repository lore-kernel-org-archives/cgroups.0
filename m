From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 2/2] mm: memcontrol: fix missed end-writeback page
 accounting
Date: Thu, 23 Oct 2014 09:57:29 -0400
Message-ID: <20141023135729.GB24269@phnom.home.cmpxchg.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-3-git-send-email-hannes@cmpxchg.org>
 <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 01:39:36PM -0700, Andrew Morton wrote:
> On Wed, 22 Oct 2014 14:29:28 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > @@ -1061,9 +1062,10 @@ void page_add_file_rmap(struct page *page)
> >   */
> >  void page_remove_rmap(struct page *page)
> >  {
> > +	struct mem_cgroup *uninitialized_var(memcg);
> >  	bool anon = PageAnon(page);
> > -	bool locked;
> >  	unsigned long flags;
> > +	bool locked;
> >  
> >  	/*
> >  	 * The anon case has no mem_cgroup page_stat to update; but may
> > @@ -1071,7 +1073,7 @@ void page_remove_rmap(struct page *page)
> >  	 * we hold the lock against page_stat move: so avoid it on anon.
> >  	 */
> >  	if (!anon)
> > -		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> > +		memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
> >  
> >  	/* page still mapped by someone else? */
> >  	if (!atomic_add_negative(-1, &page->_mapcount))
> > @@ -1096,8 +1098,7 @@ void page_remove_rmap(struct page *page)
> >  				-hpage_nr_pages(page));
> >  	} else {
> >  		__dec_zone_page_state(page, NR_FILE_MAPPED);
> > -		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
> > -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
> > +		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
> >  	}
> >  	if (unlikely(PageMlocked(page)))
> >  		clear_page_mlock(page);
> > @@ -1110,10 +1111,9 @@ void page_remove_rmap(struct page *page)
> >  	 * Leaving it set also helps swapoff to reinstate ptes
> >  	 * faster for those pages still in swapcache.
> >  	 */
> > -	return;
> >  out:
> >  	if (!anon)
> > -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
> > +		mem_cgroup_end_page_stat(memcg, locked, flags);
> >  }
> 
> The anon and file paths have as much unique code as they do common
> code.  I wonder if page_remove_rmap() would come out better if split
> into two functions?  I gave that a quick try and it came out OK-looking.

I agree, that looks better.  How about this?

---
From b518d88254b01be8c6c0c4a496d9f311f0c71b4a Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 23 Oct 2014 09:29:06 -0400
Subject: [patch] mm: rmap: split out page_remove_file_rmap()

page_remove_rmap() has too many branches on PageAnon() and is hard to
follow.  Move the file part into a separate function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/rmap.c | 78 +++++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index f574046f77d4..19886fb2f13a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1054,6 +1054,36 @@ void page_add_file_rmap(struct page *page)
 	mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
+static void page_remove_file_rmap(struct page *page)
+{
+	struct mem_cgroup *memcg;
+	unsigned long flags;
+	bool locked;
+
+	memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		goto out;
+
+	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
+	if (unlikely(PageHuge(page)))
+		goto out;
+
+	/*
+	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * these counters are not modified in interrupt context, and
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
+	 */
+	__dec_zone_page_state(page, NR_FILE_MAPPED);
+	mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
+
+	if (unlikely(PageMlocked(page)))
+		clear_page_mlock(page);
+out:
+	mem_cgroup_end_page_stat(memcg, locked, flags);
+}
+
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
@@ -1062,46 +1092,33 @@ void page_add_file_rmap(struct page *page)
  */
 void page_remove_rmap(struct page *page)
 {
-	struct mem_cgroup *uninitialized_var(memcg);
-	bool anon = PageAnon(page);
-	unsigned long flags;
-	bool locked;
-
-	/*
-	 * The anon case has no mem_cgroup page_stat to update; but may
-	 * uncharge_page() below, where the lock ordering can deadlock if
-	 * we hold the lock against page_stat move: so avoid it on anon.
-	 */
-	if (!anon)
-		memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+	if (!PageAnon(page)) {
+		page_remove_file_rmap(page);
+		return;
+	}
 
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		goto out;
+		return;
+
+	/* Hugepages are not counted in NR_ANON_PAGES for now. */
+	if (unlikely(PageHuge(page)))
+		return;
 
 	/*
-	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
-	 * and not charged by memcg for now.
-	 *
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
-	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	if (unlikely(PageHuge(page)))
-		goto out;
-	if (anon) {
-		if (PageTransHuge(page))
-			__dec_zone_page_state(page,
-					      NR_ANON_TRANSPARENT_HUGEPAGES);
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-				-hpage_nr_pages(page));
-	} else {
-		__dec_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
-	}
+	if (PageTransHuge(page))
+		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+			      -hpage_nr_pages(page));
+
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
+
 	/*
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
@@ -1111,9 +1128,6 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
-out:
-	if (!anon)
-		mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
 /*
-- 
2.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
