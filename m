From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 2/4] blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
Date: Tue, 23 Aug 2022 09:38:08 +0800
Message-ID: <20220823013810.406075-3-yukuai1@huaweicloud.com>
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

It's a little weird to call throtl_dequeue_tg() unconditionally in
throtl_select_dispatch(), since it will be called in tg_update_disptime()
again if some bio is still throttled. Thus call it later if there are no
throttled bio. There are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index fe1fa6441105..64002435fa43 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1101,13 +1101,13 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 		if (time_before(jiffies, tg->disptime))
 			break;
 
-		throtl_dequeue_tg(tg);
-
 		nr_disp += throtl_dispatch_tg(tg);
 
 		sq = &tg->service_queue;
 		if (sq->nr_queued[READ] || sq->nr_queued[WRITE])
 			tg_update_disptime(tg);
+		else
+			throtl_dequeue_tg(tg);
 
 		if (nr_disp >= THROTL_QUANTUM)
 			break;
-- 
2.31.1

