From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v6 05/11] mm: vmscan: rework move_pages_to_lru()
Date: Tue, 21 Jun 2022 20:56:52 +0800
Message-ID: <20220621125658.64935-6-songmuchun@bytedance.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JQmNu1Pi61kiVMPJr8aGyJU8VoXoYJEPNAmwcIY/MLE=;
        b=uRoZYgA2WDdO9ticBdRw4R7/aUXk5r9fqjKxKJCs1SkEG4UdxhjFsO/X/PheSrZDg+
         Q23F5hcZd9t0a7k63chGSWb3GHjtfCKitwmgpkZIMzFXmeCoTtJZt1WI45hmjAbSNvjU
         /5wRPFqGLSXBhc/RogtGwjV9RN90CBGRxKIoHDUJysh3Wr6Y4yJWuUtBVejjCQihuCj0
         CtlKQVvYF4ukD9CjCMcdRjlepscIFcl4DKR7BS4rzRSK7Mf6uRzcc1U6qlPUu8rUerNI
         JY12moVGemqnvgCfDy9ZpJmjCyPFcuQ5O6SQvqUei19rSVIpmLCFjVox8NrK4WND0BYX
         Cqsg==
In-Reply-To: <20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

In the later patch, we will reparent the LRU pages. The pages moved to
appropriate LRU list can be reparented during the process of the
move_pages_to_lru(). So holding a lruvec lock by the caller is wrong, we
should use the more general interface of folio_lruvec_relock_irq() to
acquire the correct lruvec lock.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 mm/vmscan.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a554712ef5d..697656151431 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2312,23 +2312,26 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
  * move_pages_to_lru() moves folios from private @list to appropriate LRU list.
  * On return, @list is reused as a list of folios to be freed by the caller.
  *
- * Returns the number of pages moved to the given lruvec.
+ * Returns the number of pages moved to the appropriate LRU list.
+ *
+ * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_pages_to_lru(struct lruvec *lruvec,
-				      struct list_head *list)
+static unsigned int move_pages_to_lru(struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
+	struct lruvec *lruvec = NULL;
 	LIST_HEAD(folios_to_free);
 
 	while (!list_empty(list)) {
 		struct folio *folio = lru_to_folio(list);
 
+		lruvec = folio_lruvec_relock_irq(folio, lruvec);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 		list_del(&folio->lru);
 		if (unlikely(!folio_evictable(folio))) {
-			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec_unlock_irq(lruvec);
 			folio_putback_lru(folio);
-			spin_lock_irq(&lruvec->lru_lock);
+			lruvec = NULL;
 			continue;
 		}
 
@@ -2349,19 +2352,15 @@ static unsigned int move_pages_to_lru(struct lruvec *lruvec,
 			__folio_clear_lru_flags(folio);
 
 			if (unlikely(folio_test_large(folio))) {
-				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec_unlock_irq(lruvec);
 				destroy_large_folio(folio);
-				spin_lock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
 			} else
 				list_add(&folio->lru, &folios_to_free);
 
 			continue;
 		}
 
-		/*
-		 * All pages were isolated from the same lruvec (and isolation
-		 * inhibits memcg migration).
-		 */
 		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
@@ -2370,6 +2369,8 @@ static unsigned int move_pages_to_lru(struct lruvec *lruvec,
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
+	if (lruvec)
+		lruvec_unlock_irq(lruvec);
 	/*
 	 * To save our caller's stack, now use input list for pages to free.
 	 */
@@ -2440,16 +2441,16 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, &stat, false);
 
-	spin_lock_irq(&lruvec->lru_lock);
-	move_pages_to_lru(lruvec, &page_list);
+	move_pages_to_lru(&page_list);
 
+	local_irq_disable();
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-	spin_unlock_irq(&lruvec->lru_lock);
+	local_irq_enable();
 
 	lru_note_cost(lruvec, file, stat.nr_pageout);
 	mem_cgroup_uncharge_list(&page_list);
@@ -2578,18 +2579,16 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	spin_lock_irq(&lruvec->lru_lock);
-
-	nr_activate = move_pages_to_lru(lruvec, &l_active);
-	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
+	nr_activate = move_pages_to_lru(&l_active);
+	nr_deactivate = move_pages_to_lru(&l_inactive);
 	/* Keep all free folios in l_active list */
 	list_splice(&l_inactive, &l_active);
 
+	local_irq_disable();
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
-
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	spin_unlock_irq(&lruvec->lru_lock);
+	local_irq_enable();
 
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
-- 
2.11.0

