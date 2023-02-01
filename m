From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/19] blk-wbt: open code wbt_queue_depth_changed in wbt_init
Date: Wed,  1 Feb 2023 14:41:15 +0100
Message-ID: <20230201134123.2656505-12-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=//9XVBmwitzpx1zfUZBw7kGuOnkJqlI6wOiJGG7ywCA=; b=qOs1Rxkk06oUvugIpXW2xpcEQE
        C2v9rFBDkUIg02Hx7CBEGyZJuT3G/EPKVEvuIZEyQxTnolxyyWj+9DpV4wRE6vKaWPzjGEYxYqDIv
        HWYqQ6w2p4zNEbTNSKeM+9dLIviKcasY0TPmJqXHNm0NTFGzmh3Gi24PKlzWs2wdSNSbeKotuaE9z
        Jo9/l2MbRIX0B/9dZ7zolcHGg5RVUo3QMe6R87RifKO8Zln+PNGoKPBVt7WgVO9aiUW5h2q6tlFhP
        jct/4PPwJVLaIhz9tNSkXlofQnvr4tRDGGRQnWYeuQ+VLmqGuM9rjmpryPPwd2MX0qVQkGFN6wuEh
        hFx5wADw==;
In-Reply-To: <20230201134123.2656505-1-hch@lst.de>
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

