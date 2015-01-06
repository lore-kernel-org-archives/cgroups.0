From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/45] writeback: implement bdi_for_each_wb()
Date: Tue,  6 Jan 2015 16:25:55 -0500
Message-ID: <1420579582-8516-19-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uHNiSKXW/VOrX6TI5x1J059qPuxVPytMtrQPbGu3gUs=;
        b=U/Jg6AGAY+qKq9LkeOSgeAP7g7hhwnxPxAtI69QPT72DN3EIzH/enmXUlI4qZS4pr+
         7a46YetiRlsuk6vd18pf3hR+YXPo+Qu+BS1jS16TKMdiM7jZfxiBEdtkG8IeUJotqAEe
         bwDhOJLqURtr3JvkTEe0c4m2iULiovYYxp+fsg8uV8anNvXLWPihVpIPZfy9zQjL8ONv
         g9lTJfEjmH3Hwh9+vZLKdH+XUutGPGV5wqa2CoUjKNV6YPojmzXkdyrkFH/xu+Oay+J+
         iKPX5R8ZcewLuP/OtHwg3GQ+OSnM2NuZUCFbxQZ1ZeabJy74IZr8OR5aX0pnCZj76SSx
         6IYw==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

This will be used to implement bdi-wide operations which should be
distributed across all its cgroup bdi_writebacks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h | 64 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 49feb0b..37c4299 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -380,6 +380,61 @@ static inline struct bdi_writeback *page_cgwb_wb(struct page *page)
 	return wb;
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
 
 static inline bool mapping_cgwb_enabled(struct address_space *mapping)
@@ -420,6 +475,15 @@ static inline struct bdi_writeback *page_cgwb_wb(struct page *page)
 	return &page->mapping->backing_dev_info->wb;
 }
 
+struct wb_iter {
+	int		next_id;
+};
+
+#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
+	for ((iter)->next_id = (start_blkcg_id);			\
+	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL;	\
+	     }); )
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline int mapping_read_congested(struct address_space *mapping,
-- 
2.1.0
