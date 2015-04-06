From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 39/49] writeback: make bdi_start_background_writeback() take bdi_writeback instead of backing_dev_info
Date: Mon,  6 Apr 2015 15:58:28 -0400
Message-ID: <1428350318-8215-40-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/oT7a/La9sS3bRGq5n6zQ//GgSBeN4QSC8HdNfyQptQ=;
        b=zMvjextdH/cRI6Wwv/SeTJjWY4MRCO/HxTZy8RGz675UMt4N8vOjEBYS6zAKCxj/7j
         eXPLQCM3EeSxoe/LbLm0zdi+DAaEjxvrbOLTYo/YVaHa3nE+PiRHZTPNdLxTX4bGFt2o
         FzRMnOVsPOW2mmgpCVzgDjOE8RRhrGhT3rmWy/7t058ks9bHkfOQmvWAKSUjVYYrCgSp
         wQZkB7qUi+4fRTM+BQtXGda0PGlsrB5/scIhL4WT1OrMvD18hJ0thDzVDSRCBGl1ZoJ7
         ooMIx26+OPzk0phYV3iL0WQzBqX6iSmTWJ8T4AlEQZT3LECQUa18c+MzUXcwKEHNtwrj
         BoDw==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

bdi_start_background_writeback() currently takes @bdi and kicks the
root wb (bdi_writeback).  In preparation for cgroup writeback support,
make it take wb instead.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c           | 12 ++++++------
 include/linux/backing-dev.h |  2 +-
 mm/page-writeback.c         |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ddb3178..643deab 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -216,23 +216,23 @@ void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
 }
 
 /**
- * bdi_start_background_writeback - start background writeback
- * @bdi: the backing device to write from
+ * wb_start_background_writeback - start background writeback
+ * @wb: bdi_writback to write from
  *
  * Description:
  *   This makes sure WB_SYNC_NONE background writeback happens. When
- *   this function returns, it is only guaranteed that for given BDI
+ *   this function returns, it is only guaranteed that for given wb
  *   some IO is happening if we are over background dirty threshold.
  *   Caller need not hold sb s_umount semaphore.
  */
-void bdi_start_background_writeback(struct backing_dev_info *bdi)
+void wb_start_background_writeback(struct bdi_writeback *wb)
 {
 	/*
 	 * We just wake up the flusher thread. It will perform background
 	 * writeback as soon as there is no other work to do.
 	 */
-	trace_writeback_wake_background(bdi);
-	wb_wakeup(&bdi->wb);
+	trace_writeback_wake_background(wb->bdi);
+	wb_wakeup(wb);
 }
 
 /*
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f04956c..9cc11e5 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -27,7 +27,7 @@ void bdi_unregister(struct backing_dev_info *bdi);
 int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
 void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
 			bool range_cyclic, enum wb_reason reason);
-void bdi_start_background_writeback(struct backing_dev_info *bdi);
+void wb_start_background_writeback(struct bdi_writeback *wb);
 void wb_workfn(struct work_struct *work);
 void wb_wakeup_delayed(struct bdi_writeback *wb);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3a19641..1767658 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1456,7 +1456,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 		}
 
 		if (unlikely(!writeback_in_progress(wb)))
-			bdi_start_background_writeback(bdi);
+			wb_start_background_writeback(wb);
 
 		if (!strictlimit)
 			wb_dirty_limits(wb, dirty_thresh, background_thresh,
@@ -1588,7 +1588,7 @@ pause:
 		return;
 
 	if (nr_reclaimable > background_thresh)
-		bdi_start_background_writeback(bdi);
+		wb_start_background_writeback(wb);
 }
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
-- 
2.1.0
