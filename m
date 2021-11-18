From: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next] blk-throttle: Set BIO_THROTTLED when bio has been throttled
Date: Thu, 18 Nov 2021 21:15:51 +0800
Message-ID: <20211118131551.810931-1-qiulaibin@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

1.In current process, all bio will set the BIO_THROTTLED flag
after __blk_throtl_bio().

2.If bio needs to be throttled, it will start the timer and
stop submit bio directly. Bio will submit in blk_throtl_dispatch_work_fn()
when the timer expires. But in the current process, if bio is throttled.
The BIO_THROTTLED will be set to bio after timer start. If the bio
has been completed, it may cause use-after-free.

Fix this by move BIO_THROTTLED set before timer set.

Signed-off-by: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e68a9a2..ddfbff4465d5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2149,6 +2149,7 @@ bool __blk_throtl_bio(struct bio *bio)
 	td->nr_queued[rw]++;
 	throtl_add_bio_tg(bio, qn, tg);
 	throttled = true;
+	bio_set_flag(bio, BIO_THROTTLED);
 
 	/*
 	 * Update @tg's dispatch time and force schedule dispatch if @tg
@@ -2163,7 +2164,6 @@ bool __blk_throtl_bio(struct bio *bio)
 
 out_unlock:
 	spin_unlock_irq(&q->queue_lock);
-	bio_set_flag(bio, BIO_THROTTLED);
 
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	if (throttled || !td->track_bio_latency)
-- 
2.22.0

