From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH 03/13] mm: move __ClearPageLRU() into page_off_lru()
Date: Thu, 17 Sep 2020 21:00:41 -0600
Message-ID: <20200918030051.650890-4-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xgnYESlnPAgRXuNmUoKIpEseoXbDWRNbcLBaliwt4oc=;
        b=JUmupfA4wraNNkt/3nQDRoRaUfUY18y3RzYhZnq0DDiJXlYJesex9t/1/0moJHN7v0
         50pxg0398VUNoS2zmL94S71EK7TP61x8/Q7FBsofCF2wC7NulxTKKH3hMdhR7nFOJ/PC
         uki9yZgG4KT9CzoqHNwgC7l7OkUR4FkQCLaBZwHr0QORR/rpMHGg/TdJWwEZCAtCS+8e
         4b1oC3cA+Trzzm0/dv8Wx+97jp+3a3DAAkgXb8OwFXgLmTQBqSbxgIv/X9QFjfhX+pRs
         K0DivOWlJ0PQTVXSvOGXUPE5sMtcoED2ZmrCJl1b9tqjC20mjmwqKnURY63+3efkm+wG
         BY+A==
In-Reply-To: <20200918030051.650890-1-yuzhao@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Huang Ying <ying.huang@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Minchan Kim <minchan@kernel.org>, Jaewon Kim <jaewon31.kim@samsung.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>

Now we have a total of three places that free lru pages when their
references become zero (after we drop the reference from isolation).

Before this patch, they all do:
	__ClearPageLRU()
	page_off_lru()
	del_page_from_lru_list()

After this patch, they become:
	page_off_lru()
		__ClearPageLRU()
	del_page_from_lru_list()

This change should have no side effects.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 include/linux/mm_inline.h | 1 +
 mm/swap.c                 | 2 --
 mm/vmscan.c               | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 8fc71e9d7bb0..be9418425e41 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -92,6 +92,7 @@ static __always_inline enum lru_list page_off_lru(struct page *page)
 {
 	enum lru_list lru;
 
+	__ClearPageLRU(page);
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
 		lru = LRU_UNEVICTABLE;
diff --git a/mm/swap.c b/mm/swap.c
index 40bf20a75278..8362083f00c9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -86,7 +86,6 @@ static void __page_cache_release(struct page *page)
 		spin_lock_irqsave(&pgdat->lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
-		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 	}
@@ -895,7 +894,6 @@ void release_pages(struct page **pages, int nr)
 
 			lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
-			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f257d2f61574..f9a186a96410 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1862,7 +1862,6 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		add_page_to_lru_list(page, lruvec, lru);
 
 		if (put_page_testzero(page)) {
-			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 
 			if (unlikely(PageCompound(page))) {
-- 
2.28.0.681.g6f77f65b4e-goog

