From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 3/3] mm: swap: fix update_page_reclaim_stat for huge pages
Date: Fri,  8 May 2020 14:22:15 -0700
Message-ID: <20200508212215.181307-3-shakeelb@google.com>
References: <20200508212215.181307-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+lPomwo6gVp+8sIw/I2u7q5nAUGKdenRSc6ButB2wWA=;
        b=Y/d3gs9c8fLWvNo8cv/JRlC7Gdv90wnQcNRlqk6pT0nZP3sUowsrJKLy1ajL1gCIKP
         BNUeVyKZcJBZjS+0eDdZFhjTK3KefN3ABh56eoNStvjd714RuGjuUnA3L4xeJIFNUkAY
         bO0mV9zYI5WmPppNa8u/mIKGLHCWC/TjhPqGsKKMVtsXjIEUy6r5sxDfnrG5LunrIWzK
         c4P45AcNlm8NzX8yWiwIltielavQyQsD9QYT1cC7LRok37X0rUT9i2vJ4vjVhIsWoAUZ
         ZCn8t+LqSaHTPehqaJHQ7MaZ0Cg0xB93YKJMmUk8rRApPNqqK1qZub7KUWVS80QT7IRV
         OJow==
In-Reply-To: <20200508212215.181307-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

Currently update_page_reclaim_stat() updates the lruvec.reclaim_stats
just once for a page irrespective if a page is huge or not. Fix that by
passing the hpage_nr_pages(page) to it.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/swap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 4eb179ee0b72..dc7297cb76a0 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -262,14 +262,14 @@ void rotate_reclaimable_page(struct page *page)
 	}
 }
 
-static void update_page_reclaim_stat(struct lruvec *lruvec,
-				     int file, int rotated)
+static void update_page_reclaim_stat(struct lruvec *lruvec, int file,
+				     int rotated, int nr_pages)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	reclaim_stat->recent_scanned[file]++;
+	reclaim_stat->recent_scanned[file] += nr_pages;
 	if (rotated)
-		reclaim_stat->recent_rotated[file]++;
+		reclaim_stat->recent_rotated[file] += nr_pages;
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
@@ -288,7 +288,7 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 
 		__count_vm_events(PGACTIVATE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
-		update_page_reclaim_stat(lruvec, file, 1);
+		update_page_reclaim_stat(lruvec, file, 1, nr_pages);
 	}
 }
 
@@ -546,7 +546,7 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 		__count_vm_events(PGDEACTIVATE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 	}
-	update_page_reclaim_stat(lruvec, file, 0);
+	update_page_reclaim_stat(lruvec, file, 0, nr_pages);
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
@@ -564,7 +564,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 
 		__count_vm_events(PGDEACTIVATE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
-		update_page_reclaim_stat(lruvec, file, 0);
+		update_page_reclaim_stat(lruvec, file, 0, nr_pages);
 	}
 }
 
@@ -590,7 +590,7 @@ static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
 
 		__count_vm_events(PGLAZYFREE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
-		update_page_reclaim_stat(lruvec, 1, 0);
+		update_page_reclaim_stat(lruvec, 1, 0, nr_pages);
 	}
 }
 
@@ -928,7 +928,7 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
 	}
 
 	if (!PageUnevictable(page))
-		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
+		update_page_reclaim_stat(lruvec, file, PageActive(page_tail), 1);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -973,7 +973,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 	if (page_evictable(page)) {
 		lru = page_lru(page);
 		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
-					 PageActive(page));
+					 PageActive(page), nr_pages);
 		if (was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	} else {
-- 
2.26.2.645.ge9eca65c58-goog

