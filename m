From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v10 06/15] mm/thp: narrow lru locking
Date: Mon, 27 Apr 2020 15:02:55 +0800
Message-ID: <1587970985-21629-7-git-send-email-alex.shi@linux.alibaba.com>
References: <1587970985-21629-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1587970985-21629-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrea Arcangeli <aarcange@redhat.com>

lru_lock and page cache xa_lock have no reason with current sequence,
put them together isn't necessary. let's narrow the lru locking, but
left the local_irq_disable/preempt_disable to block interrupt
re-entry and statistic update.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd28d68ad3a8..d6952a86acdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2607,8 +2607,6 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	unsigned long offset = 0;
 	int i;
 
-	lruvec = mem_cgroup_page_lruvec(head, pgdat);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -2620,6 +2618,11 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	/* lock lru list/PageCompound, isolate freezed by page_ref_freeze */
+	spin_lock(&pgdat->lru_lock);
+
+	lruvec = mem_cgroup_page_lruvec(head, pgdat);
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2637,8 +2640,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 					head + i, 0);
 		}
 	}
-
 	ClearPageCompound(head);
+	spin_unlock(&pgdat->lru_lock);
 
 	split_page_owner(head, HPAGE_PMD_ORDER);
 
@@ -2656,8 +2659,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
-
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	preempt_enable();
+	local_irq_restore(flags);
 
 	remap_page(head);
 
@@ -2796,7 +2799,6 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
-	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2868,9 +2870,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	if (mlocked)
 		lru_add_drain();
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
+	local_irq_save(flags);
+	preempt_disable();
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
@@ -2919,7 +2920,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
+		preempt_enable();
+		local_irq_restore(flags);
 		remap_page(head);
 		ret = -EBUSY;
 	}
-- 
1.8.3.1

