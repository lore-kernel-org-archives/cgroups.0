From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v4 4/5] block, bfq: remove dead code for updating 'rq_in_driver'
Date: Wed,  2 Nov 2022 10:25:41 +0800
Message-ID: <20221102022542.3621219-5-yukuai1@huaweicloud.com>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221102022542.3621219-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Such code are not even compiled since they are inside marco "#if 0".

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
---
 block/bfq-iosched.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 42aa5fc7f17b..2381cf220ba2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2321,22 +2321,6 @@ static sector_t get_sdist(sector_t last_pos, struct request *rq)
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

