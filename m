From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 09/10] block, bfq: remove unused bfq_wr_max_time in struct bfq_data
Date: Fri, 16 Dec 2022 19:12:29 +0800
Message-ID: <20221216111230.3638832-10-shikemeng@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linfeilong@huawei.com, liuzhiqiang@26.com, shikemeng@huaweicloud.com

bfqd->bfq_wr_max_time is set to 0 in bfq_init_queue and is never changed.
It is only used in bfq_wr_duration when bfq_wr_max_time > 0 which never
meets, so bfqd->bfq_wr_max_time is not used actually. Just remove it.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 block/bfq-iosched.c | 4 ----
 block/bfq-iosched.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 195cdc6be087..91bc68fba72d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1068,9 +1068,6 @@ static unsigned int bfq_wr_duration(struct bfq_data *bfqd)
 {
 	u64 dur;
 
-	if (bfqd->bfq_wr_max_time > 0)
-		return bfqd->bfq_wr_max_time;
-
 	dur = bfqd->rate_dur_prod;
 	do_div(dur, bfqd->peak_rate);
 
@@ -7079,7 +7076,6 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	 */
 	bfqd->bfq_wr_coeff = 30;
 	bfqd->bfq_wr_rt_max_time = msecs_to_jiffies(300);
-	bfqd->bfq_wr_max_time = 0;
 	bfqd->bfq_wr_min_idle_time = msecs_to_jiffies(2000);
 	bfqd->bfq_wr_min_inter_arr_async = msecs_to_jiffies(500);
 	bfqd->bfq_wr_max_softrt_rate = 7000; /*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 9fa89577322d..0b1a5438046a 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -719,8 +719,6 @@ struct bfq_data {
 	 * is multiplied.
 	 */
 	unsigned int bfq_wr_coeff;
-	/* maximum duration of a weight-raising period (jiffies) */
-	unsigned int bfq_wr_max_time;
 
 	/* Maximum weight-raising duration for soft real-time processes */
 	unsigned int bfq_wr_rt_max_time;
-- 
2.30.0

