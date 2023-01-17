From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/15] blk-wbt: open code wbt_queue_depth_changed in wbt_update_limits
Date: Tue, 17 Jan 2023 09:12:50 +0100
Message-ID: <20230117081257.3089859-9-hch@lst.de>
References: <20230117081257.3089859-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=D7iveQQJvLZA+RyWbRj86WCFcsszq3bZhAAbH9IGkEc=; b=uA1chXUQ+v2W3OmeiRzuWVlKkg
        f/WyGcEHq1NhAGU6r56rADizFFgjT7XRWDGH6jJGTTNcDg4y3GmF/8zFh/4gMQ80mRMFt6lGU09r/
        iWigeKjSPCVkAXT3tWvUn+tRSKcM8jiR57OpinaI20cGNkUYwfhvyyL4xfNRNzDFbpENDfP6i44v8
        5VngnNWra3VZqrKl+NLRCpr55UYwIwLy3DB2MexEoVHntblQrnSrd0bYLJIXC+sqDgb2XBs2TDsi4
        zS71e2rkLB6snN7H9vNOhdSEx4kxREs1FMhjPKcMn14Ow5GyI+FXDdIYWZqlyNxhzC7CJ6egbLVE6
        foTr/iIg==;
In-Reply-To: <20230117081257.3089859-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

No real need to all the method here, so open code to it to prepare
for some paramter passing changes.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-wbt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 542271fa99e8f7..473ae72befaf1a 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -863,9 +863,9 @@ int wbt_init(struct gendisk *disk)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = test_bit(QUEUE_FLAG_WC, &q->queue_flags);
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
+	rwb->rq_depth.queue_depth = blk_queue_depth(q);
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
-
-	wbt_queue_depth_changed(&rwb->rqos);
+	wbt_update_limits(rwb);
 
 	/*
 	 * Assign rwb and add the stats callback.
-- 
2.39.0

