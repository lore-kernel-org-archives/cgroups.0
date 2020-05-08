From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] mm: swap: fix vmstats for huge pages
Date: Fri,  8 May 2020 14:22:13 -0700
Message-ID: <20200508212215.181307-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H7ED1E6iU6GJrL2T+LX5Bj/uEQY3JnE8s7k3T/+egkg=;
        b=XY5On+GozPMjP6G7zkPxPhW0eE2rp4+jjdvdyV+TE6avG+bX2A6pptdCo2RW+Rn3no
         KQU1jyKtWYfy9dkYUy4EImZ9+uEOAdDNPH0YwlyphH5/olIWRcFiT8PHrG0uYO6VgAgO
         E/dVasAEh4SuLPL7R9m2RQCh6iAMAIo8SZvlMpxpYiJTLphr4eSjp2MuwGrDq5yyaNzx
         4N+w8pQqM2elRyzuI36Dqha8UAGJbBpiCNZBetFNyysG+bhxK79vAv6P6/dmFhDWQ0cZ
         53BuMgiu5tPKdTehsHF+yErNAw9OFP+cGYZN4uCLlChZJodaZgBljzVYxcpHxpU3zoun
         Gm9A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Many of the callbacks called by pagevec_lru_move_fn() do not correctly
update the vmstats for huge pages. Fix that. Also __pagevec_lru_add_fn()
use the irq-unsafe alternative to update the stat as the irqs are
already disabled.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/swap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index a37bd7b202ac..3dbef6517cac 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -225,7 +225,7 @@ static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec,
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved)++;
+		(*pgmoved) += hpage_nr_pages(page);
 	}
 }
 
@@ -285,7 +285,7 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_event(PGACTIVATE);
+		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
 		update_page_reclaim_stat(lruvec, file, 1);
 	}
 }
@@ -503,6 +503,7 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 {
 	int lru, file;
 	bool active;
+	int nr_pages = hpage_nr_pages(page);
 
 	if (!PageLRU(page))
 		return;
@@ -536,11 +537,11 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 		 * We moves tha page into tail of inactive.
 		 */
 		add_page_to_lru_list_tail(page, lruvec, lru);
-		__count_vm_event(PGROTATED);
+		__count_vm_events(PGROTATED, nr_pages);
 	}
 
 	if (active)
-		__count_vm_event(PGDEACTIVATE);
+		__count_vm_events(PGDEACTIVATE, nr_pages);
 	update_page_reclaim_stat(lruvec, file, 0);
 }
 
@@ -929,6 +930,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
+	int nr_pages = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -966,13 +968,13 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
 					 PageActive(page));
 		if (was_unevictable)
-			count_vm_event(UNEVICTABLE_PGRESCUED);
+			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	} else {
 		lru = LRU_UNEVICTABLE;
 		ClearPageActive(page);
 		SetPageUnevictable(page);
 		if (!was_unevictable)
-			count_vm_event(UNEVICTABLE_PGCULLED);
+			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
 
 	add_page_to_lru_list(page, lruvec, lru);
-- 
2.26.2.645.ge9eca65c58-goog

