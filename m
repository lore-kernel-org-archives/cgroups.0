From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 3/8] blk-throttle: Avoid tracking latency if low limit is invalid
Date: Thu,  8 Oct 2020 11:52:24 +0800
Message-ID: <f9fc5822f54e83259186f38ed6354577cbbaae9e.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The IO latency tracking is only for LOW limit, so we should add a
validation to avoid redundant latency tracking if the LOW limit
is not valid.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7e72102..b0d8f7c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2100,7 +2100,7 @@ static void throtl_update_latency_buckets(struct throtl_data *td)
 	unsigned long last_latency[2] = { 0 };
 	unsigned long latency[2];
 
-	if (!blk_queue_nonrot(td->queue))
+	if (!blk_queue_nonrot(td->queue) || !td->limit_valid[LIMIT_LOW])
 		return;
 	if (time_before(jiffies, td->last_calculate_time + HZ))
 		return;
@@ -2338,6 +2338,8 @@ void blk_throtl_bio_endio(struct bio *bio)
 	if (!blkg)
 		return;
 	tg = blkg_to_tg(blkg);
+	if (!tg->td->limit_valid[LIMIT_LOW])
+		return;
 
 	finish_time_ns = ktime_get_ns();
 	tg->last_finish_time = finish_time_ns >> 10;
-- 
1.8.3.1

