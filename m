From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 2/3] mm/memcg: remove rcu locking for lock_page_lruvec function series
Date: Thu, 17 Dec 2020 14:28:51 +0800
Message-ID: <1608186532-81218-2-git-send-email-alex.shi@linux.alibaba.com>
References: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

The rcu_read_lock was used to block memcg destory, but with the detailed
calling conditions, the memcg won't gone since the page is hold. So we
don't need it now, let's remove them to save locking load in debugging.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e6b50d068b2f..98bbee1d2faf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1356,10 +1356,8 @@ struct lruvec *lock_page_lruvec(struct page *page)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1371,10 +1369,8 @@ struct lruvec *lock_page_lruvec_irq(struct page *page)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irq(&lruvec->lru_lock);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
@@ -1386,10 +1382,8 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
 	struct lruvec *lruvec;
 	struct pglist_data *pgdat = page_pgdat(page);
 
-	rcu_read_lock();
 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
-	rcu_read_unlock();
 
 	lruvec_memcg_debug(lruvec, page);
 
-- 
2.29.GIT

