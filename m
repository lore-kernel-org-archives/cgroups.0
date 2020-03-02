From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v9 14/20] mm/lru: introduce the relock_page_lruvec function
Date: Mon,  2 Mar 2020 19:00:24 +0800
Message-ID: <1583146830-169516-15-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

During the lruvec locking, a new page's lruvec is may same as
previous one. Thus we could save a re-locking, and only
change lock iff lruvec is new.

Function named relock_page_lruvec following Hugh Dickins' patch.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/memcontrol.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |  8 ++------
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b8a04f0a2ab8..f60009580d2a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1307,6 +1307,42 @@ static inline void dec_lruvec_page_state(struct page *page,
 	mod_lruvec_page_state(page, idx, -1);
 }
 
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
+		struct lruvec *locked_lruvec)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (likely(locked_lruvec == lruvec))
+		return lruvec;
+
+	if (unlikely(locked_lruvec))
+		unlock_page_lruvec_irq(locked_lruvec);
+
+	return lock_page_lruvec_irq(page);
+}
+
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
+		struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (likely(locked_lruvec == lruvec))
+		return lruvec;
+
+	if (unlikely(locked_lruvec))
+		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+
+	return lock_page_lruvec_irqsave(page, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a58cd5ee9ea1..de925bd629eb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4325,14 +4325,10 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 
 	for (i = 0; i < pvec->nr; i++) {
 		struct page *page = pvec->pages[i];
-		struct lruvec *new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
 
 		pgscanned++;
-		if (lruvec != new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irq(lruvec);
-			lruvec = lock_page_lruvec_irq(page);
-		}
+
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 
 		if (!TestClearPageLRU(page) || !PageUnevictable(page))
 			continue;
-- 
1.8.3.1

