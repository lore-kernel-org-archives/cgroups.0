From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/13] mm: inline __update_lru_size()
Date: Thu, 17 Sep 2020 21:00:49 -0600
Message-ID: <20200918030051.650890-12-yuzhao@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wq04R7kZnQOtaC6LIn5FEyAUuNq1+kFsvgljt2u93LM=;
        b=gMRyeCTkVNljPnLMYO/c5iwSUJPLZYnD8yVlrpNnYNQl+BUx4Gp6/CVq2UXghQXGL0
         DsDMaadax8KWE8X5qaIMvpG6T690scGvd3Umzz2c8LXQDxhE5P42VbtJwYEG5wO+jFGZ
         L1gYoNlhdLpsUUd9kzHg0DoMrL069TOq4UpyUgaStksAyD4JM0446iezsZlMDIKjXeVJ
         K+15ABfhWQghGRPSS5tivLNMvFtAiisjVBtwvc/dxiDYVE6hCRMbnimrwIAZSPG1X0g0
         7Db4ovJPLWWGZgL8IdeKqCGHLlA8tr+98Io6ncueImMNiVlVOpsrvmFQY4NauP0wGXb6
         Swbg==
In-Reply-To: <20200918030051.650890-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

All other references to the function were removed after
commit a892cb6b977f ("mm/vmscan.c: use update_lru_size() in update_lru_sizes()")

This change should have no side effects.

Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/mm_inline.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 7183c7a03f09..355ea1ee32bd 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -24,7 +24,7 @@ static inline int page_is_file_lru(struct page *page)
 	return !PageSwapBacked(page);
 }
 
-static __always_inline void __update_lru_size(struct lruvec *lruvec,
+static __always_inline void update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				int nr_pages)
 {
@@ -33,13 +33,6 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
-}
-
-static __always_inline void update_lru_size(struct lruvec *lruvec,
-				enum lru_list lru, enum zone_type zid,
-				int nr_pages)
-{
-	__update_lru_size(lruvec, lru, zid, nr_pages);
 #ifdef CONFIG_MEMCG
 	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
 #endif
-- 
2.28.0.681.g6f77f65b4e-goog

