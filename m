From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v9 15/20] mm/mlock: optimize munlock_pagevec by relocking
Date: Mon,  2 Mar 2020 19:00:25 +0800
Message-ID: <1583146830-169516-16-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

During the pagevec locking, a new page's lruvec is may same as
previous one. Thus we could save a re-locking, and only
change lock iff lruvec is newer.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 mm/mlock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index d285348b147e..236a29b791f4 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -281,6 +281,7 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 	int nr = pagevec_count(pvec);
 	int delta_munlocked = -nr;
 	struct pagevec pvec_putback;
+	struct lruvec *lruvec = NULL;
 	int pgrescued = 0;
 
 	pagevec_init(&pvec_putback);
@@ -288,7 +289,6 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 	/* Phase 1: page isolation */
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
-		struct lruvec *lruvec;
 
 		if (!TestClearPageMlocked(page)) {
 			delta_munlocked++;
@@ -305,9 +305,8 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 		 * We already have pin from follow_page_mask()
 		 * so we can spare the get_page() here.
 		 */
-		lruvec = lock_page_lruvec_irq(page);
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
-		unlock_page_lruvec_irq(lruvec);
 		continue;
 
 		/*
@@ -320,6 +319,8 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
 	}
+	if (lruvec)
+		unlock_page_lruvec_irq(lruvec);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 
 	/* Now we can release pins of pages that we are not munlocking */
-- 
1.8.3.1

