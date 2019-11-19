From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v4 1/9] mm/swap: fix uninitialized compiler warning
Date: Tue, 19 Nov 2019 20:23:15 +0800
Message-ID: <1574166203-151975-2-git-send-email-alex.shi@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>

  ../mm/swap.c: In function ‘__page_cache_release’:
  ../mm/swap.c:67:10: warning: ‘flags’ may be used uninitialized in this
  function [-Wmaybe-uninitialized]
       lruvec = lock_page_lruvec_irqsave(page, pgdat, flags);
       ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5341ae93861f..c36a10244d07 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -62,7 +62,7 @@ static void __page_cache_release(struct page *page)
 	if (PageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
-		unsigned long flags;
+		unsigned long flags = 0;
 
 		spin_lock_irqsave(&pgdat->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-- 
1.8.3.1

