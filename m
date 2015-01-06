From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/45] writeback: attribute stats to the matching per-cgroup bdi_writeback
Date: Tue,  6 Jan 2015 16:25:44 -0500
Message-ID: <1420579582-8516-8-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7sxpKhNmptvO2fngMKzwAkONhSIDQgV5cFb9kivVHLk=;
        b=JHWZu63JuNi35PXY/dedqlQnjuk02r0/JFNC7LIA/ynT1cLIXGbufIsG/gnHiG97Yr
         yDOULuuwfFvtR3dEiYX3CsvD6rjT24xs3jp3MpXwDU7N5HoCYnwpmL6w+ceean3+izK7
         ZDIpk4KYy+rnmnoOPrXDrNR+J3tLw6pA42MweYd797PcQtlOQ1XZ6lVauriETwYB49At
         XkcvceKacEqedXBy5ojzTckqAjhC1QKriqeT2j/gli/1TwDZs40bs21b4oCk+bUIzEVi
         VAx0zuzo37PlMpbOUZ+p8jN31NY3qMpzi/tAj+vf5Ivi7EsW65BRfzu286B3E+9Jvilz
         wPSw==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

Until now, all WB_* stats were accounted against the root wb
(bdi_writeback), now that multiple wb (bdi_writeback) support is in
place, let's attributes the stats to the respective per-cgroup wb's.

WB_RECLAIMABLE and WB_DIRTIED are attributed to the page's dirty cgwb
(per-cgroup wb) and WB_WRITEBACK to writeback cgwb.
__test_set_page_writeback() is updated so that dirty cgwb association
takes place before WB_WRITEBACK increment so that the latter can make
use of the association.

As no filesystem has FS_CGROUP_WRITEBACK yet, this doesn't lead to
visible behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/filemap.c        |  2 +-
 mm/page-writeback.c | 18 ++++++++++++------
 mm/truncate.c       |  3 +--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 98a6675..faa577d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -211,7 +211,7 @@ void __delete_from_page_cache(struct page *page, void *shadow)
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
 		dec_zone_page_state(page, NR_FILE_DIRTY);
-		dec_wb_stat(&mapping->backing_dev_info->wb, WB_RECLAIMABLE);
+		dec_wb_stat(page_cgwb_dirty(page), WB_RECLAIMABLE);
 		page_blkcg_detach_dirty(page);
 	}
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6475504..d1fea3a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2159,10 +2159,13 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 void account_page_redirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
+
 	if (mapping && mapping_cap_account_dirty(mapping)) {
+		struct bdi_writeback *wb = page_cgwb_dirty(page);
+
 		current->nr_dirtied--;
 		dec_zone_page_state(page, NR_DIRTIED);
-		dec_wb_stat(&mapping->backing_dev_info->wb, WB_DIRTIED);
+		dec_wb_stat(wb, WB_DIRTIED);
 	}
 }
 EXPORT_SYMBOL(account_page_redirty);
@@ -2300,9 +2303,10 @@ int clear_page_dirty_for_io(struct page *page)
 		 * exclusion.
 		 */
 		if (TestClearPageDirty(page)) {
+			struct bdi_writeback *wb = page_cgwb_dirty(page);
+
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_wb_stat(&mapping->backing_dev_info->wb,
-				    WB_RECLAIMABLE);
+			dec_wb_stat(wb, WB_RECLAIMABLE);
 			page_blkcg_detach_dirty(page);
 			return 1;
 		}
@@ -2330,9 +2334,11 @@ int test_clear_page_writeback(struct page *page)
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
-				__dec_wb_stat(&bdi->wb, WB_WRITEBACK);
+				struct bdi_writeback *wb = page_cgwb_wb(page);
+
+				__dec_wb_stat(wb, WB_WRITEBACK);
 				page_blkcg_detach_wb(page);
-				__wb_writeout_inc(&bdi->wb);
+				__wb_writeout_inc(wb);
 			}
 		}
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
@@ -2366,8 +2372,8 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
-				__inc_wb_stat(&bdi->wb, WB_WRITEBACK);
 				page_blkcg_attach_wb(page);
+				__inc_wb_stat(page_cgwb_wb(page), WB_WRITEBACK);
 			}
 		}
 		if (!PageDirty(page))
diff --git a/mm/truncate.c b/mm/truncate.c
index caae624..1658e34 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -112,8 +112,7 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
-			dec_wb_stat(&mapping->backing_dev_info->wb,
-				    WB_RECLAIMABLE);
+			dec_wb_stat(page_cgwb_dirty(page), WB_RECLAIMABLE);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 			page_blkcg_detach_dirty(page);
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
