From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 1/6] blk-wbt: fix that wbt can't be disabled by default
Date: Fri, 12 May 2023 17:35:49 +0800
Message-ID: <20230512093554.911753-2-yukuai1@huaweicloud.com>
References: <20230512093554.911753-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20230512093554.911753-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: lukas.bulwahn@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

commit b11d31ae01e6 ("blk-wbt: remove unnecessary check in
wbt_enable_default()") removes the checking of CONFIG_BLK_WBT_MQ by
mistake, which is used to control enable or disable wbt by default.

Fix the problem by adding back the checking. This patch also do a litter
cleanup to make related code more readable.

Fixes: b11d31ae01e6 ("blk-wbt: remove unnecessary check in wbt_enable_default()")
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/lkml/CAKXUXMzfKq_J9nKHGyr5P5rvUETY4B-fxoQD4sO+NYjFOfVtZA@mail.gmail.com/t/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-wbt.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index e49a48684532..9ec2a2f1eda3 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -730,14 +730,16 @@ void wbt_enable_default(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct rq_qos *rqos;
-	bool disable_flag = q->elevator &&
-		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags);
+	bool enable = IS_ENABLED(CONFIG_BLK_WBT_MQ);
+
+	if (q->elevator &&
+	    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags))
+		enable = false;
 
 	/* Throttling already enabled? */
 	rqos = wbt_rq_qos(q);
 	if (rqos) {
-		if (!disable_flag &&
-		    RQWB(rqos)->enable_state == WBT_STATE_OFF_DEFAULT)
+		if (enable && RQWB(rqos)->enable_state == WBT_STATE_OFF_DEFAULT)
 			RQWB(rqos)->enable_state = WBT_STATE_ON_DEFAULT;
 		return;
 	}
@@ -746,7 +748,7 @@ void wbt_enable_default(struct gendisk *disk)
 	if (!blk_queue_registered(q))
 		return;
 
-	if (queue_is_mq(q) && !disable_flag)
+	if (queue_is_mq(q) && enable)
 		wbt_init(disk);
 }
 EXPORT_SYMBOL_GPL(wbt_enable_default);
-- 
2.39.2

