From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 4/4] blk-wbt: rename __wbt_update_limits to wbt_update_limits
Date: Sat,  9 May 2020 00:00:15 +0200
Message-ID: <20200508220015.11528-5-guoqing.jiang@cloud.ionos.com>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2bZEmVPj4bBPSpoxrezTXCxfraC/gVscBnU3FXpehw0=;
        b=fdj9m72Ets8NDXsiWFaO7GJwzxJsctQZwipDjgjjrqAisSHYUDTubMx2iwb6ZF6wZE
         HDfLsfdeZoudSXm8OBhapUknILrelw007SvvkN0Z83/elWMsEzQM9hoiK/YUfDTPGz+8
         6Ry/cj8maY9eX6iBpRlqNXpBpQRqp4mIr/+C6w3NflOfIWlb+jsRO4I+aK9Rpd/0HSBl
         Rxk/TOa809u9NPoGKeCZWj8lj4/jgLH65OsWPDEJepHH4Suz6lNEeH2kd8RyQR84Icbq
         pfgYQYNSzqsfKu7sz8mt8Oc2tER9x8XEYsFYsV5kFxbGwjBTL4yEZRO/G3hP2Gbtnp0x
         A0+A==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Now let's rename __wbt_update_limits to wbt_update_limits after the
previous one is deleted.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 block/blk-wbt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 78bb624cce53..0fa615eefd52 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -405,7 +405,7 @@ static void wb_timer_fn(struct blk_stat_callback *cb)
 		rwb_arm_timer(rwb);
 }
 
-static void __wbt_update_limits(struct rq_wb *rwb)
+static void wbt_update_limits(struct rq_wb *rwb)
 {
 	struct rq_depth *rqd = &rwb->rq_depth;
 
@@ -433,7 +433,7 @@ void wbt_set_min_lat(struct request_queue *q, u64 val)
 		return;
 	RQWB(rqos)->min_lat_nsec = val;
 	RQWB(rqos)->enable_state = WBT_STATE_ON_MANUAL;
-	__wbt_update_limits(RQWB(rqos));
+	wbt_update_limits(RQWB(rqos));
 }
 
 
@@ -677,7 +677,7 @@ static int wbt_data_dir(const struct request *rq)
 static void wbt_queue_depth_changed(struct rq_qos *rqos)
 {
 	RQWB(rqos)->rq_depth.queue_depth = blk_queue_depth(rqos->q);
-	__wbt_update_limits(RQWB(rqos));
+	wbt_update_limits(RQWB(rqos));
 }
 
 static void wbt_exit(struct rq_qos *rqos)
@@ -835,7 +835,7 @@ int wbt_init(struct request_queue *q)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = 1;
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
-	__wbt_update_limits(rwb);
+	wbt_update_limits(rwb);
 
 	/*
 	 * Assign rwb and add the stats callback.
-- 
2.17.1

