From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 36/48] writeback: make laptop_mode_timer_fn() handle multiple bdi_writeback's
Date: Mon, 23 Mar 2015 00:54:47 -0400
Message-ID: <1427086499-15657-37-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pQqu2owq0roNLS6TopCwKs770U0QPgi+qeAm0ioDXbk=;
        b=hvwdxmja5uq4ifj15p+waG19zGTdqQ6/auW5e9sHiy0mKMLXnq5t1Niza7pkLmp0ru
         yU51dS41LXRHUd5jDxdbJt4rlfoBOhBckj7vpeZwGO5JJQDlLvIfM/i7EBcq+esMDT51
         mAsjJHsIEQfkwaaOtPi/1ToUK4Kqmt/IF8rSFzqN6VH0mEauZo5W6gblcbTAI1V4sJbH
         CuImEBdJxz+M4h3t5e9QeXiarSrKzlzgHnm/5OkaLeXHgsiS5kW5EWVR73KaFa7BmXia
         ZQ/tCeBHFUQp+L1VieAMKt+HUCIjZ6VqRTF6/7+0dNhjzn0QxSfqQ+7nkmvQJ0rFa+B7
         hvMw==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

For cgroup writeback support, all bdi-wide operations should be
distributed to all its wb's (bdi_writeback's).

This patch updates laptop_mode_timer_fn() so that it invokes
wb_start_writeback() on all wb's rather than just the root one.  As
the intent is writing out all dirty data, there's no reason to split
the number of pages to write.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7c3a555..fa37e73 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1723,14 +1723,20 @@ void laptop_mode_timer_fn(unsigned long data)
 	struct request_queue *q = (struct request_queue *)data;
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
+	struct bdi_writeback *wb;
+	struct wb_iter iter;
 
 	/*
 	 * We want to write everything out, not just down to the dirty
 	 * threshold
 	 */
-	if (bdi_has_dirty_io(&q->backing_dev_info))
-		wb_start_writeback(&q->backing_dev_info.wb, nr_pages, true,
-				   WB_REASON_LAPTOP_TIMER);
+	if (!bdi_has_dirty_io(&q->backing_dev_info))
+		return;
+
+	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
+		if (wb_has_dirty_io(wb))
+			wb_start_writeback(wb, nr_pages, true,
+					   WB_REASON_LAPTOP_TIMER);
 }
 
 /*
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
