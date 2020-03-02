From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v9 07/20] mm/lru: introduce TestClearPageLRU
Date: Mon,  2 Mar 2020 19:00:17 +0800
Message-ID: <1583146830-169516-8-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Combined PageLRU check and ClearPageLRU into one function by new
introduced func TestClearPageLRU. This function will be used as page
isolation precondition.

No functional change yet.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/page-flags.h |  1 +
 mm/memcontrol.c            |  4 ++--
 mm/mlock.c                 |  3 +--
 mm/swap.c                  |  8 ++------
 mm/vmscan.c                | 19 +++++++++----------
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1bf83c8fcaa7..5cb155f3191e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -318,6 +318,7 @@ static inline void page_init_poison(struct page *page, size_t size)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
+	TESTCLEARFLAG(LRU, lru, PF_HEAD)
 PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
 	TESTCLEARFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 875e2aebcde7..f8419f3436a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2588,9 +2588,8 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 		pgdat = page_pgdat(page);
 		spin_lock_irq(&pgdat->lru_lock);
 
-		if (PageLRU(page)) {
+		if (TestClearPageLRU(page)) {
 			lruvec = mem_cgroup_page_lruvec(page, pgdat);
-			ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_lru(page));
 		} else
 			spin_unlock_irq(&pgdat->lru_lock);
@@ -2613,6 +2612,7 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 
 	if (lrucare && lruvec) {
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		SetPageLRU(page);
 		add_page_to_lru_list(page, lruvec, page_lru(page));
diff --git a/mm/mlock.c b/mm/mlock.c
index a72c1eeded77..03b3a5d99ad7 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -108,13 +108,12 @@ void mlock_vma_page(struct page *page)
  */
 static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
 {
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		struct lruvec *lruvec;
 
 		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
 		if (getpage)
 			get_page(page);
-		ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		return true;
 	}
diff --git a/mm/swap.c b/mm/swap.c
index 1ac24fc35d6b..8e71bdd04a1a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -59,15 +59,13 @@
  */
 static void __page_cache_release(struct page *page)
 {
-	if (PageLRU(page)) {
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
 		unsigned long flags;
 
 		spin_lock_irqsave(&pgdat->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
-		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 	}
@@ -831,7 +829,7 @@ void release_pages(struct page **pages, int nr)
 			continue;
 		}
 
-		if (PageLRU(page)) {
+		if (TestClearPageLRU(page)) {
 			struct pglist_data *pgdat = page_pgdat(page);
 
 			if (pgdat != locked_pgdat) {
@@ -844,8 +842,6 @@ void release_pages(struct page **pages, int nr)
 			}
 
 			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
-			VM_BUG_ON_PAGE(!PageLRU(page), page);
-			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index dcdd33f65f43..8958454d50fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1751,21 +1751,20 @@ int isolate_lru_page(struct page *page)
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
 
-	if (PageLRU(page)) {
+	get_page(page);
+	if (TestClearPageLRU(page)) {
 		pg_data_t *pgdat = page_pgdat(page);
 		struct lruvec *lruvec;
+		int lru = page_lru(page);
 
-		spin_lock_irq(&pgdat->lru_lock);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		if (PageLRU(page)) {
-			int lru = page_lru(page);
-			get_page(page);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, lru);
-			ret = 0;
-		}
+		spin_lock_irq(&pgdat->lru_lock);
+		del_page_from_lru_list(page, lruvec, lru);
 		spin_unlock_irq(&pgdat->lru_lock);
-	}
+		ret = 0;
+	} else
+		put_page(page);
+
 	return ret;
 }
 
-- 
1.8.3.1

