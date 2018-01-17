From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 36/99] mm: Convert page migration to XArray
Date: Wed, 17 Jan 2018 12:21:00 -0800
Message-ID: <20180117202203.19756-37-willy@infradead.org>
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
 bh=YUZ5beZhx/G3vTo3IKyRIyWwXMWVVFAXucGgYHIieJ8=; b=Hze5HiW4rr0yfagm7A3QB5yY28
 050Pn8+ZZk+Uw0tjcZZ5whbEl4QJlF4MHeVqOVq7VeEI+Pm9sBuPblHrfJJj+2cxmN3vMcSCOyu++
 QYtd6UGD3lxp8ox3uXrmgaglj7kCgE0qV9AVPUCkhQdMbm8qxx+xflYYuivJ+cbO8DUk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=YUZ5beZhx/G3vTo3IKyRIyWwXMWVVFAXucGgYHIieJ8=; b=FZ+FjT6CzIKQF3UpVvq0JxU59/
 lglhX02Rou1OGnwQ2Fb/1FH0bkFdQ1shlnCVOT+DjSFVLz0dR9TCKQDoWdE087zNdVNKA+zin25mM
 4OnOzSSLEXTLxX5QvO2Ulei7INANbu3++uTcUKrX/r2IiPoU6erT290V2UtrRnv6AJTg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=YUZ5beZhx/G3vTo3IKyRIyWwXMWVVFAXucGgYHIieJ8=; b=lE/AQN2OOfEQle3HMBn9P1jWK
 NEm1V602I8bsknCwDbwh2UoRLXib4V9rTnK/xmp7j1KC1dQIJ/cDfI/Y5nIfLPpPxVlyW24Pz16z3
 VQPLoCDVj6jF+EjoYSr3uqbzbx7t9/jz+kzTWdhcBbhijzmR2Q6hfwhFqXsIaYZEKqYnfvlZxg2ix
 IrkJzEFlohneFqJytue3AZZqSz29hCmf0NkAAhqOfEiMR96R8E96/MFtqcNZkGtBkqBYdz4dlxEpJ
 b7lvpbJd185lYtFa68d43++a+QqX8j8UIBb1pVvVfiBl1AjaWsSp3m8hnKbKuGikEZWQVOSL3upUK
 eRBWrnYMg==;
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

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/migrate.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 75d19904dd9a..7122fec9b075 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -322,7 +322,7 @@ void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 	page = migration_entry_to_page(entry);
 
 	/*
-	 * Once radix-tree replacement of page migration started, page_count
+	 * Once page cache replacement of page migration started, page_count
 	 * *must* be zero. And, we don't want to call wait_on_page_locked()
 	 * against a page without get_page().
 	 * So, we use get_page_unless_zero(), here. Even failed, page fault
@@ -437,10 +437,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		struct buffer_head *head, enum migrate_mode mode,
 		int extra_count)
 {
+	XA_STATE(xas, &mapping->pages, page_index(page));
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = 1 + extra_count;
-	void **pslot;
 
 	/*
 	 * Device public or private pages have an extra refcount as they are
@@ -466,21 +466,16 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	oldzone = page_zone(page);
 	newzone = page_zone(newpage);
 
-	xa_lock_irq(&mapping->pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->pages,
- 					page_index(page));
+	xas_lock_irq(&xas);
 
 	expected_count += 1 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot,
-					&mapping->pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -494,7 +489,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (mode == MIGRATE_ASYNC && head &&
 			!buffer_migrate_lock_buffers(head, mode)) {
 		page_ref_unfreeze(page, expected_count);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -522,7 +517,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		SetPageDirty(newpage);
 	}
 
-	radix_tree_replace_slot(&mapping->pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	/*
 	 * Drop cache reference from old page by unfreezing
@@ -531,7 +526,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock(&mapping->pages);
+	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
 
 	/*
@@ -571,22 +566,18 @@ EXPORT_SYMBOL(migrate_page_move_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct page *newpage, struct page *page)
 {
+	XA_STATE(xas, &mapping->pages, page_index(page));
 	int expected_count;
-	void **pslot;
-
-	xa_lock_irq(&mapping->pages);
-
-	pslot = radix_tree_lookup_slot(&mapping->pages, page_index(page));
 
+	xas_lock_irq(&xas);
 	expected_count = 2 + page_has_private(page);
-	if (page_count(page) != expected_count ||
-		radix_tree_deref_slot_protected(pslot, &mapping->pages.xa_lock) != page) {
-		xa_unlock_irq(&mapping->pages);
+	if (page_count(page) != expected_count || xas_load(&xas) != page) {
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
 	if (!page_ref_freeze(page, expected_count)) {
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
@@ -595,11 +586,11 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	get_page(newpage);
 
-	radix_tree_replace_slot(&mapping->pages, pslot, newpage);
+	xas_store(&xas, newpage);
 
 	page_ref_unfreeze(page, expected_count - 1);
 
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 
 	return MIGRATEPAGE_SUCCESS;
 }
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
