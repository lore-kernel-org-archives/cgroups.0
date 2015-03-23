From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 23/48] writeback: attribute stats to the matching per-cgroup bdi_writeback
Date: Mon, 23 Mar 2015 00:54:34 -0400
Message-ID: <1427086499-15657-24-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ujQzTQqDuebeu8TOdQEQvdOy11NP6uoAUI9fYXH33hA=;
        b=PVMgEeYQn2XH97LjQd9KvnExQ4Bwlp/+onHUAhvZjIP1MV3leI7ol7GsqSlAsbnnaW
         azYfpMLclo133NfI5n6ikUWxvoncGIAMb7zrM8MFEk9DxzJ4hCxwiG5Dzyint8K50dRo
         IqG8psGU2BHtzl3+Fkn/2RmD7Zhx418vY7IJmOqYk2LQGONYLH56N+2NWW7gF1r+Y4lF
         a7XDUOrZj1OBFrVpYH1Bg85qsFztMv/91H94MVq26oOda/RP6ZyZNd/bJKNxBKPCLLfK
         Y2WUf/S2FbkIljoVruM6OD9+DSGs0QviSmUN98nWw7lV3dCgr4ebqMvQ3vEnOvtWRmfs
         1GVQ==
In-Reply-To: <1427086499-15657-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Until now, all WB_* stats were accounted against the root wb
(bdi_writeback), now that multiple wb (bdi_writeback) support is in
place, let's attributes the stats to the respective per-cgroup wb's.

As no filesystem has FS_CGROUP_WRITEBACK yet, this doesn't lead to
visible behavior differences.

v2: Updated for per-inode wb association.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 mm/filemap.c        |  2 +-
 mm/page-writeback.c | 22 ++++++++++++++--------
 mm/truncate.c       |  6 ++++--
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a2b098b..64698fa 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -215,7 +215,7 @@ void __delete_from_page_cache(struct page *page, void *shadow,
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
 		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
 		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_wb_stat(&inode_to_bdi(mapping->host)->wb, WB_RECLAIMABLE);
+		dec_wb_stat(inode_to_wb(mapping->host), WB_RECLAIMABLE);
 	}
 }
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 10624e3..d5635cf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2175,10 +2175,13 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 void account_page_redirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
+
 	if (mapping && mapping_cap_account_dirty(mapping)) {
+		struct bdi_writeback *wb = inode_to_wb(mapping->host);
+
 		current->nr_dirtied--;
 		dec_zone_page_state(page, NR_DIRTIED);
-		dec_wb_stat(&inode_to_bdi(mapping->host)->wb, WB_DIRTIED);
+		dec_wb_stat(wb, WB_DIRTIED);
 	}
 }
 EXPORT_SYMBOL(account_page_redirty);
@@ -2324,8 +2327,7 @@ int clear_page_dirty_for_io(struct page *page)
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_wb_stat(&inode_to_bdi(mapping->host)->wb,
-				    WB_RECLAIMABLE);
+			dec_wb_stat(inode_to_wb(mapping->host), WB_RECLAIMABLE);
 			ret = 1;
 		}
 		mem_cgroup_end_page_stat(memcg);
@@ -2343,7 +2345,8 @@ int test_clear_page_writeback(struct page *page)
 
 	memcg = mem_cgroup_begin_page_stat(page);
 	if (mapping) {
-		struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
+		struct inode *inode = mapping->host;
+		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
@@ -2353,8 +2356,10 @@ int test_clear_page_writeback(struct page *page)
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
-				__dec_wb_stat(&bdi->wb, WB_WRITEBACK);
-				__wb_writeout_inc(&bdi->wb);
+				struct bdi_writeback *wb = inode_to_wb(inode);
+
+				__dec_wb_stat(wb, WB_WRITEBACK);
+				__wb_writeout_inc(wb);
 			}
 		}
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
@@ -2378,7 +2383,8 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 
 	memcg = mem_cgroup_begin_page_stat(page);
 	if (mapping) {
-		struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
+		struct inode *inode = mapping->host;
+		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
@@ -2388,7 +2394,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
-				__inc_wb_stat(&bdi->wb, WB_WRITEBACK);
+				__inc_wb_stat(inode_to_wb(inode), WB_WRITEBACK);
 		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
diff --git a/mm/truncate.c b/mm/truncate.c
index df16f8c..fe2d769 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -113,11 +113,13 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 	memcg = mem_cgroup_begin_page_stat(page);
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
+
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			struct bdi_writeback *wb = inode_to_wb(mapping->host);
+
 			mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_wb_stat(&inode_to_bdi(mapping->host)->wb,
-				    WB_RECLAIMABLE);
+			dec_wb_stat(wb, WB_RECLAIMABLE);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
-- 
2.1.0
