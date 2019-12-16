From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v6 09/10] mm/memcg: fold lock in lock_page_lru
Date: Mon, 16 Dec 2019 17:26:25 +0800
Message-ID: <1576488386-32544-10-git-send-email-alex.shi@linux.alibaba.com>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

According to the calling path of commit_charge, the lrucare is bound
with PageLRU, so we could just fold it under PageLRU. This has no
functional change.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 138f298b694f..f8e279487e1d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2621,9 +2621,10 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 static struct lruvec *lock_page_lru(struct page *page, int *isolated)
 {
-	struct lruvec *lruvec = lock_page_lruvec_irq(page);
+	struct lruvec *lruvec = NULL;
 
 	if (PageLRU(page)) {
+		lruvec = lock_page_lruvec_irq(page);
 
 		ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
@@ -2637,17 +2638,18 @@ static struct lruvec *lock_page_lru(struct page *page, int *isolated)
 static void unlock_page_lru(struct page *page, int isolated,
 				struct lruvec *locked_lruvec)
 {
-	struct lruvec *lruvec;
+	if (isolated) {
+		struct lruvec *lruvec;
 
-	unlock_page_lruvec_irq(locked_lruvec);
-	lruvec = lock_page_lruvec_irq(page);
+		if (locked_lruvec)
+			unlock_page_lruvec_irq(locked_lruvec);
+		lruvec = lock_page_lruvec_irq(page);
 
-	if (isolated) {
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		SetPageLRU(page);
 		add_page_to_lru_list(page, lruvec, page_lru(page));
+		unlock_page_lruvec_irq(lruvec);
 	}
-	unlock_page_lruvec_irq(lruvec);
 }
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
-- 
1.8.3.1

