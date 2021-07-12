From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v13 12/18] mm/memcg: Convert mem_cgroup_track_foreign_dirty_slowpath() to folio
Date: Mon, 12 Jul 2021 20:45:45 +0100
Message-ID: <20210712194551.91920-13-willy@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=DY9hlMlHbb1vO3/C6ZAp3fz6Zl9w4L5Q+jr1F8EZDYk=; b=qSAOz0rrwpwCKaHCI4cJstYd4W
        jAdyHh+jxcTn5cz8LJKCxIUQqYGLYbhprVFHWqjvz0aV0TCqsZDBi4EBbtlZvZl+rkr6j6KXUaAMD
        DhAIJApoKMpvHotJRh4VsH41zx9AGAowsMlBf80ap9hQ0Zd9dwFQZ0g8t/KKyshEALENZEle+ugih
        tS2EDuMro/lSF+/h2xTf6vK3X8BTRI0REkDwPk9NFukxZP3YsfsiJm9t7exIuT9yvuMoPMIOqZkxU
        +l2rcUeD7IRn/UpmRydzV9YmTQwZUgK2z0tkAqkDap9GBpFy8QP0Axd2CCH54EmZaGusirU6ubAN+
        Q6nYIvoQ==;
In-Reply-To: <20210712194551.91920-1-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Christoph Hellwig <hch@lst.de>

The page was only being used for the memcg and to gather trace
information, so this is a simple conversion.  The only caller of
mem_cgroup_track_foreign_dirty() will be converted to folios in a later
patch, so doing this now makes that patch simpler.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/memcontrol.h       | 7 ++++---
 include/trace/events/writeback.h | 8 ++++----
 mm/memcontrol.c                  | 6 +++---
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bad4a50e19..a82939df13dc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1560,17 +1560,18 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 			 unsigned long *pheadroom, unsigned long *pdirty,
 			 unsigned long *pwriteback);
 
-void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
+void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb);
 
 static inline void mem_cgroup_track_foreign_dirty(struct page *page,
 						  struct bdi_writeback *wb)
 {
+	struct folio *folio = page_folio(page);
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&page_memcg(page)->css != wb->memcg_css))
-		mem_cgroup_track_foreign_dirty_slowpath(page, wb);
+	if (unlikely(&folio_memcg(folio)->css != wb->memcg_css))
+		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
 }
 
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 840d1ba84cf5..297871ca0004 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -236,9 +236,9 @@ TRACE_EVENT(inode_switch_wbs,
 
 TRACE_EVENT(track_foreign_dirty,
 
-	TP_PROTO(struct page *page, struct bdi_writeback *wb),
+	TP_PROTO(struct folio *folio, struct bdi_writeback *wb),
 
-	TP_ARGS(page, wb),
+	TP_ARGS(folio, wb),
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
@@ -250,7 +250,7 @@ TRACE_EVENT(track_foreign_dirty,
 	),
 
 	TP_fast_assign(
-		struct address_space *mapping = page_mapping(page);
+		struct address_space *mapping = folio_mapping(folio);
 		struct inode *inode = mapping ? mapping->host : NULL;
 
 		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
@@ -258,7 +258,7 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
-		__entry->page_cgroup_ino = cgroup_ino(page_memcg(page)->css.cgroup);
+		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
 	),
 
 	TP_printk("bdi %s[%llu]: ino=%lu memcg_id=%u cgroup_ino=%lu page_cgroup_ino=%lu",
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 06fc88d75a04..ffa9a9b2ad76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4571,17 +4571,17 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * As being wrong occasionally doesn't matter, updates and accesses to the
  * records are lockless and racy.
  */
-void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
+void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct memcg_cgwb_frn *frn;
 	u64 now = get_jiffies_64();
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
 
-	trace_track_foreign_dirty(page, wb);
+	trace_track_foreign_dirty(folio, wb);
 
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
-- 
2.30.2

