From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/15] blk-wbt: open code wbt_queue_depth_changed in wbt_update_limits
Date: Tue, 24 Jan 2023 07:57:08 +0100
Message-ID: <20230124065716.152286-9-hch@lst.de>
References: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uWkrArfjuUhlfffQ0P1IPKAit66kvvYiFVr/571osGw=; b=A63/5NNpZ/L5wVObUfVISsvHZh
        O/U3iJpwGbYKBVSQI8/ucy0rRMNxwWJnVfzam/NhaQ3y3+zjUCtPkk73Jk5ZxBsV2/vZvs8sOL/dy
        lUopbiEDFnhSzwxehhhQMM1xbVEBZ8vsWq38D+ycqrn7HvUY1m+cPTkwwsarTVvOYbUZfV/e67qZY
        pgz8JUEz8ulV3oCnty/BCprhlAVf0uLoQwuxtc5mN5fBEO2BDsuPLtGuwBp7Qm9H7seEW30Je+drD
        d6BNg8lMSo/LkE6L7GAryUGdg0dD1rq9zl63udHnjoDRFQOeTSU7g39IfwfKVSfSn6p2stZL2rKQt
        IPSM0gWg==;
In-Reply-To: <20230124065716.152286-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

No real need to all the method here, so open code to it to prepare
for some paramter passing changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
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

