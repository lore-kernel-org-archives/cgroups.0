From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH 04/13] mm: shuffle lru list addition and deletion functions
Date: Thu, 17 Sep 2020 21:00:42 -0600
Message-ID: <20200918030051.650890-5-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=w7mV5u1sVuL/HO4R09xmKV4wSajKsT9IQhDHQgEJXm8=;
        b=jDtcgyrhMdZDz3izu8b4buHaQnBHiMajkKbH5BTR5O+yM3vyEJzubaWXG3osf+PdiA
         WDIFMK6json2onX6FGRWm1wJFG4aJtqbEZCBQVMdTSxbX52x/ZxeUD6wCdCyTDvGF/W9
         fHAhr4VdkC62NlHfxA9LHTUU9ojRZZRXc5CuhbqCHj+hov8eLDeFR9CaHt3hVHuvQ3EI
         nHk9bPEOYH99f4NTwoV1jvoEj/cFFsoLfAAVtVtU6GcMuabk7KtE4Dcj35ROnppJCQWE
         SnaNaAP0OJYZNobndXx0RCrPNI28FP1PtuIeYR2ro2oXPWKjVJ4E9T8Pam52iDeW313A
         7nVA==
In-Reply-To: <20200918030051.650890-1-yuzhao@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Huang Ying <ying.huang@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Minchan Kim <minchan@kernel.org>, Jaewon Kim <jaewon31.kim@samsung.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>

This change should have no side effects.

We want it only because we prefer to avoid forward declarations in
the following patches.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 include/linux/mm_inline.h | 42 +++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index be9418425e41..bfa30c752804 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -45,27 +45,6 @@ static __always_inline void update_lru_size(struct lruvec *lruvec,
 #endif
 }
 
-static __always_inline void add_page_to_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
-	list_add(&page->lru, &lruvec->lists[lru]);
-}
-
-static __always_inline void add_page_to_lru_list_tail(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
-	list_add_tail(&page->lru, &lruvec->lists[lru]);
-}
-
-static __always_inline void del_page_from_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
-{
-	list_del(&page->lru);
-	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
-}
-
 /**
  * page_lru_base_type - which LRU list type should a page be on?
  * @page: the page to test
@@ -126,4 +105,25 @@ static __always_inline enum lru_list page_lru(struct page *page)
 	}
 	return lru;
 }
+
+static __always_inline void add_page_to_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
+	list_add(&page->lru, &lruvec->lists[lru]);
+}
+
+static __always_inline void add_page_to_lru_list_tail(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
+	list_add_tail(&page->lru, &lruvec->lists[lru]);
+}
+
+static __always_inline void del_page_from_lru_list(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	list_del(&page->lru);
+	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
+}
 #endif
-- 
2.28.0.681.g6f77f65b4e-goog

