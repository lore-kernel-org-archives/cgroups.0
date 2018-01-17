From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 54/99] nilfs2: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:18 -0800
Message-ID: <20180117202203.19756-55-willy@infradead.org>
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
 bh=F/Hnj8kvYaykj3i37anX56d7f76QWBnAUFP09kA4Ex8=; b=eyNC6H6iorpa0EMfEfL7Opu2Zk
 SmaJvUxyPtEE1WpKGDJHq0UZpoTa9hkfovxJTfc3RL2Ppuf4PALkwhOq1GV4jYaEIbjo+yL3tjE4g
 lQunzUtwqcOA//5JCGqX7wN4d/1FOBFn6n+D9NpzMNU/gQ6KGauaAPVz0Lt5J+c37TME=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=F/Hnj8kvYaykj3i37anX56d7f76QWBnAUFP09kA4Ex8=; b=kfvu9a0TQwqsHa/u0NKFpQLcJ4
 /OuVOekbNfL07VRvIzsCeuX1W5ldoke/6ZKd7TICThiUvB4O2Lcjtvr9scddK51E4FK6aQTSXg6zs
 Y126YoN6XueXSpMFSLLu6ZUYfi6hf1ln+qGBS/zKOkOneJyo58T7FeiiYAJ65VZdPAWA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=F/Hnj8kvYaykj3i37anX56d7f76QWBnAUFP09kA4Ex8=; b=dkMlDouttD6zErHXJhFYAqPCe
 ORdifOyigFnz4o7fvUPk+rFK+YIc73LhpYm6tqzDie7lGDLj6A50sRVQTDcMmvrIzNGglj5TMqHPJ
 jghV7Fd6+VgvN+oJcggZrPYFOTnkq/2Mg14c/CFn0qWrguPMKK/Laas7kwAdQFX2QI/36KPWOzsGv
 KE2jUMcUcc1RAr6LRcMy6Ow5LeDwvbM/sr2R4kng+bLK+1oeqgeqqPaKNtxGyhCTsGBc6ZvLE1lWn
 D27u4+02W3reJJcPjRuPd0xw32M1gFzdLmNAiygD07bLc/g/2rzlJiZymSSwEf++LyNHCG5uyk/ap
 8uppGsMFQ==;
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

I'm not 100% convinced that the rewrite of nilfs_copy_back_pages is
correct, but it will at least have different bugs from the current
version.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/nilfs2/btnode.c | 37 +++++++++++-----------------
 fs/nilfs2/page.c   | 72 +++++++++++++++++++++++++++++++-----------------------
 2 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 9e2a00207436..b5997e8c5441 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -177,42 +177,36 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 	ctxt->newbh = NULL;
 
 	if (inode->i_blkbits == PAGE_SHIFT) {
-		lock_page(obh->b_page);
-		/*
-		 * We cannot call radix_tree_preload for the kernels older
-		 * than 2.6.23, because it is not exported for modules.
-		 */
+		void *entry;
+		struct page *opage = obh->b_page;
+		lock_page(opage);
 retry:
-		err = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
-		if (err)
-			goto failed_unlock;
 		/* BUG_ON(oldkey != obh->b_page->index); */
-		if (unlikely(oldkey != obh->b_page->index))
-			NILFS_PAGE_BUG(obh->b_page,
+		if (unlikely(oldkey != opage->index))
+			NILFS_PAGE_BUG(opage,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
 
-		xa_lock_irq(&btnc->pages);
-		err = radix_tree_insert(&btnc->pages, newkey, obh->b_page);
-		xa_unlock_irq(&btnc->pages);
+		entry = xa_cmpxchg(&btnc->pages, newkey, NULL, opage, GFP_NOFS);
 		/*
 		 * Note: page->index will not change to newkey until
 		 * nilfs_btnode_commit_change_key() will be called.
 		 * To protect the page in intermediate state, the page lock
 		 * is held.
 		 */
-		radix_tree_preload_end();
-		if (!err)
+		if (!entry)
 			return 0;
-		else if (err != -EEXIST)
+		if (xa_is_err(entry)) {
+			err = xa_err(entry);
 			goto failed_unlock;
+		}
 
 		err = invalidate_inode_pages2_range(btnc, newkey, newkey);
 		if (!err)
 			goto retry;
 		/* fallback to copy mode */
-		unlock_page(obh->b_page);
+		unlock_page(opage);
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
@@ -252,9 +246,8 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 		mark_buffer_dirty(obh);
 
 		xa_lock_irq(&btnc->pages);
-		radix_tree_delete(&btnc->pages, oldkey);
-		radix_tree_tag_set(&btnc->pages, newkey,
-				   PAGECACHE_TAG_DIRTY);
+		__xa_erase(&btnc->pages, oldkey);
+		__xa_set_tag(&btnc->pages, newkey, PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&btnc->pages);
 
 		opage->index = obh->b_blocknr = newkey;
@@ -283,9 +276,7 @@ void nilfs_btnode_abort_change_key(struct address_space *btnc,
 		return;
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
-		xa_lock_irq(&btnc->pages);
-		radix_tree_delete(&btnc->pages, newkey);
-		xa_unlock_irq(&btnc->pages);
+		xa_erase(&btnc->pages, newkey);
 		unlock_page(ctxt->bh->b_page);
 	} else
 		brelse(nbh);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 1c6703efde9e..31d20f624971 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -304,10 +304,10 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 void nilfs_copy_back_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	XA_STATE(xas, &dmap->pages, 0);
 	struct pagevec pvec;
 	unsigned int i, n;
 	pgoff_t index = 0;
-	int err;
 
 	pagevec_init(&pvec);
 repeat:
@@ -317,43 +317,56 @@ void nilfs_copy_back_pages(struct address_space *dmap,
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct page *page = pvec.pages[i], *dpage;
-		pgoff_t offset = page->index;
+		xas_set(&xas, page->index);
 
 		lock_page(page);
-		dpage = find_lock_page(dmap, offset);
+		do {
+			xas_lock_irq(&xas);
+			dpage = xas_create(&xas);
+			if (!xas_error(&xas))
+				break;
+			xas_unlock_irq(&xas);
+			if (!xas_nomem(&xas, GFP_NOFS)) {
+				unlock_page(page);
+				/*
+				 * Callers have a touching faith that this
+				 * function cannot fail.  Just leak the page.
+				 * Other pages may be salvagable if the
+				 * xarray doesn't need to allocate memory
+				 * to store them.
+				 */
+				WARN_ON(1);
+				page->mapping = NULL;
+				put_page(page);
+				goto shadow_remove;
+			}
+		} while (1);
+
 		if (dpage) {
-			/* override existing page on the destination cache */
+			get_page(dpage);
+			xas_unlock_irq(&xas);
+			lock_page(dpage);
+			/* override existing page in the destination cache */
 			WARN_ON(PageDirty(dpage));
 			nilfs_copy_page(dpage, page, 0);
 			unlock_page(dpage);
 			put_page(dpage);
 		} else {
-			struct page *page2;
-
-			/* move the page to the destination cache */
-			xa_lock_irq(&smap->pages);
-			page2 = radix_tree_delete(&smap->pages, offset);
-			WARN_ON(page2 != page);
-
-			smap->nrpages--;
-			xa_unlock_irq(&smap->pages);
-
-			xa_lock_irq(&dmap->pages);
-			err = radix_tree_insert(&dmap->pages, offset, page);
-			if (unlikely(err < 0)) {
-				WARN_ON(err == -EEXIST);
-				page->mapping = NULL;
-				put_page(page); /* for cache */
-			} else {
-				page->mapping = dmap;
-				dmap->nrpages++;
-				if (PageDirty(page))
-					radix_tree_tag_set(&dmap->pages,
-							   offset,
-							   PAGECACHE_TAG_DIRTY);
-			}
+			xas_store(&xas, page);
+			page->mapping = dmap;
+			dmap->nrpages++;
+			if (PageDirty(page))
+				xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&dmap->pages);
 		}
+
+shadow_remove:
+		/* remove the page from the shadow cache */
+		xa_lock_irq(&smap->pages);
+		WARN_ON(__xa_erase(&smap->pages, xas.xa_index) != page);
+		smap->nrpages--;
+		xa_unlock_irq(&smap->pages);
+
 		unlock_page(page);
 	}
 	pagevec_release(&pvec);
@@ -476,8 +489,7 @@ int __nilfs_clear_page_dirty(struct page *page)
 	if (mapping) {
 		xa_lock_irq(&mapping->pages);
 		if (test_bit(PG_dirty, &page->flags)) {
-			radix_tree_tag_clear(&mapping->pages,
-					     page_index(page),
+			__xa_clear_tag(&mapping->pages, page_index(page),
 					     PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&mapping->pages);
 			return clear_page_dirty_for_io(page);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
