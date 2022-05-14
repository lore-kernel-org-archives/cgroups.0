From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 6/8] block, bfq: remove dead code for updating 'rq_in_driver'
Date: Sat, 14 May 2022 17:05:20 +0800
Message-ID: <20220514090522.1669270-7-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Such code are not even compiled since they are inside marco "#if 0".

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 1d0141c450c0..e36a16684fb4 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2322,22 +2322,6 @@ static sector_t get_sdist(sector_t last_pos, struct request *rq)
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

