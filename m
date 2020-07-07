From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v15 15/21] mm/swap: serialize memcg changes during pagevec_lru_move_fn
Date: Tue,  7 Jul 2020 19:46:47 +0800
Message-ID: <1594122412-28057-16-git-send-email-alex.shi@linux.alibaba.com>
References: <1594122412-28057-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1594122412-28057-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hugh Dickins' found a memcg change bug on original version:
If we want to change the pgdat->lru_lock to memcg's lruvec lock, we have
to serialize mem_cgroup_move_account during pagevec_lru_move_fn. The
possible bad scenario would like:

	cpu 0					cpu 1
lruvec = mem_cgroup_page_lruvec()
					if (!isolate_lru_page())
						mem_cgroup_move_account

spin_lock_irqsave(&lruvec->lru_lock <== wrong lock.

So we need the ClearPageLRU to block isolate_lru_page(), then serialize
the memcg change here.

Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/swap.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5092fe9c8c47..8488b9b25730 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -221,8 +221,14 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 			spin_lock_irqsave(&pgdat->lru_lock, flags);
 		}
 
+		/* block memcg migration during page moving between lru */
+		if (!TestClearPageLRU(page))
+			continue;
+
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		(*move_fn)(page, lruvec);
+
+		SetPageLRU(page);
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
@@ -976,7 +982,29 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
  */
 void __pagevec_lru_add(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
+	int i;
+	struct pglist_data *pgdat = NULL;
+	struct lruvec *lruvec;
+	unsigned long flags = 0;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct pglist_data *pagepgdat = page_pgdat(page);
+
+		if (pagepgdat != pgdat) {
+			if (pgdat)
+				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			pgdat = pagepgdat;
+			spin_lock_irqsave(&pgdat->lru_lock, flags);
+		}
+
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		__pagevec_lru_add_fn(page, lruvec);
+	}
+	if (pgdat)
+		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	release_pages(pvec->pages, pvec->nr);
+	pagevec_reinit(pvec);
 }
 
 /**
-- 
1.8.3.1

