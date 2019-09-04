From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH v1 6/7] mm/vmscan: allow changing page memory cgroup during
 reclaim
Date: Wed, 04 Sep 2019 16:53:20 +0300
Message-ID: <156760520035.6560.17483443614564028347.stgit@buzz>
References: <156760509382.6560.17364256340940314860.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1567605201; bh=93aHSjkq8usOa7Vvzbeiada0aVjHgSRCpmsa9gKiW1o=;
        h=In-Reply-To:Message-ID:References:Date:To:From:Subject:Cc;
        b=zzXt8J7rWoER/p7/CTRZyY4XofxSlIu8HZMnkuI26LqBHm9vtziabp5zDNkU+/nSK
         c/l/B6DrJA6UYOrifB6EdGmZDmJyTT+rS7G3KaxXLzZmYHhAaqT25Kfy50FMFKtzw8
         fbSc9u6sHHHBL9pFhN7EpNgbMXo4W4Y/SDtZW4X4=
In-Reply-To: <156760509382.6560.17364256340940314860.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

All LRU lists in one numa node are protected with one spin-lock and
right now move_pages_to_lru() re-evaluates lruvec for each page.
This allows to change page cgroup while page is isolated by reclaimer,
but nobody use that for now. This patch makes this feature clear and
passes into move_pages_to_lru pgdat rather than lruvec pointer.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 mm/vmscan.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a6c5d0b28321..bf7a05e8a717 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1873,15 +1873,15 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
  * The downside is that we have to touch page->_refcount against each page.
  * But we had to alter page->flags anyway.
  *
- * Returns the number of pages moved to the given lruvec.
+ * Returns the number of pages moved to LRU lists.
  */
 
-static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
+static unsigned noinline_for_stack move_pages_to_lru(struct pglist_data *pgdat,
 						     struct list_head *list)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
+	struct lruvec *lruvec;
 	struct page *page;
 	enum lru_list lru;
 
@@ -1895,6 +1895,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 			spin_lock_irq(&pgdat->lru_lock);
 			continue;
 		}
+
+		/* Re-evaluate lru: isolated page could be moved */
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		SetPageLRU(page);
@@ -2005,7 +2007,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	reclaim_stat->recent_rotated[0] += stat.nr_activate[0];
 	reclaim_stat->recent_rotated[1] += stat.nr_activate[1];
 
-	move_pages_to_lru(lruvec, &page_list);
+	move_pages_to_lru(pgdat, &page_list);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 
@@ -2128,8 +2130,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	nr_activate = move_pages_to_lru(lruvec, &l_active);
-	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
+	nr_activate = move_pages_to_lru(pgdat, &l_active);
+	nr_deactivate = move_pages_to_lru(pgdat, &l_inactive);
 	/* Keep all free pages in l_active list */
 	list_splice(&l_inactive, &l_active);
 

