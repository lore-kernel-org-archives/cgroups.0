From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v8 06/10] mm/swap: only change the lru_lock iff page's lruvec is different
Date: Thu, 16 Jan 2020 11:05:05 +0800
Message-ID: <1579143909-156105-7-git-send-email-alex.shi@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Yafang Shao <laoar.shao@gmail.com>

Since we introduced relock_page_lruvec, we could use it in more place
to reduce spin_locks.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/swap.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 97e108be4f92..84a845968e1d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -196,11 +196,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		lruvec = lock_page_lruvec_irqsave(page, &flags);
+		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
 
 		(*move_fn)(page, lruvec, arg);
-		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
@@ -819,14 +820,11 @@ void release_pages(struct page **pages, int nr)
 		}
 
 		if (PageLRU(page)) {
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
 
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
-- 
1.8.3.1

