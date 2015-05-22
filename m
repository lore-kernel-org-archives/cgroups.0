From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 36/51] writeback: implement bdi_for_each_wb()
Date: Fri, 22 May 2015 17:13:50 -0400
Message-ID: <1432329245-5844-37-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BRBuKWthd1YeGpDEsuBdqVDhvdxyzsMxKqpEib1wICo=;
        b=N/6LlKU8EeWuYPh5Drxk3DZIKI1y1seeaKstSOBIPF3sAVWWoj7gaZ/fHFqJrh1Qhw
         9cLjxxRUFZZVqdsQe60uGf56nrbgXg5A23tmiCP3hoBxWfA9rC694EvuSEjY1yHZ9+Ex
         nZ4HKcckU1qsfgjgQiLD2fawUBRpdoqkGN+Rb91FJoBn/T3nE7LEM+jNRPIXqeai1rCx
         IlyvoIdbgfJ0PXejEs8+pi1BcokRgpYdGv06Gsc/RUzQHtBwJ0k/DPEMKOS3kXXd2naU
         g4h6/jllm2eRhQoYqErAjcgUmIMylI0dYQkENB3QYRku0iaLYoK0/PGa9AhGbZTTTjhD
         Nwew==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

This will be used to implement bdi-wide operations which should be
distributed across all its cgroup bdi_writebacks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h | 63 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0839e44..c797980 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -383,6 +383,61 @@ static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 	return inode->i_wb;
 }
 
+struct wb_iter {
+	int			start_blkcg_id;
+	struct radix_tree_iter	tree_iter;
+	void			**slot;
+};
+
+static inline struct bdi_writeback *__wb_iter_next(struct wb_iter *iter,
+						   struct backing_dev_info *bdi)
+{
+	struct radix_tree_iter *titer = &iter->tree_iter;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	if (iter->start_blkcg_id >= 0) {
+		iter->slot = radix_tree_iter_init(titer, iter->start_blkcg_id);
+		iter->start_blkcg_id = -1;
+	} else {
+		iter->slot = radix_tree_next_slot(iter->slot, titer, 0);
+	}
+
+	if (!iter->slot)
+		iter->slot = radix_tree_next_chunk(&bdi->cgwb_tree, titer, 0);
+	if (iter->slot)
+		return *iter->slot;
+	return NULL;
+}
+
+static inline struct bdi_writeback *__wb_iter_init(struct wb_iter *iter,
+						   struct backing_dev_info *bdi,
+						   int start_blkcg_id)
+{
+	iter->start_blkcg_id = start_blkcg_id;
+
+	if (start_blkcg_id)
+		return __wb_iter_next(iter, bdi);
+	else
+		return &bdi->wb;
+}
+
+/**
+ * bdi_for_each_wb - walk all wb's of a bdi in ascending blkcg ID order
+ * @wb_cur: cursor struct bdi_writeback pointer
+ * @bdi: bdi to walk wb's of
+ * @iter: pointer to struct wb_iter to be used as iteration buffer
+ * @start_blkcg_id: blkcg ID to start iteration from
+ *
+ * Iterate @wb_cur through the wb's (bdi_writeback's) of @bdi in ascending
+ * blkcg ID order starting from @start_blkcg_id.  @iter is struct wb_iter
+ * to be used as temp storage during iteration.  rcu_read_lock() must be
+ * held throughout iteration.
+ */
+#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
+	for ((wb_cur) = __wb_iter_init(iter, bdi, start_blkcg_id);	\
+	     (wb_cur); (wb_cur) = __wb_iter_next(iter, bdi))
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline bool inode_cgwb_enabled(struct inode *inode)
@@ -445,6 +500,14 @@ static inline void wb_blkcg_offline(struct blkcg *blkcg)
 {
 }
 
+struct wb_iter {
+	int		next_id;
+};
+
+#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
+	for ((iter)->next_id = (start_blkcg_id);			\
+	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL; }); )
+
 static inline int inode_congested(struct inode *inode, int cong_bits)
 {
 	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
-- 
2.4.0
