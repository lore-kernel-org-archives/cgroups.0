From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 58/99] dax: Convert lock_slot to XArray
Date: Wed, 17 Jan 2018 12:21:22 -0800
Message-ID: <20180117202203.19756-59-willy@infradead.org>
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
 bh=mrrq/sfPinHqr6MdRb1bdi0dlRFnUXknv+z9x35uuHc=; b=m/PV+SNN0gR3AbvDRh1HkH/LJL
 I9iooEiJzyikcTyE7zN5p15SCO+UWGb4syON5+k5TYgu3dBVabEu3zwpaXLe9LbwvTP3d9720977x
 YtA1TCnwZRd/H27mpfIFq/TxW6BXYI0pBJrZNX4hT/0TqcN1Ge06ASa2rvF5btG+b4Ow=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=mrrq/sfPinHqr6MdRb1bdi0dlRFnUXknv+z9x35uuHc=; b=YxDz0Otqa+KCC4l5JIwChNTUci
 Y7iGAFCMx7cPrlWOPTNz57/v+y0XrWzrzAvhWVFKV2dYeeqWZVNjDT2jApOB1yIgGya5kBBeTJDU0
 o5Qj2J4Q5nnzErHmciM3L6EtsUU0JvQ5U0bFsHMWZxptkys+OUt0YQhnbrCv0svOk/rQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=mrrq/sfPinHqr6MdRb1bdi0dlRFnUXknv+z9x35uuHc=; b=SGg8S7MmvpMzFowhsUmc2Z8Ob
 EqG3CvWP4cEQHP8xzqMr72qPDjBTkZiCKdBCfbd+Cr8kX6x0QwEo0NAYJxaMcRTx6+R4lC1lLO/sa
 U/brPvyp1kcb5TFjC9oHEwAjErdnUnTkWoKQGqaozRU9EJkvsS8lfTXGljMT6xbMFiHT44CwThpRY
 Y11LUSXcpD+Xn7BHT9DxYB14Wm3OYVh8Cw4E60YdLwfjgFXyYsRsQkdo0eIqV2qWBjCvLvbF30vmx
 +mMJI6Gz0P2E1HZKHLPQQgyipwAsyzEz5lYJA/4BGD0NJnlv33R3+dmi61luU+B06+1cTTzpa8bV/
 cEsPKLtIA==;
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
 fs/dax.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f3463d93a6ce..8eab0b56f7f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -188,12 +188,11 @@ static void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 /*
  * Mark the given slot as locked.  Must be called with xa_lock held.
  */
-static inline void *lock_slot(struct address_space *mapping, void **slot)
+static inline void *lock_slot(struct xa_state *xas)
 {
-	unsigned long v = xa_to_value(
-		radix_tree_deref_slot_protected(slot, &mapping->pages.xa_lock));
+	unsigned long v = xa_to_value(xas_load(xas));
 	void *entry = xa_mk_value(v | DAX_ENTRY_LOCK);
-	radix_tree_replace_slot(&mapping->pages, slot, entry);
+	xas_store(xas, entry);
 	return entry;
 }
 
@@ -244,7 +243,7 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
 
 	xas_lock_irq(&xas);
 	entry = xas_load(&xas);
-	if (WARN_ON_ONCE(!entry || !xa_is_value(entry) || !dax_locked(entry))) {
+	if (WARN_ON_ONCE(!xa_is_value(entry) || !dax_locked(entry))) {
 		xas_unlock_irq(&xas);
 		return;
 	}
@@ -303,6 +302,7 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		unsigned long size_flag)
 {
+	XA_STATE(xas, &mapping->pages, index);
 	bool pmd_downgrade = false; /* splitting 2MiB entry into 4k entries? */
 	void *entry, **slot;
 
@@ -341,7 +341,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 			 * Make sure 'entry' remains valid while we drop
 			 * xa_lock.
 			 */
-			entry = lock_slot(mapping, slot);
+			entry = lock_slot(&xas);
 		}
 
 		xa_unlock_irq(&mapping->pages);
@@ -408,7 +408,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		xa_unlock_irq(&mapping->pages);
 		return entry;
 	}
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
  out_unlock:
 	xa_unlock_irq(&mapping->pages);
 	return entry;
@@ -639,6 +639,7 @@ static int dax_writeback_one(struct block_device *bdev,
 		pgoff_t index, void *entry)
 {
 	struct radix_tree_root *pages = &mapping->pages;
+	XA_STATE(xas, pages, index);
 	void *entry2, **slot, *kaddr;
 	long ret = 0, id;
 	sector_t sector;
@@ -675,7 +676,7 @@ static int dax_writeback_one(struct block_device *bdev,
 	if (!radix_tree_tag_get(pages, index, PAGECACHE_TAG_TOWRITE))
 		goto put_unlocked;
 	/* Lock the entry to serialize with page faults */
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
 	/*
 	 * We can clear the tag now but we have to be careful so that concurrent
 	 * dax_writeback_one() calls for the same index cannot finish before we
@@ -1500,8 +1501,9 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 				  pfn_t pfn)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	void *entry, **slot;
 	pgoff_t index = vmf->pgoff;
+	XA_STATE(xas, &mapping->pages, index);
+	void *entry, **slot;
 	int vmf_ret, error;
 
 	xa_lock_irq(&mapping->pages);
@@ -1517,7 +1519,7 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 		return VM_FAULT_NOPAGE;
 	}
 	radix_tree_tag_set(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
-	entry = lock_slot(mapping, slot);
+	entry = lock_slot(&xas);
 	xa_unlock_irq(&mapping->pages);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
