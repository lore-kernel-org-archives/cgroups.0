From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 34/48] writeback: implement bdi_for_each_wb()
Date: Mon, 23 Mar 2015 00:54:45 -0400
Message-ID: <1427086499-15657-35-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5AEIioeAwrwj0ODLPxOF+bNdaSMnFgrfKsJ/G0Xfmio=;
        b=mJrcwSkCtIVP9Nu+dGCpEMhZD86YQU78+5PIjuH5+vm6taKgpJGLVOhKR3w8ud3S81
         qbIq2WTBZTPeCaHSoboPlSlIaigPfIOkfT6QwKk368++gL2dH7vV57tmyi7SOqQFZtVk
         +1focKgjsDPwAwBX7mic4RfVJPvU5pR2wYiMCUTepfvf1X8uFM6wrI5OVKM+TplpA5vT
         UOG3IvIXxkC3awZb01Tkv2yWcTf4Wz2kRBgFkPUqHRo/8yCjdFWSYxB9L16M2lK0Yyyh
         jEVfNObrXpaqi80zpGhqszmBq6J167PiBA1gl/EsA4aXIQgjG4DA8w3lP9vXsd4Nyl1J
         Qd8g==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

This will be used to implement bdi-wide operations which should be
distributed across all its cgroup bdi_writebacks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h | 63 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 433b308..9dc4eea 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -384,6 +384,61 @@ static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
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
@@ -446,6 +501,14 @@ static inline void wb_blkcg_offline(struct blkcg *blkcg)
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
 static inline int mapping_congested(struct address_space *mapping,
 				    struct task_struct *task, int cong_bits)
 {
-- 
2.1.0

