From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in struct task_struct
Date: Tue, 24 Jan 2023 07:57:05 +0100
Message-ID: <20230124065716.152286-6-hch@lst.de>
References: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=evxwlHP6hYFLNCCxHqPA/7nYjEdgIE49tiH9tt6oiLM=; b=yOyjk7zqDpiw4ADQuPVRV8AcMp
        39mj/a1LnrU4fKaFzKe0CAr9pBgBnyTKMKn9R6awDyoE0kyfRc2joJLC/+Um4IBdl7NmnWcaZQ9fK
        KwoMVfTvmRRM/t9Jv6/ZiHE+vb8SVD7FTVM2pyepoY3ZXfoz7BXkoYLYVqeL/sreNivHZ2oGMDTI8
        if60ZLC4tJlTWnlEosS4RYGyjEyRZdgP/iRzDzJMdD5gWFkatx2EZOc9HBu4Tjkl3hIzj85Jtmv7+
        3RXn1zSIf8hZBizZs0Wki4v0WqZ1P3s1GL/1v4XA0FwSZQxfpQMJJwNvud0HsAMm2y4z8HpDHV9KC
        XOeo6a0g==;
In-Reply-To: <20230124065716.152286-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

Switch from a request_queue pointer and reference to a gendisk once
for the throttle information in struct task_struct.

Move the check for the dead disk to the latest place now that is is
unbundled from the reference grab.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
---
 block/blk-cgroup.c    | 37 +++++++++++++++++++------------------
 include/linux/sched.h |  2 +-
 kernel/fork.c         |  2 +-
 mm/swapfile.c         |  2 +-
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f5a634ed098db0..603e911d1350db 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1334,9 +1334,9 @@ static void blkcg_bind(struct cgroup_subsys_state *root_css)
 
 static void blkcg_exit(struct task_struct *tsk)
 {
-	if (tsk->throttle_queue)
-		blk_put_queue(tsk->throttle_queue);
-	tsk->throttle_queue = NULL;
+	if (tsk->throttle_disk)
+		put_disk(tsk->throttle_disk);
+	tsk->throttle_disk = NULL;
 }
 
 struct cgroup_subsys io_cgrp_subsys = {
@@ -1778,29 +1778,32 @@ static void blkcg_maybe_throttle_blkg(struct blkcg_gq *blkg, bool use_memdelay)
  *
  * This is only called if we've been marked with set_notify_resume().  Obviously
  * we can be set_notify_resume() for reasons other than blkcg throttling, so we
- * check to see if current->throttle_queue is set and if not this doesn't do
+ * check to see if current->throttle_disk is set and if not this doesn't do
  * anything.  This should only ever be called by the resume code, it's not meant
  * to be called by people willy-nilly as it will actually do the work to
  * throttle the task if it is setup for throttling.
  */
 void blkcg_maybe_throttle_current(void)
 {
-	struct request_queue *q = current->throttle_queue;
+	struct gendisk *disk = current->throttle_disk;
 	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
 	bool use_memdelay = current->use_memdelay;
 
-	if (!q)
+	if (!disk)
 		return;
 
-	current->throttle_queue = NULL;
+	current->throttle_disk = NULL;
 	current->use_memdelay = false;
 
+	if (test_bit(GD_DEAD, &disk->state))
+		goto out_put_disk;
+
 	rcu_read_lock();
 	blkcg = css_to_blkcg(blkcg_css());
 	if (!blkcg)
 		goto out;
-	blkg = blkg_lookup(blkcg, q);
+	blkg = blkg_lookup(blkcg, disk->queue);
 	if (!blkg)
 		goto out;
 	if (!blkg_tryget(blkg))
@@ -1809,11 +1812,12 @@ void blkcg_maybe_throttle_current(void)
 
 	blkcg_maybe_throttle_blkg(blkg, use_memdelay);
 	blkg_put(blkg);
-	blk_put_queue(q);
+	put_disk(disk);
 	return;
 out:
 	rcu_read_unlock();
-	blk_put_queue(q);
+out_put_disk:
+	put_disk(disk);
 }
 
 /**
@@ -1835,18 +1839,15 @@ void blkcg_maybe_throttle_current(void)
  */
 void blkcg_schedule_throttle(struct gendisk *disk, bool use_memdelay)
 {
-	struct request_queue *q = disk->queue;
-
 	if (unlikely(current->flags & PF_KTHREAD))
 		return;
 
-	if (current->throttle_queue != q) {
-		if (!blk_get_queue(q))
-			return;
+	if (current->throttle_disk != disk) {
+		get_device(disk_to_dev(disk));
 
-		if (current->throttle_queue)
-			blk_put_queue(current->throttle_queue);
-		current->throttle_queue = q;
+		if (current->throttle_disk)
+			put_disk(current->throttle_disk);
+		current->throttle_disk = disk;
 	}
 
 	if (use_memdelay)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 853d08f7562bda..6f6ce9ca709798 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1436,7 +1436,7 @@ struct task_struct {
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
-	struct request_queue		*throttle_queue;
+	struct gendisk			*throttle_disk;
 #endif
 
 #ifdef CONFIG_UPROBES
diff --git a/kernel/fork.c b/kernel/fork.c
index 9f7fe354189785..d9c97704b7c9a4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1044,7 +1044,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
-	tsk->throttle_queue = NULL;
+	tsk->throttle_disk = NULL;
 	tsk->use_memdelay = 0;
 #endif
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 908a529bca12c9..3e0a742fb7bbff 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3642,7 +3642,7 @@ void __cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 	 * We've already scheduled a throttle, avoid taking the global swap
 	 * lock.
 	 */
-	if (current->throttle_queue)
+	if (current->throttle_disk)
 		return;
 
 	spin_lock(&swap_avail_lock);
-- 
2.39.0

