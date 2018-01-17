From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 48/99] shmem: Convert shmem_free_swap to XArray
Date: Wed, 17 Jan 2018 12:21:12 -0800
Message-ID: <20180117202203.19756-49-willy@infradead.org>
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
 bh=gAsKqAbzlPdEL8CQu2IbCd5XNLOOTFlIQ3rDu9U+74Q=; b=Pl0/nBJxXI9XeEdQNQNE08+iDE
 ofKATtoR7lE03zM/1sbJILIGt5rNGBy2iecYlrtblqlZPdMB4QqqHtxF+0xwyaHLfRwGb4H1s5qI/
 gn366CuddO5eBtj2OwwQvD+pQZWOPCdevCIabCmZ+F93okZgrkczDcInAXP31Rnugnu4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gAsKqAbzlPdEL8CQu2IbCd5XNLOOTFlIQ3rDu9U+74Q=; b=klRQujDLZYKC4EwkYMcJ3bZPR3
 lU35HpINc7Byh2FlmrmWdKirGwz6EoblK/35taTvp4h5dqoDNsNWx5ZpIbQAaAVDFmDu3NO9E6Hxx
 Gx2gKt4/YMxDgtxFCS+rqtWnk55q5oJnGZmQO49wpIs6qiNzIemjSIFAWKRmDhhBB11o=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gAsKqAbzlPdEL8CQu2IbCd5XNLOOTFlIQ3rDu9U+74Q=; b=GMVfCuzZbBNVdg4JB06NfIgse
 3UUPrU1E3TkrJhLbjAqrCJWJdkl2p8vgNQTnm8J4C4finQNDiFu+QR+kYr2Wec7IZwvXNk/FE76UH
 nZ7g/t5BFMcuzXQr2SVBhs2sIf3ZlIbb0N08diJC3WwPhwHvGX7qyWDkNGat9XlRoWW6g4fGuZfcr
 eFOf8pL2T1oa/0mEbjhNacmXS4dDKRZFAsjqEs+kfc/ALiW1GLeE/nB9AqvHr7qHdLWL4r4FoUhnJ
 JcnUFvygRly8pqXXFamAnSABcydXi6BeF4wcpA0i/ehCw/xZcQ2q40wqOlv0rWHoR5PLfHYxArEMm
 zC4jdo5gA==;
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

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e8233cb7ab5c..5a2226e06f8c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -635,16 +635,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	void *old;
+	void *old = xa_cmpxchg(&mapping->pages, index, radswap, NULL, 0);
 
-	xa_lock_irq(&mapping->pages);
-	old = radix_tree_delete_item(&mapping->pages, index, radswap);
-	xa_unlock_irq(&mapping->pages);
 	if (old != radswap)
 		return -ENOENT;
 	free_swap_and_cache(radix_to_swp_entry(radswap));
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
