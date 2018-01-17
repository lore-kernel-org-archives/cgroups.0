From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 69/99] brd: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:33 -0800
Message-ID: <20180117202203.19756-70-willy@infradead.org>
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
 bh=r1Akuhbdl0teZZbCCxOt80TOgcqoxMXID+sOxJvEPeg=; b=b7AWtEdwKE1FdQE3rCoJHuLadF
 1qO0+90qUAT9ExpdhYBQ18mYgRM9hbEz4LRz6zHdXJBQ7m7CDbLWxlgTBPXX26rJgSmDY4ergLaTR
 4TloYxotiHmHn3NX4hAFBzlHFG7EcGzE7AUlmF8zcb3/Dzc1OtYMdhVLXVwPevM+jfTs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=r1Akuhbdl0teZZbCCxOt80TOgcqoxMXID+sOxJvEPeg=; b=KaI2V/fPSV2qJMM9mOFy01Dg9/
 XuCg95Zqf6Hb8TA1dWKIEm7Q5yCnymbv3Ad3Opfbl6Lumsw3twy5cY8FN3wXUfMJ7I5J2++MLc4DS
 b8c+rM0xQahRE07GIQc2xGTjsw01xTKEojJGXkDxsi7zs/uKo4I1/DTnbj2PShNYxVzE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=r1Akuhbdl0teZZbCCxOt80TOgcqoxMXID+sOxJvEPeg=; b=SElaJoooYCCQiUMGRz2tf66rF
 DPtHwlYz8GPBtNYLi3vAueXXnSh9G+crUlrGSr405pniebN8uh8hDs9VZE2EYaapuDx+V2bVvQpNG
 OwXiR+fHmN5qNsCp70z35OnlTGtgWH2bazx1g2d8SQqhktK7kmt2wNIFNR3yBfrlNV8fMhrM6oNZ2
 HYl2DG8gd27t5A7lrBvWeKEhzI4gh79BE2cYUUMPXm8xM8YbeyDbveEujZKZp0Wq1MP05Rc06tF16
 zgrL+yiTQYoeyPZQomfTrKK0GaBB8rWF+tOsFf6jsETMo/BZeVdWgbc7SAzBjWIsuphMZa48X4NII
 zzZS6XE4Q==;
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

Convert brd_pages from a radix tree to an XArray.  Simpler and smaller
code; in particular another user of radix_tree_preload is eliminated.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/block/brd.c | 93 ++++++++++++++++-------------------------------------
 1 file changed, 28 insertions(+), 65 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 8028a3a7e7fd..59a1af7aaa79 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -17,7 +17,7 @@
 #include <linux/bio.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
@@ -29,9 +29,9 @@
 #define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
 
 /*
- * Each block ramdisk device has a radix_tree brd_pages of pages that stores
- * the pages containing the block device's contents. A brd page's ->index is
- * its offset in PAGE_SIZE units. This is similar to, but in no way connected
+ * Each block ramdisk device has an xarray brd_pages that stores the pages
+ * containing the block device's contents. A brd page's ->index is its
+ * offset in PAGE_SIZE units. This is similar to, but in no way connected
  * with, the kernel's pagecache or buffer cache (which sit above our block
  * device).
  */
@@ -41,13 +41,7 @@ struct brd_device {
 	struct request_queue	*brd_queue;
 	struct gendisk		*brd_disk;
 	struct list_head	brd_list;
-
-	/*
-	 * Backing store of pages and lock to protect it. This is the contents
-	 * of the block device.
-	 */
-	spinlock_t		brd_lock;
-	struct radix_tree_root	brd_pages;
+	struct xarray		brd_pages;
 };
 
 /*
@@ -62,17 +56,9 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 	 * The page lifetime is protected by the fact that we have opened the
 	 * device node -- brd pages will never be deleted under us, so we
 	 * don't need any further locking or refcounting.
-	 *
-	 * This is strictly true for the radix-tree nodes as well (ie. we
-	 * don't actually need the rcu_read_lock()), however that is not a
-	 * documented feature of the radix-tree API so it is better to be
-	 * safe here (we don't have total exclusion from radix tree updates
-	 * here, only deletes).
 	 */
-	rcu_read_lock();
 	idx = sector >> PAGE_SECTORS_SHIFT; /* sector to page index */
-	page = radix_tree_lookup(&brd->brd_pages, idx);
-	rcu_read_unlock();
+	page = xa_load(&brd->brd_pages, idx);
 
 	BUG_ON(page && page->index != idx);
 
@@ -87,7 +73,7 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
-	struct page *page;
+	struct page *curr, *page;
 	gfp_t gfp_flags;
 
 	page = brd_lookup_page(brd, sector);
@@ -108,62 +94,40 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	if (!page)
 		return NULL;
 
-	if (radix_tree_preload(GFP_NOIO)) {
-		__free_page(page);
-		return NULL;
-	}
-
-	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
 	page->index = idx;
-	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
+	curr = xa_cmpxchg(&brd->brd_pages, idx, NULL, page, GFP_NOIO);
+	if (curr) {
 		__free_page(page);
-		page = radix_tree_lookup(&brd->brd_pages, idx);
-		BUG_ON(!page);
-		BUG_ON(page->index != idx);
+		if (xa_err(curr)) {
+			page = NULL;
+		} else {
+			page = curr;
+			BUG_ON(!page);
+			BUG_ON(page->index != idx);
+		}
 	}
-	spin_unlock(&brd->brd_lock);
-
-	radix_tree_preload_end();
 
 	return page;
 }
 
 /*
- * Free all backing store pages and radix tree. This must only be called when
+ * Free all backing store pages and xarray.  This must only be called when
  * there are no other users of the device.
  */
-#define FREE_BATCH 16
 static void brd_free_pages(struct brd_device *brd)
 {
-	unsigned long pos = 0;
-	struct page *pages[FREE_BATCH];
-	int nr_pages;
-
-	do {
-		int i;
-
-		nr_pages = radix_tree_gang_lookup(&brd->brd_pages,
-				(void **)pages, pos, FREE_BATCH);
-
-		for (i = 0; i < nr_pages; i++) {
-			void *ret;
-
-			BUG_ON(pages[i]->index < pos);
-			pos = pages[i]->index;
-			ret = radix_tree_delete(&brd->brd_pages, pos);
-			BUG_ON(!ret || ret != pages[i]);
-			__free_page(pages[i]);
-		}
-
-		pos++;
+	XA_STATE(xas, &brd->brd_pages, 0);
+	struct page *page;
 
-		/*
-		 * This assumes radix_tree_gang_lookup always returns as
-		 * many pages as possible. If the radix-tree code changes,
-		 * so will this have to.
-		 */
-	} while (nr_pages == FREE_BATCH);
+	/* lockdep can't know there are no other users */
+	xas_lock(&xas);
+	xas_for_each(&xas, page, ULONG_MAX) {
+		BUG_ON(page->index != xas.xa_index);
+		__free_page(page);
+		xas_store(&xas, NULL);
+	}
+	xas_unlock(&xas);
 }
 
 /*
@@ -373,8 +337,7 @@ static struct brd_device *brd_alloc(int i)
 	if (!brd)
 		goto out;
 	brd->brd_number		= i;
-	spin_lock_init(&brd->brd_lock);
-	INIT_RADIX_TREE(&brd->brd_pages, GFP_ATOMIC);
+	xa_init(&brd->brd_pages);
 
 	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!brd->brd_queue)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
