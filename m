From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] writeback: cosmetic change in account_page_dirtied()
Date: Tue,  6 Jan 2015 14:29:15 -0500
Message-ID: <1420572557-11572-15-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TfHEp3YNPawasdB4eD9dOogQBtrobkjF880bHClWwxs=;
        b=r1+dxA0bvChimy7LV/nREUk2gMc1o4749vaBXglmTyP4wMdOpGskx3TLD1CWOYRyWs
         as4sp2fmf16QHmip8IXbyWLqZkweZqCWtgFdflp1+8Jy/nchsiLlwr/8K8tms8f9t8T5
         h8pyfQhHeNx4TvMv1UQaIzMtZe64q2YcDD5s4YwLLx8yc3fS1+OUOpaCU0ZwU9Ud9D7J
         G+5yOcteb05u9ymWWxlx+zvKCxEI5jbEGutCTu/5z5XEy8ReDAdG0Yslia+VK6BZmHOp
         jcMeobJRrv3h1FbGgiy3q6VEaRehphToMpjeiCwB6iRHB2yYiNYngfx4wf2Ks0y4XCsV
         JDZQ==
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, Tejun Heo <tj@kernel.org>, Wu Fengguang <fengguang.wu@intel.com>

Flip the polarity of mapping_cap_account_dirty() test so that the body
of page accounting can be moved outside the if () block.  This will
help adding cgroup writeback support.

This causes no logic changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 026c91b..d73539f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2094,15 +2094,16 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	trace_writeback_dirty_page(page, mapping);
 
-	if (mapping_cap_account_dirty(mapping)) {
-		__inc_zone_page_state(page, NR_FILE_DIRTY);
-		__inc_zone_page_state(page, NR_DIRTIED);
-		__inc_wb_stat(&mapping->backing_dev_info->wb, WB_RECLAIMABLE);
-		__inc_wb_stat(&mapping->backing_dev_info->wb, WB_DIRTIED);
-		task_io_account_write(PAGE_CACHE_SIZE);
-		current->nr_dirtied++;
-		this_cpu_inc(bdp_ratelimits);
-	}
+	if (!mapping_cap_account_dirty(mapping))
+		return;
+
+	__inc_zone_page_state(page, NR_FILE_DIRTY);
+	__inc_zone_page_state(page, NR_DIRTIED);
+	__inc_wb_stat(&mapping->backing_dev_info->wb, WB_RECLAIMABLE);
+	__inc_wb_stat(&mapping->backing_dev_info->wb, WB_DIRTIED);
+	task_io_account_write(PAGE_CACHE_SIZE);
+	current->nr_dirtied++;
+	this_cpu_inc(bdp_ratelimits);
 }
 EXPORT_SYMBOL(account_page_dirtied);
 
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
