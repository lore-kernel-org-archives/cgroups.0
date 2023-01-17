From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in struct task_struct
Date: Tue, 17 Jan 2023 09:12:47 +0100
Message-ID: <20230117081257.3089859-6-hch@lst.de>
References: <20230117081257.3089859-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yXYe7SJq+Eosgyb2tF7aEpHVQ7rDIKeIsjwILkXlOls=; b=JiD8mlKNf/sVBHwj5TV2B9Qf5e
        8hMcsZGIZmPebWBpjzIukoQnLn3oII0EkU815/NNTFix1jEGIXo1NjcGo09pHHiQQahi3Sf6VIyaK
        mvR/Fd345pP43Y4H9sOqoWWKb7dHdliy12mXGhXU0fEENM/3vajIAV+FGR/V6eblYZEeCAiJvjGC/
        5QcSaQXxqkIzWCNhg5vSnYT4hu+Wb6BdyDvAHBdSyuCMwWPXXvZw3f/3eReqFhC/q8ctaGYrIDcG0
        ft1ezN6eqJttyu/FIHTiUESYZDhhSbqoWu0bMAiD/6tKQLBPBQH1kLEe8uVviNuJnfrRaqwfJPxl1
        ZuANZXxw==;
In-Reply-To: <20230117081257.3089859-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

Switch from a request_queue pointer and reference to a gendisk once
for the throttle information in struct task_struct.

Move the check for the dead disk to the latest place now that is is
unboundled from the reference grab.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

