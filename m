From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v5 11/11] mm: lru: use lruvec lock to serialize memcg changes
Date: Mon, 30 May 2022 15:49:19 +0800
Message-ID: <20220530074919.46352-12-songmuchun@bytedance.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zTIPIwKXUo1jntkJwVJ1sc6imAMuNPgvSBrYOaWp7QA=;
        b=nG5qRDAwcXWO+X0Dki+i4YRhICkZTgizDnL8jGVt8i38gBcnMQ+PEzB+4S8f9bRmMM
         /dr5aZuC15y7PfpyTFr/vkOdIFmHF/lvgEW6BcSF+u0sQfJ0Jr1riyfq7eyAXMqBMriU
         gpaWesos7gIbjD/4ebYzpph8ntcaNrvYk6ZsIs+O9X8LLNZnEwvhBciiUHcFWbUkepH6
         f7uQXVabUjxGAqexFEeMZtu0mn+ShivhUM3cH96KyBk8JbMdL6sAPc5rpchNyBeAr4vu
         mkiOhXkDrR99zKdVBXqW1XnPc4KPjTH5VGTiyNXtRA+pl7QVsUAJzg1OYerfzLi4ttKY
         WPsA==
In-Reply-To: <20220530074919.46352-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

As described by commit fc574c23558c ("mm/swap.c: serialize memcg
changes in pagevec_lru_move_fn"), TestClearPageLRU() aims to
serialize mem_cgroup_move_account() during pagevec_lru_move_fn().
Now folio_lruvec_lock*() has the ability to detect whether page
memcg has been changed. So we can use lruvec lock to serialize
mem_cgroup_move_account() during pagevec_lru_move_fn(). This
change is a partial revert of the commit fc574c23558c ("mm/swap.c:
serialize memcg changes in pagevec_lru_move_fn").

And pagevec_lru_move_fn() is more hot compare with
mem_cgroup_move_account(), removing an atomic operation would be
an optimization. Also this change would not dirty cacheline for a
page which isn't on the LRU.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 34 ++++++++++++++++++++++++++++++++++
 mm/swap.c       | 45 ++++++++++++++-------------------------------
 mm/vmscan.c     |  9 ++++-----
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4db3cb2aedc..3a0f3838f02d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1333,10 +1333,39 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
 	lruvec = folio_lruvec(folio);
 	spin_lock(&lruvec->lru_lock);
 
+	/*
+	 * The memcg of the page can be changed by any the following routines:
+	 *
+	 * 1) mem_cgroup_move_account() or
+	 * 2) memcg_reparent_objcgs()
+	 *
+	 * The possible bad scenario would like:
+	 *
+	 * CPU0:                CPU1:                CPU2:
+	 * lruvec = folio_lruvec()
+	 *
+	 *                      if (!isolate_lru_page())
+	 *                              mem_cgroup_move_account()
+	 *
+	 *                                           memcg_reparent_objcgs()
+	 *
+	 * spin_lock(&lruvec->lru_lock)
+	 *                ^^^^^^
+	 *              wrong lock
+	 *
+	 * Either CPU1 or CPU2 can change page memcg, so we need to check
+	 * whether page memcg is changed, if so, we should reacquire the
+	 * new lruvec lock.
+	 */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock(&lruvec->lru_lock);
 		goto retry;
 	}
+
+	/*
+	 * When we reach here, it means that the folio_memcg(folio) is
+	 * stable.
+	 */
 	rcu_read_unlock();
 
 	return lruvec;
@@ -1364,6 +1393,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	lruvec = folio_lruvec(folio);
 	spin_lock_irq(&lruvec->lru_lock);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irq(&lruvec->lru_lock);
 		goto retry;
@@ -1397,6 +1427,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 	lruvec = folio_lruvec(folio);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
 		goto retry;
@@ -5738,7 +5769,10 @@ static int mem_cgroup_move_account(struct page *page,
 	obj_cgroup_put(rcu_dereference(from->objcg));
 	rcu_read_unlock();
 
+	/* See the comments in folio_lruvec_lock(). */
+	spin_lock(&from_vec->lru_lock);
 	folio->memcg_data = (unsigned long)rcu_access_pointer(to->objcg);
+	spin_unlock(&from_vec->lru_lock);
 
 	__folio_memcg_unlock(from);
 
diff --git a/mm/swap.c b/mm/swap.c
index 6cea469b6ff2..1b893c157bd1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -199,14 +199,8 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 		struct page *page = pvec->pages[i];
 		struct folio *folio = page_folio(page);
 
-		/* block memcg migration during page moving between lru */
-		if (!TestClearPageLRU(page))
-			continue;
-
 		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
 		(*move_fn)(page, lruvec);
-
-		SetPageLRU(page);
 	}
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
@@ -218,7 +212,7 @@ static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
 	struct folio *folio = page_folio(page);
 
-	if (!folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_unevictable(folio)) {
 		lruvec_del_folio(lruvec, folio);
 		folio_clear_active(folio);
 		lruvec_add_folio_tail(lruvec, folio);
@@ -314,7 +308,8 @@ void lru_note_cost_folio(struct folio *folio)
 
 static void __folio_activate(struct folio *folio, struct lruvec *lruvec)
 {
-	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
@@ -371,12 +366,9 @@ static void folio_activate(struct folio *folio)
 {
 	struct lruvec *lruvec;
 
-	if (folio_test_clear_lru(folio)) {
-		lruvec = folio_lruvec_lock_irq(folio);
-		__folio_activate(folio, lruvec);
-		lruvec_unlock_irq(lruvec);
-		folio_set_lru(folio);
-	}
+	lruvec = folio_lruvec_lock_irq(folio);
+	__folio_activate(folio, lruvec);
+	lruvec_unlock_irq(lruvec);
 }
 #endif
 
@@ -519,6 +511,9 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
 	bool active = PageActive(page);
 	int nr_pages = thp_nr_pages(page);
 
+	if (!PageLRU(page))
+		return;
+
 	if (PageUnevictable(page))
 		return;
 
@@ -556,7 +551,7 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageActive(page) && !PageUnevictable(page)) {
+	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec);
@@ -572,7 +567,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 
 static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageAnon(page) && PageSwapBacked(page) &&
+	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		int nr_pages = thp_nr_pages(page);
 
@@ -1007,8 +1002,9 @@ void __pagevec_release(struct pagevec *pvec)
 }
 EXPORT_SYMBOL(__pagevec_release);
 
-static void __pagevec_lru_add_fn(struct folio *folio, struct lruvec *lruvec)
+static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
 {
+	struct folio *folio = page_folio(page);
 	int was_unevictable = folio_test_clear_unevictable(folio);
 	long nr_pages = folio_nr_pages(folio);
 
@@ -1054,20 +1050,7 @@ static void __pagevec_lru_add_fn(struct folio *folio, struct lruvec *lruvec)
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	int i;
-	struct lruvec *lruvec = NULL;
-	unsigned long flags = 0;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct folio *folio = page_folio(pvec->pages[i]);
-
-		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
-		__pagevec_lru_add_fn(folio, lruvec);
-	}
-	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
-	release_pages(pvec->pages, pvec->nr);
-	pagevec_reinit(pvec);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
 }
 
 /**
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 51853d6df7b4..c591d071a598 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4789,18 +4789,17 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 		nr_pages = thp_nr_pages(page);
 		pgscanned += nr_pages;
 
-		/* block memcg migration during page moving between lru */
-		if (!TestClearPageLRU(page))
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
+
+		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
 
-		lruvec = folio_lruvec_relock_irq(folio, lruvec);
-		if (page_evictable(page) && PageUnevictable(page)) {
+		if (page_evictable(page)) {
 			del_page_from_lru_list(page, lruvec);
 			ClearPageUnevictable(page);
 			add_page_to_lru_list(page, lruvec);
 			pgrescued += nr_pages;
 		}
-		SetPageLRU(page);
 	}
 
 	if (lruvec) {
-- 
2.11.0

