From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 1/4] blk-throttle: use 'READ/WRITE' instead of '0/1'
Date: Tue, 23 Aug 2022 09:38:07 +0800
Message-ID: <20220823013810.406075-2-yukuai1@huaweicloud.com>
References: <20220823013810.406075-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220823013810.406075-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Make the code easier to read, like everywhere else.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9f5fe62afff9..fe1fa6441105 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -329,8 +329,8 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
 /* init a service_queue, assumes the caller zeroed it */
 static void throtl_service_queue_init(struct throtl_service_queue *sq)
 {
-	INIT_LIST_HEAD(&sq->queued[0]);
-	INIT_LIST_HEAD(&sq->queued[1]);
+	INIT_LIST_HEAD(&sq->queued[READ]);
+	INIT_LIST_HEAD(&sq->queued[WRITE]);
 	sq->pending_tree = RB_ROOT_CACHED;
 	timer_setup(&sq->pending_timer, throtl_pending_timer_fn, 0);
 }
@@ -1106,7 +1106,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 		nr_disp += throtl_dispatch_tg(tg);
 
 		sq = &tg->service_queue;
-		if (sq->nr_queued[0] || sq->nr_queued[1])
+		if (sq->nr_queued[READ] || sq->nr_queued[WRITE])
 			tg_update_disptime(tg);
 
 		if (nr_disp >= THROTL_QUANTUM)
-- 
2.31.1

