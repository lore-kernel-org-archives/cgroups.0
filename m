From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [Patch v4] mm: thp: remove the defer list related code since this will not happen
Date: Sat, 18 Jan 2020 07:38:36 +0800
Message-ID: <20200117233836.3434-1-richardw.yang@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, rientjes@google.com, Wei Yang <richardw.yang@linux.intel.com>, stable@vger.kernel.org

If compound is true, this means it is a PMD mapped THP. Which implies
the page is not linked to any defer list. So the first code chunk will
not be executed.

Also with this reason, it would not be proper to add this page to a
defer list. So the second code chunk is not correct.

Based on this, we should remove the defer list related code.

Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>    [5.4+]

---
v4:
  * finally we identified the related code is not necessary and not
    correct, just remove it
  * thanks to Kirill T first spot some problem
v3:
  * remove all review/ack tag since rewrite the changelog
  * use deferred_split_huge_page as the example of race
  * add cc stable 5.4+ tag as suggested by David Rientjes

v2:
  * move check on compound outside suggested by Alexander
  * an example of the race condition, suggested by Michal
---
 mm/memcontrol.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c83cf4ed970..27c231bf4565 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struct page *page,
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
-	}
-#endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
@@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struct page *page,
 	/* caller should have done css_get */
 	page->mem_cgroup = to;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
-	}
-#endif
-
 	spin_unlock_irqrestore(&from->move_lock, flags);
 
 	ret = 0;
-- 
2.17.1

