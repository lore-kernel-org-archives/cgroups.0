From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v13 04/18] mm/memcg: Remove soft_limit_tree_node()
Date: Mon, 12 Jul 2021 20:45:37 +0100
Message-ID: <20210712194551.91920-5-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZszZ6tgqEqvbn4yMeCdI0iO4PNst4fp1/dzYOIQ1JeY=; b=YpSDwjHlxKrAWxqTnShe/Lfunv
        PMbS22mlDF78y1tDdHkWsocwPLx89wpwG2MuN2NCGi2OgHvwY+V35iXkc2YC5/M0QEzGd1pjQXKCf
        MxM4N2y+9Lz+v8qgmpm5owjq7euLdb0y68lmQxaIdRrm6zZIZ3rSee8CLMcjqI6bY8HgbT53ztGHx
        T4QZTGdzftVWhQXJH2e3yH7LTeNWxnimQcunqqOncTIB9ujShu+83mjUgIj7+QFYcp4jIeDtvzEJ2
        w0/xlinPzwoufdv1bgoL+unKwZX7oXx1PokyUMmPkd7W+y4G1ZuGXRoCNIjS870X2AKoAuP4Ftzt1
        6Ho2N+9g==;
In-Reply-To: <20210712194551.91920-1-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>

Opencode this one-line function in its three callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/memcontrol.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d57ff5c5d330..f70e33d691aa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -451,12 +451,6 @@ ino_t page_cgroup_ino(struct page *page)
 	return ino;
 }
 
-static struct mem_cgroup_tree_per_node *
-soft_limit_tree_node(int nid)
-{
-	return soft_limit_tree.rb_tree_per_node[nid];
-}
-
 static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
 					 struct mem_cgroup_tree_per_node *mctz,
 					 unsigned long new_usage_in_excess)
@@ -533,7 +527,7 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
 	struct mem_cgroup_per_node *mz;
 	struct mem_cgroup_tree_per_node *mctz;
 
-	mctz = soft_limit_tree_node(nid);
+	mctz = soft_limit_tree.rb_tree_per_node[nid];
 	if (!mctz)
 		return;
 	/*
@@ -572,7 +566,7 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
 
 	for_each_node(nid) {
 		mz = memcg->nodeinfo[nid];
-		mctz = soft_limit_tree_node(nid);
+		mctz = soft_limit_tree.rb_tree_per_node[nid];
 		if (mctz)
 			mem_cgroup_remove_exceeded(mz, mctz);
 	}
@@ -3420,7 +3414,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node(pgdat->node_id);
+	mctz = soft_limit_tree.rb_tree_per_node[pgdat->node_id];
 
 	/*
 	 * Do not even bother to check the largest node if the root
-- 
2.30.2

