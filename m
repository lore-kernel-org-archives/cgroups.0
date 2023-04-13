From: chengming.zhou@linux.dev
Subject: [PATCH v2 2/2] blk-throttle: only enable blk-stat when BLK_DEV_THROTTLING_LOW
Date: Thu, 13 Apr 2023 14:28:05 +0800
Message-ID: <20230413062805.2081970-2-chengming.zhou@linux.dev>
References: <20230413062805.2081970-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681367321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uuLZUtgeUwzy7HQkKWbC2Y+wAfW1jsm3UvSSwpC9GQ=;
        b=KdB0OD7JaB79oRR+5d+zVaBx/OkQHm1RI0hi4MuiY0fVYA0qanpEgKP47Ya07PQz7534/g
        aGRUTTQBYv29sY1tMk+2zU0xsV6T3eukaU7MRE/bcN8yoQ0O50yRYeqmGlUxm0L9kLz0oN
        tla8TtElBNB6kkQ7rbtyJB2145QiMiA=
In-Reply-To: <20230413062805.2081970-1-chengming.zhou@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: josef@toxicpanda.com, osandov@fb.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

From: Chengming Zhou <zhouchengming@bytedance.com>

blk_throtl_register() will unconditionally enable blk-stat for gendisk
when register, even when we have no BLK_DEV_THROTTLING_LOW config.

Since the kernel always has only BLK_DEV_THROTTLING config and the
BLK_DEV_THROTTLING_LOW config is still in EXPERIMENTAL state, we can
just skip blk-stat when !BLK_DEV_THROTTLING_LOW.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 47e9d8be68f3..3c07c9cfa70a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2439,11 +2439,12 @@ void blk_throtl_register(struct gendisk *disk)
 #ifndef CONFIG_BLK_DEV_THROTTLING_LOW
 	/* if no low limit, use previous default */
 	td->throtl_slice = DFL_THROTL_SLICE_HD;
-#endif
 
+#else
 	td->track_bio_latency = !queue_is_mq(q);
 	if (!td->track_bio_latency)
 		blk_stat_enable_accounting(q);
+#endif
 }
 
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-- 
2.39.2

