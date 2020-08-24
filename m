From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v18 27/32] mm/swap.c: optimizing __pagevec_lru_add lru_lock
Date: Mon, 24 Aug 2020 20:55:00 +0800
Message-ID: <1598273705-69124-28-git-send-email-alex.shi@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1598273705-69124-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

The current relock logical will change lru_lock when if found a new
lruvec, so if 2 memcgs are reading file or alloc page equally, they
could hold the lru_lock alternately.

This patch will record the needed lru_lock and only hold them once in
above scenario. That could reduce the lock contention.

Suggested-by: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/swap.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 2ac78e8fab71..fe53449fa1b8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -958,24 +958,53 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
 	trace_mm_lru_insertion(page, lru);
 }
 
+struct add_lruvecs {
+	struct list_head lists[PAGEVEC_SIZE];
+	struct lruvec *vecs[PAGEVEC_SIZE];
+};
+
 /*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	int i;
+	int i, j, total;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	struct page *page;
+	struct add_lruvecs lruvecs;
+
+	lruvecs.vecs[0] = NULL;
+	for (i = total = 0; i < pagevec_count(pvec); i++) {
+		page = pvec->pages[i];
+		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+
+		/* Try to find a same lruvec */
+		for (j = 0; j <= total; j++)
+			if (lruvec == lruvecs.vecs[j])
+				break;
+		/* A new lruvec */
+		if (j > total) {
+			INIT_LIST_HEAD(&lruvecs.lists[total]);
+			lruvecs.vecs[total] = lruvec;
+			j = total++;
+			lruvecs.vecs[total] = 0;
+		}
 
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
+		list_add(&page->lru, &lruvecs.lists[j]);
+	}
 
-		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
-		__pagevec_lru_add_fn(page, lruvec);
+	for (i = 0; i < total; i++) {
+		spin_lock_irqsave(&lruvecs.vecs[i]->lru_lock, flags);
+		while (!list_empty(&lruvecs.lists[i])) {
+			page = lru_to_page(&lruvecs.lists[i]);
+			list_del(&page->lru);
+			__pagevec_lru_add_fn(page, lruvecs.vecs[i]);
+		}
+		spin_unlock_irqrestore(&lruvecs.vecs[i]->lru_lock, flags);
 	}
-	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
-- 
1.8.3.1

