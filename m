From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] truncate: swap the order of conditionals in cancel_dirty_page()
Date: Mon, 23 Mar 2015 01:25:40 -0400
Message-ID: <1427088344-17542-5-git-send-email-tj@kernel.org>
References: <1427088344-17542-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XIE4FVe2H8S45swvNfExAqLvz37ujlD5XGkr2UOGOUA=;
        b=XZEvsMZ6VQceZwpUcqZw9RUUV7wG1ba4zO6yYXZKHgd1pTB1iYt4s8t5IRJEHLdI3h
         gbnwLHcr5pF/evdG1NGRn18zLosMVua29PUIU53OC5WzK+KsJ2p8P0Kq5+4vn+GL0U80
         di/IAP0JxP+IzTsnWtL+sWQM8fOE8rwjlnKgJHxXGhh0+sIs1oL6J7FU2v5+ge2w4PES
         HaltFU3oQ5RPxb5T4VT2sdYAMYGU6elQbPvar7RNLZOutCbrWltFij3FGaQVJJOQKFLM
         H1mr1/osus994QZUqQxDZuCdD57II7/c9A+/LGWTYqTsSmku3Cd12kJyvDd+c3n2gpi0
         Impw==
In-Reply-To: <1427088344-17542-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

cancel_dirty_page() currently performs TestClearPageDirty() and then
tests whether the mapping exists and has cap_account_dirty.  This
patch swaps the order so that it performs the mapping tests first.

If the mapping tests fail, the dirty is cleared with ClearPageDirty().
The order or the conditionals is swapped but the end result is the
same.  This will help inode foreign cgroup wb switching.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 mm/truncate.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index fe2d769..9d40cd4 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -108,13 +108,13 @@ void do_invalidatepage(struct page *page, unsigned int offset,
  */
 void cancel_dirty_page(struct page *page, unsigned int account_size)
 {
-	struct mem_cgroup *memcg;
+	struct address_space *mapping = page->mapping;
 
-	memcg = mem_cgroup_begin_page_stat(page);
-	if (TestClearPageDirty(page)) {
-		struct address_space *mapping = page->mapping;
+	if (mapping && mapping_cap_account_dirty(mapping)) {
+		struct mem_cgroup *memcg;
 
-		if (mapping && mapping_cap_account_dirty(mapping)) {
+		memcg = mem_cgroup_begin_page_stat(page);
+		if (TestClearPageDirty(page)) {
 			struct bdi_writeback *wb = inode_to_wb(mapping->host);
 
 			mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
@@ -123,8 +123,10 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
+		mem_cgroup_end_page_stat(memcg);
+	} else {
+		ClearPageDirty(page);
 	}
-	mem_cgroup_end_page_stat(memcg);
 }
 EXPORT_SYMBOL(cancel_dirty_page);
 
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
