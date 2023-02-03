From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/19] blk-wbt: open code wbt_queue_depth_changed in wbt_init
Date: Fri,  3 Feb 2023 16:03:52 +0100
Message-ID: <20230203150400.3199230-12-hch@lst.de>
References: <20230203150400.3199230-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dueVlTMBYMpU6WhcVEk2hjJcCiKSsyRkz1adFsMrdaI=; b=SyYJJQO5gZWmnrdw9pEuZOssZp
        X2kKoQvA70cOOjINeHRQOtnTdb0zhgWY5joVEmXYYZTpJxkN6Rq3sUpN8bsjhT6SkpHYY/d345Amj
        +BxIUvW3zt05MFCRt8Go1Xumr40ZOgMSbiHzMBzCnNKaMT42tH0m5oGHHC2QbOfh0hpEGEG3u4cQP
        jW/drz399Vx2rp5RHRfAdpXSddaJS7WR84pSiI/l5QblXoFQdjxOhUyWAh6oy0mN/b3geUDYKEexg
        KJVlrMIxPeU/saeRkYH6aqTL/h0ojeF4fp3lvchQbhz8Lprbtf37p72HJD1BxQDlJ6o5WRHPMsr86
        KeW5G2jA==;
In-Reply-To: <20230203150400.3199230-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

wbt_queue_depth_changed just updates a field and calls another function.
Open code it in wbt_init, so that the local queue variable can be used
instead of the one stored in the rq_qos.  This will allow delaying that
rq_qos->queue assignment in a subsequent patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-wbt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 58f41a98fda911..119a43671089ea 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -941,8 +941,8 @@ int wbt_init(struct gendisk *disk)
 	rwb->wc = test_bit(QUEUE_FLAG_WC, &q->queue_flags);
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
-
-	wbt_queue_depth_changed(&rwb->rqos);
+	rwb->rq_depth.queue_depth = blk_queue_depth(q);
+	wbt_update_limits(rwb);
 
 	/*
 	 * Assign rwb and add the stats callback.
-- 
2.39.0

