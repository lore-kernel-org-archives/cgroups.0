From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 4/6] blk-wbt: remove deadcode to handle wbt enable/disable with io inflight
Date: Thu, 11 May 2023 09:45:07 +0800
Message-ID: <20230511014509.679482-5-yukuai1@huaweicloud.com>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230511014509.679482-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

enable or disable wbt is always called with queue freezed, so that wbt
can never be enabled or disabled while io is still inflight, and this
behaviour should always hold to avoid io hang(There have been reported
several times).

Therefor, the code to handle wbt enable/diskble with io inflight is not
and never will be used, hence remove such deadcode.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-wbt.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index b1ab4688eb5c..7a9a30da8650 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -200,15 +200,6 @@ static void wbt_rqw_done(struct rq_wb *rwb, struct rq_wait *rqw,
 
 	inflight = atomic_dec_return(&rqw->inflight);
 
-	/*
-	 * wbt got disabled with IO in flight. Wake up any potential
-	 * waiters, we don't have to do more than that.
-	 */
-	if (unlikely(!rwb_enabled(rwb))) {
-		rwb_wake_all(rwb);
-		return;
-	}
-
 	/*
 	 * For discards, our limit is always the background. For writes, if
 	 * the device does write back caching, drop further down before we
@@ -545,13 +536,6 @@ static inline unsigned int get_limit(struct rq_wb *rwb, blk_opf_t opf)
 {
 	unsigned int limit;
 
-	/*
-	 * If we got disabled, just return UINT_MAX. This ensures that
-	 * we'll properly inc a new IO, and dec+wakeup at the end.
-	 */
-	if (!rwb_enabled(rwb))
-		return UINT_MAX;
-
 	if ((opf & REQ_OP_MASK) == REQ_OP_DISCARD)
 		return rwb->wb_background;
 
-- 
2.39.2

