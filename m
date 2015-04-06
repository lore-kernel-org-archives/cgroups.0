From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 37/49] writeback: make laptop_mode_timer_fn() handle multiple bdi_writeback's
Date: Mon,  6 Apr 2015 15:58:26 -0400
Message-ID: <1428350318-8215-38-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qYhk27OrTp+x1R8R/yT1To/miL+FLFwzwaVOAY01/FA=;
        b=JngsJBB6TwUnEgIXyI2jUpp42oONuTpW28mC97lfi0RKmN8iwKsCnj8ZvngtNRZliH
         H4oHvCrhGTwRNugzzysKIuz7CfwKIkhKWUr47OsW2o98XjdoF5pxuOgw06bfma4XFYds
         0HMmbJvGfozS276CtImR7+lnkKmTXLc1iekoyLjCrvujgAjkfaUwKSzT1dYYYxBpDKo0
         gEa1if3tqEbodsCtnaVnkI9Jp3P9JvAnk2TckU5f+Y2w0yANPF2AulgbAAcZ7dC+UE5G
         JjcyQisRe97uJ8lRf8BOyFJu/u/T8dN3C/F2mYk9q6i241OzLmUICeRWssbV6ZEkr0m6
         idGw==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
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
index 3b6d79a..5458762 100644
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
