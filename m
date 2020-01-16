From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v8 09/10] mm/lru: add debug checking for page memcg moving
Date: Thu, 16 Jan 2020 11:05:08 +0800
Message-ID: <1579143909-156105-10-git-send-email-alex.shi@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

This debug patch could give some clues if there are sth out of
consideration.

Hugh Dickins report a bug of this patch, Thanks!

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/memcontrol.h |  5 +++++
 mm/compaction.c            |  2 ++
 mm/memcontrol.c            | 15 +++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 09e861df48e8..ece88bb11d0f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -421,6 +421,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
 struct lruvec *lock_page_lruvec_irqsave(struct page *, unsigned long*);
 void unlock_page_lruvec_irq(struct lruvec *);
 void unlock_page_lruvec_irqrestore(struct lruvec *, unsigned long);
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page);
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
@@ -1183,6 +1184,10 @@ static inline void count_memcg_page_event(struct page *page,
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
+{
+}
 #endif /* CONFIG_MEMCG */
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
diff --git a/mm/compaction.c b/mm/compaction.c
index 8c0a2da217d8..151242817bf4 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -971,6 +971,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked_lruvec = lruvec;
 
+			lruvec_memcg_debug(lruvec, page);
+
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
 				skip_updated = true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 00fef8ddbd08..a567fd868739 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1238,6 +1238,19 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
 	return lruvec;
 }
 
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
+{
+#ifdef  CONFIG_DEBUG_VM
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!page->mem_cgroup)
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != root_mem_cgroup, page);
+	else
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != page->mem_cgroup, page);
+#endif
+}
+
 struct lruvec *lock_page_lruvec_irq(struct page *page)
 {
 	struct lruvec *lruvec;
@@ -1247,6 +1260,7 @@ struct lruvec *lock_page_lruvec_irq(struct page *page)
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	spin_lock_irq(&lruvec->lru_lock);
 
+	lruvec_memcg_debug(lruvec, page);
 	return lruvec;
 }
 
@@ -1259,6 +1273,7 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 	spin_lock_irqsave(&lruvec->lru_lock, *flags);
 
+	lruvec_memcg_debug(lruvec, page);
 	return lruvec;
 }
 
-- 
1.8.3.1


