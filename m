From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 37/99] mm: Convert huge_memory to XArray
Date: Wed, 17 Jan 2018 12:21:01 -0800
Message-ID: <20180117202203.19756-38-willy@infradead.org>
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
 bh=rAYa1YOy3vh7kOTS6KP7uHSLmuSyisoLLvfiQIO0r+A=; b=Lf/hUmHrB4tu2qAmmLy7h/yQOc
 pLHOV3VXOAvsvXmZCzEEEscIQH7W8IJKGrBMKgoIhQvb1PvUSV5YTxb3N1nSkDpeg3+6JNlhBC4aq
 Fc2LdFWDVFrnLmNxTAt1IZ/DYU9hlD8rIrCaNo2uzf5RrTMIPqXLBnKsN8KNXBOW4IyA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rAYa1YOy3vh7kOTS6KP7uHSLmuSyisoLLvfiQIO0r+A=; b=PPNRwlWBr0Mf6OyAKSY2mRNX1t
 X2dkj4GlsTwhMQNjkfvoJy+wLhkSygtdYFW3kHJ5qwi1gZj2eAdZTXFl6pb6ynMWlvWvfgEyTXPu7
 yVB2gYDq3ChBVpTBmH7HqmJhxr1MmH4LhSero60f/HiDU+F3yDHt2Qna5AGMXqsa/a+Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rAYa1YOy3vh7kOTS6KP7uHSLmuSyisoLLvfiQIO0r+A=; b=WiF0JYXgFZMjryAe/3z5+0uYv
 RA5fGTFVd/NwesfIx1Jxvnkqwe055rmNTTuoeMpcTk5avcDc2ST7bULC+FPQ6MzRExHuzs3jNGTgZ
 WByecIHkc2LpqfYZxYnWJnjbnMxiGh75Llr8ttDSzbyAN8SLrzDWaBTgZP6HfEriNe5hOaRb31mlD
 xTd3WnnxofFX/Ji7sitReDZuEUrXuyhi4ViMFrL1spQg8XhiXHayeyUn0XS8tczjngdKwAUjWblwe
 jfPxZLURc8Yarf8BDfjFfn4Tbh2iggPNNULilg8Y6Ou+IO0t6skNpIU5Ty3AsEe0Sy3tW5GDmsoVP
 oF6WgMBdw==;
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

Quite a straightforward conversion.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/huge_memory.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f71dd3e7d8cd..5c275295bbd3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2379,7 +2379,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 	if (PageAnon(head) && !PageSwapCache(head)) {
 		page_ref_inc(page_tail);
 	} else {
-		/* Additional pin to radix tree */
+		/* Additional pin to page cache */
 		page_ref_add(page_tail, 2);
 	}
 
@@ -2450,13 +2450,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	ClearPageCompound(head);
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
-		/* Additional pin to radix tree of swap cache */
+		/* Additional pin to swap cache */
 		if (PageSwapCache(head))
 			page_ref_add(head, 2);
 		else
 			page_ref_inc(head);
 	} else {
-		/* Additional pin to radix tree */
+		/* Additional pin to page cache */
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->pages);
 	}
@@ -2568,7 +2568,7 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
 	int extra_pins;
 
-	/* Additional pins from radix tree */
+	/* Additional pins from page cache */
 	if (PageAnon(page))
 		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 	else
@@ -2664,17 +2664,14 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	spin_lock_irqsave(zone_lru_lock(page_zone(head)), flags);
 
 	if (mapping) {
-		void **pslot;
+		XA_STATE(xas, &mapping->pages, page_index(head));
 
-		xa_lock(&mapping->pages);
-		pslot = radix_tree_lookup_slot(&mapping->pages,
-				page_index(head));
 		/*
-		 * Check if the head page is present in radix tree.
+		 * Check if the head page is present in page cache.
 		 * We assume all tail are present too, if head is there.
 		 */
-		if (radix_tree_deref_slot_protected(pslot,
-					&mapping->pages.xa_lock) != head)
+		xa_lock(&mapping->pages);
+		if (xas_load(&xas) != head)
 			goto fail;
 	}
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
