From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v5 5/8] blk-throttle: use 'READ/WRITE' instead of '0/1'
Date: Sat, 28 May 2022 14:43:27 +0800
Message-ID: <20220528064330.3471000-6-yukuai3@huawei.com>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220528064330.3471000-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Make the code easier to read, like everywhere else.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 94fd73e8b2d9..454a360f42e8 100644
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
@@ -1150,7 +1150,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 		nr_disp += throtl_dispatch_tg(tg);
 
 		sq = &tg->service_queue;
-		if (sq->nr_queued[0] || sq->nr_queued[1])
+		if (sq->nr_queued[READ] || sq->nr_queued[WRITE])
 			tg_update_disptime(tg);
 
 		if (nr_disp >= THROTL_QUANTUM)
-- 
2.31.1

