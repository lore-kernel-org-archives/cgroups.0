From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/13] mm: don't pass enum lru_list to trace_mm_lru_insertion()
Date: Thu, 17 Sep 2020 21:00:44 -0600
Message-ID: <20200918030051.650890-7-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4MOFrrHR2/UhZD8wnGs0ogWSv0e594oXOmpHs7V/Hlc=;
        b=Dw/BE/Q/G5v7r7p+x51pZfrNQwT6ly7+dXeOKeyFItGyUFUkIUvZVYbl/2GhRz9B5T
         4EDzpTx9xwcDSkMvD4RmnNW6/nCZcAjD1C8bv7jZeW3LHYuhVAjSofCxPTb/sJvrFqkb
         XaC9tNEde7FVCTlIR39u+GG4+ga57fTsfOXaPb6/W9TU9ebCZnKpGjfeQ0+KAajoU1V4
         JexNO6nH/0XLaMxu1Wzu0g7z/+KB3XTivJ8zth62HMCUc7HtsbWrnRg9q0BJU0Ku3RwP
         tTGf9lCuOhl4wZDotKm7LIyzwDkomMVN2j58x7knCFbS1f+ICgjaHXX+oFBr5j4R5VI0
         bqqw==
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The parameter is redundant in the sense that it can be extracted
from the struct page parameter by page_lru() correctly.

This change should have no side effects.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/trace/events/pagemap.h | 11 ++++-------
 mm/swap.c                      |  5 +----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 8fd1babae761..e1735fe7c76a 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -27,24 +27,21 @@
 
 TRACE_EVENT(mm_lru_insertion,
 
-	TP_PROTO(
-		struct page *page,
-		int lru
-	),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, lru),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
 		__field(unsigned long,	pfn	)
-		__field(int,		lru	)
+		__field(enum lru_list,	lru	)
 		__field(unsigned long,	flags	)
 	),
 
 	TP_fast_assign(
 		__entry->page	= page;
 		__entry->pfn	= page_to_pfn(page);
-		__entry->lru	= lru;
+		__entry->lru	= page_lru(page);
 		__entry->flags	= trace_pagemap_flags(page);
 	),
 
diff --git a/mm/swap.c b/mm/swap.c
index 8d0e31d43852..3c89a7276359 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -962,7 +962,6 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 				 void *arg)
 {
-	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
 	int nr_pages = thp_nr_pages(page);
 
@@ -998,11 +997,9 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 	smp_mb__after_atomic();
 
 	if (page_evictable(page)) {
-		lru = page_lru(page);
 		if (was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	} else {
-		lru = LRU_UNEVICTABLE;
 		ClearPageActive(page);
 		SetPageUnevictable(page);
 		if (!was_unevictable)
@@ -1010,7 +1007,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 	}
 
 	add_page_to_lru_list(page, lruvec);
-	trace_mm_lru_insertion(page, lru);
+	trace_mm_lru_insertion(page);
 }
 
 /*
-- 
2.28.0.681.g6f77f65b4e-goog

