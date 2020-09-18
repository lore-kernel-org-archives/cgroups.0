From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/13] mm: use add_page_to_lru_list()
Date: Thu, 17 Sep 2020 21:00:39 -0600
Message-ID: <20200918030051.650890-2-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=qvnHHsvBI3sH+b5g6Iv8RJ5s4+ZnaHU0vmrrO4o5gi4=;
        b=lqyqyA8BFWcwFuv/9+MGNQiOru0sKjIbm0eSJ1ByXF6JVc9vr8FDv47rnqSsdyTs7t
         S3NxZnk+2iO6CRHdaA4UalB3w3yZF3qC28jCD2uRk5cxex4zVBD5qDQbnTRcrAf07Nsc
         ygcQl37PtmLBFqLAL8rbF46ASLQ1gAydzClOP5DevnlAsHwK/PfIrGSFDMam+ySaujJT
         hanmi+54Txv+6VjCu9U3o7d4IJIv2iwSEqK4D9aDrbo1zTg7iqka8SpMD+NpS6lHugQs
         AtUjhjYt1eOv7g1ZT8k0bRjvxL28/U/JID1UhXh/ggjhBucFBF095ClBMUlEnjXVJwfd
         7itA==
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This patch replaces the only open-coded lru list addition with
add_page_to_lru_list().

Before this patch, we have:
	update_lru_size()
	list_move()

After this patch, we have:
	list_del()
	add_page_to_lru_list()
		update_lru_size()
		list_add()

The only side effect is that page->lru is temporarily poisoned
after a page is deleted from its old list, which shouldn't be a
problem.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/vmscan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9727dd8e2581..503fc5e1fe32 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1850,8 +1850,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
+		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			list_del(&page->lru);
 			spin_unlock_irq(&pgdat->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&pgdat->lru_lock);
@@ -1862,9 +1862,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		SetPageLRU(page);
 		lru = page_lru(page);
 
-		nr_pages = thp_nr_pages(page);
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_move(&page->lru, &lruvec->lists[lru]);
+		add_page_to_lru_list(page, lruvec, lru);
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
@@ -1878,6 +1876,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 			} else
 				list_add(&page->lru, &pages_to_free);
 		} else {
+			nr_pages = thp_nr_pages(page);
 			nr_moved += nr_pages;
 			if (PageActive(page))
 				workingset_age_nonresident(lruvec, nr_pages);
-- 
2.28.0.681.g6f77f65b4e-goog

