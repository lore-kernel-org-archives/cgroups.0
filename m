From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 41/99] shmem: Convert replace to XArray
Date: Wed, 17 Jan 2018 12:21:05 -0800
Message-ID: <20180117202203.19756-42-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=ay6KUk7TfNJWncBnPIzG9Ycs/W2xRNBkPYNgt9l3/MA=; b=uw9cbbUhpWrXlnAHslZ4zWGXy
	RqWdq0A/mcP9gF7A/a5l/atLPmaoPzDT8XJpsZFDagvgWTwJEbndo0dAgSLMqASJwzh1z2T16cRM/
	DLIniXKfSoouX4AKT9dhy+O1biaS6wWErvuqq3rt1JeFZggeM/6f9KOcstdMrq81nj7vKN/s/VtMf
	5NRMmmV5q5kh0WjDizrMmi9E86v5YCYBLVsCPTDI3oqmvy/T+NjsVUlkmJXcWbB6X/lqTKDfFM6eo
	9memZWLtkHybJzR9ixmB94QMBxQsSDQTmIeW/Yv+Tikr633JIft/miFSxshLwO27hBgvdn1Ccl1WE
	WqQKPSCKA==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

shmem_radix_tree_replace() is renamed to shmem_xa_replace() and
converted to use the XArray API.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c5731bb954a1..fad6c9e7402e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -321,24 +321,20 @@ void shmem_uncharge(struct inode *inode, long pages)
 }
 
 /*
- * Replace item expected in radix tree by a new item, while holding tree lock.
+ * Replace item expected in xarray by a new item, while holding xa_lock.
  */
-static int shmem_radix_tree_replace(struct address_space *mapping,
+static int shmem_xa_replace(struct address_space *mapping,
 			pgoff_t index, void *expected, void *replacement)
 {
-	struct radix_tree_node *node;
-	void **pslot;
+	XA_STATE(xas, &mapping->pages, index);
 	void *item;
 
 	VM_BUG_ON(!expected);
 	VM_BUG_ON(!replacement);
-	item = __radix_tree_lookup(&mapping->pages, index, &node, &pslot);
-	if (!item)
-		return -ENOENT;
+	item = xas_load(&xas);
 	if (item != expected)
 		return -ENOENT;
-	__radix_tree_replace(&mapping->pages, node, pslot,
-			     replacement, NULL);
+	xas_store(&xas, replacement);
 	return 0;
 }
 
@@ -605,8 +601,7 @@ static int shmem_add_to_page_cache(struct page *page,
 	} else if (!expected) {
 		error = radix_tree_insert(&mapping->pages, index, page);
 	} else {
-		error = shmem_radix_tree_replace(mapping, index, expected,
-								 page);
+		error = shmem_xa_replace(mapping, index, expected, page);
 	}
 
 	if (!error) {
@@ -635,7 +630,7 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 
 	xa_lock_irq(&mapping->pages);
-	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	error = shmem_xa_replace(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_node_page_state(page, NR_FILE_PAGES);
@@ -1550,8 +1545,7 @@ static int shmem_replace_page(struct page **pagep, gfp_t gfp,
 	 * a nice clean interface for us to replace oldpage by newpage there.
 	 */
 	xa_lock_irq(&swap_mapping->pages);
-	error = shmem_radix_tree_replace(swap_mapping, swap_index, oldpage,
-								   newpage);
+	error = shmem_xa_replace(swap_mapping, swap_index, oldpage, newpage);
 	if (!error) {
 		__inc_node_page_state(newpage, NR_FILE_PAGES);
 		__dec_node_page_state(oldpage, NR_FILE_PAGES);
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
