From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v13 10/18] mm/lru: introduce TestClearPageLRU
Date: Fri, 19 Jun 2020 16:33:48 +0800
Message-ID: <1592555636-115095-11-git-send-email-alex.shi@linux.alibaba.com>
References: <1592555636-115095-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1592555636-115095-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Combine PageLRU check and ClearPageLRU into a function by new
introduced func TestClearPageLRU. This function will be used as page
isolation precondition to prevent other isolations some where else.
Then there are may non PageLRU page on lru list, need to remove BUG
checking accordingly.

Hugh Dickins pointed that __page_cache_release and release_pages
has no need to do atomic clear bit since no user on the page at that
moment. and no need get_page() before lru bit clear in isolate_lru_page,
since it '(1) Must be called with an elevated refcount on the page'.

As Andrew Morton mentioned this change would dirty cacheline for page
isn't on LRU. But the lost would be acceptable with Rong Chen
<rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> report:
https://lkml.org/lkml/2020/3/4/173

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/page-flags.h |  1 +
 mm/mlock.c                 |  3 +--
 mm/swap.c                  |  6 ++----
 mm/vmscan.c                | 26 +++++++++++---------------
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6be1aa559b1e..9554ed1387dc 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -326,6 +326,7 @@ static inline void page_init_poison(struct page *page, size_t size)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+	TESTCLEARFLAG(LRU, lru, PF_HEAD)
 PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
 	TESTCLEARFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
diff --git a/mm/mlock.c b/mm/mlock.c
index f8736136fad7..228ba5a8e0a5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -108,13 +108,12 @@ void mlock_vma_page(struct page *page)
  */
 static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
 {
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		struct lruvec *lruvec;
 
 		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
 		if (getpage)
 			get_page(page);
-		ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		return true;
 	}
diff --git a/mm/swap.c b/mm/swap.c
index e2a9f58a2826..7ff9aa6a716a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -83,10 +83,9 @@ static void __page_cache_release(struct page *page)
 		struct lruvec *lruvec;
 		unsigned long flags;
 
+		__ClearPageLRU(page);
 		spin_lock_irqsave(&pgdat->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
-		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 	}
@@ -877,9 +876,8 @@ void release_pages(struct page **pages, int nr)
 				spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
 			}
 
-			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
-			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
+			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81228334f7d6..3175276e3288 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1547,16 +1547,16 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 {
 	int ret = -EINVAL;
 
-	/* Only take pages on the LRU. */
-	if (!PageLRU(page))
-		return ret;
-
 	/* Compaction should not handle unevictable pages but CMA can do so */
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
 	ret = -EBUSY;
 
+	/* Only take pages on the LRU. */
+	if (!PageLRU(page))
+		return ret;
+
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
 	 * wants to isolate pages it will be able to operate on without
@@ -1670,8 +1670,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
 
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
-
 		nr_pages = compound_nr(page);
 		total_scan += nr_pages;
 
@@ -1768,21 +1766,19 @@ int isolate_lru_page(struct page *page)
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
 
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
+		int lru = page_lru(page);
 
-		spin_lock_irq(&pgdat->lru_lock);
+		get_page(page);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		if (PageLRU(page)) {
-			int lru = page_lru(page);
-			get_page(page);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, lru);
-			ret = 0;
-		}
+		spin_lock_irq(&pgdat->lru_lock);
+		del_page_from_lru_list(page, lruvec, lru);
 		spin_unlock_irq(&pgdat->lru_lock);
+		ret = 0;
 	}
+
 	return ret;
 }
 
-- 
1.8.3.1

