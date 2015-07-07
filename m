From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] writeback: remove wb_writeback_work->single_wait/done
Date: Tue,  7 Jul 2015 11:10:20 -0400
Message-ID: <1436281823-1947-3-git-send-email-tj@kernel.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=USXxolGbmCs8u+1d+yt555yaREvZ1tCUXJjhm/ZhiII=;
        b=PtNKkPiiqmYw0yOuHGllzePVaj2ubJYyuvzOjIuDJbvQUbdsjKlTSqSpdateqOiErg
         p3BUpUkfHC1K5lh0rF39OyjPJRZ9+s4p4/IkwEOGfXqTXeAhroeteJQZ1u85upwhVp+v
         ThYQdvFnEGROdMLu8334dRHWgGkaxo+MB+SwcYturkEuKwrEJzUeLbcWfQRXPP9C26As
         d1R236gmJm7dm3aEdNzS3w3YB1rFv3ylQ7L53alkEOmyEikNikjAdJT9GltUp5VfKtgO
         3Cj09PwwLlx5gtraJGR4TydFP5PKjCfzcTuKGqKyhke/zW+S4hjfnYMQQnWpSnDx9HXM
         jqZQ==
In-Reply-To: <1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

wb_writeback_work->single_wait/done are used for the wait mechanism
for synchronous wb_work (wb_writeback_work) items which are issued
when bdi_split_work_to_wbs() fails to allocate memory for asynchronous
wb_work items; however, there's no reason to use a separate wait
mechanism for this.  bdi_split_work_to_wbs() can simply use on-stack
fallback wb_work item and separate wb_completion to wait for it.

This patch removes wb_work->single_wait/done and the related code and
make bdi_split_work_to_wbs() use on-stack fallback wb_work and
wb_completion instead.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/fs-writeback.c | 116 ++++++++++++++----------------------------------------
 1 file changed, 30 insertions(+), 86 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6079922..f15148c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -53,8 +53,6 @@ struct wb_writeback_work {
 	unsigned int for_background:1;
 	unsigned int for_sync:1;	/* sync(2) WB_SYNC_ALL writeback */
 	unsigned int auto_free:1;	/* free on completion */
-	unsigned int single_wait:1;
-	unsigned int single_done:1;
 	enum wb_reason reason;		/* why was writeback initiated? */
 
 	struct list_head list;		/* pending work list */
@@ -181,11 +179,8 @@ static void wb_queue_work(struct bdi_writeback *wb,
 	trace_writeback_queue(wb->bdi, work);
 
 	spin_lock_bh(&wb->work_lock);
-	if (!test_bit(WB_registered, &wb->state)) {
-		if (work->single_wait)
-			work->single_done = 1;
+	if (!test_bit(WB_registered, &wb->state))
 		goto out_unlock;
-	}
 	if (work->done)
 		atomic_inc(&work->done->cnt);
 	list_add_tail(&work->list, &wb->work_list);
@@ -737,32 +732,6 @@ int inode_congested(struct inode *inode, int cong_bits)
 EXPORT_SYMBOL_GPL(inode_congested);
 
 /**
- * wb_wait_for_single_work - wait for completion of a single bdi_writeback_work
- * @bdi: bdi the work item was issued to
- * @work: work item to wait for
- *
- * Wait for the completion of @work which was issued to one of @bdi's
- * bdi_writeback's.  The caller must have set @work->single_wait before
- * issuing it.  This wait operates independently fo
- * wb_wait_for_completion() and also disables automatic freeing of @work.
- */
-static void wb_wait_for_single_work(struct backing_dev_info *bdi,
-				    struct wb_writeback_work *work)
-{
-	if (WARN_ON_ONCE(!work->single_wait))
-		return;
-
-	wait_event(bdi->wb_waitq, work->single_done);
-
-	/*
-	 * Paired with smp_wmb() in wb_do_writeback() and ensures that all
-	 * modifications to @work prior to assertion of ->single_done is
-	 * visible to the caller once this function returns.
-	 */
-	smp_rmb();
-}
-
-/**
  * wb_split_bdi_pages - split nr_pages to write according to bandwidth
  * @wb: target bdi_writeback to split @nr_pages to
  * @nr_pages: number of pages to write for the whole bdi
@@ -791,38 +760,6 @@ static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
 }
 
 /**
- * wb_clone_and_queue_work - clone a wb_writeback_work and issue it to a wb
- * @wb: target bdi_writeback
- * @base_work: source wb_writeback_work
- *
- * Try to make a clone of @base_work and issue it to @wb.  If cloning
- * succeeds, %true is returned; otherwise, @base_work is issued directly
- * and %false is returned.  In the latter case, the caller is required to
- * wait for @base_work's completion using wb_wait_for_single_work().
- *
- * A clone is auto-freed on completion.  @base_work never is.
- */
-static bool wb_clone_and_queue_work(struct bdi_writeback *wb,
-				    struct wb_writeback_work *base_work)
-{
-	struct wb_writeback_work *work;
-
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		*work = *base_work;
-		work->auto_free = 1;
-		work->single_wait = 0;
-	} else {
-		work = base_work;
-		work->auto_free = 0;
-		work->single_wait = 1;
-	}
-	work->single_done = 0;
-	wb_queue_work(wb, work);
-	return work != base_work;
-}
-
-/**
  * bdi_split_work_to_wbs - split a wb_writeback_work to all wb's of a bdi
  * @bdi: target backing_dev_info
  * @base_work: wb_writeback_work to issue
@@ -837,7 +774,6 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 				  struct wb_writeback_work *base_work,
 				  bool skip_if_busy)
 {
-	long nr_pages = base_work->nr_pages;
 	int next_memcg_id = 0;
 	struct bdi_writeback *wb;
 	struct wb_iter iter;
@@ -849,17 +785,39 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 restart:
 	rcu_read_lock();
 	bdi_for_each_wb(wb, bdi, &iter, next_memcg_id) {
+		DEFINE_WB_COMPLETION_ONSTACK(fallback_work_done);
+		struct wb_writeback_work fallback_work;
+		struct wb_writeback_work *work;
+		long nr_pages;
+
 		if (!wb_has_dirty_io(wb) ||
 		    (skip_if_busy && writeback_in_progress(wb)))
 			continue;
 
-		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
-		if (!wb_clone_and_queue_work(wb, base_work)) {
-			next_memcg_id = wb->memcg_css->id + 1;
-			rcu_read_unlock();
-			wb_wait_for_single_work(bdi, base_work);
-			goto restart;
+		nr_pages = wb_split_bdi_pages(wb, base_work->nr_pages);
+
+		work = kmalloc(sizeof(*work), GFP_ATOMIC);
+		if (work) {
+			*work = *base_work;
+			work->nr_pages = nr_pages;
+			work->auto_free = 1;
+			wb_queue_work(wb, work);
+			continue;
 		}
+
+		/* alloc failed, execute synchronously using on-stack fallback */
+		work = &fallback_work;
+		*work = *base_work;
+		work->nr_pages = nr_pages;
+		work->auto_free = 0;
+		work->done = &fallback_work_done;
+
+		wb_queue_work(wb, work);
+
+		next_memcg_id = wb->memcg_css->id + 1;
+		rcu_read_unlock();
+		wb_wait_for_completion(bdi, &fallback_work_done);
+		goto restart;
 	}
 	rcu_read_unlock();
 }
@@ -901,8 +859,6 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 	if (bdi_has_dirty_io(bdi) &&
 	    (!skip_if_busy || !writeback_in_progress(&bdi->wb))) {
 		base_work->auto_free = 0;
-		base_work->single_wait = 0;
-		base_work->single_done = 0;
 		wb_queue_work(&bdi->wb, base_work);
 	}
 }
@@ -1793,26 +1749,14 @@ static long wb_do_writeback(struct bdi_writeback *wb)
 	set_bit(WB_writeback_running, &wb->state);
 	while ((work = get_next_work_item(wb)) != NULL) {
 		struct wb_completion *done = work->done;
-		bool need_wake_up = false;
 
 		trace_writeback_exec(wb->bdi, work);
 
 		wrote += wb_writeback(wb, work);
 
-		if (work->single_wait) {
-			WARN_ON_ONCE(work->auto_free);
-			/* paired w/ rmb in wb_wait_for_single_work() */
-			smp_wmb();
-			work->single_done = 1;
-			need_wake_up = true;
-		} else if (work->auto_free) {
+		if (work->auto_free)
 			kfree(work);
-		}
-
 		if (done && atomic_dec_and_test(&done->cnt))
-			need_wake_up = true;
-
-		if (need_wake_up)
 			wake_up_all(&wb->bdi->wb_waitq);
 	}
 
-- 
2.4.3
