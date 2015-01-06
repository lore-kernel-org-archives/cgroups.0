From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 21/45] writeback: make writeback_in_progress() take bdi_writeback instead of backing_dev_info
Date: Tue,  6 Jan 2015 16:25:58 -0500
Message-ID: <1420579582-8516-22-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rncqn2evumpjiiIdCJBqfXgbKwUtENdJFYGgF7z1YDw=;
        b=ySu2TOaS7yEV49JSfeql5A9qCVldEk5IM13sVScaQs1DHPJ6ApDXkOX8NxAmjCb9Ab
         Gk0dW4NqTR32M3l97R/KLyhlRg4KpvA/HWTOQva9C63o9+dfc+4la3dMomBFt8F/KzCS
         daF2wltSv1UaR+aLXOmwNa4bBkmqD83C2e81HzWBC1yOHZkjm8IawSPYkbDaS2XM5doH
         RY9vqlpjyQAk+mEkZyQbihNmOJvFOt0oi1ZvX5fVpkoPSwXjFudvDWG83bDd7rapTaIh
         4222bA6IczYxpca2Y6tHo9S+BxUdgMl/aicqkEjiSoCCzX3G1XPKoNz0ee379n/u2rNv
         Kvow==
In-Reply-To: <1420579582-8516-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

writeback_in_progress() currently takes @bdi and returns whether
writeback is in progress on its root wb (bdi_writeback).  In
preparation for cgroup writeback support, make it take wb instead.
While at it, make it an inline function.

This patch doesn't make any functional difference.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/fs-writeback.c           | 15 +--------------
 include/linux/backing-dev.h | 12 +++++++++++-
 mm/page-writeback.c         |  4 ++--
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 18d8e72..6ab113b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -53,19 +53,6 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
-/**
- * writeback_in_progress - determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback waiting to be handled against a
- * backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return test_bit(WB_writeback_running, &bdi->wb.state);
-}
-EXPORT_SYMBOL(writeback_in_progress);
-
 static inline struct inode *wb_inode(struct list_head *head)
 {
 	return list_entry(head, struct inode, i_wb_list);
@@ -1501,7 +1488,7 @@ int try_to_writeback_inodes_sb_nr(struct super_block *sb,
 				  unsigned long nr,
 				  enum wb_reason reason)
 {
-	if (writeback_in_progress(sb->s_bdi))
+	if (writeback_in_progress(&sb->s_bdi->wb))
 		return 1;
 
 	if (!down_read_trylock(&sb->s_umount))
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c6278ee..953fa01 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -186,7 +186,17 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 extern struct backing_dev_info default_backing_dev_info;
 extern struct backing_dev_info noop_backing_dev_info;
 
-int writeback_in_progress(struct backing_dev_info *bdi);
+/**
+ * writeback_in_progress - determine whether there is writeback in progress
+ * @wb: bdi_writeback of interest
+ *
+ * Determine whether there is writeback waiting to be handled against a
+ * bdi_writeback.
+ */
+static inline bool writeback_in_progress(struct bdi_writeback *wb)
+{
+	return test_bit(WB_writeback_running, &wb->state);
+}
 
 static inline int wb_congested(struct bdi_writeback *wb, int bdi_bits)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 190e2a2..b250ee2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1449,7 +1449,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 			break;
 		}
 
-		if (unlikely(!writeback_in_progress(bdi)))
+		if (unlikely(!writeback_in_progress(wb)))
 			bdi_start_background_writeback(bdi);
 
 		if (!strictlimit)
@@ -1568,7 +1568,7 @@ pause:
 	if (!dirty_exceeded && wb->dirty_exceeded)
 		wb->dirty_exceeded = 0;
 
-	if (writeback_in_progress(bdi))
+	if (writeback_in_progress(wb))
 		return;
 
 	/*
-- 
2.1.0
