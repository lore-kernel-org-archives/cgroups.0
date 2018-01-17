From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 30/99] mm: Convert page-writeback to XArray
Date: Wed, 17 Jan 2018 12:20:54 -0800
Message-ID: <20180117202203.19756-31-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qPrgouP58kWLR8jrX70FWhTUzHZLolfaOU1e75K8fVc=; b=c/Czf0Vmv7BsH3/vrQaP1xCYoq
 D/PY3EJTORn+NtyRRsH5Kwa5iwqD+m8TlmN5dl/OdRb0clwe/M5eJPlokvXSyC+SYj+edGtQymSHQ
 nOcmTKucqmXNoFJEABWIY+KKEOgjfihUZQf/ItiXzP7GSPTexn1t1eHPbmPFIY4+xCJg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=qPrgouP58kWLR8jrX70FWhTUzHZLolfaOU1e75K8fVc=; b=gQtPyfSQn1jDWqB6DJGn1ixyyF
 3/v4Ng81WJsfxjasKjl1Sz7nAty5Lkmcnp4yRJpT7ctwrhcIAqKRfeItTuLKmYarLm2IHpnKTMzxa
 ER8L4AMPiz02tzlODz3MexgO3dRmb8Z7fMrNW1jdw1addo+jx+ZNGzteK75WFHFd5SIw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qPrgouP58kWLR8jrX70FWhTUzHZLolfaOU1e75K8fVc=; b=nSV/2DHVq3OXQA9IxFs/9qqfT
 a1Q4yHwFLP3xo1qgK9d7Zx4v8AY9stmAIYCgL4qMtc+o/DRqxR/zqOn9vctFAyJNoOF5Yha2ONBRK
 x0Zr4D/5k4VzAbXhmcSZA4adsrJ38YUHcSciFZFiS6dlxu8vTpM8YHA46zwgUgS/WQt1i5mGqgPcx
 CX1pCm/CqOqCXTwd6Nab8ZXScSMpneZ7jxcQFEq76LmrFDSJkPBXbxU0QHJveu4+eLpJsQPUsoB/h
 ATI0qCV2RnLlIn0XD5LbLB9rN9cXYNSF1RBZsdeUvi2HSvhwlkPQbvNjeIZb3+YagsJvBfgznQXdA
 hBEUWEomQ==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Includes moving mapping_tagged() to fs.h as a static inline, and
changing it to return bool.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/fs.h  | 17 +++++++++------
 mm/page-writeback.c | 62 +++++++++++++++++++----------------------------------
 2 files changed, 32 insertions(+), 47 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e4345c13e237..c58bc3c619bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -470,15 +470,18 @@ struct block_device {
 	struct mutex		bd_fsfreeze_mutex;
 } __randomize_layout;
 
+/* XArray tags, for tagging dirty and writeback pages in the pagecache. */
+#define PAGECACHE_TAG_DIRTY	XA_TAG_0
+#define PAGECACHE_TAG_WRITEBACK	XA_TAG_1
+#define PAGECACHE_TAG_TOWRITE	XA_TAG_2
+
 /*
- * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
- * radix trees
+ * Returns true if any of the pages in the mapping are marked with the tag.
  */
-#define PAGECACHE_TAG_DIRTY	0
-#define PAGECACHE_TAG_WRITEBACK	1
-#define PAGECACHE_TAG_TOWRITE	2
-
-int mapping_tagged(struct address_space *mapping, int tag);
+static inline bool mapping_tagged(struct address_space *mapping, xa_tag_t tag)
+{
+	return xa_tagged(&mapping->pages, tag);
+}
 
 static inline void i_mmap_lock_write(struct address_space *mapping)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 588ce729d199..0407436a8305 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2098,33 +2098,25 @@ void __init page_writeback_init(void)
  * dirty pages in the file (thus it is important for this function to be quick
  * so that it can tag pages faster than a dirtying process can create them).
  */
-/*
- * We tag pages in batches of WRITEBACK_TAG_BATCH to reduce xa_lock latency.
- */
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end)
 {
-#define WRITEBACK_TAG_BATCH 4096
-	unsigned long tagged = 0;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, start);
+	unsigned int tagged = 0;
+	void *page;
 
-	xa_lock_irq(&mapping->pages);
-	radix_tree_for_each_tagged(slot, &mapping->pages, &iter, start,
-							PAGECACHE_TAG_DIRTY) {
-		if (iter.index > end)
-			break;
-		radix_tree_iter_tag_set(&mapping->pages, &iter,
-							PAGECACHE_TAG_TOWRITE);
-		tagged++;
-		if ((tagged % WRITEBACK_TAG_BATCH) != 0)
+	xas_lock_irq(&xas);
+	xas_for_each_tag(&xas, page, end, PAGECACHE_TAG_DIRTY) {
+		xas_set_tag(&xas, PAGECACHE_TAG_TOWRITE);
+		if (++tagged % XA_CHECK_SCHED)
 			continue;
-		slot = radix_tree_iter_resume(slot, &iter);
-		xa_unlock_irq(&mapping->pages);
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
 		cond_resched();
-		xa_lock_irq(&mapping->pages);
+		xas_lock_irq(&xas);
 	}
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
@@ -2164,7 +2156,7 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	int tag;
+	xa_tag_t tag;
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
@@ -2445,7 +2437,7 @@ void account_page_cleaned(struct page *page, struct address_space *mapping,
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
- * its radix tree.
+ * the xarray.
  *
  * This is also used when a single buffer is being dirtied: we want to set the
  * page dirty in that case, but not all the buffers.  This is a "bottom-up"
@@ -2471,7 +2463,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 		BUG_ON(page_mapping(page) != mapping);
 		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
-		radix_tree_tag_set(&mapping->pages, page_index(page),
+		__xa_set_tag(&mapping->pages, page_index(page),
 				   PAGECACHE_TAG_DIRTY);
 		xa_unlock_irqrestore(&mapping->pages, flags);
 		unlock_page_memcg(page);
@@ -2634,13 +2626,13 @@ EXPORT_SYMBOL(__cancel_dirty_page);
  * Returns true if the page was previously dirty.
  *
  * This is for preparing to put the page under writeout.  We leave the page
- * tagged as dirty in the radix tree so that a concurrent write-for-sync
+ * tagged as dirty in the xarray so that a concurrent write-for-sync
  * can discover it via a PAGECACHE_TAG_DIRTY walk.  The ->writepage
  * implementation will run either set_page_writeback() or set_page_dirty(),
- * at which stage we bring the page's dirty flag and radix-tree dirty tag
+ * at which stage we bring the page's dirty flag and xarray dirty tag
  * back into sync.
  *
- * This incoherency between the page's dirty flag and radix-tree tag is
+ * This incoherency between the page's dirty flag and xarray tag is
  * unfortunate, but it only exists while the page is locked.
  */
 int clear_page_dirty_for_io(struct page *page)
@@ -2721,7 +2713,7 @@ int test_clear_page_writeback(struct page *page)
 		xa_lock_irqsave(&mapping->pages, flags);
 		ret = TestClearPageWriteback(page);
 		if (ret) {
-			radix_tree_tag_clear(&mapping->pages, page_index(page),
+			__xa_clear_tag(&mapping->pages, page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi)) {
 				struct bdi_writeback *wb = inode_to_wb(inode);
@@ -2773,7 +2765,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 			on_wblist = mapping_tagged(mapping,
 						   PAGECACHE_TAG_WRITEBACK);
 
-			radix_tree_tag_set(&mapping->pages, page_index(page),
+			__xa_set_tag(&mapping->pages, page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
 			if (bdi_cap_account_writeback(bdi))
 				inc_wb_stat(inode_to_wb(inode), WB_WRITEBACK);
@@ -2787,10 +2779,10 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 				sb_mark_inode_writeback(mapping->host);
 		}
 		if (!PageDirty(page))
-			radix_tree_tag_clear(&mapping->pages, page_index(page),
+			__xa_clear_tag(&mapping->pages, page_index(page),
 						PAGECACHE_TAG_DIRTY);
 		if (!keep_write)
-			radix_tree_tag_clear(&mapping->pages, page_index(page),
+			__xa_clear_tag(&mapping->pages, page_index(page),
 						PAGECACHE_TAG_TOWRITE);
 		xa_unlock_irqrestore(&mapping->pages, flags);
 	} else {
@@ -2806,16 +2798,6 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 }
 EXPORT_SYMBOL(__test_set_page_writeback);
 
-/*
- * Return true if any of the pages in the mapping are marked with the
- * passed tag.
- */
-int mapping_tagged(struct address_space *mapping, int tag)
-{
-	return radix_tree_tagged(&mapping->pages, tag);
-}
-EXPORT_SYMBOL(mapping_tagged);
-
 /**
  * wait_for_stable_page() - wait for writeback to finish, if necessary.
  * @page:	The page to wait on.
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
