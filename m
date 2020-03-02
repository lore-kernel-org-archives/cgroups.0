From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v9 16/20] mm/swap: only change the lru_lock iff page's lruvec is different
Date: Mon,  2 Mar 2020 19:00:26 +0800
Message-ID: <1583146830-169516-17-git-send-email-alex.shi@linux.alibaba.com>
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

Since we introduced relock_page_lruvec, we could use it in more place
to reduce spin_locks.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 mm/swap.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 50c856246f84..74e03589adde 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -197,13 +197,15 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 		if (isolation && !TestClearPageLRU(page))
 			continue;
 
-		lruvec = lock_page_lruvec_irqsave(page, &flags);
+		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
 		(*move_fn)(page, lruvec, arg);
-		unlock_page_lruvec_irqrestore(lruvec, flags);
 
 		if (isolation)
 			SetPageLRU(page);
 	}
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
+
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
@@ -821,14 +823,11 @@ void release_pages(struct page **pages, int nr)
 		}
 
 		if (TestClearPageLRU(page)) {
-			struct lruvec *new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+			struct lruvec *pre_lruvec = lruvec;
 
-			if (new_lruvec != lruvec) {
-				if (lruvec)
-					unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
+			if (pre_lruvec != lruvec)
 				lock_batch = 0;
-				lruvec = lock_page_lruvec_irqsave(page, &flags);
-			}
 
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
-- 
1.8.3.1

