From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v2 6/6] block, bfq: remove dead code for updating 'rq_in_driver'
Date: Sat, 21 May 2022 15:35:23 +0800
Message-ID: <20220521073523.3118246-7-yukuai3@huawei.com>
References: <20220521073523.3118246-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220521073523.3118246-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Such code are not even compiled since they are inside marco "#if 0".

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index c0bc463d236c..be75bd9835f5 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2323,22 +2323,6 @@ static sector_t get_sdist(sector_t last_pos, struct request *rq)
 	return 0;
 }
 
-#if 0 /* Still not clear if we can do without next two functions */
-static void bfq_activate_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-
-	bfqd->rq_in_driver++;
-}
-
-static void bfq_deactivate_request(struct request_queue *q, struct request *rq)
-{
-	struct bfq_data *bfqd = q->elevator->elevator_data;
-
-	bfqd->rq_in_driver--;
-}
-#endif
-
 static void bfq_remove_request(struct request_queue *q,
 			       struct request *rq)
 {
-- 
2.31.1

