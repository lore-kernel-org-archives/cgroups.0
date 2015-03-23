From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 35/48] writeback: remove bdi_start_writeback()
Date: Mon, 23 Mar 2015 00:54:46 -0400
Message-ID: <1427086499-15657-36-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QIGOwa4HbiRBzcJQonFAP4Y4bZSrn+xQQcdqZivNZDc=;
        b=zTMph+IKIpF0M2L6o72LM+h6Gh4dVkHXECquSdreEjZg8uU/i+nCnt5KrXMEVG8+nV
         HC3AdOJXNEA619rA6jJyypICllcw5ZFOYVAiJRFr8GPf3NirCZfgtWWI+Kjbeu3EE8Vi
         3vNlYF+qR1xsjWoL0XV5iT/xlmg880y2a7PY2AY1AhbpbKz17z9h/z3hEjljS0sjxYsT
         0tUjEYPpmyyKdW+X5lQAd4UfUnJGwqXy/XakcyatQqnb5XeFHWF1P0/Ln4/fZ9tYCWsM
         xudSPQDHroh/PBgG0sLZifuMVCL+vJMT6DYZGBcf4lzPRqsb4mDSu3wdF8Inxnby9q7t
         DRmw==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

bdi_start_writeback() is a thin wrapper on top of
__wb_start_writeback() which is used only by laptop_mode_timer_fn().
This patches removes bdi_start_writeback(), renames
__wb_start_writeback() to wb_start_writeback() and makes
laptop_mode_timer_fn() use it instead.

This doesn't cause any functional difference and will ease making
laptop_mode_timer_fn() cgroup writeback aware.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c           | 68 +++++++++++++++++----------------------------
 include/linux/backing-dev.h |  4 +--
 mm/page-writeback.c         |  4 +--
 3 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3ceacbb..c24d6fd 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -172,33 +172,6 @@ out_unlock:
 	spin_unlock_bh(&wb->work_lock);
 }
 
-static void __wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
-				 bool range_cyclic, enum wb_reason reason)
-{
-	struct wb_writeback_work *work;
-
-	if (!wb_has_dirty_io(wb))
-		return;
-
-	/*
-	 * This is WB_SYNC_NONE writeback, so if allocation fails just
-	 * wakeup the thread for old dirty data writeback
-	 */
-	work = kzalloc(sizeof(*work), GFP_ATOMIC);
-	if (!work) {
-		trace_writeback_nowork(wb->bdi);
-		wb_wakeup(wb);
-		return;
-	}
-
-	work->sync_mode	= WB_SYNC_NONE;
-	work->nr_pages	= nr_pages;
-	work->range_cyclic = range_cyclic;
-	work->reason	= reason;
-
-	wb_queue_work(wb, work);
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 /**
@@ -238,22 +211,31 @@ EXPORT_SYMBOL_GPL(mapping_congested);
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-/**
- * bdi_start_writeback - start writeback
- * @bdi: the backing device to write from
- * @nr_pages: the number of pages to write
- * @reason: reason why some writeback work was initiated
- *
- * Description:
- *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
- *   started when this function returns, we make no guarantees on
- *   completion. Caller need not hold sb s_umount semaphore.
- *
- */
-void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-			enum wb_reason reason)
+void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
+			bool range_cyclic, enum wb_reason reason)
 {
-	__wb_start_writeback(&bdi->wb, nr_pages, true, reason);
+	struct wb_writeback_work *work;
+
+	if (!wb_has_dirty_io(wb))
+		return;
+
+	/*
+	 * This is WB_SYNC_NONE writeback, so if allocation fails just
+	 * wakeup the thread for old dirty data writeback
+	 */
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		trace_writeback_nowork(wb->bdi);
+		wb_wakeup(wb);
+		return;
+	}
+
+	work->sync_mode	= WB_SYNC_NONE;
+	work->nr_pages	= nr_pages;
+	work->range_cyclic = range_cyclic;
+	work->reason	= reason;
+
+	wb_queue_work(wb, work);
 }
 
 /**
@@ -1211,7 +1193,7 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
-		__wb_start_writeback(&bdi->wb, nr_pages, false, reason);
+		wb_start_writeback(&bdi->wb, nr_pages, false, reason);
 	rcu_read_unlock();
 }
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 9dc4eea..81e39ff 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -25,8 +25,8 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
-void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
-			enum wb_reason reason);
+void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
+			bool range_cyclic, enum wb_reason reason);
 void bdi_start_background_writeback(struct backing_dev_info *bdi);
 void wb_workfn(struct work_struct *work);
 void wb_wakeup_delayed(struct bdi_writeback *wb);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 349e32b..7c3a555 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1729,8 +1729,8 @@ void laptop_mode_timer_fn(unsigned long data)
 	 * threshold
 	 */
 	if (bdi_has_dirty_io(&q->backing_dev_info))
-		bdi_start_writeback(&q->backing_dev_info, nr_pages,
-					WB_REASON_LAPTOP_TIMER);
+		wb_start_writeback(&q->backing_dev_info.wb, nr_pages, true,
+				   WB_REASON_LAPTOP_TIMER);
 }
 
 /*
-- 
2.1.0
