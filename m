From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 38/45] writeback: make cyclic writeback cursor cgroup writeback aware
Date: Tue,  6 Jan 2015 16:26:15 -0500
Message-ID: <1420579582-8516-39-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=La5TLrORjYooolHlWtQ2q1YUgEktT9or6XHbhpPjcMc=;
        b=ZrGp4hMGfC7G8csLPUB7uERSPqLcQ8ZegRXizj8KlmqSbmW8Qb7LwkHxm7is6YrZJ3
         9rYJpRPUZQFSgkCDgza6rNSyGPir/zkCv/YTGhgCi0lbmW+f7PInFo50t+gWp/33MWyu
         yGHgW+Q8foL/0Zg1bfO2avDTfpecYWTrPyRCP5OAv2dicFh0PgtHc3xKrmA5cX3lILJz
         HEdjuOPZnwLhePwSfMb++61ochZlm3ry28kE9BLn95uKXsVqvFxGh6TYeLV7yyD6ITVc
         yBvJSbQOa3Ux07Q/+TqRzryRYs3DEJPVij/j48jID/MQQvzQbeNCoU002PB6h3jFZegz
         NxXw==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

address_space->writeback_index keeps track of where to write next for
cyclic writebacks.  When cgroup writeback is used, an adress_space can
be written back by multiple wb's (bdi_writeback's) and sharing the
cyclic cursor across them doesn't make sense.

This patch adds inode_cgwb_link->writeback_index and introduces and
uses mapping_writeback_index_wbc() to determine the writeback cursor
to use.  If the writeback_control in effect indicates that non-root
cgroup writeback is in progress, the matching inode_cgwb_link's
writeback_index is used; otherwise, the mapping one is used.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev-defs.h |  2 ++
 include/linux/backing-dev.h      | 30 ++++++++++++++++++++++++++++++
 mm/page-writeback.c              |  5 +++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index e3b18f3..6d64a0e 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -193,6 +193,8 @@ struct inode_cgwb_link {
 	struct hlist_node	inode_node;	/* RCU-safe, sorted */
 	struct list_head	wb_node;
 
+	pgoff_t			writeback_index; /* cyclic writeback cursor */
+
 	struct rcu_head		rcu;
 };
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5a163fa..57dd200 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -551,6 +551,30 @@ bdi_writeback_wb(struct backing_dev_info *bdi, struct writeback_control *wbc)
 }
 
 /**
+ * mapping_writeback_index - determine the cursor for cyclic writeback
+ * @mapping: address_space under writeback
+ * @wbc: writeback_control in effect
+ *
+ * Called from address_space_operations->writepages() implementations to
+ * retrieve the pointer to the cursor variable to use for cyclic
+ * writebacks.  If cgroup writeback is enabled, there's a separate cyclic
+ * cursor for each cgroup writing back @mapping.
+ */
+static inline pgoff_t *mapping_writeback_index(struct address_space *mapping,
+					       struct writeback_control *wbc)
+{
+	struct inode_wb_link *iwbl = wbc->iwbl;
+
+	if (!iwbl || iwbl_to_wb(iwbl)->blkcg_css == blkcg_root_css) {
+		return &mapping->writeback_index;
+	} else {
+		struct inode_cgwb_link *icgwbl =
+			container_of(iwbl, struct inode_cgwb_link, iwbl);
+		return &icgwbl->writeback_index;
+	}
+}
+
+/**
  * wbc_blkcg_css - return the blkcg_css associated with a wbc
  * @wbc: writeback_control of interest
  *
@@ -652,6 +676,12 @@ bdi_writeback_wb(struct backing_dev_info *bdi, struct writeback_control *wbc)
 	return &bdi->wb;
 }
 
+static inline pgoff_t *mapping_writeback_index(struct address_space *mapping,
+					       struct writeback_control *wbc)
+{
+	return &mapping->writeback_index;
+}
+
 static inline struct cgroup_subsys_state *
 wbc_blkcg_css(struct writeback_control *wbc)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3e31458..753d76f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1906,6 +1906,7 @@ int write_cache_pages(struct address_space *mapping,
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t *writeback_index_ptr = mapping_writeback_index(mapping, wbc);
 	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
@@ -1916,7 +1917,7 @@ int write_cache_pages(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
+		writeback_index = *writeback_index_ptr; /* prev offset */
 		index = writeback_index;
 		if (index == 0)
 			cycled = 1;
@@ -2048,7 +2049,7 @@ continue_unlock:
 		goto retry;
 	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = done_index;
+		*writeback_index_ptr = done_index;
 
 	return ret;
 }
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
