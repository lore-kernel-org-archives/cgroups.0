From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/16] writeback: reorganize mm/backing-dev.c
Date: Tue,  6 Jan 2015 14:29:13 -0500
Message-ID: <1420572557-11572-13-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OZmhUE26NzSxBsJgR2UB2x45ChjIBeigsUvOcRH+Sgk=;
        b=iTRB74LQDa4RTu1h2/IiMAnPguUO5sccmQOwO28tFxhXV648LyaoQgqFD2AqQAUzfN
         0sOnRXh1ir2kekiFutHGIkfgVmc9NtqjDNS8iGSfFrCnnrBLoUojiHRhd05k5TADESc7
         BupqeupVgeb8wcj7Qur4tbGmedm3/fH3EZd9os0C7Gl3HgBWAvkT+zkYEVZ0HJSE0oJi
         fpEKBeoTN0g/y6/yLCxb9sx5QaU9T4Yx2QlyKvCam1BVyi7fhiruAGM2UhvxZ5u/U1sF
         vvdFVgaGStIMmJnZ5Z1Y3LUg/Awi3T63/pvjHhTxLxRDrh0ccpP47ZbA/3GJXkKNtz+y
         qgJg==
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, Tejun Heo <tj@kernel.org>, Wu Fengguang <fengguang.wu@intel.com>

Move wb_shutdown(), bdi_register(), bdi_register_dev(),
bdi_prune_sb(), bdi_remove_from_list() and bdi_unregister() so that
init / exit functions are grouped together.  This will make updating
init / exit paths for cgroup writeback support easier.

This is pure source file reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/backing-dev.c | 206 +++++++++++++++++++++++++++----------------------------
 1 file changed, 103 insertions(+), 103 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index dbd321e..a98a957 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -338,109 +338,6 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
 }
 
 /*
- * Remove bdi from bdi_list, and ensure that it is no longer visible
- */
-static void bdi_remove_from_list(struct backing_dev_info *bdi)
-{
-	spin_lock_bh(&bdi_lock);
-	list_del_rcu(&bdi->bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	synchronize_rcu_expedited();
-}
-
-int bdi_register(struct backing_dev_info *bdi, struct device *parent,
-		const char *fmt, ...)
-{
-	va_list args;
-	struct device *dev;
-
-	if (bdi->dev)	/* The driver needs to use separate queues per device */
-		return 0;
-
-	va_start(args, fmt);
-	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
-	va_end(args);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
-
-	bdi->dev = dev;
-
-	bdi_debug_register(bdi, dev_name(dev));
-	set_bit(WB_registered, &bdi->wb.state);
-
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	trace_writeback_bdi_register(bdi);
-	return 0;
-}
-EXPORT_SYMBOL(bdi_register);
-
-int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
-{
-	return bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
-}
-EXPORT_SYMBOL(bdi_register_dev);
-
-/*
- * Remove bdi from the global list and shutdown any threads we have running
- */
-static void wb_shutdown(struct bdi_writeback *wb)
-{
-	/* Make sure nobody queues further work */
-	spin_lock_bh(&wb->work_lock);
-	clear_bit(WB_registered, &wb->state);
-	spin_unlock_bh(&wb->work_lock);
-
-	/*
-	 * Drain work list and shutdown the delayed_work.  !WB_registered
-	 * tells wb_workfn() that @wb is dying and its work_list needs to
-	 * be drained no matter what.
-	 */
-	mod_delayed_work(bdi_wq, &wb->dwork, 0);
-	flush_delayed_work(&wb->dwork);
-	WARN_ON(!list_empty(&wb->work_list));
-	WARN_ON(delayed_work_pending(&wb->dwork));
-}
-
-/*
- * This bdi is going away now, make sure that no super_blocks point to it
- */
-static void bdi_prune_sb(struct backing_dev_info *bdi)
-{
-	struct super_block *sb;
-
-	spin_lock(&sb_lock);
-	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_bdi == bdi)
-			sb->s_bdi = &default_backing_dev_info;
-	}
-	spin_unlock(&sb_lock);
-}
-
-void bdi_unregister(struct backing_dev_info *bdi)
-{
-	if (bdi->dev) {
-		bdi_set_min_ratio(bdi, 0);
-		trace_writeback_bdi_unregister(bdi);
-		bdi_prune_sb(bdi);
-
-		if (bdi_cap_writeback_dirty(bdi)) {
-			/* make sure nobody finds us on the bdi_list anymore */
-			bdi_remove_from_list(bdi);
-			wb_shutdown(&bdi->wb);
-		}
-
-		bdi_debug_unregister(bdi);
-		device_unregister(bdi->dev);
-		bdi->dev = NULL;
-	}
-}
-EXPORT_SYMBOL(bdi_unregister);
-
-/*
  * Initial write bandwidth: 100 MB/s
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
@@ -485,6 +382,27 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	return 0;
 }
 
+/*
+ * Remove bdi from the global list and shutdown any threads we have running
+ */
+static void wb_shutdown(struct bdi_writeback *wb)
+{
+	/* Make sure nobody queues further work */
+	spin_lock_bh(&wb->work_lock);
+	clear_bit(WB_registered, &wb->state);
+	spin_unlock_bh(&wb->work_lock);
+
+	/*
+	 * Drain work list and shutdown the delayed_work.  !WB_registered
+	 * tells wb_workfn() that @wb is dying and its work_list needs to
+	 * be drained no matter what.
+	 */
+	mod_delayed_work(bdi_wq, &wb->dwork, 0);
+	flush_delayed_work(&wb->dwork);
+	WARN_ON(!list_empty(&wb->work_list));
+	WARN_ON(delayed_work_pending(&wb->dwork));
+}
+
 static void wb_exit(struct bdi_writeback *wb)
 {
 	int i;
@@ -540,6 +458,88 @@ int bdi_init(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(bdi_init);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...)
+{
+	va_list args;
+	struct device *dev;
+
+	if (bdi->dev)	/* The driver needs to use separate queues per device */
+		return 0;
+
+	va_start(args, fmt);
+	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
+	va_end(args);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	bdi->dev = dev;
+
+	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(WB_registered, &bdi->wb.state);
+
+	spin_lock_bh(&bdi_lock);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
+	trace_writeback_bdi_register(bdi);
+	return 0;
+}
+EXPORT_SYMBOL(bdi_register);
+
+int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
+{
+	return bdi_register(bdi, NULL, "%u:%u", MAJOR(dev), MINOR(dev));
+}
+EXPORT_SYMBOL(bdi_register_dev);
+
+/*
+ * This bdi is going away now, make sure that no super_blocks point to it
+ */
+static void bdi_prune_sb(struct backing_dev_info *bdi)
+{
+	struct super_block *sb;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_bdi == bdi)
+			sb->s_bdi = &default_backing_dev_info;
+	}
+	spin_unlock(&sb_lock);
+}
+
+/*
+ * Remove bdi from bdi_list, and ensure that it is no longer visible
+ */
+static void bdi_remove_from_list(struct backing_dev_info *bdi)
+{
+	spin_lock_bh(&bdi_lock);
+	list_del_rcu(&bdi->bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
+	synchronize_rcu_expedited();
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	if (bdi->dev) {
+		bdi_set_min_ratio(bdi, 0);
+		trace_writeback_bdi_unregister(bdi);
+		bdi_prune_sb(bdi);
+
+		if (bdi_cap_writeback_dirty(bdi)) {
+			/* make sure nobody finds us on the bdi_list anymore */
+			bdi_remove_from_list(bdi);
+			wb_shutdown(&bdi->wb);
+		}
+
+		bdi_debug_unregister(bdi);
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+}
+EXPORT_SYMBOL(bdi_unregister);
+
 void bdi_destroy(struct backing_dev_info *bdi)
 {
 	bdi_unregister(bdi);
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
