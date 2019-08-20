From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 05/14] lru/huge_page: use per lruvec lock in __split_huge_page
Date: Tue, 20 Aug 2019 17:48:28 +0800
Message-ID: <1566294517-86418-6-git-send-email-alex.shi@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, David Rientjes <rientjes@google.com>, Souptick Joarder <jrdr.linux@gmail.com>

Using lruvec lock to replace pgdat lru_lock.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3a483deee807..9a96c0944b4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2529,7 +2529,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_unlock(&head->mapping->i_pages);
 	}
 
-	spin_unlock_irqrestore(&pgdat->lruvec.lru_lock, flags);
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 
 	remap_page(head);
 
@@ -2671,6 +2671,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	struct lruvec *lruvec;
 	int count, mapcount, extra_pins, ret;
 	bool mlocked;
 	unsigned long flags;
@@ -2739,8 +2740,10 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	if (mlocked)
 		lru_add_drain();
 
+	lruvec = mem_cgroup_page_lruvec(head, pgdata);
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lruvec.lru_lock, flags);
+	spin_lock_irqsave(&lruvec->lru_lock, flags);
+	sync_lruvec_pgdat(lruvec, pgdata);
 
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
@@ -2785,7 +2788,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		spin_unlock(&pgdata->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lruvec.lru_lock, flags);
+		spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 		remap_page(head);
 		ret = -EBUSY;
 	}
-- 
1.8.3.1

