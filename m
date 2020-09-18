From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/13] mm: VM_BUG_ON lru page flags
Date: Thu, 17 Sep 2020 21:00:48 -0600
Message-ID: <20200918030051.650890-11-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=JWU8yC6IA7OOmAjcclmLYHeJJ6Drguj19pPsyjDCDs0=;
        b=qy3asCDaCFhH2UckwoVpj1hLkwKFWdJ8Q5ketDmhYI3hL6mTuFwQvIqRDiOthDLcop
         PaTh5jl3tn3RExOoer2eQ1sA4CtBHf8RusyChtv3D0k48TiFbyxIhJyEXtCqHq/0n1xE
         3Yn8oq0MtIy5PWoW+p1Bq2LKE228TMBHdm2Q2e3ocu7wJuESMOzDPfmS1X2MYwdMtH0N
         /lhTVZtJPDrrqCIwW+Ymnxtxhor8zWXlnCdwoOxR8+e1hPcZXo/+sihZSJUl+SblRMo0
         nvdn+vCO4zY56L7FbvQlWb3v1qy4rUB83yS9VcoBBSfFkDeCenHZoAYK3FFf8xrMjl6h
         SWWw==
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Move scattered VM_BUG_ONs to two essential places that cover all
lru list additions and deletions.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/mm_inline.h | 4 ++++
 mm/swap.c                 | 2 --
 mm/vmscan.c               | 1 -
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 07d9a0286635..7183c7a03f09 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -51,6 +51,8 @@ static __always_inline void update_lru_size(struct lruvec *lruvec,
  */
 static __always_inline void __clear_page_lru_flags(struct page *page)
 {
+	VM_BUG_ON_PAGE(!PageLRU(page), page);
+
 	__ClearPageLRU(page);
 
 	/* this shouldn't happen, so leave the flags to bad_page() */
@@ -72,6 +74,8 @@ static __always_inline enum lru_list page_lru(struct page *page)
 {
 	enum lru_list lru;
 
+	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
+
 	if (PageUnevictable(page))
 		return LRU_UNEVICTABLE;
 
diff --git a/mm/swap.c b/mm/swap.c
index b252f3593c57..4daa46907dd5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -85,7 +85,6 @@ static void __page_cache_release(struct page *page)
 
 		spin_lock_irqsave(&pgdat->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		del_page_from_lru_list(page, lruvec);
 		__clear_page_lru_flags(page);
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
@@ -885,7 +884,6 @@ void release_pages(struct page **pages, int nr)
 			}
 
 			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
-			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			del_page_from_lru_list(page, lruvec);
 			__clear_page_lru_flags(page);
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d93033407200..4688e495c242 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4276,7 +4276,6 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 			continue;
 
 		if (page_evictable(page)) {
-			VM_BUG_ON_PAGE(PageActive(page), page);
 			del_page_from_lru_list(page, lruvec);
 			ClearPageUnevictable(page);
 			add_page_to_lru_list(page, lruvec);
-- 
2.28.0.681.g6f77f65b4e-goog

