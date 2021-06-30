From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 03/18] mm/memcg: Use the node id in mem_cgroup_update_tree()
Date: Wed, 30 Jun 2021 05:00:19 +0100
Message-ID: <20210630040034.1155892-4-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=61msnB23CZehcqWgrUMdSZxzGrV4zpn68Z+u3tCZTOE=; b=uNMObRprg4+OmqsxA0UfUTIJkx
        c3zHhQf7t6L2nqJM4ojCzgrX6z24uOr/+MKd0azZ+sbs5dGRWZhqPoJjcWYddv4WD+F4FP/P+y0OT
        aybe9mP3u9dHSn3FWQJLveBE6zgBPuYzcnC01BdfugK6Juqj1IDJv4ZcTWC9bmBvSuEC9gdaf4KbK
        T0BPioCtVfEbHk//sTi07twwcr7MBIHZbpvb53MPhg8lyjbqTg4GpP9PpcZm6gEwWIRWXBfgl1YG7
        nAX/VHI0UR6VhYXq2Fbn279d6pDKESdnAmreE7QLhovuKPtBdXCMDSyvYsHUAIWM6xmBAieKk9eJo
        bMi4fGhA==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

By using the node id in mem_cgroup_update_tree(), we can delete
soft_limit_tree_from_page() and mem_cgroup_page_nodeinfo().  Saves 42
bytes of kernel text on my config.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/memcontrol.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 25cad0fb7d4e..29b28a050707 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -446,28 +446,12 @@ ino_t page_cgroup_ino(struct page *page)
 	return ino;
 }
 
-static struct mem_cgroup_per_node *
-mem_cgroup_page_nodeinfo(struct mem_cgroup *memcg, struct page *page)
-{
-	int nid = page_to_nid(page);
-
-	return memcg->nodeinfo[nid];
-}
-
 static struct mem_cgroup_tree_per_node *
 soft_limit_tree_node(int nid)
 {
 	return soft_limit_tree.rb_tree_per_node[nid];
 }
 
-static struct mem_cgroup_tree_per_node *
-soft_limit_tree_from_page(struct page *page)
-{
-	int nid = page_to_nid(page);
-
-	return soft_limit_tree.rb_tree_per_node[nid];
-}
-
 static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 					 struct mem_cgroup_tree_per_node *mctz,
 					 unsigned long new_usage_in_excess)
@@ -538,13 +522,13 @@ static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
 	return excess;
 }
 
-static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
+static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
 {
 	unsigned long excess;
 	struct mem_cgroup_per_node *mz;
 	struct mem_cgroup_tree_per_node *mctz;
 
-	mctz = soft_limit_tree_from_page(page);
+	mctz = soft_limit_tree_node(nid);
 	if (!mctz)
 		return;
 	/*
@@ -552,7 +536,7 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 	 * because their event counter is not touched.
 	 */
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		mz = mem_cgroup_page_nodeinfo(memcg, page);
+		mz = memcg->nodeinfo[nid];
 		excess = soft_limit_excess(memcg);
 		/*
 		 * We have to update the tree if mz is on RB-tree or
@@ -879,7 +863,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 						MEM_CGROUP_TARGET_SOFTLIMIT);
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
-			mem_cgroup_update_tree(memcg, page);
+			mem_cgroup_update_tree(memcg, page_to_nid(page));
 	}
 }
 
-- 
2.30.2

