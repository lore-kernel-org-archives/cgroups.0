From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/51] page_writeback: revive cancel_dirty_page() in a restricted form
Date: Fri, 22 May 2015 17:13:15 -0400
Message-ID: <1432329245-5844-2-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oHI+hB8ZERMHDe//q/qAvIr1JmNDwU2s7jOv3e2jkG8=;
        b=X4xaeo8wIdkjmqeYVu5XUrr/srfHSFWDYs3Icgzrq4CCc2k8afBIOthNhpo5enem2+
         CAXvYNs58Im3FwlPqdT6KYrpJVOxY1+Lo7a/HI977SkqBuWoIL2UiG84G4qUHZjx1Fgv
         LxCMl1Z58rGjRDQ4WinPXG+T2ELlxx2Kp6SNdEBpQsHwaWxRZoSs9cT01sjVKeNwWTFr
         OimT1qpn1o20Or38XuUpFfB2noj0bK63v7isBQCi7R8kOfGkdnSZ/dvwiz+fn8vfsEr8
         CPINBHUbuNMZUhRM49vaPwHWZFh89dpyOSfSOUwf2DoaxvTbh4egEFhOns2WrminUWXY
         CLyw==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

cancel_dirty_page() had some issues and b9ea25152e56 ("page_writeback:
clean up mess around cancel_dirty_page()") replaced it with
account_page_cleaned() which makes the caller responsible for clearing
the dirty bit; unfortunately, the planned changes for cgroup writeback
support requires synchronization between dirty bit manipulation and
stat updates.  While we can open-code such synchronization in each
account_page_cleaned() callsite, that's gonna be unnecessarily awkward
and verbose.

This patch revives cancel_dirty_page() but in a more restricted form.
All it does is TestClearPageDirty() followed by account_page_cleaned()
invocation if the page was dirty.  This helper covers all
account_page_cleaned() usages except for __delete_from_page_cache()
which is a special case anyway and left alone.  As this leaves no
module user for account_page_cleaned(), EXPORT_SYMBOL() is dropped
from it.

This patch just revives cancel_dirty_page() as a trivial wrapper to
replace equivalent usages and doesn't introduce any functional
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 .../lustre/include/linux/lustre_patchless_compat.h |  4 +---
 fs/buffer.c                                        |  4 ++--
 include/linux/mm.h                                 |  1 +
 mm/page-writeback.c                                | 27 ++++++++++++++++------
 mm/truncate.c                                      |  4 +---
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
index d726058..1456278 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
@@ -55,9 +55,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	if (PagePrivate(page))
 		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
 
-	if (TestClearPageDirty(page))
-		account_page_cleaned(page, mapping);
-
+	cancel_dirty_page(page);
 	ClearPageMappedToDisk(page);
 	ll_delete_from_page_cache(page);
 }
diff --git a/fs/buffer.c b/fs/buffer.c
index efd85e0..e776bec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3233,8 +3233,8 @@ int try_to_free_buffers(struct page *page)
 	 * to synchronise against __set_page_dirty_buffers and prevent the
 	 * dirty bit from being lost.
 	 */
-	if (ret && TestClearPageDirty(page))
-		account_page_cleaned(page, mapping);
+	if (ret)
+		cancel_dirty_page(page);
 	spin_unlock(&mapping->private_lock);
 out:
 	if (buffers_to_free) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0755b9f..a83cf3a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1215,6 +1215,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping);
 void account_page_cleaned(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
+void cancel_dirty_page(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
 int get_cmdline(struct task_struct *task, char *buffer, int buflen);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5daf556..227b867 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2112,12 +2112,6 @@ EXPORT_SYMBOL(account_page_dirtied);
 
 /*
  * Helper function for deaccounting dirty page without writeback.
- *
- * Doing this should *normally* only ever be done when a page
- * is truncated, and is not actually mapped anywhere at all. However,
- * fs/buffer.c does this when it notices that somebody has cleaned
- * out all the buffers on a page without actually doing it through
- * the VM. Can you say "ext3 is horribly ugly"? Thought you could.
  */
 void account_page_cleaned(struct page *page, struct address_space *mapping)
 {
@@ -2127,7 +2121,6 @@ void account_page_cleaned(struct page *page, struct address_space *mapping)
 		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
 	}
 }
-EXPORT_SYMBOL(account_page_cleaned);
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
@@ -2266,6 +2259,26 @@ int set_page_dirty_lock(struct page *page)
 EXPORT_SYMBOL(set_page_dirty_lock);
 
 /*
+ * This cancels just the dirty bit on the kernel page itself, it does NOT
+ * actually remove dirty bits on any mmap's that may be around. It also
+ * leaves the page tagged dirty, so any sync activity will still find it on
+ * the dirty lists, and in particular, clear_page_dirty_for_io() will still
+ * look at the dirty bits in the VM.
+ *
+ * Doing this should *normally* only ever be done when a page is truncated,
+ * and is not actually mapped anywhere at all. However, fs/buffer.c does
+ * this when it notices that somebody has cleaned out all the buffers on a
+ * page without actually doing it through the VM. Can you say "ext3 is
+ * horribly ugly"? Thought you could.
+ */
+void cancel_dirty_page(struct page *page)
+{
+	if (TestClearPageDirty(page))
+		account_page_cleaned(page, page_mapping(page));
+}
+EXPORT_SYMBOL(cancel_dirty_page);
+
+/*
  * Clear a page's dirty flag, while caring for dirty memory accounting.
  * Returns true if the page was previously dirty.
  *
diff --git a/mm/truncate.c b/mm/truncate.c
index 66af903..0c36025 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -116,9 +116,7 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	 * the VM has canceled the dirty bit (eg ext3 journaling).
 	 * Hence dirty accounting check is placed after invalidation.
 	 */
-	if (TestClearPageDirty(page))
-		account_page_cleaned(page, mapping);
-
+	cancel_dirty_page(page);
 	ClearPageMappedToDisk(page);
 	delete_from_page_cache(page);
 	return 0;
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
