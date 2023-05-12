From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 3/6] blk-wbt: remove dead code to handle wbt enable/disable with io inflight
Date: Fri, 12 May 2023 17:35:51 +0800
Message-ID: <20230512093554.911753-4-yukuai1@huaweicloud.com>
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

enable or disable wbt is always called with queue freezed, so that wbt
can never be enabled or disabled while io is still inflight, and this
behaviour should always hold to avoid io hang(There have been reported
several times).

Therefor, the code to handle wbt enable/diskble with io inflight is not
and never will be used, hence remove such dead code.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-wbt.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 9ec2a2f1eda3..cb464c572840 100644
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

