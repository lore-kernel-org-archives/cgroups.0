From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 6/8] blk-throttle: Move service tree validation out of the throtl_rb_first()
Date: Thu,  8 Oct 2020 11:52:27 +0800
Message-ID: <a35c029a21514c4e14f99ef4f638340f3270eb60.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
In-Reply-To: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
References: <cover.1602128837.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The throtl_schedule_next_dispatch() will validate if the service queue
is empty before calling update_min_dispatch_time(), and the
update_min_dispatch_time() will call throtl_rb_first(), which will
validate service queue again.

Thus we can move the service queue validation out of the
throtl_rb_first() to remove the redundant validation in the fast path.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 block/blk-throttle.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f1bcb5c..38aed8b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -638,9 +638,6 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 throtl_rb_first(struct throtl_service_queue *parent_sq)
 {
 	struct rb_node *n;
-	/* Service tree is empty */
-	if (!parent_sq->nr_pending)
-		return NULL;
 
 	n = rb_first_cached(&parent_sq->pending_tree);
 	WARN_ON_ONCE(!n);
@@ -1224,9 +1221,13 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 	unsigned int nr_disp = 0;
 
 	while (1) {
-		struct throtl_grp *tg = throtl_rb_first(parent_sq);
+		struct throtl_grp *tg;
 		struct throtl_service_queue *sq;
 
+		if (!parent_sq->nr_pending)
+			break;
+
+		tg = throtl_rb_first(parent_sq);
 		if (!tg)
 			break;
 
-- 
1.8.3.1

