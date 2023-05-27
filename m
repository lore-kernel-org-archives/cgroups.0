From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v3 3/5] blk-wbt: cleanup rwb_enabled() and wbt_disabled()
Date: Sat, 27 May 2023 09:06:42 +0800
Message-ID: <20230527010644.647900-4-yukuai1@huaweicloud.com>
References: <20230527010644.647900-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230527010644.647900-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

'wb_normal' will set to 0 if 'min_lat_nsec' is 0, and 'min_lat_nsec' can
only be set to 0 through sysfs configuration where 'WBT_STATE_OFF_MANUAL'
is set together, in the meantime, they can only be cleared together
through sysfs afterwards. Hence 'wb_normal != 0' is the same as
'rwb->enable_state != WBT_STATE_OFF_MANUAL'.

The code is redundan, hence replace the checking of 'wb_normal' to
'enable_state' in rwb_enabled() and reuse rwb_enabled() for
wbt_disabled().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-wbt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index cb464c572840..06d400fa050d 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -146,7 +146,7 @@ enum {
 static inline bool rwb_enabled(struct rq_wb *rwb)
 {
 	return rwb && rwb->enable_state != WBT_STATE_OFF_DEFAULT &&
-		      rwb->wb_normal != 0;
+		      rwb->enable_state != WBT_STATE_OFF_MANUAL;
 }
 
 static void wb_timestamp(struct rq_wb *rwb, unsigned long *var)
@@ -494,8 +494,7 @@ bool wbt_disabled(struct request_queue *q)
 {
 	struct rq_qos *rqos = wbt_rq_qos(q);
 
-	return !rqos || RQWB(rqos)->enable_state == WBT_STATE_OFF_DEFAULT ||
-	       RQWB(rqos)->enable_state == WBT_STATE_OFF_MANUAL;
+	return !rqos || !rwb_enabled(RQWB(rqos));
 }
 
 u64 wbt_get_min_lat(struct request_queue *q)
-- 
2.39.2

