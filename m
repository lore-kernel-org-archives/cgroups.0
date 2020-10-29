From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v20 10/20] mm/swap.c: fold vm event PGROTATED into pagevec_move_tail_fn
Date: Thu, 29 Oct 2020 18:44:55 +0800
Message-ID: <1603968305-8026-11-git-send-email-alex.shi@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1603968305-8026-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Fold the PGROTATED event collection into pagevec_move_tail_fn call back
func like other funcs does in pagevec_lru_move_fn. Thus we could save
func call pagevec_move_tail().
Now all usage of pagevec_lru_move_fn are same and no needs of its 3rd
parameter.

It's just simply the calling. No functional change.

[lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org: found a build issue in the original patch, thanks]
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/swap.c | 65 ++++++++++++++++++++++-----------------------------------------
 1 file changed, 23 insertions(+), 42 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 05bc9ff6d8c0..31fc3ebc1079 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -204,8 +204,7 @@ int get_kernel_page(unsigned long start, int write, struct page **pages)
 EXPORT_SYMBOL_GPL(get_kernel_page);
 
 static void pagevec_lru_move_fn(struct pagevec *pvec,
-	void (*move_fn)(struct page *page, struct lruvec *lruvec, void *arg),
-	void *arg)
+	void (*move_fn)(struct page *page, struct lruvec *lruvec))
 {
 	int i;
 	struct pglist_data *pgdat = NULL;
@@ -224,7 +223,7 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		(*move_fn)(page, lruvec, arg);
+		(*move_fn)(page, lruvec);
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
@@ -232,35 +231,22 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	pagevec_reinit(pvec);
 }
 
-static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec,
-				 void *arg)
+static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
-	int *pgmoved = arg;
-
 	if (PageLRU(page) && !PageUnevictable(page)) {
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved) += thp_nr_pages(page);
+		__count_vm_events(PGROTATED, thp_nr_pages(page));
 	}
 }
 
 /*
- * pagevec_move_tail() must be called with IRQ disabled.
- * Otherwise this may cause nasty races.
- */
-static void pagevec_move_tail(struct pagevec *pvec)
-{
-	int pgmoved = 0;
-
-	pagevec_lru_move_fn(pvec, pagevec_move_tail_fn, &pgmoved);
-	__count_vm_events(PGROTATED, pgmoved);
-}
-
-/*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
  * inactive list.
+ *
+ * rotate_reclaimable_page() must disable IRQs, to prevent nasty races.
  */
 void rotate_reclaimable_page(struct page *page)
 {
@@ -273,7 +259,7 @@ void rotate_reclaimable_page(struct page *page)
 		local_lock_irqsave(&lru_rotate.lock, flags);
 		pvec = this_cpu_ptr(&lru_rotate.pvec);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_move_tail(pvec);
+			pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 }
@@ -315,8 +301,7 @@ void lru_note_cost_page(struct page *page)
 		      page_is_file_lru(page), thp_nr_pages(page));
 }
 
-static void __activate_page(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
@@ -340,7 +325,7 @@ static void activate_page_drain(int cpu)
 	struct pagevec *pvec = &per_cpu(lru_pvecs.activate_page, cpu);
 
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, __activate_page, NULL);
+		pagevec_lru_move_fn(pvec, __activate_page);
 }
 
 static bool need_activate_page_drain(int cpu)
@@ -358,7 +343,7 @@ static void activate_page(struct page *page)
 		pvec = this_cpu_ptr(&lru_pvecs.activate_page);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, __activate_page, NULL);
+			pagevec_lru_move_fn(pvec, __activate_page);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -374,7 +359,7 @@ static void activate_page(struct page *page)
 
 	page = compound_head(page);
 	spin_lock_irq(&pgdat->lru_lock);
-	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat), NULL);
+	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
 	spin_unlock_irq(&pgdat->lru_lock);
 }
 #endif
@@ -525,8 +510,7 @@ void lru_cache_add_inactive_or_unevictable(struct page *page,
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
-			      void *arg)
+static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
 {
 	int lru;
 	bool active;
@@ -573,8 +557,7 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 	}
 }
 
-static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
@@ -591,8 +574,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 	}
 }
 
-static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
-			    void *arg)
+static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
@@ -636,21 +618,21 @@ void lru_add_drain_cpu(int cpu)
 
 		/* No harm done if a racing interrupt already did this */
 		local_lock_irqsave(&lru_rotate.lock, flags);
-		pagevec_move_tail(pvec);
+		pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 
 	pvec = &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
 
 	pvec = &per_cpu(lru_pvecs.lru_deactivate, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_deactivate_fn);
 
 	pvec = &per_cpu(lru_pvecs.lru_lazyfree, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 
 	activate_page_drain(cpu);
 }
@@ -679,7 +661,7 @@ void deactivate_file_page(struct page *page)
 		pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
 
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -701,7 +683,7 @@ void deactivate_page(struct page *page)
 		pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_deactivate_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -723,7 +705,7 @@ void mark_page_lazyfree(struct page *page)
 		pvec = this_cpu_ptr(&lru_pvecs.lru_lazyfree);
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
+			pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 		local_unlock(&lru_pvecs.lock);
 	}
 }
@@ -974,8 +956,7 @@ void __pagevec_release(struct pagevec *pvec)
 }
 EXPORT_SYMBOL(__pagevec_release);
 
-static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
-				 void *arg)
+static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
@@ -1034,7 +1015,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
 }
 
 /**
-- 
1.8.3.1

