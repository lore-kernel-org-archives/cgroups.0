From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 68/99] vmalloc: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:32 -0800
Message-ID: <20180117202203.19756-69-willy@infradead.org>
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
 bh=p1nKCANnj+NpenPHx5xTQWGs5IuJSDxvO05UkyJDO2c=; b=cTm6zAVCU4gXKYg18/221WE/2X
 EdLmzyuHOmdSlW5RWzjWNPp6o5YDCFMMpHbr24232TKKthZWflZEKD5ra9nvPe5od8ZQXgy6V9JBz
 VPmiJYgA0oyBDjATJ/CxPBIWItAnWcFnn/Q/7BwwqsZ6YfWnwcU7hVtLk3nPw6w822yk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=p1nKCANnj+NpenPHx5xTQWGs5IuJSDxvO05UkyJDO2c=; b=ic+U1xnze+tydBJx2hJ57AEmsL
 TPUZmp78OYI5fUpNRCLKQG8ekc3pSZv9qEBLnGJbWSI+/5Kxmm5NNQDTCk0RJRve4xi5OfFNkp+LE
 Vl5Mp9ohX018dCmE1n/eI0Yfzhh5tkPL4ar6hfJELW1PGVeEeEIWEBhcHU2PBs5yx25g=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=p1nKCANnj+NpenPHx5xTQWGs5IuJSDxvO05UkyJDO2c=; b=CWYgI2D7YgaBoQYajPBP7Jpgk
 S8B86ykiQybmpD5rPRVoJfs7zJVTRXLC1cA6zaWLMBCvg/fCXAgcUU0orhyGFu6buHAas41QK5wxJ
 sTEXeuQgKVR9mmmAekeI+Q+3OBTA1gvucSMym38+tTXwj+Uz7rYSJCaTnstLAJN+ZJK9H7Tjmlo9T
 MAUwsqyn7QZ7sCzrhpS9GDXpx/HKb0Lt6g0mklkeVN+tO6tfVe18ics8vGTrig+S3eKngQbMwWP4K
 ZAdrhV37f1ibaZ5Zd7picZrAvpw0GCkMKKZyixwxt0BYEpIdhwKAW7C6JRXFmCMZZU/CT5gbWhYi5
 vlHy0qv1Q==;
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

The radix tree of vmap blocks is simpler to express as an XArray.
Saves a couple of hundred bytes of text and eliminates a user of the
radix tree preload API.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/vmalloc.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 673942094328..b6c138633592 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,7 +23,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -821,12 +821,11 @@ struct vmap_block {
 static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
- * Radix tree of vmap blocks, indexed by address, to quickly find a vmap block
+ * XArray of vmap blocks, indexed by address, to quickly find a vmap block
  * in the free path. Could get rid of this if we change the API to return a
  * "cookie" from alloc, to be passed to free. But no big deal yet.
  */
-static DEFINE_SPINLOCK(vmap_block_tree_lock);
-static RADIX_TREE(vmap_block_tree, GFP_ATOMIC);
+static DEFINE_XARRAY(vmap_block_tree);
 
 /*
  * We should probably have a fallback mechanism to allocate virtual memory
@@ -865,8 +864,8 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 	struct vmap_block *vb;
 	struct vmap_area *va;
 	unsigned long vb_idx;
-	int node, err;
-	void *vaddr;
+	int node;
+	void *ret, *vaddr;
 
 	node = numa_node_id();
 
@@ -883,13 +882,6 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 		return ERR_CAST(va);
 	}
 
-	err = radix_tree_preload(gfp_mask);
-	if (unlikely(err)) {
-		kfree(vb);
-		free_vmap_area(va);
-		return ERR_PTR(err);
-	}
-
 	vaddr = vmap_block_vaddr(va->va_start, 0);
 	spin_lock_init(&vb->lock);
 	vb->va = va;
@@ -902,11 +894,12 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	err = radix_tree_insert(&vmap_block_tree, vb_idx, vb);
-	spin_unlock(&vmap_block_tree_lock);
-	BUG_ON(err);
-	radix_tree_preload_end();
+	ret = xa_store(&vmap_block_tree, vb_idx, vb, gfp_mask);
+	if (xa_is_err(ret)) {
+		kfree(vb);
+		free_vmap_area(va);
+		return ERR_PTR(xa_err(ret));
+	}
 
 	vbq = &get_cpu_var(vmap_block_queue);
 	spin_lock(&vbq->lock);
@@ -923,9 +916,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	unsigned long vb_idx;
 
 	vb_idx = addr_to_vb_idx(vb->va->va_start);
-	spin_lock(&vmap_block_tree_lock);
-	tmp = radix_tree_delete(&vmap_block_tree, vb_idx);
-	spin_unlock(&vmap_block_tree_lock);
+	tmp = xa_erase(&vmap_block_tree, vb_idx);
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
@@ -1031,7 +1022,6 @@ static void *vb_alloc(unsigned long size, gfp_t gfp_mask)
 static void vb_free(const void *addr, unsigned long size)
 {
 	unsigned long offset;
-	unsigned long vb_idx;
 	unsigned int order;
 	struct vmap_block *vb;
 
@@ -1045,10 +1035,7 @@ static void vb_free(const void *addr, unsigned long size)
 	offset = (unsigned long)addr & (VMAP_BLOCK_SIZE - 1);
 	offset >>= PAGE_SHIFT;
 
-	vb_idx = addr_to_vb_idx((unsigned long)addr);
-	rcu_read_lock();
-	vb = radix_tree_lookup(&vmap_block_tree, vb_idx);
-	rcu_read_unlock();
+	vb = xa_load(&vmap_block_tree, addr_to_vb_idx((unsigned long)addr));
 	BUG_ON(!vb);
 
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
