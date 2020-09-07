From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 1/5] blk-throttle: Fix some comments' typos
Date: Mon,  7 Sep 2020 16:10:13 +0800
Message-ID: <e9451429c646d2f34b4225e2f0d716bc1e8dad5f.1599458244.git.baolin.wang@linux.alibaba.com>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1599458244.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
In-Reply-To: <cover.1599458244.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
References: <cover.1599458244.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Fix some comments' typos.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 block/blk-throttle.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fee3325..2fc6c3e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -150,7 +150,7 @@ struct throtl_grp {
 	/* user configured IOPS limits */
 	unsigned int iops_conf[2][LIMIT_CNT];
 
-	/* Number of bytes disptached in current slice */
+	/* Number of bytes dispatched in current slice */
 	uint64_t bytes_disp[2];
 	/* Number of bio's dispatched in current slice */
 	unsigned int io_disp[2];
@@ -852,7 +852,7 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 	/*
 	 * A bio has been dispatched. Also adjust slice_end. It might happen
 	 * that initially cgroup limit was very low resulting in high
-	 * slice_end, but later limit was bumped up and bio was dispached
+	 * slice_end, but later limit was bumped up and bio was dispatched
 	 * sooner, then we need to reduce slice_end. A high bogus slice_end
 	 * is bad because it does not allow new slice to start.
 	 */
@@ -1082,7 +1082,7 @@ static void throtl_add_bio_tg(struct bio *bio, struct throtl_qnode *qn,
 	 * If @tg doesn't currently have any bios queued in the same
 	 * direction, queueing @bio can change when @tg should be
 	 * dispatched.  Mark that @tg was empty.  This is automatically
-	 * cleaered on the next tg_update_disptime().
+	 * cleared on the next tg_update_disptime().
 	 */
 	if (!sq->nr_queued[rw])
 		tg->flags |= THROTL_TG_WAS_EMPTY;
@@ -1303,7 +1303,7 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 			}
 		}
 	} else {
-		/* reached the top-level, queue issueing */
+		/* reached the top-level, queue issuing */
 		queue_work(kthrotld_workqueue, &td->dispatch_work);
 	}
 out_unlock:
@@ -1314,8 +1314,8 @@ static void throtl_pending_timer_fn(struct timer_list *t)
  * blk_throtl_dispatch_work_fn - work function for throtl_data->dispatch_work
  * @work: work item being executed
  *
- * This function is queued for execution when bio's reach the bio_lists[]
- * of throtl_data->service_queue.  Those bio's are ready and issued by this
+ * This function is queued for execution when bios reach the bio_lists[]
+ * of throtl_data->service_queue.  Those bios are ready and issued by this
  * function.
  */
 static void blk_throtl_dispatch_work_fn(struct work_struct *work)
@@ -2230,7 +2230,7 @@ bool blk_throtl_bio(struct bio *bio)
 
 		/*
 		 * @bio passed through this layer without being throttled.
-		 * Climb up the ladder.  If we''re already at the top, it
+		 * Climb up the ladder.  If we're already at the top, it
 		 * can be executed directly.
 		 */
 		qn = &tg->qnode_on_parent[rw];
-- 
1.8.3.1

