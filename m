From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] writeback: bdi_for_each_wb() iteration is memcg ID based not blkcg
Date: Tue,  7 Jul 2015 11:10:19 -0400
Message-ID: <1436281823-1947-2-git-send-email-tj@kernel.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pe0lk/XdZcyjl3UQLyYVZ0DDkhCVH70eUz7YX9XAx+w=;
        b=Zd4ZhMNGGuXxcQog/SsX7hie+Osi6y+ay+bCzENfXa6kf6nrCix6ZOPhumBX0WleEb
         xuDzOWxuBUvXo745ymGbSFgdLfardEGy9FXfhs4gviCCj/2UzkgF1Pned5idymqIa0TR
         8sW6Rj6n8lRMawA2XDrtdZsa8b5weD1o8qUfeHFDSMFYqeHFJYZR2dwhtBY1xBFkSvW5
         n6CzqMiJi0n4B/vudJagNgqPWXkGPOBn939TrSvlhgFXYisLeozu0JxzOblDotPnJhQx
         RrPwL69TqeWgfaK+7KJs7kKWJXDsHqZl0ZmNYBK1jwVpSxHO4Vsh09kfa+L9raAp2SD2
         NsQg==
In-Reply-To: <1436281823-1947-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

wb's (bdi_writeback's) are currently keyed by memcg ID; however, in an
earlier implementation, wb's were keyed by blkcg ID.
bdi_for_each_wb() walks bdi->cgwb_tree in the ascending ID order and
allows iterations to start from an arbitrary ID which is used to
interrupt and resume iterations.

Unfortunately, while changing wb to be keyed by memcg ID instead of
blkcg, bdi_for_each_wb() was missed and is still assuming that wb's
are keyed by blkcg ID.  This doesn't affect iterations which don't get
interrupted but bdi_split_work_to_wbs() makes use of iteration
resuming on allocation failures and thus may incorrectly skip or
repeat wb's.

Fix it by changing bdi_for_each_wb() to take memcg IDs instead of
blkcg IDs and updating bdi_split_work_to_wbs() accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c           |  6 +++---
 include/linux/backing-dev.h | 24 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f0520bc..6079922 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -838,7 +838,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 				  bool skip_if_busy)
 {
 	long nr_pages = base_work->nr_pages;
-	int next_blkcg_id = 0;
+	int next_memcg_id = 0;
 	struct bdi_writeback *wb;
 	struct wb_iter iter;
 
@@ -848,14 +848,14 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		return;
 restart:
 	rcu_read_lock();
-	bdi_for_each_wb(wb, bdi, &iter, next_blkcg_id) {
+	bdi_for_each_wb(wb, bdi, &iter, next_memcg_id) {
 		if (!wb_has_dirty_io(wb) ||
 		    (skip_if_busy && writeback_in_progress(wb)))
 			continue;
 
 		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
 		if (!wb_clone_and_queue_work(wb, base_work)) {
-			next_blkcg_id = wb->blkcg_css->id + 1;
+			next_memcg_id = wb->memcg_css->id + 1;
 			rcu_read_unlock();
 			wb_wait_for_single_work(bdi, base_work);
 			goto restart;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0fe9df9..23ebb94 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -402,7 +402,7 @@ static inline void unlocked_inode_to_wb_end(struct inode *inode, bool locked)
 }
 
 struct wb_iter {
-	int			start_blkcg_id;
+	int			start_memcg_id;
 	struct radix_tree_iter	tree_iter;
 	void			**slot;
 };
@@ -414,9 +414,9 @@ static inline struct bdi_writeback *__wb_iter_next(struct wb_iter *iter,
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (iter->start_blkcg_id >= 0) {
-		iter->slot = radix_tree_iter_init(titer, iter->start_blkcg_id);
-		iter->start_blkcg_id = -1;
+	if (iter->start_memcg_id >= 0) {
+		iter->slot = radix_tree_iter_init(titer, iter->start_memcg_id);
+		iter->start_memcg_id = -1;
 	} else {
 		iter->slot = radix_tree_next_slot(iter->slot, titer, 0);
 	}
@@ -430,30 +430,30 @@ static inline struct bdi_writeback *__wb_iter_next(struct wb_iter *iter,
 
 static inline struct bdi_writeback *__wb_iter_init(struct wb_iter *iter,
 						   struct backing_dev_info *bdi,
-						   int start_blkcg_id)
+						   int start_memcg_id)
 {
-	iter->start_blkcg_id = start_blkcg_id;
+	iter->start_memcg_id = start_memcg_id;
 
-	if (start_blkcg_id)
+	if (start_memcg_id)
 		return __wb_iter_next(iter, bdi);
 	else
 		return &bdi->wb;
 }
 
 /**
- * bdi_for_each_wb - walk all wb's of a bdi in ascending blkcg ID order
+ * bdi_for_each_wb - walk all wb's of a bdi in ascending memcg ID order
  * @wb_cur: cursor struct bdi_writeback pointer
  * @bdi: bdi to walk wb's of
  * @iter: pointer to struct wb_iter to be used as iteration buffer
- * @start_blkcg_id: blkcg ID to start iteration from
+ * @start_memcg_id: memcg ID to start iteration from
  *
  * Iterate @wb_cur through the wb's (bdi_writeback's) of @bdi in ascending
- * blkcg ID order starting from @start_blkcg_id.  @iter is struct wb_iter
+ * memcg ID order starting from @start_memcg_id.  @iter is struct wb_iter
  * to be used as temp storage during iteration.  rcu_read_lock() must be
  * held throughout iteration.
  */
-#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
-	for ((wb_cur) = __wb_iter_init(iter, bdi, start_blkcg_id);	\
+#define bdi_for_each_wb(wb_cur, bdi, iter, start_memcg_id)		\
+	for ((wb_cur) = __wb_iter_init(iter, bdi, start_memcg_id);	\
 	     (wb_cur); (wb_cur) = __wb_iter_next(iter, bdi))
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
-- 
2.4.3
