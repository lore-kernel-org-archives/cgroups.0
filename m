From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 3/5] writeback: bdi_writeback iteration must not skip
 dying ones
Date: Fri, 2 Oct 2015 14:47:05 -0400
Message-ID: <20151002184705.GB8983@mtj.duckdns.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
 <1443545274-18787-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zENQ+swQy4mCWwCHJwGpIU1E3nXqBEL+9z9SrgFlgIg=;
        b=zKL5Lg5EVstR3i9sZIdwnYCZTOeuA1R7VGiFYhtW5WxfTAxiXshKT9XVWSElGRA45x
         mJ4yOp5NzEUI0mPl2MysjRbPUgwybnQrB9x+yzWmcJ728/2uS5BUimjzChug+iqiPnXw
         uRkfDLlZoVb2xf5gdEnyWAEwPq7EDkfUb65FW/1KLtJqStw8zNQB0/ZDlddxt83GHNDr
         D3olBka2e3yzRLfqzCszlGPkzdN8e0T5lkSVL7H0jJf1aGWTERXHbAJFA2+nRryVHCl5
         8TVo3CvojqlPWnKVPy6n1ONvegyeeQfUWYnxg/Hy9u4qCYXljQLvRYg5dvY+wx3PYtHJ
         JdPA==
Content-Disposition: inline
In-Reply-To: <1443545274-18787-4-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, tytso@mit.edu, dedekind1@gmail.com, decui@microsoft.com, kernel-team@fb.com

bdi_for_each_wb() is used in several places to wake up or issue
writeback work items to all wb's (bdi_writeback's) on a given bdi.
The iteration is performed by walking bdi->cgwb_tree; however, the
tree only indexes wb's which are currently active.

For example, when a memcg gets associated with a different blkcg, the
old wb is removed from the tree so that the new one can be indexed.
The old wb starts dying from then on but will linger till all its
inodes are drained.  As these dying wb's may still host dirty inodes,
writeback operations which affect all wb's must include them.
bdi_for_each_wb() skipping dying wb's led to sync(2) missing and
failing to sync the inodes belonging to those wb's.

This patch adds a RCU protected @bdi->wb_list which lists all wb's
beloinging to that bdi.  wb's are added on creation and removed on
release rather than on the start of destruction.  bdi_for_each_wb()
usages are replaced with list_for_each[_continue]_rcu() iterations
over @bdi->wb_list and bdi_for_each_wb() and its helpers are removed.

v2: Updated as per Jan.  last_wb ref leak in bdi_split_work_to_wbs()
    fixed and unnecessary list head severing in cgwb_bdi_destroy()
    removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Artem Bityutskiy <dedekind1@gmail.com>
Fixes: ebe41ab0c79d ("writeback: implement bdi_for_each_wb()")
Link: http://lkml.kernel.org/g/1443012552.19983.209.camel@gmail.com
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c                |   31 +++++++++++++------
 include/linux/backing-dev-defs.h |    3 +
 include/linux/backing-dev.h      |   63 ---------------------------------------
 mm/backing-dev.c                 |   14 ++++++++
 mm/page-writeback.c              |    3 -
 5 files changed, 39 insertions(+), 75 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -778,19 +778,24 @@ static void bdi_split_work_to_wbs(struct
 				  struct wb_writeback_work *base_work,
 				  bool skip_if_busy)
 {
-	int next_memcg_id = 0;
-	struct bdi_writeback *wb;
-	struct wb_iter iter;
+	struct bdi_writeback *last_wb = NULL;
+	struct bdi_writeback *wb = list_entry_rcu(&bdi->wb_list,
+						struct bdi_writeback, bdi_node);
 
 	might_sleep();
 restart:
 	rcu_read_lock();
-	bdi_for_each_wb(wb, bdi, &iter, next_memcg_id) {
+	list_for_each_entry_continue_rcu(wb, &bdi->wb_list, bdi_node) {
 		DEFINE_WB_COMPLETION_ONSTACK(fallback_work_done);
 		struct wb_writeback_work fallback_work;
 		struct wb_writeback_work *work;
 		long nr_pages;
 
+		if (last_wb) {
+			wb_put(last_wb);
+			last_wb = NULL;
+		}
+
 		/* SYNC_ALL writes out I_DIRTY_TIME too */
 		if (!wb_has_dirty_io(wb) &&
 		    (base_work->sync_mode == WB_SYNC_NONE ||
@@ -819,12 +824,22 @@ restart:
 
 		wb_queue_work(wb, work);
 
-		next_memcg_id = wb->memcg_css->id + 1;
+		/*
+		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
+		 * continuing iteration from @wb after dropping and
+		 * regrabbing rcu read lock.
+		 */
+		wb_get(wb);
+		last_wb = wb;
+
 		rcu_read_unlock();
 		wb_wait_for_completion(bdi, &fallback_work_done);
 		goto restart;
 	}
 	rcu_read_unlock();
+
+	if (last_wb)
+		wb_put(last_wb);
 }
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
@@ -1857,12 +1872,11 @@ void wakeup_flusher_threads(long nr_page
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
-		struct wb_iter iter;
 
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		bdi_for_each_wb(wb, bdi, &iter, 0)
+		list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node)
 			wb_start_writeback(wb, wb_split_bdi_pages(wb, nr_pages),
 					   false, reason);
 	}
@@ -1894,9 +1908,8 @@ static void wakeup_dirtytime_writeback(s
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
-		struct wb_iter iter;
 
-		bdi_for_each_wb(wb, bdi, &iter, 0)
+		list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node)
 			if (!list_empty(&wb->b_dirty_time))
 				wb_wakeup(wb);
 	}
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -116,6 +116,8 @@ struct bdi_writeback {
 	struct list_head work_list;
 	struct delayed_work dwork;	/* work item used for writeback */
 
+	struct list_head bdi_node;	/* anchored at bdi->wb_list */
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct percpu_ref refcnt;	/* used only for !root wb's */
 	struct fprop_local_percpu memcg_completions;
@@ -150,6 +152,7 @@ struct backing_dev_info {
 	atomic_long_t tot_write_bandwidth;
 
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
+	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
 	struct rb_root cgwb_congested_tree; /* their congested states */
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -401,61 +401,6 @@ static inline void unlocked_inode_to_wb_
 	rcu_read_unlock();
 }
 
-struct wb_iter {
-	int			start_memcg_id;
-	struct radix_tree_iter	tree_iter;
-	void			**slot;
-};
-
-static inline struct bdi_writeback *__wb_iter_next(struct wb_iter *iter,
-						   struct backing_dev_info *bdi)
-{
-	struct radix_tree_iter *titer = &iter->tree_iter;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	if (iter->start_memcg_id >= 0) {
-		iter->slot = radix_tree_iter_init(titer, iter->start_memcg_id);
-		iter->start_memcg_id = -1;
-	} else {
-		iter->slot = radix_tree_next_slot(iter->slot, titer, 0);
-	}
-
-	if (!iter->slot)
-		iter->slot = radix_tree_next_chunk(&bdi->cgwb_tree, titer, 0);
-	if (iter->slot)
-		return *iter->slot;
-	return NULL;
-}
-
-static inline struct bdi_writeback *__wb_iter_init(struct wb_iter *iter,
-						   struct backing_dev_info *bdi,
-						   int start_memcg_id)
-{
-	iter->start_memcg_id = start_memcg_id;
-
-	if (start_memcg_id)
-		return __wb_iter_next(iter, bdi);
-	else
-		return &bdi->wb;
-}
-
-/**
- * bdi_for_each_wb - walk all wb's of a bdi in ascending memcg ID order
- * @wb_cur: cursor struct bdi_writeback pointer
- * @bdi: bdi to walk wb's of
- * @iter: pointer to struct wb_iter to be used as iteration buffer
- * @start_memcg_id: memcg ID to start iteration from
- *
- * Iterate @wb_cur through the wb's (bdi_writeback's) of @bdi in ascending
- * memcg ID order starting from @start_memcg_id.  @iter is struct wb_iter
- * to be used as temp storage during iteration.  rcu_read_lock() must be
- * held throughout iteration.
- */
-#define bdi_for_each_wb(wb_cur, bdi, iter, start_memcg_id)		\
-	for ((wb_cur) = __wb_iter_init(iter, bdi, start_memcg_id);	\
-	     (wb_cur); (wb_cur) = __wb_iter_next(iter, bdi))
-
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline bool inode_cgwb_enabled(struct inode *inode)
@@ -515,14 +460,6 @@ static inline void wb_blkcg_offline(stru
 {
 }
 
-struct wb_iter {
-	int		next_id;
-};
-
-#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
-	for ((iter)->next_id = (start_blkcg_id);			\
-	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL; }); )
-
 static inline int inode_congested(struct inode *inode, int cong_bits)
 {
 	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -480,6 +480,10 @@ static void cgwb_release_workfn(struct w
 						release_work);
 	struct backing_dev_info *bdi = wb->bdi;
 
+	spin_lock_irq(&cgwb_lock);
+	list_del_rcu(&wb->bdi_node);
+	spin_unlock_irq(&cgwb_lock);
+
 	wb_shutdown(wb);
 
 	css_put(wb->memcg_css);
@@ -575,6 +579,7 @@ static int cgwb_create(struct backing_de
 		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
 		if (!ret) {
 			atomic_inc(&bdi->usage_cnt);
+			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
 			list_add(&wb->blkcg_node, blkcg_cgwb_list);
 			css_get(memcg_css);
@@ -764,15 +769,22 @@ static void cgwb_bdi_destroy(struct back
 
 int bdi_init(struct backing_dev_info *bdi)
 {
+	int ret;
+
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->wb_list);
 	init_waitqueue_head(&bdi->wb_waitq);
 
-	return cgwb_bdi_init(bdi);
+	ret = cgwb_bdi_init(bdi);
+
+	list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);
+
+	return ret;
 }
 EXPORT_SYMBOL(bdi_init);
 
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1956,7 +1956,6 @@ void laptop_mode_timer_fn(unsigned long
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
 	struct bdi_writeback *wb;
-	struct wb_iter iter;
 
 	/*
 	 * We want to write everything out, not just down to the dirty
@@ -1966,7 +1965,7 @@ void laptop_mode_timer_fn(unsigned long
 		return;
 
 	rcu_read_lock();
-	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
+	list_for_each_entry_rcu(wb, &q->backing_dev_info.wb_list, bdi_node)
 		if (wb_has_dirty_io(wb))
 			wb_start_writeback(wb, nr_pages, true,
 					   WB_REASON_LAPTOP_TIMER);
