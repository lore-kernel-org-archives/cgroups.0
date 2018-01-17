From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 46/99] shmem: Convert shmem_add_to_page_cache
 to XArray
Date: Wed, 17 Jan 2018 12:21:10 -0800
Message-ID: <20180117202203.19756-47-willy@infradead.org>
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
 bh=CI6+ICcbAPgkjpBfhyq9h1AbkNo2ZS67PXe5OqCkJMY=; b=gs9EXy9cHs8FgNve4mmnqW7Q/w
 wXbSlyGN4fGHmHxqqXfNj7rtyuv4keSUt4K0CSNc24AOez07mRK+VAwz+sGh9fIquhrwaWutcOJ/i
 rD9FHbmbWGCeBQm5of8X1KUHFkCIGFnPg3y9KE5QpMEMGx8AmgiFG/gbZTXdlUPSMbGE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=CI6+ICcbAPgkjpBfhyq9h1AbkNo2ZS67PXe5OqCkJMY=; b=Bl9669BY7SIFmrPU4IZu6Seb15
 WcV4o2XQkitvzmrtthHVht2hjANoC9Fh0hOiCQHPyHmg1+HdJeHXd3oh/OUhYSGFTcVLRzDYAkkKd
 YiO1ZW45W0TXQh1AbQC6M25xd4man1QneESpVIyeJA1odZz/RUWNfKxhOwbeuXT1NtAY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=CI6+ICcbAPgkjpBfhyq9h1AbkNo2ZS67PXe5OqCkJMY=; b=mIUjrCwXlMr9wLcuz0iUayZju
 +gyupOkDgdS9Jdvz0w5QN+toNF504XyF0v3ZG39cY+Zl3fJ6eI69RnaeXOLO7bOfdQDag6A8U82Ob
 ++0NMYcWZdxblROLZ6OalPG9/dllEjyP6F09jEY6x17gZDCs21bPeMxXBXIs99xGsuypFxowBxekP
 O2ohRyCuWVmFCn3i6VgLBJEAEVIMQVLhDRhg5rgRe9rWjgt08OJ4ID3xZnfTbHFRj8NO2cs6ZT81c
 9YSDNhoA8ZqRAV2SrvrMUq6/TN8ECG7qBY9omBaIB6fW9Ve+znsq2+hUI2OPLZnv5RsgRESyNNy5v
 BtpMmA3IA==;
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

This removes the last caller of radix_tree_maybe_preload_order().
Simpler code, unless we run out of memory for new xa_nodes partway through
inserting entries into the xarray.  Hopefully we can support multi-index
entries in the page cache soon and all the awful code goes away.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 87 ++++++++++++++++++++++++++++----------------------------------
 1 file changed, 39 insertions(+), 48 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e4a2eb1336be..0f49edae05e4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -558,9 +558,10 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
  */
 static int shmem_add_to_page_cache(struct page *page,
 				   struct address_space *mapping,
-				   pgoff_t index, void *expected)
+				   pgoff_t index, void *expected, gfp_t gfp)
 {
-	int error, nr = hpage_nr_pages(page);
+	XA_STATE(xas, &mapping->pages, index);
+	unsigned long i, nr = 1UL << compound_order(page);
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
@@ -569,49 +570,47 @@ static int shmem_add_to_page_cache(struct page *page,
 	VM_BUG_ON(expected && PageTransHuge(page));
 
 	page_ref_add(page, nr);
-	page->mapping = mapping;
 	page->index = index;
+	page->mapping = mapping;
 
-	xa_lock_irq(&mapping->pages);
-	if (PageTransHuge(page)) {
-		void __rcu **results;
-		pgoff_t idx;
-		int i;
-
-		error = 0;
-		if (radix_tree_gang_lookup_slot(&mapping->pages,
-					&results, &idx, index, 1) &&
-				idx < index + HPAGE_PMD_NR) {
-			error = -EEXIST;
+	do {
+		xas_lock_irq(&xas);
+		xas_create_range(&xas, index + nr - 1);
+		if (xas_error(&xas))
+			goto unlock;
+		for (i = 0; i < nr; i++) {
+			void *entry = xas_load(&xas);
+			if (entry != expected)
+				xas_set_err(&xas, -ENOENT);
+			if (xas_error(&xas))
+				goto undo;
+			xas_store(&xas, page + i);
+			xas_next(&xas);
 		}
-
-		if (!error) {
-			for (i = 0; i < HPAGE_PMD_NR; i++) {
-				error = radix_tree_insert(&mapping->pages,
-						index + i, page + i);
-				VM_BUG_ON(error);
-			}
+		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_ALLOC);
+			__inc_node_page_state(page, NR_SHMEM_THPS);
 		}
-	} else if (!expected) {
-		error = radix_tree_insert(&mapping->pages, index, page);
-	} else {
-		error = shmem_xa_replace(mapping, index, expected, page);
-	}
-
-	if (!error) {
 		mapping->nrpages += nr;
-		if (PageTransHuge(page))
-			__inc_node_page_state(page, NR_SHMEM_THPS);
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		__mod_node_page_state(page_pgdat(page), NR_SHMEM, nr);
-		xa_unlock_irq(&mapping->pages);
-	} else {
+		goto unlock;
+undo:
+		while (i-- > 0) {
+			xas_store(&xas, NULL);
+			xas_prev(&xas);
+		}
+unlock:
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, gfp));
+
+	if (xas_error(&xas)) {
 		page->mapping = NULL;
-		xa_unlock_irq(&mapping->pages);
 		page_ref_sub(page, nr);
+		return xas_error(&xas);
 	}
-	return error;
+
+	return 0;
 }
 
 /*
@@ -1159,7 +1158,7 @@ static int shmem_unuse_inode(struct shmem_inode_info *info,
 	 */
 	if (!error)
 		error = shmem_add_to_page_cache(*pagep, mapping, index,
-						radswap);
+						radswap, gfp);
 	if (error != -ENOMEM) {
 		/*
 		 * Truncation and eviction use free_swap_and_cache(), which
@@ -1677,7 +1676,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 				false);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-						swp_to_radix_entry(swap));
+						swp_to_radix_entry(swap), gfp);
 			/*
 			 * We already confirmed swap under page lock, and make
 			 * no memory allocation here, so usually no possibility
@@ -1783,13 +1782,8 @@ alloc_nohuge:		page = shmem_alloc_and_acct_page(gfp, inode,
 				PageTransHuge(page));
 		if (error)
 			goto unacct;
-		error = radix_tree_maybe_preload_order(gfp & GFP_RECLAIM_MASK,
-				compound_order(page));
-		if (!error) {
-			error = shmem_add_to_page_cache(page, mapping, hindex,
-							NULL);
-			radix_tree_preload_end();
-		}
+		error = shmem_add_to_page_cache(page, mapping, hindex,
+						NULL, gfp & GFP_RECLAIM_MASK);
 		if (error) {
 			mem_cgroup_cancel_charge(page, memcg,
 					PageTransHuge(page));
@@ -2256,11 +2250,8 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	if (ret)
 		goto out_release;
 
-	ret = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
-	if (!ret) {
-		ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL);
-		radix_tree_preload_end();
-	}
+	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+						gfp & GFP_RECLAIM_MASK);
 	if (ret)
 		goto out_release_uncharge;
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
