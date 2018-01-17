From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 32/99] mm: Convert truncate to XArray
Date: Wed, 17 Jan 2018 12:20:56 -0800
Message-ID: <20180117202203.19756-33-willy@infradead.org>
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
 bh=z2wUjX53zsGmPoUiEiA7zW7Pqnae/hfF/ikw47JMqAo=; b=D+ZLr8vBjQEG3R8Wzczs4DPPYo
 q+QA7qBAIwAWOe9/Q1LCsC/Ve4IB656GUvzliAr2T/1O9954OqDU8FUQ/eqmvz5N0tYwuZRkUgHng
 f8unuxSVPtBFT+DmeBnf3+IfQwSG0Cku8of8aqzB4VJ7iybSjhbX9SQfV5LK91ouQTqw=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=z2wUjX53zsGmPoUiEiA7zW7Pqnae/hfF/ikw47JMqAo=; b=XNy5y1QFIVfRz782gjzXf1ksVx
 7kSOI/qBG+0B61WnnKhLAaaSrjUMAGp5FznDdZnKZlW/kDavrWQSM+uZU0wi3Z9v5Sxo7up6G8XoY
 hrbD812rO/49zPdlX7potu6yqQMNDJSgp0uLmSQJiTlYWrKXyN8yDmeSsT638wevu0V4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=z2wUjX53zsGmPoUiEiA7zW7Pqnae/hfF/ikw47JMqAo=; b=UVVbNfS46+4TSAeJMR4tkZdgE
 krd6cgrrD1lXZpmRTUAdmhCMqYiX5NGj7cNteCRp1Ui78W8Lfkq1/OnIgXX9nxY6wUphK66CWkscl
 bh0oTMgVheB0L38kjfA0rOMyf4aeWgGe8hlk6Xpn0tWx7Fx3D8Dbsi60BhuYgbRHe8lryJAemmu7z
 R1vs+bqmqrTDE1lL1RAXHGcXIm/pPaEEcCpDYn2QOE4cSMRAU1alZ8GN8WlMmoGXkV5SomzOL9Os4
 ooqetvxaMiuGrfQFMks+D9AKJw5orOz5JvuGsPx715I2CxYVi9+oHzZ0hEcX527A7ARQhjIT/PoH/
 aIM7o6ZhQ==;
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

This is essentially xa_cmpxchg() with the locking handled above us,
and it doesn't have to handle replacing a NULL entry.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/truncate.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 69bb743dd7e5..70323c347298 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -33,15 +33,12 @@
 static inline void __clear_shadow_entry(struct address_space *mapping,
 				pgoff_t index, void *entry)
 {
-	struct radix_tree_node *node;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, index);
 
-	if (!__radix_tree_lookup(&mapping->pages, index, &node, &slot))
+	xas_set_update(&xas, workingset_update_node);
+	if (xas_load(&xas) != entry)
 		return;
-	if (*slot != entry)
-		return;
-	__radix_tree_replace(&mapping->pages, node, slot, NULL,
-			     workingset_update_node);
+	xas_store(&xas, NULL);
 	mapping->nrexceptional--;
 }
 
@@ -746,10 +743,10 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		index++;
 	}
 	/*
-	 * For DAX we invalidate page tables after invalidating radix tree.  We
+	 * For DAX we invalidate page tables after invalidating page cache.  We
 	 * could invalidate page tables while invalidating each entry however
 	 * that would be expensive. And doing range unmapping before doesn't
-	 * work as we have no cheap way to find whether radix tree entry didn't
+	 * work as we have no cheap way to find whether page cache entry didn't
 	 * get remapped later.
 	 */
 	if (dax_mapping(mapping)) {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
