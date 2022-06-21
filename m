From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v6 11/11] mm: lru: use lruvec lock to serialize memcg changes
Date: Tue, 21 Jun 2022 20:56:58 +0800
Message-ID: <20220621125658.64935-12-songmuchun@bytedance.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FXYyMqCuMn8N8AtiePCadIk2ihaRxjS8+sCa4dkDZyY=;
        b=ID4gt1H5XAXZc2WTCkcM4F1wzX1sAe3JOWtacCk0iQKQ+aLMZXAoV2LeDm9V/qhVXx
         6tpAVEejJhQBmJjVUK+nIaNyniVWz7hJGtPgx1OZl1uOfj2pujAFTcbGChoVU9DBG1kQ
         iSr/YRd45uGdFIuCRF+nZy0GIGBavXDFzjNLsbIp/9bZz+yRlZan+nvKfKhVHEPvjiD5
         P/VKwyJbbrvB0eRUS26CEwFTb/hg3CWoix8AAXQYFzZU3v7OZBDBODtMEhL6UOydPlDK
         QPnx0hfY8bRXub0eY6AxeQXF/rpFM66dPqaBxFcGtr4OkljZGqrs6ATOyrSkIf9U3exr
         0w8A==
In-Reply-To: <20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

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
 mm/swap.c       | 32 +++++++++++++++-----------------
 mm/vmscan.c     | 16 +++++++---------
 3 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 803dbdf5f233..85adc43c5a25 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1330,10 +1330,39 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
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
@@ -1361,6 +1390,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	lruvec = folio_lruvec(folio);
 	spin_lock_irq(&lruvec->lru_lock);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irq(&lruvec->lru_lock);
 		goto retry;
@@ -1394,6 +1424,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
 	lruvec = folio_lruvec(folio);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
+	/* See the comments in folio_lruvec_lock(). */
 	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
 		spin_unlock_irqrestore(&lruvec->lru_lock, *flags);
 		goto retry;
@@ -5809,7 +5840,10 @@ static int mem_cgroup_move_account(struct page *page,
 	obj_cgroup_put(rcu_dereference(from->objcg));
 	rcu_read_unlock();
 
+	/* See the comments in folio_lruvec_lock(). */
+	spin_lock(&from_vec->lru_lock);
 	folio->memcg_data = (unsigned long)rcu_access_pointer(to->objcg);
+	spin_unlock(&from_vec->lru_lock);
 
 	__folio_memcg_unlock(from);
 
diff --git a/mm/swap.c b/mm/swap.c
index 987dcbd93ffa..0fc59409e27d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -196,6 +196,7 @@ static void lru_add_fn(struct lruvec *lruvec, struct folio *folio)
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
+	folio_set_lru(folio);
 	/*
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests the mlocked flag, to rule out the possibility
@@ -238,14 +239,8 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
-			continue;
-
 		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
 		move_fn(lruvec, folio);
-
-		folio_set_lru(folio);
 	}
 
 	if (lruvec)
@@ -265,7 +260,7 @@ static void folio_batch_add_and_move(struct folio_batch *fbatch,
 
 static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_unevictable(folio)) {
 		lruvec_del_folio(lruvec, folio);
 		folio_clear_active(folio);
 		lruvec_add_folio_tail(lruvec, folio);
@@ -348,7 +343,8 @@ void lru_note_cost_folio(struct folio *folio)
 
 static void folio_activate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && !folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
@@ -394,12 +390,9 @@ static void folio_activate(struct folio *folio)
 {
 	struct lruvec *lruvec;
 
-	if (folio_test_clear_lru(folio)) {
-		lruvec = folio_lruvec_lock_irq(folio);
-		folio_activate_fn(lruvec, folio);
-		lruvec_unlock_irq(lruvec);
-		folio_set_lru(folio);
-	}
+	lruvec = folio_lruvec_lock_irq(folio);
+	folio_activate_fn(lruvec, folio);
+	lruvec_unlock_irq(lruvec);
 }
 #endif
 
@@ -542,6 +535,9 @@ static void lru_deactivate_file_fn(struct lruvec *lruvec, struct folio *folio)
 	bool active = folio_test_active(folio);
 	long nr_pages = folio_nr_pages(folio);
 
+	if (!folio_test_lru(folio))
+		return;
+
 	if (folio_test_unevictable(folio))
 		return;
 
@@ -580,7 +576,8 @@ static void lru_deactivate_file_fn(struct lruvec *lruvec, struct folio *folio)
 
 static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (folio_test_active(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && folio_test_active(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
@@ -596,8 +593,9 @@ static void lru_deactivate_fn(struct lruvec *lruvec, struct folio *folio)
 
 static void lru_lazyfree_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
+	if (folio_test_lru(folio) && folio_test_anon(folio) &&
+	    folio_test_swapbacked(folio) && !folio_test_swapcache(folio) &&
+	    !folio_test_unevictable(folio)) {
 		long nr_pages = folio_nr_pages(folio);
 
 		lruvec_del_folio(lruvec, folio);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 51b1607c81e4..11e1f6fc5898 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4864,21 +4864,19 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 		if (PageTransTail(page))
 			continue;
 
-		nr_pages = thp_nr_pages(page);
+		nr_pages = folio_nr_pages(folio);
 		pgscanned += nr_pages;
 
-		/* block memcg migration during page moving between lru */
-		if (!TestClearPageLRU(page))
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
+		if (!folio_test_lru(folio) || !folio_test_unevictable(folio))
 			continue;
 
-		lruvec = folio_lruvec_relock_irq(folio, lruvec);
-		if (page_evictable(page) && PageUnevictable(page)) {
-			del_page_from_lru_list(page, lruvec);
-			ClearPageUnevictable(page);
-			add_page_to_lru_list(page, lruvec);
+		if (folio_evictable(folio)) {
+			lruvec_del_folio(lruvec, folio);
+			folio_clear_unevictable(folio);
+			lruvec_add_folio(lruvec, folio);
 			pgrescued += nr_pages;
 		}
-		SetPageLRU(page);
 	}
 
 	if (lruvec) {
-- 
2.11.0

