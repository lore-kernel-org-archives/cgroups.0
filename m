From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 7/8] blk-throttle: Open code __throtl_de/enqueue_tg()
Date: Thu,  8 Oct 2020 11:52:28 +0800
Message-ID: <6a43ae990da3163204bae3ddedb6025d73b91545.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The __throtl_de/enqueue_tg() functions are only be called by
throtl_de/enqueue_tg(), thus we can just open code them to
make code more readable.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 38aed8b..fc5c14f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -691,29 +691,21 @@ static void tg_service_queue_add(struct throtl_grp *tg)
 			       leftmost);
 }
 
-static void __throtl_enqueue_tg(struct throtl_grp *tg)
-{
-	tg_service_queue_add(tg);
-	tg->flags |= THROTL_TG_PENDING;
-	tg->service_queue.parent_sq->nr_pending++;
-}
-
 static void throtl_enqueue_tg(struct throtl_grp *tg)
 {
-	if (!(tg->flags & THROTL_TG_PENDING))
-		__throtl_enqueue_tg(tg);
-}
-
-static void __throtl_dequeue_tg(struct throtl_grp *tg)
-{
-	throtl_rb_erase(&tg->rb_node, tg->service_queue.parent_sq);
-	tg->flags &= ~THROTL_TG_PENDING;
+	if (!(tg->flags & THROTL_TG_PENDING)) {
+		tg_service_queue_add(tg);
+		tg->flags |= THROTL_TG_PENDING;
+		tg->service_queue.parent_sq->nr_pending++;
+	}
 }
 
 static void throtl_dequeue_tg(struct throtl_grp *tg)
 {
-	if (tg->flags & THROTL_TG_PENDING)
-		__throtl_dequeue_tg(tg);
+	if (tg->flags & THROTL_TG_PENDING) {
+		throtl_rb_erase(&tg->rb_node, tg->service_queue.parent_sq);
+		tg->flags &= ~THROTL_TG_PENDING;
+	}
 }
 
 /* Call with queue lock held */
-- 
1.8.3.1

