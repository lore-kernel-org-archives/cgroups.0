From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v16 17/22] mm/swap: serialize memcg changes during pagevec_lru_move_fn
Date: Sat, 11 Jul 2020 08:58:51 +0800
Message-ID: <1594429136-20002-18-git-send-email-alex.shi@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name

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

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
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

