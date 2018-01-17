From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 27/99] page cache: Convert delete_batch to
 XArray
Date: Wed, 17 Jan 2018 12:20:51 -0800
Message-ID: <20180117202203.19756-28-willy@infradead.org>
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
 bh=YCyp/MYO1v2eFw8uoARMmvpkyzwhuRu/zKMe0LeUMMY=; b=MeO8mt6CTHpYG6UK92lhhxScpO
 yTQMpHz0Ksb/al186Jar2C5tr10Yc9ckS+Y4Xv0Vdkwi5+a3yFgWtVK0faK4d+dzsyy+Hyby5EtxY
 U9DePukVaeT3vEd4QEgSHlxIJhkzJaTStPPgR8n4v7dEGib4tmHi6ZI05jigwnYNE9n0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YCyp/MYO1v2eFw8uoARMmvpkyzwhuRu/zKMe0LeUMMY=; b=BojJyhT+eoa0qdJdiDX1iajIHN
 L1kwwBUzxS4aMa4wRTOH7CaBmT9tGNY8WJJQmHKLlSLqBnFZWLgRpetV5FoCNQg486x399w3IEFzO
 sVGryW8dAKTgyzqzOKqE7maym2Y+q4kG38XVeZQohZI6gZ6fcWZurdK+Ati4dHHxHNm4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YCyp/MYO1v2eFw8uoARMmvpkyzwhuRu/zKMe0LeUMMY=; b=bd8pIXNLhHCzWfGxCjC297st6
 dQK+mVvzZyp7yIjU1x57jEx1/ZC+ldpvmYhviCneP71JltQCrWGxxMDAfDSL/whj/J1dwUqpuMRLM
 BBJVq6W25emNyqODRwgZEyk431GQu1XyLLZLU5szoJddASvJ/HZ9U00kBitvP0vwg45PVLgp7gQ7K
 CF9etVv0XI7IcYYJVGXVodv8nVsURyRKoMYMBgFnfo7r/Diz1mhBQqz3BSdaXfE6KqMNG5F+ciUA3
 /8P+e/lGPzpWLIhKI0HI1a0PTTwkqlXlenOvaVjulDmbXr8FQd0aJouuY3JBqPFi4DBmUcJZIi75I
 0kx5ITbGA==;
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

Rename the function from page_cache_tree_delete_batch to just
page_cache_delete_batch.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 317a89df1945..d2a0031d61f5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -276,7 +276,7 @@ void delete_from_page_cache(struct page *page)
 EXPORT_SYMBOL(delete_from_page_cache);
 
 /*
- * page_cache_tree_delete_batch - delete several pages from page cache
+ * page_cache_delete_batch - delete several pages from page cache
  * @mapping: the mapping to which pages belong
  * @pvec: pagevec with pages to delete
  *
@@ -289,23 +289,18 @@ EXPORT_SYMBOL(delete_from_page_cache);
  *
  * The function expects xa_lock to be held.
  */
-static void
-page_cache_tree_delete_batch(struct address_space *mapping,
+static void page_cache_delete_batch(struct address_space *mapping,
 			     struct pagevec *pvec)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, pvec->pages[0]->index);
 	int total_pages = 0;
 	int i = 0, tail_pages = 0;
 	struct page *page;
-	pgoff_t start;
 
-	start = pvec->pages[0]->index;
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
+	mapping_set_update(&xas, mapping);
+	xas_for_each(&xas, page, ULONG_MAX) {
 		if (i >= pagevec_count(pvec) && !tail_pages)
 			break;
-		page = radix_tree_deref_slot_protected(slot,
-						       &mapping->pages.xa_lock);
 		if (xa_is_value(page))
 			continue;
 		if (!tail_pages) {
@@ -314,8 +309,11 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 			 * have our pages locked so they are protected from
 			 * being removed.
 			 */
-			if (page != pvec->pages[i])
+			if (page != pvec->pages[i]) {
+				VM_BUG_ON_PAGE(page->index >
+						pvec->pages[i]->index, page);
 				continue;
+			}
 			WARN_ON_ONCE(!PageLocked(page));
 			if (PageTransHuge(page) && !PageHuge(page))
 				tail_pages = HPAGE_PMD_NR - 1;
@@ -326,11 +324,11 @@ page_cache_tree_delete_batch(struct address_space *mapping,
 			 */
 			i++;
 		} else {
+			VM_BUG_ON_PAGE(page->index + HPAGE_PMD_NR - tail_pages
+					!= pvec->pages[i]->index, page);
 			tail_pages--;
 		}
-		radix_tree_clear_tags(&mapping->pages, iter.node, slot);
-		__radix_tree_replace(&mapping->pages, iter.node, slot, NULL,
-				workingset_lookup_update(mapping));
+		xas_store(&xas, NULL);
 		total_pages++;
 	}
 	mapping->nrpages -= total_pages;
@@ -351,7 +349,7 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 
 		unaccount_page_cache_page(mapping, pvec->pages[i]);
 	}
-	page_cache_tree_delete_batch(mapping, pvec);
+	page_cache_delete_batch(mapping, pvec);
 	xa_unlock_irqrestore(&mapping->pages, flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
