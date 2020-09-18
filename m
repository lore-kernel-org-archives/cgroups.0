From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/13] mm: inline page_lru_base_type()
Date: Thu, 17 Sep 2020 21:00:47 -0600
Message-ID: <20200918030051.650890-10-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=b85d06LSJeBa6rsJlkkKw7JSUKETD4Y77r+y+YRUjRk=;
        b=cWN5izs+aaUKIykYldczEGDmX7RVsvXEViMXNM8ddq7IeJUErvEZ7YdO38E4AFWwxP
         YEGT0mKVWONgbxqp+r4pTV4D1WwdDlqTrABmb6KVFHS5OFMTLKY2UEzRGM+vL7hhdhKx
         IaQIzDSeHjmyce1otEEqrqDyv6uST3U5GfHz2sDAE1s8kXR5cjQj4EETNK69mu8yGn9j
         GvzZfTkNo0CzoDjDLYHYJ8I5KsS2eGdRS+qV0OiiRKfOB1pppqA28sk9tyOGnxQxSwcr
         G+u1NzRVk46Muag854KLQHKD6YgqmcxLbkzWgPIt4r7DV7v+ZaC3USwXXEuUreUOuKSI
         IIcw==
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

We've removed all other references to this function.

This change should have no side effects.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/mm_inline.h | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ef3fd79222e5..07d9a0286635 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -45,21 +45,6 @@ static __always_inline void update_lru_size(struct lruvec *lruvec,
 #endif
 }
 
-/**
- * page_lru_base_type - which LRU list type should a page be on?
- * @page: the page to test
- *
- * Used for LRU list index arithmetic.
- *
- * Returns the base LRU type - file or anon - @page should be on.
- */
-static inline enum lru_list page_lru_base_type(struct page *page)
-{
-	if (page_is_file_lru(page))
-		return LRU_INACTIVE_FILE;
-	return LRU_INACTIVE_ANON;
-}
-
 /**
  * __clear_page_lru_flags - clear page lru flags before releasing a page
  * @page: the page that was on lru and now has a zero reference
@@ -88,12 +73,12 @@ static __always_inline enum lru_list page_lru(struct page *page)
 	enum lru_list lru;
 
 	if (PageUnevictable(page))
-		lru = LRU_UNEVICTABLE;
-	else {
-		lru = page_lru_base_type(page);
-		if (PageActive(page))
-			lru += LRU_ACTIVE;
-	}
+		return LRU_UNEVICTABLE;
+
+	lru = page_is_file_lru(page) ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+	if (PageActive(page))
+		lru += LRU_ACTIVE;
+
 	return lru;
 }
 
-- 
2.28.0.681.g6f77f65b4e-goog

