From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/45] writeback: minor reorganization of fs/fs-writeback.c
Date: Tue,  6 Jan 2015 16:26:10 -0500
Message-ID: <1420579582-8516-34-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OnX+NSB+MQZeHc3I9JmksfZgaoobSZqSn/473tCRq0Q=;
        b=Cljgwnkxm6P3Jmg0O+78DTGvPZeMlkNPUekUJ1uViKfl5Ev4Ku7fNJHyACkNNTn8Mf
         DW11Dpwoe+lZy+VyfWVZegekUEu0CgZNtxxLrAwq/WcW6N2la2+lLMJKTh8B1He32Rjp
         JEPKRALvacQkhpm390GUu6938xhn/OvcFpGjjxzkPHTF6YZansYs0At+OpbJLQ7t11ZC
         t1t4TQueA7weZxwwcNDlGEeGsWEzqorFOK0TmgszMQEfyxwrS0Kir84yTZ++5ueLb1mP
         BKy4tpo6mL9ezHj/qnXnVwwHhLix73YCi/VCjHeQczmwg/UKCZjo27Xb1FyK+QNR2inX
         zPzQ==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

Move iwbl_{move|del}_locked() and __inode_wait_for_writeback() upwards
before #ifdef CONFIG_CGROUP_WRITEBACK block and make separate
identical copies of __inode_wait_for_writeback() in the #ifdef and
#else branches.  The relocation and two copies will help following
cgroup writeback changes.

This is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 199 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 109 insertions(+), 90 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6851088..ab77ed2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -132,6 +132,75 @@ static void wb_wait_for_completion(struct backing_dev_info *bdi,
 	wait_event(bdi->wb_waitq, !atomic_read(&done->cnt));
 }
 
+/**
+ * iwbl_move_locked - move an inode_wb_link onto a bdi_writeback IO list
+ * @iwbl: inode_wb_link to be moved
+ * @wb: target bdi_writeback
+ * @head: one of @wb->b_{dirty|io|more_io}
+ *
+ * Move @iwbl->dirty_list to @list of @wb and set %WB_has_dirty_io.
+ * Returns %true if all IO lists were empty before; otherwise, %false.
+ */
+static bool iwbl_move_locked(struct inode_wb_link *iwbl,
+			     struct bdi_writeback *wb, struct list_head *head)
+{
+	assert_spin_locked(&wb->list_lock);
+
+	list_move(&iwbl->dirty_list, head);
+
+	if (wb_has_dirty_io(wb)) {
+		return false;
+	} else {
+		set_bit(WB_has_dirty_io, &wb->state);
+		WARN_ON_ONCE(!wb->avg_write_bandwidth);
+		atomic_long_add(wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
+		return true;
+	}
+}
+
+/**
+ * iwbl_del_locked - remove an inode_wb_link from its bdi_writeback IO list
+ * @iwbl: inode_wb_link to be removed
+ * @wb: bdi_writeback @inode is being removed from
+ *
+ * Remove @iwbl which may be on one of @wb->b_{dirty|io|more_io} lists and
+ * clear %WB_has_dirty_io if all are empty afterwards.
+ */
+static void iwbl_del_locked(struct inode_wb_link *iwbl,
+			    struct bdi_writeback *wb)
+{
+	assert_spin_locked(&wb->list_lock);
+
+	list_del_init(&iwbl->dirty_list);
+
+	if (wb_has_dirty_io(wb) && list_empty(&wb->b_dirty) &&
+	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io)) {
+		clear_bit(WB_has_dirty_io, &wb->state);
+		WARN_ON_ONCE(atomic_long_sub_return(wb->avg_write_bandwidth,
+					&wb->bdi->tot_write_bandwidth) < 0);
+	}
+}
+
+/*
+ * Wait for writeback on an inode to complete. Called with i_lock held.
+ * Caller must make sure inode cannot go away when we drop i_lock.
+ */
+static void __inode_wait_for_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+	__acquires(inode->i_lock)
+{
+	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
+	wait_queue_head_t *wqh;
+
+	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
+	while (inode->i_state & I_SYNC) {
+		spin_unlock(&inode->i_lock);
+		__wait_on_bit(wqh, &wq, bit_wait, TASK_UNINTERRUPTIBLE);
+		spin_lock(&inode->i_lock);
+	}
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 /**
@@ -331,6 +400,26 @@ restart:
 	rcu_read_unlock();
 }
 
+/*
+ * Sleep until I_SYNC is cleared. This function must be called with i_lock
+ * held and drops it. It is aimed for callers not holding any inode reference
+ * so once i_lock is dropped, inode can go away.
+ */
+static void inode_sleep_on_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+{
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
+	int sleep;
+
+	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
+	sleep = inode->i_state & I_SYNC;
+	spin_unlock(&inode->i_lock);
+	if (sleep)
+		schedule();
+	finish_wait(wqh, &wait);
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static void init_cgwb_dirty_page_context(struct dirty_context *dctx)
@@ -358,6 +447,26 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 	}
 }
 
+/*
+ * Sleep until I_SYNC is cleared. This function must be called with i_lock
+ * held and drops it. It is aimed for callers not holding any inode reference
+ * so once i_lock is dropped, inode can go away.
+ */
+static void inode_sleep_on_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+{
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
+	int sleep;
+
+	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
+	sleep = inode->i_state & I_SYNC;
+	spin_unlock(&inode->i_lock);
+	if (sleep)
+		schedule();
+	finish_wait(wqh, &wait);
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /**
@@ -451,56 +560,6 @@ void wb_start_background_writeback(struct bdi_writeback *wb)
 	wb_wakeup(wb);
 }
 
-/**
- * iwbl_move_locked - move an inode_wb_link onto a bdi_writeback IO list
- * @iwbl: inode_wb_link to be moved
- * @wb: target bdi_writeback
- * @head: one of @wb->b_{dirty|io|more_io}
- *
- * Move @iwbl->dirty_list to @list of @wb and set %WB_has_dirty_io.
- * Returns %true if all IO lists were empty before; otherwise, %false.
- */
-static bool iwbl_move_locked(struct inode_wb_link *iwbl,
-			     struct bdi_writeback *wb, struct list_head *head)
-{
-	assert_spin_locked(&wb->list_lock);
-
-	list_move(&iwbl->dirty_list, head);
-
-	if (wb_has_dirty_io(wb)) {
-		return false;
-	} else {
-		set_bit(WB_has_dirty_io, &wb->state);
-		WARN_ON_ONCE(!wb->avg_write_bandwidth);
-		atomic_long_add(wb->avg_write_bandwidth,
-				&wb->bdi->tot_write_bandwidth);
-		return true;
-	}
-}
-
-/**
- * iwbl_del_locked - remove an inode_wb_link from its bdi_writeback IO list
- * @iwbl: inode_wb_link to be removed
- * @wb: bdi_writeback @inode is being removed from
- *
- * Remove @iwbl which may be on one of @wb->b_{dirty|io|more_io} lists and
- * clear %WB_has_dirty_io if all are empty afterwards.
- */
-static void iwbl_del_locked(struct inode_wb_link *iwbl,
-			    struct bdi_writeback *wb)
-{
-	assert_spin_locked(&wb->list_lock);
-
-	list_del_init(&iwbl->dirty_list);
-
-	if (wb_has_dirty_io(wb) && list_empty(&wb->b_dirty) &&
-	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io)) {
-		clear_bit(WB_has_dirty_io, &wb->state);
-		WARN_ON_ONCE(atomic_long_sub_return(wb->avg_write_bandwidth,
-					&wb->bdi->tot_write_bandwidth) < 0);
-	}
-}
-
 /*
  * Remove the inode from the writeback list it is on.
  */
@@ -657,26 +716,6 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
 }
 
 /*
- * Wait for writeback on an inode to complete. Called with i_lock held.
- * Caller must make sure inode cannot go away when we drop i_lock.
- */
-static void __inode_wait_for_writeback(struct inode *inode)
-	__releases(inode->i_lock)
-	__acquires(inode->i_lock)
-{
-	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
-	wait_queue_head_t *wqh;
-
-	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
-	while (inode->i_state & I_SYNC) {
-		spin_unlock(&inode->i_lock);
-		__wait_on_bit(wqh, &wq, bit_wait,
-			      TASK_UNINTERRUPTIBLE);
-		spin_lock(&inode->i_lock);
-	}
-}
-
-/*
  * Wait for writeback on an inode to complete. Caller must have inode pinned.
  */
 void inode_wait_for_writeback(struct inode *inode)
@@ -687,26 +726,6 @@ void inode_wait_for_writeback(struct inode *inode)
 }
 
 /*
- * Sleep until I_SYNC is cleared. This function must be called with i_lock
- * held and drops it. It is aimed for callers not holding any inode reference
- * so once i_lock is dropped, inode can go away.
- */
-static void inode_sleep_on_writeback(struct inode *inode)
-	__releases(inode->i_lock)
-{
-	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
-	int sleep;
-
-	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
-	sleep = inode->i_state & I_SYNC;
-	spin_unlock(&inode->i_lock);
-	if (sleep)
-		schedule();
-	finish_wait(wqh, &wait);
-}
-
-/*
  * Find proper writeback list for the inode depending on its current state and
  * possibly also change of its state while we were doing writeback.  Here we
  * handle things such as livelock prevention or fairness of writeback among
-- 
2.1.0
